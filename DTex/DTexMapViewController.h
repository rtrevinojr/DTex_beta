//
//  DTexMapViewController.h
//  DTex
//
//  Created by Rene  Trevino Jr. on 11/10/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DTexMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;

@property (retain, nonatomic) CLLocationManager *locationManager;

@end
