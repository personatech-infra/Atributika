// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Atributika",
                      platforms: [.macOS(.v10_10),
                                  .iOS(.v12),
                                  .tvOS(.v9),
                                  .watchOS(.v2)],
                      products: [.library(name: "Atributika",
                                          targets: ["Atributika"])],
                      dependencies: [.package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.6.2"))],
                      targets: [.target(name: "Atributika",
                                        path: "Sources"),
                                .testTarget(
                                    name: "AtributikaTests",
                                    dependencies: ["Atributika"]),],
                      swiftLanguageVersions: [.v5])
