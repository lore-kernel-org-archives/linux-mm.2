Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E92C3CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 13:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1324D8E0023; Mon, 25 Aug 2025 09:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E36B8E0001; Mon, 25 Aug 2025 09:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14088E0023; Mon, 25 Aug 2025 09:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDE6B8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:36:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 628A881F84
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:36:56 +0000 (UTC)
X-FDA: 83815380432.21.64ECC9D
Received: from mail-ed1-f65.google.com (mail-ed1-f65.google.com [209.85.208.65])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4E01C100013
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:36:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=aK5n0Ncb;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf05.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.208.65 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756129014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pDTMpOHUU+5woUIgWQOxnynpQcS2ptNxqXsiFnt7QfQ=;
	b=LOuAep+W6wA5qYY6meHFbYtm+C9d7g0wNLpPAsbSVqIPB7xILAX6tSWKyt7XmIB1OZjz9M
	LKt8Dpd0TQd7Ds2G2QRT5Dx2iRHL8hSwN6eAXXgY1ym74dXziJ8k61ll3x2+6mztKk/PRm
	pSynKSyVsEU/uQtae2yJ7KFUV7SNNqk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=aK5n0Ncb;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf05.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.208.65 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756129014; a=rsa-sha256;
	cv=none;
	b=pchk8uis8E7C/QOkkK4lTjmp2PWLFQbAHlcjzs3+0yqkzzW1zMpyAsUliLCzmd8J9GWaek
	AHS6k7pG+1Zd8mgaXt6oguv47A7WtSGYL5hZczP7bpN3ZNfPIiv4ag5htfGLcWteYosnEt
	FnNYmjuPp4vUV7nSJOETH5pi3zy+Bzk=
Received: by mail-ed1-f65.google.com with SMTP id 4fb4d7f45d1cf-61c38da68ddso4475952a12.2
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 06:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756129012; x=1756733812; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pDTMpOHUU+5woUIgWQOxnynpQcS2ptNxqXsiFnt7QfQ=;
        b=aK5n0NcbYKken8CNFkVeT6MXB5j9pTpxEdZ02uRH7/vv4u6EwWIji+NBpc4Oiiv297
         bgWGHe6MPoUhJlSjaRhdvlHa12hk9qHgBqArnm5wOK3eM0NllJNgRjmLYvqHihMk8mNN
         kIjP32BpwZ2NXP1TUMHgTJRTEE0UyKP8m9g3QQWfg99h8+gL55kIqfdnzxajWYyx6W9r
         AYMa2uh3GAJounrldpK7Y5mOqRELqcy6bnQwXj1m+fPjnUeYAL5309gg3cQKEjhqL6qj
         NJ43HQVb9dMCll71TTT1xqDgn5JGPQHbgh+aEiKBIEv7RzBZ1wRo0Y5DU9s20WmWBA7B
         y8dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756129012; x=1756733812;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pDTMpOHUU+5woUIgWQOxnynpQcS2ptNxqXsiFnt7QfQ=;
        b=MB7obgAehfvwBCUuTVR4sYdOLVLeOr/1fw/bWxfQGorWo6scphmgICXkvhuLjl9viz
         oDrZ6UvI5pV00kEFPNrJ2ZFJxn4+Vy2hxXlr3jaSknfXLzlJBK2C34XDeWEkWtrsXj9p
         P2/vwZ+9Wn9iSVmlPCDB/nDbF1FLHj02AF257GJxhP0dFTcHdwowcCp0hsWKpkgoPq6t
         4xij3i4c2F2EmCtcu4SehZZTzaxD9zqaPPBQSD7zvxHBe8rEYbCoEfILfOty1mPIi+gm
         4Z2Ebmkw/HSPozmCyWAK3mzBLzqvb9RvhkfEzwH/cvpv0+4fbrXbyk/bwBvByrmu/W/v
         q4WQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsUKedqmIinIwu4UA2NkBIcLJp4voMG6X/iT/wRPYIOCOWEBs5O+xPS6nR4tAbTu94u52L+GlGjA==@kvack.org
X-Gm-Message-State: AOJu0YxubaKQeUenVed6rOdajA+fVsKKdQzS+TVXmDYzgFnXuq7Bbp7c
	Ige8llOUmK70o07/waN08ody8wusjzQWtvqSp/6zp44ztGJmVvLfW91PZR4sFIHAYD4=
X-Gm-Gg: ASbGncuAmSjzaq6TELliwVOr8tVYBisHMOfU9iSYVXZZQf4XDTviPA7UUTJcW91T2YR
	xLIT2Ib94APwClmB0kXtdaZxE85qKj7LSzfkbLuNvCjROcwF7CrZ5f0gBs+l4YetRC/dQnBW5op
	wfBdPT74APOwpI03bk5iW2VSJjP0xct/YvyCwQOIMpcvrYXW3of45u5bEptilIqZZcuWqnmaoiH
	fOfrMYeXvVP1QmMAOaPi8tArpm+Tkr8kVD8utaTpJkiomxPGkLe7Fv9E5pjDReXucImXcU9HEUT
	4noPbUKdgMNYgFqACuokJxqNpvvWCPwN7Ne7G8m4iMtsQM59vDQgIOE2Y6zNLyTvkN+j9y83lUC
	ACWaf269byNlsMJn84rQtzGtElknAhA==
X-Google-Smtp-Source: AGHT+IFLBUsjEEaRTMKTTS5UYe1p7dIIzUWH6NZxIBU0sDo3Xlc4F0hHutvr4vh9c1wWtrm9SoU6bw==
X-Received: by 2002:a17:907:7202:b0:af9:bfef:156b with SMTP id a640c23a62f3a-afe296a7876mr865808766b.59.1756129012418;
        Mon, 25 Aug 2025 06:36:52 -0700 (PDT)
Received: from [192.168.0.24] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe91744c66sm72984966b.88.2025.08.25.06.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 06:36:52 -0700 (PDT)
Message-ID: <01c67173-818c-48cf-8515-060751074c37@linaro.org>
Date: Mon, 25 Aug 2025 16:36:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
To: David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org,
 Christoph Hellwig <hch@infradead.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-23-eugen.hristev@linaro.org>
 <ffc43855-2263-408d-831c-33f518249f96@redhat.com>
 <e66f29c2-9f9f-4b04-b029-23383ed4aed4@linaro.org>
 <751514db-9e03-4cf3-bd3e-124b201bdb94@redhat.com>
 <aJCRgXYIjbJ01RsK@tiehlicka>
 <e2c031e8-43bd-41e5-9074-c8b1f89e04e6@linaro.org>
 <23e7ec80-622e-4d33-a766-312c1213e56b@redhat.com>
 <f43a61b4-d302-4009-96ff-88eea6651e16@linaro.org>
 <77d17dbf-1609-41b1-9244-488d2ce75b33@redhat.com>
 <ecd33fa3-8362-48f0-b3c2-d1a11d8b02e3@linaro.org>
 <9f13df6f-3b76-4d02-aa74-40b913f37a8a@redhat.com>
 <64a93c4a-5619-4208-9e9f-83848206d42b@linaro.org>
 <f1f290fc-b2f0-483b-96d5-5995362e5a8b@redhat.com>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <f1f290fc-b2f0-483b-96d5-5995362e5a8b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4E01C100013
X-Stat-Signature: 1ue7cji6iok7row3irbo9k4q7wwt751c
X-Rspam-User: 
X-HE-Tag: 1756129014-168962
X-HE-Meta: U2FsdGVkX1/eQEjIltB5sGGkyTSaYLVvmb6vkeQxMphfPM99rxGXNY5CynADMV5xEXRk+W84M0qHNgU2ubSRGgZc+ciNCRs8qQhJ3obwuPZYmQLXb2KS+5oEQt5SGSqDVHHTXa4rQKMHRVjwAzo59XDU3VoSYSC97rRiBMqV4wdRHRoicONoGaqJYvHQpSHPk2ooXgifCsqz3y/31+5AMoxSOh+aWZr3pDdCNg9KjTYR0tJkaczeVbqMZ2QoDKJi7bHsvoNSQU5VwHBD6T9Ub4F2i3FSvuO8aax1UMP6RNgjbhuOTGnkyO03gSnBGYdoxI6kbLOgH7H+adxxsFYvEXdTem12vhCQR+vVvUBCgnsMom0PRbX42MjS/Ont9QRXbS03pEFcTwa643OzsVErn+igAe9OjcEm94lAxjj29LbZSkIi4dX8W5ErlW33XMRz9tDqD92rKS4k+oN6IJrKbRd2AfDTJdXD78+gdA8NsLAtJNuXqimI39QnvaRSbsCgrVxXSjGjYTabZU/0yLUZ3BWeTs24d2nLoG5U5qt/txnIIlceh2k0o9KBQjjn+qdXapoplSmIloaObbVB3B9b65KIYfwkMM9eP/4y+iSbMr4VxMVyLu2YRCyM9MKgF9FY3jNwiSWnKTHBFBT3J1XooIJ8sU17pP3dsgaETmFXS6CKcSN0L00/odtzgjGnqM6rSGfzALtLnFODDHk1wAQUpsPLh55WoOEQ9AhSbiL6q+Z1QZ0fJcfU4ye9u29DN41+Q7gLL34+3LQdkX0qzNL8vUuWNBBdLYXISbr7etsRMpH1I+yMncdZN3BLuH1Z4XTXpuqDmZQbR79D/3pAo+SsbeVDB+mW95ayG9N/LZVTPvoAhO1Aq4xoOvMzgtUUmcPcgSt/6e7/ww9ZU9coHRbXZ6jqOA0joj20+H+zEdxMl8UfNBRxoBcJ6hUif5AUjafW15ALPs+dC8vEceIJbYD
 bOlU60sC
 26B2CKOMHxRunnaLn3m/ApldoANKo55IK6utzNC0uiu+9s6Z/tSKnvhjXicEDGROvqrCZM6zUgaTY89i8kyVG1PfCklq6jYIOMWjwejyFuhj7a6BKCJZt/831yZqylwu/fwSFcSszpk429iklI+N0hetWdrqoiNYfAs5sz7+EpuqWX4wOLSVGUcrwgMCxYFHCbH7REN1D/d3Yjp5McTwANxdBfcs08v0S1kpNOV1WtvTiYkNAPJ+xe10/jZ3OASLjiqnjbFuR9mHn71fYShSUKu8rQZNGrjGv0dn9GuR03EGo4UYG5xp5N1bY2h+p8oKRR0mhvnVgzIzcJFZBZgd/PMcb48OYu6OEf2o2/tF7QjNjfSg/y7LAQhwS7o2s6cb5++1eTIDG969mfnUJ6zN6ivq7gk1cjCXiPKDkEpsu2dOXQb0eAaGmbzZWrammWatykyHRUVHfPc1P9e0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/25 16:20, David Hildenbrand wrote:
> 
>>>
>>> IIRC, kernel/vmcore_info.c is never built as a module, as it also
>>> accesses non-exported symbols.
>>
>> Hello David,
>>
>> I am looking again into this, and there are some things which in my
>> opinion would be difficult to achieve.
>> For example I looked into my patch #11 , which adds the `runqueues` into
>> kmemdump.
>>
>> The runqueues is a variable of `struct rq` which is defined in
>> kernel/sched/sched.h , which is not supposed to be included outside of
>> sched.
>> Now moving all the struct definition outside of sched.h into another
>> public header would be rather painful and I don't think it's a really
>> good option (The struct would be needed to compute the sizeof inside
>> vmcoreinfo). Secondly, it would also imply moving all the nested struct
>> definitions outside as well. I doubt this is something that we want for
>> the sched subsys. How the subsys is designed, out of my understanding,
>> is to keep these internal structs opaque outside of it.
> 
> All the kmemdump module needs is a start and a length, correct? So the 
> only tricky part is getting the length.

I also have in mind the kernel user case. How would a kernel programmer
want to add some kernel structs/info/buffers into kmemdump such that the
dump would contain their data ? Having "KMEMDUMP_VAR(...)" looks simple
enough.
Otherwise maybe the programmer has to write helpers to compute lengths
etc, and stitch them into kmemdump core.
I am not saying it's impossible, but just tiresome perhaps.

> 
> One could just add a const variable that holds this information, or even 
> better, a simple helper function to calculate that.
> 
> Maybe someone else reading along has a better idea.

This could work, but it requires again adding some code into the
specific subsystem. E.g. struct_rq_get_size()
I am open to ideas , and thank you very much for your thoughts.

> 
> Interestingly, runqueues is a percpu variable, which makes me wonder if 
> what you had would work as intended (maybe it does, not sure).

I would not really need to dump the runqueues. But the crash tool which
I am using for testing, requires it. Without the runqueues it will not
progress further to load the kernel dump.
So I am not really sure what it does with the runqueues, but it works.
Perhaps using crash/gdb more, to actually do something with this data,
would give more insight about its utility.
For me, it is a prerequisite to run crash, and then to be able to
extract the log buffer from the dump.

> 
>>
>>  From my perspective it's much simpler and cleaner to just add the
>> kmemdump annotation macro inside the sched/core.c as it's done in my
>> patch. This macro translates to a noop if kmemdump is not selected.
> 
> I really don't like how we are spreading kmemdump all over the kernel, 
> and adding complexity with __section when really, all we need is a place 
> to obtain a start and a length.
> 

I understand. The section idea was suggested by Thomas. Initially I was
skeptic, but I like how it turned out.

> So we should explore if there is anything easier possible.
> 
>>>
>>>>
>>>> So I am unsure whether just removing the static and adding them into
>>>> header files would be more acceptable.
>>>>
>>>> Added in CC Cristoph Hellwig and Sergey Senozhatsky maybe they could
>>>> tell us directly whether they like or dislike this approach, as kmemdump
>>>> would be builtin and would not require exports.
>>>>
>>>> One other thing to mention is the fact that the printk code dynamically
>>>> allocates memory that would need to be registered. There is no mechanism
>>>> for kmemdump to know when this process has been completed (or even if it
>>>> was at all, because it happens on demand in certain conditions).
>>>
>>> If we are talking about memblock allocations, they sure are finished at
>>> the time ... the buddy is up.
>>>
>>> So it's just a matter of placing yourself late in the init stage where
>>> the buddy is already up and running.
>>>
>>> I assume dumping any dynamically allocated stuff through the buddy is
>>> out of the picture for now.
>>>
>>
>> The dumping mechanism needs to work for dynamically allocated stuff, and
>> right now, it works for e.g. printk, if the buffer is dynamically
>> allocated later on in the boot process.
> 
> You are talking about the memblock_alloc() result, correct? Like
> 
> new_log_buf = memblock_alloc(new_log_buf_len, LOG_ALIGN);
> 
> The current version is always stored in
> 
> static char *log_buf = __log_buf;
> 
> 
> Once early boot is done and memblock gets torn down, you can just use 
> log_buf and be sure that it will not change anymore.
> 
>>
>> To have this working outside of printk, it would be required to walk
>> through all the printk structs/allocations and select the required info.
>> Is this something that we want to do outside of printk ?
> 
> I don't follow, please elaborate.
> 
> How is e.g., log_buf_len_get() + log_buf_addr_get() not sufficient, 
> given that you run your initialization after setup_log_buf() ?
> 
> 

My initial thought was the same. However I got some feedback from Petr
Mladek here :

https://lore.kernel.org/lkml/aBm5QH2p6p9Wxe_M@localhost.localdomain/

Where he explained how to register the structs correctly.
It can be that setup_log_buf is called again at a later time perhaps.

