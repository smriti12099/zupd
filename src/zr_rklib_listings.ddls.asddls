@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZRKLIB_LISTINGS'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_RKLIB_LISTINGS
  as select from ZRK_LIB_LISTINGS
{
  key listing_uuid as ListingUUID,
  id as ID,
  title as Title,
  type as Type,
  author as Author,
  publisher_studio as PublisherStudio,
  isbn_ean as IsbnEan,
  language_code as LanguageCode,
  publication_year as PublicationYear,
  description as Description,
  totalcopies as Totalcopies,
  available_copies as AvailableCopies,
  location_shelf_id as LocationShelfID,
  lending_duration_days as LendingDurationDays,
  status as Status,
  cover_image_url as CoverImageUrl,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
}
