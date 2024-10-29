// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: invalid_annotation_target
part of openai_realtime_schema;

// ==========================================
// CLASS: SessionConfig
// ==========================================

/// Session configuration to update.
@freezed
class SessionConfig with _$SessionConfig {
  const SessionConfig._();

  /// Factory constructor for SessionConfig
  const factory SessionConfig({
    /// The set of modalities the model can respond with. To disable audio, set this to ["text"].
    @JsonKey(includeIfNull: false) List<Modality>? modalities,

    /// The default system instructions prepended to model calls.
    @JsonKey(includeIfNull: false) String? instructions,

    /// The voice the model uses to respond - one of `alloy`, `echo`,
    /// or  `shimmer`. Cannot be changed once the model has responded
    /// with audio  at least once.
    @JsonKey(
      includeIfNull: false,
      unknownEnumValue: JsonKey.nullForUndefinedEnumValue,
    )
    Voice? voice,

    /// The format of input audio. Options are "pcm16", "g711_ulaw", or "g711_alaw".
    @JsonKey(
      name: 'input_audio_format',
      includeIfNull: false,
      unknownEnumValue: JsonKey.nullForUndefinedEnumValue,
    )
    AudioFormat? inputAudioFormat,

    /// The format of output audio. Options are "pcm16", "g711_ulaw", or "g711_alaw".
    @JsonKey(
      name: 'output_audio_format',
      includeIfNull: false,
      unknownEnumValue: JsonKey.nullForUndefinedEnumValue,
    )
    AudioFormat? outputAudioFormat,

    /// Configuration for input audio transcription. Can be set to null to turn off.
    @JsonKey(name: 'input_audio_transcription', includeIfNull: false)
    InputAudioTranscriptionConfig? inputAudioTranscription,

    /// Configuration for turn detection.
    @JsonKey(name: 'turn_detection', includeIfNull: false)
    TurnDetection? turnDetection,

    /// Tools (functions) available to the model.
    @JsonKey(includeIfNull: false) List<ToolDefinition>? tools,

    /// How the model chooses tools.
    @_SessionConfigToolChoiceConverter()
    @JsonKey(name: 'tool_choice', includeIfNull: false)
    SessionConfigToolChoice? toolChoice,

    /// Sampling temperature for the model.
    @JsonKey(includeIfNull: false) double? temperature,

    /// Maximum number of output tokens for a single assistant response, inclusive of tool calls. Defaults to "inf".
    @_SessionConfigMaxResponseOutputTokensConverter()
    @JsonKey(name: 'max_response_output_tokens', includeIfNull: false)
    SessionConfigMaxResponseOutputTokens? maxResponseOutputTokens,
  }) = _SessionConfig;

  /// Object construction from a JSON representation
  factory SessionConfig.fromJson(Map<String, dynamic> json) =>
      _$SessionConfigFromJson(json);

  /// List of all property names of schema
  static const List<String> propertyNames = [
    'modalities',
    'instructions',
    'voice',
    'input_audio_format',
    'output_audio_format',
    'input_audio_transcription',
    'turn_detection',
    'tools',
    'tool_choice',
    'temperature',
    'max_response_output_tokens'
  ];

  /// Perform validations on the schema property values
  String? validateSchema() {
    return null;
  }

  /// Map representation of object (not serialized)
  Map<String, dynamic> toMap() {
    return {
      'modalities': modalities,
      'instructions': instructions,
      'voice': voice,
      'input_audio_format': inputAudioFormat,
      'output_audio_format': outputAudioFormat,
      'input_audio_transcription': inputAudioTranscription,
      'turn_detection': turnDetection,
      'tools': tools,
      'tool_choice': toolChoice,
      'temperature': temperature,
      'max_response_output_tokens': maxResponseOutputTokens,
    };
  }
}

// ==========================================
// ENUM: SessionConfigToolChoiceMode
// ==========================================

/// `none` means the model will not call any tool and instead generates a message. `auto` means the model can pick between generating a message or calling one or more tools. `required` means the model must call one or more tools.
enum SessionConfigToolChoiceMode {
  @JsonValue('none')
  none,
  @JsonValue('auto')
  auto,
  @JsonValue('required')
  required,
}

// ==========================================
// CLASS: SessionConfigToolChoice
// ==========================================

/// How the model chooses tools.
@freezed
sealed class SessionConfigToolChoice with _$SessionConfigToolChoice {
  const SessionConfigToolChoice._();

  /// `none` means the model will not call any tool and instead generates a message. `auto` means the model can pick between generating a message or calling one or more tools. `required` means the model must call one or more tools.
  const factory SessionConfigToolChoice.mode(
    SessionConfigToolChoiceMode value,
  ) = SessionConfigToolChoiceEnumeration;

  /// No Description
  const factory SessionConfigToolChoice.toolChoiceForced(
    ToolChoiceForced value,
  ) = SessionConfigToolChoiceToolChoiceForced;

  /// Object construction from a JSON representation
  factory SessionConfigToolChoice.fromJson(Map<String, dynamic> json) =>
      _$SessionConfigToolChoiceFromJson(json);
}

/// Custom JSON converter for [SessionConfigToolChoice]
class _SessionConfigToolChoiceConverter
    implements JsonConverter<SessionConfigToolChoice?, Object?> {
  const _SessionConfigToolChoiceConverter();

  @override
  SessionConfigToolChoice? fromJson(Object? data) {
    if (data == null) {
      return null;
    }
    if (data is String &&
        _$SessionConfigToolChoiceModeEnumMap.values.contains(data)) {
      return SessionConfigToolChoiceEnumeration(
        _$SessionConfigToolChoiceModeEnumMap.keys.elementAt(
          _$SessionConfigToolChoiceModeEnumMap.values.toList().indexOf(data),
        ),
      );
    }
    if (data is Map<String, dynamic>) {
      try {
        return SessionConfigToolChoiceToolChoiceForced(
          ToolChoiceForced.fromJson(data),
        );
      } catch (e) {}
    }
    throw Exception(
      'Unexpected value for SessionConfigToolChoice: $data',
    );
  }

  @override
  Object? toJson(SessionConfigToolChoice? data) {
    return switch (data) {
      SessionConfigToolChoiceEnumeration(value: final v) =>
        _$SessionConfigToolChoiceModeEnumMap[v]!,
      SessionConfigToolChoiceToolChoiceForced(value: final v) => v.toJson(),
      null => null,
    };
  }
}

// ==========================================
// CLASS: SessionConfigMaxResponseOutputTokens
// ==========================================

/// Maximum number of output tokens for a single assistant response, inclusive of tool calls. Defaults to "inf".
@freezed
sealed class SessionConfigMaxResponseOutputTokens
    with _$SessionConfigMaxResponseOutputTokens {
  const SessionConfigMaxResponseOutputTokens._();

  /// Provide an integer between 1 and 4096 to limit output tokens.
  const factory SessionConfigMaxResponseOutputTokens.int(
    int value,
  ) = SessionConfigMaxResponseOutputTokensInt;

  /// Use inf for the maximum available tokens for a given model.
  const factory SessionConfigMaxResponseOutputTokens.string(
    String value,
  ) = SessionConfigMaxResponseOutputTokensString;

  /// Object construction from a JSON representation
  factory SessionConfigMaxResponseOutputTokens.fromJson(
          Map<String, dynamic> json) =>
      _$SessionConfigMaxResponseOutputTokensFromJson(json);
}

/// Custom JSON converter for [SessionConfigMaxResponseOutputTokens]
class _SessionConfigMaxResponseOutputTokensConverter
    implements JsonConverter<SessionConfigMaxResponseOutputTokens?, Object?> {
  const _SessionConfigMaxResponseOutputTokensConverter();

  @override
  SessionConfigMaxResponseOutputTokens? fromJson(Object? data) {
    if (data == null) {
      return null;
    }
    if (data is int) {
      return SessionConfigMaxResponseOutputTokensInt(data);
    }
    if (data is String) {
      return SessionConfigMaxResponseOutputTokensString(data);
    }
    throw Exception(
      'Unexpected value for SessionConfigMaxResponseOutputTokens: $data',
    );
  }

  @override
  Object? toJson(SessionConfigMaxResponseOutputTokens? data) {
    return switch (data) {
      SessionConfigMaxResponseOutputTokensInt(value: final v) => v,
      SessionConfigMaxResponseOutputTokensString(value: final v) => v,
      null => null,
    };
  }
}