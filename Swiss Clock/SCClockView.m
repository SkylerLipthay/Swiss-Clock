//
//  SCClockView.m
//  Swiss Clock
//
//  Created by Skyler on 7/5/13.
//  Copyright (c) 2013 Skyler. All rights reserved.
//

#import "SCClockView.h"

@interface SCClockView (Private)

- (void)drawClockWithTimeInterval:(NSTimeInterval)timeInterval;
- (void)redraw;

@end

@implementation SCClockView

- (id)initWithFrame:(NSRect)frame {
  if ((self = [super initWithFrame:frame]) == nil) {
    return nil;
  }
  
  _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 60.0
                                            target:self
                                          selector:@selector(redraw)
                                          userInfo:nil
                                           repeats:YES];
  
  return self;
}

- (void)drawRect:(NSRect)rect {
  const NSRect frame = self.frame;
  
  [[NSColor colorWithDeviceRed:0.8 green:0.9 blue:1 alpha:1] set];
  [NSBezierPath fillRect:frame];
  
  [self drawClockWithTimeInterval:[[NSDate date] timeIntervalSince1970]];
}

- (void)drawClockWithTimeInterval:(NSTimeInterval)timeInterval {
  const long roundedInterval = (long)timeInterval;
  const long dayInterval = roundedInterval - (roundedInterval % 86400);
  const NSTimeInterval seconds = timeInterval - dayInterval + [[NSTimeZone systemTimeZone] secondsFromGMT];
  NSColor *veryDarkGray = [NSColor colorWithDeviceWhite:0.2 alpha:1];
  const NSRect frame = NSMakeRect(0, 0, 300, 300);
  
  [[NSColor grayColor] set];
  const NSRect borderRect = NSInsetRect(frame, 10, 10);
  NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:borderRect];
  [path fill];
  
  [[NSColor whiteColor] set];
  const NSRect backgroundRect = NSInsetRect(borderRect, 10, 10);
  path = [NSBezierPath bezierPathWithOvalInRect:backgroundRect];
  [path fill];
  
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSCenterTextAlignment;
  NSDictionary *textAttribute = @{
    NSFontAttributeName: [NSFont fontWithName:@"HelveticaNeue-UltraLight" size:16],
    NSForegroundColorAttributeName: [NSColor grayColor],
    NSKernAttributeName: [NSNumber numberWithInt:1],
    NSParagraphStyleAttributeName: paragraphStyle
  };
  [@"\u03a3\u03ba\u03c5\u03bb\u03b5\u03c1" drawInRect:NSMakeRect(100, 80, 100, 24) withAttributes:textAttribute];
  
  [veryDarkGray set];
  
  for (NSUInteger index = 0; index < 60; index++) {
    const NSRect tickRect = index % 5 == 0 ? NSMakeRect(-4, 97, 8, 28) : NSMakeRect(-1.5, 115, 3, 10);
    const double tickAngle = index * 6;
    path = [NSBezierPath bezierPathWithRect:tickRect];
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:150.0 yBy:150.0];
    [transform rotateByDegrees:tickAngle];
    [path transformUsingAffineTransform:transform];
    [path fill];
  }
  
  const NSRect hoursRect = NSMakeRect(-7, -27, 14, 115);
  const double hoursAngle = -(seconds / 43200.0) * 360.0;
  path = [NSBezierPath bezierPathWithRect:hoursRect];
  NSAffineTransform *transform = [NSAffineTransform transform];
  [transform translateXBy:150.0 yBy:150.0];
  [transform rotateByDegrees:hoursAngle];
  [path transformUsingAffineTransform:transform];
  [path fill];

  const NSRect minutesRect = NSMakeRect(-5, -27, 10, 140);
  const double minutesAngle = -(seconds / 3600.0) * 360.0;
  path = [NSBezierPath bezierPathWithRect:minutesRect];
  transform = [NSAffineTransform transform];
  [transform translateXBy:150.0 yBy:150.0];
  [transform rotateByDegrees:minutesAngle];
  [path transformUsingAffineTransform:transform];
  [path fill];
  
  [[NSColor colorWithDeviceRed:0.8 green:0 blue:0 alpha:1] set];
  const NSRect secondsRect = NSMakeRect(-2, -32, 4, 120);
  const double secondsAngle = -(seconds / 60.0) * 360.0;
  path = [NSBezierPath bezierPathWithRect:secondsRect];
  transform = [NSAffineTransform transform];
  [transform translateXBy:150.0 yBy:150.0];
  [transform rotateByDegrees:secondsAngle];
  [path transformUsingAffineTransform:transform];
  [path fill];
  
  path = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(-10, 78, 20, 20)];
  transform = [NSAffineTransform transform];
  [transform translateXBy:150.0 yBy:150.0];
  [transform rotateByDegrees:secondsAngle];
  [path transformUsingAffineTransform:transform];
  [path fill];
}

- (void)redraw {
  [self setNeedsDisplay:YES];
}

- (void)dealloc {
  [_timer invalidate];
  
  [super dealloc];
}

@end
