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
  var value: Int = Int(CCRANDOM_0_1() + 1) * 2 {
    didSet {
      self.updateValueDisplay()
    }
  }
  var placeholder = false
  
  func didLoadFromCCB() {
    self.updateValueDisplay()
  }
  
  func updateValueDisplay() {
    valueLabel.string = "\(value)"
  }
}
