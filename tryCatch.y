%{
#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;
extern FILE *yyout;
int yylex();
void yyerror(const char *s);
%}


%token id num try catch finally data_type
%right '='
%left '+' '-'
%left '*' '/'


%%

//START SYMBOL
//ACCEPTING STATE
START                   : data_type id '(' MULTIPLE_PARAM ')' '{' LINES '}' {printf("Accepted \n"); exit(0);}
                        ;    
//LINES
LINES  	                : TRY                               //TRY STATEMENT IN LINE
                        | TRY LINES                         //TRY AND AGAIN LINE
                        | EXPRESSION                        //EXPRESSION IN LINE 
                        | EXPRESSION LINES                  //EXPRESSION AND AGAIN LINE
                        ;

//TRY DEFINATION
TRY                     : try BODY CATCH_OR_FINALLY         //AFTER TRY, CATCH OR FINALLY SHOULD COME
                        ;

//ONE OR MORE THAN ONE CATCH WITH OR WITHOUT FINAL
CATCH_OR_FINALLY        : CATCH BODY                        //SINGLE CATCH
                        | finally BODY                      //FINALLY
                        | CATCH BODY  CATCH_OR_FINALLY      //CATCH OR FINALLY AFTER CATCH
                        ;

//CATCH ARGUMENTS
CATCH                   : catch '(' CATCH_PARAM  ')'        //CATCH ARGUMENT
                        ;  

//CATCH PARAMETER
CATCH_PARAM             : id '|' CATCH_PARAM                //MULTIPLE EXCEPTIONS IN PARAMETER
                        | id id                             //EXCEPTION EX
                        ;
//Multiple Parameter
MULTIPLE_PARAM          : PARAM                      
                        |
                        ;
//PARAM
PARAM                   : data_type id ',' PARAM
                        | data_type id
                        ;
                        
//BODY OF TRY CATCH FINALLY
BODY                    : '{' '}'                           //EMPTY BODY
                        | '{' LINES '}'                     //BODY CONTAINS LINES
                        ;

//EXPRESSION IN LINE
EXPRESSION              : data_type id ';'                  //DECLARATION 
                        | data_type id '='num ';'           //DECLARE AND ASSIGN
                        | data_type id '=' id ';'           //DECLARE AND ASSIGN
                        | id '=' num ';'                    //ASSIGNMENT
                        | id '=' id '+' num ';'             //ASSIGNMENT
                        | id '=' id '-' num ';'             //ASSIGNMENT
                        | id '=' id '*' num ';'             //ASSIGNMENT
                        | id '=' id '/' num ';'             //ASSIGNMENT
                        | UNARY_EXPRESSION ';'              //UNARY_EXPRESSION
                        ;

//UNARY EXPRESSION
UNARY_EXPRESSION        : UNARY_EXPRESSION '+' '+'          //POST INCREMENT 
                        | UNARY_EXPRESSION '-' '-'          //POST DECREMENT 
                        | '+' '+' UNARY_EXPRESSION          //PRE INCREMENT
                        | '-' '-' UNARY_EXPRESSION          //PRE DECREMENT 
                        | id                                //IDENTIFIER
                        ;  

%%

 
void yyerror(char const *s)
{
    printf("\nyyerror  %s\n",s);
    exit(1) ;
}

int main(int argc,char **argv) {
    yyin = fopen(argv[argc-1],"r");
    //yyout = fopen("commi.txt", "w"); 
    yyparse();
     
    return 1;
}