//
//  Store.m
//  objc.io example project (edition #1)
//

#import "Store.h"
#import "Photo.h"


@implementation Store

+ (instancetype)store
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self readArchive];
    }
    return self;
}

- (void)readArchive
{
    //读文件
    NSURL *archiveURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"photodata" withExtension:@"bin"];
    NSAssert(archiveURL != nil, @"Unable to find archive in bundle."); //断言  前面条件不成立(即 URL == nil) 则输出提示
    //转为NSData
    NSData *data = [NSData dataWithContentsOfURL:archiveURL options:0 error:NULL];
    //解档
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    _users = [unarchiver decodeObjectOfClass:[NSArray class] forKey:@"users"];
    _photos = [unarchiver decodeObjectOfClass:[NSArray class] forKey:@"photos"];
    [unarchiver finishDecoding];
}

- (NSArray *)sortedPhotos
{
    //数组排序-- 按创建时间 
    return [self.photos sortedArrayUsingComparator:^NSComparisonResult(Photo *photo1, Photo *photo2) {
        return [photo2.creationDate compare:photo1.creationDate];
    }];
}

@end
