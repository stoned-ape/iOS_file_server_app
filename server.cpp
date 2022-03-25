//
//  server.cpp
//  hack1
//
//  Created by Apple1 on 3/10/22.
//



#include "objc.h"
#include "server.hpp"

void allocate_buf(int n){
    assert(globals.magic==1234567);
    if(globals.data!=NULL) free(globals.data);
    globals.size=n;
    globals.data=(uint8_t*)malloc(n);
    assert(globals.data);
}

server sv(8000);

void globals_init(){
    puts("globals_init");
    globals.magic=1234567;
    globals.isrunning=false;
    globals.port=sv.host_port;
    globals.url=(char*)malloc(sv.url.size()+1);
    strcpy(globals.url,sv.url.c_str());
    globals.data=NULL;
    char html[]=
    "<html>\n"
    "   <h1>iOS HTTP Server</h1>\n"
    "   Once a file is selected, you can find it here.\n"
    "</html>\n"
    ;
    allocate_buf(sizeof(html)-1);
    strcpy((char*)globals.data,(char*)html);
}



//phone ip:169.254.153.19


void run_cpp_server(){
    assert(globals.magic==1234567);
    globals.isrunning=true;
    printf("c++ \n");
    printf("username: %s\n",getlogin());
    char *app_key=basename(getenv("HOME"));
    puts(app_key);
    string bundle_path="/private/var/containers/Bundle/Application/";
    bundle_path+=app_key;
    bundle_path+="/hack1.app";
    cout<<bundle_path<<'\n';
    SYSCALL_NOEXIT(chdir(bundle_path.c_str()));
    
    sv.thread_server=true;
//#define DIR_SERVER
#ifndef DIR_SERVER
    sv.set_callback("/[^]*",[](http){
        http rsp;
        vector<char> data;
        for(int i=0;i<globals.size;i++) data.push_back(globals.data[i]);
        rsp.set_data(data);
        return rsp;
    });
#else
    sv.set_callback("/[^]*",file_server_callback);
#endif
    PTHREAD(pthread_create(&globals.server_tid,NULL,[](void*)->void*{
        sv.run();
        return NULL;
    },NULL));

}

//app
// /private/var/containers/Bundle/Application/25645A09-7B91-4431-B67D-5EE72FE2DC33/hack1.app


int _main(int argc,char **argv,char **envp){
    puts("c++ main()");
    for(int i=0;i<argc;i++){
        puts(argv[i]);
    }
    SYSCALL(open(argv[0],O_RDONLY));
    char *dir=NULL;
    dir=getenv("CFFIXED_USER_HOME");
    dir=getenv("HOME");
//    dir=getenv("TMPDIR");
    printf("dir: %s\n",dir);
    SYSCALL(chdir(dir));
    int i=0;
    while(envp[i]!=NULL){
        puts(envp[i]);
        i++;
    }
    globals_init();
    run_cpp_server();
    while(1){
        sleep(1);
    }
}
