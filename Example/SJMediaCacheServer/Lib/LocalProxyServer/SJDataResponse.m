//
//  SJDataResponse.m
//  SJMediaCacheServer_Example
//
//  Created by BlueDancer on 2020/6/2.
//  Copyright © 2020 changsanjiang@gmail.com. All rights reserved.
//

#import "SJDataResponse.h"
#import "SJResource.h"

@interface SJDataResponse ()<SJResourceReaderDelegate>
@property (nonatomic, weak) id<SJDataResponseDelegate> delegate;
@property (nonatomic, strong) SJDataRequest * request;
@property (nonatomic, strong) SJResource *resource;
@property (nonatomic, strong) id<SJResourceReader> reader;
@end

@implementation SJDataResponse
- (instancetype)initWithRequest:(SJDataRequest *)request delegate:(id<SJDataResponseDelegate>)delegate {
    self = [super init];
    if ( self ) {
        _request = request;
        _delegate = delegate;
    }
    return self;
}

- (void)prepare {
    _resource = [SJResource resourceWithURL:_request.URL];
    _reader = [_resource readDataWithRequest:_request];
    _reader.delegate = self;
    [_reader prepare];
}

- (NSDictionary *)responseHeaders {
    return _reader.response.responseHeaders;
}

- (NSUInteger)contentLength {
    return _reader.response.contentLength;
}

- (nullable NSData *)readDataOfLength:(NSUInteger)length {
    return [_reader readDataOfLength:length];
}

- (NSUInteger)offset {
    return _reader.offset;
}

- (BOOL)isPrepared {
    return _reader.isPrepared;
}

- (BOOL)isDone {
    return _reader.isReadingEndOfData;
}

- (void)close {
    [_reader close];
}

#pragma mark -

- (void)readerPrepareDidFinish:(id<SJResourceReader>)reader {
    [_delegate responsePrepareDidFinish:self];
}

- (void)readerHasAvailableData:(id<SJResourceReader>)reader {
    [_delegate responseHasAvailableData:self];
}

- (void)reader:(id<SJResourceReader>)reader anErrorOccurred:(NSError *)error {
    [_delegate response:self anErrorOccurred:error];
}
@end
