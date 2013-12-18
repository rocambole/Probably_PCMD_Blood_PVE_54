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
		durationBP =  (bpExpires - (GetTime()-(ProbablyEngine.lag/1000)))
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

function pcmdDK.gotBloodRunes()
	if GetRuneType(1) ~= 4 and GetRuneType(2) ~= 4 then
		return true
	end 
	return false
end
ProbablyEngine.library.register("pcmdDK", pcmdDK)