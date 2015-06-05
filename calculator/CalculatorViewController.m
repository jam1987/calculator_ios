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
@property (nonatomic) BOOL  userIsToTheMiddelOfTyppingVariable;
// Esta propiedad es para tener acceso a los metodos del brain (Modelo).
@property (nonatomic,strong) CalculatorBrain *brain;
@property (nonatomic,strong) NSString *group; 
@property (nonatomic,strong) NSMutableDictionary *testVariableValues;
@property (nonatomic,strong) NSMutableSet *variablesUsedInProgram;


@end

@implementation CalculatorViewController
// Esta propiedad representa el display principal donde se muestra el resultado 
// de una operacion
@synthesize display = _display;
// Esta propiedad representa el display que se encuentra en la parte superior, el
// cual lleva el historial de todas las operaciones.
@synthesize history_display = _history_display;
@synthesize variable_display = _variable_display;
@synthesize userIsToTheMiddleOfTyppingNumber = _userIsToTheMiddleOfTyppingNumber;
@synthesize userIsToTheMiddelOfTyppingVariable = _userIsToTheMiddelOfTyppingVariable;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;
@synthesize variablesUsedInProgram = _variablesUsedInProgram;
@synthesize group = _group;


int number = 0;

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
};


-(NSMutableSet*)variablesUsedInProgram {
    if (!_variablesUsedInProgram) {
        _variablesUsedInProgram = [[NSMutableSet alloc] init];
    }
    return _variablesUsedInProgram;
}


-(NSMutableDictionary*)testVariableValues {
    if (!_testVariableValues) {
        _testVariableValues =[[NSMutableDictionary alloc] init];
    }
    return _testVariableValues;
}

-(NSString*) group {
    if (!_group) {
        _group = [[NSString alloc] init];
    }
    return _group;
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
    if ([self.history_display.text isEqualToString:@"0"]) {
        NSRange range = [self.history_display.text rangeOfString:@"0"];
        self.history_display.text = [self.history_display.text stringByReplacingCharactersInRange:range withString:@""];
    }
    if (number==0) {
         
        self.history_display.text = [self.history_display.text stringByAppendingString:self.display.text];
        self.history_display.text = [self.history_display.text stringByAppendingString:@" "];
            self.userIsToTheMiddleOfTyppingNumber = NO;
        number++;
    } else {
       
        NSString *aux= self.display.text;
        aux = [aux stringByAppendingString:@" "];
        aux = [aux stringByAppendingString:@","];
        aux = [aux stringByAppendingString:@" "];
        aux = [aux stringByAppendingString:self.history_display.text];
        self.history_display.text = aux;
        self.userIsToTheMiddleOfTyppingNumber = NO;
        number++;

    }
}



- (IBAction)testPressed:(id)sender {
    int k=1;
   
    if ([[sender currentTitle] isEqualToString:@"Test 1"]) {
        NSArray *keys = [self.testVariableValues allKeys];
        [self.testVariableValues removeAllObjects];
        for (NSString *key in keys) {
            [self.testVariableValues setObject:[NSString stringWithFormat:@"%d",k] forKey:key];
            k++;
        }
        
    } else if ([[sender currentTitle] isEqualToString:@"Test 2"]) {
        k=-1;
        NSArray *keys = [self.testVariableValues allKeys];
        [self.testVariableValues removeAllObjects];
        for (NSString *key in keys) {
            [self.testVariableValues setObject:[NSString stringWithFormat:@"%d",k] forKey:key];
            k--;
        }
        
    } else if ([[sender currentTitle] isEqualToString:@"Test 3"]) {
        NSArray *keys = [self.testVariableValues allKeys];
        [self.testVariableValues removeAllObjects];
        for (NSString *key in keys) {
            [self.testVariableValues setObject:@"0" forKey:key];
        }
        
    }
    
    self.variable_display.text = @"";
    
    for (id key in self.testVariableValues) {
        
        self.variable_display.text = [[[[self.variable_display.text stringByAppendingString:[NSString stringWithFormat:key]] stringByAppendingString:@" = "] stringByAppendingString:[self.testVariableValues objectForKey:key]] stringByAppendingString:@"  "];
    }
    self.userIsToTheMiddelOfTyppingVariable=NO;
}

- (IBAction)variablePressed:(UIButton*)sender {
    NSString *var = [sender currentTitle];
    if (![self.variablesUsedInProgram containsObject:var]) {
        [self.variablesUsedInProgram addObject:var];
        
        [self.brain pushVariable:var];
        

        [self.testVariableValues setObject:[NSString stringWithFormat:@"%g",0] forKey:var];   
        /* Se detecta si el usuario no ha dejado de presionar digitos
         */
        if (self.userIsToTheMiddelOfTyppingVariable) {
            self.variable_display.text = [self.variable_display.text stringByAppendingString:@"  "];
            self.variable_display.text = [[[self.variable_display.text stringByAppendingString:[sender currentTitle]] stringByAppendingString:@" = "] stringByAppendingString:[NSString stringWithFormat:@"%g",0]];
            
            self.history_display.text = [self.history_display.text stringByAppendingString:[sender currentTitle]];
            self.history_display.text = [self.history_display.text stringByAppendingString:@" "];

            
        } else {
    
            self.variable_display.text = [[[sender currentTitle] stringByAppendingString:@" = "] stringByAppendingString:@"0"];     
            NSString *aux= [sender currentTitle];
            aux = [aux stringByAppendingString:@" "];
            aux = [aux stringByAppendingString:@","];
            aux = [aux stringByAppendingString:@" "];
            aux = [aux stringByAppendingString:self.history_display.text];
            self.history_display.text = aux;

            self.userIsToTheMiddelOfTyppingVariable = YES;
        }
        double resultado = [self.brain performOperation:[sender currentTitle] usingVariablesValues:self.testVariableValues];
        if (resultado==INFINITY || isnan(resultado)) {
            self.display.text = @"Math Error!";
        } else {
            
            // Se guarda tanto el resultado como la operacion dentro del historial de operaciones
            // que se muestra en la parte superior de la calculadora.
            NSString *result = [NSString stringWithFormat:@"%g",resultado];
            self.history_display.text = [self.history_display.text stringByAppendingString:[sender currentTitle]];
            self.history_display.text = [self.brain printOperation:[sender currentTitle]];
            
            self.display.text = result;
        }

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
    double resultado = [self.brain performOperation:[sender currentTitle] usingVariablesValues:self.testVariableValues];
    // Esto es para detectar la division por cero.
    
    if (resultado==INFINITY || isnan(resultado)) {
        self.display.text = @"Math Error!";
    } else {
       
        // Se guarda tanto el resultado como la operacion dentro del historial de operaciones
        // que se muestra en la parte superior de la calculadora.
        NSString *result = [NSString stringWithFormat:@"%g",resultado];
        self.history_display.text = [self.history_display.text stringByAppendingString:[sender currentTitle]];
        self.history_display.text = [self.brain printOperation:[sender currentTitle]];

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
    self.variable_display.text = @"";
    [self.testVariableValues removeAllObjects];
    [self.variablesUsedInProgram removeAllObjects];
    self.userIsToTheMiddleOfTyppingNumber = NO;
    number = 0;
    
}


- (void)viewDidUnload {
    [self setVariable_display:nil];
    [super viewDidUnload];
}
@end
