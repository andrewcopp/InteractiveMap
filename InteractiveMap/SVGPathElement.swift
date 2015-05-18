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
    
    init(attributes : [NSObject: AnyObject]) {
        super.init()
    }
}
