# Studio Export Snapshot

This folder stores local snapshots of the active Roblox Studio project so progress can be versioned in Git even when the source of truth still lives in Studio.

## Intent

- Preserve active gameplay code and config in the repo
- Keep a human-readable audit trail of Studio-side progress
- Make it possible to diff gameplay changes over time

## Important Limits

- This is not a full `.rbxl` or `.rbxlx` place export.
- Binary assets, mesh data, UI layout instances, and most non-script objects are not automatically mirrored here unless we write dedicated manifests for them.
- The true live source still lives in Roblox Studio until we finish a proper source export workflow.

## Sync Rule

After Studio-side work, update this folder with:

- changed active script sources
- config manifests if tuning values changed
- any new notes needed to explain coverage or gaps

## Current Coverage

- Exported:
  - `ServerScriptService.RunConfig`
  - weapon template config manifest
  - enemy archetype config manifest
- Tracked in manifest, not yet fully mirrored as source files:
  - `ServerScriptService.GameDirector`
  - `Workspace.Round.EnemyVariantDirector`
  - `StarterPlayer.StarterPlayerScripts.RunClient`

See `studio_export/manifest.json` for the current export coverage snapshot.
