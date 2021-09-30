import 'dart:io';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:turunify/data/model/measurement.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:turunify/data/repo/measurement_repo.dart';
import 'package:turunify/util/shared_pref_service.dart';
import 'package:share_plus/share_plus.dart';

class ExportHandler {
  static generateExcel(List<MeasurementModel> allMeasurements,
      MeasurementModel currentWeight, double targetWeight) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    var excel = Excel.createExcel();

    var sheet = excel.sheets.values.first;

    sheet.appendRow(["turunify"]);
    sheet.appendRow(["MEASUREMENTS EXPORT"]);
    sheet.appendRow([""]);
    sheet.appendRow([
      "Print date: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}"
    ]);
    sheet.appendRow(["Current Weight: ${currentWeight.weightEntry} kg"]);
    sheet.appendRow(["Target Weight: ${targetWeight.toString()} kg"]);
    sheet.appendRow([""]);
    sheet.appendRow([""]);
    sheet.appendRow(["Date", "Weight"]);

    allMeasurements.forEach((element) {
      sheet.appendRow([
        "${element.dateAdded.year}-${element.dateAdded.month}-${element.dateAdded.day}",
        element.weightEntry
      ]);
    });

    String dir = (await getExternalStorageDirectory()).path +
        "/measurements-${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}--${DateTime.now().minute}.${DateTime.now().second}.xlsx";

    var fileBytes = excel.save();

    File excelFile = File(join(dir))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);

    await Share.shareFiles([dir]);

    excelFile.delete();
  }
}
