import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/new_expense.dart';
import 'package:flutter_expense_tracker/widgets/chart/chart.dart';
import 'package:flutter_expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:flutter_expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpense = [
    Expense(
        title: 'In n Out',
        amount: 3.99,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'Movie',
        amount: 15.6,
        date: DateTime.now(),
        category: Category.leisure)
  ];

  _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true, // makes sure modal doesn't overlap with camera
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(onAddExpense: _addExpense);
      },
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpense.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpense.indexOf(expense);

    setState(() {
      _registeredExpense.remove(expense);
    });

    ScaffoldMessenger.of(context)
        .clearSnackBars(); // removes any existing info message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpense.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expense found. Start adding some'),
    );

    if (_registeredExpense.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpense,
        onExpenseRemove: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpense),
                Expanded(
                  child: mainContent,
                )
              ],
            )
          : Row(
              children: [
                Expanded(
                    child: Chart(
                        expenses:
                            _registeredExpense)), // Expanded is required here because both chart and row has infinity width
                Expanded(
                  child: mainContent,
                )
              ],
            ),
    );
  }
}
