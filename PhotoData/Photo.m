//
//  Photo.m
//  objc.io example project (edition #1)
//

#import "Photo.h"
#import "User.h"


static NSString * const IdentifierKey = @"identifier";
static NSString * const NameKey = @"name";
static NSString * const CreationDateKey = @"creationDate";
static NSString * const RatingKey = @"rating";
static NSString * const UserKey = @"user";


@implementation Photo

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@: %p> (%lld) \"%@\"",
            [self class], self, (long long) self.identifier, self.name];
}
//归档(NSCoding协议）
- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeInt64:self.identifier forKey:IdentifierKey];
    [coder encodeObject:self.name forKey:NameKey];
    [coder encodeObject:self.creationDate forKey:CreationDateKey];
    [coder encodeDouble:self.rating forKey:RatingKey];
    [coder encodeConditionalObject:self.user forKey:UserKey];  //User拥有photos，photo对象不会主动encode user对象, 如果存在user对象 ,那么就指向它,否则就指向空。(条件encode）
}

- (BOOL)requiresSecureCoding
{
    return YES;
}
//(NSSecureCoding协议）---上面返回Yes 就必须实现安全编码协议
+ (BOOL)supportsSecureCoding
{
    return YES;
}

//解档---初始化(NSCoding协议）
- (id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    if (self) {
        self.identifier = [coder decodeInt64ForKey:IdentifierKey];
        self.name = [coder decodeObjectOfClass:[NSString class] forKey:NameKey];
        self.creationDate = [coder decodeObjectOfClass:[NSDate class] forKey:CreationDateKey];
        self.rating = [coder decodeDoubleForKey:RatingKey];
        self.user = [coder decodeObjectOfClass:[User class] forKey:UserKey];
    }
    return self;
}


- (NSString*)authorFullName
{
    return self.user.fullName;
}

- (double)adjustedRating
{
    double adjustedRating = (self.rating - 97) / 3.0;
    if (adjustedRating < 0) {
        adjustedRating = 0;
    }
    return adjustedRating;
}

@end
