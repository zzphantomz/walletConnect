/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import {PropsWithChildren, useEffect, useState} from 'react';
import React from 'react';
import {
  Button,
  SafeAreaView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';

import {Core} from '@walletconnect/core';
import {IWalletKit, WalletKit} from '@reown/walletkit';

import {Colors} from 'react-native/Libraries/NewAppScreen';

type SectionProps = PropsWithChildren<{
  title: string;
}>;


function App(): React.JSX.Element {
  const isDarkMode = useColorScheme() === 'dark';

  const [clientWC, setClientWC] = useState<IWalletKit>();


  const core = new Core({
    projectId: '2dbe4db7e11c1057cc45b368eeb34319',
    relayUrl: 'wss://relay.walletconnect.org',
  });

  const initWalletConnect = async () => {
    try {
      const client = await WalletKit.init({
        core,
        metadata: {
          name: 'Coin98 Super Wallet',
          description: 'Coin98 Wallet is the #1 non-custodial, multi-chain wallet, and DeFi gateway',
          url: 'https://coin98.com/wallet',
          icons: [
            'https://explorer-api.walletconnect.com/v3/logo/lg/fc460647-ea95-447a-99f0-1bff8fa4be00?projectId=2f05ae7f1116030fde2d36508f472bfb',
          ],
        },
      });
      setClientWC(client);
      return client;
    } catch (error) {

      // console.error(error)
    }
  };

  useEffect(() => {
    initWalletConnect();
  }, []);


  const INJECTED_JAVASCRIPT = `(function() {
  const tokenLocalStorage = window.localStorage.getItem('token');
  window.ReactNativeWebView.postMessage(tokenLocalStorage);
})();`;
  const onMessage = (payload) => {
    console.log('payload', payload);
  };
  const wcuri = 'wc:66c4e4641be46cbc1de5836464f03c24110a705261cebc3c8d34df9547113b46@2?expiryTimestamp=1731900855&relay-protocol=irn&symKey=c0791f538f80df4615164271385192f34fdb47df915be119b24cb3084dd12e82';
  const onParing = async () => {
    try {
      const data = await clientWC?.core.pairing.pair({uri: wcuri});
      if (!data) {
        throw new Error('Pairing failed');
      }
      return data;
    }
    catch (error) {
      console.error(error);
    }
  };

  const consoleLog = (message) => {
    console.log(message);
  };

  const initSeasonWC = async () => {
    try {
      if (clientWC) {
        clientWC.on('session_proposal', consoleLog);
        clientWC.on('session_delete', consoleLog);
        clientWC.on('session_request', consoleLog);
        clientWC.on('proposal_expire', consoleLog);
        clientWC.on('session_request_expire', consoleLog);
      }
    } catch (e) {
    }
  };

  React.useEffect(() => {

    if (!clientWC) {
    } else {
      initSeasonWC();
    }
  }, [clientWC]);


  return (
    <SafeAreaView>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
      />
      <View style={{ flex: 1}}>
        <TouchableOpacity style={{
          width: 100,
          height: 100,
          backgroundColor: 'red',
          justifyContent: 'center',
          alignItems: 'center',
        }}
          onPress={onParing} />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
});

export default App;
