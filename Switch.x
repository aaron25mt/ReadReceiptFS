#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import "notify.h"

#define readReceiptPlist @"/var/mobile/Library/Preferences/com.apple.madrid.plist"

@interface ReadReceiptFSSwitch : NSObject <FSSwitchDataSource>
@end

@implementation ReadReceiptFSSwitch
-(FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier {
	NSDictionary* readReceiptSettings = [NSDictionary dictionaryWithContentsOfFile:readReceiptPlist];
	return [[readReceiptSettings objectForKey:@"ReadReceiptsEnabled"] boolValue] ? FSSwitchStateOn : FSSwitchStateOff;
}

-(void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier {
	NSMutableDictionary* readReceiptSettings = [NSMutableDictionary dictionaryWithContentsOfFile:readReceiptPlist];

	if(newState == FSSwitchStateIndeterminate) {
		return;
	} else if(newState == FSSwitchStateOn) {
		[readReceiptSettings setObject:[NSNumber numberWithBool:YES] forKey:@"ReadReceiptsEnabled"];
	} else if(newState == FSSwitchStateOff) {
		[readReceiptSettings setObject:[NSNumber numberWithBool:NO] forKey:@"ReadReceiptsEnabled"]; 
	}
	[readReceiptSettings writeToFile:readReceiptPlist atomically:YES];
	notify_post("com.apple.madrid-prefsChanged");
}

-(NSString *)titleForSwitchIdentifier:(NSString *)switchIdentifier {
	return @"Read Receipts";
}
@end