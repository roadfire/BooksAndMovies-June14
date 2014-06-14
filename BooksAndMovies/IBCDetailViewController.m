//
//  IBCDetailViewController.m
//  BooksAndMovies
//
//  Created by Josh Brown on 6/13/14.
//  Copyright (c) 2014 Roadfire Software. All rights reserved.
//

#import "IBCDetailViewController.h"

@interface IBCDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *genreLabel;
@property (strong, nonatomic) IBOutlet UITextView *summaryView;

@end

@implementation IBCDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.entry[@"im:name"][@"label"];
    self.nameLabel.text = self.entry[@"im:artist"][@"label"];
    self.genreLabel.text = self.entry[@"category"][@"attributes"][@"label"];
    self.summaryView.text = self.entry[@"summary"][@"label"];
    
    self.imageView.alpha = 0;
    
    [self loadImageView];
}

- (void)loadImageView
{
    NSArray *images = self.entry[@"im:image"];
    NSDictionary *imageDict = images.lastObject;
    NSString *urlString = imageDict[@"label"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]])
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if (httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299)
            {
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = image;
                    [UIView animateWithDuration:2.0 animations:^{
                        self.imageView.alpha = 1;
                    }];
                });
            }
        }
    }];
    [task resume];
}

@end
