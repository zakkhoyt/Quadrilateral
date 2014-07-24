//
//  ViewController.m
//  Quadrilateral
//
//  Created by Zakk Hoyt on 7/11/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//
// See http://stackoverflow.com/questions/13269432/perspective-transform-crop-in-ios-with-opencv
// One more to try: http://stackoverflow.com/questions/13523837/find-corner-of-papers/13532779#13532779



#import "ViewController.h"
#import "PointView.h"

#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <iostream>

// Not sure if Pnt/Quadrilateral are defined somewehere in OpenCV... I made my own to meet the signatures
struct Pnt{
    float x;
    float y;
};


struct Quadrilateral{
    Pnt topLeft;
    Pnt topRight;
    Pnt bottomLeft;
    Pnt bottomRight;
};



@interface ViewController (){
    CGFloat startX;
    CGFloat startY;
}


@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet PointView *topLeftView;
@property (weak, nonatomic) IBOutlet PointView *topRightView;
@property (weak, nonatomic) IBOutlet PointView *bottomRightView;
@property (weak, nonatomic) IBOutlet PointView *bottomLeftView;
@property (nonatomic) CGRect original;

@property (weak, nonatomic) IBOutlet UIButton *distortButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@end

@implementation ViewController

#pragma mark UIViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupImage];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.original = self.imageView.layer.frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupImage{
    [self.imageView removeFromSuperview];
    UIImage *image = [UIImage imageNamed:@"skew"];
    self.imageView = [[UIImageView alloc]initWithImage:image];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
//    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.imageView.backgroundColor = [UIColor greenColor];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandler:)];
    [self.view addGestureRecognizer:panGesture];

    [self.view addSubview:self.imageView];
    
    [self.view bringSubviewToFront:self.topLeftView];
    [self.view bringSubviewToFront:self.topRightView];
    [self.view bringSubviewToFront:self.bottomLeftView];
    [self.view bringSubviewToFront:self.bottomRightView];
    [self.view bringSubviewToFront:self.resetButton];
    [self.view bringSubviewToFront:self.distortButton];
}

-(void)panHandler:(UIPanGestureRecognizer*)recognizer{
    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    if(recognizer.state == UIGestureRecognizerStateBegan){
        startX = recognizer.view.center.x;
        startY = recognizer.view.center.y;
    }
    
    
    self.imageView.center = CGPointMake(startX + translation.x,
                                         startY + translation.y);
}

- (IBAction)resetButtonAction:(id)sender {
    [self setupImage];
}


- (IBAction)buttonAction:(id)sender {
    
    Quadrilateral quadFrom;
    float scale = 1.0;
    quadFrom.topLeft.x = self.topLeftView.center.x / scale;
    quadFrom.topLeft.y = self.topLeftView.center.y / scale;
    quadFrom.topRight.x = self.topRightView.center.x / scale;
    quadFrom.topRight.y = self.topRightView.center.y / scale;
    quadFrom.bottomLeft.x = self.bottomLeftView.center.x / scale;
    quadFrom.bottomLeft.y = self.bottomLeftView.center.y / scale;
    quadFrom.bottomRight.x = self.bottomRightView.center.x / scale;
    quadFrom.bottomRight.y = self.bottomRightView.center.y / scale;
    
    Quadrilateral quadTo;
    quadTo.topLeft.x = self.view.bounds.origin.x;
    quadTo.topLeft.y = self.view.bounds.origin.y;
    quadTo.topRight.x = self.view.bounds.origin.x + self.view.bounds.size.width;
    quadTo.topRight.y = self.view.bounds.origin.y;
    quadTo.bottomLeft.x = self.view.bounds.origin.x;
    quadTo.bottomLeft.y = self.view.bounds.origin.y + self.view.bounds.size.height;
    quadTo.bottomRight.x = self.view.bounds.origin.x + self.view.bounds.size.width;
    quadTo.bottomRight.y = self.view.bounds.origin.y + self.view.bounds.size.height;

    CATransform3D t = [self transformQuadrilateral:quadFrom toQuadrilateral:quadTo];
//    t = CATransform3DScale(t, 0.5, 0.5, 1.0);
    self.imageView.layer.anchorPoint = CGPointZero;
    [UIView animateWithDuration:1.0 animations:^{
        self.imageView.layer.transform = t;
    }];

}


#pragma mark OpenCV stuff...
-(CATransform3D)transformQuadrilateral:(Quadrilateral)origin toQuadrilateral:(Quadrilateral)destination {
    
    CvPoint2D32f *cvsrc = [self openCVMatrixWithQuadrilateral:origin];
    CvMat *src_mat = cvCreateMat( 4, 2, CV_32FC1 );
    cvSetData(src_mat, cvsrc, sizeof(CvPoint2D32f));
    

    CvPoint2D32f *cvdst = [self openCVMatrixWithQuadrilateral:destination];
    CvMat *dst_mat = cvCreateMat( 4, 2, CV_32FC1 );
    cvSetData(dst_mat, cvdst, sizeof(CvPoint2D32f));
    
    CvMat *H = cvCreateMat(3,3,CV_32FC1);
    cvFindHomography(src_mat, dst_mat, H);
    cvReleaseMat(&src_mat);
    cvReleaseMat(&dst_mat);
    
    CATransform3D transform = [self transform3DWithCMatrix:H->data.fl];
    cvReleaseMat(&H);
    
    return transform;
}

- (CvPoint2D32f*)openCVMatrixWithQuadrilateral:(Quadrilateral)origin {
    
    CvPoint2D32f *cvsrc = (CvPoint2D32f *)malloc(4*sizeof(CvPoint2D32f));
    cvsrc[0].x = origin.topLeft.x;
    cvsrc[0].y = origin.topLeft.y;
    cvsrc[1].x = origin.topRight.x;
    cvsrc[1].y = origin.topRight.y;
    cvsrc[2].x = origin.bottomRight.x;
    cvsrc[2].y = origin.bottomRight.y;
    cvsrc[3].x = origin.bottomLeft.x;
    cvsrc[3].y = origin.bottomLeft.y;

    return cvsrc;
}

-(CATransform3D)transform3DWithCMatrix:(float *)matrix {
    CATransform3D transform = CATransform3DIdentity;
    
    transform.m11 = matrix[0];
    transform.m21 = matrix[1];
    transform.m41 = matrix[2];
    
    transform.m12 = matrix[3];
    transform.m22 = matrix[4];
    transform.m42 = matrix[5];
    
    transform.m14 = matrix[6];
    transform.m24 = matrix[7];
    transform.m44 = matrix[8];
    
    return transform; 
}


@end
