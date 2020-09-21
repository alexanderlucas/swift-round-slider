//
//  SwiftSlider.swift
//  Good Slider
//
//  Created by Alex Lucas on 10/18/19.
//  Copyright © 2019 Alex Lucas. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public class SliderData: ObservableObject {
    
    var minValue: Double
    var maxValue: Double
    var defaultValue: Double
    public var color: Color
    var goesUp: Bool
    
    public init(minValue: Double, maxValue: Double, defaultValue: Double, color: Color, goesUp: Bool = true) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.defaultValue = defaultValue
        self.color = color
        self.goesUp = goesUp
        self.value = defaultValue
    }

    @Published var value: Double
    
    public func getValue() -> Double {
        value
    }
}

@available(iOS 13.0, macOS 10.15, *)
public struct RoundSlider: View {
    @EnvironmentObject var data: SliderData
    @GestureState var isDetectingLongPress = false
    @State var moving: Bool = false
    @State var initialPosition: CGSize?
    
    var valueString: String {
        String(Int(data.value))
    }
    
    public init() {
        
    }

    public var body: some View {
        
        return
            GeometryReader { (geometry) -> AnyView in
                var max: CGFloat {
                    (geometry.size.width / 2 - 26)
                }
                var min: CGFloat {
                    (geometry.size.width / -2 + 26)
                }
                let press = LongPressGesture(minimumDuration: 1)
                    .updating(self.$isDetectingLongPress) { currentState, gestureState, transaction in
                        
                        gestureState = currentState
                    }

                let drag = DragGesture()
                    .onChanged {
                        if self.initialPosition == nil {
                            let oldDiff = max - min
                            let newDiff = CGFloat(self.data.maxValue - self.data.minValue)
                            let valDiff = CGFloat(self.data.defaultValue - self.data.maxValue)
                            
                            self.initialPosition = CGSize(width: (oldDiff / newDiff) * valDiff + max, height: 0)
                        }
                        var tran = $0.translation

                        tran.width += self.initialPosition!.width
                        if tran.width < min {
                            tran.width = min
                        }
                        if tran.width > max {
                            tran.width = max
                        }
                        
                        self.moving = true

                        
                        let newDiff = CGFloat(self.data.maxValue - self.data.minValue)
                        let oldDiff = max - min
                        
                        let valDiff = tran.width - max
                        
                        let newVal = (newDiff / oldDiff) * valDiff + CGFloat(self.data.maxValue)
                        
                        self.data.value = Double(newVal)
                        
                }
                .onEnded {
                    var tran = $0.translation
                    
                    tran.width += self.initialPosition!.width

                    if tran.width < min {
                        tran.width = min
                    }
                    if tran.width > max {
                        tran.width = max
                    }

                    self.initialPosition!.width = tran.width
                    self.initialPosition!.height = 0
                    self.moving = false

                    let newDiff = CGFloat(self.data.maxValue - self.data.minValue)
                    let oldDiff = max - min
                    
                    let valDiff = tran.width - max
                    
                    let newVal = (newDiff / oldDiff) * valDiff + CGFloat(self.data.maxValue)
                    
                    self.data.value = Double(newVal)
                    

                }
                
                var offsetWidth: CGFloat {
                    let oldDiff = max - min
                    let newDiff = CGFloat(self.data.maxValue - self.data.minValue)
                    let valDiff = CGFloat(self.data.value - self.data.maxValue)
                    
                    return (oldDiff / newDiff) * valDiff + max
                }
                
                return AnyView(
                    ZStack {
                        Rectangle()
                            .frame(width: geometry.size.width, height: 40)
                            .cornerRadius(20)
                            .animation(.spring())
                            .foregroundColor(self.data.color)
                        Thumb(label: self.valueString, isUp: self.data.goesUp && (self.moving || self.isDetectingLongPress), color: self.data.color)
                            .frame(width: 40, height: 40)
                            .offset(x: offsetWidth, y: self.isDetectingLongPress || self.moving ? -37 : 0)
                            .gesture(press)
                            .gesture(drag)
                            .animation(Animation.spring(dampingFraction: 0.76).speed(1.6))
                })
        }
            .frame(height: 40)
        
    }
}

@available(iOS 13.0, macOS 10.15, *)
private struct Thumb: View {
    var label: String = ""
    
    var isUp: Bool
    
    var color: Color

    
    var body: some View {
        
        ZStack {
            Path { p in
                p.move(to: CGPoint(x: 10, y: 38))
                p.addCurve(to: CGPoint(x: 20, y: 0), control1: CGPoint(x: -2, y: 38), control2: CGPoint(x: -10, y: 2))
                p.addCurve(to: CGPoint(x: 30, y: 38), control1: CGPoint(x: 50, y: 2), control2: CGPoint(x: 42, y: 38))
            }
            .fill(color)
            Circle()
                .fill(Color.white)
                .padding(3)
            Text(label)
                .foregroundColor(color)
                .font(.system(size: 14, design: .monospaced))

            .minimumScaleFactor(0.01)

        }
        

    }
}
