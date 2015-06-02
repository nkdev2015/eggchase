//
//  MyScene.h
//  MyEggs
//

//  Copyright (c) 2014 5solution. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "StartGameLayer.h"
@import AVFoundation;
@interface MyScene : SKScene<SKPhysicsContactDelegate,StartGameLayerDelegate>
{
    int lostEgg;
    int point;
    int wrongEgg;
    // Chicken
    SKSpriteNode * chicken1;
    SKSpriteNode * chicken2;
    SKSpriteNode * chicken3;
    SKSpriteNode * chicken4;
    SKSpriteNode * chicken5;
    // Point
    
    CGPoint point1;
    CGPoint point2;
    CGPoint point3;
    CGPoint point4;
    CGPoint point5;
    
    //lbl
    SKLabelNode *lblScoreTitle;
    SKLabelNode *lblBestScoreTitle;
    //
    SKSpriteNode * live;
    int _highScore;
    
    StartGameLayer* _startGameLayer;
    BOOL _gameStarted;
    BOOL _gameOver;
    
    AVAudioPlayer *eggSound1;
    AVAudioPlayer *eggSound2;
    AVAudioPlayer *eggSound3;
    AVAudioPlayer *eggSound4;
    AVAudioPlayer *eggSound5;
    AVAudioPlayer *eggBrown;
    AVAudioPlayer *eggBreakSound;
    AVAudioPlayer *eggFall;
    AVAudioPlayer *brackGroundSound;
    AVAudioPlayer *bonusSound;
    AVAudioPlayer *sitFall;
    AVAudioPlayer *chicken;
    
    int display_Chiken;
}
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@end
