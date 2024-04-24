import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmydairy/homeProvider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      provider.webController.reload();
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (await provider.webController.canGoBack()) {
            provider.webController.goBack();
          }
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("My Dairy"),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  provider.refresh();
                },
              ),
            ),
            body: Stack(
              children: [
                WebViewWidget(
                    controller: provider.webController
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..setNavigationDelegate(NavigationDelegate(
                        onNavigationRequest: (request) {
                          print("url.....${request.url}");
                          if (request.url.endsWith("admin")) {
                            provider.signIn(request.url);
                          } else if (request.url.endsWith("Pdf")) {
                            provider.launchURL(request.url);
                            return NavigationDecision.prevent;
                          } else if (request.url.endsWith("Export")) {
                            provider.launchURL(request.url);
                            return NavigationDecision.prevent;
                          } else if (request.url.endsWith("logout")) {
                            provider.logOut(request.url);
                          }
                          return NavigationDecision.navigate;
                        },
                      ))),
                if (provider.isLoading == true)
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
