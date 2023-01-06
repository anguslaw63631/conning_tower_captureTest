import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:dio/dio.dart';
Future<WebResourceResponse?> interceptRequest(
    WebResourceRequest orgRequest) async {
  if (orgRequest.method == 'POST') {
    if (orgRequest.url.path.contains('get_incentive')) {
      return null;
    }
    var kcResponse = await http.post(orgRequest.url, headers: orgRequest.headers);
    print("KCA");
    print("URL");
    print(orgRequest);

    print("status:");
    print(kcResponse.headers);
    print(kcResponse.request);
    print(kcResponse.reasonPhrase);
    print(kcResponse.contentLength);
    print(kcResponse.isRedirect);
    print(kcResponse.persistentConnection);
    print("body:");
    print(kcResponse.body);
    print("KCA END");
    return WebResourceResponse(
        contentEncoding: 'gzip',
        contentType: 'text/plain',
        data: kcResponse.bodyBytes,
        headers: kcResponse.headers,
        reasonPhrase: kcResponse.reasonPhrase,
        statusCode: kcResponse.statusCode);
  }
  return null;
}

Future<WebResourceResponse?> interceptRequestByDIO(
    WebResourceRequest orgRequest) async {
  if (orgRequest.method == 'POST') {
    if (orgRequest.url.path.contains('get_incentive')) {
      return null;
    }

    Response kcResponse;
    var dio = Dio(BaseOptions(
        method: 'POST',
        headers: orgRequest.headers
    ));
    print("KCA Q");
    kcResponse = await dio.post(orgRequest.url.path);
    print("KCA Z");
    print("KCA");
    print("KC request hasGesture");
    print(orgRequest.hasGesture);
    print("KC request headers");
    print(orgRequest.headers);
    print("KC request isForMainFrame");
    print(orgRequest.isForMainFrame);
    print("KC request isRedirect");
    print(orgRequest.isRedirect);
    print("KC request method");
    print(orgRequest.method);
    print("KC request url");
    print(orgRequest.url);

    print("KC response headers:");
    print(kcResponse.headers);
    print("KC response request:");
    print(kcResponse.requestOptions);
    print("KC response isRedirect:");
    print(kcResponse.isRedirect);
    print("KC response data:");
    print(kcResponse.data);
    print("KC response extra:");
    print(kcResponse.extra);

    print("KC response redirects:");
    print(kcResponse.redirects);
    print("KC response statusCode:");
    print(kcResponse.statusCode);
    print("KC response statusMessage:");
    print(kcResponse.statusMessage);
    return WebResourceResponse(
        contentEncoding: 'gzip',
        contentType: 'text/plain',
        data: kcResponse.data,


        statusCode: kcResponse.statusCode);

  }
  return null;
}