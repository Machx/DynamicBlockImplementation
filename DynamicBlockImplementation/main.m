//
//  main.m
//  DynamicBlockImplementation
//
//  Created by Colin Wheeler on 9/16/11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface MyFoo : NSObject
@property(readonly,retain) NSString *myFooTitle;
@end

@implementation MyFoo

-(id)init {
    self = [super init];
    if (self) {
        //
    }
    return self;
}

@dynamic myFooTitle; //will be implemented in resolveInstanceMethod

+(BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(myFooTitle)) {
        IMP myFooImp = imp_implementationWithBlock(^(id _self){
            return @"MyFoozleWazzle";
        });
        
        //see http://goo.gl/teCc0 for more info on type encodings
        //dynamically add the method
        class_addMethod([self class], @selector(myFooTitle), myFooImp, "@@");
        
        return YES;
    }
    return NO;
}

@end

int main (int argc, const char * argv[])
{

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    // insert code here...
    NSLog(@"Hello, World!");
    
    MyFoo *aFoo = [[MyFoo alloc] init];
    
    //now call our method which will have to dynamically resolve
    NSLog(@"The Foo Title is %@",[aFoo myFooTitle]);

    [aFoo release];

    [pool drain];
    return 0;
}

