//
//  TransformMainView.m
//  TransformBall
//
//  Created by MADAO on 15/10/28.
//  Copyright © 2015年 MADAO. All rights reserved.
//

#import "TransformMainView.h"
#import "Ball.h"
@interface TransformMainView ()
@property (nonatomic,strong) NSMutableArray *balls;
@property (nonatomic,strong) NSMutableArray *linePath;
@end
@implementation TransformMainView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(NSMutableArray *)balls
{
    if (!_balls) {
        _balls=[NSMutableArray new];
    }
    return _balls;
}
-(NSMutableArray *)linePath
{
    if (!_linePath) {
        _linePath=[NSMutableArray new];
    }
    return _linePath;
}-(void)awakeFromNib{
    /**启动创建Ball定时器*/
    [NSTimer scheduledTimerWithTimeInterval:.7f
                                    target:self
                                   selector:@selector(createBall)
                                   userInfo:nil
                                    repeats:YES];
     [self createBall];
    /**定时器移动*/
    [NSTimer scheduledTimerWithTimeInterval:0.03f
                                     target:self
                                   selector:@selector(moveTheBall)
                                   userInfo:nil
                                    repeats:YES];
   


}
/**创建球*/
-(void)createBall{
   /**球数量固定30*/
    if (self.balls.count>24) {
        return;
    }
    CGPoint ballCenter=[self getRandomPoint];
    Ball *newBall=[[Ball alloc]initWith:ballCenter];
    [self.balls addObject:newBall];
    [self setNeedsDisplay];
}
/**取屏幕内随机点*/
-(CGPoint)getRandomPoint{
    CGFloat x=arc4random()%(int)(self.frame.size.width-BALL_RADIUS/2);
    CGFloat y=arc4random()%(int)(self.frame.size.height-BALL_RADIUS/2);
    /**值必须大于0+球半径一半*/
    if (x>(BALL_RADIUS/2)&&(y>BALL_RADIUS/2)) {
        return CGPointMake(x, y);
    }
    else if (x<(BALL_RADIUS/2)&&y>(BALL_RADIUS/2))    {
        return CGPointMake(x+BALL_RADIUS/2, y+BALL_RADIUS/2);
    }
    else if (x>(BALL_RADIUS/2)&&y<(BALL_RADIUS)/2){
        return CGPointMake(x, y+BALL_RADIUS/2);
    }
    else
    {
        return CGPointMake(x+BALL_RADIUS/2, y+BALL_RADIUS/2);
    }
}
#pragma mark - move
-(void)moveTheBall{
    for (Ball *ball in self.balls) {
        [ball moveBall];
        [ball findNearBallInBallArray:self.balls];
        /**配置LinePath*/
        for (Ball *ballTwo in ball.connectedBalls) {
            [ball.linePath addLineToPoint:ballTwo.ballCenter];
           }
        /**判断碰撞*/
        ball.ballDirection=[ball directionAfterTouchInRect:self.frame];
    }
    [self setNeedsDisplay];
}
#pragma mark - drawRect
/**画图*/
-(void)drawRect:(CGRect)rect
{
    for (Ball *ball in self.balls) {
        [[UIColor lightGrayColor]setFill];
        [ball.path fill];
        [[UIColor lightGrayColor]setStroke];
        [ball.linePath stroke];
    }
}

@end
