//
//  MainScene.swift
//  Mazes
//
//  Created by Andrew Brandt on 7/13/15.
//  Copyright (c) 2015 Dory Studios. All rights reserved.
//

import Foundation

class MainScene: CCNode, VisitorDelegate, ScientistDelegate {
    
    weak var grid: Grid!
    
    var visitor = Visitor()
    var scientist = Scientist()
    
    var isBusy: Bool = false
    
    override func onEnter() {
        //let tile = CCBReader.load("Tile") as! Tile
        
        //tile.position = ccp(200,200)
        
        //tile.top.visible = false
        
        //grid.addChild(tile)
        
        grid.generate()
        
        visitor.delegate = self
        visitor.grid = grid
        
        scientist.delegate = self
        scientist.grid = grid
        
        //let visitor = Visitor()
        
        //visitor.transformGrid(grid, toMazeType: .BinaryTree)
        
    }
    
    func startBinaryTree() {
        
        if !isBusy {
            grid.reset()
            isBusy = true
            visitor.transformGridToMazeType(.BinaryTree)
        }
    }
    
    func startSidewinder() {
        
        if !isBusy {
            grid.reset()
            isBusy = true
            visitor.transformGridToMazeType(.Sidewinder)
        }
    }
    
    func startAldousBroder() {
        
        if !isBusy {
            grid.reset()
            isBusy = true
            visitor.transformGridToMazeType(.AldousBroder)
        }
    }
    
    func startWilson() {
        
        if !isBusy {
            grid.reset()
            isBusy = true
            visitor.transformGridToMazeType(.Wilson)
        }
    }
    
    func runRandomDepthAnalysis() {
        
        if !isBusy {
            
            isBusy = true
            scientist.startRandomDepthAnalysis()
            
        }
    }
    
    func runCustomDepthAnalysis() {
        
        if !isBusy {
        
            isBusy = true
            
            scientist.startCustomDepthAnalysisAtCoordinate(Coordinate(row: 1,column: 1))
        }
    }
    
    //MARK: - VisitorDelegate methods
    
    func visitorDidFinish() {
        isBusy = false
    }
    
    //MARK: - ScientistDelegate methods
    
    func scientistDidFinish() {
        isBusy = false
    }
}
