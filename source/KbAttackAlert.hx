package;

import flixel.group.FlxGroup;
import flixel.FlxBasic;
import flixel.graphics.frames.FlxFrame;
import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import lime.app.Application;

using StringTools;
using FlxSpriteTools;

class KbAttackAlert extends FlxGroup
{
	public var alert:FlxSprite;
	public var tipTxt:FlxText;
	public var newalert:Bool = false;

	var alertAdded:Bool = false;
	var dodgeWarning:String = 'Press ${ClientPrefs.getkeys('qt_dodge')} to dodge!';

	public var alpha(default, set):Float = 1;

	@:noCompletion function set_alpha(value:Float):Float
	{
		alpha = value;
		if (alertAdded)
		{
			if (newalert && alert != null)
				alert.alpha = alpha;
			if (tipTxt != null)
				tipTxt.alpha = alpha;
		}

		return alpha;
	}

	@:noCompletion override function set_visible(value:Bool):Bool
	{
		visible = value;
		if (alertAdded)
		{
			alert.visible = value;
			tipTxt.visible = value;
		}

		return visible;
	}

	@:noCompletion override function set_active(value:Bool):Bool
	{
		active = value;
		if (alertAdded)
		{
			alert.active = value;
			tipTxt.active = value;
		}

		return active = value;
	}

	@:noCompletion override function set_exists(value:Bool):Bool
	{
		exists = value;
		if (alertAdded)
		{
			alert.exists = value;
			tipTxt.exists = value;
		}

		return exists;
	}

	@:noCompletion override function set_alive(value:Bool):Bool
	{
		alive = value;
		if (alertAdded)
		{
			alert.alive = value;
			tipTxt.alive = value;
		}

		return alive;
	}

	public function new()
	{
		super();
		create();
	}

	public function create():Void
	{
		// Alert!
		if (!alertAdded)
		{
			alert = new FlxSprite();
			alert.frames = Paths.getSparrowAtlas('hazard/qt-port/attack_alert_NEW', 'shared');
			alert.antialiasing = ClientPrefs.globalAntialiasing;
			alert.setGraphicSize(Std.int(alert.width * 1.5));

			var animFrames:Array<FlxFrame> = [];
			@:privateAccess {
				alert.animation.findByPrefix(animFrames, "Alert-Single");
				alert.animation.findByPrefix(animFrames, "Alert-Double");
				alert.animation.findByPrefix(animFrames, "Alert-Triple");
				alert.animation.findByPrefix(animFrames, "Alert-Quad");
			}

			if (animFrames.length > 0)
			{
				newalert = true;

				alert.animation.addByPrefix('alert', 'Alert-Single', 0);
				alert.animation.addByPrefix('alertDOUBLE', 'Alert-Double', 0);
				alert.animation.addByPrefix('alertTRIPLE', 'Alert-Triple', 0);
				alert.animation.addByPrefix('alertQUAD', 'Alert-Quad', 0);
			}
			else
			{
				newalert = false;

				alert.animation.addByPrefix('alert', 'kb_attack_animation_alert-single', 24, false);
				alert.animation.addByPrefix('alertDOUBLE', 'kb_attack_animation_alert-double', 24, false);
				alert.animation.addByPrefix('alertTRIPLE', 'kb_attack_animation_alert-triple', 24, false);
				alert.animation.addByPrefix('alertQUAD', 'kb_attack_animation_alert-quad', 24, false);
			}

			alert.screenCenter(X);
			alert.x += alert.width / 4; // wtf? haz?
			alert.y = 205 + (ClientPrefs.downScroll ? 20 : 0);
			alert.moves = false;
			add(alert);

			tipTxt = new FlxText(0, ClientPrefs.downScroll ? alert.y - 66 : alert.y + alert.height + 36, 0, dodgeWarning, 26);
			tipTxt.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			tipTxt.applyMarkup(dodgeWarning, [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "$")]);
			tipTxt.antialiasing = ClientPrefs.globalAntialiasing;
			tipTxt.borderSize = 1.1;
			tipTxt.centerOnSprite(alert, X);
			tipTxt.x -= alert.width / 4;
			tipTxt.moves = false;
			add(tipTxt);

			alertAdded = true;
		}
	}

	public function playAnim(Anim:String)
	{
		if (alertAdded)
		{
			alert.animation.play(Anim, true);
			switch (Anim)
			{
				default:
					alert.offset.set(0, 0);
				case "alertQUAD":
					alert.offset.set(152, 38);
				case "alertTRIPLE":
					alert.offset.set(150, 56);
				case "alertDOUBLE":
					alert.offset.set(75, 5);
			}
			alpha = 1;
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (alpha > 0)
			alpha -= 3.2 * elapsed;
	}
}
