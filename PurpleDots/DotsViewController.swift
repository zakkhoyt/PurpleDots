//
//  DotsViewController.swift
//  PurpleDots
//
//  Created by Zakk Hoyt on 6/9/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

import UIKit

class DotsViewController: UIViewController {

//    #if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1)
//    @property (nonatomic, strong) UIVisualEffectView *blurView;
//    #endif
//    @property (nonatomic, strong) NSMutableArray *dots;
//    @property (nonatomic) NSUInteger currentIndex;
//    @property (weak, nonatomic) IBOutlet UISegmentedControl *blurSegment;
//    @property (nonatomic, strong) UIView *centerDot;
//    @property (weak, nonatomic) IBOutlet UISlider *timeSlider;
//    @property (nonatomic, strong) NSTimer *timer;
//    @property (weak, nonatomic) IBOutlet UILabel *infoLabel;
//    @property (nonatomic, strong) NSTimer *alphaTimer;
//    @property (weak, nonatomic) IBOutlet UISegmentedControl *colorSegment;
    var blurView: UIVisualEffectView
    var dots = Array<UIView>()
    var currentIndex: Int
    @IBOutlet var blurSegment : UISegmentedControl
    var centerDot: UIView
    @IBOutlet var timeSlider : UISlider
    var timer: NSTimer
    @IBOutlet var infoLabel : UILabel
    var alphaTimer: NSTimer
    @IBOutlet var colorSegment : UISegmentedControl
    
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        blurView = UIVisualEffectView()
        currentIndex = 0
        centerDot = UIView()
        timer = NSTimer()
        alphaTimer = NSTimer()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
