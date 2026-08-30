Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 620CCC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 12:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5290C6B008C; Sun, 30 Aug 2026 08:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA406B0092; Sun, 30 Aug 2026 08:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0A76B0095; Sun, 30 Aug 2026 08:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15B046B008C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:45:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F27E1402CA
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 12:45:23 +0000 (UTC)
X-FDA: 85157906526.08.72F1720
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C96F21A0008
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 12:45:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A3t3iDLZ;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788093921;
	b=SPvCk2XA3RoYdamqxyRS9Q7a+67ScERne3lU2H9ggg4H1zgZxkxKF2NwJKZNszTtLa4BAz
	KNLFKiBKZ/j04CHATVc+RDve2a4WqDer43kkUjBYI/XqgmqXTlYYuE3kdxOpzZkcvXbRMF
	ZdxfLuYjfnr78Hu6fjILp2I/cvQv6n8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A3t3iDLZ;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788093921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k9cnmp5ZkTHdW2lOosIXUykWsrrVlbAOxtMT9OdCYxk=;
	b=7RgwmEoB/h/Ec2luQicXLlYTtTPCxakGDLTjseem5pfLas38mzk0WETpOR/T312gc5U6Xd
	dOQgMYBojcfA8F8LLkMZs0LHhmHb3LsFlm6X7Dt+ugn2uHI/zE4V7BwXW/4Zsui8TChwW5
	ScSoUuMAaDdY0I+gRmN+yhk2tT4FVAA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EDCA40530;
	Sun, 30 Aug 2026 12:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044191F000E9;
	Sun, 30 Aug 2026 12:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788093920;
	bh=k9cnmp5ZkTHdW2lOosIXUykWsrrVlbAOxtMT9OdCYxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A3t3iDLZnHq1YFyUtUOiBvOMlXGNNVk912o1wn7eYy18KDA+IFdiRun+WxiQq9YEU
	 Cmdw73N9/G9XQIzqWRG+VNDPlO3HMMaKCp5ZITH4U5y0zMXp40px/ZyWcJkUHU6PLU
	 ikmJUxoosR3F6tAI2l2jytjXhcWo+FFudJ0K8fpkI4GAGZKLb2lvoQF/fm7dxnLt3T
	 pkUCiK62yxjzuWVHVOI61LlU0ELjQp1fvH/vA/VOq8HqyczrSaU5sEJchwkwmesVOQ
	 tusT6c7RdUk1nYSRM19d2l11kEAyusfnSoPQxl0OwOuB++psqIoapLu/0KZpD5ivrX
	 tunkXec23SWSA==
Date: Sun, 30 Aug 2026 12:45:17 +0000
From: Harry Yoo <harry@kernel.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: take n->list_lock for the list_add() in
 __refill_objects_node()
Message-ID: <apQU8wjMlvbKBQgh@dev>
References: <apPa-cGLcyt90l-E@v4bel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apPa-cGLcyt90l-E@v4bel>
X-Rspam-User: 
X-Stat-Signature: cftozjjdjri988bmtk3tfprorb3m84du
X-Rspamd-Queue-Id: C96F21A0008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788093921-331078
X-HE-Meta: U2FsdGVkX1+pZbDKDJ78bea89yh42NiMHxUM7REv3IHj+cPbKEdJheDOnQB6Q9a9gTVEgoXnBAXeg/PxP2lty5GO1gmWzyfK+EI9hGRZLP1L7P+xE9GImmn/thHWnEbJwJ8ETbduLTG2cuYtKVd91yHMMu+/9K4tXk7X/Eq3kTjEPQHh4tmBcoDRgiU2mcmvzAz9G/Dtf+MaEixA+rzMfiZVl31Uq1s0uW1o0FEJjn0SgChh72Nf1Ib6gOx7JHVqfAuWNp1DN8WxwLT9AzzEHyhDBfLHVbeHHzoSfm8HxNvOrDksL1I2MbxQgvxW7BqbwhKvPq2cGLdAxa2eqRRyMN9YfkmbSrKUKwSa75cafEhCTK43Qgh0c1jB1l/OGw6UizQDRm5bBZvUJ29Djwv1odagFrrcWkitLRWSj9u4E7ZNTaN+FD1uNv4sb+ndCKg9dFm1SbsDtKjLuwCS1CLVDlT7aQO0cLP/DJvO9Eo8M7UNi4DosfOzOX5BLLFlmDgffJDVMJT4EluOBVnCNITGsXNTywWYphGmfPMHqeDOq3+eibuV+4W0asQNcHxaKewrcU0g3imymyKTMN+FMexvxipgwk/6AlrI0ilahem7pIAkoOCMnO31sVXKI7UVab+rClq9u7YRisA8mM6/KoIV1zWbH3iOC14/vonhlPv5Hk5ijRAN0n6Iw/RogpOYwvC0hkzEnZSjP6zBJaKuzQezHUtiEqf7yOtlefhhMxRpTMeA9PlrYidqXdQkfJ1TjlEZSx0iZDGZi+mddqugXMw/r7dJnHGQ3SwV9ZsteT7BsugcME0sugqrsFMv6OLLBrqMbfJ9CKE7fXDc7ZGPEMpJipTQjtk7826ZfIjQHDLIl/g98APZytfo1nm0/MSHzdSVEG3qztmrCk31/Ps50QAMPhzzfYZl1rus8ZKKrpiy4gvyJXxPxHtONfVNBYC1vhU0L5iehG74oK/1CbjMj31
 1HqF7jSf
 2wPy1pYgmbwvlAT7hgfuiSRAVeVr3uyIgcAPJqnI7uOH2T6AUqVjTtA7h90zdyVWwBu6iBmsXGOPOhLHfYab7tCcReGrkwaoJ32W0cSl9KH9s+eNnvAFNCDxZMdcQsz4dyZB+E5ntXNyBzw0KQICxxQlrsLjPlhxFwXMkd/ZWxrLKDnIAmqHT2WrfZmdlN7oNuSpU8fhoTMwIxFpCSOmAEMeYAuem5WGpeEz6645PS3/suJxmtJ5GXIRIit6q/r9jm3oF8C1wAJ/4VTCRkR6rjpCdRjcLWB5GMz1ReTwsnZE1Z6xEiE380MSEIKuBIHPyMuEHROz36C1Ce2DlhI2K8M+8muIe6vumcLMF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 04:25:45PM +0900, Hyunwoo Kim wrote:
> In __refill_objects_node(), the list_add(&slab->slab_list, &pc.slabs) that
> follows a successful __slab_try_return_freelist() is done without
> n->list_lock.
>
> __slab_try_return_freelist() only succeeds while slab->freelist is NULL. The
> slab we are refilling from is taken off pc.slabs by the list_del() at the
> top of the loop, so at that point it is on no list.
> 
> If another CPU frees an object of that slab, __slab_free() sees the slab as
> full and puts it back on n->partial. If a third CPU then takes that object
> in get_from_partial_node(), the freelist becomes NULL again.

Ouch. Good catch, Hyunwoo.
A classic ABA problem :)

> A slab that sits on n->partial with a NULL freelist only exists while
> get_from_partial_node() holds n->list_lock, between its cmpxchg and its
> remove_partial().
> 
> A list_add() in that window overwrites slab_list to point into pc.slabs.
> The list_del() in remove_partial() then follows the overwritten links, so it
> unlinks the slab from pc.slabs and poisons slab_list while leaving the
> n->partial side alone. n->partial is left pointing at the poisoned slab.
> 
>            CPU0                        CPU1                  CPU2
> 
>   __refill_objects_node()
>     get_partial_node_bulk()   // n->partial to pc.slabs
>     list_del()                // on no list now
>     get_freelist_nofreeze()   // freelist = NULL
>                               __slab_free()
>                                 add_partial()
>                                 // back on n->partial
> 	                        // freelist is not NULL
> 
>                                                     get_from_partial_node()
>                                                       lock
>                                                       cmpxchg
>                                                       // freelist = NULL
>     __slab_try_return_freelist()
>     list_add(&pc.slabs)       // overwrites slab_list
>                                                       remove_partial()
>                                                         list_del()
>                                                         // off pc.slabs
>                                                         // slab_list = POISON
> 
> panic log:
> 
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
> Do the list_add() under n->list_lock. Reattaching the freelist stays outside
> the lock. Once it succeeds the freelist is no longer NULL, so __slab_free()
> cannot put the slab back, and by the time the lock is taken remove_partial()
> has finished and the slab is on no list.

Yeah, this should work correctly. 

> The lock is held until the block below that returns the remaining slabs to
> the partial list. That block already took the same lock on this path, so no
> lock/unlock pair is added.
> 
> The unlock is keyed on having taken the lock instead of on pc.slabs being
> empty. With CONFIG_DEBUG_LIST or CONFIG_LIST_HARDENED, __list_add() returns
> without linking anything if its check fails, which would leave pc.slabs
> empty.

Well, if the check fails, it has a bug and should be fixed.
We should not make the code less readable to handle a bug.

I think it's better to have (diff on top of the patch, not tested):

diff --git a/mm/slub.c b/mm/slub.c
index 7a7f9935c711..eff96b992164 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7216,12 +7216,10 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 			break;
 	}
 
-	if (!locked && !list_empty(&pc.slabs)) {
-		spin_lock_irqsave(&n->list_lock, flags);
-		locked = true;
-	}
+	if (!list_empty(&pc.slabs)) {
+		if (!locked)
+			spin_lock_irqsave(&n->list_lock, flags);
 
-	if (locked) {
 		list_for_each_entry(slab, &pc.slabs, slab_list)
 			set_node_partial_state(n, slab);

> Fixes: ba7425312607 ("mm, slab: add an optimistic __slab_try_return_freelist()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> ---
>  mm/slub.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f9b56cb439e709..4f6d1a03a8ee46 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7260,6 +7260,7 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>  	struct slab *slab, *slab2;
>  	unsigned int refilled = 0;
>  	unsigned long flags;
> +	bool locked = false;
>  	void *object;
>  
>  	pc.flags = gfp;

uh, I'm not a big fan of having a new variable to store 'locked' state,
but okay, this seems unavoidable with current implementation.

> @@ -7297,7 +7298,10 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>  			void *tail;
>  
>  			if (__slab_try_return_freelist(s, slab, head, count)) {
> +				/* get_from_partial_node() may be mid-removal of the slab */
> +				spin_lock_irqsave(&n->list_lock, flags);
>  				list_add(&slab->slab_list, &pc.slabs);
> +				locked = true;
>  				break;
>  			}
>  
> @@ -7312,9 +7316,12 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>  			break;
>  	}
>  
> -	if (!list_empty(&pc.slabs)) {
> +	if (!locked && !list_empty(&pc.slabs)) {
>  		spin_lock_irqsave(&n->list_lock, flags);
> +		locked = true;
> +	}
 
-- 
Cheers,
Harry / Hyeonggon
 

