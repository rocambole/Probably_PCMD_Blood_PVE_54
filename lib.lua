pcmdDK = {}
pcmdDK.darkSimSpells = {
-- siege of orgrimmar
"Froststorm Bolt","Arcane Shock","Rage of the Empress","Chain Lightning",
-- pvp
"Hex","Mind Control","Cyclone","Polymorph","Pyroblast","Tranquility","Divine Hymn","Hymn of Hope","Ring of Frost","Entangling Roots"
}

ProbablyEngine.condition.register("shouldInterrupt", function(unit)
	local stop = ProbablyEngine.condition["casting"](unit)
	if stop then SpellStopCasting() end
		return stop
	end
	return false
end)

pcmdDK.shouldDarkSimFocus = function() end
function pcmdDK.shoulDarkSimUnit(unit)
	for index,spellName in pairs(pcmdDK.darkSimSpells) do
		
		if jps.IsCastingSpell(spellName, unit) then return true end
		if jps.IsChannelingSpell(spellName, unit) then return true end
	end
	return false
end

function pcmdDK.shouldDarkSimTarget()
	return pcmdDK.shoulDarkSimUnit("target")
end

function pcmdDK.shouldDarkSimFocus()
	return pcmdDK.shoulDarkSimUnit("focus")
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

ProbablyEngine.library.register("pcmdDK", pcmdDK)