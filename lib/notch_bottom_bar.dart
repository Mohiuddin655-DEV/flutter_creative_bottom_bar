import 'package:flutter/material.dart';
import 'package:tab_navigation_bar/tab_navigation_bar.dart';

class NotchBottomBar extends StatefulWidget {
  const NotchBottomBar({
    super.key,
  });

  @override
  State<NotchBottomBar> createState() => _NotchBottomBarState();
}

class _NotchBottomBarState extends State<NotchBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animation;

  int _tabIndex = 0;

  double height = 60;

  var _isExpanded = false;
  var _boxItemVisible = false;
  final _duration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: _duration,
    );
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _floatingButton(),
      bottomNavigationBar: Container(
        color: Colors.blue,
        child: BottomAppBar(
          elevation: 0,
          notchMargin: 1.5,
          shape: _isExpanded ? const CircularNotchedRectangle() : null,
          child: _bottomBar(),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              child: IndexedStack(
                index: _tabIndex,
                children: const [
                  CustomPage(
                    title: "Page - 1",
                  ),
                  CustomPage(
                    title: "Page - 2",
                  ),
                  SizedBox(),
                  CustomPage(
                    title: "Page - 3",
                  ),
                  CustomPage(
                    title: "Page - 4",
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (_, child) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 500),
                      bottom: _animation.value <= 0.5 ? -32 : -height + 12,
                      child: Container(
                        width: height,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    child!,
                  ],
                );
              },
              child: _box(),
            ),
          ],
        ),
      ),
    );
  }

  _floatingButton() {
    return GestureDetector(
      child: Container(
        width: height,
        height: height,
        margin: const EdgeInsets.only(top: 35),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) => Transform.rotate(
              angle: _animation.value * 0.5 * 3.1415,
              child: child,
            ),
            child: Icon(
              _isExpanded ? Icons.close : Icons.add,
              size: 32,
              color: Colors.white,
            ),
          ),
          onPressed: _toggleAnimation,
        ),
      ),
    );
  }

  _bottomBar() {
    return TabNavigationBar(
      backgroundColor: Colors.transparent,
      indicatorHeight: 5,
      indicatorWidth: 5,
      indicatorCornerRadius: 8,
      inactiveIconColor: Colors.grey,
      primaryColor: Colors.black,
      bottomPadding: 12,
      selectedIndex: _tabIndex,
      onItemSelected: _onTabChanged,
      items: const [
        TabNavigationItem(icon: Icons.light_mode_outlined),
        TabNavigationItem(icon: Icons.message_outlined),
        TabNavigationItem(),
        TabNavigationItem(icon: Icons.group_work_outlined),
        TabNavigationItem(icon: Icons.copy_rounded),
      ],
    );
  }

  _box() {
    return AnimatedContainer(
      duration: _duration,
      curve: Curves.fastEaseInToSlowEaseOut,
      width: _isExpanded ? 200.0 : height / 2,
      height: _isExpanded ? 200.0 : 0,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: _boxItemVisible
          ? Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16 * _animation.value,
                vertical: 12 * _animation.value,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BoxOptionItem(
                    title: "Mood check-in",
                    icon: Icons.face,
                    isSelected: true,
                    animation: _animation,
                  ),
                  BoxOptionItem(
                    title: "Voice note",
                    icon: Icons.record_voice_over_outlined,
                    animation: _animation,
                  ),
                  BoxOptionItem(
                    title: "Add photo",
                    icon: Icons.photo_camera_back_outlined,
                    animation: _animation,
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }

  void _toggleAnimation() {
    Future.delayed(_duration, () {
      setState(() {
        _boxItemVisible = true;
      });
    });
    setState(() {
      if (_boxItemVisible) {
        _boxItemVisible = false;
      }
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animation.forward();
      } else {
        _animation.reverse();
      }
    });
  }

  void _onTabChanged(index) {
    if (!_isExpanded) {
      setState(() {
        _tabIndex = index;
      });
    }
  }
}

class BoxOptionItem extends StatelessWidget {
  final Animation<double> animation;
  final bool isSelected;
  final String title;
  final IconData icon;

  const BoxOptionItem({
    super.key,
    required this.animation,
    this.isSelected = false,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isSelected ? 1 : 0.75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14 * animation.value,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Container(
            padding: EdgeInsets.all(6 * animation.value),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8 * animation.value),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 18 * animation.value,
            ),
          )
        ],
      ),
    );
  }
}

class BButton extends StatelessWidget {
  final bool selected;
  final Function() onPressed;
  final IconData icon;

  const BButton({
    super.key,
    this.selected = false,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        splashColor: Colors.black12,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: selected ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}

class CustomPage extends StatelessWidget {
  final String? title;

  const CustomPage({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      color: Colors.grey.shade200,
      child: Text(
        title ?? "",
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
