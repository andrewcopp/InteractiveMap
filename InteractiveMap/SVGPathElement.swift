//
//  SVGPathElement.swift
//  InteractiveMap
//
//  Created by Andrew Copp on 5/18/15.
//  Copyright (c) 2015 Andrew Copp. All rights reserved.
//

import UIKit

class SVGPathElement: NSObject {
   
    var title : String?
    var identifier : String?
    var className : String?
    var transform : String?
    var path : UIBezierPath?
    var fill : Bool?
    
    var lastPoint : CGPoint?
    
    init(attributes : [NSObject: AnyObject]) {
        
        lastPoint = CGPointMake(0, 0)
        fill = false
        title = attributes["title"] as! String
        identifier = attributes["id"] as! String
        className = attributes["class"] as! String
        transform = attributes["transform"] as! String
        path = nil
        
        super.init()
        
        parsePathData(attributes["d"] as! String)
        SVGUtils.parseTransform(transform!)
        
        let fillString : String? = attributes["fill"] as! String
        if fillString != nil && fillString == "none" {
            fill = false
        }
    }
    
    func parsePathData(pathData: String) {
        
        if pathData.isEmpty {
            return
        }
        
        path = UIBezierPath()
        
        // find character
        
        let letters = NSCharacterSet.letterCharacterSet()

        for uni in pathData.unicodeScalars {
            letters.longCharacterIsMember(uni.value)
        }
//        if pathData.unicodeScalars[1] {
//            
//        }
        
        // move until the next character
        
        // execute
        
        // rinse repeat
        
    }
    
    func executeCommand(command: Character, forValue value: String) {
        
        let coordinates : [NSNumber] = SVGUtils.parsePoints(value)
        
        if !coordinates.isEmpty && command != "z" && command != "Z" {
            return
        }
        
        switch command {
            case "M":
                executeMoveTo(coordinates, isAbsolute: true)
            case "m":
                executeMoveTo(coordinates, isAbsolute: false)
            case "L":
                executeLineTo(coordinates, isAbsolute: true)
            case "l":
                executeLineTo(coordinates, isAbsolute: false)
            case "H":
                executeHorizontalLineTo(coordinates, isAbsolute: true)
            case "h":
                executeHorizontalLineTo(coordinates, isAbsolute: false)
            case "V":
                executeVerticalLineTo(coordinates, isAbsolute: true)
            case "v":
                executeVerticalLineTo(coordinates, isAbsolute: false)
            case "C":
                executeCurveTo(coordinates, isAbsolute: true)
            case "c":
                executeCurveTo(coordinates, isAbsolute: false)
            case "Z", "z":
                path?.closePath()
                fill = true
            default:
                println("Warning: Unknown command \(command)")
        }
    }
    
    func executeMoveTo(coordinates: [NSNumber], isAbsolute absolute: Bool) {
        for var i = 0; i < coordinates.count / 2; i++ {
            
            if i * 2 + 2 > coordinates.count {
                return
            }
            
            let p : CGPoint = CGPointMake(CGFloat(coordinates[i * 2].floatValue), CGFloat(coordinates[i * 2 + 1].floatValue))
            
            if absolute {
                lastPoint = p
            } else {
                lastPoint = CGPointMake(p.x + lastPoint!.x, p.y + lastPoint!.y)
            }
            
            path?.moveToPoint(lastPoint!)
        }
    }
    
    func executeLineTo(coordinates: [NSNumber], isAbsolute absolute: Bool) {
        for var i = 0; i < coordinates.count / 2; i++ {
            
            if i * 2 + 2 > coordinates.count {
                return
            }
            
            let p : CGPoint = CGPointMake(CGFloat(coordinates[i * 2].floatValue), CGFloat(coordinates[i * 2 + 1].floatValue))
            
            if absolute {
                lastPoint = p
            } else {
                lastPoint = CGPointMake(p.x + lastPoint!.x, p.y + lastPoint!.y)
            }
            
            path?.addLineToPoint(lastPoint!)
        }
    }
    
    func executeHorizontalLineTo(coordinates: [NSNumber], isAbsolute absolute: Bool) {
        for var i = 0; i < coordinates.count; i++ {
            
            if i + 1 > coordinates.count {
                return
            }
            
            let value : Float = coordinates[i * 2].floatValue
            
            if absolute {
                lastPoint?.x = CGFloat(value)
            } else {
                lastPoint = CGPointMake(CGFloat(value) + lastPoint!.x, lastPoint!.y)
            }
            
            path?.addLineToPoint(lastPoint!)
        }
    }
    
    func executeVerticalLineTo(coordinates: [NSNumber], isAbsolute absolute: Bool) {
        for var i = 0; i < coordinates.count; i++ {
            
            if i + 1 > coordinates.count {
                return
            }
            
            let value : Float = coordinates[i * 2].floatValue
            
            if absolute {
                lastPoint?.y = CGFloat(value)
            } else {
                lastPoint = CGPointMake(lastPoint!.x, CGFloat(value) + lastPoint!.y)
            }
            
            path?.addLineToPoint(lastPoint!)
        }
    }
    
    func executeCurveTo(coordinates: [NSNumber], isAbsolute absolute: Bool) {
        for var i = 0; i < coordinates.count / 6; i++ {
            if i * 6 + 6 > coordinates.count {
                return
            }
            
            let c1 : CGPoint = CGPointMake(CGFloat(coordinates[i * 6].floatValue), CGFloat(coordinates[i * 6 + 1].floatValue))
            let c2 : CGPoint = CGPointMake(CGFloat(coordinates[i * 6 + 2].floatValue), CGFloat(coordinates[i * 6 + 3].floatValue))
            let p : CGPoint = CGPointMake(CGFloat(coordinates[i * 6 + 4].floatValue), CGFloat(coordinates[i * 6 + 5].floatValue))
            
            if absolute {
                lastPoint = p
                path?.addCurveToPoint(p, controlPoint1: c1, controlPoint2: c2)
            } else {
                path?.addCurveToPoint(CGPointMake(lastPoint!.x + p.x, lastPoint!.y + p.y), controlPoint1: CGPointMake(lastPoint!.x + c1.x, lastPoint!.y + c1.y), controlPoint2: CGPointMake(lastPoint!.x + c2.x, lastPoint!.y + c2.y))
            }
        }
    }
}
