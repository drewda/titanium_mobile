/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#ifdef USE_TI_APP

#import "TiAppPropertiesProxy.h"
#import "TiUtils.h"

@implementation TiAppPropertiesProxy

-(void)dealloc
{
	RELEASE_TO_NIL(defaultsObject);
	[super dealloc];
}

-(void)_configure
{
	defaultsObject = [[NSUserDefaults standardUserDefaults] retain];
	[super _configure];
}

-(BOOL)propertyExists: (NSString *) key;
{
	if (![key isKindOfClass:[NSString class]]) return NO;
	return ([defaultsObject objectForKey:key] != nil);
}

#define GETPROP \
ENSURE_TYPE(args,NSArray);\
NSString *key = [args objectAtIndex:0];\
id defaultValue = [args count] > 1 ? [args objectAtIndex:1] : nil;\
if (![self propertyExists:key]) return defaultValue; \

-(id)getBool:(id)args
{
	GETPROP
	return [NSNumber numberWithBool:[defaultsObject boolForKey:key]];
}

-(id)getDouble:(id)args
{
	GETPROP
	return [NSNumber numberWithDouble:[defaultsObject doubleForKey:key]];
}

-(id)getInt:(id)args
{
	GETPROP
	return [NSNumber numberWithInt:[defaultsObject integerForKey:key]];
}

-(id)getString:(id)args
{
	GETPROP
	return [defaultsObject stringForKey:key];
}

-(id)getList:(id)args
{
	GETPROP
	return [defaultsObject arrayForKey:key];
}

#define CLEAR_PROP_IF_NIL_OR_NULL	\
if (value==nil || value==[NSNull null]) {\
    [defaultsObject removeObjectForKey:key];\
	[defaultsObject synchronize]; \
	return;\
}\

#define SETPROP \
ENSURE_TYPE(args,NSArray);\
NSString *key = [args objectAtIndex:0];\
id value = [args count] > 1 ? [args objectAtIndex:1] : nil;\
CLEAR_PROP_IF_NIL_OR_NULL

#if 0

-(void)setBool:(NSString *)key withObject:(id)value
{
	CLEAR_PROP_IF_NIL_OR_NULL
	[defaultsObject setBool:[TiUtils boolValue:value] forKey:key];
	[defaultsObject synchronize];
}

-(void)setDouble:(NSString *)key withObject:(id)value
{
	CLEAR_PROP_IF_NIL_OR_NULL
	[defaultsObject setDouble:[TiUtils doubleValue:value] forKey:key];
	[defaultsObject synchronize];
}

-(void)setInt:(NSString *)key withObject:(id)value
{
	CLEAR_PROP_IF_NIL_OR_NULL
	[defaultsObject setInteger:[TiUtils intValue:value] forKey:key];
	[defaultsObject synchronize];
}

-(void)setString:(NSString *)key withObject:(id)value
{
	CLEAR_PROP_IF_NIL_OR_NULL
	[defaultsObject setObject:[TiUtils stringValue:value] forKey:key];
	[defaultsObject synchronize];
}

-(void)setList:(NSString *)key withObject:(id)value
{
	CLEAR_PROP_IF_NIL_OR_NULL
	[defaultsObject setObject:value forKey:key];
	[defaultsObject synchronize];
}

#else

-(void)setBool:(id)args
{
	SETPROP
	[defaultsObject setBool:[TiUtils boolValue:value] forKey:key];
	[defaultsObject synchronize];
}

-(void)setDouble:(id)args
{
	SETPROP
	[defaultsObject setDouble:[TiUtils doubleValue:value] forKey:key];
	[defaultsObject synchronize];	
}


-(void)setInt:(id)args
{
	SETPROP
	[defaultsObject setInteger:[TiUtils intValue:value] forKey:key];
	[defaultsObject synchronize];	
}

-(void)setString:(id)args
{
	SETPROP
	[defaultsObject setObject:[TiUtils stringValue:value] forKey:key];
	[defaultsObject synchronize];
}

-(void)setList:(id)args
{
	SETPROP
	[defaultsObject setObject:value forKey:key];
	[defaultsObject synchronize];
}

#endif

-(void)removeProperty:(id)args
{
	ENSURE_SINGLE_ARG(args,NSString);
	[defaultsObject removeObjectForKey:[TiUtils stringValue:args]];
	[defaultsObject synchronize];
}

-(id)hasProperty:(id)args
{
	ENSURE_SINGLE_ARG(args,NSString);
	return [NSNumber numberWithBool:[self propertyExists:[TiUtils stringValue:args]]];
}

-(id)listProperties:(id)args
{
	return [[defaultsObject dictionaryRepresentation] allKeys];
}

@end

#endif