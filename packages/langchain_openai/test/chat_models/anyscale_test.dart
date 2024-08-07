@TestOn('vm')
library; // Uses dart:io

import 'dart:io';

import 'package:langchain_core/chat_models.dart';
import 'package:langchain_core/language_models.dart';
import 'package:langchain_core/prompts.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:test/test.dart';

void main() {
  group('Anyscale tests', () {
    late ChatOpenAI chatModel;

    setUp(() async {
      chatModel = ChatOpenAI(
        apiKey: Platform.environment['ANYSCALE_API_KEY'],
        baseUrl: 'https://api.endpoints.anyscale.com/v1',
      );
    });

    tearDown(() {
      chatModel.close();
    });

    test('Test invoke Anyscale API with different models', () async {
      final models = [
        'meta-llama/Llama-2-70b-chat-hf',
        'codellama/CodeLlama-34b-Instruct-hf',
        'mistralai/Mistral-7B-Instruct-v0.1',
        'mistralai/Mixtral-8x7B-Instruct-v0.1',
      ];
      for (final model in models) {
        final res = await chatModel.invoke(
          PromptValue.string(
            'List the numbers from 1 to 9 in order. '
            'Output ONLY the numbers in one line without any spaces or commas. '
            'NUMBERS:',
          ),
          options: ChatOpenAIOptions(model: model),
        );

        expect(res.id, isNotEmpty);
        expect(
          res.finishReason,
          isNot(FinishReason.unspecified),
          reason: model,
        );
        expect(
          res.output.content.replaceAll(RegExp(r'[\s\n]'), ''),
          contains('123456789'),
          reason: model,
        );
        expect(res.metadata, isNotNull, reason: model);
        expect(res.metadata['created'], greaterThan(0), reason: model);
        expect(res.metadata['model'], isNotEmpty, reason: model);
        await Future<void>.delayed(const Duration(seconds: 1)); // Rate limit
      }
    });

    test('Test stream Anyscale API with different models', () async {
      final models = [
        'meta-llama/Llama-2-70b-chat-hf',
        'codellama/CodeLlama-34b-Instruct-hf',
        'mistralai/Mistral-7B-Instruct-v0.1',
        'mistralai/Mixtral-8x7B-Instruct-v0.1',
      ];
      for (final model in models) {
        final stream = chatModel.stream(
          PromptValue.string(
            'List the numbers from 1 to 9 in order. '
            'Output ONLY the numbers in one line without any spaces or commas. '
            'NUMBERS:',
          ),
          options: ChatOpenAIOptions(model: model),
        );

        String content = '';
        int count = 0;
        await for (final res in stream) {
          content += res.output.content.replaceAll(RegExp(r'[\s\n,]'), '');
          count++;
        }
        expect(count, greaterThan(1), reason: model);
        expect(content, contains('123456789'), reason: model);
        await Future<void>.delayed(const Duration(seconds: 1)); // Rate limit
      }
    });

    test('Test countTokens', () async {
      final models = [
        'mistralai/Mixtral-8x7B-Instruct-v0.1',
        'mistralai/Mistral-7B-Instruct-v0.2',
        'NousResearch/Nous-Hermes-2-Yi-34B',
        'openchat/openchat-3.5-1210',
        'togethercomputer/llama-2-70b-chat',
        'togethercomputer/falcon-40b-instruct',
      ];
      for (final model in models) {
        const text = 'Hello, how are you?';

        final numTokens = await chatModel.countTokens(
          PromptValue.chat([ChatMessage.humanText(text)]),
          options: ChatOpenAIOptions(model: model),
        );
        expect(numTokens, 13, reason: model);
      }
    });
  });
}
