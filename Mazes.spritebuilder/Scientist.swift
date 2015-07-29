//
//  Scientist.swift
//  Mazes
//
//  Created by Andrew Brandt on 7/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

protocol ScientistDelegate {
    
    func scientistDidFinish()
    
}

class Scientist {

    var grid: Grid!
    
    var delegate: ScientistDelegate!
    
    func runRandomDepthAnalysis() {
    
    }
    
}
