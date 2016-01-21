# CLAvatarPickerController
a wechat style avatar picker controller.

![image](https://raw.githubusercontent.com/iOS-mamu/CLAvatarPickerController/master/Clips/clip_0.png)

How to use:

1.you need to download Masonry to autolayout. Or you can modify the source .m file with frame(CGRect) to layout.However I still recommend Masonry.

2.drag the CLAvatarControlelr source code folder to your project.

3.just one line code
+ (void)showUpInPresentController:(UIViewController *)controller fromInputImage:(UIImage *)inputImage  ToOutputImage:(void (^)(UIImage * outputImage))callback;

controller is the controller you want to present from.
inputImage is the image you want to clip
callback is where you get the outputImage

4.check the demo to test


feel free to modify as you wish.
