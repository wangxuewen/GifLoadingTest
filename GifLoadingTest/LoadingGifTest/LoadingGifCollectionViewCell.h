//
//  LoadingGifCollectionViewCell.h
//  YunRuoTest
//
//  Created by Davin on 2020/7/28.
//  Copyright © 2020 WenZheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoadingGifCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *gifUrl;
@property (nonatomic, strong) UIImageView *gifImageView;
// 滑动后是否还在当前屏幕展示 （放置重复加载）
@property (nonatomic, assign) BOOL isShowCurrentPage;
@end

NS_ASSUME_NONNULL_END
