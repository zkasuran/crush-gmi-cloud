"""Small invoice helpers."""


def line_total(price, quantity, discount_percent=0):
    """Return the cost of one invoice line after a percentage discount."""
    discounted = price * (1 - discount_percent / 100)
    return round(discounted * quantity, 2)


def invoice_total(lines):
    """Sum the line totals. Each line is (price, quantity, discount_percent)."""
    total = 0
    for price, quantity, discount_percent in lines:
        total += line_total(price, quantity)
    return round(total, 2)
