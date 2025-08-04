#!/bin/bash
set -euo pipefail

NAME="MyGrpcWrapper"
SCHEME="MyGrpcWrapper"

# Clean build
rm -rf build
mkdir -p build

# Archive iOS Device
xcodebuild archive \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS" \
  -archivePath "build/ios_devices.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Archive iOS Simulator
xcodebuild archive \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "build/ios_simulator.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Archive macOS
xcodebuild archive \
  -scheme "$SCHEME" \
  -destination "generic/platform=macOS" \
  -archivePath "build/macos.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Create XCFramework
xcodebuild -create-xcframework \
  -framework "build/ios_devices.xcarchive/Products/Library/Frameworks/${NAME}.framework" \
  -framework "build/ios_simulator.xcarchive/Products/Library/Frameworks/${NAME}.framework" \
  -framework "build/macos.xcarchive/Products/Library/Frameworks/${NAME}.framework" \
  -output "${NAME}.xcframework"

# Zip it
zip -r "${NAME}.xcframework.zip" "${NAME}.xcframework"

