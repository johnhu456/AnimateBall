//
//  Ball.h
//  TransformBall
//
//  Created by MADAO on 15/10/28.
//  Copyright © 2015年 MADAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define BALL_RADIUS 4
#define BALL_DISTANCE 100
#define WS __weak typeof(self) weakself=self
typedef enum{
    /**正上*/
    BallDirectionUp=0,
    /**右上*/
    BallDirectionUpRight,
    /**正右*/
    BallDirectionRight,
    /**右下*/
    BallDirectionDownRight,
    /**正下*/
    BallDirectionDown,
    /**左下*/
    BallDirectionDownLeft,
    /**正左*/
    BallDirectionLeft,
    /**左上*/
    BallDirectionUpLeft,
}BallDirection;
/**碰撞到的边界类型*/
typedef enum{
    BoundryTypeNone=0,
    BoundryTypeUp,
    BoundryTypeRight,
    BoundryTypeDown,
    BoundryTypeLeft,
}BoundryType;
@interface Ball: NSObject
/**绘制相关*/
@property (nonatomic,strong)UIBezierPath *path;
@property (nonatomic,strong)UIBezierPath *linePath;
/**球心*/
@property (nonatomic)CGPoint ballCenter;
/**方向*/
@property (nonatomic)BallDirection ballDirection;
/**碰撞边界类型*/
@property (nonatomic)BoundryType boundryBeTouched;
/**速度*/
@property (nonatomic)CGFloat speed;
/**相连球数组*/
@property (nonatomic,strong) NSMutableArray *connectedBalls;
/**初始化方法*/
-(instancetype)initWith:(CGPoint)center;
/**移动*/
-(instancetype)moveBall;
/**寻找相近的球*/
-(void)findNearBallInBallArray:(NSMutableArray *)array;
/**碰撞后方向*/
-(BallDirection)directionAfterTouchInRect:(CGRect)rect;
@end
