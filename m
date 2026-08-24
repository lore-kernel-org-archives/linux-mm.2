Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FB88C5DF8C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 03:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8316B009B; Sun, 23 Aug 2026 23:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7FC86B009D; Sun, 23 Aug 2026 23:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995AC6B009F; Sun, 23 Aug 2026 23:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78B026B009B
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 23:06:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E85E1C03CC
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:06:12 +0000 (UTC)
X-FDA: 85134674184.28.087D707
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id E123A40008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:06:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AeW14FV0;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787540771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0RTeEPPkTUJwAhiSHeNNGSJtMypaSRst3/83QMi1Dk=;
	b=OJBmNtkgxeFJn40itLCrZK1MdaqVs/zzopmqRgRAnQxyk/w8bOmLJ7j5QWBg//tWiY6R+Q
	vZIW1ATX0O/ExdM+3pNiRKHCyhJrG0+wtImTcweFN35Xe/IsbBBZKe8erqRpCiJzHOARmm
	y/p0dQmN9XGSj7rHSf2RMGGucURtAaU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AeW14FV0;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787540771;
	b=dXKLxjxsfB0epRXnysEv0MOgHuR3Wb/eR5NQ7hrz2Z6fm43PCHNHxW1CofDJHs0asQD5Vr
	KFTbjinRA1GqXURmIYRSaxIq7VDoBeGAA8nPKU6X/W+TVFyDdKqq5/vasN3t/Np6UUa3Lv
	geXKnQ7u3P9Tfdtu18CjkLtREebX6u8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X0RTeEPPkTUJwAhiSHeNNGSJtMypaSRst3/83QMi1Dk=; b=AeW14FV0pgandiUG8boMQJRZgN
	EPCw6yOxDJzGLA1rJCA/w4NwUKKN6YG0+UoMewkfLhX8Y/dQclE0U9YLbmNq4DpVp+OCxGn0630X7
	ERMYRdyMNW1NgTowHL2yUsLEf/zisUPcL8sJ7XPO7kdi4lvEmTTQ12T/Lfk5Fre1blEXjWWh9uNzt
	Y4YOI3q+aAz5YeGba6MJXcyPCBXhQC7S2rn2quLoh117+WJl3VR/SZOVfzPqntchz1t0Pui72hJ8E
	b0R+NPODtuOnXn0YrHCXL5iBrJnMsVU9QZ/+FDdfPyEzy4JjupA5I7wXLntsO7peH/6Z0ULQxnl6h
	YSwvTsxQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyL0e-000000059Vk-0XNn;
	Mon, 24 Aug 2026 03:06:04 +0000
Date: Mon, 24 Aug 2026 04:06:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, edumazet@google.com,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	stable@vger.kernel.org, david@kernel.org, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/mempolicy: refcount the weighted interleave state
 instead of copying it
Message-ID: <aou1Gwxk2s8Qjdm9@casper.infradead.org>
References: <20260821104043.f692421fec915c0c5bc1fbe6@linux-foundation.org>
 <20260824024117.1755899-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824024117.1755899-1-gourry@gourry.net>
X-Stat-Signature: bei3ahbb1xa6wbjpfpa1u3wk6g6i5zwr
X-Rspamd-Queue-Id: E123A40008
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787540770-159216
X-HE-Meta: U2FsdGVkX1+Nd/KBe1silvRkKkXsv8HG7XeH7REbwK9L6Tap3e3xIH5OaZRUVwDtkh+faWty3sSwtTCGvM7MC+FK+KlyFunFcAXFgKHBVUB/ycHN5CY7c3RCjBT0r6/pWmuV+THuk1ZlE1k1uZn1IwXpytLMreSq/EOLYEa+DbrDC0aFNfSXZRZ1I0McoHYRqx1aOtShpfFrzHWAVO4JHhDvBXiSCzKb87y6vQJXbW2BvlONdB6DqQh5OQJQF+165rnDVvqGPbrynDR6dPC2YXYz4bMsUVJfr7Moc0Rl82IoMe6ARD+DRKqJvpEeZ0vzwc9havqSz6c7nIwGfy0bJRARDi8AB2OU3PdqAUdfqvrbk6wSAp9DIUt4dDhWA1bSIr6JU6klb/dST9+FAQgi5/D63oJxVBKWyJdyka95hNpFNkAlAdnh8ElNf9UBTfvH62M22+rj4ayW0/a1M/V6hyjF5muUju5s5yovtIX5jAf3kI+DePjtXixG+TmjGgp1gvzuiQPyKigqnFXt1jhuqt8DJiAk/uHn9jr16Ix++OrhD+MMd09zxmtdy9S14A2jd6+3hAIJZEIuvX4XkziQIVRohPwiNcQXgHBAqKNXI2HiMi0/wehqygHJmO+LV70vLHlDYRsfUN8LnR98C5s3O/slZUC0EBMXxYcgEjpZaTkLhy5InFlrbuQSAgretSemrnPVCZ4qTOcxyrwouw/DX7Sm/3ONWWhuO1n6XR0+ov8HAzT8aswuXSHwvarR8CW3rgtnKQBDk8t32XHS8EUNDPmfwgORNiXoxS1ctJ0XpaiH+eKizJQDzj6N6h7Qbkdf2aRT9ydRaGBv7otNiA+TB6li0xKjllUOIfQOfSeBQhp1lbd+haNLSh7r83JSOTVJp0MBBmzKzHla3c4vRaNxpooxj3ry69P/bujnWNpzl9i44Ma9M5pdOkjo9WLQxDlXAT2HF7r++Fl8Kt2ffUQ
 D4/zoPIe
 xMZFOsTec88FrkW4fnlbIKKOTELEZvdeUex/H9TH+0oX2p+1yM2j8E7bXTixvQe8CLgAKKETkSrb/5tF9Hyimfh5RUgwc+aqgzq7UhsRpP7bZOFxMJhFXkjojt09tEs+RQrIMc20kBM+Sas33c37CAmFK697dpzfOlWgj7xzluGlovthgSdTpII3ABHB7dYQGqTgPx1jMKZZ/fHwz5eGVWPvXw1lrPt3vMqh61w33jqOeORypULFajHDXw1C0vMrOjf0v/AK4VakWZjFRpqLAs7Ak5+XNQsVex+7OEYYwYpZGNP78B5nvbZbbNL3Ds9UATOGjVspYDjBTu3vd/UVHLUlA51NLf5LNTCwYTwxL5QTvBEVErB+zXCuMLAAXjquSVI+2Yw891vVzw+jwWlJHFbz58A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 23, 2026 at 10:41:17PM -0400, Gregory Price wrote:
> @@ -2632,7 +2654,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
>  	unsigned long nr_allocated = 0;
>  	unsigned long rounds;
>  	unsigned long node_pages, delta;
> -	u8 *weights, weight;
> +	u8 *table, weight;
>  	unsigned int weight_total = 0;
>  	unsigned long rem_pages = nr_pages;
>  	nodemask_t nodes;
> @@ -2676,25 +2698,12 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
>  	me->il_weight = 0;
>  	prev_node = node;
>  
> -	/* create a local copy of node weights to operate on outside rcu */
> -	weights = kzalloc(nr_node_ids, GFP_KERNEL);
> -	if (!weights)
> -		return total_allocated;
> -
> -	rcu_read_lock();
> -	state = rcu_dereference(wi_state);
> -	if (state) {
> -		memcpy(weights, state->iw_table, nr_node_ids * sizeof(u8));
> -		rcu_read_unlock();
> -	} else {
> -		rcu_read_unlock();
> -		for (i = 0; i < nr_node_ids; i++)
> -			weights[i] = 1;
> -	}
> +	state = wi_state_get();
> +	table = state ? state->iw_table : NULL;
>  
>  	/* calculate total, detect system default usage */
>  	for_each_node_mask(node, nodes)
> -		weight_total += weights[node];
> +		weight_total += table ? table[node] : 1;
>  
>  	/*
>  	 * Calculate rounds/partial rounds to minimize __alloc_pages_bulk calls.
> @@ -2706,10 +2715,10 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
>  	rounds = rem_pages / weight_total;
>  	delta = rem_pages % weight_total;
>  	resume_node = next_node_in(prev_node, nodes);
> -	resume_weight = weights[resume_node];
> +	resume_weight = table ? table[resume_node] : 1;
>  	for (i = 0; i < nnodes; i++) {
>  		node = next_node_in(prev_node, nodes);
> -		weight = weights[node];
> +		weight = table ? table[node] : 1;
>  		node_pages = weight * rounds;
>  		/* If a delta exists, add this node's portion of the delta */
>  		if (delta > weight) {
> @@ -2735,7 +2744,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
>  	}
>  	me->il_prev = resume_node;
>  	me->il_weight = resume_weight;
> -	kfree(weights);
> +	wi_state_put(state);
>  	return total_allocated;
>  }
>  

Bit of a shame to take/put a refcount on every memory allocation.  That
seems like it might hurt (even being on a different cacheline).  Would
it make more sense to use SRCU for this?

