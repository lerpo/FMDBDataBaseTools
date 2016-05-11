//
//  DataBaseUtil.h
//  FMDBTest
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
@class FMDataBaseModel;
@interface FMDataBaseManager : NSObject


+ (void)creatTable:(NSString *)tableName;

// 插入模型数据
+ (BOOL)insertModel:(FMDataBaseModel *)model tableName:(NSString *)tableName;

/** 查询数据,如果 传空 默认会查询表中所有数据 */
+ (FMDataBaseModel *)queryData:(NSString *)tableName selection:(NSString *)selection;

/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(NSString *)tableName selection:(NSString *)selection;

/** 修改数据 */
+ (BOOL)modifyData:(FMDataBaseModel *)model tableName:(NSString *)tableName selection:(NSString *)selection;
@end
