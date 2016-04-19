//
//  ViewController.m
//  GameKit
//
//  Created by Joe on 16/4/19.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "ViewController.h"
#import <GameKit/GameKit.h>

@interface ViewController ()<GKPeerPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iamgeView;

@property (strong, nonatomic)GKSession *session;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
// 建立连接
- (IBAction)connection:(UIButton *)sender {
    
    GKPeerPickerController *ppc = [[GKPeerPickerController alloc] init];
    
    // 设置代理监听连接成功的方法
    ppc.delegate = self;
    
    [ppc show];
    
    
    
}




- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    
    [picker dismiss];
    self.session = session;
    
    [self.session setDataReceiveHandler:self
                            withContext:nil];
    
}
// 发送数据
- (IBAction)send:(UIButton *)sender {
    if (self.iamgeView.image == nil) {
        return;
    }
    
    [self.session sendDataToAllPeers:UIImagePNGRepresentation(self.iamgeView.image) withDataMode:GKSendDataReliable error:nil];
    
}

//// 连接成功就会调用
//- (void)peerPickerController:(GKPeerPickerController *)picker // 弹窗
//              didConnectPeer:(NSString *)peerID // 连接到的蓝牙设备号
//                   toSession:(GKSession *)session // 连接会话(通过它进行数据交互)
//{
//    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
//    // 弹窗消失
//    [picker dismiss];
//    // 保存会话
//    self.session = session;
//    // 处理接收到的数据[蓝牙设备接收到数据时,就会调用 [self receiveData:fromPeer:inSession:context:]]
//    // 设置数据接受者为:self
//    
//}
#pragma mark - 蓝牙设备接收到数据时,就会调用
- (void)receiveData:(NSData *)data // 数据
           fromPeer:(NSString *)peer // 来自哪个设备
          inSession:(GKSession *)session // 连接会话
            context:(void *)context
{
    // 显示
    self.iamgeView.image = [UIImage imageWithData:data];
    // 写入相册
    UIImageWriteToSavedPhotosAlbum(self.iamgeView.image, nil, nil, nil);
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:peer message:peer preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    ipc.delegate = self;
    
    [self presentViewController:ipc animated:YES completion:nil];
    
    
}


// UIImagePickerController代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.iamgeView.image = info[UIImagePickerControllerOriginalImage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
