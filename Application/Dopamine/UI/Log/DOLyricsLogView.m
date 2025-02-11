//
//  DOLyricsLogView.m
//  Dopamine
//
//  Created by tomt000 on 13/01/2024.
//

#import "DOLyricsLogView.h"
#import "DOProgressiveBlurView.h"

#define LOG_HEIGHT 40

@implementation DOLyricsLogView

- (id)init
{
    if (self = [super init]) {
        self.stackView = [[UIStackView alloc] init];
        self.stackView.axis = UILayoutConstraintAxisVertical;
        self.stackView.spacing = 0;
        self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
        self.stackView.alignment = UIStackViewAlignmentLeading;
        [self addSubview:self.stackView];

        [NSLayoutConstraint activateConstraints:@[
            [self.stackView.topAnchor constraintEqualToAnchor:self.bottomAnchor constant:-80],
            [self.stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:25],
            [self.stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-25],
        ]];


        DOProgressiveBlurView *blurView = [[DOProgressiveBlurView alloc] initWithGradientMask:[UIImage imageNamed:@"alpha-gradient"] maxBlurRadius:4];
        blurView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:blurView];

        [NSLayoutConstraint activateConstraints:@[
            [blurView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [blurView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [blurView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [blurView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-125],
        ]];

    }
    return self;
}

- (void)showLog:(nonnull NSString *)log
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLog:log];
        });
        return;
    }

    [self.stackView.arrangedSubviews makeObjectsPerformSelector:@selector(setCompleted)];

    DOLyricsLogItemView *itemView = [[DOLyricsLogItemView alloc] initWithString:log];
    [self.stackView addArrangedSubview:itemView];

    [NSLayoutConstraint activateConstraints:@[
        [itemView.leadingAnchor constraintEqualToAnchor:self.stackView.leadingAnchor],
        [itemView.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor],
        [itemView.heightAnchor constraintEqualToConstant:LOG_HEIGHT]
    ]];

    CGFloat currentTranslation = self.stackView.transform.ty;
    [UIView animateWithDuration:0.3 animations:^{
        itemView.alpha = 1;
        self.stackView.transform = CGAffineTransformMakeTranslation(0, currentTranslation - LOG_HEIGHT);
    }];
}

- (void)updateLog:(nonnull NSString *)log
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateLog:log];
        });
        return;
    }
    DOLyricsLogItemView *lastItemView = self.stackView.arrangedSubviews.lastObject;
    lastItemView.label.text = log;
}

- (void)didComplete
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didComplete];
        });
        return;
    }

    [self showLog:@"Done"];
    [self.stackView.arrangedSubviews makeObjectsPerformSelector:@selector(setSuccess)];
}

@end
