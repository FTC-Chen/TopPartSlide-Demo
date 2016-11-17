//
//  NewsTableViewController.m
//  TopPartSlide
//
//  Created by anyongxue on 2016/11/16.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "NewsTableViewController.h"

@interface NewsTableViewController ()

@end

static NSString *ID = @"socialCell";

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@栏目 --- %zd ",self.title,indexPath.row];
    
    return cell;
}

@end
