import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quote_builder/models/client.dart';
import 'package:quote_builder/models/line_item.dart';
import 'package:quote_builder/widgets/quote_preview.dart'; // For sharing/saving/printing PDF

class QuotePreviewScreen extends StatelessWidget {
  final Client client;
  final List<LineItem> lineItems;
  final double subtotal;
  final double grandTotal;

  const QuotePreviewScreen({
    super.key,
    required this.client,
    required this.lineItems,
    required this.subtotal,
    required this.grandTotal,
  });

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                'Product Quote',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Client Information:',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text('Client Name: ${client.name}'),
            pw.Text('Address: ${client.address}'),
            pw.Text('Reference: ${client.reference}'),
            pw.SizedBox(height: 20),
            pw.Text(
              'Line Items:',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.Table.fromTextArray(
              headers: [
                'Product/Service',
                'Qty',
                'Rate',
                'Disc',
                'Tax %',
                'Total',
              ],
              data: lineItems
                  .map((item) => [
                        item.productName,
                        item.quantity.toString(),
                        item.rate.toStringAsFixed(2),
                        item.discount.toStringAsFixed(2),
                        '${item.taxRate.toStringAsFixed(2)}%',
                        item.total.toStringAsFixed(2),
                      ])
                  .toList(),
              border: pw.TableBorder.all(color: PdfColors.grey),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.all(5),
            ),
            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
                  pw.Text(
                    'Grand Total: \$${grandTotal.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            // You can add more elements here like a footer, terms, etc.
          ];
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[200],
        centerTitle: true,
        title: const Text('Quote Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print), // Use a print icon for PDF actions
            onPressed: () async {
              // This opens a preview window allowing print, save, share
              await Printing.layoutPdf(onLayout: _generatePdf);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            QuotePreview(
              client: client,
              lineItems: lineItems,
              subtotal: subtotal,
              grandTotal: grandTotal,
            ),
            const SizedBox(height: 20),
            /*
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Download PDF'),
              onPressed: () async {
                try {
                  final pdfBytes = await _generatePdf(PdfPageFormat.a4);
                  final directory = await getTemporaryDirectory();
                  final file = File('${directory.path}/quote.pdf');
                  await file.writeAsBytes(pdfBytes);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PDF saved to ${file.path}')),
                  );
                  // Optionally open the file after saving
                  // await OpenFilex.open(file.path); // requires open_filex package
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving PDF: $e')),
                  );
                }
              },
            ),
            */
          ],
        ),
      ),
    );
  }
}
