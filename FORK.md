# KobeTools fork of Maccy

Upstream: https://github.com/p0deje/Maccy (branch `master`). Built from source with no auto-update. Re-check every row after each upstream sync.

## Fork changes

| Change | Where |
|---|---|
| Sparkle is never started; update toggle and "Check now" removed | Maccy/SoftwareUpdater.swift (`startingUpdater: false`), Maccy/Settings/GeneralSettingsPane.swift |
| Upstream update feed removed | Maccy/Info.plist (no `SUFeedURL`) |
| Source build: ad-hoc signed through xcodebuild so sandbox entitlements (and the history container) are kept; no hardened runtime so the vendor-signed Sparkle framework loads | scripts/build-install-local.sh |
| Build output ignored | .gitignore (`/.derivedData`) |

## Notes

- `secure-paste` branch: Secure Paste work in progress, not merged.

## Syncing

Sync to upstream **release tags**, not the tip of `master`. From mactools run `scripts/audit-upstream.sh maccy`, merge only after review, then check every row above.
