//
//  ViewController.m
//  Tricks
//
//  Created by Zakk Hoyt on 6/8/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//
//  Images:

//  http://www.geek.com/wp-content/uploads/2013/10/12.gif
//  http://www.moillusions.com/wp-content/uploads/2013/09/cool_optical_illusion_03.gif
//  http://www.cartographersguild.com/attachments/general-miscellaneous-mapping/2189d1201121550-optical-illusion-graphic-map-object-no-holes.gif
//
//  A bunch:
//  http://izismile.com/2013/11/04/hypnotic_optical_illusion_gifs_that_are_just_too_1_pic_17_gifs.html
//  http://www.pomakis.com/opticalIllusions/
#import "ViewController.h"


@interface ViewController ()
#if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1)
@property (nonatomic, strong) UIVisualEffectView *blurView;
#endif
@property (nonatomic, strong) NSMutableArray *dots;
@property (nonatomic) NSUInteger currentIndex;
@property (weak, nonatomic) IBOutlet UISegmentedControl *blurSegment;
@property (nonatomic, strong) UIView *centerDot;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) NSTimer *alphaTimer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorSegment;
@property (weak, nonatomic) IBOutlet UISlider *countSlider;
@property (nonatomic) CGRect smallFrame;
@property (nonatomic) CGRect largeFrame;
@property (nonatomic) NSUInteger capacity;
@property (nonatomic) BOOL controlsHidden;
@property (nonatomic) NSUInteger colorIndex;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    self.blurSegment.selectedSegmentIndex = 3;
    self.timeSlider.value = 4;
    
    
    self.capacity = 12;
    
    self.countSlider.value = self.capacity;
    
    self.dots = [[NSMutableArray alloc]initWithCapacity:self.capacity];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.smallFrame = CGRectMake(0, 0, 8, 8);
        self.largeFrame = CGRectMake(0, 0, 100, 100);
        
    } else {
        self.smallFrame = CGRectMake(0, 0, 4, 4);
        self.largeFrame = CGRectMake(0, 0, 40, 40);
    }

    [self configureDots];
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1)
    self.centerDot = [self addDotToView:self.blurView.contentView frame:self.smallFrame center:self.view.center color:[UIColor blackColor]];
#else
    self.centerDot = [self addDotToView:self.view frame:self.smallFrame center:self.view.center color:[UIColor blackColor]];
    self.blurSegment.hidden = YES;
#endif
    
    // Start animation timer
    [self timeSliderValueChange:self.timeSlider];

    [self showControls];
    
    self.alphaTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
}

-(BOOL)shouldAutorotate{
    return NO;
}

-(void)configureDots{
    
    // Remove all dots by animating them shrinking to nothing
    for(UIView *dot in self.dots){
        [UIView animateWithDuration:0.2 animations:^{
            dot.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL finished) {
            [dot removeFromSuperview];
            [self.dots removeObject:dot];
        }];
    }


    
    
    // Add new dots
    for(NSUInteger index = 0; index < self.capacity; index++){
        float radius = self.view.bounds.size.width / 2.0 * 0.75;
        float angle = -2 * M_PI * index / self.capacity;
        float xOffset = sin(angle) * radius;
        float yOffset = cos(angle) * radius;
        
        float circumference = 2 * M_PI * radius;
        float dotDiameter = circumference / self.capacity / 2.0;
        
        UIView *dot = [self addDotToView:self.view frame:CGRectMake(0, 0, dotDiameter, dotDiameter) center:self.view.center color:[self colorFromColorIndex]];
        [UIView animateWithDuration:0.2 animations:^{
            dot.center = CGPointMake(self.view.center.x + xOffset, self.view.center.y + yOffset);
        }];
        
        [self.dots addObject:dot];
    }
    
    self.currentIndex = 0;
    
    if(self.blurView){
        [self.view addSubview:self.blurView];
    }

}
-(UIView*)addDotToView:(UIView*)view frame:(CGRect)frame center:(CGPoint)center color:(UIColor*)color{
    UIView *dot = [[UIView alloc]initWithFrame:frame];
    dot.backgroundColor = color;
    dot.layer.cornerRadius = frame.size.width / 2.0;
    dot.center = center;
    [self.view addSubview:dot];
    return dot;
}


-(void)cycleDot{
    
    for(NSUInteger index = 0; index < self.capacity; index++){
        UIView *dot = self.dots[index];
        if(index == self.currentIndex){
            //            [UIView animateWithDuration:0.1 animations:^{
            dot.alpha = 0.0;
            //            }];
            
        } else {
            //            [UIView animateWithDuration:0.1 animations:^{
            dot.alpha = 1.0;
            //            }];
            
        }
    }
    
    if(self.currentIndex == self.capacity - 1){
        self.currentIndex = 0;
    } else {
        self.currentIndex++;
    }
}

-(void)setDotsColor:(UIColor*)color{
    for(UIView *dot in self.dots) {
        dot.backgroundColor = color;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self showControls];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.controlsHidden){
        [self showControls];
    } else {
        [self hideControls];
    }
}

-(void)showControls{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.infoLabel.alpha = 1.0;
        self.colorSegment.alpha = 1.0;
        self.timeSlider.alpha = 1.0;
        self.blurSegment.alpha = 1.0;
        self.countSlider.alpha = 1.0;
    }];
    
    self.controlsHidden = NO;
}
-(void)hideControls{
    [UIView animateWithDuration:0.2 animations:^{
        self.infoLabel.alpha = 0.0;
        self.colorSegment.alpha = 0.0;
        self.timeSlider.alpha = 0.0;
        self.blurSegment.alpha = 0.0;
        self.countSlider.alpha = 0.0;
    }];
    
    self.controlsHidden = YES;
}



-(IBAction)blurSegmentValueChanged:(UISegmentedControl*)sender{
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1)
    UIVisualEffect *visualEffect;
    if(sender.selectedSegmentIndex == 0){
        visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    } else if(sender.selectedSegmentIndex == 1){
        visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    } else if(sender.selectedSegmentIndex == 2){
        visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
    
    if(self.blurView){
        [self.view addSubview:self.countSlider];
        [self.view addSubview:self.infoLabel];
        [self.view addSubview:self.colorSegment];
        [self.view addSubview:self.timeSlider];
        [self.view addSubview:self.centerDot];
        [self.view addSubview:self.blurSegment];
        
        [self.blurView removeFromSuperview];
        self.blurView = nil;
        
    }
    self.blurView = [[UIVisualEffectView alloc]initWithEffect:visualEffect];
    self.blurView.frame = self.view.frame;
    [self.view addSubview:self.blurView];
    
    [self.blurView.contentView addSubview:self.countSlider];
    [self.blurView.contentView addSubview:self.infoLabel];
    [self.blurView.contentView addSubview:self.colorSegment];
    [self.blurView.contentView addSubview:self.timeSlider];
    [self.blurView.contentView addSubview:self.blurSegment];
    [self.blurView.contentView addSubview:self.centerDot];
    
#endif
}

-(UIColor*)colorFromColorIndex{
    if(self.colorIndex == 0){
        return [UIColor magentaColor];
    } else if(self.colorIndex == 1){
        return [UIColor redColor];
    } else if(self.colorIndex == 2){
        return [UIColor greenColor];
    } else if(self.colorIndex == 3){
        return [UIColor cyanColor];
    }
    
    return [UIColor blackColor];
}

- (IBAction)timeSliderValueChange:(UISlider*)sender {
    [self.timer invalidate];
    _timer = nil;
    
    self.currentIndex = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 / (float)self.capacity / (float)sender.value target:self selector:@selector(cycleDot) userInfo:nil repeats:YES];
    
}

- (IBAction)colorSegmentValueChanged:(UISegmentedControl*)sender {
    self.colorIndex = sender.selectedSegmentIndex;
    [self setDotsColor:[self colorFromColorIndex]];
}

- (IBAction)countSliderTouchUpInside:(UISlider*)sender {
    self.capacity = sender.value;
    [self configureDots];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
