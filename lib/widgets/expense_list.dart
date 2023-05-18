import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_item.dart';

class ExpenseList extends StatelessWidget {
  final void Function(Expense expense) onRemoveExpense;
  final List<Expense> expenses;
  const ExpenseList({
    Key? key,
    required this.onRemoveExpense,
    required this.expenses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: expenses.length,
          itemBuilder: ((context, index) => Dismissible(
              key: ValueKey(expenses[index]),
              background: Container(
                color: Theme.of(context).colorScheme.error.withOpacity(0.75),
                margin: EdgeInsets.symmetric(
                    horizontal: Theme.of(context).cardTheme.margin!.horizontal),
              ),
              onDismissed: (direction) {
                onRemoveExpense(expenses[index]);
              },
              child: ExpenseItem(expenses[index])))),
    );
  }
}
//from the expense List that is where the action is carried out of deleting 
//so a void function is passed in the constructor which expects an expense and returns nothing 
//void Function(Expense expense) onRemoveExpense
//when onRemoveExpense is used it just passes the expense as onRemoveExpense(expenses[index]);
//then it is passed from the constructor to the Expenses screen, it is then linked to the removeExpense function which receives that expense as a parameter and deletes it from the list.