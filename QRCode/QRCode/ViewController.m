//
//  ViewController.m
//  QRCode
//
//  Created by 余亮 on 16/2/21.
//  Copyright © 2016年 余亮. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
#import "UIImage+QRCode.h"
#import "ScaningViewController.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIImageView *middleImgV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1.常滤镜对象
    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"]; //CIQRCodeGenerator：固定写法
    
    //2.设置二维码的数据（通过KVC）
        //需要把字符串转为NSDate
//    NSString * NameStr = @"手扶拖拉机";   //扫描一个字符串
    NSString * UrlStr = @"https://github.com/YL19930403";   //扫描一个连接
    NSData * data = [UrlStr dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    //3.获取二维码
    CIImage * outputImage = [filter outputImage];
    self.middleImgV.image = [UIImage imageNamed:@"me"];
//    self.imageV.image = [UIImage imageWithCIImage:outputImage];
   self.imageV.image = [UIImage createNonInterpolatedUIImageFromCIImage:outputImage withSize:200];
}


- (IBAction)ButtonClick:(UIButton *)sender {
    ScaningViewController * scaningVC = [ScaningViewController scaningViewController];
    [self presentViewController:scaningVC animated:YES completion:nil];
}

@end








