// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Atributika",
                      platforms: [.macOS(.v10_14),
                                  .iOS(.v12),
                                  .tvOS(.v9),
                                  .watchOS(.v2)],
                      products: [.library(name: "Atributika",
                                          targets: ["Atributika"])],
                      dependencies: [.package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "8.0.1"))],
                      targets: [.target(name: "Atributika",
                                        dependencies: ["Kingfisher"],
                                        path: "Sources"),
                                .testTarget(
                                    name: "AtributikaTests",
                                    dependencies: ["Atributika"]),],
                      swiftLanguageVersions: [.v5])
