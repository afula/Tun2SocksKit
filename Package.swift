// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Tun2SocksKit",
  platforms: [.iOS(.v14), .macOS(.v10_14)],
  products: [
    .library(
        name: "Tun2SocksKit",
        targets: ["Tun2SocksKit"]
    ),
    .library(
        name: "Tun2SocksKitC",
        targets: ["Tun2SocksKitC"]
    )
  ],
  targets: [
    .target(
        name: "Tun2SocksKit",
        dependencies: ["HevSocks5Tunnel", "Tun2SocksKitC"]
    ),
    .target(
        name: "Tun2SocksKitC",
        publicHeadersPath: "."
    ),
    .binaryTarget(
        name: "HevSocks5Tunnel",
        url: "https://github.com/afula/Tun2SocksKit/releases/download/v2.7.9/HevSocks5Tunnel.xcframework.zip",
        checksum: "4ccf1e5067b151c3ef7846881e41b2b97aa78c4f83dc10b7eeeb952fe02e4d19"
    )
  ]
)

