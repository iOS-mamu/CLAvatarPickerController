#import "CLAvatarPickerController.h"
#import "Masonry.h"


//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//屏幕缩放比系数
#define FACTOR_WIDTH ([UIScreen mainScreen].bounds.size.width)/375.0f
#define FACTOR_HEIGHT ([UIScreen mainScreen].bounds.size.height)/667.0f

@interface CLAvatarPickerController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic,strong)UIView * upMaskView;
@property(nonatomic,strong)UIView * downMaskView;
@property(nonatomic,strong)UIView * menuView;
@property(nonatomic,strong)UIButton * cancelBtn;
@property(nonatomic,strong)UIButton * confirmBtn;
@property(nonatomic,strong)UIImage * outputImage;
@property(nonatomic,strong)UIView * clippedZoneView;

@end
@implementation CLAvatarPickerController

#pragma mark - 视图生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
    [self setupUI];
}
#pragma mark - 懒加载

-(UIScrollView *)scrollView
{
    if(_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]init];
    }
    return _scrollView;
    
}

-(UIImageView *)imageView
{
    if(_imageView == nil)
    {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

- (UIView *)upMaskView
{
    if(_upMaskView == nil)
    {
        _upMaskView = [[UIImageView alloc]init];
    }
    return _upMaskView;
}

- (UIView *)downMaskView
{
    if(_downMaskView == nil)
    {
        _downMaskView = [[UIImageView alloc]init];
    }
    return _downMaskView;
}

- (UIView *)menuView
{
    if(_menuView == nil)
    {
        _menuView = [[UIView alloc]init];
    }
    return _menuView;
}

- (UIButton *)cancelBtn
{
    if(_cancelBtn == nil)
    {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn
{
    if(_confirmBtn == nil)
    {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _confirmBtn;
}

- (UIImage *)outputImage
{
    _outputImage = [self screenView:self.clippedZoneView inView:self.clippedZoneView];
    return _outputImage;
}

- (UIView *)clippedZoneView
{
    if(_clippedZoneView == nil)
    {
        _clippedZoneView = [[UIView alloc]init];
    }
    return _clippedZoneView;
}



#pragma mark - UI
- (void)prepareView
{
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)setupUI

{   [self.view addSubview:self.clippedZoneView];
    [self.clippedZoneView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];

    [self.view addSubview:self.upMaskView];
    [self.view addSubview:self.downMaskView];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.confirmBtn];
    
    self.scrollView.decelerationRate = 0.1f;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.clippedZoneView.mas_centerX);
        make.centerY.equalTo(self.clippedZoneView.mas_centerY);
        make.width.equalTo(@SCREEN_WIDTH);
        make.height.equalTo(@SCREEN_HEIGHT);
        
    }];
    
    self.scrollView.contentSize = self.inputImage.size;
    //设置代理scrollview的代理对象
    self.scrollView.delegate=self;
    //设置最大伸缩比例
    self.scrollView.maximumZoomScale=2.0;
    //设置最小伸缩比例
    self.scrollView.minimumZoomScale=0.5;


    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.inputImage;
    self.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    
    self.upMaskView.backgroundColor = [UIColor blackColor];
    self.upMaskView.alpha = 0.6;
    
    self.upMaskView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.upMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(136*FACTOR_HEIGHT));
        
    }];
    
    
    self.downMaskView.backgroundColor = [UIColor blackColor];
    self.downMaskView.alpha = 0.6;
    
    self.downMaskView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.downMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(156*FACTOR_HEIGHT));
        
    }];
    
    
    self.menuView.backgroundColor = [UIColor blackColor];
    self.menuView.alpha = 0.6;
    self.menuView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(72.5*FACTOR_HEIGHT));
        
    }];
    
    
    [self.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitle:@"cancel" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menuView.mas_left).with.offset(10);
        make.centerY.equalTo(self.menuView.mas_centerY);
    }];
    
    
    [self.confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn setTitle:@"confirm" forState:UIControlStateNormal];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.menuView.mas_right).with.offset(-10);
        make.centerY.equalTo(self.menuView.mas_centerY);
    }];
    
    self.clippedZoneView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.clippedZoneView.layer.borderWidth = 1;
//    self.clippedZoneView.userInteractionEnabled = NO;
    self.clippedZoneView.backgroundColor = [UIColor clearColor];
    self.clippedZoneView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.clippedZoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.upMaskView.mas_bottom);
        make.bottom.equalTo(self.downMaskView.mas_top);
    }];
    
}

#pragma mark - 点击事件
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)confirm
{
    
    self.callback(self.outputImage);
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 启动方法
+ (void)showUpInPresentController:(UIViewController *)controller fromInputImage:(UIImage *)inputImage ToOutputImage:(void (^)(UIImage * outputImage))callback
{
    CLAvatarPickerController * iconController = [[CLAvatarPickerController alloc]init];
    iconController.inputImage = inputImage;
    iconController.callback = callback;
    [controller presentViewController:iconController animated:YES completion:^{
        
    }];
}

#pragma mark - UIScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


//图片缩放后居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

//截屏方法
- (UIImage*)screenView:(UIView *)view inView:(UIView *)zoneView
{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(zoneView.bounds.size.width, zoneView.bounds.size.height), YES, 0);     //设置截屏大小
    
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return outputImage;
}
@end
