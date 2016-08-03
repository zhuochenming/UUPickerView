//
//  UUPickerView.m
//  UUPickerView
//
//  Created by Zhuochenming on 16/1/27.
//  Copyright © 2016年 Zhuochenming. All rights reserved.
//

#import "UUPickerView.h"

static CGFloat const TopToobarHeight = 40;

@interface UUPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

//传入的数组
@property (nonatomic, strong) NSArray *dataArray;

//UI
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *bacView;

//高度
@property (nonatomic, assign) NSInteger pickeviewHeight;

@property (nonatomic, strong) NSMutableArray *rowArray;

@end

@implementation UUPickerView

- (NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (void)initWithPickerView {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.showsSelectionIndicator = NO;
    _pickerView = pickerView;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    pickerView.frame = CGRectMake(0, TopToobarHeight, screenWidth, pickerView.frame.size.height);
    self.pickeviewHeight = pickerView.frame.size.height;
    [self addSubview:pickerView];
}

#pragma mark - 初始化
- (instancetype)initPickerViewWithPlistName:(NSString *)plistName title:(NSString *)title {
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
        self.dataArray = array;
        [self initWithPickerView];
        [self createSubViewWithTitle:title];
    }
    return self;
}

- (instancetype)initPickerViewWithArray:(NSArray *)array title:(NSString *)title {
    self = [super init];
    if (self) {
        self.dataArray = array;
        [self initWithPickerView];
        [self createSubViewWithTitle:title];
    }
    return self;
}

- (instancetype)initDatePickerWithDate:(NSDate *)defaulDate
                        datePickerMode:(UIDatePickerMode)datePickerMode
                                 title:(NSString *)title {
    self = [super init];
    if (self) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        [datePicker setLocale:[NSLocale systemLocale]];
        datePicker.datePickerMode = datePickerMode;
        //        [datePicker setTimeZone:[NSTimeZone defaultTimeZone]];
        [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
        
        datePicker.backgroundColor = [UIColor whiteColor];
        [datePicker setDate:defaulDate];
        _datePicker = datePicker;
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        datePicker.frame = CGRectMake(0, TopToobarHeight, screenWidth, datePicker.frame.size.height);
        self.pickeviewHeight = datePicker.frame.size.height;
        [self addSubview:datePicker];
        
        [self createSubViewWithTitle:title];
    }
    return self;
}

- (void)createSubViewWithTitle:(NSString *)title {
    self.rowArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        [self.rowArray addObject:@(0)];
    }
    
    CGFloat height = _pickeviewHeight + TopToobarHeight;
    CGFloat top = CGRectGetHeight([UIScreen mainScreen].bounds) - height;
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, top, width, height);
    
    CGFloat buttonWidth = 50;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(15, 0, buttonWidth, TopToobarHeight);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithRed:75 / 255.0 green:137 / 255.0 blue:220 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:leftButton];
    
    CGFloat left = (CGRectGetWidth(self.frame) - 150) / 2.0;
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, 150, TopToobarHeight)];
    lable.text = title;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor lightGrayColor];
    lable.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:lable];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(CGRectGetWidth(self.frame) - 15 - TopToobarHeight, 0, buttonWidth, TopToobarHeight);
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:75 / 255.0 green:137 / 255.0 blue:220 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:rightButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, TopToobarHeight - 0.5, width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
}

#pragma mark - piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _dataArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *rowArray = _dataArray[component];
    return rowArray.count;
}

#pragma mark UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *rowArray = _dataArray[component];
    return rowArray[row];
 }

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.rowArray replaceObjectAtIndex:component withObject:@(row)];
}

#pragma mark - 属性自定义
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    NSArray *rowArray = _dataArray[component];
    if (rowArray.count == 1) {
        return 200;
    } else {
        return 100;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *lable = [[UILabel alloc] init];
    NSArray *rowArray = _dataArray[component];
    if (rowArray.count == 1) {
        lable.frame = CGRectMake(0.0, 0.0, 200, 30);
    } else {
        lable.frame = CGRectMake(0.0, 0.0, 100, 30);
    }
    
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = _dataArray[component][row];
    lable.font = [UIFont systemFontOfSize:14];
    lable.backgroundColor = [UIColor clearColor];
    return lable;
}

- (void)pickerViewSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.rowArray replaceObjectAtIndex:component withObject:@(row)];
    [self.pickerView selectRow:row inComponent:component animated:YES];
    [self.pickerView reloadComponent:component];
}

- (void)datePickerSelectedDate:(NSDate *)date {
    [self.rowArray replaceObjectAtIndex:0 withObject:date];
    self.datePicker.date = date;
}

#pragma mark - 展示
- (void)show {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.bacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - self.pickeviewHeight - TopToobarHeight)];
    self.bacView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_bacView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)remove {
    if ([self.delegate respondsToSelector:@selector(cancleClick:)]) {
        [self.delegate cancleClick:self];
    }
    
    [self removeViewWithAnimation];
}

- (void)removeViewWithAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.bacView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bacView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - 按钮点击事件
- (void)cancleButtonClick {
    [self remove];
}

- (void)okButtonClick {
    if (_pickerView) {
        [self.delegate pickerViewClick:self rowArray:_rowArray];
        [self removeViewWithAnimation];
    } else if (_datePicker) {
        [_rowArray replaceObjectAtIndex:0 withObject:_datePicker.date];
        [self.delegate pickerViewClick:self rowArray:_rowArray];
        [self removeViewWithAnimation];
    }
}

@end
