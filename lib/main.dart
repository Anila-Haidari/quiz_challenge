import 'package:flutter/material.dart';
import 'package:quiz/quiz_brain.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quiz());

class Quiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.purpleAccent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  int correctAnswers = 0;

  void showResultDialog(BuildContext context, int score, int total) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Congratulations!",
      desc: "Your score is $score / $total",
      buttons: [
        DialogButton(
          child: Text(
            "Restart", style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {Navigator.pop(context);
          },
          color: Colors.purpleAccent,
        )
      ],
    ).show();
  }

  void checkAnswer(bool userAnswer) {
    bool correctAnswer = quizBrain.getCorrectAnswer();

    setState(() {
      if (correctAnswer == userAnswer) {
        scoreKeeper.add(Icon(Icons.check, color: Colors.green));
        correctAnswers++;
      } else {
        scoreKeeper.add(Icon(Icons.close, color: Colors.red));
      }

      if (quizBrain.isFinished()) {
        showResultDialog(
          context,
          correctAnswers,
          quizBrain.getTotalQuestions(),
        );

        quizBrain.reset();
        scoreKeeper.clear();
        correctAnswers = 0;
      } else {
        quizBrain.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 20),
              ),
              onPressed: () => checkAnswer(true),
              child: Text('True'),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 20),
              ),
              onPressed: () => checkAnswer(false),
              child: Text('False'),
            ),
          ),
        ),
        Row(children: scoreKeeper),
      ],
    );
  }
}
