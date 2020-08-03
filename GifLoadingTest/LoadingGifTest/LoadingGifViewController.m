//
//  LoadingGifViewController.m
//  YunRuoTest
//
//  Created by Davin on 2020/7/28.
//  Copyright © 2020 WenZheng. All rights reserved.
//

#import "LoadingGifViewController.h"
#import "LoadingGifCollectionViewCell.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>
#import <MJRefresh/MJRefresh.h>

#define GIFURL @"https://test-img.caochangjihe.com/img/20200724172007-9e6bb42b-188b-452f-a22a-beaee4dd58a71595582407684.gif"

@interface LoadingGifViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *gifList;

@end

@implementation LoadingGifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"gif加载";
    
    [self initializeData];
    [self creatSubviews];
    [self configRefresh];
    [self configGIFData:YES];
}

- (void)initializeData {
    self.gifList = nil;
}

- (void)creatSubviews {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)configRefresh {
    MJWeakSelf
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf configGIFData:YES];
    }];
    self.collectionView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf configGIFData:NO];
    }];
    footer.automaticallyRefresh = NO;
    footer.triggerAutomaticallyRefreshPercent = 10;
    self.collectionView.mj_footer = footer;
}

- (void)configGIFData:(BOOL)isRefresh {
    if (isRefresh) {
        [self.gifList removeAllObjects];
    }
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < 20; i++) {
        [tempArray addObject:GIFURL];
    }
    [self.gifList addObjectsFromArray:tempArray];
    
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView reloadData];
    // 适当添加延时保证collectionView布局完成
    if (isRefresh) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadingGifPicture];
        });
    }
}


#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gifList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    LoadingGifCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LoadingGifCollectionViewCell" forIndexPath:indexPath];
    if (self.gifList.count > indexPath.item) {
        // gifUrl先赋值暂不加载（加载放在后面的逻辑中）
        cell.gifUrl = [NSString stringWithFormat:@"%@?key=%ld", self.gifList[indexPath.item], 200 + indexPath.item];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadingGifPicture) object:@"loadingGif"];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self performSelector:@selector(loadingGifPicture) withObject:@"loadingGif" afterDelay:0.5];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self performSelector:@selector(loadingGifPicture) withObject:@"loadingGif" afterDelay:0.5];
}

// 加载gif图片
- (void)loadingGifPicture {
    NSArray *visibleCells = [self.collectionView visibleCells];
    for (UICollectionViewCell *cell in visibleCells) {
        if ([cell isKindOfClass:[LoadingGifCollectionViewCell class]]) {
            CGRect rect = [cell convertRect:cell.bounds toView:self.collectionView.superview];
            // cell完成在屏幕中再加载，可以修改部分在屏幕中也加载...
            if (CGRectContainsRect(self.collectionView.frame, rect)) { // cell在屏幕中，先压缩图片尺寸，再加载gif
                LoadingGifCollectionViewCell *item = (LoadingGifCollectionViewCell*)cell;
                // 阿里云上传的图片可以使用这种方式压缩
                NSString *urlStr = [NSString stringWithFormat:@"%@&x-oss-process=image/resize,w_200", item.gifUrl];
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:urlStr]];
                
                SDImageCache* cache = [SDImageCache sharedImageCache];
                UIImage *img = [cache imageFromDiskCacheForKey:key];
                
                [item.gifImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:img options:SDWebImageLowPriority];
            } else { // cell不在屏幕中，加载封面图
                LoadingGifCollectionViewCell *item = (LoadingGifCollectionViewCell*)cell;
                [item.gifImageView stopAnimating];
                [item.gifImageView setImage:[UIImage imageNamed:@"wenzheng"]];
            }
        }
    }
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat vw = (self.view.frame.size.width - 16 * 2 - 8) / 2.;
        CGFloat vh = vw * 207. / 152.;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(vw, vh);
        layout.minimumInteritemSpacing = 8;
        layout.minimumLineSpacing = 8;
        layout.headerReferenceSize = CGSizeZero;
        layout.footerReferenceSize = CGSizeZero;
        layout.sectionInset = UIEdgeInsetsMake(12, 16, 12, 16);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithRed:248 / 255. green:248 / 255. blue:247 / 255. alpha:1];;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[LoadingGifCollectionViewCell class] forCellWithReuseIdentifier:@"LoadingGifCollectionViewCell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (NSMutableArray *)gifList {
    if (_gifList == nil) {
        _gifList = [NSMutableArray arrayWithCapacity:0];
    }
    return _gifList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"#############内存爆了，清理下sd缓存############");
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeAll completion:nil];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
