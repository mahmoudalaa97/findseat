import 'package:find_seat/model/repo/user_repository.dart';
import 'package:find_seat/presentation/screen/login/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:find_seat/utils/validators.dart';
import 'package:flutter/material.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository? _userRepository;

  LoginBloc({required UserRepository? userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository, super(LoginState.empty());

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<Transition<LoginEvent,LoginState>> transformEvents( events,Stream<Transition<LoginEvent,LoginState>> Function(LoginEvent) next) {



    return super.transformEvents(
      events.distinct(),
      next,
    );
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginSubmitEmailPasswordEvent) {
      yield* _mapLoginSubmitEmailPasswordEventToState(
          event.email, event.password);
    } else if (event is LoginEmailChanged) {
      yield* _mapLoginEmailChangedToState(event.email);
    } else if (event is LoginPasswordChanged) {
      yield* _mapLoginPasswordChangedToState(event.password);
    }
  }

  Stream<LoginState> _mapLoginSubmitEmailPasswordEventToState(
      String email, String password) async* {
    try {
      yield LoginState.loading();

      await _userRepository!.signInWithCredentials(email, password);
      bool isSignedIn = await _userRepository!.isSignedIn();

      if (isSignedIn) {
        yield LoginState.success();
      } else {
        yield LoginState.failure();
      }
    } catch (e) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapLoginEmailChangedToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<LoginState> _mapLoginPasswordChangedToState(String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password));
  }
}
