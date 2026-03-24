//
//  AppDelegate.m
//  RedBull
//
//  Created by Nikita Litvinov on 1/22/26.
//  Copyright 2026 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{ 	
	caffeineEnabled = NO;
	assertionID = 0;
	
	statusItem = [[[NSStatusBar systemStatusBar]
				   statusItemWithLength:NSSquareStatusItemLength] retain];
	NSImage *normal = [NSImage imageNamed:@"status.png"];
	NSImage *highlight = [NSImage imageNamed:@"status_alt.png"];
	[statusItem setImage:normal];
	[statusItem setAlternateImage:highlight];
	[statusItem setHighlightMode:YES];
	
	statusMenu = [[NSMenu alloc] init];
	
	timeItem = [[NSMenuItem alloc]
				initWithTitle:@"Time: 00:00:00"
				action:nil
				keyEquivalent:@""];
	
	[statusMenu	addItem:timeItem];
	[statusMenu addItem:[NSMenuItem separatorItem]];
	
	NSMenuItem *toggle = 
		[[NSMenuItem alloc] initWithTitle:@"RedBull is out?"
								   action:@selector(toggleCaffeine:)
							keyEquivalent:@""];
	
	[toggle setTarget:self];
	[statusMenu	addItem:toggle];
	[toggle release];
	
	NSMenuItem *quit = 
		[[NSMenuItem alloc] initWithTitle:@"Quit"
								   action:@selector(quitApp:)
							keyEquivalent:@"q"];
	
	[quit setTarget:self];
	[statusMenu addItem:quit];
	[quit release];
	
	[statusItem setMenu:statusMenu];
	[statusMenu setDelegate:self];
	[self enableCaffeine];

}

#pragma mark - Caffeine logic

- (void)enableCaffeine
{
	if (caffeineEnabled)
		return;
	IOPMAssertionCreate(
		kIOPMAssertionTypeNoIdleSleep,
		kIOPMAssertionLevelOn,
		&assertionID
		);
	
	caffeineEnabled = YES;
	startDate = [[NSDate date] retain];
	
	timer = [[NSTimer scheduledTimerWithTimeInterval:1.0
											  target:self
											selector:@selector(updateTime:)
											userInfo:nil
											 repeats:YES] retain];
}

- (void)disableCaffeine 
{
	if (!caffeineEnabled)
		return;
	
	IOPMAssertionRelease(assertionID);
	assertionID = 0;
	caffeineEnabled = NO;
	
	[timer invalidate];
	[timer release];
	timer = nil;
	
	[startDate release];
	startDate = nil;
	
	[timeItem setTitle:@"Time: 00:00:00"];
}

- (IBAction)toggleCaffeine:(id)sender
{
	NSImage *disa = [NSImage imageNamed:@"status_off.png"];
	NSImage *ena = [NSImage imageNamed:@"status.png"];
	NSImage *disaHighlight = [NSImage imageNamed:@"status_off_alt.png"];
	NSImage *enaHighlight = [NSImage imageNamed:@"status_alt.png"];
	
	if (caffeineEnabled) {
		[self disableCaffeine];
		[sender setTitle:@"Maybe RedBull?"];
		[statusItem setImage:disa];
		[statusItem setAlternateImage:disaHighlight];
	} else {
		[self enableCaffeine];
		[sender setTitle:@"RedBull is out?"];
		[statusItem setImage:ena];
		[statusItem setAlternateImage:enaHighlight];

	}
}

#pragma mark - Timer

- (void)updateTime:(NSTimer *)t
{
	NSTimeInterval Interval =
	[[NSDate date] timeIntervalSinceDate:startDate];
	
	int seconds = (int)Interval;
	int h = seconds / 3600;
	int m = (seconds % 3600) / 60;
	int s = seconds % 60;
	
	NSString *timeStr = 
		[NSString stringWithFormat:
		 @"Time: %02d:%02d:%02d", h, m, s];
	
	[timeItem setTitle:timeStr];
}

#pragma mark - Quit
- (IBAction)quitApp:(id)sender
{
	[self disableCaffeine];
	[NSApp terminate:nil];
}

- (void)dealloc
{
	[statusMenu release];
	[timeItem release];
	[statusItem release];
	[super dealloc];
}
	
@end
