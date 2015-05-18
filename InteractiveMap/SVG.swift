//
//  SVG.swift
//  InteractiveMap
//
//  Created by Andrew Copp on 5/18/15.
//  Copyright (c) 2015 Andrew Copp. All rights reserved.
//

import UIKit

class SVG: NSObject, NSXMLParserDelegate {
   
    var paths : [SVGPathElement]?
    var bounds : CGRect?
    private var transforms : [String]?
    private var currentTransform : CGAffineTransform?
    
    class func svgWithFile(filePath: String) -> SVG {
        return SVG(filename: filePath)
    }
    
    init(filename: String) {
        
        let data : NSData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource(filename, ofType: "svg")!)!
        let parser = NSXMLParser(data: data)
        
        super.init()
        
        parser.delegate = self
        parser.parse()
        self.computeBounds()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        if elementName == "path" {
            var element : SVGPathElement = SVGPathElement(attributes: attributeDict)
            if element.path != nil {
                paths?.append(element)
            }
            
            var t : CGAffineTransform = currentTransform!
            
            if attributeDict["transform"] != nil {
                let pathTransform : CGAffineTransform = SVGUtils.parseTransform(attributeDict["transform"] as! String)
                t = CGAffineTransformConcat(pathTransform, currentTransform!)
            }
            
            element.path?.applyTransform(t)
            
        } else if elementName == "g" {
            var t : CGAffineTransform = CGAffineTransformIdentity
            
            if attributeDict["transform"] != nil {
                t = SVGUtils.parseTransform(attributeDict["transform"] as! String)
            }
            
            currentTransform = CGAffineTransformConcat(t, currentTransform!)
            transforms?.append(NSStringFromCGAffineTransform(currentTransform!)
)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "g" {
            transforms?.removeLast()
            
            if transforms?.count > 0 {
                currentTransform = CGAffineTransformFromString(transforms?.last)
            } else {
                currentTransform = CGAffineTransformIdentity
            }
        }
    }
    
    func computeBounds() {
        bounds?.origin.x = CGFloat(MAXFLOAT)
        bounds?.origin.y = CGFloat(MAXFLOAT)
        var maxx = -CGFloat(MAXFLOAT)
        var maxy = -CGFloat(MAXFLOAT)
        
        for path in paths! {
            let b : CGRect = CGPathGetBoundingBox(path.path?.CGPath)
            
            if b.origin.x < bounds?.origin.x {
                bounds!.origin.x = b.origin.x
            }
            
            if b.origin.y < bounds!.origin.y {
                bounds!.origin.y = b.origin.y
            }
            
            if b.origin.x + b.size.width > maxx {
                maxx = b.origin.x + b.size.width
            }
            
            if b.origin.y + b.size.width > maxy {
                maxy = b.origin.y + b.size.width
            }
        }
        
        bounds!.size.width = maxx - bounds!.origin.x
        bounds!.size.height = maxy - bounds!.origin.y
    }
}
