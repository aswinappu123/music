import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  var playIndex = 0.obs;
  var isplaying = false.obs;

  var duration = ''.obs;
  var position = ''.obs;

  var max = 0.0.obs;
  var value = 0.0.obs;

  late List<SongModel> playlist;

  @override
  void onInit() {
    super.onInit();
    CheckPermission();
    updateposition();
    audioPlayer.playerStateStream.listen((State) {
      if (State.processingState == ProcessingState.completed) {
        playnext();
      }
    });
  }

  updateposition() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      value.value = p.inSeconds.toDouble();
    });
  }

  changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  playSong(String? uri, index) {
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isplaying(true);
      updateposition();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  playnext() {
    if (playIndex.value < playlist.length - 1) {
      playIndex.value++;
      playSong(playlist[playIndex.value].uri, playIndex.value);
    }
  }

  CheckPermission() async {
    var perm = await Permission.storage.request();
    if (perm.isGranted) {
      loadPlaylist();
    } else {
      CheckPermission();
    }
  }

  loadPlaylist() async {
    // Query songs and set up the playlist
    playlist = await audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: null,
      uriType: UriType.EXTERNAL,
    );
  }
}
