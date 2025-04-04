#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>

@interface RCT_EXTERN_MODULE(TvosKeyboardViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(onTextChange, RCTBubblingEventBlock)
RCT_EXTERN_METHOD(focusSearchBar:(nonnull NSNumber *)reactTag)

@end
