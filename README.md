# Volume Manager Pro ANE V1.0.0 (Android+iOS)
This air native extension is a must have ANE for you in every game you are developing. It will not only let you control the native music stream volume, you can listen to the volume changes. Moreover, you can listen to know when the device goes to silenced mode and when does it retuen. And on top of that, you are able to stop any background music which might be playing in background.

This native extension answers the most two important questions that an Air developer could had solved before!
- What would you do if you want to make sure your game's sound effects are muted when the user's device goes silenced?
- What would you do when your game begins but a background music from device's media player or another app is already playing?

# Demo .apk
you may like to see the ANE in action? [Download demo .apk](https://github.com/myflashlab/VolumePro-ANE/tree/master/FD/dist)

**NOTICE**: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.
[Download the ANE](https://github.com/myflashlab/VolumePro-ANE/tree/master/FD/lib)

# Air Usage
```actionscript
import com.myflashlab.air.extensions.volume.Volume;
import com.myflashlab.air.extensions.volume.VolumeEvent;

Volume.init();

// you may use the Volume.value getter/setter to read and write know volume values. it must be a number between 0 and 1

// It is VERY important to Volume.dispose(); or at least remove the listener when you're closing your app
Volume.service.addEventListener(VolumeEvent.VOLUME_CHANGE, onDeviceVolumeChanged);

function onDeviceVolumeChanged(e:VolumeEvent):void
{
	trace("volume = " + e.param);
}

// you can also set a listener to know when the device goes silenced and when it comes back to normal
// It is VERY important to Volume.dispose(); or at least remove the listener when you're closing your app
Volume.service.addEventListener(VolumeEvent.MUTE_STATE, onDeviceMuteChanged);

function onDeviceMuteChanged(e:VolumeEvent):void
{
	trace("is device mute? " + e.param);
}

// You can also request for audio focus to your app or even abandon the focus from your app with the following command:
// But make sure to read the documentations to know how different iOS and Android would react on this method.
// Volume.requestFocus();
// Volume.abandonFocus();

// And finally, you can listen to possible error messages which may happen on iOS side.
Volume.service.addEventListener(VolumeEvent.ERROR, onError);

function onError(e:VolumeEvent):void
{
	trace("onError = " + e.param);
}
```

# Air .xml manifest
```xml
<extensions>
	<extensionID>com.myflashlab.air.extensions.volume</extensionID>
</extensions>
```

# Requirements
* Android SDK 10 or higher
* iOS 8.0 or higher

# Commercial Version
http://www.myflashlabs.com/product/volume-control-adobe-air-native-extension-pro-version/

![Volume Manager Pro ANE](http://www.myflashlabs.com/wp-content/uploads/2016/02/product_adobe-air-ane-extension-volume-manager-pro-595x738.jpg)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  

# Changelog
*Feb 08, 2016 - V1.0.0*
* beginning of the journey!