#!/bin/bash
set -euo pipefail

NAME="MyGrpcWrapper"
SCHEME="MyGrpcWrapper"

# Swift 編譯旗標（避免 Swift 6 錯誤）
SWIFT_FLAGS="-Xfrontend -disable-availability-checking"

# 清除舊的建構結果
rm -rf build
mkdir -p build

echo "📦 Building iOS Device archive..."
xcodebuild archive \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS" \
  -archivePath "build/ios_devices.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SWIFT_VERSION=5 \
  OTHER_SWIFT_FLAGS="$SWIFT_FLAGS"

echo "📱 Building iOS Simulator archive..."
xcodebuild archive \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "build/ios_simulator.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SWIFT_VERSION=5 \
  OTHER_SWIFT_FLAGS="$SWIFT_FLAGS"

echo "🖥  Building macOS archive..."
xcodebuild archive \
  -scheme "$SCHEME" \
  -destination "generic/platform=macOS" \
  -archivePath "build/macos.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SWIFT_VERSION=5 \
  OTHER_SWIFT_FLAGS="$SWIFT_FLAGS"

echo "🧩 Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "build/ios_devices.xcarchive/Products/Library/Frameworks/${NAME}.framework" \
  -framework "build/ios_simulator.xcarchive/Products/Library/Frameworks/${NAME}.framework" \
  -framework "build/macos.xcarchive/Products/Library/Frameworks/${NAME}.framework" \
  -output "${NAME}.xcframework"

echo "📦 Zipping XCFramework..."
zip -r "${NAME}.xcframework.zip" "${NAME}.xcframework"

echo "✅ Build complete: ${NAME}.xcframework.zip"
