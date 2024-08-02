import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

// Only import desktop_webview_window if the platform is desktop
import 'package:desktop_webview_window/desktop_webview_window.dart'
if (dart.library.html) 'package:desktop_webview_window/desktop_webview_window.dart';

// Only import webview_flutter if the platform is Android or iOS
import 'package:webview_flutter/webview_flutter.dart'
if (dart.library.html) 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Webview App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();  // Enable hybrid composition for Android
    }
    _launchWebView();
  }

  Future<void> _launchWebView() async {
    if (Platform.isAndroid || Platform.isIOS) {
      // For mobile platforms, use webview_flutter
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const WebViewPage(),
      ));
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // For desktop platforms, use desktop_webview_window
      final webview = await WebviewWindow.create();
      webview
        ..setBrightness(Brightness.light)
        ..launch('https://desktop2.sizaf.com/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webview App'),
      ),
      body: const Center(
        child: Text('Loading WebView...'),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView App'),
      ),
      body: const WebView(
        initialUrl: 'https://desktop2.sizaf.com/login',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

