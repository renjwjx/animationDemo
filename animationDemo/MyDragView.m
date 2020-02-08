//
//  MyDragView.m
//  animationDemo
//
//  Created by jinren on 2/7/20.
//  Copyright © 2020 jinren. All rights reserved.
//

#import "MyDragView.h"
@interface MyDragView()

@property (assign, nonatomic) CGPoint ori_point;
@end


@implementation MyDragView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPan:)];
//        [self addGestureRecognizer:panGesture];
        srand((unsigned)time(0));
        CGFloat r = (float)rand() / RAND_MAX;
        NSLog(@"r:%f", r);
        r = (float)rand() / RAND_MAX;
        NSLog(@"r:%f", r);
        self.backgroundColor = [UIColor colorWithRed:(float)rand() / RAND_MAX green:(float)rand() / RAND_MAX blue:(float)rand() / RAND_MAX alpha:1];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect myFrame = self.bounds;
    
    CGContextSetLineWidth(context, 5);
    CGRectInset(myFrame, 5, 5);
    [[UIColor redColor] set];
    
    UIRectFrame(myFrame);
    CGPoint center = CGPointMake(myFrame.size.width/2, myFrame.size.height/2);
    CGFloat radius = (myFrame.size.width - 10)/2;
    CGContextAddArc(context, center.x, center.y, radius, 0, M_PI*2, true);
    
    CGContextStrokePath(context);
}

- (void)detectPan:(UIPanGestureRecognizer*)pan
{
    CGPoint point = [pan translationInView:self.superview];
    self.center = CGPointMake(self.ori_point.x + point.x, self.ori_point.y + point.y);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch Began\n\n\n");
    UITouch* touch = [touches anyObject];

    CGPoint location = [touch locationInView:self];
    self.ori_point = location;
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"moved, touch: %@, event: %@", touches, event);
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    NSLog(@"location: %f, %f, ori:%f, %f", location.x, location.y, self.ori_point.x, self.ori_point.y);
    self.center = CGPointMake(self.center.x + location.x - self.ori_point.x, self.center.y + location.y - self.ori_point.y);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}
@end
