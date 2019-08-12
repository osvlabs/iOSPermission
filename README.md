# iOSPermission

cordova plugin to check some permissions on iOS platform

## Install

`cordova plugin add @osvlabs/ios-permissions-vitta@latest`

## use

```
 IOSPermission.checkPhotoPermission(success => {
    // allow
 }, failed => {
    // forbidden or error
 })

  IOSPermission.checkCameraPermission(success => {
    // allow
 }, failed => {
    // forbidden or error
 })
```
