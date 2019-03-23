#pragma source on
#pragma statistic on
#pragma token on
int main(){
#pragma token off
	printf("hello");
#pragma token on
	int a = 5;
#pragma token off
	float b = 01.010;
#pragma token on	
	int c = -1;
#pragma token off
	printf("hello world");
	printf("hello world123");
	printf("hello world456");
	return 0;
}
