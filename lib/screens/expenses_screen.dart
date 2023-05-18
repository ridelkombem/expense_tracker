import 'package:expense_tracker/widgets/chart.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_list.dart';
import '../screens/new_expenses_screen.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final List<Expense> _items = [
    Expense(
        category: Category.work,
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now()),
    Expense(
        category: Category.leisure,
        title: 'Cinema',
        amount: 15.69,
        date: DateTime.now()),
  ];

  void addExpense(Expense expense) {
    setState(() {
      _items.add(expense);
    });
  }

  void removeExpense(Expense expense) {
    final expenseIndex = _items.indexOf(expense);
    setState(() {
      _items.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Expense deleted'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              _items.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  void _openAddExpenseOverlay(context) {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpensesScreen(
              onAddExpense: addExpense,
            ));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No Expenses Found.Start adding some!'),
    );

    if (_items.isNotEmpty) {
      mainContent =
          ExpenseList(onRemoveExpense: removeExpense, expenses: _items);
    }

    return Scaffold(
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Expense Tracker',
                textAlign: TextAlign.start,
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _openAddExpenseOverlay(context);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: Column(children: [Chart(expenses: _items), mainContent]));
  }
}
