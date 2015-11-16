//
//  Ball.m
//  TransformBall
//
//  Created by MADAO on 15/10/28.
//  Copyright © 2015年 MADAO. All rights reserved.
//

#import "Ball.h"
@interface Ball ()
@end
@implementation Ball
-(instancetype)initWith:(CGPoint)center{
    if (self=[super init]) {
        /**初始化方向*/
        self.ballDirection=[self askForDirection];
        /**初始曲线*/
        self.path=[UIBezierPath bezierPathWithArcCenter:center
                                                 radius:BALL_RADIUS
                                             startAngle:0
                                               endAngle:2*M_PI
                                              clockwise:YES];
        self.linePath=[UIBezierPath bezierPath];
        self.boundryBeTouched=BoundryTypeNone;
        self.speed=(arc4random()%5)/10.0+0.5;
        
        self.ballCenter=center;
        [self.linePath moveToPoint:self.ballCenter];
    }
    return self;
}
-(NSMutableArray *)connectedBalls
{
    if (!_connectedBalls) {
        _connectedBalls=[NSMutableArray new];
    }
    return _connectedBalls;
}
/**随机生成8个方向*/
-(BallDirection)askForDirection{
    int i=arc4random()%8;
    return i;
}
/**球移动*/
-(instancetype)moveBall{
    /**方向判断*/
    BallDirection dir=self.ballDirection;
    CGPoint newCenter;
    switch (dir) {
        case BallDirectionUp:
            newCenter=CGPointMake(self.ballCenter.x, self.ballCenter.y-self.speed);
            break;
        case BallDirectionUpRight:
            newCenter=CGPointMake(self.ballCenter.x+self.speed, self.ballCenter.y-self.speed);
            break;
        case BallDirectionRight:
            newCenter=CGPointMake(self.ballCenter.x+self.speed, self.ballCenter.y);
            break;
        case BallDirectionDownRight:
            newCenter=CGPointMake(self.ballCenter.x+self.speed, self.ballCenter.y+self.speed);
            break;
        case BallDirectionDown:
            newCenter=CGPointMake(self.ballCenter.x, self.ballCenter.y+self.speed);
            break;
        case BallDirectionDownLeft:
            newCenter=CGPointMake(self.ballCenter.x-self.speed, self.ballCenter.y+self.speed);
            break;
        case BallDirectionLeft:
            newCenter=CGPointMake(self.ballCenter.x-self.speed, self.ballCenter.y+self.speed);
            break;
        case BallDirectionUpLeft:
            newCenter=CGPointMake(self.ballCenter.x-self.speed, self.ballCenter.y-self.speed);
            break;
        default:
            break;
    }
    self.ballCenter=newCenter;
    self.path=[UIBezierPath bezierPathWithArcCenter:self.ballCenter
                                             radius:BALL_RADIUS
                                         startAngle:0
                                           endAngle:2*M_PI
                                          clockwise:YES];
    self.linePath=[UIBezierPath bezierPath];
    [self.linePath moveToPoint:self.ballCenter];
    return self;
}
/**在数组中寻找相近的球*/
-(void)findNearBallInBallArray:(NSMutableArray *)array{
    /**弱引用*/
    for (Ball *ball in array) {
        if(ball){
            if (![self.connectedBalls containsObject:ball]&&(![ball.connectedBalls containsObject:self])) {
            CGFloat distance=[self getDistanceWithBall:ball];
                /**距离小于等于150 连线*/
            if (distance<=BALL_DISTANCE) {
                [ball.connectedBalls addObject:self];
            }
            }
            /**已经连过线，判断是否需要移除*/
            else{
                CGFloat distance=[self getDistanceWithBall:ball];
                if(distance>BALL_DISTANCE){
                    [ball.connectedBalls removeObject:self];
                }
            }
            
        }
    }
    
}
/**获取碰撞后球方向*/
-(BallDirection)directionAfterTouchInRect:(CGRect)rect{
    BoundryType type=[self whichBoudryIsFrame:rect touchedBall:self];
    switch (type) {
        case BoundryTypeUp:
            switch (self.ballDirection) {
                case BallDirectionUpLeft:
                    return BallDirectionDownLeft;
                    break;
                case BallDirectionUp:
                    return BallDirectionDown;
                    break;
                case BallDirectionUpRight:
                    return BallDirectionDownRight;
                default:
                    break;
            }
            break;
        case BoundryTypeDown:
            switch (self.ballDirection) {
                case BallDirectionDownRight:
                    return BallDirectionUpRight;
                    break;
                case BallDirectionDown:
                    return BallDirectionUp;
                    break;
                case BallDirectionDownLeft:
                    return BallDirectionUpLeft;
                    break;
                default:
                    break;
            }
            break;
        case BoundryTypeLeft:
            switch (self.ballDirection) {
                case BallDirectionDownLeft:
                    return BallDirectionDownRight;
                    break;
                case BallDirectionLeft:
                    return BallDirectionRight;
                    break;
                case BallDirectionUpLeft:
                    return BallDirectionUpRight;
                    break;
                default:
                    break;
            }
            break;
        case BoundryTypeRight:
            switch (self.ballDirection) {
                case BallDirectionDownRight:
                    return BallDirectionDownLeft;
                    break;
                case BallDirectionRight:
                    return BallDirectionLeft;
                    break;
                case BallDirectionUpRight:
                    return BallDirectionUpLeft;
                    break;
                default:
                    break;
            }
            break;
        case BoundryTypeNone:
            return self.ballDirection;
            break;
        default:
            break;
    }
    return self.ballDirection;
}
/**返回碰撞边界*/
-(BoundryType)whichBoudryIsFrame:(CGRect)rect
          touchedBall:(Ball *)ball{
    
    if (ball.ballCenter.y<(rect.origin.y+BALL_RADIUS)) {
        return BoundryTypeUp;
    }
    else if (ball.ballCenter.y>(rect.size.height-BALL_RADIUS)){
        return  BoundryTypeDown;
    }
    else if (ball.ballCenter.x<(rect.origin.x+BALL_RADIUS)){
        return BoundryTypeLeft;
    }
    else if (ball.ballCenter.x>(rect.size.width-BALL_RADIUS)){
        return BoundryTypeRight;
    }
    else
        return BoundryTypeNone;
}
-(CGFloat)getDistanceWithBall:(Ball *)ball{
    CGFloat x_dis=ball.ballCenter.x-self.ballCenter.x;
    CGFloat y_dis=ball.ballCenter.y-self.ballCenter.y;
    CGFloat dis=sqrt(x_dis*x_dis+y_dis*y_dis);
    return dis;
}
@end
