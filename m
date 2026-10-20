Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43FFE606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 12:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B2uqYVE8
Received: by kanga.kvack.org (Postfix)
	id 60DD66B04B1; Tue, 20 Oct 2026 08:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE6A6B04B2; Tue, 20 Oct 2026 08:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486916B04B3; Tue, 20 Oct 2026 08:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2426B04B1
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:29:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A41D240135
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:29:58 +0000 (UTC)
X-FDA: 85342936476.07.9F36DC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E9B4B80007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:29:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B2uqYVE8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792499396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/MID1K25Mec5eR+j04LKuk8ipD9KHKFrdRCTo2aARc=;
	b=cEBAA3sjTT1hskaqFKHTKYxrkSAMKbf/Ub7nZ4JKpbkGhV8w4N4Lvv0q4BITwOU9S7l+qA
	mkbLAZAgWNFExhlV1iro2rPIMrLE3qhDPJS2Y8NHoTK9ipWBl/JfznRfAco3JzKmH0sj+X
	lz9EMYHHHxdySkLMlWiQxvwD7aegV9w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B2uqYVE8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792499396;
	b=Cx5HoS57y/P0LkjwnKkzPXw6wxmflsZCT9gjof9xqXv7+wEFo8umsl+O/FfKBBpNINOvLY
	/8P5P8pGacWfBVk4Uz06Gq2Ylb7l2lzgJ5ja8wogdYG2Bqr381TgeHnh/wT/jAbKjElAlc
	RUdgl18S0eYRV5O0IzYGjlMbYqPnQnw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 77C8760229;
	Tue, 20 Oct 2026 12:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E42A1F000C4;
	Tue, 20 Oct 2026 12:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792499395;
	bh=Y/MID1K25Mec5eR+j04LKuk8ipD9KHKFrdRCTo2aARc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=B2uqYVE8plxA7X8mvYgrzK3qEquiNs021U0p6b+yCiVYWhT7G60RSFxPOBhzwiVsA
	 aPZmths8avYqBicU0fy03yc3VVQp4TB/RYegsDOxtQ2kpFpGQiw97IgK6B39er7LXz
	 fsFRQz+KLT0wx7jeO+BlegiOycWR1Jz8rlpIdU98bv1QE/9F6pru48+OaPw8E40z1i
	 TYyaiCvgpLwh4tp9aEp1MWgdazUWeJPxLpQffSqqaGHhxhqEF5h5RYrWgeeV2YZL2m
	 YdzWTsKkmN1qeYtlhoElohfvp4Dw+Sqr9ayotEX99d9KXDokRYouWH42L/w+gE+9VC
	 00j+UB6yWUDhQ==
Message-ID: <2e8cd2e0-c5c0-4f26-8e75-113b16c20903@kernel.org>
Date: Tue, 20 Oct 2026 14:29:50 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/kasan: Detect double-free involving
 kfree_rcu_sheaf().
To: Kuniyuki Iwashima <kuniyu@google.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>
Cc: Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org
References: <20261009214639.2878857-1-kuniyu@google.com>
 <20261009214639.2878857-2-kuniyu@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261009214639.2878857-2-kuniyu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E9B4B80007
X-Stat-Signature: sm91e95idm5n6tb6tsnwfg8jtb9w5cw8
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792499396-746434
X-HE-Meta: U2FsdGVkX1/+dc0T+54nmz1qhlKumGv6mT9TDSRAyfwhg0gwG8TWsfCM9RQtYOxob3HY37Sb4zOkP0Y64uwCkYI7/1qKjppSzmlL1zMo4iTrGgSAxoLYJPzFOFcaSFgDu69mybIdTfcYkOIth4BnQbUmR7lv9Y2bhPafkLyW0U28YiVUFlX18dVLBo+2ZnczgfpzMBNBsyAto+tbjVESi63tTp1cHcolISayTEpMuqqMh11O1P2XAl5lweB4Wvp4J3e4xa5F3qNlE227ToSXFB+aO8KKxhROHNg/cas64XKTywm8kpEv7mCt44ZZgVd2JnIbCKgKXnFokJtLRYl1hxWxsaqBlPlOLq2i/HADUJPv1soOUtpMprmuNImKEEvnAnqhvLQZbVUiG1zz2sw29Pljg45ovP3870xZE1lb001cbBeRdv7ttV6JsgjeBxa5cj6Z1d3hGqafnrmiuvakrSul+DNlVpNiXw0YWTCoRKbhCSwZuS28K8NKC/CGxXVJQE2nuDBrXvJlntxuRBewbr+KnU0dYvue1vRnjNt8BulogmTNGDSdIffLDy7LD4UJjE1GkBM7aU0YW8OwCUep0FPyrkDrDG0fgB+UHjA/XrcSho6jVG9LdHX5d2H+9bF7a8kJ8I9IAtP66BWlft96lBgtQpm3l9wSHsCpQHF/iiUQpcoj0TcbSiTcwzbHBsNHp5unysMZMgpDyLESyCjTXbk731dAmH7LZER7JCj36TAaOeYIDOOGh+cgbgAkPJmOg7lJxwfvMG640lGj0pdF6nKoaEYRvKawLqm4yGmGm2TUrH7IWAWBjbCw94tX5iunUqklAx6NpcUf1aaPsmZgRJu4mjILD9EwP5D1eOSZL5RI2EhsOsVVIxr1PDTZIl/gcv2ELxzmpkrnfWhOEIs9rqqxfTlmOJjyVXE+teNHePh14IoXb/u/lW/bN+Sd2HvRIIWO48B8ASIi3km+g+1
 OIMXQRMS
 NBpWPcf7VoIewi2ZyWUI+P9QtXiElY1nxkVycGQRApDSrXR6m1Fr/Fsos61VckTByilGTKpu6hmnTYrkNxloQuwgNXiGDMtziQKvQztdZR1zuL9k0iwOBTP90y15VC026JrSYMTvrWKXkdMt/i8ZCALmBv9tx8NCEcyb670H/cDTM5UCmiqzjscFBiAYYy63FJKpMz3SRK0+GFw/C6er0jhxCYcdYKcFUydkockbkDhfyThPdBbIw33khcEkQ4GJc1F4XDt+eo431ca6CqbOpGQM+8ZsIAtIVoJlHUFWr2nI1ayryQjnhT1XeBbxKxj8H9qZIyZwmhhjE5DThG5uiOnU6BG7Etd/hc9/Yu4lnYeJHJLmKOT6gKquXCG6S4v7ezZzP8unEoMMw8xu5NWjVoIyVKghDYOvJvCd/a0i/TpKrCw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/9/26 23:46, Kuniyuki Iwashima wrote:
> syzbot reported a weird use-after-free splat. [0]
> 
> In the report, an object in the kmalloc-64 cache was freed via
> rcu_free_sheaf() while it was still in use, even though the
> object should always be freed with kfree() (in xfrm_hash_free()),
> implying that the object was a victim of a double-free involving
> kfree_rcu() somewhere else.
> 
> When kvfree_call_rcu() frees an object via kfree_rcu_sheaf() and
> queues it into pcs->rcu_free, debug facilities are skipped, e.g.,
> kasan_slab_pre_free(), kasan_record_aux_stack(),
> debug_rcu_head_queue(), etc.
> 
> As a result, KASAN cannot detect the double-free at the call site.
> 
> If the object is still in the KASAN quarantine when the sheaf is
> flushed, KASAN can detect the double-free in rcu_free_sheaf(), but
> with no trace of the suspect.
> 
> Worse yet, once the object is evicted from the quarantine and
> reallocated before the sheaf is flushed, rcu_free_sheaf() silently
> poisons the live object, resulting in a false-positive use-after-free
> report on the new user.
> 
> If __kfree_rcu_sheaf() simply calls kasan_slab_pre_free(), we
> can detect the second kfree_rcu(), but only while the object is
> poisoned in the KASAN quarantine after the first free:
> 
>   kfree()     --(poisoned)--------------------> kfree_rcu()
>   kfree_rcu() -> rcu_free_sheaf() -(poisoned)-> kfree_rcu()
> 
> An object queued in pcs->rcu_free remains unpoisoned until the
> sheaf becomes full and rcu_free_sheaf() runs after the RCU
> grace period, so a subsequent kfree_rcu() or kfree() before
> rcu_free_sheaf() cannot be detected by shadow bytes alone:
> 
>   kfree_rcu() -(unpoisoned)-> kfree_rcu() -> rcu_free_sheaf() (too late!)
>   kfree_rcu() -(unpoisoned)-> kfree()     -> rcu_free_sheaf() (too late!)
> 
> These cases can be detected if we call debug_rcu_head_queue()
> before kfree_rcu_sheaf(), but ODEBUG splat only shows the second
> free.
> 
> To detect these cases with KASAN, we just need a 1-bit flag
> to indicate the state, which can reuse an unused bit in struct
> kasan_track.pid. (PID_MAX_LIMIT is 1<<22)
> 
> The bit is marked along with recording the stack trace when
> deferring slab frees in kfree_rcu_sheaf() and checked in
> check_slab_allocation() so that any double-free pattern above
> can be detected immediately.
> 
> Link: https://lore.kernel.org/all/6ac959ee.70ed5d86.2ac85.007d.GAE@google.com/ #[0]
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

For the slab part.

> ---
>  include/linux/kasan.h | 13 +++++++++----
>  mm/kasan/common.c     | 13 ++++++++-----
>  mm/kasan/generic.c    | 14 +++++++++++++-
>  mm/kasan/kasan.h      | 34 +++++++++++++++++++++++++++++++++-
>  mm/slub.c             | 13 ++++++++++---
>  5 files changed, 73 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index bf233bde68c7..3a43e3d2658e 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -180,7 +180,7 @@ static __always_inline void * __must_check kasan_init_slab_obj(
>  }
>  
>  bool __kasan_slab_pre_free(struct kmem_cache *s, void *object,
> -			unsigned long ip);
> +			   unsigned long ip, bool after_rcu_delay);
>  /**
>   * kasan_slab_pre_free - Check whether freeing a slab object is safe.
>   * @object: Object to be freed.
> @@ -193,10 +193,12 @@ bool __kasan_slab_pre_free(struct kmem_cache *s, void *object,
>   * @Return true if freeing the object is unsafe; false otherwise.
>   */
>  static __always_inline bool kasan_slab_pre_free(struct kmem_cache *s,
> -						void *object)
> +						void *object,
> +						bool after_rcu_delay)
>  {
>  	if (kasan_enabled())
> -		return __kasan_slab_pre_free(s, object, _RET_IP_);
> +		return __kasan_slab_pre_free(s, object, _RET_IP_,
> +					     after_rcu_delay);
>  	return false;
>  }
>  
> @@ -424,7 +426,8 @@ static inline void *kasan_init_slab_obj(struct kmem_cache *cache,
>  	return (void *)object;
>  }
>  
> -static inline bool kasan_slab_pre_free(struct kmem_cache *s, void *object)
> +static inline bool kasan_slab_pre_free(struct kmem_cache *s, void *object,
> +				       bool after_rcu_delay)
>  {
>  	return false;
>  }
> @@ -495,6 +498,7 @@ void kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
>  void kasan_cache_shrink(struct kmem_cache *cache);
>  void kasan_cache_shutdown(struct kmem_cache *cache);
>  void kasan_record_aux_stack(void *ptr);
> +void kasan_record_aux_stack_rcu(void *ptr);
>  
>  #else /* CONFIG_KASAN_GENERIC */
>  
> @@ -512,6 +516,7 @@ static inline void kasan_cache_create(struct kmem_cache *cache,
>  static inline void kasan_cache_shrink(struct kmem_cache *cache) {}
>  static inline void kasan_cache_shutdown(struct kmem_cache *cache) {}
>  static inline void kasan_record_aux_stack(void *ptr) {}
> +static inline void kasan_record_aux_stack_rcu(void *ptr) {}
>  
>  #endif /* CONFIG_KASAN_GENERIC */
>  
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index 7d21c4db68d2..4187606a88cf 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -68,6 +68,7 @@ void kasan_set_track(struct kasan_track *track, depot_stack_handle_t stack)
>  	track->timestamp = ts_nsec >> 9;
>  #endif /* CONFIG_KASAN_EXTRA_INFO */
>  	track->pid = current->pid;
> +	track->rcu_free = 0;
>  	track->stack = stack;
>  }
>  
> @@ -231,7 +232,7 @@ void * __must_check __kasan_init_slab_obj(struct kmem_cache *cache,
>  
>  /* Returns true when freeing the object is not safe. */
>  static bool check_slab_allocation(struct kmem_cache *cache, void *object,
> -				  unsigned long ip)
> +				  unsigned long ip, bool after_rcu_delay)
>  {
>  	void *tagged_object = object;
>  
> @@ -242,7 +243,8 @@ static bool check_slab_allocation(struct kmem_cache *cache, void *object,
>  		return true;
>  	}
>  
> -	if (!kasan_byte_accessible(tagged_object)) {
> +	if (!kasan_byte_accessible(tagged_object) ||
> +	    kasan_check_rcu_free(cache, object, after_rcu_delay)) {
>  		kasan_report_invalid_free(tagged_object, ip, KASAN_REPORT_DOUBLE_FREE);
>  		return true;
>  	}
> @@ -259,17 +261,18 @@ static inline void poison_slab_object(struct kmem_cache *cache, void *object,
>  
>  	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
>  			KASAN_SLAB_FREE, init);
> +	kasan_clear_rcu_free(cache, object);
>  
>  	if (kasan_stack_collection_enabled())
>  		kasan_save_free_info(cache, tagged_object);
>  }
>  
>  bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
> -				unsigned long ip)
> +			   unsigned long ip, bool after_rcu_delay)
>  {
>  	if (is_kfence_address(object))
>  		return false;
> -	return check_slab_allocation(cache, object, ip);
> +	return check_slab_allocation(cache, object, ip, after_rcu_delay);
>  }
>  
>  bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
> @@ -544,7 +547,7 @@ bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
>  
>  	slab = page_slab(page);
>  
> -	if (check_slab_allocation(slab->slab_cache, ptr, ip))
> +	if (check_slab_allocation(slab->slab_cache, ptr, ip, false))
>  		return false;
>  
>  	poison_slab_object(slab->slab_cache, ptr, false);
> diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
> index 2b8e73f5f6a7..07636ffe1626 100644
> --- a/mm/kasan/generic.c
> +++ b/mm/kasan/generic.c
> @@ -536,7 +536,7 @@ size_t kasan_metadata_size(struct kmem_cache *cache, bool in_object)
>   * This function avoids dynamic memory allocations and thus can be called from
>   * contexts that do not allow allocating memory.
>   */
> -void kasan_record_aux_stack(void *addr)
> +static void __kasan_record_aux_stack(void *addr, bool rcu_free)
>  {
>  	struct slab *slab = kasan_addr_to_slab(addr);
>  	struct kmem_cache *cache;
> @@ -552,10 +552,22 @@ void kasan_record_aux_stack(void *addr)
>  	if (!alloc_meta)
>  		return;
>  
> +	if (rcu_free)
> +		alloc_meta->alloc_track.rcu_free = 1;
>  	alloc_meta->aux_stack[1] = alloc_meta->aux_stack[0];
>  	alloc_meta->aux_stack[0] = kasan_save_stack(0, 0);
>  }
>  
> +void kasan_record_aux_stack(void *addr)
> +{
> +	__kasan_record_aux_stack(addr, false);
> +}
> +
> +void kasan_record_aux_stack_rcu(void *addr)
> +{
> +	__kasan_record_aux_stack(addr, true);
> +}
> +
>  void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
>  {
>  	struct kasan_alloc_meta *alloc_meta;
> diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
> index fc9169a54766..43d608899544 100644
> --- a/mm/kasan/kasan.h
> +++ b/mm/kasan/kasan.h
> @@ -191,7 +191,10 @@ static inline bool kasan_requires_meta(void)
>  #define KASAN_STACK_DEPTH 64
>  
>  struct kasan_track {
> -	u32 pid;
> +#define KASAN_PID_BITS const_ilog2(PID_MAX_LIMIT)
> +	u32 pid:KASAN_PID_BITS;
> +	u32 rcu_free:1;
> +	u32 unused:32 - (KASAN_PID_BITS + 1);
>  	depot_stack_handle_t stack;
>  #ifdef CONFIG_KASAN_EXTRA_INFO
>  	u64 cpu:20;
> @@ -390,8 +393,37 @@ struct kasan_alloc_meta *kasan_get_alloc_meta(struct kmem_cache *cache,
>  struct kasan_free_meta *kasan_get_free_meta(struct kmem_cache *cache,
>  						const void *object);
>  void kasan_init_object_meta(struct kmem_cache *cache, const void *object);
> +
> +static inline bool kasan_check_rcu_free(struct kmem_cache *cache,
> +					const void *object,
> +					bool after_rcu_delay)
> +{
> +	struct kasan_alloc_meta *alloc_meta;
> +
> +	alloc_meta = kasan_get_alloc_meta(cache, object);
> +	if (!alloc_meta)
> +		return false;
> +
> +	return alloc_meta->alloc_track.rcu_free != after_rcu_delay;
> +}
> +
> +static inline void kasan_clear_rcu_free(struct kmem_cache *cache,
> +					const void *object)
> +{
> +	struct kasan_alloc_meta *alloc_meta;
> +
> +	alloc_meta = kasan_get_alloc_meta(cache, object);
> +	if (alloc_meta)
> +		alloc_meta->alloc_track.rcu_free = 0;
> +}
>  #else
>  static inline void kasan_init_object_meta(struct kmem_cache *cache, const void *object) { }
> +static inline bool kasan_check_rcu_free(struct kmem_cache *cache, const void *object,
> +					bool after_rcu_delay)
> +{
> +	return false;
> +}
> +static inline void kasan_clear_rcu_free(struct kmem_cache *cache, const void *object) { }
>  #endif
>  
>  depot_stack_handle_t kasan_save_stack(gfp_t flags, depot_flags_t depot_flags);
> diff --git a/mm/slub.c b/mm/slub.c
> index 544cff39762c..8a08ca73d76b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2690,7 +2690,7 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
>  	 * Give KASAN a chance to notice an invalid free operation before we
>  	 * modify the object.
>  	 */
> -	if (kasan_slab_pre_free(s, x))
> +	if (kasan_slab_pre_free(s, x, after_rcu_delay))
>  		return false;
>  
>  #ifdef CONFIG_SLUB_RCU_DEBUG
> @@ -2706,7 +2706,7 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
>  			 * We have to do this manually because the rcu_head is
>  			 * not located inside the object.
>  			 */
> -			kasan_record_aux_stack(x);
> +			kasan_record_aux_stack_rcu(x);
>  
>  			delayed_free->object = x;
>  			call_rcu(&delayed_free->head, slab_free_after_rcu_debug);
> @@ -6177,6 +6177,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
>  	}
>  
>  do_free:
> +	if (unlikely(kasan_slab_pre_free(s, obj, false))) {
> +		local_unlock(&s->cpu_sheaves->lock);
> +		goto out;
> +	}
> +
> +	kasan_record_aux_stack_rcu(obj);
>  
>  	rcu_sheaf = pcs->rcu_free;
>  
> @@ -6217,6 +6223,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
>  	local_unlock(&s->cpu_sheaves->lock);
>  
>  	stat(s, FREE_RCU_SHEAF);
> +out:
>  	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
>  		lock_map_release(&kfree_rcu_sheaf_map);
>  	return true;
> @@ -6850,7 +6857,7 @@ void kfree_nolock(const void *object)
>  	 *  -> kfree_nolock() -> kasan_report_invalid_free() on the same CPU
>  	 * is double buggy and deserves to deadlock.
>  	 */
> -	if (kasan_slab_pre_free(s, x))
> +	if (kasan_slab_pre_free(s, x, false))
>  		return;
>  	/*
>  	 * memcg, kasan_slab_pre_free are done for 'x'.


