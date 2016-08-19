//
//  ViewController.m
//  UISearchBar的简单实用
//
//  Created by 天桥算命 on 16/8/18.
//  Copyright © 2016年 OrangeIce. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UISearchBar *searchBar;

@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,strong) NSMutableArray *historyArray;
@property (nonatomic,strong) NSArray *hotArray;

@property (nonatomic,assign) CGFloat lastY;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    
    searchBar.placeholder = @"热门搜索:王宝强";
    
    self.navigationItem.titleView = searchBar;
    

    self.searchBar = searchBar;
    
    [self setupTableView];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
//    [self setupTableView];
    
    [UIView animateWithDuration:1.0 animations:^{
       
        self.tableView.alpha = 1;
    }];
    
    self.searchBar.placeholder = @"你想找点什么?";
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTintColor:[UIColor blackColor]];
            [cancel addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }

    }
    
//    NSLog(@"%@",self.historyArray);
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.historyArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([searchBar.text isEqualToString:obj]) {
            return ;
        }
    }];
    
    [self.historyArray addObject:searchBar.text];
    [self.tableView reloadData];
}


//取消按钮点击方法
- (void)cancelBtnClick {
    [UIView animateWithDuration:1.0 animations:^{
        
                self.tableView.alpha = 0;
    }];
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    self.searchBar.placeholder = @"热门搜索:王宝强";
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 500) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.tableView.tableHeaderView.backgroundColor = [UIColor redColor];
    
//    self.tableView.backgroundColor = [UIColor redColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alpha = 0;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375, 28)];
    

    if (section == 0) {
        label.text = @"     历史搜索";
    }else {
        label.text = @"     热门搜索";
    }

    label.backgroundColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:12];
    return label;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *array = self.sectionArray[section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSArray *array = self.sectionArray[indexPath.section];
    cell.textLabel.text = array[indexPath.row];
//    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSArray *array = self.sectionArray[indexPath.section];
    self.searchBar.text = array[indexPath.row];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    
//    return 0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    NSLog(@"%@",NSStringFromCGPoint(point));
    
    CGFloat currentY = point.y;
    
    if (currentY > self.lastY) {
        
        [self.searchBar becomeFirstResponder];
        self.lastY = currentY;
        
        
    }else if (self.lastY > currentY){
        
         [self.searchBar endEditing:YES];
        self.lastY = currentY;
        
    }
    
}


- (NSMutableArray *)sectionArray {
    
    if (_sectionArray == nil) {
        
        _sectionArray = [NSMutableArray arrayWithObjects:self.historyArray,self.hotArray, nil];
    }
    return _sectionArray;
}
- (NSMutableArray *)historyArray {
    if (_historyArray == nil) {
        
        _historyArray = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return _historyArray;
}
- (NSArray *)hotArray {
    
    if (_hotArray == nil) {
        _hotArray = @[@"王宝强",@"王祖蓝",@"宋喆",@"马蓉",@"龚文娟"];
    }
    return _hotArray;
}
@end
