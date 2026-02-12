Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4E51EE368C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 15:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93D66B0005; Thu, 12 Feb 2026 10:08:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A380D6B0089; Thu, 12 Feb 2026 10:08:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943A46B008A; Thu, 12 Feb 2026 10:08:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80CAB6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:08:05 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11F42C0976
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:08:05 +0000 (UTC)
X-FDA: 84436134930.08.E13B23E
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id D320518000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:08:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XxaWGlEC;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770908883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nwOfzTHo9+0udcjtzr/t6KDnWYj44fvh58Cy5u0CarI=;
	b=nrGTOxJp9TwwvBLMQ6zGxSgq/AhX62PcYQrrDZeJzUKj437H6trwblRan7gTTgixWtLu5I
	oJQZSinS/b6YTXJFd7lTDy02Kxzu8AG2GP8JoA/tfPMdiUUoYiYPJSf+Sm5ZpRVsAXzTiR
	XVg+1JsURRvYmWvaEDa3HgCLZmHQhiE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XxaWGlEC;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770908883; a=rsa-sha256;
	cv=none;
	b=dclXXeIjQEyQ63OilLTK4GJGpGeQjtGckiG1vV+9oyjrHnjr0pf8PBJNlR5uXaUIiteLht
	Lbj25UI5a1i5FLcXDjRGhWSWDEGwuLWEIcKf2opqIyGiFaTmc4FPdxXkRHClLyDv/5HSy7
	3rqXhpjJwIECAOoy2Hyw5Kigb3r0OrE=
Date: Thu, 12 Feb 2026 07:07:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770908880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nwOfzTHo9+0udcjtzr/t6KDnWYj44fvh58Cy5u0CarI=;
	b=XxaWGlECBN4a610iIpj/hxVRt0G79D1N7svcZQZiL0dTP19ojT1qgU0qS98Wddx7J0SXc8
	IGi/YSGTIcDrI2HQgoyDrN67COuIc51tksr8vGdaB9ljvXyEwlm2cL8dA9cKXH18EO/RSu
	EBGdEiAwXGwlIFEFzkdNeio4AIT4vyE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org, 
	axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org, 
	eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com, hannes@cmpxchg.org, 
	joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com, mhocko@suse.com, 
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, surenb@google.com, 
	virtualization@lists.linux.dev, vbabka@suse.cz, weixugc@google.com, xuanzhuo@linux.alibaba.com, 
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
Message-ID: <aY3r75eewxbArKVu@linux.dev>
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212045109.255391-2-inwardvessel@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: io13cjo8mjtont8w9ss8886918kaqykj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D320518000D
X-HE-Tag: 1770908882-586445
X-HE-Meta: U2FsdGVkX18iSGFbFxZrUYFo+t7NzSmDhstkyMdIv+XR4zCwwbBBoA9VaMoI3RsEI36FrsF3KwvgGxoCsd87SgkSoBmCwgNVeoQlqlYUK9JfA9GKISzkGc45FehrF2X6QC2iwQvCdzkNOl9bsKf7Cq0Wl/Cfs16BfynM5QM6w+UZn6IbvZOPlpyI3sT4XviLAOrdaEFaEKrRNmjP12qA7eH9plSFcrOnJyxA3WQCd6k463irZzo6YsDeLMb9n5hQ/A9DaFu7UIApmgCVWcqmAy2gnCErDau8n5GC7bDCfFAV8Nhq0FRIx/4OoMuL1KODqAqXNKLZ7UpysduJm3VxX9/iAJrD/FU+gClCpPtV7+lzKHx33f7a6nD66aRk3ekp9OkEQLn4yBz8apy8lu+oaqUDxsFjM2qp/0F8nvjz5uEVC6Jef1AQuitvx48RXoP8I/bj4ib+S57uci6KkfKZTdc+HuGaEmLHr+VrHr/gWlOb54jo4rrvv/rNJDWAHWj/T7/4mouuqvFoHMjOUJb++rZf8moABsVGzQoA4aQA0shL2D5glusNcg/GLdduEGpj7FSs+OAtlDRIX9DZCA2UceMQPmSfc1TmIYBv3K1sBWp4dVzxESwR/SC8LO1nL2OJyD3yDNDNOZBsi6qige+bLXFMtYBwpbFWtVTQk3/ifbpEiN5eb4wt91JMmilpjv4f500GXNEIW412cF0H7rqhW1e8jnHIzPN0OCkd9c18lVHN7GBrmANFehgddSOGfd17n2Mys+YKugHLuj1qWJc6h58Eq2ujgJQdkK3JQwNqoI+nMzp2e1fDY8S3YCfY/q1poksreBvkjbNtYAoWcCVzzY7X8p0lT3OuDFys6vuxlqJeJ0cbhwvjTUGxYSsF7JKzrKznBCm4w5pAM5A0jR9kn1pGT/l+GIe8WcuYgVK074GBIPg/vay0fzyY95QRiSr+TL05UP3/dnbTb4Mz0Yx
 sbWnb/CV
 AVOxeIHvyhj6MSg8+pCCcHmb7Few8+zXtuVxN0eZldaatljl2M/BwID5EZ4d/R8kCstnl+Y29I/KSoOf31tDS3dGAIhlkiQVdrpA4YHV4ig+mB0bd5FTsSpoQUgiXsBV9p8SrSJgybzbN5crPfehscnj3ZCFObuAlA8g3w3eVw91+h8tU+4JTX7wJ5OghAJRKwTh89jikpfGYgwr9wWL8ckGyeoOb+i2Da9CPWFxRl0BDHBmKJD9ILApqfu+Pvrqb7hnEM1Lr8BlbEDqjIuWSJV+rKMGCaspigNm9QcvGlpQQ1FFf1OkB/DDfvfnJQTl4pI8EOWr+NS/k5MLzuNpzfyBcDUI0DIzSyqRg0HCEuKZwn9U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 08:51:08PM -0800, JP Kobryn wrote:
> It would be useful to see a breakdown of allocations to understand which
> NUMA policies are driving them. For example, when investigating memory
> pressure, having policy-specific counts could show that allocations were
> bound to the affected node (via MPOL_BIND).
> 
> Add per-policy page allocation counters as new node stat items. These
> counters can provide correlation between a mempolicy and pressure on a
> given node.
> 
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>

[...]

>  int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
>  {
>  	struct weighted_interleave_state *new_wi_state, *old_wi_state = NULL;
> @@ -2446,8 +2461,14 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  
>  	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
>  
> -	if (pol->mode == MPOL_PREFERRED_MANY)
> -		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
> +	if (pol->mode == MPOL_PREFERRED_MANY) {
> +		page = alloc_pages_preferred_many(gfp, order, nid, nodemask);
> +		if (page)
> +			__mod_node_page_state(page_pgdat(page),
> +					mpol_node_stat(MPOL_PREFERRED_MANY), 1 << order);

Here and two places below, please use mod_node_page_state() instead of
__mod_node_page_state() as __foo() requires preempt disable or if the
given stat can be updated in IRQ, then IRQ disable. This code path does
not do either of that.

> +
> +		return page;
> +	}
>  
>  	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>  	    /* filter "hugepage" allocation, unless from alloc_pages() */
> @@ -2472,6 +2493,9 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  			page = __alloc_frozen_pages_noprof(
>  				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
>  				nid, NULL);
> +			if (page)
> +				__mod_node_page_state(page_pgdat(page),
> +						mpol_node_stat(pol->mode), 1 << order);
>  			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
>  				return page;
>  			/*
> @@ -2484,6 +2508,8 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  	}
>  
>  	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
> +	if (page)
> +		__mod_node_page_state(page_pgdat(page), mpol_node_stat(pol->mode), 1 << order);
>  

