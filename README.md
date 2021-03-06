# AiryLayout 💨
A simple Auto Layout wrapper - write readable layouts!

[![Language: Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat")](https://developer.apple.com/swift)

### Simple Example:
```swift
label.top(10).left(5).right(20).bottom()
```

### Pins edge to edge and with inset:
```swift
tableView.pin()
scrollView.pin(10)
```

### Different components:
```swift
label.topAnchor ~ customView.bottomAnchor + 7.0
label.leftAnchor ~ customView.leftAnchor + 15.0
label.rightAnchor ~ customView.rightAnchor - 4.0
```
### Equals more compact API:
```swift
label.pin([.top(7): .bottom, .left(15): .left, .right(4): .right], to: customView)
```

### Combinations:
```swift

@Layouting var switcher = UISwitch()
@Layouting var label = UILabel()
@Layouting var button = UIButton()

switcher.centerY().left(8)

label.centerY().centerX()

button
   .left(to: .right(20), of: label)
   .top(to: switcher)
   .right(24)
```
<p align="left">
  <img src="https://i.imgur.com/X0w6WIS.png" width="400">
</p>

### Enabling safe area API
```swift
collectionView.left().right().safeArea { $0.top().bottom(10) }
```

## Installation
### Swift Package Manager
The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Just add AiryLayout in your `Package.swift` as a dependency:
```swift
dependencies: [
    .package(url: "https://github.com/kabyshev/AiryLayout.git", .upToNextMajor(from: "1.0.0"))
]
```

### Manually
If you prefer not to use SPM, you can integrate AiryLayout into your project manually: add `Sources` folder to your project.
