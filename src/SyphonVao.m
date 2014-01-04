/*
 
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //      SyphonVao.m
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

#import "SyphonVao.h"
#import "SyphonOpenGLHeader.h"

#if !defined( SYPHON_OPENGL_VERSION_32 )
    #import <Cocoa/Cocoa.h>
#endif

// stdlib for malloc
#include <stdlib.h>


#define OGL_BUFFER_OFFSET(i) ((char *)NULL + (i))

#define OGL_ATTRIBUTE_POSITION  0
#define OGL_ATTRIBUTE_TEXCOORD  4



@implementation SyphonVao

//=================================================================================================
- (id)init
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

//=================================================================================================
- (id)initWithSize: (NSSize)size
       textureSize: (NSSize)texSize
     textureTarget: (GLenum)texTarget
           oglInit: (BOOL)callInitGL
{
#if defined( SYPHON_OPENGL_VERSION_32 )
    self = [super init];
	if( self )
	{
        // Init vertices datas
        vertexCount = 4;
        vertexSize = vertexCount * 4 * sizeof(float);
        pVertexData = (float*)malloc( vertexSize );
        
        
        // Init element datas
        elementCount = 6;
        elementSize = elementCount * sizeof(GLuint);
        pElementData = (GLuint*)malloc( elementSize );
        
        pElementData[0] = 0;
        pElementData[1] = 1;
        pElementData[2] = 2;
        pElementData[3] = 2;
        pElementData[4] = 3;
        pElementData[5] = 0;
        
        
        // Grab texture target
        target = texTarget;
#ifndef NDEBUG
        assert( ((target==GL_TEXTURE_2D) || (target==GL_TEXTURE_RECTANGLE)) );
#endif
        
        
        // Compute datas
        [self computeData: size
              textureSize: texSize];
        
        
        // OpenGL init
        if( callInitGL ) {
            [self oglInit];
        }
    }
    
    return self;
    
#else
    NSLog( @"Syphon target OpenGL version is 2.1 legacy, do not call this method (SyphonVao initWithSize)" );
    return (id)0;
    
#endif
}

//=================================================================================================
- (void)dealloc
{
#if defined( SYPHON_OPENGL_VERSION_32 )
    // pElementData is a table
    if( pElementData != nil )
    {
        free( pElementData );
        pElementData = nil;
    }
    
    // pVertexData is a table
    if( pVertexData != nil )
    {
        free( pVertexData );
        pVertexData = nil;
    }
    
#else
    NSLog( @"Syphon target OpenGL version is 2.1 legacy, do not call this method (SyphonVao dealloc)" );
    
#endif
    
    [super dealloc];
}



//=================================================================================================
- (void)computeData: (NSSize)size
        textureSize: (NSSize)texSize
{
#if defined( SYPHON_OPENGL_VERSION_32 )
    /*
    float wr = texSize.width / size.width;
    float hr = texSize.height / size.height;
    float ratio;
    ratio = (hr < wr ? wr : hr);
    NSSize scaled = NSMakeSize((texSize.width / ratio), (texSize.height / ratio));
    
    NSPoint at =
    {
        (size.width / 2) - (scaled.width / 2),
        (size.height / 2) - (scaled.height / 2)
    };
     */
    
    pVertexData[ 0 ] = pVertexData[ 4 ] = 0.0f; //at.x;
    pVertexData[ 8 ] = pVertexData[12 ] = size.width; //at.x + scaled.width;
    pVertexData[ 1 ] = pVertexData[13 ] = 0.0f; //at.y;
    pVertexData[ 5 ] = pVertexData[ 9 ] = size.height; //at.y + scaled.height;
    
    if( target == GL_TEXTURE_RECTANGLE )
    {
        pVertexData[ 2 ] = 0.0f;            pVertexData[ 3 ] = texSize.height;
        pVertexData[ 6 ] = 0.0f;            pVertexData[ 7 ] = 0.0f;
        pVertexData[10 ] = texSize.width;   pVertexData[11 ] = 0.0f;
        pVertexData[14 ] = texSize.width;   pVertexData[15 ] = texSize.height;
    }
    else
    if( target == GL_TEXTURE_2D )
    {
        pVertexData[ 2 ] = 0.0f;   pVertexData[ 3 ] = 1.0f;
        pVertexData[ 6 ] = 0.0f;   pVertexData[ 7 ] = 0.0f;
        pVertexData[10 ] = 1.0f;   pVertexData[11 ] = 0.0f;
        pVertexData[14 ] = 1.0f;   pVertexData[15 ] = 1.0f;
    }
    
#else
    NSLog( @"Syphon target OpenGL version is 2.1 legacy, do not call this method (SyphonVao computeData)" );
    
#endif
}



//=================================================================================================
- (void)oglInit
{
#if defined( SYPHON_OPENGL_VERSION_32 )
    glGenBuffers( 1, &elementBufferId );
	glBindBuffer( GL_ELEMENT_ARRAY_BUFFER, elementBufferId );
	glBufferData( GL_ELEMENT_ARRAY_BUFFER, elementSize, pElementData, GL_STATIC_DRAW );
	glBindBuffer( GL_ELEMENT_ARRAY_BUFFER, 0 );
    
    
	glGenBuffers( 1, &arrayBufferId );
	glBindBuffer( GL_ARRAY_BUFFER, arrayBufferId );
	glBufferData( GL_ARRAY_BUFFER, vertexSize, pVertexData, GL_STATIC_DRAW );
	glBindBuffer( GL_ARRAY_BUFFER, 0 );
    
    
	glGenVertexArrays( 1, &vertexArrayId );
	glBindVertexArray( vertexArrayId );
    
    glBindBuffer( GL_ARRAY_BUFFER, arrayBufferId );
    glVertexAttribPointer( OGL_ATTRIBUTE_POSITION, 2, GL_FLOAT, GL_FALSE, sizeof(float)*4, OGL_BUFFER_OFFSET(0) );
    glVertexAttribPointer( OGL_ATTRIBUTE_TEXCOORD, 2, GL_FLOAT, GL_FALSE, sizeof(float)*4, OGL_BUFFER_OFFSET(sizeof(float)*2) );
    glBindBuffer( GL_ARRAY_BUFFER, 0 );
    
    glEnableVertexAttribArray( OGL_ATTRIBUTE_POSITION );
    glEnableVertexAttribArray( OGL_ATTRIBUTE_TEXCOORD );
    
	glBindVertexArray( 0 );
    
#else
    NSLog( @"Syphon target OpenGL version is 2.1 legacy, do not call this method (SyphonVao oglInit)" );
    
#endif
}

//=================================================================================================
- (void)oglUninit
{
#if defined( SYPHON_OPENGL_VERSION_32 )
    if( vertexArrayId )
    {
        glDeleteVertexArrays( 1, &vertexArrayId );
        vertexArrayId = 0;
    }
    
    if( arrayBufferId )
    {
        glDeleteBuffers( 1, &arrayBufferId );
        arrayBufferId = 0;
    }
    
    if( elementBufferId )
    {
        glDeleteBuffers( 1, &elementBufferId );
        elementBufferId = 0;
    }
    
#else
    NSLog( @"Syphon target OpenGL version is 2.1 legacy, do not call this method (SyphonVao oglUninit)" );
    
#endif
}

//=================================================================================================
- (void)oglUpdate
{
#if defined( SYPHON_OPENGL_VERSION_32 )
    glBindBuffer( GL_ARRAY_BUFFER, arrayBufferId );
    glBufferSubData( GL_ARRAY_BUFFER, 0,  vertexSize, pVertexData );
    glBindBuffer( GL_ARRAY_BUFFER, 0 );
    
#else
    NSLog( @"Syphon target OpenGL version is 2.1 legacy, do not call this method (SyphonVao oglUpdate)" );
    
#endif
}



//=================================================================================================
- (void)oglDraw
{
#if defined( SYPHON_OPENGL_VERSION_32 )
    glBindVertexArray( vertexArrayId );
    glBindBuffer( GL_ELEMENT_ARRAY_BUFFER, elementBufferId );
    
    glDrawElementsInstancedBaseVertex( GL_TRIANGLES, elementCount, GL_UNSIGNED_INT, NULL, 1, 0 );
    
    glBindBuffer( GL_ELEMENT_ARRAY_BUFFER, 0 );
    glBindVertexArray( 0 );
    
#else
    NSLog( @"Syphon target OpenGL version is 2.1 legacy, do not call this method (SyphonVao oglDraw)" );
    
#endif
}



//=================================================================================================
- (void)setTarget: (GLenum)texTarget
{
#if defined( SYPHON_OPENGL_VERSION_32 )
    target = texTarget;
    
#else
    NSLog( @"Syphon target OpenGL version is 2.1 legacy, do not call this method (SyphonVao setTarget)" );
    
#endif
}

@end


