//
//  Tile.swift
//  2048
//
//  Created by Dion Larson on 2/26/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

class Tile: CCNode {
  var valueLabel: CCLabelTTF!
  var backgroundNode: CCNodeColor!
  var value: Int = 0 {
    didSet {
      valueLabel.string = "\(value)"
    }
  }
  var mergedThisRound = false
  
  func didLoadFromCCB() {
    value = Int(CCRANDOM_MINUS1_1() + 2) * 2
  }
}
