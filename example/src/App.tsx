import { useState } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { TvosKeyboardView } from 'react-native-tvos-keyboard';

export default function App() {
  const [value, setValue] = useState('');

  return (
    <View style={styles.container}>
      <TvosKeyboardView
        onTextChange={(e) => setValue(e.nativeEvent.text)}
        style={styles.keyboard}
      />
      <Text style={styles.text}>Typed: {value}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
    justifyContent: 'center',
    alignItems: 'center',
  },
  keyboard: {
    width: 1,
    height: 1,
  },
  text: {
    marginTop: 20,
    color: 'white',
    fontSize: 18,
  },
});
