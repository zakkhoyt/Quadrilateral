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

//#import "AGGeometryKit.h"
//#import "UIView_Quadrilateral.h"
////#import "UIImage+AGKQuad.h"



#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <iostream>

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



@interface ViewController ()

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
//    self.imageView = [[UIImageView alloc]init];
    
    self.imageView.contentMode = UIViewContentModeScaleToFill;
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.frame = self.view.bounds;
    self.imageView.backgroundColor = [UIColor greenColor];

    //    self.imageView.center = self.view.center;
    [self.view addSubview:self.imageView];
    
    [self.view bringSubviewToFront:self.topLeftView];
    [self.view bringSubviewToFront:self.topRightView];
    [self.view bringSubviewToFront:self.bottomLeftView];
    [self.view bringSubviewToFront:self.bottomRightView];
    
    [self.view bringSubviewToFront:self.resetButton];
    
    [self.view bringSubviewToFront:self.distortButton];

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
    
    
    
    
//    AGKQuad quad = [self quadForBlueToFill];
    
//    AGKQuad quad = view.layer.quadrilateral;
    
    //    quad.br.x += 20; // shift bottom right x-value with 20 pixels
    //    quad.br.y += 50; // shift bottom right y-value with 50 pixels
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
//    AGKQuad quad;
//    CGPoint topLeft = [self.view convertPoint:self.topLeftView.center toView:self.imageView];
//    NSLog(@"topLeft: %@", NSStringFromCGPoint(topLeft));
//    quad.tl = topLeft;
//
//    
//    CGPoint topRight = [self.view convertPoint:self.topRightView.center toView:self.imageView];
//    NSLog(@"topRight: %@", NSStringFromCGPoint(topRight));
//    quad.tr = topRight;
//
//    
//    CGPoint bottomLeft = [self.view convertPoint:self.bottomLeftView.center toView:self.imageView];
//    NSLog(@"bottomLeft: %@", NSStringFromCGPoint(bottomLeft));
//    quad.bl = bottomLeft;
//
//    
//    CGPoint bottomRight = [self.view convertPoint:self.bottomRightView.center toView:self.imageView];
//    NSLog(@"bottomRight: %@", NSStringFromCGPoint(bottomRight));
//    quad.br = bottomRight;
//
//    self.imageView.image = [self.imageView.image imageWithQuad:quad scale:1.0];

    
//    const Point2f boxPoints[4] = {
//        {0, 0},
//        {0, 0},
//        {0, 0},
//        {0, 0}
//    };
//
//    const Point2f target[4] = {
//        {0, 0},
//        {0, 0},
//        {0, 0},
//        {0, 0}
//    };
//
//    cv::Mat mat = cv::getPerspectiveTransform(boxPoints, target);
//    cv::warpPerspective([photo CVMat], result, mat, cv::Size(width, height));
    
    // See solution here: http://stackoverflow.com/questions/7838487/executing-cvwarpperspective-for-a-fake-deskewing-on-a-set-of-cvpoint
    
    
//    CATransform3D t = [ViewController rectToQuad:self.imageView.bounds quadTL:self.topLeftView.center quadTR:self.topRightView.center quadBL:self.bottomLeftView.center quadBR:self.bottomRightView.center];
//    [UIView animateWithDuration:1.0 animations:^{
//        self.imageView.layer.transform = t;
//    }];
    
    
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
//
//    Quadrilateral quadFrom;
////    float scale = 0.5;
//    float scale = 1.0;
//    quadFrom.topLeft.x = self.topLeftView.layer.frame.origin.x / scale;
//    quadFrom.topLeft.y = self.topLeftView.layer.frame.origin.y / scale;
//    quadFrom.topRight.x = self.topRightView.layer.frame.origin.x / scale;
//    quadFrom.topRight.y = self.topRightView.layer.frame.origin.y / scale;
//    quadFrom.bottomLeft.x = self.bottomLeftView.layer.frame.origin.x / scale;
//    quadFrom.bottomLeft.y = self.bottomLeftView.layer.frame.origin.y / scale;
//    quadFrom.bottomRight.x = self.bottomRightView.layer.frame.origin.x / scale;
//    quadFrom.bottomRight.y = self.bottomRightView.layer.frame.origin.y / scale;
//    
//    Quadrilateral quadTo;
//    quadTo.topLeft.x = self.view.layer.frame.origin.x;
//    quadTo.topLeft.y = self.view.layer.frame.origin.y;
//    quadTo.topRight.x = self.view.layer.frame.origin.x + self.view.frame.size.width;
//    quadTo.topRight.y = self.view.layer.frame.origin.y;
//    quadTo.bottomLeft.x = self.view.layer.frame.origin.x;
//    quadTo.bottomLeft.y = self.view.layer.frame.origin.y + self.view.frame.size.height;
//    quadTo.bottomRight.x = self.view.layer.frame.origin.x + self.view.frame.size.width;
//    quadTo.bottomRight.y = self.view.layer.frame.origin.y + self.view.frame.size.height;
//
// 
    CATransform3D t = [self transformQuadrilateral:quadFrom toQuadrilateral:quadTo];
//    CATransform3D tt = CATransform3DScale(t, 0.5, 0.5, 1.0);
//    CATransform3D tt = CATransform3DTranslate(t, -0.5, -0.5, 0);
    self.imageView.layer.anchorPoint = CGPointMake(0, 0);
//    self.imageView.layer.anchorPoint = self.view.center;
//    [self.imageView.layer ensureAnchorPointIsSetToZero];
    [UIView animateWithDuration:1.0 animations:^{
        self.imageView.layer.transform = t;
    }];

    
    
    
    
//    [self.view transformToFitQuadTopLeft:self.topLeftView.center topRight:self.topRightView.center bottomLeft:self.bottomLeftView.center bottomRight:self.bottomRightView.center];
    

}
- (IBAction)resetButtonAction:(id)sender {
//
//    [UIView animateWithDuration:1.0 animations:^{
//        AGKQuad quad = AGKQuadMakeWithCGRect(self.original);
//        self.imageView.layer.quadrilateral = quad;
//    }];

//    self.imageView.image = [UIImage imageNamed:@"ocrfeeder_skewed1"];

    [self setupImage];

}



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

+ (CATransform3D)rectToQuad:(CGRect)rect
                     quadTL:(CGPoint)topLeft
                     quadTR:(CGPoint)topRight
                     quadBL:(CGPoint)bottomLeft
                     quadBR:(CGPoint)bottomRight
{
    return [self rectToQuad:rect quadTLX:topLeft.x quadTLY:topLeft.y quadTRX:topRight.x quadTRY:topRight.y quadBLX:bottomLeft.x quadBLY:bottomLeft.y quadBRX:bottomRight.x quadBRY:bottomRight.y];
}

+ (CATransform3D)rectToQuad:(CGRect)rect
                    quadTLX:(CGFloat)x1a
                    quadTLY:(CGFloat)y1a
                    quadTRX:(CGFloat)x2a
                    quadTRY:(CGFloat)y2a
                    quadBLX:(CGFloat)x3a
                    quadBLY:(CGFloat)y3a
                    quadBRX:(CGFloat)x4a
                    quadBRY:(CGFloat)y4a
{
    CGFloat X = rect.origin.x;
    CGFloat Y = rect.origin.y;
    CGFloat W = rect.size.width;
    CGFloat H = rect.size.height;
    
    CGFloat y21 = y2a - y1a;
    CGFloat y32 = y3a - y2a;
    CGFloat y43 = y4a - y3a;
    CGFloat y14 = y1a - y4a;
    CGFloat y31 = y3a - y1a;
    CGFloat y42 = y4a - y2a;
    
    CGFloat a = -H*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42);
    CGFloat b = W*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);
    CGFloat c = H*X*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42) - H*W*x1a*(x4a*y32 - x3a*y42 + x2a*y43) - W*Y*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);
    
    CGFloat d = H*(-x4a*y21*y3a + x2a*y1a*y43 - x1a*y2a*y43 - x3a*y1a*y4a + x3a*y2a*y4a);
    CGFloat e = W*(x4a*y2a*y31 - x3a*y1a*y42 - x2a*y31*y4a + x1a*y3a*y42);
    CGFloat f = -(W*(x4a*(Y*y2a*y31 + H*y1a*y32) - x3a*(H + Y)*y1a*y42 + H*x2a*y1a*y43 + x2a*Y*(y1a - y3a)*y4a + x1a*Y*y3a*(-y2a + y4a)) - H*X*(x4a*y21*y3a - x2a*y1a*y43 + x3a*(y1a - y2a)*y4a + x1a*y2a*(-y3a + y4a)));
    
    CGFloat g = H*(x3a*y21 - x4a*y21 + (-x1a + x2a)*y43);
    CGFloat h = W*(-x2a*y31 + x4a*y31 + (x1a - x3a)*y42);
    CGFloat i = W*Y*(x2a*y31 - x4a*y31 - x1a*y42 + x3a*y42) + H*(X*(-(x3a*y21) + x4a*y21 + x1a*y43 - x2a*y43) + W*(-(x3a*y2a) + x4a*y2a + x2a*y3a - x4a*y3a - x2a*y4a + x3a*y4a));
    
    const double kEpsilon = 0.0001;
    
    if(fabs(i) < kEpsilon)
    {
        i = kEpsilon* (i > 0 ? 1.0 : -1.0);
    }
    
    CATransform3D transform = {a/i, d/i, 0, g/i, b/i, e/i, 0, h/i, 0, 0, 1, 0, c/i, f/i, 0, 1.0};
    
    return transform;
}

//
//-(void)test{
//    cv::Mat src = cv::imread(argv[1], 1);
//    
//    // After some magical procedure, these are points detect that represent
//    // the corners of the paper in the picture:
//    // [408, 69] [72, 2186] [1584, 2426] [1912, 291]
//    vector<Point> not_a_rect_shape;
//    not_a_rect_shape.push_back(Point(408, 69));
//    not_a_rect_shape.push_back(Point(72, 2186));
//    not_a_rect_shape.push_back(Point(1584, 2426));
//    not_a_rect_shape.push_back(Point(1912, 291));
//    
//    // For debugging purposes, draw green lines connecting those points
//    // and save it on disk
//    const Point* point = &not_a_rect_shape[0];
//    int n = (int)not_a_rect_shape.size();
//    Mat draw = src.clone();
//    polylines(draw, &point, &n, 1, true, Scalar(0, 255, 0), 3, CV_AA);
//    imwrite("draw.jpg", draw);
//    
//    // Assemble a rotated rectangle out of that info
//    RotatedRect box = minAreaRect(cv::Mat(not_a_rect_shape));
//    std::cout << "Rotated box set to (" << box.boundingRect().x << "," << box.boundingRect().y << ") " << box.size.width << "x" << box.size.height << std::endl;
//    
//    // Does the order of the points matter? I assume they do NOT.
//    // But if it does, is there an easy way to identify and order
//    // them as topLeft, topRight, bottomRight, bottomLeft?
//    cv::Point2f src_vertices[4];
//    src_vertices[0] = not_a_rect_shape[0];
//    src_vertices[1] = not_a_rect_shape[1];
//    src_vertices[2] = not_a_rect_shape[2];
//    src_vertices[3] = not_a_rect_shape[3];
//    
//    Point2f dst_vertices[4];
//    dst_vertices[0] = Point(0, 0);
//    dst_vertices[1] = Point(0, box.boundingRect().width-1);
//    dst_vertices[2] = Point(0, box.boundingRect().height-1);
//    dst_vertices[3] = Point(box.boundingRect().width-1, box.boundingRect().height-1);
//    
//    Mat warpMatrix = getPerspectiveTransform(src_vertices, dst_vertices);
//    
//    cv::Mat rotated;
//    warpPerspective(src, rotated, warpMatrix, rotated.size(), INTER_LINEAR, BORDER_CONSTANT);
//    
//    imwrite("rotated.jpg", rotated);
//}
@end
