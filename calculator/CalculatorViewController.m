//
//  MySecondAppViewController.m
//  calculator
//
//  Created by Julio De Abreu on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

// Esta propiedad es usada para saber si el usuario ha dejado de
// introducir numeros.
@property (nonatomic) BOOL  userIsToTheMiddleOfTyppingNumber; 

// Esta propiedad es para tener acceso a los metodos del brain (Modelo).
@property (nonatomic,strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController
// Esta propiedad representa el display principal donde se muestra el resultado 
// de una operacion
@synthesize display = _display;
// Esta propiedad representa el display que se encuentra en la parte superior, el
// cual lleva el historial de todas las operaciones.
@synthesize history_display = _history_display;
@synthesize userIsToTheMiddleOfTyppingNumber = _userIsToTheMiddleOfTyppingNumber;
@synthesize brain = _brain;


/* Nombre del metodo: brain
 * Parametros de entrada: Ninguno
 * Tipo que devuelve: CalculatorBrain*
 * Descripcion del Metodo: Este metodo es un
 * getter que se le construyo al objeto CalculatorBrain (Modelo).
 *
 */
-(CalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain  alloc ] init];
    }
    return _brain;
}

/* Nombre del metodo: digitPressed
 * Parametros de Entrada: sender, de tipo UIButton*
 * Tipo que devuelve: IBAction
 * Descripcion del Metodo: Este metodo detecta cuando 
 * un usuario presiona un digito y lo muestra en la
 * interfaz.
 */
- (IBAction)digitPressed:(UIButton*)sender {
    
    /* Esto es porque al sender le quiero pasar el digito actual que se presiona y eso lo guardo en digito */
    NSString  *digito = [sender currentTitle];
    /* Se detecta si el usuario no ha dejado de presionar digitos
     */
    if (self.userIsToTheMiddleOfTyppingNumber) {
        self.display.text = [self.display.text stringByAppendingString:digito];
    /* Esto significa que el usuario no ha presionado ningun digito, y que esta 
     * por presionarlo */
    } else {
        self.display.text = digito;        
        self.userIsToTheMiddleOfTyppingNumber = YES;
    }
   
    
    
}

/* Nombre del metodo: erasePressed
 * Parametros de entrada: Ninguno
 * Tipo que devuelve: IBAction
 * Descripcion del Metodo: Este metodo detecta si
 * fue presionada la tecla "<-", la cual borra un digito
 * del numero introducido
 */
- (IBAction)erasePressed {
    /* Esto es para chequear si no se ha dejado de 
     * presionar digitos
     */
    if (self.userIsToTheMiddleOfTyppingNumber) {
        /* Se chequea si la cantidad de digitos es mayor a 1, esto es para
         * saber si de ser asi, entonces se borra un digito o, en caso 
         * contrario, se coloca 0
         */
        if ([self.display.text length]>1){
            self.display.text = [self.display.text substringToIndex:[self.display.text length] -1];
        } else {
            self.display.text = @"0";
            self.userIsToTheMiddleOfTyppingNumber = NO;
        }
    }
}

/* Nombre del Metodo: dotPressed
 * Parametros de Entrada: Ninguno
 * Tipo que devuelve: IBAction
 * Descripcion del Metodo: Este metodo chequea cuando
 * se ha presionado el boton ".". Esto permite tener
 * numeros en punto flotante
 */
- (IBAction)dotPressed {
    NSRange range = [self.display.text rangeOfString:@"."];
    /* Esto es para chequear si ya se ha introducido la tecla "." 
     * anteriormente. En caso afirmativo, arrojar un mensaje de error,
     * en caso negativo colocar un "." al numero
     */
    if (range.location == NSNotFound) {
        self.display.text = [self.display.text stringByAppendingString:@"."];
        self.userIsToTheMiddleOfTyppingNumber = YES;
    } else {
        self.display.text = @"Syntax Error!";
    }
}

/* Nombre del Metodo: enterPressed
 * Parametros de entrada: Ninguno
 * Tipo que devuelve: IBAction
 * Descripcion del Metodo: Este metodo detecta cuando se ha
 * presionado el boton "Enter", esto es para introducir un operando
 * dentro de la pila
 */
- (IBAction)enterPressed {
    // se introduce el operando en la pila
    [self.brain pushOperand:[self.display.text doubleValue]];
    // Esto es para formar el historial de operaciones que se muestra en la parte superior 
    // de la calculadora.
    if ([[self.history_display.text substringToIndex:1] doubleValue]==0) {
        self.history_display.text = @"";
    }
    
    self.history_display.text = [self.history_display.text stringByAppendingString:self.display.text];
    self.history_display.text = [self.history_display.text stringByAppendingString:@" "];
        self.userIsToTheMiddleOfTyppingNumber = NO;
}

/* Nombre del Metodo: ad_sub_pressed
 * Parametros de Entrada: sender de tipo id.
 * Tipo que devuelve: IBAction
 * Descripcion del Metodo: Este metodo detecta si el boton
 * "-/+" fue presionado, y en caso positivo, se chequea alguno
 * de los dos siguientes casos: 1) Si se ha presionado un numero
 * se le cambia el signo. 2) Si no se ha presionado un numero,
 * se toma el ultimo operando que entro en la pila y se le aplica
 * como un operador unario.
 */
- (IBAction)ad_sub_pressed:(id)sender {
    if (self.userIsToTheMiddleOfTyppingNumber) {
        double number = [self.display.text doubleValue];
        number = number * (-1);
        NSString *res = [NSString stringWithFormat:@"%g",number];
        self.display.text = res;
    } else {
        double resultado = [self.brain performOperation:[sender currentTitle]];
        NSString *res = [NSString stringWithFormat:@"%g",resultado];
        self.display.text = res;
        self.history_display.text = [self.history_display.text stringByAppendingString:[sender currentTitle]];
        self.history_display.text = [self.history_display.text stringByAppendingString:@" "];
        self.history_display.text = [self.history_display.text stringByAppendingString:@"="];
        self.history_display.text = [self.history_display.text stringByAppendingString:res];
        self.history_display.text = [self.history_display.text stringByAppendingString:@" "];
        self.display.text = res;

        
    }
}

/* Nombre del Metodo: operationPressed
 * Parametros de Entrada: sender de tipo id
 * Tipo que devuelve: IBAction
 * Descripcion del Metodo: Este metodo detecta cual operador
 * fue presionado y ejecuta el calculo correspondiente
 */
- (IBAction)operationPressed:(id)sender {
    // Esto es para chequear si el usuario presiono el boton de "Enter"
    // antes de presionar el boton del operador.
    if (self.userIsToTheMiddleOfTyppingNumber) [self enterPressed];
    // Aqui se obtiene el resultado
    double resultado = [self.brain performOperation:[sender currentTitle]];
    // Esto es para detectar la division por cero.
    
    if (resultado==INFINITY || isnan(resultado)) {
        self.display.text = @"Math Error!";
    } else {
       
        // Se guarda tanto el resultado como la operacion dentro del historial de operaciones
        // que se muestra en la parte superior de la calculadora.
        NSString *result = [NSString stringWithFormat:@"%g",resultado];
        self.history_display.text = [self.history_display.text stringByAppendingString:[sender currentTitle]];
        self.history_display.text = [self.history_display.text stringByAppendingString:@" "];
        self.history_display.text = [self.history_display.text stringByAppendingString:@"="];
        self.history_display.text = [self.history_display.text stringByAppendingString:result];
        self.history_display.text = [self.history_display.text stringByAppendingString:@" "];
        self.display.text = result;
    }
    
}

/* Nombre del Metodo: clearPressed
 * Parametros de entrada: Ninguno
 * Tipo que devuelve: IBAction
 * Descripcion del Metodo: Este metodo detecta si se presiono el boton "C".
 * Este es para borrar tanto el historial de operaciones como la ultima operacion
 */
- (IBAction)clearPressed {
    // Se borra la pila
    [self.brain clearStack];
    NSString *cero = @"0";
    // Se borra la ultima operacion
    self.display.text = cero;
    // Se borra el historial de operaciones.
    self.history_display.text = cero;
    self.userIsToTheMiddleOfTyppingNumber = NO;
}


@end
