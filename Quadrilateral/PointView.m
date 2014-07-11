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

    
    recognizer.view.center = CGPointMake(startX + translation.x,
                                         startY + translation.y);
}


@end
