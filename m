Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEB2BC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 04:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A54C76B00D3; Mon, 21 Sep 2026 00:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04FE6B00D9; Mon, 21 Sep 2026 00:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91B176B00DB; Mon, 21 Sep 2026 00:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F05B6B00D3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:21:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76E80140527
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:21:25 +0000 (UTC)
X-FDA: 85236470130.14.7632033
Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5651F100002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:21:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kynw/lNj";
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789964483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lj2BpIRqnVNDpbWDnMA5HARJLB+CiLv4FMf2YxNF54=;
	b=N0/5byLtTrtry6kJMwjr99pfqTmoqQxU6Kv2IwOefbNiHY4jHn5gAAiyEX43FLR1YooXN2
	2p5PGw9+UTTgj8Okws4JUbk2NBvgH6PjnM7grHH9pgUTsRE/lR78QeaHQdjvrFMqp2CaxJ
	IhhOI097wkyBRdjrAvxt5lx5t4F3wWU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kynw/lNj";
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789964483;
	b=xefbp6UWlJsjcIhXe9vvBSTOHukRz8b9Q+iPPSJo56o9AeSq7UWCfLaYMAYyxeWkiM1M8l
	7g6vXsyeJvo6+QEP42tN2bFHcH8Novy4FlIfid8AXLO0mejSlHOF2rv/qznmGnkcYNtVaW
	IzLvib1gb/NcWcstTfiCkkvC/hoRME4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QnBJ2lINDbYZLtvPWtK1dgRGpLQIhKeHYrcIi78w4I0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789964479; v=1; x=1790569279;
 b=kynw/lNjDWMnyo5YXkrz+F55As/OJhjVnORKp0jV0dMrWXAD5rE35JMiqpw9oK5qCIvBiUhV
 68B2gRtYwgEZygyCzCgoQsFEULeeLRYMphHDBKgeN1q9r9mEUkjdluHQ2JQ/euIo1NOWlryMggw
 eHWgqWzORMSPgC+3aqohtiuI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f6ec75b7ce5dac5b;
	Mon, 21 Sep 2026 04:21:19 +0000
X-Mizu-Trace-ID: f6ec75b7ce5dac5b
X-Migadu-Flow: FLOW_OUT
Date: Mon, 21 Sep 2026 12:21:14 +0800
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: refill prefilled sheaves from the barn
Message-ID: <arCeRr44nni8hykr@fedora>
References: <20260918114318.124346-1-hao.li@linux.dev>
 <aq0ylDidEHa2kg4X@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq0ylDidEHa2kg4X@thinkstation>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5651F100002
X-Stat-Signature: epmthyacfyfcyk7chfnjfhxch515aaim
X-Rspam-User: 
X-HE-Tag: 1789964481-530668
X-HE-Meta: U2FsdGVkX1/JPGnQej6oUUxkJDVrP7ZXCFb+E0w/ZyLZbyQKc2GsRN/gFwASnH6ctgaJic9zSCa4wj+lFVyK9T5iluSTuAgI+Pqj+3kOGMjB1qOGNqnUgIz/XUSEkq3736GA9gnNk+Nrn4AiABnFYsTgC4dxND8wAxjrB/l6JQz1bvRM6W8DqOllpH7q9uc5iWYx4NlAw+jhLwCKf4U0QiVeKEteoysCZJGxDoLFT9neg8CHbwDGVoLiaCZnv/YBmQhM75xrojtzms94b2qlH7m+92xz7ZQGIsMEEr3rBsqS3RXHfxuo1oD7EJEFWwrhWYrWF5TfShdu5JxAft5tiwwviGWu/bFwL08Rj793ysy9ZE95flgRjyE+lhE+/UcWpHKlGYQqFaK9jFr5kxjy0wsdijz+x1QaHGUYOU6M9M6zEpesgdPg9nI841xsL1OvlHB1XFLh3KPpv+fnLv3RQpi6eYknzW5nWwAF1Zuo5fJ0uzAI9TaqprNSaP26i0anYE94NGsNho6xH4xZMHcLLiFrcqpvoFxarY69g1e6rp7QFR0QG4LfCwo31iXTMdwPPAqixYkx7l3+qv/mIu7YP4vQ+z50TWKRCnH9MXsdhizK5BIHUw5pkBUzf4F30asAwWvW9D56Gk4XtpabXcvRM+MyLRLPnboynlv5YaYSbzAb+kUVAZnfqMrS+/RoM0Mcv69IuM+Nsur1PlpH9++9UR0B9OlHcmqsrfu7fyrX8tnk4PBQ04NTBuEafRT/Pe1k+13S+sR31wi5lpDsUnWg9tjfPv5SFgrid1EXgdspDBlG3GymstKCQefyjPRr2uOXS5OznmcxH9BTCsGUlagHKy+JIXEyifLTTeozdUa9eW3wc4pgHcaovqF3QItVq3JCzhXjUYPPBKmXGpZ0Whf8MyG/+72VMh3L4wChuHAHhWOIr5wdR7sItfuRhjWZXv9Bia4pVH0ZF26PzLirLEf
 tFuoUszQ
 iuaH4ySC0IS+xNL1ZDcT3C31qSgxBu9pzpTkWiBzevWbnWdxKCuk1QGS55p+xYFPDbIxN0BKJCeKdJic7v2PTE3Ijh4s8usQqgOTDgMn27unOec04KyNedze0bLjcVqYMEH/gYvEEreSRPKACDPhuUlVTz/b+VbzekFXUNfSrBH8O6hN9MdnmxlFliJB5sM2Q0TyT9PxU5m5RYNfcke576yRDYrLkWC8H3L8wLXMiJ5ZUbBddU7ODWu0T4kNtsoTz+kd+VXkf2QE1WM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 04:35:15PM +0100, Harry Yoo wrote:
> On Fri, Sep 18, 2026 at 07:41:56PM +0800, Hao Li wrote:
> > Currently, when the prefill API refills a non-full sheaf, it takes the
> > objects from partial slabs and never from the full sheaves in the barn,
> > so once the barn's full list becomes saturated, it stays saturated.
> > 
> > For objects freed via kfree_rcu(), every RCU sheaf then has to be
> > flushed to slabs because the barn's full list has no room.
> > 
> > To fix this, let the sheaf refill from the barn first, and introduce a
> > partial sheaf in the barn, which holds the leftover objects.
> > 
> > If no partial sheaf exists, take a full sheaf from the barn and return
> > it to the caller; the non-full sheaf becomes the partial sheaf, or is
> > put on the barn's empty list if it holds no objects.
> > 
> > If a partial sheaf exists and the non-full sheaf and the partial sheaf
> > together reach capacity, the one holding more objects is filled up from
> > the other and handed out instead, so no full sheaf needs to be taken
> > from the barn.
> > 
> > If a partial sheaf exists but the two together do not reach capacity,
> > take a full sheaf from the barn for the caller; the objects of the
> > non-full sheaf are absorbed into the partial sheaf, and the non-full
> > sheaf, now empty, is put on the barn's empty list.
> 
> Perhaps let's explain why the slab allocator needs this partial sheaf
> handling only for prefilled sheaves path?

Agreed, that's definitely worth an explanation here!

> 
> while reviewing it i was wondering "why is this just not part of
> refill_sheaf()"
> 
> I assume the reason is: usually we only refill empty sheaves because
> if it has at least one object, it can serve the allocation.

I think the distinction is less about why refill_sheaf() doesn't use
sheaf_partial, and more about what the two paths do beforehand.

For simplicity, let's call the __pcs_replace_empty_main path the
generic path, to distinguish it from the prefill path.

In both paths, refill_sheaf() plays an equivalent role: it simply pulls objects
from n->partial. Since neither involves the barn at that point, sheaf_partial
doesn't really come into play there.

The real difference is what happens before calling refill_sheaf(). The generic
path cleanly swaps an empty sheaf for a full one from the barn. But on the
prefill path, the incoming sheaf isn't necessarily empty, so taking objects
from the barn usually leaves leftovers. That's why we need a data structure
to temporarily hold those leftovers, and that's where sheaf_partial comes in.

If this explanation makes sense, I'll add it to the commit message. :)

> 
> > the gain comes from two sides: every full sheaf taken out makes room on
> > the barn's full list for a future rcu sheaf, and refilling from the
> > barn is cheaper than refilling from partial slabs under list_lock.
> > 
> > note that putting the non-full sheaf on the full list instead would not
> > work: it would occupy room on the full list, so the list would stay
> > saturated and rcu_free_sheaf() would still keep flushing.
> 
> [..]
> 
> > ---
> >  mm/slub.c | 142 +++++++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 134 insertions(+), 8 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 54ec12503357..0b1de6b42b61 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -3164,6 +3165,89 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
> >  	return empty;
> >  }
> >  
> > +/*
> > + * Exchange @sheaf, which holds fewer objects than requested, for a full one,
> > + * keeping the leftover objects in the barn's partial sheaf instead of
> > + * flushing them.
> > + *
> > + * Returns a full sheaf, or NULL if the barn cannot make one.
> > + * The returned sheaf might be @sheaf itself or a new one.
> > + */
> > +static struct slab_sheaf *barn_replace_partial_sheaf(struct kmem_cache *s,
> > +						     struct node_barn *barn,
> > +						     struct slab_sheaf *sheaf)
> > +{
> > +	struct slab_sheaf *full = NULL, *partial;
> > +	unsigned int to_move;
> > +	unsigned long flags;
> > +
> > +	if (!data_race(barn->nr_full) && !data_race(barn->sheaf_partial))
> > +		return NULL;
> > +
> > +	spin_lock_irqsave(&barn->lock, flags);
> > +
> > +	partial = barn->sheaf_partial;
> > +	if (partial && partial->size + sheaf->size >= s->sheaf_capacity) {
> > +		/* Fill the larger one to capacity from the smaller */
> > +		if (partial->size > sheaf->size)
> > +			swap(partial, sheaf);
> 
> Hmm but why switch sheaves when we don't have to?

My thinking was to minimize the amount of data copied via memcpy as much as
possible, since I was a bit concerned that the copy overhead might stretch the
lock hold time in the critical section.

> Sounds like we're losing cache affinity unnecessarily.

Yeah, that makes sense to me.

I'll reply to the other points in the next email.

-- 
Thanks,
Hao

