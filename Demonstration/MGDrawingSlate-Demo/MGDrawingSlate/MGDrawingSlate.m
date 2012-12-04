//
//  MGDrawingSlate.m
//  MGDrawingSlate
//
//  Created by Mihir Garimella on 6/28/12.
//  Copyright (c) 2012 Mihir Garimella.
//  Licensed for use under the MIT License. See the license file included with this source code or visit http://opensource.org/licenses/MIT for more information.
//

#import "MGDrawingSlate.h"

@interface MGDrawingSlate (){
    NSMutableArray *drawingPaths;
    UIBezierPath *currentDrawingPath;
    BOOL isDrawing;
}

- (void)commonInit;

@end

@implementation MGDrawingSlate

#pragma mark - Initialization
- (void)commonInit{
    //Initialize MGDrawingSlate and set default values
    self.backgroundColor = [UIColor clearColor];
    
    self.lineWeight = 4; //Default line weight - change with changeLineWeightTo: method.
    self.lineColor = [UIColor blackColor]; //Default color - change with changeColorTo: method.
    drawingPaths = [NSMutableArray array];
    isDrawing = NO;
    
}

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Edit 
-(void)undoStroke{
    if (drawingPaths.count>0) {
        [drawingPaths removeLastObject];
        [self setNeedsDisplay];
    }
}

#pragma mark - Drawing Methods
- (void)drawRect:(CGRect)rect
{
    [self.lineColor setStroke];
    for (UIBezierPath *path in drawingPaths) {
        [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [[touches allObjects] objectAtIndex:0];    
    currentDrawingPath = [[UIBezierPath alloc] init];
    currentDrawingPath.lineCapStyle = kCGLineCapRound;
    currentDrawingPath.miterLimit = 0;
    currentDrawingPath.lineWidth = self.lineWeight;
    [currentDrawingPath moveToPoint:[touch locationInView:self]];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!isDrawing){
        [drawingPaths addObject:currentDrawingPath];
        isDrawing = YES;
    }
    
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    UIBezierPath *lastDrawingPath = [drawingPaths objectAtIndex:drawingPaths.count-1];
    [lastDrawingPath addLineToPoint:[touch locationInView:self]];
    [self setNeedsDisplay];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Paths: %i",drawingPaths.count);
    currentDrawingPath = nil;
    isDrawing = NO;
}

@end