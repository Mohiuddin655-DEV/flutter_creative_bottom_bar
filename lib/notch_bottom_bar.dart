import 'package:flutter/material.dart';

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

  var _isExpanded = false;
  var _boxItemVisible = false;
  final _duration = const Duration(milliseconds: 200);

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
      floatingActionButton: GestureDetector(
        child: Container(
          width: 70,
          height: 70,
          margin: const EdgeInsets.only(top: 25),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(24),
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
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.blue,
        child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return BottomAppBar(
                elevation: 0,
                height: 70,
                shape: _isExpanded ? const CircularNotchedRectangle() : null,
                notchMargin: 0,
                child: Row(
                  children: [
                    BButton(
                      selected: _tabIndex == 0,
                      icon: Icons.light_mode_outlined,
                      onPressed: () => _onTabChanged(0),
                    ),
                    BButton(
                      selected: _tabIndex == 1,
                      icon: Icons.message_outlined,
                      onPressed: () => _onTabChanged(1),
                    ),
                    const Spacer(),
                    BButton(
                      selected: _tabIndex == 2,
                      icon: Icons.group_work_outlined,
                      onPressed: () => _onTabChanged(2),
                    ),
                    BButton(
                      selected: _tabIndex == 3,
                      icon: Icons.copy_rounded,
                      onPressed: () => _onTabChanged(3),
                    ),
                  ],
                ),
              );
            }),
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
              left: 0,
              right: 0,
              child: IndexedStack(
                index: _tabIndex,
                children: const [
                  CustomPage(
                    title: "Page - 1",
                  ),
                  CustomPage(
                    title: "Page - 2",
                  ),
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
              builder: (context, child) {
                final value = _animation.value;
                return AnimatedPositioned(
                  duration: _duration,
                  bottom: _isExpanded && value > 0.5 ? 0 : -48,
                  child: AnimatedContainer(
                    duration: _duration,
                    curve: Curves.fastEaseInToSlowEaseOut,
                    width: _isExpanded ? 200.0 : 70.0,
                    height: _isExpanded ? 200.0 : 70.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(25),
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
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
