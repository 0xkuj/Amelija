@import UIKit;


// LS


static BOOL lsBlur;
static BOOL epicLSBlur;
static BOOL blurIfNotifs;

static int lsBlurType;

static float lsIntensity = 1.0f;
static float epicLSBlurIntensity = 1.0f;

static UIBlurEffect* lsBlurEffect;

static int notificationCount = 0;
static NSInteger axonCellCount = 0;
static NSInteger takoCellCount = 0;


// HS


static BOOL hsBlur;
static BOOL epicHSBlur;

static int blurType;

static float hsIntensity = 1.0f;
static float epicHSBlurIntensity = 1.0f;

static UIBlurEffect* hsBlurType;


static NSString *takeMeThere = @"/var/mobile/Library/Preferences/me.luki.amēlijaprefs.plist";


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(long long)arg1;
@end


@interface _UIBackdropView : UIView
@property (assign,nonatomic) BOOL blurRadiusSetOnce;
@property (nonatomic,copy) NSString * _blurQuality;
@property (assign,nonatomic) double _blurRadius;
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
- (id)initWithSettings:(id)arg1;
@end


@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end


@interface CSCoverSheetViewController : UIViewController
@property (nonatomic, strong) UIView *blurView;
- (void)unleashThatLSBlur;
- (void)showBlurIfNotifsPresent;
@end


@interface SBHomeScreenViewController : UIViewController
- (void)unleashThatHSBlur;
@end

@interface NCNotificationMasterList : NSObject
@property(nonatomic, assign) NSInteger notificationCount;
@end


@interface AXNView : UIView
@end


@interface TKOView : UIView
@end


static void loadPrefs() {


	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:takeMeThere];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];


	lsBlur = prefs[@"lsBlur"] ? [prefs[@"lsBlur"] boolValue] : NO;
	epicLSBlur = prefs[@"epicLSBlur"] ? [prefs[@"epicLSBlur"] boolValue] : NO;
	blurIfNotifs = prefs[@"blurIfNotifs"] ? [prefs[@"blurIfNotifs"] boolValue] : NO;
	lsBlurType = prefs[@"lsBlurType"] ? [prefs[@"lsBlurType"] integerValue] : 0;
	lsIntensity = prefs[@"lsIntensity"] ? [prefs[@"lsIntensity"] floatValue] : 1.0f;
	epicLSBlurIntensity = prefs[@"epicLSBlurIntensity"] ? [prefs[@"epicLSBlurIntensity"] floatValue] : 1.0f;


	hsBlur = prefs[@"hsBlur"] ? [prefs[@"hsBlur"] boolValue] : NO;
	epicHSBlur = prefs[@"epicHSBlur"] ? [prefs[@"epicHSBlur"] boolValue] : NO;
	blurType = prefs[@"blurType"] ? [prefs[@"blurType"] integerValue] : 0;
	hsIntensity = prefs[@"hsIntensity"] ? [prefs[@"hsIntensity"] floatValue] : 1.0f;
	epicHSBlurIntensity = prefs[@"epicHSBlurIntensity"] ? [prefs[@"epicHSBlurIntensity"] floatValue] : 1.0f;


}


/*


Axon support smh, only because I love your creation Nepeta,
thank you so much for this gem. Hope you come back some day.
Lmao I'm writing this like if she's ever gonna come here,
anyways here's the magic, and we gotta do it kinda the old school way
because otherwise due to Amēlija being alphabetically before Axon
in the loading process, normal hooks loaded in the constructor wouldn't
take any effect, so that's why we pass a message with MSHookMessageEx
so we can control when to load it. And no, fuck dlopen, this is better


*/


static NSInteger (*origNumberOfCells)(id self, SEL _cmd, id collectionView, NSInteger section);


NSInteger numberOfCells(id self, SEL _cmd, id collectionView, NSInteger section) {


	axonCellCount = origNumberOfCells(self, _cmd, collectionView, section);

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"notifArrivedSoApplyingBlurNow" object:nil];

	return axonCellCount;


}


static NSInteger (*takoOrigNumberOfCells)(id self, SEL _cmd, id collectionView, NSInteger section);


NSInteger takoNumberOfCells(id self, SEL _cmd, id collectionView, NSInteger section) {


	takoCellCount = takoOrigNumberOfCells(self, _cmd, collectionView, section);

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"notifArrivedSoApplyingBlurNow" object:nil];

	return takoCellCount;


}


%hook SpringBoard


- (void)applicationDidFinishLaunching:(id)app {


	%orig;

	MSHookMessageEx(%c(AXNView), @selector(collectionView:numberOfItemsInSection:), (IMP) &numberOfCells, (IMP *) &origNumberOfCells);
	MSHookMessageEx(%c(TKOView), @selector(collectionView:numberOfItemsInSection:), (IMP) &takoNumberOfCells, (IMP *) &takoOrigNumberOfCells);


}


%end




%hook NCNotificationMasterList


- (void)removeNotificationRequest:(id)arg1 { // get notification count in a reliable way

	%orig;

	notificationCount = [self notificationCount];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"notifArrivedSoApplyingBlurNow" object:nil];

}

- (void)insertNotificationRequest:(id)arg1 {

	%orig;

	notificationCount = [self notificationCount];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"notifArrivedSoApplyingBlurNow" object:nil];

}

- (void)modifyNotificationRequest:(id)arg1 {

	%orig;

	notificationCount = [self notificationCount];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"notifArrivedSoApplyingBlurNow" object:nil];

}

%end




%hook CSCoverSheetViewController


%property (nonatomic, strong) UIView *blurView;


%new


- (void)unleashThatLSBlur { // self explanatory


	loadPrefs();

	[[self.view viewWithTag:1337] removeFromSuperview];


	if(lsBlur) {


		switch(lsBlurType) {


			case 1:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
				break;


			case 2:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
				break;


			case 3:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
				break;


			case 4:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterial];
				break;


			case 5:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
				break;


			case 6:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
				break;


			default:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
				break;


		}


		UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:lsBlurEffect];
		blurEffectView.tag = 1337;
		blurEffectView.alpha = lsIntensity;
		blurEffectView.frame = self.view.bounds;
		blurEffectView.clipsToBounds = YES;
		blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view insertSubview:blurEffectView atIndex:0];

		if(blurIfNotifs && notificationCount == 0) blurEffectView.alpha = 0;

		self.blurView = blurEffectView;


	}


	else if(epicLSBlur) {


		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

		_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
		blurView.blurRadiusSetOnce = NO;
		blurView._blurQuality = @"high";
		blurView.tag = 1337;
		blurView.alpha = epicLSBlurIntensity;
		[self.view insertSubview:blurView atIndex:0];

		if(blurIfNotifs && notificationCount == 0) blurView.alpha = 0;

		self.blurView = blurView;


	}


	if(self.blurView) [self showBlurIfNotifsPresent];


}


%new

- (void)showBlurIfNotifsPresent { // self explanatory


	loadPrefs();

	NSFileManager *fileM = [NSFileManager defaultManager];

	if(!blurIfNotifs) self.blurView.alpha = epicLSBlur ? epicLSBlurIntensity : lsIntensity;

	else if(![fileM fileExistsAtPath:@"Library/MobileSubstrate/DynamicLibraries/Tako.dylib"]) {

 		if((notificationCount == 0) && (axonCellCount == 0)) {

			[UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

				self.blurView.alpha = 0;

			} completion:nil];

		} else {

			[UIView transitionWithView:self.blurView duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

				self.blurView.alpha = epicLSBlur ? epicLSBlurIntensity : lsIntensity;

			} completion:nil];

		}

	} 

	else {

		if(takoCellCount == 0) {

			[UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

				self.blurView.alpha = 0;

			} completion:nil];

		} else {

			[UIView transitionWithView:self.blurView duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

				self.blurView.alpha = epicLSBlur ? epicLSBlurIntensity : lsIntensity;

			} completion:nil];

		}

	}

}


- (void)viewDidLoad { // create notification observers


	%orig;

	[self unleashThatLSBlur];

	[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(unleashThatLSBlur) name:@"lsBlurApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(showBlurIfNotifsPresent) name:@"notifArrivedSoApplyingBlurNow" object:nil];


}


%end




%hook SBHomeScreenViewController


%new


- (void)unleashThatHSBlur { // self explanatory


	loadPrefs();

	[[self.view viewWithTag:1337] removeFromSuperview];


	if(hsBlur) {


		switch(blurType) {


			case 1:

				hsBlurType = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
				break;


			case 2:

				hsBlurType = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
				break;


			case 3:

				hsBlurType = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
				break;


			case 4:

				hsBlurType = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterial];
				break;


			case 5:

				hsBlurType = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
				break;


			case 6:

				hsBlurType = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
				break;


			default:

				hsBlurType = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
				break;


		}


		UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:hsBlurType];
		blurEffectView.tag = 1337;
		blurEffectView.alpha = hsIntensity;
		blurEffectView.frame = self.view.bounds;
		blurEffectView.clipsToBounds = YES;
		blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view insertSubview:blurEffectView atIndex:0];


	}


	if(!(hsBlur) && (epicHSBlur)) {


		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

		_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero
		autosizesToFitSuperview:YES settings:settings];
		blurView.blurRadiusSetOnce = NO;
		blurView._blurRadius = 80.0;
		blurView._blurQuality = @"high";
		blurView.tag = 1337;
		blurView.alpha = epicHSBlurIntensity;
		[self.view insertSubview:blurView atIndex:0];


	}

}


- (void)viewDidLoad { // create notification observers


	%orig;

	[self unleashThatHSBlur];

	[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(unleashThatHSBlur) name:@"hsBlurApplied" object:nil];


}


%end




%ctor {

	loadPrefs();

}
