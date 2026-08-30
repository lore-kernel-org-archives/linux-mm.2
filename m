Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E625C61DE1
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 14:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 420546B0088; Sun, 30 Aug 2026 10:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB836B008A; Sun, 30 Aug 2026 10:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D096B008C; Sun, 30 Aug 2026 10:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2A3A6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:35:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CB8B1C1B34
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:35:22 +0000 (UTC)
X-FDA: 85158183684.28.ECA758F
Received: from mta1.migadu.com (out-200.mta1.migadu.com [95.215.58.200])
	by imf09.hostedemail.com (Postfix) with ESMTP id DC691140003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:35:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YEf6glFJ;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788100520;
	b=wpE0p8rBs02uA6UwMCY/vNPn3tB5AgIqQSeYF+yA8ZrIGgImjQ63qGOrES2Q3OhGkZ0eHZ
	0vTtF86oTcKsVOJKip9FmLIvbCCNUM/fr6VcZrQOeRCrzH+A19ZWQkdLztMqe71ymXOK1o
	To8wK07a5k/9jhjEuInzr4V9dbkG93s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YEf6glFJ;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788100520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNjwEDgT+2o1Aly9z6IP657xu7wGYOJRxTJKdrcl9x0=;
	b=L9yiK2UrvLNfVE+FJrbYSFOApr4iwYSuwcRWSzFCegUGYb/2+5vt3Xa+ZZ29OL/RCrOKN9
	Zg/JFmDbQwPALcWCsiNsmQZ0jbHGfiQ5HY1lpQjSgZvjVcbKdDIHrWl1U9HyXZWo9JPPA8
	9jWwEMaVc5RPYojSbaC64ZtZMBlKmDE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+N14Rp4OCXct2uVsVwDD8EQMxAy6jpii7x/pKnom5qk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788100518; v=1; x=1788705318;
 b=YEf6glFJxRskQA11glTzC4mptlVeLQnhLl1+DO9+9JgwJIXfV3wG1T5k0VCeJmop/dppTduk
 RAXOtvHvuAee4q6rRKz+Nj+nXwR5AiXgsmENRemXOlwDNZ1QFUQ9GyOxWhuNnxU6FKndT0zqp+6
 6wX4ZQQW+HAJmiKdhw1yOW7E=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6a81fa71451a6454;
	Sun, 30 Aug 2026 14:35:13 +0000
X-Mizu-Trace-ID: 6a81fa71451a6454
X-Migadu-Flow: FLOW_OUT
Date: Sun, 30 Aug 2026 22:35:01 +0800
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: take n->list_lock for the list_add() in
 __refill_objects_node()
Message-ID: <apQ7osHcRj3vdJPn@fedora>
References: <apPa-cGLcyt90l-E@v4bel>
 <apQU8wjMlvbKBQgh@dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apQU8wjMlvbKBQgh@dev>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DC691140003
X-Stat-Signature: q3e1dgzhj3w9ppe4scoi88bngzm6h1sh
X-HE-Tag: 1788100519-166822
X-HE-Meta: U2FsdGVkX18HlVdD4BWHoq5JEAlaW1K6BjySh1DJoYmw91OFV8CwjmG0N+0J9oCD2gk0p91Xy1G+2leUFIiIB1v7eySwZ3bHWbPwPUEj5sYtYApCqD7j37waH5gqFAXvCg2Uz1aMGaGvUh0RvjakuZn+XWRS+zx9qcuL1qTnEUTQ/UFmnEF9pSsLBuEtXub7of51+nRMEv0eZQPRx8pTLVGSUZGOQ8GMsgcL3FrCdgZRQ3HDZEc40qYi8cKC1GB0UAM0bbm9Eb6p5qPQCqlTZZuq8PIOi0cdfHjQm4O5Mxbv3gfbQHBj/yLin8cabGcGuPpIXNGTk3ibmuLjUrt1redyUsf9JgrKGMn+S8gl1Hnn5FxhRlSqxhUp0Jmj8anOqKwGEguwaKARdLufB8KGMHipxNQ7V7UtCC9uEtWMQHWzqPGfeLBD67+pnmZXDY4OCfcRaX31n629nmjkfqQ8J6ZFfXQvRYVfsfkOautTY6usLY/0sJY/fe0sb+S6RGBJyNKtM20Hfri8eGi7qfGoXqw9QX9WVPre/ktYMbw2Ca9rKrwaKZeU3it0ZITK0fa+cS2FCyTKCk1G9mKdSR3mZvTz5CdL1nFSGRbO3UOMVNGx5/gfTsqYyXcwXKXwrCmMtDiL+ct0OBRRNvnjc/AaWaHR0rBS87fJho2UrEjBytkj0LPXZANCjRgbyQOZYG4VglmkJvv0KWlyIR8d2eYWmHtKmp0+hnJ+IrGxJIwbEnToUIfIUR9rd1YzcipI7IjxHSOxlgiS1VFyZyaZsflCdLuJZi7GXBnkv4R1st0dtwev7zCilJMOrGjrsjbqxS20wBPQMaHAQc/PJrpHKUHdixCSDYNcZyKLfPIIV/tTGrmC+qKckMY+ELByM4tZlXpgYon7WCrNDn+Teh5pO9IRxu4rZtq4oibibsONZNwpXkt2hiIKaWSmppS6I27dT6R2UkylII17JtuFiV7G9jv
 2yrZMqV9
 oB25slUXIB/l+lm7hmHPeNEPc3gd47fxXQclzB8+rNOmven+I3Ku+nIPDZYeuKAXMqwehbmoryQVOkfB+i4M2PMARlZsPDQaP8/J0bwnRbXJOkjSwIJzhDpDoZ6LodIJHjnZM2VlDwYhWFQYugTIyo6fk5JImqFGLrd7uUqQZfcNbMygnVsHm2Mo0Lm9JhcL9hpdlAt+BHGIQwZ6DA58leei8CfeI+WfDtbIsKd8nYNwXGxJ+vcyqv3UPtSrwVhud/MPTIqQJmEFg3I6bYGs+bVtk8WZRMjBih7Piy1QVrz5wnA9Z+wb2iNGRtwkeKsJ1SmBIAoYMdniiVTBUFB6srsWyiUXTe+aEXKcWwARPJnsyTps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 12:45:17PM +0000, Harry Yoo wrote:
> On Sun, Aug 30, 2026 at 04:25:45PM +0900, Hyunwoo Kim wrote:
> > In __refill_objects_node(), the list_add(&slab->slab_list, &pc.slabs) that
> > follows a successful __slab_try_return_freelist() is done without
> > n->list_lock.
> >
> > __slab_try_return_freelist() only succeeds while slab->freelist is NULL. The
> > slab we are refilling from is taken off pc.slabs by the list_del() at the
> > top of the loop, so at that point it is on no list.
> > 
> > If another CPU frees an object of that slab, __slab_free() sees the slab as
> > full and puts it back on n->partial. If a third CPU then takes that object
> > in get_from_partial_node(), the freelist becomes NULL again.
> 
> Ouch. Good catch, Hyunwoo.
> A classic ABA problem :)
> 
> > A slab that sits on n->partial with a NULL freelist only exists while
> > get_from_partial_node() holds n->list_lock, between its cmpxchg and its
> > remove_partial().
> > 
> > A list_add() in that window overwrites slab_list to point into pc.slabs.
> > The list_del() in remove_partial() then follows the overwritten links, so it
> > unlinks the slab from pc.slabs and poisons slab_list while leaving the
> > n->partial side alone. n->partial is left pointing at the poisoned slab.
> > 
> >            CPU0                        CPU1                  CPU2
> > 
> >   __refill_objects_node()
> >     get_partial_node_bulk()   // n->partial to pc.slabs
> >     list_del()                // on no list now
> >     get_freelist_nofreeze()   // freelist = NULL
> >                               __slab_free()
> >                                 add_partial()
> >                                 // back on n->partial
> > 	                        // freelist is not NULL
> > 
> >                                                     get_from_partial_node()
> >                                                       lock
> >                                                       cmpxchg
> >                                                       // freelist = NULL
> >     __slab_try_return_freelist()
> >     list_add(&pc.slabs)       // overwrites slab_list
> >                                                       remove_partial()
> >                                                         list_del()
> >                                                         // off pc.slabs
> >                                                         // slab_list = POISON
> > 
> > panic log:
> > 
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
> > Do the list_add() under n->list_lock. Reattaching the freelist stays outside
> > the lock. Once it succeeds the freelist is no longer NULL, so __slab_free()
> > cannot put the slab back, and by the time the lock is taken remove_partial()
> > has finished and the slab is on no list.
> 
> Yeah, this should work correctly. 
> 
> > The lock is held until the block below that returns the remaining slabs to
> > the partial list. That block already took the same lock on this path, so no
> > lock/unlock pair is added.
> > 
> > The unlock is keyed on having taken the lock instead of on pc.slabs being
> > empty. With CONFIG_DEBUG_LIST or CONFIG_LIST_HARDENED, __list_add() returns
> > without linking anything if its check fails, which would leave pc.slabs
> > empty.
> 
> Well, if the check fails, it has a bug and should be fixed.
> We should not make the code less readable to handle a bug.
> 
> I think it's better to have (diff on top of the patch, not tested):
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 7a7f9935c711..eff96b992164 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7216,12 +7216,10 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>  			break;
>  	}
>  
> -	if (!locked && !list_empty(&pc.slabs)) {
> -		spin_lock_irqsave(&n->list_lock, flags);
> -		locked = true;
> -	}
> +	if (!list_empty(&pc.slabs)) {
> +		if (!locked)
> +			spin_lock_irqsave(&n->list_lock, flags);
>  
> -	if (locked) {
>  		list_for_each_entry(slab, &pc.slabs, slab_list)
>  			set_node_partial_state(n, slab);

Since introducing a new variable seems unavoidable, what if we temporarily
stash this slab in a pointer like below, and then add it to pc.slabs once we
acquire the lock.

struct slab *leftover_slab = NULL;

...
...
	if (__slab_try_return_freelist(s, slab, head, count)) {
		leftover_slab = slab;
		break;
	}

...
...
if (!list_empty(&pc.slabs)) {
	spin_lock_irqsave(&n->list_lock, flags);

	if (leftover_slab)
		list_add(&leftover_slab->slab_list, &pc.slabs);
	...
	...
}

PS: If I recall correctly, Vlastimil's initial patch was actually fine. It was
my suggestion to save an extra lock/unlock pair that accidentally led to this
trap...

> 
> > Fixes: ba7425312607 ("mm, slab: add an optimistic __slab_try_return_freelist()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> > ---
> >  mm/slub.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index f9b56cb439e709..4f6d1a03a8ee46 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -7260,6 +7260,7 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
> >  	struct slab *slab, *slab2;
> >  	unsigned int refilled = 0;
> >  	unsigned long flags;
> > +	bool locked = false;
> >  	void *object;
> >  
> >  	pc.flags = gfp;
> 
> uh, I'm not a big fan of having a new variable to store 'locked' state,
> but okay, this seems unavoidable with current implementation.
> 
> > @@ -7297,7 +7298,10 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
> >  			void *tail;
> >  
> >  			if (__slab_try_return_freelist(s, slab, head, count)) {
> > +				/* get_from_partial_node() may be mid-removal of the slab */
> > +				spin_lock_irqsave(&n->list_lock, flags);
> >  				list_add(&slab->slab_list, &pc.slabs);
> > +				locked = true;
> >  				break;
> >  			}
> >  
> > @@ -7312,9 +7316,12 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
> >  			break;
> >  	}
> >  
> > -	if (!list_empty(&pc.slabs)) {
> > +	if (!locked && !list_empty(&pc.slabs)) {
> >  		spin_lock_irqsave(&n->list_lock, flags);
> > +		locked = true;
> > +	}
>  
> -- 
> Cheers,
> Harry / Hyeonggon
>  

-- 
Thanks,
Hao

