dotEngine.dots = {
	55078:{modifier: {"attackPower","crit","dmg","mastery"}, refreshAt: 2 }
}
dotEngine.namesToID = {}

dotEngine.currentDotStats = {}
dotEngine.dotModifiers = {
	attackPower: dotEngine.totalAttackPower,
	crit: GetCritChance,
	dmg: dotEngine.getDamageBuff,
	mastery: GetMastery,
	intellect: dotEngine.getIntellect
	strength: dotEngine.getStrength
	agility: dotEngine.getAgility
	spirit: dotEngine.getSpirit
}
dotEngine.addDot = function(dotID, localizedName, modifiersTable, refrestAtSeconds )
	dotEngine.namesToID[localizedName] = dotID
	dotEngine.dots[dotID] = {name: localizedName, modifiers: modifiersTable, refrestAt: refrestAtSeconds}
end

dotEngine.dmgIncreaseBuffs = {
	{138002, 0.4}, --+40% jin rokh fluidity
	{140741, 1,0.1, "HARMFUL"},-- +100% +10% per stack - ji kun nitrument
	{57934, 0.15}, -- +15% - tricks
	{118977, 0.6},-- +60% - fearless
}
dotEngine.getDamageBuff = function()
	-- credits to kirk' dotTracker
	local damageBuff = 1
	for i, buff in ipairs(dotEngine.dmgIncreaseBuffs) do
		local filter = buff[4] or nil
		hasBuff,_,_,stacks = UnitAura("player", buff[1], nil, filter)
		if hasBuff then
			damageBuff = damageBuff + buff[2] + (buff[2] * stacks)
		end
	end
	return damageBuff
end

dotEngine.getIntellect = function() return UnitStat("player", 4) end
dotEngine.getStrength = function() return UnitStat("player", 1) end
dotEngine.getAgility = function() return UnitStat("player", 2) end
dotEngine.getSpirit = function() return UnitStat("player", 5) end

dotEngine.totalAttackPower = function()
	local base, pos, neg = UnitAttackPower("player")
	return base + pos + neg
end

dotEngine.getDotInfo = function(data)
	if type(data) == "number" then
		local dotID = data
		local debuffName = select(1,GetSpellInfo(data))
	else
		local dotID = dotEngine.namesToID[data]
		local debuffName = data
	end
	return dotId, debuffName
end

dotEngine.shouldRefresh = function(dotName, unit)
	if not unit then unit = "target" end
	local dotID, debuffName = dotEngine.getDotInfo(dotName)
	if not debuffName then return false end -- something is wrong :) 
	local debuff,_,expiresAt,caster = UnitDebuff(unit, debuffName)
	if not debuff or (caster ~= 'player' and caster ~= 'pet') then
		return true
	end
	local shouldRefresh = false
	if dotEngine.dotIsKnown(dotID) then
		for key,value in pairs(dotEngine.dots[dotID].modifiers) do
			if dotEngine.currentDotStats[dotID].value then
				if dotEngine.dotModifiers[value]() > dotEngine.currentDotStats[dotID][value]  then
					shoudRefresh = true
					break
				end
			end
		end
	end
	if shouldRefresh == true then
		dotEngine.currentDotStats[dotID].isStrong = true
	end
	return shouldRefresh
end

dotEngine.shouldExtendDot = function(dotName, unit)
	if not unit then unit = "target" end
	local dotID, debuffName = dotEngine.getDotInfo(dotName)
	if not debuffName then return false end -- something is wrong :) 
	local debuff,_,_,caster = UnitDebuff(unit, debuffName)
	if not debuff or (caster ~= 'player' and caster ~= 'pet') then
		return false
	end
	if not dotEngine.shouldRefreshDot(spellID, unit) and dotEngine.currentDotStats[spellID].isStrong then return true end -- extend current "strong" dot's
	return false
end

dotEngine.dotIsKnown = function(dotID)
	if not dotID then return false end
	if type(dotName) ~= "number" then
		-- throw some errors
		return false
	end
	if dotEngine.dots[dotID] ~= nil then return true end
	return false
end

dotEngine.logDotDmg = function(...)
	local eventtype = select(2, ...)
	local srcName = select(5 , ...)
	local spellID = select(12, ...)

	if  not eventtype or srcName ~= select(1,UnitName("player")) then return end
	if not dotEngine.dotIsKnown(spellID) then return end
	if eventtype == "SPELL_AURA_APPLIED" or eventtype == "SPELL_AURA_REFRESH" then
		if not dotEngine.currentDotStats[spellID] then
			dotEngine.currentDotStats[spellID] = {}
			dotEngine.currentDotStats[spellID].isStrong = false
		end
		for key,value in pairs(dotEngine.dots[dotID].modifiers) do
			dotEngine.currentDotStats[dotID][value] = dotEngine.dotModifiers[value]()
		end
	end
	if eventtype == "SPELL_AURA_REMOVED" then
		if dotEngine.currentDotStats[spellID] then
			for key,value in pairs(dotEngine.dots[dotID].modifiers) do
				dotEngine.currentDotStats[dotID][value] = 0
			end
			dotEngine.currentDotStats[dotID].isStrong = false
		end
	end
end
ProbablyEngine.listener.register(	"COMBAT_LOG_EVENT_UNFILTERED", dotEngine.logDotDmg)
ProbablyEngine.library.register("dotTracker", dotEngine)