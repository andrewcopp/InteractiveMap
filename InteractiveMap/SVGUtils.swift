//
//  SVGUtils.swift
//  InteractiveMap
//
//  Created by Andrew Copp on 5/18/15.
//  Copyright (c) 2015 Andrew Copp. All rights reserved.
//

import UIKit

class SVGUtils: NSObject {
   
    class func parsePoints(str: String) -> [NSNumber] {
        let scanner : NSScanner = NSScanner(string: str)
        scanner.charactersToBeSkipped = NSCharacterSet(charactersInString: "\n, ")
        
        var array : [NSNumber] = []
        
        var value : Float = 0
        while scanner.scanFloat(&value) {
            let number : NSNumber = NSNumber(float: value)
            array.append(number)
        }
        
        return array
    }
    
    class func parseTransform(str: String) -> CGAffineTransform {
        
        var transform : CGAffineTransform = CGAffineTransformIdentity
        
        if !str.isEmpty {
            transform = CGAffineTransformConcat(transform, parseMatrix(str))
            transform = CGAffineTransformConcat(transform, parseTranslate(str))
        }
        
        return transform
    }
    
    private class func parseMatrix(str: String) -> CGAffineTransform {
        
        var transform : CGAffineTransform = CGAffineTransformIdentity
        let range : NSRange = NSMakeRange(0, count(str))
        let patternMatrix : String = "matrix\\((.*)\\)"
        var regexError : NSError?
        
        let regexTranslate : NSRegularExpression = NSRegularExpression(pattern: patternMatrix, options: NSRegularExpressionOptions.CaseInsensitive, error: &regexError)!
        
        if regexError != nil {
            let matches : [AnyObject] = regexTranslate.matchesInString(str, options: NSMatchingOptions.WithoutAnchoringBounds, range: range)
            if !matches.isEmpty {
                let entry : NSTextCheckingResult = matches[0] as! NSTextCheckingResult
//                let parameters : String = str.substringWithRange(entry.rangeAtIndex(1))
                let parameters : String = "Replace me"
                let coordinates : [NSNumber] = SVGUtils.parsePoints(parameters)
                
                if coordinates.count == 6 {
                    transform = CGAffineTransformMake(CGFloat(coordinates[0].floatValue), CGFloat(coordinates[1].floatValue), CGFloat(coordinates[2].floatValue), CGFloat(coordinates[3].floatValue), CGFloat(coordinates[4].floatValue), CGFloat(coordinates[5].floatValue))
                }
            }
        }
        
        return transform
    }
    
    private class func parseTranslate(str: String) -> CGAffineTransform {
        var transform : CGAffineTransform = CGAffineTransformIdentity
        let range : NSRange = NSMakeRange(0, count(str))
        let patternTranslate : String = "translate\\((.*)\\)"
        var regexError : NSError?
        
        let regexTranslate : NSRegularExpression = NSRegularExpression(pattern: patternTranslate, options: NSRegularExpressionOptions.CaseInsensitive, error: &regexError)!
        
        if regexError != nil {
            let matches : [AnyObject] = regexTranslate.matchesInString(str, options: NSMatchingOptions.WithoutAnchoringBounds, range: range)
            if !matches.isEmpty {
                let entry : NSTextCheckingResult = matches[0] as! NSTextCheckingResult
//                let test : Range<String.Index> = entry.rangeAtIndex(1)
//                let parameters : String = str.substringWithRange(test)
                let parameters : String = "Replace me"
                let coordinates : [NSNumber] = SVGUtils.parsePoints(parameters)
                
                if coordinates.count == 2 {
                    transform = CGAffineTransformMakeTranslation(CGFloat(coordinates[0].floatValue), CGFloat(coordinates[1].floatValue))
                }
            }
        }
        
        return transform
    }
}
