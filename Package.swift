// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Atributika",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v12),
        .tvOS(.v9),
        .watchOS(.v2),
    ],
    products: [
        .library(name: "Atributika", targets: ["Atributika"]),
        .library(name: "AtributikaViews", targets: ["AtributikaViews"]),
    ],
    dependencies: [.package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.6.2"))],
    targets: [
        .target(name: "Atributika",
                dependencies: ["Kingfisher"],
                path: "Sources/Core"),
        .target(name: "AtributikaViews", path: "Sources/Views"),
        .testTarget(name: "AtributikaTests", dependencies: ["Atributika"]),
    ],
    swiftLanguageVersions: [.v5]
)
