#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <AudioToolbox/AudioServices.h>
#import <spawn.h>


static NSString *const takeMeThere = @"/var/mobile/Library/Preferences/me.luki.amēlijaprefs.plist";

#define AmelijaTintColor [UIColor colorWithRed: 0.47 green: 0.21 blue: 0.24 alpha: 1.0]


@interface OBWelcomeController : UIViewController
@property (assign, nonatomic) BOOL _shouldInlineButtontray;
- (id)initWithTitle:(id)arg1 detailText:(id)arg2 icon:(id)arg3;
- (void)addBulletedListItemWithTitle:(id)arg1 description:(id)arg2 image:(id)arg3;
@end


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(long long)arg1;
@end


@interface _UIBackdropView : UIView
@property (assign, nonatomic) BOOL blurRadiusSetOnce;
@property (assign, nonatomic) double _blurRadius;
@property (copy, nonatomic) NSString *_blurQuality;
- (id)initWithSettings:(id)arg1;
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end


@interface AMLRootVC : PSListController
@end


@interface LSRootVC : PSListController
@property (nonatomic, strong) NSMutableDictionary *savedSpecifiers;
@end


@interface HSRootVC : PSListController
@property (nonatomic, strong) NSMutableDictionary *savedSpecifiers;
@end


@interface AmelijaLinksVC : PSListController
@end


@interface AmelijaContributorsVC : PSListController
@end


@interface AmelijaTableCell : PSTableCell
@end


@interface PSListController (Private)
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end


@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end
