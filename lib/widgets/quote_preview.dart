import 'package:flutter/material.dart';
import 'package:quote_builder/models/client.dart';
import 'package:quote_builder/models/line_item.dart';

class QuotePreview extends StatelessWidget {
  final Client client;
  final List<LineItem> lineItems;
  final double subtotal;
  final double grandTotal;

  const QuotePreview({
    super.key,
    required this.client,
    required this.lineItems,
    required this.subtotal,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quote for:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text('Client: ${client.name}'),
            Text('Address: ${client.address}'),
            Text('Reference: ${client.reference}'),
            const Divider(height: 30),
            Text(
              'Detailed Items:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1.5),
              },
              border: TableBorder.all(color: Colors.grey.shade300),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  children: const [
                    Padding(padding: EdgeInsets.all(8.0), child: Text('Product/Service', style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8.0), child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8.0), child: Text('Rate', style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8.0), child: Text('Disc', style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8.0), child: Text('Tax %', style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8.0), child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                ...lineItems.map((item) => TableRow(
                  children: [
                    Padding(padding: const EdgeInsets.all(8.0), child: Text(item.productName)),
                    Padding(padding: const EdgeInsets.all(8.0), child: Text(item.quantity.toString())),
                    Padding(padding: const EdgeInsets.all(8.0), child: Text(item.rate.toStringAsFixed(2))),
                    Padding(padding: const EdgeInsets.all(8.0), child: Text(item.discount.toStringAsFixed(2))),
                    Padding(padding: const EdgeInsets.all(8.0), child: Text('${item.taxRate.toStringAsFixed(2)}%')),
                    Padding(padding: const EdgeInsets.all(8.0), child: Text(item.total.toStringAsFixed(2))),
                  ],
                )).toList(),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
                  Text(
                    'Grand Total: \$${grandTotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}