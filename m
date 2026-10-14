Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C412CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07EA66B0095; Wed, 14 Oct 2026 11:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 055D26B0098; Wed, 14 Oct 2026 11:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE936B009B; Wed, 14 Oct 2026 11:45:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3C686B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:45:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 246B9A0622
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:45:23 +0000 (UTC)
X-FDA: 85321656126.24.DB89762
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7B22920008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:45:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m6lJhoYb;
	spf=pass (imf31.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791992721;
	b=4zFogMjKji5ciVzrzuNueh5rKOvwUpD2AVU8Lb4bp6DcrtyJXQMeBqcCBLDcvVI8WSSyZK
	A1e3+6I7gIXNn9g5bzgOdVh9lkMXo8ni/qwsXJRNYsaDorJfnPzliSCdrpeV4Ji4O3rZ8i
	KXcI79sIPMag9Zbb7MAtzvktdqAA99Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m6lJhoYb;
	spf=pass (imf31.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791992721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CKsvn5/mex49XJDPJGQYYFFebPfyHMGW+J5OfBAf2Y=;
	b=fGkkFiYtpHRCUPKTbA7Sghz7QJ0dBvGZuJoF/AA3JLpXcRj3d8YPkMxfg3HFKB8R5YaTmK
	Yd9eIE77NiSD2K82lOiA0OeNoYHgJz8lo5qd12Z0/9yhHXeGhICZpcglTwhtXuuAfzjTml
	P9re1g/zyvMwUJL/ipJfF1Kf/QK+hcA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EA134118D;
	Wed, 14 Oct 2026 15:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1115C1F000C4;
	Wed, 14 Oct 2026 15:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791992720;
	bh=8CKsvn5/mex49XJDPJGQYYFFebPfyHMGW+J5OfBAf2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m6lJhoYbS0mrwh34mwo41hcZ3ABbTS5dPXhJg2elGFJaUejLR8bBgcjaCO6EFqFSw
	 tiUPE++o2isIZK5AY87SGks9Qh9YE0GNF2Z3meLiZlDQhEVZWKP2n7ZH0L9DTzZDSG
	 jmy+/S5Rknb+lLh5dST2ltTazZ9FNQYVWzaqzyntAIRjVpI+qU/Jcj8yPg0P5XB/FS
	 dbsduDm1t6NtXUUpOH9nmqPLA8rFeiQHTTZrX7H56p9sMnslBbqRrTGNWU8n4RwpZ0
	 oL8YKAbLdd15q3CPNvH9MlejwCqEJfMvac5EXRAMZVPuQ5qD+I5baDrl1IQ08hpSHn
	 8wcHYqwHqPqtg==
Date: Wed, 14 Oct 2026 15:45:18 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
Message-ID: <as-jZopKRfuYAiTE@google.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7B22920008
X-Rspam-User: 
X-Stat-Signature: oo4oyynzr5f5xf9um6onya6kpeh6t6m6
X-HE-Tag: 1791992721-261265
X-HE-Meta: U2FsdGVkX1+2Xe/yxE/vqVJ4eUx2yPzDgX3S547TmTiETjuxlkKCcx2/l8qifuqVW03+AjrZTQLxq0n3Qd0Ci1D5Avr4SaiBRMd2idf6fiK1TGTNeraQ+fMHj8b+3Yx8KznbvYmLRyCr80RzsPnEJsL8+dIhviLs5757HT3EngUcxqxceu0gJ6cPU7Cby794XwYVioPPpbvUtpVY6QlMqaN0kuD67O56Nix9dU8Ohfbw62qTuY5ocQfg+pnTL4ERjl2qpY2lNHoqabWgrkw+O4jXdx0p8NICsmg6u3vvOehssYQaZ7dH0wmaMHY+tXMnL30ZEVnGYwb2oFa+A1n1uh+Laib+2T9a6roB/NDojg2NViTkeSQtFLJQpROYEzHgQP1rLd+fV3WS2vCF9M28a1RFcsdIdoDmh0oK+BdNq2AVKt6ISHrTjKKAun/+S4F7AfbiV20fWrD7SVd3ohTb+GfL7xIXcLsstn8Pny5ZW0MOX34MvJ3HB7RNSrwnV1KZfCEB697erZ/6RZw2j1mSVaz59TlK94+rCzibIURQpwMRSY2uLhwzIj4kFUyRNzuAPo0OBHA88G4ICnj7bjgIH8J6fFMCBUlVmabCjbs4rzeuO1658uWTlWPEbJK2vxKSOCIWaLT03JiH8NdnrS718oZgquETCb9p+zjlfmjFIY+ggcM4SMPaV6zYi+MqBqrVpoXzdZxIIhS9oUJjtX3TaG1KSt79pLFVujD8f37Y+jR+6/qp147+r4a2TKwZhKvZxXzeyKjFEMB0cmso2Lek9+3vZ9odjHwQV9oWApBHKdKRh3Fddu4TJTAySb04QBdvqXVOGCFaiOqWTGCBJzAWjpGC8EjbaIWHc9mGf5FFQOKAJJXoUS7IgFnaFkPNj9iJ4UvRv9mp9mn6cjnWNCwEiThLZmN36iqoLZHmXskE4tGzT2Ndp1Ao3LEcUGN+Id5TBDgUGRZSnWGwHJX1oqI
 c3AD3Phm
 kzq3Irn5ijRhVhfAEy6nCYWyw77JfBqoGk1QDiRhlnk0/RXEp/vV1jw7KEBPIOAIUpiSb9LJd7sr+1EoMsFMs0AtgWbXppaSLDWKAQJemS8m9Bpm3X9GE9dRscKCW2NlD5W1LvdZx0LpEwY1nnV5Xw/tGRCfdXnfHxIn28cTwuEJuu4PjAgb1qBrHreHpZdIst2RBqyJRoKkS51KqeJ9nZY6cHzamO4F+XKVbW+QnN34KukPGllSMMjKe9oRi+Mmwo+IxjXjh8tz7xeBvwOKbjiotZ0EaJW4t+3710q7a0OslcCrMCqy8iKgr5fK5A9OgGZs/hzePxrkks6FkqCbX7pe97yHQOp6muQbkh8Ro+TqrPysMIwPQ9gcWwUwihSqoAFVelPGw6mRCs7prVF/mGLkRg2cLg3DgFuzATwD/xaCedOIhlxv/ZkMNN2fQP6E/9SC44IkWVBJ3P0I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 08, 2026 at 11:28:06AM -0700, Kanchana P. Sridhar wrote:
> v1: Batched zswap_store() with compression batching
> ===================================================
> 
> This series is a spin-off of "v14: zswap compression batching with optimized
> iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zswap
> compression batching enablers. Resuming work on this series following a gap
> since v14 (January 2026). Please note that my email address and affiliation have
> changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail.com. I
> have retained the original Intel sign-offs on prior patches for historical
> attribution while signing off v1 of this series with my current address.
> 
> To summarize the main contribution of this patch series: Batching is introduced
> in zswap_store() of large folios: we carve out a large folio into batches of
> ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store each
> batch. Moving the fundamental operations that need to be happen to store a page
> to now work at the granularity of a batch offers opportunities to optimize them
> from these perspectives:
> 
> 1) Utilize existing kernel API that minimize obtaining locks for bulk
>    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> 
> 2) We keep the working set for each of the core store functionalities (alloc
>    entries, compress pages, store pages in zsmalloc) to be focused on a
>    batch, thereby minimizing cache evictions and benefiting from cache
>    locality.
> 
> 3) Along the lines of (1), the main zswap_compress() batching routine obtains
>    the acomp_ctx mutex lock once per batch, and releases it after it has
>    processed all pages in that batch.
> 
> 4) Any zswap store functionality that works on a batch can potentially be
>    parallelized as a next step, to further improve performance.
> 
> Performance data: usemem with 60% over-commit:
> ==============================================

How much of the performance benefits come from patch 6 vs patch 8?

> Validation was done with mm-unstable as of 10-3-2026 (Baseline) and with this
> patch series.
> 
> Testing was done on a Chromebook with a QEMU "vng" VM running in Crostini.
>     
> Chromebook Diagnostics reports:
>   Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
>   RAM: 16GB
> 
> vng setup:
>          Memory: 7G
>            Swap: 3G
>     Pinned CPUs: 4 (E-Cores: 4,5,6,7)
> 
> zswap compressor:
>   ZSTD
> 
> mTHP enabled:
>   64kB
> 
> vm-scalability/usemem setup:
> 
>   cgroup memory.high: 3G
>   4 usemem processes, each allocates 1200M anonymous memory, reads the
>   Silesia dataset [2] from a pre-fork-allocated buffer into the 1200M,
>   writes to each unsigned long in the 1200M, sleeps for 10 sec, then
>   frees the memory and exits.
> 
>     usemem --read-silesia -w -O -b 1 -s 10 -n 4 1200M
> 
>  usemem metrics averaged across 10 iterations*:
>  ================================================
>  
>  --------------------------------------------------------------------------
>                                           Baseline       Patch     Change
>                                        mm-unstable      series       with
>                                          10-3-2026          v1         v1  
>  --------------------------------------------------------------------------
>  Average Throughput (KB/s)                  11,794      17,810    +51.00%
>  Total Throughput (KB/s)                    47,179      71,242    +51.00%
>  Average Time to Free Memory (usecs)       490,973     294,920    -39.93%
>  Total Time to Free Memory (usecs)       1,963,892   1,179,682    -39.93%
>  --------------------------------------------------------------------------
>  * vmstats are as reported at the end of the 10th iteration:
> 
>  64kB-alloc                                834,567     828,199     -0.76%
>  64kB-zswpout                              700,138     743,697      6.22%
>  64kB-swpout-fallback                       35,342      17,978    -49.13%
>  64kB-swpout                                     0           0           
>  --------------------------------------------------------------------------
> 
>  The speedup with zswap store batching of large folios has a propelling effect
>  on other parts of mm, especially, by enabling large folios to be swapped out
>  without splitting, as the data shows. This enables other mm components that are
>  optimized for large folios, such as munmap(), folio refcounts/mapcounts
>  updates, PTE invalidation upon freeing memory, zswap_invalidate(); which
>  benefit from xarray offsets/range continuity. As a result, subsequent large
>  folio swapouts are more likely to find contiguous swap slots, there are fewer
>  large folio splits during reclaim, more mTHP zswpouts and the cycle
>  continues. As the data demonstrates, this directly contributes to more memory
>  over-commit opportunity.
> 
> Detailed usemem metrics/cgroup memory utilization/vmstats:
> ==========================================================
> 
>  A) MAX zswap pool_total_size vmstats:
>  =====================================
>  This is a snapshot at the 10th iteration's peak zswap pool usage:
> 
>  --------------------------------------------------------------------------
>                                     Baseline             Patch     Change
>                                  mm-unstable            series       with
>                                    10-3-2026                v1         v1  
>  --------------------------------------------------------------------------
>  pswpin                                    0                 0
>  pswpout                                   0                 0
>  thp_swpout                                0                 0
>  thp_swpout_fallback                       0                 0
>  swpin_zero                              594               548
>  swpout_zero                           1,062               864
>  zswpin                           10,603,882        11,070,673
>  zswpout                          16,594,356        16,509,201     -0.51%
>  zswpwb                                    0                 0           
>  nrswpin                                   0                 0           
>  nrswpout                                  0                 0           
>  pgmajfault                        1,460,360         1,470,092      0.67%
>  nr_free_pages                       897,249           908,935      1.30%
>  nr_free_pages_blocks                892,928           903,680      1.20%
>  64kB-alloc                          831,788           825,556     -0.75%
>  64kB-zswpout                        690,961           735,863      6.50%
>  64kB-swpout                               0                 0           
>  64kB-swpout-fallback                 32,982            16,545    -49.84%
>  64kB-swpin                                0                 0           
>  zswap_pool_total_size         1,420,120,064     1,377,210,368     -3.02%
>  memory.current                3,390,189,568     3,299,569,664     -2.67%
>  memory.swap.current           3,221,221,376     3,221,221,376
>  --------------------------------------------------------------------------
> 
>   B) STEADY STATE vmstats after usemem finishes:
>   ==============================================
>   This is a snapshot after the 10th iteration finishes:
> 
>  --------------------------------------------------------------------------
>                                     Baseline             Patch     Change
>                                  mm-unstable            series       with
>                                    10-3-2026                v1         v1  
>  --------------------------------------------------------------------------
>  pswpin                                    0                 0 
>  pswpout                                   0                 0
>  thp_swpout                                0                 0
>  thp_swpout_fallback                       0                 0
>  swpin_zero                              594               548
>  swpout_zero                           1,062               949
>  zswpin                           11,526,695        11,963,729
>  zswpout                          17,293,120        17,219,911     -0.42%
>  zswpwb                                    0                 0           
>  nrswpin                                   0                 0           
>  nrswpout                                  0                 0           
>  pgmajfault                        1,591,298         1,596,095      0.30%
>  nr_free_pages                     1,752,789         1,753,264      0.03%
>  nr_free_pages_blocks              1,258,496         1,240,064     -1.46%
>  64kB-alloc                          834,567           828,199     -0.76%
>  64kB-zswpout                        700,138           743,697      6.22%
>  64kB-swpout                               0                 0           
>  64kB-swpout-fallback                 35,342            17,978    -49.13%
>  64kB-swpin                                0                 0           
>  zswap_pool_total_size                     0                 0           
>  memory.current                      757,760           802,816      5.95%
>  memory.swap.current                       0                 0
>  --------------------------------------------------------------------------
>  zswap debugfs counters:                                      
>                                                               
>   pool_limit_hit                           0                 0
>   written_back_pages                       0                 0
>   reject_alloc_fail                        0                 0
>   reject_kmemcache_fail                    0                 0
>   reject_reclaim_fail                      0                 0
>   reject_compress_fail                     0                 0
>   reject_compress_poor                     0                 0
>   decompress_fail                          0                 0
>   stored_incompressible_pages              0                 0
>   stored_pages                             0                 0
>  --------------------------------------------------------------------------
> 
> 
> [1]: https://patchwork.kernel.org/project/linux-mm/cover/20260125033537.334628-1-kanchana.p.sridhar@intel.com/
> [2]: https://wanos.co/assets/silesia.tar
> 
> 
> Changes since [1]:
> ==================
> 1) Better cacheline placement of struct zswap_pool and struct zswap_entry
>    members for temporal memory access efficiency in zswap store/load hot paths,
>    while minimizing holes.
> 
> 2) Refactored the core compression batching functionality to a separate
>    __zswap_compress() function, which is called by zswap_compress(), as per
>    Nhat's and Yosry's comments. Hopefully this helps explain the outer "store
>    batching" zswap_compress() vis-a-vis the inner "compress batching"
>    __zswap_compress() distinction.
> 
> 3) The acomp_ctx is locked once and is passed to the routine that compresses a
>    batch, per the algorithm's batch-size. Similarly, the folio's node id and
>    writeback_enabled status are computed once and passed to the routines that
>    implement the different store functionalities, to save latency by avoid
>    localized recomputes of information that doesn't change.
> 
> 4) Moved the folio node id being stored in zswap_entry to a separate patch, per
>    Yosry's comment.
> 
> 5) Addressed the kunmap_local() issue flagged by Jixin He in the
>    IS_ERR_VALUE(handle) error path
>    (https://patchwork.kernel.org/comment/27095925) - thanks!
> 
> 6) Moved comments inline, per Yosry's suggestions.
> 
> Thanks,
> Kanchana
> 
> 
> Kanchana P. Sridhar (8):
>   crypto: acomp - Define a unit_size in struct acomp_req to enable
>     batching. mm: zswap: Set the unit size for zswap to PAGE_SIZE.
>   crypto: acomp - Add bit to indicate segmentation support.
>   crypto: acomp - Add trivial segmentation wrapper.
>   crypto: acomp - Add API to get a compression algorithm's batch-size.
>   mm: zswap: Store the folio's node id in the zswap_entry.
>   mm: zswap: Store large folios in batches.
>   mm: zswap: Optimally place members of struct zswap_pool, struct
>     zswap_entry.
>   mm: zswap: Batched zswap_compress() for storing large folios in
>     batches.
> 
>  crypto/acompress.c                  |  47 ++-
>  include/crypto/acompress.h          |  62 +++
>  include/crypto/algapi.h             |   5 +
>  include/crypto/internal/acompress.h |   8 +
>  include/linux/crypto.h              |   3 +
>  mm/zswap.c                          | 571 ++++++++++++++++++++--------
>  6 files changed, 528 insertions(+), 168 deletions(-)
> 
> -- 
> 2.39.5
> 

