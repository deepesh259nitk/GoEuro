//
//  ViewController.m
//  GoEuro
//
//  Created by ITRMG on 2015-10-10.
//  Copyright (c) 2015 djrecker. All rights reserved.
//

#import "ViewController.h"
#import "DataDriver.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const BaseURLString = @"https://api.goeuro.com/api/v2/position/suggest/de/hamburg";

@interface ViewController ()

@property(strong) NSDictionary *fromDict;
@property(strong) NSArray *toData, *mySortedArray;

@end

@implementation ViewController

@synthesize from, to, date;
@synthesize fromList, toList;
@synthesize datePicker;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    toLoc = [[CLLocation alloc] init];
    currentLoc = [[CLLocation alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    //Use ASIHTTPFormRequest request lib to call and store the values in toData
    
    //[[DataDriver sharedInstance] object];
    
    // 1 -> put this into a method and class
    
    locationManager = [[CLLocationManager alloc] init];
    
     //NSString *string = [NSString stringWithFormat:@"hamburg", BaseURLString];
     NSURL *url = [NSURL URLWithString:BaseURLString];
     NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
        //locationManager = [[CLLocationManager alloc] init];
        //locationManager.delegate = self;
        //[self getCurrentLocation];
        currentLoc = [[CLLocation alloc] initWithLatitude:51.50998000 longitude:-0.13370000];
    
     // 2 -> put this into a method and class
     AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
     operation.responseSerializer = [AFJSONResponseSerializer serializer];
     
     [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     // 3
     //self.fromDict = (NSDictionary *)responseObject;
     NSLog(@"Success -- %@", responseObject);
     
         _toData = [NSArray arrayWithArray:responseObject];
         
         NSMutableArray *holdMeters = [[NSMutableArray alloc] init];
         NSMutableArray *holdName = [[NSMutableArray alloc] init];
         //NSMutableArray *unsortedArray = [[NSMutableArray alloc] init];
         toListDictUnSorted = [[NSMutableDictionary alloc] init];
         
         
         for (int i = 0; i < [_toData count]; i++)
         {
             //NSLog(@"lat is %@, Long is %@, place is %@", [[_toData objectAtIndex:i] valueForKey:@"name"]);
             //NSDictionary *test = [[[_toData objectAtIndex:i] valueForKey:@"geo_position"] valueForKey:@"latitude"];
             NSString *lat, *lon;
             
             lat = [[[_toData objectAtIndex:i] valueForKey:@"geo_position"] valueForKey:@"latitude"];
             lon = [[[_toData objectAtIndex:i] valueForKey:@"geo_position"] valueForKey:@"longitude"];
             
             double myDoubleLat = [lat doubleValue];
             double myDoubleLon = [lon doubleValue];
   
            // NSLog(@"lat is %@", [[[_toData objectAtIndex:i] valueForKey:@"geo_position"] valueForKey:@"latitude"]);
            // NSLog(@"long is %@", [[[_toData objectAtIndex:i] valueForKey:@"geo_position"] valueForKey:@"longitude"]);
             
             toLoc = [toLoc initWithLatitude:myDoubleLat longitude:myDoubleLon];
             //toLoc = [[CLLocation alloc] initWithLatitude:53.57532 longitude:10.01534];
             //currentLoc =  [currentLoc initWithLatitude:53.57532 longitude:10.01534];
             
             CLLocationDistance meters = (int) [toLoc distanceFromLocation:currentLoc];
             
             NSLog(@"distance is %0.f", meters);
             
             //NSLog(@"Calculated Miles %@", [NSString stringWithFormat:@"%.1fmi",(meters/1609.344)]);
            
             /*toListDictUnSorted = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [NSArray arrayWithObjects:[NSNumber numberWithInt:meters], [[_toData objectAtIndex:i] valueForKey:@"name"], nil], [[_toData objectAtIndex:i] valueForKey:@"name"] , nil];
              */
             [holdMeters addObject:[NSNumber numberWithInt:meters]];
             [holdName addObject:[[_toData objectAtIndex:i] valueForKey:@"fullName"]];
             
             NSLog(@"keys are %@", [[_toData objectAtIndex:i] valueForKey:@"name"]);
             
             
        }
         
         NSLog(@"Dict is %@", toListDictUnSorted);
         NSLog(@"Array now has %@", holdMeters);
         //NSLog(@"Array now has %@", holdName);
         
         //NSMutableDictionary *unsortedDict = [[NSMutableDictionary alloc] init];

         for(int i=0; i<[holdName count]; i++) {
             
             [toListDictUnSorted setObject:holdMeters[i] forKey:holdName[i]];
             //[unsortedArray setValue:holdMeters[i] forKey:holdName[i]];
             
         }
         
         NSLog(@"unsortedDict is %@", toListDictUnSorted);
         //NSLog(@"unsortedArray is %@", unsortedArray);

         
         _mySortedArray = [toListDictUnSorted keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
             
             if ([obj1 integerValue] > [obj2 integerValue]) {
                 
                 return (NSComparisonResult)NSOrderedDescending;
             }
             if ([obj1 integerValue] < [obj2 integerValue]) {
                 
                 return (NSComparisonResult)NSOrderedAscending;
             }
             
             return (NSComparisonResult)NSOrderedSame;
         }];
         
         NSLog(@"myArray is %@", _mySortedArray);
         [self.toList reloadAllComponents];
         [self.fromList reloadAllComponents];
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
     // 4
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
     message:[error localizedDescription]
     delegate:nil
     cancelButtonTitle:@"Ok"
     otherButtonTitles:nil];
     [alertView show];
     }];
     
     // 5
     [operation start];
    
    //toData  = [NSArray arrayWithObjects:@"haz",@"bar",@"foo",nil];
    fromData  = [NSArray arrayWithObjects:@"soo",@"tar",@"haz",nil];
    
    to.delegate = self;
    from.delegate = self;
    date.delegate = self;
    
    toList.dataSource = self;
    toList.delegate = self;
    
    fromList.delegate = self;
    fromList.dataSource = self;
    
    //[self sortToList] //using current location lat long
    
    //currentLoc = /* Assume you have found it */;
    //restaurnatLoc = [[CLLocation alloc] initWithLatitude:restaurnatLat longitude:restaurnatLng];
    
    //toLoc = [[CLLocation alloc] initWithLatitude:53.57532 longitude:10.01534];
    //currentLoc = [[CLLocation alloc] initWithLatitude:51.50998000 longitude:-0.13370000];

    //CLLocationDistance meters = [toLoc distanceFromLocation:currentLoc];
    
    //NSLog(@"Distance in meter is %0.f", meters);
    // hard code toLoc from reponse object
    // latitude = "53.57532";
    //longitude = "10.01534";
    
    //NSDictionary *unsortedDict = [self createDictwithDistance];
    
    NSLog(@"raw data contains %@", toListDictUnSorted);

    
    
    //[self sortDictwithDistance]
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//======================================================================
// Sorts Locaiton  on the basis of Distance (integer data)
//======================================================================
-(void) sortKeysOnTheBasisOfDistance{
    //Method of NSDictionary class which sorts the keys using the logic given by the comparator block.
    NSArray * sortArray = [toListDictUnSorted keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        
        //Comparing the integer values of national income:
        
        //First value is greather than the second.
        if ([[obj1 objectAtIndex:0] intValue] > [[obj2 objectAtIndex:0] intValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        //First value is less than the second.
        if ([[obj1 objectAtIndex:0] intValue] < [[obj2 objectAtIndex:0] intValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        //Both the values are same
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    //Show Result in the Output Panel: Country Name and its Population
    for (int i = 0; i < [sortArray count]; i++) {
        NSLog(@"Location Name:%@  -- Distance :%d",[sortArray objectAtIndex:i],
              [[[toListDictUnSorted valueForKey:[sortArray objectAtIndex:i]] objectAtIndex:0] intValue]);
    }
    
    
}


- (void)getCurrentLocation {
    NSLog(@"test");
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    NSLog(@"test here");
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        //longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        //latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        NSString *lat, *lon;
        
        lon = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        lat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        currentLoc = currentLocation;
        
        NSLog(@"lat is %@, lon is %@", lat, lon);
        //exit once the locaiton is recieved.
        //request for current location again using reset button on form.
        
    }
}

- (IBAction)pickerChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startdate= [NSString stringWithFormat:@"%@",
                          [dateFormatter stringFromDate: datePicker.date]];
    
    date.text=startdate;
    
    
}

// Delete Methods UIText field

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {    // return NO to disallow editing.
    
    [textField resignFirstResponder];
    
    if(textField.tag==0)
    {
        //[textField resignFirstResponder];
        NSLog(@"Begin editing 0");
        [toList setHidden:NO];
        [fromList setHidden:YES];
        [datePicker setHidden:YES];
        return NO;
        
    }else if(textField.tag==1)
    {
        //[textField resignFirstResponder];
        NSLog(@"Begin editing 1");
        [toList setHidden:YES];
        [fromList setHidden:NO];
        [datePicker setHidden:YES];
        return NO;
        
    }else if(textField.tag==2)
    {
        //[textField resignFirstResponder];
        NSLog(@"Show date picker here 2");
        [toList setHidden:YES];
        [fromList setHidden:YES];
        [datePicker setHidden:NO];
        
        return NO;
    }
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    //if(textField == to)
    //NSLog(@"left editing");
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

//Picker View Delegate Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if(pickerView.tag==0)
        return [_mySortedArray count];
    
    if(pickerView.tag==1)
        return [_mySortedArray count];
    
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(pickerView.tag==0)
        return [_mySortedArray objectAtIndex:row];
    
    if(pickerView.tag==1)
        return [_mySortedArray objectAtIndex:row];
    
    return @"test";
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(pickerView.tag==0){
        NSLog(@"value slected is %@",[_mySortedArray objectAtIndex:row]);
        to.text = [_mySortedArray objectAtIndex:row];
    }
    
    if(pickerView.tag==1)
    {
        NSLog(@"selected text is %@ ", [_mySortedArray objectAtIndex:row] );
        from.text = [_mySortedArray objectAtIndex:row];
    }
}


- (IBAction)clickedSearch:(id)sender
{
    NSLog(@"search clicked");
   
    if([from.text isEqualToString:to.text]){
        //Alert users :- cannot select same origin and destination.
        //Or dont load the option selected in from list in to list, this way this condition or check is not required.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation Error !"
                                                        message:@"Orgin and Destination Cannot Be Same."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
}

@end
