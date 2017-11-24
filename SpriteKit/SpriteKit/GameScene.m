//
//  GameScene.m
//  SpriteKit
//
//  Created by Ezequiel França on 11/24/17.
//  Copyright (c) 2017 Ezequiel França. All rights reserved.
//

#import "GameScene.h"

#define ARC4RANDOM_MAX 0x100000000

static const uint32_t CATEGORY_FENCE     = 0x1 << 0;
static const uint32_t CATEGORY_CIRCLE    = 0x1 << 1;
static const uint32_t CATEGORY_RECTANGLE = 0x1 << 2;
static const uint32_t CATEGORY_NOTHING   = 0x0 << 0;

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    SKNode *background = [self childNodeWithName:@"Background"];
    background.zPosition = 0;
    
    SKFieldNode *vortex = [SKFieldNode vortexField];
    vortex.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    [self addChild:vortex];
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = CATEGORY_FENCE;
    self.physicsBody.collisionBitMask = CATEGORY_NOTHING;
    self.physicsBody.contactTestBitMask = CATEGORY_NOTHING;
    
    int num = 5;
    for (int i = 0; i < num; i++) {
        SKSpriteNode *node = [self randomNode];
        [self addChild:node];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKSpriteNode *node = [self randomNode];
        node.position = location;
        [self addChild:node];
    }
}

- (SKSpriteNode *)randomNode {
    static int count = 0;
    NSString *imageName = [NSString stringWithFormat:@"%d", ++count % 12 + 1];
    CGFloat scale = ((double)arc4random() / ARC4RANDOM_MAX) * (1.5 - 0.5) + 0.5;

    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    
    node.xScale = scale;
    node.yScale = scale;
    node.position = CGPointMake(arc4random_uniform(self.size.width - node.size.width), arc4random_uniform(self.size.height - node.size.height));
    node.zPosition = 1;
    
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size];
    node.physicsBody.dynamic = YES;
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.allowsRotation = YES;
    node.physicsBody.friction = 0 + arc4random_uniform(1);
    node.physicsBody.restitution = 0.7;
    node.physicsBody.linearDamping = 0.1;
    node.physicsBody.angularDamping = 0.1;
    node.physicsBody.angularVelocity = (double)(arc4random_uniform(100) + 1) / 100;
    node.physicsBody.mass = 1.0;
    node.physicsBody.velocity = CGVectorMake(arc4random_uniform(50) - 25.0, arc4random_uniform(50) - 25.0);
    node.physicsBody.categoryBitMask = CATEGORY_CIRCLE;
    node.physicsBody.collisionBitMask = CATEGORY_FENCE | CATEGORY_CIRCLE | CATEGORY_RECTANGLE;
    node.physicsBody.contactTestBitMask = CATEGORY_NOTHING;
    node.physicsBody.usesPreciseCollisionDetection = YES;
    
    return node;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
