# RoundSlider

## Introduction

This project is a simple SwiftUI implementation of an interactive slider with customizable minimum, maximum, and color.

## Requirements

* iOS 13.0+
* macOS 10.15+
* Swift 5+
* Xcode 11.0+

## Installation

`RoundSlider` is available via Swift Package Manager. 

Go to `File > Swift Packages > Add Package Dependency` and enter https://github.com/alexanderlucas/swift-round-slider

## Example Usage

```Swift
import RoundSlider
```

Use `SliderData` to set the minimum, maximum, and default values as Double, as well as the background Color of the slider. 

```Swift
var sliderData = SliderData(minValue: 0, maxValue: 100, defaultValue: 30, color: .red)
var body: some View {
    VStack {
        Text("Hello, World!")
        RoundSlider().environmentObject(sliderData)
    }
}
```
