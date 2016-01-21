//
//  ViewController.m
//  CLAvatarPickerControllerDemo
//
//  Created by 蔡磊 on 16/1/21.
//  Copyright © 2016年 mamu. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "CLAvatarPickerController.h"

@interface ViewController ()
@property (nonatomic,strong)UIImageView * avatarView;
@property (nonatomic,strong)UIButton * pushBtn;
@end

@implementation ViewController
#pragma mark - lazy loading
- (UIImageView *)avatarView
{
    if(_avatarView == nil)
    {
        _avatarView = [[UIImageView alloc]init];
        
    }
    return _avatarView;
}

-(UIButton *)pushBtn
{
    if(_pushBtn == nil)
    {
        _pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _pushBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.avatarView];
    [self.view addSubview:self.pushBtn];
    
    self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.5);
        
    }];
    
    self.pushBtn.backgroundColor = [UIColor redColor];
    [self.pushBtn setTitle:@"click me to push" forState:UIControlStateNormal];
    [self.pushBtn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    self.pushBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(1.5);
    }];
    
    
    
}

#pragma mark - push event
- (void)push
{
    [CLAvatarPickerController showUpInPresentController:self fromInputImage:[UIImage imageNamed:@"avatar"] ToOutputImage:^(UIImage *outputImage) {
        self.avatarView.image = outputImage;
    }];
}

@end
