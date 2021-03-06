//
//  ORCWebViewController.m
//  Orchestra
//
//  Created by Judith Medina on 30/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCWebViewController.h"
#import "ORCBarButtonItem.h"
#import "ORCStorage.h"
#import "ORCGIGLayout.h"
#import "ORCThemeSdk.h"
#import "NSBundle+ORCBundle.h"
#import "UIImage+ORCGIGExtension.h"

CGFloat const HEIGHT_TOOLBAR = 44;


@interface ORCWebViewController()
<UIWebViewDelegate>

@property (strong, nonatomic) ORCStorage *storage;
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSURL *url;

@end

@implementation ORCWebViewController


#pragma mark - LIFECYCLE

- (instancetype)initWithURLString:(NSString *)urlString
{
    self = [super init];
    
    if (self)
    {
        _url = [NSURL URLWithString:urlString];
        _storage = [[ORCStorage alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];

    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - ACTIONS

- (void)cancelButtonTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goBackWebView
{
    [self.webView goBack];
}

- (void)goForwardWebView
{
    [self.webView goForward];
}

- (void)reloadWebView
{
    [self.webView reload];
}

#pragma mark - PRIVATE

- (void)initialize
{
    ORCThemeSdk *theme = [self.storage loadThemeSdk];

    self.title =  ORCLocalizedBundle(@"Browser", nil, nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: theme.secondaryColor}];
    self.navigationItem.leftBarButtonItem = [[ORCBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:self action:@selector(cancelButtonTapped)];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.webView];
    gig_layout_fit(self.webView);
    
    self.toolBar = [[UIToolbar alloc] init];
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    // Back button
    UIImage *previousImg = [NSBundle imageFromBundleWithName:@"previous-grey"];
    UIImage *previousCustomize = [UIImage imageFromMaskImage:previousImg withColor:theme.secondaryColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:previousCustomize forState:UIControlStateNormal];
    [backButton setBounds:CGRectMake(0, 0, previousCustomize.size.width, previousCustomize.size.height)];
    [backButton addTarget:self action:@selector(goBackWebView) forControlEvents:UIControlEventTouchUpInside];
    ORCBarButtonItem *backBarButton = [[ORCBarButtonItem alloc] initWithCustomView:backButton];
    [items addObject:backBarButton];
    
    // Forward button
    UIImage *nextImg = [NSBundle imageFromBundleWithName:@"next-grey"];
    UIImage *nextCustomize = [UIImage imageFromMaskImage:nextImg withColor:theme.secondaryColor];
    
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forwardButton setImage:nextCustomize forState:UIControlStateNormal];
    [forwardButton setBounds:CGRectMake(0, 0, nextCustomize.size.width, nextCustomize.size.height)];
    [forwardButton addTarget:self action:@selector(goForwardWebView) forControlEvents:UIControlEventTouchUpInside];
    ORCBarButtonItem *forwardBarButton = [[ORCBarButtonItem alloc] initWithCustomView:forwardButton];
    [items addObject:forwardBarButton];
    
    // Flexible Space
    [items addObject:[[ORCBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                      target:nil action:nil]];
    
    // Refresh button
    [items addObject:[[ORCBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                      target:self action:@selector(reloadWebView)]];
    [self.toolBar setItems:items];
    [self.view addSubview:self.toolBar];
    
    gig_layout_bottom(self.toolBar, 0);
    gig_constrain_height(self.toolBar, HEIGHT_TOOLBAR);
    
    NSArray *constraintWidth = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"|[toolBar]|"
                                options:0
                                metrics:nil
                                views:@{@"toolBar" : self.toolBar}];
    [self.view addConstraints:constraintWidth];
}


@end
