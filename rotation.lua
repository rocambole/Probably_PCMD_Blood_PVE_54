-- ProbablyEngine Rotation Packager
-- Custom Blood Death Knight Rotation		
-- Created on Dec 17th 2013 8:14 am
ProbablyEngine.rotation.register_custom(250, "PCMD Blood PVE 5.4", {
	-- Blood presence
	{"Blood Presence",	'!player.buff(Blood Presence)'},
	
	{"Pause",	'@pcmdDK.modifierActionForSpellIsAlt("PAUSE")'},
	{"Pause",	'@pcmdDK.modifierActionForSpellIsShift("PAUSE")'},
	{"Pause",	'@pcmdDK.modifierActionForSpellIsControl("PAUSE")'},
	
	{"Death and Decay",	'@pcmdDK.modifierActionForSpellIsAlt("DND")'},
	{"Death and Decay",	'@pcmdDK.modifierActionForSpellIsShift("DND")','ground'},
	{"Death and Decay",	'@pcmdDK.modifierActionForSpellIsControl("DND")','ground'},
	
	{"Anti-Magic Zone",	'@pcmdDK.modifierActionForSpellIsAlt("ANTIMAGICZONE")'},
	{"Anti-Magic Zone",	'@pcmdDK.modifierActionForSpellIsShift("ANTIMAGICZONE")','ground'},
	{"Anti-Magic Zone",	'@pcmdDK.modifierActionForSpellIsControl("ANTIMAGICZONE")','ground'},
	
	{"Army of the Dead",	'@pcmdDK.modifierActionForSpellIsAlt("ARMY")'},
	{"Army of the Dead",	'@pcmdDK.modifierActionForSpellIsShift("ARMY")'},
	{"Army of the Dead",	'@pcmdDK.modifierActionForSpellIsControl("ARMY")'},

	-- Defensive cooldowns
	{{
		{"#5512", 'player.health < 70'}, --healthstone
		{"Icebound Fortitude",	'@pcmdDK.configUnitHpBelowThreshold("ibfPercentage","player")'},
		{"Vampiric Blood",	{'modifier.cooldowns','@pcmdDK.configUnitHpBelowThreshold("vbPercentage","player")'}},
		{"Death Pact",	{'@pcmdDK.configUnitHpBelowThreshold("dpPercentage","player")','@pcmdDK.hasGhoul()'}},
		{"Lichborne",	{'@pcmdDK.configUnitHpBelowThreshold("lichbornePercentage","player")','player.runicpower >= 40','player.spell.exists(Lichborne)'}},
		{"Death Coil",	{'player.health < 90','player.runicpower >= 40','player.buff(lichborne)'}, "player"},
	},"modifier.cooldowns"},

	{"Rune Tap",	'@pcmdDK.configUnitHpBelowThreshold("runeTapPercentage","player")'},

	-- Interrupts
	{"mind freeze",	'target.shouldInterrupt'},
	{"mind freeze",	'focus.shouldInterrupt', "focus"},
	{"Strangulate",	{'!target.spell(47528).range','!player.modifier.last(47528)'}},
	{"Strangulate",	{'mouseover.shouldInterrupt','!focus.spell(47528).range','!modifier.last(47528)'}, "mouseover"},
	{"Strangulate",	{'focus.shouldInterrupt','!focus.spell(47528).range','!modifier.last(47528)'}, "focus" },
	{"Asphyxiate",	{'target.shouldInterrupt','!modifier.last(47528)'}},
	{"Asphyxiate",	{'mouseover.shouldInterrupt','!modifier.last(47528)'}, "mouseover"},
	{"Asphyxiate",	{'focus.shouldInterrupt','!modifier.last(47528)'}, "focus"},

	-- Spell Steal
	{"Dark Simulacrum ", '@pcmdDK.shoulDarkSimUnit("target")' , "target"},
	{"Dark Simulacrum ", '@pcmdDK.shoulDarkSimUnit("focus")' , "focus"},

	{"Raise Dead",	{'modifier.cooldowns','!@pcmdDK.hasGhoul()'}},
	{
		{
			{"Dancing Rune Weapon", "!toggle.DRW"},
			-- Requires engineering
			{ '#gloves'},
			-- Requires herbalism
			{"Lifeblood"},
			-- Racials
			{ "Berserking"},
			{ "Blood Fury"},
		},
		{'modifier.cooldowns', 'target.spell(56815).range'}
	},

	-- Buff
	{"Bone Shield",	'!player.buff(Bone Shield)'},

	-- Diseases
	{"Unholy Blight",	'target.debuff(frost fever).duration < 2'},
	{"Unholy Blight",	'target.debuff(blood plague).duration < 2'},
	{"Outbreak",	'target.debuff(frost fever).duration < 2'},
	{"Outbreak",	'target.debuff(blood plague).duration < 2'},

	-- Multi target
	{"Death and Decay",	{'@pcmdDK.modifierActionForSpellIsAlt("DND")','player.buff(Crimson Scourge)'}},
	{"Death and Decay",	{'@pcmdDK.modifierActionForSpellIsShift("DND")','player.buff(Crimson Scourge)'}},
	{"Death and Decay",	{'@pcmdDK.modifierActionForSpellIsControl("DND")','player.buff(Crimson Scourge)'}},
	{"Blood Boil",	{'modifier.multitarget','target.range <= 10'}},
	{"Rune Strike",	{'player.runicpower >= 30','toggle.DPS'}},
	{"Blood Boil",	{'player.buff(Crimson Scourge)','target.range <= 10'}},

	-- Rotation
	
	{"Death Strike",	'@pcmdDK.configUnitHpBelowThreshold("deathStrikePercentage","player")'},
	{"Death Strike",	'player.buff(Blood Shield).duration <= 4'},
	{"Soul Reaper",	'target.health <= 35'},
	{"Plague Strike",	'target.debuff(Blood Plague).duration = 0'},
	{"Icy Touch",	'target.debuff(Frost Fever).duration = 0'},
	{"Rune Strike",	{'player.runicpower >= 80','player.runes(frost).count < 2','player.runes(unholy).count < 2'}},
	{"Death Strike"},

	-- Death Siphon when we need a bit of healing. (talent based)
	{"Death Siphon",	'player.health < 60'},

	{"Heart Strike",	{'target.debuff(Blood Plague).duration > 0','target.debuff(Frost Fever).duration > 0','@pcmdDK.gotBloodRunes()'}},
	{"Rune Strike",	{'player.runicpower >= 30','!player.buff(lichborne)'}}, -- stop using Rune Strike if Lichborne is up

	{"Horn of Winter"},
	{"Plague Leech",	'@pcmdDK.canCastPlagueLeech(3)'},
	{"Blood Tap", 'player.buff(Blood Charge).count >= 5'},
	{"Empower Rune Weapon",	{'modifier.cooldowns','target.spell(56815).range','player.runes(death).count < 1','player.runes(frost).count < 1','player.runes(unholy).count < 1','player.runicpower < 30'}},
}, {
	-- Out Of Combat
	{"Horn of Winter", '@pcmdDK.configShouldUseSpell("useOutOfCombatHorn")'},

}, function()
ProbablyEngine.toggle.create('DPS', 'Interface\\Icons\\Spell_DeathKnight_DarkConviction', 'Push your DPS with Rune Strike', 'Toggle On if you wan\' to prioritize Rune Strike over Death Strike')
ProbablyEngine.toggle.create('DRW', 'Interface\\Icons\\INV_Sword_07', 'stop using Dancing Rune Weapon', 'Toggle On if you dont\'t want to use DRW on CD' )
end)