//
//  Meditation Bowls - Ben Taylor
//  Based on Mobile Music Template Created by Jesse Allison
//

#import "MAGViewController.h"

@interface MAGViewController ()

@end

@implementation MAGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // _________________ LOAD Pd Patch ____________________
    dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:dispatcher];
    patch = [PdBase openFile:@"mag_template.pd" path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"Failed to open patch!");
    }
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval  = 1.0/20.0;
    self.motionManager.gyroUpdateInterval = 1.0/20.0;
    self.motionManager.magnetometerUpdateInterval = 1.0/20.0;
    
    if (self.motionManager.accelerometerAvailable) {
        NSLog(@"Accelerometer avaliable");
        NSOperationQueue *queue = [NSOperationQueue currentQueue];
        [self.motionManager startAccelerometerUpdatesToQueue:queue
            withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                CMAcceleration acceleration = accelerometerData.acceleration;
                [PdBase sendFloat:acceleration.x toReceiver:@"tiltx"];
                [PdBase sendFloat:acceleration.y toReceiver:@"tilty"];
                [PdBase sendFloat:acceleration.z toReceiver:@"tiltz"];
            }];
    }
    
        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
            withHandler:^(CMGyroData *gyroData, NSError *error) {
                [PdBase sendFloat:gyroData.rotationRate.z toReceiver:@"rotationz"];
                 [PdBase sendFloat:gyroData.rotationRate.x toReceiver:@"rotationx"];
                
            }];
    
    
    
    [self.motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue currentQueue]
            withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {
                    // keeping these comments in to use for later
                    //[self outputRotationData:gyroData.rotationRate];
                    //  CMRotationRate *rotation = gyroData.rotationRate;
                   //    self.yLabel.text = [NSString stringWithFormat:@"%f", magnetometerData.magneticField.y];
                 //     self.zLabel.text = [NSString stringWithFormat:@"%f", magnetometerData.magneticField.z];
                  //  [PdBase sendFloat:magnetometerData.magneticField.x toReceiver:@"rotationz"];
                                        
            }];

}


/*
- (void)viewDidUnload
{
    // uncomment for pre-iOS 6 deployment
    [super viewDidUnload];
    [PdBase closeFile:patch];
    [PdBase setDelegate:nil];
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
