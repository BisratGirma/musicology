import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../artist.dart';

typedef ArtistSearchResponse = Either<NetworkException<void>, Artists>;

/// A repository responsible for storing and retrieving [Artist]/s data to/from
/// different data sources.
///
/// The implementation depends on [ArtistRemoteSource] to send and fetch
/// [Artist] related data from/to the API.
abstract class ArtistRepository {
  /// Returns [Artist]s matching with the given [name].
  Future<ArtistSearchResponse> findByName(String name);
}
