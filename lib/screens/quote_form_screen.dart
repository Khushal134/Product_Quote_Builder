import 'package:flutter/material.dart';
import 'package:quote_builder/models/client.dart';
import 'package:quote_builder/models/line_item.dart';
import 'package:quote_builder/screens/quote_preview_screen.dart';
import 'package:quote_builder/widgets/client_info_form.dart';
import 'package:quote_builder/widgets/line_item_form.dart';

class QuoteFormScreen extends StatefulWidget {
  const QuoteFormScreen({super.key});

  @override
  State<QuoteFormScreen> createState() => _QuoteFormScreenState();
}

class _QuoteFormScreenState extends State<QuoteFormScreen> {
  Client client = Client();
  List<LineItem> lineItems = [LineItem()]; // Start with one line item

  double get subtotal {
    // sum of all items
    return lineItems.fold(0.0, (sum, item) => sum + item.total);
  }

  double get grandTotal {
    // Grand total calculation will be the same as subtotal initially
    // (If tax-inclusive/exclusive logic is added, this might change)
    return subtotal;
  }

  void _addLineItem() {
    setState(() {
      lineItems.add(LineItem());
    });
  }

  void _removeLineItem(int index) {
    setState(() {
      if (lineItems.length > 1) {
        lineItems.removeAt(index);
      } else {
        // Optionally, clear the existing line item if it's the last one
        lineItems[0] = LineItem();
      }
    });
  }

  void _navigateToPreview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuotePreviewScreen(
          client: client,
          lineItems: lineItems,
          subtotal: subtotal,
          grandTotal: grandTotal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[200],
        centerTitle: true,
        title: const Text('Product Quote Builder'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ClientInfoForm(
              client: client,
              onChanged: (updatedClient) {
                setState(() {
                  client = updatedClient;
                });
              },
            ),
            const SizedBox(height: 30),
            Text('Line Items',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Important for nested scrollables
              itemCount: lineItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: LineItemForm(
                    lineItem: lineItems[index],
                    onChanged: (updatedItem) {
                      setState(() {
                        lineItems[index] = updatedItem;
                      });
                    },
                    onRemove: () => _removeLineItem(index),
                    showRemoveButton:
                        lineItems.length > 1, // Only show if more than one item
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _addLineItem,
                icon: const Icon(Icons.add),
                label: const Text('Add Line Item'),
              ),
            ),
            const SizedBox(height: 30),
            // Calculations Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal:',
                    style: Theme.of(context).textTheme.titleLarge),
                Text('\$${subtotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Grand Total:',
                    style: Theme.of(context).textTheme.headlineMedium),
                Text('\$${grandTotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
            const SizedBox(height: 30),
            // Preview Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _navigateToPreview,
                label: Text("View Quote Preview"),
                icon: Icon(Icons.preview),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
