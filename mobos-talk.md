# Cross-Platform Swift

## MobOS Conference, February 2016

### Boris Bügling - @NeoNacho

![20%, original, inline](images/contentful.png)

<!--- use Poster theme, black -->

---

## CocoaPods

![](images/cocoapods.jpg)

---

## Contentful

![](images/contentful-bg.png)

---

![100%](images/coloring-books.jpg)

---

# Agenda

- Which platforms can we target?
- How to share code between them
- Some practical examples

---

## Which platforms can we target?

---

# Apple platforms

- OS X
- iOS
- watchOS
- tvOS

---

## Frameworks shared between Apple platforms

```
CFNetwork.framework
CoreData.framework
CoreFoundation.framework
CoreGraphics.framework
CoreLocation.framework
CoreText.framework
Foundation.framework
ImageIO.framework
Security.framework
```

---

## There's more depending on the subset we target

```
Accelerate.framework
AudioToolbox.framework
AudioUnit.framework
AVFoundation.framework
AVKit.framework
CloudKit.framework
CoreBluetooth.framework
```

---

## There's more depending on the subset we target

```
CoreImage.framework
CoreMedia.framework
CoreVideo.framework
EventKit.framework
GameController.framework
GameKit.framework
GLKit.framework
MapKit.framework
```

---

## There's more depending on the subset we target

```
MediaAccessibility.framework
Metal.framework
MobileCoreServices.framework
SceneKit.framework
SpriteKit.framework
StoreKit.framework
SystemConfiguration.framework
```

---

# UIKit

When only targeting `iOS` and `tvOS`

---

# NIBs 😭

![inline](images/ios-nibs.png)

If you don't feel like copy-pasting stuff between NIBs 👇

<https://github.com/neonichu/bohne>

---

# Open Source Swift

- Linux

---

# Open Source Swift

- FreeBSD (somewhat)

---

# Open Source Swift

- Android (someday, maybe)

<https://github.com/SwiftAndroid/swift>

---

## Frameworks shared between **all** platforms

```
Foundation.framework
```

<https://github.com/apple/swift-corelibs-foundation>

---

## Foundation is incomplete and sometimes different from OS X

```swift
#if os(Linux)
      let index = p.startIndex.distanceTo(p.startIndex.successor())
      path = NSString(string: p).substringFromIndex(index)
#else
      path = p.substringFromIndex(p.startIndex.successor())
#endif
```

---

# Apple's goal

- Be compatible with Swift 3.0
- Scheduled to ship by the end of 2016

---

## Even some things in the standard library might not be available

```objectivec
#if _runtime(_ObjC)
// Excluded due to use of dynamic casting and Builtin.autorelease, neither
// of which correctly work without the ObjC Runtime right now.
// See rdar://problem/18801510
[...]
public func getVaList(args: [CVarArgType]) -> CVaListPointer {
```

---

## Even libc is problematic

```swift
#if os(Linux)
import Glibc
#else
import Darwin.C
#endif
```

---

```swift
let flags = GLOB_TILDE | GLOB_BRACE | GLOB_MARK
    if system_glob(cPattern, flags, nil, &gt) == 0 {
#if os(Linux)
      let matchc = gt.gl_pathc
#else
      let matchc = gt.gl_matchc
#endif
```

---

## And other random fun

```
./.build/debug/spectre-build
/usr/bin/ld: .build/debug/Clock.a(ISO8601Parser.swift.o): 
undefined reference to symbol '_swift_FORCE_LOAD_$_swiftGlibc'
/home/travis/.swiftenv/versions/swift-2.2-SNAPSHOT-2015-12-22-a/
usr/lib/swift/linux/libswiftGlibc.so: error adding symbols: DSO 
missing from command line
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

---

## => it's complicated

---

## How to share code between them

---

- Shared files
- Shared frameworks
- Shared packages

---

# Shared files

![inline](images/targets.png)

---

# Build configurations

- os(): OSX, iOS, watchOS, tvOS, Linux
- arch(): x86_64, arm, arm64, i386

---

```swift
#if os(OSX)
print("Running on OS X")
#elseif os(watchOS)
print("Running on watchOS")
#else
print("Running on any platform but OS X and watchOS")
#end
```

---

# Shared frameworks

![inline](images/supported-platforms.png)

---

## [Xcode 7 beta] Linking dual (iphoneos and watchos) frameworks with same product name causes archive to fail

<http://openradar.appspot.com/22392501>

---

# Shared packages

- CocoaPods
- Carthage
- Swift Package Manager

---

# CocoaPods

```json
  "platforms" : {
    "osx" : "10.10",
    "ios": "8.0",
    "watchos": "2.0",
    "tvos": "9.0"
  }
```

---

## If a Pod does not support a certain platform

- Fork and add it
- Submit a PR
- For the adventurous 👇

<https://github.com/orta/cocoapods-expert-difficulty>

---

# CocoaPods avoids 22392501

- Each duplicated target gets scoped
- <.../Build/Debug-iphoneos/Pods-UserTarget/*.framework>

---

# Conche

```
$ conche build
Downloading Dependencies
-> PathKit 0.5.0
-> Commander 0.5.0
Building Dependencies
-> PathKit
-> Commander
Building Conche
Building Entry Points
-> conche -> .conche/bin/conche
```

---

# Carthage

- Essentially a nicer way to do shared frameworks

---

# Swift Package Manager

---

# What is swiftpm?

---

```swift
import PackageDescription

let package = Package(
    name: "Hello",
    dependencies: [
        .Package(url: "ssh://git@example.com/Greeter.git", 
          versions: Version(1,0,0)..<Version(2,0,0)),
    ]
)
```

---

```bash
$ swift build
Compiling Swift Module 'Clock' (2 sources)
Linking Library:  .build/debug/Clock.a
```

---

# What does it do?

- Compiles and links Swift packages
- Resolves, fetches and builds their dependencies

---

# Current state

- Currently builds static libraries or binaries
- Supported platforms are OS X and Ubuntu Linux
- Only builds Swift code, no C/C++/Objective-C/...

---

```bash
$ swift build --help
OVERVIEW: Build sources into binary products

USAGE: swift build [options]

MODES:
  --configuration <value>  Build with configuration (debug|release) [-c]
  --clean                  Delete all build intermediaries and products [-k]

OPTIONS:
  --chdir <value>    Change working directory before any other operation [-C]
  -v                 Increase verbosity of informational output
```

---

![250%](images/gh-repo.png)

---

# Making our own package

---

# 🕕

A small library for parsing and writing ISO8601 date strings.

---

```
Sources/
└── Clock
    ├── ISO8601Parser.swift
    └── ISO8601Writer.swift

1 directory, 2 files
```

---

```bash
$ touch Package.swift
$ swift build
```

---

## Tests?

---

# Spectre

```swift
describe("a person") {
  let person = Person(name: "Kyle")

  $0.it("has a name") {
    try expect(person.name) == "Kyle"
  }

  $0.it("returns the name as description") {
    try expect(person.description) == "Kyle"
  }
}
```

---

# spectre-build

```bash
$ swift build
$ .build/debug/spectre-build
-> a person
  -> has a name
  -> returns the name as description

2 passes and 0 failures
```

---

```swift
import PackageDescription

let package = Package(
  name: "Clock",
  testDependencies: [
    .Package(url: "https://github.com/neonichu/spectre-build.git",
      majorVersion: 0),
  ]
)
```

---

```makefile
BUILD_DIR=./.build/debug

.PHONY: clean lib test

test: lib
  $(BUILD_DIR)/spectre-build

clean:
  swift build --clean

lib:
  swift build
```

---

```bash
$ make test
swift build
./.build/debug/spectre-build
-> Converting dates to strings
  -> can convert NSDate to an ISO8601 GMT string

-> Parsing of localtime dates
  -> can parse dates
  -> can parse dates with negative timezone offsets
  -> can parse timezone offsets without colons

-> Parsing of UTC dates
  -> can parse dates
  -> can parse epoch
  -> can parse dates without seconds
  -> is resilient against Y2K bugs

8 passes and 0 failures
```

---

# Swift versions

```bash
$ cat .swift-version 
swift-2.2-SNAPSHOT-2015-12-22-a
```

- Is read by either `chswift` or `swiftenv`

---

# Travis CI

```haml
os:
- linux
- osx
language: generic
sudo: required
dist: trusty
osx_image: xcode7.2
install:
- curl -sL https://gist.github.com/kylef/
5c0475ff02b7c7671d2a/raw/
621ef9b29bbb852fdfd2e10ed147b321d792c1e4/swiftenv-install.sh | bash
script:
- . ~/.swiftenv/init
```

---

# Git tagging

- `Package.swift` only supports tagged dependencies
- Don't forget to push your tags to GitHub

---

# CocoaPods

- `chocolat-cli` converts `Package.swift` to a JSON Podspec

---

```swift
public func parse_package(packagePath: String) throws -> PackageDescription.Package {
  // FIXME: We depend on `chswift` installation and use here
  let toolchainPath = PathKit.Path(POSIX.getenv("CHSWIFT_TOOLCHAIN") ?? "")
  libc.setenv("SPM_INSTALL_PATH", toolchainPath.parent().description, 1)
  print_if("Using libPath \(Resources.runtimeLibPath)", false)

  let package = (try Manifest(path: packagePath)).package
  print_if("Converting package \(package.name) at \(packagePath)", false)

  return package
}
```

---

# Integrate system libraries

- Empty `Package.swift`
- `module.modulemap`:

```
module curl [system] {
    header "/usr/include/curl/curl.h"
    link "curl"
    export *
}
```

---

```
let package = Package(
    name: "example",
    dependencies: [
        .Package(url: "https://github.com/neonichu/curl",
          majorVersion: 1)
    ]
)
```

---

# How does it work?

---

## Modules inside SwiftPackageManager

- OS abstractions: `libc`, `POSIX`, `sys`
- Package: `PackageDescription`
- Manifest: `dep`
- Downloading code: `swift-get`
- Building code: `swift-build`

---

# Dependencies

- Can be local or remote Git repositories
- Need to be tagged
- Will be fetched to `./Packages/MyPackage-0.0.1`

---

# Rough build process

- `PackageDescription` generates TOML
- `dep` parses the TOML and can generate YAML
- Dependencies are fetched by `swift-get`
- YAML is used as input to `llbuild`
- `swift-build` calls out to `llbuild`

---

# llbuild

---

```
$ cat .build/debug/Clock.o/llbuild.yaml 
client:
  name: swift-build

tools: {}

targets:
  "": [<Clock>]
  Clock: [<Clock>]
```

---

```
commands:
  <Clock-swiftc>:
    tool: swift-compiler
    executable: "/usr/bin/swiftc"
    inputs: ["ISO8601Parser.swift","ISO8601Writer.swift"]
    outputs: ["<Clock-swiftc>","Clock.swiftmodule",
    "ISO8601Parser.swift.o","ISO8601Writer.swift.o"]
    module-name: "Clock"
    module-output-path: "Clock.swiftmodule"
    is-library: true
    sources: ["ISO8601Parser.swift","ISO8601Writer.swift"]
    objects: ["ISO8601Parser.swift.o","ISO8601Writer.swift.o"]
    import-paths: ["/Users/boris/Projects/Clock/.build/debug"]
    temps-path: "/Users/boris/Projects/Clock/.build/debug/Clock.o/Clock"
    other-args: ["-j8","-Onone","-g","-target","x86_64-apple-macosx10.10",
    "-enable-testing","-sdk",
    "/.../Developer/SDKs/MacOSX10.11.sdk","-I","/usr/local/include"]
```

---

```
  <Clock>:
    tool: shell
    inputs: ["<Clock-swiftc>","ISO8601Parser.swift.o","ISO8601Writer.swift.o"]
    outputs: ["<Clock>","Clock.a"]
    args: ["/bin/sh","-c","rm -f 'Clock.a'; 
    ar cr 'Clock.a' 'ISO8601Parser.swift.o' 'ISO8601Writer.swift.o'"]
    description: "Linking Library:  .build/debug/Clock.a"
```

---

## Additional Package.swift syntax

---

# Targets

```swift
import PackageDescription

let package = Package(
    name: "Example",
    targets: [
        Target(
            name: "top",
            dependencies: [.Target(name: "bottom")]),
        Target(
            name: "bottom")
    ]
)
```

---

# Exclusion

```swift
let package = Package(
    name: "Example",
    exclude: ["tools", "docs", "Sources/libA/images"]
)
```

---

# Test dependencies

```swift
import PackageDescription

let package = Package(
    name: "Hello",
    testDependencies: [
        .Package(url: "ssh://git@example.com/Tester.git",
          versions: Version(1,0,0)..<Version(2,0,0)),
    ]
)
```

---

# Customizing builds

```swift
import PackageDescription

var package = Package()

#if os(Linux)
let target = Target(name: "LinuxSources/foo")
package.targets.append(target)
#endif
```

---

> You should think of it as an alpha code base that hasn't had a release yet. Yes, it is useful for doing some things [...]
-- Daniel Dunbar

---

# Some practical examples

---

# SpriteKit Example

Can run on OS X, iOS and tvOS

![inline](images/spritekit-demo-2.png)

---

# Clock

```
~/Clock# make
swift build
./.build/debug/spectre-build
-> Parsing of localtime dates
fatal error: init(forSecondsFromGMT:) is not yet implemented:
	file Foundation/NSTimeZone.swift, line 69
Illegal instruction
InvocationError()
Makefile:6: recipe for target 'test' failed
make: *** [test] Error 1
```

---

# Electronic Moji

```
$ ./.build/debug/electronic-moji car
🎠  🚃  🚋  🚓  🚔  🚨  🎏  🏎  🃏  🎴  💳  🗂  📇  🗃
```

![inline](images/emoji-keyboard.png)

---

# Contentful SDK

---

# Conclusion

- It's complicated :)
- Still a lot of code *can* be shared
- Swift 3.0 will help a lot

---

## References

- <https://swift.org>
- <https://github.com/apple/swift-package-manager>
- <https://github.com/apple/llbuild>
- <https://github.com/neonichu/chocolat>
- <https://github.com/neonichu/chswift>
- <https://github.com/neonichu/freedom>
- <https://github.com/kylef/spectre-build>
- <https://github.com/kylef/swiftenv>

---

# Thank you!

![](images/thanks.gif)

---

@NeoNacho

boris@contentful.com

http://buegling.com/talks

![](images/contentful-bg.png)
