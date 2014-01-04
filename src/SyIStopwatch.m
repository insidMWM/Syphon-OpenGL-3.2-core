/*
    SyIStopwatch.m
	Syphon (Implementations)
	
    Copyright 2010 bangnoise (Tom Butterworth) & vade (Anton Marini).
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

#import "SyIStopwatch.h"

#include <sys/time.h>

@implementation SyIStopwatch

- (void)start
{
	struct timeval tvStart;
	if(gettimeofday(&tvStart, NULL) == 0)
	{
		running = YES;
		start = (tvStart.tv_sec * 1000) + (tvStart.tv_usec/1000);
		runs++;
	}
	else
	{
		running = NO;
	}	
}

- (void)stop
{
	if (running)
	{
		struct timeval tvEnd;
		long millisecondsEnd;
		if(gettimeofday(&tvEnd, NULL) == 0)
			millisecondsEnd = (tvEnd.tv_sec * 1000) + (tvEnd.tv_usec/1000);
		else
			millisecondsEnd = 0;

		time += millisecondsEnd - start;
		running = NO;
	}
}

- (void)reset
{
	time = 0;
}

- (NSTimeInterval)time
{
	return (float)time / 1000.0;
}

- (NSUInteger)runs
{
	return runs;
}

- (NSTimeInterval)runAverage
{
	if (runs)
	{
		return self.time / (float)runs;
	}
	else
	{
		return 0.0;
	}
}
@end
