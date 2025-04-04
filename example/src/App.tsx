import { useEffect, useRef } from 'react';
import {
  findNodeHandle,
  UIManager,
  Platform,
  View,
  StyleSheet,
  Text,
  TouchableOpacity,
} from 'react-native';
import { TvosKeyboardView } from 'react-native-tvos-keyboard';

export default function App() {
  const keyboardRef = useRef(null);

  useEffect(() => {
    const tag = findNodeHandle(keyboardRef.current);

    if (Platform.isTV && tag != null) {
      const viewManager =
        UIManager.getViewManagerConfig?.('TvosKeyboardView') ?? {};
      const commandId = viewManager.Commands?.focusSearchBar;

      if (commandId != null) {
        UIManager.dispatchViewManagerCommand(tag, commandId, []);
      }
    }
  }, []);

  return (
    <View style={styles.container}>
      {/* Top Button */}
      <TouchableOpacity
        style={styles.button}
        activeOpacity={0.8}
        onPress={() => console.log('Top Button Pressed')}
        hasTVPreferredFocus={true}
        focusable={true}
      >
        <Text style={styles.buttonText}>↑ Top Button</Text>
      </TouchableOpacity>

      {/* TV Keyboard */}
      <TvosKeyboardView
        ref={keyboardRef}
        style={styles.keyboard}
        onTextChange={(e) => console.log('Typed:', e.nativeEvent.text)}
      />

      {/* Bottom Button */}
      <TouchableOpacity
        style={styles.button}
        activeOpacity={0.8}
        onPress={() => console.log('Bottom Button Pressed')}
        focusable={true}
      >
        <Text style={styles.buttonText}>↓ Bottom Button</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#111',
    justifyContent: 'center',
    alignItems: 'center',
  },
  keyboard: {
    width: '100%',
    height: 500,
    marginVertical: 30,
    backgroundColor: 'transparent',
  },
  button: {
    paddingVertical: 20,
    paddingHorizontal: 50,
    backgroundColor: '#1e90ff',
    borderRadius: 12,
    marginVertical: 10,
  },
  buttonText: {
    color: '#fff',
    fontSize: 22,
  },
});
