import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

void main() {
  runApp(
    const App(),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaveFrom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

WebViewPlusController? webViewPlusController;
late Uri url;

void changeWebStateAndTheme() {
  if (webViewPlusController != null) {
    webViewPlusController!.webViewController.runJavascript(
        "document.getElementsByTagName('footer')[0].remove();document.getElementsByTagName('header')[0].remove();");
    webViewPlusController!.webViewController.runJavascript(
        "document.getElementsByClassName('search-panel__container container_arrow_new')[0].remove()");
    webViewPlusController!.webViewController.runJavascript(
        "document.getElementsByClassName('wrapper wrapper-after-output')[0].remove()");
    webViewPlusController!.webViewController.runJavascript(
        "document.getElementsByClassName('terms__string')[0].remove()");
  }
}

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String videoUrl = await webViewPlusController!.webViewController
                .runJavascriptReturningResult(
                    "document.getElementsByClassName('def-btn-box')[0].querySelector("
                    "a"
                    ").getAttribute("
                    "href"
                    ");");
            // print('VideoURL :');
            // print(videoUrl);
            url = Uri.parse(videoUrl);
            await launchUrl(
              url,
              mode: LaunchMode.platformDefault,
              webViewConfiguration: const WebViewConfiguration(),
            );
          },
          child: const Icon(
            Icons.download,
            color: Colors.white,
          ),
        ),
        body: WebViewPlus(
          initialUrl: 'https://en.savefrom.net/',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewPlusController controllerPlus) {
            webViewPlusController = controllerPlus;
          },
          onProgress: (progress) {
            changeWebStateAndTheme();
          },
        ),
      ),
    );
  }
}
