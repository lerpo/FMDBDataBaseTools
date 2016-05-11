//
//  DataBaseModel.h
//  FMDBTest
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDataBaseModel : NSObject

@property(nonatomic,copy) NSString *db_key;     //id值
@property(nonatomic,copy) NSString *db_value;   //存储内容
@property(nonatomic,copy) NSString *db_assist1; //预留辅助字段
@property(nonatomic,copy) NSString *db_assist2; //预留辅助字段
@end
