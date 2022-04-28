;Jacob Thomas
;Script game to remind user to leave PC at set intervals, level up system, Overwatch theme
;Installer, script, messy and requires cleaning up someday, but does the job well
;Created March 6th, 2021




^!F2::
;Take these values, /2, then - half my gui screen dimensions for centre of screen
SeqX := A_ScreenWidth
SeqX /= 2
SeqY := A_ScreenHeight
SeqY /= 2
SeqX := (SeqX-375)
SeqY := (SeqY-225)


;Compare EndDate with current date, if equal, check if current hour is greater or equal to MissionCompleteTime2
FileReadLine, SeqStats, %A_ScriptDir%\System\StatsLog.txt, 1

SeqParameters := StrSplit(SeqStats, "|")
SeqEndDate := SeqParameters[7]
SeqMissionCompleteTime2 := SeqParameters[8]
FormatTime, CurrentDate,, dd
FormatTime, CurrentHour,, HH

;Gets the next day even if it's next month
Days += 1, Days
FormatTime, SeqNextDay,%Days%, dd

;Current Date and Target date are the same
if (CurrentDate = SeqEndDate)
{
	;If target hour is in past, end mission
	if (SeqMissionCompleteTime2 <= CurrentHour)
	{
		HeroChoice := SeqParameters[1]
		MissionCompleteTime := SeqParameters[2]
		HowOftenChoice := SeqParameters[3]
		EnergyChoice := SeqParameters[4]
		SoundChoice := SeqParameters[5]
		HeroPortrait := SeqParameters[6]
		EndDate := SeqParameters[7]
		MissionCompleteTime2 := SeqParameters[8]
		Enemy := SeqParameters[9]
		EnemyMaxHP := SeqParameters[10]
		EnemyCurrentHP := SeqParameters[11]
		Level := SeqParameters[12]
		SleepFor := SeqParameters[13]
		SeqActivate := SeqParameters[14]
		
		TargetEnemyHP := (EnemyMaxHP / 2)
		
		;If victory, level up and show victory screen
		if (EnemyCurrentHP <= TargetEnemyHP)
		{
			Level := Level+1

			;Calculate Border Colour, Stars, and Level X Location
			SeqResults := StrSplit(SeqCalculations(level), "|")
			
			Stars := SeqResults[1]
			levelColour := SeqResults[2]
			SeqLevelNum := SeqResults[3]
			SeqLevelXLocation := SeqResults[4]

			GUI, LevelUp: Color, Purple
			GUI, LevelUp: Font, s15, Bold
			GUI, LevelUp: Font, cYellow
			GUI, LevelUp: Font, w800
			GUI, LevelUp: Margin , 10, 10
			GUI, LevelUp: add, text,x%SeqLevelXLocation% y374,%Level%
			GUI, LevelUp: Add, Picture, x25 y25 w300 h300, %A_ScriptDir%\%HeroChoice%\%HeroPortrait%.jpg
			GUI, LevelUp: Add, Picture, x500 y100 w150 h150 vProfilePic, %A_ScriptDir%\UI\LevelUp.gif
			GUI, LevelUp: Add, Picture, x455 y290 w244 h56 vPlayPic gSeqSetup, %A_ScriptDir%\UI\NextLevel.png
			GUI, LevelUp: Add, Picture, x109 y312 w150 h150 +BackgroundTrans, %A_ScriptDir%\Levels\%levelColour%\%SeqLevelNum%0.png
			GUI, LevelUp: Add, Picture, x121 y376 w125 h75 +BackgroundTrans, %A_ScriptDir%\Levels\%levelColour%\%Stars%.png
			GUI, LevelUp:-Caption ;Hide minimize or drag bar
			GUI, LevelUp:show, X%SeqX% Y%SeqY% W750 H450
			return
		}
		;If defeat, show defeat screen
		if !(EnemyCurrentHP <= TargetEnemyHP)
		{
			;Possible future addition, add exp for effort?  0.5% level...? 
			
			
			;Calculate Border Colour, Stars, and Level X Location
			SeqResults := StrSplit(SeqCalculations(level), "|")
			
			Stars := SeqResults[1]
			levelColour := SeqResults[2]
			SeqLevelNum := SeqResults[3]
			SeqLevelXLocation := SeqResults[4]
			

			
			GUI, NoLevelUp: Color, Black 
			GUI, NoLevelUp: Font, s15, Bold
			GUI, NoLevelUp: Font, cYellow
			GUI, NoLevelUp: Font, w800
			GUI, NoLevelUp: Margin, 10, 10
			GUI, NoLevelUp: add, text,x%SeqLevelXLocation% y374, %Level%
			GUI, NoLevelUp: Add, Picture, x25 y25 w300 h300, %A_ScriptDir%\UI\Defeat.jpg
			GUI, NoLevelUp: Add, Picture, x500 y100 w150 h150 vProfilePic, %A_ScriptDir%\UI\Fail.png
			GUI, NoLevelUp: Add, Picture, x455 y290 w244 h56 vPlayPic gSeqSetup, %A_ScriptDir%\UI\Retry.png
			GUI, NoLevelUp: Add, Picture, x109 y312 w150 h150 +BackgroundTrans, %A_ScriptDir%\Levels\%levelColour%\%SeqLevelNum%0.png
			GUI, NoLevelUp: Add, Picture, x121 y376 w125 h75 +BackgroundTrans, %A_ScriptDir%\Levels\%levelColour%\%Stars%.png
			GUI, NoLevelUp:-Caption ;Hide minimize or drag bar
			GUI, NoLevelUp:show, X%SeqX% Y%SeqY% W750 H450
			return
			
		}
	}
	;If same day but still has time left - REBUILD variables and show Vs Screen
	if (SeqMissionCompleteTime2 > CurrentHour)
	{
		;msgbox, Getting variables1
		HeroChoice := SeqParameters[1]
		MissionCompleteTime := SeqParameters[2]
		HowOftenChoice := SeqParameters[3]
		EnergyChoice := SeqParameters[4]
		SoundChoice := SeqParameters[5]
		HeroPortrait := SeqParameters[6]
		EndDate := SeqParameters[7]
		MissionCompleteTime2 := SeqParameters[8]
		Enemy := SeqParameters[9]
		EnemyMaxHP := SeqParameters[10]
		EnemyCurrentHP := SeqParameters[11]
		Level := SeqParameters[12]
		SleepFor := SeqParameters[13]
		SeqActivate := SeqParameters[14]
		
		;Calls the Vs screen
		Goto, ShowVsScreen
		
	}
}
if (CurrentDate != SeqEndDate)
{
	if (SeqNextDay = SeqEndDate)
	{
		;Scenario - CD 31	TD 01	(normal scenario = okay)		Check if CD +1 = TD
		;Scenario - CD 03	TD 04	(normal scenario = okay)		Check if CD +1 = TD
		;msgbox, this is okay 1		;Probably load script here
		
		;msgbox, Getting variables2
		HeroChoice := SeqParameters[1]
		MissionCompleteTime := SeqParameters[2]
		HowOftenChoice := SeqParameters[3]
		EnergyChoice := SeqParameters[4]
		SoundChoice := SeqParameters[5]
		HeroPortrait := SeqParameters[6]
		EndDate := SeqParameters[7]
		MissionCompleteTime2 := SeqParameters[8]
		Enemy := SeqParameters[9]
		EnemyMaxHP := SeqParameters[10]
		EnemyCurrentHP := SeqParameters[11]
		Level := SeqParameters[12]
		SleepFor := SeqParameters[13]
		SeqActivate := SeqParameters[14]
		
		;Calls the Vs screen
		Goto, ShowVsScreen
	}
	if (SeqNextDay != SeqEndDate)
	{
		;Scenario - CD 01	TD 29	(gone over td = no okay)		just 'else' do this?  Can check above, 'if != TD then...'
		;msgbox, This is NOT okay 1 - reset		;Probably need to goto re-create screen
		;Goto,  ResetDay
		;Test this works somehow?   Code from top instead, move comments up
		
		
		HeroChoice := SeqParameters[1]
		MissionCompleteTime := SeqParameters[2]
		HowOftenChoice := SeqParameters[3]
		EnergyChoice := SeqParameters[4]
		SoundChoice := SeqParameters[5]
		HeroPortrait := SeqParameters[6]
		EndDate := SeqParameters[7]
		MissionCompleteTime2 := SeqParameters[8]
		Enemy := SeqParameters[9]
		EnemyMaxHP := SeqParameters[10]
		EnemyCurrentHP := SeqParameters[11]
		Level := SeqParameters[12]
		SleepFor := SeqParameters[13]
		SeqActivate := SeqParameters[14]
		
		TargetEnemyHP := (EnemyMaxHP / 2)

		;If victory, level up and show victory screen
		if (EnemyCurrentHP <= TargetEnemyHP)
		{
			Level := Level+1
			
			;Calculate Border Colour, Stars, and Level X Location
			SeqResults := StrSplit(SeqCalculations(level), "|")
			
			Stars := SeqResults[1]
			levelColour := SeqResults[2]
			SeqLevelNum := SeqResults[3]
			SeqLevelXLocation := SeqResults[4]

			GUI, LevelUp: Color, Purple
			GUI, LevelUp: Font, s15, Bold
			GUI, LevelUp: Font, cYellow
			GUI, LevelUp: Font, w800
			GUI, LevelUp: Margin , 10, 10
			GUI, LevelUp: add, text,x%SeqLevelXLocation% y374,%Level%
			GUI, LevelUp: Add, Picture, x25 y25 w300 h300, %A_ScriptDir%\%HeroChoice%\%HeroPortrait%.jpg
			GUI, LevelUp: Add, Picture, x500 y100 w150 h150 vProfilePic, %A_ScriptDir%\UI\LevelUp.gif
			GUI, LevelUp: Add, Picture, x455 y290 w244 h56 vPlayPic gSeqSetup, %A_ScriptDir%\UI\NextLevel.png
			GUI, LevelUp: Add, Picture, x109 y312 w150 h150 +BackgroundTrans, %A_ScriptDir%\Levels\%levelColour%\%SeqLevelNum%0.png
			GUI, LevelUp: Add, Picture, x121 y376 w125 h75 +BackgroundTrans, %A_ScriptDir%\Levels\%levelColour%\%Stars%.png
			GUI, LevelUp:-Caption ;Hide minimize or drag bar
			GUI, LevelUp:show, X%SeqX% Y%SeqY% W750 H450
			return
		}
		;If defeat, show defeat screen
		if !(EnemyCurrentHP <= TargetEnemyHP)
		{
			;Possible future addition, add exp for effort?  0.5% level...? 
			
		;Calculate Border Colour, Stars, and Level X Location
			SeqResults := StrSplit(SeqCalculations(level), "|")
			
			Stars := SeqResults[1]
			levelColour := SeqResults[2]
			SeqLevelNum := SeqResults[3]
			SeqLevelXLocation := SeqResults[4]
			

			
			GUI, NoLevelUp: Color, Black 
			GUI, NoLevelUp: Font, s15, Bold
			GUI, NoLevelUp: Font, cYellow
			GUI, NoLevelUp: Font, w800
			GUI, NoLevelUp: Margin, 10, 10
			GUI, NoLevelUp: add, text,x%SeqLevelXLocation% y374, %Level%
			GUI, NoLevelUp: Add, Picture, x25 y25 w300 h300, %A_ScriptDir%\UI\Defeat.jpg
			GUI, NoLevelUp: Add, Picture, x500 y100 w150 h150 vProfilePic, %A_ScriptDir%\UI\Fail.png
			GUI, NoLevelUp: Add, Picture, x455 y290 w244 h56 vPlayPic gSeqSetup, %A_ScriptDir%\UI\Retry.png
			GUI, NoLevelUp: Add, Picture, x109 y312 w150 h150 +BackgroundTrans, %A_ScriptDir%\Levels\%levelColour%\%SeqLevelNum%0.png
			GUI, NoLevelUp: Add, Picture, x121 y376 w125 h75 +BackgroundTrans, %A_ScriptDir%\Levels\%levelColour%\%Stars%.png
			GUI, NoLevelUp:-Caption ;Hide minimize or drag bar
			GUI, NoLevelUp:show, X%SeqX% Y%SeqY% W750 H450
			return			
		}
	}
}
return


;Stops all active timers and prevents extra popups
StopAllTimers(Source, RestTime)
{
	SetTimer, EnergyReminderPopup, Off
	SetTimer, ShowVsScreen, Off
	SetTimer, ReminderPopup, Off

	if Source = None
	{
		return
	}
	if Source != None
	{
		SetTimer, %Source%, %RestTime%
		return
	}
}
return

;Calculate Border Colour, Stars, and Level X Location
SeqCalculations(level)
{
	;Determine border colour and stars
	if (level <= 600)
	{
		levelColour = Bronze
		if (level < 101)
			Stars = 0
		if (level > 100)
			Stars = 1
		if (level > 200)
			Stars = 2
		if (level > 300)
			Stars = 3
		if (level > 400)
			Stars = 4
		if (level > 500)
			Stars = 5
	}
	if (level > 600 AND level  <= 1200)
	{
		levelColour = Silver
		if (level < 701)
			Stars = 0
		if (level > 700)
			Stars = 1
		if (level > 800)
			Stars = 2
		if (level > 900)
			Stars = 3
		if (level > 1000)
			Stars = 4
		if (level > 1100)
			Stars = 5
	}
	if (level > 1200 AND level  <= 1800)
	{
		levelColour = Gold
		if (level < 1301)
			Stars = 0
		if (level > 1300)
			Stars = 1
		if (level > 1400)
			Stars = 2
		if (level > 1500)
			Stars = 3
		if (level > 1600)
			Stars = 4
		if (level > 1700)
			Stars = 5
	}
	if (level > 1800)
	{
		levelColour = Platinum
		if (level < 1901)
			Stars = 0
		if (level > 1900)
			Stars = 1
		if (level > 2000)
			Stars = 2
		if (level > 2100)
			Stars = 3
		if (level > 2200)
			Stars = 4
		if (level > 2300)
			Stars = 5
	}

	;Calculate what level border to use
	;-1 takes the last 2 characters - ie. lvl 125 it grabs the '25' and only takes the '2' part
	SeqLevelNum := SubStr(Level, -1, 1)


	SeqLevelXLocation = 177
	if (Level > 9)
		SeqLevelXLocation = 172
	if (Level > 99)
		SeqLevelXLocation = 166.5
	if (Level > 999)
		SeqLevelXLocation = 159

	SeqResults := Stars "|" levelColour "|" SeqLevelNum "|" SeqLevelXLocation			

	return SeqResults
}
return



;Collect data and start new mission
SeqSetup:
	DestroyAllGUI()

	;Required code for starting new mission
	SeqMissionLength = 0	;Length of daily mission before reset
	SeqHero = 0				;Hero selected
	SeqGoal = 0				;How many times to remind to move through day
	SeqEnergy = N			;Remind about smoothie Y/N
	SeqSound = N			;Sound reminders Y/N

	SeqText2 = Enter Mission Length (How long until stopping)
	SeqText = Select your Hero
	SeqText3 = Mission Goal (How often to pop up reminders)
	SeqText4 = Energy Reminders? (Smoothie reminders)
	SeqText5 = Sound Reminders?



	;Random, HeroPortrait, 1, 15
	;sleep 50
	;GuiControl,, ProfilePic, %A_ScriptDir%\%HeroChoice%\%HeroPortrait%.jpg
	;Play sound later - Seq

	;Intro screen to get variables
	GUI, GwynBattles: Color, Teal
	GUI, GwynBattles: Font, s10
	GUI, GwynBattles: Font, cBlack
	Gui, GwynBattles: Margin , 10, 10
	GUI, GwynBattles: add, text,x50 y50,%SeqText%
	GUI, GwynBattles: Add, DropDownList, vHeroChoice ys x350 y50 gSeqHeroChoice , Mercy|Brig|Ana|Moira
	GUI, GwynBattles: add, DropDownList, vMissionCompleteTime gSeqMissionCompleteTime disabled, 08 AM|09 AM|10 AM|11 AM|12 PM|01 PM|02 PM|03 PM|04 PM|05 PM|06 PM|07 PM|08 PM|09 PM|10 PM|11 PM|12 AM||01 AM|02 AM|03 AM|04 AM|05 AM|06 AM
	GUI, GwynBattles: Add, DropDownList, vHowOftenChoice gSeqHowOftenChoice disabled, 30 min|45 min|1 hr|1 hr 15 mins|1 hr 30 mins|1 hr 45 mins|2 hrs
	GUI, GwynBattles: Add, CheckBox, x350 y155 vEnergyChoice gSeqEnergyChoice
	GUI, GwynBattles: Add, CheckBox, x350 y190 vSoundChoice gSeqSoundChoice
	GUI, GwynBattles: add, text,x50 y85,%SeqText2%
	GUI, GwynBattles: add, text,x50 y120,%SeqText3%
	GUI, GwynBattles: add, text,x50 y155,%SeqText4%
	GUI, GwynBattles: add, text,x50 y190,%SeqText5%
	GUI, GwynBattles: add, text,x50 y225, Reminder window becomes active on popup?
	GUI, GwynBattles: Add, CheckBox, vSeqActivate gSeqActivate x350 y225		;This is the 'active' checkbox
	Gui, GwynBattles: Add, Picture, x550 y25 w150 h150 vProfilePic
	Gui, GwynBattles: Add, Picture, x275 y375 vPlayPic gSeqPlay
	;Gui, GwynBattles: Add, Picture, x550 y25 w150 h150 vProfilePic, %A_ScriptDir%\Mercy\%MercyPortrait%.jpg
	GUI, GwynBattles:-Caption ;Hide minimize or drag bar
	;GUI, GwynBattles:show, NoActivate X%SeqX% Y%SeqY%, W500 H500;NoActivate means doesn't steal focus!
	GUI, GwynBattles:show, X%SeqX% Y%SeqY% W750 H450
return


SeqActivate:
	Gui, Submit, nohide
return

;Code behind play button
SeqPlay:

;Gets the AM/PM part of time
GetAMorPM := SubStr(MissionCompleteTime, 4,1)
;Gets the numeric part of time
SeqGetTimeNumber := SubStr(MissionCompleteTime, 1,2)

;Extract AM/PM and add +12 if PM
if GetAMorPM = P
{
	MissionCompleteTime2 := SeqGetTimeNumber + 12
}
if GetAMorPM = A
{
	MissionCompleteTime2 := SeqGetTimeNumber
}
If SeqGetTimeNumber = 12
{
	;12pm (noon) should be 12:00
	If GetAMorPM = P
	{
		MissionCompleteTime2 := SeqGetTimeNumber
	}
	;12am (midnight) should be 24:00
	If GetAMorPM = A
	{
		MissionCompleteTime2 := SeqGetTimeNumber + 12
	}
}

FormatTime, CurrentDate,, dd
FormatTime, CurrentHour,, HH

;Figure out how many hours to run for tomorrow and today together
If (MissionCompleteTime2 < currentHour)
{
	HoursLeftToday := (24-CurrentHour)
	HoursLeftTomorrow := MissionCompleteTime2
	TotalHours := HoursLeftToday+HoursLeftTomorrow

	;Calculate end time for tomorrow in hours
	EndTime := (TotalHours-HoursLeftToday)

	;Some cool shiz here, formats 'date' as +1 days.  Then calculates it using that variable
	Date += 1, Days
	FormatTime, nDate, %Date%, dd

	EndDate := nDate
}
If (MissionCompleteTime2 > currentHour)
{
	TotalHours := MissionCompleteTime2-CurrentHour
	;msgbox, Hours until target time today: %TotalHours% hours!

	;Calculate end time for today in hours
	EndTime := currentHour + TotalHours
	EndDate := CurrentDate
}
;TotalHours = How much time until mission complete


MissionGoalFirstValue := SubStr(HowOftenChoice, 1,1)

;Gets the total minutes to run, stores in GetMissionGoal
If (MissionGoalFirstValue = 1)
{
	;Get minutes
	MissionGoalSecondValue := SubStr(HowOftenChoice, 6,2)
	if MissionGoalSecondValue =
	{
		GetMissionGoal = 1
		SleepFor = 60
	}
	if MissionGoalSecondValue = 15
	{
		GetMissionGoal = 1.25
		SleepFor = 75
	}
	if MissionGoalSecondValue = 30
	{
		GetMissionGoal = 1.5
		SleepFor = 90
	}
	if MissionGoalSecondValue = 45
	{
		GetMissionGoal = 1.75
		SleepFor = 105
	}
}
If (MissionGoalFirstValue = 2)
{
	GetMissionGoal = 2
	SleepFor = 120
}
If (SubStr(HowOftenChoice, 1,2) = 30)
{
	GetMissionGoal = 0.5
	SleepFor = 30
}
If (SubStr(HowOftenChoice, 1,2) = 45)
{
	GetMissionGoal = 0.75
	SleepFor = 45
}
;Calculate the minutes to sleep for
SleepFor := SleepFor*60000

;Get the MAX number of attempts possible, dividing by 2 to calculate 'reasonable' goal
Attempts := TotalHours / GetMissionGoal / 2

;TotalHours		= Hours until mission complete
;GetMissionGoal	= Time between reminders

;Determine which enemy, add this to its own method later
if Attempts < 6
{
 	Random, EnemyNumber, 1, 5
	Switch EnemyNumber
	{
		case 1:
		Enemy = Tracer
		case 2:
		Enemy = Widowmaker
		case 3:
		Enemy = Sombra
		case 4:
		Enemy = Hanzo
		case 5:
		Enemy = Genji
	}
	EnemyHealth = 3
}
if (Attempts > 5) AND (Attempts < 8)
{
	Random, EnemyNumber, 1, 5
	Switch EnemyNumber
	{
		case 1:
		Enemy = Phara
		case 2:
		Enemy = Mccree
		case 3:
		Enemy = Echo
		case 4:
		Enemy = Soldier76
		case 5:
		Enemy = Torbjorn
	}
	EnemyHealth = 4
}
if (Attempts > 7) AND (Attempts < 10)
{
	Random, EnemyNumber, 1, 5
	Switch EnemyNumber
	{
		case 1:
		Enemy = AsheBob
		case 2:
		Enemy = Symmetra
		case 3:
		Enemy = Reaper
		case 4:
		Enemy = Junkrat
		case 5:
		Enemy = Bastion
	}
	EnemyHealth = 5
}
if (Attempts > 9) AND (Attempts < 12)
{
	Random, EnemyNumber, 1, 5
	Switch EnemyNumber
	{
		case 1:
		Enemy = Zarya
		case 2:
		Enemy = WreckingBall
		case 3:
		Enemy = Sigma
		case 4:
		Enemy = Doomfist
		case 5:
		Enemy = Mei
	}
	EnemyHealth = 6
}
if (Attempts > 11)
{
	Random, EnemyNumber, 1, 5
	Switch EnemyNumber
	{
		case 1:
		Enemy = Roadhog
		case 2:
		Enemy = Rein
		case 3:
		Enemy = Winston
		case 4:
		Enemy = Orisa
		case 5:
		Enemy = Dva
	}
	EnemyHealth = 7
}

EnemyMaxHP := (EnemyHealth * 2)
;EnemyCurrentHP := EnemyHealth
EnemyCurrentHP = 10

/*
;Add this in later when time to download pictures
;Generate Enemy portrait for the day
Random, j, 1, 15
sleep 50
GuiControl,, ProfilePic, %A_ScriptDir%\%Enemy%\%EnemyPortrait%.jpg
*/

	;msgbox, Hero: %HeroChoice%`nHero Number: %HeroPortrait%`nEnd of Mission time: %MissionCompleteTime%`nFrequency of Alerts: %HowOftenChoice%`nSmoothie Reminders: %EnergyChoice%`nSound enabled: %SoundChoice%`nHero Portrait: %HeroPortrait%`nEnd Date: %EndDate%`nMission Complete Time: %MissionCompleteTime2%`nEnemy: %Enemy%`nEnemy Max HP: %EnemyMaxHP%`nEnemy Current HP: %EnemyCurrentHP%`nLevel: %Level%`nSleep for: %SleepFor%`nActivate: %SeqActivate%
	
	FileDelete, %A_ScriptDir%\System\StatsLog.txt
	FileAppend, %HeroChoice%|%MissionCompleteTime%|%HowOftenChoice%|%EnergyChoice%|%SoundChoice%|%HeroPortrait%|%EndDate%|%MissionCompleteTime2%|%Enemy%|%EnemyMaxHP%|%EnemyCurrentHP%|%Level%|%SleepFor%|%SeqActivate%, %A_ScriptDir%\System\StatsLog.txt
	FileAppend, `nHero Name | Time ending | Intervals | Smoothie | Sound | Hero # | End Date | Comp Time | Enemy | Enemy Max HP | Enemy Curr HP| Level | Sleep For | Activate, %A_ScriptDir%\System\StatsLog.txt

;Start 'energy' reminder (Smoothie) every 2 hours
if EnergyChoice = 1
{
	;SetTimer, EnergyReminderPopup, 7200000
	StopAllTimers("EnergyReminderPopup", 7200000)
}

Goto, ShowVsScreen

return



;Screen for energy reminder (Smoothie)
EnergyReminderPopup:
{
	;SetTimer, EnergyReminderPopup, Off
	StopAllTimers("None", RestTime)
	
	/*	;Keeping this in case I want it for later.  Uses only primary monitor
	SeqX := A_ScreenWidth
	SeqX := SeqX-320
	SeqY := A_ScreenHeight
	SeqY := SeqY-210
	*/
	
	;Gets width of 2nd monitor
	SysGet, TotalScreenWidth, 78
	SysGet, TotalscreenHeight, 79

	SeqX := TotalScreenWidth
	SeqX /= 1.35
	SeqY := TotalscreenHeight
	SeqY /= 2
	SeqX := (SeqX-375)
	SeqY := (SeqY-225)
	
	
	

	Gui, EnergyReminder: Destroy
	Gui, EnergyReminder: Margin , 0, 0
	GUI, EnergyReminder: +AlwaysOnTop
	Gui, EnergyReminder: Add, Picture, w320 h175 x0 y0 gEnergyReminderGuiEscape, %A_ScriptDir%\UI\Powerup.png
	gui, EnergyReminder: add, button, default x0 y175 w320 H35 gEnergyComplete, Complete!
;	gui, EnergyReminder: add, button, x75 y300 w75 H50 gRestTime10, 10 mins
	;gui, EnergyReminder: add, button, x150 y300 w75 H50 gRestTime15, 15 mins
	;gui, EnergyReminder: add, button, x225 y300 w75 H50 gRestTime30, 30 mins
	;Gui, EnergyReminder: Add, Picture, w50 h50 x0 y0 vTime5 gRestTime, %A_ScriptDir%\UI\5min.png
	Gui, EnergyReminder: -Caption
	
	if SeqActivate = 0
	{
		GUI, EnergyReminder: Show, NoActivate X%SeqX% Y%SeqY% W300 H350
	}
	if SeqActivate = 1
	{
		GUI, EnergyReminder: Show, X%SeqX% Y%SeqY% W320 H210
	}
}
return

;
EnergyComplete:
{
	;SetTimer, EnergyReminderPopup, Off
	StopAllTimers("None", None)
}
return

;Escape key for Energy Reminder
EnergyReminderGuiEscape:
	Gui, EnergyReminder: Destroy
	;SetTimer, EnergyReminderPopup, 7200000
	StopAllTimers("EnergyReminderPopup", 7200000)
	;SetTimer, EnergyReminderPopup, 2000		;Testing variable
return

ReminderPopupGuiEscape:
{
	;DestroyAllGUI()
	Gui, ReminderPopup: Destroy
	;SetTimer, ReminderPopup, 300000		;2000 good test time, Sleep 5 minutes atm
	StopAllTimers("ReminderPopup", 300000)
}
return

;j::


;Reminder screen if not good time or screen is closed
ReminderPopup:
;SetTimer, ReminderPopup, Off
StopAllTimers("None", None)

/*		Keeping this for later
SeqX := A_ScreenWidth
SeqX := SeqX-300
SeqY := A_ScreenHeight
SeqY := SeqY-360
*/


SysGet, TotalScreenWidth, 78
SysGet, TotalscreenHeight, 79

SeqX := TotalScreenWidth
SeqY := TotalscreenHeight
SeqX := (SeqX-300)
SeqY := (SeqY-360)


Random, NPCNum, 1, 3

Gui, ReminderPopup: Destroy
Gui, ReminderPopup: Margin , 0, 0
GUI, ReminderPopup: +AlwaysOnTop
Gui, ReminderPopup: Add, Picture, w300 h300 x0 y15 gRemind, %A_ScriptDir%\NPC\%NPCNum%.png
gui, ReminderPopup: add, button, default x0 y300 w75 H50 gRestTime5, 5 mins
gui, ReminderPopup: add, button, x75 y300 w75 H50 gRestTime10, 10 mins
gui, ReminderPopup: add, button, x150 y300 w75 H50 gRestTime15, 15 mins
gui, ReminderPopup: add, button, x225 y300 w75 H50 gRestTime30, 30 mins
;Gui, ReminderPopup: Add, Picture, w50 h50 x0 y0 vTime5 gRestTime, %A_ScriptDir%\UI\5min.png
Gui, ReminderPopup: -Caption

;If sound is null show checkbox that way
if SoundChoice = 0
{
	Gui, ReminderPopup: Add, CheckBox, x135 y0 vSeqSound gSeqSound, Sound?
}
if SoundChoice = 1
{
	Gui, ReminderPopup: Add, CheckBox, x135 y0 Checked vSeqSound gSeqSound, Sound?
}

;If activate is null show checkbox that way
if SeqActivate = 0
{
	Gui, ReminderPopup: Add, CheckBox, x235 y0 vSeqActivated gSeqActivated, Activate?
	GUI, ReminderPopup: Show, NoActivate X%SeqX% Y%SeqY% W300 H350
}
if SeqActivate = 1
{
	Gui, ReminderPopup: Add, CheckBox, x235 y0 Checked vSeqActivated gSeqActivated, Activate?
	GUI, ReminderPopup: Show, X%SeqX% Y%SeqY% W300 H360
}

StopAllTimers("None", None)
return

;If the Activate checkbox on reminder window is changed, update the file
SeqActivated:
{
	GUI, ReminderPopup: Submit, NoHide

	if (SeqActivate != SeqActivated)
	{
		SeqActivate := SeqActivated
		FileDelete, %A_ScriptDir%\System\StatsLog.txt
		FileAppend, %HeroChoice%|%MissionCompleteTime%|%HowOftenChoice%|%EnergyChoice%|%SoundChoice%|%HeroPortrait%|%EndDate%|%MissionCompleteTime2%|%Enemy%|%EnemyMaxHP%|%EnemyCurrentHP%|%Level%|%SleepFor%|%SeqActivate%, %A_ScriptDir%\System\StatsLog.txt
		FileAppend, `nHero Name | Time ending | Intervals | Smoothie | Sound | Hero # | End Date | Comp Time | Enemy | Enemy Max HP | Enemy Curr HP | Level | Sleep For | Activate, %A_ScriptDir%\System\StatsLog.txt
	}
}
return

;If the Sound checkbox on reminder window is changed, update the file
SeqSound:
{
	GUI, ReminderPopup: Submit, NoHide

	if (SoundChoice != SeqSound)
	{
		SoundChoice := SeqSound
		FileDelete, %A_ScriptDir%\System\StatsLog.txt
		FileAppend, %HeroChoice%|%MissionCompleteTime%|%HowOftenChoice%|%EnergyChoice%|%SoundChoice%|%HeroPortrait%|%EndDate%|%MissionCompleteTime2%|%Enemy%|%EnemyMaxHP%|%EnemyCurrentHP%|%Level%|%SleepFor%|%SeqActivate%, %A_ScriptDir%\System\StatsLog.txt
		FileAppend, `nHero Name | Time ending | Intervals | Smoothie | Sound | Hero # | End Date | Comp Time | Enemy | Enemy Max HP | Enemy Curr HP | Level | Sleep For | Activate, %A_ScriptDir%\System\StatsLog.txt
	}
}
return

;If picture is clicked, go to the Vs Screen
Remind:
{
	Gui, ReminderPopup: Destroy
	StopAllTimers("None", None)
	GoTo, ShowVsScreen
}
return

RestTime5:
{
	Gui, ReminderPopup: Destroy
	StopAllTimers("ReminderPopup", 300000)
	;SetTimer, ReminderPopup, off
	;SetTimer, ShowVsScreen, off
	;SetTimer, ReminderPopup, 300000		;Sleep 5 minutes	
}
return

RestTime10:
{
	Gui, ReminderPopup: Destroy
	StopAllTimers("ReminderPopup", 600000)
	;SetTimer, ReminderPopup, off
	;SetTimer, ShowVsScreen, off
	;SetTimer, ReminderPopup, 600000		;Sleep 10 minutes	
}
return

RestTime15:
{
	Gui, ReminderPopup: Destroy
	StopAllTimers("ReminderPopup", 900000)
	;SetTimer, ReminderPopup, off
	;SetTimer, ShowVsScreen, off
	;SetTimer, ReminderPopup, 900000		;Sleep 15 minutes
}
return

RestTime30:
{
	Gui, ReminderPopup: Destroy
	StopAllTimers("ReminderPopup", 1800000)
	;SetTimer, ReminderPopup, off
	;SetTimer, ShowVsScreen, off
	;SetTimer, ReminderPopup, 1800000	;Sleep 30 minutes	
}
return


;Main screen to get missions
ShowVsScreen:
;SetTimer, ShowVsScreen, off
;SetTimer, ReminderPopup, off
StopAllTimers("None", None)

	;Might not need these 15~ lines below, test later and delete?
	FileReadLine, SeqStats, %A_ScriptDir%\System\StatsLog.txt, 1

	SeqParameters := StrSplit(SeqStats, "|")

	HeroChoice := SeqParameters[1]
	MissionCompleteTime := SeqParameters[2]
	HowOftenChoice := SeqParameters[3]
	EnergyChoice := SeqParameters[4]
	SoundChoice := SeqParameters[5]
	HeroPortrait := SeqParameters[6]
	EndDate := SeqParameters[7]
	MissionCompleteTime2 := SeqParameters[8]
	Enemy := SeqParameters[9]
	EnemyMaxHP := SeqParameters[10]
	EnemyCurrentHP := SeqParameters[11]
	Level := SeqParameters[12]
	SleepFor := SeqParameters[13]
	SeqActivate := SeqParameters[14]

if SoundChoice = 1
{
	Random, SoundNum, 1, 5
	SoundPlay, %A_ScriptDir%\Sounds\%HeroChoice%\A%SoundNum%.mp3
}

SysGet, TotalScreenWidth, 78
SysGet, TotalscreenHeight, 79

SeqX := TotalScreenWidth
SeqX /= 1.35
SeqY := TotalscreenHeight
SeqY /= 2
SeqX := (SeqX-650)
SeqY := (SeqY-370)


	;Calculate Border Colour, Stars, and Level X Location
	SeqResults := StrSplit(SeqCalculations(level), "|")
	
	Stars := SeqResults[1]
	levelColour := SeqResults[2]
	SeqLevelNum := SeqResults[3]
	SeqLevelXLocation := SeqResults[4]


;Random Battle button
Random, BattleNum, 1, 3

;Destroy previous GUI and build new 'Vs Screen'
DestroyAllGUI()
GUI, GwynBattles2: Color, Red
GUI, GwynBattles2: Font, s16
GUI, GwynBattles2: Font, cBlack
GUI, GwynBattles2: +AlwaysOnTop
GUI, GwynBattles2: add, text,x385 y610 w500 h50 +Wrap vGetText
Gui, GwynBattles2: Margin , 10, 10
Gui, GwynBattles2: Add, Picture, x0 y0 W1307 H741, %A_ScriptDir%\UI\Vs.png
Gui, GwynBattles2: Add, Picture, x50 y150 w300 h300, %A_ScriptDir%\%HeroChoice%\%HeroPortrait%.jpg
Gui, GwynBattles2: Add, Picture, x950 y150 w300 h300, %A_ScriptDir%\Enemies\%Enemy%\1.jpg		;Change this when downloaded more pictures, add random 1,15 thing somewhere
Gui, GwynBattles2: Add, Picture, x925 y475 w350 h65 +BackgroundTrans, %A_ScriptDir%\UI\%EnemyCurrentHP%.png
Gui, GwynBattles2: Add, Picture, x500 y625 w350 h65 gGetMission, %A_ScriptDir%\UI\Battle%BattleNum%.jpg
Gui, GwynBattles2: Add, Picture, x275 y485 +BackgroundTrans vGetMission gGetMission
Gui, GwynBattles2: Add, Picture, x1050 y575 h150 w150 +BackgroundTrans vMissionComplete gCompleteMission
GUI, GwynBattles2: add, text,x%SeqLevelXLocation% y575, %Level%
GUI, GwynBattles2: Add, Picture, x109 y512 w150 h150 +BackgroundTrans, %A_ScriptDir%\Levels\%levelColour%\%SeqLevelNum%0.png
GUI, GwynBattles2: Add, Picture, x121 y576 w125 h75 +BackgroundTrans, %A_ScriptDir%\Levels\%levelColour%\%Stars%.png
GUI, GwynBattles2:show, X%SeqX% Y%SeqY% W1300 H740

StopAllTimers("None", None)
return

;If escape key is pressed, destroys gui
GwynBattles2GuiEscape:
DestroyAllGui()
StopAllTimers("ReminderPopup", 2000)
;SetTimer, ReminderPopup, 2000
return

DestroyAllGUI()
{
	GUI, GwynBattles:destroy
	GUI, GwynBattles2:destroy
	GUI, LevelUp:destroy
	GUI, NoLevelUp:destroy
	;GUI, ReminderPopup:destroy
}
return



;After doing a workout/stretch, decrease enemy hp, update file, set timer up again
CompleteMission:
if EnemyCurrentHP != 0
{
	EnemyCurrentHP := EnemyCurrentHP-1
	DestroyAllGui()
	
	FileDelete, %A_ScriptDir%\System\StatsLog.txt
	FileAppend, %HeroChoice%|%MissionCompleteTime%|%HowOftenChoice%|%EnergyChoice%|%SoundChoice%|%HeroPortrait%|%EndDate%|%MissionCompleteTime2%|%Enemy%|%EnemyMaxHP%|%EnemyCurrentHP%|%Level%|%SleepFor%|%SeqActivate%, %A_ScriptDir%\System\StatsLog.txt
	FileAppend, `nHero Name | Time ending | Intervals | Smoothie | Sound | Hero # | End Date | Comp Time | Enemy | Enemy Max HP | Enemy Curr HP | Level | Sleep For | Activate, %A_ScriptDir%\System\StatsLog.txt
	;StartTimer(SleepFor)
	StopAllTimers("ShowVsScreen", SleepFor)
	return
}

;If enemy health is already 0, stay there, setup timer
DestroyAllGui()
StopAllTimers("ShowVsScreen", SleepFor)
;StartTimer(SleepFor)
return

/*
;Old - delete this
;This is the timer for how long to sleep before notifications
StartTimer(SleepFor)
{
;	#Persistent ; uncomment this line to see the effect?  Don't think we need this
	SetTimer, ShowVsScreen, %SleepFor%
	return		; Why is this return here...?  Delete someday
}
return
*/

;When hero drop down is changed in setup screen load hero picture
SeqHeroChoice:
Gui, Submit, nohide
	if HeroChoice = Mercy
	{
		;Generate Mercy portrait for the day
		Random, HeroPortrait, 1, 15
		sleep 50
		GuiControl,, ProfilePic, %A_ScriptDir%\%HeroChoice%\%HeroPortrait%.jpg
		;Play sound later - Seq
	}
	if HeroChoice = Brig
	{
		Random, HeroPortrait, 1, 5
		sleep 50
		GuiControl,, ProfilePic, %A_ScriptDir%\%HeroChoice%\%HeroPortrait%.jpg
	}
	if HeroChoice = Ana
	{
		Random, HeroPortrait, 1, 10
		sleep 50
		GuiControl,, ProfilePic, %A_ScriptDir%\%HeroChoice%\%HeroPortrait%.jpg
	}
	if HeroChoice = Moira
	{
		Random, HeroPortrait, 1, 5
		sleep 50
		GuiControl,, ProfilePic, %A_ScriptDir%\%HeroChoice%\%HeroPortrait%.jpg
	}	
	if HeroChoice !=
	{
		;If no choice provided, disable controls
		GuiControl, Enable, MissionCompleteTime
		GuiControl, Enable, HowOftenChoice
	}
	if HeroChoice =
	{
		GuiControl, Disable, MissionCompleteTime
		Send {home}
	}
	
return

;When mission time drop down is changed in setup screen enable next control
SeqMissionCompleteTime:
Gui, Submit, nohide
sleep 50
	if MissionCompleteTime !=
	{
		GuiControl, Enable, HowOftenChoice
	}
	if MissionCompleteTime =
	{
		GuiControl, Disable, HowOftenChoice
		Send {home}
	}
return

;When mission time drop down is changed in setup screen enable next control
SeqHowOftenChoice:
Gui, Submit, nohide
sleep 50
	if HowOftenChoice !=
	{
		GuiControl, Enable, EnergyChoice
		GuiControl, Enable, SoundChoice
		GuiControl,, PlayPic, %A_ScriptDir%\UI\Play.png
	}
	if HowOftenChoice =
	{
		GuiControl, Disable, EnergyChoice
	}
return

;When Energy drop down is changed in setup screen enable next control
SeqEnergyChoice:
Gui, Submit, nohide
sleep 50
	if EnergyChoice !=
	{
		GuiControl, Enable, SoundChoice
		
	}
	if EnergyChoice =
	{
		GuiControl, Disable, SoundChoice
	}
return

;Delete this probably
SeqSoundChoice:
Gui, Submit, nohide
sleep 50
	if SoundChoice !=
	{
		;GuiControl, Enable, EnergyChoice
	}
	if SoundChoice =
	{
		;GuiControl, Disable, EnergyChoice
	}
return



;Gwynnie workout thing
GetMission:
Random, OutputVar, 1, 30
Seq = %OutputVar%

GuiControl,, GetMission, %A_ScriptDir%\UI\Text.png
sleep 50
GuiControl,, MissionComplete, %A_ScriptDir%\UI\Check.png


switch Seq
{
	case 1:
	SeqMissionMessage := "Eat chocolate!"
	case 2:
	SeqMissionMessage := "Stand then sit in chair 5 times!"
	case 3:
	SeqMissionMessage := "Wiggle hips to left and right for 25 seconds."
	case 4:
	SeqMissionMessage := "Lift weights 5x ONLY above your head"
	case 5:
	SeqMissionMessage := "Lift weights 5x ONLY forward"
	case 6:
	SeqMissionMessage := "Lift weights 5x curles "
	case 7:
	SeqMissionMessage := "Walk to window and  back 2~3x"
	case 8:
	SeqMissionMessage := "Knee grabs 5x"
	case 9:
	SeqMissionMessage := "Door Frame hang/stretch 5 seconds"
	case 10:
	SeqMissionMessage := "Spin hands like a blender together from `ndoor to window and back"
	case 11:
	SeqMissionMessage := "Edge of chair back stretch with chest out. `n ~15 seconds while looking out window"
	case 12:
	SeqMissionMessage := "Hip swirl 5x left, 5x right"
	case 13:
	SeqMissionMessage := "Leg slow kick out and hold x1 per leg"
	case 14:
	SeqMissionMessage := "Forward thrust 5x with arms out"
	case 15:
	SeqMissionMessage := "30 full seconds of wonderwoman pose"
	case 16:
	SeqMissionMessage := "Tumbler arms while walking to window and back(like swimming)"
	case 17:
	SeqMissionMessage := "Edge of chair back stretch with chest out.  `nMin 30 seconds while looking out window!"
	case 18:
	SeqMissionMessage := "15x wall thrusts with happy ball!"
	case 19:
	SeqMissionMessage := "Two foot bunny hop to door and back to computer"
	case 20:
	SeqMissionMessage := "Eat chocolate!"
	case 21:
	SeqMissionMessage := "Frog stroke arms from door to window"
	case 22:
	SeqMissionMessage := "Frog stance dance 5x `n(lean left and right while crouched)"
	case 23:
	SeqMissionMessage := "Standing arm pulses behind back"
	case 24:
	SeqMissionMessage := "Push-up time"
	case 25:
	SeqMissionMessage := "5x chair squats"
	case 26:
	SeqMissionMessage := "Pretend jump rope from desk to front door"
	case 27:
	SeqMissionMessage := "Wall Push-ups"
	case 28:
	SeqMissionMessage := "Elbow to opposite knee while sitting 5x per knee"
	case 29:
	SeqMissionMessage := "Head down, arms out while sitting`nHold for 3 deep breaths"
	case 30:
	SeqMissionMessage := "Hamstring Stretch, touch toesfor 3 deep breaths per leg"
}

GuiControl,, GetText, %SeqMissionMessage%

Return