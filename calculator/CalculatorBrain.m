//
//  MySecondAppBrain.m
//  calculator
//
//  Created by Julio De Abreu on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain  ();
@property (nonatomic,strong) NSMutableArray *operandStack;


@end
@implementation CalculatorBrain

@synthesize operandStack = _operandStack;


/* Nombre del Metodo: operandStack
 * Argumentos de entrada: ninguno
 * Tipo que devuelve: NSMutableArray*
 * Descripcion: Este metodo es un getter
 * propiedad operandStack.
 *
 */
-(NSMutableArray *) operandStack {
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
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
    [self.operandStack addObject:[NSNumber numberWithDouble: operand]];
};


/* Nombre del metodo: clearStack
 * Parametros de Entrada: ninguno
 * Tipo que devuelve: void
 * Descripcion del metodo: Este metodo
 * borra todos los elementos de la pila.
 *
 */
-(void) clearStack {
    [self.operandStack removeAllObjects];
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
-(double) popOperand {
    NSNumber *operando = [self.operandStack lastObject];
    if (operando) [self.operandStack removeLastObject];
    return [operando doubleValue];
}

/* Nombre del Metodo: performOperation
 * Parametros de entrada: operation de tipo NSString*.
 * Tipo que devuelve: double
 * Descripcion: Este metodo recibe un NSString que re-
 * presenta la operacion a ejecutar en la calculadora, 
 * toma los operandos necesarios de la pila a traves de
 * popOperand, realiza el calculo y devuelve el resultado y
 * lo introduce dentro de la pila a traves del pushOperand.
 *
 */
-(double) performOperation: (NSString*) operation {
    double resultado;
    if ([operation isEqualToString:@"+"]) {
        resultado = [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        double op1 = [self popOperand];
        double op2 = [self popOperand];
        resultado = op2 - op1;
    } else if ([operation isEqualToString:@"x"]) {
        resultado = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"/"]) {
        double e1 = [self popOperand];
        double e2 = [self popOperand];
        resultado = e2 / e1;
    } else if ([operation isEqualToString:@"sin"]) {
        resultado = sin([self popOperand]);
    } else if ([operation isEqualToString:@"cos"]) {
        resultado = cos([self popOperand]);
    } else if ([operation isEqualToString:@"sqrt"]) {
        double op = [self popOperand];
        if (op>=0) {
            resultado = sqrt(op);
        } else {
            resultado = NAN;
        }
    } else if ([operation isEqualToString:@"pi"]) {
        resultado = M_PI;
    } else if ([operation isEqualToString:@"-/+"]) {
        resultado = [self popOperand] * (-1);
    }
    [self pushOperand:resultado];
    return resultado;
};
@end
