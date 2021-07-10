#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <AudioToolbox/AudioServices.h>
#import <spawn.h>


@interface OBButtonTray : UIView
@property (nonatomic,retain) UIVisualEffectView * effectView;
- (void)addButton:(id)arg1;
- (void)addCaptionText:(id)arg1;;
@end


@interface OBBoldTrayButton : UIButton
- (void)setTitle:(id)arg1 forState:(unsigned long long)arg2;
+ (id)buttonWithType:(long long)arg1;
@end


@interface OBWelcomeController : UIViewController
@property (nonatomic, retain) UIView * viewIfLoaded;
@property (nonatomic, strong) UIColor * backgroundColor;
@property (assign, nonatomic) BOOL _shouldInlineButtontray;
- (OBButtonTray *)buttonTray;
- (id)initWithTitle:(id)arg1 detailText:(id)arg2 icon:(id)arg3;
- (void)addBulletedListItemWithTitle:(id)arg1 description:(id)arg2 image:(id)arg3;
@end


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(long long)arg1;
@end

@interface _UIBackdropView : UIView
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
- (id)initWithSettings:(id)arg1;
@property (assign, nonatomic) BOOL blurRadiusSetOnce;
@property (assign, nonatomic) double _blurRadius;
@property (nonatomic, copy) NSString * _blurQuality;
@end


UIBarButtonItem *changelogButtonItem;


@interface AmelijaTableCell : PSTableCell
@end


@interface AmelijaLinksRootListController : PSListController
@end


@interface AmelijaContributorsRootListController : PSListController
@end


@interface AMLRootListController : PSListController {

	UITableView * _table;

}
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) UIImageView *headerImageView;
@property (nonatomic, retain) OBWelcomeController *changelogController;
- (void)showWtfChangedInThisVersion:(UIButton *)sender;
- (void)shatterThePrefsToPieces;
- (void)respringMethod;
@end


@interface PSListController (Private)
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end


@interface LSRootListController : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@end


@interface HSRootListController : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@end


@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end