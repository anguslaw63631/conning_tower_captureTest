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
                  print("button");
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
                      "https://www.dmm.com/netgame/social/application/-/detail/=/app_id=854854/")),
              onWebViewCreated: (InAppWebViewController controller) {
                webViewController = controller;
              },
              shouldInterceptRequest: (
                controller,
                WebResourceRequest request,
              ) async {
                if (request.url.path.contains("/kcsapi/")) {
                  //print('androidShouldInterceptRequest: $request');
                  //Future<WebResourceResponse?> customResponse = interceptRequest(request);
                  //Future<WebResourceResponse?> customResponse = interceptRequestByDIO(request);
                  Future<WebResourceResponse?> customResponse = interceptRequestByHttpclient(request);
                  if(customResponse!=null){
                    print("KCA: Return customResponse");
                    return customResponse;
                  }
                }
                return null;
              },
            ),
          ])),
        ]));
  }
}
