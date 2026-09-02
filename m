Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1051C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9926B00E0; Wed,  2 Sep 2026 12:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D0EA6B00E2; Wed,  2 Sep 2026 12:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BF796B00E3; Wed,  2 Sep 2026 12:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5458A6B00E0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:58:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3BB4A3FAF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:57:59 +0000 (UTC)
X-FDA: 85169429478.07.8A78931
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2FBC720005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:57:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bRC3J1nx;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788368278;
	b=jftNSvezp+KBjAMHIxsBmG1mVHVxSQQSIfwNBM6GwgpvXaXe5d7W7FUdoxDA8ziu8ERLx9
	hhXYAqj7jZBxSKvDA4GaynJZdr5ZM9r8gb6PSct+EK0SV2kv7GMz/yvkkUbwOQS23laiCT
	W+fFVud1Lmt0eCEviVksSgMjStKPXC0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bRC3J1nx;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788368278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=egVdb9UoIL1aFUo42c4ZwNrUAMjWH0tjK9izmK9H+8E=;
	b=TF5KiNHH3ruMjYohzmkRpIzCPCyIy9+5qIt+vN5yGyhxXMkF0Xgpy37P/+31iUZR3GqGjG
	qmjyVd+xHNmGEvUhr0lfNw7H+b2GGJwo0Oyg8SBS+jMia4F1a05eJW+lGJ1qMbQwPU4wz5
	nm/4qLgcPTeWZVq0Ym9R1wYnhNq6KZc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7ADA600D1;
	Wed,  2 Sep 2026 16:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D381F00A3A;
	Wed,  2 Sep 2026 16:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788368277;
	bh=egVdb9UoIL1aFUo42c4ZwNrUAMjWH0tjK9izmK9H+8E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bRC3J1nxrhByXxV1AzoxvxllYIAt9IFtTY8uFYbNNIEThdUlLVwzKclQGJsQgyqKu
	 wW3d/ZWibebIPxjn2Qj7i54hBJ9j3hiRHFD1tsk+2FEYBMqZH1n91FgrZ1xZ8GJDlQ
	 p5J9cld0PMCG7FKqipexJezTLfyw3+JrG5RVTU1HvYLAnmatcb9BBFsWmR+eYiB8w+
	 cTRa64QUk18pJFpJCRnHG7O+1gU8Ordfg0g+cDtKi9uVV2jQROhougTPl1hpbuDRpy
	 I1EKZrdWjGt7P1AWZ+65QJSuygNTsHiDSEHNNBNRyr9U1hWk2sS8PvA2Hqo9VATkXe
	 ud+QOgnfWYejg==
Message-ID: <b85f9954-4bbd-45f4-80dc-6c9d32cefcd5@kernel.org>
Date: Wed, 2 Sep 2026 18:57:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slab: take n->list_lock in
 __slab_try_return_freelist() to avoid race
Content-Language: en-US
To: "Harry Yoo (Meta)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hyunwoo Kim <imv4bel@gmail.com>
References: <20260902-slab-fix-aba-v2-1-d1ece15a8417@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260902-slab-fix-aba-v2-1-d1ece15a8417@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2FBC720005
X-Stat-Signature: 5j4ddxjey6d5cggubokb4tdmc8j7mino
X-Rspam-User: 
X-HE-Tag: 1788368277-652006
X-HE-Meta: U2FsdGVkX19qK3RS4sq0zJt21XBXGzsYubxz23eE4UmeTwkRrA5vo1/RpLcpxci7qYrAeaHQ3o8DqZC+L4vo1DZnKY0wrcNoxeClEixVWEcc21K63W/qUuNDTzJJI2Ew9FjenbOBhGOzR/SJlwaTGMcUHkq/+zwwVbwMXcnRu/ht204dJ/di2fkkZHRtKBuoUDJxkn2jyvHPNzgkUaLn3ODFzaldDaXPWgWShvggWE6v3LL7/bmUgXHvR6d9Q0UE39uliii3coDspLirJRo0QTlNOI1xWuh55DZhVOsJMobxEyGrKuCe8bVyvBGYkbkA2IH4KuZEf6gZy8BWeAu3qNu3R3bmGctgiTIrwc583138OMhrBSoxT0C3KH25hLAcyQS3qfnE3t/husO0cNMDbWZRZHwsXcCM9g/REdJ2CjzO4aNRYxmBpPTHl0mu5Fzo/4umrh/0BZYKafzbq2MCoD0jCtB5YUaWYYUPX0AQAyBE1SnINmpBIb7OHrOCyfjpz+CsVYFcGlRctcoxs1V0qeyTj5CpXS1zomOOuN75IGSTbQ7As6uy1KBSnOaErEso25GFB11TPEdT2NxgyNqKPGfNj/dgjU8VLaPlkyZJILb7RP+991jEDxhJUtTBi2PwyjcDexirAsvMa4ZC4E6actNEW8u6hLzs1vXsvGlcgfMaZuiSjZjWnm9IK8BDcA28Yys9tdhTtbbx0KM1J/mKJCdIEaqW84Sgdp3u6AkbfApVMkW0n9B5zwzt4QZk6wnOh30qMxfHpMHlBS5ESy11yeL70ama8YSHCs/aZgp7v2p3GywLSbXZeSTubjGl2G8TjGdmiztihoQXNKT2N143Q8ulP+ColRfr93dusjWJHzxzgzMzlEIAl3eVSL63DevwzA/6tCLMJGhwHZOtGwW87aak5vc7QIKhqvL6nqff/GpZmIJIr25cgBTH4snoQEuUo94hkK+6Tji67qHTufb
 56MlmBSa
 GUEgSMTLr7X4BpG5/oJiGDDz0eSQ8IgTXUeYykKzs969zsIhx0PKrNSNsSC/Zg4hVm1M2MTI4DD/YX7hJLZDwic6fjOuy+jr0gxFMHLUDFKAGyN7iq6FRHLqAGGBL3IBlerb/CIWiD8IMzDIarvyMAY4I0H7lihaMbJpenC/QXk64GBElDX30UEpbNQ3jVpACE5Hx1imDBSoNjtSEueVHsRGFl/mx2d+HUhXrObU/7LXYIpfaZg0E/DrjD9QOjrkWXeXPSfEPC54YTNlP/865Gx0SWuiorx9z80Bz0bj/3GGh98Nq5dDXGf8tE0WugnPO48RItbpkiboR/9JBVVSyEWroWMR6H9kFaLdp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 18:41, Harry Yoo (Meta) wrote:
> Commit ba7425312607 ("mm, slab: add an optimistic
> __slab_try_return_freelist()") incorrectly assumed that nobody has freed
> an object to the slab as long as slab->freelist is NULL and cmpxchg
> succeeds.
> 
> However, as reported by Hyunwoo Kim [1], other CPUs might have freed
> an object to the slab, insert the slab to the partial list, then
> allocated an object from the slab, and be in the middle of removing
> the slab from the list under n->list_lock.
> 
> Since __refill_objects_node() puts the slab back on pc.slabs
> outside n->list_lock, it might insert the slab into that list while
> the slab is concurrently being removed from n->partial.
> This led to a list corruption, as reported by Hyunwoo Kim [1]:

"as reported by ..." was already said above, we could keep just the [1] or
drop completely?

>   list_add corruption. next->prev should be prev
>   (ffff888100000248), but was dead000000000122.
>   (next=ffffea000416e410).
>   kernel BUG at lib/list_debug.c:29!
>   Oops: invalid opcode: 0000 [#1] SMP NOPTI
>   CPU: 1 UID: 65534 PID: 144 Comm: poc Not tainted
>   7.2.0-16172-gcf72cbb39da8-dirty #1 PREEMPT(lazy)
>   RIP: 0010:__list_add_valid_or_report+0x80/0xd0
>   ...
>   Call Trace:
>    alloc_from_new_slab+0x183/0x300
>    ___slab_alloc+0x31c/0x890
>    __kmalloc_noprof+0x3d4/0x800
>    lsm_blob_alloc+0x2d/0x50
>    security_msg_msg_alloc+0x26/0x90
>    load_msg+0x1aa/0x210
>    do_msgsnd+0x91/0x800
>    do_syscall_64+0x109/0x5d0
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   ...
>   Kernel panic - not syncing: Fatal exception
> 
> This is a classic ABA problem where cmpxchg succeeds but the state has
> changed since __refill_objects_node() took the freelist from the slab.
> 
> As Vlastimil Babka mentioned [2], it should be rare to return more than
> one slab (due to the racy read of slab->counters in
> get_partial_node_bulk()). Therefore, instead of introducing additional
> complexity, acquire and release n->list_lock twice in the worst case.
> 
> Return the slab directly to the partial list and hold n->list_lock
> across the cmpxchg and add_partial(). This is similar to the initial
> version of commit ba7425312607 [3]. This is enough to avoid the race as
> the list manipulation is serialized by n->list_lock. While at it,
> bring back unlikely() hint now that the condition is unlikely.

Ah nicely spotted.

> Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/apPa-cGLcyt90l-E@v4bel [1]
> Link: https://lore.kernel.org/linux-mm/ae25c193-b95f-40c1-83b6-1c2546467e41@kernel.org [2]
> Link: https://lore.kernel.org/all/20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org [3]
> Fixes: ba7425312607 ("mm, slab: add an optimistic __slab_try_return_freelist()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
> ---
> Changes in v2:
> - EDITME: describe what is new in this series revision.
> - EDITME: use bulletpoints and terse descriptions.
> - Link to v1: https://lore.kernel.org/r/apPa-cGLcyt90l-E@v4bel
> ---
>  mm/slub.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f9b56cb439e7..5cbbacb8ee32 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5684,6 +5684,8 @@ static bool __slab_try_return_freelist(struct kmem_cache *s, struct slab *slab,
>  				       void *head, int cnt)
>  {
>  	struct freelist_counters old, new;
> +	struct kmem_cache_node *n;
> +	unsigned long flags;
>  
>  	old.freelist = slab->freelist;
>  	old.counters = slab->counters;
> @@ -5695,9 +5697,16 @@ static bool __slab_try_return_freelist(struct kmem_cache *s, struct slab *slab,
>  	new.counters = old.counters;
>  	new.inuse -= cnt;
>  
> -	if (!slab_update_freelist(s, slab, &old, &new, "__slab_try_return_freelist"))
> +	n = get_node(s, slab_nid(slab));

Wonder if we could just pass the 'n' to __slab_try_return_freelist() that we
already have in the caller.

> +	spin_lock_irqsave(&n->list_lock, flags);
> +
> +	if (!slab_update_freelist(s, slab, &old, &new, "__slab_try_return_freelist")) {
> +		spin_unlock_irqrestore(&n->list_lock, flags);
>  		return false;
> +	}
>  
> +	add_partial(n, slab, ADD_TO_TAIL);
> +	spin_unlock_irqrestore(&n->list_lock, flags);
>  	return true;
>  }
>  
> @@ -7296,10 +7305,8 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>  			void *head = object;
>  			void *tail;
>  
> -			if (__slab_try_return_freelist(s, slab, head, count)) {
> -				list_add(&slab->slab_list, &pc.slabs);
> +			if (__slab_try_return_freelist(s, slab, head, count))
>  				break;
> -			}
>  
>  			do {
>  				tail = object;
> @@ -7312,7 +7319,7 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>  			break;
>  	}
>  
> -	if (!list_empty(&pc.slabs)) {
> +	if (unlikely(!list_empty(&pc.slabs))) {
>  		spin_lock_irqsave(&n->list_lock, flags);
>  
>  		list_for_each_entry(slab, &pc.slabs, slab_list)
> 
> ---
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> change-id: 20260902-slab-fix-aba-d60f39fc9dee
> 
> Best regards,


