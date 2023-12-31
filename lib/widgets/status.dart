import 'package:flutter/material.dart';

enum StatusType {
  ready,
  review,
  rejected,
  revise,
  done,
}

class Status extends StatelessWidget {
  const Status({
    super.key,
    this.type = StatusType.ready,
    this.isExpand = false,
    this.isElevated = false,
  });

  final StatusType type;
  final bool isExpand;
  final bool isElevated;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: isElevated ? 2 : 0,
      color: Colors.white,
      shape: const StadiumBorder(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Row(
          children: [
            Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: changeStatusColor(type),
              ),
            ),
            if (isExpand) ...[
              const SizedBox(width: 8),
              Text(
                changeStatusText(type),
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ]
          ],
        ),
      ),
    );
  }

  String changeStatusText(StatusType status) {
    switch (status) {
      case StatusType.ready:
        return 'Ready to Review';
      case StatusType.review:
        return 'On Review';
      case StatusType.rejected:
        return 'Rejected';
      case StatusType.revise:
        return 'Need Revise';
      case StatusType.done:
        return 'Done';
    }
  }

  Color changeStatusColor(StatusType status) {
    switch (status) {
      case StatusType.ready:
        return Colors.black;
      case StatusType.review:
        return Colors.blue;
      case StatusType.rejected:
        return Colors.red;
      case StatusType.revise:
        return Colors.yellow;
      case StatusType.done:
        return Colors.green;
    }
  }
}
