from invoice import invoice_total, line_total


def test_line_total_applies_discount():
    assert line_total(20.0, 3, 10) == 54.0


def test_invoice_total_applies_each_line_discount():
    lines = [(20.0, 3, 10), (5.0, 2, 0)]
    assert invoice_total(lines) == 64.0
