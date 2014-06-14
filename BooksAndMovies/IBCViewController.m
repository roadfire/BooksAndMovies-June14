//
//  IBCViewController.m
//  BooksAndMovies
//
//  Created by Josh Brown on 6/13/14.
//  Copyright (c) 2014 Roadfire Software. All rights reserved.
//

#import "IBCViewController.h"
#import "IBCDetailViewController.h"

@interface IBCViewController ()

@property NSArray *entries;

@end

@implementation IBCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadBooks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *entry = self.entries[indexPath.row];
    NSString *title = entry[@"im:name"][@"label"];
    cell.textLabel.text = title;
    
    return cell;
}

- (IBAction)didChangeSegment:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    if (control.selectedSegmentIndex == 0)
    {
        [self loadBooks];
    }
    else
    {
        [self loadMovies];
    }
}

- (void)loadBooks
{
    [self loadFromURLString:@"https://itunes.apple.com/us/rss/toppaidebooks/limit=15/json"];
}

- (void)loadMovies
{
    [self loadFromURLString:@"https://itunes.apple.com/us/rss/topmovies/limit=15/json"];
}

- (void)loadFromURLString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]])
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if (httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299)
            {
                NSError *jsonError = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                if (!jsonError) {
                    self.entries = json[@"feed"][@"entry"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            }
        }
    }];
    [task resume];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[IBCDetailViewController class]])
    {
        IBCDetailViewController *vc = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        NSDictionary *entry = self.entries[path.row];
        vc.entry = entry;
    }
}

@end
