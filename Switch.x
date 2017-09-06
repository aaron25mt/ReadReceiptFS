#import "FSSwitchDataSource.h" //Necessary for all flipswitches
#import "FSSwitchPanel.h" //Necessary for all flipswitches
#import "notify.h" //So, we can let the device know, we changed a setting

#define readReceiptPlist @"/var/mobile/Library/Preferences/com.apple.madrid.plist" //So we can easily reference this file, let's make it a variable

@interface ReadReceiptFSSwitch : NSObject <FSSwitchDataSource>
@end
//Necessary to delegate FSSwitchDataSource

@implementation ReadReceiptFSSwitch //Where all the magic happens
-(FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier { //This is where we set the state of the flipswitch (on or off)
	NSDictionary* readReceiptSettings = [NSDictionary dictionaryWithContentsOfFile:readReceiptPlist]; //Lets read the read receipt file
	return [[readReceiptSettings objectForKey:@"ReadReceiptsEnabled"] boolValue] ? FSSwitchStateOn : FSSwitchStateOff; //If read receipts are on, the switch is on and vise versa
}

-(void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier { //Let's change read receipts, based on if the user switched the switch
	NSMutableDictionary* readReceiptSettings = [NSMutableDictionary dictionaryWithContentsOfFile:readReceiptPlist]; //Let's get the files contents

	if(newState == FSSwitchStateIndeterminate) { //If switch is neither on or off (the user dun goofed)..
		return; //Don't do anything
	} else if(newState == FSSwitchStateOn) { //If toggled on..
		[readReceiptSettings setObject:[NSNumber numberWithBool:YES] forKey:@"ReadReceiptsEnabled"]; //turn read reciepts on!
	} else if(newState == FSSwitchStateOff) { //But if toggled off..
		[readReceiptSettings setObject:[NSNumber numberWithBool:NO] forKey:@"ReadReceiptsEnabled"]; //turn read reciepts off!
	}
	[readReceiptSettings writeToFile:readReceiptPlist atomically:YES]; //let's change the actual file with the changes we made above
	notify_post("com.apple.madrid-prefsChanged"); //update prefs through apple notification
}

-(NSString *)titleForSwitchIdentifier:(NSString *)switchIdentifier { //the title that shows when you click the flipswitch
	return @"Read Receipts"; //title show to user
}
@end
