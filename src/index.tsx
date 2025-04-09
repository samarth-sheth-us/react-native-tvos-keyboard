import {
  requireNativeComponent,
  UIManager,
  Platform,
  type ViewStyle,
  type NativeSyntheticEvent,
  type ViewProps,
} from 'react-native';
import React, { forwardRef } from 'react';

type OnFocusEvent = NativeSyntheticEvent<{
  focused: boolean;
}>;

type OnBlurEvent = NativeSyntheticEvent<{
  blurred: boolean;
}>;

type OnTextChangeEvent = NativeSyntheticEvent<{
  text: string;
}>;

export type TvosKeyboardProps = ViewProps & {
  onTextChange?: (event: OnTextChangeEvent) => void;
  onFocus?: (event: OnFocusEvent) => void;
  onBlur?: (event: OnBlurEvent) => void;
  style?: ViewStyle;
};

const ComponentName = 'TvosKeyboardView';

let NativeKeyboardComponent: React.ComponentType<TvosKeyboardProps>;

if (UIManager.getViewManagerConfig(ComponentName) != null) {
  NativeKeyboardComponent =
    requireNativeComponent<TvosKeyboardProps>(ComponentName);
} else {
  throw new Error(
    `The package 'react-native-tvos-keyboard' doesn't seem to be linked. Make sure:\n\n` +
      Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
      '- You rebuilt the app after installing the package\n' +
      '- You are not using Expo Go\n'
  );
}

// ✅ SAFE AND FLEXIBLE: Let the ref be 'any' to avoid TS mismatch
export const TvosKeyboardView = forwardRef<any, TvosKeyboardProps>(
  (props, ref) => {
    return <NativeKeyboardComponent {...props} ref={ref} />;
  }
);
