import 'dart:typed_data';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

const String interceptJS ='''

var origOpen = XMLHttpRequest.prototype.open;
XMLHttpRequest.prototype.open = function() {
    this.addEventListener('load', function() {
        if (this.responseURL.includes('/kcsapi/')) {
            kcMessage.postMessage(this.responseText);
        }
    });
    origOpen.apply(this, arguments);
};

''';

Uint8List convertStringToUint8List(String str) {
  final List<int> codeUnits = str.codeUnits;
  final Uint8List unit8List = Uint8List.fromList(codeUnits);

  return unit8List;
}
Future<WebResourceResponse?> interceptRequest(
    WebResourceRequest orgRequest) async {
    var kcResponse = await http.get(orgRequest.url, headers: orgRequest.headers);
    // print("KCA");
    // print("URL");
    // print(orgRequest);
    //
    // print("status:");
    // print(kcResponse.headers);
    // print(kcResponse.request);
    // print(kcResponse.reasonPhrase);
    // print(kcResponse.contentLength);
    // print(kcResponse.isRedirect);
    // print(kcResponse.persistentConnection);
    // print("body:");
    // print(kcResponse.body);
    // print("KCA END");

    String temp = kcResponse.body + interceptJS;
    return WebResourceResponse(
        contentEncoding: 'gzip',
        contentType: 'application/javascript',
        data: convertStringToUint8List(temp),
        headers: kcResponse.headers,
        reasonPhrase: kcResponse.reasonPhrase,
        statusCode: kcResponse.statusCode);
}