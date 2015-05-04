//
//  GeoFencingTutorialTests.swift
//  GeoFencingTutorialTests
//
//  Created by Downey on 4/28/15.
//  Copyright (c) 2015 Downey. All rights reserved.
//

import UIKit
import Quick
import Nimble

class GeoFencingTutorialTests: QuickSpec {
    
    override func setUp() {
        println("I'm run BEFORE every test.")
    }
    
    override func tearDown() {
        println("I'm run AFTER every test.")
    }
    
    override func spec() {
        describe("The first test") {
            it("should be true") {
                expect(true).to(beTrue())
            }
            
            it("should be false") {
                expect(false).to(beFalse())
            }
        }
    }
}