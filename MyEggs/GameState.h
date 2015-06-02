//
//  GameState.h
//  MyEggs
//
//  Created by khangfet on 4/25/14.
//  Copyright (c) 2014 5solution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameState : NSObject

@property (nonatomic, assign) int score;
@property (nonatomic, assign) int highScore;
+ (instancetype)sharedInstance;
- (void) saveState;
@end
