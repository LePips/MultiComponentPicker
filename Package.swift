// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MultiComponentPicker",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "MultiComponentPicker",
            targets: ["MultiComponentPicker"]),
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MultiComponentPicker",
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
            ]
        ),
    ]
)
