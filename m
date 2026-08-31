Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9C45C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 12:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82686B009B; Mon, 31 Aug 2026 08:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C345A6B009D; Mon, 31 Aug 2026 08:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B22E56B009E; Mon, 31 Aug 2026 08:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89F5A6B009B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:55:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1EE54A14AF
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:55:14 +0000 (UTC)
X-FDA: 85161560148.23.3D59EAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 36E701C0007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:55:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e+EG9G68;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788180912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OmPaskXm6g4JpidhOBhlM22xpKNyZgtcM28tDodfu/o=;
	b=cBMwOJ6IujjyArkyyId2WdB1OHEkKcmpaI49k//mtsiAfMYx90q4WfhtRH9EzN8DGbuoVw
	Ro/D/GlJ64mfHBweBVuOPni/mRHfGX/c2I/nBuJ9I0x2KdNw3d06vhN06IT0C4oxv0Zn7d
	zOTy+3L1jKqv9ukS1xKWcU3ynL0i1OA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788180912;
	b=QK0dH++j8QNjDB0WOgGdwKo2OTKeUSOVT6+DPQa5zoydWzBqkus8op35xJwJS8q5D5/GwQ
	35j5fQzX4LJnWc6OwW9dtW50uYegUvFQ4CSjif5AgnNrjVeAMn6iwKhx07dDlQhxlmcWua
	R4oOlS7XVX163yXOMBrXfazz+vFLABY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e+EG9G68;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1FC641FB3;
	Mon, 31 Aug 2026 12:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FE71F000E9;
	Mon, 31 Aug 2026 12:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788180910;
	bh=OmPaskXm6g4JpidhOBhlM22xpKNyZgtcM28tDodfu/o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e+EG9G68U0egvi5dVujy7wSn5FyFsg24+XtNF1z9xGohynv3E5mfZEfo4t3cYN4dB
	 5Hkx8+6x8V/sUsaxLHZHHB3jF8PiYiN6Z+2BUKF1A4F4F7EuBxxRdBpc3xDNBTpK1n
	 E0TnZ6I9SeYDKmlj/P2fBQgDGy5Yprf9Vv4f00KLQqcUrm9x65Cosi9lRr7puiwWpE
	 Y0DQEpz6b6XjtdHmmro5rRk9s5oyrRf4WRVfo1soZlYnD3MXGltT9Vg34EcPhhug54
	 IuWuOxxe+RoDrN1q/OdwSLyP/IFTVd0yO/HuqjwefKpEMTfnM1l8wYroTj+wpt52xA
	 ujXU3u3+/e0Vw==
Message-ID: <ae25c193-b95f-40c1-83b6-1c2546467e41@kernel.org>
Date: Mon, 31 Aug 2026 14:55:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: take n->list_lock for the list_add() in
 __refill_objects_node()
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <apPa-cGLcyt90l-E@v4bel> <apQU8wjMlvbKBQgh@dev>
 <apQ7osHcRj3vdJPn@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <apQ7osHcRj3vdJPn@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 36E701C0007
X-Stat-Signature: r66ay569p7k987kg3ixdwoebrr7k6eam
X-HE-Tag: 1788180912-851630
X-HE-Meta: U2FsdGVkX18QQSIQKBIhXQXQfVMnx3ujf7YgaO0FLnosoRtlyWpBJCwNd/gAHxVUptU9fGdRfzRaYA7h6027qhLkEorZUuA3eD26a/nSn7I4JVnpG3ubxL9zUYRY+PMoeJqivlpvTH8GjPXJq8PJZMJM7CoFLn1x0AhUjDCh+b2QHPPERsG8JGJ0ydGJIiK4NQRZoBKU5ivGMf0kboBWLWm29yMgcQqm8EJO1KMUPZHpEw+v2egbDHjtpLfib1tQ1mJW8q5wO9HcrZLE+w57U+XMaj5uRZxxalGy0dZDOURpAGbViufHfNXgqtM71utyOEE2tzsqULep6em5RLmKzDnk5ByakEh4kqWh6Qyb3WgC5mE4Pb2T9DJwAgUrXVyMvMNFApTw1Y48aPx0QuliCTI9s8dUSTBazJt+qLjHp4SUc2denMAaioldg9knTmSN6pHxWSMh7R5A07O/LtCORNkWm1SdziYNNbXenjEt6jmjSMhMgWhXPDZzBVU5p7W9vx2E+Uomi+zWmUEpQKSJlQLAhXMQ6Lrx4Jtbo4XSVLK2Dm9UVwWva4nxk3cMIMaBxTxor4LvT+PLIuxXsiXdMVlpH87ExDdk4IM79qrHLgbwWluMC+XRUF17zYaZS+8JWf6ZeT61ZvjzU1AEHC4yQ1gGXwGE21wMCagEuSJvwvsMsw1IEzERqCbxCgPORXFYGnZMy10DgNPNQ8nCBkjoKg+T+ndJ5258TmQTixM7a9V1CV9vM5t7jOTN7fvi3gmVBP+SnsTkQWwdCMX0XcGfvwm2R3EpwV+gsdZmGTIAB9CCnnnMMH5cKxKASEnTNWCuyDVdbW43Ql7muZwHJrFR27MxSh3KquGqLe8E+U2T1W6kLj7kqN+G9ULdzUgtfxYlqoaGK6J9booR34wz7uV5tOlp9beYdGn9pQx3oLrDpWub0ULevORCNd0Ecj3hthooK6cRMXVyL3l4ytObVUD
 4LyOqHs8
 wFxYqbkGs3hU0G8KtO5F9cNyyCq6BnihEYRF0dHsAA0SmopLqp3tpKtzSDm0GatlTyc0Zd9t5ICRZ0bn7nXBrOMiHsZU+5uqud9ceNee1QLSHvB/t5be/7SgKllxdhzhXHbqbeJXLfMXhMfIwKOcahac6G+IGI9qq75DtZbTDXIfB/WOdzWX5OjKIR+3f0Q7IFS5pWll2NS3UgWh3Fu8e1itkrCB68p98NYLHXhmV6uWtL3TByL/gNaQa9QStbUP3QcEr4PIkad5hTMqFYcXvHxGFboJ7BFQ7dogrp72CzMw93Dmwfo/+/uL1yhQKLmv7SsGGyaj/ZkxzbT9N7RfhXOsg/ombWtRBIQhc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/30/26 16:35, Hao Li wrote:
> On Sun, Aug 30, 2026 at 12:45:17PM +0000, Harry Yoo wrote:
>> On Sun, Aug 30, 2026 at 04:25:45PM +0900, Hyunwoo Kim wrote:
>> > In __refill_objects_node(), the list_add(&slab->slab_list, &pc.slabs) that
>> > follows a successful __slab_try_return_freelist() is done without
>> > n->list_lock.
>> >
>> > __slab_try_return_freelist() only succeeds while slab->freelist is NULL. The
>> > slab we are refilling from is taken off pc.slabs by the list_del() at the
>> > top of the loop, so at that point it is on no list.
>> > 
>> > If another CPU frees an object of that slab, __slab_free() sees the slab as
>> > full and puts it back on n->partial. If a third CPU then takes that object
>> > in get_from_partial_node(), the freelist becomes NULL again.
>> 
>> Ouch. Good catch, Hyunwoo.
>> A classic ABA problem :)

Ouch, indeed.

>> > A slab that sits on n->partial with a NULL freelist only exists while
>> > get_from_partial_node() holds n->list_lock, between its cmpxchg and its
>> > remove_partial().
>> > 
>> > A list_add() in that window overwrites slab_list to point into pc.slabs.
>> > The list_del() in remove_partial() then follows the overwritten links, so it
>> > unlinks the slab from pc.slabs and poisons slab_list while leaving the
>> > n->partial side alone. n->partial is left pointing at the poisoned slab.
>> > 
>> >            CPU0                        CPU1                  CPU2
>> > 
>> >   __refill_objects_node()
>> >     get_partial_node_bulk()   // n->partial to pc.slabs
>> >     list_del()                // on no list now
>> >     get_freelist_nofreeze()   // freelist = NULL
>> >                               __slab_free()
>> >                                 add_partial()
>> >                                 // back on n->partial
>> > 	                        // freelist is not NULL
>> > 
>> >                                                     get_from_partial_node()
>> >                                                       lock
>> >                                                       cmpxchg
>> >                                                       // freelist = NULL
>> >     __slab_try_return_freelist()
>> >     list_add(&pc.slabs)       // overwrites slab_list
>> >                                                       remove_partial()
>> >                                                         list_del()
>> >                                                         // off pc.slabs
>> >                                                         // slab_list = POISON
>> > 
>> > panic log:
>> > 
>> >   list_add corruption. next->prev should be prev
>> >   (ffff888100000248), but was dead000000000122.
>> >   (next=ffffea000416e410).
>> >   kernel BUG at lib/list_debug.c:29!
>> >   Oops: invalid opcode: 0000 [#1] SMP NOPTI
>> >   CPU: 1 UID: 65534 PID: 144 Comm: poc Not tainted
>> >   7.2.0-16172-gcf72cbb39da8-dirty #1 PREEMPT(lazy)
>> >   RIP: 0010:__list_add_valid_or_report+0x80/0xd0
>> >   ...
>> >   Call Trace:
>> >    alloc_from_new_slab+0x183/0x300
>> >    ___slab_alloc+0x31c/0x890
>> >    __kmalloc_noprof+0x3d4/0x800
>> >    lsm_blob_alloc+0x2d/0x50
>> >    security_msg_msg_alloc+0x26/0x90
>> >    load_msg+0x1aa/0x210
>> >    do_msgsnd+0x91/0x800
>> >    do_syscall_64+0x109/0x5d0
>> >    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> >   ...
>> >   Kernel panic - not syncing: Fatal exception
>> > 
>> > Do the list_add() under n->list_lock. Reattaching the freelist stays outside
>> > the lock. Once it succeeds the freelist is no longer NULL, so __slab_free()
>> > cannot put the slab back, and by the time the lock is taken remove_partial()
>> > has finished and the slab is on no list.
>> 
>> Yeah, this should work correctly. 
>> 
>> > The lock is held until the block below that returns the remaining slabs to
>> > the partial list. That block already took the same lock on this path, so no
>> > lock/unlock pair is added.
>> > 
>> > The unlock is keyed on having taken the lock instead of on pc.slabs being
>> > empty. With CONFIG_DEBUG_LIST or CONFIG_LIST_HARDENED, __list_add() returns
>> > without linking anything if its check fails, which would leave pc.slabs
>> > empty.
>> 
>> Well, if the check fails, it has a bug and should be fixed.
>> We should not make the code less readable to handle a bug.
>> 
>> I think it's better to have (diff on top of the patch, not tested):
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 7a7f9935c711..eff96b992164 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -7216,12 +7216,10 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>>  			break;
>>  	}
>>  
>> -	if (!locked && !list_empty(&pc.slabs)) {
>> -		spin_lock_irqsave(&n->list_lock, flags);
>> -		locked = true;
>> -	}
>> +	if (!list_empty(&pc.slabs)) {
>> +		if (!locked)
>> +			spin_lock_irqsave(&n->list_lock, flags);
>>  
>> -	if (locked) {
>>  		list_for_each_entry(slab, &pc.slabs, slab_list)
>>  			set_node_partial_state(n, slab);
> 
> Since introducing a new variable seems unavoidable, what if we temporarily
> stash this slab in a pointer like below, and then add it to pc.slabs once we
> acquire the lock.
> 
> struct slab *leftover_slab = NULL;
> 
> ...
> ...
> 	if (__slab_try_return_freelist(s, slab, head, count)) {
> 		leftover_slab = slab;
> 		break;
> 	}
> 
> ...
> ...
> if (!list_empty(&pc.slabs)) {
> 	spin_lock_irqsave(&n->list_lock, flags);
> 
> 	if (leftover_slab)
> 		list_add(&leftover_slab->slab_list, &pc.slabs);
> 	...
> 	...
> }
> 
> PS: If I recall correctly, Vlastimil's initial patch was actually fine. It was
> my suggestion to save an extra lock/unlock pair that accidentally led to this
> trap...

Ah, thanks for the reminder. This [1] was the original attempt.

[1]
https://lore.kernel.org/all/20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org/

I wonder if the fix should be to return to that approach and just have
__slab_try_return_freelist() handle the list_lock. The code would be simpler
with not "bool locked".

It should be really very rare that we would end up returning a partial list
and also have additional slabs to return on pc.slabs? So I think there would
be no noticeable performance downside to the simpler code potentially ending
up taking the list_lock twice instead of once.

>> 
>> > Fixes: ba7425312607 ("mm, slab: add an optimistic __slab_try_return_freelist()")
>> > Cc: stable@vger.kernel.org
>> > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
>> > ---
>> >  mm/slub.c | 9 ++++++++-
>> >  1 file changed, 8 insertions(+), 1 deletion(-)
>> > 
>> > diff --git a/mm/slub.c b/mm/slub.c
>> > index f9b56cb439e709..4f6d1a03a8ee46 100644
>> > --- a/mm/slub.c
>> > +++ b/mm/slub.c
>> > @@ -7260,6 +7260,7 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>> >  	struct slab *slab, *slab2;
>> >  	unsigned int refilled = 0;
>> >  	unsigned long flags;
>> > +	bool locked = false;
>> >  	void *object;
>> >  
>> >  	pc.flags = gfp;
>> 
>> uh, I'm not a big fan of having a new variable to store 'locked' state,
>> but okay, this seems unavoidable with current implementation.
>> 
>> > @@ -7297,7 +7298,10 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>> >  			void *tail;
>> >  
>> >  			if (__slab_try_return_freelist(s, slab, head, count)) {
>> > +				/* get_from_partial_node() may be mid-removal of the slab */
>> > +				spin_lock_irqsave(&n->list_lock, flags);
>> >  				list_add(&slab->slab_list, &pc.slabs);
>> > +				locked = true;
>> >  				break;
>> >  			}
>> >  
>> > @@ -7312,9 +7316,12 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>> >  			break;
>> >  	}
>> >  
>> > -	if (!list_empty(&pc.slabs)) {
>> > +	if (!locked && !list_empty(&pc.slabs)) {
>> >  		spin_lock_irqsave(&n->list_lock, flags);
>> > +		locked = true;
>> > +	}
>>  
>> -- 
>> Cheers,
>> Harry / Hyeonggon
>>  
> 


