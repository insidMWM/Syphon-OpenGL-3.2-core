/*
 
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //      SyphonCamera.h
    //		Copyright 2013 InsiD SAS, all rights reserved
    //
    //		Date        17/12/2013
    //		Developer   Romain Cheminade
    //		Contact     info@insidinc.com
    ///////////////////////////////////////////////////////////////////////////////////////////////
 
    Syphon
    Copyright 2010-2011 bangnoise (Tom Butterworth) & vade (Anton Marini).
    All rights reserved.
 
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
 
    * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 
    * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
 
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SyphonCamera.h"

// stdlib for malloc
#include <stdlib.h>


@interface SyphonCamera()

- (void)computeOrthoMatrix;

@end



@implementation SyphonCamera

//=================================================================================================
- (id)init
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

//=================================================================================================
- (id)initCamera: (float)left
   frustrumRight: (float)right
  frustrumBottom: (float)bottom
     frustrumTop: (float)top
    frustrumNear: (float)nearPlane
     frustrumFar: (float)farPlane;
{
    self = [super init];
	if( self )
	{
        boundLeft   = left;
        boundRight  = right;
        boundBottom = bottom;
        boundTop    = top;
        boundNear   = nearPlane;
        boundFar    = farPlane;
        
        data = (float*)malloc( sizeof(float) * 16 );
        
        [self computeOrthoMatrix];
    }
    
    return self;
}

//=================================================================================================
- (void)dealloc
{
    // data is a table
    if( data != nil )
    {
        free( data );
        data = nil;
    }
    
    [super dealloc];
}



//=================================================================================================
- (void)computeOrthoMatrix
{
    data[ 0] =  2.0f/(boundRight - boundLeft);
    data[ 4] =  0.0f;
    data[ 8] =  0.0f;
    data[12] =  -(boundRight + boundLeft)/(boundRight - boundLeft);
    
    data[ 1] =  0.0f;
    data[ 5] =  2.0f/(boundTop - boundBottom);
    data[ 9] =  0.0f;
    data[13] =  -(boundTop + boundBottom)/(boundTop - boundBottom);
    
    data[ 2] =  0.0f;
    data[ 6] =  0.0f;
    data[10] = -2.0f/(boundFar - boundNear);
    data[14] = -(boundFar + boundNear)/(boundFar - boundNear);
    
    data[ 3] =  0.0f;
    data[ 7] =  0.0f;
    data[11] =  0.0f;
    data[15] =  1.0f;
}



//=================================================================================================
- (void)updateCamera: (float)left
       frustrumRight: (float)right
      frustrumBottom: (float)bottom
         frustrumTop: (float)top
        frustrumNear: (float)nearPlane
         frustrumFar: (float)farPlane
{
    boundLeft   = left;
    boundRight  = right;
    boundBottom = bottom;
    boundTop    = top;
    boundNear   = nearPlane;
    boundFar    = farPlane;
    
    [self computeOrthoMatrix];
}

//=================================================================================================
- (void)updateCamera: (float)left
       frustrumRight: (float)right
      frustrumBottom: (float)bottom
         frustrumTop: (float)top
{
    boundLeft   = left;
    boundRight  = right;
    boundBottom = bottom;
    boundTop    = top;
    
    [self computeOrthoMatrix];
}



//=================================================================================================
- (float*)baseAddress
{
    return data;
}

@end


