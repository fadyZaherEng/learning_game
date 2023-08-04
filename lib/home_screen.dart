import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:learning_game/model_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AudioPlayer player= AudioPlayer();
  List<ItemModel> images = [];
  List<ItemModel> names = [];
  int score = 0;
  bool gameOver = false;

  initGame() {
    gameOver = false;
    score = 0;
    images = [
      ItemModel(name: "lion", value: "Lion", image: "assets/lion.png"),
      ItemModel(name: "panda", value: "Panda", image: "assets/panda.png"),
      ItemModel(name: "camel", value: "Camel", image: "assets/camel.png"),
      ItemModel(name: "dog", value: "Dog", image: "assets/dog.png"),
      ItemModel(name: "cat", value: "Cat", image: "assets/cat.png"),
      ItemModel(name: "horse", value: "Horse", image: "assets/horse.png"),
      ItemModel(name: "sheep", value: "Sheep", image: "assets/sheep.png"),
      ItemModel(name: "hen", value: "Hen", image: "assets/hen.png"),
      ItemModel(name: "fox", value: "Fox", image: "assets/fox.png"),
      ItemModel(name: "cow", value: "Cow", image: "assets/cow.png"),
    ];
    names = List<ItemModel>.from(images);
    names.shuffle();
    images.shuffle();
  }

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      gameOver = true;
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: 'Score..',
                        style: Theme.of(context).textTheme.titleMedium),
                    TextSpan(
                        text: "$score",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Colors.teal)),
                  ]),
                ),
              ),
              if (!gameOver)
                Row(
                  children: [
                    const Spacer(),
                    //draggable
                    Column(
                      children: images
                          .map(
                            (item) => Container(
                              margin: const EdgeInsets.all(8),
                              child: Draggable<ItemModel>(
                                data: item,
                                childWhenDragging: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(item.image),
                                  radius: 50,
                                ),
                                feedback: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(item.image),
                                  radius: 30,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(item.image),
                                  radius: 30,
                                ),
                                onDragStarted: () {},
                                onDraggableCanceled: (velocity, offset) {},
                                onDragCompleted: () {},
                                onDragEnd: (dragDetails) {},
                                onDragUpdate: (dragDetails) {},
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                    //drag target
                    Column(
                      children: names
                          .map(
                            (itemNames) => DragTarget<ItemModel>(
                              onAccept: (receivedItem) {
                                if (itemNames.value == receivedItem.value) {
                                  setState(() {
                                    images.remove(receivedItem);
                                    names.remove(itemNames);
                                    score += 10;
                                    itemNames.isAccepting = false;
                                    player.play(AssetSource('true.wav'));
                                  });
                                } else {
                                  setState(() {
                                    score -= 5;
                                    itemNames.isAccepting = false;
                                    player.play(AssetSource("false.wav"));
                                  });
                                }
                              },
                              onWillAccept: (receivedItem) {
                                setState(() {
                                  itemNames.isAccepting = true;
                                });
                                return true;
                              },
                              onLeave: (receivedItem) {
                                setState(() {
                                  itemNames.isAccepting = false;
                                });
                              },
                              builder: (context, acceptedItem, rejectedItem) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: itemNames.isAccepting
                                        ? Colors.grey[400]
                                        : Colors.grey[200],
                                  ),
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.sizeOf(context).width / 6.5,
                                  width: MediaQuery.sizeOf(context).width / 3,
                                  margin: const EdgeInsets.all(8),
                                  child: Text(
                                    itemNames.name,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                    const Spacer(),
                  ],
                ),
              if (gameOver)
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text("Game Over",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,color: Colors.red
                        ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(result(),
                          style: Theme.of(context).textTheme.titleMedium
                        ),
                      ),
                    ],
                  ),
                ),
              if(gameOver)
                Container(
                  height: MediaQuery.sizeOf(context).width/10,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(onPressed: (){
                    setState(() {
                      initGame();
                    });
                  }, child:const Text('New Game',style: TextStyle(color: Colors.white),)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String result() {
    if(score==100){
      player.play(AssetSource("success.wav"));
      return 'Awesome !';
    }else{
      player.play(AssetSource("tryAgain.wav"));
      return 'Play Again to get better Score';
    }
  }
}
