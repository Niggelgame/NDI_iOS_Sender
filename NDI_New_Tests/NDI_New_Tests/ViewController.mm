//
//  ViewController.m
//  NDI_New_Tests
//
//  Created by Nicolas on 28.03.20.
//  Copyright © 2020 Kedil. All rights reserved.
//

#import "ViewController.h"
#import "include/Processing.NDI.Lib.h"
#import "NDI_New_Tests-Swift.h"
#import <AVKit/AVKit.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureStillImageOutput *photoOutput;
@property (nonatomic) BOOL streaming;
@property (nonatomic) NDIlib_send_instance_t pSend;

@end

@implementation ViewController
- (IBAction)stopStreaming:(id)sender {
    self.streaming = false;
}


void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}
//UIView *view;
//UIView *boxView;
- (IBAction)pleasestart:(id)sender {
    
    [self startStreaming];
}
//UIButton *button1= [UIButton buttonWithType:UIButtonTypeRoundedRect] ;


- (void) startStreaming {
    self.streaming = true;
    dispatch_queue_t queue = dispatch_queue_create("com.kedil.NDI-New-Tests", NULL);
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    
    
        
        printf("Yallah das ist ja super gelaufen!!! \r\n");
        
        
        
        
        
        NDIlib_video_frame_v2_t NDI_video_frame;
        NDI_video_frame.xres = 1920;
        NDI_video_frame.yres = 1080;
        NDI_video_frame.frame_rate_D = 500;
        NDI_video_frame.FourCC = NDIlib_FourCC_type_BGRX;
        NDI_video_frame.p_data = (uint8_t*)malloc(NDI_video_frame.xres*NDI_video_frame.yres * 4);
        
        //if(NDI_video_frame == NULL) printf("Fuck wir haben das frame verloren ):");
        
        
        printf("Funktioniert es? Bitte.... \r\n");
        
        
        
        
        
        while (self.streaming) {
            for (int idx = 200; idx; idx--)
                    {    // Fill in the buffer. It is likely that you would do something much smarter than this.
                        //memset((void*)NDI_video_frame.p_data, (idx & 1) ? 255 : 0, NDI_video_frame.xres*NDI_video_frame.yres * 4);
                        
                        memset((void*)NDI_video_frame.p_data, 255, NDI_video_frame.xres*NDI_video_frame.yres * 4);
                        
                        //[photoOutput captureStillImageAsynchronouslyFromConnection:[[photoOutput connections] objectAtIndex:0] completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                          //  CVImageBufferRef cameraFrame = CMSampleBufferGetImageBuffer(imageSampleBuffer);
                          //  CVPixelBufferLockBaseAddress(cameraFrame, 0);
                          //  GLubyte *rawImageBytes = (GLubyte*)CVPixelBufferGetBaseAddress(cameraFrame);
                          //  size_t bytesPerRow = CVPixelBufferGetBytesPerRow(cameraFrame);
                          //  NSData *dataForRawBytes = [NSData dataWithBytes:rawImageBytes length:bytesPerRow * CVPixelBufferGetHeight(cameraFrame)];
                            // Do whatever with your bytes

                          //  CVPixelBufferUnlockBaseAddress(cameraFrame, 0);
                        //}];
                        
                        //memset((void*)NDI_video_frame.p_data, 255, NDI_video_frame.xres*NDI_video_frame.yres * 4);
            
                        // We now submit the frame. Note that this call will be clocked so that we end up submitting at exactly 29.97fps.
                        NDIlib_send_send_video_v2(self.pSend, &NDI_video_frame);
                        //printf(&"Sending frame" [ idx]);
    
                        usleep(16666);
                    }
            
            printf("lel \r\n");
        }
        //
            // Free the video frame
            //free(NDI_video_frame.p_data);
        printf("Ended streaming \r\n");
    });
    printf("Ja guten morgen \r\n");
        
}
//AVCaptureVideoDataOutput *videoDataOutput;
//DispatchQueue *dispatchQueue;

- (void)setupLivePreview {
    
    self.videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    if (self.videoPreviewLayer) {
        
        self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        [self.previewView.layer addSublayer:self.videoPreviewLayer];
        
        
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    printf("Executing viewDidAppear \r\n");
    self.session = [AVCaptureSession new];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!backCamera) {
        NSLog(@"Unable to access back camera!");
        return;
    }
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera
                                                                        error:&error];
    if (!error) {
        //Step 9
    }
    else {
        NSLog(@"Error Unable to initialize back camera: %@", error.localizedDescription);
    }
    
    
    self.photoOutput = [AVCaptureStillImageOutput new];
    
    [self.session beginConfiguration];
    
    if ([self.session canAddInput:input] && [self.session canAddOutput:self.photoOutput]) {
        
        [self.session addInput:input];
        [self.session addOutput:self.photoOutput];
        [self setupLivePreview];
    }
    
    [self.session commitConfiguration];
    
    dispatch_queue_t globalQueue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(globalQueue, ^{
        printf("Starting session \r\n");
        [self.session startRunning];
        //Step 13
    });
    
    self.videoPreviewLayer.frame = self.previewView.bounds;
    dispatch_async(dispatch_get_main_queue(), ^{
        printf("Setting preview\r\n");
        
    });
    
    if (!NDIlib_initialize()) {
        NSException* myException = [NSException
                exceptionWithName:@"FileNotFoundException"
                reason:@"File Not Found on System"
                userInfo:nil];
        @throw myException;
    } else {
        printf("Initialized NDIlib");
    }
    
    NDIlib_send_create_t create_params_Send;
    
    
    
    create_params_Send.p_ndi_name = "My Video";
    
    create_params_Send.p_groups = nullptr;
    
    create_params_Send.clock_video = true;
    
    create_params_Send.clock_audio = true;
    
    self.pSend = NDIlib_send_create(&create_params_Send);
    if (!self.pSend) printf("Error creating NDI Sender");
    
    
    
        
        
        //AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType: AVCaptureDeviceTypeBuiltInUltraWideCamera];
        
        //AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:{ }];
        
        
        
        
        
        
        
        
        
        //[session beginConfiguration];
        
        //[session canAddInput:videoDeviceInput];
        //[session addInput:videoDeviceInput];
        
        
        
        //Screen *sr = [Screen new];
        
        
        
        //NSString * str = [sr buildOverlay:@"lol"];
        //[sr init];
        //[sr sayHello];
        
        
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
        // Free the video frame
    
    
        
    /*
     
     create_params_Send.p_ndi_name = “My Video”; create_params_Send.p_groups = nullptr; create_params_Send.clock_video = true; create_params_Send.clock_audio = true;
     NDIlib_send_instance_t pSend = NDIlib_send_create_v4(&create_params_Send); if (!pSend) printf(“Error creating NDI Sender”);

     
     */
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session stopRunning];
}


@end
