package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var options:Array<String> = [
		'Foraging',
		'Kill Streak'
	];
	private var grpTexts:FlxTypedGroup<Alphabet>;

	private var curSelected = 0;

	override function create()
	{
		FlxG.camera.bgColor = FlxColor.BLACK;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Editors Main Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('orlDesat'));
		bg.scrollFactor.set();
		bg.color = 0xFF9271FD;
		add(bg);

		grpTexts = new FlxTypedGroup<Alphabet>();
		add(grpTexts);

		for (i in 0...options.length)
		{
			var leText:Alphabet = new Alphabet(0, (70 * i) + 30, options[i], true, false);
			leText.isMenuItem = true;
			leText.targetY = i;
			grpTexts.add(leText);
		}

		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			switch(options[curSelected]) {
				case 'Foraging':
					PlayState.SONG = Song.loadFromJson('foraging', 'foraging');
					LoadingState.loadAndSwitchState(new PlayState());
				case 'Kill Streak':
					PlayState.SONG = Song.loadFromJson('kill-streak', 'kill-streak');
					LoadingState.loadAndSwitchState(new PlayState());
			}
			FlxG.sound.music.volume = 0;
		}
		
		var bullShit:Int = 0;
		for (item in grpTexts.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;
	}
}