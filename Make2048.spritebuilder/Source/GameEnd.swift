//
//  GameEnd.swift
//  Make2048
//
//  Created by Dion Larson on 3/25/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class GameEnd: CCNode {
  weak var messageLabel: CCLabelTTF!
  weak var scoreLabel: CCLabelTTF!
  
  func newGame() {
    var mainScene = CCBReader.loadAsScene("MainScene")
    CCDirector.sharedDirector().presentScene(mainScene)
  }
  
  func setMessage(message: String, score: Int) {
    messageLabel.string = message
    scoreLabel.string = "\(score)"
  }
}
