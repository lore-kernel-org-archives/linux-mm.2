Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF2A0EFB806
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 06:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52006B0088; Tue, 24 Feb 2026 01:51:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5406B0089; Tue, 24 Feb 2026 01:51:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D44C6B008A; Tue, 24 Feb 2026 01:51:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 750596B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:51:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A368E1B67EA
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:51:41 +0000 (UTC)
X-FDA: 84478429602.06.B72933B
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id A2395100003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:51:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p0HhqgO5;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771915900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wL0cOnmJMhg9IShRfsDtR2P4Agh9WQYIhyu2eoIwvjg=;
	b=g/0qZCC6lmNa0PD/BWtHOJzMirrIfnlTVPQM8D3Kbg2NrJ5YWwHhuXoUR5nAr1uFXX1Uqc
	EZxbsU3D9pssx/6iIxXU3hz9zEqPQ4J+alczHAbW1F7IenkWAGoxlijf0XPmnAFbgfpK3U
	thop0JZAeNzp2HkL+DP4UMFSIU3/J5Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771915900; a=rsa-sha256;
	cv=none;
	b=dI7crVERTIPH4ff978T0CVil8KoOlPwmqo/xnIyE4D9rtq5rp4fQhnxLnr4vcqbWR5Eulq
	CXBxSa6rkM5BWJQqGUqZiYBreg2zjqs1mS/lyeYzos5zcuiekg3w8MXuwGYCG948fFSBRe
	G9xKSrcHc6K4amPsJdivyaitNC+c7HE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p0HhqgO5;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 24 Feb 2026 14:51:26 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771915897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wL0cOnmJMhg9IShRfsDtR2P4Agh9WQYIhyu2eoIwvjg=;
	b=p0HhqgO5dg1k9LXHplOqEs+tFh+vkPP1zGHNp6Aj4iPU5rCPKtvUfUThRlnWgFiXz0SNV3
	rhfRiNw7C9gNRKhOiNbQHtbm5W9FMfc6HdP73fpTSAvq7/lEb8le0Q0R+0CqFXR9QVU1hZ
	QmdLlmdhIwObmZMIBnz3KEAnSD3KRPs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Ming Lei <ming.lei@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <wprja2flkybpsmdpnihtxp4usbl4fdsayarg4sitnyn3leis5e@vdqas3zhqndw>
References: <aZ0SbIqaIkwoW2mB@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZ0SbIqaIkwoW2mB@fedora>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A2395100003
X-Stat-Signature: nra95axmyzw84wcb7fiw18xen9qtf4tr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771915899-215436
X-HE-Meta: U2FsdGVkX1/N7etVzu5oDfTd4UerSZtkdWIjAzpn05ZB5fmhN62y5yDtBOFHcnbJW/A2aTdlTV8K1Np+8ztPmQvWPADvSx5g4WtAkGpqW0U5AepRbgkfzW4Qo9Fsq8DCuqX+FhAMb8uq2FzBixllx8Cix1jENMLe7YINGQ/5eDTcP/Kn503ElceE2r87lmAk9evqqnMJhQFne0S6C7ElYu4xzw9WP1as8vKCmtTgE6UQSR+O9iev6JpzzZsCpCez5PfWWC4/Ba5UXqSJkXdOxjZb8GCMbCxgIxF4ssZzua766eLnAnU8IKGH1psdwUSdeK2yLFmrd0eHDPRBg08fXYN2T8Q51J9f0NU33rbmV4LAB7Q+/c12xHggfBLFM4S7gkXBHv4+jRIyMrPJPNMXFH2jQlCvoEEcGaOas8lES1/V6gBb26zS+sGvJyJvPpFM/lJ6gT1A31903VjGWdxYvUXqUjFRiW2l51D18whJf9ZZM8QuZD+CQkP/gE11r7R3DGRA38fzEWWzQI4YqjLU/PX9sMi8f7TsusF0yZZss+CP10Q5FIaclEYb5p92abeUguLvQ/BMNcLLodvhZr4xrhaFQZKVQhd4IBriL2pEdLgQlPZea7p36rlf1LBoWmss99GtmipTRjU7foMGe7PO/7y3KdEyTRRowfINPsPJRHQyWHCEg/xUFKKMszqTB6lE4bAVxiJzPFcfcE8xj1odVmFOkogCXHBt/h/0uHJcaYY8falOws3gSthavlkB8Iz/zESX/sLJgmmctrluDeJ7aaO0t8yoqrFFsqMLYmLCB3/NZkLakulVfGY6HoBAtnd6Pkx6eP5UquxvYXarEW9jY2YyeW0ZW5C2F6GDtgsCzs22ot3bnkOYYJ3j4QE570UkT5tw6JpOCeX+ogkqHnE2DibgkYLYKSsrGuFwHpgETa4JYsMfrI1pa9IpgkVriT3O/uLHVAX8JXPdvrhp4uX
 ROKf0m5a
 BDr/VNQUCF6B8ML6XzAP8yzI77KuPqAiFxpUA6P7mXfK4XJ4zmg7xnLbOWuS+YbM55jISCXcmpk5VAu+xta0nCX1Q1un87etynCIQsM7FVvvRd7tkXQcIxoovNApA+y0jv2mzQxiyA/7ONb53lCvLZE5v3fbSV7zg6UmyVNNGpwLHpkxRPQDXAYx/tFtPX0Owh7MYGBDtBHMNPLr6geIH6884Yf5F4a9BUOWazRnLOYz/EQsZgj4Yk+HFpmGjrVxMeMPk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 10:52:28AM +0800, Ming Lei wrote:
> Hello Vlastimil and MM guys,
> 
> The SLUB "sheaves" series merged via 815c8e35511d ("Merge branch
> 'slab/for-7.0/sheaves' into slab/for-next") introduces a severe
> performance regression for workloads with persistent cross-CPU
> alloc/free patterns. ublk null target benchmark IOPS drops
> significantly compared to v6.19: from ~36M IOPS to ~13M IOPS (~64%
> drop).

Thanks for testing.

> 
> Bisecting within the sheaves series is blocked by a kernel panic at
> 17c38c88294d ("slab: remove cpu (partial) slabs usage from allocation
> paths"),

As Harry said, this is odd. Could you post crash logs?

> so the exact first bad commit could not be identified.

Based on my earlier test results, this performance regression (more precisely, I
suspect it is an expected return to the previous baseline - see below) should have
been introduced by two patches:

slab: add optimized sheaf refill from partial list
slab: remove SLUB_CPU_PARTIAL

https://lore.kernel.org/linux-mm/imzzlzuzjmlkhxc7hszxh5ba7jksvqcieg5rzyryijkkdhai5q@l2t4ye5quozb/

> 
> Reproducer
> ==========
> 
[...]
> 
> the result is that the allocating cpu's per-cpu slab caches are
> continuously drained without being replenished by local frees. the bio
> layer's own per-cpu cache (bio_alloc_cache) suffers the same mismatch:
> freed bios go to the completion cpu's cache via bio_put_percpu_cache(),
> leaving the submitter cpus' caches empty and falling through to
> mempool_alloc() -> kmem_cache_alloc() -> slub slow path.
> 
> in v6.19, slub handled this with a 3-tier allocation hierarchy:
> 
>   Tier 1: CPU slab freelist         lock-free (cmpxchg)
>   Tier 2: CPU partial slab list     lock-free (per-CPU local_lock)
>   Tier 3: Node partial list         kmem_cache_node->list_lock
> 
> The CPU partial slab list (Tier 2) was the critical buffer. It was
> populated during __slab_free() -> put_cpu_partial() and provided a
> lock-free pool of partial slabs per CPU. Even when the CPU slab was
> exhausted, the CPU partial list could supply more slabs without
> touching any shared lock.
> 
> The sheaves architecture replaces this with a 2-tier hierarchy:
> 
>   Tier 1: Per-CPU sheaf             lock-free (local_lock)
>   Tier 2: Node partial list         kmem_cache_node->list_lock
> 
> The intermediate lock-free tier is gone. When the per-CPU sheaf is
> empty and the spare sheaf is also empty, every refill must go through
> the node partial list, requiring kmem_cache_node->list_lock. With 16
> CPUs simultaneously allocating bios and all hitting empty sheaves, this
> creates a thundering herd on the node list_lock.
> 
> When the local node's partial list is also depleted (objects freed on
> remote nodes accumulate there instead), get_from_any_partial() kicks in
> to search other NUMA nodes, compounding the contention with cross-NUMA
> list_lock acquisition — explaining the 41% in get_from_any_partial ->
> native_queued_spin_lock_slowpath seen in the profile.

The purpose of introducing sheaves was to fully replace the percpu partial slabs
mechanism with sheaves. During this process, we first added the sheaves caching
layer and only later removed the percpu partial slabs layer, so it's expected
that performance could first improve and then return to the previous level.

Would you mind also comparing against a baseline with "no sheaves at all" (e.g.
commit `9d4e6ab865c4`) versus "only the sheaves layer exists" (i.e. commit
`815c8e35511d`)? If those two results are close, then the ~64% performance
regression we're currently discussing might be better interpreted as returning
to the previous baseline (i.e. a reversion), rather than a true regression.

The link below contains my previous test results. According to will-it-scale,
the performance of "no sheaves at all" and "only the sheaves layer exists" is
close:
https://lore.kernel.org/linux-mm/pdmjsvpkl5nsntiwfwguplajq27ak3xpboq3ab77zrbu763pq7@la3hyiqigpir/


-- 
Thanks,
Hao

> 
> The mitigation in 40fd0acc45d0 ("slub: avoid list_lock contention from
> __refill_objects_any()") uses spin_trylock for cross-NUMA refill, but
> does not address the fundamental architectural issue: the missing
> lock-free intermediate caching tier that the CPU partial list provided.
> 
> Thanks,
> Ming
> 
> 

