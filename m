Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB00CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 09:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ECAA8E0017; Sat, 16 Aug 2025 05:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29DAA8E000F; Sat, 16 Aug 2025 05:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3868E0017; Sat, 16 Aug 2025 05:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07D618E000F
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 05:33:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AFB631A0226
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 09:33:07 +0000 (UTC)
X-FDA: 83782106814.08.43E3BB9
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id C9688180003
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 09:33:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zq3almMM;
	spf=pass (imf16.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755336785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Px5kT9Zj2OEa6lf/DpL6BrsHwqOYEXNq7iLeLvlTsBw=;
	b=2j9NmFd/pLmg6Al3jLuf9ENTcDgciCnwc0J9W7l4F/U5vUkrxZ6y8OZirwA6co8xf1OANo
	frfqVrXNkVUrQapLowBa7Vv/U8/6SRqovzN+2N0OpQkkkhiFBa4eaBKQWePUFMZVg6VDRU
	ibwgdDhiFYOmU7IhOPxoC4+DtKDvB8k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zq3almMM;
	spf=pass (imf16.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755336785; a=rsa-sha256;
	cv=none;
	b=FvK6cFkJjLD43arJYNLYGvoa71j4f6QcOGHH/yBROXVjybbAHUBKnwQ3o7cd4sGgZpGdos
	IuhedxCG2zhiWRv8dj5JfWJe2Zp67oArVRWisRY+/Au24TZHqGSt3Hr2fAmMI5KGiipXiK
	hm7jwCVvABqUpGPeYxVylwp5cY/Tdm4=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3b9e4110df6so363681f8f.2
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755336784; x=1755941584; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Px5kT9Zj2OEa6lf/DpL6BrsHwqOYEXNq7iLeLvlTsBw=;
        b=Zq3almMMSOPMGENmodmjTI9UwJta4GZ7Fu5ov/TQnT+Y9gJvN32Qk863S8mbSqnsVA
         DqlT/TevwRyc8q6KWFz9KMjMJFVBk15FNOhkKVPgJU0o2/PCDa72s3Z5YgbxFptU13cT
         ps/tQ9YRnVaOfwaDm5sXB6Daj8JkBj+J0KTgCC+ZKPG+wVa/uJoLva/B/TXXfgxX5ktf
         8MClfxW6YIEQKt5ROyN6pRb4Sy6wvpcF7O84IVmb48Ur+qN5pKzFhL35/RGBL/i91kzw
         JpFMJ8qkLurnozFDuKZjVoe9smFYvll/fPr0l6qYVzSqNAGBdcVrNDyq3+q1jHJhj0tI
         zUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755336784; x=1755941584;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Px5kT9Zj2OEa6lf/DpL6BrsHwqOYEXNq7iLeLvlTsBw=;
        b=efN8M14wNM5N4AYxUtJx4vTDyducYWkLGpZOwl3js1eEGDeFnDJ4An4RQwrezwsmqA
         wt8xnwuTaH6/v+5ZodL2+ya/debY6a9PT0SKIIeC/VHLWevmUuDbjqdsQV3D9gFbDZ1R
         iXAm/JJK120QRb+yWywaKIwidfgBq90DxnJ79ppGEn0VXTxrblu6+oNjOCGuG3AgbkNv
         eBI7sJqxsqlOarFpvQDbFbVNICs+PG/lUnsj3V+3pS8+2FW8R7Yh7QIKu9QtVh0D8fFB
         ybck0QTCHuttVCHkSdAB8VETUnkJNRJcq7iOLKmqmIWcgHs+PokJA6fKm4B9qxHh8H7J
         PZ5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXpHpJFTuASfLaxGO/VgxS3eUXPk0I9oUzSbwPcAiMOTMO5EcuvkhJYC84b0xhwbb3OzcGk2iUt8A==@kvack.org
X-Gm-Message-State: AOJu0YyV0Z64lpBG8eRiBHZOTBHD8LjrHyDL/tapR8lTXTqD5OR0MFrq
	DmmQ66wJJTDHgGKLky4XhGJHor0WVj5qwoGz7pCyaf3jJmAx23zdc8vd
X-Gm-Gg: ASbGncumZRdSdKny2HRn3ZidV3vF16FK3U72lTgHQdMGp2og8X/kWZMca3EpulGAhFL
	eJzD6PGkzxDfgl9RWtPNRU+tKCss/Nji8GMqkXZDYow7Kz4VaPoDML97wyY1eweXD36WoqABd34
	C+i86qwoaTUYiVWmwwT0yi6bQoIAzpUOhoHbId+Dj6iQXEUBVZV3MHBW7XpfbkBh08o321AiLAZ
	qhL+SgeNjhAewo9wFlmX6dsRHbl/A3/0e/w3OOtTW1DtMFtNck5U1CFS/rIYJ3024yIOiGE48aQ
	1Ht9zX8ni0rcLBog9XGO5w0w+wuii8z19W3tvCIIVJeQ7JsPw/nHyyEfnaYcdTusuTdf4hh/SWC
	XcR7ZDQ+IGJxY3747g5NK3+50Be3VCOPNQRmbHM7FkkSPtUe4xbLw
X-Google-Smtp-Source: AGHT+IHOKiBGjTArO+Umj5Qhqd1VsyKLXbP72Y00mZJdxOsRmVixr/6cIZOinpjUeu5gz+hEOi9gkA==
X-Received: by 2002:a05:600c:444a:b0:459:d449:a629 with SMTP id 5b1f17b1804b1-45a21895202mr18979955e9.8.1755336783950;
        Sat, 16 Aug 2025 02:33:03 -0700 (PDT)
Received: from [192.168.100.4] ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb6475857dsm5171864f8f.2.2025.08.16.02.33.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 02:33:03 -0700 (PDT)
Message-ID: <eab6a734-b134-41a4-b455-7269eaaf033e@gmail.com>
Date: Sat, 16 Aug 2025 13:33:00 +0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: slub: avoid wake up kswapd in set_track_prepare
To: Harry Yoo <harry.yoo@oracle.com>, yangshiguang1011@163.com
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, glittao@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 yangshiguang <yangshiguang@xiaomi.com>
References: <20250814111641.380629-2-yangshiguang1011@163.com>
 <aKBAdUkCd95Rg85A@harry>
Content-Language: en-US
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
In-Reply-To: <aKBAdUkCd95Rg85A@harry>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C9688180003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: d9f8tt8fdgrgjc44kf39skn4ub8pjjs4
X-HE-Tag: 1755336785-570305
X-HE-Meta: U2FsdGVkX19o7wBMO8XKjbwDUp1hxkTIa3Bi0Gytkv2UL8+HcDC82jgUuhtmb/TjZ/iOcmTArklN3YeuxZl6wKPEqhNcsthixyuMhGFrpb32LDLAdccB+hj5f8CcT9vlbB44zQaKLQFsrRgo3OSkjpQkdVFZ7dCOyXfjtt0BABcxmsUJnHB0XyBrkLh0np1THjifbm1FRiBLklnCV6i4k+57duJqNz2Th7SKR5gksdL7L6Uxj+E2ttoW3DDiK5j7tmzp63usf+RPT/9M3BQWyOR1eAgr6OWYfyZ5DwqgGp1tsOaDSrhku65IDHZE7E16uEqpaRN0bxoRy2WGSmEk7C8+KumNXnzpK1loJV3+4B7TAcEOHLBQmDm0Xb/mNyf35Yruh3ChDQlDUopvfxhRkWRRaI/MiXGltqPjvJ86jceD1vFz1xTwDhP4J81pStVxNpt9Qyq8hb4KwIgWVHKOPvGTey/t1HJ3OJQaELk0PAMa6JReyUUbnzwU28hedNGPW1nnGyPsQ2MVFqa9htLwfIwiAluC6+MZROi0zyeXe0eeNP2GOD2rlsESwfkTrj+l0B9H1BPL66qdR/ZbjEjcsJ7L8kP5c7GsrkoCKnG01LC/u2y/wFbsP2urecS1kzJ8GCHJCT889CYIbcno+opzwVwcUZd9gEGbGnG6wVlWPOt1u0IiqSQwpEiYloQSeLKHs6phuURi6cgmGBnyfZmbW9EXLUsUs9ccX+elzptvuQKtsBNnhsKzAfPQQ6Bibl5OF5CFFyLspz3u9qda42mMr7n8LJU61pPSXJdC0+0kxB4wfXL4U1QQXuFhXveqHfDwx3AZEcTpJt1MONkEr3uredv/biE3YJCfPXYJ2LMg8qy5CCAyjKj2UlTo5K6oUE8zKCnbTBY4VJ3nmRnWrvpmLtQrQSJ0f7tp3L6P3cy3adWZeV3uQO3A3sM4cd6aKivBdD3VkMapKfrONlQAmM6
 QJTiLiQh
 bbwwIjD0gVIkMGCReIcoPeJB1fXS5VEccsDvaXzNI2Rhv8hC5I1TSFrly8+4SuzvBVUtlXobuER0O8Endno5F+a+bMgXrth0CxBjtJU/EBUY8TIE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than masking to GFP_NOWAIT—which still allows kswapd to be 
woken—let’s strip every reclaim bit (`__GFP_RECLAIM` and 
`__GFP_KSWAPD_RECLAIM`) and add `__GFP_NORETRY | __GFP_NOWARN`. That 
guarantees we never enter the slow path that calls `wakeup_kswapd()`, so 
the timer-base lock can’t be re-entered.

On 8/16/2025 12:25 PM, Harry Yoo wrote:
> On Thu, Aug 14, 2025 at 07:16:42PM +0800, yangshiguang1011@163.com wrote:
>> From: yangshiguang <yangshiguang@xiaomi.com>
>>
>> From: yangshiguang <yangshiguang@xiaomi.com>
>>
>> set_track_prepare() can incur lock recursion.
>> The issue is that it is called from hrtimer_start_range_ns
>> holding the per_cpu(hrtimer_bases)[n].lock, but when enabled
>> CONFIG_DEBUG_OBJECTS_TIMERS, may wake up kswapd in set_track_prepare,
>> and try to hold the per_cpu(hrtimer_bases)[n].lock.
>>
>> So avoid waking up kswapd.The oops looks something like:
> 
> Hi yangshiguang,
> 
> In the next revision, could you please elaborate the commit message
> to reflect how this change avoids waking up kswapd?
> 
>> BUG: spinlock recursion on CPU#3, swapper/3/0
>>   lock: 0xffffff8a4bf29c80, .magic: dead4ead, .owner: swapper/3/0, .owner_cpu: 3
>> Hardware name: Qualcomm Technologies, Inc. Popsicle based on SM8850 (DT)
>> Call trace:
>> spin_bug+0x0
>> _raw_spin_lock_irqsave+0x80
>> hrtimer_try_to_cancel+0x94
>> task_contending+0x10c
>> enqueue_dl_entity+0x2a4
>> dl_server_start+0x74
>> enqueue_task_fair+0x568
>> enqueue_task+0xac
>> do_activate_task+0x14c
>> ttwu_do_activate+0xcc
>> try_to_wake_up+0x6c8
>> default_wake_function+0x20
>> autoremove_wake_function+0x1c
>> __wake_up+0xac
>> wakeup_kswapd+0x19c
>> wake_all_kswapds+0x78
>> __alloc_pages_slowpath+0x1ac
>> __alloc_pages_noprof+0x298
>> stack_depot_save_flags+0x6b0
>> stack_depot_save+0x14
>> set_track_prepare+0x5c
>> ___slab_alloc+0xccc
>> __kmalloc_cache_noprof+0x470
>> __set_page_owner+0x2bc
>> post_alloc_hook[jt]+0x1b8
>> prep_new_page+0x28
>> get_page_from_freelist+0x1edc
>> __alloc_pages_noprof+0x13c
>> alloc_slab_page+0x244
>> allocate_slab+0x7c
>> ___slab_alloc+0x8e8
>> kmem_cache_alloc_noprof+0x450
>> debug_objects_fill_pool+0x22c
>> debug_object_activate+0x40
>> enqueue_hrtimer[jt]+0xdc
>> hrtimer_start_range_ns+0x5f8
>> ...
>>
>> Signed-off-by: yangshiguang <yangshiguang@xiaomi.com>
>> Fixes: 5cf909c553e9 ("mm/slub: use stackdepot to save stack trace in objects")
>> ---
>> v1 -> v2:
>>      propagate gfp flags to set_track_prepare()
>>
>> [1] https://lore.kernel.org/all/20250801065121.876793-1-yangshiguang1011@163.com
>> ---
>>   mm/slub.c | 21 +++++++++++----------
>>   1 file changed, 11 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 30003763d224..dba905bf1e03 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -962,19 +962,20 @@ static struct track *get_track(struct kmem_cache *s, void *object,
>>   }
>>   
>>   #ifdef CONFIG_STACKDEPOT
>> -static noinline depot_stack_handle_t set_track_prepare(void)
>> +static noinline depot_stack_handle_t set_track_prepare(gfp_t gfp_flags)
>>   {
>>   	depot_stack_handle_t handle;
>>   	unsigned long entries[TRACK_ADDRS_COUNT];
>>   	unsigned int nr_entries;
>> +	gfp_flags &= GFP_NOWAIT;
> 
> Is there any reason to downgrade it to GFP_NOWAIT when the gfp flag allows
> direct reclamation?
> 
>>   	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 3);
>> -	handle = stack_depot_save(entries, nr_entries, GFP_NOWAIT);
>> +	handle = stack_depot_save(entries, nr_entries, gfp_flags);
>>   
>>   	return handle;
>>   }
>>   #else
>> -static inline depot_stack_handle_t set_track_prepare(void)
>> +static inline depot_stack_handle_t set_track_prepare(gfp_t gfp_flags)
>>   {
>>   	return 0;
>>   }
>> @@ -4422,7 +4423,7 @@ static noinline void free_to_partial_list(
>>   	depot_stack_handle_t handle = 0;
>>   
>>   	if (s->flags & SLAB_STORE_USER)
>> -		handle = set_track_prepare();
>> +		handle = set_track_prepare(GFP_NOWAIT);
> 
> I don't think it is safe to use GFP_NOWAIT during free?
> 
> Let's say fill_pool() -> kmem_alloc_batch() fails to allocate an object
> and then free_object_list() frees allocated objects,
> set_track_prepare(GFP_NOWAIT) may wake up kswapd, and the same deadlock
> you reported will occur.
> 
> So I think it should be __GFP_NOWARN?
> 


