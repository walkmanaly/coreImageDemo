//
//  ViewController.m
//  coreImageDemo
//
//  Created by Nick on 2018/7/31.
//  Copyright © 2018年 nick. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, assign) CGAffineTransform transformToUIKit;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self coreImageDemo1];
}

- (void)coreImageDemo1 {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 600)];
    
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"585px-Nathan_Fillion_by_Gage_Skidmore.jpg" withExtension:nil];
    CIImage *coreImage = [CIImage imageWithContentsOfURL:imageUrl];
    UIImage *image = [UIImage imageWithCIImage:coreImage];
    
    imageView.image = image;
    [self.view addSubview:imageView];
    
    //this is the translation from the CIImage coordinates to the UIKit coordinates
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    self.transformToUIKit = CGAffineTransformTranslate(transform, 0, -image.size.height);
    
    NSDictionary * detectorOptions = @{CIDetectorAccuracy:CIDetectorAccuracyHigh};
    CIDetector * detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                               context:context
                                               options:detectorOptions];
    NSArray * foundFaces = [detector featuresInImage:coreImage];
    
    for (CIFaceFeature * feature in foundFaces) {
        
        [self addRectangleFromCGRect:feature.bounds toView:self.view withColor:[UIColor redColor]];
        
        [self addCircleAroundPoint:feature.leftEyePosition
                            toView:self.view withColor:[UIColor greenColor] andWidth:20];
        [self addCircleAroundPoint:feature.rightEyePosition
                            toView:self.view withColor:[UIColor greenColor] andWidth:20];
        [self addCircleAroundPoint:feature.mouthPosition
                            toView:self.view withColor:[UIColor blueColor] andWidth:40];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Adds a rectangle-view to the passed view
 *
 *  @param rect  the dimensions and position of the new rectangle
 *  @param view  the parent-view
 *  @param color the color of the rectangle (will have an alpha-value of 0.3)
 */
- (void) addRectangleFromCGRect:(CGRect)rect toView:(UIView *) view withColor:(UIColor *) color
{
    CGRect translatedRect = CGRectApplyAffineTransform(rect, self.transformToUIKit);
    
    UIView * newView = [[UIView alloc] initWithFrame:translatedRect];
    newView.layer.cornerRadius = 10;
    newView.alpha = 0.3;
    newView.backgroundColor = color;
    [view addSubview:newView];
}

/**
 *  adds a circle-view to the passed view
 *
 *  @param point the center of the circle
 *  @param view  the parent-view
 *  @param color the color of the circle (will have an alpha-value of 0.3)
 *  @param width the diameter of the circle
 */
- (void) addCircleAroundPoint:(CGPoint) point toView:(UIView *) view withColor:(UIColor *) color andWidth:(NSInteger) width
{
    CGPoint translatedPoint = CGPointApplyAffineTransform(point, self.transformToUIKit);
    CGRect circleRect = CGRectMake(translatedPoint.x-width/2, translatedPoint.y-width/2, width, width);
    
    UIView * circleView = [[UIView alloc] initWithFrame:circleRect];
    circleView.layer.cornerRadius = width/2;
    circleView.alpha = 0.7;
    circleView.backgroundColor = color;
    [view addSubview:circleView];
}

@end
