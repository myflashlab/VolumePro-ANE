# Volume Manager Pro ANE V2.0.2 (Android+iOS)
This air native extension is a must have ANE for you in every game you are developing. It will not only let you control the native music stream volume, you can listen to the volume changes. Moreover, you can listen to know when the device goes to silenced mode and when does it return. And on top of that, you are able to stop any background music which might be playing in background.

This native extension answers the most two important questions that an Air developer could had solved before!
- What would you do if you want to make sure your game's sound effects are muted when the user's device goes silenced?
- What would you do when your game begins but a background music from device's media player or another app is already playing?

Since V2+ of this ANE, it also supports Native Sound objects which allows you to play sounds in your AIR app with almost no latency. Many of you are experiencing a nerve-racking challenge when dealing with sounds in AIR apps/games. This ANE is here to help you manage your sounds gracefully. 

# asdoc
[find the latest asdoc for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/volume/package-detail.html)

[Download demo ANE](https://github.com/myflashlab/VolumePro-ANE/tree/master/AIR/lib)

# Air Usage
For the complete AS3 code usage, see the [demo project here](https://github.com/myflashlab/VolumePro-ANE/blob/master/AIR/src/Main.as).

```actionscript
import com.myflashlab.air.extensions.volume.*;

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
# Air Usage - NativeSound
```actionscript
import com.myflashlab.air.extensions.volume.*;

var _nativeSound1:NativeSound;
var _nativeSound2:NativeSound;

Volume.initNativeSoundObject()
Volume.service.addEventListener(VolumeEvent.SOUND_LOADED, onSoundLoaded);

// preload your sound files. Sound files must be less than 30 seconds.
// Preferred file format for iOS is .caf (You can convert mp3 files to .caf very easily. just Google it.
Volume.getNativeSoundObject(File.applicationDirectory.resolvePath("sound01.mp3"));
Volume.getNativeSoundObject(File.applicationDirectory.resolvePath("sound02.mp3"));

function onSoundLoaded(e:VolumeEvent):void
{
	// save a reference to sound objects for later use.
		
	switch(e.nativeSound.file)
	{
		case "sound01.mp3":
				
			_nativeSound1 = e.nativeSound;
			_nativeSound1.play();
			
			break;
		case "sound02.mp3":
			
			_nativeSound2 = e.nativeSound;
			_nativeSound2.play();
			
			break;
	}
}

```

# AIR .xml manifest
```xml
<extensions>
	
	<extensionID>com.myflashlab.air.extensions.volume</extensionID>
	
	<!-- download the dependency ANEs from https://github.com/myflashlab/common-dependencies-ANE -->
	<extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
	
</extensions>
```

# Requirements
* AIR SDK 30+
* Android SDK 15+
* iOS 8.0+

# Commercial Version
http://www.myflashlabs.com/product/volume-control-adobe-air-native-extension-pro-version/

![Volume Manager Pro ANE](https://www.myflashlabs.com/wp-content/uploads/2016/02/product_adobe-air-ane-extension-volume-manager-pro-595x738.jpg)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  

# Changelog
*Sep 24, 2018 - V2.0.2*
* Removed androidSupport dependency

*Dec 15, 2017 - V2.0.1*
* optimized for [ANE-LAB sofwate](https://github.com/myflashlab/ANE-LAB).

*May 31, 2017 - V2.0.0*
* Introduced [NativeSound](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/volume/NativeSound.html) Which allows you play Sound effects in your app with almost no latency. To know how to use it, read [this document](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/volume/Volume.html#getNativeSoundObject()) or check out the sample project available on Github.
* Min AIR SDK is 25

*Mar 31, 2017 - V1.1.1*
* Updated with the latest overrideAir. Even if you are building for iOS only, you will still need this dependency
* Min iOS version to support this ANE is 8.0
* Min Android version to suppirt this ANE is 15

*Nov 08, 2016 - V1.1.0*
* Optimized for Android manual permissions if you are targeting AIR SDK 24+
* From now on, this ANE will depend on androidSupport.ane and overrideAir.ane on the Android side

*Feb 08, 2016 - V1.0.0*
* beginning of the journey!