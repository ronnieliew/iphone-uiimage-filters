//
//  UIImage+Filter.m
//  BlurFilter
//
//  Created by Ronnie Liew on 6/12/10.
//  Inspired by JH Labs, filter code ported from: (http://www.jhlabs.com/ip/blurring.html)
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Filter.h"


#define getRed(p)   ((p) & 0x0000FF00) >> 8 
#define getGreen(p) ((p) & 0x00FF0000) >> 16
#define getBlue(p)  ((p) & 0xFF000000) >> 24


@implementation UIImage(Filter)



+(void)convolveWithMatrix:(CGFloat*)matrix
               matrixSize:(NSUInteger)matrixSize
                 inPixels:(UInt32*)inPixels 
                outPixels:(UInt32*)outPixels
                    width:(NSUInteger)width
                   height:(NSUInteger)height{
    
    NSUInteger cols = matrixSize;
    NSInteger colsMid = cols/2;
    
    for (NSUInteger y = 0; y < height; y++) {
        NSUInteger index = y;
        NSUInteger pixelIndex = y * width;
        
        for (NSUInteger x = 0; x < width; x++) {
            CGFloat r = 0, g = 0, b = 0;
            
            for (NSInteger col = -colsMid; col <= colsMid; col++) {
                CGFloat f = matrix[colsMid+col];
                
                if (f != 0) {
                    NSUInteger ix = x+col;
                    
                    if ( ix < 0 )ix = 0;
                    else if ( ix >= width) ix = width-1;
                    
                    UInt32 pixel = inPixels[pixelIndex+ix];
                    r += f * ((pixel >> 8) & 0xff);
                    g += f * ((pixel >> 16) & 0xff);
                    b += f * ((pixel >> 24)& 0xff);
                    
                }
            }
            outPixels[index] = 255 | ((int)r << 8) | ((int)g << 16) | ((int)b << 24);
            index += height;
        }
    }
} 





+(UIImage*)blur:(UIImage*)srcImage radius:(CGFloat)radius{
    CGImageRef imageRef = srcImage.CGImage;    
    NSData* data        = [(NSData *) CGDataProviderCopyData(CGImageGetDataProvider(imageRef)) autorelease];
    size_t width                    = CGImageGetWidth(imageRef);
    size_t height                   = CGImageGetHeight(imageRef);
    size_t bitsPerComponent         = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel             = CGImageGetBitsPerPixel(imageRef);
    size_t bytesPerRow              = CGImageGetBytesPerRow(imageRef);
    
    UInt32* pixels    = (UInt32 *)[data bytes];
    UInt32* outPixels = malloc(width*height * sizeof (UInt32));
    
    // In practice, when computing a discrete approximation of the Gaussian function, 
    // pixels at a distance of more than 3*sigma are small enough to be considered effectively zero. 
    NSInteger r = (NSInteger)ceil(radius);
    NSInteger rows = r*2+1;
    CGFloat matrix[rows];
    CGFloat sigma = radius/3;       
    CGFloat sigma22 = 2 * sigma * sigma;
    CGFloat sigmaPi2 = 2 * M_PI * sigma;
    CGFloat sqrtSigmaPi2 = (CGFloat)sqrt(sigmaPi2);
    CGFloat radius2 = radius * radius;
    CGFloat total = 0.0;

    NSUInteger index = 0;

    for (NSInteger row = -r; row <= r; row++) {
        CGFloat distance = row * row;
        if (distance > radius2)
            matrix[index] = 0;
        else
            matrix[index] = (CGFloat)exp(-(distance)/sigma22) / sqrtSigmaPi2;
        total += matrix[index];
        index++;
    }

    for (NSUInteger i = 0; i < rows; i++)
        matrix[i] /= total;

    
    // 2-pass convolution
    [UIImage convolveWithMatrix:matrix
                     matrixSize:rows
                       inPixels:pixels 
                      outPixels:outPixels
                          width:width
                         height:height];

    [UIImage convolveWithMatrix:matrix 
                     matrixSize:rows
                       inPixels:outPixels 
                      outPixels:pixels
                          width:height
                         height:width];
    
    
    
    CGColorSpaceRef colorspace      = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo         = CGImageGetBitmapInfo(imageRef);
    CGDataProviderRef provider      = CGDataProviderCreateWithData(NULL, pixels, [data length], NULL);
    
    CGImageRef newImageRef = CGImageCreate (width,
                                            height,
                                            bitsPerComponent,
                                            bitsPerPixel,
                                            bytesPerRow,
                                            colorspace,
                                            bitmapInfo,
                                            provider,
                                            NULL,
                                            false,
                                            kCGRenderingIntentDefault);

    
    UIImage *newImage   = [UIImage imageWithCGImage:newImageRef];    

    free(outPixels);
    CGDataProviderRelease(provider);
    CGImageRelease(newImageRef);
    CGColorSpaceRelease(colorspace);
    
    return newImage;
}
@end
