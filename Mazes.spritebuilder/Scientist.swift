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

class NTree<T> {
    var children: [NTree<T>] = []
    var value: T
    
    init(element: T) {
        value = element
    }
}

class Scientist {

    var grid: Grid!
    
    var delegate: ScientistDelegate!
    
    var flatTree: [Coordinate] = []
    
    func startRandomDepthAnalysis() {
        
        let coord = Coordinate.pickRandomCellCoordinate()
        //var rootNode = NTree<Coordinate>(element: coord)
        
        let rootNode = recursivelyBuildTree(coord, parent: nil)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { (Void) in
            self.recursivelyWalkTree(rootNode, depth: 0, flatten: false)
            //self.walkFlattenedTree()
            
            dispatch_async(dispatch_get_main_queue(), { (Void) in
                if let delegate = self.delegate {
                    delegate.scientistDidFinish()
                }
            })
            
        })
    }
    
    func startCustomDepthAnalysisAtCoordinate(coordinate: Coordinate) {
        let rootNode = recursivelyBuildTree(coordinate, parent: nil)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { (Void) in
            self.recursivelyWalkTree(rootNode, depth: 0, flatten: false)
            //self.walkFlattenedTree()
            
            dispatch_async(dispatch_get_main_queue(), { (Void) in
                if let delegate = self.delegate {
                    delegate.scientistDidFinish()
                }
            })
            
        })
    }
    
    func runDepthAnalysisAtCoordinate(coordinate: Coordinate) {
        let rootNode = recursivelyBuildTree(coordinate, parent: nil)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { (Void) in
            self.recursivelyWalkTree(rootNode, depth: 0, flatten: false)
            //self.walkFlattenedTree()
            
            dispatch_async(dispatch_get_main_queue(), { (Void) in
                if let delegate = self.delegate {
                    delegate.scientistDidFinish()
                }
            })
            
        })
    }
    
    func recursivelyBuildTree(current: Coordinate, parent: Coordinate?) -> NTree<Coordinate> {
        var node = NTree<Coordinate>(element: current)
        //var children: [NTree<Coordinate>]() = []
        
        let coord = current
        let tile = grid.tileAtCoordinate(coord)
        let directions = tile.connectedDirections
        
        for direction in directions {
            let dest = coord.coordinateOffsetByDirection(direction)
            var child: NTree<Coordinate>?
            if let parent = parent {
                if parent != dest {
                    child = recursivelyBuildTree(dest, parent: current)
                }
            } else {
                child = recursivelyBuildTree(dest, parent: current)
            }
            if let child = child {
                node.children.append(child)
            }
        }
        
        return node
    }
    
    func recursivelyWalkTree(node: NTree<Coordinate>, depth: Int, flatten: Bool) {
        let coord = node.value
        let tile = grid.tileAtCoordinate(coord)
        if flatten {
            flatTree.append(coord)
        } else {
            let const = Float(1.0 - Double(depth)*0.03)
            tile.background.color = CCColor(red: 0.6, green: const, blue: const)
        }
        NSThread.sleepForTimeInterval(SLEEP_TIME)
        for child in node.children {
            recursivelyWalkTree(child, depth: depth+1, flatten: flatten)
        }
    }
    
    func walkFlattenedTree() {
        for coord in flatTree {
            let tile = grid.tileAtCoordinate(coord)
            tile.background.color = CCColor.greenColor()
            NSThread.sleepForTimeInterval(SLEEP_TIME)
        }
    }
    
}
