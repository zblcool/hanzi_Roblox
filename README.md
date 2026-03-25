[English](D:/Coding/hanzi_Roblox/README.md) | [简体中文](D:/Coding/hanzi_Roblox/README.zh-CN.md)

# Rogue Survivor Config Audit

This repository does not yet contain an exported Roblox source tree. The current source of truth still lives inside the active Roblox Studio place `Rogue Survivor`.

This document captures the current live configuration layout as inspected in Studio on `2026-03-25` through MCP.

## Repository State

- Filesystem repo status:
  - `ROBLOX_MIGRATION_CHECKLIST.md` is the current migration log.
  - Active Roblox scripts and assets are still stored in Studio, not as checked-in `.lua` files.
- Practical consequence:
  - Most gameplay tuning currently has to be changed in Roblox Studio.
  - This README should be treated as an audit snapshot, not a generated source export.

## Active System Map

These are the active Studio paths that currently control the run:

| Studio path | Role |
| --- | --- |
| `ServerScriptService.RunConfig` | Main run tuning: phases, timers, loadouts, routes, rewards, potion settings |
| `ServerScriptService.GameDirector` | Owns the run loop, creates runtime state/remotes, applies player bonuses, spawns enemies and rewards |
| `Workspace.Round.EnemyVariantDirector` | Enemy archetypes, runtime enemy promotion, wave scaling, AI behavior, enemy visual styling |
| `StarterPlayer.StarterPlayerScripts.RunClient` | HUD, draft modals, route/interlude UI, bilingual presentation, visual phase theming |
| `ServerStorage.RunAssets` | Active weapon and enemy templates |
| `ServerStorage.ProjectCleanup` | Archived legacy systems that are not meant to drive the live run |

## Current Phase Flow

The active server loop in `GameDirector` is:

`Waiting -> Loadout -> Intermission -> Wave -> Interlude -> Route`

Additional phase enums also exist:

- `Reward`
- `Defeat`

Important note:

- `Reward` is still defined in `RunConfig` and still supported by parts of `RunClient`.
- `GameDirector` still contains a `runRewardPhase` helper.
- The main loop does **not** call `runRewardPhase`, so `Reward` currently reads like leftover or parked flow rather than the active progression path.

## Runtime Objects Created By The Server

These objects are created by `GameDirector` at runtime, so they may not exist in edit mode before the server bootstraps:

### `ReplicatedStorage.RunState`

- `Phase` (`StringValue`)
- `Wave` (`IntValue`)
- `TimeLeft` (`IntValue`)
- `EnemiesAlive` (`IntValue`)
- `EnemiesTotal` (`IntValue`)

### `ReplicatedStorage.RunRemotes`

- `ShowRewardChoices`
- `ChooseReward`
- `ShowLoadoutSelection`
- `ChooseLoadout`
- `RestartRun`

### `Workspace.Round`

- `RunDrops` folder is created to hold health potion drops

## Core RunConfig Values

### Base Player Defaults

| Setting | Value |
| --- | --- |
| `BaseWalkSpeed` | `16` |
| `BaseMaxHealth` | `100` |
| `BaseLoadout` | empty |
| `DefaultLoadoutId` | `scribe` |
| `WeaponOrder` | `ClassicSword`, `Pistol`, `AR` |

### Loadout Choices

| Id | Title | Starting weapons | Bonuses |
| --- | --- | --- | --- |
| `scribe` | `Ink Scribe` | `Pistol` | `fireRateMultiplier = 0.95`, `ammoBonus = 2` |
| `xia` | `Wandering Xia` | `ClassicSword` | `maxHealthBonus = 18`, `walkSpeedBonus = 1`, `damageMultiplier = 1.08` |

### Route Choices

| Id | Title | Theme | Bonuses |
| --- | --- | --- | --- |
| `ember_blade` | `Ember Edge` | burst / melee pressure | `damageMultiplier = 1.12` |
| `ink_ward` | `Ink Ward` | sustain / health | `maxHealthBonus = 20` |
| `storm_lattice` | `Storm Lattice` | ranged pressure / speed / ammo | `fireRateMultiplier = 0.9`, `ammoBonus = 2` |
| `wayfarer` | `Wayfarer Script` | mobility / repositioning | `walkSpeedBonus = 2` |

### Timing And Wave Tuning

| Setting | Value |
| --- | --- |
| `RouteMilestoneWaves` | `4, 8, 12` |
| `RouteChoiceDuration` | `18` seconds |
| `LoadoutSelectionDuration` | `15` seconds |
| `IntermissionDuration` | `10` seconds |
| `InterludeDuration` | `20` seconds |
| `DefeatRestartDelay` | `4` seconds |
| `InterludeEveryNWaves` | `1` |
| `WaveBaseEnemyCount` | `6` |
| `WaveEnemyGrowth` | `3` per wave |
| `WaveSpawnDelay` | `0.4` seconds |
| `PostWaveHealPercent` | `0.25` |
| `EliteEveryNWaves` | `5` |
| `EliteSpawnCount` | `1` |
| `RewardChoicesPerSet` | `3` |
| `PotionHealPercent` | `0.3` |
| `PotionDropMeterStep` | `0.24` |
| `PotionLifetimeSeconds` | `18` |
| `MaxPotionDrops` | `2` |

## Interlude Content

### Event Blessings

| Id | Cost | Gating | Bonuses |
| --- | --- | --- | --- |
| `ember_pact` | lose `14%` max health | favors `ember_blade` | `damageMultiplier = 1.25`, `walkSpeedBonus = 1` |
| `warding_ink` | lose `10%` max health | favors `ink_ward` | `maxHealthBonus = 30` |
| `storm_contract` | lose `12%` max health | favors `storm_lattice`, requires `Pistol` or `AR` | `fireRateMultiplier = 0.85`, `ammoBonus = 4` |
| `traveler_vow` | lose `12%` max health | favors `wayfarer` | `walkSpeedBonus = 3`, `fireRateMultiplier = 0.9` |

### Rest Option

| Title | Effect | Route preference |
| --- | --- | --- |
| `Short Rest` | heal `35%` max health, `fireRateMultiplier = 0.95` | `ink_ward`, `wayfarer` |

### Reward Pool

| Id | Effect | Notes |
| --- | --- | --- |
| `vitality` | `+25` max health and full heal | biased to `ink_ward` |
| `quick_hands` | `15%` faster attack speed | biased to `storm_lattice`, `wayfarer`, `ember_blade` |
| `high_caliber` | `20%` more weapon damage | biased to `ember_blade`, `storm_lattice` |
| `fleet_footed` | `+2` walk speed | biased to `wayfarer` |
| `ammo_stockpile` | `+4` firearm ammo capacity | requires `Pistol` or `AR` |
| `unlock_ar` | unlock `AR` for the current run | hidden if already owned |

## Weapon Template Audit

Active weapon templates live under `ServerStorage.RunAssets.WeaponTemplates`.

### Firearms

| Weapon | Damage | Cooldown | Ammo | Notes |
| --- | --- | --- | --- | --- |
| `Pistol` | `20` | `0.2` | `10` | `GravityFactor = 0.5`, `MaxSpread = 2`, pistol casing FX |
| `AR` | `14` | `0.125` | `30` | `FireMode = Automatic`, `GravityFactor = 0.5`, `MaxSpread = 0.6`, rifle casing FX |

Additional firearm config comes from `Configuration` value objects such as recoil, muzzle flash size, spread, and projectile effect.

### Melee

`ClassicSword` does not use a `Configuration` folder like the firearms. Instead, `GameDirector` injects runtime values into the cloned tool:

- `DamageMultiplier`
- `AttackCooldown`
- `ComboWindow`

Current sword runtime defaults are driven from code:

- `AttackCooldown = max(0.15, 0.45 * fireRateMultiplier)`
- `ComboWindow = 0.2`

## Enemy System Audit

Active enemy templates live under `ServerStorage.RunAssets.EnemyTemplates`:

- `BasicEnemy`
- `EliteEnemy`

Important implementation detail:

- The templates themselves are not the final enemy balance source.
- `EnemyVariantDirector` overrides live enemy health, movement, AI, visuals, and variant identity after the model spawns.
- That means enemy balance is currently split between template assets and one large runtime director script.

### Map Spawn Layout

`Workspace.Round.GameBricks` currently contains `4` spawn marker parts.

### Runtime Enemy Archetypes

`EnemyVariantDirector` currently defines four live archetypes:

| Archetype | WalkSpeed | MaxHealth | Core attack pattern |
| --- | --- | --- | --- |
| `raider` | `9` | `95` | melee |
| `mage` | `7` | `72` | ranged caster plus weak melee |
| `lancer` | `10` | `118` | melee plus charge |
| `elite` | `11` | `260` | charge plus ranged projectile |

### Detailed Enemy Parameters

| Archetype | Key values |
| --- | --- |
| `raider` | melee damage `10`, melee range `4.5`, melee cooldown `1.1` |
| `mage` | melee damage `6`, melee range `3`, melee cooldown `1.4`, desired range `28`, retreat range `16`, cast range `64`, cast cooldown `2.6`, projectile damage `14`, projectile speed `72`, projectile size `0.9` |
| `lancer` | melee damage `12`, charge damage `22`, melee range `5`, melee cooldown `0.95`, charge range `12-68`, charge cooldown `4.4`, charge speed `52`, charge duration `0.7` |
| `elite` | melee damage `18`, charge damage `30`, melee range `5.5`, melee cooldown `0.85`, charge range `10-72`, charge cooldown `3.5`, charge speed `60`, charge duration `0.9`, cast range `72`, cast cooldown `4.2`, projectile damage `20`, projectile speed `80`, projectile size `1.2` |

### Wave Scaling Applied By EnemyVariantDirector

- Health scale per wave: `1 + (wave - 1) * 0.16`
- Damage scale per wave: `1 + (wave - 1) * 0.08`

### Variant Promotion Rules

Even if `GameDirector` only spawns `BasicEnemy` and scheduled `EliteEnemy` templates, `EnemyVariantDirector` can still promote spawned enemies into stronger archetypes:

- `mage` becomes available at wave `2` or after `4` total spawns
- `lancer` becomes available at wave `3` or after `6` total spawns
- `elite` can appear early at wave `4` or after `14` total spawns

This means:

- The final enemy mix is **not** controlled by `RunConfig` alone.
- Balance changes to waves may need edits in both `RunConfig` and `EnemyVariantDirector`.

## Scene And Environment Structure

`Workspace.Round` currently contains:

- `EnemyVariantDirector`
- `GameBricks`
- `LobbyBricks`
- `AtmosphereRunes`
- `WallGlyphPlaques`
- `GatehouseArchiveBanners`

Interpretation:

- `GameBricks` is the combat bowl / spawn area.
- `LobbyBricks` is the corridor or transition side used by the archive presentation systems.
- The other folders support the current atmosphere layer and client visual dressing.

## Player State Model

`GameDirector` maintains per-player state with:

- selected loadout
- owned weapons
- permanent unlocks
- route affinities
- route history
- latest boon kind/title
- modifier bundle:
  - `maxHealthBonus`
  - `walkSpeedBonus`
  - `damageMultiplier`
  - `fireRateMultiplier`
  - `ammoBonus`

These are mirrored back onto player attributes such as:

- `SelectedLoadoutId`
- `SelectedLoadoutTitle`
- `OwnedWeapons`
- `OwnedWeaponsDisplay`
- `PrimaryRouteId`
- `PrimaryRouteTitle`
- `RouteHistory`
- `LatestBoonKind`
- `LatestBoonTitle`

`RunClient` reads those attributes to drive the HUD and chamber identity panels.

## Deep Analysis Notes

### 1. The game is already playable, but config is fragmented

There is a clear active gameplay loop, but live balance is spread across several places:

- `RunConfig` for run pacing and reward logic
- `GameDirector` for runtime object creation and tool mutation
- `EnemyVariantDirector` for enemy balance and AI
- weapon `Configuration` value objects for firearm tuning
- `RunClient` for presentation text and phase-specific UX

This is workable for iteration, but hard to audit quickly.

### 2. `Reward` looks like a partially retired phase

Evidence:

- `RunConfig.Phases.Reward` still exists
- `RunClient` still contains `Reward` presentation branches
- `GameDirector` still contains `runRewardPhase`
- `RewardDuration` is referenced by `GameDirector`
- `RewardDuration` is **not** defined in `RunConfig`
- the main loop does not call `runRewardPhase`

Recommended interpretation:

- Treat `Interlude` as the active reward/event/rest pick phase
- Treat `Reward` as parked or dead flow until it is either restored or removed

### 3. Enemy tuning is less centralized than player tuning

Player tuning is relatively centralized in `RunConfig`.

Enemy tuning is not:

- base wave counts live in `RunConfig`
- archetype stats live in `EnemyVariantDirector`
- enemy template rigs live in `ServerStorage.RunAssets.EnemyTemplates`
- explicit elite spawn count lives in `RunConfig`
- hidden early elite promotion also lives in `EnemyVariantDirector`

If balance work starts soon, enemy config is the first area worth extracting into a dedicated module.

### 4. The repo is still missing source control for the actual game code

This is the main project-level limitation today.

Until the active Studio scripts are exported into the repo:

- code review is harder
- diffs are harder
- balancing changes are harder to track
- README accuracy has to be maintained manually

## Known Risks And Follow-Up Targets

- `RunConfig.RewardDuration` is missing even though `GameDirector` references it.
- `Reward` phase appears dead or unfinished.
- `ServerStorage.ProjectCleanup` still contains a large legacy archive and increases the chance of reviving the wrong assets.
- Client presentation config is heavily embedded in `RunClient`.
- Enemy balance is embedded in `Workspace.Round.EnemyVariantDirector`, which is a surprising location for gameplay-critical server tuning.

## Recommended Next Refactor Steps

1. Export the active Studio scripts into this repo so the filesystem becomes the real source of truth.
2. Split enemy numbers out of `EnemyVariantDirector` into a dedicated config module.
3. Decide whether `Reward` is coming back; if not, remove the dead phase and missing `RewardDuration` reference.
4. Keep `ProjectCleanup` archived, but document exactly which live systems still depend on copied legacy assets.
5. Move the most common weapon and route balance values into fewer, more obvious config surfaces.
