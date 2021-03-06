//
//  DTexBarDetailViewController.m
//  DTex
//
//  Created by Rene  Trevino Jr. on 10/17/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import "DTexBarDetailViewController.h"

#import "DTexBarEventsTableViewController.h"
//#import "UIButton+Glossy.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface DTexBarDetailViewController ()

//@property (strong, nonatomic) PFObject * exam;

@property (strong, nonatomic) NSString * BarName;
@property (strong, nonatomic) NSNumber * BarKey;

@property (weak, nonatomic) IBOutlet UILabel *label_barname;
@property (weak, nonatomic) IBOutlet UILabel *BarNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *webButton;
@property (weak, nonatomic) IBOutlet UIButton *eventsButton;


@property (retain, nonatomic) CLLocationManager *locationManager;

@property (nonatomic) NSNumber * BarLatitude;
@property (nonatomic) NSNumber * BarLongitude;

@property (weak, nonatomic) NSNumber * BarRating;
@property (weak, nonatomic) IBOutlet UILabel *RatingLabel;

@end


@implementation DTexBarDetailViewController

@synthesize BarName;
@synthesize mapView;
@synthesize BarKey;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFObject * selection = _exam;
    BarName = [selection objectForKey:@"Bar_Name"];
    BarKey = [selection objectForKey:@"ID"];
    _AddressLabel.text = [selection objectForKey:@"Address"];
    _BarLatitude = [selection objectForKey:@"latitude"];
    _BarLongitude = [selection objectForKey:@"longitude"];
    NSLog(@"Bar Name = %@", BarName);

    NSNumber *bar_rate = [selection objectForKey:@"Rating"];
    NSString * rating_str = [bar_rate stringValue];
    NSNumber * onev = [NSNumber numberWithInt:1];
    if ([bar_rate isEqualToNumber:onev])
        rating_str = [rating_str stringByAppendingString:@" Person Likes this Venue!"];
    else
        rating_str = [rating_str stringByAppendingString:@" People Like this Venue!"];
    _RatingLabel.text = rating_str;
    
    _BarNameLabel.text = BarName;
    _label_barname.text = BarName;
    
    
    // Round button corners
    CALayer *callbtnLayer = [_callButton layer];
    [callbtnLayer setMasksToBounds:YES];
    [callbtnLayer setCornerRadius:10.0f];
    CALayer *webbtnLayer = [_webButton layer];
    [webbtnLayer setMasksToBounds:YES];
    [webbtnLayer setCornerRadius:10.0f];
    CALayer *eventsbtnLayer = [_eventsButton layer];
    [eventsbtnLayer setMasksToBounds:YES];
    [eventsbtnLayer setCornerRadius:10.0f];
    // Apply a 1 pixel, black border
    [callbtnLayer setBorderWidth:1.0f];
    [callbtnLayer setBorderColor:[[UIColor blackColor] CGColor]];
    [webbtnLayer setBorderWidth:1.0f];
    [webbtnLayer setBorderColor:[[UIColor blackColor] CGColor]];
    [eventsbtnLayer setBorderWidth:1.0f];
    [eventsbtnLayer setBorderColor:[[UIColor blackColor] CGColor]];
    // Draw a custom gradient
    CAGradientLayer *callbtnGradient = [CAGradientLayer layer];
    callbtnGradient.frame = _callButton.bounds;
    callbtnGradient.colors = [NSArray arrayWithObjects:[UIColor blackColor],
                          //(id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [_callButton.layer insertSublayer:callbtnGradient atIndex:0];
    // Draw a custom gradient
    CAGradientLayer *webbtnGradient = [CAGradientLayer layer];
    webbtnGradient.frame = _callButton.bounds;
    webbtnGradient.colors = [NSArray arrayWithObjects:[UIColor blackColor],
                          //(id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          //(id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [_callButton.layer insertSublayer:webbtnGradient atIndex:0];
    // Draw a custom gradient
    CAGradientLayer *eventsbtnGradient = [CAGradientLayer layer];
    eventsbtnGradient.frame = _callButton.bounds;
    eventsbtnGradient.colors = [NSArray arrayWithObjects:[UIColor blackColor],
                             //(id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                             //(id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                             nil];
    [_callButton.layer insertSublayer:eventsbtnGradient atIndex:0];
 
    /*
    mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        //[self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    
    //mapView.showsUserLocation = YES;
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
     */
    
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    //region.center.latitude = self.locationManager.location.coordinate.latitude;
    //region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.center.latitude = [_BarLatitude floatValue];
    region.center.longitude = [_BarLongitude floatValue];
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [mapView setRegion:region animated:NO];
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    //point.coordinate = userLocation.coordinate;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [_BarLatitude floatValue];
    coordinate.longitude = [_BarLongitude floatValue];
    point.coordinate = coordinate;
    point.title = BarName;
    point.subtitle = _AddressLabel.text;
    [self.mapView addAnnotation:point];
    [self.mapView selectAnnotation:point animated:YES];
    
    self.mapView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.mapView.layer.borderWidth = 2.0;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.view addSubview:self.mapView];
    //[self.view sendSubviewToBack:self.mapView];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*
    if (self.view.superview.frame.origin.y > 44.0) {
        UIView *container = self.view.superview;
        container.frame = CGRectMake(container.frame.origin.x, container.frame.origin.y - 20.0, container.frame.size.width, container.frame.size.height + 20.0);
    }
     */
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self.mapView removeFromSuperview];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


//telprompt will return to your app after they finish the call
- (IBAction)callTouched:(id)sender {
    PFObject * selection = _exam;
    NSString *temp = [NSString stringWithFormat:@"%@%@", @"telprompt://", [selection objectForKey:@"Phone"]];
    NSLog(@"%@", temp);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp]];
}

//websites must start with http://
- (IBAction)webTouched:(id)sender {
    PFObject * selection = _exam;

    NSURL *url = [[ NSURL alloc ] initWithString: [selection objectForKey:@"Website"]];
    [[UIApplication sharedApplication] openURL:url];
    NSLog(@"%@\n", [url description]);
}

/*
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
     CLLocationDistance distance = 1000;
     CLLocationCoordinate2D myCoordinate;
     myCoordinate.latitude = [_BarLatitude floatValue];
     myCoordinate.longitude = [_BarLongitude floatValue];
     MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(myCoordinate,
     distance,
     distance);
     
     MKCoordinateRegion adjusted_region = [self.mapView regionThatFits:region];
     [self.mapView setRegion:adjusted_region animated:YES];

    // MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    // [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];

    // Add an annotation
    // MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    // point.coordinate = userLocation.coordinate;
    // point.title = @"Where am I?";
    // point.subtitle = @"I'm here!!!";
    // [self.mapView addAnnotation:point];
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setBarObject:(PFObject*) obj
{
    _exam = obj;
}
- (void) setBarName:(NSString *) name
{
    BarName = name;
}
- (void) setBarKey:(NSNumber *)key {
    BarKey = key;
}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceLat {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}
- (NSString *)deviceLon {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceAlt {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"drinkspecialsegue"]){
        [[segue destinationViewController] setBarSelection:BarName];
        [[segue destinationViewController] setBarFKeySelection:BarKey];
        NSLog(@"Bar Name Selection: %@", BarName);
    }
}

@end

