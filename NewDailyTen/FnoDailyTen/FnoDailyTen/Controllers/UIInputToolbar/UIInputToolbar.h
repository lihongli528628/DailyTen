/*
 *  UIInputToolbar.h
 *
 *  Created by Brandon Hamilton on 2011/05/03.
 *  Copyright 2011 Brandon Hamilton.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "UIExpandingTextView.h"
//#import "AMRObject.h"

@class UIInputToolbar;

@protocol UIInputToolbarDelegate <NSObject>
@optional
-(void)inputMovieButtonPressed;
-(void)inputButtonPressed:(NSString *)inputText;
// 当输入框的高度发生变化时调用
-(void)expandingToolbar:(UIInputToolbar *)toolbar diff:(float)diffHeight;
-(void)expandingToolbar:(UIInputToolbar *)toolbar;

-(void)voiceBtnUpClicked;
-(void)voiceBtnDownClicked;
-(void)voicebtnDragClicked;
- (void)recoderFinishedFileName:(NSString *)fileName baseFilePath:(NSString *)basePath;

@end

@interface UIInputToolbar : UIToolbar <UIExpandingTextViewDelegate,UIGestureRecognizerDelegate>
{
    UIExpandingTextView *textView;
    UIBarButtonItem *inputButton;
    NSObject <UIInputToolbarDelegate> *delegate;
    UIButton *button;
    UIButton *movieButton;
    UIButton *voiceButton;
    BOOL     cancelAudioSender;
    CGPoint curTouchPoint;
}

- (void)drawRect:(CGRect)rect;
-(void)inputButtonMoviePressed;
- (void)focus;

@property (nonatomic, retain) UIExpandingTextView *textView;
@property (nonatomic, retain) UIBarButtonItem *inputButton;
@property (nonatomic, assign) id <UIInputToolbarDelegate> delegate;
@property (assign ,nonatomic)  int          audioTime;
@property (assign, nonatomic)  BOOL         currentIsText;

@end
