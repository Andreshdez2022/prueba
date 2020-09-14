import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:songtube/internal/models/songFile.dart';
import 'package:songtube/internal/playerService.dart';
import 'package:songtube/provider/mediaProvider.dart';
import 'package:transparent_image/transparent_image.dart';

class MediaMusicList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaProvider mediaProvider = Provider.of<MediaProvider>(context);
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      child: mediaProvider.listSongs.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Text(
                    "Getting your Songs...",
                    style: TextStyle(
                      fontFamily: 'YTSans',
                      fontSize: 20
                    ),
                  ),
                )
              ],
            ),
          )
        : ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: mediaProvider.listSongs.length,
            itemBuilder: (context, index) { 
              SongFile song = mediaProvider.listSongs[index];
              return ListTile(
                title: Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color
                  ),
                ),
                subtitle: Text(
                  song.author,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6)
                  ),
                ),
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage(
                      fadeInDuration: Duration(milliseconds: 200),
                      placeholder: MemoryImage(kTransparentImage),
                      image: FileImage(File(song.coverPath)),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(MdiIcons.dotsVertical, size: 18),
                  onPressed: () {

                  },
                ),
                onTap: () async {
                  if (!AudioService.running) {
                    await AudioService.start(
                      backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
                      androidNotificationChannelName: 'SongTube',
                      // Enable this if you want the Android service to exit the foreground state on pause.
                      //androidStopForegroundOnPause: true,
                      androidNotificationColor: 0xFF2196f3,
                      androidNotificationIcon: 'drawable/ic_stat_music_note',
                      androidEnableQueue: true,
                    );
                    await AudioService.updateQueue(mediaProvider.listMediaItems);
                  }
                  MediaItem item = AudioService.queue[index];
                  await AudioService.playMediaItem(item);
                },
              );
            },
          )
    );
  }
}