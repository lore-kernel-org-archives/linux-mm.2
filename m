Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26551CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 19:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18AEB6B0005; Tue, 19 May 2026 15:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 162D26B0088; Tue, 19 May 2026 15:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09FE36B008A; Tue, 19 May 2026 15:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE7D26B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:47:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2EE81403F3
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:47:48 +0000 (UTC)
X-FDA: 84785204616.09.19A0DA8
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf06.hostedemail.com (Postfix) with ESMTP id A14CF18000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:47:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=TQqxe7kz;
	spf=pass (imf06.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779220067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rulbKwFB5t9+i4HSuYZTS79H6o4XLdanavcWBockdOs=;
	b=wYb7kKF3fFWLzNBflG8VhV0yXDr0HNYU5+cqea5eMg+7qDEchQ6ORKvUln0olmSCZc8ADe
	BHzvr+00EVts5fUJGHHLX4FxkxPiYzuLRcSnebP+o3RiwnJnPLI/7saXIlElEmD2aqMzXq
	SPQAz1OHAtJP64XvHehjY3DdROhhk1o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=TQqxe7kz;
	spf=pass (imf06.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779220067; a=rsa-sha256;
	cv=none;
	b=eEfNIE8qsmxD0dH46HaNgzlgAQMi97MJIdg/2Fd+XWtnZLeJMgYRGo+KdA/pIpdlnOY/98
	A+9QGUWFhdpUj1BPk3wdRLuCLB0NaM4J9MgpWowG3oMYUIV9s9M7ShB8tkyFS85q95v2B2
	r8YpE3VsgoasSk1mcMPvFPrnSBjeJH4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=rulbKwFB5t9+i4HSuYZTS79H6o4XLdanavcWBockdOs=; b=TQqxe7kzHq2AhEgd84M7ojJSag
	MNdlPvAL9a0Ab/tQwxBDtwX3c8xKGXRSsJnfv/AAylGGujR1wYKNiS0eF/Rj7590vLfiUJ9367bL1
	8FEKZLng2C+QWHn5rW6wZFcSeI66yytrlW+6qHbrpBaa9rXaFt1NUOO69OyDSbUqLQrY9bAIFY/Mw
	iqVpsZpF2JFCy2s1GjAPoVFDKQbMHrUWDBlYfUhJwHlWf2B5K5fQRhn1XxOsdVbgzdIIxBZPM1ox3
	cnbxvhYG5NqedMmbGp0zROfn2NkJ4lkC95Z8ORImcQMp0MM3ZyGtIFLR2fp4fRfdFXV0HOCXe6Tnp
	wjlyaeaQ==;
Received: from [179.193.2.40] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1wPQPJ-003Mu7-PV; Tue, 19 May 2026 21:47:14 +0200
Message-ID: <471b5b42-974c-441a-9afb-13e1baba5c44@igalia.com>
Date: Tue, 19 May 2026 16:47:05 -0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] string: Introduce strtostr() for safe and performance
 string copies
To: David Laight <david.laight.linux@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Steven Rostedt <rostedt@goodmis.org>, Christian Brauner
 <brauner@kernel.org>, Kees Cook <kees@kernel.org>,
 Shuah Khan <shuah@kernel.org>, willy@infradead.org,
 mathieu.desnoyers@efficios.com,
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com,
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org,
 linux-api@vger.kernel.org
References: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
 <20260517-tonyk-long_name-v1-3-3c282eaa91e2@igalia.com>
 <20260517223419.3262de7c@pumpkin>
 <d4d6cf61-568e-478e-88d6-01b769d7eded@igalia.com>
 <20260518193843.7bde8d53@pumpkin>
Content-Language: en-US
From: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
In-Reply-To: <20260518193843.7bde8d53@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A14CF18000B
X-Stat-Signature: smszdz4zzag3gx5i4nrko6idp56h3gij
X-HE-Tag: 1779220065-805828
X-HE-Meta: U2FsdGVkX1/7/2P4dgUvwoT8xjbho+CTI5wChc1wokv0N/5W+FuNg/E/O/PijlqH49dife/dwm567XD8jop/TtnGU5pRYjDm9NuvTAYpBHsOyinKrMyer9ynYfRSBJu4QysJkU6hyaJLqdfGi2smTA9HASJUdGQ2+IHL81IcaVYHZh0la2ED3WQzXnotn9FHQiRxesq3fzMunBBye1v/I3NAePdkIDZDOAc9zO1Izlx8LdukcXTyTFWTv66bg6A5R5WAHouCGnGjfYzzi9Vbm49spAH8Jd9vTwUA925V/fSP426aYYu+bwvogeHB+FFxQ/hmTm3FAVPA/d6IGBsJCUUgYoB+SIlkZp52Ykq0htk/fnof519rh/NZBvw/FmAdW0AMfhSTTkqXVg9uJ+ZVsCfonuKdrZbeYSfvuUUyD9GWZcu/1FBMuqqXnjM7/Eq4kXmAO7PhlyZcc1v10nERUUcGGQ01DUd7ikisPL5nHBDu9qM6/483/ltqeUQcvngPI3ZnBPQ8kWiXnPyMqfsfU/je+BEQp6RnyJ9/yjxUglMV/CUCLb6vOrOBVnPMn7y+p6tjW3IbBYQB/VkZJTFFDtTnDUgoPa7zJeLSquwQ4h15xO/XBjyNiCk5/raskobOvLToiLnAynzRmy3Do5Wd/ySEmTpNANkntN16PX8odm7mYnS3TNilQmQgCVejVlYdzcPzqV/L7cAz51ieXAlR2xI/nNPMFa/kaTQ6eAPM8DlSsg4s8O8qvS19rtTkiYL9ClBW7QcjYbc8EhgDVZQctd9VwIf1gyFhbKSTHVGZRd7T+rpdDNZXmwE0TLf+Ii0hM11fUgJFVeoWk84lUgJoRvEw6SSxciJH/CQqoWtt3T6s7/v/dwWH3FtaNfHosCAWzJvbzeeIwB8MZ9qqG+HZm2ZRy21C4fo8Boc+O+5DRn2xDiBS8Vn53sDhqb9Pz0MpjBuQVOEWkfc2xaFhieV
 SO44xPYd
 HxX4Zh1DOjayxG5M7KZGp3ZWNdkXBhAUm+STPd5LMcmvkfSo/J/uU7jT7TYjRGwbviMkfzTNys73b0MPufCtXY4E9KNKeHlIsscp9SFVWedDoinDQ1nP7oJW5Xk8twLYiFZ/yR/jDgkCvY5kuUY7tryUD19HDVQStc/hvjmW8v/cPksTlDV4JrAmc5B4onmXKhlgfmkRjeUEVTvsed304hsvVW/bxJYR14nsUVBC2duxa9KCQualCqE0g6jAVoc4AXqdL9cl1aTcAj43XHtTWcxJ31BTpDVM9NDQHYplakupNju26TZAL/uTsDl8hcaTEyTLnhF4ntTgeInFgR9k7sPLWFmlYAIUQrwz00sh9l6c9T5fTF8kW+pup50KS3ARkkHi9i1q7KINsELDsRgnsqcYdu1vIKyvL3gTm7Zow4f1P8YEMPbDGnlIlj7e2krWUxijR1beJZ7SrLG9X9pieFurXn4EgFvjwMJLF+Z8xqLf3q+eovuYyeZnrFpqXXE8NyKy/XGbPcT5WIs2C5Vrpel5xjqhgRexQMXA8i8gvndhhAQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Em 18/05/2026 15:38, David Laight escreveu:
> On Mon, 18 May 2026 11:36:49 -0300
> André Almeida <andrealmeid@igalia.com> wrote:
> 
>> Hi David, thanks for the feedback!
>>
>> Em 17/05/2026 18:34, David Laight escreveu:
>>> On Sun, 17 May 2026 15:36:13 -0300
>>> André Almeida <andrealmeid@igalia.com> wrote:
>>>    
>>>> Some parts of the kernel uses memcpy() instead of strscpy() because they
>>>> are performance sensitive and doesn't care about the return value of
>>>> strscpy(). One such common case is to copy current->comm to a different
>>>> buffer.
>>>>
>>>> As the command name is guaranteed to be NUL-terminated in the range of
>>>> TASK_COMM_LEN, this is safe enough and doesn't create unterminated
>>>> strings. However, in order to expand the size of current->comm, this
>>>> expectation will be broken and those memcpy() could create such strings
>>>> without trailing NUL byte.
>>>>
>>>> In order to support a fast and safe string copy, create strtostr(), to copy
>>>> a NUL-terminated string to a new string buffer. If the destination buffer
>>>> is bigger than the source, no pad is applied, but the string is
>>>> NUL-terminated. If the destination buffer is smaller, the string is
>>>> truncated. The last byte of the destination is always set to NUL for safety.
>>>>
>>>> Signed-off-by: André Almeida <andrealmeid@igalia.com>
>>>> ---
>> [...]>> +/**
>>>> + * strtostr - Copy NUL-terminanted string to NUL-terminate string
>>>> + *
>>>> + * @dest: Pointer of destination string
>>>> + * @src: Pointer to NUL-terminates string
>>>> + *
>>>> + * This is a replacement for strcpy() where the caller doesn't care about the
>>>> + * return value and if the string is going to be truncated, albeit it needs
>>>> + * to mark sure that it will be NUL-terminated. Intended for performance
>>>> + * sensitive cases, such as tracing.
>>>
>>> If you care about performance, and the destination isn't smaller (especially
>>> if the sizes are the same) then just use memcpy().
>>>      
>>
>> The problem is that as I'm expanding current->comm, the source buffer
>> might be bigger than destination, and when we truncate the string, it
>> won't have the termination NUL byte. So we need an extra dest[len-1] =
>> \0 after the memcpy.
> 
> It depends on other access to the destination.
> If it might be being concurrently read it is vital that it is always
> terminated.
> So you can't even temporarily have a non-zero byte at the end.
> 

I don't think this is the case here, as far as I can tell all the 
callers of strtostr will wait the end of the copy before using it.

>>
>>>> + *
>>>> + * If the destination is bigger than the source, no padding happens. It it's
>>>> + * smaller the strings gets truncated.
>>>> + *
>>>> + * Both arguments needs to be arrays with lengths discoverable by the compiler.
>>>> + */
>>>> +#define strtostr(dest, src)	do {					\
>>>> +	const size_t _dest_len = __must_be_cstr(dest) +			\
>>>> +				 ARRAY_SIZE(dest);			\
>>>> +	const size_t _src_len = __must_be_cstr(src) +			\
>>>> +				__builtin_object_size(src, 1);		\
>>>> +									\
>>>> +	BUILD_BUG_ON(!__builtin_constant_p(_dest_len) ||		\
>>>> +		     _dest_len == (size_t)-1);				\
>>>> +	memcpy(dest, src, strnlen(src, min(_src_len, _dest_len)));	\
>>>> +	dest[_dest_len - 1] = '\0';						\
>>>> +} while (0)
>>>
>>> That doesn't work (for all sorts of reasons).
>>> _dest_len can be the size of a pointer - no array check.
>>> You need to use __is_array() and sizeof () for both dest and src.
>>> You might have meant to check that _src_len is constant, not _dest_len.
>>> You must not leave the destination unterminated.
>>>
>>> __builtin_object_size(x->y,1) is also entirely useless!
>>> If you have a pointer to a structure that ends in an array then the
>>> object size of that array is SIZE_MAX (as if the array continues past
>>> the end of the structure).
>>> See https://godbolt.org/z/csenjfvxe (which I happened to prepare earlier today).
>>>
>>> __builtin_object_size(x->y,0) also seems to always return SIZE_MAX.
>>> You do get a sane answer for (x->y,3) on recent clang - but nowhere else.
>>>    
>>
>> Oops, you are right, thanks for pointing that out. This is how it would
>> look like checking that both args are arrays and using sizeof to get
>> their length, if it sounds good I can apply for the v2:
>>
>> #define strtostr(dest, src)	do {				\
>> 	const size_t _dest_len = __must_be_array(dest) +	\
>> 				 sizeof(dest);			\
>> 	const size_t _src_len = __must_be_array(src) +		\
>> 				sizeof(src);			\
>> 								\
>> 	BUILD_BUG_ON(!__builtin_constant_p(_dest_len) ||	\
>> 		     _dest_len == (size_t)-1);			\
> 
> That test can never fail.
> 
>> 	memcpy(dest, src, min(_src_len, _dest_len)));		\
>> 	dest[_dest_len - 1] = '\0';				\
> 
> You are expending 'dest' twice.
> Where it (p++)->array then the two values would be different and the final
> value of 'p' incorrect.
> Much better to assign both pointers to local variables.
> Here you can use their required types to get type checking (I wouldn't bother
> about the extra checks that _must_be_cstr() does).
> 

Also, all those memcpy() that I replaced had explicitly the dest size. I 
think I could reuse it for strtostr() to simplify a bit things, what do 
you think?

> I'd also create function that is explicitly for copying process names.
> (Or replace the one that is already there - saves a lot of churn.)
> then you know (and can check) the sizes are the expected ones.
> 

I don't have strong feeling about get_task_comm(), but Linus said that 
"I'd rather aim to get rid of get_task_comm() entirely"[1] so for me 
it's fine to get a new function for that.

[1] 
https://lore.kernel.org/all/CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com/

> It might even be worth making the #define (needed to get the array sizes)
> call out to different functions for the different cases.
> 
> Thinks more...
> On 64bit the 16 byte copy can be 'load; store; load; mask; store' provided
> the buffer is aligned (copying u64 on 32bit will work the same).
> But that requires that all the buffers be aligned.
> So you'd need to check _Alignof(dest) >= _Alignof(u64) as well.
> (Probably with a fallback to get things to compile.)
> 
> Whether that is best for the longer 64 byte copy is anybodies guess.
> 
> I also suspect it would be best to zero fill when copying a 16 byte
> name into a 64 byte buffer.
> (If you zero fill first then you can just copy 16 bytes over.)
> 
> -- David
> 
>> } while (0)
>>
>>
>>> -- David
>>>
>>>    
>>
> 


