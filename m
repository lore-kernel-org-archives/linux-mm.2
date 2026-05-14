Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94EDACD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 13:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45996B0005; Thu, 14 May 2026 09:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6676B008A; Thu, 14 May 2026 09:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0C7A6B008C; Thu, 14 May 2026 09:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AD0FB6B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:00:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F9A21C0DB2
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:00:42 +0000 (UTC)
X-FDA: 84766034724.17.6565B82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 44A2140017
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:00:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IRqPjVXD;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778763640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DWZK6tn0p1xoHisyYXDHu4gAczndYla3ytggBiUMz6A=;
	b=xIMNH14kwMyne09IJ5FTYrHlbFR/nS/KZWuiZqDbBMcirG3CAg91DW9s3qSQgJsaPngJMu
	cy9Q5/8I74GhO9P7BybfKata8BMyeor/2kP4Xkze5vmjmxhhD++3yildlNT/DlRR1lA6mH
	/RhSuDJ0QXYWFCwzaVAsXAJnQEQufPU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778763640; a=rsa-sha256;
	cv=none;
	b=T6axo6eVSAdxE17YWCSPxAw8SIgBxdHecbxk5BUpqfoDNkziJzWw9RijqnyctxHu/6zc/+
	dzAeIydKwTdaE+oV/BnZSCQh8D5Fl+JyvJ4LSaaFqBaWBGv//HpiG5MasNLsfRbuIQhnzj
	WTrSQwOpwLYCWbTssOp0nLXwVtyQk4I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IRqPjVXD;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A96843595;
	Thu, 14 May 2026 13:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C184C2BCB3;
	Thu, 14 May 2026 13:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778763639;
	bh=y+63E2ApBElpTrupNQOJ7GnljASd3GxnwbYuEUdT9D0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IRqPjVXDYNip0scBemnQXcCSA3FB1zpPZ9wLrCssrGqzAHMZdfWtYMKfxFmQv7pjY
	 X6lAMVPKY5OyYR98Z4+ASXv+mJo6PdM8fSu8174vpY6+H3hT4UIWrZjuRlY5wmdNS6
	 VQTmKmtRYox1kywc5BYZ9FHx0fzVaMFyCUk+WgW9Gto8SSYCmblMjP2OgXUNT0VY8P
	 CpRuXQtfG4wQH8zbzSNZJhtSi8lrbRdxoKqrt2BYbBpvc+TttPqo4U0CXvQLyiQksY
	 HQwu76lOcTvVe8wanDVficAF0Y3wb2XTMkDVPSIK7DotnISkD6W+A4//OJEqtiEh3L
	 24uHP7x28k7GA==
Message-ID: <2e78296b-7783-4303-9a88-16f154d0bed7@kernel.org>
Date: Thu, 14 May 2026 15:00:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: hold cpus_read_lock around
 flush_rcu_sheaves_on_cache()
Content-Language: en-US
To: Qing Wang <wangqing7171@gmail.com>, harry@kernel.org
Cc: akpm@linux-foundation.org, cl@gentwo.org, hao.li@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
 roman.gushchin@linux.dev
References: <dpowyf5xneyg36lp25flxyjfy6dhijje7qy6z4sa7q5jpwp23d@uht5ja2rmfng>
 <20260512035035.762317-1-wangqing7171@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260512035035.762317-1-wangqing7171@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 44A2140017
X-Rspam-User: 
X-Stat-Signature: dcackmja3x1yqedroqwgss37gz9jh1je
X-HE-Tag: 1778763640-31454
X-HE-Meta: U2FsdGVkX1824zomhQwQudopU3HyY6+7/+KwGE91kTed5e/fx1bUzOA+62w2SadeDqDKQiLgrBgzK04azn2ICELKT3vqCeGqYTraGFSwYaHwxYbtI4FmcWMlWYhFmxCKHZaIjHRXLtqEgToRClW7AMaSf8H9o2kWzYW17JgpMEUGIhhQwt1osyKVmG5RI6EtBwSZ5gPyhquVg2mxEwkQ4WgU/ZUVOfrVcDcw0Q/dkoCfUl9eG+3TjrndDpqAIt/p7d3vruPLCP9j61+TiMqSiXBFCqenFl75kVebSWYIAWedqdJPnwdfmWXsNTYJ1leOSdBV8L4DNnucxhgLyTuZjunCJD0mW103Y8F84jHDUhlnQ38pGqvz+CFrJIPmEkOOfJkOl5RDEkWiJlRxWrYcQlKChwysrSYSrk2LMSUC54ImW8rf0dqrFoICNmCP/c67jDpZU8eVVm2xXCw9oA9kh7eXG0sIiWjv05p1DslqHMPl6XFZNZyoEu2UdF+lFY8+fTU45uPBphNGDO5UyLQ3SstVv3Pyhtt72lMFkvf2C5i/7hS9M8s0x1r6g+bHDmrqGTg3MS25ZJrMEWEqVbLEq09QJmFmGFII8/r/GTm+G7rX7Hau7Uojg0x9Pik8ASpGQ4S6t+zzZ5JvD4Qh4wH3KyQd/s0niO+Jg0vZoOctc75O8peIXn+NDtUt6cNaF43ZfIvbiPBjh/9HKZgNlScSnaLcqHcbpzN9E84gHcfIRiBCGBECjyEFyg0GWZW8+OmNVJT2BUoOk8UV3Hd2FhAsznNk+5T80EW5cQBVedFrEIqmJ0eFMwndQobHSWEXv5fHJq7uTTZ00sg+p6ONO1zph6X+tlIXi6Ba+ubM7whci9pVAW695HQ5fNcxbI3V9D/fTLXcBZe170Y6bOyB8aAtkwb5vIHkCZhXv5MhKwzvSv+L32PNyxQptUdJJDRV2z6SFEy+6UTAOrz+RaTZA3f
 r2mIS9db
 7Zzdmo6cI4Ry4XrodCia8TmwBRADB5pO6HVk31gX32GAoqIcU+4Ff1xDquJFoAGTE7bjgYCVsHn2e1TikmR1kp6VrWfZO5d4hv+3bBczAWiaE3jVvSExzAbJUP9Nas4BRajJMasB6sWcLJGDrPadRCtze1LoHmZ/B2TT7XKFe+AfTPVHQsQQvALdjEG/7UYmSYOm0+O/jx3zvg7itHH9cLvnuo5CZG9/PzqDOOXLFj8gKD18D+s/a80S6NAAQoPsyJB032Q02XvGQiqv7Gck4w0f31KM8F5ei5JYqvcen8fu/uxEzTNnfXGHDLvKMYuPeT7Qb7eW7fwO2dHc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 05:50, Qing Wang wrote:
> flush_rcu_sheaves_on_cache() calls queue_work_on() in a
> for_each_online_cpu() loop, which requires the cpu to stay online.
> But cpus_read_lock() is not held in kvfree_rcu_barrier_on_cache() and the
> set of "online cpus" is subject to change.
> 
> There are two paths that call flush_rcu_sheaves_on_cache():
> 
>   // has cpus_read_lock()
>   flush_all_rcu_sheaves()
>     -> flush_rcu_sheaves_on_cache()
> 
>   // no cpus_read_lock()
>   kvfree_rcu_barrier_on_cache()
>     -> flush_rcu_sheaves_on_cache()
> 
> Fix this by holding cpus_read_lock() in kvfree_rcu_barrier_on_cache().
> 
> Why not move cpus_read_lock() from flush_all_rcu_sheaves() into
> flush_rcu_sheaves_on_cache()? The reason is it would introduce a new lock
> order (slab_mutex -> cpu_hotplug_lock). The reverse order
> (cpu_hotplug_lock -> slab_mutex) is established by
> 
> - cpuhp_setup_state_nocalls(..., slub_cpu_setup, ...)
> - kmem_cache_destroy()
> 
> The two orders together would form an AB-BA deadlock.
> 
> Finally, add lockdep_assert_cpus_held() in flush_rcu_sheaves_on_cache()
> to catch the same problem in the future.
> 
> Fixes: 0f35040de593 ("mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction")
> Signed-off-by: Qing Wang <wangqing7171@gmail.com>

Added Cc: stable as Harry suggested. Applied to slab/for-next-fixes. Thanks!

> ---
> Changes in v2:
> - Deleted the unnecessary comment.
> - Added "Fixes" field in the commit message.
> Changes in v3:
> - Deleted the unnecessary comment.
> 
>  mm/slab_common.c | 2 ++
>  mm/slub.c        | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index d5a70a831a2a..8b661fff5eed 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -2110,7 +2110,9 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
>  void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>  {
>  	if (cache_has_sheaves(s)) {
> +		cpus_read_lock();
>  		flush_rcu_sheaves_on_cache(s);
> +		cpus_read_unlock();
>  		rcu_barrier();
>  	}
>  
> diff --git a/mm/slub.c b/mm/slub.c
> index 161079ac5ba1..2a005d1e3a74 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4024,6 +4024,7 @@ void flush_rcu_sheaves_on_cache(struct kmem_cache *s)
>  	struct slub_flush_work *sfw;
>  	unsigned int cpu;
>  
> +	lockdep_assert_cpus_held();
>  	mutex_lock(&flush_lock);
>  
>  	for_each_online_cpu(cpu) {


