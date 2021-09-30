import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:turunify/data/model/measurement.dart';
import 'package:turunify/data/repo/measurement_repo.dart';
import 'package:turunify/util/shared_pref_service.dart';

part 'on_boarding_event.dart';

part 'on_boarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final MeasurementRepository measurementRepository;

  OnBoardingBloc({@required this.measurementRepository})
      : super(OnBoardingOpenedState());

  @override
  Stream<OnBoardingState> mapEventToState(OnBoardingEvent event) async* {
    if (event is AddedWeightUnit) {
      yield* _mapAddedWeightUnitToState(event, state);
    } else if (event is AddedStartWeight) {
      yield* _mapAddedStartWeightToState(event, state);
    } else if (event is AddedWeightGoal) {
      yield* _mapAddedWeightGoalToState(event, state);
    }
  }

  Stream<OnBoardingState> _mapAddedWeightUnitToState(
      AddedWeightUnit event, OnBoardingState state) async* {
    final sharedPrefService = await SharedPreferencesService.instance;

    sharedPrefService.setWeightUnitType(event.weightUnit);
  }

  Stream<OnBoardingState> _mapAddedStartWeightToState(
      AddedStartWeight event, OnBoardingState state) async* {
    final sharedPrefService = await SharedPreferencesService.instance;

    sharedPrefService.setStartWeight(double.parse(event.startWeight));

    Box _weightInfo = await Hive.openBox('weightInfo');
    _weightInfo.add(MeasurementModel(
        DateTime.now(), double.parse(event.startWeight.replaceAll(',', '.'))));
  }

  Stream<OnBoardingState> _mapAddedWeightGoalToState(
      AddedWeightGoal event, OnBoardingState state) async* {
    final sharedPrefService = await SharedPreferencesService.instance;

    sharedPrefService
        .setTargetWeight(double.parse(event.targetWeight.replaceAll(',', '.')));

    sharedPrefService.setOnBoardingSeenBefore(true);

    yield OnBoardingFinished();
  }
}
