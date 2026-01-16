Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC04D47CD6
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 11:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FF726B0093; Fri, 16 Jan 2026 06:25:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8BF6B0095; Fri, 16 Jan 2026 06:25:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784E66B009F; Fri, 16 Jan 2026 06:25:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 661976B0093
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:25:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27805C22CB
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:25:00 +0000 (UTC)
X-FDA: 84337595160.13.A720F5D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id A0BEF140006
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:24:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=biNtuGN7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ypZtmz1k;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=biNtuGN7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ypZtmz1k;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768562698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EPxWoGREDJBDCfaaqNFnAl/rLl9XxuU79MPtOoauRfg=;
	b=xNM5KZnZHuEst1Kvjf0KlPqjxNEA9R9Ku1YhPKTfNsoyXa5Pff9yLVCansy58+9zQiPsd6
	OtwUg5+iAHjCjm2L2atqiXc+TPcNNgYcPRNiQAsetIfulrmxZrg+MRfU4ijFQtzgOEAUzy
	0pmauOPV0ih1i5HIOUT4hJ/TZgvo88Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=biNtuGN7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ypZtmz1k;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=biNtuGN7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ypZtmz1k;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768562698; a=rsa-sha256;
	cv=none;
	b=yQFRvCiMFrnogW2IRrjr+VWAEx2PLwCLr1IKVUIAasQpQzFmgnjh3iQdzaYe+vq+tV4dcl
	IQTjCSYDzh9z6f06ofWPagB0QDJMG1usX9XUBs12uCAi4UedgEPHun4KNonBsYOR31zPRR
	6AKCiDyj+Ms3JV/WHDvWDT9X0DkJRvg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0C47D336A7;
	Fri, 16 Jan 2026 11:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768562696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EPxWoGREDJBDCfaaqNFnAl/rLl9XxuU79MPtOoauRfg=;
	b=biNtuGN7QWxMfL9DRBGYDCAGWEbHE54eFrVw/zIaCQnltNU8jvFnBsUe38ntDoHY8ktEnh
	EfVw57ewHwcclwsAbF5Pa0AFmSHnKXf3mnvKRxtEdlPvcuuI+y/pApYsFGx5vBXXje0o0r
	xzSRQJjS63dG+h/swU8kZ48Ihar8eM4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768562696;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EPxWoGREDJBDCfaaqNFnAl/rLl9XxuU79MPtOoauRfg=;
	b=ypZtmz1kT5RKMaAeLMUJmN/BwWs7hH5IOndqlaoX4481tMZ14YtbulHcekPA6MFce6FNEZ
	UCZEjeRP5XnQygDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768562696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EPxWoGREDJBDCfaaqNFnAl/rLl9XxuU79MPtOoauRfg=;
	b=biNtuGN7QWxMfL9DRBGYDCAGWEbHE54eFrVw/zIaCQnltNU8jvFnBsUe38ntDoHY8ktEnh
	EfVw57ewHwcclwsAbF5Pa0AFmSHnKXf3mnvKRxtEdlPvcuuI+y/pApYsFGx5vBXXje0o0r
	xzSRQJjS63dG+h/swU8kZ48Ihar8eM4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768562696;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EPxWoGREDJBDCfaaqNFnAl/rLl9XxuU79MPtOoauRfg=;
	b=ypZtmz1kT5RKMaAeLMUJmN/BwWs7hH5IOndqlaoX4481tMZ14YtbulHcekPA6MFce6FNEZ
	UCZEjeRP5XnQygDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D44ED3EA63;
	Fri, 16 Jan 2026 11:24:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 45r3MQcgamlWMQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 11:24:55 +0000
Message-ID: <d310d788-b6df-47dc-9557-643813351838@suse.cz>
Date: Fri, 16 Jan 2026 12:24:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 04/20] slab: add sheaves to most caches
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-4-98225cfb50cf@suse.cz>
 <CAJuCfpFKKtxB2mREuOSa4oQu=MBGkbQRQNYSSnubAAgPENcO-Q@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpFKKtxB2mREuOSa4oQu=MBGkbQRQNYSSnubAAgPENcO-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xq6agd4sr9tpqjb5r6re516j9ndym6gr
X-Rspamd-Queue-Id: A0BEF140006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768562697-563122
X-HE-Meta: U2FsdGVkX1+5vpM0M9ABrfhgUlnVQmtC/x+FTJe0GHfxOQb0jX7jRhIuuHgc/m3d3gbgs099EvMOrUPDkEbDY8I9T3iP+PfXkVa0PtwF2RGflmftS9OtlpPeDqGyTnJHYx9LHDzSFkCZ1tfiyXDxBayDH6sqP71FLIqRjZpJvrqPUkq8bl/WY8nKn6XkcNBsUNIKeHluLv3KcCHsTAwr70WUbkqR4q8hcn1HVOrrjKWMJfKikpvi78aP4FvHpH28ZU4dM+oUmkUnIju5w6kgmKMenUY7RZOlTGRrJwuteR1QM2A7bNq0E503ClAiZIbvsN3AJiiq/dj2SrDHQOOb+0ILvEoQYbS6/PcuQRYO6THIVPozPs4O5ob51nVLCFlhFxpK1afIGtd1e5J76kGhI/R1JBerTD0whbojOZYAs3mOa4p0fsoiJt2pee8N2rTTTu9GtVqsiCVqGmge4ENY+BrrRWE+l9wd6vPpRHHM6nK2QuaGsyxvTgDr2yx69+CKPzuxpKBVZ+3tZUDCCfuov4was8LQB/xsn4NqahiPDqkwmGktsu0nINsGEGbXhDbPt8BReFMbmpRdzXbmRFMixFmmn3O/g08IEYYdS7115b92ZRYZ5KlVJs6RxBGBmZzJqAQL0iwPN7a+mRW8I2kJZbQpqnkHZqmmNxpbf1kiUaZr8y7T25t0D5BhM44AdGLNX2U4zMHMgdRvy+AMaOPWPMrs2c9ZAJkPhCKvZjR6Iu9yOyOfEc2wQv65kDvYksceMc3z7b0NEYtCKRsnakY/Dl+QRgS9iR/br5WL6oWmwggwahGooLRRmefzYDmI42MN4W5InUMvkrz5ZbghZ6Ml3SMP3qoGaYxGxlIDzJKxVzUu1OfX5us8d2GC0NFuD/rwZqmEqculLi73GlfEEKfVcWx8G56G8aY7vJE/bXFAF+tBmqWHclQgUc9ehBwZT6nkuLwTFUy/HKcwaj1P+GN
 wBb0r48y
 xkNwSsrgiQywnoO6UA8A1fIsNtOLihXGGZuh62JuKAuumw8q0BCG+Q8H/eibn9OeNSZ3yh2o7kIekby2MrKG04ESXRN4F1ZgkhP0sJuHdoZQYKWS40QPC5tnrjGXKkJRik8s9hepf6He7cjLC4aTjPnca6mYsaGsFzu+HxJDcKTjkP+dqmKJp0xfbvwKVx1t6juDLr2qDnwYnaBcFCHCBrrEEr48PlaRtRnBAsSUYpDbmBHZUjcz39M1vtzz0nppyDguqB8eVOn9S82YVdvbdJ9K3xTsHCDiLzcl1CIq+w6RkTSvJD6XjNzhE9oUaLFf9uDMg8Tw1OFpvswQrs8/zN9NBJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/16/26 06:45, Suren Baghdasaryan wrote:
> On Mon, Jan 12, 2026 at 3:17 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> In the first step to replace cpu (partial) slabs with sheaves, enable
>> sheaves for almost all caches. Treat args->sheaf_capacity as a minimum,
>> and calculate sheaf capacity with a formula that roughly follows the
>> formula for number of objects in cpu partial slabs in set_cpu_partial().
>>
>> This should achieve roughly similar contention on the barn spin lock as
>> there's currently for node list_lock without sheaves, to make
>> benchmarking results comparable. It can be further tuned later.
>>
>> Don't enable sheaves for bootstrap caches as that wouldn't work. In
>> order to recognize them by SLAB_NO_OBJ_EXT, make sure the flag exists
>> even for !CONFIG_SLAB_OBJ_EXT.
>>
>> This limitation will be lifted for kmalloc caches after the necessary
>> bootstrapping changes.
>>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> One nit but otherwise LGTM.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks.

>> ---
>>  include/linux/slab.h |  6 ------
>>  mm/slub.c            | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
>>  2 files changed, 47 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/slab.h b/include/linux/slab.h
>> index 2482992248dc..2682ee57ec90 100644
>> --- a/include/linux/slab.h
>> +++ b/include/linux/slab.h
>> @@ -57,9 +57,7 @@ enum _slab_flag_bits {
>>  #endif
>>         _SLAB_OBJECT_POISON,
>>         _SLAB_CMPXCHG_DOUBLE,
>> -#ifdef CONFIG_SLAB_OBJ_EXT
>>         _SLAB_NO_OBJ_EXT,
>> -#endif
>>         _SLAB_FLAGS_LAST_BIT
>>  };
>>
>> @@ -238,11 +236,7 @@ enum _slab_flag_bits {
>>  #define SLAB_TEMPORARY         SLAB_RECLAIM_ACCOUNT    /* Objects are short-lived */
>>
>>  /* Slab created using create_boot_cache */
>> -#ifdef CONFIG_SLAB_OBJ_EXT
>>  #define SLAB_NO_OBJ_EXT                __SLAB_FLAG_BIT(_SLAB_NO_OBJ_EXT)
>> -#else
>> -#define SLAB_NO_OBJ_EXT                __SLAB_FLAG_UNUSED
>> -#endif
>>
>>  /*
>>   * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 8ffeb3ab3228..6e05e3cc5c49 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -7857,6 +7857,48 @@ static void set_cpu_partial(struct kmem_cache *s)
>>  #endif
>>  }
>>
>> +static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
>> +                                            struct kmem_cache_args *args)
>> +
>> +{
>> +       unsigned int capacity;
>> +       size_t size;
>> +
>> +
>> +       if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
>> +               return 0;
>> +
>> +       /* bootstrap caches can't have sheaves for now */
>> +       if (s->flags & SLAB_NO_OBJ_EXT)
>> +               return 0;
>> +
>> +       /*
>> +        * For now we use roughly similar formula (divided by two as there are
>> +        * two percpu sheaves) as what was used for percpu partial slabs, which
>> +        * should result in similar lock contention (barn or list_lock)
>> +        */
>> +       if (s->size >= PAGE_SIZE)
>> +               capacity = 4;
>> +       else if (s->size >= 1024)
>> +               capacity = 12;
>> +       else if (s->size >= 256)
>> +               capacity = 26;
>> +       else
>> +               capacity = 60;
>> +
>> +       /* Increment capacity to make sheaf exactly a kmalloc size bucket */
>> +       size = struct_size_t(struct slab_sheaf, objects, capacity);
>> +       size = kmalloc_size_roundup(size);
>> +       capacity = (size - struct_size_t(struct slab_sheaf, objects, 0)) / sizeof(void *);
>> +
>> +       /*
>> +        * Respect an explicit request for capacity that's typically motivated by
>> +        * expected maximum size of kmem_cache_prefill_sheaf() to not end up
>> +        * using low-performance oversize sheaves
>> +        */
>> +       return max(capacity, args->sheaf_capacity);
>> +}
>> +
>>  /*
>>   * calculate_sizes() determines the order and the distribution of data within
>>   * a slab object.
>> @@ -7991,6 +8033,10 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
>>         if (s->flags & SLAB_RECLAIM_ACCOUNT)
>>                 s->allocflags |= __GFP_RECLAIMABLE;
>>
>> +       /* kmalloc caches need extra care to support sheaves */
>> +       if (!is_kmalloc_cache(s))
> 
> nit: All the checks for the cases when sheaves should not be used
> (like SLAB_DEBUG_FLAGS and SLAB_NO_OBJ_EXT) are done inside
> calculate_sheaf_capacity(). Only this is_kmalloc_cache() one is here.
> It would be nice to have all of them in the same place but maybe you
> have a reason for keeping it here?

Yeah, in "slab: handle kmalloc sheaves bootstrap" we call
calculate_sheaf_capacity() from another place for kmalloc normal caches so
the check has to be outside.

>> +               s->sheaf_capacity = calculate_sheaf_capacity(s, args);
>> +
>>         /*
>>          * Determine the number of objects per slab
>>          */
>> @@ -8595,15 +8641,12 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
>>
>>         set_cpu_partial(s);
>>
>> -       if (args->sheaf_capacity && !IS_ENABLED(CONFIG_SLUB_TINY)
>> -                                       && !(s->flags & SLAB_DEBUG_FLAGS)) {
>> +       if (s->sheaf_capacity) {
>>                 s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
>>                 if (!s->cpu_sheaves) {
>>                         err = -ENOMEM;
>>                         goto out;
>>                 }
>> -               // TODO: increase capacity to grow slab_sheaf up to next kmalloc size?
>> -               s->sheaf_capacity = args->sheaf_capacity;
>>         }
>>
>>  #ifdef CONFIG_NUMA
>>
>> --
>> 2.52.0
>>


