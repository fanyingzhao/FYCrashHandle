//
//  ViewController.m
//  闪退
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ViewController.h"
#import "TempView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic, strong) TempView* tempView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@",NSHomeDirectory());
    [self.btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.tempView = [[TempView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.tempView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.tempView];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pressBtn:(UIButton*)btn
{
    [self.tempView removeFromSuperview];
    self.tempView = nil;
    
    
    NSArray* array = [NSArray arrayWithObjects:@"a",@"b",@"c", nil];
    [array objectAtIndex:5];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.tempView.backgroundColor = [UIColor redColor];
        [self.tempView temp];
    });
}

@end
