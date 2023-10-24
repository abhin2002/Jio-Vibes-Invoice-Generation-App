import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generate_pdf/helper/pdf_helper.dart';
import 'package:generate_pdf/helper/pdf_invoice_helper.dart';
import 'package:generate_pdf/main.dart';
import 'package:generate_pdf/model/customer.dart';
import 'package:generate_pdf/model/invoice.dart';
import 'package:generate_pdf/model/supplier.dart';
import 'package:generate_pdf/widget/button_widget.dart';
import 'package:generate_pdf/widget/title_widget.dart';
import 'package:gsheets/gsheets.dart';
import 'record.dart'; // Import the new page

const _credentials = r'''
{
  "type": "service_account",
  "project_id": "vibes-387319",
  "private_key_id": "1218cd57864fdbd118607580b936217f5b2005dd",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDNU0+oAkxbsnak\ng3NRI8i6IU+8ZP6Of2Cv10Adesdu9kkGMzeW7KOaQb0Vi94n5tED1gux2LLGBiCj\nSl5fPYRj8GI4t6rGaVGgI4i3B+5BtcuNCvC63sdqDBic+w6viEjsE7VXoReLXdFL\nV8ogJbJSlVhDQvzP+1HM47Hr80d4lgwprZvVtuQgb1kgyYyj6H6dKV31GozlOZ4a\n57MLsfBSAihMibdpZbWSmrjJ9UTWzkverD4fjIgRDOGT8R0JhTRCNeux8Zq7zqzB\n/mVF7KXwIKENl7bGQ3NqF6f8OGHn2Z+mWN00Hxvh1Hr9pW26WqEqNblRkLkGVvNO\n/72OVdNHAgMBAAECggEADBqCtpRGY8H6tnOq+dyATDwDUyK6rjQHwzXYICS//uRi\npVWiJx+VanqcJrVuvq8fjtPneEtndnXEAnwzYWR1Y5USd3iY0CJDOouP+72O8Paw\nEhdmS3JT7iraYAMvipP7YHvSpheeOdUXQBNRd6o8pBufE6JAju4V3aVl6y6ntKAX\ngm21xnHqqSi31K7zBtfeeqc53yX5pDrOfAw7p/YCBqSXmfiMhZH6lCTctTmFnw7t\nwcfA36RBDmbUlq7DodoRPkToOnu0xH/3aeU8EJK4fiSJkWZnwnRfH9CBTUTEgdcF\newIROGxntixG6RdnuZ7xHSp9HM0kYOdXQeR0gf7HoQKBgQD0GRBtMFFD7E/d7Eqc\n8n9V5jdb6lPY44rcnk48z6CadIKrdWQXPfaqJvt/MHDzbPGowuQkaw7nftY+2tGM\nXsMNGTYDTlxFSvPovekP2hihXQuBzKcqqYd10Jc1JCIa5rPWdTVrEZoVUApevqoD\nm6PbY2edvneVnCN9uHm6rwqgdwKBgQDXVkWuIR1rI67hCXd3s32mwOxtBokx5WyT\nf8U+opLCzw8CtJWqcTmMr3xeuwqGJAxtJBGcbcmC0nW/sbdUHe/oQxHStqVabOpL\n28oKX/PeMoOClE/h4xz0W4fkFjXfROuhqIVXe5hMvlbSquqCngfhHi2O1lcTF3u0\nqoavajtnsQKBgQCxcGbYeH8aePW1xMaYQE8AClHDpxs8Vmvi49DLs8JzhK5YJQWV\nP53HIn8/fd8dlNw2aTWeo5Q6A6GKH1akS15Obz0sOhIo7MtRLHv24ft1kUWEHViH\nUqT9p5vDLXj9RScFhj5Gjo0LYRuos8CyzrjWCfSQXpxfTRkfkrIqWoPHEQKBgQC4\n//V9VBXiJhXoYCmzPRGGYdi9EhBsPZ66WdsrpKBRnXJX8K1kcUHwDBPdjvPLqszC\nN2qp6ehl7EodFqFaMx4ZfQWi8ie9ODVSVtGNeEIbc2polOLMPkJx7PEik7JUzvFh\nQVbNgfGmfSA6fXxcG0jJrxOU07CbRmGRJa/wpGPFAQKBgQDmJU/lMzGLSYLhsQfl\nyBt0mUZ2Yp4Tfd1ttIN66dnaMz3RkATEDIngh14e1R+jaO2ZJuad4n4ixnk+ao+N\nweR/vvSPOiCRXAKIi0ulDscfWFbBzHuGql7Epz6pCE2Y2cOKF8/Wpn00cScCHRT6\nIBg8XK+xcTGNwBETFldohdcehQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "vibes-attendance-app@vibes-387319.iam.gserviceaccount.com",
  "client_id": "108811484370089265341",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/vibes-attendance-app%40vibes-387319.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

''';

const _spreadSheetId = '1Z3pyd8D1YlFun-VRYPita556mJtDAy1TuKICjmTPI0g';

class PdfPage extends StatefulWidget {
  const PdfPage({super.key});

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {

  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerAmountController = TextEditingController();
  final TextEditingController debitController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  double customerAmount = 0;
  double debit= 0;
  String? selectedDropdownValue; // Initialize this variable
  String? remark;
  final _formKey = GlobalKey<FormState>();

  Future<void> connectToGoogleSheets() async {

  final gsheets = GSheets(_credentials);
  final ss = await gsheets.spreadsheet(_spreadSheetId);
  var sheet = ss.worksheetByTitle('jVibes2');

  var date = DateTime.now();
  var Cr_Ledger = selectedDropdownValue;
  var amount = customerAmount;
  var debitamount = debit;
  var remarkItem = remark;

  // Create a list with the values to insert
  final valuesToInsert = [date.toString(), Cr_Ledger.toString(), amount.toString(), debitamount.toString(), remarkItem.toString()];

  // Insert an empty row above the second row
  await sheet?.insertRow(2);

  // Now, insert your data into the second row
  await sheet?.values.insertRow(2, valuesToInsert);
}

  // Define the dropdown items
  List<String> crLedgerOptions = [
    '5G HUB MOBILE&ELECTRONICS (662300287)',
    'AFFA COMMUNICATION 2 (662520120)',
    'AMBASSADOR PRABHASH (661788503)',
    'BROTHERS (662580716)',
    'CELL CARE (661039481)',
    'CELL4U (660807523)',
    'CH STORE (66230551)',
    'CK COLLECTION (660809178)',
    'CLASSIC COMMUNICATIONS (660251833)',
    'CONNECT MOBILE 2 (662367848)',
    'DILU STORE (662542802)',
    'FALCON MOBILE (662015071)',
    'FATHIMA MOBILES (662007488)',
    'FONE CARE (662164729)',
    'GR MOBILE (662382835)',
    'GULF BAZAR MOBILE (662199709)',
    'INDEX ELECTRONICS (660921730)',
    'INTECH (660277289)',
    'INTIMATE ONLINE PAYWORLD',
    'IZZA MOBILES (662476223)',
    'JAMNAS MALAYAN KANDY (661930131)',
    'KAIRALI STORE (661648341)',
    'KK STORE EDACHERY (662526478)',
    'MADEENA MOBILES (662477790)',
    'MOBI TIME (661157789)',
    'MOBI TIME NEW (662214598)',
    'MOBI TIME THALAYI (662085996)',
    'MOBILE CORNER (661627562)',
    'MOBILE FRIENDS (660254493)',
    'MS COMMUNICATION (660229766)',
    'MUHAMMAD ASHID N (662340336)',
    'NICE MOBILE (660511753)',
    'NILAVARA (662451179)',
    'PADMATHEERTHAM (662587088)',
    'PAGE FOR YOUTH PAYWORLD',
    'PERFECT COMMUNICATION (660295590)',
    'PERFECT COMMUNICATION 2 (662085964)',
    'PHEONIX (660277290)',
    'PHOENIX CELL (660295876)',
    'PLANET MOBILE (662288513)',
    'PLUS MOBILE (661703930)',
    'PLUS MOBILE (662339649)',
    'PM ONLINE PAYWORLD',
    'PRABEESSH (661926572)',
    'RAJAN MOBILES (661632152)',
    'REGAL (662577078)',
    'RING TONES MUKKALI (660277522)',
    'SAI ELECTRONICS (662311503)',
    'SELFIE MOBILE (660710199)',
    'SELFIE MOBILES (661162064)',
    'SHIBIL P K (661996458)',
    'SIVADAS K T K (662550909)',
    'SP ENTERPRISES (662210979)',
    'SREE COMMUNICATIONS (661627834)',
    'SS MOBI CARE (662512077)',
    'SWATHI MOBILES (660254509)',
    'TECHNO (6621180610)',
    'TECHNO MOBILES (660036837)',
    'TECHNO MOBILES 2 (661721529)',
    'THALLA MOBILE (662407168)',
    'THUSHARA (660277288)',
    'ZAHARE 3(660450976)',
    'ZERO MAX (660887284)'

    // Add more options as needed
  ];


  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color.fromARGB(66, 196, 194, 194),
        appBar: AppBar(
          title: const Text(MyApp.title),
          centerTitle: true,
          actions: [
          IconButton(
            icon: Icon(Icons.history), // Replace with the desired icon
  
            onPressed: () {
              Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Record(
              spreadId: _spreadSheetId,
              credentials: _credentials,
            ),
          ),
        );
            },
          ),
        ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Center(child: Form( // Wrap your form with a Form widget and use the form key
              key: _formKey,
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TitleWidget(
                  icon: Icons.picture_as_pdf,
                  text: 'Generate Invoice',
                ),
                // User Input Fields
                // Dropdown Menu
                DropdownButtonFormField<String>(
                  value: selectedDropdownValue,
                  items: crLedgerOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedDropdownValue = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Cr Ledger',
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.red),
                  ),
                  style: TextStyle(color: Colors.red),
                  validator: (value) {
                    if (value == null) {
                      return 'Cr Ledger is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16), // Added some spacing
                TextFormField(
                  controller: customerAmountController,
                  decoration: InputDecoration(
                    labelText: 'Credit',
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.red),
                  ),
                  style: TextStyle(color: Colors.red),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Credit is required';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16), // Added some spacing
                TextFormField(
                  controller: debitController,
                  decoration: InputDecoration(
                    labelText: 'Debit',
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.red),
                  ),
                  style: TextStyle(color: Colors.red),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Debit is required';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16), // Added some spacing
                TextFormField(
                  controller: remarkController,
                  decoration: InputDecoration(
                    labelText: 'Remark',
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.red),
                  ),
                  style: TextStyle(color: Colors.red),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Remark is required';
                    }
                    return null;
                  },
                  
                ),
                

                const SizedBox(height: 48),
                ButtonWidget(
                  text: 'Get PDF',
                  onClicked: () async {
                    if (_formKey.currentState!.validate()) {
                    connectToGoogleSheets();
                    final date = DateTime.now();
                    // final dueDate = date.add(
                    //   const Duration(days: 7),
                    // );
                    // Parse the customerAmountController.text to a double
                    customerAmount = double.tryParse(customerAmountController.text)!;
                    debit = double.tryParse(debitController.text)!;
                    remark = remarkController.text;



                    final invoice = Invoice(
                      supplier: const Supplier(
                        name: 'GSTIN : 32AVAPV4356P1Z2',
                        address: 'MOB : 7034386224',
                        paymentInfo: 'https://paypal.me/codespec',
                      ),
                      customer: const Customer(
                        name: '13/19, 1st FLOOR, GATEWAY COMPLEX,',
                        address: 'BALAVADI, KAINATTY,VADAKARA-673102',
                      ),
                      info: InvoiceInfo(
                        date: date,
                        description: 'RECEIPT VOUCHER',
                        number: '${DateTime.now().year}-9999',
                      ),
                      items: [
                        InvoiceItem(
                          description: selectedDropdownValue!,
                          date: DateTime.now(),
                          quantity: 0,
                          vat: 0.19,
                          unitPrice: customerAmount,
                        ),
                       
                      ],
                    );

                    final pdfFile = await PdfInvoicePdfHelper.generate(invoice);

                    PdfHelper.openFile(pdfFile);

                    customerNameController.clear();
                    customerAmountController.clear();
                    debitController.clear();
                    remarkController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
  ));
      @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    customerNameController.dispose();
    customerAmountController.dispose();
    super.dispose();
  }
}
