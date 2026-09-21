Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC307C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 04:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCB236B00A4; Mon, 21 Sep 2026 00:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7C206B00BC; Mon, 21 Sep 2026 00:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C92446B00D9; Mon, 21 Sep 2026 00:36:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E3586B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:36:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40C6C12058A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:36:30 +0000 (UTC)
X-FDA: 85236508140.27.40F3960
Received: from mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0E42320002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:36:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cBdTJYQz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cBdTJYQz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789965388;
	b=Pf7rfWBx1VcdssON0eCWZnGD4JMO9ruuyRDMITuZa1ucUKcXXHd5ZV7OnArLrJQPKszVTg
	g20oG2jgSXkInUSqzE5X/W40LNVY8U1IKSEhA4ph5x1LZNf8tTRNBzSRE0ZzOyu6sBWuN8
	lflfOOXjV6Q8odYbdWCTw8w+zhABXcg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789965388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6JI8fafkCZihrd3Lm2VcAIPqyFbjHsG/pWSzGDC6wQ=;
	b=m/5pDkfFavUIo/fsO6Z9WLfHsQXNxp1hGZ2/O5DwGuAMu1+tNmW9VUAwxUUOI2Tdzb6dkH
	RvsdMNnkVKMhndKxnn+Gd6GeeIMlqIcL2xv/LS8/qaeGCfW0Jh5m+29NpsJeVAmJILGB5R
	euv5TdlhA7eA/cXBufmAw7GBaP2NY/k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JPE0DpDhJZWGDtqTX2FloCT0gbPLYjQbwGm/k7GkBwk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789965386; v=1; x=1790570186;
 b=cBdTJYQzjki0wDo0932rpMybswHwyn9toBhoMyxCUfgbogdAkcykiz3njdhGGoVbdhyHS6Q8
 mUTsera7qUT1PQmPEh2E6ehKunzdZRHQdTtAlak/SzrNI53yxfrQ9mv2Tqgp4Efe0o1JXoee+I4
 tAPIgUwbLAGuiTOJEBorEV20=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e6610a640427393d;
	Mon, 21 Sep 2026 04:36:26 +0000
X-Mizu-Trace-ID: e6610a640427393d
X-Migadu-Flow: FLOW_OUT
Date: Mon, 21 Sep 2026 12:36:17 +0800
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: refill prefilled sheaves from the barn
Message-ID: <arCww4QOLsZxT9Ja@fedora>
References: <20260918114318.124346-1-hao.li@linux.dev>
 <aq0ylDidEHa2kg4X@thinkstation>
 <aq1c0ycER3b4Mfds@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq1c0ycER3b4Mfds@thinkstation>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E42320002
X-Stat-Signature: aq6b6ipjtzwa3hu8zx1i75ei9bs59b17
X-Rspamd-Server: rspam01
X-HE-Tag: 1789965387-442980
X-HE-Meta: U2FsdGVkX18/vMgNQfdBB4Eg3l/L0i2d/GFwhh58+S9Q5VnDGlPXrI9Zx5n++LcrYtZuPS+2hgW5aELvBGBfQgIfh3yTSY9Uxf23m7VDee66EQ94DDY+ir5OPxyLL7DIq0y8aGrSqgw9wEP7gSKzMYSYe0RssnwQH/cZBQLdU6zdeBaIu7OEZxTfhSD5FlNWFxmyjW/oXatEaCWckbXs7jmAF8yGFZto6IG+O07iXfoblbH4fde1GI5E4KR/aPO8+LRzdp4ImFz1GsXehWFncbUkzRlvvFnRopZNJjlHfk4N45hxPgXCRFV8dImMrUEmZtnWxRkiXq0gY0YBuEv/XmY+P9TJELLKNeJhpTDlokgl1smGgxHUwf26PFsIihe5kO/8NgjYerfUY7tC/TNaKVrfS+zM8MSd679cbbMKlIDvTz3GmHhk1t/ohIA5kkg6zkI2CBnNyA0evBqOS/KIrJ8sAQRIPz5xsE4YdSZnPier7Dq/i46scSyGe/mXBQ4yon/IXj0+6vxN9Sc+Y8FtXlsyFjvxcJTRKEA+Lsrsie4mhfo6SOu2jSAJ2z3qhem8YDvxnonxr7FHWexrLJ1rptqsoket2kKlr3jklI61CSHshJPZTVohxclI6EFtQD22Z0fuLUjbOob97k7ij3w0+AvQvEXkiZW+OHETA9KRPiUoM391ODwgZe6OnzqZEtHhgHM5s8xprKOsvS9uiuu8oj5QT4iN6DGavmkJwEjvidlhoSBstKvrHip7YqT/lSbXiBD+Ykt8yCI34T3jIAz+S0O3z7xQ/zKWgWTRZ1bjHLQnMPy2gi4NilEexxvhk+KoV+kh4ERcVSObIPPOtijfIXm7Vw8d9J1VbnsEF1ZvE9HAvMee+2O/YSpi1AVAEPuuUalw/ZV3kifhr94VbN1lFNSjm3zwo75fgVFkJI7S2yTQIbpLxMFbCsJFM0LlTGB4HXGGTv5F+RpCAGt5AjC
 yowc06CO
 xsRu/r1ODLJK3kO4rO/3dwgvlBBDeWsopGCSiLUDs5zuWtZgS9foErhpvDoIfjynprciSWAtr39ZdBNR5ajEtV1lnLaO2d1czZlfX9McuIa+cOQNnsK7k2DOW4hTyeDgD574Djv+aSs5NRiAELU1BOV/TBDEI7sbTVZAMrWv8PWDVK0tAXORmRVsBJIDPXfix0JDW/u01eOr3luwyMAp7VYTdGLnYgt0sorX3A8EdFph9sR6CTooawnq/bXm48K1FATIZxooGFUADIqI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 04:52:43PM +0100, Harry Yoo wrote:
> On Fri, Sep 18, 2026 at 04:35:17PM +0100, Harry Yoo wrote:
> > On Fri, Sep 18, 2026 at 07:41:56PM +0800, Hao Li wrote:
> > > +/*
> > > + * Exchange @sheaf, which holds fewer objects than requested, for a full one,
> > > + * keeping the leftover objects in the barn's partial sheaf instead of
> > > + * flushing them.
> > > + *
> > > + * Returns a full sheaf, or NULL if the barn cannot make one.
> > > + * The returned sheaf might be @sheaf itself or a new one.
> > > + */
> > > +static struct slab_sheaf *barn_replace_partial_sheaf(struct kmem_cache *s,
> > > +						     struct node_barn *barn,
> > > +						     struct slab_sheaf *sheaf)
> > > +{
> > > +	struct slab_sheaf *full = NULL, *partial;
> > > +	unsigned int to_move;
> > > +	unsigned long flags;
> > > +
> > > +	if (!data_race(barn->nr_full) && !data_race(barn->sheaf_partial))
> > > +		return NULL;
> > > +
> > > +	spin_lock_irqsave(&barn->lock, flags);
> > > +
> > > +	partial = barn->sheaf_partial;
> > > +	if (partial && partial->size + sheaf->size >= s->sheaf_capacity) {
> > > +		/* Fill the larger one to capacity from the smaller */
> > > +		if (partial->size > sheaf->size)
> > > +			swap(partial, sheaf);
> > 
> > Hmm but why switch sheaves when we don't have to?
> > Sounds like we're losing cache affinity unnecessarily.
> > 
> > I think we should try to refill from barn->sheaf_partial,
> > or if that's not available, refill from a full sheaf, and then move
> > the previously-full-sheaf to barn->sheaf_partial or barn->sheaf_empty.
> > 
> > Then we'll never replace the sheaf with a new one.
> > 
> > With that, the control flow could be simplified quite a bit.
> > Something like this. (Warning: pseudocode, it won't compile)
> > 
> > // refill a sheaf from barn.
> > // return true when the sheaf becomes full
> > // return false when the sheaf is not full
> > 
> > bool refill_sheaf_from_barn(s, sheaf) {
> > 	struct node_barn *barn = get_barn(s);
> > 	struct slab_sheaf *partial;
> > 	unsigned int to_move;
> > 	unsigned long flags;
> > 
> > 	spin_lock_irqsave(&barn->lock, flags);
> > 
> > 	partial = barn->sheaf_partial;
> > 	barn->sheaf_partial = NULL;
> > 
> > 	if (!partial && barn->nr_full) {
> > 		// grab one from full list
> > 		partial = [...];
> > 	}
> > 
> > 	if (!partial)
> > 		// cannot refill from the barn. the caller will try
> > 		// refilling from n->partial list
> > 		goto done;
> > 
> > 	to_move = min(s->sheaf_capacity - sheaf->size, partial->size);
> > 	partial->size -= to_move;
> > 	// copy `to_move` objects from `partial` to `sheaf`
> > 	memcpy(...);
> > 	sheaf->size += to_move;

Thanks! Make sense and I like this simple and straightforward approach.

When writing the patch, I was too focused on trying to avoid memcpy, or at
least minimizing the data to copy if it was unavoidable. However, I didn't
actually measure first whether memcpy makes any noticeable performance
difference. :P

The approach above is very intuitive, and as long as performance holds up, I
completely agree with taking the simpler way. I went ahead and tested it, and
the performance numbers are basically on par with the current patch. So I'll
switch to this cleaner approach in v2!

> 
> Hmm, but if it's from barn->sheaf_partial, it might end up refilling
> the sheaf from n->partial. Needs bit more thoughts. Perhaps retry if
> it's still not full?

Right, there are mainly two cases here. First, sheaf_partial might not have
enough objects. Second, a full sheaf obtained from the barn might not actually
be completely full, as noted in the comment of rcu_free_sheaf().

So we need a loop to keep going until @sheaf is completely filled up.

Also, I thought maybe we don't need to fill @sheaf completely, and only need to
fill it to the requested size. But the actual test showed that the performance
was not as good as expected :/

The resulting code looks something like this:

spin_lock_irqsave(&barn->lock, flags);

while (sheaf->size < s->sheaf_capacity) {
	src = barn->sheaf_partial;
	barn->sheaf_partial = NULL;
	if (!src) {
		if (!barn->nr_full)
			break;
		src = list_first_entry(&barn->sheaves_full,
				       struct slab_sheaf, barn_list);
		list_del(&src->barn_list);
		barn->nr_full--;
	}

	to_move = min(s->sheaf_capacity - sheaf->size, src->size);
	src->size -= to_move;
	memcpy(&sheaf->objects[sheaf->size], &src->objects[src->size],
	       to_move * sizeof(void *));
	sheaf->size += to_move;

	if (src->size) {
		barn->sheaf_partial = src;
	} else {
		/*
		 * No empty-limit check: the sheaf put on the empty list
		 * was already in the barn, so the barn holds no more
		 * sheaves than before. barn_replace_empty_sheaf() skips
		 * the check for the same reason.
		 */
		list_add(&src->barn_list, &barn->sheaves_empty);
		barn->nr_empty++;
	}
}

spin_unlock_irqrestore(&barn->lock, flags);

if (sheaf->size < s->sheaf_capacity)
	return false;

-- 
Thanks,
Hao

