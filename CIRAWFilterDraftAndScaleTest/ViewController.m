//
//  ViewController.m
//  CIRAWFilterTest
//
//  Created by Yuan Liu on 12/15/2020.
//  Copyright © 2016 VSCO. All rights reserved.
//

#import "ViewController.h"

@import CoreImage;
@import AssetsLibrary;

static NSString *kImageFileURLPath = @"IMG_0317";
static NSString *kImageFileURLExtension = @"DNG";

@interface ViewController ()

@property (strong, nonatomic) UIImage *draft;
@property (strong, nonatomic) UIImage *nondraft;

@property (weak, nonatomic) IBOutlet UISwitch *imageSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *imageURL = [NSURL fileURLWithPath:[bundle pathForResource:kImageFileURLPath ofType:kImageFileURLExtension]];
    assert(imageURL);
    
    CIFilter *CIRAWFilter = [CIFilter filterWithImageURL:imageURL options:@{}];
    [CIRAWFilter setValue:@(YES) forKey:kCIInputAllowDraftModeKey];
    [CIRAWFilter setValue:@(0.2) forKey:kCIInputScaleFactorKey]; // string value of kCIInputScaleFactorKey

    CIImage *CIRAWFilterOutputImage = CIRAWFilter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextWorkingFormat:@(kCIFormatRGBAh),
                                                         kCIContextUseSoftwareRenderer:@YES
                                                         }];
    
    CGImageRef CIRAWFilterOutputCGImage = [context createCGImage:CIRAWFilterOutputImage fromRect:CIRAWFilterOutputImage.extent];
    self.draft = [UIImage imageWithCGImage:CIRAWFilterOutputCGImage];


    CIFilter *CIRAWFilter2 = [CIFilter filterWithImageURL:imageURL options:@{}];
    [CIRAWFilter2 setValue:@(NO) forKey:kCIInputAllowDraftModeKey];
    [CIRAWFilter2 setValue:@(0.2) forKey:kCIInputScaleFactorKey]; // string value of kCIInputScaleFactorKey

    CIImage *CIRAWFilterOutputImage2 = CIRAWFilter2.outputImage;
    CGImageRef CIRAWFilterOutputCGImage2 = [context createCGImage:CIRAWFilterOutputImage2 fromRect:CIRAWFilterOutputImage2.extent];
    self.nondraft = [UIImage imageWithCGImage:CIRAWFilterOutputCGImage2];
    
    if (self.imageSwitch.on) {
        [self.imageView setImage:self.draft];
    } else {
        [self.imageView setImage:self.nondraft];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)switchAction:(UISwitch *)sender {

    if (sender.on) {
        [self.imageView setImage:self.draft];
    } else {
        [self.imageView setImage:self.nondraft];
    }
}

@end
