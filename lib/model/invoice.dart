import 'package:generate_pdf/model/customer.dart';
import 'package:generate_pdf/model/supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime? dueDate;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    this.dueDate,
  });
}

class InvoiceItem {
  final String description;
  final DateTime? date;
  final int? quantity;
  final double? vat;
  final double unitPrice;

  const InvoiceItem({
    required this.description,
     this.date,
     this.quantity,
     this.vat,
    required this.unitPrice,
  });
}
