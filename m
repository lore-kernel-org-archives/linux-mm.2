Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95367EC1449
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 13:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095236B00A8; Tue,  3 Mar 2026 08:45:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 018846B00F0; Tue,  3 Mar 2026 08:45:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D4B6B00F3; Tue,  3 Mar 2026 08:45:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D21376B00A8
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:45:25 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9127F1BFF6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:45:25 +0000 (UTC)
X-FDA: 84504873810.13.2A66C53
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id A90A014000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:45:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NO7o3ebi;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772545524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3cDdicZmTJGsrJ93Z00IaY7+tBeVssbAV0nwfydT7Q=;
	b=y4yk4svf1dSi4QjH/nmVW8V+rQXx3DQVUk9XWnKFUsIsrtMABsALlstQ65XRWT2qxfsYZp
	AKJFPgoU0kaXOzK1pmnPmbmDIJZErboPycfCsaGVxMOPwfjlbupGIvrdD+UEmsWJ8shzJ6
	ZhxHlfvKARf6Y3bPoAr+Mknw2hnaf5c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NO7o3ebi;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772545524; a=rsa-sha256;
	cv=none;
	b=2J8JubTL0H/YeUHeItgsaCtAVogAxD8Rs8AbC02Gvq4e0o3bEUIRy5L2RsZDHyl7HQfgCu
	741PmxuFuC2+jfqpnIb++OOXB6FMIWLaLoNUn3ZtE+bSLd7Z/WGOzex90PNMFngO8M7ZMM
	Vw5LgoNCVhrr3cfOrkxZE0qU+SnVCOw=
Date: Tue, 3 Mar 2026 05:45:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772545522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W3cDdicZmTJGsrJ93Z00IaY7+tBeVssbAV0nwfydT7Q=;
	b=NO7o3ebiu/lXOgRIsnDdillpTCZEhFFuus4HkPuivwr/d8AFliAgO9uFRLKy/Ax6XnLqPo
	neebTbcVkrH3sFYTZL2TQ1fIsGMAS9rXI6UTgXRyqv9mCSJ3A2G/mW8yONl0k+mCsbLbXQ
	EbM4iRry+BsD7AD634uk0eZrCy3aEAg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mm: memcg: separate slab stat accounting from objcg
 charge cache
Message-ID: <aablae2eFl9ne5fW@linux.dev>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-6-hannes@cmpxchg.org>
 <ji2jjt4vtmt2ox7wzytpivttc4z7j3u6cwmv23r6xit5322gns@te4t4djl5nlk>
 <541a6661-7bfe-4517-a32c-5839002c61e5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541a6661-7bfe-4517-a32c-5839002c61e5@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A90A014000D
X-Rspamd-Server: rspam07
X-Stat-Signature: hwmhiyyer5ufk8arn4fbde6bzs3hhtxw
X-Rspam-User: 
X-HE-Tag: 1772545523-300045
X-HE-Meta: U2FsdGVkX18k/izmWzCQe+nbIwECo9TA2yQBn/4HJa8YmGy5zbZOjA1CogdP0XbrvxjKp7cL6H8PFAPLWl2SZZcr97Pw0WBJxaYdSaWdYsJcWIq+RJt1g2OxAMUX+z5UPQtMQuXDTptESdMYWSODP1jSNES/c8Pal0w82oK+Gp8iuzA2tpITiJ22vw+D9yvIzi/GRVJJy2EaI6TVnW6L239fpmcq33ZuiHjzcNNmZu74KPSC2TBAwi3iaEPPSp0iTKAMAgstggbCGG7fSE8PXsO3SCvOc41G8Oe4CM/N2fNoxf6bl7Ki1YickqcTnW4WUIrGWmAD5Sl3vXK1ugXSy/B0DTi2Uyx+ZDnMV/O1F9cf25RrvU2AF5ouoiDkwTvohsK4UJoD4EfIviji7bSaCP6UCK7wjEOXMEbFTiwPVVyRy6x5mycbUX+UGj7Agb64n4LvLl1QTDUtHDYPAfHRUIrBh3HCloCEw8loKcDp+VCWLH1IGLcvJGH7KRxGwA6xvPjtpRdtZk7f3z4LtVmsyjZa2ZUtRGxyK6sTcUKmoUBKgrI3iqGlLAEKGLZe+DioCI7hLlKDlO3Djob8e0elhpjLGa0fn3v5bwoe/ur/ZAWo/sDgMJSXTgVi6kw0rghuRgdJ67P9ryPuroAPJrhbkYAl9jaMnDcwBMY7Z8KwjXbUFc5BxrtE9LuafQ3vHJT+ePkBVvaj0fdODTh9l6UtHWYrjOKakU29Utt0m0TmcnW2e5U0VtG0uNUq/YAv/48T5+UYDu5RCv9Y6VlCwnQ8uYNevWjMv2goLjJzMiNIfQDAFyGqvmVe3vazddaQvojIQC14yMVI9Qa/maiMFfBajl5tqHhjAI66R0wR2DL05fNaEIroFyOt3i1Xnw/sJJPSwD+ErXdympYIlCGy+lr+P9pzCQW2VhJCRAYN5bUZ4Mb+ih3AaNxz+Hty3jGhgER+2kXEagjYpF71f2thVyw
 3nfYxoTJ
 j72VIcsM4LEvx2Cd33za5wNLHxzvFAzHvzMyuyrimzuLf+sjhXmKkgfwQwyXpAHVSw4JX278BVSC2otCyVDF+jnTpIFYqf94BKUzcZpY91dFqNCH7mspSG1v5gxs4XVGqN45WXqFv6h938BFmVdqR8U1s4+dHFrDLy5hZQ138FA+QfZc+ta88urXFTGJOqQGYCdtlre53Rcu0zeyIOFq9XOuPuOL+55uJ93D+rDf9e8LLgOhUNTyI2wDm4rCAkYATq9y1izxRTKdykR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:42:31AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/3/26 09:54, Hao Li wrote:
> > On Mon, Mar 02, 2026 at 02:50:18PM -0500, Johannes Weiner wrote:
> >> Cgroup slab metrics are cached per-cpu the same way as the sub-page
> >> charge cache. However, the intertwined code to manage those dependent
> >> caches right now is quite difficult to follow.
> >> 
> >> Specifically, cached slab stat updates occur in consume() if there was
> >> enough charge cache to satisfy the new object. If that fails, whole
> >> pages are reserved, and slab stats are updated when the remainder of
> >> those pages, after subtracting the size of the new slab object, are
> >> put into the charge cache. This already juggles a delicate mix of the
> >> object size, the page charge size, and the remainder to put into the
> >> byte cache. Doing slab accounting in this path as well is fragile, and
> >> has recently caused a bug where the input parameters between the two
> >> caches were mixed up.
> >> 
> >> Refactor the consume() and refill() paths into unlocked and locked
> >> variants that only do charge caching. Then let the slab path manage
> >> its own lock section and open-code charging and accounting.
> >> 
> >> This makes the slab stat cache subordinate to the charge cache:
> >> __refill_obj_stock() is called first to prepare it;
> >> __account_obj_stock() follows to hitch a ride.
> >> 
> >> This results in a minor behavioral change: previously, a mismatching
> >> percpu stock would always be drained for the purpose of setting up
> >> slab account caching, even if there was no byte remainder to put into
> >> the charge cache. Now, the stock is left alone, and slab accounting
> >> takes the uncached path if there is a mismatch. This is exceedingly
> >> rare, and it was probably never worth draining the whole stock just to
> >> cache the slab stat update.
> >> 
> >> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> >> ---
> >>  mm/memcontrol.c | 100 +++++++++++++++++++++++++++++-------------------
> >>  1 file changed, 61 insertions(+), 39 deletions(-)
> >> 
> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> index 4f12b75743d4..9c6f9849b717 100644
> >> --- a/mm/memcontrol.c
> >> +++ b/mm/memcontrol.c
> >> @@ -3218,16 +3218,18 @@ static struct obj_stock_pcp *trylock_stock(void)
> >>  
> > 
> > [...]
> > 
> >> @@ -3376,17 +3383,14 @@ static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
> >>  	return flush;
> >>  }
> >>  
> >> -static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
> >> -		bool allow_uncharge, int nr_acct, struct pglist_data *pgdat,
> >> -		enum node_stat_item idx)
> >> +static void __refill_obj_stock(struct obj_cgroup *objcg,
> >> +			       struct obj_stock_pcp *stock,
> >> +			       unsigned int nr_bytes,
> >> +			       bool allow_uncharge)
> >>  {
> >> -	struct obj_stock_pcp *stock;
> >>  	unsigned int nr_pages = 0;
> >>  
> >> -	stock = trylock_stock();
> >>  	if (!stock) {
> >> -		if (pgdat)
> >> -			__account_obj_stock(objcg, NULL, nr_acct, pgdat, idx);
> >>  		nr_pages = nr_bytes >> PAGE_SHIFT;
> >>  		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
> >>  		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
> >> @@ -3404,20 +3408,25 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
> >>  	}
> >>  	stock->nr_bytes += nr_bytes;
> >>  
> >> -	if (pgdat)
> >> -		__account_obj_stock(objcg, stock, nr_acct, pgdat, idx);
> >> -
> >>  	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
> >>  		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
> >>  		stock->nr_bytes &= (PAGE_SIZE - 1);
> >>  	}
> >>  
> >> -	unlock_stock(stock);
> >>  out:
> >>  	if (nr_pages)
> >>  		obj_cgroup_uncharge_pages(objcg, nr_pages);
> >>  }
> >>  
> >> +static void refill_obj_stock(struct obj_cgroup *objcg,
> >> +			     unsigned int nr_bytes,
> >> +			     bool allow_uncharge)
> >> +{
> >> +	struct obj_stock_pcp *stock = trylock_stock();
> >> +	__refill_obj_stock(objcg, stock, nr_bytes, allow_uncharge);
> >> +	unlock_stock(stock);
> > 
> > Hi Johannes,
> > 
> > I noticed that after this patch, obj_cgroup_uncharge_pages() is now inside
> > the obj_stock.lock critical section. Since obj_cgroup_uncharge_pages() calls
> > refill_stock(), which seems non-trivial, this might increase the lock hold time.
> > In particular, could that lead to more failed trylocks for IRQ handlers on
> > non-RT kernel (or for tasks that preempt others on RT kernel)?
> 
> Yes, it also seems a bit self-defeating? (at least in theory)
> 
> refill_obj_stock()
>   trylock_stock()
>   __refill_obj_stock()
>     obj_cgroup_uncharge_pages()
>       refill_stock()
>         local_trylock() -> nested, will fail

Not really as the local_locks are different i.e. memcg_stock.lock in
refill_stock() and obj_stock.lock in refill_obj_stock(). However Hao's concern
is valid and I think it can be easily fixed by moving obj_cgroup_uncharge_pages()
out of obj_stock.lock.

