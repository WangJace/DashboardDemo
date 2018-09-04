//
//  DashboardView.m
//  DashboardDemo
//
//  Created by 王傲云 on 2018/9/3.
//  Copyright © 2018 王傲云. All rights reserved.
//

#import "WJDashboardView.h"

#define HalfCircleDegree 180     // 半圆弧度
#define PerDegree        4.5     // 每个刻度线跨越的弧度
#define PerScaleDegree   45      // 每个刻度值跨越的弧度
#define LineWidth        1       // 线框
#define SmallLineLength  30      // 短线长
#define BigLineLength    40      // 长线长
#define SpaceWidth       40      // 左右预留的空间
#define FontSize         10      // 字体大小
#define ScaleLabelWidth  20      // 刻度宽度

@interface WJDashboardView()
{
    CGFloat _radius;
    CGPoint _center;
}
@property (nonatomic, strong) UIImageView *pointerImageView;

@end

@implementation WJDashboardView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _radius = CGRectGetWidth(frame)/2 - SpaceWidth;
        _center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetWidth(frame)/2);
    }
    return self;
}

-(void) setPercent:(CGFloat)percent {
    _percent = percent/100;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat currentDegree = 0;
    [self setScales];
    [self setPointer];
    while (currentDegree <= HalfCircleDegree) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, _center.x, _center.y);     // 坐标原点偏移
        CGContextRotateCTM(context, currentDegree*M_PI/180);      // 坐标原点选择
        
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        if ((int)currentDegree%PerScaleDegree == 0) {
            [bezierPath moveToPoint: CGPointMake(-_radius, -0)];
        }
        else {
            [bezierPath moveToPoint: CGPointMake(-_radius+(BigLineLength-SmallLineLength), -0)];
        }
        [bezierPath addLineToPoint: CGPointMake(-_radius + SmallLineLength, 0)];
        bezierPath.lineCapStyle = kCGLineCapRound;
        if (currentDegree <= _percent*HalfCircleDegree && _percent != 0) {
            [[UIColor colorWithRed:0.20 green:0.94 blue:0.60 alpha:1.00] setStroke];
        }
        else {
            [[UIColor whiteColor] setStroke];
        }
        bezierPath.lineWidth = LineWidth;
        [bezierPath stroke];
        CGContextRestoreGState(context);
        
        currentDegree += PerDegree;
    }
}

// 指针
-(void)setPointer {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, _center.x, _center.y);
    CGContextRotateCTM(context, _percent*M_PI);
    UIImage *image = [UIImage imageNamed:@"pointer"];
    [image drawAtPoint:CGPointMake(-40, -6.5)];
    CGContextRestoreGState(context);
}

// 刻度文本
-(void)setScales{
    NSArray *scales = @[@"0", @"25", @"50", @"75", @"100"];
    for (NSInteger i = 0; i < scales.count; i++) {
        CGFloat x = _center.x-(cos(i*45*M_PI/180))*_radius;
        CGFloat y = _center.y-(sin(i*45*M_PI/180))*_radius;
        switch (i) {
            case 0:
                x -= ScaleLabelWidth;
                y -= ScaleLabelWidth/2;
                break;
            case 1:
                x -= ScaleLabelWidth;
                y -= ScaleLabelWidth;
                break;
            case 2:
                x -= ScaleLabelWidth/2;
                y -= ScaleLabelWidth;
                break;
            case 3:
                y -= ScaleLabelWidth;
                break;
            case 4:
                y -= ScaleLabelWidth/2;
                break;
            default:
                break;
        }
        NSLog(@"x = %g, y = %g", x, y);
        [scales[i] drawAtPoint:CGPointMake(x, y) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
}

@end
