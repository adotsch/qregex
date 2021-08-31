regex.so: regex.c
	gcc -std=gnu99 -DKXVER=3 -fPIC -c regex.c
	gcc -shared -fPIC regex.o -o regex.so
