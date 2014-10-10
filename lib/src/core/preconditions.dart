// Copyright 2014 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// TODO(danielwhite): Where should documentation like this go (if anywhere)? It
// applies to all the methods in the file and I'd rather not repeat it.
/// A simple set of precondition checkers based on the Guava Preconditions class
/// in Java. These checks are stronger than 'assert' statements, which can be
/// switched off, so they must only be used in situations where we actively
/// want the program to break when the precondition does not hold.
///
/// ## Performance
/// Performance may be an issue with these checks if complex logic is computed
/// in order to make the method call. You should be careful with its use in
/// these cases - this library is aimed at improving maintainability and
/// readability rather than performance. They are also useful when the program
/// should fail early - for example, null-checking a parameter that might not
/// be used until the end of the method call.
///
/// ## Error messages
/// The message parameter can be either a '() => Object' or any other Object.
/// The object will be converted to an error message by calling its toString(),
/// The Function should be preferred if the message is complex to construct
/// (i.e., it uses String interpolation), because it is only called when the
/// precondition fails.
///
/// If the message parameter is null or returns null, a default error message
/// will be used.
part of quiver.core;

/// Throws an [ArgumentError] if the given [expression] is false.
void checkArgument(bool expression, {message}) {
  if (!expression) {
    throw new ArgumentError(_resolveMessage(message, null));
  }
}

/// Throws a [RangeError] if the given [index] is not a valid index for a list
/// with [size] elements.
int checkListIndex(int index, int size, {message}) {
  if (index < 0 || index >= size) {
    throw new RangeError(_resolveMessage(
        message, "index $index not valid for list of size $size"));
  }
  return index;
}

/// Throws a [StateError] if the given [reference] is null.
dynamic checkNotNull(reference, {message}) {
  if (reference == null) {
    throw new StateError(_resolveMessage(message, "null pointer"));
  }
  return reference;
}

/// Throws a [StateError] if the given [expression] is false.
void checkState(bool expression, {message}) {
  if (!expression) {
    throw new StateError(_resolveMessage(message, "failed precondition"));
  }
}

String _resolveMessage(message, String defaultMessage) {
  if (message is Function) message = message();
  if (message == null) return defaultMessage;
  return message.toString();
}
