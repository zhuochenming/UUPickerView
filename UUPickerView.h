//
//  UUPickerView.h
//  UUPickerView
//
//  Created by Zhuochenming on 16/1/27.
//  Copyright © 2016年 Zhuochenming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UUPickerView;
@protocol UUPickerViewDelegate <NSObject>

@required
//如果是datePicker返回的数组第一个值是选择的时间
- (void)pickerViewClick:(UUPickerView *)pickerView rowArray:(NSArray *)rowArray;

@optional
- (void)cancleClick:(UUPickerView *)pickerView;

@end

@interface UUPickerView : UIView

@property (nonatomic, weak) id<UUPickerViewDelegate>delegate;

//通过plistName添加一个pickView(最多三层，太多自己改UI)
- (instancetype)initPickerViewWithPlistName:(NSString *)plistName title:(NSString *)title;
//通过数组添加一个pickView(最多三层，太多自己改UI)
- (instancetype)initPickerViewWithArray:(NSArray *)array title:(NSString *)title;

//DatePicker
- (instancetype)initDatePickerWithDate:(NSDate *)defaulDate
                        datePickerMode:(UIDatePickerMode)datePickerMode
                                 title:(NSString *)title;

//UIPickerView默认选中行
- (void)pickerViewSelectRow:(NSInteger)row inComponent:(NSInteger)component;
//UIDatePicker默认选中行
- (void)datePickerSelectedDate:(NSDate *)date;

- (void)show;

@end
