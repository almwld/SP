import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}
class LoginWithEmail extends AuthEvent {
  final String email, password;
  const LoginWithEmail({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}
class RegisterWithEmail extends AuthEvent {
  final String name, email, phone, password;
  const RegisterWithEmail({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });
  @override
  List<Object?> get props => [name, email, phone, password];
}
class LoginWithGoogle extends AuthEvent {}
class LogoutRequested extends AuthEvent {}

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginWithEmail>(_onLoginWithEmail);
    on<RegisterWithEmail>(_onRegisterWithEmail);
    on<LoginWithGoogle>(_onLoginWithGoogle);
    on<LogoutRequested>(_onLogout);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) {
    final user = _auth.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginWithEmail(LoginWithEmail event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(cred.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'فشل تسجيل الدخول'));
    }
  }

  Future<void> _onRegisterWithEmail(RegisterWithEmail event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'name': event.name,
        'email': event.email,
        'phone': event.phone,
        'createdAt': FieldValue.serverTimestamp(),
      });
      emit(AuthAuthenticated(cred.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'فشل إنشاء الحساب'));
    }
  }

  Future<void> _onLoginWithGoogle(LoginWithGoogle event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthUnauthenticated());
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCred = await _auth.signInWithCredential(credential);
      emit(AuthAuthenticated(userCred.user!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    emit(AuthUnauthenticated());
  }
}
