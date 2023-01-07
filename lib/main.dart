import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'kcaHandler.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WebView.debugLoggingSettings.enabled = false;
  runApp(const MaterialApp(home: MyApp()));
}

enum ProgressIndicatorType { circular, linear }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewSettings webViewSetting = InAppWebViewSettings(
    javaScriptEnabled: true,
    useShouldInterceptRequest: true,
    userAgent:
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36",
  );
  InAppWebViewController? webViewController;
  double progress = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("KanColle", style: const TextStyle(fontSize: 18)),
          actions: [
            IconButton(
                onPressed: () async {
                  await webViewController?.loadUrl(
                      urlRequest: URLRequest(
                          url: WebUri(
                              "https://www.dmm.com/netgame/social/application/-/detail/=/app_id=854854/")));
                },
                icon: const Icon(Icons.home)),
            IconButton(
                onPressed: () async {
                  await webViewController?.reload();
                },
                icon: const Icon(Icons.refresh)),
            IconButton(
                onPressed: () async {
                },
                icon: const Icon(Icons.account_circle))
          ],
        ),
        body: Column(children: <Widget>[
          Expanded(
              child: Stack(children: [
            InAppWebView(
              key: webViewKey,
              initialSettings: webViewSetting,
              initialUrlRequest: URLRequest(
                  url: WebUri(
                      "https://www.dmm.com/netgame/social/application/-/detail/=/app_id=854854")),
              onWebViewCreated: (InAppWebViewController controller) {
                webViewController = controller;
                WebMessageListener kcListener= WebMessageListener(jsObjectName: "kcMessage",
                    onPostMessage: (message, sourceOrigin, isMainFrame, replyProxy) {
                      print("=======================================================");
                      print("kc listener:");
                      print(message);
                      print("=======================================================");
                    }
                );
                controller.addWebMessageListener(kcListener);
              },
              onLoadStop: (controller,uri){
                if(uri.toString().contains("app_id=854854")){
                  print("autoscale");
                  controller.injectJavascriptFileFromAsset(assetFilePath: "assets/js/gameAutoFitAndroid.js");
                }
              },
              onConsoleMessage: (controll,message){
                //Only print Kancolle data
                // if(message.message.contains("api_result")){
                //   print("console:$message");
                // }
              },
              shouldInterceptRequest: (
                controller,
                WebResourceRequest request,
              ) async {
                if (request.url.path.contains("/kcs2/js/main.js")) {
                    // print('androidShouldInterceptRequest: $request');
                    Future<WebResourceResponse?> customResponse = interceptRequest(request);
                    return customResponse;
                }
                return null;
              },
            ),
          ])),
        ]));
  }
}
