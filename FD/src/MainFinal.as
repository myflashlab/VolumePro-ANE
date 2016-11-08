package 
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.events.StatusEvent;
	import flash.text.AntiAliasType;
	import flash.text.AutoCapitalize;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import com.myflashlab.air.extensions.volume.Volume;
	import com.myflashlab.air.extensions.volume.VolumeEvent;
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.starling.utils.list.List;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.Easing;
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 2/9/2013 12:06 PM
	 */
	public class MainFinal extends Sprite 
	{
		private const BTN_WIDTH:Number = 150;
		private const BTN_HEIGHT:Number = 60;
		private const BTN_SPACE:Number = 2;
		private var _txt:TextField;
		private var _body:Sprite;
		private var _list:List;
		private var _numRows:int = 1;
		
		[Embed(source = "myGameMusic.mp3")]
		private var MySound:Class;
		private var _myMusic:Sound;
		private var _myMusicChannel:SoundChannel;
		
		public function MainFinal():void 
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate, false, 0, true);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke, false, 0, true);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
			
			stage.addEventListener(Event.RESIZE, onResize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			C.startOnStage(this, "`");
			C.commandLine = false;
			C.commandLineAllowed = false;
			C.x = 20;
			C.width = 250;
			C.height = 150;
			C.strongRef = true;
			C.visible = true;
			C.scaleX = C.scaleY = DeviceInfo.dpiScaleMultiplier;
			
			_txt = new TextField();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = false;
			_txt.htmlText = "<font face='Arimo' color='#333333' size='20'><b>Volume Manager ANE V"+Volume.VERSION+"</b></font>";
			_txt.scaleX = _txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			this.addChild(_txt);
			
			_body = new Sprite();
			this.addChild(_body);
			
			_list = new List();
			_list.holder = _body;
			_list.itemsHolder = new Sprite();
			_list.orientation = Orientation.VERTICAL;
			_list.hDirection = Direction.LEFT_TO_RIGHT;
			_list.vDirection = Direction.TOP_TO_BOTTOM;
			_list.space = BTN_SPACE;
			
			init();
			onResize();
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
		}
		
		private function handleActivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		private function handleKeys(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.BACK)
            {
				Volume.service.removeEventListener(VolumeEvent.VOLUME_CHANGE, onDeviceVolumeChanged);
				Volume.service.removeEventListener(VolumeEvent.MUTE_STATE, onDeviceMuteChanged);
				Volume.service.removeEventListener(VolumeEvent.ERROR, onError);
				
				// when you are done with the extension or when you are leaving the app, make sure to dispose the ANE.
				// When you dispose the ANE, you HAVE to initialize it again with Volume.init(); if you wish to use it again.
				Volume.dispose();
				
				e.preventDefault();
				NativeApplication.nativeApplication.exit();
            }
		}
		
		private function onResize(e:*=null):void
		{
			if (_txt)
			{
				_txt.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				
				C.x = 0;
				C.y = _txt.y + _txt.height + 0;
				C.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				C.height = 300 * (1 / DeviceInfo.dpiScaleMultiplier);
			}
			
			if (_list)
			{
				_numRows = Math.floor(stage.stageWidth / (BTN_WIDTH * DeviceInfo.dpiScaleMultiplier + BTN_SPACE));
				_list.row = _numRows;
				_list.itemArrange();
			}
			
			if (_body)
			{
				_body.y = stage.stageHeight - _body.height;
			}
		}
		
		private function init():void
		{
			// initialize the extension like this
			Volume.init();
			
			// listen to possible error messages which may happen on iOS side. explained in details at the bottom of this document.
			Volume.service.addEventListener(VolumeEvent.ERROR, onError);
			
			// if you don't need the following two services, you shouldn't listen to them at all. because when you're listening to them, 
			// the ANE will register an observer on the native side to check for the values. and if you remove them, those native observers 
			// will also be unregistered.
			Volume.service.addEventListener(VolumeEvent.VOLUME_CHANGE, onDeviceVolumeChanged);
			Volume.service.addEventListener(VolumeEvent.MUTE_STATE, onDeviceMuteChanged);
			
			// ----------------------------------------------------------------------------
			
			var btn1:MySprite = createBtn("play my music");
			btn1.addEventListener(MouseEvent.CLICK, start);
			_list.add(btn1);
			
			function start(e:MouseEvent):void
			{
				if(!_myMusic) _myMusic = (new MySound) as Sound;
				
				
				var btn:MySprite = e.target as MySprite;
				
				if (btn.data.txt.text == "play my music")
				{
					btn.data.txt.text = "stop my music";
					
					_myMusicChannel = _myMusic.play(0, 999);
				}
				else if (btn.data.txt.text == "stop my music")
				{
					btn.data.txt.text = "play my music";
					
					_myMusicChannel.stop();
				}
			}
			
			// ----------------------------------------------------------------------------
			
			
			var btn2:MySprite = createBtn("Request Audio Focus");
			btn2.addEventListener(MouseEvent.CLICK, setAudioFocus);
			_list.add(btn2);
			
			function setAudioFocus(e:MouseEvent):void
			{
				var btn:MySprite = e.target as MySprite;
				
				if (btn.data.txt.text == "Request Audio Focus")
				{
					C.log("request Focus result = ", Volume.requestFocus());
					btn.data.txt.text = "Abandon Audio Focus";
				}
				else if (btn.data.txt.text == "Abandon Audio Focus")
				{					
					C.log("abandon Focus result = ", Volume.abandonFocus());
					btn.data.txt.text = "Request Audio Focus";
				}
			}
			
			// ----------------------------------------------------------------------------
			
			var btn3:MySprite = createBtn("volume +");
			btn3.addEventListener(MouseEvent.CLICK, increaseVolume);
			_list.add(btn3);
			
			function increaseVolume(e:MouseEvent):void
			{
				Volume.value = Volume.value + 0.1;
			}
			
			// ----------------------------------------------------------------------------
			
			var btn4:MySprite = createBtn("volume -");
			btn4.addEventListener(MouseEvent.CLICK, decreaseVolume);
			_list.add(btn4);
			
			function decreaseVolume(e:MouseEvent):void
			{
				Volume.value = Volume.value - 0.1;
			}
			
			// ----------------------------------------------------------------------------
			
			
		}
		
		private function onDeviceVolumeChanged(e:VolumeEvent):void
		{
			C.log("volume = " + e.param);
		}
		
		private function onDeviceMuteChanged(e:VolumeEvent):void
		{
			C.log("is device mute? " + e.param);
		}
		
		private function onError(e:VolumeEvent):void
		{
			C.log("onError = " + e.param);
			
			/*
				
				If you are seeing AIR_SDK_BUG_ABANDON_FOCUS it means:
				unfortunaitly there is a bug in iOS Adobe Air SDK which cannot abandon audio focus once obtained.
				we have reported this bug to Adobe.
				
				If you are seeing AIR_SDK_BUG_REQUEST_FOCUS it means:
				Again this error is related to the former one above! but it happens only when you have played a sound
				in your Air app prior to calling the Volume.requestFocus() method. Let me put it this way: When your 
				app starts, you MUST obtain focus by calling Volume.requestFocus() before you start playing ANY sound.
				Once any sound is played in your Air app, due to the Air SDK bug explained above, you will never again
				be able to obtain the audio focus unless your app starts again. So, always make sure to request for 
				audio focus before playing any sound in your app.
				
				On the Android side though, everything works with no problem. you can simply request focus and abandon it
				anytime you wish no matter if you are playing any sound or music in your app.
			 
			*/
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function createBtn($str:String):MySprite
		{
			var sp:MySprite = new MySprite();
			sp.addEventListener(MouseEvent.MOUSE_OVER,  onOver);
			sp.addEventListener(MouseEvent.MOUSE_OUT,  onOut);
			sp.addEventListener(MouseEvent.CLICK,  onOut);
			sp.bgAlpha = 1;
			sp.bgColor = 0xDFE4FF;
			sp.drawBg();
			sp.width = BTN_WIDTH * DeviceInfo.dpiScaleMultiplier;
			sp.height = BTN_HEIGHT * DeviceInfo.dpiScaleMultiplier;
			
			function onOver(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = 0xFFDB48;
				sp.drawBg();
			}
			
			function onOut(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = 0xDFE4FF;
				sp.drawBg();
			}
			
			var format:TextFormat = new TextFormat("Arimo", 16, 0x666666, null, null, null, null, null, TextFormatAlign.CENTER);
			
			var txt:TextField = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.mouseEnabled = false;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.scaleX = txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			txt.width = sp.width * (1 / DeviceInfo.dpiScaleMultiplier);
			txt.defaultTextFormat = format;
			txt.text = $str;
			
			txt.y = sp.height - txt.height >> 1;
			sp.addChild(txt);
			
			sp.data.txt = txt;
			
			return sp;
		}
	}
	
}