import 'package:freezed_annotation/freezed_annotation.dart';

part 'demo_bloc_state.freezed.dart';

@freezed
abstract class DemoBlocState with _$DemoBlocState {
  const factory DemoBlocState({
    @Default(false) bool isLoading,
    @Default([]) List<String> list,
    @Default("") String msg,
  }) = _DemoBlocState;
}
