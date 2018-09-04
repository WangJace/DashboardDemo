//
//  ViewController.m
//  DashboardDemo
//
//  Created by 王傲云 on 2018/9/3.
//  Copyright © 2018 王傲云. All rights reserved.
//

#import "ViewController.h"
#import "WJDashboardView.h"

@interface ViewController ()

@property (nonatomic, strong) WJDashboardView *dashboardView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:0.07 green:0.62 blue:0.82 alpha:1.00];
    _dashboardView = [[WJDashboardView alloc] initWithFrame:CGRectMake(0, 0, 300, 160)];
    _dashboardView.center = self.view.center;
    _dashboardView.backgroundColor = [UIColor colorWithRed:0.07 green:0.62 blue:0.82 alpha:1.00];
    [self.view addSubview:_dashboardView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderValueChange:(UISlider *)sender {
    _valueLabel.text = [NSString stringWithFormat:@"%ld", (long)sender.value];
    _dashboardView.percent = sender.value;
}

@end
