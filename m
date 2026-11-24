Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70D5D606A331
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 20:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M3+Z+FhH
Received: by kanga.kvack.org (Postfix)
	id 5A4926B0856; Tue, 24 Nov 2026 15:29:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556376B0857; Tue, 24 Nov 2026 15:29:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46AAB6B0858; Tue, 24 Nov 2026 15:29:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DFBF6B0856
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:29:41 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 460E8120C41
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:29:38 +0000 (UTC)
X-FDA: 85471153236.15.7CAC95C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8978920002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:29:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3+Z+FhH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795552176;
	b=wDoXTMjZ72wsdnqqgrgVQfRI9IHsEWjMAq6OdXwZIqfafoyHrx0sxra7ou7sSs553ry9G+
	EZtQenoXLsK325NqpcRMw9A/AbBGj7Fn4lJ5IhpemSZMLS2GTNvuK4LZ87gmIoSDiCyBYR
	RgOetK3n+GQQ93DZsEPNOXzBkp4BKJI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795552176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nCkPH/nN6u2NETiQD/6yq+D9xmbvirvIbqgwVplco7I=;
	b=fLQOeZmgDVnhGpkYAuvt/GQGzg4kUG1qDCOVFeoPNI5SOa9dZRK7b4rNwa0UIpknpZFUES
	7ClvafNJZGuOLTXtsR1fTpJg/GcKuWWgLPQZ33WuA9VbN88nIl5HXy2JSjN59SEegdwrV2
	rjjASZOVH3YaD+4COfTbsfNr4hBlzL4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3+Z+FhH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F17C061F82;
	Tue, 24 Nov 2026 20:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BE71F000C6;
	Tue, 24 Nov 2026 20:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795552175;
	bh=nCkPH/nN6u2NETiQD/6yq+D9xmbvirvIbqgwVplco7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M3+Z+FhH5f/923MHgrkI3rEoI+RLZdSjZh767QSe5JHNrJez3U8F7nmhPkn3rcMD5
	 KL7R3OPGccEfOThBmRcD7IdbUTGoQJp5kMfbMOMGzvyaVtJPAwjdiA4NM0fvwo7MvJ
	 EBtmE2rat7wrtXZpq2c61+96yfts6j4bKn0IO+KXDw9+DAIenlLZIk3F8VlZxkA4Zd
	 8d0VLhy103oXqKTH6MgCH01B3+FlPmIHwmKwkBL6ASqNeYe2gArz++OOZLRa3Ergs9
	 8Wq3ALMgrg8OtmXZbNoHO1Z89Un364pPQKslZdHViy/0/ue464PFlj/mM2z/WEzkmd
	 BfhqqAG17JrEA==
Date: Tue, 24 Nov 2026 20:29:33 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, 
	hannes@cmpxchg.org, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, rientjes@google.com, 
	willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression
 batching
Message-ID: <awXr6iHBR54wBB05@google.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: 6mfqatkhjicknh6idcgcjwyx8d4j9dx1
X-Rspamd-Queue-Id: 8978920002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795552176-316915
X-HE-Meta: U2FsdGVkX1+V6E20fYNFCr14yBfXPYQgBlCaJXMpmhqqS7Oxm9vzwyryUtSz/jGclWh5fydiOZBbREV/3xfMPWSItPPoY/6yzGDdwqSE/RAFlVY4wOu74z4I1TRjL40ggF7rSgeqV0qCKs1tq36rbe/94k5ldSX62KW4ik3CQECy9YuSFXlxGyJT/zI/N9x3tBR7gZg7OXoCu27pimN53nbmh72f8CbRRxw3WgLAQr7kqXbNp71m+9yXwMH6D4gSiZazsqsJE+rmGLOPbsqirw+gtUtO+ZSf4nyR6gZnM1s29d8cISGbh4qu7gfJRl2nOZFfw2IDFevzH42j9d+yJ1xm+me9CARqWLsZFnlYbynRdz4fy5ONa9uouOP7/Qu92AVRH4tWeXx/lInVbNX6okafXBGQZAW10AvkmM4jIVcDXFfFGWs7dJuRQ3JzHaQd+iwFUJBf/+dFZrohwsJpu1LyK83Iaz86nGjudedkAK8UhpPRZNCVHDSimRqiAANBxoGMgo+mjhJ1uEk51aGbZ04xpqq+VDwWnwk7VSEpcSXb3LC7kFw0oCv8hPLyudHoo78eiBb/LxZM8j7n9x6TVj2Q0GFLh4GbKpnQ4g2W+6LZzwkODJHsDR2lHeGHkKuNMDhdDrBEg58nqjTvEKrjKsMZcDJ3x/1f7YNS5JXTW0u8wxCi34LeLsNEVtfLzYrfrbPF/C2OVXSrSlv7KhtUpwg6rq4ZEh1TaSaiEIA7PKJ57NgIuU4DfsoIz3bZYoovrz8jO2H0KlhgAE+u4DgetJwTtNHKehowA+PUVDmmQ7e0n2A2JbgRHocsL6krpM+w8xSz2w3lDyCPn9TwkJ7FFHEz1lO7elfZzHvl3rEu0hLbioiWzwVXghTQbEjrxGylSyGSKDcEMN6DU8RdL3G2cPqCc+CIMq2ZNB9VKAUvY721E4wvzt2uGEx/YJ2sGvIsDcxF5GQ5OKjngyfUtfe
 uPSyikd2
 Lz+1vh9jQPluo+CkmkIJ41XRDEMy3qwlOLMivVLiZaD6A+yxW3GaU7WVYnLnGxd7uJloL8IdCg/VZ0iyGmDjyc5JQNOhd9Ru/odjUYeE1nmMgn3E/bWDHysplWCsXMqkxozRp8pJmJYJjrOnxJSaItMQFN+IsEMrHhNF2a6FNrwcnWlK4rnMFEDf0APhxXHbrMt3FQdbwQhoFe3bYTkkUEVq793PlZ0/4aFa1OyyvjKPeXPaICN49HsG6OEbtxh30CoHv4s+8l8B0r/PjdGsbh1ruuQ3rue1dI0jpRWuQ5LWKRjRqore936412K/pUDrXGH134tx7vun9KeqqY8SSdXPX65d3AHifWg7Y9m90MLMpQJS+iVMxVNNTzXTtxyLcM86PsUqNUqqr5HQnI5fL3tGpg2yrllWbhjwK4iYJtnv+d0SWmALa065J8DxYYkKrAdZGGMN63F25LwPC4hECz3j8Z1QTrxTV3VsT9fEfi00Xp7M4BR2obDM24pWWlX3Hppg664pi1d7FxV/dlYIWwSNvjgL+g5ZelaHNCkHJ2teqIJuQEwfdFFXSkFn/fj5sd7uAbqpyXftdjWXrCdOwr4mGGlCfxmhEv7QBsFb+jPKsTA39LYdqX6i7n/Ph6j+HzvYYihtWBCnbCSSvJXgF9PJ86tGHFsIcFr87
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 03:16:32PM -0800, Nhat Pham wrote:
> On Thu, Nov 19, 2026 at 8:19 PM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> >
> > v4: Batched zswap_store() framework with compression batching
> > =============================================================
> >
> > This series is a spin-off of "v14: zswap compression batching with optimized
> > iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zswap
> > compression batching enablers. Resuming work on this series following a gap
> > since v14 (January 2026). Please note that my email address and affiliation have
> > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail.com. I
> > have retained the original Intel sign-offs on prior patches for historical
> > attribution while signing off v4 of this series with my current address.
> >
> > The main focus of v4 was to establish a performance measurement methodology to
> > quantify the benefits to high level metrics by using zswap compression
> > batching. This was done using an Intel Sapphire Rapids bare-metal instance with
> > 48 physical cores and by running "usemem30", i.e., 30 concurrent usemem
> > processes, each of which allocates 10G, in a 150G memory.high contrained cgroup,
> > for 10 iterations. The environment was set up to minimize performance jitter so
> > we can understand the system-level/workload-level advantages of zswap
> > compression batching when running workloads at scale.
> >
> > To summarize the main contribution of this patch series: Batching is introduced
> > in zswap_store() of large folios: we carve out a large folio into batches of
> > ZSWAP_MAX_BATCH_SIZE (4 pages) for software compressors, and store each
> > batch. Moving the fundamental operations that need to be happen to store a page
> > to now work at the granularity of a batch offers opportunities to optimize them
> > from these perspectives:
> >
> > 1) Utilize existing kernel API that minimize obtaining locks for bulk
> >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> >
> > 2) We keep the working set for each of the core store functionalities
> >    (alloc/initialize zswap entries, compress pages, store pages in zsmalloc,
> >    pool/objcg reference increments, objcg charging) to be focused on a
> >    batch, thereby minimizing cache evictions and benefiting from cache
> >    locality.
> >
> > 3) Along the lines of (1), the main zswap_compress() batching routine obtains
> >    the comp_ctx mutex lock once per batch, and releases it after it has
> >    processed all pages in that batch.
> >
> > 4) Any zswap store functionality that works on a batch can potentially be
> >    optimized via bulk-processing/parallelized as a next step, to further improve
> >    performance.
> >
> > Performance testing: usemem30 with 100% over-commit:
> > =====================================================
> > Validation was done with mm-unstable as of 11-17-2026 (Baseline: commit
> > 866f761fd414) and with this patch series.
> >
> > v4 was validated on an Intel Xeon Sapphire Rapids bare-metal instance with
> > 48 cores.
> >
> >  Bare-metal instance specs:
> >  --------------------------
> >  - 48 physical cores
> >  - 190G RAM
> >  - 200G SWAP disk partition
> >
> >  Workload: 30 concurrent usemem processes, each allocates 10G:
> >  -------------------------------------------------------------
> >  The vm-scalability "usemem" test (unmodified version) was run in a
> >  cgroup with memory.high fixed at 150G. There is no swap limit set for the
> >  cgroup.
> >
> >  To quantify the performance benefit of zswap compress batching at scale,
> >  30 usemem processes were run ("usemem30"), each allocating and writing 10G of
> >  memory, and sleeping for 10 sec before exiting.
> >
> >   usemem -w -O -b 5 -s 10 -n 30 10g
> >   echo 0 > /sys/module/zswap/parameters/shrinker_enabled
> >
> >  Performance validation methodology:
> >  -----------------------------------
> >  These settings were used to minimize variation:
> >
> >  - All cores were fixed to run at 2.4GHz with "performance" scaling governor.
> >  - Turbo boost was disabled.
> >  - CPU power-saving C-states restricted with:
> >
> >      GRUB_CMDLINE_LINUX_DEFAULT="intel_idle.max_cstate=1 processor.max_cstate=1"
> >
> >  The usemem30 experiments were run with the baseline mm-unstable as of
> >  11-17-2026 (commit 866f761fd414) and with this patch-series.
> >
> >  After booting into each kernel:
> >
> >   1) Constrain the cgroup's memory.high to 150G.
> >
> >   2) Run 2 warm-up iterations of usemem30. Don't use this data for benchmarking
> >      since sys time typically skews higher for initial runs.
> >
> >   3) Next, run 10 benchmarking iterations of usemem30:
> >      - Log these high-level metrics: Sys time and individual usemem throughput.
> >
> >   4) Sys time and Throughput metrics were gathered for three mTHP settings:
> >
> >      - 2048kB
> >      - 1024kB
> >      - 64kB
> >
> >   5) Benchmark summary data includes Sys time and Throughput components from the
> >      10 iterations of usemem30:
> >
> >      - Total Samples
> >      - Mean Value
> >      - Std Deviation
> >      - CoV (Variance): Coefficient of variation (relative standard deviation)
> >        measures spread relative to the mean rather than statistical variance.
> >
> >  An LLM was used to help generate the benchmarking and data processing scripts.
> >
> > usemem30 Benchmarking Summary:
> > ==============================
> >
> >  ---------------------------------------------------
> >     Improvement with v4 zswap compress batching
> >  ---------------------------------------------------
> >   mTHP enabled:       2048kB     1024kB       64kB
> >  ---------------------------------------------------
> >       Sys time:      -13.87%     -2.64%     -1.72%
> >     Throughput:       +3.85%     +0.42%     +1.31%
> >  ---------------------------------------------------
> 
> Have you tried perf-ing the store path to see what was the overhead
> source (before and after this optimization)? I'm curious.

So I was able to reproduce the usemem30 sys/wall time improvements here
on a Sapphire Rapids machine (both in a VM and on baremetal), and I
threw my LLM at perf-ing to figure out what the overhead was. It's
important to note that the sys/wall time improvement I observed was on
the free phase, the write phase / throughput (which involves zswap
store) didn't show much of a change.

Batching made more consecutive pages that compress to the same zsmalloc
class more likely to land in the same zspage, so the freeing path gets
faster as the zspage and metadata are hot in the cache, which alleviates
contention on the class lock.

I think the memory allocated by usemem all compresses to the same class
size, which makes holding the class lock in the freeing path a
bottleneck. I confirmed this by a hacky patch to shard the class lock
into 32 locks, which caused the same usemem improvements and the series
doesn't improve performance anymore on top of that change.

I also tried usemem with Silesia to get realistic compression data
(similar to Kanchana's testing on previous versions), and didn't see
similar improvements (because the compressed pages get distributed
across multiple classes). I also tried a kernel build and the munmap
microbenchmark in [1] (which Sergey quoted in [2]), which also didn't
show improvements.

That got me curious tho, and I had my LLM explore other optimizations to
the freeing path. I think we can get similar improvements in usemem
as well as the munmap microbenchmark [1] by batching zswap entries
freeing. We can batch both the zsmalloc object freeing as well as the
LRU deletion. I am still looking into it and I might send out patches.

But I think this series doesn't really move the needle on realistic
workloads, as I previously mentioned. Regarding the bpftrace
measurements, I couldn't reproduce them. I think one factor is that
probing both zswap_store() and zswap_compress() makes the zswap_store()
numbers different based on how many zswap_compress() calls we make
(which are less with batching) due to the overhead of the probe itself.
When I trace zswap_store() without zswap_compress(), I don't see
meaningful changes in latency.

[1] https://lore.kernel.org/linux-mm/20261016120927.3191690-1-hongfengchen@xiaomi.com/
[2] https://lore.kernel.org/linux-mm/20261123054746.2579253-1-senozhatsky@chromium.org/

