//
//  FileUtil.swift
//  flutter_ocr_plugin
//
//  Created by 荆学涛 on 2020/8/21.
//

import Foundation

class FileUtil {
    
    static let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    
    static let idCardFront = documents + "/idCardFront.jpg"
    
    static let idCardBack = documents + "/idCardBack.jpg"
    
    static let bankCard = documents + "/bankCard.jpg"
    
    static let vehicle = documents + "/vehicle.jpg"
    
    static let driving = documents + "/driving.jpg"
    
    static func saveFileWithPath(_ path: String, image: UIImage) {
        let manager = FileManager.default
        manager.createFile(atPath: path, contents: image.jpegData(compressionQuality: 1.0), attributes: nil)
    }
}
