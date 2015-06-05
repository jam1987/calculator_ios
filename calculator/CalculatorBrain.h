//
//  MySecondAppBrain.h
//  calculator
//
//  Created by Julio De Abreu on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (readonly) id program;


-(void) pushOperand:(double)operand;
-(void) pushVariable:(NSString*)variable;
 
-(double) performOperation: (NSString*) operation usingVariablesValues:(NSDictionary *)variableValues;

-(NSString*) printOperation: (NSString*) operation;


-(void) clearStack;

+(double) runProgram:(id)program usingVariablesValues:(NSDictionary*) variableValues;
+(NSString*) descriptionOfProgram:(id)program;

@end
