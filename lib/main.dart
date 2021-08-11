import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:read_text/controller/speak_controller.dart';

void main() {
  runApp(MyMain());
}

class MyMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpeakController(false, ""))
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Read Text For me',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum TtsState { playing, stopped, paused, continued }

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterTts flutterTts = FlutterTts();
  final TextEditingController textController = TextEditingController();

  List<Widget> list = [];

  @override
  void initState() {
    super.initState();
    setLan();
  }

  Future setLan() async {
    var languages = await flutterTts.getLanguages;
    print(await flutterTts.getLanguages);
    for (var item in await languages) {
      list.add(
          Consumer<SpeakController>(builder: (context, controller, widget) {
        return CheckboxListTile(
          title: Text(item),
          value: controller.getString() == item,
          onChanged: (bool? value) {
            controller.setString(item);
            print(controller.getString());
          },
        );
      }));
    }
  }

  Future speak(String text, String language) async {
    await flutterTts.setLanguage(language);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  Future stop() async {
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Text('Read Text', style: TextStyle(color: Colors.white38)),
        actions: [
          Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          }),
        ],
      ),
      endDrawer: endDrawer(),
      body: Consumer<SpeakController>(
        builder: (context, controller, widget) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: TextFormField(
                      controller: textController,
                      decoration: InputDecoration(
                        // contentPadding:
                        //     EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: InputBorder.none,
                        hintText: 'Enter Your Text',
                      ),
                      // textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      // onChanged: (String value){},
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        icon: controller.isPause
                            ? Icon(Icons.pause)
                            : Icon(Icons.mic_rounded),
                        onPressed: () async {
                          if (!controller.isPause) {
                            // await speak(textController.text, controller.getString());

                            controller.setPause(true);
                            await flutterTts
                                .setLanguage(controller.getString());
                            await flutterTts.setPitch(1);
                            await flutterTts.speak(textController.text);
                            flutterTts.setCompletionHandler(() {
                              controller.setPause(false);
                            });
                          } else {
                            stop();
                            controller.setPause(false);
                          }
                        }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Drawer endDrawer() {
    return Drawer(
        child: SingleChildScrollView(
      child: Center(
        child: Column(
          children: list,
        ),
        // child: Text('End Drawer'),
      ),
    ));
  }
}
