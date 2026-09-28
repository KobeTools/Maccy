#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT="Maccy"
SCHEME="Maccy"
CONFIGURATION="${CONFIGURATION:-Release}"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-$REPO_ROOT/.derivedData}"
INSTALL_DIR="${INSTALL_DIR:-/Applications}"
APP_PATH="$DERIVED_DATA_PATH/Build/Products/$CONFIGURATION/$PROJECT.app"
DEST_PATH="$INSTALL_DIR/$PROJECT.app"

# No hardened runtime: its library validation refuses to load frameworks that
# aren't signed by the app's Team ID, and ad-hoc builds have none (Sparkle comes
# prebuilt and vendor-signed). It's only required for notarized distribution;
# the sandbox entitlements still apply.
# Ad-hoc sign through xcodebuild (not CODE_SIGNING_ALLOWED=NO) so the sandbox
# entitlements are kept and the app reuses its existing history container.
echo "Building $PROJECT ($CONFIGURATION) with ad-hoc signing..."

xcodebuild \
  -project "$REPO_ROOT/$PROJECT.xcodeproj" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -destination "platform=macOS" \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  -disableAutomaticPackageResolution \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGN_STYLE=Manual \
  DEVELOPMENT_TEAM="" \
  PROVISIONING_PROFILE_SPECIFIER="" \
  ENABLE_HARDENED_RUNTIME=NO \
  build

if [[ ! -d "$APP_PATH" ]]; then
  echo "Build succeeded but app was not found at:"
  echo "  $APP_PATH"
  exit 1
fi

if pgrep -x "$PROJECT" >/dev/null 2>&1; then
  echo "Stopping running $PROJECT instance..."
  pkill -x "$PROJECT" || true
fi

echo "Installing to $DEST_PATH..."
rm -rf "$DEST_PATH"
ditto "$APP_PATH" "$DEST_PATH"

echo "Opening installed app..."
open "$DEST_PATH"

echo
echo "Installed $PROJECT to:"
echo "  $DEST_PATH"
echo "Re-grant Accessibility for Maccy if paste stops working (new signature)."
