//
//  UIView+UIView_Quadrilateral.h
//  Quadrilateral
//
//  Created by Zakk Hoyt on 7/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Quadrilateral)

//Sets frame to bounding box of quad and applies transform
- (void)transformToFitQuadTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br;

@end
