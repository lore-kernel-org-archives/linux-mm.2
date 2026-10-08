Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32175CA600D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 18:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0398E6B008C; Thu,  8 Oct 2026 14:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00F266B0092; Thu,  8 Oct 2026 14:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40CC6B0093; Thu,  8 Oct 2026 14:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF2C36B008C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 14:28:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 532ACC0461
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:32 +0000 (UTC)
X-FDA: 85300294464.28.5E39010
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8723940006
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="PSPbu/7u";
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791484110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xZEd1koy5JUNRs9RrhkiE6ort9fMSMjj77pbdlRj/T0=;
	b=FjeKqvzx5IgS2feftBw/FKnYu4eXC/HmsM4ftvGtzr7X+rL5Vn6ihDhexVVRPJJXOHUimE
	DOS08uGsYQfLOTnbAOaJ9NquroLJJLcxEsDrJfhfQqEu4RroO+Z7pOMcaJQloSh/8SleCS
	zBevKLhoLJ37TgrT9EKEJbuEN/za0rY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791484110;
	b=bhTf4l8hHxCN57zp+l/kNwWj/r0g7/7kxORpM/slyYWOS5AP/o+BHpR95DwPwfrTILe3ow
	ZivtVvcFNHXWQefF3LmNSG2ExNflJlaVxS4iq1vV7zBUaMTMmGi9SdYtcIHywPMQhbeVzk
	Zi2WRD3bO4B23K+LRNHtPhW3YVYVsLQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="PSPbu/7u";
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-16079d54c17so2754664c88.0
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 11:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484109; x=1792088909; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xZEd1koy5JUNRs9RrhkiE6ort9fMSMjj77pbdlRj/T0=;
        b=PSPbu/7uPqoGHdaXmHIOPP59cBz6VmLuU1y9nao0zzL5bCeNpHJSdoJCDSWv8j2yjX
         VSji2yhRnfy1+2YbCNW7x0XpjR0dLhzLNGAAKdeyjGfigEMnBpWJUoJhkCQNlJoC2q7k
         iiYkzlICsWIQJRw63ZtHu3xLrIcra6IMn9ezEeoKJqLzSfBheWgIXXQmj3FcLbYgr6Mt
         87AbYwjwB/YsAzVD6wFSS6jeNj1kRrIHNgLowAALh6niDsbBkLwQWCYhh+Lq61oaNbIn
         F7gOII7rJN8KuvbiWxYqFFmZjlwrzr3D7j9ULlxABKJcMloHcCgmEsrr7BFXQQ06S339
         2hfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484109; x=1792088909;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xZEd1koy5JUNRs9RrhkiE6ort9fMSMjj77pbdlRj/T0=;
        b=se4eGBnJ4em7sEXe/bsMFtuK6W/8AkmNSl3tEHzUGlPzILZ5E5gNRrLKC5oREMLY0v
         MlNXlaJE9y6I018WKP6wHYry1ai5H1wlucGuBWInhOj5ksjZv53BBGvP39m32zY1O6ta
         DUL4GpTMT70azAoM9/8jPjF5wsDfrsgZ3i8UH4yADTAasenV+bUvGJHA43phTnB/MWfi
         tfvM604SXiHDW5rYAboerbzztyo4VGWxO/Qy2sSk4prr8+PjkpuaNc9AyjusGnDI5VQD
         3vLRANJhRAHdSnwUXJOff38uWqUewyKsm6II1avYgm30DXy+zDzKCXjuEXe3Dy8lQCmg
         7yXg==
X-Forwarded-Encrypted: i=1; AKwUvBw+GXojiYMzgqJF10xX+2ZA/FEqsIveJqUuRDXYRE32T23XuujOwDWs2s/jG5F/h3KTNjjL6tjdCA==@kvack.org
X-Gm-Message-State: AFuF++kAd3Ayt6k9fI/761VPljsqATFAsWNFZkZFgfisspL0zZo/be6v
	96sBuAvnmJYHYTaM7qcQi31dvBR0ZtG5Y4r3FQwGxyZ9cvwQeOvFP/hG
X-Gm-Gg: AYBFou1kzYIRWV0byFsHzuXp/uXlxA9BW2Qn7JEq/p7pZ/t7BQElv6jDjgbaeq5PlsL
	nW9i3shjszqPfNWM1oMY8SY7wD+s0e69F9Ev+GtyEE2yIqA+DP/1IS0/8jTIs5JlgTeWv0Zwpwk
	fVRt0KIrQmvq0K7ByNAPE8+ZmxyCTl+c1VxojpwJ9aRBYFtzQecRxH16xxp/wBQCzRW8fIQHdPR
	3/wF0JqGLCu/DAO7vKlme8XlKz002th7GZXVyMJSAJw5jGUMO3qukBYBcYXoPuRAmTtBmdjFLQC
	g/6SpwXjmUg8QEpJQsBsA1h9bzPpJX75e0aHmz+YFqgx9qogf97G3M4fIJlTxL6gaNbzGR+gIVJ
	7W6p1HIOAFSuYm8QHnUkPyuUtK+l/Rt/0KIXnQftrTLw17nipV9LVtB+TSqefHJISafVxaLBYvq
	Bv/ONJfo/KQDV2W9hFI0TZitPKx32qdfUREjh1As2hEq/QEADHbLwCo3n3jT45cFguDoF06+P3i
	SG++jncHv4=
X-Received: by 2002:a05:701b:4519:20b0:151:2068:e81f with SMTP id a92af1059eb24-162076c832amr7195694c88.27.1791484109046;
        Thu, 08 Oct 2026 11:28:29 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:28 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v1 0/8] Batched zswap_store() with compression batching
Date: Thu,  8 Oct 2026 11:28:06 -0700
Message-Id: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8723940006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9k77u3qacocmymurf6un86gac9tgxkbq
X-HE-Tag: 1791484110-374027
X-HE-Meta: U2FsdGVkX19X961iZv9TgMzAtWnQjKgvDfL5mKPDOAJuI1AhZgaaouH4YKMcG8NVIYNUs+J7ZYQEkpkNZ7wwxDrCPFKfQeVBuZENYd16HCocRnSyTxn8D3ug0+8xZQftyt1DUOz8BM75P3bLa3kHhhegTpTGNR4hlrCSVYryP2i2CuFYK4EzsiFrS08OppkfGAQRonvzVZZxVYiEE56J9mny7BfZA38e1CE2v52Tde7HmpT1QdfZMWRN+D4ZY2+HMG6za/gSRj9SyoF2BZ1mMrLcF/YqO89P9L7NJ4+JPBZadRKOnFBlx2WK33EGU/fU3BU+tU1BEnbFe8udObb/NCzoIYGX1LH7pUyxCRNq08zkfQQf1s0zMKr2Pu4O2sP7pdVjhxo/t8pw0aaFwtgVl7u8FW33cEZdeCSlDxZQBcOUnLlpEjfn9xQ/DjJmgpcORBj/HsUzxH0Jcj+DiWtvkJaIDeNWO3S1yPi5EK/HXa9vv2zsqQbwdfLs544NsaDK/q2HjLvIQduQ4utmGNpObQP4fJlBFfA5/sIXRCk6qtQudNPCa7BPTGidKekVk5Lq1yxvGZF7ylggTaAG+GitlxWCXR4SxebH1pRI76TlbBa723z5jM+V8UdHMwChvuPQPY1D6nvyWb6bdxul6SehyvdCR/qlCGQdRtjRIftNikXDskG6ynnHWByPSVMUuP9imANI586tcWELXtsD4bLoSjH92dMd6l0792O64UquCpFBaobI0U8WSRFSbwJahM8MhswJIAjztXSXOZQ8jQNinP2rGTSGp3a7N+RGFP/omASmxbraNR2wiQBZ9dqyVdQYxKhrVWh9ct9fAQGSC2YrcLgzxQUIqMdgxz0nf5tjRTIx3lPiJUzPQ6xn6JD8IRb7Om6KCGMg4yUgexgrA3RfPzF7awMOz3HDnNWtNXp38dJoz3ZwFPjrnE/OTapdT8htWtQA1gl31LJuFM3T5Fp
 MILa+guT
 XsnRpW8Ll84Q9E0z6q7WxTbDYb9bt2Xd+pOBh3UE+/lyZ+tlJGxUf6mcDciUTpOqXjbvg+VES1cEfcrwIwmjqvcH4m40qc2cWqQLKpBg7PnVgY1qY8tt4z3KDD+8U2685YzbS4cqVZQsuN9tBORyeAmbDI7XGZirCFCEXtgUWHUaQETJd2wkN45aFzzyd2D8KkCUi8Fs6/IWviPfC1V0kg7EUU2GZ79r9sk6JDqOn1k+fAQW9dmvnlJqZRbiPRdqReWYLXfwnagMGUnNqJK+W/SU+7RLKRBDpLt49/WdqjGQ18MqdBZXF/h5JTtzG1mznZ9XUaJob3sawUA/z8I/dLQoumgt4ztQTPiWbcN+4iYzy4/ixg6Vf1NO/c1B7a4VHNI4n/4WaPOdqXTw3Z3y/GDWMXI6GUyxBeIiKvTMrN/uHBtXLWo2afUwvpKNYCDb2RZrIbdFS3BrNhwufkI9++4d2heA/m1ZBGR7AYc2NtchOBdv749Dr8lA4yK2SHvkYvnLzsv+AwBH3J9O0MBV2V+wDYp1uo5cnOYN4mp2HAZ69WQR06k/rUPIc4ZBOiFBW3xUyJRo8Wi4V8leWW10rthWd0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v1: Batched zswap_store() with compression batching
===================================================

This series is a spin-off of "v14: zswap compression batching with optimized
iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zswap
compression batching enablers. Resuming work on this series following a gap
since v14 (January 2026). Please note that my email address and affiliation have
changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail.com. I
have retained the original Intel sign-offs on prior patches for historical
attribution while signing off v1 of this series with my current address.

To summarize the main contribution of this patch series: Batching is introduced
in zswap_store() of large folios: we carve out a large folio into batches of
ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store each
batch. Moving the fundamental operations that need to be happen to store a page
to now work at the granularity of a batch offers opportunities to optimize them
from these perspectives:

1) Utilize existing kernel API that minimize obtaining locks for bulk
   operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().

2) We keep the working set for each of the core store functionalities (alloc
   entries, compress pages, store pages in zsmalloc) to be focused on a
   batch, thereby minimizing cache evictions and benefiting from cache
   locality.

3) Along the lines of (1), the main zswap_compress() batching routine obtains
   the acomp_ctx mutex lock once per batch, and releases it after it has
   processed all pages in that batch.

4) Any zswap store functionality that works on a batch can potentially be
   parallelized as a next step, to further improve performance.

Performance data: usemem with 60% over-commit:
==============================================
Validation was done with mm-unstable as of 10-3-2026 (Baseline) and with this
patch series.

Testing was done on a Chromebook with a QEMU "vng" VM running in Crostini.
    
Chromebook Diagnostics reports:
  Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
  RAM: 16GB

vng setup:
         Memory: 7G
           Swap: 3G
    Pinned CPUs: 4 (E-Cores: 4,5,6,7)

zswap compressor:
  ZSTD

mTHP enabled:
  64kB

vm-scalability/usemem setup:

  cgroup memory.high: 3G
  4 usemem processes, each allocates 1200M anonymous memory, reads the
  Silesia dataset [2] from a pre-fork-allocated buffer into the 1200M,
  writes to each unsigned long in the 1200M, sleeps for 10 sec, then
  frees the memory and exits.

    usemem --read-silesia -w -O -b 1 -s 10 -n 4 1200M

 usemem metrics averaged across 10 iterations*:
 ================================================
 
 --------------------------------------------------------------------------
                                          Baseline       Patch     Change
                                       mm-unstable      series       with
                                         10-3-2026          v1         v1  
 --------------------------------------------------------------------------
 Average Throughput (KB/s)                  11,794      17,810    +51.00%
 Total Throughput (KB/s)                    47,179      71,242    +51.00%
 Average Time to Free Memory (usecs)       490,973     294,920    -39.93%
 Total Time to Free Memory (usecs)       1,963,892   1,179,682    -39.93%
 --------------------------------------------------------------------------
 * vmstats are as reported at the end of the 10th iteration:

 64kB-alloc                                834,567     828,199     -0.76%
 64kB-zswpout                              700,138     743,697      6.22%
 64kB-swpout-fallback                       35,342      17,978    -49.13%
 64kB-swpout                                     0           0           
 --------------------------------------------------------------------------

 The speedup with zswap store batching of large folios has a propelling effect
 on other parts of mm, especially, by enabling large folios to be swapped out
 without splitting, as the data shows. This enables other mm components that are
 optimized for large folios, such as munmap(), folio refcounts/mapcounts
 updates, PTE invalidation upon freeing memory, zswap_invalidate(); which
 benefit from xarray offsets/range continuity. As a result, subsequent large
 folio swapouts are more likely to find contiguous swap slots, there are fewer
 large folio splits during reclaim, more mTHP zswpouts and the cycle
 continues. As the data demonstrates, this directly contributes to more memory
 over-commit opportunity.

Detailed usemem metrics/cgroup memory utilization/vmstats:
==========================================================

 A) MAX zswap pool_total_size vmstats:
 =====================================
 This is a snapshot at the 10th iteration's peak zswap pool usage:

 --------------------------------------------------------------------------
                                    Baseline             Patch     Change
                                 mm-unstable            series       with
                                   10-3-2026                v1         v1  
 --------------------------------------------------------------------------
 pswpin                                    0                 0
 pswpout                                   0                 0
 thp_swpout                                0                 0
 thp_swpout_fallback                       0                 0
 swpin_zero                              594               548
 swpout_zero                           1,062               864
 zswpin                           10,603,882        11,070,673
 zswpout                          16,594,356        16,509,201     -0.51%
 zswpwb                                    0                 0           
 nrswpin                                   0                 0           
 nrswpout                                  0                 0           
 pgmajfault                        1,460,360         1,470,092      0.67%
 nr_free_pages                       897,249           908,935      1.30%
 nr_free_pages_blocks                892,928           903,680      1.20%
 64kB-alloc                          831,788           825,556     -0.75%
 64kB-zswpout                        690,961           735,863      6.50%
 64kB-swpout                               0                 0           
 64kB-swpout-fallback                 32,982            16,545    -49.84%
 64kB-swpin                                0                 0           
 zswap_pool_total_size         1,420,120,064     1,377,210,368     -3.02%
 memory.current                3,390,189,568     3,299,569,664     -2.67%
 memory.swap.current           3,221,221,376     3,221,221,376
 --------------------------------------------------------------------------

  B) STEADY STATE vmstats after usemem finishes:
  ==============================================
  This is a snapshot after the 10th iteration finishes:

 --------------------------------------------------------------------------
                                    Baseline             Patch     Change
                                 mm-unstable            series       with
                                   10-3-2026                v1         v1  
 --------------------------------------------------------------------------
 pswpin                                    0                 0 
 pswpout                                   0                 0
 thp_swpout                                0                 0
 thp_swpout_fallback                       0                 0
 swpin_zero                              594               548
 swpout_zero                           1,062               949
 zswpin                           11,526,695        11,963,729
 zswpout                          17,293,120        17,219,911     -0.42%
 zswpwb                                    0                 0           
 nrswpin                                   0                 0           
 nrswpout                                  0                 0           
 pgmajfault                        1,591,298         1,596,095      0.30%
 nr_free_pages                     1,752,789         1,753,264      0.03%
 nr_free_pages_blocks              1,258,496         1,240,064     -1.46%
 64kB-alloc                          834,567           828,199     -0.76%
 64kB-zswpout                        700,138           743,697      6.22%
 64kB-swpout                               0                 0           
 64kB-swpout-fallback                 35,342            17,978    -49.13%
 64kB-swpin                                0                 0           
 zswap_pool_total_size                     0                 0           
 memory.current                      757,760           802,816      5.95%
 memory.swap.current                       0                 0
 --------------------------------------------------------------------------
 zswap debugfs counters:                                      
                                                              
  pool_limit_hit                           0                 0
  written_back_pages                       0                 0
  reject_alloc_fail                        0                 0
  reject_kmemcache_fail                    0                 0
  reject_reclaim_fail                      0                 0
  reject_compress_fail                     0                 0
  reject_compress_poor                     0                 0
  decompress_fail                          0                 0
  stored_incompressible_pages              0                 0
  stored_pages                             0                 0
 --------------------------------------------------------------------------


[1]: https://patchwork.kernel.org/project/linux-mm/cover/20260125033537.334628-1-kanchana.p.sridhar@intel.com/
[2]: https://wanos.co/assets/silesia.tar


Changes since [1]:
==================
1) Better cacheline placement of struct zswap_pool and struct zswap_entry
   members for temporal memory access efficiency in zswap store/load hot paths,
   while minimizing holes.

2) Refactored the core compression batching functionality to a separate
   __zswap_compress() function, which is called by zswap_compress(), as per
   Nhat's and Yosry's comments. Hopefully this helps explain the outer "store
   batching" zswap_compress() vis-a-vis the inner "compress batching"
   __zswap_compress() distinction.

3) The acomp_ctx is locked once and is passed to the routine that compresses a
   batch, per the algorithm's batch-size. Similarly, the folio's node id and
   writeback_enabled status are computed once and passed to the routines that
   implement the different store functionalities, to save latency by avoid
   localized recomputes of information that doesn't change.

4) Moved the folio node id being stored in zswap_entry to a separate patch, per
   Yosry's comment.

5) Addressed the kunmap_local() issue flagged by Jixin He in the
   IS_ERR_VALUE(handle) error path
   (https://patchwork.kernel.org/comment/27095925) - thanks!

6) Moved comments inline, per Yosry's suggestions.

Thanks,
Kanchana


Kanchana P. Sridhar (8):
  crypto: acomp - Define a unit_size in struct acomp_req to enable
    batching. mm: zswap: Set the unit size for zswap to PAGE_SIZE.
  crypto: acomp - Add bit to indicate segmentation support.
  crypto: acomp - Add trivial segmentation wrapper.
  crypto: acomp - Add API to get a compression algorithm's batch-size.
  mm: zswap: Store the folio's node id in the zswap_entry.
  mm: zswap: Store large folios in batches.
  mm: zswap: Optimally place members of struct zswap_pool, struct
    zswap_entry.
  mm: zswap: Batched zswap_compress() for storing large folios in
    batches.

 crypto/acompress.c                  |  47 ++-
 include/crypto/acompress.h          |  62 +++
 include/crypto/algapi.h             |   5 +
 include/crypto/internal/acompress.h |   8 +
 include/linux/crypto.h              |   3 +
 mm/zswap.c                          | 571 ++++++++++++++++++++--------
 6 files changed, 528 insertions(+), 168 deletions(-)

-- 
2.39.5


