%{
#define MAX_LINE_LENGTH 256
#define MAX_ID_LENGTH 256
#define MAX_STRING_LENGTH 256
#define LIST                { strncat(buf, yytext, MAX_LINE_LENGTH); }
#define tokenString(t, s)   { LIST; if (Opt_Token) printf("<%s:%s>\n", t, s); }
#define checkRedundency()	{ }
#define addFreqency()		{ }

int Opt_Source = 1;
int Opt_Token = 1;
int Opt_Statistic = 1;
int linenum = 1;
char buf[MAX_LINE_LENGTH+1];

char ids[50][MAX_LINE_LENGTH+1];
int id_count[50];
int id_check = 0;
int id_idx = 0;

%}

digit [0-9]
_integer 0|([1-9][0-9]*)
_float {digit}+[\56]{digit}+
_space [\40\t]+
letter [a-zA-Z]
_string [\42][\40-\176]*[\42]
_identifier {letter}({letter}|{digit})*
_delimiter [\(\)\{\}\,\;] 
addition [\53]
subtraction [\55]
multiplication [\52]
division [\57\45]
assignment [\75]
relational \74|(\74\75)|(\41\75)|(\76\75)|\76|\75\75
logical \46\46|\174\174|\41
_op {addition}|{subtraction}|{multiplication}|{division}|{assignment}|{relational}|{logical}
_keyword while|do|if|else|true|false|for|int|print|const|read|boolean|bool|void|float|double|string|continue|break|return
_scientific ({_float}|{_integer})E[\53\55]?[0-9]*
com1 (\57\57)[\40-\176]*(\57\57)
com2 (\57\52)[\40-\176]*(\52\57)
_comment {com1}|{com2}
_pragmaSourceOn [\43]pragma[\40]source[\40](on)$ 
_pragmaSourceOff [\43]pragma[\40]source[\40](off)$ 
_pragmaTokenOn [\43]pragma[\40]token[\40](on)$ 
_pragmaTokenOff [\43]pragma[\40]token[\40](off)$
_pragmaStatisticOn [\43]pragma[\40]statistic[\40](on)$ 
_pragmaStatisticOff [\43]pragma[\40]statistic[\40](off)$

%%
[\40\t\n]?
{_pragmaSourceOn} {
	LIST;
	Opt_Source = 1;
}

{_pragmaSourceOff} {
	LIST;
	Opt_Source = 0;
}

{_pragmaTokenOn} {
	LIST;
	Opt_Token = 1;
}

{_pragmaTokenOff} {
	LIST;
	Opt_Token = 0;
}

{_pragmaStatisticOn} {
	LIST;
	Opt_Statistic = 1;
}

{_pragmaStatisticOff} {
	LIST;
	Opt_Statistic = 0;
}

{_comment} {
    LIST; 
}

{_scientific} {
    tokenString("sci", yytext); 
}

{_keyword} {
    tokenString("kw", yytext); 
}

{_op} {
    tokenString("op", yytext); 
}

{_integer} {
    tokenString("int", yytext); 
}

{_float} {
    tokenString("float", yytext); 
}


{_space} {
	LIST;
}

{_string} {
	LIST;
	if (Opt_Token){
		printf("<string:");
		for(int i = 1; i < yyleng - 1; i++){
			printf("%c", yytext[i]);
		};
	    printf(">\n");	
	}
}

{_identifier} { // record the id
	for(int i=0; i<=id_idx; i++){
		if (strcmp(yytext, ids[i]) == 0){
			id_check = 1;
			id_count[i]++;
			break;
		} 
	}
	if (id_check == 0){
    	strcpy(ids[id_idx], yytext); 
		id_count[id_idx] = 1;
		id_idx++;
	}
	id_check == 0;
	tokenString("id", yytext);
}

{_delimiter} {
    tokenString("delim", yytext);
}


\n {
    LIST;
    if (Opt_Source)
        printf("%d:%s\n", linenum, buf);
    ++linenum;
    buf[0] = '\0';
}

. { // Unrecognized character
    fprintf(stderr, "Error at line %d: %s\n", linenum, yytext);
    exit(1);
}

%%

int main( int argc, char **argv )
{
    if (argc >= 2)
    {
        yyin = fopen( argv[1], "r" );
        if ( NULL == yyin ) {
            fprintf( stderr, "Cannot open: %s\n", argv[1] );
            exit(-1);
        }
    }
    else
    {
        yyin = stdin;
    }

    yylex();
	
    if (Opt_Statistic)
    {
        printf("frequencies of identifiers:\n");
        for(int i=0; i<id_idx; i++){
        	printf("%s %d\n", ids[i], id_count[i]);
		}
        //format :  printf("%s\t%d\n");
    }
	
    exit(0);
}
