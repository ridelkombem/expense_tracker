import 'package:flutter/material.dart';
import '../models/expense.dart';

class NewExpensesScreen extends StatefulWidget {
  const NewExpensesScreen({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpensesScreen> createState() => _NewExpensesScreenState();
}

class _NewExpensesScreenState extends State<NewExpensesScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDayPicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
         setState(() {
      _selectedDate = pickedDate;

    });
  }

//picked date is what is being awaited to happen in the future we could use.then and then get value to be further used
//but equating what is being awaited to picked date makes picked date to be used only when it is available
//after waiting for the _selectedDate which was first nothing (Datetime?),then when the future date is chosen using pickeddate we equate it
   

  void _saveForm() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Invalid Input',
                    style: Theme.of(context).textTheme.titleLarge),
                content: Text(
                    'Please make sure a valid title, amount, date and category was entered',
                    style: Theme.of(context).textTheme.titleSmall),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Okay'))
                ],
              ));
      return;
    }

    widget.onAddExpense(Expense(
      category: _selectedCategory,
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
    ));

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
             style: Theme.of(context).textTheme.titleSmall,
            maxLength: 20,
            decoration: const InputDecoration(label: Text('Title')),
            controller: _titleController,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                   style: Theme.of(context).textTheme.titleSmall,
                  decoration: const InputDecoration(
                    
                    label: Text('Amount'),
                    prefixText: '\$',
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.name,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'No Date Selected'
                        : formatter.format(_selectedDate!),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  IconButton(
                      onPressed: () {
                        _presentDayPicker();
                      },
                      icon: const Icon(Icons.calendar_month))
                ],
              )
            ],
          ),
          Row(
            children: [
              DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toUpperCase(),
                              style: Theme.of(context).textTheme.titleSmall)))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = value;
                    });
                  }),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: _saveForm, child: const Text('Save Expense'))
            ],
          )
        ],
      ),
    );
  }
}
//from the NewExpenseScreen that is where the action is carried out of entering values 
//so a void function is passed  in the constructor which expects an expense and returns nothing 
//void Function(Expense expense) onAddExpense
//when onAddExpense is used it just passes the expense as onAddeExpense(Expense(with new values));
//then it is passed from the constructor to the Expenses screen, it is then linked to the AddExpense function which receives that expense as a parameter and adds it to the list.