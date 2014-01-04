/*
 
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //      SyphonVao.h
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

#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>

#import "SyphonBuildMacros.h"


#define SYPHON_VAO_UNIQUE_CLASS_NAME SYPHON_UNIQUE_CLASS_NAME(SyphonVao)

@interface SYPHON_VAO_UNIQUE_CLASS_NAME : NSObject
{
	GLsizei                 vertexCount;
	GLsizeiptr              vertexSize;
    
	// pVertexData is a table of size vertexCount*4 containing x, y, s, t coordinates
    float *                 pVertexData;
    
	GLsizei                 elementCount;
	GLsizeiptr              elementSize;
    
	// m_pElementData is a table of size elementCount
	GLuint *                pElementData;
    
	GLuint                  vertexArrayId;
	GLuint                  elementBufferId;
	GLuint                  arrayBufferId;
    
    GLenum                  target;
}

- (id)initWithSize: (NSSize)size
       textureSize: (NSSize)texSize
     textureTarget: (GLenum)texTarget
           oglInit: (BOOL)callInitGL;
- (void)dealloc;

- (void)computeData: (NSSize)size
        textureSize: (NSSize)texSize;

- (void)oglInit;
- (void)oglUninit;
- (void)oglUpdate;

- (void)oglDraw;

- (void)setTarget: (GLenum)texTarget;

@end


#if defined(SYPHON_USE_CLASS_ALIAS)
@compatibility_alias SyphonVao SYPHON_VAO_UNIQUE_CLASS_NAME;
#endif
