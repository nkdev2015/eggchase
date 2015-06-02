//
//  MyScene.m
//  MyEggs
//
//  Created by khangfet on 4/24/14.
//  Copyright (c) 2014 5solution. All rights reserved.
//

#import "MyScene.h"
#import "GameOverScene.h"
#import "Constans.h"
#import "GameState.h"
static NSString* egg1CategoryName = @"egg";
static NSString* egg2CategoryName = @"gold";
static NSString* egg3CategoryName = @"brown";
static NSString* sitCategoryName = @"sit";
static NSString* lineCategoryName = @"line";
static NSString* cartNodeCategoryName = @"cart";

static const uint32_t eggCategory  = 0x1 << 0;
static const uint32_t bottomCategory = 0x1 << 1;
static const uint32_t cartCategory = 0x1 << 2;

static int numOfChicken = 5;
//static int objOfChicken = 3;
//static int lostGame = 3;

static float time_chiken_egg = 0.7;
static float margin_top = 0.84;
@interface MyScene()

@property (nonatomic) BOOL isFingerOnPaddle;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        [self initSound];
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:background];
        
        SKSpriteNode* cart = [[SKSpriteNode alloc] initWithImageNamed: @"paddle.png"];
        cart.name = cartNodeCategoryName;
        cart.position = CGPointMake(CGRectGetMidX(self.frame), cart.frame.size.height * 2.5f);
        [self addChild:cart];
        cart.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:cart.frame.size];
        cart.physicsBody.restitution = 0.1f;
        cart.physicsBody.friction = 0.4f;
        // make physicsBody static
        
        //Category to which this object belongs to
        cart.physicsBody.categoryBitMask = cartCategory;
        
        //To notify intersection with objects
        cart.physicsBody.contactTestBitMask = eggCategory;
        cart.physicsBody.collisionBitMask =0;
        
        cart.physicsBody.dynamic = NO;
        
        _gameStarted = NO;
        [self initializeStartGameLayer];
        [self showStartGameLayer];
        
        [self initPoint];
        [self initLineBottom];
        //[self initScore];
        [self initChicken];
        
        [self updateLive:@"Heart3"];
        self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
        self.physicsWorld.contactDelegate = self;
        _gameOver = NO;
        display_Chiken =0;
    }
    return self;
}

-(void)initSound
{

    // Play sound
    NSError *errorMap;
    NSURL *mapMusicURL = [[NSBundle mainBundle] URLForResource:@"nhacnen.mp3" withExtension:nil];
    brackGroundSound = [[AVAudioPlayer alloc] initWithContentsOfURL:mapMusicURL error:&errorMap];
    brackGroundSound.numberOfLoops = -1;
    brackGroundSound.volume = 1.0;
    [brackGroundSound play];
    
    NSError *error1;
    NSURL *mapMusic1 = [[NSBundle mainBundle] URLForResource:@"trungroi.mp3" withExtension:nil];
    eggFall = [[AVAudioPlayer alloc] initWithContentsOfURL:mapMusic1 error:&error1];
    eggFall.volume = 10.0;
    
    NSError *error11;
    NSURL *mapMusic11 = [[NSBundle mainBundle] URLForResource:@"gakeu1.mp3" withExtension:nil];
    eggSound1 = [[AVAudioPlayer alloc] initWithContentsOfURL:mapMusic11 error:&error11];
    eggSound1.volume = 10.0;
    
    NSError *error12;
    NSURL *mapMusic12 = [[NSBundle mainBundle] URLForResource:@"gakeu1.mp3" withExtension:nil];
    eggSound2 = [[AVAudioPlayer alloc] initWithContentsOfURL:mapMusic12 error:&error12];
    eggSound2.volume = 10.0;
    
    
    NSError *error14;
    NSURL *mapMusic14 = [[NSBundle mainBundle] URLForResource:@"Gakeu3.mp3" withExtension:nil];
    eggSound3 = [[AVAudioPlayer alloc] initWithContentsOfURL:mapMusic14 error:&error14];
    eggSound3.volume = 10.0;
    
    NSError *error17;
    NSURL *mapMusic17 = [[NSBundle mainBundle] URLForResource:@"Gakeu4.mp3" withExtension:nil];
    eggSound4 = [[AVAudioPlayer alloc] initWithContentsOfURL:mapMusic17 error:&error17];
    eggSound4.volume = 10.0;
    
    
    NSError *error18;
    NSURL *mapMusic18 = [[NSBundle mainBundle] URLForResource:@"Gakeu5.mp3" withExtension:nil];
    eggSound5 = [[AVAudioPlayer alloc] initWithContentsOfURL:mapMusic18 error:&error18];
    eggSound5.volume = 10.0;
    
    
    NSError *error15;
    NSURL *mapMusic15 = [[NSBundle mainBundle] URLForResource:@"hungPhaitrungDen.mp3" withExtension:nil];
    eggBrown = [[AVAudioPlayer alloc] initWithContentsOfURL:mapMusic15 error:&error15];
    eggBrown.volume = 1.0;
    
    
    NSError *error16;
    NSURL *mapMusic16 = [[NSBundle mainBundle] URLForResource:@"bonus.mp3" withExtension:nil];
    bonusSound = [[AVAudioPlayer alloc] initWithContentsOfURL:mapMusic16 error:&error16];
    bonusSound.volume = 1.0;
    
    NSError *error21;
    NSURL *mapMusic21 = [[NSBundle mainBundle] URLForResource:@"trungvo.mp3" withExtension:nil];
    eggBreakSound = [[AVAudioPlayer alloc] initWithContentsOfURL:mapMusic21 error:&error21];
    eggBreakSound.volume = 1.0;
    
    NSError *error22;
    NSURL *mapMusic22 = [[NSBundle mainBundle] URLForResource:@"cutnhao.mp3" withExtension:nil];
    eggBreakSound = [[AVAudioPlayer alloc] initWithContentsOfURL:mapMusic22 error:&error22];
    eggBreakSound.volume = 1.0;
    
    
    NSError *error23;
    NSURL *mapMusic23 = [[NSBundle mainBundle] URLForResource:@"cutnhao.mp3" withExtension:nil];
    chicken = [[AVAudioPlayer alloc] initWithContentsOfURL:mapMusic23 error:&error23];
    chicken.volume = 1.0;

}

- (void) initializeStartGameLayer
{
    _startGameLayer = [[StartGameLayer alloc]initWithSize:self.size];
    _startGameLayer.userInteractionEnabled = YES;
    _startGameLayer.delegate = self;
}

#pragma mark - GameStatus calls
- (void) showStartGameLayer
{
    //Remove currently exising on pillars from scene and purge them
    [self addChild:_startGameLayer];
}

#pragma mark - Delegates
#pragma mark -StartGameLayer
- (void)startGameLayer:(StartGameLayer *)sender tapRecognizedOnButton:(StartGameLayerButtonType)startGameLayerButton
{
    _gameStarted = YES;
    [self initScore];
    [_startGameLayer removeFromParent];
}

-(void)updateLive:(NSString*)_live
{
    live  = [SKSpriteNode spriteNodeWithImageNamed:_live];
    live.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*0.97);
    [self addChild:live];
}
-(void)initLineBottom
{
     SKSpriteNode* line = [SKSpriteNode spriteNodeWithImageNamed:@"Line.png"];
     line.position = CGPointMake(0, self.frame.size.height*0.15);
     line.name = lineCategoryName;
     line.anchorPoint = CGPointZero;
     line.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:line.frame.size];
    
    //Category to which this object belongs to
    line.physicsBody.categoryBitMask = bottomCategory;
    
    //To notify intersection with objects
    line.physicsBody.contactTestBitMask = eggCategory;
     line.physicsBody.collisionBitMask =0;
    
     line.physicsBody.affectedByGravity = NO;
     line.physicsBody.dynamic = NO;
     [self addChild:line];
}

-(void)initScore
{
    _highScore =[GameState sharedInstance].highScore;
    lblScoreTitle = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    lblScoreTitle.fontSize = 20;
    [lblScoreTitle setText: @"Score:000"];
    lblScoreTitle.position = CGPointMake(point4.x + 50, self.frame.size.height* 0.95);
    [self addChild:lblScoreTitle];
    
    lblBestScoreTitle = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    lblBestScoreTitle.fontSize = 20;
    lblBestScoreTitle.text = [NSString stringWithFormat:@"Best:%d",_highScore];    lblBestScoreTitle.position = CGPointMake(point5.x - 70, self.frame.size.height* 0.95);
    [self addChild:lblBestScoreTitle];
    
    lostEgg =3;
    wrongEgg =3;
    point = 0;
}

-(void)initPoint
{
    
    point1 = CGPointMake(self.frame.size.width/2, self.frame.size.height* margin_top);
    point2 = CGPointMake(self.frame.size.width*0.3, self.frame.size.height* margin_top);
    point3 = CGPointMake(self.frame.size.width*0.7, self.frame.size.height* margin_top);
    point4 = CGPointMake(self.frame.size.width*0.1, self.frame.size.height* margin_top);
    point5 = CGPointMake(self.frame.size.width*0.9, self.frame.size.height* margin_top);
    
}
-(void)initChicken
{
    SKAction *run = [SKAction animateWithTextures:SPRITES_CHICKEN timePerFrame:0.1];
    SKAction *walkAnim = [SKAction repeatActionForever:run];
    chicken1 = [SKSpriteNode spriteNodeWithImageNamed:@"ga0001.png"];
    chicken1.position = point1 ;//CGPointMake(self.frame.size.width/2, self.frame.size.height* 0.85);
    [self addChild:chicken1];
    [chicken1 runAction:walkAnim];
    
    chicken2 = [SKSpriteNode spriteNodeWithImageNamed:@"ga0001.png"];
    chicken2.position = point2 ;//CGPointMake(self.frame.size.width*0.3, self.frame.size.height* 0.85);
    [self addChild:chicken2];
    [chicken2 runAction:walkAnim];
    
    chicken3 = [SKSpriteNode spriteNodeWithImageNamed:@"ga0001.png"];
    chicken3.position = point3;// CGPointMake(self.frame.size.width*0.7, self.frame.size.height* 0.85);
    [self addChild:chicken3];
    [chicken3 runAction:walkAnim];
    
    chicken4 = [SKSpriteNode spriteNodeWithImageNamed:@"ga0001.png"];
    chicken4.position = point4;// CGPointMake(self.frame.size.width*0.1, self.frame.size.height* 0.85);
    [self addChild:chicken4];
    [chicken4 runAction:walkAnim];
    
    chicken5 = [SKSpriteNode spriteNodeWithImageNamed:@"ga0001.png"];
    chicken5.position = point5;// CGPointMake(self.frame.size.width*0.9, self.frame.size.height* 0.85);
    [self addChild:chicken5];
    [chicken5 runAction:walkAnim];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    SKPhysicsBody* body = [self.physicsWorld bodyAtPoint:touchLocation];
    if (body && [body.node.name isEqualToString: cartNodeCategoryName]) {
        NSLog(@"Began touch on paddle");
        self.isFingerOnPaddle = YES;
    }
    
}


-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    
    // 1 Check whether user tapped paddle
    if (self.isFingerOnPaddle) {
        // 2 Get touch location
        UITouch* touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        // 3 Get node for paddle
        SKSpriteNode* cart = (SKSpriteNode*)[self childNodeWithName: cartNodeCategoryName];
        // 4 Calculate new position along x for paddle
        int paddleX = cart.position.x + (touchLocation.x - previousLocation.x);
        // 5 Limit x so that the paddle will not leave the screen to left or right
        paddleX = MAX(paddleX, cart.size.width/2);
        paddleX = MIN(paddleX, self.size.width - cart.size.width/2);
        // 6 Update position of paddle
        cart.position = CGPointMake(paddleX, cart.position.y);
    }
}


-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    self.isFingerOnPaddle = NO;
}

-(void)displayGameOver
{
    _gameStarted = NO;
    _gameOver = YES;
    [[GameState sharedInstance] saveState];
    GameOverScene* gameOverScene = [[GameOverScene alloc] initWithSize:self.frame.size playerWon:NO score:point];
    [self.view presentScene:gameOverScene];
    
    
}
#pragma Colision

- (void)didBeginContact:(SKPhysicsContact*)contact {
    // 1 Create local variables for two physics bodies
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    // 3 react to the contact between ball and bottom
    if (firstBody.categoryBitMask == eggCategory && secondBody.categoryBitMask == bottomCategory) {
        [eggBreakSound play];
        //TODO: Replace the log statement with display of Game Over Scene
        if(firstBody.node.name!=sitCategoryName&&firstBody.node.name!=egg3CategoryName)
        {
          lostEgg--;
           [self updateLive:[NSString stringWithFormat:@"Heart%d",lostEgg]];
            [eggFall play];
            //[self updateLive:@"Heart3"];
        }
        if(lostEgg == 0)
        {
            [self displayGameOver];
        }
        NSLog(@"Hit Game Over");
        
        [self egg:(SKSpriteNode*)firstBody.node didCollideWithObject:(SKSpriteNode*)secondBody.node ];
        
    }
    
    if (firstBody.categoryBitMask == eggCategory && secondBody.categoryBitMask == cartCategory) {
        
        /*
         [secondBody.node removeFromParent];
         if ([self isGameWon]) {
         GameOverScene* gameWonScene = [[GameOverScene alloc] initWithSize:self.frame.size playerWon:YES];
         [self.view presentScene:gameWonScene];
         }
         */
       if(firstBody.node.name==egg3CategoryName)
       {
           if(point>0)
           {
               point--;
               SKLabelNode* bestLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
               bestLabel.fontSize = 40;
               bestLabel.position = firstBody.node.position;
               [bestLabel setText:[NSString stringWithFormat:@"-1"]];
               [self addChild:bestLabel];
               SKAction * actionMoveEgg = [SKAction moveTo:CGPointMake(lblScoreTitle.position.x , lblBestScoreTitle.position.y) duration:1];
               SKAction * actionMoveDoneEgg = [SKAction removeFromParent];
               [bestLabel runAction:[SKAction sequence:@[actionMoveEgg, actionMoveDoneEgg]]];
           }
           wrongEgg--;
           [self updateLive:[NSString stringWithFormat:@"Heart%d",wrongEgg]];
           [eggBrown play];
           if(wrongEgg==0)
           {
               [self displayGameOver];
           }
       }
       else
       {
           if(firstBody.node.name==sitCategoryName)
           {
               [sitFall play];
               [self displayGameOver];
           }
           else
           {
               
               [bonusSound play];
               SKLabelNode* bestLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
               bestLabel.fontSize = 40;
               bestLabel.position = firstBody.node.position;
               if(firstBody.node.name==egg1CategoryName)
               {
                   
                   [bestLabel setText:[NSString stringWithFormat:@"+1"]];
                   point ++;
                   
               }
               if(firstBody.node.name==egg2CategoryName)
               {
                   [bestLabel setText:[NSString stringWithFormat:@"+2"]];
                   point +=2;
               }
               [self addChild:bestLabel];
               SKAction * actionMoveEgg = [SKAction moveTo:CGPointMake(lblScoreTitle.position.x , lblBestScoreTitle.position.y) duration:1];
               SKAction * actionMoveDoneEgg = [SKAction removeFromParent];
               [bestLabel runAction:[SKAction sequence:@[actionMoveEgg, actionMoveDoneEgg]]];
           }
        }
        NSLog(@"Hit Point");
        [self egg:(SKSpriteNode*)firstBody.node didCollideWithObject:(SKSpriteNode*)secondBody.node ];
        [lblScoreTitle setText:[NSString stringWithFormat:@"Score: %d",point]];
        
    }
    
    [GameState sharedInstance].score = point;
    
}

- (void)egg:(SKSpriteNode *)egg didCollideWithObject:(SKSpriteNode *)obj
{
   if(obj.name==lineCategoryName)
   {
    if(egg.name == egg1CategoryName || egg.name == egg2CategoryName) // Gold
    {
        
        SKSpriteNode *tempEgg = [SKSpriteNode spriteNodeWithImageNamed:@"TrungVangVo0001.png"];
        tempEgg.position = CGPointMake(egg.frame.origin.x, egg.frame.origin.y);
        [self addChild:tempEgg];
        SKAction *run = [SKAction animateWithTextures:SPRITES_CHICKEN_BREAK timePerFrame:0.1];
        SKAction * actionMoveDoneEgg = [SKAction removeFromParent];
        [tempEgg runAction:[SKAction sequence:@[run, actionMoveDoneEgg]]];
        [egg removeFromParent];
        
        
    }
    if(egg.name == sitCategoryName) // Sit
    {
        
        SKSpriteNode *tempEgg = [SKSpriteNode spriteNodeWithImageNamed:@"SitVo.png"];
        tempEgg.position = CGPointMake(egg.frame.origin.x, egg.frame.origin.y);
        [self addChild:tempEgg];
        SKAction *run = [SKAction animateWithTextures:SPRITES_CHICKEN_SIT timePerFrame:0.1];
        SKAction * actionMoveDoneEgg = [SKAction removeFromParent];
        [tempEgg runAction:[SKAction sequence:@[run, actionMoveDoneEgg]]];
        [egg removeFromParent];
        
    }
    if(egg.name == egg3CategoryName) // Brown
    {
        [eggBreakSound play];
        SKSpriteNode *tempEgg = [SKSpriteNode spriteNodeWithImageNamed:@"TrungDenVo0001.png"];
        tempEgg.position = CGPointMake(egg.frame.origin.x, egg.frame.origin.y);
        [self addChild:tempEgg];
        SKAction *run = [SKAction animateWithTextures:SPRITES_CHICKEN_BROWN_BREAK timePerFrame:0.1];
        SKAction * actionMoveDoneEgg = [SKAction removeFromParent];
        [tempEgg runAction:[SKAction sequence:@[run, actionMoveDoneEgg]]];
        [egg removeFromParent];
       
    }
   }
    if(obj.name==cartNodeCategoryName)
    {
      
      [egg removeFromParent];
    }
}

-(void)crateEgg:(CGPoint)_point index:(int)ramdomEgg
{
    [eggFall play];
    SKSpriteNode * egg;
    switch (ramdomEgg) {
        case 0:
        {
            egg = [SKSpriteNode spriteNodeWithImageNamed:@"TrungGold.png"];
            SKAction *run = [SKAction animateWithTextures:SPRITES_CHICKEN_GOLD timePerFrame:time_chiken_egg];
            [egg runAction:run];
              egg.name = egg2CategoryName;
            break;
        }
    
        case 1:
        {
            egg = [SKSpriteNode spriteNodeWithImageNamed:@"TrungDen.png"];
            egg.name = egg3CategoryName;
            break;
        }
        case 2:
        {
            egg = [SKSpriteNode spriteNodeWithImageNamed:@"TrungVang.png"];
            egg.name = egg1CategoryName;
            break;
        }
        case 3:
        {
            egg = [SKSpriteNode spriteNodeWithImageNamed:@"Sit.png"];
            egg.name = sitCategoryName;
            break;
        }
        default:
            break;
    }
    
    egg.position = CGPointMake(_point.x , _point.y - chicken1.frame.size.height/2);
    int timeFall =0;
    timeFall = arc4random()%3;
    float timeDown =1.0f;
    switch (timeFall) {
        case 0:
            timeDown = 0.8f;
            break;
        case 1:
            timeDown = 1.0f;
            break;
        case 2:
            timeDown = 0.7f;
            break;
        default:
            break;
    }
    SKAction * actionMoveEgg = [SKAction moveTo:CGPointMake(_point.x , 0) duration:timeDown];
    SKAction * actionMoveDoneEgg = [SKAction removeFromParent];
    [egg runAction:[SKAction sequence:@[actionMoveEgg, actionMoveDoneEgg]]];
    egg.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:egg.size];
    //Category to which this object belongs to
    egg.physicsBody.categoryBitMask = eggCategory;
    //To notify intersection with objects
    egg.physicsBody.contactTestBitMask = cartCategory|bottomCategory;
    //To detect collision with category of objects. Default all categories
    egg.physicsBody.collisionBitMask = 0;

    
    egg.physicsBody.dynamic = YES;
    [self addChild:egg];
    
    //return  egg;
}

-(void)randomEgg
{
    
    int rand = arc4random()%numOfChicken;
    int rand_egg = arc4random()%4;
    
    
    int soundEgg = arc4random()%5;
    
    switch (soundEgg) {
        case 0:
            [eggSound1 play];
            break;
            case 1:
            [eggSound2 play];
            break;
            case 2:
             [eggSound3 play];
            break;
        case 3:
            [eggSound4 play];
            break;
        case 4:
            [eggSound5 play];
            break;
        default:
            break;
    }
    
    switch (rand) {
        case 0:
        {
            SKAction *run = [SKAction animateWithTextures:SPRITES_CHICKEN_EGG timePerFrame:time_chiken_egg];
            [chicken5 runAction:run];
            [self crateEgg:point5 index:rand_egg];
            
        }
            break;
        case 1:
        {
            SKAction *run = [SKAction animateWithTextures:SPRITES_CHICKEN_EGG timePerFrame:time_chiken_egg];
            [chicken1 runAction:run];
            [self crateEgg:point1 index:rand_egg];
        }
            
            break;
        case 2:
        {
            SKAction *run = [SKAction animateWithTextures:SPRITES_CHICKEN_EGG timePerFrame:time_chiken_egg];
            [chicken2 runAction:run];
            [self crateEgg:point2 index:rand_egg];
        }
            
            break;
        case 3:
        {
            SKAction *run = [SKAction animateWithTextures:SPRITES_CHICKEN_EGG timePerFrame:time_chiken_egg];
            [chicken3 runAction:run];
            [self crateEgg:point3 index:rand_egg];
        }
            
            break;
        case 4:
        {
            SKAction *run = [SKAction animateWithTextures:SPRITES_CHICKEN_EGG timePerFrame:time_chiken_egg];
            [chicken4 runAction:run];
            [self crateEgg:point4 index:rand_egg];
        }
            
            break;
        default:
            break;
    }
    
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        if(_gameOver==NO&&_gameStarted==YES)
        {
            display_Chiken++;
            if(display_Chiken>4)
            {
                [chicken play];
               SKSpriteNode* chicken6 = [SKSpriteNode spriteNodeWithImageNamed:@"GaTrong1.png"];
                chicken6.position = CGPointMake(self.frame.size.width*1.5, self.frame.size.height*0.3);//
                [self addChild:chicken6];
                SKAction *run = [SKAction animateWithTextures:SPRITES_GATRONG timePerFrame:time_chiken_egg];
                [chicken6 runAction:run];
                SKAction * actionMoveEgg = [SKAction moveTo:CGPointMake(self.frame.size.width*0.93, self.frame.size.height*0.1) duration:2];
                SKAction * actionMoveDoneEgg = [SKAction removeFromParent];
                [chicken6 runAction:[SKAction sequence:@[actionMoveEgg,actionMoveEgg, actionMoveDoneEgg]]];
                display_Chiken =0;
            
            }
            [self randomEgg];
        }
    }
}

- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
}

@end
