//
//  StartGameLayer.h
//  MyEggs
//
//  Created by khangfet on 4/25/14.
//  Copyright (c) 2014 5solution. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameLayerHelper.h"
typedef NS_ENUM(NSUInteger, StartGameLayerButtonType)
{
    StartGameLayerPlayButton = 0
};


@protocol StartGameLayerDelegate;
@interface StartGameLayer : GameLayerHelper
{
    SKLabelNode *  btnRate;
}
@property (nonatomic, assign) id<StartGameLayerDelegate> delegate;
@end


//**********************************************************************
@protocol StartGameLayerDelegate <NSObject>
@optional

- (void) startGameLayer:(StartGameLayer*)sender tapRecognizedOnButton:(StartGameLayerButtonType) startGameLayerButton;
@end