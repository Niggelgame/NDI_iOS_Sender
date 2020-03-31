//
//  screen.swift
//  NDI_New_Tests
//
//  Created by Nicolas on 29.03.20.
//  Copyright © 2020 Kedil. All rights reserved.
//

import Foundation

@objc class Screen : NSObject {
    
    var youstink = "You stink";
    
    override init() {
        super.init()
        print("Screen: { init }")
    }
    
    func sayHello() -> Void {
        print("Hello");
    }
    
    
    
    func buildOverlay(name:String) -> String {
        let returnVal = "You sent me \(name)";
        return returnVal;
    }
}
