//
//  ScaningViewController.m
//  QRCode
//
//  Created by 余亮 on 16/2/21.
//  Copyright © 2016年 余亮. All rights reserved.
//

#import "ScaningViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScaningViewController ()<AVCaptureMetadataOutputObjectsDelegate>

/**
 *  捕捉会话
 */
@property(nonatomic,weak) AVCaptureSession * session ;

@property(nonatomic,weak) AVCaptureVideoPreviewLayer * layer ;

//@property(nonatomic,strong) UIWindow * lastWindow ;

@property(nonatomic,strong) UIButton * backButton ;


@end

@implementation ScaningViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backButton];

}



- (void) backButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    //1.创建捕捉会话
    AVCaptureSession * session = [[AVCaptureSession alloc] init];
    //2.给会话设置输入接口（input）
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [session addInput:input];
    
    //3.给会话设置输出接口
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    //4.添加预览图层
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.frame = self.view.bounds ;
    [self.view.layer addSublayer:layer];
    self.layer = layer ;
    
    //5.开始扫描
    [session startRunning];
    self.session = session ;
    
}
#pragma mark  -  AVCaptureMetadataOutput的代理方法
- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    AVMetadataMachineReadableCodeObject * object = [metadataObjects lastObject];
    //如果扫描到了数据
    if (object) {
        NSLog(@"%@",object.stringValue) ;
    }
    //去掉预览图层
    [self.layer removeFromSuperlayer];
    //停止扫描
    [self.session stopRunning];
}


- (instancetype)initScaningViewController
{
    if (self == [super init]) {
        self.view.backgroundColor = [UIColor orangeColor];
    }
    return self ;
}

+ (instancetype) scaningViewController
{
    return [[self alloc] initScaningViewController];
}

#pragma mark  - 懒加载
//- (UIWindow *)lastWindow
//{
//    NSArray * windows = [UIApplication sharedApplication].windows;
//    for (UIWindow * window in windows) {
//        if ([windows isKindOfClass:[UIWindow class]] && CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)) {
//            self.lastWindow = window ;
//            return window ;
//        }
//    }
//    return [UIApplication sharedApplication].keyWindow;
//}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 50,30)];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton ;
}


@end






