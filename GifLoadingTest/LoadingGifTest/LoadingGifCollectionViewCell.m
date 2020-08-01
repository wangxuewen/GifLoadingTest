//
//  LoadingGifCollectionViewCell.m
//  YunRuoTest
//
//  Created by Davin on 2020/7/28.
//  Copyright © 2020 WenZheng. All rights reserved.
//

#import "LoadingGifCollectionViewCell.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LoadingGifCollectionViewCell()


@end

@implementation LoadingGifCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatSubviews];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.isShowCurrentPage = NO;
    [self.gifImageView stopAnimating];
    
}

- (void)creatSubviews {
    [self.contentView addSubview:self.gifImageView];
    [self.gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setGifUrl:(NSString *)gifUrl {
    if (![_gifUrl isEqualToString:gifUrl]) {
        _gifUrl = gifUrl;
    }
}

#pragma mark - Getter
- (UIImageView *)gifImageView {
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc] init];
        _gifImageView.backgroundColor = [UIColor orangeColor];
        _gifImageView.contentMode = UIViewContentModeScaleAspectFill;
        _gifImageView.clipsToBounds = YES;
    }
    return _gifImageView;
}

@end
