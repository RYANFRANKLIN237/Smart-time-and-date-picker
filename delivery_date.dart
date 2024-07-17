import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mansa/features/personalization/controllers/deliverytime_controller.dart';
import 'package:mansa/utils/constraints/colors.dart';
import 'package:mansa/utils/constraints/sizes.dart';
import 'package:mansa/utils/constraints/text_strings.dart';
import 'package:mansa/utils/helpers/snackbars.dart';

class DeliveryDateScreen extends StatelessWidget {
  DeliveryDateScreen({super.key});

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final DeliveryDateController controller = Get.put(DeliveryDateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.grey100,
      appBar: AppBar(
        title: const Text(MTexts.deliveryDateScreenTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: MColors.grey200),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Obx(() => Column(
                    children: [
                      CalendarDatePicker(
                        initialDate:
                            controller.selectedDate.value ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2101),
                        onDateChanged: (DateTime date) {
                          controller.setDate(date);
                        },
                        selectableDayPredicate: (DateTime date) {
                          //only allow mondays to saturdays to be selected
                          return date.weekday != DateTime.sunday;
                        },
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: MSizes.spaceBtwSections),
            Obx(() => Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: MColors.grey200),
                  ),
                  child: ListTile(
                    title: const Text(MTexts.preferredDeliveryTime),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: MColors.grey200,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        controller.selectedTime.value == null
                            ? '10:30'
                            : controller.selectedTime.value!.format(context),
                        style: const TextStyle(color: MColors.primary),
                      ),
                    ),
                    onTap: () {
                      _selectTime(context);
                    },
                  ),
                )),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (controller.selectedDate.value != null &&
                controller.selectedTime.value != null) {
              Get.back(result: {
                'date': DateFormat('yyyy-MM-dd')
                    .format(controller.selectedDate.value!),
                'time': controller.selectedTime.value!.format(context),
              });
            } else {
              // Handle error
              print('Date and time not selected');
            }
          },
          child: Text(MTexts.done),
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: controller.selectedTime.value ??
          const TimeOfDay(hour: 10, minute: 30),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null) {
      if (picked.hour >= 9 && picked.hour < 19) {
        controller.setTime(picked);
      } else {
        SnackbarUtils.showErrorSnackbar(
            'Please select a time between 9am and 7pm');
      }
    }
  }
}
