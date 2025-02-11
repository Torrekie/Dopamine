//
//  DOLyricsLogItemView.m
//  Dopamine
//
//  Created by tomt000 on 18/01/2024.
//

#import "DOLyricsLogItemView.h"

@implementation DOLyricsLogItemView

- (id)initWithString:(NSString *)string {
    if (self = [super init]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.alpha = 0.9;

        self.label = [[UILabel alloc] init];
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        self.label.text = string;
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.label];

        self.loadingIndicator = [[DOLoadingIndicator alloc] init];
        self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.loadingIndicator];

        [NSLayoutConstraint activateConstraints:@[
            [self.loadingIndicator.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [self.loadingIndicator.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [self.loadingIndicator.heightAnchor constraintEqualToConstant:30],
            [self.loadingIndicator.widthAnchor constraintEqualToConstant:30],
            
            [self.label.leadingAnchor constraintEqualToAnchor:self.loadingIndicator.trailingAnchor constant:15],
            [self.label.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [self.label.topAnchor constraintEqualToAnchor:self.topAnchor],
            [self.label.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

        ]];
        self.transform = CGAffineTransformMakeTranslation(0, 8);
        self.feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        self.alpha = 0;
    }
    return self;
}

- (void)completeWithSymbol: (NSString*)name
{
    if (self.completed) return;
    self.completed = YES;

    UIImage *checkmarkImage = [UIImage systemImageNamed:name];
    checkmarkImage = [checkmarkImage imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:19 weight:UIImageSymbolWeightRegular]];
    UIImageView *checkView = [[UIImageView alloc] initWithImage:checkmarkImage];

    checkView.translatesAutoresizingMaskIntoConstraints = NO;
    checkView.tintColor = [UIColor whiteColor];
    checkView.alpha = 0;

    [self addSubview:checkView];
    [NSLayoutConstraint activateConstraints:@[
        [checkView.centerYAnchor constraintEqualToAnchor:self.loadingIndicator.centerYAnchor],
        [checkView.centerXAnchor constraintEqualToAnchor:self.loadingIndicator.centerXAnchor],
    ]];

    self.label.font = [UIFont systemFontOfSize:18];

    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.5;
        self.loadingIndicator.alpha = 0;
        checkView.alpha = 1;
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    }];

    [self.feedbackGenerator impactOccurred];
}

- (void)setCompleted {
    [self completeWithSymbol: @"checkmark"];
}

- (void)setFailed {
    [self completeWithSymbol: @"exclamationmark.circle"];
}

- (void)setSuccess {
    [self completeWithSymbol: @"lock.open"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.feedbackGenerator impactOccurredWithIntensity:1];
    });
}

@end
