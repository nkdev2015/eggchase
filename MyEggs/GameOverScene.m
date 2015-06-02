//
//  GameOverScene.m
//  MyEggs
//
//  Created by khangfet on 4/25/14.
//  Copyright (c) 2014 5solution. All rights reserved.
//

#import "GameOverScene.h"
#import "MyScene.h"
#import "GameState.h"
#import  <Social/Social.h>
@implementation GameOverScene

- (id)initWithSize:(CGSize)size playerWon:(BOOL)isWon score:(int)_score
{
    self = [super initWithSize:size];
    if (self) {
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"GameOver.png"];
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:background];
        
        // 1
        SKLabelNode* gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        gameOverLabel.fontSize = 42;
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height*0.8);
        if (isWon) {
            gameOverLabel.text = @"Game Won";
        } else {
            gameOverLabel.text = @"Game Over";
        }
        [self addChild:gameOverLabel];
        
        int highScore = [GameState sharedInstance].highScore;
        
        SKLabelNode* scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        scoreLabel.fontSize = 30;
        scoreLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*0.5);
        [scoreLabel setText:[NSString stringWithFormat:@"Score: %d",_score]];
        _currentScore = _score;
        
        [self addChild:scoreLabel];
        
        SKLabelNode* bestLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        bestLabel.fontSize = 30;
        bestLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*0.6);
        [bestLabel setText:[NSString stringWithFormat:@"Best: %d",highScore]];
        [self addChild:bestLabel];
        
        SKLabelNode* retryLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        retryLabel.fontSize = 30;
        retryLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*0.4);
        retryLabel.text=@"Tap to try again";
        [self addChild:retryLabel];
        
         btnShareFb = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        btnShareFb.fontSize = 30;
         btnShareFb.name = @"btnFB";
        btnShareFb.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*0.3);
        btnShareFb.text=@"Share your score on Facebook :)";
        [self addChild:btnShareFb];
        
        
        // Play sound
        NSError *errorMap;
        NSURL *mapMusicURL = [[NSBundle mainBundle] URLForResource:@"game-over.mp3" withExtension:nil];
        brackGroundSound = [[AVAudioPlayer alloc] initWithContentsOfURL:mapMusicURL error:&errorMap];
        brackGroundSound.volume = 1.0;
        [brackGroundSound play];
    }
    return self;
}


-(void)postFB
{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString * temp = [NSString stringWithFormat:@"Great! Your get %d eggs. Tell your friend and Your friend can get it now :)) %@",_currentScore,@" https://itunes.apple.com/us/app/egg-chase/id869716884?l=vi&ls=1&mt=8"];
        [controller setInitialText:temp];
        [controller addImage:[UIImage imageNamed:@"ga0001.png"]];
        UIViewController *vc = self.view.window.rootViewController;
        [vc presentViewController:controller animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Fun Circus" message:@"Please login with your Facebook Acount in Setting " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if ([btnShareFb containsPoint:location])
    {
        [self postFB];
    }
    else
    {
        MyScene* GameScene = [[MyScene alloc] initWithSize:self.size];
        [self.view presentScene:GameScene];
    }
}
@end
