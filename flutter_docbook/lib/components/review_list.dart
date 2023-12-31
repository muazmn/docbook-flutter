import 'package:flutter/material.dart';
import 'package:flutter_docbook/components/expanded_widget.dart';

class ReviewList extends StatefulWidget {
  const ReviewList(
      {super.key,
      this.route,
      required this.padding,
      required this.patientName,
      required this.date,
      required this.comment,
      required this.margin,
      required this.border,
      this.dividerWidth,
      this.divider});

  final String? route;
  final String patientName;
  final String comment;
  final String date;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Border? border;
  final double? dividerWidth;
  final Divider? divider;

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: widget.margin,
          padding: widget.padding,
          decoration: BoxDecoration(border: widget.border),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.patientName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.date,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 5)
                ],
              ),
              const SizedBox(height: 5),
              ExpandedWidget(
                text: widget.comment,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: widget.dividerWidth,
              child: widget.divider,
            ),
          ],
        ),
      ],
    );
  }
}
