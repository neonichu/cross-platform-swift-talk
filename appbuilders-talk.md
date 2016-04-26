# Cross-Platform Swift

## App Builders Swizzleland, April 2016

### Boris Bügling - @NeoNacho

![20%, original, inline](images/contentful.png)

![](images/paintings/cross.jpg)

<!-- use Poster theme, black -->

---

## CocoaPods

<!-- ![original](images/cocoapods.jpg) -->

![](images/paintings/hellmouth.jpg)

---

## Contentful

![](images/paintings/headless.jpg)

---

![](images/contentful-customers.jpg)

---

![inline](images/colouring-books.png)

![](images/paintings/painter.jpg)

---

# Cross-platform Swift

![](images/paintings/cross.jpg)

---

## Why Swift?

![](images/paintings/bird.jpg)

---

![140%](images/dev-productivity.png)

---

# 😎

![90%](images/paintings/hipster-moses.jpg)

---

## Which platforms can we target?

![](images/paintings/platform.jpg)

---

# Apple platforms

- macOS 💻
- iOS 📱
- watchOS ⌚️
- tvOS 📺
- carOS 🚘

![](images/paintings/day1.jpeg)

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

![](images/paintings/day1.jpeg)

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

![](images/paintings/day1.jpeg)

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

![](images/paintings/day1.jpeg)

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

![](images/paintings/day1.jpeg)

---

# UIKit

When only targeting `iOS` and `tvOS`

![](images/paintings/day1.jpeg)

---

# NIBs 😭

![inline](images/ios-nibs.png)

If you don't feel like copy-pasting stuff between NIBs 👇

<https://github.com/neonichu/bohne>

![](images/paintings/day1.jpeg)

---

# Open Source Swift

- Linux

![350%](images/paintings/beard.jpg)

---

# Open Source Swift

- FreeBSD (<https://github.com/apple/swift/pull/713>)
- Windows / Cygwin (<https://github.com/apple/swift/pull/1108>)
- Android (<https://github.com/apple/swift/pull/1442>)

![](images/paintings/bruegel-12a.jpg)

---

![inline](images/android-faq.png)

![](images/paintings/bruegel-12a.jpg)

---

# Importing JNI into Swift

```c
module CJavaVM [system] {
    header "jni.h"
    link "jvm"
    export *
}
```

---

# Calling Java using JNI from Swift

```swift
import CJavaVM

var vm: UnsafeMutablePointer<JavaVM> = nil
let env = create_vm(&vm)
let jni = env.pointee.pointee

let hello_class = jni.FindClass(env, "helloWorld")

let main_method = jni.GetStaticMethodID(env, hello_class,
  "main", "([Ljava/lang/String;)V")
jni.CallStaticVoidMethodA(env, hello_class, main_method, [])
```

---

## A *really* long way to go 🏃

![](images/paintings/bruegel-12a.jpg)

---

## Frameworks shared between **all** platforms

```
Foundation.framework
```

<https://github.com/apple/swift-corelibs-foundation>

![](images/paintings/maharaja-riding-elephant-his-army-historical-mural-jodhpur-india-mehrangarh-fort-foundation-fort-was-50934935.jpg)

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

![](images/paintings/maharaja-riding-elephant-his-army-historical-mural-jodhpur-india-mehrangarh-fort-foundation-fort-was-50934935.jpg)

---

## Some things in the standard library might not be available

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

## e.g. struct members can be completely different

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

## => it's complicated

![](images/paintings/maharaja-riding-elephant-his-army-historical-mural-jodhpur-india-mehrangarh-fort-foundation-fort-was-50934935.jpg)

---

## but only *right* now

![](images/paintings/nostradamus.jpg)

---

## How to share code between them

![](images/paintings/share.jpg)

---

- Shared files
- Shared frameworks
- Shared packages

![](images/paintings/share.jpg)

---

# Shared files

![inline](images/targets.png)

![](images/paintings/share.jpg)

---

# Build configurations

- os(): OSX, iOS, watchOS, tvOS, Linux
- arch(): x86_64, arm, arm64, i386

![](images/paintings/share.jpg)

---

# Using build configurations

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

## Can also be used to distinguish versions (SE-0020)

```swift
#if swift(>=2.2)
  print("Active!")
#else
  this! code! will! not! parse! or! produce! diagnostics!
#endif
```

---

## Or to see if your code is being built by swiftpm

```swift
#if SWIFT_PACKAGE
import Foundation
#endif
```

---

# Shared frameworks

![inline](images/supported-platforms.png)

![](images/paintings/share.jpg)

---

## [Xcode 7 beta] Linking dual (iphoneos and watchos) frameworks with same product name causes archive to fail

<http://openradar.appspot.com/22392501>

![](images/paintings/share.jpg)

---

# Shared packages/libraries

- CocoaPods
- Carthage
- Swift Package Manager

![](images/paintings/share.jpg)

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

![](images/paintings/hellmouth.jpg)

---

## If a Pod does not support a certain platform

- Fork and add it
- Submit a PR
- For the adventurous 👇

<https://github.com/orta/cocoapods-expert-difficulty>

![](images/paintings/adventure.jpg)

---

# CocoaPods avoids 22392501

- Each duplicated target gets scoped
- <.../Build/Debug-iphoneos/Pods-UserTarget/*.framework>

![](images/paintings/hellmouth.jpg)

---

# Conche

- Deprecated now, but nice example of what package manifests enable

```bash
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

![](images/paintings/hellmouth.jpg)

---

# Carthage

- Essentially a nicer way to do shared frameworks

![](images/paintings/Sack_of_Rome_of_1527_by_Johannes_Lingelbach_17th_century.jpg)

---

# Swift Package Manager

- Currently the only way to target Linux
- Does not support iOS, watchOS or tvOS, though

![](images/paintings/bird.jpg)

---

# Swift Package Manager

- No real platform syntax, but can use build configs:

```swift
import PackageDescription

var package = Package()

#if os(Linux)
let target = Target(name: "LinuxSources/foo")
package.targets.append(target)
#endif
```

![](images/paintings/bird.jpg)

---

# Current status

- Use swiftpm for OS X and Linux
- Use CocoaPods for the iOS-ish platforms
- Use build configurations to distinguish

![](images/paintings/hellmouth.jpg)

---

# Development Environment

![](images/paintings/developers.jpg)

---

- Xcode
- Xcode + Swift Toolchain
- Any editor + `swift build`

![](images/paintings/developers.jpg)

---

![inline](images/xcode_toolchain.png)

![](images/paintings/developers.jpg)

---

# Swift versions

```bash
$ cat .swift-version 
swift-2.2-SNAPSHOT-2015-12-22-a
```

- Is read by either `chswift` or `swiftenv`

![](images/paintings/bird.jpg)

---

## How to test/develop for Linux?

![](images/paintings/Trapeze_Artists_in_Circus.jpg)

---

# IBM Swift Sandbox

![inline](images/ibm-swift-sandbox.png)

- No third party dependencies
- Limited to 65535 characters in a source file

![](images/paintings/Trapeze_Artists_in_Circus.jpg)

---

# Docker

Easiest way on OS X: dlite 
<https://github.com/nlf/dlite/releases>

```bash
$ brew install dlite docker
$ sudo dlite install
$ docker run -it ubuntu bash
```

![](images/paintings/circus2.jpg)

---

# Docker

- A Swift `Dockerfile`
e.g. <https://github.com/IBM-MIL/Samples/tree/master/docker-swift>

```bash
$ docker build -t swift ./
$ docker run -it swift /bin/bash
$ docker ps # Get 'CONTAINER ID'
```

- or `docker pull swiftdocker/swift`

![](images/paintings/circus2.jpg)

---

# Docker

If you don't want to create new containers all the time:

```bash
$ docker start XXXX
$ docker exec -it XXXX /bin/bash
$ docker stop XXXX
```

![](images/paintings/circus2.jpg)

---

# Heroku

- <https://github.com/neonichu/swift-buildpack>
- <https://github.com/kylef/heroku-buildpack-swift>

```bash
$ heroku run bash
```

![](images/paintings/circus3.jpg)

---

# CI

![](images/paintings/circus3.jpg)

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

![](images/paintings/circus3.jpg)

---

# Practical example

![](images/paintings/theatre.jpg)

---

# Emoji!

### 😀  😁  😂  😃  😄  😅  😆  😉  😊  😋  😎  😍  😘  😗  😙  😚  🙂  🤗  😇  🤔  😐  😑  😶  🙄  😏  😣  😥  😮  🤐  😯  😪  😫  😴  😌  🤓  😛  😜  😝

![](images/paintings/theatre.jpg)

---

# electronic-moji

```swift
import Foundation
import Regex

extension Character {
  public var unicodeName: String {
    let mutableString = NSMutableString(string: "\(self)")
    CFStringTransform(mutableString, nil, kCFStringTransformToUnicodeName, false)
    let unicodeName = "\(mutableString)".lowercaseString
    let regex = Regex(".*\\{(.*)\\}")
    return regex.match(unicodeName)?.captures.first.flatMap { $0 } ?? unicodeName
  }
}

extension CollectionType where Generator.Element == Character {
  public func findUnicodeName(term: String) -> [Character] {
    let regex = Regex(".*\(term).*")
    return self.filter { regex.matches($0.unicodeName) }
  }
}
```

---

# Frank

Frank is a DSL for quickly writing web applications in Swift with type-safe path routing.

<https://github.com/nestproject/Frank>

![](images/frank.jpg)

---

```swift
import Emoji
import Frank

get { _ in
  return "Hello 🇨🇭\n"
}

get(*) { (_, name: String) in
  return (EMOJI.findUnicodeName(name)
    .map { "\($0)" }
    .first ?? "¯\\_(ツ)_/¯") + "\n"
}
```

---

# Demo

![](images/paintings/theatre.jpg)

---

```bash
.build/debug/example
[2016-04-26 10:21:09 +0200] [65201] [INFO] Listening at http://0.0.0.0:8000 (65201)
[2016-04-26 10:21:09 +0200] [65202] [INFO] Booting worker process with pid: 65202
[worker] GET / - 200 OK
[worker] GET /glasses - 200 OK
[worker] GET /nerd - 200 OK
```

```bash
$ curl http://0.0.0.0:8000
Hello 🇨🇭
$ curl http://0.0.0.0:8000/glasses
😎
$ curl http://localhost:8000/nerd
🤓
```

---

# emoji search keyboard

![150%](images/keyboard.png)

<https://github.com/neonichu/emoji-search-keyboard>

---

# CLI tool

```bash
$ electronic-moji bird
🐦
```

![](images/paintings/theatre.jpg)

---

# Conclusion

- It's complicated :)
- Still a lot of code *can* be shared
- Swift 3.0 will help a lot

![](images/paintings/Lorenzetti_amb.effect2.jpg)

---

# Thank you!

![](images/paintings/thanks.jpg)

---

# References

- <https://swift.org>
- <https://github.com/neonichu/freedom>
- <https://github.com/kylef/swiftenv>
- <https://github.com/nestproject/Frank>
- <https://speakerdeck.com/jpsim/practical-cross-platform-swift>
- <https://speakerdeck.com/kylef/end-to-end-building-a-web-service-in-swift-mce-2016>

![](images/paintings/Lorenzetti_amb.effect2.jpg)

---

> “Experienced engineer examines comments in a legacy module”
--=> <http://classicprogrammerpaintings.com>

![](images/paintings/tumblr_o5pb9bPbgQ1ugyavxo1_1280.jpg)

---

-

-

-

@NeoNacho

boris@contentful.com

http://buegling.com/talks

![original](images/contentful-bg.png)
