import 'package:flutter/material.dart';
import 'package:computer_12/action_button/about.dart';
import 'package:computer_12/topics/topics.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:share/share.dart';

class ActionButton extends StatefulWidget {
  const ActionButton({Key? key}) : super(key: key);

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;
//////////advertisment code
  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  _initBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {},
      ),
      request: const AdRequest(),
    );
    _bannerAd.load();
  }

////////floating icon
  ///
  ///rating dilog box
  void show() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.2),
          child: RatingDialog(
            initialRating: 1.0,
            title: const Text(
              'Rate Us',
              textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: true),
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            message: const Text(
              'Tap a star to set your rating. Add more description here if you want.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            image: Image.asset(
              "images/icon_logo_app.png",
              height: 100.0,
              width: 100,
            ),
            starSize: 25,
            submitButtonText: 'Submit',
            commentHint: 'Tell Us Your Comments',
            // ignore: avoid_print
            onCancelled: () => print('cancelled'),
            onSubmitted: (response) {
              // ignore: avoid_print
              print('rating:${response.rating},comment:${response.comment}');
            },
          ),
        );
      },
    );
  }

//////
  ///appbar and share floating icons
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 40.0,
          backgroundColor: const Color.fromARGB(255, 17, 65, 65),
          centerTitle: true,
          title: const Text(
            'Computer Science',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Ubuntu',
            ),
          ),
        ),

        /////share floating icon
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_home,
          spacing: 6.0,
          spaceBetweenChildren: 6.0,
          animationDuration: const Duration(milliseconds: 150),
          backgroundColor: const Color.fromARGB(255, 31, 86, 86),
          overlayColor: const Color.fromARGB(255, 171, 191, 208),
          overlayOpacity: 0.4,
          openCloseDial: isDialOpen,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.share),
              onTap: () {
                Share.share(
                    "https://play.google.com/store/apps/details?id=com.instructivetech.testapp");
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.star),
              onTap: () {
                show();
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.person),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AbouT(),
                  ),
                );
              },
            ),
          ],
        ),
        body: TopicsList(),

        ///////
        ///banner advertisment
        bottomNavigationBar: _isAdLoaded
            // ignore: sized_box_for_whitespace
            ? Container(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd),
              )
            : const SizedBox(),
      ),
    );
  }
}
