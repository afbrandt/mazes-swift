//
//  MainScene.swift
//  Mazes
//
//  Created by Andrew Brandt on 7/13/15.
//  Copyright (c) 2015 Dory Studios. All rights reserved.
//

import Foundation

class MainScene: CCNode {
    
    weak var grid: Grid!
    
    var visitor = Visitor()
    
    override func onEnter() {
        //let tile = CCBReader.load("Tile") as! Tile
        
        //tile.position = ccp(200,200)
        
        //tile.top.visible = false
        
        //grid.addChild(tile)
        
        grid.generate()
        
        visitor.grid = grid
        
        //let visitor = Visitor()
        
        //visitor.transformGrid(grid, toMazeType: .BinaryTree)
        
    }
    
    func startBinaryTree() {
        
        grid.reset()
        
        visitor.transformGridToMazeType(.BinaryTree)
    }
    
    func startSidewinder() {
        
        grid.reset()
        
        visitor.transformGridToMazeType(.Sidewinder)
    }
    
    func startAldousBroder() {
        
        grid.reset()
        
        visitor.transformGridToMazeType(.AldousBroder)
    }
    
    func startWilson() {
        
        grid.reset()
        
        visitor.transformGridToMazeType(.Wilson)
    }
}
