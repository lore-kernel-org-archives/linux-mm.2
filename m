Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B81BCD4F52
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 08:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73DBD6B0095; Tue, 19 May 2026 04:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EEDE6B0096; Tue, 19 May 2026 04:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDCF6B0098; Tue, 19 May 2026 04:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0EF6B0095
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:15:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40B9C140275
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:15:24 +0000 (UTC)
X-FDA: 84783459768.06.08A8484
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 589F34000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:15:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Jn4/3sy2";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779178522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGZIoECghENTz19nZIYgGw5w0bGGlvLuwFKuz0DRy+w=;
	b=naJXUf1CuKqoSHhO2CFihXjPJB+y2n4zqComIq6G3pdmjlrEGhnkzgDyysFvIjrGv7RmPF
	ApXLa25ReMo7cyVMX0EOZ45cNc7D7ismEJXugy9AzVyFfcuyQ9uulJzi452vkrEaKCUrE6
	ua52PnXSdo7n6q0RWEzm+Kosgx0SJJo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779178522; a=rsa-sha256;
	cv=none;
	b=XYg0mSi96maVdxGguljc4ziMHs0bWG6XGCTWID9kRvze8BtCGmnrbuOaAbXFi4BpU8NN7R
	anwonZDonTTFZNebI52Oqun6UcZQEZQT1CwCeGq189Zix2xMM4nScJaPX9F0mT/UKfl9Xk
	UROWkYzT0V8f6J7mcc3z4e+DXGPckZw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Jn4/3sy2";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D943D176C;
	Tue, 19 May 2026 01:15:15 -0700 (PDT)
Received: from [10.164.19.29] (unknown [10.164.19.29])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A02A3F85F;
	Tue, 19 May 2026 01:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779178521; bh=w4Yz3HOXhM5euI2SHyg+QaD5Wz2hKTM9cDNFBaPIJS0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Jn4/3sy2K+eK93XJk32kuEjbyH+JBG1gG0I7r3wGkK67VLZvEp65ryD+2oqDkoZDv
	 urOsC2OnbkJ1paLUhubgQHneZJ8J5ltQt2Qf3YtnzS2yTynd1sGRUk4wg+RXYit4Y7
	 TgOZ/KnfGDFd77snZpRVw+8OneoCLpo/teeGyuAw=
Message-ID: <14da7ffe-1332-45d0-86d6-e9d9ae0a4fe0@arm.com>
Date: Tue, 19 May 2026 13:45:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] kasan: avoid re-poisoning tag-based kmalloc redzones
To: akpm@linux-foundation.org, vbabka@kernel.org, harry@kernel.org,
 ryabinin.a.a@gmail.com
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, kasan-dev@googlegroups.com,
 ryan.roberts@arm.com, anshuman.khandual@arm.com, catalin.marinas@arm.com
References: <20260513105734.3380544-1-dev.jain@arm.com>
 <20260513105734.3380544-3-dev.jain@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260513105734.3380544-3-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 589F34000A
X-Stat-Signature: 1s8g65zicxe8i3ri3e7xo3ommht1ptbi
X-Rspam-User: 
X-HE-Tag: 1779178522-365063
X-HE-Meta: U2FsdGVkX1+7errebE2zuQ/GzKh6E9I8Ne2c+B6aPsQyBpf37MWAEp5VbVrA27DXxeuLxEEnAsa7FZxoPCzbXvmnkUZDenXd0r2HmuWQx9DJwcMRf8RizgHkHcBRcTWK1WmECUnOhTlbLIQV+34Y/AwYCtclD9Yio6T9NCRQjEZ6k3/ah06OTE03dqQw459RvP3wpGYPF2VYoXNt5DPH30aDMc2cbXGgzMgHggTALMYTYy/Th3uo8bxo/nrOBdJsGK0iJMezArcdMp9xJQ3hshu5uPa1jTZMAV1UmMdcIJ/BbTl9Ba3PIPhrTKcHoDQ6RmZIz4ut159WkNyyyMoPwPQMDMsMIyk4v07MUkYQEH4dBN2JvKaNIeNMZZAMPWTa1C6EPMlO8MGHf1x3FrtcLCDLmQtCRLPw3XaNrxAaewuPq8Aq9AhmodFWdufG+yDJpu7hSsvoyZuL7FmTuJuPAu5ubnLT0LXf/jaxENs6voQDCvVMFvO+/ikY2hNtsFK3kNsrfpLbDNuYnrN1XfOTVhEbvpBOdHxGAWuxJsBx06gIdpREx+9Lzg/gFYAXjTTpHh/7GzP6C63d1O8ZKZ8pfczBZIqvBR+ubW/UGPBGDKbxKtG0NOWUknZKASWuo5KSBCHUQZjr5pH93QzTvuXD2/UCWRb+FgvsbcNzI4QxhNsDPqMjvmQumYJL5DEbCy1icDyg3RtYMY2eZ0wA7s3AJ0wL3GV/N5s/Lx8qlx89De2svqr/C+11Gq+Ekh+XkKN6f8dtSTsYwpvbjQB4CSRdJPDVL5+5FHwyHpO1H0TguGMjAZ0XxhsQqrWWal+sUv4KCWRj2wq5lHTpWwHVC68QVgqe2HtQnrmo4RQU/X+W8EZEru9xyk+C/0keuwiqMKiTgpWBzb/Eo4xduJpsqB5PuUY9r5EBLCEfu/UWVFeJGM6Q9Ke48MbL9jL6DUDETWDxgo0dxKjFl/D+1uI+19H
 Ib+5pIXq
 ndPmi5BonZLg8Wt0WhnjubdALZNOpdT8NROXE1BrvAGG8pnj6K1tnO+mdQVYZrdQcgtPzucHHCXCnZ6hCj5itg58fYYH0ABUC23PDfC10NcMUUZPofN8D7/U72wpxV/Rs13SBGAlmPtnR3Z88aIYqEFAuaHa6WQQIn0pH/Oh/qEWOiw+GGIf7GpJOgjVaUgD8rhs0ZIsw8z/WKGw+WV8dqZSEOSrdOEHgC0K9czkYiAl+cvbfMGSPGAhvlGEdlCLjPBsLzxEeF632OfUBamNYShtnEfFhyatjkuR2iC8ou416wRYHCUdV0oHFItaOiiP9T45KYaK0y68Gay6dBr5pjJpV6dw+FsCARuI/Ui1vKyg4gy4Yk1pEshpDX1PDubwDJIqx/E3JYtfIH4yh3rly7n1Xiv/SxvIS+6aAnbDX25BIi0g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/05/26 4:27 pm, Dev Jain wrote:
> When we allocate object from slab, kasan will unpoison the entire object.
> In case of allocation from kmalloc caches, the actual allocation size
> request can be less than the size of the kmalloc cache. kasan poisons
> the bytes following allocation size up till object size to catch OOB.
> 
> We can do this operation in one shot: while unpoisoning the object upon
> allocation, only unpoison up till allocation size bytes, so that the
> bytes following that up till object size remain poisoned.
> 
> Currently when we free an object into the slab, we use KASAN_SLAB_FREE for
> poisoning, and use KASAN_SLAB_REDZONE for poisoning the tail end. For
> tag-based kasan, these two are equal, as opposed to generic kasan. So we
> make this optimization only for tag-based kasan.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Sashiko: https://sashiko.dev/#/patchset/20260513105734.3380544-1-dev.jain@arm.com

So I'll explain what Sashiko is saying with examples. If I am mis-interpreting
then please correct me!

Problem 1:

p = kzalloc(96, GFP_KERNEL);                 // kmalloc-128
p = krealloc(p, 120, GFP_KERNEL | __GFP_ZERO);

Before my patch, kzalloc zeroed bytes 0..127, krealloc exposes bytes 96..119
which are already zero from kzalloc.

After my patch, kzalloc zeroes only 0..95, krealloc may think old
size is 128, so it does not zero 96..119, 96..119 may contain stale data.

Why is this a problem? Surely caller of krealloc shouldn't be
relying on a previous zeroing. krealloc documentation explicitly says that
GFP_ZERO is ignored.


Problem 2 for SW tags:

p = kzalloc(97, GFP_KERNEL);   // kmalloc-128, granule = 16

Before patch:

KASAN unpoisons 0..111
memset zeroes 0..127
p[100] will not be caught by KASAN, but reads zero

After patch:

KASAN unpoisons 0..111
memset zeroes only 0..96
p[100] will not be caught by KASAN and reads stale data

Again why is this a problem?

>  include/linux/kasan.h | 17 +++++++++----
>  mm/kasan/common.c     | 55 +++++++++++++++++++++++++++++++++----------
>  mm/slub.c             | 11 +++++----
>  3 files changed, 61 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index bf233bde68c7..fd7c1f5f9fd6 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -102,6 +102,12 @@ static inline bool kasan_has_integrated_init(void)
>  	return kasan_hw_tags_enabled();
>  }
>  
> +static inline bool kasan_has_tag_based_kmalloc_redzones(void)
> +{
> +	return kasan_enabled() &&
> +	       (IS_ENABLED(CONFIG_KASAN_SW_TAGS) || kasan_hw_tags_enabled());
> +}
> +
>  #ifdef CONFIG_KASAN
>  void __kasan_unpoison_range(const void *addr, size_t size);
>  static __always_inline void kasan_unpoison_range(const void *addr, size_t size)
> @@ -244,13 +250,14 @@ static __always_inline void kasan_kfree_large(void *ptr)
>  		__kasan_kfree_large(ptr, _RET_IP_);
>  }
>  
> -void * __must_check __kasan_slab_alloc(struct kmem_cache *s,
> -				       void *object, gfp_t flags, bool init);
> +void * __must_check __kasan_slab_alloc(struct kmem_cache *s, void *object,
> +				       size_t size, gfp_t flags, bool init);
>  static __always_inline void * __must_check kasan_slab_alloc(
> -		struct kmem_cache *s, void *object, gfp_t flags, bool init)
> +		struct kmem_cache *s, void *object, size_t size,
> +		gfp_t flags, bool init)
>  {
>  	if (kasan_enabled())
> -		return __kasan_slab_alloc(s, object, flags, init);
> +		return __kasan_slab_alloc(s, object, size, flags, init);
>  	return object;
>  }
>  
> @@ -437,7 +444,7 @@ static inline bool kasan_slab_free(struct kmem_cache *s, void *object,
>  }
>  static inline void kasan_kfree_large(void *ptr) {}
>  static inline void *kasan_slab_alloc(struct kmem_cache *s, void *object,
> -				   gfp_t flags, bool init)
> +				   size_t size, gfp_t flags, bool init)
>  {
>  	return object;
>  }
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index b7d05c2a6d93..9a4db9c21aaf 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -326,14 +326,25 @@ void __kasan_kfree_large(void *ptr, unsigned long ip)
>  	/* The object will be poisoned by kasan_poison_pages(). */
>  }
>  
> +static inline size_t slab_unpoison_size(struct kmem_cache *cache, size_t size)
> +{
> +	if (kasan_has_tag_based_kmalloc_redzones() && is_kmalloc_cache(cache))
> +		return min_t(size_t, size, cache->object_size);
> +
> +	return cache->object_size;
> +}
> +
>  static inline void unpoison_slab_object(struct kmem_cache *cache, void *object,
> -					gfp_t flags, bool init)
> +					size_t size, gfp_t flags, bool init)
>  {
>  	/*
> -	 * Unpoison the whole object. For kmalloc() allocations,
> -	 * poison_kmalloc_redzone() will do precise poisoning.
> +	 * For tag-based modes, kmalloc redzones all use the same invalid tag.
> +	 * Keep the tail poisoned and only unpoison the requested allocation
> +	 * size. Generic KASAN keeps distinct shadow values for free objects and
> +	 * redzones, so it still unpoisons the whole object and later poisons
> +	 * the precise redzone.
>  	 */
> -	kasan_unpoison(object, cache->object_size, init);
> +	kasan_unpoison(object, slab_unpoison_size(cache, size), init);
>  
>  	/* Save alloc info (if possible) for non-kmalloc() allocations. */
>  	if (kasan_stack_collection_enabled() && !is_kmalloc_cache(cache))
> @@ -341,7 +352,8 @@ static inline void unpoison_slab_object(struct kmem_cache *cache, void *object,
>  }
>  
>  void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
> -					void *object, gfp_t flags, bool init)
> +					void *object, size_t size,
> +					gfp_t flags, bool init)
>  {
>  	u8 tag;
>  	void *tagged_object;
> @@ -363,11 +375,18 @@ void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
>  	tagged_object = set_tag(object, tag);
>  
>  	/* Unpoison the object and save alloc info for non-kmalloc() allocations. */
> -	unpoison_slab_object(cache, tagged_object, flags, init);
> +	unpoison_slab_object(cache, tagged_object, size, flags, init);
>  
>  	return tagged_object;
>  }
>  
> +static inline void save_kmalloc_alloc_info(struct kmem_cache *cache,
> +					   void *object, gfp_t flags)
> +{
> +	if (kasan_stack_collection_enabled() && is_kmalloc_cache(cache))
> +		kasan_save_alloc_info(cache, object, flags);
> +}
> +
>  static inline void poison_kmalloc_redzone(struct kmem_cache *cache,
>  				const void *object, size_t size, gfp_t flags)
>  {
> @@ -394,8 +413,7 @@ static inline void poison_kmalloc_redzone(struct kmem_cache *cache,
>  	 * Save alloc info (if possible) for kmalloc() allocations.
>  	 * This also rewrites the alloc info when called from kasan_krealloc().
>  	 */
> -	if (kasan_stack_collection_enabled() && is_kmalloc_cache(cache))
> -		kasan_save_alloc_info(cache, (void *)object, flags);
> +	save_kmalloc_alloc_info(cache, (void *)object, flags);
>  
>  }
>  
> @@ -411,8 +429,14 @@ void * __must_check __kasan_kmalloc(struct kmem_cache *cache, const void *object
>  	if (is_kfence_address(object))
>  		return (void *)object;
>  
> -	/* The object has already been unpoisoned by kasan_slab_alloc(). */
> -	poison_kmalloc_redzone(cache, object, size, flags);
> +	/*
> +	 * For tag-based modes, the object has already been precisely
> +	 * unpoisoned by kasan_slab_alloc(). The tail remains poisoned.
> +	 */
> +	if (kasan_has_tag_based_kmalloc_redzones())
> +		save_kmalloc_alloc_info(cache, (void *)object, flags);
> +	else
> +		poison_kmalloc_redzone(cache, object, size, flags);
>  
>  	/* Keep the tag that was set by kasan_slab_alloc(). */
>  	return (void *)object;
> @@ -561,11 +585,16 @@ void __kasan_mempool_unpoison_object(void *ptr, size_t size, unsigned long ip)
>  		return;
>  
>  	/* Unpoison the object and save alloc info for non-kmalloc() allocations. */
> -	unpoison_slab_object(slab->slab_cache, ptr, flags, false);
> +	unpoison_slab_object(slab->slab_cache, ptr, size, flags, false);
>  
>  	/* Poison the redzone and save alloc info for kmalloc() allocations. */
> -	if (is_kmalloc_cache(slab->slab_cache))
> -		poison_kmalloc_redzone(slab->slab_cache, ptr, size, flags);
> +	if (is_kmalloc_cache(slab->slab_cache)) {
> +		if (kasan_has_tag_based_kmalloc_redzones())
> +			save_kmalloc_alloc_info(slab->slab_cache, ptr, flags);
> +		else
> +			poison_kmalloc_redzone(slab->slab_cache, ptr, size,
> +					       flags);
> +	}
>  }
>  
>  bool __kasan_check_byte(const void *address, unsigned long ip)
> diff --git a/mm/slub.c b/mm/slub.c
> index da3520769d1f..15144b2e078c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4550,8 +4550,9 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>  	 * replacement of current poisoning under certain debug option, and
>  	 * won't break other sanity checks.
>  	 */
> -	if (kmem_cache_debug_flags(s, SLAB_STORE_USER | SLAB_RED_ZONE) &&
> -	    (s->flags & SLAB_KMALLOC))
> +	if ((s->flags & SLAB_KMALLOC) &&
> +	    (kmem_cache_debug_flags(s, SLAB_STORE_USER | SLAB_RED_ZONE) ||
> +	     kasan_has_tag_based_kmalloc_redzones()))
>  		zero_size = orig_size;
>  
>  	/*
> @@ -4573,7 +4574,8 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>  	 * As p[i] might get tagged, memset and kmemleak hook come after KASAN.
>  	 */
>  	for (i = 0; i < size; i++) {
> -		p[i] = kasan_slab_alloc(s, p[i], init_flags, kasan_init);
> +		p[i] = kasan_slab_alloc(s, p[i], orig_size, init_flags,
> +					kasan_init);
>  		if (p[i] && init && (!kasan_init ||
>  				     !kasan_has_integrated_init()))
>  			memset(p[i], 0, zero_size);
> @@ -7615,7 +7617,8 @@ static void early_kmem_cache_node_alloc(int node)
>  #ifdef CONFIG_SLUB_DEBUG
>  	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
>  #endif
> -	n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL, false);
> +	n = kasan_slab_alloc(kmem_cache_node, n, kmem_cache_node->object_size,
> +			     GFP_KERNEL, false);
>  	slab->freelist = get_freepointer(kmem_cache_node, n);
>  	slab->inuse = 1;
>  	kmem_cache_node->per_node[node].node = n;


