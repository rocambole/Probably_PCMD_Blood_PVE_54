pcmdDK = {}
pcmdDK.darkSimSpells = {
-- siege of orgrimmar
"Froststorm Bolt","Arcane Shock","Rage of the Empress","Chain Lightning",
-- pvp
"Hex","Mind Control","Cyclone","Polymorph","Pyroblast","Tranquility","Divine Hymn","Hymn of Hope","Ring of Frost","Entangling Roots"
}

ProbablyEngine.condition.register("shouldInterrupt", function(unit)
	if not ProbablyEngine.condition["modifier.toggle"]('interrupt') then return false end
	local stop = ProbablyEngine.condition["casting"](unit)
	if stop then SpellStopCasting() end
	return stop
end)

function pcmdDK.shoulDarkSimUnit(unit)
	for index,spellName in pairs(pcmdDK.darkSimSpells) do
		if ProbablyEngine.condition["casting"](unit, spellName) then return true end
	end
	return false
end

function pcmdDK.canCastPlagueLeech(timeLeft)
	local frostFeverApplied, _, ffExpires, ffCaster = UnitDebuff("target","Frost Fever","player")
	local bloodPlagueApplied, _, bpExpires, bpCaster = UnitDebuff("target","Blood Plague","player")
	local durationFF = 0
	local durationBP = 0
	if ffExpires and ffCaster == "player" then
		durationFF = (ffExpires - (GetTime()-(ProbablyEngine.lag/1000)))
	end
	if bpExpires and bpCaster == "player" then
		durationBP = (bpExpires - (GetTime()-(ProbablyEngine.lag/1000)))
	end
	
	if not frostFeverApplied or not bloodPlagueApplied then return false end
	if durationFF <= timeLeft then
		return true
	end
	if durationBP <= timeLeft then
		return true
	end
	return false
end
function pcmdDK.hasGhoul()
		if ProbablyEngine.module.player.specName == "Unholy" then
			if UnitExists("pet") == nil then return false end
		else
			if select(1,GetTotemInfo(1)) == false then return false end
		end
		return true
	end
	
function pcmdDK.gotBloodRunes()
	if GetRuneType(1) ~= 4 and GetRuneType(2) ~= 4 then
		return true
	end 
	return false
end

ProbablyEngine.library.register("pcmdDK", pcmdDK)

--[[
	testConfig:addCheckBox("checkTest", "CheckBox Text: ".. veryLongText, "CheckBox Tooltip Text", false)
	testConfig:addTextBox("textTest", "TextBox Text: ".. veryLongText, "TextBox Tooltip Text", "giulia")
	testConfig:addNumericBox("numericTest", "NumericBox Text: ".. veryLongText, "NumericBox Tooltip Text", 42)
	testConfig:addText("Short Text - no tooltip")
	testConfig:addText("Text Text: ".. veryLongText, "Text Segment Test")
	testConfig:addSlider("sliderText", "Slider Text: ".. veryLongText, "Slider Tooltip Text", 1, 10, 4, 1)
	testConfig:addButton("Button Text: Ignores Width!", "Button Tooltip Text", function(cfg) print("You pressed the Button! (Config @" .. tostring(cfg) .. ")") end)
	testConfig:addDropDown("dropdownTest", "Drop Down Text: " .. veryLongText, "DropDown Tooltip", {"alpha", "beta", "gamma"}, 2)
	testConfig:addDropDown("dropdownNamedTest", "Drop Down Named Keys", "DropDown Tooltip 2", {ALPHA="alpha", BETA="beta", GAMMA="gamma"}, "ALPHA")
]]--


pcmdDK.config = {}
function pcmdDK.initConfig()
	--[[[mConfig copyright & thanks to https://github.com/kirk24788/mConfig , if u use this , please keep his copyright ;) ]]--
	pcmdDK.config = mConfig:createConfig("Blood Deathknight Config","BloodDKConfig","Default",{"/dk"})
	
	--deff cooldowns
	pcmdDK.config:addText("Deff Cooldowns")
	pcmdDK.config:addSlider("ibfPercentage","Icebound Fortitude HP %","HP % you need to drop to use Icebound Fortitude", 10,100,40,1)
	pcmdDK.config:addSlider("vbPercentage","Vampiric Blood HP %","HP % you need to drop to use Vampiric Blood", 10,100,40,1)
	pcmdDK.config:addSlider("dpPercentage","Death Pact HP %","HP % you need to drop to use Death Pact", 10,100,50,1)
	pcmdDK.config:addSlider("lichbornePercentage","Lichborne HP %","HP % you need to drop to use Lichborne", 10,100,50,1)
	pcmdDK.config:addSlider("runeTapPercentage","Rune Tap HP %","HP % you need to drop to use Rune Tap", 10,100,80,1)
	pcmdDK.config:addSlider("deathStrikePercentage","Death Strike HP %","HP % you need to drop to use Death Strike on CD", 10,100,70,1)
	
	--spell usage checkboxes
	pcmdDK.config:addText("Spell Usage")	
	pcmdDK.config:addCheckBox("useOutOfCombatHorn", "Horn of Winter out of combat", "Use Horn of Winter out of combat", true)
	
	--modifiers
	pcmdDK.config:addText("Modifier Actions")
	pcmdDK.config:addDropDown("altKeyAction", "Alt-Key Action", "Action to do when Alt-Key is pressed", {ANTIMAGICZONE="Anti Magic Zone", DND="Death and Decay", PAUSE="Pause Rotation", ARMY="Army of Death"}, "ANTIMAGICZONE")
	pcmdDK.config:addDropDown("shiftKeyAction", "Shift-Key Action", "Action to do when Shift-Key is pressed", {ANTIMAGICZONE="Anti Magic Zone", DND="Death and Decay", PAUSE="Pause Rotation", ARMY="Army of Death"}, "DND")
	pcmdDK.config:addDropDown("controlKeyAction", "Control-Key Action", "Action to do when Control-Key is pressed", {ANTIMAGICZONE="Anti Magic Zone", DND="Death and Decay", PAUSE="Pause Rotation", ARMY="Army of Death"}, "PAUSE")
	
end

function pcmdDK.getConfig(key)
	return pcmdDK.config:get(key)
end
function pcmdDK.configShouldUseSpell(key)
	return pcmdDK.config:get(key)
end

function pcmdDK.configUnitHpBelowThreshold(key,unit)
	return ProbablyEngine.condition["health"](unit) <= pcmdDK.config:get(key)
end

function pcmdDK.modifierActionForSpellIsAlt(name)
	return IsAltKeyDown() and not GetCurrentKeyBoardFocus() and pcmdDK.getConfig("altKeyAction")==name
end
function pcmdDK.modifierActionForSpellIsShift(name)
	return IsShiftKeyDown() and not GetCurrentKeyBoardFocus() and pcmdDK.getConfig("shiftKeyAction")==name
end
function pcmdDK.modifierActionForSpellIsControl(name)
	return IsControlKeyDown() and not GetCurrentKeyBoardFocus() and pcmdDK.getConfig("controlKeyAction")==name
end
pcmdDK.initConfig()