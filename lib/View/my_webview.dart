// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import '../Controller/Provider/net_provider.dart';

class MyWebView extends StatefulWidget {
  final String url;

  const MyWebView({super.key, required this.url});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
          pullToRefreshController?.endRefreshing();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Browser"),
        centerTitle: true,
        leading: SizedBox.shrink(),
        actions: [
          PopupMenuButton(
            constraints: const BoxConstraints.expand(height: 110, width: 200),
            offset: const Offset(30, 50),
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.bookmark_add_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text("BookMark"),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.screen_search_desktop_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Search Engine"),
                      ],
                    ),
                  ),
                ),
              ];
            },
            onSelected: (val) {
              if (val == 1) {
                showModalBottomSheet(
                  isDismissible: false,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return Container(
                      height: MediaQuery.sizeOf(context).height * 0.9,
                      color: Colors.white,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              color: Colors.black26,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.close),
                                  SizedBox(width: 5),
                                  Text("Dismiss"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              if (val == 2) {
                AlertDialog alert = AlertDialog(
                  title: Center(child: Text('Search Engine')),
                  actions: [
                    Consumer<UrlProvider>(
                      builder: (BuildContext context, Uvalue, Widget? child) {
                        return Container(
                          height: MediaQuery.sizeOf(context).height * 0.3,
                          width: MediaQuery.sizeOf(context).width * 0.6,
                          child: Column(
                            children: [
                              RadioListTile(
                                title: Text('Google'),
                                value: 1,
                                groupValue: Uvalue.selectedValue,
                                onChanged: (value) {
                                  Uvalue.radioChange(value!);
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return MyWebView(
                                          url: "https://www.google.com");
                                    },
                                  ));
                                },
                              ),
                              RadioListTile(
                                title: Text('Yahoo'),
                                value: 2,
                                groupValue: Uvalue.selectedValue,
                                onChanged: (value) {
                                  Uvalue.radioChange(value!);
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return MyWebView(
                                          url: "https://in.search.yahoo.com");
                                    },
                                  ));
                                },
                              ),
                              RadioListTile(
                                title: Text('Bing'),
                                value: 3,
                                groupValue: Uvalue.selectedValue,
                                onChanged: (value) {
                                  Uvalue.radioChange(value!);
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return MyWebView(
                                          url: "https://www.bing.com");
                                    },
                                  ));
                                },
                              ),
                              RadioListTile(
                                title: Text('Duck Duck Go'),
                                value: 4,
                                groupValue: Uvalue.selectedValue,
                                onChanged: (value) {
                                  Uvalue.radioChange(value!);
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return MyWebView(
                                          url: "https://duckduckgo.com");
                                    },
                                  ));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Consumer<UrlProvider>(
            builder: (context, netProvider, child) {
              if (netProvider.progress >= 1) {
                return SizedBox.shrink();
              }
              return LinearProgressIndicator(
                minHeight: 8,
                value: netProvider.progress,
                color: Colors.yellow,
              );
            },
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              pullToRefreshController: pullToRefreshController,
              onLoadStop: (controller, url) async {
                var canGoBack = await controller.canGoBack();
                var canGoForward = await controller.canGoForward();
                print("mounted $mounted");

                if (mounted) {
                  Provider.of<UrlProvider>(context, listen: false)
                      .backForwardStatus(canGoBack, canGoForward);
                }

                print("canGoBack $canGoBack");
              },
              onProgressChanged: (controller, progress) {
                Provider.of<UrlProvider>(context, listen: false)
                    .changeProgress(progress / 100);
                print("progress => $progress");
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Search or type web address",
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder()),
              onFieldSubmitted: (value) {
                if (widget.url == "https://www.google.com") {
                  //Google
                  var searchText = "https://www.google.com/search?q=$value";
                  webViewController?.loadUrl(
                      urlRequest: URLRequest(url: WebUri(searchText)));
                  print("Entered Text $value");
                } else if (widget.url == "https://in.search.yahoo.com") {
                  //Yahoo
                  var searchText =
                      "https://in.search.yahoo.com/search?p=$value";
                  webViewController?.loadUrl(
                      urlRequest: URLRequest(url: WebUri(searchText)));
                  print("Entered Text $value");
                } else if (widget.url == "https://www.bing.com") {
                  //Bing
                  var searchText = "https://www.bing.com/?q=$value";
                  webViewController?.loadUrl(
                      urlRequest: URLRequest(url: WebUri(searchText)));
                  print("Entered Text $value");
                } else if (widget.url == "https://duckduckgo.com") {
                  //Duck Duck Go
                  var searchText = "https://duckduckgo.com/&q=$value";
                  webViewController?.loadUrl(
                      urlRequest: URLRequest(url: WebUri(searchText)));
                  print("Entered Text $value");
                }
              },
            ),
          ),
          SizedBox(height: 16),
          Consumer<UrlProvider>(builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    child: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MyWebView(url: widget.url);
                      },
                    ));
                  },
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                )),
                Container(
                  child: IconButton(
                      onPressed: () async {
                        webViewController?.loadUrl(
                            urlRequest: URLRequest(
                                url: await webViewController?.getUrl()));
                        var link =
                            URLRequest(url: await webViewController?.getUrl());
                        print("link ==> $link");
                      },
                      icon: Icon(Icons.bookmark_add, size: 30)),
                ),
                Container(
                  child: IconButton(
                      onPressed: value.canGoBack
                          ? () {
                              webViewController?.goBack();
                            }
                          : null,
                      icon: (value.canGoBack)
                          ? Icon(Icons.arrow_back_ios, size: 30)
                          : Icon(
                              Icons.arrow_back_ios,
                              size: 30,
                              color: Colors.black12,
                            )),
                ),
                Container(
                  child: IconButton(
                      onPressed: () {
                        webViewController?.reload();
                      },
                      icon: Icon(Icons.refresh, size: 30)),
                ),
                Container(
                  child: IconButton(
                      onPressed: value.canGoForward
                          ? () => webViewController?.goForward()
                          : null,
                      icon: (value.canGoForward)
                          ? Icon(Icons.arrow_forward_ios, size: 30)
                          : Icon(
                              Icons.arrow_forward_ios,
                              size: 30,
                              color: Colors.black12,
                            )),
                ),
              ],
            );
          }),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
