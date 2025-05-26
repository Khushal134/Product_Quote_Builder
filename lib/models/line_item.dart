class LineItem {
  String productName;
  int quantity;
  double rate;
  double discount; // optional
  double taxRate; // as a percentage, e.g., 0.05 for 5%

  LineItem({
    this.productName = '',
    this.quantity = 1,
    this.rate = 0.0,
    this.discount = 0.0,
    this.taxRate = 0.0,
  });

  // Per-item total calculation
  double get total {
    // ((rate - discount) * quantity) + tax
    double baseTotal = (rate - discount) * quantity;
    return baseTotal * (1 + (taxRate / 100));
  }
}