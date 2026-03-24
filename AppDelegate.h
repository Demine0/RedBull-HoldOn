//
//  AppDelegate.h
//  RedBull
//
//  Created by Nikita Litvinov on 1/22/26.
//  Copyright 2026 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOKit/pwr_mgt/IOPMLib.h>

@interface AppDelegate : NSObject {
	NSStatusItem *statusItem;
	NSMenu *statusMenu;
	NSMenuItem *timeItem;
	
	IOPMAssertionID assertionID;
	BOOL caffeineEnabled;
	
	NSDate *startDate;
	NSTimer *timer;
}

- (void)enableCaffeine;
- (void)disableCaffeine;
- (IBAction)toggleCaffeine:(id)sender;
- (IBAction)quitApp:(id)sender;

@end
