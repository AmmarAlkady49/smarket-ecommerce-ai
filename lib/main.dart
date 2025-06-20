import 'package:e_commerce_graduation/core/cubit/general_cubit.dart';
import 'package:e_commerce_graduation/core/utils/routes/app_router.dart';
import 'package:e_commerce_graduation/core/utils/app_constants.dart';
import 'package:e_commerce_graduation/features/auth/auth_cubit/auth_cubit.dart';
import 'package:e_commerce_graduation/features/cart/cubit/cart_cubit.dart';
import 'package:e_commerce_graduation/features/favorites/cubit/favorites_cubit.dart';
import 'package:e_commerce_graduation/features/home/home_bubit/cubit/home_cubit.dart';
import 'package:e_commerce_graduation/features/notification/cubit/notification_cubit.dart';
import 'package:e_commerce_graduation/features/notification/services/notification_services.dart';
import 'package:e_commerce_graduation/features/order/cubit/order_cubit.dart';
import 'package:e_commerce_graduation/features/profile/profile_cubit/cubit/profile_cubit.dart';
import 'package:e_commerce_graduation/firebase_options.dart';
import 'package:e_commerce_graduation/generated/l10n.dart';
import 'package:e_commerce_graduation/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationServicesImpl().initNotificationsFirebase();
  await NotificationServicesImpl().initNotificationLocal();
  await dotenv.load(fileName: ".env");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  debugInvertOversizedImages = false;

  SharedPreferences pref = await SharedPreferences.getInstance();
  String lang = pref.getString('lang') ?? 'ar';
  bool rememberMe = pref.getBool("rememberMe") ?? false;

  runApp(Phoenix(
    child: MyApp(lang: lang, rememberMe: rememberMe),
  ));

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final String lang;
  final bool rememberMe;
  const MyApp({super.key, required this.lang, required this.rememberMe});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>(
              create: (context) {
                final cubit = AuthCubit();
                cubit.checkAuth();
                return cubit;
              },
            ),
            BlocProvider<FavoritesCubit>(
              create: (context) =>
                  FavoritesCubit()..getFavoriteProducts(context),
            ),
            BlocProvider<CartCubit>(
              create: (context) => CartCubit(
                favoritesCubit: context.read<FavoritesCubit>(),
                // )..getCartItems(),
              ),
            ),
            BlocProvider<HomeCubit>(
              create: (context) => HomeCubit(
                favoritesCubit: context.read<FavoritesCubit>(),
              ),
            ),
            BlocProvider(
              create: (context) => OrderCubit(
                  cartCubit: context.read<CartCubit>(),
                  favoritesCubit: context.read<FavoritesCubit>()),
            ),
            BlocProvider<ProfileCubit>(
              create: (context) => ProfileCubit(
                  cartCubit: context.read<CartCubit>(),
                  favoritesCubit: context.read<FavoritesCubit>(),
                  homeCubit: context.read<HomeCubit>()),
            ),
            BlocProvider<NotificationCubit>(
              create: (context) => NotificationCubit(),
            ),
            BlocProvider<GeneralCubit>(
              create: (context) => GeneralCubit(
                favoritesCubit: context.read<FavoritesCubit>(),
                homeCubit: context.read<HomeCubit>(),
              ),
            ),
          ],
          child: Builder(
            builder: (context) {
              return MaterialApp(
                title: AppConstants.appTitle,
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                localizationsDelegates: [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                locale: Locale(lang),
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                  useMaterial3: true,
                ),
                home: SplashScreen(rememberMe: rememberMe),
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            },
          ),
        );
      },
    );
  }
}
