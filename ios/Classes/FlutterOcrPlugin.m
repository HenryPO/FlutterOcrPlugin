#import "FlutterOcrPlugin.h"
#if __has_include(<flutter_ocr_plugin/flutter_ocr_plugin-Swift.h>)
#import <flutter_ocr_plugin/flutter_ocr_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_ocr_plugin-Swift.h"
#endif

@implementation FlutterOcrPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterOcrPlugin registerWithRegistrar:registrar];
}
@end
