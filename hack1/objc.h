//
//  objc.h
//  hack1
//
//  Created by Apple1 on 4/30/21.
//

#ifndef objc_h
#define objc_h

#include <pthread.h>
#include <stdio.h>
#include <stdbool.h>

typedef struct{
    int magic;
    char *ip,*url;
    short port;
    int size;
    unsigned char *data;
    pthread_t server_tid;
    bool isrunning;
}shared_data;




#ifdef __cplusplus

#define _LIBCPP_MATH_H
shared_data globals;
extern "C" void run_cpp_server();
extern "C" void allocate_buf(int n);
extern "C" void globals_init();

#else
extern shared_data globals;
extern void run_cpp_server(void);

void globals_init(void);
void allocate_buf(int n);



#endif

#endif /* objc_h */
