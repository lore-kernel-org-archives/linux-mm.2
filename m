Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D34FCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 18:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B885A6B0005; Fri, 15 May 2026 14:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B60C36B0088; Fri, 15 May 2026 14:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A768D6B008C; Fri, 15 May 2026 14:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 985616B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:42:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19D32A021B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 18:42:54 +0000 (UTC)
X-FDA: 84770525868.10.FBFCB4E
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 00DAD40009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 18:42:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qRvy1mR+;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778870572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PjvRMJtvM6Mkc95mQ7/7EbrQxH9jqXTEFZpG9TrHmG8=;
	b=XPLohP5l4Jb++iSFBYrQ27kW1lkJd3Aty0z4PTpUQfvgZRXPDPJeNsXkjqrxne+2bgKV+C
	8bZTjP9tcmI8pT09Z6gOi5nvCeD9Inz+gb9IrlLNF+iB82HBZF182X334SJ4ilEaQnDhS1
	GL9Vf4C2KqlRPY8JIhpQ32ZoCZGtoiY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qRvy1mR+;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778870572; a=rsa-sha256;
	cv=none;
	b=t2EzOsxKLLskXvr7l62kdLbOIqsZwr8kEiq0aaEuMJCNYYetjpxeR66ynOApxMgNx3LX2Q
	D6yY0uM98YtEv4OMJWxE7Y9tW2kJcMkUxGvBr6kntdxQv6RqjgQ3OORxnIASIqQvDHNW/j
	D6CAc7SK6El1L5Y0xFcOrdJwLZS/GgE=
Date: Fri, 15 May 2026 11:42:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778870569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PjvRMJtvM6Mkc95mQ7/7EbrQxH9jqXTEFZpG9TrHmG8=;
	b=qRvy1mR+U/vAVR7cDUbzs088r2gSDw15pRWeMOcnGAKJkR3UJjFUdLRmfk00zHrPM1t9FU
	TKrWNMLh8uOBZq7JMKkzgHB49EP5E1uVs/oWEmO1K54BmVr1kkCZYv4CPFflbErxavpRvO
	wL/rqecTS770pdQXOxhk58tdf/o2lp8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] memcg: cache obj_stock by memcg, not by objcg pointer
Message-ID: <agdnTPXhuepuu7hG@linux.dev>
References: <20260515171953.2224503-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260515171953.2224503-1-shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 00DAD40009
X-Stat-Signature: cfxf7h1gthtx5auhxeup7noih4qdmcnh
X-HE-Tag: 1778870571-508867
X-HE-Meta: U2FsdGVkX1/jYhezIWRS62GHvUs744nsAJe1WQELxXPDHSFAIllAAfiXAXZy+lviItM++gnWzR3xxTKVmEcBWjd/fVdk68rYhfMIxfZRgrm3mRetunwRM8uTIpiCnpRYyI9Gg2O3H3gok1HBB34dTfYq0UfOoCcyqMmrSSoLIHyMlfCTKEzMEOBdf7zpdYhFKKAV4AQ5bPJz9Rm1QtyHwDeuWHBGt5hlRgSbzJVeqslWQKvrxudWFEzixnYVSKCdqsUC4/ZE4f5mnGz1M2G0tf6/H/1C7kfwtHCezbiG2LK6xDqXfMxRER6AVl0j0kBNQ5W7Jf8VWZcmKtM5gEk1qfz63eN4n3MivvA+Yo7YhlZ/m/02vGqYyiD8XHi+fZbR53/0OOPsRl0OWHKxhcgdrpxiPCusXMKEHEaUeXcOy3jxF+SJKR612JN20QtoZ0ykKbIHal0/k81XpV/emEj65zebZsDgI+kmbPFwnVukOcme7ed9Y5DknJCLv6tJKGRlDMXhtKcWcXcy/455H9mYMqdFtO1dzAWHqgBXM32zGIQEuXUO29Uz/j56g4Q7R/ojmz3fRJTwAD+iYdr/v4T2vwxUHY75xlq8ciYFe7gRuH2+Ve/nYuYCh9z8KkgrjnIMmkGtpfDKqLE6N8LAYd0NFmVCHuMYWtrL7e+ggZS243kWX4e7ecs2GLPpi/ovlXTD+nEw9b+I3qrJ7/BH1Hhzjn0KYtzmM88M/Tj8qYwhWiLhZcdR42ojw8k5xSqNn9YsVVy4ZWcQDWGPjqhkPlzPGgTiOlddTnjt1jrv3qr2377uxtB8FtCeFIWtf0q0tWQun94z1CHw7+2g77ULVf8jcCoYP2mnblN/aIcGxVm4yz+bgd+JmBsbEkkYbpsIvF3QrnbmOLRMLMsvDZ7IejTZ5JfW0+NaTQPGVMB/nW6VSVyPUykmZYsQHjwSd9GEP7gdTLY6cd6LrcUcockOvot
 Xe7vTUSC
 OITm3I7kWT0yUV4aGK9E1GBqrCv6qRBo/Uv8RrVDN7PtoYDXNRZplCV/6uNgdIbgNy59A48Cq95FtamWHm1L+N22ntSveZwn0MOlIz6NBBbrZHC2yNQdDr+OFQ1BYjgqFZgEVR2qfhp7L1llLNiBnRvoint0CZy7VofejVxfQxIoQCeD37uKSWzZbPfGY4Y9YpEja77SFCS6eDSDdx5hnR0qOtqAEGvwmDgIRkO6qrfkQL2kTlFGE+CB94eRaB8fJB6s+yFt35qCYH2NcXqJDRV+EUHY2vC6F+y1rbSxpmbFHGnX8/aPFSAQqkqBzJTxezLPDJ014ID22kkG6/yBmg+yHRQaaJBcat56MRvunEO+tdEhC7/Nly2NjKGpJDeIW5KBo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 10:19:53AM -0700, Shakeel Butt wrote:
> Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
> per-node type") split a memcg's single obj_cgroup into one per NUMA
> node, but the per-CPU obj_stock_pcp still keys cached_objcg by
> pointer. Cross-NUMA workloads now see a drain on every refill and a
> miss on every consume that targets a sibling per-node objcg of the
> same memcg, producing the 67.7% stress-ng switch-mq regression
> reported by LKP.
> 
> stock->nr_bytes are fungible across per-node objcgs of one memcg:
> drain_obj_stock() and obj_cgroup_uncharge_pages() both account via
> obj_cgroup_memcg(). Treat the cache as keyed by memcg in both
> __consume_obj_stock() and __refill_obj_stock() so siblings share the
> reserve -- eliminating the drain on free and keeping the alloc fast
> path in consume.
> 
> Though kernel test robot reported the regression but it was not easy to
> reproduce locally. Qi implemented [1] a specialized reproducer to show
> the corner case which cause the regression and then Qi tested the patch
> and reported that the corner case is eliminated after the patch.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
> Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> Link: https://lore.kernel.org/19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev/ [1]
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Debugged-by: Qi Zheng <qi.zheng@linux.dev>
> Tested-by: Qi Zheng <qi.zheng@linux.dev>

Pasting the sashiko review here as it seems interesting and good:

May 15, 2026 at 10:52 AM, sashiko-bot@kernel.org mailto:sashiko-bot@kernel.org  wrote:


> 
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] Fungible sharing of stock reserve bytes between per-node objcgs breaks the obj_cgroup_release invariant, causing permanent kmem charge leaks and WARN_ON_ONCE.
> - [High] Missing update to `__account_obj_stock()` bypasses vmstat batching for sibling objcgs, causing severe lock and atomic contention.
> - [High] Calling `obj_cgroup_memcg()` without required RCU or cgroup locks triggers lockdep splats on fast paths.
> --
> 
> commit e77fe5b6af93b69e06c1ccd13f83e26b59234483
> Author: Shakeel Butt <shakeel.butt@linux.dev>
> 
> memcg: cache obj_stock by memcg, not by objcg pointer
> 
> This commit modifies the per-CPU object stock caching to share the reserve
> among per-node sibling obj_cgroups of the same memcg, aiming to reduce
> drains and refills on cross-NUMA workloads.
> 
> Link: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
> Link: https://lore.kernel.org/19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev/
> 
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >  index d978e18b9b2d0..66448f4285316 100644
> >  --- a/mm/memcontrol.c
> >  +++ b/mm/memcontrol.c
> >  @@ -3210,7 +3210,11 @@ static bool __consume_obj_stock(struct obj_cgroup *objcg,
> >  struct obj_stock_pcp *stock,
> >  unsigned int nr_bytes)
> >  {
> >  - if (objcg == READ_ONCE(stock->cached_objcg) &&
> >  + struct obj_cgroup *cached = READ_ONCE(stock->cached_objcg);
> >  +
> >  + /* Cache is keyed by memcg; sibling per-node objcgs share the reserve. */
> >  + if ((cached == objcg ||
> >  + (cached && obj_cgroup_memcg(cached) == obj_cgroup_memcg(objcg))) &&
> > 
> Does calling obj_cgroup_memcg() here trigger lockdep warnings on slab fast
> paths?
> 
> Looking at obj_cgroup_memcg(), it expects rcu_read_lock_held() or
> lockdep_is_held(&cgroup_mutex) to be true.
> 
> Since this function is called from slab fast paths where only the local
> CPU stock lock is held, the RCU read lock may not be held.
> 
> Could this check directly compare READ_ONCE(cached->memcg) and
> READ_ONCE(objcg->memcg) to avoid the lockdep assertion?

Yes, this makes sense as we are not really dereferencing the memcg here.

> 
> > 
> > stock->nr_bytes >= nr_bytes) {
> >  stock->nr_bytes -= nr_bytes;
> >  return true;
> > 
> Will sharing the reserve between per-node sibling objcgs without updating
> stock->cached_objcg break the page multiple invariant in
> obj_cgroup_release()?
> 
> If an allocation for objcg_B consumes bytes originally funded by objcg_A,
> and the stock is later drained, those borrowed bytes are flushed into
> objcg_A->nr_charged_bytes.
> 
> When obj_cgroup_release() is invoked, nr_charged_bytes will not be an
> exact multiple of PAGE_SIZE. Will this trigger
> WARN_ON_ONCE(nr_bytes & (PAGE_SIZE - 1)) and truncate the remainder,
> permanently leaking the page charge from the memcg?

This is actually a very good point and need more thought.

> 
> [ ... ]
> 
> > 
> > @@ -3318,6 +3322,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
> >  unsigned int nr_bytes,
> >  bool allow_uncharge)
> >  {
> > 
> [ ... ]
> 
> > 
> > - if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
> >  + cached = READ_ONCE(stock->cached_objcg);
> >  + /* Same memcg: bytes are fungible, no drain needed. */
> >  + if (cached != objcg &&
> >  + (!cached || obj_cgroup_memcg(cached) != obj_cgroup_memcg(objcg))) {
> >  drain_obj_stock(stock);
> > 
> Since the stock->cached_objcg pointer is not updated when a sibling is
> already cached, does this bypass the vmstat batching in
> __account_obj_stock()?
> 
> If __account_obj_stock() still requires strict pointer equality
> (READ_ONCE(stock->cached_objcg) == objcg), alternating cross-node
> allocations will continually fail that match.
> 
> Will this force a fallback to direct mod_objcg_mlstate() updates on every
> object allocation and free, causing severe cacheline contention?

This is not that worrying. Yes, the stats update will take slower path. This can
be fixed when we add multiple objcg per-cpu stock.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260515171953.2224503-1-shakeel.butt@linux.dev?part=1
>


