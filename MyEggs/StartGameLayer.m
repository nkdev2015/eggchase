//
//  StartGameLayer.m
//  MyEggs
//
//  Created by khangfet on 4/25/14.
//  Copyright (c) 2014 5solution. All rights reserved.
//

#import "StartGameLayer.h"
@interface StartGameLayer()
@property (nonatomic, retain) SKSpriteNode* playButton;
@property (nonatomic, retain) SKSpriteNode* rateButton;
@end

static NSString* IOS7_APP_STORE_URL = @"https://itunes.apple.com/us/app/egg-chase-pro/id870310951?ls=1&mt=8";
static NSString* YOUR_APP_STORE_ID = @"870310951";

@implementation StartGameLayer

- (id)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        /*
        SKSpriteNode* startGameText = [SKSpriteNode spriteNodeWithImageNamed:@"FlappyBirdText"];
        startGameText.position = CGPointMake(size.width * 0.5f, size.height * 0.8f);
        startGameText.zPosition = 130;
        [self addChild:startGameText];
         */
        
        SKSpriteNode* playButton = [SKSpriteNode spriteNodeWithImageNamed:@"TabAndHold"];
        playButton.position = CGPointMake(size.width * 0.5f, size.height * 0.27f);
        playButton.zPosition = 130;
        [self addChild:playButton];
        
        [self setPlayButton:playButton];
        
        btnRate = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        btnRate.fontSize = 30;
        btnRate.name = @"btnFB";
        btnRate.position = CGPointMake(size.width * 0.5f, size.height *0.45);
        btnRate.text=@"Click to Rate :)";
        [self addChild:btnRate];
        
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if ([_playButton containsPoint:location])
    {
        if([self.delegate respondsToSelector:@selector(startGameLayer:tapRecognizedOnButton:)])
        {
            [self.delegate startGameLayer:self tapRecognizedOnButton:StartGameLayerPlayButton];
        }
    }
    if ([btnRate containsPoint:location])
    {
        [self reviewApp];
    }
}

-(void)reviewApp
{
    NSString * str = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? IOS7_APP_STORE_URL: IOS7_APP_STORE_URL, YOUR_APP_STORE_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}
@end