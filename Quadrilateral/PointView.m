//
//  PointView.m
//  Quadrilateral
//
//  Created by Zakk Hoyt on 7/11/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "PointView.h"


@interface PointView (){
    CGFloat startX;
    CGFloat startY;
}
@property (weak, nonatomic) IBOutlet UIImageView *zoomImageView;
@end
@implementation PointView


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandler:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}


-(void)panHandler:(UIPanGestureRecognizer*)recognizer{
    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    if(recognizer.state == UIGestureRecognizerStateBegan){
        startX = recognizer.view.center.x;
        startY = recognizer.view.center.y;
    }

    UIImage *image = [self getTarget];
    self.zoomImageView.image = image;
    recognizer.view.center = CGPointMake(startX + translation.x,
                                         startY + translation.y);
}


- (UIImage *)getTarget{
    UIView *view = self.imageView;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end
