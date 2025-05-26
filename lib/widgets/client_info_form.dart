import 'package:flutter/material.dart';
import 'package:quote_builder/models/client.dart';

class ClientInfoForm extends StatefulWidget {
  final Client client;
  final ValueChanged<Client> onChanged;

  const ClientInfoForm({
    super.key,
    required this.client,
    required this.onChanged,
  });

  @override
  State<ClientInfoForm> createState() => _ClientInfoFormState();
}

class _ClientInfoFormState extends State<ClientInfoForm> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _referenceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.name);
    _addressController = TextEditingController(text: widget.client.address);
    _referenceController = TextEditingController(text: widget.client.reference);

    _nameController.addListener(_updateClient);
    _addressController.addListener(_updateClient);
    _referenceController.addListener(_updateClient);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  void _updateClient() {
    widget.onChanged(Client(
      name: _nameController.text,
      address: _addressController.text,
      reference: _referenceController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Client Name'),
        ),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(labelText: 'Address'),
        ),
        TextFormField(
          controller: _referenceController,
          decoration: const InputDecoration(labelText: 'Reference'),
        ),
      ],
    );
  }
}