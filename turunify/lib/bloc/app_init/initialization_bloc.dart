import 'dart:async';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:turunify/data/model/measurement.dart';
import 'package:turunify/util/shared_pref_service.dart';

part 'initialization_event.dart';

part 'initialization_state.dart';

class InitializationBloc
    extends Bloc<InitializationEvent, InitializationState> {
  InitializationBloc() : super(InitStarted());

  @override
  Stream<InitializationState> mapEventToState(
      InitializationEvent event) async* {
    if (event is InitializeApp) {
      yield* _mapInitializeAppEventToState();
    } else if (event is FinishOnBoarding) {
      yield* _mapOnBoardingFinishedEventToState();
    }
  }

  Stream<InitializationState> _mapInitializeAppEventToState() async* {
    await Future.delayed(Duration(seconds: 1));

    final sharedPrefService = await SharedPreferencesService.instance;
    final onBoardingSeenBefore = sharedPrefService.getOnBoardingSeenBefore;

    await Hive.initFlutter();
    Hive.registerAdapter(MeasurementModelAdapter());

    if (onBoardingSeenBefore == null) {
      yield Uninitialized();
    } else if (onBoardingSeenBefore == false) {
      yield Uninitialized();
    } else if (onBoardingSeenBefore == true) {
      yield Initialized();
    }
  }

  Stream<InitializationState> _mapOnBoardingFinishedEventToState() async* {
    final sharedPrefService = await SharedPreferencesService.instance;
    final onBoardingSeenBefore = sharedPrefService.getOnBoardingSeenBefore;

    if (onBoardingSeenBefore == null) {
      yield Uninitialized();
    } else if (onBoardingSeenBefore == false) {
      yield Uninitialized();
    } else if (onBoardingSeenBefore == true) {
      yield Initialized();
    }
  }
}
