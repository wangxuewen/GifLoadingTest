//
//  FLAnimatedImageView+GifLoading.m
//  YunRuoTest
//
//  Created by Davin on 2020/8/1.
//  Copyright © 2020 WenZheng. All rights reserved.
//

#import "FLAnimatedImageView+GifLoading.h"
#import "FLAnimatedImage.h"
#import "SDWebImage.h"

@implementation FLAnimatedImageView (GifLoading)

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)image {
    [self sd_internalSetImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed context:nil setImageBlock:^(UIImage * _Nullable image, NSData * _Nullable imageData, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        SDImageFormat format =  [NSData sd_imageFormatForImageData:imageData];
        if (format == SDImageFormatGIF) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                FLAnimatedImage * animatedImage =  [[FLAnimatedImage alloc] initWithAnimatedGIFData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.animatedImage = animatedImage;
                    self.image = nil;
                });
            });
        } else {
            self.image = image;
            self.animatedImage = nil;
        }
    } progress:nil completed:nil];
}




@end
