Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4FC0606A327
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rb3CYL53
Received: by kanga.kvack.org (Postfix)
	id 06E4B6B00EF; Thu, 29 Oct 2026 15:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01E126B05B2; Thu, 29 Oct 2026 15:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75E66B05B3; Thu, 29 Oct 2026 15:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C35AF6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:12:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 36EC41A0498
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:12:26 +0000 (UTC)
X-FDA: 85376609892.14.3857061
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6DB1540008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:12:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rb3CYL53;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793301144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SnGkcBSoxO1qg6e+mIm2ZjnwnYuiHewsm9s9apLqRbE=;
	b=CUuNN/cpWGnjWnKTE3G7hkZlM53gOJRtmOGGlP6e1tmpzHAEyWy29v0PF3L6a/v6hZWneY
	jmk6Z7GUq5CueUaIkQpx4eKsW1f8py70Jbyb/jzfT0A/9TV1dHnxd6IakYh3xg8l7stTxa
	AMPAdMsF6/RqYF5b8NH7sdVQjV4R1+4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rb3CYL53;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793301144;
	b=wOanVBlMTlYo7W51TM71bo5P4wKyEKdY+kpDWjAvTDsjLIF/wCA7lIITeekeeVkYIEz4hE
	0/7LWgi/bW63t1pQMvPYwXfsnCDevGrV9tPa8azT2/dYCRf/f3/oW30VtO3TQP0AGK79Wz
	Yh45HNSyncWEDYFaUvCWFpI7lw9LNZw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8494D4321D;
	Thu, 29 Oct 2026 19:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEFE1F01816;
	Thu, 29 Oct 2026 19:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793301143;
	bh=SnGkcBSoxO1qg6e+mIm2ZjnwnYuiHewsm9s9apLqRbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rb3CYL53RIcciYxSZiawLVDUdyakhf2hNs1VYKt0wlOXoHDN/B4rIwelSImNphBob
	 7A3ue5eWxrlxNEVWF/dVqlFZh5xIN2dIpM9m+ZKFk0AV5Ts2Y4rre6jTYMr1aXn8Bp
	 qRi66ltRFii7c8p0ry/J4045S+ndNFOF790670QA9tivmgcUEf601tGUqKgDvQxSke
	 iKlFGaW3vt1NE4TMe6YzSsC/OWt3kBlnAFazGbwB7gWruDhQiZc6Wk4Cdm/bR4/YXo
	 JTKhs/274CRnWfrbD706jxcYiuN/BHVR0py0Ku9L1p+WDfkUtqZtO9AR7QnOiZ6da9
	 yk6odrBEbNVvA==
Date: Thu, 29 Oct 2026 19:12:21 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v2 0/8] Batched zswap_store() framework with compression
 batching
Message-ID: <auOZBtRqQGzFcbAT@google.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6DB1540008
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 84n6nyowciieyg73rfizpo3k9nuf7ym6
X-HE-Tag: 1793301144-750948
X-HE-Meta: U2FsdGVkX1+sus1hL4KACblqa26VUJ7Aa0lkG74rETrgdNcggKEBAwW/fBAMVG5dj+SNiadptQrK7WgFXWgpHIH0x7MD5hwcKrNAYJGZc/VGrxNgpp/Qx7FBB1xa6tAkTdnJx7uki9Yrl77RflLzaoUVFHWUZuhyc5wBoBwfHWwZnPpYATbr74chualFs1G/3RRa9/+2EBbUT59xz/BwSAZprMq5U/cQTryMOWa644bjwQg6vMt+riN2qEed6avWRZ65cz8Fcwnya1DUzpGyAC147mnM6x2DcjyrfIX1J0/tIERUMjCxIzjlpQiDahmmvFgDvJdmpP+aiZPE/8Z6Iu+yLiPXltBbzn5T5Xw0GU7s831qOqYfG6lpLmgVShnC3diM+UwoZvoJLC4WtYOZMGN6YnEyhKmXfi6CngbfPdv4ZxS9MU4sP8h8n7zDdHxl9p+1T91Wv6JVLgDq0aQe3PiqcF4RctuHEcgXT4gD9MHSSNswUtYupPSl90EeivfiDU5/NFB5aSApqF1KRXJeV2oMnzy2BSJIoO8sghgBqM+wmoTwXfdtJSwz5485WrmvgP8YbYYakla9YLlZwXv4OsR2Dt/l9kNG1w+YKzw2vzBV3Lpun2XcCJmGQVDq9KKgE40HqWXqKadWUeHBF7qHZ8rV7rpmTPdzmz9WjJMNgMvSE5vRZkLhwKgFdBggN/kSFTiILX/aCm17hOHPLp9vH36Yx/J7mnvJxk6Fj+7pE8gyJLLn13wtjb1tvvMvHOSZ3vCM8rDdWs+zyswApmSRdA7Nn9Yrq+ab3ph6gJcJkiRKwH5mw9szEr5VZV/tuR2+AnatDaBE3jo14YHFRokWmwjQ0aFX1tzw7pOuzrTKTu6D+vifHuEDbNGTSxVFXNAxfhgajHKMp5F74Y1DNxYlOfdoF0uVJ73EmcIzRVZYRgP7YrpgZr4lLHRey5BKI4gDa3bzZ8V8tfhCi6jPfm1
 0RSqBtn/
 S4TTIu6FvuDom5VzjMddcH+RP2wzE7bGZwl/rmkBQ2zTqazMuvkdElSRvNvnCLE7WluI/Q7KP0plxumOr6g0GA0QBVWxxfsM3My2rESj7vs4QWRDMciNxBQGBjr6JqDPo+VNEZYK5uFVUIxWDNE21hNL+Z2ZLvfc5Y4zhTHq87ueoqv+s8kb0fmzyreThpe7BD1gMmn8lIn+X3XygYzGpBFDg/Kpe17gXf7JJxKUbR61gjAtFqjECrMLtKuIymZrmKbOGKq3Dk+arTxo8gAil2CigMicKw61TRaycM+j9s11r/lQ4rOJL+09bds+alDqiuIciBlR3Y6lF0gcFHngovR5EPWPmBDv+MrZ8p9Z9K2n4eENJ7ebc3M1yKrRlXfMEV6a/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 08:04:55PM -0700, Kanchana P. Sridhar wrote:
> 
> v2: Batched zswap_store() framework with compression batching
> =============================================================
> 
> This series is a spin-off of "v14: zswap compression batching with optimized
> iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zswap
> compression batching enablers. Resuming work on this series following a gap
> since v14 (January 2026). Please note that my email address and affiliation have
> changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail.com. I
> have retained the original Intel sign-offs on prior patches for historical
> attribution while signing off v2 of this series with my current address.
> 
> The main focus of v2 was to establish a reliable and accurate performance
> measurement methodology, that addressed the problems with variation in v1. This
> is accomplished and used to validate v2, by reducing usemem to 2 processes and
> enabling PMD THP. As the data shows, we get exactly the same "2048kB-zswpout"
> counts in the baseline and with this series.
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
> 2) We keep the working set for each of the core store functionalities
>    (alloc/initialize zswap entries, compress pages, store pages in zsmalloc,
>    pool/objcg reference increments, objcg charging) to be focused on a
>    batch, thereby minimizing cache evictions and benefiting from cache
>    locality.
> 
> 3) Along the lines of (1), the main zswap_compress() batching routine obtains
>    the comp_ctx mutex lock once per batch, and releases it after it has
>    processed all pages in that batch.
> 
> 4) Any zswap store functionality that works on a batch can potentially be
>    optimized via bulk-processing/parallelized as a next step, to further improve
>    performance.
> 
> Performance data: usemem with 56% over-commit:
> ==============================================
> Validation was done with mm-unstable as of 10-25-2026 (Baseline) and with this
> patch series. To minimize variation in the data, I made these changes to my
> performance measurement methodology:
> 
> 1) Reduced the number of usemem processes to 2. Each process tried to allocate
>    2400M, in a 3G cgroup memory.high budget, effectively accomplishing a 56.25%
>    over-commit.
> 
> 2) Increased the runtime of the workload to ~9 minutes by enabling PMD THP,
>    i.e., 2048kB mTHP folios.
> 
> 3) The use of PMD THP forces zswap_store()/zswap_compress() latency to be in the
>    critical path, and thus enables very reliable measurements with bpftrace.
> 
> 4) I used lhist() instead of hist() in bpftrace to gather latencies at a finer
>    level of granularity and accuracy.
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
>     Pinned CPUs: 2 (E-Cores: 2,3)
> 
> zswap compressor:
>   ZSTD
> 
> mTHP enabled:
>   2048kB (PMD THP)
> 
> I used the help of an LLM to write the bpftrace data post-processing scripts
> that generate latency percentiles.
> 
> vm-scalability/usemem setup:
> 
>   cgroup memory.high: 3G
>   2 usemem processes, each allocates 2400M anonymous memory, reads the
>   Silesia dataset [2] from a pre-fork-allocated buffer into the 2400M,
>   writes to each unsigned long in the 2400M, sleeps for 10 sec, then
>   frees the memory and exits.
> 
>     usemem -w --read-silesia -O -b 1 -s 10 -n 2 2400M
> 
>  usemem metrics are reported from a single run after starting the QEMU VM.
>  Further, I have tabulated the bpftrace p50/p95/p99 latencies with these labels:
> 
>  "zswap_store_higher_order":
>     zswap_store() of PMD folios.
> 
>  "zswap_store_order_0":
>     zswap_store() of order-0 folios.
> 
>  "zswap_batch_compress_per_page":
>     zswap_compress() per-page latency of store batches generated from PMD
>     folios.
> 
>  "zswap_single_compress_per_page":
>     zswap_compress() per-page latency of order-0 folios.
> 
>  
>  ----------------------------------------------------------------------------
>  usemem                       Baseline      zswap        zswap   Change with
>  PMD THP                   mm-unstable      store     compress      compress
>                             10-25-2026   batching     batching      batching
>                                         (patch 6)    (patch 8)          %
>  ----------------------------------------------------------------------------
>  usemem process 1                6,353      7,240        7,428
>   Throughput (KB/s)
> 
>  usemem process 2                6,352      7,236        7,422   
>   Throughput (KB/s)
> 
>  Average Throughput (KB/s)       6,353      7,238        7,425        17%
>  ----------------------------------------------------------------------------
>  usemem process 1              484,580    308,903      257,230
>   Time to free memory (usecs)
> 
>  usemem process 2              518,928    438,585      446,958 
>   Time to free memory (usecs)
> 
>  Average Time to               501,754    373,744      352,094       -30%
>   Free Memory (usecs)
>  -------------------------------------------------------------------------------
> 
>  -------------------------------------------------------------------------------
>  usemem                          Baseline        zswap        zswap       Change
>  PMD THP                      mm-unstable        store     compress         with
>  BPFTRACE                      10-25-2026     batching     batching     compress
>                                              (patch 6)    (patch 8)     batching
>                                                                             (ns)
>  -------------------------------------------------------------------------------
>  zswap_batch_compress_per_page (ns):            
>                          p50                                 40,086        1,569
>                          p95                                 54,689      -64,505
>                          p99                                 83,248      -88,488
>  -------------------------------------------------------------------------------
>  zswap_single_compress_per_page (ns):
>                          p50       38,517       38,352       36,650       -1,867
>                          p95      119,194      121,174      133,678       14,484
>                          p99      171,736      158,601      169,010       -2,726
>  -------------------------------------------------------------------------------
>  zswap_store_higher_order (ns):
>                          p50   21,012,222   21,322,885   20,176,667     -835,556
>                          p95   25,643,500   26,204,375   24,485,000   -1,158,500
>                          p99   28,567,400   38,577,750   26,158,000   -2,409,400
>  -------------------------------------------------------------------------------
>  zswap_store_order_0 (ns):
>                          p50       37,601       36,994       37,568          -33
>                          p95      123,731      137,034      128,366        4,635
>                          p99      159,965      169,282      175,618       15,653
>  -------------------------------------------------------------------------------
>  vmstat summary:
>  -------------------------------------------------------------------------------
>  zswpin                         1,104,226      993,412    1,091,146       
>  zswpout                        1,688,181    1,582,664    1,669,671       
>  2048kB-alloc                       2,500        2,505        2,500   
>  2048kB-zswpout                     1,535        1,535        1,535   
>  2048kB-swpout-fallback               927          929          875     
>  -------------------------------------------------------------------------------
> 
>  Detailed vmstat & zswap stats after workload finishes:
>  ======================================================
> 
>  ------------------------------------------------------
>  usemem                          Baseline        zswap
>  PMD THP                      mm-unstable     compress
>                                10-25-2026     batching
>                                              (patch 8)
>                                                       
>  ------------------------------------------------------
>  vmstat:
>  ------------------------------------------------------
>  pswpin                               0              0
>  pswpout                              0              0
>  thp_swpout                           0              0
>  thp_swpout_fallback                927            875
>  swpin_zero                           0              0
>  swpout_zero                          0              0
>  zswpin                       1,104,226      1,091,146
>  zswpout                      1,688,181      1,669,671
>  zswpwb                               0              0
>  nrswpin                              0              0
>  nrswpout                             0              0
>  pgmajfault                     173,554        173,774
>  nr_free_pages                1,753,879      1,755,195
>  nr_free_pages_blocks         1,651,712      1,667,072
>  2048kB-alloc                     2,500          2,500
>  2048kB-zswpout                   1,535          1,535
>  2048kB-swpout                        0              0
>  2048kB-swpout-fallback             927            875
>  2048kB-swpin                         0              0
>  memory.current                 352,256        499,712
>  memory.swap.current                  0              0
>  ------------------------------------------------------
>  zswap stats:                                         
>  ------------------------------------------------------
>  pool_limit_hit                       0              0
>  written_back_pages                   0              0
>  reject_alloc_fail                    0              0
>  reject_kmemcache_fail                0              0
>  reject_reclaim_fail                  0              0
>  reject_compress_fail                 0              0
>  reject_compress_poor                 0              0
>  decompress_fail                      0              0
>  stored_incompressible_pages          0              0
>  stored_pages                         0              0
>  pool_total_size                      0              0
>  ------------------------------------------------------

As mentioned in the previous version, I cannot reproduce these results,
mainly because the noise is too high. Digging a bit deeper, it's because
the throttling from memory.high varies. Hacking in a change to make
calculate_high_delay() always return 0 (no memory.high stalls) paints a
clearer picture about throughput improvements from the series up to
patch 6 and patch 8. With that, I see 1-2% improvement in throughput
with patch 6, and almost no improvement with patch 8 on top. Similarly,
for zswap store latency for high-order folios, I see a slight (~1-2%)
improvement with patch 6, but almost none with patch 8 on top.

In order to make meaningful progress, can you send patches 5-6
separately? I assume that 1-4 are prep for 7-8, so 5-6 are standalone. I
also think patch 6 will be simplified if we drop the prep work for
patches 7-8?

Also, PTAL at Sashiko reviews before respinning.

