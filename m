Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 836E8CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBA966B0427; Mon,  1 Jun 2026 11:38:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6B616B0429; Mon,  1 Jun 2026 11:38:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9176B042A; Mon,  1 Jun 2026 11:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8C486B0427
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:38:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7214012023D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:38:43 +0000 (UTC)
X-FDA: 84831751326.19.49ADBA1
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7E1D12000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:38:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KHtpwLhT;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780328321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2z6l1eP+ZdCcfkpO0TKMaBFbF5X2F+vxzdUXR8PskAc=;
	b=iSorzsIO2WH2vMNxxJ3xi757kqJP8rGz5N2K+UWapp7YYdPEcGTQJJQYqzXLmwdVqUGeVg
	m21Ac5/WvGEDnQ324AkdV1E5yKaXnHcz31iw0Xa0pwL54pKiOBfIfCVF0pkiuK41AYDz+k
	SRucqvn+Y1oT4NPJ017tHbMt9h252JM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780328321;
	b=cz7NHWPIQQccaQHBolxny2xRlIgVNf8oLTBXRbmD61mD6aT37k+hQ6JwcLlhvVWeEDakB7
	GC//4lxtSkig/i3Hmwldi5NCzAj/NBfHlFglgnEMAzXW8fTHN6zkl2+XUWlCoHlFzFw2HI
	6MDNFWugAdnG1f9i0+tCzNt7Dea8M40=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KHtpwLhT;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 1 Jun 2026 08:38:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780328317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2z6l1eP+ZdCcfkpO0TKMaBFbF5X2F+vxzdUXR8PskAc=;
	b=KHtpwLhTvVrqtHqDyiaV9jYA6yFgTEe8LfzAu3vB+kBo3qWS47wIzxAITvaeLCYDxh18aZ
	vUX4AMePlF0+sHW5KZYD41NSW3FAnYcGJkL/OOj2zn3tW5vHVa9vH+TRqUFzpj+ZnE7KSz
	4WrRn2cKiwrT3Ajkn8/cUzIFn5QU/xE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: [PATCH] mm/list_lru: drain before clearing xarray entry on
 reparent
Message-ID: <ah2VXGfGZOOdjhs3@linux.dev>
References: <20260601063408.2879011-1-shakeel.butt@linux.dev>
 <79CD986A-2130-4FB8-804F-A543AF22342B@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79CD986A-2130-4FB8-804F-A543AF22342B@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7E1D12000C
X-Rspam-User: 
X-Stat-Signature: buqqxn3wxe1sa1u3ph65ho43wc1e9ttt
X-Rspamd-Server: rspam08
X-HE-Tag: 1780328321-208816
X-HE-Meta: U2FsdGVkX1/17AKtspeeWdLYyBN3gFybED+g4MntBQp9lA5XUFxkZtx7owQw3CdMuvtf/8FUkIinD84d/Ez5NyvQxSx+nyZh8NyvrWImTkn5NE7HFwUqW48k8QvCVXVMp+4a5HFJNNU9C2z7IoDRdTkg7paT2ZrkTcwnbl7URlEw23dX+ilnXReS9FY59eu2zoHqoodu8zFC1Rlmc/9l83IP/IpiewetWfa1KbsL5dXRsU0+yDZI37JZzPF3PVdvz0waJ/YIrDKWEtg3uXbasjPT6yaE/QEgaiUdhkIhozv+nmEaz6M7fJ88BWvRBG6LvjdmPP+v1h3Q/kyUmC5wtAwkQOGRFdMd6Y1aQMPUrAcUn5xa9WYjc7UtMMWJe2Ws0ScNLjkpLLaQTa6vNNw4Dv1PxndrF+VrGfRyJnhjqUYns0macNxxskdggTxEuixlsYzZqrnhBTNOn3nBj+VmVKVXWheChOOouvxDfvZ1DkcZw5JC6h8NZhAjmbsjnueFj9yRMAtetKti/lxfcwnJ9ejb8ZvhPHEbuvBF1E4WrwkT+Vj7j/ehtgESJubhonwHORJejqATcDc9Wjijs2NNUmbcQrIIJRsH9DYyJBIUGRD6388l35CSSttoST2yC6Khu0h50rLhROkZF94qQ9zJAikImWfCggsNaB2hXCv4liiLfj8Fs87olPXtillMJBKeqSF0Na1oktm8mcQ8tR49LOLdapxhM9ZsrgA1g3WfaypLo4GdzRdnE/Wsr3hgb4UP6tvbIL8FlNny4IHvPtYZ89jdb54i2VU6e3iQiDE9Xdh929DdeYIQYt2xShycBZM+prOjWnDvaT2HAxqsiQlks4XDmWOZ8A9Nraa/MRf+kKYlNV1fpm0uhNIhcHpTyk+bLDxIFRzunesQHr5LQMxDr1cK9CbS805rTfvIA90HI7CV4HBxaN1DrQQrIWe2NX2A/RkZhEVfgt83Ragezh5
 12JSHkBJ
 eg5B/TNh0rvX7K2reyxCId8bPPgCIkr/Z7BYKaGfGYqS+td/z30TcsIVs7+yaBEfqZhMWSE8T82e9bVl0xJ2rZJhG0GsIVq/QNvnNy4NKx8ypK0S2vLJaOaVJG2f0/zRkWJ2rdXB0VsA4ToTPUSusx5HO7fbZdZD7HEqgCbZb7VC01e9ygNCId2KIiVQCXQcbYrOd9Ume2h2zJP+UOUCOUNE9fBge5p5B5CLskAGWxrBGOTVXXGACZdB1iS2h3Z8kSEzTbZKVcPLNLxz0vSFkxusMr0X2plCoNwWV8p9qdY0lh9/s4TBQI/0pCzBVuC3W8+zAmq7eFScIO5/IIsCZNLAEmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Muchun, thanks for taking a look.

On Mon, Jun 01, 2026 at 05:54:01PM +0800, Muchun Song wrote:
> 
> 
> > On Jun 1, 2026, at 14:34, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > 
> > memcg_reparent_list_lrus() clears the dying memcg's xarray entry with
> > xas_store(&xas, NULL) before reparenting its per-node lists into the
> > parent. This opens a window where a concurrent list_lru_del() arriving
> > for the dying memcg sees xa_load() == NULL, walks to the parent in
> > lock_list_lru_of_memcg(), takes the parent's per-node lock, and calls
> > list_del_init() on an item still physically linked on the dying
> > memcg's list.
> > 
> > If another in-flight thread holds the dying memcg's per-node lock at
> > the same moment (another list_lru_del, or a list_lru_walk_one running
> > an isolate callback), both threads modify ->next/->prev pointers on the
> > same physical list under different locks. Adjacent items can corrupt
> > each other's links.
> > 
> > Fix it by reversing the order: reparent each per-node list and mark the
> > child's list lru dead and then clear the xarray entry. Any concurrent
> > list_lru op that finds the still-set xarray entry either takes the dying
> > memcg's per-node lock (synchronizing with the drain) or sees LONG_MIN
> > and walks to the parent, where the items now live.
> > 
> > Fixes: fb56fdf8b9a2 ("mm/list_lru: split the lock to per-cgroup scope")
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Reported-by: Chris Mason <clm@fb.com>
> > ---
> > mm/list_lru.c | 20 +++++++++-----------
> > 1 file changed, 9 insertions(+), 11 deletions(-)
> > 
> > diff --git a/mm/list_lru.c b/mm/list_lru.c
> > index dd29bcf8eb5f..ae55a52307db 100644
> > --- a/mm/list_lru.c
> > +++ b/mm/list_lru.c
> > @@ -473,26 +473,24 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
> > 	mutex_lock(&list_lrus_mutex);
> > 	list_for_each_entry(lru, &memcg_list_lrus, list) {
> > 		struct list_lru_memcg *mlru;
> > - 		XA_STATE(xas, &lru->xa, memcg->kmemcg_id);
> > 
> > - 		/*
> > -		 * Lock the Xarray to ensure no on going list_lru_memcg
> > -		 * allocation and further allocation will see css_is_dying().
> > -		 */
> > - 		xas_lock_irq(&xas);
> > - 		mlru = xas_store(&xas, NULL);
> > - 		xas_unlock_irq(&xas);
> > + 		mlru = xa_load(&lru->xa, memcg->kmemcg_id);
> > 		if (!mlru)
> > 			continue;
> 
> Is it possible that concurrent threads running memcg_list_lru_alloc() could
> allocate a new mlru after this check passes? This could happen because the
> threads haven't noticed css_is_dying() yet. We would consequently miss the
> reparent operation for this list. So xas_lock_irq is necessary to serialize
> CSS_DYING setting here. Right?

Good question and it seems like Sashiko [1] raised a similar concern. However
please note that memcg_list_lru_alloc() uses CSS_DYING when it allocate a new
mlru but memcg_reparent_list_lrus() is called from offlice_css() callback and
the given css should already have CSS_DYING before calling offline_css(). There
is a rcu grace period between setting CSS_DYING and calling offline_css().

[1] https://sashiko.dev/#/patchset/20260601063408.2879011-1-shakeel.butt%40linux.dev

> 
> Thanks.
> Muchun
> 
> > 
> > 		/*
> > -		 * With Xarray value set to NULL, holding the lru lock below
> > -		 * prevents list_lru_{add,del,isolate} from touching the lru,
> > -		 * safe to reparent.
> > +		 * Reparent each per-node list and mark the child dead
> > +		 * (LONG_MIN) before clearing xarray entry otherwisw a
> > +		 * concurrent list_lru_del() may corrupt the list if it arrives
> > +		 * after xarray clear but before reparenting as
> > +		 * lock_list_lru_of_memcg will acquire parent's lock while the
> > +		 * item is still on child's list.
> > 		 */
> > 		for_each_node(i)
> > 			memcg_reparent_list_lru_one(lru, i, &mlru->node[i], parent);
> > 
> > + 		xa_erase(&lru->xa, memcg->kmemcg_id);

This one is more tricky. Sashiko said:

" Is it safe to use xa_erase() here instead of xa_erase_irq()?

The list_lru xarray is initialized with XA_FLAGS_LOCK_IRQ, and elements are
added holding the lock via xas_lock_irqsave(), which establishes an IRQ-safe
lock class.

Since xa_erase() internally calls spin_lock() without disabling local
interrupts, an interrupt firing while the lock is held could attempt to
re-acquire the same lock in __memcg_list_lru_alloc(), leading to a deadlock.

This could also trigger a lockdep warning for an inconsistent lock state. "

Initially I though this is a false positive as I couldn't find irq callers for
kmem_cache_alloc_lru() but then claude came up with more concrete scenario which
is below:

"""
For the shadow_nodes lru this lock is also acquired nested under the page
cache i_pages lock, which is irq-safe.  Adding a folio holds i_pages and
then allocates an xarray node through the shadow_nodes lru:

__filemap_add_folio()
  mapping_set_update(&xas, mapping)     // xas->xa_lru = &shadow_nodes
  xas_lock_irq(&xas)                    // holds mapping->i_pages
  xas_store() -> xas_alloc()
    kmem_cache_alloc_lru(radix_tree_node_cachep, xas->xa_lru, gfp)
      memcg_list_lru_alloc(memcg, &shadow_nodes, gfp)
        xas_lock_irqsave(&shadow_nodes->xa)   // shadow_nodes->xa under i_pages

and i_pages is taken from writeback completion in irq context:

__folio_end_writeback()
        xa_lock_irqsave(&mapping->i_pages, flags);

So with xa_erase() taking shadow_nodes->xa with irqs enabled:

CPU0 memcg_reparent_list_lrus()    CPU1 __filemap_add_folio()
  xa_erase(&shadow_nodes->xa)
    xa_lock(&shadow_nodes->xa)
                                   xas_lock_irq(&i_pages)  // holds i_pages
                                   ... memcg_list_lru_alloc()
                                     xas_lock_irqsave(&shadow_nodes->xa) // waits
  <io completion irq on CPU0>
  __folio_end_writeback()
    xa_lock_irqsave(&i_pages)  // waits

Can this deadlock, and should this be xa_erase_irq() to keep the irq-safe
acquisition that the removed xas_lock_irq() had?
"""

This seems more plausible and I think simply using xa_erase_irq() is more safe.

I will send a v2 with this change.

