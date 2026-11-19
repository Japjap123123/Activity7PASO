import 'package:flutter/material.dart';

// ====== STUDENT INFO ======
const String studentName = 'Jasper Paso';
const String studentId = '553296';
const String studentCourseSection = 'CCE106 - 3447';
const String studentEmail = 'j.paso.553296@umindanao.edu.ph';
// ==========================

void main() {
  runApp(const StudentApp());
}

// ---------------- DemoAuth ----------------
class DemoAuth {
  static String? registeredUsername;
  static String? registeredPassword;
  static String? currentUsername;

  static bool login(String username, String password) {
    final isAdmin = username == 'admin' && password == 'admin123';

    final isRegisteredUser = registeredUsername != null &&
        username == registeredUsername &&
        password == registeredPassword;

    if (isAdmin || isRegisteredUser) {
      currentUsername = username;
      return true;
    }

    return false;
  }

  static void register(String username, String password) {
    registeredUsername = username;
    registeredPassword = password;
  }

  static void logout() {
    currentUsername = null;
  }
}

// ---------------- App ----------------
class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Navigation App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

// ---------------- Login ----------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool hidePassword = true;

  void login() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final isValid = DemoAuth.login(
      usernameController.text.trim(),
      passwordController.text,
    );

    if (isValid) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password.')),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_person, size: 80, color: Colors.indigo),
              const SizedBox(height: 16),
              const Text('Welcome Back!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                    labelText: 'Username', border: OutlineInputBorder()),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter your username.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    tooltip: hidePassword ? 'Show password' : 'Hide password',
                    icon: Icon(hidePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your password.'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: login, child: const Text('Login')),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const RegisterScreen()));
                },
                child: const Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Register ----------------
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  void register() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    DemoAuth.register(
      usernameController.text.trim(),
      passwordController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration successful! You can now log in.'),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.person_add, size: 80, color: Colors.indigo),
              const SizedBox(height: 16),
              const Text('Create an Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                    labelText: 'Username', border: OutlineInputBorder()),
                validator: (value) {
                  final username = value?.trim() ?? '';
                  if (username.length < 3) return 'Use at least 3 characters.';
                  if (username.toLowerCase() == 'admin') {
                    return 'This username is reserved.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a password.';
                  }
                  if (value.length < 6) return 'Use at least 6 characters.';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm your password.';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                  onPressed: register, child: const Text('Register')),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Main Screen (Bottom Navigation) ----------------
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    final username = DemoAuth.currentUsername!;

    pages = [
      DashboardPage(username: username),
      const CalculatorScreen(),
      SocialMediaPage(username: username),
      ProfilePage(username: username),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Social',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ---------------- Dashboard ----------------
class DashboardPage extends StatelessWidget {
  final String username;

  const DashboardPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.dashboard, size: 80, color: Colors.indigo),
          const SizedBox(height: 16),
          Text(
            'Welcome, $username!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Explore your student application using '
            'the navigation bar below.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.calculate),
                  title: Text('Calculator'),
                  subtitle: Text('Perform basic arithmetic operations.'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Social'),
                  subtitle: Text('Create posts, like posts, and add comments.'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  subtitle: Text('View student information and log out.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Calculator ----------------
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final firstNumberController = TextEditingController();
  final secondNumberController = TextEditingController();

  String result = '0';
  String operationLabel = 'Enter two numbers';

  void calculate(String operation) {
    final first = double.tryParse(firstNumberController.text.trim());
    final second = double.tryParse(secondNumberController.text.trim());

    if (first == null ||
        second == null ||
        !first.isFinite ||
        !second.isFinite) {
      setState(() {
        result = 'Invalid input';
        operationLabel = 'Please enter two valid numbers';
      });
      return;
    }

    if (operation == '÷' && second == 0) {
      setState(() {
        result = 'Cannot divide by zero';
        operationLabel = 'Please change the second number';
      });
      return;
    }

    double answer;

    switch (operation) {
      case '+':
        answer = first + second;
        break;
      case '-':
        answer = first - second;
        break;
      case '×':
        answer = first * second;
        break;
      case '÷':
        answer = first / second;
        break;
      default:
        return;
    }

    setState(() {
      result = answer.toString();
      operationLabel = '$first $operation $second';
    });
  }

  void clearCalculator() {
    firstNumberController.clear();
    secondNumberController.clear();

    setState(() {
      result = '0';
      operationLabel = 'Enter two numbers';
    });
  }

  @override
  void dispose() {
    firstNumberController.dispose();
    secondNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Stateful Calculator'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.calculate, size: 64, color: Colors.indigo),
            const SizedBox(height: 12),
            const Text(
              'BASIC CALCULATOR',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: firstNumberController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: const InputDecoration(
                labelText: 'First Number',
                hintText: 'Enter the first number',
                prefixIcon: Icon(Icons.looks_one),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: secondNumberController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Second Number',
                hintText: 'Enter the second number',
                prefixIcon: Icon(Icons.looks_two),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: () => calculate('+'),
                  child: const Text('+', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => calculate('-'),
                  child: const Text('−', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => calculate('×'),
                  child: const Text('×', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => calculate('÷'),
                  child: const Text('÷', style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo),
              ),
              child: Column(
                children: [
                  Text(operationLabel, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  const Text(
                    'RESULT',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: clearCalculator,
              icon: const Icon(Icons.refresh),
              label: const Text('Clear'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Created by: $studentName\nSection: $studentCourseSection',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Social: Post model ----------------
class Post {
  final String username;
  final String caption;
  final String imageUrl;

  const Post({
    required this.username,
    required this.caption,
    required this.imageUrl,
  });
}

// ---------------- Social: Create Post Sheet ----------------
class CreatePostSheet extends StatefulWidget {
  final String username;

  const CreatePostSheet({super.key, required this.username});

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  void submitPost() {
    final String caption = _captionController.text.trim();
    final String imageUrl = _imageController.text.trim();

    if (caption.isEmpty || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete both fields before submitting!'),
        ),
      );
      return;
    }

    final uri = Uri.tryParse(imageUrl);

    if (uri == null ||
        !uri.hasAuthority ||
        (uri.scheme != 'https' && uri.scheme != 'http')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid HTTP or HTTPS image URL.'),
        ),
      );
      return;
    }

    final Post newPost = Post(
      username: widget.username,
      caption: caption,
      imageUrl: imageUrl,
    );

    Navigator.pop(context, newPost);
  }

  @override
  void dispose() {
    _captionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create Post',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _captionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Caption',
                prefixIcon: Icon(Icons.edit),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _imageController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                prefixIcon: Icon(Icons.image),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitPost,
              child: const Text('Submit Post'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Social: Post Card ----------------
class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final TextEditingController commentController = TextEditingController();

  final List<String> comments = [];

  bool isLiked = false;

  void likePost() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void addComment() {
    final String comment = commentController.text.trim();

    if (comment.isEmpty) {
      return;
    }

    setState(() {
      comments.add(comment);
    });

    commentController.clear();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final username = widget.post.username.trim();

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                username.isEmpty ? '?' : username[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Student Feed'),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              widget.post.caption,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Image.network(
            widget.post.imageUrl,
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                height: 220,
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 70,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: likePost,
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : null,
                ),
                label: Text(isLiked ? 'Liked' : 'Like'),
              ),
              Text('${comments.length} Comments'),
            ],
          ),
          for (final String comment in comments)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(comment),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: addComment,
                  icon: const Icon(Icons.send),
                  color: Colors.green,
                  tooltip: 'Send comment',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Social: Feed ----------------
class SocialMediaPage extends StatefulWidget {
  final String username;

  const SocialMediaPage({super.key, required this.username});

  @override
  State<SocialMediaPage> createState() => _SocialMediaPageState();
}

class _SocialMediaPageState extends State<SocialMediaPage> {
  final List<Post> posts = [
    const Post(
      username: 'JohnDoe',
      caption: 'Enjoying the sunny weather!',
      imageUrl: 'https://picsum.photos/id/20/600/400',
    ),
    const Post(
      username: 'JaneSmith',
      caption: 'Just finished a great book!',
      imageUrl: 'https://picsum.photos/id/24/600/400',
    ),
  ];

  Future<void> openCreatePostSheet() async {
    final Post? newPost = await showModalBottomSheet<Post>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return CreatePostSheet(username: widget.username);
      },
    );

    if (!mounted || newPost == null) {
      return;
    }

    setState(() {
      posts.insert(0, newPost);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social Media')),
      body: posts.isEmpty
          ? const Center(child: Text('No posts yet. Create one!'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  key: ObjectKey(posts[index]),
                  post: posts[index],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreatePostSheet,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        tooltip: 'Create Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ---------------- Profile ----------------
class ProfilePage extends StatelessWidget {
  final String username;

  const ProfilePage({super.key, required this.username});

  void logout(BuildContext context) {
    DemoAuth.logout();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.indigo,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            studentName,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Logged in as: $username',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.badge),
                  title: Text('Student ID'),
                  subtitle: Text(studentId),
                ),
                ListTile(
                  leading: Icon(Icons.school),
                  title: Text('Course and Section'),
                  subtitle: Text(studentCourseSection),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text('Email'),
                  subtitle: Text(studentEmail),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}