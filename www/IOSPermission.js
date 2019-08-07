var exec = require('cordova/exec');

var IOSPermission = function () {
}

IOSPermission.prototype.checkCameraPermission = function (successCallback, errorCallback) {
    return exec(successCallback, errorCallback, 'IOSPermission', 'checkCameraPermission', []);
}

IOSPermission.prototype.checkPhotoPermission = function (successCallback, errorCallback) {
    return exec(successCallback, errorCallback, 'IOSPermission', 'checkPhotoPermission', []);
}

module.exports = new IOSPermission();