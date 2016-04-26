import PackageDescription

_ = Package(
      name: "example",
      dependencies: [
        .Package(url: "https://github.com/nestproject/Frank.git", majorVersion: 0, minor: 3),
        .Package(url: "https://github.com/neonichu/electronic-moji.git", majorVersion: 0),
      ]
    )

