Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DAC2CD4F52
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 08:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099F26B0005; Tue, 19 May 2026 04:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B236B0088; Tue, 19 May 2026 04:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA30A6B008C; Tue, 19 May 2026 04:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D89E96B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:54:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4574940254
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:54:02 +0000 (UTC)
X-FDA: 84783557124.16.D1BBE1F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id D3C2A160006
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:53:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fSzoZtlt;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779180840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CRFYIR2juBknz40vE1C/ywWVzCmL8l+4o8tJrRkf+s=;
	b=3gkE3Nz0yM9iXycc0aVo2rS1WHnk3mR0NzY99YDJQMyfIdj0Sf2q9/FDSi3tUxSbHDTA8r
	yBvweLWhqicw1hL1QGIpSKW/puLuHlxRX5BWlROH57YsXKaP0siSVZ5xL+ZSXZ5434txQu
	PxvPh2q+vEHyMTx/T/NqQAnSyMRxRaQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fSzoZtlt;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779180840; a=rsa-sha256;
	cv=none;
	b=uhiGVwJycAgv2sJrHIuzs73+aIsvK3IYn4UDVqq/s4hi/xYRD3UjrUYldzm6lnUBazyDqp
	faoNZpFEMh6iG3q9ldixyuZA5UiwH21ofolt4cG5Y+GDlEh9C+oLkbb05wphhU6ZRGqHnD
	R4kHqKnLfwbB6XB8QMKBprkqS1o50lY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 773C034FC;
	Tue, 19 May 2026 01:53:53 -0700 (PDT)
Received: from [10.57.90.238] (unknown [10.57.90.238])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16F373F85F;
	Tue, 19 May 2026 01:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779180838; bh=9m3g68iZohH7nlU/DGiQB3qTcGS3h2EgujSLKlci3tc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fSzoZtltMXzCsNvgy6KTo/Lt4o+ML+Au+mkLPARFmb4EqGGuLhfsiohF66+1n0k8D
	 IAMrNNehPpApn+MLNU+l8BTnDKR9kk0dcJyLCJEXl6Wv6V4JGI4KGX6YoAAUpECu1Q
	 8u1M8JmgOZo+o7nmeV/cYxGYG4oUrj6vcPtWaYoE=
Message-ID: <2609d691-5e70-4baa-8e58-99f5ea708c6a@arm.com>
Date: Tue, 19 May 2026 09:53:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] kasan: avoid re-poisoning tag-based kmalloc redzones
Content-Language: en-GB
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
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
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <14da7ffe-1332-45d0-86d6-e9d9ae0a4fe0@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D3C2A160006
X-Stat-Signature: epiad1fguy14agnhof4faxe1n1gbpfux
X-HE-Tag: 1779180839-708469
X-HE-Meta: U2FsdGVkX1/NBOBiI+8nw+kFv3INRAxyuT0iKgxv0zmcf/ZFvlkav/hUfoUzuvkIRaY1pxn42ZPIUkmJ54Fq5Pbu/vPfExDYYCGEgabeNbK+uEZzk6ElKV4V9usujv+v4zPOa2JyTNkWGDO71rVvi4BE4/nSd44Z8+TYPLNZq4tsiOwXlt41PuQkGIHzMzQIvn0L9wmzwRFgwkjwHyIgaUvyzCsSZgLuSpILQimmLMT41hBkazoxhlgTKfBbkj2c0k4Zf95crHFZuqXqbbNjpSxRChwyscc8RSSiRt7iMOHCzKvLmqiMZH4dHQMC1gsjYjotRfdykOpBHJ2Y9QI3mV+fOzEft7tMpOpdDamYltGlm4eaNaGZfsqo9DhyRdk08LyqVRltmVbTHXuKqT8rFIpegyB4nXC4fAiMTuQE3rOWiZOrD/wIH1U/HVIWiQM3CyNL4ZmCk1ebvwmHTyzYrXSff2pjSMYSpBYKuFgTkyWRiSdWsHZxjM2wYZU8KX3ea01yqp/gWUj+HH8f1654gF1CXRiOWIN2rD7cKl2o0Lmhtw01UNG4Bml4Y1Mr9QluBAqArthUuU56eLjU9KwVmMGTal29FjVRp6U6QT2Fbc9kyW/QClwnxAK7G9inpGZtqvHpBwhMPLggVwos4l0zY2pguAV6sJLlMg9yhKdks5Qm2n5togXE9NSojEi/5R5mONnyaBAZOstfEznul04ljkOPnYkKreA2hL64oh3TU0CTG3gRtpGFWrqvSoFiYW82lh31i0EA6TGhU8t/v8meGxvBP/IK2elW+EoRODbDk8lkCbd/8brxp55lsQnxhTE+axy3tK5YKeVchWpJrQ32kObpnDvdTCg4An6b1zmlSq5ggdc1Xb+X/saIOUzy2+AyEYZHH8kJsV55Uy11icsk0xnY3WnkHNRj54/j4Qhep6uSZU7ZTKH75nHMEy7nvHliN6lrSENmS6gJTDzz+kG
 mcv2OFbb
 V3gQPblgAiOOCM7rlJTdZ8tFCL0bQw4+md6DVq6VlwPjKU/ou4zkEUd9CVhvoi8yH0JL4O6juEoyeWHYKXJiZJh0cTDEOICmQq83HnRpnzNKHtB8bwRBwdtk2bp9INBbsLOe2/oxvVbpd+CxcWsVNrBkS80Z0mcEvzmg7584Or6WrzoumqIDkDcpbOFyO2FFaZ4i4ZTc1dk1IFeYz6zDlkewx0EFD628WFZ2N1F83UcIZ0UyPO9cI2+8rRo3XtRtAaRkVkPPYjD4r1ChF5ZtmBK5K5dV0y6A0HeHhC1ppAylYV8dgRCBvQROwfcwwqLi/YDEIn4kEpPwRPgirnAikj0y0Sp75xsR6LCvW6l87vYhhNlK1RYhzkHX8PlWf5l5E2XEpEMonplJnQrz3KwiHoF/N9bBufGtRHKL63F0cw0m+AMI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/05/2026 09:15, Dev Jain wrote:
> 
> 
> On 13/05/26 4:27 pm, Dev Jain wrote:
>> When we allocate object from slab, kasan will unpoison the entire object.
>> In case of allocation from kmalloc caches, the actual allocation size
>> request can be less than the size of the kmalloc cache. kasan poisons
>> the bytes following allocation size up till object size to catch OOB.
>>
>> We can do this operation in one shot: while unpoisoning the object upon
>> allocation, only unpoison up till allocation size bytes, so that the
>> bytes following that up till object size remain poisoned.
>>
>> Currently when we free an object into the slab, we use KASAN_SLAB_FREE for
>> poisoning, and use KASAN_SLAB_REDZONE for poisoning the tail end. For
>> tag-based kasan, these two are equal, as opposed to generic kasan. So we
>> make this optimization only for tag-based kasan.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
> 
> Sashiko: https://sashiko.dev/#/patchset/20260513105734.3380544-1-dev.jain@arm.com
> 
> So I'll explain what Sashiko is saying with examples. If I am mis-interpreting
> then please correct me!
> 
> Problem 1:
> 
> p = kzalloc(96, GFP_KERNEL);                 // kmalloc-128
> p = krealloc(p, 120, GFP_KERNEL | __GFP_ZERO);
> 
> Before my patch, kzalloc zeroed bytes 0..127, krealloc exposes bytes 96..119
> which are already zero from kzalloc.
> 
> After my patch, kzalloc zeroes only 0..95, krealloc may think old
> size is 128, so it does not zero 96..119, 96..119 may contain stale data.
> 
> Why is this a problem? 

Intuitively, I would say it's a problem if you're leaking when you previously
were not.

> Surely caller of krealloc shouldn't be
> relying on a previous zeroing. krealloc documentation explicitly says that
> GFP_ZERO is ignored.

What would happen if you did:

p = kzalloc(96, GFP_KERNEL);                 // kmalloc-128
p = krealloc(p, 129, GFP_KERNEL | __GFP_ZERO);

Presumably the krealloc() would have to move the whole allocation to the next
biggest bin? Would p[128] be zeroed? If so, then I'd say your change is problematic.

> 
> 
> Problem 2 for SW tags:
> 
> p = kzalloc(97, GFP_KERNEL);   // kmalloc-128, granule = 16
> 
> Before patch:
> 
> KASAN unpoisons 0..111
> memset zeroes 0..127
> p[100] will not be caught by KASAN, but reads zero
> 
> After patch:
> 
> KASAN unpoisons 0..111
> memset zeroes only 0..96
> p[100] will not be caught by KASAN and reads stale data
> 
> Again why is this a problem?

Because you have defeated KASAN and are leaking data? I think you'd want to zero
at least to the end of the KASAN granule?

Thanks,
Ryan


> 
>>  include/linux/kasan.h | 17 +++++++++----
>>  mm/kasan/common.c     | 55 +++++++++++++++++++++++++++++++++----------
>>  mm/slub.c             | 11 +++++----
>>  3 files changed, 61 insertions(+), 22 deletions(-)
>>
>> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
>> index bf233bde68c7..fd7c1f5f9fd6 100644
>> --- a/include/linux/kasan.h
>> +++ b/include/linux/kasan.h
>> @@ -102,6 +102,12 @@ static inline bool kasan_has_integrated_init(void)
>>  	return kasan_hw_tags_enabled();
>>  }
>>  
>> +static inline bool kasan_has_tag_based_kmalloc_redzones(void)
>> +{
>> +	return kasan_enabled() &&
>> +	       (IS_ENABLED(CONFIG_KASAN_SW_TAGS) || kasan_hw_tags_enabled());
>> +}
>> +
>>  #ifdef CONFIG_KASAN
>>  void __kasan_unpoison_range(const void *addr, size_t size);
>>  static __always_inline void kasan_unpoison_range(const void *addr, size_t size)
>> @@ -244,13 +250,14 @@ static __always_inline void kasan_kfree_large(void *ptr)
>>  		__kasan_kfree_large(ptr, _RET_IP_);
>>  }
>>  
>> -void * __must_check __kasan_slab_alloc(struct kmem_cache *s,
>> -				       void *object, gfp_t flags, bool init);
>> +void * __must_check __kasan_slab_alloc(struct kmem_cache *s, void *object,
>> +				       size_t size, gfp_t flags, bool init);
>>  static __always_inline void * __must_check kasan_slab_alloc(
>> -		struct kmem_cache *s, void *object, gfp_t flags, bool init)
>> +		struct kmem_cache *s, void *object, size_t size,
>> +		gfp_t flags, bool init)
>>  {
>>  	if (kasan_enabled())
>> -		return __kasan_slab_alloc(s, object, flags, init);
>> +		return __kasan_slab_alloc(s, object, size, flags, init);
>>  	return object;
>>  }
>>  
>> @@ -437,7 +444,7 @@ static inline bool kasan_slab_free(struct kmem_cache *s, void *object,
>>  }
>>  static inline void kasan_kfree_large(void *ptr) {}
>>  static inline void *kasan_slab_alloc(struct kmem_cache *s, void *object,
>> -				   gfp_t flags, bool init)
>> +				   size_t size, gfp_t flags, bool init)
>>  {
>>  	return object;
>>  }
>> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
>> index b7d05c2a6d93..9a4db9c21aaf 100644
>> --- a/mm/kasan/common.c
>> +++ b/mm/kasan/common.c
>> @@ -326,14 +326,25 @@ void __kasan_kfree_large(void *ptr, unsigned long ip)
>>  	/* The object will be poisoned by kasan_poison_pages(). */
>>  }
>>  
>> +static inline size_t slab_unpoison_size(struct kmem_cache *cache, size_t size)
>> +{
>> +	if (kasan_has_tag_based_kmalloc_redzones() && is_kmalloc_cache(cache))
>> +		return min_t(size_t, size, cache->object_size);
>> +
>> +	return cache->object_size;
>> +}
>> +
>>  static inline void unpoison_slab_object(struct kmem_cache *cache, void *object,
>> -					gfp_t flags, bool init)
>> +					size_t size, gfp_t flags, bool init)
>>  {
>>  	/*
>> -	 * Unpoison the whole object. For kmalloc() allocations,
>> -	 * poison_kmalloc_redzone() will do precise poisoning.
>> +	 * For tag-based modes, kmalloc redzones all use the same invalid tag.
>> +	 * Keep the tail poisoned and only unpoison the requested allocation
>> +	 * size. Generic KASAN keeps distinct shadow values for free objects and
>> +	 * redzones, so it still unpoisons the whole object and later poisons
>> +	 * the precise redzone.
>>  	 */
>> -	kasan_unpoison(object, cache->object_size, init);
>> +	kasan_unpoison(object, slab_unpoison_size(cache, size), init);
>>  
>>  	/* Save alloc info (if possible) for non-kmalloc() allocations. */
>>  	if (kasan_stack_collection_enabled() && !is_kmalloc_cache(cache))
>> @@ -341,7 +352,8 @@ static inline void unpoison_slab_object(struct kmem_cache *cache, void *object,
>>  }
>>  
>>  void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
>> -					void *object, gfp_t flags, bool init)
>> +					void *object, size_t size,
>> +					gfp_t flags, bool init)
>>  {
>>  	u8 tag;
>>  	void *tagged_object;
>> @@ -363,11 +375,18 @@ void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
>>  	tagged_object = set_tag(object, tag);
>>  
>>  	/* Unpoison the object and save alloc info for non-kmalloc() allocations. */
>> -	unpoison_slab_object(cache, tagged_object, flags, init);
>> +	unpoison_slab_object(cache, tagged_object, size, flags, init);
>>  
>>  	return tagged_object;
>>  }
>>  
>> +static inline void save_kmalloc_alloc_info(struct kmem_cache *cache,
>> +					   void *object, gfp_t flags)
>> +{
>> +	if (kasan_stack_collection_enabled() && is_kmalloc_cache(cache))
>> +		kasan_save_alloc_info(cache, object, flags);
>> +}
>> +
>>  static inline void poison_kmalloc_redzone(struct kmem_cache *cache,
>>  				const void *object, size_t size, gfp_t flags)
>>  {
>> @@ -394,8 +413,7 @@ static inline void poison_kmalloc_redzone(struct kmem_cache *cache,
>>  	 * Save alloc info (if possible) for kmalloc() allocations.
>>  	 * This also rewrites the alloc info when called from kasan_krealloc().
>>  	 */
>> -	if (kasan_stack_collection_enabled() && is_kmalloc_cache(cache))
>> -		kasan_save_alloc_info(cache, (void *)object, flags);
>> +	save_kmalloc_alloc_info(cache, (void *)object, flags);
>>  
>>  }
>>  
>> @@ -411,8 +429,14 @@ void * __must_check __kasan_kmalloc(struct kmem_cache *cache, const void *object
>>  	if (is_kfence_address(object))
>>  		return (void *)object;
>>  
>> -	/* The object has already been unpoisoned by kasan_slab_alloc(). */
>> -	poison_kmalloc_redzone(cache, object, size, flags);
>> +	/*
>> +	 * For tag-based modes, the object has already been precisely
>> +	 * unpoisoned by kasan_slab_alloc(). The tail remains poisoned.
>> +	 */
>> +	if (kasan_has_tag_based_kmalloc_redzones())
>> +		save_kmalloc_alloc_info(cache, (void *)object, flags);
>> +	else
>> +		poison_kmalloc_redzone(cache, object, size, flags);
>>  
>>  	/* Keep the tag that was set by kasan_slab_alloc(). */
>>  	return (void *)object;
>> @@ -561,11 +585,16 @@ void __kasan_mempool_unpoison_object(void *ptr, size_t size, unsigned long ip)
>>  		return;
>>  
>>  	/* Unpoison the object and save alloc info for non-kmalloc() allocations. */
>> -	unpoison_slab_object(slab->slab_cache, ptr, flags, false);
>> +	unpoison_slab_object(slab->slab_cache, ptr, size, flags, false);
>>  
>>  	/* Poison the redzone and save alloc info for kmalloc() allocations. */
>> -	if (is_kmalloc_cache(slab->slab_cache))
>> -		poison_kmalloc_redzone(slab->slab_cache, ptr, size, flags);
>> +	if (is_kmalloc_cache(slab->slab_cache)) {
>> +		if (kasan_has_tag_based_kmalloc_redzones())
>> +			save_kmalloc_alloc_info(slab->slab_cache, ptr, flags);
>> +		else
>> +			poison_kmalloc_redzone(slab->slab_cache, ptr, size,
>> +					       flags);
>> +	}
>>  }
>>  
>>  bool __kasan_check_byte(const void *address, unsigned long ip)
>> diff --git a/mm/slub.c b/mm/slub.c
>> index da3520769d1f..15144b2e078c 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -4550,8 +4550,9 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>>  	 * replacement of current poisoning under certain debug option, and
>>  	 * won't break other sanity checks.
>>  	 */
>> -	if (kmem_cache_debug_flags(s, SLAB_STORE_USER | SLAB_RED_ZONE) &&
>> -	    (s->flags & SLAB_KMALLOC))
>> +	if ((s->flags & SLAB_KMALLOC) &&
>> +	    (kmem_cache_debug_flags(s, SLAB_STORE_USER | SLAB_RED_ZONE) ||
>> +	     kasan_has_tag_based_kmalloc_redzones()))
>>  		zero_size = orig_size;
>>  
>>  	/*
>> @@ -4573,7 +4574,8 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>>  	 * As p[i] might get tagged, memset and kmemleak hook come after KASAN.
>>  	 */
>>  	for (i = 0; i < size; i++) {
>> -		p[i] = kasan_slab_alloc(s, p[i], init_flags, kasan_init);
>> +		p[i] = kasan_slab_alloc(s, p[i], orig_size, init_flags,
>> +					kasan_init);
>>  		if (p[i] && init && (!kasan_init ||
>>  				     !kasan_has_integrated_init()))
>>  			memset(p[i], 0, zero_size);
>> @@ -7615,7 +7617,8 @@ static void early_kmem_cache_node_alloc(int node)
>>  #ifdef CONFIG_SLUB_DEBUG
>>  	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
>>  #endif
>> -	n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL, false);
>> +	n = kasan_slab_alloc(kmem_cache_node, n, kmem_cache_node->object_size,
>> +			     GFP_KERNEL, false);
>>  	slab->freelist = get_freepointer(kmem_cache_node, n);
>>  	slab->inuse = 1;
>>  	kmem_cache_node->per_node[node].node = n;
> 


