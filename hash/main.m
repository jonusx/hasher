//
//  main.m
//  hash
//
//  Created by Mathew Cruz on 8/27/13.
//  Copyright (c) 2013 Cloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <CommonCrypto/CommonDigest.h>
#import <mach/mach_time.h>

NSString *MD5(NSData *data);

static CGFloat BNRTimeBlock (void (^block)(void)) {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return -1.0;
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    return (CGFloat)nanos / NSEC_PER_SEC;
    
}


#define TIME(x) do {                            \
CGFloat time = BNRTimeBlock( ^{ (x); } );   \
printf ("done in %0.4f seconds\n", time);   \
} while (0)

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        if (argc == 1)
        {
            printf("At least one path is required.\n");
            exit(1);
        }
        
        NSLog(@"Argh %@", [NSString stringWithUTF8String:argv[1]]);
        
        for(int i = 1; i < argc; i++)
        {
            NSString * __block hash;
            CGFloat time = BNRTimeBlock(^{
                NSString *path = [NSString stringWithUTF8String:argv[i]];
                NSData *data = [NSData dataWithContentsOfFile:path];
                hash = MD5(data);
            });
            printf ("MD5 = %s - done in %0.4f seconds\n", [hash UTF8String], time);
        }

        
    }
    return 0;
}

NSString *MD5(NSData *data)
{
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(data.bytes, data.length, md5Buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", md5Buffer[i]];
    
    return output;
}

