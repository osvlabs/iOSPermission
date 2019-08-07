#import <Cordova/CDV.h>

@interface IOSPermission : CDVPlugin
- (void)checkPhotoPermission:(CDVInvokedUrlCommand *)command;
- (void)checkCameraPermission:(CDVInvokedUrlCommand *)command;
@end