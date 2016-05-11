//
//  DataBaseUtil.m
//  FMDBTest
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FMDataBaseManager.h"
#import "FMDataBaseModel.h"
#import <objc/runtime.h>
#define LVSQLITE_NAME @"modals.sqlite"

@implementation FMDataBaseManager

static FMDatabase *_fmdb;

#pragma mark 初始化数据库
+ (void)initialize {
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LVSQLITE_NAME];
    //    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSLog(@"dataBase Path:%@",filePath);
    if (_fmdb == nil)
    {
        _fmdb = [FMDatabase databaseWithPath:filePath];
    }
}

+ (void)creatTable:(NSString *)tableName{
    [self initialize];
    if([_fmdb open]){
        
        NSMutableArray *keys = [self propertyKeys:[FMDataBaseModel new]];
        NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(",tableName];
        for (int i = 0; i < keys.count ;i++) {
            if([keys[i] isEqualToString:@"db_key"]){
                [sql appendString:[NSString stringWithFormat:@"%@ TEXT PRIMARY KEY,",keys[i]]];
            }else if(i == keys.count-1){
                [sql appendString:[NSString stringWithFormat:@"%@ TEXT)",keys[i]]];
            }else{
                [sql appendString:[NSString stringWithFormat:@"%@ TEXT,",keys[i]]];
            }
            
        }
        [_fmdb executeUpdate:sql];
    }
}

+ (BOOL)insertModel:(FMDataBaseModel *)model tableName:(NSString *)tableName{
    [self initialize];
    
    BOOL result = false;
    if([_fmdb open])
    {
        NSMutableString *insertSql = [NSMutableString stringWithFormat:@"INSERT INTO %@(",tableName];
        NSMutableString *insertValue = [NSMutableString stringWithFormat:@" VALUES ("];
        NSMutableArray *keys = [self propertyKeys:model];
        for (int i = 0; i < keys.count ;i++) {
            if(i == keys.count-1){
                [insertSql appendString:[NSString stringWithFormat:@"%@)",keys[i]]];
                [insertValue appendString:[NSString stringWithFormat:@"'%@');",[model valueForKey:keys[i]]]];
            }else{
                [insertSql appendString:[NSString stringWithFormat:@"%@,",keys[i]]];
                [insertValue appendString:[NSString stringWithFormat:@"'%@',",[model valueForKey:keys[i]]]];
            }
        }
        [insertSql appendString:insertValue];
        result = [_fmdb executeUpdate:insertSql];
        [_fmdb close];
    }
    return result;
}

+ (FMDataBaseModel *)queryData:(NSString *)tableName selection:(NSString *)selection {
    [self initialize];
    
    if([_fmdb open]){
        
        NSString  *querySql = nil;
        if (selection == nil ) {
            querySql = [@"SELECT * FROM " stringByAppendingString:tableName];
        }else{
            querySql = [@"SELECT * FROM " stringByAppendingString:[NSString stringWithFormat:@"%@ where %@",tableName,selection]];
        }
        
        FMResultSet *set = [_fmdb executeQuery:querySql];
        FMDataBaseModel *model = [FMDataBaseModel new];
        NSMutableArray *keys = [self propertyKeys:model];
        
        while ([set next]) {
            
            for(NSString *key in keys)
            {
                [model setValue:[set stringForColumn:key] forKey:key];
            }
            
        }
        [_fmdb close];
        return model;
    }
    else{
        return nil;
    }
}

+ (BOOL)deleteData:(NSString *)tableName selection:(NSString *)selection {
    [self initialize];
    BOOL result = false;
    if([_fmdb open])
    {
        NSString *deleteSql = nil;
        if (selection == nil ) {
            deleteSql = [@"DELETE  FROM " stringByAppendingString:tableName];
        }else{
            deleteSql = [@"DELETE  FROM " stringByAppendingString:[NSString stringWithFormat:@"%@ where %@",tableName,selection]];
        }
        result = [_fmdb executeUpdate:deleteSql];
        [_fmdb close];
    }
    return result;
    
}

+ (BOOL)modifyData:(FMDataBaseModel *)model tableName:(NSString *)tableName selection:(NSString *)selection {
    [self initialize];
    BOOL result = false;
    if([_fmdb open])
    {
        NSMutableString *modifySql = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",tableName];
        
        NSMutableArray *keys = [self propertyKeys:model];
        for (int i = 0; i < keys.count ;i++) {
            if(i == keys.count-1){
                [modifySql appendString:[NSString stringWithFormat:@"%@ = '%@' ",keys[i], [model valueForKey:keys[i]]]];
            }
            else{
                [modifySql appendString:[NSString stringWithFormat:@"%@ = '%@',",keys[i], [model valueForKey:keys[i]]]];
            }
            
        }
        if(selection != nil){
            
            [modifySql stringByAppendingString:[NSString stringWithFormat:@" WHERE %@",selection]];
        }
        result  = [_fmdb executeUpdate:modifySql];
        [_fmdb close];
    }
    
    
    return result;
}



/**********************************************************/


+(NSMutableArray *)propertyKeys:(FMDataBaseModel *)model{
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:5];
    unsigned int count ;
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    for(int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *key = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:key];
    }
    return keys;
    
}
@end
