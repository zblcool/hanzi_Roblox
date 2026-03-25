# Roblox Migration Checklist

Source repo: [`/Users/ash/Documents/Github/hanziHero`](/Users/ash/Documents/Github/hanziHero)  
Target experience: active Roblox Studio project `Rogue Survivor`  
Focus: migrate the `字海残卷 / Hanzi Hero` line first, not the full two-game launcher

Status tags: `done`, `in progress`, `pending`, `blocked`  
Last reviewed: `2026-03-24`

## Front-End And Launcher
- [done] Brand the run choice modals with `字海残卷` identity.
  Notes: source front-end carries a strong `INK-BORN ROGUELITE` / `字海残卷` header; Roblox `RunClient` now adds that identity and phase badges to loadout and chamber-choice modals.
- [done] Keep a staged run-entry flow instead of immediate combat.
  Notes: source opens through front-screen selection; Roblox already opens with a hero-pick modal before wave 1.
- [done] Add a compact `About / Controls` drawer off the archive welcome card.
  Notes: source front surfaces an about view plus persistent control guidance; Roblox `RunClient` now exposes `WelcomeFrame.NotesButton` / `NotesPanel` with quick archive notes, active-skill / draft / pause / restart / ledger / mobile-target hints, a close button, and hint copy that advertises the `[H]` shortcut. Studio validation restarted play, confirmed live `Players.zbl_ash.PlayerGui.RewardGui.WelcomeFrame.NotesButton` and `NotesPanel`, inspected the mounted summary / controls text values, and saw no new `RunClient` errors on the clean restart. Direct click validation remained noisy because the normal run flow immediately hid the welcome card and Studio mouse-input calls timed out while that flow was reclaiming focus.
- [done] Add a compact `Character Codex / 人物志` drawer off the archive welcome card.
  Notes: source front screen exposes a `Character Codex` panel with hero lore before a run; Roblox `RunClient` now mounts `WelcomeFrame.LoreButton` plus `LorePanel` with compact bilingual Ink Scribe / Wandering Xia codex copy and a matching welcome hint path. Studio validation restarted play, confirmed live `Players.zbl_ash.PlayerGui.RewardGui.WelcomeFrame.LoreButton`, `LorePanel`, and `LorePanel.Body`, inspected the mounted codex text values, and saw no new `RunClient` errors on the clean restart. Direct hotkey / click validation remained noisy because Studio input automation did not reliably hand focus to the welcome card before the draft timer advanced.
- [done] Add a compact `Fusion Codex / 合字图谱` drawer off the archive welcome card.
  Notes: source front screen follows character lore with a `Fusion Codex` panel; Roblox `RunClient` now mounts `WelcomeFrame.CompendiumButton` plus `CompendiumPanel` with a short radical list, public fusion examples, word-upgrade examples, and the hidden-route note for `俊` / `强`, while the welcome hint and notes drawer now advertise the `[J]` shortcut. Studio validation restarted play, confirmed live `Players.zbl_ash.PlayerGui.RewardGui.WelcomeFrame.CompendiumButton` and `CompendiumPanel`, inspected the mounted `CompendiumPanel.Body` text values, and saw no new console output beyond the existing `ReplicatedStorage.WeaponsSystem is now active.` spam. Direct hotkey / click validation remained blocked because Studio client-focus automation would not hand input to the live play window reliably.
- [done] Add a Roblox-safe bilingual layer to the live HUD and hero draft.
  Notes: source surfaces bilingual copy throughout the launcher and battlefield; Roblox `RunClient` now pairs the hero draft plus the persistent `Run Identity` and `Chamber Notes` panels with English/Chinese labels. Studio validation started play, read the live `PlayerGui` text values, and captured the bilingual HUD in the intermission state.
- [in progress] Build a true front screen / launcher equivalent with `Start`, character lore, compendium, bestiary, and leaderboard panels.
  Notes: source implements these in `src/launcher.js` and `src/hanzi-hero/dom.js`; Roblox still drops directly into the run loop, but the archive welcome card now carries first front-shell drawers for `About / Controls`, `Fusion Codex / 合字图谱`, and `Character Codex / 人物志`.
- [pending] Extend bilingual copy and theme affordances beyond the live HUD into a launcher equivalent.
  Notes: the live run HUD and hero draft now carry a Roblox-safe bilingual layer, but the experience still lacks the source launcher's broader bilingual front screen, lore/compendium entry points, and theme switch affordances.

## Gameplay Loop
- [done] Run waves through a staged loop instead of a flat endless arena.
  Notes: Roblox `GameDirector` already drives `Loadout -> Intermission -> Wave -> Interlude -> Route` progression with timers and choices.
- [done] Let the player commit to a starting hero before the run.
  Notes: `RunConfig.LoadoutChoices` and the client modal already support two openers with different bonuses.
- [done] Feed interlude and route choices back into later rewards.
  Notes: Roblox already tracks route affinities, event blessings, rest options, and route-biased reward selection.
- [done] Add chamber-path framing to interlude, reward, and route modals.
  Notes: source uses explicit chamber travel language and overlay framing; Roblox `RunClient` now adds chamber-number header copy, an `Archive Path` travel strip, and route-trail context inside the live choice modal. Studio validation re-opened the experience, confirmed the client stayed error-free, and captured the framed modal layout in a simulated chamber-choice preview.
- [done] Add a local world-space `Archive Beacon` between the arena and archive approach.
  Notes: source `game.js` drives a dungeon beacon / travel cue between chambers; Roblox `RunClient` now spawns a pulsing neon `Archive Beacon` during `Intermission`, `Interlude`, `Route`, and `Reward`, anchored along the `GameBricks -> LobbyBricks` corridor and mirroring chamber / route copy from the modal travel strip.
- [done] Validate the live beacon against the current Studio play camera.
  Notes: this run started play, locked `Ink Scribe`, forced a long `Intermission` to hold the chamber-staging corridor, and confirmed a live `Workspace.ArchiveBeacon` at `Transparency ~0.14` alongside the new threshold shimmer pass. The earlier no-character / no-`RunState` validation blocker did not recur on the standard client path.
- [pending] Add a fuller room-to-room movement or gate interaction once runtime validation is reliable.
  Notes: source still goes beyond a beacon into a stronger transition handoff; Roblox now has the first in-world cue but not a full chamber traversal beat.
- [in progress] Add immediate defeat restart parity through the server defeat phase.
  Notes: source README calls out instant restart with the current hero; Roblox `RunClient` now renders a branded `Defeat` overlay tied to `RunState.Phase`, with preserved-hero restart copy and an `[R]` action wired to the existing `RestartRun` remote. Studio validation forced `Phase = Defeat` while the player was alive, confirmed `Players.zbl_ash.PlayerGui.RewardGui.DefeatFrame`, and captured the live overlay. Full end-to-end validation remains blocked because a real death currently drops the session into a no-character, no-`PlayerGui` state before the overlay can stay mounted.

## Combat And Enemies
- [done] Support multiple weapons and scaling enemy waves.
  Notes: Roblox already uses sword, pistol, and AR templates plus `BasicEnemy` and `EliteEnemy` wave spawning.
- [done] Show the hero's health in-world, not only in the HUD corner.
  Notes: source emphasizes an in-world health bar; Roblox already has an overhead HP billboard, verified in play.
- [done] Add healing pickup / potion gameplay.
  Notes: source README mentions red `丹` healing potions; `GameDirector` now spawns red `丹` pickups into `Workspace.Round.RunDrops` on enemy deaths and each pickup restores `30%` max health. Studio play validation forced a wave clear, observed two live potion drops, then confirmed a pickup moved player health from `40` to `93`.
- [done] Add elite arrival taunt bubbles for key spawn telegraphs.
  Notes: source `game.js` announces elite and other key arrivals with short taunt bubbles; Roblox `GameDirector` now attaches a short bilingual `ArrivalCallout` billboard to spawned `EliteEnemy` models. Studio validation temporarily forced one elite onto wave 1, detected `Workspace.EliteEnemy.ArrivalCallout` during live play, then restored the original `RunConfig` values and confirmed a clean normal-config boot with an empty console.
- [in progress] Improve enemy telegraph readability and combat FX style.
  Notes: source leans on fog-of-war and calligraphic combat feedback; Roblox now mirrors elite arrival taunt bubbles, but attack telegraphs, impact FX, and broader calligraphic combat feedback are still relatively plain.

## Progression And Content
- [done] Carry route-based stat growth and unlocks across a run.
  Notes: Roblox already applies loadout bonuses, route bonuses, stat multipliers, rest/event choices, and weapon unlock rewards.
- [pending] Add radical, fusion, word-skill, and relic systems.
  Notes: source data and leaderboard UI track radicals, fused characters, word skills, and relics; Roblox progression is still generic stats plus weapons.
- [in progress] Surface character lore, bestiary, and compendium content.
  Notes: source exposes these as implemented panels before a run; Roblox now has compact `Character Codex / 人物志` and `Fusion Codex / 合字图谱` drawers on the archive welcome card, but a bestiary view and fuller compendium depth are still missing.
- [pending] Add leaderboard and run-history identity.
  Notes: source stores player-name identity and leaderboard views; inspected Roblox systems did not expose a leaderboard path.

## HUD And UX
- [done] Show core run-state HUD for phase, wave progress, health, and XP.
  Notes: verified top run header, bottom progress strip, corner health bar, and overhead HP bar in Studio play.
- [done] Bring source identity into the active choice overlays.
  Notes: this run migrated branded modal framing so loadout/reward surfaces feel closer to `字海残卷`.
- [done] Add a compact build-state HUD panel for current hero, route lean, and owned weapons.
  Notes: `RunClient` now renders a persistent `Run Identity` panel backed by synced player attributes, and Studio play confirmed it updates from `Ink Scribe | Route uncommitted` to `Ink Scribe | Storm Lattice` after an interlude choice.
- [done] Expand build-state HUD with route history and latest boon tracking.
  Notes: source HUD and build snapshots emphasize readable run context; Roblox `RunClient` now shows route rank, route trail, and the latest blessing / event / rest title in the persistent `Run Identity` panel. Studio play validated `Trail  | Storm Lattice x2 | Ink Ward` and `Boon   | Event · Warding Ink` during wave 1.
- [pending] Keep expanding build-state HUD beyond the current identity slice.
  Notes: source HUD and pause-build surfaces still track richer build detail than Roblox, especially relic / radical / fusion-equivalent context and broader run-state surfacing.
- [pending] Add richer overlay treatment for interludes and future upgrade drafts.
  Notes: source uses layered overlays, logs, and build trays; Roblox choices are functional but still simple text buttons.

## Audio, FX, And Polish
- [pending] Add music, hit SFX, and ambient audio.
  Notes: source ships with an audio runtime; no custom Roblox sound assets were found under `SoundService`.
- [done] Add a first archive-themed battlefield lighting grade and fog pass.
  Notes: source rendering explicitly uses fogged battlefield mood; Roblox `Lighting` now adds an `ArchiveGrade` color-correction effect, cooler `Atmosphere` decay, softer bloom, and reduced sun shafts for a darker ink-toned battlefield. Studio validation started play, confirmed the updated grade on the hero-draft scene, and returned an empty console.
- [done] Add a first ambient rune-stamp pass around the active chamber.
  Notes: source `README.en.md` calls out revealable stamp layers and giant realm glyph shifts; Roblox `Workspace.Round.AtmosphereRunes` now adds five persistent non-colliding neon floor sigils (`宇`, `天`, `地`, `玄`, `黄`) with bilingual captions around the combat bowl. Studio validation inspected the authored folder plus `CoreRune.GlyphSurface` text values in edit mode, started play, navigated the character to the chamber center, and captured the live floor stamp in-camera with no new console errors.
- [done] Add a first wall-glyph plaque pass around the chamber perimeter.
  Notes: source battlefield identity extends into boundary walls and engraved realm markers; Roblox `RunClient` now spawns four local `AmbientWallGlyphs` plaques around `GameBricks`, each with a bilingual title plus chamber, route, or phase copy, and the east / west plaques swap to the live route or phase glyph. Studio validation started play, locked in `Ink Scribe`, confirmed `Workspace.Round.AmbientWallGlyphs` with four plaques, inspected the live `SurfaceGui` text on the north/east/south/west panels, captured the plaques in the intermission scene, and saw no new console errors beyond the existing `ReplicatedStorage.WeaponsSystem is now active.` spam.
- [done] Add a first chamber-bound fog curtain pass around the active chamber.
  Notes: source `README` describes reveal-linked fog curtains on segmented chamber boundaries; Roblox `RunClient` now spawns four client-side `AmbientFogCurtains` veils sized from `Workspace.Round.GameBricks`, tinted by the live phase accent, and faded back as the player nears an edge. Studio validation restarted play cleanly, confirmed `Workspace.Round.AmbientFogCurtains` with four parts, inspected live curtain spans plus far/near transparency states (`~0.53` while distant, `1` when the player root was near the east edge), and saw no new console output beyond the existing `ReplicatedStorage.WeaponsSystem is now active.` spam.
- [done] Add a first archive-corridor gate shimmer pass.
  Notes: source chamber exits and seal / loot transitions carry a stronger threshold treatment; Roblox `RunClient` now spawns three client-side `ArchiveGateShimmer` ribbons aligned to the real `GameBricks -> LobbyBricks` corridor, tinted by the live phase accent, and faded back near the player so the threshold reads without blocking sightlines. Studio validation started play, locked `Ink Scribe`, forced a long `Intermission` to hold the corridor beat, confirmed `Workspace.Round.ArchiveGateShimmer` with three parts, inspected `GateShimmer_mid` at `Transparency ~0.44`, and saw no new console output beyond the existing `ReplicatedStorage.WeaponsSystem is now active.` spam.
- [done] Add a lightweight seal / loot-specific threshold variant.
  Notes: source chamber exits branch between `封 / SEAL` and `奖 / LOOT` beats; Roblox `RunClient` now retitles the archive beacon by phase (`Door Ward`, `Archive Threshold`, `Seal Ward`, `Loot Beacon`) and subtly shifts the corridor shimmer width, height, opacity, and tint between staging, threshold, route-seal, and loot states without adding new server flow. Studio validation reran play cleanly with no further `Out of local registers` compile errors, captured the threshold branch in play, and script-inspected the phase-specific beacon / shimmer logic; direct route-versus-reward capture remained noisy because the live run loop kept yanking the session back into combat / defeat during forced phase pinning.
- [pending] Keep expanding battlefield atmosphere beyond the first lighting pass.
  Notes: Roblox now has the first lighting grade, the floor-rune pass, a first wall-plaque layer, a first chamber-bound fog-curtain layer, a first archive-gate shimmer layer, and a lightweight seal / loot threshold fork, but source still layers denser fog-of-war reveals, stronger gatekeeper / loot payoffs, and broader calligraphic scene FX that the live experience does not mirror yet.
- [pending] Add more front-end reveal polish.
  Notes: source launcher/front screen use stronger motion and presentation than the Roblox entry flow.

## Mobile And Platform
- [pending] Add mobile controls and orientation handling.
  Notes: source includes mobile controls and a rotate-back prompt; equivalent Roblox mobile UI was not found in the inspected tree.
- [pending] Decide whether to expose Roblox-safe debug/test entry equivalents.
  Notes: source exposes preview starts plus `FPS`, `Probe`, and `Inspector`; Roblox currently keeps the player-facing surface much slimmer.

## Technical Debt
- [in progress] Keep untangling legacy assets from the active run systems.
  Notes: `ServerStorage.ProjectCleanup` still contains many archived scripts, tools, models, and remotes alongside the active migration path.
- [blocked] Fix the current no-character / no-`PlayerGui` death state before relying on live defeat validation.
  Notes: in Studio play, a real player death still strips both `Character` and `PlayerGui`, leaving only the legacy `Time Left:` surface visible and preventing end-to-end confirmation of the new defeat restart overlay.
- [pending] Keep future HUD work centered on `RunClient`, not restored legacy GUI scripts.
  Notes: archived health/level GUI scripts still exist in cleanup storage; avoid reviving them accidentally.
- [pending] Manual publish remains outside this automation.
  Notes: local Studio implementation is possible here, but no supported publish step is available in this run.

## Recommended Next Item
- [pending] Add a compact monster-bestiary drawer off the archive welcome card.
  Notes: source front screen pairs the character and fusion panels with `Monster Bestiary`; Roblox now has a reusable welcome-card drawer pattern for notes, lore, and compendium copy, so the next low-risk step is a short enemy-family / threat reference panel before attempting a fuller launcher shell.
