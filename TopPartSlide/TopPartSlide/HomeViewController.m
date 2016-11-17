//
//  HomeViewController.m
//  TopPartSlide
//
//  Created by anyongxue on 2016/11/16.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "HomeViewController.h"
#import "NewsTableViewController.h"


@interface HomeViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)NSArray *titleArr;

@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self addChildVC];
    
    [self titleScrollViewLabel];
    
    //默认选中第一个控制器
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
    
    self.contentScrollView.delegate = self;
}

//添加子控制器
- (void)addChildVC{
    
    self.titleArr = @[@"头条",@"要闻",@"社会",@"财经",@"股票",@"体育",@"房产"];
    
    for (int i = 0; i<7; i++) {
        
        NewsTableViewController *VC= [[NewsTableViewController alloc] init];
        
        VC.title = [self.titleArr objectAtIndex:i];
        
        [self addChildViewController:VC];
    }
}

- (void)titleScrollViewLabel{
    
    for (NSInteger i = 0 ; i < 7; i ++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = self.childViewControllers[i].title;
        
        CGFloat labelW = 100;
        CGFloat labelH = self.titleScrollView.bounds.size.height;
        
        label.frame = CGRectMake(i * labelW, 0, labelW, labelH);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica-Thin" size:16];
        label.userInteractionEnabled = YES;
        label.tag = i;
        
        //字体红色变大
        if (i == 0) {
            label.transform = CGAffineTransformMakeScale(1 + 0.15 ,1 + 0.15);
            label.textColor = [UIColor redColor];
        }
        
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)]];
        
        [self.titleScrollView addSubview:label];
        
        self.titleScrollView.contentSize = CGSizeMake(7 * labelW, 0);
        
        self.contentScrollView.contentSize = CGSizeMake(7 * [UIScreen mainScreen].bounds.size.width, 0);
    }
}


- (void)titleLabelClick:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag;
    
    CGPoint offset = self.contentScrollView.contentOffset;
    
    offset.x = index * self.contentScrollView.frame.size.width;
    
    [self.contentScrollView setContentOffset:offset animated:YES];
}


#pragma mark -scrollVeiwDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 向contentScrollView上添加控制器的View
    NSInteger index = offsetX / width;
    
    // 取出要显示的控制器
    UIViewController *willShowVc = self.childViewControllers[index];
    
    //设置顶部的titleScrollVeiw滚动到中间
    UILabel *label = self.titleScrollView.subviews[index];
    CGPoint titleContentOffset = CGPointMake(label.center.x - width * 0.5, 0);
    
    //设置左边的距离不会太靠右
    if (titleContentOffset.x < 0){
        
        titleContentOffset.x = 0;
    }
    
    CGFloat maxTitleContentOffsetX = self.titleScrollView.contentSize.width - width;
    
    //设置右边的距离不会太靠左
    if (titleContentOffset.x > maxTitleContentOffsetX){
    
        titleContentOffset.x = maxTitleContentOffsetX;
    }
    
    [self.titleScrollView setContentOffset:titleContentOffset animated:YES];
    
    //如果当前控制器已经显示过一次就不要再次显示出来 就直接返回;
    if ([willShowVc isViewLoaded]) {
        return;
    }
    
    willShowVc.view.frame = CGRectMake(width * index, 0, width, height);
    
    [scrollView addSubview:willShowVc.view];
}


//手动拖拽scrollView的时候才会调用这个方法,通过点击上面的方法导致的scrollView滚动快停止的时候不会调用这个方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat scal = self.contentScrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    
    NSInteger leftLabelIndex = scal;
    
    NSInteger rightLabelIndex = scal + 1;
    
    CGFloat leftScal = scal - leftLabelIndex;
    
    CGFloat rightScal = rightLabelIndex - scal;
    
    
    if (rightLabelIndex == self.titleScrollView.subviews.count) {
        
        return;
    }
    // 拿出对应的label
    UILabel *leftLabel = self.titleScrollView.subviews[leftLabelIndex];
    
    UILabel *rightLabel = self.titleScrollView.subviews[rightLabelIndex];
    
    [leftLabel setTextColor:[UIColor colorWithRed:1 - leftScal green:0 blue:0 alpha:1]];
    
    [rightLabel setTextColor:[UIColor colorWithRed:1 - rightScal green:0 blue:0 alpha:1]];
    
    leftLabel.transform = CGAffineTransformMakeScale(1 + (1 - leftScal) * 0.15,1 + (1 - leftScal)* 0.15);
    
    rightLabel.transform = CGAffineTransformMakeScale(1 + (1 - rightScal)* 0.15,1 + (1-rightScal)* 0.15);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
