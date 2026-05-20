Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4530CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 07:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE826B0005; Wed, 20 May 2026 03:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E976B0088; Wed, 20 May 2026 03:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385056B008A; Wed, 20 May 2026 03:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 285A56B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:02:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C85FA401B8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:02:26 +0000 (UTC)
X-FDA: 84786904692.01.398C5CB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 94D621C0009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:02:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QmRVncha;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779260544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GhXITUOH1VGBUAtAh5cZfjcK36VXLo1VALX04MFtLL0=;
	b=u7jV4LEzqMkdaxGjYunJKVlxeRxlV3CUuAFCMg9llV29Zuj2WsxRe//UrnXiDI17+wLc6C
	V5o+3aMqsRIanpPc7PzCNG9sKVfDpMsVK7CURdIKUXam6cpLKComab4XPXc9WhyJffbnK1
	0k+uguur3XyTLXPInn39cnhNcheKubE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779260544; a=rsa-sha256;
	cv=none;
	b=gmTVyiw9EORGgq/7OMrso3Rdtq5X6hHC31ELShG1q+kPWnXQNzuZg7Hs6oq0/VSFjw9IGb
	nGtsEa7YyNgpQEqhoohwDuNzpArkgYg2pNDYFrvHsAkFq8dHhDSprQ2GIg73ECa1AH/HnJ
	O4jS6gdCO9aV38kLD5kN23IRL3ww9c4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QmRVncha;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92B62266C;
	Wed, 20 May 2026 00:02:16 -0700 (PDT)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 627A23F85F;
	Wed, 20 May 2026 00:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779260541; bh=z+Gawe1ObcnCuFaB6f/Zzi3ezhaODFYj1zjM+3lFNk8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QmRVnchaASY4z1Vexjo2bfobBwTQ8nYRVyjCq70gsDmmY88cDyAvzP/kNd5rKRcCY
	 RBaYexApbbHUf1d7ilLvrOQz9BvuMgkQDQGxnp/wl8FcaLus+dkJp734SzVHcvlULh
	 49EA2JY3jv9n7uwyvSd/MZ/s+c8TlVfXj8uFaiMM=
Message-ID: <4061d696-1567-41fe-9ff9-af408ca6d4bd@arm.com>
Date: Wed, 20 May 2026 12:32:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] kasan: avoid re-poisoning tag-based kmalloc redzones
To: Ryan Roberts <ryan.roberts@arm.com>, akpm@linux-foundation.org,
 vbabka@kernel.org, harry@kernel.org, ryabinin.a.a@gmail.com
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, kasan-dev@googlegroups.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com
References: <20260513105734.3380544-1-dev.jain@arm.com>
 <20260513105734.3380544-3-dev.jain@arm.com>
 <14da7ffe-1332-45d0-86d6-e9d9ae0a4fe0@arm.com>
 <2609d691-5e70-4baa-8e58-99f5ea708c6a@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <2609d691-5e70-4baa-8e58-99f5ea708c6a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 94D621C0009
X-Stat-Signature: wbz3ojudaxhcjjo51njahxmbnde5w1qm
X-Rspam-User: 
X-HE-Tag: 1779260544-442072
X-HE-Meta: U2FsdGVkX189ZCoh7L707HOpRvNJqA2cI9uCIwhLoQ9sH8R33i/KlzNupibskSLgFF5UpMwJFfw4OzRTXgDPSPG55z1E1myHlof0DWeo05nG4ZhKbDYLhL90/nmzluruSRnIRKY636yazzC2O8eOvxqg7cEKcYctbwWGqUjHmZ61Ewn21FaKd04KhE4vC7ON3i10f714kMcZJHExZybGfwzBzAZW6nS/WVJU6ChGzto0ugfunuLxTofq7tOmYpPpSJAUIKBJtdbuG6JdK5nlxXwwdOGdWKg9SqCmbpqIKgsucGQ8vLye7XzIEbB8LkowMdUOF01zyDTqS1pCJgjrgc6pkMQSPLVTD10bHOJw7nYXf9E+4CMlvnRW90YvuZ8fYQ6myMXq+tp6e/IVa4bHlBvdpgaPXzV4EM5shkjYH/q12vpNz+fryaXeMOu2tm9TUPPORDxtSb/pbuijTkj2HIMPJqsDluSkGYnoaeeNkyebUIFUK513KabTz2It99qByMtDnoyj2WV1K9pyhkZqjLIkmoBAE9egYyNngUQkecsOWzE5shxblJtnxxkkUgZu4eW9RfuUwLs9Bo8kNgskh4pFFcG/rYYfZ7RbLOsiqfvRC99is8d2Mup42d3F/3lK4x/Aj8+fQOJUrOd4YRtkJXI2VQJbsRnEA9j1Uh/mXk4k+Sz62RC6Bk9QvdGmP4DpnAerg1j7+bR3E5SthjN344SkNEn+v54WAx04XLY9fCpionFlNzzriwDlI1h8qIJxTQNhgo1bxjRPv1OU/uuofkx9FjC+V21IhS9UJGLWsyIiwfOmMMoKpvW4gYRxV7K1a80vvDwJwxvjCnqzyROQDiUK+Ul4jcDLfIVIQs+SshKo6K0gwcjRbH4vpNbFwUYjQdLmu7j2EIojaDzIsVaVVvkaSi7bXmWyRd04Tgt6Xo99QEMrks7DNP6HoNC5xn+CXuHX/XycWoM6QkUho/p
 XW+IZRYg
 VPK/jQoBD9Mj2HIAwmXll8t6Juca97MfxEJMZePZB+X22gVSnChi2JveLh/JmHHWPAKw9eA2853ugUsGy8FP70fYZlPVpKa/5YxQUYMt3OuK9F6afV4XI42gFfIIvQSzTZ+eOsMG0EYAqi76ko/pZAglsInDtjjxg2esp869y+os47e2PCQ4WIu5GmrK2gJJisxVPsvVLO/zGGjYksWYjsuJS86vfOAR63KpfziVIiUHeuJ9q6FfnaQnCR7wfYHSAhThLkVtEaK66mNUvtReFynUawvN97OMvLqjWnz1TSZaha5P74arkDmcQ122ihMn9aXC7p84YGMiQwGw4uJ1IxnH089vVJ38Tb1JgudQ+du1O504zBJbkgEalYATAn8XJfLqYLpQMc4raOuDrrM9SIUPOQTVGc5v931zfbbAz6Gwm58E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 19/05/26 2:23 pm, Ryan Roberts wrote:
> On 19/05/2026 09:15, Dev Jain wrote:
>>
>>
>> On 13/05/26 4:27 pm, Dev Jain wrote:
>>> When we allocate object from slab, kasan will unpoison the entire object.
>>> In case of allocation from kmalloc caches, the actual allocation size
>>> request can be less than the size of the kmalloc cache. kasan poisons
>>> the bytes following allocation size up till object size to catch OOB.
>>>
>>> We can do this operation in one shot: while unpoisoning the object upon
>>> allocation, only unpoison up till allocation size bytes, so that the
>>> bytes following that up till object size remain poisoned.
>>>
>>> Currently when we free an object into the slab, we use KASAN_SLAB_FREE for
>>> poisoning, and use KASAN_SLAB_REDZONE for poisoning the tail end. For
>>> tag-based kasan, these two are equal, as opposed to generic kasan. So we
>>> make this optimization only for tag-based kasan.
>>>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>
>> Sashiko: https://sashiko.dev/#/patchset/20260513105734.3380544-1-dev.jain@arm.com
>>
>> So I'll explain what Sashiko is saying with examples. If I am mis-interpreting
>> then please correct me!
>>
>> Problem 1:
>>
>> p = kzalloc(96, GFP_KERNEL);                 // kmalloc-128
>> p = krealloc(p, 120, GFP_KERNEL | __GFP_ZERO);
>>
>> Before my patch, kzalloc zeroed bytes 0..127, krealloc exposes bytes 96..119
>> which are already zero from kzalloc.
>>
>> After my patch, kzalloc zeroes only 0..95, krealloc may think old
>> size is 128, so it does not zero 96..119, 96..119 may contain stale data.
>>
>> Why is this a problem? 
> 
> Intuitively, I would say it's a problem if you're leaking when you previously
> were not.
> 
>> Surely caller of krealloc shouldn't be
>> relying on a previous zeroing. krealloc documentation explicitly says that
>> GFP_ZERO is ignored.
> 
> What would happen if you did:
> 
> p = kzalloc(96, GFP_KERNEL);                 // kmalloc-128
> p = krealloc(p, 129, GFP_KERNEL | __GFP_ZERO);
> 
> Presumably the krealloc() would have to move the whole allocation to the next
> biggest bin? Would p[128] be zeroed? If so, then I'd say your change is problematic.
> 
>>
>>
>> Problem 2 for SW tags:
>>
>> p = kzalloc(97, GFP_KERNEL);   // kmalloc-128, granule = 16
>>
>> Before patch:
>>
>> KASAN unpoisons 0..111
>> memset zeroes 0..127
>> p[100] will not be caught by KASAN, but reads zero
>>
>> After patch:
>>
>> KASAN unpoisons 0..111
>> memset zeroes only 0..96
>> p[100] will not be caught by KASAN and reads stale data
>>
>> Again why is this a problem?
> 
> Because you have defeated KASAN and are leaking data? I think you'd want to zero
> at least to the end of the KASAN granule?

I got the problem now. The problem is that krealloc() does not know what was the
old allocation size.

So only talking about HW tags, can't we simply do the following. We can use
HW tags integrated init to initialize only the part we want to unpoison.


diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index b7d05c2a6d93d..c424be3cd02bb 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -474,7 +474,7 @@ void * __must_check __kasan_krealloc(const void *object, size_t size, gfp_t flag
 	 * Part of it might already have been unpoisoned, but it's unknown
 	 * how big that part is.
 	 */
-	kasan_unpoison(object, size, false);
+	kasan_unpoison(object, size, want_init_on_alloc(flags));

 	slab = virt_to_slab(object);

diff --git a/mm/slub.c b/mm/slub.c
index 0baa906f39ab8..62ee59fc389d8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6686,7 +6686,7 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
 		goto alloc_new;

 	/* Zero out spare memory. */
-	if (want_init_on_alloc(flags)) {
+	if (want_init_on_alloc(flags) && !kasan_has_integrated_init()) {
 		kasan_disable_current();
 		if (orig_size && orig_size < new_size)
 			memset(kasan_reset_tag(p) + orig_size, 0, new_size - orig_size);



> 
> Thanks,
> Ryan
> 
> 
>>
>>>  include/linux/kasan.h | 17 +++++++++----
>>>  mm/kasan/common.c     | 55 +++++++++++++++++++++++++++++++++----------
>>>  mm/slub.c             | 11 +++++----
>>>  3 files changed, 61 insertions(+), 22 deletions(-)
>>>
>>> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
>>> index bf233bde68c7..fd7c1f5f9fd6 100644
>>> --- a/include/linux/kasan.h
>>> +++ b/include/linux/kasan.h
>>> @@ -102,6 +102,12 @@ static inline bool kasan_has_integrated_init(void)
>>>  	return kasan_hw_tags_enabled();
>>>  }
>>>  
>>> +static inline bool kasan_has_tag_based_kmalloc_redzones(void)
>>> +{
>>> +	return kasan_enabled() &&
>>> +	       (IS_ENABLED(CONFIG_KASAN_SW_TAGS) || kasan_hw_tags_enabled());
>>> +}
>>> +
>>>  #ifdef CONFIG_KASAN
>>>  void __kasan_unpoison_range(const void *addr, size_t size);
>>>  static __always_inline void kasan_unpoison_range(const void *addr, size_t size)
>>> @@ -244,13 +250,14 @@ static __always_inline void kasan_kfree_large(void *ptr)
>>>  		__kasan_kfree_large(ptr, _RET_IP_);
>>>  }
>>>  
>>> -void * __must_check __kasan_slab_alloc(struct kmem_cache *s,
>>> -				       void *object, gfp_t flags, bool init);
>>> +void * __must_check __kasan_slab_alloc(struct kmem_cache *s, void *object,
>>> +				       size_t size, gfp_t flags, bool init);
>>>  static __always_inline void * __must_check kasan_slab_alloc(
>>> -		struct kmem_cache *s, void *object, gfp_t flags, bool init)
>>> +		struct kmem_cache *s, void *object, size_t size,
>>> +		gfp_t flags, bool init)
>>>  {
>>>  	if (kasan_enabled())
>>> -		return __kasan_slab_alloc(s, object, flags, init);
>>> +		return __kasan_slab_alloc(s, object, size, flags, init);
>>>  	return object;
>>>  }
>>>  
>>> @@ -437,7 +444,7 @@ static inline bool kasan_slab_free(struct kmem_cache *s, void *object,
>>>  }
>>>  static inline void kasan_kfree_large(void *ptr) {}
>>>  static inline void *kasan_slab_alloc(struct kmem_cache *s, void *object,
>>> -				   gfp_t flags, bool init)
>>> +				   size_t size, gfp_t flags, bool init)
>>>  {
>>>  	return object;
>>>  }
>>> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
>>> index b7d05c2a6d93..9a4db9c21aaf 100644
>>> --- a/mm/kasan/common.c
>>> +++ b/mm/kasan/common.c
>>> @@ -326,14 +326,25 @@ void __kasan_kfree_large(void *ptr, unsigned long ip)
>>>  	/* The object will be poisoned by kasan_poison_pages(). */
>>>  }
>>>  
>>> +static inline size_t slab_unpoison_size(struct kmem_cache *cache, size_t size)
>>> +{
>>> +	if (kasan_has_tag_based_kmalloc_redzones() && is_kmalloc_cache(cache))
>>> +		return min_t(size_t, size, cache->object_size);
>>> +
>>> +	return cache->object_size;
>>> +}
>>> +
>>>  static inline void unpoison_slab_object(struct kmem_cache *cache, void *object,
>>> -					gfp_t flags, bool init)
>>> +					size_t size, gfp_t flags, bool init)
>>>  {
>>>  	/*
>>> -	 * Unpoison the whole object. For kmalloc() allocations,
>>> -	 * poison_kmalloc_redzone() will do precise poisoning.
>>> +	 * For tag-based modes, kmalloc redzones all use the same invalid tag.
>>> +	 * Keep the tail poisoned and only unpoison the requested allocation
>>> +	 * size. Generic KASAN keeps distinct shadow values for free objects and
>>> +	 * redzones, so it still unpoisons the whole object and later poisons
>>> +	 * the precise redzone.
>>>  	 */
>>> -	kasan_unpoison(object, cache->object_size, init);
>>> +	kasan_unpoison(object, slab_unpoison_size(cache, size), init);
>>>  
>>>  	/* Save alloc info (if possible) for non-kmalloc() allocations. */
>>>  	if (kasan_stack_collection_enabled() && !is_kmalloc_cache(cache))
>>> @@ -341,7 +352,8 @@ static inline void unpoison_slab_object(struct kmem_cache *cache, void *object,
>>>  }
>>>  
>>>  void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
>>> -					void *object, gfp_t flags, bool init)
>>> +					void *object, size_t size,
>>> +					gfp_t flags, bool init)
>>>  {
>>>  	u8 tag;
>>>  	void *tagged_object;
>>> @@ -363,11 +375,18 @@ void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
>>>  	tagged_object = set_tag(object, tag);
>>>  
>>>  	/* Unpoison the object and save alloc info for non-kmalloc() allocations. */
>>> -	unpoison_slab_object(cache, tagged_object, flags, init);
>>> +	unpoison_slab_object(cache, tagged_object, size, flags, init);
>>>  
>>>  	return tagged_object;
>>>  }
>>>  
>>> +static inline void save_kmalloc_alloc_info(struct kmem_cache *cache,
>>> +					   void *object, gfp_t flags)
>>> +{
>>> +	if (kasan_stack_collection_enabled() && is_kmalloc_cache(cache))
>>> +		kasan_save_alloc_info(cache, object, flags);
>>> +}
>>> +
>>>  static inline void poison_kmalloc_redzone(struct kmem_cache *cache,
>>>  				const void *object, size_t size, gfp_t flags)
>>>  {
>>> @@ -394,8 +413,7 @@ static inline void poison_kmalloc_redzone(struct kmem_cache *cache,
>>>  	 * Save alloc info (if possible) for kmalloc() allocations.
>>>  	 * This also rewrites the alloc info when called from kasan_krealloc().
>>>  	 */
>>> -	if (kasan_stack_collection_enabled() && is_kmalloc_cache(cache))
>>> -		kasan_save_alloc_info(cache, (void *)object, flags);
>>> +	save_kmalloc_alloc_info(cache, (void *)object, flags);
>>>  
>>>  }
>>>  
>>> @@ -411,8 +429,14 @@ void * __must_check __kasan_kmalloc(struct kmem_cache *cache, const void *object
>>>  	if (is_kfence_address(object))
>>>  		return (void *)object;
>>>  
>>> -	/* The object has already been unpoisoned by kasan_slab_alloc(). */
>>> -	poison_kmalloc_redzone(cache, object, size, flags);
>>> +	/*
>>> +	 * For tag-based modes, the object has already been precisely
>>> +	 * unpoisoned by kasan_slab_alloc(). The tail remains poisoned.
>>> +	 */
>>> +	if (kasan_has_tag_based_kmalloc_redzones())
>>> +		save_kmalloc_alloc_info(cache, (void *)object, flags);
>>> +	else
>>> +		poison_kmalloc_redzone(cache, object, size, flags);
>>>  
>>>  	/* Keep the tag that was set by kasan_slab_alloc(). */
>>>  	return (void *)object;
>>> @@ -561,11 +585,16 @@ void __kasan_mempool_unpoison_object(void *ptr, size_t size, unsigned long ip)
>>>  		return;
>>>  
>>>  	/* Unpoison the object and save alloc info for non-kmalloc() allocations. */
>>> -	unpoison_slab_object(slab->slab_cache, ptr, flags, false);
>>> +	unpoison_slab_object(slab->slab_cache, ptr, size, flags, false);
>>>  
>>>  	/* Poison the redzone and save alloc info for kmalloc() allocations. */
>>> -	if (is_kmalloc_cache(slab->slab_cache))
>>> -		poison_kmalloc_redzone(slab->slab_cache, ptr, size, flags);
>>> +	if (is_kmalloc_cache(slab->slab_cache)) {
>>> +		if (kasan_has_tag_based_kmalloc_redzones())
>>> +			save_kmalloc_alloc_info(slab->slab_cache, ptr, flags);
>>> +		else
>>> +			poison_kmalloc_redzone(slab->slab_cache, ptr, size,
>>> +					       flags);
>>> +	}
>>>  }
>>>  
>>>  bool __kasan_check_byte(const void *address, unsigned long ip)
>>> diff --git a/mm/slub.c b/mm/slub.c
>>> index da3520769d1f..15144b2e078c 100644
>>> --- a/mm/slub.c
>>> +++ b/mm/slub.c
>>> @@ -4550,8 +4550,9 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>>>  	 * replacement of current poisoning under certain debug option, and
>>>  	 * won't break other sanity checks.
>>>  	 */
>>> -	if (kmem_cache_debug_flags(s, SLAB_STORE_USER | SLAB_RED_ZONE) &&
>>> -	    (s->flags & SLAB_KMALLOC))
>>> +	if ((s->flags & SLAB_KMALLOC) &&
>>> +	    (kmem_cache_debug_flags(s, SLAB_STORE_USER | SLAB_RED_ZONE) ||
>>> +	     kasan_has_tag_based_kmalloc_redzones()))
>>>  		zero_size = orig_size;
>>>  
>>>  	/*
>>> @@ -4573,7 +4574,8 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>>>  	 * As p[i] might get tagged, memset and kmemleak hook come after KASAN.
>>>  	 */
>>>  	for (i = 0; i < size; i++) {
>>> -		p[i] = kasan_slab_alloc(s, p[i], init_flags, kasan_init);
>>> +		p[i] = kasan_slab_alloc(s, p[i], orig_size, init_flags,
>>> +					kasan_init);
>>>  		if (p[i] && init && (!kasan_init ||
>>>  				     !kasan_has_integrated_init()))
>>>  			memset(p[i], 0, zero_size);
>>> @@ -7615,7 +7617,8 @@ static void early_kmem_cache_node_alloc(int node)
>>>  #ifdef CONFIG_SLUB_DEBUG
>>>  	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
>>>  #endif
>>> -	n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL, false);
>>> +	n = kasan_slab_alloc(kmem_cache_node, n, kmem_cache_node->object_size,
>>> +			     GFP_KERNEL, false);
>>>  	slab->freelist = get_freepointer(kmem_cache_node, n);
>>>  	slab->inuse = 1;
>>>  	kmem_cache_node->per_node[node].node = n;
>>
> 
> 


