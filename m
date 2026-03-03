Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91D77E67A9F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B76426B00A8; Tue,  3 Mar 2026 03:54:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D706B00AA; Tue,  3 Mar 2026 03:54:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4DCB6B00AB; Tue,  3 Mar 2026 03:54:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 923DA6B00A8
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:54:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 542FB1B7831
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:54:25 +0000 (UTC)
X-FDA: 84504140490.04.FC0BD26
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf22.hostedemail.com (Postfix) with ESMTP id E880BC0009
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:54:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VdaLmcCl;
	spf=pass (imf22.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772528063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F7y7kpyZN5h3rth4U4l4dHOAQLEKFRkncvb8z3K3NMY=;
	b=e/w7WKU7Ac6ulW5qnXSqR3kcqTIdwuH3FetT4oaplrt1cAKdR24mt1ilBYcGrxDpFvlBml
	Lg5tNOOhBbyNVOsvil0MkVE/n0KXQjnYE/R3Wq4UvLiJkkBIX38EE+2chaEEDijYInGBZ8
	BDDHt/EQp7nnQ0qsolOzdYk/ilo+hao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772528063; a=rsa-sha256;
	cv=none;
	b=U7fqfyB2+Zipdcq3l5SusyhvcnjA1wpPi2k2YdwbXDxPRAuQmxN13/r3ls5fBMfO1zY0ZM
	oUBTLfY8Vrig8ARD+D3thaD27oJId/+ZkBJP8vPJGXtzMUjctN8kGhCcb9XZ3DI6/cboKM
	vbDWO8FVg3BLbQ5sOYtBZtcZJPZMdl8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VdaLmcCl;
	spf=pass (imf22.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 3 Mar 2026 16:54:09 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772528058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F7y7kpyZN5h3rth4U4l4dHOAQLEKFRkncvb8z3K3NMY=;
	b=VdaLmcCldqdF5tNiByu00tqk5QGK3YQEXUwVUrW5vuWfkcPJ7QJg9zh7Qidc5PQKB+MUnE
	kOheGmcW0gKohRFMFcrhvNwA0iZiFRdvJDXAI3QtqGjxGTG4Q6JLIsDANsqzoZNOp14zyl
	ulow0/coOHbDp2q0j3Hd5nHENrLDzz4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mm: memcg: separate slab stat accounting from objcg
 charge cache
Message-ID: <ji2jjt4vtmt2ox7wzytpivttc4z7j3u6cwmv23r6xit5322gns@te4t4djl5nlk>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-6-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302195305.620713-6-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E880BC0009
X-Stat-Signature: 9hi7x1n8kksgai81scxkp7r3pfumzc66
X-Rspam-User: 
X-HE-Tag: 1772528061-622010
X-HE-Meta: U2FsdGVkX1+rJvFi1NwnJ2Walvm2rVWuLPq1r2PKiQNrxW9Pzu9cfRlcyqyutmcqupWJh3SXiKA1pvH6bl49MDgSJt1Jaftgkem1oj0ANKV+TEX5VosBQy5IHAJMGlM4I+U4o8LhdMYMdmQdyO0hVuKoQ2cUlw+BXSK/zu/ER/wtwHfK4nL/X+hOjP9VRK7pjR34gBtAYGcj6tCaROXQtLFyZL2eknQJsuSYIxc2pwSNoT2cBfZ6EnHeg2+7b+Mabr4W4NOcMbgAWut8w+1y9nrOwgLEBej7rAIFR5TyXiewwySCeZ1oSSk7t3QSM/H4+gC9kEGgA0IMXS9u9I3Uv4MHFCqVERNR3RlyNeEAvJc5wAbUjSZiaGQuPRm4MIDNjlXx3bo4fcfuwxrnnWSzM+plU02r6KcmFqKpMgqPIoa9QZqmG5muWA7MJMbW420ZBV3SvLwT0nMs79jE/umeVYSNPO9L1MZd32EfzkaGaVvB/pLDLOiKWGdvqvVK3rzjYqDs72ojei5THGni2wyKlLMK13x8fX7iiSbE6zwHyDIkoIGl6W23ZdrRrcDOJbb35U85yv4w9WU/X9KaJrSTCBNT4RxK7oAG2gTIFlMd+k/y4EAcve7+z8janNaeSGiI+xD1sACRfqOjWrbWN4FcSivdjt/y2xldrgsRJFA0S0vyGrcanP8s75AqHf5PIayRPTAXr4F2gg7HJNSst9C1BEojo9T7gN98HZSZbwQW5kyOSDnYh9Wd2dovhCv7DIkVQq/z6pHubeMC7BschTFpJS9G3tY14vvH3rKiur/FPOS4qx5Yq+/KkK1Jhb9tcas8vL55KTl0cFog2jcyMdq6pMhp0RbUkF4iaTW6JtZlmgpcgfC7+wND74U3rnWYzl/6IlbklE1u51eBRUOjENVCzAi+25QBdNivJu0IRXxkC83P9rP4cOROF4utCcQU/pWrhbR3Yi4eyX2aDat64aZ
 nMUOhAy7
 a4Fv3f/bI+qkqDwpz7ZaVBJewZd0EJJCw3LQjlkg4fc34TEnt4d+ktALjc0/zh+Vd0hqLaP/6EIgHuHSchO8AdZlZDfKE3xRUJgAHRZu2yIa0yYV3CnGtzjtfMuySTdDbYNrGScDLAYTP0UTLS2E1En+gy6Y6r7shI2QnTPoiHVkkBhlo6w74xDsZlTiKcYk5C+kvCv6B+XD1aUjsXZaviZjHO7Sg5N21CfbZ2Dox3OgbpwVTQ+gyU7IQ0IjaaVTYPZ8UyvGqZGeHH0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 02:50:18PM -0500, Johannes Weiner wrote:
> Cgroup slab metrics are cached per-cpu the same way as the sub-page
> charge cache. However, the intertwined code to manage those dependent
> caches right now is quite difficult to follow.
> 
> Specifically, cached slab stat updates occur in consume() if there was
> enough charge cache to satisfy the new object. If that fails, whole
> pages are reserved, and slab stats are updated when the remainder of
> those pages, after subtracting the size of the new slab object, are
> put into the charge cache. This already juggles a delicate mix of the
> object size, the page charge size, and the remainder to put into the
> byte cache. Doing slab accounting in this path as well is fragile, and
> has recently caused a bug where the input parameters between the two
> caches were mixed up.
> 
> Refactor the consume() and refill() paths into unlocked and locked
> variants that only do charge caching. Then let the slab path manage
> its own lock section and open-code charging and accounting.
> 
> This makes the slab stat cache subordinate to the charge cache:
> __refill_obj_stock() is called first to prepare it;
> __account_obj_stock() follows to hitch a ride.
> 
> This results in a minor behavioral change: previously, a mismatching
> percpu stock would always be drained for the purpose of setting up
> slab account caching, even if there was no byte remainder to put into
> the charge cache. Now, the stock is left alone, and slab accounting
> takes the uncached path if there is a mismatch. This is exceedingly
> rare, and it was probably never worth draining the whole stock just to
> cache the slab stat update.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 100 +++++++++++++++++++++++++++++-------------------
>  1 file changed, 61 insertions(+), 39 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4f12b75743d4..9c6f9849b717 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3218,16 +3218,18 @@ static struct obj_stock_pcp *trylock_stock(void)
>  

[...]

> @@ -3376,17 +3383,14 @@ static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
>  	return flush;
>  }
>  
> -static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
> -		bool allow_uncharge, int nr_acct, struct pglist_data *pgdat,
> -		enum node_stat_item idx)
> +static void __refill_obj_stock(struct obj_cgroup *objcg,
> +			       struct obj_stock_pcp *stock,
> +			       unsigned int nr_bytes,
> +			       bool allow_uncharge)
>  {
> -	struct obj_stock_pcp *stock;
>  	unsigned int nr_pages = 0;
>  
> -	stock = trylock_stock();
>  	if (!stock) {
> -		if (pgdat)
> -			__account_obj_stock(objcg, NULL, nr_acct, pgdat, idx);
>  		nr_pages = nr_bytes >> PAGE_SHIFT;
>  		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
>  		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
> @@ -3404,20 +3408,25 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
>  	}
>  	stock->nr_bytes += nr_bytes;
>  
> -	if (pgdat)
> -		__account_obj_stock(objcg, stock, nr_acct, pgdat, idx);
> -
>  	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
>  		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
>  		stock->nr_bytes &= (PAGE_SIZE - 1);
>  	}
>  
> -	unlock_stock(stock);
>  out:
>  	if (nr_pages)
>  		obj_cgroup_uncharge_pages(objcg, nr_pages);
>  }
>  
> +static void refill_obj_stock(struct obj_cgroup *objcg,
> +			     unsigned int nr_bytes,
> +			     bool allow_uncharge)
> +{
> +	struct obj_stock_pcp *stock = trylock_stock();
> +	__refill_obj_stock(objcg, stock, nr_bytes, allow_uncharge);
> +	unlock_stock(stock);

Hi Johannes,

I noticed that after this patch, obj_cgroup_uncharge_pages() is now inside
the obj_stock.lock critical section. Since obj_cgroup_uncharge_pages() calls
refill_stock(), which seems non-trivial, this might increase the lock hold time.
In particular, could that lead to more failed trylocks for IRQ handlers on
non-RT kernel (or for tasks that preempt others on RT kernel)?

-- 
Thanks,
Hao

