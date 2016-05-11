//
//  ViewController.m
//  FMDBTest
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "FMDataBaseManager.h"
#import "FMDataBaseModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FMDataBaseManager creatTable:@"dbmodel"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20,44, 44)];
    [btn setTitle:@"增" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self  action:@selector(testSave) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(44*1, 20,44, 44)];
    [btn1 setTitle:@"删" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self  action:@selector(testDelete) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(44*2, 20,44, 44)];
    [btn2 setTitle:@"查" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 addTarget:self  action:@selector(testQuery) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(44*3, 20,44, 44)];
    [btn3 setTitle:@"改" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 addTarget:self  action:@selector(testUpdate) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
}

-(void)testSave
{
    FMDataBaseModel *model = [[FMDataBaseModel alloc] init];
    model.db_key = @"1";
    model.db_value = @"上海迪斯尼乐园";
    model.db_assist1 = @"备用字段1";
    model.db_assist2 = @"备用字2";
    [FMDataBaseManager insertModel:model tableName:@"dbmodel"];
    
}

-(void)testUpdate{

    FMDataBaseModel *model = [[FMDataBaseModel alloc] init];
    model.db_key = @"1";
    model.db_value = @"上海迪斯尼乐园 开园啦！";
    model.db_assist1 = @"备用字段1 修改后";
    model.db_assist2 = @"备用字2 修改后";
    if([FMDataBaseManager modifyData:model tableName:@"dbmodel" selection:@"db_key == 1"])
    {
        NSLog(@"更新成功");
    }else{
        NSLog(@"更新失败");
    }
}

-(void)testQuery{
    
    FMDataBaseModel *mode = [FMDataBaseManager queryData:@"dbmodel" selection:nil];
    NSLog(@"%@,%@,%@,%@",mode.db_key,mode.db_value,mode.db_assist1,mode.db_assist2);
}
-(void)testDelete{

    if([FMDataBaseManager deleteData:@"dbmodel" selection:nil])
    {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
