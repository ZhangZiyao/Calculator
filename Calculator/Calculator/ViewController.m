//
//  ViewController.m
//  Calculator
//
//  Created by dingxin on 2017/8/2.
//  Copyright © 2017年 dingxin. All rights reserved.
//

#import "ViewController.h"
#import "FSCustomButton.h"
#import "Masonry.h"

#define UIColorFromRGB16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGB10(R,G,B,A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(A)]
#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)

#define kDesignWidth    750.0
#define kDesignHeight   1334.0

@interface ViewController ()
{
    NSString *result;
    NSString *inputA;
    BOOL isOperate;
    BOOL havePoint;
    NSArray *numbers;
    NSMutableArray *memories;
}

@property (nonatomic, strong) UILabel *progressLabel0;
@property (nonatomic, strong) UILabel *progressLabel1;
@property (nonatomic, strong) UILabel *progressLabel2;
@property (nonatomic, strong) UILabel *progressLabel3;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) UILabel *resultLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _selectedIndex = 0;
    numbers = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@".", nil];
    inputA = @"0";
    result = @"0";
    memories = [NSMutableArray array];
    isOperate = NO;
    havePoint = false;
    
    [self layoutSubviews];
}
- (void)clearAll{
    _resultLabel.text = @"0";
    _progressLabel0.text = @"";
    _progressLabel1.text = @"";
    _progressLabel2.text = @"";
    _progressLabel3.text = @"";
    memories = [NSMutableArray array];
    result = @"0";
    isOperate = NO;
    havePoint = false;
}

- (void)inputNum:(NSString *)str{
    if (memories.count > 0) {
        if ([memories[0] length] > 8) {
            return;
        }
    }
    if (isOperate) {
        result = @"";
        _resultLabel.text=@"";
        [memories removeAllObjects];
        [self updateMemories];
        isOperate = NO;
    }
    if (![result isEqualToString:@""]) {
        result=@"";
    }
    //归零后 继续输入数字，取消最前的0的显示
    if (![str isEqualToString:@"."]) {
        if ([_resultLabel.text isEqual:@"0"]) {
            _resultLabel.text=@"";
        }
    }
    if (havePoint && [str isEqual: @"."]) {
        return;
    }
    if([str isEqual:@"."]){
        havePoint = true;
    }
    inputA = [_resultLabel.text stringByAppendingString:str];
    _resultLabel.text = inputA;
    if (memories.count > 0) {
        if ([str isEqualToString:@"0"]) {
            if ([memories[0] isEqualToString:@"0"]) {
                str = @"";
            }
        }
    }
    
    //控制输入数字时“.”的出现次数为1次。检测到点的个数超过一个时，删除掉最后一个
    NSArray * array=[inputA componentsSeparatedByString:@"."];
    NSInteger count=[array count]-1;
    if (count>1) {
        NSMutableString *c = [NSMutableString stringWithString:_resultLabel.text];
        [c deleteCharactersInRange:NSMakeRange((c.length-1), 1)];
        _resultLabel.text=c;
    }
    if (memories.count > 0) {
        NSMutableString *str0 = [NSMutableString stringWithString:memories[0]];
        if (![@[@"+",@"-",@"x"] containsObject:str0]) {
            
            if ([str0 isEqualToString:@"0"] && ![str isEqualToString:@"."]) {
                [str0 replaceCharactersInRange:NSMakeRange(0, 1) withString:str];
            }else{
                [str0 appendString:str];
            }
            
            [memories replaceObjectAtIndex:0 withObject:str0];
            
        }else{
            if ([str isEqualToString:@"."]) {
                [memories insertObject:@"0." atIndex:0];
            }else{
                
                [memories insertObject:str atIndex:0];
            }
        }
    }else{
        if ([str isEqualToString:@"."]) {
            [memories insertObject:@"0." atIndex:0];
        }else{
            [memories insertObject:str atIndex:0];
        }
    }
    [self updateMemories];
}
- (void)updateMemories{
    NSLog(@"memories %@ ",memories);
    if (memories.count == 0) {
        _progressLabel0.text = @"";
        _progressLabel1.text = @"";
        _progressLabel2.text = @"";
        _progressLabel3.text = @"";
        return;
    }
    BOOL flag = NO;
    for (NSString *str in memories) {
        if ([@[@"+",@"-",@"x"] containsObject:str]) {
            flag = YES;
        }
    }
    if (!isOperate) {
        if (flag) {
            result = 0;
            _resultLabel.text = @"0";
        }
    }
    if (memories.count == 1) {
        result = memories[0];
    }else{
        result = 0;
    }
    if (memories.count %2 == 1) {
        _progressLabel0.text = memories[0];
        if (memories.count < 2) {
            _progressLabel1.text = @"";
            _progressLabel2.text = @"";
            _progressLabel3.text = @"";
            return;
        }
        _progressLabel0.text = [NSString stringWithFormat:@"%@%@",memories[1],memories[0]];
        if (memories.count < 3) {
            _progressLabel1.text = @"";
            _progressLabel2.text = @"";
            _progressLabel3.text = @"";
            return;
        }
        _progressLabel1.text = memories[2];
        if (memories.count < 4) {
            _progressLabel2.text = @"";
            _progressLabel3.text = @"";
            return;
        }
        _progressLabel1.text = [NSString stringWithFormat:@"%@%@",memories[3],memories[2]];
        if (memories.count < 5) {
            _progressLabel2.text = @"";
            _progressLabel3.text = @"";
            return;
        }
        _progressLabel2.text = memories[4];
        if (memories.count < 6) {
            _progressLabel3.text = @"";
            return;
        }
        _progressLabel2.text = [NSString stringWithFormat:@"%@%@",memories[5],memories[4]];
        if (memories.count < 7) {
            _progressLabel3.text = @"";
            return;
        }
        _progressLabel3.text = memories[6];
        if (memories.count < 8) {
            return;
        }
        _progressLabel3.text = [NSString stringWithFormat:@"%@%@",memories[7],memories[6]];
    }else{
        _progressLabel0.text = memories[0];
        if (memories.count < 2) {
            _progressLabel1.text = @"";
            _progressLabel2.text = @"";
            _progressLabel3.text = @"";
            return;
        }
        _progressLabel1.text = memories[1];
        if (memories.count < 3) {
            _progressLabel2.text = @"";
            _progressLabel3.text = @"";
            return;
        }
        _progressLabel1.text = [NSString stringWithFormat:@"%@%@",memories[2],memories[1]];
        if (memories.count < 4) {
            _progressLabel2.text = @"";
            _progressLabel3.text = @"";
            return;
        }
        _progressLabel2.text = memories[3];
        if (memories.count < 5) {
            _progressLabel3.text = @"";
            return;
        }
        _progressLabel2.text = [NSString stringWithFormat:@"%@%@",memories[4],memories[3]];
        if (memories.count < 6) {
            _progressLabel3.text = @"";
            return;
        }
        _progressLabel3.text = memories[5];
        if (memories.count < 7) {
            return;
        }
        _progressLabel3.text = [NSString stringWithFormat:@"%@%@",memories[6],memories[5]];
        
    }
    
}
- (void)funcAction:(FSCustomButton *)sender{
    switch (sender.tag) {
        case 20086:
        case 20086+1:
        case 20086+2:
        {
            if (isOperate) {
                isOperate = NO;
            }
            havePoint = NO;
            if (memories.count == 0) {
                [memories addObject:@"0"];
            }
            NSMutableString *str0 = [NSMutableString stringWithString:memories[0]];
            if ([str0 isEqualToString:@"+"] || [str0 isEqualToString:@"-"] || [str0 isEqualToString:@"x"]) {
                return;
            }
            if ([_resultLabel.text isEqualToString:@""]) {
                _resultLabel.text=@"0";
            }
            
            result = 0;
            _resultLabel.text=@"0";
            [memories insertObject:sender.title atIndex:0];
            [self updateMemories];

        }
            break;
        case 20086+3:
        {
            if (isOperate) {
                isOperate = NO;
                result = 0;
                _resultLabel.text = @"0";
                [memories removeAllObjects];
                [self updateMemories];
            }
            //退格
            if (memories.count == 0) {
                return;
            }
            
            NSMutableString *c = [NSMutableString stringWithString:memories[0]];
            NSString *str = [c substringWithRange:NSMakeRange(c.length-1, 1)];
            [c deleteCharactersInRange:NSMakeRange(c.length-1, 1)];
            if ([str isEqualToString:@"."]) {
                havePoint = NO;
            }
            
            if (c.length==0) {
                
                [memories removeObjectAtIndex:0];
                if (memories.count == 0) {
                    result = 0;
                    _resultLabel.text = @"0";
                }
            }else{
                if (memories.count == 1) {
                    result = c;
                    _resultLabel.text = c;
                }
                [memories replaceObjectAtIndex:0 withObject:c];
            }
            
            
            [self updateMemories];
        }
            break;
        case 40086:
        {
            //===========
            havePoint = NO;
            if (memories.count == 0) {
                result = 0;
                return;
            }
            
            NSMutableString *formulaString = [NSMutableString string];
            for (int i = 0; i < memories.count; i ++) {
                [formulaString insertString:memories[i] atIndex:0];
            }
            NSLog(@"表达式：%@",formulaString);
            result = [self calcComplexFormulaString:formulaString];
            _resultLabel.text = result;
            
            [memories removeAllObjects];
            [memories addObject:result];
            [self updateMemories];
            isOperate = YES;
            
        }
            break;
            
        default:
            break;
    }
    
}
- (void)payAction:(UIButton *)sender{
    switch (sender.tag) {
        case 40086+2:
        {
            //跳转页面
//            if (!([result doubleValue] > 0)) {
//                NSLog(@"请输入金额");
//                return;
//            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"跳转页面 带结果" message:result preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
            NSLog(@"%@",result);
            
        }
            break;
        case 40086+1:
        {
            //结果
//            if (!([result doubleValue] > 0)) {
//                NSLog(@"请输入金额");
//                return;
//            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前结果" message:result preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
            NSLog(@"%@",result);
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - calculate
- (void)tapNumAction:(FSCustomButton *)sender{
    //    NSLog(@"%ld----%@",sender.tag,sender.titleLabel.text);
    
    switch (sender.tag-30086) {
        case 2:
        {
            //C
            [self clearAll];
        }
            break;
        case 0:
            //.
        case 1:
            //0
        case 3:
            //3
        case 4:
            //2
        case 5:
            //1
        case 6:
            //6
        case 7:
            //5
        case 8:
            //4
        case 9:
            //9
        case 10:
            //8
        case 11:
            //7
            [self inputNum:sender.title];
            break;
            
        default:
            break;
    }
}
//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - 计算
- (NSString *)jiafa:(NSString *)inputa b:(NSString *)inputb{
    NSLog(@"is pure %d",[self isPureInt:inputa]);
    if ([self isPureInt:inputa] && [self isPureInt:inputb]) {
        return [NSString stringWithFormat:@"%d",[inputa intValue]+[inputb intValue]];
    }else{
        return [NSString stringWithFormat:@"%.2f",[inputa floatValue]+[inputb floatValue]];
    }
}
- (NSString *)jianfa:(NSString *)inputa b:(NSString *)inputb{
    NSLog(@"is pure %d",[self isPureInt:inputa]);
    if ([self isPureInt:inputa] && [self isPureInt:inputb]) {
        return [NSString stringWithFormat:@"%d",[inputa intValue]-[inputb intValue]];
    }else{
        return [NSString stringWithFormat:@"%.2f",[inputa floatValue]-[inputb floatValue]];
    }
}
- (NSString *)chengfa:(NSString *)inputa b:(NSString *)inputb{
    NSLog(@"is pure %d",[self isPureInt:inputa]);
    if ([self isPureInt:inputa] && [self isPureInt:inputb]) {
        return [NSString stringWithFormat:@"%d",[inputa intValue]*[inputb intValue]];
    }else{
        return [NSString stringWithFormat:@"%.2f",[inputa floatValue]*[inputb floatValue]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)navLeftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - subviews
- (void)layoutSubviews{
    float buttonWidth = 180/kDesignWidth*ScreenWidth;
    float padding     = (ScreenWidth-3*buttonWidth-188/kDesignWidth*ScreenWidth)/3;
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = UIColorFromRGB16(0xdddddd);
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.view).offset(-(620+158)/kDesignHeight*ScreenHeight-padding*2);
    }];
    
    
    NSArray *array = @[@"jia",@"jian",@"cheng",@"tg"];
    NSArray *ftitleArray = @[@"+",@"-",@"x",@"<-"];
    for (int i = 0; i < array.count; i++) {
        FSCustomButton *button = [[FSCustomButton alloc] init];
        [button setBackgroundColor:UIColorFromRGB16(0xf8f8f8)];
        [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button.tag = i+20086;
        [button addTarget:self action:@selector(funcAction:) forControlEvents:UIControlEventTouchDown];
        button.title = ftitleArray[i];
        if (i == array.count-1) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(-(620/kDesignHeight*ScreenHeight+padding*2));
                make.width.mas_equalTo(188/kDesignWidth*ScreenWidth);
                make.height.mas_equalTo(158/kDesignHeight*ScreenHeight);
            }];
        }else{
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).offset((buttonWidth+padding)*i);
                make.bottom.equalTo(self.view).offset(-(620/kDesignHeight*ScreenHeight+padding*2));
                make.width.mas_equalTo(buttonWidth);
                make.height.mas_equalTo(158/kDesignHeight*ScreenHeight);
            }];
        }
        
    }
    
    float numButtonHeight = (310/kDesignHeight*ScreenHeight+padding)*2/4;
    float numButtonWidth = (kDesignWidth-188)/3/kDesignWidth*ScreenWidth;
    NSArray *numArray = @[@"·",@"0",@"C",@"3",@"2",@"1",@"6",@"5",@"4",@"9",@"8",@"7"];
    NSArray *numTitleArray = @[@".",@"0",@"C",@"3",@"2",@"1",@"6",@"5",@"4",@"9",@"8",@"7"];
    for (int i = 0; i < numArray.count; i++) {
        FSCustomButton *button = [[FSCustomButton alloc] init];
        button.adjustsTitleTintColorAutomatically = YES;
        [button setTintColor:UIColorFromRGB16(0x666666)];
        UIFont *font = [UIFont systemFontOfSize:40];
        button.titleLabel.font = font;
        [button setTitle:numArray[i] forState:UIControlStateNormal];
        button.layer.cornerRadius = 4;
        button.buttonImagePosition = FSCustomButtonImagePositionTop;
        button.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        [self.view addSubview:button];
        button.tag = i+30086;
        button.title = numTitleArray[i];
        [button addTarget:self action:@selector(tapNumAction:) forControlEvents:UIControlEventTouchDown];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-numButtonWidth*(i%3)-188/kDesignWidth*ScreenWidth);
            make.bottom.equalTo(self.view).offset(-numButtonHeight*(i/3));
            make.width.mas_equalTo(numButtonWidth);
            make.height.mas_equalTo(numButtonHeight);
        }];
    }
    
    NSArray *ffArray = @[@"deng",@"fszf",@"zszf"];
    NSArray *fftitleArray = @[@"=",@"结果",@"跳转"];
    float sumHeight = 0;//157,229,229
    float padding6 = 6/kDesignHeight*ScreenHeight;
    for (int i = 0; i < ffArray.count; i++) {
        FSCustomButton *button = [[FSCustomButton alloc] init];
        [button setBackgroundColor:UIColorFromRGB16(0xf8f8f8)];
        
        [self.view addSubview:button];
        button.tag = i+40086;
        button.title = fftitleArray[i];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:ffArray[i]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(funcAction:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [button setTitleColor:UIColorFromRGB16(0x1ab395) forState:UIControlStateNormal];
            [button setTitle:fftitleArray[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-sumHeight);
            make.width.mas_equalTo(188/kDesignWidth*ScreenWidth);
            if (i == 0) {
                make.height.mas_equalTo(157/kDesignHeight*ScreenHeight);
            }else{
                make.height.mas_equalTo(229/kDesignHeight*ScreenHeight);
            }
        }];
        if (i == 0) {
            sumHeight += padding6+157/kDesignHeight*ScreenHeight;
        }else if (i == 1){
            sumHeight += padding6+229/kDesignHeight*ScreenHeight;
        }else{
            sumHeight += padding6+229/kDesignHeight*ScreenHeight;
        }
    }
    
    _resultLabel = [[UILabel alloc] init];
    _resultLabel.text = result;
    _resultLabel.textColor = [UIColor blackColor];
    _resultLabel.font = [UIFont systemFontOfSize:45];
    _resultLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_resultLabel];
    [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-40/kDesignWidth*ScreenWidth);
        make.bottom.equalTo(line).offset(-70/kDesignHeight*ScreenHeight);
        make.height.mas_equalTo(75/kDesignHeight*ScreenHeight);
    }];
    
    for (int i = 0; i < 4; i ++) {
        UILabel *progressLabel = [[UILabel alloc] init];
        progressLabel.textColor = UIColorFromRGB16(0x999999);
        progressLabel.font = [UIFont systemFontOfSize:20];
        progressLabel.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:progressLabel];
        [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-40/kDesignWidth*ScreenWidth);
            make.bottom.equalTo(_resultLabel.mas_top).offset(-(50/kDesignHeight*ScreenHeight+50/kDesignHeight*ScreenHeight*i));
            make.height.mas_equalTo(35/kDesignHeight*ScreenHeight);
        }];
        switch (i) {
            case 0:
            {
                _progressLabel0 = progressLabel;
            }
                break;
            case 1:
            {
                _progressLabel1 = progressLabel;
            }
                break;
            case 2:
            {
                _progressLabel2 = progressLabel;
            }
                break;
            case 3:
            {
                _progressLabel3 = progressLabel;
            }
                break;
                
            default:
                break;
        }
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB10(255, 255, 255, 1.0).CGColor,(__bridge id)UIColorFromRGB10(255, 255, 255, 0.5).CGColor,(__bridge id)UIColorFromRGB10(255, 255, 255, 0).CGColor];
    gradientLayer.locations = @[@0, @0.5,@1];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, ScreenWidth, 300/kDesignHeight*ScreenHeight);
    [self.view.layer addSublayer:gradientLayer];
    
}

- (NSString *)calcSimpleFormula:(NSString *)formula {
    
    NSString *resultnum = @"0";
    char symbol = '+';
    
    int len = (int)formula.length;
    int numStartPoint = 0;
    for (int i = 0; i < len; i++) {
        char c = [formula characterAtIndex:i];
        if (c == '+' || c == '-') {
            NSString *num = [formula substringWithRange:NSMakeRange(numStartPoint, i - numStartPoint)];
            switch (symbol) {
                case '+':
                    resultnum = [self jiafa:resultnum b:num];
                    break;
                case '-':
                    resultnum = [self jianfa:resultnum b:num];
                    break;
                default:
                    break;
            }
            symbol = c;
            numStartPoint = i + 1;
        }
    }
    if (numStartPoint < len) {
        NSString *num = [formula substringWithRange:NSMakeRange(numStartPoint, len - numStartPoint)];
        switch (symbol) {
            case '+':
                resultnum = [self jiafa:resultnum b:num];
                break;
            case '-':
                resultnum = [self jianfa:resultnum b:num];
                break;
            default:
                break;
        }
    }
    return resultnum;
}
// 获取字符串中的后置数字
- (NSString *)lastNumberWithString:(NSString *)str {
    int numStartPoint = 0;
    for (int i = (int)str.length - 1; i >= 0; i--) {
        char c = [str characterAtIndex:i];
        if ((c < '0' || c > '9') && c != '.') {
            numStartPoint = i + 1;
            break;
        }
    }
    return [str substringFromIndex:numStartPoint];
}

// 获取字符串中的前置数字
- (NSString *)firstNumberWithString:(NSString *)str {
    int numEndPoint = (int)str.length;
    for (int i = 0; i < str.length; i++) {
        char c = [str characterAtIndex:i];
        if ((c < '0' || c > '9') && c != '.') {
            numEndPoint = i;
            break;
        }
    }
    return [str substringToIndex:numEndPoint];
}
// 包含 * / 的计算
- (NSString *)calcNormalFormula:(NSString *)formula {
    NSRange mulRange = [formula rangeOfString:@"x" options:NSLiteralSearch];
    // 只包含加减的运算
    if (mulRange.length == 0) {
        return [self calcSimpleFormula:formula];
    }
    // 进行乘除运算
    int index = (int)mulRange.location ;
    // 计算左边表达式
    NSString *left = [formula substringWithRange:NSMakeRange(0, index)];
    NSString *num1 = [self lastNumberWithString:left];
    left = [left substringWithRange:NSMakeRange(0, left.length - num1.length)];
    // 计算右边表达式
    NSString *right = [formula substringFromIndex:index + 1];
    NSString *num2 = [self firstNumberWithString:right];
    right = [right substringFromIndex:num2.length];
    // 计算一次乘除结果
    NSString *tempResult = @"0";
    if (index == mulRange.location) {
        tempResult = [self chengfa:num1 b:num2];
    }
    // 代入计算得到新的公式
    NSString *newFormula = [NSString stringWithFormat:@"%@%@%@", left, tempResult, right];
    return [self calcNormalFormula:newFormula];
}
- (NSString *)calcComplexFormulaString:(NSString *)formula {
    // 左括号
    NSRange lRange = [formula rangeOfString:@"(" options:NSBackwardsSearch];
    // 没有括号进行二步运算(含有乘除加减)
    if (lRange.length == 0) {
        return [self calcNormalFormula:formula];
    }
    // 右括号
    NSRange rRange = [formula rangeOfString:@")" options:NSLiteralSearch range:NSMakeRange(lRange.location, formula.length-lRange.location)];
    // 获取括号左右边的表达式
    NSString *left = [formula substringWithRange:NSMakeRange(0, lRange.location)];
    NSString *right = [formula substringFromIndex:rRange.location + 1];
    // 括号内的表达式
    NSString *middle = [formula substringWithRange:NSMakeRange(lRange.location+1, rRange.location-lRange.location-1)];
    // 代入计算新的公式
    NSString *newFormula = [NSString stringWithFormat:@"%@%@%@", left, [self calcNormalFormula:middle], right];
    return [self calcComplexFormulaString:newFormula];
}
@end
