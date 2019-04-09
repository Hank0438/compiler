%{
int nchar, nword, nline, nn;
%}

word [^ \t\n]+

%%
{word} { nword++; nchar += yyleng; }
\n { nline++; nchar++; }
[\40-\127] {ECHO; nn++;}


%%

int main( int argc, char **argv ) {
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
	printf("%d\t%d\t%d\t%d\n", nchar, nword, nline, nn);
	exit(0);
}
