//
//  ViewController.m
//  animationDemo
//
//  Created by jinren on 2/6/20.
//  Copyright © 2020 jinren. All rights reserved.
//

#import "ViewController.h"
#import "MyDragView.h"

@interface ViewController ()
@property (strong, nonatomic) UIView* viewA;
@property (strong, nonatomic) UIView* viewB;
@property (assign, nonatomic) CGPoint ori_center;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView* viewAn = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    viewAn.layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view addSubview:viewAn];
    self.viewA = viewAn;
    self.viewA.tag = 100;
    
    UIView* viewBn = [[MyDragView alloc] initWithFrame: CGRectMake(110, 60, 80, 60)];
    [self.view addSubview:viewBn];
    self.viewB = viewBn;
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 100, 50)];
    [btn setTitle:@"Animation" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.viewA.clipsToBounds = YES;
    self.viewA.autoresizesSubviews = YES;
    self.viewB.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    UIPanGestureRecognizer* panGuesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGuesture:)];
    panGuesture.minimumNumberOfTouches = 1;
    
    UITapGestureRecognizer* tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewA)];
    [self.viewA addGestureRecognizer:tapGuesture];
    [self.viewA addGestureRecognizer:panGuesture];
    
    
}


#pragma mark -- tap

- (void)tapViewA
{
    NSLog(@"user tap");
}

- (void)panGuesture:(UIPanGestureRecognizer*)panGuesture
{
    if (panGuesture.state == UIGestureRecognizerStateBegan) {
        self.ori_center = self.viewA.center;
    } else {
        CGPoint point = [panGuesture translationInView:panGuesture.view.superview];
        NSLog(@"panGuesture:%f, %f ", point.x, point.y);
        CGRect ori_frame = self.viewA.frame;
        ori_frame.origin.x = point.x;
        ori_frame.origin.y = point.y;
        //    self.viewA.frame = ori_frame;
        panGuesture.view.center = CGPointMake(self.ori_center.x + point.x, self.ori_center.y + point.y);

    }
}

#pragma mark -- button action
- (void)btnAction
{
    NSLog(@"button Touch");
    UIView* viewA = [self.view viewWithTag:100];
    NSLog(@"viewA : %@", viewA);
    
    [self.view bringSubviewToFront:viewA];

    //layer core animation
    
    // Animation 1
    CAKeyframeAnimation* widthAnim = [CAKeyframeAnimation animationWithKeyPath:@"borderWidth"];
    NSArray* widthValues = [NSArray arrayWithObjects:@1.0, @10.0, @5.0, @30.0, @0.5, @15.0, @2.0, @50.0, @0.0, nil];
    widthAnim.values = widthValues;
    widthAnim.calculationMode = kCAAnimationPaced;
    
    // Animation 2
    CAKeyframeAnimation* colorAnim = [CAKeyframeAnimation animationWithKeyPath:@"borderColor"];
    NSArray* colorValues = [NSArray arrayWithObjects:(id)[UIColor greenColor].CGColor,
                            (id)[UIColor redColor].CGColor, (id)[UIColor blueColor].CGColor,  nil];
    colorAnim.values = colorValues;
    colorAnim.calculationMode = kCAAnimationPaced;
    
    // Animation group
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:colorAnim, widthAnim, nil];
    group.duration = 5.0;
    
    
    [self.viewA.layer addAnimation:group forKey:@"BorderChanges"];

    
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath,NULL,74.0,74.0);
    CGPathAddCurveToPoint(thePath,NULL,74.0,500.0,
                          200,500.0,
                          200.0,74.0);
    CGPathAddCurveToPoint(thePath,NULL,200.0,500.0,
                          400.0,500.0,
                          400.0,74.0);
    CAKeyframeAnimation * theAnimation;
    
    // Create the animation object, specifying the position property as the key path.
    theAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    theAnimation.path=thePath;
    theAnimation.duration=5.0;
//    theAnimation.rotationMode = kCAAnimationRotateAutoReverse;
    theAnimation.calculationMode = kCAAnimationLinear;
    //keyTimes controll the keyframe time
//    theAnimation.keyTimes = @[@0.0, @0.1, @0.2, @0.3, @0.4, @0.8, @0.9, @0.91, @0.93, @1.0];
    
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    fadeAnim.fromValue = @1;
    fadeAnim.toValue = @3;
    fadeAnim.duration = 5.0;
    // parameter key is used to remove the animation, removeAnimationForKey:
//    [self.viewA.layer addAnimation:fadeAnim forKey:@"transform.scale.x"];
//    [self.viewA.layer addAnimation:theAnimation forKey:@"position"];

    //layer core animation end

// repeat and reverse
//    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseOut animations:^{
//        [UIView setAnimationRepeatCount:2.5];
//        self.viewA.center = CGPointMake(200, 400);
//        self.viewA.alpha = 0.8;
//        self.viewA.backgroundColor = [UIColor greenColor];
//        self.viewA.bounds = CGRectMake(0, 0, 200, 100);
//    } completion:^(BOOL finished) {
//        NSLog(@"animate end");
//    }];

//    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
//        [UIView setAnimationRepeatCount:2];
//
//        CGAffineTransform scale2X = CGAffineTransformMakeScale(1.5, 1.5);
//        CGAffineTransform scale_2X = CGAffineTransformScale(self.viewA.transform, 1.5, 1.5);
//
//        CGAffineTransform rotate6 = CGAffineTransformMakeRotation(M_PI/6);
//        CGAffineTransform rotate_6 = CGAffineTransformRotate(scale_2X, M_PI/6);
//
//        self.viewA.transform = scale_2X;
//
//    } completion:^(BOOL finished) {
//        NSLog(@"animate end");
//        NSLog(@"frame.width : %@", @(self.viewA.frame.size.width));
//        CGAffineTransform origin = CGAffineTransformMakeScale(1, 1);
//        self.viewA.transform = origin;
//    }];

    
    //change visible subviews
    
//    [UIView transitionWithView:self.view duration:1 options:UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionAllowAnimatedContent animations:^{
//        self.viewA.hidden = !self.viewA.hidden;
//        self.viewB.hidden = !self.viewB.hidden;
//    } completion:^(BOOL finished) {
//        NSLog(@"show other view end");
//    }];
    //replace view
//    [UIView transitionFromView:self.viewA toView:self.viewB duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
//        NSLog(@"transition end");
//        self.viewA.hidden = !self.viewA.hidden;
//        self.viewB.hidden = !self.viewB.hidden;
//
//    }];
    
}





@end
