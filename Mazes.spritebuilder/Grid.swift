//
//  Grid.swift
//  Mazes
//
//  Created by Andrew Brandt on 7/13/15.
//  Copyright (c) 2015 Dory Studios. All rights reserved.
//

let GRID_SIZE = 10

enum Direction {
    case North, South, East, West
    
    func oppositeDirection() -> Direction {
        switch (self) {
            case .North: return .South
            case .South: return .North
            case .East: return .West
            case .West: return .East
        }
    }
    
    static func allDirections() -> [Direction] {
        return [.North, .South, .East, .West]
    }
    
    static func randomDirection() -> Direction {
        let all = allDirections()
        let index = Int(CCRANDOM_0_1()*Float(all.count)-0.001)
        return all[index]
    }
}

enum MazeType {
    case BinaryTree, Sidewinder, AldousBroder, Wilson
}

struct Coordinate: Equatable {
    var row: Int = 0
    var column: Int = 0
    
    func coordinateOffsetByDirection(direction: Direction) -> Coordinate{
        switch direction {
            case .North:
            return Coordinate(row:self.row+1, column:self.column)
            case .South:
            return Coordinate(row:self.row-1, column:self.column)
            case .East:
            return Coordinate(row:self.row, column:self.column+1)
            case .West:
            return Coordinate(row:self.row, column:self.column-1)
        }
    }
    
    static func pickRandomCellCoordinate() -> Coordinate {
        let row = Int(CCRANDOM_0_1()*Float(GRID_SIZE))
        let column = Int(CCRANDOM_0_1()*Float(GRID_SIZE))
        let coordinate = Coordinate(row: row,column: column)
        return coordinate
    }
}

infix operator ->> {}

//Create a new operator that returns the Direction required to travel from Coordinate a to Coordinate b
func ->> (a: Coordinate, b: Coordinate) -> Direction {
    let aRow = a.row
    let aColumn = a.column
    
    let bRow = b.row
    let bColumn = b.column
    
    var direction: Direction!
    
    if aRow == bRow {
        if aColumn > bColumn {
            direction = .West
        } else {
            direction = .East
        }
    } else if aRow > bRow {
        direction = .South
    } else {
        direction = .North
    }
    
    return direction
}

func ==(a: Coordinate, b: Coordinate) -> Bool {
    return a.row == b.row && a.column == b.column
}

class Grid: CCNode {

    var tiles: [[Tile]] = [[Tile]](count: GRID_SIZE, repeatedValue: [Tile](count: GRID_SIZE, repeatedValue: Tile()))
    
    func generate() {
        let row = CCLayoutBox()
        let sizeGuide = CCBReader.load("Tile") as! Tile
        row.direction = .Horizontal
        row.spacing = 30.0
        
        for i in 0..<GRID_SIZE {
            let column = CCLayoutBox()
            column.direction = .Vertical
            column.spacing = 30.0
            
            for j in 0..<GRID_SIZE {
                
                let tile = CCBReader.load("Tile") as! Tile
                column.addChild(tile)
                println("added to column")
                //Verify row/columns are correct
//                if j == 5 && i == 8 {
//                    tile.top.visible = false
//                    tile.bottom.visible = false
//                }
                //i = column, j = row
                tile.coordinate = Coordinate(row: j, column: i)
                tiles[i][j] = tile
                //column.layout()
            }
            
            println("added to row")
            row.addChild(column)
            //row.layout()
        }
        addChild(row)
    }
    
    func reset() {
        for i in 0..<GRID_SIZE {
            for j in 0..<GRID_SIZE {
                disconnectTileAtCoordinate(Coordinate(row: i,column: j))
            }
        }
    }
    
    func tileAtCoordinate(coordinate: Coordinate) -> Tile {
        return tiles[coordinate.column][coordinate.row]
    }
    
    func tileConnectionsFromCoordinate(coordinate: Coordinate) -> [Direction] {
        let tile = tiles[coordinate.column][coordinate.row]
        
        return Array(tile.connectedDirections)
    }
    
    func hasTileAtCoordinate(coordinate: Coordinate, attachedInDirection direction: Direction) -> Bool {
        switch (direction) {
            case .North:
                return coordinate.row < GRID_SIZE-1
            case .South:
                return coordinate.row > 0
            case .East:
                return coordinate.column < GRID_SIZE-1
            case .West:
                return coordinate.column > 0
        }
    }
    
    func tileAtCoordinate(coordinate: Coordinate, attachedInDirection direction: Direction) -> Tile? {
        var tile: Tile?
        switch (direction) {
        case .North:
            if hasTileAtCoordinate(coordinate, attachedInDirection: direction) {
                tile = tiles[coordinate.column][coordinate.row+1]
            }
        case .South:
            if hasTileAtCoordinate(coordinate, attachedInDirection: direction) {
                tile = tiles[coordinate.column][coordinate.row-1]
            }
        case .East:
            if hasTileAtCoordinate(coordinate, attachedInDirection: direction) {
                tile = tiles[coordinate.column+1][coordinate.row]
            }
        case .West:
            if hasTileAtCoordinate(coordinate, attachedInDirection: direction) {
                tile = tiles[coordinate.column-1][coordinate.row]
            }
        }
        return tile
    }
    
    //this should be improved by returning a status signifying successful connection
    func connectTileAtCoordinate(coordinate: Coordinate, inDirection direction: Direction) {
        let origin = tileAtCoordinate(coordinate)
        let terminus = tileAtCoordinate(coordinate, attachedInDirection: direction)
        origin.connectInDirection(direction)
        terminus?.connectInDirection(direction.oppositeDirection())
        let dir = direction == .North ? "North" : "East"
        //println("Coordinate row: \(coordinate.row) and column: \(coordinate.column) and \(dir)")
    }
    
    func disconnectTileAtCoordinate(coordinate: Coordinate) {
        let compass = Direction.allDirections()
        
        for direction in compass {
            let tile = tileAtCoordinate(coordinate)
            if let connectedTile = tileAtCoordinate(coordinate, attachedInDirection: direction) {
                tile.disconnectInDirection(direction)
                tile.visited = false
                tile.background.color = CCColor(red: 54/255, green: 166/255, blue: 222/255)
                connectedTile.disconnectInDirection(direction.oppositeDirection())
            }
        }
    }
    
    func hasUnvisitedTiles() -> Bool {
        var count = 0
        for i in 0..<GRID_SIZE {
            for j in 0..<GRID_SIZE {
                let tile = tileAtCoordinate(Coordinate(row: i,column: j))
                count++
                if !tile.visited {
                    println("found unvisited tile after \(count) tiles")
                    return true
                }
            }
        }
        return false
    }
    
}
