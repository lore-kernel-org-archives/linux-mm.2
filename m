Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 017B2C624D7
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E7DF6B00B5; Thu,  3 Sep 2026 06:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072296B00B7; Thu,  3 Sep 2026 06:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3396B00B8; Thu,  3 Sep 2026 06:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B86E06B00B5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:22:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5012BA04D0
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:22:22 +0000 (UTC)
X-FDA: 85172061324.20.DDEDF7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A6F1320003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:22:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QQGCnZ47;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788430940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vEpLXgLt5BvR7hF8m7cdeksa+geMrv7LSsfWhyIOPZE=;
	b=gEGcS8V4TQ7ff0fXYiBIwXnK19A75MTcgfAxBBWlK6h1gwgV9dLlxjTzNmroNQrQ/xV3J1
	0wh8SbIzEfOrEPkc02a5VpbCe+Xeg1Apif8QNYi+kB0jDig9eEXzq3kYoTOsjMVpaoITti
	5aPWM8WfoEn927byIipRkB5XG1kvaE4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788430940;
	b=ag9SdiaPepGApbHrt1sSj7IfzBvUKt6aKvUJJOL5rkJ1E4nsqmWIxSCNfkjXc8cywHynCM
	NznERMfMAlVgcIuZHYJBpkTKs73n5u+xbS9EgGl791Y6BuayRMGRfiDxCrV42wbgfka1tV
	TXzXc2373Fwj4aqjjcERDTXsNXnSuH4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QQGCnZ47;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 96D6E43987;
	Thu,  3 Sep 2026 10:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F0E1F00A3A;
	Thu,  3 Sep 2026 10:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788430939;
	bh=vEpLXgLt5BvR7hF8m7cdeksa+geMrv7LSsfWhyIOPZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QQGCnZ47fkRm6UHXBzWDo7WAVs9V0NX+m3P2MS54lcMGqQGUej9wXvnyQW72T0glC
	 n7OzcFLuuAiY3n11Eu46S6XXUxBAN1CVPQLr1FyJBs2bl4yBQGnAMBPY9H8NcRXyjA
	 YjboFghi9QegdzYpOuuD7fGUHMXU/m+kc1X53MHJlU89+XXR5tZzyYTJh8aQrYgQze
	 wAWFR31ekI+3/PpGP99vvUHbguigwl05V/yztSWVRhqnDZNHREksFa3ZmH4v7dy6XY
	 If+5urBcnHaeFOPQy19B8nK90jIeozYIESseZMwYnLG+tRDZ9TPFThjMvw7xZVB6Tn
	 jSGeo5Lk7RQsg==
Date: Thu, 3 Sep 2026 11:22:17 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hyunwoo Kim <imv4bel@gmail.com>
Subject: Re: [PATCH v2] mm/slab: take n->list_lock in
 __slab_try_return_freelist() to avoid race
Message-ID: <aplJWzzxioK9TlT9@nixos>
References: <20260902-slab-fix-aba-v2-1-d1ece15a8417@kernel.org>
 <b85f9954-4bbd-45f4-80dc-6c9d32cefcd5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b85f9954-4bbd-45f4-80dc-6c9d32cefcd5@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A6F1320003
X-Stat-Signature: oua9rs4udowxdxu5a1iwj6kdt1zr5on1
X-HE-Tag: 1788430940-563461
X-HE-Meta: U2FsdGVkX19Ymm24Gtmgc+R8mjFpFGbDJK4J4uO1YkgB/klXZQODCTtfExJc2QxqZAj7/1bSbRn5I5d7JJDIjnNctAr9ly3f4eKgurPy/PJtu8ufk10xb2FM0OnycDItHeG1qykmCWPPOrjIwZEuud+Arv3nbaT3D0kuJlbVstS5JB7u9fcNQpxIrCK8g48GkPPJmcbMSqxIE2LZgWdWQwErfPdrgNvx9Egu/lPlXF3VRGkS38pLLlD4K+36FSNBNETLyoR1pn9KLPrjMJRqDgzp5a4IB6TJz9N7MHFZO2oiCvoEupX0emRgI7R8zcDLlBv1AJxB9NR10PLa1vRxa/oLMXZY6M5qpEGwrapyb185d2G9nDxw87jv+R3fztkfLyLiT8ad7E4hmaXxPUNa0sVJ/YlhKY8+zvUIy702+1Z190bOTPelk3lzWnm7ba6maFQ/idCQknLYC/lPWuGjWOa/Mybv2s2KfP8Eo2Roz5O5fMGcWrwWD42n9IitCQ5Y3Rooh1prFFOWEBpTcL906bO+hpj279KTYXoZpzFH9SpVpflkHI5UE6QpOnBt8sWepGRiSvBP/gkTuLNcm3x1uthEzR3M0w3Ps/up5jifrgK/aXNagezuGVMljgcxSmj0PFEnkdXv/o4bZ93nMNKPCtcaeJvumCTNGpi0lMYTRxx+dIBQtxw4/4XMdUlw/DoYgmXQ1HrUuUq169j14FxzDs2XUoKAxI5gaWuWJ2n95qAqycwIihYrjenUNRTEsRor2AGisUp6/mR7pu1DyPGX2uwUPg4LKjO02gSVJBsgV4w7WT7JSP5YECJVgwbFuZbTMN7toGpolw1FjyVx243F+GtjICJ5QyrAoeQgCiczMUX8zu3ZE2Dw3xVFvfGLNKIwKQ6gSJAzl4zRJhAf0YHIuu0cvFTX4WcY3N/SuUUjwTxdK1gi+/LhQc/ehRuVAH+1qjjYgyvte5YHfn4hzrK
 r1urWwFw
 Q/Am45waSY55ScPyELWJpnI+W9+j1L2/FTqTOmQEXFuktaWAkEEP2w3S7CiuMBWSXQQukxFGNWCjkmuaBPMK6YTiLzfHsJRQN135J4gxYOH7v6J4zFzKWYKBJvLIU+ibsEHcYagH6lmMPxFaa4oUjAUT5XlaqdALRWMCRuYtx+K7ZrgxQN78olGiKN9O5sWiQs2SYPf5KvhHXJNGguYMguWS/zv74s5phB1uwmJchanh66Mu9XIPetsjgE2nSnrHNxZwf1q/6qqAa8DEebXuphpWHTx5GDHfwzhr5SDY3bgEKo04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 06:57:53PM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/2/26 18:41, Harry Yoo (Meta) wrote:
> > Commit ba7425312607 ("mm, slab: add an optimistic
> > __slab_try_return_freelist()") incorrectly assumed that nobody has freed
> > an object to the slab as long as slab->freelist is NULL and cmpxchg
> > succeeds.
> > 
> > However, as reported by Hyunwoo Kim [1], other CPUs might have freed
> > an object to the slab, insert the slab to the partial list, then
> > allocated an object from the slab, and be in the middle of removing
> > the slab from the list under n->list_lock.
> > 
> > Since __refill_objects_node() puts the slab back on pc.slabs
> > outside n->list_lock, it might insert the slab into that list while
> > the slab is concurrently being removed from n->partial.
> > This led to a list corruption, as reported by Hyunwoo Kim [1]:
> 
> "as reported by ..." was already said above, we could keep just the [1] or
> drop completely?

I didn't want to steal the credit for splat ;) but yeah keeping [1]
should be enough.

> >   list_add corruption. next->prev should be prev
> >   (ffff888100000248), but was dead000000000122.
> >   (next=ffffea000416e410).
> >   kernel BUG at lib/list_debug.c:29!
> >   Oops: invalid opcode: 0000 [#1] SMP NOPTI
> >   CPU: 1 UID: 65534 PID: 144 Comm: poc Not tainted
> >   7.2.0-16172-gcf72cbb39da8-dirty #1 PREEMPT(lazy)
> >   RIP: 0010:__list_add_valid_or_report+0x80/0xd0
> >   ...
> >   Call Trace:
> >    alloc_from_new_slab+0x183/0x300
> >    ___slab_alloc+0x31c/0x890
> >    __kmalloc_noprof+0x3d4/0x800
> >    lsm_blob_alloc+0x2d/0x50
> >    security_msg_msg_alloc+0x26/0x90
> >    load_msg+0x1aa/0x210
> >    do_msgsnd+0x91/0x800
> >    do_syscall_64+0x109/0x5d0
> >    entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >   ...
> >   Kernel panic - not syncing: Fatal exception
> > 
> > This is a classic ABA problem where cmpxchg succeeds but the state has
> > changed since __refill_objects_node() took the freelist from the slab.
> > 
> > As Vlastimil Babka mentioned [2], it should be rare to return more than
> > one slab (due to the racy read of slab->counters in
> > get_partial_node_bulk()). Therefore, instead of introducing additional
> > complexity, acquire and release n->list_lock twice in the worst case.
> > 
> > Return the slab directly to the partial list and hold n->list_lock
> > across the cmpxchg and add_partial(). This is similar to the initial
> > version of commit ba7425312607 [3]. This is enough to avoid the race as
> > the list manipulation is serialized by n->list_lock. While at it,
> > bring back unlikely() hint now that the condition is unlikely.
> 
> Ah nicely spotted.

Thanks ;-)

> > diff --git a/mm/slub.c b/mm/slub.c
> > index f9b56cb439e7..5cbbacb8ee32 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5684,6 +5684,8 @@ static bool __slab_try_return_freelist(struct kmem_cache *s, struct slab *slab,
> >  				       void *head, int cnt)
> >  {
> >  	struct freelist_counters old, new;
> > +	struct kmem_cache_node *n;
> > +	unsigned long flags;
> >  
> >  	old.freelist = slab->freelist;
> >  	old.counters = slab->counters;
> > @@ -5695,9 +5697,16 @@ static bool __slab_try_return_freelist(struct kmem_cache *s, struct slab *slab,
> >  	new.counters = old.counters;
> >  	new.inuse -= cnt;
> >  
> > -	if (!slab_update_freelist(s, slab, &old, &new, "__slab_try_return_freelist"))
> > +	n = get_node(s, slab_nid(slab));
> 
> Wonder if we could just pass the 'n' to __slab_try_return_freelist() that we
> already have in the caller.

Sounds good, will do.

-- 
Cheers,
Harry / Hyeonggon

