import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../album.dart';

part 'albums_state.dart';

/// A cubit responsible for [Albums] related functionality.
@injectable
class AlbumsCubit extends Cubit<AlbumsState> {
  final AlbumRepository _albumRepository;
  StreamSubscription? _streamSubscription;

  AlbumsCubit(this._albumRepository) : super(const AlbumsInitial());

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    await super.close();
  }

  /// Removes all [Albums] from the [_albumRepository] and emits
  /// [AllAlbumsLoaded] state with an empty albums list.
  Future<void> deleteAllAlbums() {
    return _albumRepository
        .deleteAllAlbums()
        .then((_) => const AllAlbumsLoaded([]))
        .then(emit);
  }

  /// Gets all [Albums] from the [_albumRepository] and emits [AllAlbumsLoaded]
  /// state with the albums list.
  ///
  /// Also, [AlbumsLoading] state will be emitted while the albums are loaded.
  Future<void> loadAllAlbums() async {
    emit(const AlbumsLoading());
    return _albumRepository
        .findAll()
        .then((albums) => AllAlbumsLoaded(albums))
        .then(emit);
  }

  /// Gets top [Albums] of an artist with the given [name] from the
  /// [_albumRepository]. And once, the albums are found, it will emit
  /// [TopAlbumsLoaded] state.
  ///
  /// Also, [AlbumsLoading] state will be emitted while the top albums are
  /// loaded.
  Future<void> loadTopAlbumsByArtistName(String name) async {
    emit(const AlbumsLoading());
    return _albumRepository
        .findTopAlbumsByArtistName(name)
        .then((response) => TopAlbumsLoaded(response))
        .then(emit);
  }

  /// Watches for any updated [AlbumDetails] from [_albumRepository] and
  /// emits [AllAlbumsLoaded] state with all albums list.
  ///
  /// Before watching for any update, it will load all albums by calling
  /// [loadAllAlbums] method.
  Future<void> watchAllAlbums() async {
    await loadAllAlbums();
    _streamSubscription ??= _albumRepository
        .watchAllAlbums()
        .map((albums) => AllAlbumsLoaded(albums))
        .listen(emit);
  }
}
