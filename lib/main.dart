import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Lab 1'),
    );
  }
}

double lbsToKgFunction(int number) {
  const double lbsConst = 0.4535924;
  return number * lbsConst;
}

List<String> getListOfWords(String text) {
  var matches = RegExp(r"[\w-|\wA-Z|\wа-я|\wА-Я|wє-і]+").allMatches(text);
  return matches.map((e) => e.group(0)!).toList();
}

Map<String, int> getMostCommonWordsFromList(List<String> listOfWords) {
  var map = {};
  if (listOfWords.length >= 2) {
    for (var x in listOfWords) {
      map[x] = !map.containsKey(x) ? (1) : (map[x] + 1);
    }
    final sortedKeys = map.keys.toList()
      ..sort((a, b) => map[b].compareTo(map[a]));
    Map<String, int> finalMap = {};
    if (sortedKeys.length > 2) {
      for (int i = 0; i <= 2; i++) {
        if (map[sortedKeys[i]] > 1) {
          finalMap.addEntries([MapEntry(sortedKeys[i], map[sortedKeys[i]])]);
        }
      }
      return finalMap;
    } else {
      return {listOfWords.first: map[sortedKeys[0]]};
    }
  } else {
    return {listOfWords.first: 1};
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TextEditingController taskOneController;
  late TextEditingController taskTwoController;
  late TextEditingController resultController;
  bool buttonPressed = false;
  Map<String, int> mostCommonWords = {};
  late TabController tapBarController;

  @override
  void initState() {
    super.initState();
    taskOneController = TextEditingController();
    taskTwoController = TextEditingController();
    resultController = TextEditingController();
    tapBarController = TabController(length: 2, vsync: this);
    tapBarController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(children: [
          TabBar(
            indicatorPadding: const EdgeInsets.only(right: 10),
            isScrollable: true,
            labelPadding: const EdgeInsets.only(right: 10),
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: CupertinoColors.black,
            controller: tapBarController,
            tabs: const [
              Tab(
                text: "Task 1",
              ),
              Tab(
                text: "Task 2",
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 50,
            child: TabBarView(controller: tapBarController, children: [
              Column(
                children: [
                  const SizedBox(
                      height: 30,
                      child: Center(child: Text("Write your text"))),
                  SizedBox(
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                          textAlignVertical: TextAlignVertical.top,
                          expands: true,
                          maxLines: null,
                          controller: taskOneController,
                          onChanged: (change) {},
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF8B8B8B),
                                width: 2.0,
                              ),
                            ),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            buttonPressed = true;
                            var list = getListOfWords(taskOneController.text);
                            if (list.isNotEmpty) {
                              mostCommonWords =
                                  getMostCommonWordsFromList(list);
                            }
                            else{
                              mostCommonWords.clear();
                            }
                          });
                        },
                        child: const Text("Calculate most common words"),
                        style: Theme.of(context).elevatedButtonTheme.style,
                      ),
                    ),
                  ),
                  if (mostCommonWords.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Most common words:",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                  if (mostCommonWords.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Text(
                                "${mostCommonWords.entries.toList()[index].key} : ${mostCommonWords.entries.toList()[index].value}"),
                          );
                        },
                        itemCount: mostCommonWords.entries.toList().length,
                      ),
                    )
                  else if (buttonPressed)
                    const Text("No repeated words")
                ],
              ),
              Wrap(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: Text("Enter your value")),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: TextField(
                                textAlign: TextAlign.center,
                                controller: taskTwoController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF8B8B8B),
                                      width: 2.0,
                                    ),
                                  ),
                                )),
                          ),
                          if (taskTwoController.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      resultController.clear();
                                      taskTwoController.clear();
                                    });
                                  },
                                  child: const Text("Clear")),
                            )
                        ],
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          "lbs",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                resultController.text = taskTwoController
                                        .text.isNotEmpty
                                    ? lbsToKgFunction(
                                            int.parse(taskTwoController.text))
                                        .toString()
                                    : "";
                              });
                            },
                            icon: const Icon(Icons.arrow_forward)),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: TextField(
                                textAlign: TextAlign.center,
                                controller: resultController,
                                enabled: false,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF8B8B8B),
                                      width: 2.0,
                                    ),
                                  ),
                                )),
                          ),
                          if (resultController.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    resultController.text = double.parse(
                                                resultController.text) >
                                            9
                                        ? double.parse(resultController.text)
                                            .round()
                                            .toString()
                                        : double.parse(resultController.text)
                                            .toStringAsFixed(2);
                                  },
                                  child: const Text("Round")),
                            )
                        ],
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          "kg",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          )
        ]),
      ),
    );
  }
}
