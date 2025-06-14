import 'package:e_commerce_graduation/bottom_nav_bar.dart';
import 'package:e_commerce_graduation/core/utils/routes/app_routes.dart';
import 'package:e_commerce_graduation/core/widgets/too_many_request_page.dart';
import 'package:e_commerce_graduation/features/address/cubit/address_cubit.dart';
import 'package:e_commerce_graduation/features/address/views/pages/address_page.dart';
import 'package:e_commerce_graduation/features/address/views/pages/new_address_page.dart';
import 'package:e_commerce_graduation/features/auth/auth_cubit/auth_cubit.dart';
import 'package:e_commerce_graduation/features/auth/views/pages/create_account.dart';
import 'package:e_commerce_graduation/features/auth/views/pages/forget_password_page.dart';
import 'package:e_commerce_graduation/features/auth/views/pages/sign_in_page.dart';
import 'package:e_commerce_graduation/core/models/product_response.dart';
import 'package:e_commerce_graduation/features/auth/views/pages/verify_account.dart';
import 'package:e_commerce_graduation/features/cart/cubit/cart_cubit.dart';
import 'package:e_commerce_graduation/features/home/home_bubit/cubit/home_cubit.dart';
import 'package:e_commerce_graduation/features/home/views/widgets/products_by_category.dart';
import 'package:e_commerce_graduation/features/notification/models/notification_message_model.dart';
import 'package:e_commerce_graduation/features/notification/views/notification_page.dart';
import 'package:e_commerce_graduation/features/order/cubit/order_cubit.dart';
import 'package:e_commerce_graduation/features/order/views/pages/confirm_order_page.dart';
import 'package:e_commerce_graduation/features/favorites/cubit/favorites_cubit.dart';
import 'package:e_commerce_graduation/features/home/views/pages/home_page.dart';
import 'package:e_commerce_graduation/features/order/views/pages/my_order_page.dart';
import 'package:e_commerce_graduation/features/order/views/pages/payment_webview_page.dart';
import 'package:e_commerce_graduation/features/product_details/cubit/product_details_cubit.dart';
import 'package:e_commerce_graduation/features/product_details/views/pages/product_details_page.dart';
import 'package:e_commerce_graduation/features/product_details/views/widgets/add_review_page.dart';
import 'package:e_commerce_graduation/features/product_details/views/widgets/product_reviews.dart';
import 'package:e_commerce_graduation/features/profile/views/pages/account_page.dart';
import 'package:e_commerce_graduation/core/widgets/change_password_profile.dart';
import 'package:e_commerce_graduation/features/profile/views/pages/lang_page.dart';
import 'package:e_commerce_graduation/features/profile/views/pages/profile_page.dart';
import 'package:e_commerce_graduation/features/search/cubit/search_cubit.dart';
import 'package:e_commerce_graduation/features/search/views/pages/speech_to_text_search_page.dart';
import 'package:e_commerce_graduation/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    debugPrint('---------------------Navigating to: ${settings.name}');
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => AuthCubit(),
                  child: SignInPage(),
                ));
      case AppRoutes.createAccount:
        return MaterialPageRoute(builder: (_) => CreateAccount());
      case AppRoutes.tooManyRequestPage:
        return MaterialPageRoute(builder: (_) => TooManyRequestsPage());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordPage());
      case AppRoutes.notificationPage:
        final args = settings.arguments as List<NotificationMessageModel>;
        return MaterialPageRoute(
            builder: (_) => NotificationPage(
                  notifications: args,
                ));
      case AppRoutes.speechToText:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => SearchCubit()..initSpeechToText(),
                  child: const SpeechToTextSearchPage(),
                ));

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.bottomNavBar:
        final int selectedIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
            builder: (_) => BottomNavBar(selectedIndex: selectedIndex));
      case AppRoutes.productsByCategoryPage:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ProductsByCategory(
                  categoryCode: args['categoryCode'],
                  categoryCode2: args['categoryCode2'],
                  categoryName: args['categoryName'],
                ));

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      // Uncomment the following lines if you want to use BlocProvider for ProfilePage
      // return MaterialPageRoute(
      // builder: (_) => BlocProvider(
      //       create: (_) => ProfileCubit(),
      //       child: const ProfilePage(),
      //     ));
      case AppRoutes.languagePage:
        return MaterialPageRoute(builder: (_) => const LangPage());
      case AppRoutes.paymentWebviewPage:
        final String paymentUrl = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => PaymentWebviewPage(paymentUrl: paymentUrl));
      case AppRoutes.confirmOrderPage:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => OrderCubit(
                      cartCubit: context.read<CartCubit>(),
                      favoritesCubit: context.read<FavoritesCubit>()),
                  child: const ConfirmOrderPage(),
                ));
      case AppRoutes.myOrderPage:
        return MaterialPageRoute(builder: (_) => MyOrderPage());
      // return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //           create: (context) => OrderCubit(
      //               cartCubit: context.read<CartCubit>(),
      //               favoritesCubit: context.read<FavoritesCubit>()),
      //           child: const MyOrderPage(),
      //         ));

      case AppRoutes.verifyEmail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => VerifyAccount(
            email: args['email'],
            pageType: args['pageType'],
          ),
        );
      case AppRoutes.addressPage:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) {
                    final cubit = AddressCubit();
                    cubit.getAllAddresses();
                    return cubit;
                  },
                  child: const AddressPage(),
                ));
      case AppRoutes.newAddressPage:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => AddressCubit(),
                  child: const NewAddressPage(),
                ));
      case AppRoutes.splash:
        final bool rememberMe = settings.arguments as bool;
        return MaterialPageRoute(
          builder: (_) => SplashScreen(rememberMe: rememberMe),
        );
      case AppRoutes.changePassword:
        final String? email = settings.arguments as String?;

        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => AuthCubit(),
                  child: ChangePasswordProfile(email: email),
                ));
      case AppRoutes.accountPage:
        return MaterialPageRoute(builder: (_) => const AccountPage());
      case AppRoutes.productReviewsPage:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ProductReviews(
                  product: args['product'],
                  productDetailsCubit: args['productDetailsCubit'],
                ));
      case AppRoutes.addReviewPage:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
            builder: (_) => AddReviewPage(
                  product: args['product'],
                  productDetailsCubit: args['productDetailsCubit'],
                ));
      case AppRoutes.productPage:
        final product = settings.arguments as ProductResponse;
        return MaterialPageRoute(
          builder: (context) {
            final cartCubit = context.read<CartCubit>();
            final favoriteCubit = context.read<FavoritesCubit>();
            final homeCubit = context.read<HomeCubit>();
            final productDetailsCubit = ProductDetailsCubit(
              cartCubit: cartCubit,
              favoritesCubit: favoriteCubit,
              homeCubit: homeCubit,
            )..getProductDetails(product.productID!);

            return BlocProvider.value(
              value: productDetailsCubit,
              child: ProductDetailsPage(),
            );
          },
        );

      default:
        debugPrint('No route defined for ${settings.name}');
        return CupertinoPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
