//
//  MySecondAppBrain.h
//  calculator
//
//  Created by Julio De Abreu on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject


-(void) pushOperand:(double)operand;

-(double) performOperation: (NSString*) operation;


-(void) clearStack;


@end