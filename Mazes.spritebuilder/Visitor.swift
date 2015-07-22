//
//  Visitor.swift
//  Mazes
//
//  Created by Andrew Brandt on 7/14/15.
//  Copyright (c) 2015 Dory Studios. All rights reserved.
//

//delay in seconds for intervals between connections
let SLEEP_TIME = 0.15

protocol VisitorDelegate {

    func visitorDidFinish()
}

class Visitor: CCNode {
    
    var grid: Grid!
    var runSpeed: UInt32 = 1
    var delegate: VisitorDelegate?
    
    func transformGridToMazeType(type:MazeType) {
        //self.grid = grid
        //grid.connectTileAtCoordinate(Coordinate(row: 1,column: 1), inDirection: .North)
        
        srandom(UInt32(time(nil)))
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            switch (type) {
            case .BinaryTree:
            self.runBinaryTreeMaze()
            case .Sidewinder:
            self.runSidewinderMaze()
            case .AldousBroder:
            self.runAldousBroderMaze()
            case .Wilson:
            self.runWilsonMaze()
        }
        })
    }
    
    func pickRandomCellCoordinate() -> Coordinate {
        let row = Int(CCRANDOM_0_1()*Float(GRID_SIZE))
        let column = Int(CCRANDOM_0_1()*Float(GRID_SIZE))
        let coordinate = Coordinate(row: row,column: column)
        return coordinate
    }
    
    func runBinaryTreeMaze() {
        for i in 0..<GRID_SIZE {
            for  j in 0..<GRID_SIZE {
                var direction: Direction
                if j == GRID_SIZE-1 && i == GRID_SIZE-1 {
                    //end condition
                    grid.tileAtCoordinate(Coordinate(row: i,column: j)).background.color = CCColor.yellowColor()
                    break;
                } else if j == GRID_SIZE-1 {
                    //rightmost column
                    direction = .North
                } else if i == GRID_SIZE-1 {
                    //top row
                    direction = .East
                } else if CCRANDOM_0_1() > 0.5 {
                    direction = .North
                } else {
                    direction = .East
                }
                //dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let coordinate = Coordinate(row: i,column: j)
                grid.tileAtCoordinate(coordinate).background.color = CCColor.yellowColor()
                grid.connectTileAtCoordinate(coordinate, inDirection: direction)
                //integers only, would like to sleep for <1 second
                //wait(SLEEP_TIME)
                NSThread.sleepForTimeInterval(SLEEP_TIME)
                grid.tileAtCoordinate(coordinate).background.color = CCColor.lightGrayColor()
            }
        }
        
        if let delegate = delegate {
            delegate.visitorDidFinish()
        }
    }
    
    func runSidewinderMaze() {
        var coordinates = [Coordinate]()
        
        for i in 0..<GRID_SIZE {
            for  j in 0..<GRID_SIZE {
                var sidewind = false
                let coordinate = Coordinate(row: i,column: j)
                coordinates.append(coordinate)
                if j == GRID_SIZE-1 && i == GRID_SIZE-1 {
                    //end condition
                    grid.tileAtCoordinate(coordinate).background.color = CCColor.yellowColor()
                    break;
                } else if j == GRID_SIZE-1 {
                    //rightmost column
                    sidewind = true
                } else if i == GRID_SIZE-1 {
                    //top row
                    //dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.grid.connectTileAtCoordinate(coordinate, inDirection: .East)
                        self.grid.tileAtCoordinate(coordinate).background.color = CCColor.yellowColor()
                        NSThread.sleepForTimeInterval(SLEEP_TIME)
                        self.grid.tileAtCoordinate(coordinate).background.color = CCColor.grayColor()
                    //})
                } else if CCRANDOM_0_1() > 0.5 {
                    //coordinates.append(coordinate)
                    //rendering pipeline does not appreciate dispatch_async to main apparently
                    //dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.grid.connectTileAtCoordinate(coordinate, inDirection: .East)
                    self.grid.tileAtCoordinate(coordinate).background.color = CCColor.yellowColor()
                    NSThread.sleepForTimeInterval(SLEEP_TIME)
                    self.grid.tileAtCoordinate(coordinate).background.color = CCColor.grayColor()
                    //})
                } else {
                    sidewind = true
                }
                if sidewind {
                    let r = Int(CCRANDOM_0_1()*Float(coordinates.count))
                    
                    grid.tileAtCoordinate(coordinate).background.color = CCColor.yellowColor()
                    NSThread.sleepForTimeInterval(SLEEP_TIME)
                    grid.tileAtCoordinate(coordinate).background.color = CCColor.grayColor()
                    
                    let coordinate = coordinates[Int(r)]
                    //rendering pipeline does not appreciate dispatch_async to main apparently
                    //dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.grid.connectTileAtCoordinate(coordinate, inDirection: .North)
                    //})
                    coordinates.removeAll(keepCapacity: true)
                    grid.tileAtCoordinate(coordinate).background.color = CCColor.yellowColor()
                    NSThread.sleepForTimeInterval(SLEEP_TIME)
                    grid.tileAtCoordinate(coordinate).background.color = CCColor.grayColor()
                    //coordinates.append(coordinate)
                }
                //sleep(runSpeed)
            }
        }
        
        if let delegate = delegate {
            delegate.visitorDidFinish()
        }
    }
    
    //random walk maze
    func runAldousBroderMaze() {
    
        //pick random cell to start
        var coordinate = pickRandomCellCoordinate()
        
        var uniqueCells = GRID_SIZE*GRID_SIZE - 1
        
        while uniqueCells > 0 {
        
            var direction = Direction.randomDirection()
            
            //Find a valid tile in a random direction
            while !grid.hasTileAtCoordinate(coordinate, attachedInDirection: direction) {
                direction = Direction.randomDirection()
            }
            
            let tile = grid.tileAtCoordinate(coordinate)
            
            //If tile has no connection, make one
            if grid.tileAtCoordinate(coordinate, attachedInDirection: direction)!.connectedDirections.count == 0 {
                uniqueCells--
                
                if uniqueCells % 10 == 0 {
                    println("\(uniqueCells) cells remaining")
                }
                //tile.connectInDirection(direction)
                grid.connectTileAtCoordinate(coordinate, inDirection: direction)
                
                //if tile.connectedDirections.count == 0 {
                    //tile.connectInDirection(direction.oppositeDirection())
                    //coordinate = coordinate.coordinateOffsetByDirection(direction.oppositeDirection())
                //}
                //sleep(SLEEP_TIME)
            }
            
            grid.tileAtCoordinate(coordinate).background.color = CCColor.grayColor()
            coordinate = coordinate.coordinateOffsetByDirection(direction)
            grid.tileAtCoordinate(coordinate).background.color = CCColor.yellowColor()
            NSThread.sleepForTimeInterval(SLEEP_TIME/2)
        }
        
        if let delegate = delegate {
            delegate.visitorDidFinish()
        }
    }
    
    //loop-erase maze
    func runWilsonMaze() {
        
        //pick random cell and mark visited
        var coordinate = pickRandomCellCoordinate()
        var tile = grid.tileAtCoordinate(coordinate)
        tile.visited = true
        tile.background.color = CCColor.redColor()
        
        var walk: [Coordinate] = []
        
        //continue to build maze until all tiles have been visited
        while grid.hasUnvisitedTiles() {
            
            //first loop builds walk
            coordinate = pickRandomCellCoordinate()
            var direction: Direction!
            
            //build walk until visited tile encountered
            while !grid.tileAtCoordinate(coordinate).visited {
                
                //remove loops encountered in walk
                if let dup = find(walk, coordinate) {
                    walk.removeRange((dup+1)..<walk.count)
                } else {
                    walk.append(coordinate)
                }
                
                //randomly choose direction to walk
                do {
                    direction = Direction.randomDirection()
                } while (!grid.hasTileAtCoordinate(coordinate, attachedInDirection: direction))
                
                coordinate =  coordinate.coordinateOffsetByDirection(direction)
            }
            
            //walk.append(coordinate)
        
            println("building walk of length \(walk.count)")
            
            //second loop carves maze path
            for var i = 0; i < walk.count; i++ {
                let origin = walk[i]
                var terminus: Coordinate!
                if i == walk.count-1 {
                    terminus = coordinate
                } else {
                    terminus = walk[i+1]
                }
                //custom infix operator to determine direction between coordinates
                let direction = origin ->> terminus
                let tile = grid.tileAtCoordinate(origin)
                
                grid.connectTileAtCoordinate(origin, inDirection: direction)
                tile.background.color = CCColor.yellowColor()
                tile.visited = true
                NSThread.sleepForTimeInterval(SLEEP_TIME)
                tile.background.color = CCColor.grayColor()
                //sleep(SLEEP_TIME)
            }
            //start new walk
            walk.removeAll(keepCapacity: true)
            
        }
        
        if let delegate = delegate {
            delegate.visitorDidFinish()
        }
        
    }
}
