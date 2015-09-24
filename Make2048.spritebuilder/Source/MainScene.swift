//
//  MainScene.swift
//  Make2048
//
//  Created by Dion Larson on 2/26/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import UIKit

class MainScene: CCNode {
  weak var grid: Grid!
  weak var scoreLabel: CCLabelTTF!
  weak var highscoreLabel: CCLabelTTF!
  
  func didLoadFromCCB() {
    NSUserDefaults.standardUserDefaults().addObserver(self, forKeyPath: "highscore", options: [], context: nil)
    updateHighscore()
  }
  
  func updateHighscore() {
    let newHighscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
    highscoreLabel.string = "\(newHighscore)"
  }
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    if keyPath == "highscore" {
      updateHighscore()
    }
  }
}
