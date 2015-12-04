//
//  ViewController.h
//  GoEuro
//
//  Created by ITRMG on 2015-11-10.
//  Copyright (c) 2015 djrecker. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate>
{
    UITextField *from, *to, *date;
    UIPickerView *fromList, *toList;
    UIDatePicker *datePicker;
    
    //The below should be declared in a model class
    
    NSArray *fromData;
    CLLocationManager *locationManager;
    CLLocation *currentLoc, *toLoc;
    
    NSMutableDictionary * toListDictUnSorted;

}
@property ( nonatomic, retain) IBOutlet UITextField *from, *to, *date;
@property ( nonatomic, retain) IBOutlet UIPickerView *fromList, *toList;
@property ( nonatomic, retain) IBOutlet UIDatePicker *datePicker;
//@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
- (IBAction)pickerChanged:(id)sender;
- (void)getCurrentLocation;


@end
