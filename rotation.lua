-- ProbablyEngine Rotation Packager
-- Custom Blood Death Knight Rotation		
-- Created on Dec 17th 2013 8:14 am
ProbablyEngine.rotation.register_custom(250, "PCMD Blood PVE 5.4", {
	-- Blood presence
	{"Blood Presence",	'!player.buff(Blood Presence)'},

	{"Death and Decay",	'modifier.shift','ground'},
	{"Anti-Magic Zone",	'modifier.alt','ground'},

	-- Defensive cooldowns
	{{
		{"#5512", 'player.health < 70'}, --healthstone
		{"Icebound Fortitude",	'player.health <= 30'},
		{"Vampiric Blood",	{'modifier.cooldowns','player.health < 40'}},
		{"Death Pact",	{'player.health < 50','pet.alive'}},
		{"Lichborne",	{'player.health < 50','player.runicpower >= 40','player.spell.exists(Lichborne)'}},
		{"Death Coil",	{'player.health < 90','player.runicpower >= 40','player.buff(lichborne)'}, "player"},
	},"modifier.cooldowns"},
	{"Rune Tap",	'player.health < 80'},

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

	{"Raise Dead",	{'modifier.cooldowns','!pet.alive'}},

	{
		{
			{"Dancing Rune Weapon"},
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
	{"Blood Boil",	{'modifier.multitarget','target.spell(48721).range'}},
	{"Death and Decay",	{'modifier.shift','player.buff(Crimson Scourge)'}},
	{"Blood Boil",	{'player.buff(Crimson Scourge)','target.spell(48721).range'}},

	-- Rotation
	{"Death Strike",	'player.health < 70'},
	{"Death Strike",	'player.buff(Blood Shield).duration <= 4'},
	{"Soul Reaper",	'target.health <= 35'},
	{"Plague Strike",	'target.debuff(Blood Plague).duration = 0'},
	{"Icy Touch",	'target.debuff(Frost Fever).duration = 0'},
	{"Rune Strike",	{'player.runicpower >= 80','player.runes(frost).count < 2','player.runes(unholy).count < 2'}},
	{"Death Strike"},

	-- Death Siphon when we need a bit of healing. (talent based)
	{"Death Siphon",	'player.health < 60'},

	{"Heart Strike",	{'target.debuff(Blood Plague).duration > 0','target.debuff(Frost Fever).duration > 0','@pcmdDK.bloodRuneCheck()'}},

	{"Rune Strike",	{'player.runicpower >= 30','!player.buff(lichborne)'}}, -- stop using Rune Strike if Lichborne is up

	{"Horn of Winter"},
	{"Plague Leech",	'@pcmdDK.canCastPlagueLeech(3)'},
	{"Blood Tap", 'player.buff(Blood Charge).count >= 5'},
	{"Empower Rune Weapon",	{'modifier.cooldowns','target.spell(56815).range','player.runes(death).count < 1','player.runes(frost).count < 1','player.runes(unholy).count < 1','player.runicpower < 30'}},
})