import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/consts/text_style.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ))
          ],
          leading: const Icon(Icons.sort_rounded),
          title: const Text(
            "Music",
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontFamily: bold,
            ),
          ),
        ),
        body: FutureBuilder<List<SongModel>>(
            future: controller.audioQuery.querySongs(
              ignoreCase: true,
              orderType: OrderType.ASC_OR_SMALLER,
              sortType: null,
              uriType: UriType.EXTERNAL,
            ),
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                return Center(
                    child: Text(
                  'No Songs Found',
                  style: ourstyle(),
                ));
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          margin: EdgeInsets.only(bottom: 4),
                          child: Obx(
                            () => ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              title: Text(
                                  snapshot.data![index].displayNameWOExt,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                '${snapshot.data![index].artist}',
                                style: ourstyle(family: regular, size: 12),
                              ),
                              leading: QueryArtworkWidget(
                                id: snapshot.data![index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note,
                                  size: 32,
                                ),
                              ),
                              trailing: controller.playIndex.value == index &&
                                      controller.isplaying.value
                                  ? const Icon(
                                      Icons.play_arrow_rounded,
                                      size: 26,
                                    )
                                  : null,
                              onTap: () {
                                Get.to(
                                  () => Player(
                                    data: snapshot.data!,
                                  ),
                                  transition: Transition.downToUp,
                                );
                                Container(
                                  color: Colors.white,
                                );

                                controller.playSong(
                                    snapshot.data![index].uri, index);
                              },
                            ),
                          ));
                    },
                  ),
                );
              }
            }));
  }
}
