#import "IOSPermission.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation IOSPermission

- (void)checkPhotoPermission:(CDVInvokedUrlCommand *)command {
  [self.commandDelegate runInBackground:^{
    __block CDVPluginResult *pluginResult = nil;
    // 1.获取相册授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    // 2.根据状态进行相应的操作
    switch (status) {
    case PHAuthorizationStatusNotDetermined: { // 用户还没有做出选择
      // 2.1请求获取权限
      [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusDenied) {
          // 拒绝授权
          pluginResult =
              [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                messageAsString:@"Not allow"];
        } else if (status == PHAuthorizationStatusAuthorized) {
          // 授权成功
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                           messageAsString:@"Allow"];
        } else if (status == PHAuthorizationStatusRestricted) {
          pluginResult =
              [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                messageAsString:@"Not allow"];
          // 受限制,家长控制,不允许访问
        }
      }];
      break;
    }
    case PHAuthorizationStatusRestricted:
      // 受限制,家长控制,不允许访问
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                       messageAsString:@"Not allow"];
      break;
    case PHAuthorizationStatusDenied:
      // 用户拒绝授权使用相册，需提醒用户到设置里面去开启app相册权限
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                       messageAsString:@"Not allow"];
      break;
    case PHAuthorizationStatusAuthorized:
      // 用户已经授权，可以使用
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                       messageAsString:@"Allow"];
      break;
    default:
      break;
    }
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
  }];
}
- (void)checkCameraPermission:(CDVInvokedUrlCommand *)command {
  [self.commandDelegate runInBackground:^{
    __block CDVPluginResult *pluginResult = nil;
    if ([UIImagePickerController
            isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      // 可以使用，进行权限判断
      // 1.获取相机授权状态
      AVAuthorizationStatus status =
          [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
      // 2.检测授权状态
      switch (status) {
      case AVAuthorizationStatusNotDetermined: { // 用户还没有做出选择
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted) {
                                   if (granted) {
                                     // 成功授权
                                     pluginResult = [CDVPluginResult
                                         resultWithStatus:CDVCommandStatus_OK
                                          messageAsString:@"Allow"];
                                   } else {
                                     // 拒绝授权
                                     pluginResult = [CDVPluginResult
                                         resultWithStatus:CDVCommandStatus_ERROR
                                          messageAsString:@"Not allow"];
                                   }
                                 }];
      } break;
      case AVAuthorizationStatusRestricted:
        // 受限制,家长控制,不允许访问
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                         messageAsString:@"Not allow"];
        break;
      case AVAuthorizationStatusDenied:
        // 用户拒绝授权使用相机，需提醒用户到设置里面去开启app相机权限
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                         messageAsString:@"Not allow"];
        break;
      case AVAuthorizationStatusAuthorized:
        // 已经授权
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                         messageAsString:@"Allow"];
        break;
      default:
        break;
      }
    } else {
      // 没有检查到设备
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                       messageAsString:@"Camera can't use"];
    }
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
  }];
}
@end
