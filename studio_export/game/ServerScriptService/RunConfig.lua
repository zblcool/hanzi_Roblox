local RunConfig = {}

RunConfig.Phases = {
	Waiting = "Waiting",
	Loadout = "Loadout",
	Intermission = "Intermission",
	Wave = "Wave",
	Interlude = "Interlude",
	Reward = "Reward",
	Route = "Route",
	Defeat = "Defeat",
}

RunConfig.BaseWalkSpeed = 16
RunConfig.BaseMaxHealth = 100
RunConfig.BaseLoadout = {}
RunConfig.DefaultLoadoutId = "scribe"
RunConfig.WeaponOrder = { "ClassicSword", "Pistol", "AR" }

RunConfig.LoadoutChoices = {
	{
		id = "scribe",
		title = "Ink Scribe",
		description = "Ranged starter. Open with a pistol and safer spacing.",
		weapons = { "Pistol" },
		bonuses = {
			fireRateMultiplier = 0.95,
			ammoBonus = 2,
		},
	},
	{
		id = "xia",
		title = "Wandering Xia",
		description = "Melee starter. Open with a sword and pressure up close.",
		weapons = { "ClassicSword" },
		bonuses = {
			maxHealthBonus = 18,
			walkSpeedBonus = 1,
			damageMultiplier = 1.08,
		},
	},
}

RunConfig.Routes = {
	{
		id = "ember_blade",
		title = "Ember Edge",
		description = "Burst and close pressure. Future rewards lean damage and melee tempo.",
		glyph = "Lie",
		bonuses = {
			damageMultiplier = 1.12,
		},
	},
	{
		id = "ink_ward",
		title = "Ink Ward",
		description = "Sustain and hold ground. Future rewards lean health and recovery.",
		glyph = "Shou",
		bonuses = {
			maxHealthBonus = 20,
		},
	},
	{
		id = "storm_lattice",
		title = "Storm Lattice",
		description = "Volley and control. Future rewards lean attack speed, ammo, and ranged pressure.",
		glyph = "Lei",
		bonuses = {
			fireRateMultiplier = 0.9,
			ammoBonus = 2,
		},
	},
	{
		id = "wayfarer",
		title = "Wayfarer Script",
		description = "Mobility and repositioning. Future rewards lean speed and cleaner lane cuts.",
		glyph = "You",
		bonuses = {
			walkSpeedBonus = 2,
		},
	},
}

RunConfig.RouteMilestoneWaves = { 4, 8, 12 }
RunConfig.RouteChoiceDuration = 18
RunConfig.LoadoutSelectionDuration = 15
RunConfig.IntermissionDuration = 10
RunConfig.InterludeDuration = 20
RunConfig.DefeatRestartDelay = 4
RunConfig.InterludeEveryNWaves = 1
RunConfig.WaveBaseEnemyCount = 6
RunConfig.WaveEnemyGrowth = 3
RunConfig.WaveSpawnDelay = 0.4
RunConfig.PostWaveHealPercent = 0.25
RunConfig.EliteEveryNWaves = 5
RunConfig.EliteSpawnCount = 1
RunConfig.RewardChoicesPerSet = 3
RunConfig.PotionHealPercent = 0.3
RunConfig.PotionDropMeterStep = 0.24
RunConfig.PotionLifetimeSeconds = 18
RunConfig.MaxPotionDrops = 2

RunConfig.EventBlessings = {
	{
		id = "ember_pact",
		title = "Ember Pact",
		description = "Lose 14% max health. Gain 25% more damage and +1 walk speed.",
		healthCostPercent = 14,
		routeBiases = { "ember_blade" },
		bonuses = {
			damageMultiplier = 1.25,
			walkSpeedBonus = 1,
		},
	},
	{
		id = "warding_ink",
		title = "Warding Ink",
		description = "Lose 10% max health. Gain +30 max health and a sturdier run.",
		healthCostPercent = 10,
		routeBiases = { "ink_ward" },
		bonuses = {
			maxHealthBonus = 30,
		},
	},
	{
		id = "storm_contract",
		title = "Storm Contract",
		description = "Lose 12% max health. Gain 15% faster attacks and +4 ammo capacity.",
		healthCostPercent = 12,
		routeBiases = { "storm_lattice" },
		requiresAnyWeapon = { "Pistol", "AR" },
		bonuses = {
			fireRateMultiplier = 0.85,
			ammoBonus = 4,
		},
	},
	{
		id = "traveler_vow",
		title = "Traveler's Vow",
		description = "Lose 12% max health. Gain +3 walk speed and 10% faster attacks.",
		healthCostPercent = 12,
		routeBiases = { "wayfarer" },
		bonuses = {
			walkSpeedBonus = 3,
			fireRateMultiplier = 0.9,
		},
	},
}

RunConfig.RestOption = {
	title = "Short Rest",
	description = "Recover 35% max health and gain 5% faster attacks.",
	healPercent = 35,
	bonuses = {
		fireRateMultiplier = 0.95,
	},
	preferredRoutes = { "ink_ward", "wayfarer" },
}

RunConfig.Rewards = {
	{
		id = "vitality",
		title = "Vitality",
		description = "+25 max health and heal to full",
		routeBiases = { "ink_ward" },
	},
	{
		id = "quick_hands",
		title = "Quick Hands",
		description = "15% faster attack speed",
		routeBiases = { "storm_lattice", "wayfarer", "ember_blade" },
	},
	{
		id = "high_caliber",
		title = "High Caliber",
		description = "20% more weapon damage",
		routeBiases = { "ember_blade", "storm_lattice" },
	},
	{
		id = "fleet_footed",
		title = "Fleet Footed",
		description = "+2 walk speed",
		routeBiases = { "wayfarer" },
	},
	{
		id = "ammo_stockpile",
		title = "Ammo Stockpile",
		description = "+4 ammo capacity on firearms",
		routeBiases = { "storm_lattice" },
		requiresAnyWeapon = { "Pistol", "AR" },
	},
	{
		id = "unlock_ar",
		title = "Assault Rifle",
		description = "Unlock the AR for this run",
		routeBiases = { "storm_lattice", "ember_blade" },
		excludeIfOwnedWeapon = "AR",
	},
}

return RunConfig
