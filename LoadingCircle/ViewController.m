//
//  ViewController.m
//  LoadingCircle
//
//  Created by wangwendong on 16/1/5.
//  Copyright © 2016年 sunricher. All rights reserved.
//

#import "ViewController.h"
#import "WMLoadingCircelView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet WMLoadingCircelView *loadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [_loadingView start];
}

- (IBAction)updateValue:(id)sender {
    [_loadingView updateProgressCurrentValue:(arc4random_uniform(101) / 100.f )];
}

- (IBAction)startOrStop:(id)sender {
    UIButton *startOrStopButton = (UIButton *)sender;
    
    [startOrStopButton setSelected:!startOrStopButton.isSelected];
    
    if (startOrStopButton.isSelected) {
        [_loadingView start];
    } else {
        [_loadingView stopWithCompletion:^{
            [_loadingView updateProgressCurrentValue:0.5];
        }];
    }
}

- (IBAction)updateProgressColor:(id)sender {
    switch ([sender tag]) {
        case 0: {
            [_loadingView updateProgressColor:[UIColor redColor]];
        
            break;
        }
        case 1: {
            [_loadingView updateProgressColor:[UIColor greenColor]];
        
            break;
        }
        case 2: {
            [_loadingView updateProgressColor:[UIColor blueColor]];
        
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

@end
