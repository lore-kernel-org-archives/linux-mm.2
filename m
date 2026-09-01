Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB41BC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18B06B008A; Tue,  1 Sep 2026 04:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9446B00A1; Tue,  1 Sep 2026 04:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE12E6B00A5; Tue,  1 Sep 2026 04:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FD896B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:14:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0193FA0383
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:14:10 +0000 (UTC)
X-FDA: 85164480702.02.4EFAB33
Received: from mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3AAA18000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:14:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z4nRn4e3;
	spf=pass (imf06.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788250449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYPzEf3zjyaKVKOnNrhOtNlD5nTR4dNzBBL5BCBVfpg=;
	b=gChy8IPfgZt6m1j5fxDK7tDMxAFNyEGMM6IrzViZ4w8LSBEY+kvIZN3TyWw/tlLH2nTHwa
	Iqt6Q+RgRsjW4DiBxSW6CavOU8cG35iorzAgHB5q4uVJ+DYL18nj2j6QV0Tk8DZdLmft6X
	y8XLGoY2D2Ua16tBlvdi4adKh8gxMCk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788250449;
	b=P+QD/KKwAI40KQk+LozO12KYRTxUxhPKSeAV16RTM+1TLwQTmzSHQeum4xgNn6x4HM/00y
	agZ4jxGX7d86iHtd89zNd8Iw1Iw0spSWrA/LUiCyfIBzSfVI5r/KibSVjofLfnY3qzxxoU
	vwpyL5kYgQYLy56doeCBfHH4Q2vWO6U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z4nRn4e3;
	spf=pass (imf06.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bV4kcBvH/DWH/5vJ1R7+0iB1kjHHNS7RhB31HwS5w6E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788250447; v=1; x=1788855247;
 b=Z4nRn4e3So7F5EGRLac5Ypi0WLnBdMDgBE/1FXKDk6TwxkfJDalOb7ZBwDMElSwlFZedtIn6
 DDiqnvmXtam/mutNQrfoSRkY0eRVmC7Pcy3SotRRS6bcwKDHQoF1oIKPIWzXSbHsRMm266m6POy
 gwtwaZwLfCWVuXN3dmf457d4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 569a57e56a310cb2;
	Tue, 01 Sep 2026 08:13:57 +0000
X-Mizu-Trace-ID: 569a57e56a310cb2
X-Migadu-Flow: FLOW_OUT
Date: Tue, 1 Sep 2026 16:13:47 +0800
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hyunwoo Kim <imv4bel@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: take n->list_lock for the list_add() in
 __refill_objects_node()
Message-ID: <apaIWBnTJkM52hMy@fedora>
References: <apPa-cGLcyt90l-E@v4bel>
 <apQU8wjMlvbKBQgh@dev>
 <apQ7osHcRj3vdJPn@fedora>
 <ae25c193-b95f-40c1-83b6-1c2546467e41@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae25c193-b95f-40c1-83b6-1c2546467e41@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E3AAA18000A
X-Stat-Signature: jnk41bftojnhrc9fua7ob54pj3f9ocgf
X-HE-Tag: 1788250448-299899
X-HE-Meta: U2FsdGVkX1+zB7eROccP1ty+/h4JFqkbhutK07VX7ukxqpabBOqYgh+tEmzCW25663JlhbTwx8JwKrURkhbnB3M7znW3Jyao5ioOKBvnlQhZauPGprogM7xHwZcaSObCB7fdULUsNaWHn2x92aTJCMKRe7EGbS+sP7mijLCftRljzJbOTkkFosnrLDAyNXD5Emt6G3B3ZOCm3njyD3LUieY3dsOMj4KVupPxcF/SkCVCpao4ImPLGDIns2+7NR405gdrxp0IbDJTbd8N1kxqNXQMN4752Oc/pDsLFwMdCWvn+hegnpZBV9k3ic8AL9dDdqq6+TXl4moIfSZz6q9Y9PWTenNJd8HvBDgqRdw3d1xbdMCye2qvLaVvj3rAT10mACufG97/21NaeE8JRbSDuyU+0DIc16QCibivpSHH+nNEPp8JhlloE3J/4UYb3LOWOdyaQY2iG6QcKw0oBufKPlkdNVcdonPGpM7+vhgN7dlELwHH5L0yHOoelQC99p7bp4TZxrSlHxG/zqR84dF7F0VJL1M3hzeX23xzTrof7T7gttGqswO13gPLzNTmLvUNiPdpBOUiF60xIDzqYiscZ1HpRoRKXEJfGHhgDEVu22mjowG4Mm+dAAS/dmsN/MCU/SlzcTS9IGLN9AevtjW6zIVLED2EaC/BZXg0G9/LgTin+Dvm7cRj69cz4PwRSdz+QiTaomQVDNixqz8EN6p9EM6WZ9WA4dmwcRImKNN7X21T2dDalzKY/HJiZS5h4ju0Zd6RDGMsAZhg2PuWCrfTBKz8ksiqekZuuhE5lyHE2dXvKPfFOiRMQAUWnC+JwPUCoBXnUQtsz2jaligYBEdXuowZKsshpzNHKLuMiuGHjX60ADu9IJ3EIQr/IhiFvA8evDXsLaX1k3RsIJmITTvJiDpXUDyu/U0j2pQNQzY/OKWM/r9oY43IloykwYMPwh3FRjSKWs5bHeH04/nMS4C
 Z6oI9lWN
 Z3o74YCGog036SCDiZWx4g/KeO++mhpGjTO0ZkvAZLElLTzFk+Yxz6ZmgA0T0BFq9kGxxVtuA3yf80VZ1oBG5x0I2yaAyGs80dBLoidlSveAbH9y3Cke6BRtUR5kkmw9xWKPtMBsaXif4UfP5H+jPglQ+yqwKDU5XsLRViuxeMlTfoLkECUVEW71eaGSk4dF6jivRNMBXlCG1IJ/EfCEfOr00w3EphlGQH28zI1b/kPjxLFo8f5e2Gw7PGozJZHTNC1noVcKo+UDj9DP52gi4GWJfRh91aItu7G1mNdefysPcEoNRNRQAQMNVwygwia3AMAHB86JiF8YAjrbM1Io5nEEZQnnkBQj7Eyuz0ESps1CDQpo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 02:55:06PM +0200, Vlastimil Babka (SUSE) wrote:
> On 8/30/26 16:35, Hao Li wrote:
> > On Sun, Aug 30, 2026 at 12:45:17PM +0000, Harry Yoo wrote:
> >> On Sun, Aug 30, 2026 at 04:25:45PM +0900, Hyunwoo Kim wrote:
> >> > In __refill_objects_node(), the list_add(&slab->slab_list, &pc.slabs) that
> >> > follows a successful __slab_try_return_freelist() is done without
> >> > n->list_lock.
> >> >
> >> > __slab_try_return_freelist() only succeeds while slab->freelist is NULL. The
> >> > slab we are refilling from is taken off pc.slabs by the list_del() at the
> >> > top of the loop, so at that point it is on no list.
> >> > 
> >> > If another CPU frees an object of that slab, __slab_free() sees the slab as
> >> > full and puts it back on n->partial. If a third CPU then takes that object
> >> > in get_from_partial_node(), the freelist becomes NULL again.
> >> 
> >> Ouch. Good catch, Hyunwoo.
> >> A classic ABA problem :)
> 
> Ouch, indeed.
> 
> >> > A slab that sits on n->partial with a NULL freelist only exists while
> >> > get_from_partial_node() holds n->list_lock, between its cmpxchg and its
> >> > remove_partial().
> >> > 
> >> > A list_add() in that window overwrites slab_list to point into pc.slabs.
> >> > The list_del() in remove_partial() then follows the overwritten links, so it
> >> > unlinks the slab from pc.slabs and poisons slab_list while leaving the
> >> > n->partial side alone. n->partial is left pointing at the poisoned slab.
> >> > 
> >> >            CPU0                        CPU1                  CPU2
> >> > 
> >> >   __refill_objects_node()
> >> >     get_partial_node_bulk()   // n->partial to pc.slabs
> >> >     list_del()                // on no list now
> >> >     get_freelist_nofreeze()   // freelist = NULL
> >> >                               __slab_free()
> >> >                                 add_partial()
> >> >                                 // back on n->partial
> >> > 	                        // freelist is not NULL
> >> > 
> >> >                                                     get_from_partial_node()
> >> >                                                       lock
> >> >                                                       cmpxchg
> >> >                                                       // freelist = NULL
> >> >     __slab_try_return_freelist()
> >> >     list_add(&pc.slabs)       // overwrites slab_list
> >> >                                                       remove_partial()
> >> >                                                         list_del()
> >> >                                                         // off pc.slabs
> >> >                                                         // slab_list = POISON
> >> > 
> >> > panic log:
> >> > 
> >> >   list_add corruption. next->prev should be prev
> >> >   (ffff888100000248), but was dead000000000122.
> >> >   (next=ffffea000416e410).
> >> >   kernel BUG at lib/list_debug.c:29!
> >> >   Oops: invalid opcode: 0000 [#1] SMP NOPTI
> >> >   CPU: 1 UID: 65534 PID: 144 Comm: poc Not tainted
> >> >   7.2.0-16172-gcf72cbb39da8-dirty #1 PREEMPT(lazy)
> >> >   RIP: 0010:__list_add_valid_or_report+0x80/0xd0
> >> >   ...
> >> >   Call Trace:
> >> >    alloc_from_new_slab+0x183/0x300
> >> >    ___slab_alloc+0x31c/0x890
> >> >    __kmalloc_noprof+0x3d4/0x800
> >> >    lsm_blob_alloc+0x2d/0x50
> >> >    security_msg_msg_alloc+0x26/0x90
> >> >    load_msg+0x1aa/0x210
> >> >    do_msgsnd+0x91/0x800
> >> >    do_syscall_64+0x109/0x5d0
> >> >    entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >> >   ...
> >> >   Kernel panic - not syncing: Fatal exception
> >> > 
> >> > Do the list_add() under n->list_lock. Reattaching the freelist stays outside
> >> > the lock. Once it succeeds the freelist is no longer NULL, so __slab_free()
> >> > cannot put the slab back, and by the time the lock is taken remove_partial()
> >> > has finished and the slab is on no list.
> >> 
> >> Yeah, this should work correctly. 
> >> 
> >> > The lock is held until the block below that returns the remaining slabs to
> >> > the partial list. That block already took the same lock on this path, so no
> >> > lock/unlock pair is added.
> >> > 
> >> > The unlock is keyed on having taken the lock instead of on pc.slabs being
> >> > empty. With CONFIG_DEBUG_LIST or CONFIG_LIST_HARDENED, __list_add() returns
> >> > without linking anything if its check fails, which would leave pc.slabs
> >> > empty.
> >> 
> >> Well, if the check fails, it has a bug and should be fixed.
> >> We should not make the code less readable to handle a bug.
> >> 
> >> I think it's better to have (diff on top of the patch, not tested):
> >> 
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 7a7f9935c711..eff96b992164 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -7216,12 +7216,10 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
> >>  			break;
> >>  	}
> >>  
> >> -	if (!locked && !list_empty(&pc.slabs)) {
> >> -		spin_lock_irqsave(&n->list_lock, flags);
> >> -		locked = true;
> >> -	}
> >> +	if (!list_empty(&pc.slabs)) {
> >> +		if (!locked)
> >> +			spin_lock_irqsave(&n->list_lock, flags);
> >>  
> >> -	if (locked) {
> >>  		list_for_each_entry(slab, &pc.slabs, slab_list)
> >>  			set_node_partial_state(n, slab);
> > 
> > Since introducing a new variable seems unavoidable, what if we temporarily
> > stash this slab in a pointer like below, and then add it to pc.slabs once we
> > acquire the lock.
> > 
> > struct slab *leftover_slab = NULL;
> > 
> > ...
> > ...
> > 	if (__slab_try_return_freelist(s, slab, head, count)) {
> > 		leftover_slab = slab;
> > 		break;
> > 	}
> > 
> > ...
> > ...
> > if (!list_empty(&pc.slabs)) {
> > 	spin_lock_irqsave(&n->list_lock, flags);
> > 
> > 	if (leftover_slab)
> > 		list_add(&leftover_slab->slab_list, &pc.slabs);
> > 	...
> > 	...
> > }
> > 
> > PS: If I recall correctly, Vlastimil's initial patch was actually fine. It was
> > my suggestion to save an extra lock/unlock pair that accidentally led to this
> > trap...
> 
> Ah, thanks for the reminder. This [1] was the original attempt.
> 
> [1]
> https://lore.kernel.org/all/20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org/
> 
> I wonder if the fix should be to return to that approach and just have
> __slab_try_return_freelist() handle the list_lock. The code would be simpler
> with not "bool locked".
> 
> It should be really very rare that we would end up returning a partial list
> and also have additional slabs to return on pc.slabs? So I think there would
> be no noticeable performance downside to the simpler code potentially ending
> up taking the list_lock twice instead of once.

Yes, make sense, in fact, when I first looked at this patch, I did consider
that maybe the original locking approach was best for readability and safety :)

> 
> >> 
> >> > Fixes: ba7425312607 ("mm, slab: add an optimistic __slab_try_return_freelist()")
> >> > Cc: stable@vger.kernel.org
> >> > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> >> > ---
> >> >  mm/slub.c | 9 ++++++++-
> >> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >> > 
> >> > diff --git a/mm/slub.c b/mm/slub.c
> >> > index f9b56cb439e709..4f6d1a03a8ee46 100644
> >> > --- a/mm/slub.c
> >> > +++ b/mm/slub.c
> >> > @@ -7260,6 +7260,7 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
> >> >  	struct slab *slab, *slab2;
> >> >  	unsigned int refilled = 0;
> >> >  	unsigned long flags;
> >> > +	bool locked = false;
> >> >  	void *object;
> >> >  
> >> >  	pc.flags = gfp;
> >> 
> >> uh, I'm not a big fan of having a new variable to store 'locked' state,
> >> but okay, this seems unavoidable with current implementation.
> >> 
> >> > @@ -7297,7 +7298,10 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
> >> >  			void *tail;
> >> >  
> >> >  			if (__slab_try_return_freelist(s, slab, head, count)) {
> >> > +				/* get_from_partial_node() may be mid-removal of the slab */
> >> > +				spin_lock_irqsave(&n->list_lock, flags);
> >> >  				list_add(&slab->slab_list, &pc.slabs);
> >> > +				locked = true;
> >> >  				break;
> >> >  			}
> >> >  
> >> > @@ -7312,9 +7316,12 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
> >> >  			break;
> >> >  	}
> >> >  
> >> > -	if (!list_empty(&pc.slabs)) {
> >> > +	if (!locked && !list_empty(&pc.slabs)) {
> >> >  		spin_lock_irqsave(&n->list_lock, flags);
> >> > +		locked = true;
> >> > +	}
> >>  
> >> -- 
> >> Cheers,
> >> Harry / Hyeonggon
> >>  
> > 
> 

