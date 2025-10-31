@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZRKLIB_LISTINGS'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_RKLIB_LISTINGS000
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_RKLIB_LISTINGS
  association [1..1] to ZR_RKLIB_LISTINGS as _BaseEntity on $projection.LISTINGUUID = _BaseEntity.LISTINGUUID
{
  key ListingUUID,
  ID,
  Title,
  Type,
  Author,
  PublisherStudio,
  IsbnEan,
  LanguageCode,
  PublicationYear,
  Description,
  Totalcopies,
  AvailableCopies,
  LocationShelfID,
  LendingDurationDays,
  Status,
  CoverImageUrl,
  @Semantics: {
    User.Createdby: true
  }
  LocalCreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  LocalCreatedAt,
  @Semantics: {
    User.Localinstancelastchangedby: true
  }
  LocalLastChangedBy,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalLastChangedAt,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChangedAt,
  _BaseEntity
}
