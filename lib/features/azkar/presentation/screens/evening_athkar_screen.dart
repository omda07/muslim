import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../core/general_controllers/font_controller/font_cubit.dart';
import '../../../../core/general_controllers/font_controller/font_state.dart';
import '../../../../core/local/cache_helper.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../core/widgets/text_custom/text_custom.dart';
import '../azkar_cubit/azkar_cubit.dart';
import '../azkar_cubit/azkar_state.dart';

class EveningAzkarScreen extends StatelessWidget {
  const EveningAzkarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AzkarCubit()..getAzkarEvening(context: context),
      child: BlocConsumer<AzkarCubit, AzkarStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AzkarCubit.get(context);
          return ConditionalBuilder(
            condition: cubit.azkarEveningModel != null,
            builder: (context) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0.w, vertical: 10.0.h),
                      child: FadeIn(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/paperBackground.jpg'),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  spreadRadius: 1,
                                  blurRadius: 9,
                                  offset: const Offset(
                                      0, 7), // changes position of shadow
                                ),
                              ]),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 20.h,
                                bottom: 10.h,
                                right: 20.w,
                                left: 20.w),
                            child: Column(
                              children: [
                                BlocConsumer<FontCubit, FontState>(
                                  listener: (context, state) {
                                    // TODO: implement listener
                                  },
                                  builder: (context, state) {
                                    var fontCubit = FontCubit.get(context);
                                    return TextCustom(
                                        text: cubit.azkarEveningModel!
                                            .evening![index].zekr!,
                                        fontSize: fontCubit.azkarFontSize?.sp ??
                                            16.sp,
                                        fontWeight: FontWeight.bold);
                                  },
                                ),
                                const Divider(),
                                TextCustom(
                                    text: cubit.azkarEveningModel!
                                        .evening![index].description!,
                                    color: ColorManager.grey2),
                                Row(
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                              text: cubit.azkarEveningModel!
                                                  .evening![index].zekr!));
                                          Fluttertoast.showToast(
                                              msg: 'تم النسخ');
                                        },
                                        icon: const Icon(Icons.copy),
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          cubit.incrementEveningCounter(
                                              counter: int.parse(
                                                  '${cubit.azkarEveningModel!.evening![index].count}'),
                                              percent: cubit.azkarEveningModel!
                                                  .evening![index].percent!,
                                              index: index);

                                          CacheHelper.put(
                                              key: '$index m',
                                              value: cubit.azkarEveningModel!
                                                  .evening![index].count);
                                        },
                                        child: CircularPercentIndicator(
                                          radius: AppSize.s30,
                                          lineWidth: 5.0.w,
                                          percent: cubit.azkarEveningModel!
                                              .evening![index].percent!,
                                          animation: true,
                                          animateFromLastPercent: true,
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                          center: TextCustom(
                                              textAlign: TextAlign.center,
                                              text: cubit
                                                          .azkarEveningModel!
                                                          .evening![index]
                                                          .counter ==
                                                      0
                                                  ? '${cubit.azkarEveningModel!.evening![index].count}'
                                                  : '${cubit.azkarEveningModel!.evening![index].counter}',
                                              fontSize: 24.sp),
                                          // onAnimationEnd:1,
                                          progressColor:
                                              ColorManager.kGreenColor,
                                        )),

                                    // Expanded(
                                    //   child: TextCustom(
                                    //       textAlign: TextAlign.center,
                                    //       text:
                                    //           '${cubit.azkarEveningModel!.evening![index].count}',
                                    //       fontSize: 24.sp),
                                    // ),
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {
                                          cubit.share(
                                              cubit.azkarEveningModel!
                                                  .evening![index].zekr!,
                                              '',
                                              '');
                                        },
                                        icon: const Icon(Icons.share),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                itemCount: cubit.azkarEveningModel!.evening!.length,
              );
            },
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
