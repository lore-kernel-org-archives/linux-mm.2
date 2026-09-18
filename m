Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B685FC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1A336B0095; Fri, 18 Sep 2026 11:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9666B00A5; Fri, 18 Sep 2026 11:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DFEE6B00A6; Fri, 18 Sep 2026 11:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78CDC6B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:35:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8D281C2F95
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:35:19 +0000 (UTC)
X-FDA: 85227281958.21.8BB6447
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 248C714000E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:35:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i0MCptV/";
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789745718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=os+ZB0D+705FI+w63ragnyl5EpLiV81b9g1IpQiTgrM=;
	b=KQnaSoEojIXCw3+HJqO+Ye96mywMaIgvOQOuO/y6FMiN3FveXpRLVGAZ3A3FhjPg8HaCLO
	7ReXBrfWuyo8ANrxH5//l95DHh+B3+aleukjYpGkJHWtizeBwghs9fpfVUiZ7tWPpPYpUa
	2dvBrsoY20lzK4Ltlsdr8FS/umf63nY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789745718;
	b=5tmL6Eu7yZwoeDRduYvY2iQzPgMbvXKY9tPjgteBzbnGuvw1uILPvi9R7Ph1LbauB3S7oG
	0f6Y877SO12Mcwuybx8VOb546SDNHwSJdwi/7z0TUG+JepZDYsU2uVhH2cQJ3Frjxxt4Ek
	8ZA7EWw3UPt93Sao57XT1Zj69X3IPIY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i0MCptV/";
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66222408AC;
	Fri, 18 Sep 2026 15:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38CB1F000FF;
	Fri, 18 Sep 2026 15:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789745717;
	bh=os+ZB0D+705FI+w63ragnyl5EpLiV81b9g1IpQiTgrM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i0MCptV/YkhLNOf1Pa0kPVwKcjspNX4GrvgozU57nBs7lz9Ycdi59VUD9PiiIzgGI
	 D+/J9j/n30fktDBJBb9Vx1E/SOqiBWMee3doQxtUMmWp578i+3MxKRyUIFRkKO24H7
	 4LMU67+2Bp2NLu7pvHPYFvBHkd8Yy2RPdppcOl+SVUxeO4JqZTA+8hSLp+QoCq75Jk
	 goPNMpPzKnV2rKSzxaLUDKnGnNGR4Whz5xIsLH32zk0d9/rY9FpRb4ypeoR++/cgTs
	 YmjqlzlwmHQokfqrQPyYIQ3LdRoNSERyP4PLIizs8WKeA7Ai6Swfr3GO0uecDLCvKX
	 p7IWVxfVE002w==
Date: Fri, 18 Sep 2026 16:35:15 +0100
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: refill prefilled sheaves from the barn
Message-ID: <aq0ylDidEHa2kg4X@thinkstation>
References: <20260918114318.124346-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918114318.124346-1-hao.li@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 248C714000E
X-Stat-Signature: 5zadcbyoxxbc1gfqu81911tsufwsg1ke
X-Rspam-User: 
X-HE-Tag: 1789745717-620023
X-HE-Meta: U2FsdGVkX19+rEPhN7vpRQEECJatva5WX0PaL6Mhr8zFtt9+SzUvGxu84HgzMqL1q6wGRNNJy7dYjQuz0Y7a7O6qqh84KB3MJQHZ//xNu0kXR6a1gEuq+nvz7dGFJK2V2J9+ZXoYqE1C6wjpYzvQ318GBD5nkgUnTvTHj/+qWLte/yao1n/BphaFrtUjFgqRjg5atTn5sNYsVg84G/Z+nvmWH+M4uBej/z1g9r3gz85kj6mQ8jQw7YUZUInsN7hGcuTUHSzP89qKZEyu5fJ8ERJPFedc3NwTWkiGpDZXZhkpyGn7kvpmnuAvCn+RzIDtnqD9veCXgohownbmCjGofFMVmT/lnkQbMgEziMz9hj+pxdin1RdLVM0KPgXzwdd+Pp/KxhbW/oPF9sUX1CW6Pc2zHmAF1n3sXabPZndKniFol84j7lyUbg+C9Yl7DTnRWy+hF3fpxCn6nT1XE0DB8g+u0/J9VrDCHPvdUromCOhgTCYEbpyrzfOGVt+MJoqeIJedjP1O7J0BU/3PyjpvgE3f2UPsjE/vLJgBWvSqN+CJCUw8ywdFSafAByQlW8rWmRHsFdupYQ2JbParLnScFmTPKoX72b+BsosDMNuJNRTgDpPb16CqEqgUtdKLqE5csKSiUF1Zifgs9FiL8u6JlikwrzTn09nafrmMfMYRMY7tN6UOodepj0kOr6AhYhPbbcAWkcsXY1uYxWcnqmrEqWbcZ2aU42IOjFgHGhUxTrKGz3irwe3ImZKVe0RbLnkgBiuOyrKOQ7hkPp0QQPVbQAipdMJbe25Rla9dgmA6rIaB/Cun+JQhRBqJsK+VLotO83hKtZMY8K/bvvAiOKf07yEssnESAS1LGNDZU+FVJhBHXnXO0Y30eEK6GpodugHVxwyGx1VS3E0QOSrRjPNFTLNWFip1Viu1gRoyUrl4g9N752w2aucImgnHnGIqHsTasc96+5RMNHhS5MYE6YI
 mC+TQ0V5
 nlsDjIBgepbHOXpHY/sQxyzb0zIl+aoPhe2iJCSJ9EDG8+DrdkFK1UQmfyPRpBHkV7VnxIET+95jDN1vjMev/Hdgk99P6fSr9NJETXNUPOez81vSB+k2FKHvt5B5m0XpQH9/WgiGyB8ss3OoRmnoNTCfOlP9GcQnIe94ZhGzVr2TK4p1tvJWWy2+hUuphbMx/aHx5OfZrMKg3Ti0mCgTo9ZKm//1uy7yrro3tPbdiQCKIXbWhvMHI0T4ecrS6KkZubqJ3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 07:41:56PM +0800, Hao Li wrote:
> Currently, when the prefill API refills a non-full sheaf, it takes the
> objects from partial slabs and never from the full sheaves in the barn,
> so once the barn's full list becomes saturated, it stays saturated.
> 
> For objects freed via kfree_rcu(), every RCU sheaf then has to be
> flushed to slabs because the barn's full list has no room.
> 
> To fix this, let the sheaf refill from the barn first, and introduce a
> partial sheaf in the barn, which holds the leftover objects.
> 
> If no partial sheaf exists, take a full sheaf from the barn and return
> it to the caller; the non-full sheaf becomes the partial sheaf, or is
> put on the barn's empty list if it holds no objects.
> 
> If a partial sheaf exists and the non-full sheaf and the partial sheaf
> together reach capacity, the one holding more objects is filled up from
> the other and handed out instead, so no full sheaf needs to be taken
> from the barn.
> 
> If a partial sheaf exists but the two together do not reach capacity,
> take a full sheaf from the barn for the caller; the objects of the
> non-full sheaf are absorbed into the partial sheaf, and the non-full
> sheaf, now empty, is put on the barn's empty list.

Perhaps let's explain why the slab allocator needs this partial sheaf
handling only for prefilled sheaves path?

while reviewing it i was wondering "why is this just not part of
refill_sheaf()"

I assume the reason is: usually we only refill empty sheaves because
if it has at least one object, it can serve the allocation.

> the gain comes from two sides: every full sheaf taken out makes room on
> the barn's full list for a future rcu sheaf, and refilling from the
> barn is cheaper than refilling from partial slabs under list_lock.
> 
> note that putting the non-full sheaf on the full list instead would not
> work: it would occupy room on the full list, so the list would stay
> saturated and rcu_free_sheaf() would still keep flushing.

[..]

> ---
>  mm/slub.c | 142 +++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 134 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 54ec12503357..0b1de6b42b61 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3164,6 +3165,89 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
>  	return empty;
>  }
>  
> +/*
> + * Exchange @sheaf, which holds fewer objects than requested, for a full one,
> + * keeping the leftover objects in the barn's partial sheaf instead of
> + * flushing them.
> + *
> + * Returns a full sheaf, or NULL if the barn cannot make one.
> + * The returned sheaf might be @sheaf itself or a new one.
> + */
> +static struct slab_sheaf *barn_replace_partial_sheaf(struct kmem_cache *s,
> +						     struct node_barn *barn,
> +						     struct slab_sheaf *sheaf)
> +{
> +	struct slab_sheaf *full = NULL, *partial;
> +	unsigned int to_move;
> +	unsigned long flags;
> +
> +	if (!data_race(barn->nr_full) && !data_race(barn->sheaf_partial))
> +		return NULL;
> +
> +	spin_lock_irqsave(&barn->lock, flags);
> +
> +	partial = barn->sheaf_partial;
> +	if (partial && partial->size + sheaf->size >= s->sheaf_capacity) {
> +		/* Fill the larger one to capacity from the smaller */
> +		if (partial->size > sheaf->size)
> +			swap(partial, sheaf);

Hmm but why switch sheaves when we don't have to?
Sounds like we're losing cache affinity unnecessarily.

I think we should try to refill from barn->sheaf_partial,
or if that's not available, refill from a full sheaf, and then move
the previously-full-sheaf to barn->sheaf_partial or barn->sheaf_empty.

Then we'll never replace the sheaf with a new one.

With that, the control flow could be simplified quite a bit.
Something like this. (Warning: pseudocode, it won't compile)

// refill a sheaf from barn.
// return true when the sheaf becomes full
// return false when the sheaf is not full

bool refill_sheaf_from_barn(s, sheaf) {
	struct node_barn *barn = get_barn(s);
	struct slab_sheaf *partial;
	unsigned int to_move;
	unsigned long flags;

	spin_lock_irqsave(&barn->lock, flags);

	partial = barn->sheaf_partial;
	barn->sheaf_partial = NULL;

	if (!partial && barn->nr_full) {
		// grab one from full list
		partial = [...];
	}

	if (!partial)
		// cannot refill from the barn. the caller will try
		// refilling from n->partial list
		goto done;

	to_move = min(s->sheaf_capacity - sheaf->size, partial->size);
	partial->size -= to_move;
	// copy `to_move` objects from `partial` to `sheaf`
	memcpy(...);
	sheaf->size += to_move;

	if (!partial->size)
		// move it to empty list
	else
		barn->sheaf_partial = partial;

done:
	spin_unlock_irqrestore(&barn->lock, flags);
	return (sheaf->size == s->sheaf_capacity);
}

What do you think?

-- 
Cheers,
Harry / Hyeonggon

