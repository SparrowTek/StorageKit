// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "StorageKit",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "StorageKit",
            targets: ["StorageKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "StorageKit",
            dependencies: []),
    ]
)
