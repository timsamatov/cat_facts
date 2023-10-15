import 'dart:io';

import 'package:cat_facts/cat_facts.dart' as cat_facts;
import 'package:dio/dio.dart';
import 'package:translator/translator.dart';

void main(List<String> arguments) {
  catFacts();
}

Future<void> catFacts() async {
  print('Выберите язык(kg, en, ru): ');
  String language = stdin.readLineSync()!.toLowerCase();

  final translator = GoogleTranslator();
  Dio dio = Dio();
  do {
    try {
      var response = await dio
          .get('https://catfact.ninja/fact?lang=$language');
      if (response.statusCode == 200) {
        String fact = response.data['fact'];
        String translatedFact = await translator
            .translate(fact, to: language)
            .then((value) => value.text);
        print('\nФакт о кошках: $translatedFact');
        await actions(translatedFact);
      } else {
        print('Произошла ошибка при получении.');
      }
    } catch (e) {
      print('Произошла ошибка: $e');
    }
  } while (true);
}

Future<void> actions(String fact) async {
  List<String> likedFacts = [];

  while (true) {
    print(
        '\nВыберите действие (Понравился, Далее, Показать список понравившихся фактов, Очистить факты, Выход): ');
    String action = stdin.readLineSync() ?? '';

    switch (action) {
      case 'Понравился':
        likedFacts.add(fact);
        break;
      case 'Далее':
        await catFacts();
        return;
      case 'Показать список понравившихся фактов':
        print('\nПонравившиеся факты:');
        likedFacts.forEach((likedFact) => print(likedFact));
        break;
      case 'Очистить факты':
        likedFacts.clear();
        print('Список очищен.');
        break;
      case 'Выход':
        exit(0);
      default:
        print('Неверная команда. Попробуйте снова.');
    }
  }
}
