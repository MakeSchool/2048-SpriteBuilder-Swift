//
//  Tile.swift
//  Make2048
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
      updateColor()
    }
  }
  var mergedThisRound = false
  
  func didLoadFromCCB() {
    value = Int(CCRANDOM_MINUS1_1() + 2) * 2
  }
  
  func updateColor() {
    var backgroundColor: CCColor
    
    switch value {
    case 2:
      backgroundColor = CCColor(red: 20.0/255, green: 20.0/255, blue: 80.0/255)
      break
    case 4:
      backgroundColor = CCColor(red: 20.0/255, green: 20.0/255, blue: 140.0/255)
      break
    case 8:
      backgroundColor = CCColor(red:20.0/255, green:60.0/255, blue:220.0/255)
      break
    case 16:
      backgroundColor = CCColor(red:20.0/255, green:120.0/255, blue:120.0/255)
      break
    case 32:
      backgroundColor = CCColor(red:20.0/255, green:160.0/255, blue:120.0/255)
      break
    case 64:
      backgroundColor = CCColor(red:20.0/255, green:160.0/255, blue:60.0/255)
      break
    case 128:
      backgroundColor = CCColor(red:50.0/255, green:160.0/255, blue:60.0/255)
      break
    case 256:
      backgroundColor = CCColor(red:80.0/255, green:120.0/255, blue:60.0/255)
      break
    case 512:
      backgroundColor = CCColor(red:140.0/255, green:70.0/255, blue:60.0/255)
      break
    case 1024:
      backgroundColor = CCColor(red:170.0/255, green:30.0/255, blue:60.0/255)
      break
    case 2048:
      backgroundColor = CCColor(red:220.0/255, green:30.0/255, blue:30.0/255)
      break
    default:
      backgroundColor = CCColor.greenColor()
      break
    }
    
    backgroundNode.color = backgroundColor
  }
}
