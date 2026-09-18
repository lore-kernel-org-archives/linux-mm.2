Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68FC3C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE726B008C; Fri, 18 Sep 2026 11:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47F556B0096; Fri, 18 Sep 2026 11:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E496B0098; Fri, 18 Sep 2026 11:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18A2C6B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:52:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E5D91606F8
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:52:48 +0000 (UTC)
X-FDA: 85227326016.23.0523509
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0FA15100003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:52:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C7HvoUZe;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789746767;
	b=Xk7X4aDeug6S1JHSPwADISkHRRIajsDg0dbAOeT5C32k7l9HiHK7Wkot82d6VoYhGYgYqR
	uzvJ/YP9eqOflf925dMld0htSjgBGEm7YQBhRyZLtM+JdVznkZBF96trTHbxRqb+ZpFEJU
	meWkhnckaOLDoqaQ7DCqtan6peSVCwA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C7HvoUZe;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789746767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HD1risQVKtKf77whM7zkZxSBxDakySBApLr7kIjmWJo=;
	b=kmNd03eHyqrGOqwAcnzs3U5D0MX1jELJyX2pjulz0wrcrg22JiNqhXyuCXYh4sNU1a3QuJ
	rqs1mGENA6ZMVeektyuXQTe5QWD2QWLZbETCX/DW/QkZFGUy+/8lu3Jh2pRPmnkKrla/V6
	Q/8PetTxO0f8azaTWaT3SFY5uEtd2go=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33DD3601EF;
	Fri, 18 Sep 2026 15:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584481F000FF;
	Fri, 18 Sep 2026 15:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789746765;
	bh=HD1risQVKtKf77whM7zkZxSBxDakySBApLr7kIjmWJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C7HvoUZeD+qSD1/6uxQ5C7v/YHlVEbj7TYgHwDkjA0KzA3CRwaBXTrXRA7QUXyHAa
	 7aBOC15eKV/gEyG4qj2njCA+dQUItmpcvoxH5y/JulsGs+1gUEBOoUI7+oNYPXO0N1
	 i+64enmlOeIpbSyZ2jQXykUOWZ0PcCAfLud7qgGoO6qCGX/f5bcuT/DMmnhNCyf9Vv
	 ME+XRC8F6xEx+M8Kxdx11XAf8V0FbQMpKZLPp+bhfO9A6ISPyeZq4nNtKzd5fr5Oly
	 DXigG/gUVip4Rd72fU4uCVeL7SHFNcrt1EoCiZsmivkNbB77iEvZr8L2T/sfvuVhYI
	 JlHMyv5c76JOA==
Date: Fri, 18 Sep 2026 16:52:43 +0100
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: refill prefilled sheaves from the barn
Message-ID: <aq1c0ycER3b4Mfds@thinkstation>
References: <20260918114318.124346-1-hao.li@linux.dev>
 <aq0ylDidEHa2kg4X@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq0ylDidEHa2kg4X@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0FA15100003
X-Stat-Signature: 4yyjr9wouhaezca4fkw5m5xjqf6wckgg
X-HE-Tag: 1789746766-239442
X-HE-Meta: U2FsdGVkX1/6uG9fGWvu8YEeTwpG1PoWQ3g0QD1eygqPkxK/r441GgYduCb0eiLVWVYL1UtvGtuKJGeZm1zYeEU0BVHU7iLcRMGDA0lDx2v8A8/Pplwt9bsE+19/DiV5ZRHzHVSGqLv3JQv/1MyxKaqlUu8Mm6EK9Byg372xaJT0SV0VlxP9cB8XUlc/hzp5Vj6h6L5erCN2fYdCsJPM1m/jiGMyab0ZTZblx02cgYiACc/jnt7b/g1I+JoQRx9aBzmlJePgWaR4azuAg2bZe3iEQJZwVQGta91J+y7kXyiay6nUsZqB0G6SV1eVO1qoTrOh5pNY/OyIzNTNIzDhtRdMbHdr74CaM3aekt0U5tBH0h3MkyxVw9b9M759GhiGQC+WRiCAWaRxShUGr12QVmXFrKgK2GJb+cPC303WXn9OYNpjnpA4J6KhT/NOelAgfPEiIrDVdxkdUGDMDxKefl8x0U6jw/23JncVPCK15HlUR9/iR5MThZLsRf+LTLeNCv59JsoSw2r06uISEe06EP0+xFeovSsI5yFuSfanuoK1AWNGwCFPSwyqPOsRmWQ3R1D8y2e0kELOJuB5Skk/+aYijJrl3fjKFqvcgKogPSli3+Gph28/MdoErYUMVaE0pnkMip2cA3yW1dNhkZ9y2dE4zKQexVWc6MC1XIc+PoZ44oLOtOkjdD5eNyrt83qSVaMLoMarL83xSRHpqHKGrs6KkI1MCWRY3q+CsRKYAXS0wBlmt4rCqV8cdGFchddRkCJBbuKSaUxKGiWPeaSRpzz5NDhhgHk73VcPimfxA6bkUZKTwbYO5zJ8TfCZkXPfWpmdz+OE3qsgBPMYd7NLTAscpNQLtY5OD2cjw+HdUSJjOuKw0U5yhjdX8Sd8IJlX1ph80ouZ+zH7p2xYvdwiFzliHZT1bPhBbj2eimP4SKh8CfWBkbV3mJBtadbYAiPYluT8x5PGKeTp8rYmbEz
 s2h3x+ue
 nWhhQovGowaVQ1f0412vBUVcfpr9EyBydjFKRxeagi2p/OxRAb+f9MU7V9+ovucLrSKMY2uDMSgnbVdMEHa1bv0HYCzLLwVSX8V9ZItGvmYfJPW8zbvKzOcqK8feffzHr2p78rNO7l1XY82nIQnOxDyFjnWqDbP7WiGl2ZXvGFmde4gyvFWVAF2iUO2nM1szfYcEkR3B3ymOfRvlTZfmFWGlzmCDuxqGTlKfONIu7U/17eF+8xkUVHYYc9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 04:35:17PM +0100, Harry Yoo wrote:
> On Fri, Sep 18, 2026 at 07:41:56PM +0800, Hao Li wrote:
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
> Sounds like we're losing cache affinity unnecessarily.
> 
> I think we should try to refill from barn->sheaf_partial,
> or if that's not available, refill from a full sheaf, and then move
> the previously-full-sheaf to barn->sheaf_partial or barn->sheaf_empty.
> 
> Then we'll never replace the sheaf with a new one.
> 
> With that, the control flow could be simplified quite a bit.
> Something like this. (Warning: pseudocode, it won't compile)
> 
> // refill a sheaf from barn.
> // return true when the sheaf becomes full
> // return false when the sheaf is not full
> 
> bool refill_sheaf_from_barn(s, sheaf) {
> 	struct node_barn *barn = get_barn(s);
> 	struct slab_sheaf *partial;
> 	unsigned int to_move;
> 	unsigned long flags;
> 
> 	spin_lock_irqsave(&barn->lock, flags);
> 
> 	partial = barn->sheaf_partial;
> 	barn->sheaf_partial = NULL;
> 
> 	if (!partial && barn->nr_full) {
> 		// grab one from full list
> 		partial = [...];
> 	}
> 
> 	if (!partial)
> 		// cannot refill from the barn. the caller will try
> 		// refilling from n->partial list
> 		goto done;
> 
> 	to_move = min(s->sheaf_capacity - sheaf->size, partial->size);
> 	partial->size -= to_move;
> 	// copy `to_move` objects from `partial` to `sheaf`
> 	memcpy(...);
> 	sheaf->size += to_move;

Hmm, but if it's from barn->sheaf_partial, it might end up refilling
the sheaf from n->partial. Needs bit more thoughts. Perhaps retry if
it's still not full?

> 	if (!partial->size)
> 		// move it to empty list
> 	else
> 		barn->sheaf_partial = partial;
>
> done:
> 	spin_unlock_irqrestore(&barn->lock, flags);
> 	return (sheaf->size == s->sheaf_capacity);
> }
> 
> What do you think?
> 
> -- 
> Cheers,
> Harry / Hyeonggon

-- 
Cheers,
Harry / Hyeonggon

