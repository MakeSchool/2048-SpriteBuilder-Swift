//
//  Grid.swift
//  2048
//
//  Created by Dion Larson on 2/26/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

class Grid: CCNodeColor {
  let gridSize = 4
  let startTiles = 2
  
  var columnWidth: CGFloat = 0
  var columnHeight: CGFloat = 0
  var tileMarginVertical: CGFloat = 0
  var tileMarginHorizontal: CGFloat = 0
  
  var gridArray = [[Tile?]]()
  var noTile: Tile? = nil
  
  func didLoadFromCCB() {
    self.setupBackground()
    
    for i in 0..<gridSize {
      var column = [Tile?]()
      for j in 0..<gridSize {
        column.append(nil)
      }
      gridArray.append(column)
    }
    
    self.spawnStartTiles()
    
    self.setupGestures()
  }
  
  func setupBackground() {
    var tile: CCNode = CCBReader.load("Tile") as Tile
    
    columnWidth = tile.contentSize.width
    columnHeight = tile.contentSize.height
    
    tileMarginHorizontal = (self.contentSize.width - (CGFloat(gridSize) * columnWidth)) / CGFloat(gridSize + 1)
    tileMarginVertical = (self.contentSize.height - (CGFloat(gridSize) * columnHeight)) / CGFloat(gridSize + 1)
    
    var x = tileMarginHorizontal
    var y = tileMarginVertical
    
    for i in 0..<gridSize {
      x = tileMarginHorizontal
      for j in 0..<gridSize {
        var backgroundTile: CCNodeColor = CCNodeColor.nodeWithColor(CCColor.grayColor()) as CCNodeColor
        backgroundTile.contentSize = CGSize(width: columnWidth, height: columnHeight)
        backgroundTile.position = CGPoint(x: x, y: y)
        self.addChild(backgroundTile)
        x += columnWidth + tileMarginHorizontal
      }
      y += columnHeight + tileMarginVertical
    }
  }
  
  func addTileAtColumn(column: Int, row: Int) {
    var tile: Tile = CCBReader.load("Tile") as Tile
    gridArray[column][row] = tile
    tile.scale = 0
    self.addChild(tile)
    tile.position = self.positionForColumn(column, row: row)
    var delay = CCActionDelay.actionWithDuration(0.3) as CCActionDelay
    var scaleUp = CCActionScaleTo.actionWithDuration(0.2, scale: 1) as CCActionScaleTo
    var sequence = CCActionSequence.actionWithArray([delay, scaleUp]) as CCActionSequence
    tile.runAction(sequence)
  }
  
  func positionForColumn(column: Int, row: Int) -> CGPoint {
    var x = tileMarginHorizontal + CGFloat(column) * (tileMarginHorizontal + columnWidth)
    var y = tileMarginVertical + CGFloat(row) * (tileMarginVertical + columnHeight)
    return CGPoint(x: x, y: y)
  }
  
  func spawnStartTiles() {
    for i in 0..<startTiles {
      self.spawnRandomTile()
    }
  }
  
  func spawnRandomTile() {
    var spawned = false
    while !spawned {
      let randomRow = Int(CCRANDOM_0_1() * Float(gridSize))
      let randomColumn = Int(CCRANDOM_0_1() * Float(gridSize))
      let positionFree = gridArray[randomColumn][randomRow] == noTile
      if positionFree {
        self.addTileAtColumn(randomColumn, row: randomRow)
        spawned = true
      }
    }
  }
  
  func move(direction: CGPoint) {
    // apply negative vector until reaching boundary, this way we get the tile that is the furthest away
    // bottom left corner
    var currentX = 0
    var currentY = 0
    // Move to relevant edge by applying direction until reaching border
    while self.indexValid(currentX, y: currentY) {
      var newX = currentX + Int(direction.x)
      var newY = currentY + Int(direction.y)
      if self.indexValid(newX, y: newY) {
        currentX = newX
        currentY = newY
      } else {
        break
      }
    }
    // store initial row value to reset after completing each column
    var initialY = currentY
    // define changing of x and y value (moving left, up, down or right?)
    var xChange = Int(-direction.x)
    var yChange = Int(-direction.y)
    if xChange == 0 {
      xChange = 1
    }
    if yChange == 0 {
      yChange = 1
    }
    // visit column for column
    while self.indexValid(currentX, y: currentY) {
      while self.indexValid(currentX, y: currentY) {
        // get tile at current index
        var tile = gridArray[currentX][currentY]
        if let t = tile {
          // if tile is not nil
          var newX = currentX
          var newY = currentY
          // find the farthest position by iterating in direction of the vector until reaching boarding of 
          // grid or occupied cell
          while self.indexValidAndUnoccupied(newX+Int(direction.x), y: newY+Int(direction.y)) {
            newX += Int(direction.x)
            newY += Int(direction.y)
          }
          if newX != currentX || newY != currentY {
            self.moveTile(t, fromX: currentX, fromY: currentY, toX: newX, toY: newY)
          }
        }
        // move further in this column
        currentY += yChange
      }
      currentX += xChange
      currentY = initialY
    }
  }
  
  func indexValid(x: Int, y: Int) -> Bool {
    var indexValid = true
    indexValid &= x >= 0
    indexValid &= y >= 0
    if indexValid {
      indexValid &= x < Int(gridArray.count)
      if indexValid {
        indexValid &= y < Int(gridArray[x].count)
      }
    }
    return indexValid
  }
  
  func indexValidAndUnoccupied(x: Int, y: Int) -> Bool {
    var indexValid = self.indexValid(x, y: y)
    if !indexValid {
      return false
    }
    // unoccupied?
    return gridArray[x][y] == noTile
  }
  
  func moveTile(tile: Tile, fromX: Int, fromY: Int, toX: Int, toY: Int) {
    gridArray[toX][toY] = gridArray[fromX][fromY]
    gridArray[fromX][fromY] = noTile
    var newPosition = self.positionForColumn(toX, row: toY)
    var moveTo = CCActionMoveTo.actionWithDuration(0.2, position: newPosition) as CCActionMoveTo
    tile.runAction(moveTo)
  }
  
  func setupGestures() {
    var swipeLeft = UISwipeGestureRecognizer(target: self, action: "swipeLeft") as UISwipeGestureRecognizer
    swipeLeft.direction = .Left
    CCDirector.sharedDirector().view.addGestureRecognizer(swipeLeft)
    
    var swipeRight = UISwipeGestureRecognizer(target: self, action: "swipeRight") as UISwipeGestureRecognizer
    swipeRight.direction = .Right
    CCDirector.sharedDirector().view.addGestureRecognizer(swipeRight)
    
    var swipeUp = UISwipeGestureRecognizer(target: self, action: "swipeUp") as UISwipeGestureRecognizer
    swipeUp.direction = .Up
    CCDirector.sharedDirector().view.addGestureRecognizer(swipeUp)
    
    var swipeDown = UISwipeGestureRecognizer(target: self, action: "swipeDown") as UISwipeGestureRecognizer
    swipeDown.direction = .Down
    CCDirector.sharedDirector().view.addGestureRecognizer(swipeDown)
  }
  
  func swipeLeft() {
    self.move(CGPoint(x: -1, y: 0))
  }
  
  func swipeRight() {
    self.move(CGPoint(x: 1, y: 0))
  }
  
  func swipeUp() {
    self.move(CGPoint(x: 0, y: 1))
  }
  
  func swipeDown() {
    self.move(CGPoint(x: 0, y: -1))
  }
  
}
