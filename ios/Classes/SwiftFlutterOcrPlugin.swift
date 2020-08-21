import Flutter
import UIKit
import AipOcrSdk
import SVProgressHUD

public class SwiftFlutterOcrPlugin: NSObject, FlutterPlugin {
    
    var viewController: UIViewController?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "95Flutter/flutter_baidu_ocr", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterOcrPlugin()
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "init" {
            if let args = call.arguments as? [String: String] {
                let appKey = args["appKey"] ?? ""
                let secretKey = args["secretKey"] ?? ""
                AipOcrService.shard()?.auth(withAK: appKey, andSK: secretKey)
            }
        } else if call.method == "bankCard" {
            guard let vc = AipCaptureCardVC.viewController(with: .bankCard, andImageHandler: { (image) in
                guard let image = image else {
                    return
                }
                SVProgressHUD.show(withStatus: "正在识别...")
                AipOcrService.shard()?.detectBankCard(from: image, successHandler: { (value) in
                    SVProgressHUD.showSuccess(withStatus: "识别成功!")
                    guard let value = value as? [String: Any] else { return }
                    FileUtil.saveFileWithPath(FileUtil.bankCard, image: image)
                    self.handle(body: value, path: FileUtil.bankCard, result: result)
                }, failHandler: { (error) in
                    print(error?.localizedDescription ?? "")
                    SVProgressHUD.showError(withStatus: "识别失败!")
                })
            }) else { return }
            viewController = vc
            viewControllerWithWindow(nil)?.present(vc, animated: true, completion: nil)
        } else if call.method == "vehicle" {
            guard let vc = AipGeneralVC.viewController(handler: { (image) in
                guard let image = image else {
                    return
                }
                SVProgressHUD.show(withStatus: "正在识别...")
                AipOcrService.shard()?.detectVehicleLicense(from: image, withOptions: nil, successHandler: { (value) in
                    SVProgressHUD.showSuccess(withStatus: "识别成功!")
                    guard let value = value as? [String: Any] else { return }
                    FileUtil.saveFileWithPath(FileUtil.vehicle, image: image)
                    self.handle(body: value, path: FileUtil.vehicle, result: result)
                }, failHandler: { (error) in
                    SVProgressHUD.showError(withStatus: "识别失败!")
                    self.handle(error: error, result: result)
                })
            }) else { return }
            viewController = vc
            viewControllerWithWindow(nil)?.present(vc, animated: true, completion: nil)
        } else if call.method == "driving" {
            guard let vc = AipGeneralVC.viewController(handler: { (image) in
                guard let image = image else {
                    return
                }
                SVProgressHUD.show(withStatus: "正在识别...")
                AipOcrService.shard()?.detectDrivingLicense(from: image, withOptions: nil, successHandler: { (value) in
                    SVProgressHUD.showSuccess(withStatus: "识别成功!")
                    guard let value = value as? [String: Any] else { return }
                    FileUtil.saveFileWithPath(FileUtil.driving, image: image)
                    self.handle(body: value, path: FileUtil.driving, result: result)
                }, failHandler: { (error) in
                    SVProgressHUD.showError(withStatus: "识别失败!")
                    self.handle(error: error, result: result)
                })
            }) else { return }
            viewController = vc
            viewControllerWithWindow(nil)?.present(vc, animated: true, completion: nil)
        } else if call.method == "idCardFront" {
            guard let vc = AipCaptureCardVC.viewController(with: .idCardFont, andImageHandler: { (image) in
                guard let image = image else {
                    return
                }
                SVProgressHUD.show(withStatus: "正在识别...")
                AipOcrService.shard()?.detectIdCardFront(from: image, withOptions: [:], successHandler: { (value) in
                    SVProgressHUD.showSuccess(withStatus: "识别成功!")
                    guard let value = value as? [String: Any] else { return }
                    FileUtil.saveFileWithPath(FileUtil.idCardFront, image: image)
                    self.handle(body: value, path: FileUtil.idCardFront, result: result)
                }, failHandler: { (error) in
                    SVProgressHUD.showError(withStatus: "识别失败!")
                    self.handle(error: error, result: result)
                })
            }) else { return }
            viewController = vc
            viewControllerWithWindow(nil)?.present(vc, animated: true, completion: nil)
        } else if call.method == "idCardBack" {
            guard let vc = AipCaptureCardVC.viewController(with: .idCardBack, andImageHandler: { (image) in
                guard let image = image else {
                    return
                }
                SVProgressHUD.show(withStatus: "正在识别...")
                AipOcrService.shard()?.detectIdCardFront(from: image, withOptions: [:], successHandler: { (value) in
                    SVProgressHUD.showSuccess(withStatus: "识别成功!")
                    guard let value = value as? [String: Any] else { return }
                    FileUtil.saveFileWithPath(FileUtil.idCardBack, image: image)
                    self.handle(body: value, path: FileUtil.idCardBack, result: result)
                }, failHandler: { (error) in
                    SVProgressHUD.showError(withStatus: "识别失败!")
                    self.handle(error: error, result: result)
                })
            }) else { return }
            viewController = vc
            viewControllerWithWindow(nil)?.present(vc, animated: true, completion: nil)
        } else {
            result("iOS " + UIDevice.current.systemVersion)
        }
    }
    
    func handle(body: [String: Any], path: String, result: @escaping FlutterResult) {
        let dic = [
            "body": body,
            "filePath": path
            ] as [String : Any]
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: []) else {
            return
        }
        let string = String(data: data, encoding: .utf8) ?? ""
        result(string)
        DispatchQueue.main.async {
            self.viewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func handle(error: Error?, result: @escaping FlutterResult) {
        result(error?.localizedDescription ?? "")
    }
    
    func viewControllerWithWindow(_ window: UIWindow?) -> UIViewController? {
        var windowToUse = window
        if windowToUse == nil {
            for window in UIApplication.shared.windows {
                if window.isKeyWindow {
                    windowToUse = window
                    break
                }
            }
        }
        var topController = windowToUse?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
}
