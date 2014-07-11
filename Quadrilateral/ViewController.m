//
//  ViewController.m
//  Quadrilateral
//
//  Created by Zakk Hoyt on 7/11/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "ViewController.h"
#import "AGGeometryKit.h"
#import "PointView.h"

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
    UIView *view = self.imageView;
    [view.layer ensureAnchorPointIsSetToZero]; // set the anchor point to [0, 0] (this method keeps the same position)
    
    AGKQuad quad = view.layer.quadrilateral;

//    quad.br.x += 20; // shift bottom right x-value with 20 pixels
//    quad.br.y += 50; // shift bottom right y-value with 50 pixels
    CGPoint topLeft = view.layer.frame.origin;
    CGPoint topRight = CGPointMake(view.layer.frame.origin.x + view.layer.frame.size.width, view.layer.frame.origin.y);
    CGPoint bottomRight = CGPointMake(view.layer.frame.origin.x + view.layer.frame.size.width, view.layer.frame.origin.y + view.layer.frame.size.height);
    CGPoint bottomLeft = CGPointMake(view.layer.frame.origin.x , view.layer.frame.origin.y + view.layer.frame.size.height);
    
    CGFloat tlxa = self.topLeftView.center.x - topLeft.x;
    quad.tl.x += tlxa;
    CGFloat tlya = self.topLeftView.center.y - topLeft.y;
    quad.tl.y += tlya;
    
    CGFloat trxa = self.topRightView.center.x - topRight.x;
    quad.tr.x += trxa;
    CGFloat trya = self.topRightView.center.y - topRight.y;
    quad.tr.y += trya;

    CGFloat brxa = self.bottomRightView.center.x - bottomRight.x;
    quad.br.x += brxa;
    CGFloat brya = self.bottomRightView.center.y - bottomRight.y;
    quad.br.y += brya;

    CGFloat blxa = self.bottomLeftView.center.x - bottomLeft.x;
    quad.bl.x += blxa;
    CGFloat blya = self.bottomLeftView.center.y - bottomLeft.y;
    quad.bl.y += blya;

    
    
    [UIView animateWithDuration:1.0 animations:^{
        view.layer.quadrilateral = quad; // the quad is converted to CATransform3D and applied
    }];
    

}
- (IBAction)resetButtonAction:(id)sender {

    [UIView animateWithDuration:1.0 animations:^{
        AGKQuad quad = AGKQuadMakeWithCGRect(self.original);
        self.imageView.layer.quadrilateral = quad;
    }];


}

@end
