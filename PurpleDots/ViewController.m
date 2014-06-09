//
//  ViewController.m
//  Tricks
//
//  Created by Zakk Hoyt on 6/8/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "ViewController.h"


const NSUInteger capacity = 12;

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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    self.blurSegment.selectedSegmentIndex = 3;
    self.timeSlider.value = 4;
    
    
    self.dots = [[NSMutableArray alloc]initWithCapacity:capacity];
    
    CGRect smallFrame;
    CGRect largeFrame;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        smallFrame = CGRectMake(0, 0, 8, 8);
        largeFrame = CGRectMake(0, 0, 100, 100);
        
    } else {
        smallFrame = CGRectMake(0, 0, 4, 4);
        largeFrame = CGRectMake(0, 0, 40, 40);
    }
    
    // purple dots
    for(NSUInteger index = 0; index < capacity; index++){
        float angle = -2 * M_PI * index / capacity;
        float xOffset = sin(angle) * self.view.bounds.size.width / 2.0 * 0.75;
        float yOffset = cos(angle) * self.view.bounds.size.width / 2.0 * 0.75;;
        
        UIView *dot = [self addDotToView:self.view frame:largeFrame center:CGPointMake(self.view.center.x + xOffset, self.view.center.y + yOffset) color:[UIColor magentaColor]];
        [self.dots addObject:dot];
    }
#if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1)
    self.centerDot = [self addDotToView:self.blurView.contentView frame:smallFrame center:self.view.center color:[UIColor blackColor]];
#else
    self.centerDot = [self addDotToView:self.view frame:smallFrame center:self.view.center color:[UIColor blackColor]];
    self.blurSegment.hidden = YES;
#endif
    [self timeSliderValueChange:self.timeSlider];
    
    [self showControls];
    
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
    
    for(NSUInteger index = 0; index < capacity; index++){
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
    
    if(self.currentIndex == capacity - 1){
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
    [self showControls];
}

-(void)showControls{
    [UIView animateWithDuration:0.2 animations:^{
        self.infoLabel.alpha = 1.0;
        self.colorSegment.alpha = 1.0;
        self.timeSlider.alpha = 1.0;
        self.blurSegment.alpha = 1.0;
    }];
    
    if(self.alphaTimer){
        [self.alphaTimer invalidate];
        _alphaTimer = nil;
    }
    
    self.alphaTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
    
}
-(void)hideControls{
    [UIView animateWithDuration:0.2 animations:^{
        self.infoLabel.alpha = 0.0;
        self.colorSegment.alpha = 0.0;
        self.timeSlider.alpha = 0.0;
        self.blurSegment.alpha = 0.0;
    }];
    
    [self.alphaTimer invalidate];
    _alphaTimer = nil;
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
    
    [self.blurView.contentView addSubview:self.infoLabel];
    [self.blurView.contentView addSubview:self.colorSegment];
    [self.blurView.contentView addSubview:self.timeSlider];
    [self.blurView.contentView addSubview:self.blurSegment];
    [self.blurView.contentView addSubview:self.centerDot];
    
#endif
}

- (IBAction)timeSliderValueChange:(UISlider*)sender {
    [self.timer invalidate];
    _timer = nil;
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 / (float)capacity / (float)sender.value target:self selector:@selector(cycleDot) userInfo:nil repeats:YES];
    
}

- (IBAction)colorSegmentValueChanged:(UISegmentedControl*)sender {
    if(sender.selectedSegmentIndex == 0){
        [self setDotsColor:[UIColor magentaColor]];
    } else if(sender.selectedSegmentIndex == 1){
        [self setDotsColor:[UIColor redColor]];
    } else if(sender.selectedSegmentIndex == 2){
        [self setDotsColor:[UIColor greenColor]];
    } else if(sender.selectedSegmentIndex == 3){
        [self setDotsColor:[UIColor cyanColor]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
