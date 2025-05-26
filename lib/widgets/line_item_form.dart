import 'package:flutter/material.dart';
import 'package:quote_builder/models/line_item.dart';

class LineItemForm extends StatefulWidget {
  final LineItem lineItem;
  final ValueChanged<LineItem> onChanged;
  final VoidCallback onRemove;
  final bool showRemoveButton;

  const LineItemForm({
    super.key,
    required this.lineItem,
    required this.onChanged,
    required this.onRemove,
    this.showRemoveButton = true,
  });

  @override
  State<LineItemForm> createState() => _LineItemFormState();
}

class _LineItemFormState extends State<LineItemForm> {
  late TextEditingController _productNameController;
  late TextEditingController _quantityController;
  late TextEditingController _rateController;
  late TextEditingController _discountController;
  late TextEditingController _taxRateController;

  @override
  void initState() {
    super.initState();
    _productNameController =
        TextEditingController(text: widget.lineItem.productName);
    _quantityController =
        TextEditingController(text: widget.lineItem.quantity.toString());
    _rateController =
        TextEditingController(text: widget.lineItem.rate.toStringAsFixed(2));
    _discountController = TextEditingController(
        text: widget.lineItem.discount.toStringAsFixed(2));
    _taxRateController =
        TextEditingController(text: widget.lineItem.taxRate.toStringAsFixed(2));

    _productNameController.addListener(_updateLineItem);
    _quantityController.addListener(_updateLineItem);
    _rateController.addListener(_updateLineItem);
    _discountController.addListener(_updateLineItem);
    _taxRateController.addListener(_updateLineItem);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    _rateController.dispose();
    _discountController.dispose();
    _taxRateController.dispose();
    super.dispose();
  }

  void _updateLineItem() {
    widget.onChanged(LineItem(
      productName: _productNameController.text,
      quantity: int.tryParse(_quantityController.text) ?? 0,
      rate: double.tryParse(_rateController.text) ?? 0.0,
      discount: double.tryParse(_discountController.text) ?? 0.0,
      taxRate: double.tryParse(_taxRateController.text) ?? 0.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _productNameController,
                    decoration:
                        const InputDecoration(labelText: 'Product/Service'),
                  ),
                ),
                if (widget.showRemoveButton) ...[
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.onRemove,
                  ),
                ],
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _rateController,
                    decoration: const InputDecoration(labelText: 'Rate'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _discountController,
                    decoration:
                        const InputDecoration(labelText: 'Discount (optional)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _taxRateController,
                    decoration: const InputDecoration(labelText: 'Tax %'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Item Total: \$${widget.lineItem.total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
