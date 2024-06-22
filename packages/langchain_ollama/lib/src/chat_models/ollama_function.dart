import 'package:langchain_core/chat_models.dart';
import 'package:langchain_core/src/prompts/types.dart';
import 'package:langchain_core/tools.dart';
import 'package:langchain_ollama/src/chat_models/types.dart';
import 'package:http/http.dart' as http;
import 'package:ollama_dart/ollama_dart.dart';
import 'package:uuid/uuid.dart';
import '../llms/mappers.dart';
import 'mappers.dart';
import 'types.dart';
import 'chat_models.dart';

class OllamaFunction extends BaseChatModel<ChatOllamaFunctionOptions> {
  OllamaFunction({
    final String baseUrl = 'http://localhost:11434/api',
    final Map<String, String>? headers,
    final Map<String, dynamic>? queryParams,
    final http.Client? client,
    super.defaultOptions = const ChatOllamaFunctionOptions(
      options: ChatOllamaOptions(model: 'llama3'),
    ),
  }) : _client = OllamaClient(
          baseUrl: baseUrl,
          headers: headers,
          queryParams: queryParams,
          client: client,
        );

  final OllamaClient _client;

  late final Uuid _uuid = const Uuid();

  @override
  Future<ChatResult> invoke(
    PromptValue input, {
    ChatOllamaFunctionOptions? options,
  }) async {
    final id = _uuid.v4();
    final completion = await _client.generateChatCompletion(
      request: _generateCompletionRequest(input.toChatMessages(),
          options: options?.options),
    );
    return completion.toChatResult(id);
  }

  @override
  String get modelType => 'ollama-function';

  GenerateChatCompletionRequest _generateCompletionRequest(
    final List<ChatMessage> messages, {
    final bool stream = false,
    final ChatOllamaOptions? options,
  }) {
    return GenerateChatCompletionRequest(
      model: options?.model ??
          defaultOptions.options.model ??
          throwNullModelError(),
      messages: messages.toMessages(),
      format: options?.format?.toResponseFormat(),
      keepAlive: options?.keepAlive,
      stream: stream,
      options: RequestOptions(
        numKeep: options?.numKeep ?? defaultOptions.options.numKeep,
        seed: options?.seed ?? defaultOptions.options.seed,
        numPredict: options?.numPredict ?? defaultOptions.options.numPredict,
        topK: options?.topK ?? defaultOptions.options.topK,
        topP: options?.topP ?? defaultOptions.options.topP,
        tfsZ: options?.tfsZ ?? defaultOptions.options.tfsZ,
        typicalP: options?.typicalP ?? defaultOptions.options.typicalP,
        repeatLastN: options?.repeatLastN ?? defaultOptions.options.repeatLastN,
        temperature: options?.temperature ?? defaultOptions.options.temperature,
        repeatPenalty:
            options?.repeatPenalty ?? defaultOptions.options.repeatPenalty,
        presencePenalty:
            options?.presencePenalty ?? defaultOptions.options.presencePenalty,
        frequencyPenalty: options?.frequencyPenalty ??
            defaultOptions.options.frequencyPenalty,
        mirostat: options?.mirostat ?? defaultOptions.options.mirostat,
        mirostatTau: options?.mirostatTau ?? defaultOptions.options.mirostatTau,
        mirostatEta: options?.mirostatEta ?? defaultOptions.options.mirostatEta,
        penalizeNewline:
            options?.penalizeNewline ?? defaultOptions.options.penalizeNewline,
        stop: options?.stop ?? defaultOptions.options.stop,
        numa: options?.numa ?? defaultOptions.options.numa,
        numCtx: options?.numCtx ?? defaultOptions.options.numCtx,
        numBatch: options?.numBatch ?? defaultOptions.options.numBatch,
        numGpu: options?.numGpu ?? defaultOptions.options.numGpu,
        mainGpu: options?.mainGpu ?? defaultOptions.options.mainGpu,
        lowVram: options?.lowVram ?? defaultOptions.options.lowVram,
        f16Kv: options?.f16KV ?? defaultOptions.options.f16KV,
        logitsAll: options?.logitsAll ?? defaultOptions.options.logitsAll,
        vocabOnly: options?.vocabOnly ?? defaultOptions.options.vocabOnly,
        useMmap: options?.useMmap ?? defaultOptions.options.useMmap,
        useMlock: options?.useMlock ?? defaultOptions.options.useMlock,
        numThread: options?.numThread ?? defaultOptions.options.numThread,
      ),
    );
  }

  @override
  Future<List<int>> tokenize(
    PromptValue promptValue, {
    ChatOllamaFunctionOptions? options,
  }) {
    // TODO: implement tokenize
    throw UnimplementedError();
  }
}

//test demo
void main() {
  getTool();
}

void getTool() async {
  final model = OllamaFunction(
    defaultOptions: const ChatOllamaFunctionOptions(
      options: ChatOllamaOptions(model: 'llama3:8b'),
      tools: [tool1],
    ),
  );
  final messages = [
    ChatMessage.system(
      'You have access to the following tools: {name:get_current_weather,description:Get the current weather in a given location}You must always select one of the above tools and respond with only a JSON object matching the following schema: {tool: name of the selected tool}',
    ),
    ChatMessage.humanText("What's the weather in Vellore,India?"),
  ];
  final prompt = PromptValue.chat(messages);
  final res = await model.invoke(prompt);
  print(res);
}

const tool1 = ToolSpec(
  name: 'get_current_weather',
  description: 'Get the current weather in a given location',
  inputJsonSchema: getWeatherInputJsonSchema,
);

const Map<String, dynamic> getWeatherInputJsonSchema = {
  'type': 'object',
  'properties': {
    'location': {
      'type': 'string',
      'description': 'The city and state, e.g. San Francisco, CA',
    },
    'unit': {
      'type': 'string',
      'enum': ['celsius', 'fahrenheit'],
    },
  },
  'required': ['location'],
};
