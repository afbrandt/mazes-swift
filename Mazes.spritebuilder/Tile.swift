//
//  Tile.swift
//  Mazes
//
//  Created by Andrew Brandt on 7/13/15.
//  Copyright (c) 2015 Dory Studios. All rights reserved.
//

import UIKit

class Tile: CCNode {
    weak var left: CCNodeColor!
    weak var right: CCNodeColor!
    weak var top: CCNodeColor!
    weak var bottom: CCNodeColor!
    weak var background: CCNodeColor!
    
    var visited: Bool = false
    var coordinate: Coordinate = Coordinate(row: -1,column: -1)
    
    var connectedDirections: Set<Direction> = Set<Direction>()
    
    func connectInDirection(direction: Direction) {
        switch(direction) {
            case .North:
                connectedDirections.insert(.North)
                top.visible = false
            case .South:
                connectedDirections.insert(.South)
                bottom.visible = false
            case .East:
                connectedDirections.insert(.East)
                right.visible = false
            case .West:
                connectedDirections.insert(.West)
                left.visible = false
        }
    }
    
    func disconnectInDirection(direction: Direction) {
        switch(direction) {
            case .North:
                connectedDirections.remove(.North)
                top.visible = true
            case .South:
                connectedDirections.remove(.South)
                bottom.visible = true
            case .East:
                connectedDirections.remove(.East)
                right.visible = true
            case .West:
                connectedDirections.remove(.West)
                left.visible = true
        }
    }
}
