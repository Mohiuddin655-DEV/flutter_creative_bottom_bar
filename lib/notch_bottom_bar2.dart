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
  int _counter = 0;

  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // _rotationAnimation = Tween<double>(
    //   begin: 0,
    //   end: 0.5,
    // ).animate(_animationController);
  }

  void _toggleAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        showWidgets = true;
      });
    });
    setState(() {
      if (showWidgets) {
        showWidgets = false;
      }
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int _cIndex = 0;

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

  bool showWidgets = false;

  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isExpanded ? 70 : 70,
              height: isExpanded ? 70 : 70,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                icon: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animationController.value * 0.5 * 3.1415,
                      child: child,
                    );
                  },
                  child: Icon(
                    isExpanded ? Icons.close : Icons.add,
                    // size: 30,
                    color: Colors.white,
                  ),
                ),
                onPressed: _toggleAnimation,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.blue,
        child: BottomAppBar(
          height: 70,
          shape: isExpanded
              ? const CircularNotchedRectangle()
              : null,
          notchMargin: 0,
          child: const Row(
            children: [
              BButton(
                icon: Icons.light_mode_outlined,
              ),
              BButton(
                icon: Icons.message_outlined,
              ),
              Spacer(),
              BButton(
                icon: Icons.group_work_outlined,
              ),
              BButton(
                icon: Icons.copy_rounded,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: -50,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.decelerate,
                  width: isExpanded ? 200.0 : 0.0,
                  height: isExpanded ? 200.0 : 0.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Container(
                    height: 70,
                    color: Colors.blue,
                    child: BottomAppBar(
                      height: 70,
                      shape: isExpanded
                          ? const CircularNotchedRectangle()
                          : null,
                      notchMargin: 0,
                      child: const Row(
                        children: [
                          BButton(
                            icon: Icons.light_mode_outlined,
                          ),
                          BButton(
                            icon: Icons.message_outlined,
                          ),
                          Spacer(),
                          BButton(
                            icon: Icons.group_work_outlined,
                          ),
                          BButton(
                            icon: Icons.copy_rounded,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BButton extends StatelessWidget {
  final IconData icon;

  const BButton({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        splashColor: Colors.black12,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {},
        icon: Icon(
          icon,
          color: Colors.grey,
        ),
      ),
    );
  }
}
