//
//  ViewController.m
//  Quadrilateral
//
//  Created by Zakk Hoyt on 7/11/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//
// See http://stackoverflow.com/questions/13269432/perspective-transform-crop-in-ios-with-opencv

#import "ViewController.h"
//#import "AGGeometryKit.h"
#import "PointView.h"

#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <iostream>
//#import <opencv2/open

struct Pnt{
    NSUInteger x;
    NSUInteger y;
};

struct Quadrilateral{
    Pnt upperLeft;
    Pnt upperRight;
    Pnt lowerLeft;
    Pnt lowerRight;
};



@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet PointView *topLeftView;
@property (weak, nonatomic) IBOutlet PointView *topRightView;
@property (weak, nonatomic) IBOutlet PointView *bottomRightView;
@property (weak, nonatomic) IBOutlet PointView *bottomLeftView;
@property (nonatomic) CGRect original;
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.original = self.imageView.layer.frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction:(id)sender {
//    UIView *view = self.imageView;
//    [view.layer ensureAnchorPointIsSetToZero]; // set the anchor point to [0, 0] (this method keeps the same position)
//    
//    AGKQuad quad = view.layer.quadrilateral;
//
////    quad.br.x += 20; // shift bottom right x-value with 20 pixels
////    quad.br.y += 50; // shift bottom right y-value with 50 pixels
//    CGPoint topLeft = view.layer.frame.origin;
//    CGPoint topRight = CGPointMake(view.layer.frame.origin.x + view.layer.frame.size.width, view.layer.frame.origin.y);
//    CGPoint bottomRight = CGPointMake(view.layer.frame.origin.x + view.layer.frame.size.width, view.layer.frame.origin.y + view.layer.frame.size.height);
//    CGPoint bottomLeft = CGPointMake(view.layer.frame.origin.x , view.layer.frame.origin.y + view.layer.frame.size.height);
//    
//    CGFloat tlxa = self.topLeftView.center.x - topLeft.x;
//    quad.tl.x += tlxa;
//    CGFloat tlya = self.topLeftView.center.y - topLeft.y;
//    quad.tl.y += tlya;
//    
//    CGFloat trxa = self.topRightView.center.x - topRight.x;
//    quad.tr.x += trxa;
//    CGFloat trya = self.topRightView.center.y - topRight.y;
//    quad.tr.y += trya;
//
//    CGFloat brxa = self.bottomRightView.center.x - bottomRight.x;
//    quad.br.x += brxa;
//    CGFloat brya = self.bottomRightView.center.y - bottomRight.y;
//    quad.br.y += brya;
//
//    CGFloat blxa = self.bottomLeftView.center.x - bottomLeft.x;
//    quad.bl.x += blxa;
//    CGFloat blya = self.bottomLeftView.center.y - bottomLeft.y;
//    quad.bl.y += blya;
//
//    
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        view.layer.quadrilateral = quad; // the quad is converted to CATransform3D and applied
//    }];
//
		
    
//    Quadrilateral from;
//    from.upperLeft.x = self.topLeftView.center.x;
//    from.upperLeft.y = self.topLeftView.center.y;
//    
//    from.upperRight.x = self.topRightView.center.x;
//    from.upperRight.y = self.topRightView.center.y;
//    
//    from.lowerLeft.x = self.bottomLeftView.center.x;
//    from.lowerLeft.y = self.bottomLeftView.center.x;
//    
//    from.lowerRight.x = self.bottomRightView.center.x;
//    from.lowerRight.y = self.bottomRightView.center.x;
//    
//    Quadrilateral to;
//    to.upperLeft.x = self.imageView.frame.origin.x;
//    to.upperLeft.y = self.imageView.frame.origin.y;
//    
//    to.upperRight.x = self.imageView.frame.origin.x + self.imageView.frame.size.width;
//    to.upperRight.y = self.imageView.frame.origin.y;
//    
//    to.lowerLeft.x = self.imageView.frame.origin.x;
//    to.lowerLeft.y = self.imageView.frame.origin.y + self.imageView.frame.size.height;
//    
//    to.lowerRight.x = self.imageView.frame.origin.x + self.imageView.frame.size.width;
//    to.lowerRight.y = self.imageView.frame.origin.y + self.imageView.frame.size.height;
//    
//    
//    CATransform3D transform = [ViewController transformQuadrilateral:from toQuadrilateral:to];
//    self.imageView.layer.transform = transform;
}
- (IBAction)resetButtonAction:(id)sender {
//
//    [UIView animateWithDuration:1.0 animations:^{
//        AGKQuad quad = AGKQuadMakeWithCGRect(self.original);
//        self.imageView.layer.quadrilateral = quad;
//    }];


}

+ (CATransform3D)transformQuadrilateral:(Quadrilateral)origin toQuadrilateral:(Quadrilateral)destination {
    
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

+ (CvPoint2D32f *)openCVMatrixWithQuadrilateral:(Quadrilateral)origin {
    
    CvPoint2D32f *cvsrc = (CvPoint2D32f *)malloc(4*sizeof(CvPoint2D32f));
    cvsrc[0].x = origin.upperLeft.x;
    cvsrc[0].y = origin.upperLeft.y;
    cvsrc[1].x = origin.upperRight.x;
    cvsrc[1].y = origin.upperRight.y;
    cvsrc[2].x = origin.lowerRight.x;
    cvsrc[2].y = origin.lowerRight.y;
    cvsrc[3].x = origin.lowerLeft.x;
    cvsrc[3].y = origin.lowerLeft.y;
    return cvsrc;
}

+ (CATransform3D)transform3DWithCMatrix:(float *)matrix {
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


- (void)confirmedImage
{
    UIImage *_sourceImage = self.imageView.image;
    UIImageView *_sourceImageView = self.imageView;
    
    cv::Mat originalRot = [self cvMatFromUIImage:_sourceImage];
    cv::Mat original;
    cv::transpose(originalRot, original);
    
    originalRot.release();
    
    cv::flip(original, original, 1);
    
    
    CGFloat scaleFactor =  1.0;//[_sourceImageView contentScale];
    
    
//    CGPoint topLeft = view.layer.frame.origin;
//    CGPoint topRight = CGPointMake(view.layer.frame.origin.x + view.layer.frame.size.width, view.layer.frame.origin.y);
//    CGPoint bottomRight = CGPointMake(view.layer.frame.origin.x + view.layer.frame.size.width, view.layer.frame.origin.y + view.layer.frame.size.height);
//    CGPoint bottomLeft = CGPointMake(view.layer.frame.origin.x , view.layer.frame.origin.y + view.layer.frame.size.height);
//
//    CGFloat tlxa = self.topLeftView.center.x - topLeft.x;
//    quad.tl.x += tlxa;
//    CGFloat tlya = self.topLeftView.center.y - topLeft.y;
//    quad.tl.y += tlya;
//
//    CGFloat trxa = self.topRightView.center.x - topRight.x;
//    quad.tr.x += trxa;
//    CGFloat trya = self.topRightView.center.y - topRight.y;
//    quad.tr.y += trya;
//
//    CGFloat brxa = self.bottomRightView.center.x - bottomRight.x;
//    quad.br.x += brxa;
//    CGFloat brya = self.bottomRightView.center.y - bottomRight.y;
//    quad.br.y += brya;
//
//    CGFloat blxa = self.bottomLeftView.center.x - bottomLeft.x;
//    quad.bl.x += blxa;
//    CGFloat blya = self.bottomLeftView.center.y - bottomLeft.y;
//    quad.bl.y += blya;
    
//    CGPoint ptBottomLeft = [_adjustRect coordinatesForPoint:1 withScaleFactor:scaleFactor];
//    CGPoint ptBottomRight = [_adjustRect coordinatesForPoint:2 withScaleFactor:scaleFactor];
//    CGPoint ptTopRight = [_adjustRect coordinatesForPoint:3 withScaleFactor:scaleFactor];
//    CGPoint ptTopLeft = [_adjustRect coordinatesForPoint:4 withScaleFactor:scaleFactor];

    CGPoint ptBottomLeft = self.bottomLeftView.center;
    CGPoint ptBottomRight = self.bottomRightView.center;
    CGPoint ptTopRight = self.topRightView.center;
    CGPoint ptTopLeft = self.topLeftView.center;

    
    CGFloat w1 = sqrt( pow(ptBottomRight.x - ptBottomLeft.x , 2) + pow(ptBottomRight.x - ptBottomLeft.x, 2));
    CGFloat w2 = sqrt( pow(ptTopRight.x - ptTopLeft.x , 2) + pow(ptTopRight.x - ptTopLeft.x, 2));
    
    CGFloat h1 = sqrt( pow(ptTopRight.y - ptBottomRight.y , 2) + pow(ptTopRight.y - ptBottomRight.y, 2));
    CGFloat h2 = sqrt( pow(ptTopLeft.y - ptBottomLeft.y , 2) + pow(ptTopLeft.y - ptBottomLeft.y, 2));
    
    CGFloat maxWidth = (w1 < w2) ? w1 : w2;
    CGFloat maxHeight = (h1 < h2) ? h1 : h2;
    
    cv::Point2f src[4], dst[4];
    src[0].x = ptTopLeft.x;
    src[0].y = ptTopLeft.y;
    src[1].x = ptTopRight.x;
    src[1].y = ptTopRight.y;
    src[2].x = ptBottomRight.x;
    src[2].y = ptBottomRight.y;
    src[3].x = ptBottomLeft.x;
    src[3].y = ptBottomLeft.y;
    
    dst[0].x = 0;
    dst[0].y = 0;
    dst[1].x = maxWidth - 1;
    dst[1].y = 0;
    dst[2].x = maxWidth - 1;
    dst[2].y = maxHeight - 1;
    dst[3].x = 0;
    dst[3].y = maxHeight - 1;
    
    cv::Mat undistorted = cv::Mat( cvSize(maxWidth,maxHeight), CV_8UC1);
    cv::warpPerspective(original, undistorted, cv::getPerspectiveTransform(src, dst), cvSize(maxWidth, maxHeight));
    
    UIImage *newImage = [self UIImageFromCVMat:undistorted];
    
    undistorted.release();
    original.release();
    
    [_sourceImageView setNeedsDisplay];
    [_sourceImageView setImage:newImage];
//    [_sourceImageView setContentMode:UIViewContentModeScaleAspectFit];
    
}

- (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                     // Width
                                        cvMat.rows,                                     // Height
                                        8,                                              // Bits per component
                                        8 * cvMat.elemSize(),                           // Bits per pixel
                                        cvMat.step[0],                                  // Bytes per row
                                        colorSpace,                                     // Colorspace
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,  // Bitmap info flags
                                        provider,                                       // CGDataProviderRef
                                        NULL,                                           // Decode
                                        false,                                          // Should interpolate
                                        kCGRenderingIntentDefault);                     // Intent
    
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return image;
}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.height;
    CGFloat rows = image.size.width;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

@end
