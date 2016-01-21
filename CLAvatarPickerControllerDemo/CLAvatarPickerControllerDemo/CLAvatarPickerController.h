#import <UIKit/UIKit.h>

@interface CLAvatarPickerController : UIViewController
@property(nonatomic,strong)UIImage * inputImage;
@property(nonatomic,copy)void(^callback)(UIImage * outputImage);
+ (void)showUpInPresentController:(UIViewController *)controller fromInputImage:(UIImage *)inputImage  ToOutputImage:(void (^)(UIImage * outputImage))callback;
@end
