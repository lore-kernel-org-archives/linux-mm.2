Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3104C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 09:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B28C6B0088; Wed,  8 Jul 2026 05:11:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716396B008C; Wed,  8 Jul 2026 05:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604566B0092; Wed,  8 Jul 2026 05:11:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DAB66B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:11:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2EEE1A06E1
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:11:02 +0000 (UTC)
X-FDA: 84965039964.08.865B745
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D443B10000B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:11:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jzKzjmpr;
	spf=pass (imf05.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783501861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dW8sOSS3FdbEHsIw7SmlY+a62m8HNpwrJ4kN8Xbnhvo=;
	b=nvEEhSXurGQvK+cW2F/1HIcXloFZH5M8cGYQbF6N9mcJe6h903xyg0uFHMi7gDwHyro+1O
	M3fhM5NWRd/ujCvpj49Y4CnZlh5HPfqrxuvkoSCPs8z4MAZWpZkpbPt1CmVUNLX/EbDTx2
	+ry6iwJnLmxWoOytlBbrWA1kBrneUZQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jzKzjmpr;
	spf=pass (imf05.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783501861;
	b=8rUtk5LHq9Q3PDXvxl2j1iUd6K7kCv2kz+G6UTxOO1/OexwqNe2rX9WYdSEj7+ckZSqQ8L
	TawaAxYmBxUhCg71iglX6tlva9M/9LA6fQxLAF3EjcPo84tKWmsZQ6f26R4P4UUEWNcJFF
	sNvpCDh1xoLCTGdGb/UMJqkHxzyYIAU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 17FCB43714;
	Wed,  8 Jul 2026 09:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94FD1F000E9;
	Wed,  8 Jul 2026 09:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783501860;
	bh=dW8sOSS3FdbEHsIw7SmlY+a62m8HNpwrJ4kN8Xbnhvo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jzKzjmprrtAOmJenR33gNI8QcTeXaSiCijAPzz7I5lb1f9acyW1+/Nb7SRI9gMcUS
	 lfrVrHRC5RmFWHThkB8JCysrrMXx0clTrSR4TiZiGDXe0yUv8md52iHmmiVZ4l2RLv
	 2wdfiiaNOl+K29l0kxbYVLYUS/S6t44oNd5rt9twDSUnQOzi+0Bf14YUfoSO/NC12J
	 RiHiyv/WxSUR4wCdE/yrOOnbZpoUhiTVBqoGQc4psjGI28t7uacHbLEMPoy7jAgSSg
	 2qIAhOe3Yp6GZwV8Mdk9FPble5wDFSDAHx7OXwnX9WYS/LhY8dtwqMDXoV8kcIxZJg
	 EckozkOO6YhIA==
Message-ID: <6ecf5579-0b3b-4e8c-a625-bbf0a4a48f94@kernel.org>
Date: Wed, 8 Jul 2026 11:10:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in
 zswap_shrinker_count()
To: Yosry Ahmed <yosry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Yunzhao Li <yunzhao@cloudflare.com>, linux-mm@kvack.org,
 nphamcs@gmail.com, yosryahmed@google.com, shakeel.butt@linux.dev,
 akpm@linux-foundation.org, zhouchengming@bytedance.com,
 James Houghton <jthoughton@google.com>,
 kernel-team <kernel-team@cloudflare.com>
References: <20260702180908.150136-1-yunzhao@cloudflare.com>
 <akbHBZP9HxOJMtQB@cmpxchg.org>
 <CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D443B10000B
X-Stat-Signature: 9zkk5gbkztz9d76atudf9z8jg9hgo7ho
X-HE-Tag: 1783501860-552414
X-HE-Meta: U2FsdGVkX18Tgd43mx38i1AGLIpc/o1nWg8UEM4lu0CcxW+T9vfZ9M3xywTADP6JZSmIgMDH5TNIop5tJujWKii+zfhCmmYerxUYX2RdJZfnDcniLAcxCkcxPEzQjAoFuunLZg94ebZr8vUJC5BCHlnZcqt9v6tQ0gjAUm6vqSKkZU1E0i37OiV15dJsCCLyG6yWRAWkIuNVzSNxdgX+dG4NwSHl9jC4AqikcXqRFePA5ZvEvNgc7D9QhmGNK/3y/FtHNbmQwb4ka80VNXld3j6dT8zBf67HoAkhAF51jnZmm3CEnHBMnQxrz5aPYEJrZ3PSNM+7tQWou4JofplUSAIIgx38lHRpy3I6IIRbbgOj6duC9lzG88ScnQ4gHrEOF+HsvCxs9EDVbHoUVOtdCXVcrpBqB19H6g9ALsG0hS19qj9ym3wmJ0YeRBGiayMBI1tkQS/z18hhjsvOGYH44I5AuW/DIDZI31ap/+Qox2YqDQlFrc+1A0A/KNfTSBKCwDeXSBPWxOXI09+cOs36JE1fSE5tNhiHDY+rVD9ptKb47oKamAream/SbVKG3pZz+lM3uIf8ZvcnaSSJFCDWKgNp5Jr6ksKuOrffxyhgtqp6+dsCSx7ff9VpwYUwP0uOYK6NVu1HCjqCsEOVr286UZ7mo95Y+bcyIH9wdeAbiMDJFjOVxNvcTxZtAjtTluvTcwq2Jwcn74H4nqTOLrXzNUnp3xYH6615LK+yeDczBg2/HxwOXGcqcLK9boQvmZTDfdSDkSsAq7rAHgEqfYvzbU6auNmxOa32I0nz3JG0un8Q6E0SvTpBKjtGgdQ4OWMLBJjfaIdjAlUtpkNPOgK4lCum2hggXOngkjH80eDihm/tm8oitWu4cM1KU8gJeS8fJZ+jw4s2662xz5pkCr1P0rkuZiC+cL1HEp+FN8pfBBe+wHsHRbbzyKWDjAZU/xTwlCCbGos9nyOyrFlPU87
 DWYvDTzc
 Hq5c+CZyAdomom1kU+9FH1zlUVDdZ7YOtwPgqILZ/e8POvEEke3LBZTz7O2jqb7wwnJN/4D1JaCNTRuMAaVICssCO2v/7ArJVkvOmLVeaXaqqI6kbGjMB3YuUp611THUdhQuW5+C/d8WfssyV+IRerIb/ZFjlwG6K1hkuVMIXt7XrDKKZ9ObxTNOVx4ZsNssfvmxQ0OelNQef33Km9nlysHMDQ+S8WDHc7oA0ibhu6HiE7wZmYLme1U3m1acAcv4ej6maKc3vkLKKPx4B9kOtCTRafYN/P/NTstjddj5AsEjdv0/3hVEdA50feGaLeWNepPJwWVIeDXLSM95JiaURpcqgsIsGgpCN1B797saAwkMNnF8G9KNo6NIxMp+NBC0x76IMlaafHUE7/gpCRc2skf7H4OOPlYqq2RGYJSZiiZmGXE8LnrNuUYUvl/ad3JxKTdOY4O3AlDqM0N2hZoe8KAWE0rmGbNoq9uVA6pNUOEOxl8eIIq6aII8BHVzxjmwFvW7X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/07/2026 21.46, Yosry Ahmed wrote:
> On Thu, Jul 2, 2026 at 6:01 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>>
>> On Thu, Jul 02, 2026 at 11:07:35AM -0700, Yunzhao Li wrote:
>>> zswap_shrinker_count() calls mem_cgroup_flush_stats(), which takes the
>>> global cgroup rstat lock synchronously. On machines with many CPUs and
>>> NUMA nodes, this creates severe lock contention in the kswapd reclaim
>>> path:
>>>
>>>    - Multiple kswapd threads (one per NUMA node) run concurrently.
>>>    - do_shrink_slab() invokes zswap_shrinker_count() for each
>>>      memcg-aware shrinker pass.
>>>    - Each call flushes the full cgroup rstat hierarchy under the global
>>>      lock.
>>>
>>> On AMD EPYC 9684X machines (96 cores, 192 threads, 12 NUMA nodes)
>>> running production workloads with zswap enabled, perf shows 2.88% of
>>> kernel cycles in osq_lock contention from this path:
>>>
>>>       2.88%  [k] osq_lock
>>>                --__mutex_lock.constprop.0
>>>                    --__cgroup_rstat_lock
>>>                        --cgroup_rstat_flush_locked
>>>                            --cgroup_rstat_flush
>>>                                --zswap_shrinker_count
>>>                                    do_shrink_slab
>>>                                    shrink_slab
>>>                                    shrink_node
>>>                                    balance_pgdat
>>>                                    kswapd
>>>
>>> 84% of kswapd kernel cycles are spent in
>>> shrink_slab -> zswap_shrinker_count -> cgroup_rstat_flush, not in actual
>>> page reclaim (shrink_lruvec).
>>>
>>> Controlled A/B on identical hardware and workload:
>>>
>>>    shrinker=Y: 2.88% osq_lock, memory PSI 1.58%
>>>    shrinker=N: 0.00% osq_lock, memory PSI 0.57%
>>>
>>> eBPF-based rstat lock wait measurement across 8 production metals
>>> confirms the contention splits cleanly along shrinker enablement:
>>>
>>>    shrinker=Y: 50-250x more contended lock acquisitions (248/s vs 1.1/s)
>>>    shrinker=N: baseline lock wait (0.0017 s/s vs 1.04 s/s)
>>>
>>> zswap_shrinker_count() only produces a heuristic estimate, scaled by
>>> compression ratio via mult_frac(). The actual writeback happens in
>>> zswap_shrinker_scan(). Slightly stale stats are acceptable here.
>>>
>>> Switch to mem_cgroup_flush_stats_ratelimited(), which only flushes if
>>> the periodic 2-second flusher is one full cycle late. This matches the
>>> approach already used in prepare_scan_control() (mm/vmscan.c) for the
>>> same reclaim path.
>>>
>>> After applying this patch, rstat flush latency and lock wait time on
>>> shrinker=Y machines dropped to the same level as shrinker=N controls,
>>> while the zswap shrinker continues to function (pool size remains
>>> bounded under the max_pool_percent cap).
>>>
>>> Previously discussed:
>>>    - Chengming Zhou (Dec 2023): rstat contention from
>>>      zswap_shrinker_count [1]
>>>    - Shakeel Butt (Aug 2024): zswap_shrinker_count still uses sync
>>>      flush [2]
>>>    - Yosry Ahmed (Aug 2024): suggested eliminating in-kernel
>>>      flushers [3]
>>>    - Jesper Dangaard Brouer (Sep 2024): cgroup/rstat V11 patch [4]
>>>
>>> [1] https://lore.kernel.org/linux-mm/20231206103935.3440502-1-zhouchengming@bytedance.com/
>>> [2] https://lore.kernel.org/linux-mm/CALvZod7LFxLCxVpOFH8b2Ppm8T40HPGMKQwX_=NPCWB_mFW+oQ@mail.gmail.com/
>>> [3] https://lore.kernel.org/linux-mm/CAJD7tkYvFyOSX+rP_FKGBhxvZiCDxtpsNp-c5CGOA-4Bq9oXSg@mail.gmail.com/
>>> [4] https://lore.kernel.org/linux-mm/172616070094.2055617.17676042522679701515.stgit@firesoul/
>>>
>>> Suggested-by: Jesper Dangaard Brouer <hawk@kernel.org>
>>> Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
>>> Signed-off-by: Yunzhao Li <yunzhao@cloudflare.com>
>>> Tested-by: Yunzhao Li <yunzhao@cloudflare.com>
>>
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>>
>> A lot can happen in 2s, but I agree doing this every time is
>> silly. vmscan has been good with 2s for a while, so this should be
>> fine as well. We can re-evaluate if we run into weird behavior.
> 
> Hmm actually we are starting to exercise kernels with the 2s change in
> the vmscan path, and we are observing some seemingly premature OOM
> kills for VMs under memory pressure. We are still looking into it, but
> I would honestly hold off on adding another ratelimited flush here. It
> may not be as big of a deal for the zswap path, but I'd rather fix
> this properly instead of just plugging it. We should probably move
> away from using rstat for zswapped/zswap_b stats and use page counters
> as we discussed previously (i.e. eliminating the flushes to begin
> with).
> 
> (Adding James here as he's looking into the premature OOM kills internally)

IMHO it doesn't make any sense to hold off on this patch.
This only relates to zswap path with shrinker enabled. Today we are
forced to run with shrinker disabled.

If you find some better approach to ratelimited flush, then that is
great.  You can change this code again for your use-case. No reason to
stall this patch IMHO.

--Jesper


