//
//  GameOverScene.h
//  MyEggs
//
//  Created by khangfet on 4/25/14.
//  Copyright (c) 2014 5solution. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@import AVFoundation;
@interface GameOverScene : SKScene
{
    SKLabelNode *btnShareFb;
    int _currentScore;
     AVAudioPlayer *brackGroundSound;
}
- (id)initWithSize:(CGSize)size playerWon:(BOOL)isWon score:(int)_score;
@end
