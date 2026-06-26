Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4558FC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FE316B00A4; Fri, 26 Jun 2026 10:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3516B00A5; Fri, 26 Jun 2026 10:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF556B00A6; Fri, 26 Jun 2026 10:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6F356B00A4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:41:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E8E312048B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:41:29 +0000 (UTC)
X-FDA: 84922327098.28.110CABD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7640B1A0014
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:41:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jsbn6NIx;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782484887;
	b=lwph3R2mqimqVlU4D06OWlRSH1n2oZ5ccJn0F4twwHKnE7L9TDY+WIdrDbLmOz4VbjNVms
	s0MYi/gHmwQDKN/k84Xx9FHMCmGxM7UvSJTfebEbJVo/najLWKIjhopFm3iI2d+OebvkzB
	xYmj5E/1bbZFllGM7jl1g4UTL5lFrHE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782484887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8XGeGFmEocugFI9gz5oMoSnIsxLpV060sj+N7xRZ+U=;
	b=YYDToFiaFqYzahvfcMoxlZB3P90ETXWs5J58+FP/OmmANrUtddcKRB19pzKmODjqlEM7Tk
	Ye4EC/pKcjg6musAkaZ1+pQNmHtADtqJZCsr/5Rz1emxALRgEnfW55dCI3j8N+1GIlqPQc
	UMM5iqmH6BbZNG4lYSZWLb02mXbj9vg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jsbn6NIx;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D1A8A600D9;
	Fri, 26 Jun 2026 14:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7261F000E9;
	Fri, 26 Jun 2026 14:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782484886;
	bh=j8XGeGFmEocugFI9gz5oMoSnIsxLpV060sj+N7xRZ+U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Jsbn6NIxVX46djM81aCv3IWkt5UPG+pi7DIrD2i2MXD2S7Ta2jGW/1hmBvxLR430T
	 V3HDHYwc+SiVzQi0y+/JoVoOMURAtg4BKGZKze7gZFd1NtJCR2xVpgwfZYTmJBR+9P
	 o7GwDsVF7vYaCBqcCvjGWAyjX6xGW5vBQbmwkVVf7ByUtDYQaXZqyanbSTYZxbG1Np
	 Ib5uTh1S4pMfFP6kMVxYu0lT6i4IcPygJo6JDrLmuH5Kfizs3sCBa1bWzZkdfJdiX+
	 VIUAL6wv+PDwXCQNLIwM9QKijcxEjcHhzyn5aeVbYBoIhOFr+KS7oI/h038M1hJ7Xw
	 LqKWq5Fx5zGgg==
Message-ID: <91776136-ecaf-4687-be63-a2c074435462@kernel.org>
Date: Fri, 26 Jun 2026 16:41:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/4] mm/slab: handle allow_spin in slab_free_hook()
 instead of open coding
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Alexei Starovoitov <ast@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
 <20260624-kmalloc-nolock-fixes-v1-2-fdf4d17351dd@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260624-kmalloc-nolock-fixes-v1-2-fdf4d17351dd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 975kygfksdm888m58h7h8i3s6j1cwfzj
X-Rspamd-Queue-Id: 7640B1A0014
X-Rspamd-Server: rspam06
X-HE-Tag: 1782484887-69551
X-HE-Meta: U2FsdGVkX18WPj62mNuHayNoNad+sEM39V815p38H9CG7pB3qK1xWwB8r/Ol0vub0DEUfVv6E+a0vK/LbtPRw8DaxCGybdfbGBdnVgSfTxGQ3DFzP1IxqesWUS84uJsz/oTw0+9A1nsD74uAgMLJYijnMVImmRCIhJqW21KPqT6lbq7mEsFlXBPAFzx/F/3KNzgkTmycMw6Di2uKpQkKyHXhJCKHe8nKXMNV+6fZ6FhcHuucuZevXKHcbBpK7KkaRTsXUfM9cS08JybzwZgTBj7jRyrgI4NAD9AKUT8PMA3uCVol3zbTaeCvDIBjZmL24adAVgIWUDxlIsNc9KKRzo4cIZe3MLgnj+2eNa++eUkCykWDRMeCXDKg3ipq1iQFpuNBMI5m5CDRi5IsOtJiWoykPCQUm01nGAtJcMq4A4rMWlOrqZ36ec2DbTgUO1KBOdwMsiqh9az2Tof8Lqarl0/S6enPuLFDRP9JSKlBXoeQNu+mYe6LZqlNzBVwZ+um6ug2oDq07wg/e7FD7sAmjnFysTZfjU3X7di5Nc9xXPJaqtEMs4Ih0dhLfELhCwruZjZWxukfezrpI2MJ/Gs89TQ1yZBBYVc6kwA+UAEDp38W7niN8D/bHsapoIawUAiJfacw4eCrhsnX7Qlkv+DK491wNtO6QeuIOrM8146BqahLvbfJyvJYpGImCzIWTn/U2yL92MkZLmJvtEkvsXscCgfrVNRoEsnBdkpffvcBJqKUTtdhfv8LGx0eoltfUsyJDVusNH/X0DRz7P+t60xrfdkNt+ieTLD6H0LONQyuVOEpxEtFbX1uuD4E1zPt0DgVz8Q/CEGz+1HQX31Tzu1VCQG3TQ18Bsen2aRjlEuQf9tDCuyqo7aJ7Lm8F0OadBBTKunHZOcTmyhwuLRknAWJSdiR62FBJBUppCNthqzrcDLcowWnW9i3ODKuSNB3vxgiyUhLUVlJNPqCA+WiLbO
 4xXAEvWA
 6wm22kw2Dv5snZT+jARXx1sFO1X7UZd7QPh90TXxMlTFOlpARZZ2oGOsx0s9s6SOcAM1q4lBm4ehXQkp9IxkqawPWjydCftR+TyjBLOSUi6Lf5077yAt1u20MKlZ+Dchj1bmgluu+SU/3HMjClje9wnJ3j/UUisIBvmnxEwnS98JPqB8tMLvL5d9op86lsRuS1Rd2X/waZOBK/VE0ZjLDxazNwezG5tu4SX+Khngf2KswpMzngJihiqqe8uD/Gb20L6KLIPvl2j8xIg4h/7ANs+XE9Jy6fxK4of3HUlT9L7/AGVYKrEZagG8+9vETv//pDTUDBEW4qslIKQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 15:11, Harry Yoo (Oracle) wrote:
> kfree_nolock() deliberately skips slab free hooks that should not be
> called in unknown context. However, there is one more place that
> needs the same thing: memcg_alloc_abort_single().
> 
> Instead of open coding slab_free_hook(), let it handle the allow_spin
> parameter. This is required to correctly handle allocation failures due
> to memcg.
> 
> There are two functional changes from this.
> 
> First, memcg_alloc_abort_single() -> slab_free_hook() path no longer
> calls free hooks that acquire spinlocks if !allow_spin.
> 
> Second, kfree_nolock() now follows init_on_free which has been ignored.
> 
> Besides that, no functional change intended.
> 
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Cc: stable@vger.kernel.org
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
>  mm/slub.c | 100 +++++++++++++++++++++++++++++++-------------------------------
>  1 file changed, 50 insertions(+), 50 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 32672a92581b..85760c8ff2e2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2611,41 +2611,52 @@ struct rcu_delayed_free {
>   * - memcg_slab_post_alloc_hook()
>   * - alloc_tagging_slab_alloc_hook()
>   *
> + * slab_free_hook() assumes that memcg_slab_free_hook() and
> + * alloc_tagging_slab_free_hook() are already invoked.
> + *
>   * Free hooks that must handle missing corresponding alloc hooks:
>   * - kmemleak_free_recursive()
>   * - kfence_free()
>   *
> - * Free hooks that have no alloc hook counterpart, and thus safe to call:
> + * Free hooks that have no alloc hook counterpart, and thus safe to call
> + * when spinning is allowed:
>   * - debug_check_no_locks_freed()
>   * - debug_check_no_obj_freed()
>   * - __kcsan_check_access()
>   */
>  static __always_inline
>  bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
> -		    bool after_rcu_delay)
> +		    bool after_rcu_delay, bool allow_spin)
>  {
>  	/* Are the object contents still accessible? */
>  	bool still_accessible = (s->flags & SLAB_TYPESAFE_BY_RCU) && !after_rcu_delay;
>  
> -	kmemleak_free_recursive(x, s->flags);
>  	kmsan_slab_free(s, x);
>  
> -	debug_check_no_locks_freed(x, s->object_size);
> -
> -	if (!(s->flags & SLAB_DEBUG_OBJECTS))
> -		debug_check_no_obj_freed(x, s->object_size);
> -
> -	/* Use KCSAN to help debug racy use-after-free. */
> -	if (!still_accessible)
> -		__kcsan_check_access(x, s->object_size,
> -				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
> -
> -	if (kfence_free(x))
> -		return false;
> +	if (likely(allow_spin)) {
> +		/* These hooks acquire spinlocks */
> +		kmemleak_free_recursive(x, s->flags);
> +		debug_check_no_locks_freed(x, s->object_size);

This line shouldn't be here?

> +		if (!(s->flags & SLAB_DEBUG_OBJECTS))
> +			debug_check_no_obj_freed(x, s->object_size);
> +		/* Use KCSAN to help debug racy use-after-free. */
> +		if (!still_accessible)
> +			__kcsan_check_access(x, s->object_size,
> +					     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
> +		if (kfence_free(x))
> +			return false;

The whole block now misses free space lines that it had.

> +	}
>  
>  	/*
>  	 * Give KASAN a chance to notice an invalid free operation before we
>  	 * modify the object.
> +	 *
> +	 * If KASAN finds a bug it will do kasan_report_invalid_free() which
> +	 * will call raw_spin_lock_irqsave() which is technically unsafe from
> +	 * NMI, but take chance and report kernel bug. The sequence of
> +	 * kasan_report_invalid_free() -> raw_spin_lock_irqsave() -> NMI
> +	 * -> kfree_nolock() -> kasan_report_invalid_free() on the same CPU
> +	 *  is double buggy and deserves to deadlock.
>  	 */
>  	if (kasan_slab_pre_free(s, x))
>  		return false;
> @@ -2654,6 +2665,7 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
>  	if (still_accessible) {
>  		struct rcu_delayed_free *delayed_free;
>  
> +		VM_WARN_ON_ONCE(!allow_spin);
>  		delayed_free = kmalloc_obj(*delayed_free, GFP_NOWAIT);
>  		if (delayed_free) {
>  			/*
> @@ -2701,8 +2713,11 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
>  		set_orig_size(s, x, orig_size);
>  
>  	}
> -	/* KASAN might put x into memory quarantine, delaying its reuse. */
> -	return !kasan_slab_free(s, x, init, still_accessible, false);
> +	/*
> +	 * KASAN might put x into memory quarantine, delaying its reuse.
> +	 * Skip quarantine when spinning is not allowed as it uses a spinlock.
> +	 */
> +	return !kasan_slab_free(s, x, init, still_accessible, !allow_spin);
>  }
>  
>  static __fastpath_inline
> @@ -2714,9 +2729,10 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
>  	void *next = *head;
>  	void *old_tail = *tail;
>  	bool init;
> +	bool allow_spin = true;
>  
>  	if (is_kfence_address(next)) {
> -		slab_free_hook(s, next, false, false);
> +		slab_free_hook(s, next, false, false, allow_spin);
>  		return false;
>  	}
>  
> @@ -2731,7 +2747,7 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
>  		next = get_freepointer(s, object);
>  
>  		/* If object's reuse doesn't have to be delayed */
> -		if (likely(slab_free_hook(s, object, init, false))) {
> +		if (likely(slab_free_hook(s, object, init, false, allow_spin))) {
>  			/* Move object to the new freelist */
>  			set_freepointer(s, object, *head);
>  			*head = object;
> @@ -2954,7 +2970,7 @@ static bool __rcu_free_sheaf_prepare(struct kmem_cache *s,
>  		memcg_slab_free_hook(s, slab, p + i, 1, allow_spin);
>  		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
>  
> -		if (unlikely(!slab_free_hook(s, p[i], init, true))) {
> +		if (unlikely(!slab_free_hook(s, p[i], init, true, allow_spin))) {
>  			p[i] = p[--sheaf->size];
>  			continue;
>  		}
> @@ -6225,7 +6241,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  		memcg_slab_free_hook(s, slab, p + i, 1, allow_spin);
>  		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
>  
> -		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
> +		if (unlikely(!slab_free_hook(s, p[i], init, false, allow_spin))) {
>  			p[i] = p[--size];
>  			continue;
>  		}
> @@ -6401,11 +6417,12 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>  	       unsigned long addr)
>  {
>  	bool allow_spin = true;
> +	bool init = slab_want_init_on_free(s);
>  
>  	memcg_slab_free_hook(s, slab, &object, 1, allow_spin);
>  	alloc_tagging_slab_free_hook(s, slab, &object, 1);
>  
> -	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
> +	if (unlikely(!slab_free_hook(s, object, init, false, allow_spin)))
>  		return;
>  
>  	if (likely(can_free_to_pcs(slab)) &&
> @@ -6422,10 +6439,12 @@ static noinline
>  void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
>  {
>  	struct slab *slab = virt_to_slab(object);
> +	bool init = slab_want_init_on_free(s);
> +	bool allow_spin = true;
>  
>  	alloc_tagging_slab_free_hook(s, slab, &object, 1);
>  
> -	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), false)))
> +	if (likely(slab_free_hook(s, object, init, false, allow_spin)))
>  		__slab_free(s, slab, object, object, 1, _RET_IP_);
>  }
>  #endif
> @@ -6456,6 +6475,8 @@ static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
>  	void *object = delayed_free->object;
>  	struct slab *slab = virt_to_slab(object);
>  	struct kmem_cache *s;
> +	bool allow_spin = true;
> +	bool init;
>  
>  	kfree(delayed_free);
>  
> @@ -6469,8 +6490,9 @@ static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
>  	if (WARN_ON(!(s->flags & SLAB_TYPESAFE_BY_RCU)))
>  		return;
>  
> +	init = slab_want_init_on_free(s);
>  	/* resume freeing */
> -	if (slab_free_hook(s, object, slab_want_init_on_free(s), true)) {
> +	if (slab_free_hook(s, object, init, true, allow_spin)) {
>  		__slab_free(s, slab, object, object, 1, _THIS_IP_);
>  		stat(s, FREE_SLOWPATH);
>  	}
> @@ -6742,6 +6764,7 @@ void kfree_nolock(const void *object)
>  	struct kmem_cache *s;
>  	void *x = (void *)object;
>  	bool allow_spin = false;
> +	bool init;
>  
>  	if (unlikely(ZERO_OR_NULL_PTR(object)))
>  		return;
> @@ -6756,33 +6779,10 @@ void kfree_nolock(const void *object)
>  
>  	memcg_slab_free_hook(s, slab, &x, 1, allow_spin);
>  	alloc_tagging_slab_free_hook(s, slab, &x, 1);
> -	/*
> -	 * Unlike slab_free() do NOT call the following:
> -	 * kmemleak_free_recursive(x, s->flags);
> -	 * debug_check_no_locks_freed(x, s->object_size);
> -	 * debug_check_no_obj_freed(x, s->object_size);
> -	 * __kcsan_check_access(x, s->object_size, ..);
> -	 * kfence_free(x);
> -	 * since they take spinlocks or not safe from any context.
> -	 */
> -	kmsan_slab_free(s, x);
> -	/*
> -	 * If KASAN finds a kernel bug it will do kasan_report_invalid_free()
> -	 * which will call raw_spin_lock_irqsave() which is technically
> -	 * unsafe from NMI, but take chance and report kernel bug.
> -	 * The sequence of
> -	 * kasan_report_invalid_free() -> raw_spin_lock_irqsave() -> NMI
> -	 *  -> kfree_nolock() -> kasan_report_invalid_free() on the same CPU
> -	 * is double buggy and deserves to deadlock.
> -	 */
> -	if (kasan_slab_pre_free(s, x))
> +
> +	init = slab_want_init_on_free(s);
> +	if (!slab_free_hook(s, x, init, false, allow_spin))
>  		return;
> -	/*
> -	 * memcg, kasan_slab_pre_free are done for 'x'.
> -	 * The only thing left is kasan_poison without quarantine,
> -	 * since kasan quarantine takes locks and not supported from NMI.
> -	 */
> -	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
>  
>  	if (likely(can_free_to_pcs(slab)) &&
>  			likely(free_to_pcs(s, x, allow_spin)))
> 


