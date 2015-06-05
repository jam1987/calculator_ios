//
//  MySecondAppBrain.m
//  calculator
//
//  Created by Julio De Abreu on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain  ();
@property (nonatomic,strong) NSMutableArray *programStack;



@end
@implementation CalculatorBrain

@synthesize programStack = _programStack;

BOOL hasOperations =NO;
NSSet *operations;

NSString *lastOperation =@"";




/* Nombre del Metodo: operandStack
 * Argumentos de entrada: ninguno
 * Tipo que devuelve: NSMutableArray*
 * Descripcion: Este metodo es un getter
 * propiedad operandStack.
 *
 */
-(NSMutableArray *) programStack {
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}



/*
 * Nombre del Metodo: pushOperand
 * Parametros de entrada: operand tipo Double
 * Tipo que devuelve: void
 * Descripcion: Este metodo toma un operando y 
 * lo mete en una pila representada por el
 * operandStack.
 */
-(void) pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble: operand]];
};

-(void) pushVariable:(NSString*) variable {
    [self.programStack addObject: variable];
}


/* Nombre del metodo: clearStack
 * Parametros de Entrada: ninguno
 * Tipo que devuelve: void
 * Descripcion del metodo: Este metodo
 * borra todos los elementos de la pila.
 *
 */
-(void) clearStack {
    [self.programStack removeAllObjects];
}



/*
 * Nombre del Metodo: popOperand
 * Parametros de entrada: ninguno
 * Tipo que devuelve: double
 * Descripcion: Este metodo toma un operando del  
 * tope de una pila representada por el
 * operandStack, lo elimina de la misma y
 * lo devuelve.
 */
+(double) popStack :(NSMutableArray*) stack withVariables :(NSDictionary*) variable {
    double resultado = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    } else {
        resultado = 0;
    }
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        resultado = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            double op1= [self popStack:stack withVariables:variable];
            double op2 = [self popStack:stack withVariables:variable];
            if (!op1) {
                op1 = 0;
            }
            if (!op2) {
                op2 = 0;
            }
            resultado = op1+op2;
        } else if ([operation isEqualToString:@"-"]) {
            double op1 = [self popStack:stack withVariables:variable];
            double op2 = [self popStack:stack withVariables:variable];
            if (!op1) {
                op1 = 0;
            }
            if (!op2) {
                op2 = 0;
            }

            resultado = op2 - op1;
                          
            } else if ([operation isEqualToString:@"X"]) {
                double op1 = [self popStack:stack withVariables:variable];
                double op2 = [self popStack:stack withVariables:variable];
                if (!op1) {
                    op1 = 0;
                }
                if (!op2) {
                    op2 = 0;
                }

                resultado = op1 * op2;
        } else if ([operation isEqualToString:@"/"]) {
            double e1 = [self popStack:stack withVariables:variable];
            double e2 = [self popStack:stack withVariables:variable];
            if (!e1) {
                e1 = 0;
            }
            if (!e2) {
                e2 = 0;
            }
            resultado = e2 / e1;
        } else if ([operation isEqualToString:@"sin"]) {
            double e1 = [self popStack:stack withVariables:variable];
            if (!e1) {
                e1 = 0;
            }
            resultado = sin(e1);
        } else if ([operation isEqualToString:@"cos"]) {
            double e1 = [self popStack:stack withVariables:variable];
            if (!e1) {
                e1 = 0;
            }
            resultado = cos(e1);
        } else if ([operation isEqualToString:@"sqrt"]) {
            double op = [self popStack:stack withVariables:variable];
            if (!op) {
                op = 0;
            }
            if (op>=0) {
                resultado = sqrt(op);
            } else {
                resultado = NAN;
            }
         } else if ([operation isEqualToString:@"pi"]) {
            resultado = M_PI;
        } else if ([operation isEqualToString:@"x"] ){
            double num = [[variable objectForKey:operation] doubleValue];
            NSLog(@"%g",num);
            
            resultado = num;

        } else {
            [stack addObject:[NSString stringWithFormat:@"%g",0]];
        }

        
    }
    
    
   
    return resultado;
}




+(double) runProgram:(id)program usingVariablesValues:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popStack:stack withVariables:variableValues];
}


-(double) performOperation: (NSString*) operation usingVariablesValues:(NSDictionary *)variableValues {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program usingVariablesValues:variableValues];
}

-(NSString*) printOperation: (NSString*) operation {
        return [CalculatorBrain descriptionOfProgram:self.program];
}

-(id)program {
    return [self.programStack copy];
}

+(NSString*) descriptionOfTopOfStack:(NSMutableArray*) stack {
    NSString *resultado;
    id topOfStack = [stack lastObject];
    if (topOfStack) {
      
        [stack removeLastObject];
    }
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        double num = [topOfStack doubleValue];
        NSString *number = [NSString stringWithFormat:@"%g",num];
        resultado = number;
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        NSSet *binaryOp = [NSSet setWithObjects:@"+",@"-",@"X",@"/", nil];
        NSSet *function = [NSSet setWithObjects:@"sin",@"cos",@"sqrt", nil];
        if ([binaryOp containsObject:operation]) {
            
            NSString *op1 = [self descriptionOfTopOfStack:stack];
            NSString *op2 = [self descriptionOfTopOfStack:stack];
            if (!op1) {
                op1 = @"0";
            }
            if (!op2) {
                op2 = @"0";
            }
            if ([operation isEqualToString:@"-"] || [operation isEqualToString:@"/"]) {
                resultado = [[@"(" stringByAppendingString: [[op2 stringByAppendingString:operation] stringByAppendingString:op1]] stringByAppendingString:@")"];
            } else {
                
                resultado = [[@"(" stringByAppendingString: [[op1 stringByAppendingString:operation] stringByAppendingString:op2]] stringByAppendingString:@")"];
            }
        } else if ([function containsObject:operation]) {
            NSString *op1 = [self descriptionOfTopOfStack:stack];
            resultado = [[[operation stringByAppendingString:@"("] stringByAppendingString:op1] stringByAppendingString:@")"];
        } else if ([operation isEqualToString:@"pi"]) {
            resultado = [NSString stringWithFormat:@"%g",M_PI];
        }
        
    }  

    return resultado;
    
}



+(NSString*) descriptionOfProgram:(id)program {
    NSMutableArray * stack;
       if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }

    NSString *result = [self descriptionOfTopOfStack:stack];
    NSString *prueba = @"";
    int i =1;
    id elem = [stack lastObject];
    while (elem) {
        if (i>1) {
            prueba = [prueba stringByAppendingString:@" , "];
        }
        if ([elem isKindOfClass:[NSString class]]) {
            
            if ([elem isEqualToString:@"sin"] || [elem isEqualToString:@"cos"] || [elem isEqualToString:@"sqrt"] ) {
                prueba = [prueba stringByAppendingString:elem];
                [stack removeLastObject];
                elem = [stack lastObject];
                NSString *number = [NSString stringWithFormat:@"%@",elem];
                prueba = [prueba stringByAppendingString:@"("];
                prueba = [prueba stringByAppendingString:number];
                prueba = [prueba stringByAppendingString:@")"];
                [stack removeLastObject];
                elem = [stack lastObject];
            } else {
                if ([elem isEqualToString:@"sin"] || [elem isEqualToString:@"cos"]) {
                    NSString *operator = elem;
                    [stack removeLastObject];
                    elem = [stack lastObject];
                    NSString *number1 = [NSString stringWithFormat:@"%@",elem];
                    [stack removeLastObject];
                    elem = [stack lastObject];
                    NSString *number2 = [NSString stringWithFormat:@"%@",elem];
                    prueba = [prueba stringByAppendingString:@"("];
                    prueba = [prueba stringByAppendingString:number2];
                    prueba = [prueba stringByAppendingString:operator];
                    prueba = [prueba stringByAppendingString:number1];
                    prueba = [prueba stringByAppendingString:@")"];
                    [stack removeLastObject];
                    elem = [stack lastObject];

                
                } else {
                    NSString *operator = elem;
                    [stack removeLastObject];
                    elem = [stack lastObject];
                    NSString *number1 = [NSString stringWithFormat:@"%@",elem];
                    prueba = [prueba stringByAppendingString:@"("];
                    prueba = [prueba stringByAppendingString:number1];
                    prueba = [prueba stringByAppendingString:operator];
                    [stack removeLastObject];
                    elem = [stack lastObject];
                    NSString *number2 = [NSString stringWithFormat:@"%@",elem];
                    prueba = [prueba stringByAppendingString:number2];
                    prueba = [prueba stringByAppendingString:@")"];
                    [stack removeLastObject];
                    elem = [stack lastObject];
                }
                
            }
        } else {
            int k =1;
            while (elem && [elem isKindOfClass:[NSNumber class]]) {
                if (k>1) {
                    prueba = [prueba stringByAppendingString:@" , "];
                }
                NSString *number1 = [NSString stringWithFormat:@"%@",elem];
                prueba = [prueba stringByAppendingString:number1];
                [stack removeLastObject];
                elem = [stack lastObject];
            }
            k++;
        }
        i++;
    }
    if (![prueba isEqualToString:@""]) {
        result = [result stringByAppendingString:@" , "];
    }
    result = [result stringByAppendingString:prueba];
    return result;
}


/*
       [self pushOperand:resultado];
    return resultado;
}; */
@end
