#!/usr/bin/env bash
# Generates the Android Gradle scaffold with the Flutter SDK installed on the
# build machine (so Gradle/AGP/Kotlin versions always match that SDK), then
# applies the small customisations this app needs.
# Safe to run repeatedly: it only generates android/ when it is missing.
set -euo pipefail

PROJECT_NAME="tickoff_replacement"
ORG="dev.tickoffreplacement"
APP_LABEL="TickOff"

if [ ! -d "android/app" ]; then
  echo "Generating Android scaffold with the installed Flutter SDK..."
  SCAFFOLD_DIR="$(mktemp -d)"
  flutter create --platforms=android \
    --project-name "$PROJECT_NAME" \
    --org "$ORG" \
    "$SCAFFOLD_DIR/$PROJECT_NAME"
  cp -R "$SCAFFOLD_DIR/$PROJECT_NAME/android" ./android
  rm -f android/local.properties
else
  echo "android/ already exists - leaving it untouched."
fi

MANIFEST="android/app/src/main/AndroidManifest.xml"
if [ -f "$MANIFEST" ]; then
  sed -i "s/android:label=\"[^\"]*\"/android:label=\"$APP_LABEL\"/" "$MANIFEST"
  echo "App label set to $APP_LABEL"
else
  echo "ERROR: $MANIFEST not found" >&2
  exit 1
fi
