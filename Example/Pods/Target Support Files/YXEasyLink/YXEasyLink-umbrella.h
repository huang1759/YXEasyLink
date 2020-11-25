#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "EasyLink.h"
#import "ELAsyncSocket.h"
#import "ELAsyncUdpSocket.h"
#import "ELReachability.h"
#import "route.h"

FOUNDATION_EXPORT double YXEasyLinkVersionNumber;
FOUNDATION_EXPORT const unsigned char YXEasyLinkVersionString[];

