// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "MyGrpcWrapper",
    platforms: [
        .iOS(.v13),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "MyGrpcWrapper",
            type: .static,
            targets: ["MyGrpcWrapper"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift.git", exact: "1.21.0"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-nio.git", exact: "2.58.0")
    ],
    targets: [
        .target(
            name: "MyGrpcWrapper",
            dependencies: [
                .product(name: "GRPC", package: "grpc-swift"),
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),
                .product(name: "NIO", package: "swift-nio")
            ],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-disable-availability-checking"])
            ]
        )
    ]
)
