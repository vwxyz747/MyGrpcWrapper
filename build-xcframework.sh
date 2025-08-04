#!/bin/bash
set -euo pipefail

NAME="MyGrpcWrapper"
SCHEME="MyGrpcWrapper"

# 通用 Swift Flags（關閉 Swift 6 嚴格特性）
SWIFT_FLAGS="-Xfrontend -disable-availability-checking"

# 清理舊資料
rm -rf build
mkdir -p build

echo "📦 Building iOS Device archive..."
xcodebuild archive \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS" \
  -archivePath "build/ios_devices.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  OTHER_SWIFT_FLAGS="$SWIFT_FLAGS"

echo "📱 Building iOS Simulator archive..."
xcodebuild archive \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "build/ios_simulator.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  OTHER_SWIFT_FLAGS="$SWIFT_FLAGS"

echo "🖥  Building macOS archive..."
xcodebuild archive \
  -scheme "$SCHEME" \
  -destination "generic/platform=macOS" \
  -archivePath "build/macos.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
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
