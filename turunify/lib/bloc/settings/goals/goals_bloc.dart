import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:turunify/data/model/measurement.dart';
import 'package:turunify/data/repo/measurement_repo.dart';
import 'package:turunify/util/shared_pref_service.dart';

part 'goals_event.dart';

part 'goals_state.dart';

class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  final MeasurementRepository measurementRepository;

  GoalsBloc({this.measurementRepository}) : super(GoalsOpened());

  @override
  Stream<GoalsState> mapEventToState(GoalsEvent event) async* {
    if (event is GoalsStarted) {
      yield* _mapGoalsStartedToState();
    } else if (event is ChangeStartWeight) {
      yield* _mapChangeStartWeightToState(event.startWeight);
    } else if (event is ChangeTargetWeight) {
      yield* _mapChangeTargetWeightToState(event.targetWeight);
    }
  }

  Stream<GoalsState> _mapGoalsStartedToState() async* {
    yield GoalsLoading();

    final sharedPrefService = await SharedPreferencesService.instance;
    double startWeight = sharedPrefService.getStartWeight;
    String startWeightDate = sharedPrefService.getStartWeightDate;
    double targetWeight = sharedPrefService.getTargetWeight;
    String targetWeightDate = sharedPrefService.getTargetWeightDate;

    yield GoalsLoaded(
        startWeight: startWeight,
        startWeightDate: startWeightDate,
        targetWeight: targetWeight,
        targetWeightDate: targetWeightDate);
  }

  Stream<GoalsState> _mapChangeStartWeightToState(
      String newStartWeight) async* {
    final sharedPrefService = await SharedPreferencesService.instance;
    sharedPrefService
        .setStartWeight(double.parse(newStartWeight.replaceAll(',', '.')));

    yield GoalsLoading();

    double startWeight = sharedPrefService.getStartWeight;
    String startWeightDate = sharedPrefService.getStartWeightDate;
    double targetWeight = sharedPrefService.getTargetWeight;
    String targetWeightDate = sharedPrefService.getTargetWeightDate;

    yield GoalsLoaded(
        startWeight: startWeight,
        startWeightDate: startWeightDate,
        targetWeight: targetWeight,
        targetWeightDate: targetWeightDate);
  }

  Stream<GoalsState> _mapChangeTargetWeightToState(
      String newTargetWeight) async* {
    final sharedPrefService = await SharedPreferencesService.instance;
    sharedPrefService
        .setTargetWeight(double.parse(newTargetWeight.replaceAll(',', '.')));

    yield GoalsLoading();

    double startWeight = sharedPrefService.getStartWeight;
    String startWeightDate = sharedPrefService.getStartWeightDate;
    double targetWeight = sharedPrefService.getTargetWeight;
    String targetWeightDate = sharedPrefService.getTargetWeightDate;

    yield GoalsLoaded(
        startWeight: startWeight,
        startWeightDate: startWeightDate,
        targetWeight: targetWeight,
        targetWeightDate: targetWeightDate);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
