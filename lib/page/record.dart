import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';

class Record extends StatefulWidget {
  final String spreadId;
  final String credentials;

  Record({required this.spreadId, required this.credentials});

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  late GSheets _gsheets;
  Worksheet? _worksheet;
  List<dynamic> _headers = [];
  List<List<dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _gsheets = GSheets(widget.credentials);
    _loadData();
  }

  Future<void> _loadData() async {
    final spreadsheet = await _gsheets.spreadsheet(widget.spreadId);
    _worksheet = spreadsheet.worksheetByTitle('jVibes2');
    _headers = (await _worksheet?.values.row(1))!.cast<dynamic>();
    _data = (await _worksheet?.values.allRows())!.cast<List<dynamic>>();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    // Use the spreadId and credentials in this page
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction'),
      ),
      body: _buildDataTable(),
    );
  }

 Widget _buildDataTable() {
  if (_data.isEmpty) {
    return Center(child: CircularProgressIndicator());
  } else {
    // Remove the first row from the data
    final List<List<dynamic>> dataWithoutHeader = _data.sublist(1);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: _headers.map((header) => DataColumn(label: Text(header.toString()))).toList(),
          rows: dataWithoutHeader.map((row) {
            final cells = List<DataCell>.generate(
              _headers.length,
              (index) {
                final cellData = row.length > index ? row[index] : '';
                if (index == 0) {
                  // Process the data in the first column (index 0) as a date-time
                  final dateTimeValue = _parseDateTime(cellData.toString());
                  return DataCell(
                    Text(_formatDateTime(dateTimeValue)),
                  );
                } else {
                  // For other columns, just display the data as is
                  return DataCell(
                    Text(cellData.toString()),
                  );
                }
              },
            );
            return DataRow(cells: cells);
          }).toList(),
        ),
      ),
    );
  }
}

DateTime? _parseDateTime(String data) {
  try {
    final numericValue = double.tryParse(data);
    if (numericValue != null) {
      // Convert the numeric value to a DateTime by adding days to the reference date (December 30, 1899)
      final referenceDate = DateTime(1899, 12, 30);
      final days = numericValue.toInt();
      final fraction = numericValue - days;
      final milliseconds = (fraction * 24 * 60 * 60 * 1000).round();
      final result = referenceDate.add(Duration(days: days, milliseconds: milliseconds));
      return result;
    }
  } catch (e) {
    // Handle parsing errors
  }
  return null; // Return null if parsing fails
}


String _formatDateTime(DateTime? dateTime) {
  // Format the DateTime as a string, e.g., 'yyyy-MM-dd HH:mm:ss'
  if (dateTime != null) {
    final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    return formattedDateTime;
  }
  return ''; // Return an empty string if the DateTime is null
}



}
