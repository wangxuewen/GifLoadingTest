//
//  FLAnimatedImageView+GifLoading.h
//  YunRuoTest
//
//  Created by Davin on 2020/8/1.
//  Copyright © 2020 WenZheng. All rights reserved.
//

#import "FLAnimatedImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLAnimatedImageView (GifLoading)

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
