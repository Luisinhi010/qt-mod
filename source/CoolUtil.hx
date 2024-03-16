package;

import flixel.util.FlxSave;
import flixel.FlxG;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import flixel.system.FlxSound;
import openfl.display.BlendMode;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.text.FlxText.FlxTextAlign;
import flixel.tweens.FlxTween.FlxTweenType;
#if sys
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end

using StringTools;

class CoolUtil
{
	public static final defaultDifficulties:Array<String> = ['Easy', 'Normal', 'Hard', 'Harder'];
	public static final defaultDifficulty:String = 'Normal'; // The chart that has no suffix and starting difficulty on Freeplay/Story Mode
	public static var difficulties:Array<String> = [];

	inline public static function capitalize(text:String)
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	public static function getDifficultyFilePath(num:Null<Int> = null):String
	{
		if (num == null)
			num = PlayState.storyDifficulty;
		var fileSuffix:String = difficulties[num];
		if (fileSuffix != defaultDifficulty)
			fileSuffix = '-' + fileSuffix;
		else
			fileSuffix = '';
		return Paths.formatToSongPath(fileSuffix);
	}

	public static function difficultyString():String
		{
			var dumbShit:String = difficulties[PlayState.storyDifficulty].toUpperCase();
	
			if(PlayState.SONG != null && PlayState.THISISFUCKINGDISGUSTINGPLEASESAVEME == true){
				if(PlayState.SONG.song.toLowerCase()=="termination"){
					if(PlayState.storyDifficulty == 2)
						dumbShit = "CLASSIC";
					else
						dumbShit = "VERY HARD";
				}else if(PlayState.SONG.song.toLowerCase()=="cessation"){
					dumbShit = "FUTURE";
				}else if(PlayState.SONG.song.toLowerCase()=="interlope"){
					dumbShit = "???";
				}
			}
			return dumbShit;
		}

	inline public static function boundTo(value:Float, min:Float, max:Float):Float
		return Math.max(min, Math.min(max, value));

	public static function coolTextFile(path:String):Array<String>
	{
		#if sys
		if (FileSystem.exists(path))
			return [for (i in File.getContent(path).trim().split('\n')) i.trim()];
		#else
		if (Assets.exists(path))
			return [for (i in Assets.getText(path).trim().split('\n')) i.trim()];
		#end
		return [];
	}

	inline public static function listFromString(string:String):Array<String>
		return [for (i in string.trim().split('\n')) i.trim()];

	public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];
		for (col in 0...sprite.frameWidth)
		{
			for (row in 0...sprite.frameHeight)
			{
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if (colorOfThisPixel != 0)
				{
					if (countByColor.exists(colorOfThisPixel))
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					else if (countByColor[colorOfThisPixel] != 13520687 - (2 * 13520687))
						countByColor[colorOfThisPixel] = 1;
				}
			}
		}
		var maxCount = 0;
		var maxKey:Int = 0; // after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
		for (key in countByColor.keys())
		{
			if (countByColor[key] >= maxCount)
			{
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

	inline public static function numberArray(max:Int, ?min = 0):Array<Int>
		return [for (i in min...max) i];

	// uhhhh does this even work at all? i'm starting to doubt
	// yes it does. -Luis
	public static function precacheSound(sound:String, ?library:String = null):Void
		precacheSoundFile(Paths.sound(sound, library));

	public static function precacheMusic(sound:String, ?library:String = null):Void
		precacheSoundFile(Paths.music(sound, library));

	public static function precacheVoices(sound:String, ?library:String = null):Void
		precacheSoundFile(Paths.voices(sound));

	public static function precacheInst(sound:String, ?library:String = null):Void
		precacheSoundFile(Paths.inst(sound));

	public static function precacheImage(image:String, ?library:String = null):Void
		precacheImageFile(Paths.image(image, library));

	private static function precacheSoundFile(file:Dynamic):Void
	{
		if (Assets.exists(file, SOUND) || Assets.exists(file, MUSIC))
			Assets.getSound(file, true);
	}

	private static function precacheImageFile(file:Dynamic):Void
	{
		if (Assets.exists(file, IMAGE))
			LimeAssets.getImage(file, true);
	}

	inline public static function browserLoad(site:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}
}
