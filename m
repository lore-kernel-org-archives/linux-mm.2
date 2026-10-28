Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C14606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 03:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OY/he/w4
Received: by kanga.kvack.org (Postfix)
	id 5B3ED6B096D; Tue, 27 Oct 2026 23:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5648F6B096F; Tue, 27 Oct 2026 23:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405EB6B0970; Tue, 27 Oct 2026 23:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2C06B096D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:05:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 942C4A893F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:25 +0000 (UTC)
X-FDA: 85370544210.07.D7F7AC8
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id AD9E880007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="OY/he/w4";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793156723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=APLAV0ZJuR/FzIwnAo/aU9jS3GkzW09H+h9WgSzD6P0=;
	b=UdulnzrVDZwssKscUOlV1wTsIBq4A4ck0T0EQ7ZwzqoBSB69RnxdIiicZIsYZ7EVYwNx8o
	WLLDMHlMYgV0cLLVYNhAwM7f3iE292WOIaCggqwy9FIzmfXF3fSFlOpp0m/n/hQIAb+pSX
	O5nIP2mTNYQ3vehkPQ+gogb9xisKwcw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="OY/he/w4";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793156723;
	b=typDO+bfQxAmXyWBVHkgGRlz7+8fAiFV5n8i7rlwrpeBu7KXHkVaDN7AOI0CoYNEFXlVYG
	8BnXtP9i6SfQ7o17fag6waptaYCWTcz3v8SjoZQuQ00puyT2tzZ9G+pB9ZUbW25ZL/W5mX
	EInOZ7ZLbSgBPZeKoKISMO5+DCfCZwo=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1931ff67a29so1255193c88.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156722; x=1793761522; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=APLAV0ZJuR/FzIwnAo/aU9jS3GkzW09H+h9WgSzD6P0=;
        b=OY/he/w4IY2AGLBErLMp6djU1tJMdkYad1i6TWWUdNgVIzUdtgKCnsVccEPl/S/FwE
         yLXDZ9Hc/Qd26FU/yYfVeJx9lrgGEGch5gwvDEfs1bN6ons9VjUQdGGEi8VX0by/APZ/
         6zTQtQZ+6F5C1B3DtcddPH7bP2YKBUsjqd2Mv/v/frhEx8zitu1D2JKWJkwewat/ga1m
         2pKOUk94Tba+eYd6vtYhdY+MNeIPiy4xpAAozdFDetRJgDlhws4bBkm7wLE/nWzZ3EIz
         eEPnMQ5RNo+OC0YMWL5R18316GypcSC0ylWYA+KChn5Q0izjCHW9m8haMRs51cLTn2CZ
         pyzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156722; x=1793761522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=APLAV0ZJuR/FzIwnAo/aU9jS3GkzW09H+h9WgSzD6P0=;
        b=posjRJozaiG8PBWfWOtd8E87S9/o0jqYX9CLkY21ZiizMogZ5Sas1ROEuY0tONHb8f
         SBYjdmSK6G3YLu2yYtHOG58bsqTG8c/dcpSi80tPYgrIC7y+23N91xfzQ9xYIbVDArw7
         CqxAibQqr/4Wo3GkxBYgH/YubVGk6wxV5h71GYZYPjRiEgdVWvhrlB59tIoUoq99orU5
         hGNic5J2WYBZ+BVob9C5kZ4U4USqCiph+ipONOIt+Zsn7ApRGL8c0TuuR6wIZTqD5pew
         A0JRc+b3VXVsLaUyyCjkhjsBDmK4Bo7kOT080kL6FHjpA/5Q7wylh2FGYd58P2lpAuOs
         NyVw==
X-Forwarded-Encrypted: i=1; AKwUvBz/M9YTh4Bj2yOjaO7hdSGH9UP3ISdWhTYtoJPG1xBeT1DMQP3ujJV715fT4CN7zmRP98U1mgF89A==@kvack.org
X-Gm-Message-State: AFq9FYJwDDM5dmTJ1sdXYBokNbi3dm0GXj7YsUWohErBl+spCdoSluV2
	PxKRiidvp6XX/3ijoJO7Xv5MvJvSu8TiSC7pwy3P4zWL0gcQaeimZI7suJPwew==
X-Gm-Gg: AYBFou05ogT63Rw4FwFxp24hml9ISpfQ+tTdummAG548NS6KwtVLy/j5LvXLFUDugde
	1ps11vfP4poOE1zo/AsdZLMtD/iPdyep5iK7geOr4ZBmMvw3iD6LRRBybAAink6f5iWr7BCAM6d
	71qUNUFg+grAaipGvLgS56hnQ6vOBrR7blu2np52lgexkqjicvgvfaSQ5Isx8zsjjdAxCpz7y3m
	vwCEVvQc0Ju7s1wwi38d9hECrvUSY52ct0MGfgUw+hhf9sA6eQ9fUweg0iepHmcrarXj7ndZdG3
	XpQr7q6ZVz9XGcQbhduAD8d3JXx3JNGfq8A1jlMjsoOavvim6OSgpJ/kbSerDQdF9zhqld5wLcZ
	Yk3b62lgHuZ1GM/cgv5VCjm43VwtA+nmGwU/U0djC5nFv2LYHsfzeLLlPIkMCmmvDaiXa1a3MmX
	jdI98pVWu4zA3ZjrgP/EpY2INGMz/zQsJKwthMfE8zQxp3lKULzGS4FTkr2umkPisE8yQHvgY/6
	4UJKDqUL0+HmBOEiUG0Scp9goETKAylnFCQPG2w4HI2B9b396w/KEhA0SnMZT+7yA050rrnaaMN
	1pG8eajaW3dFOVbYWGBFVWaPkczhwSmN0B/+x85mqnJcZuXbkY5hPt2tF5zM8zI=
X-Received: by 2002:a05:701a:ca03:b0:151:5d01:9316 with SMTP id a92af1059eb24-1a6cca02d70mr1584749c88.23.1793156722103;
        Tue, 27 Oct 2026 20:05:22 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:21 -0700 (PDT)
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
Subject: [PATCH v2 8/8] mm: zswap: Refactor and optimize zswap_store_pages() batch operations.
Date: Tue, 27 Oct 2026 20:05:03 -0700
Message-Id: <20261028030503.17923-9-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD9E880007
X-Stat-Signature: 4okshkxx53au9xjktr3o5mhfe1agrtah
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793156723-985618
X-HE-Meta: U2FsdGVkX18UeL0/kKNpsyD/C1o+DerIbOsTxQy8y/Kidh+B/GWTBgTxvYcATv1aL8uM5mklJSH7hINOxCvDqn4mSW0QGKEkkVZnNE/qQ8yPuRxn9u7GPAJrHPBH5BdA5gsgYbvEsu4GNi6LgAlDjElNOyBhrjEZAo4hApQU9z1jQxymytjFk5hOQfQzL5bSsF/kkKIYxIIuzdWWEyshPP2LTrZmyRonTT/hKH1B+tb4UMxUuRUT0sif9rfUPCwYXdWbRO2kAOGN3vgJoLcm9IKTJvHqpZM5HP8tonz5+VNfXtW8JMX3x8ophhzVIoGxKQJJIApfW3CJ/qnd7yAksV2nwHkd/KQY6nCx+ZRDgeIkBIcopsIEdO/GlswMYERiO+BAAs6eS3vU/81b190lwHW8JqmDVQzwf+fJ55T8CqVzTAIWUuFRIvCBnjQrSoRULOoJ/xA1ekbt1PIxgXFXjCgrH+fT+5QH9zZ8T4TA/JoFoBkPdAev2PaMSuh+0f/wPSjD+d5AdJ9fOYMxH8GCwdc7XyCdt6uvm026Z8KKuRs1Ev3P4YhmKTUtMESH8pcwsS/XwTy8m7medGQRHAiWGNw46L50wIB0L/tAE660ZAREjqBjuiNypLMKZBYSncvnakXh7QblftCzOKfLU8EihxeWBnHd7fJLzEU0IGeX8FNCZLJ8LwSwVwVyUh2XWfgJJ8BK0RBKt4tXOPGvs/ZVjCFPeA5Wgqu6dPHBXgOnwxQkVxg8r8r5ZaOmFZJ+ZxTg0YlOPTOr7TJBcXBke07AgKhULhlY9g2BWueI4eNbObWQE3ptUkBALxG59Y5BW+r2WcNl2EhVmZ7qWb9amTCmkoModwJGQ+H+TKOwd6YNWaWQmfB7I6URnoFuBHI9yNBSZZXGBkAz1YEO8ffSLLCkCAx8lQqhpacEw4O1jyfY9+0tUU5UNVehmn/U6O8HzsW4oUDrSN9HlYIeSeeLodk
 YRR5+NDy
 J6LiaAHCZogrbKL+Izc1jnS+Z3J2JxSDPvtDQ71sC1JU4nhvwscToLfuWj4V8J1y6CsGCMyvCTM4t4/ytejJI5pI8t7sP8F3zMr13ubqdiAufcxYii6CaBnVh86aOQHeNmFE/9ZKhZrr3spb8rFnh4KSkIbLeXyChE2YYCQAG3oq1GQpl5D/ltN7RcIqG5jKZBUs1uD52BHVoHEQTw+aDixezOWdigVEgvzC4wm+hF4mSNVTwEw2NxE2YERgOspQnZMVQqJS3pXF09I/5XKIS5l//XGxop+H/sqk2UeYREfYsvvGkYMYR6IMTWW9o01613r2LKBRk/UU1dbmrp27lqYT2cFoX5UFDi4HRpiWfx0Ue56jTZXQLnF1eiqKnjMrT2FH41v4DfwBlrZTebK7YSDk4mPJv8KQwye2HGngehJjqp10MRDkEPBo5DT4RugGl4lYhXoHy5yPAH6v6JsMnZGW/C6fpmYmg+7VY4cJJ09UcFcxRn2FftfGI9gSJOXbpykM3+lNLnHAHPZRu4ZnjjhkkXpx6niZsPZIk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This various stages of zswap_store_pages() are broken down into routines
that work on a batch of data when a large folio is being processed:

 zswap_init_entries()
 zswap_compress()
 zswap_tree_stores()
 zswap_account_stores()

The struct zswap_store_context is used to pass constraints and data
among these batching components. The resulting code is highly simplified
and maintainable, where each of the batching sub-routines of
zswap_store() can be optimized modularly.

For instance, the zswap_account_stores() now does the zswap atomics
counter increments, getting pool references, getting objcg references
and objcg zswap charging at the batch level.

Subsequent patch series will be submitted, that implement ideas building
upon this batching framework:

 1) Replacing zsmalloc with SLUB allocator, comprising of kmem_caches
    for a finite # of compressed size bins. This enables bulk allocation
    of compressed buffers in a batch, that belong to the same size
    bin. It gets rid of significant zsmalloc latency overhead (locks,
    compressed data spanning zspages, etc.), without compromising memory
    efficiency.

 2) vmscan reclaim batching of hybrid any-order folios, that will submit
    a batch of folios to zswap_store()'s batching framework to optimize
    storing of batches of pages from different folios, and also within
    large folios.

The batching framework introduced in this series improves zswap_store()
latency by a lot.

Performance data: usemem with 56% over-commit:
==============================================
Validation was done with mm-unstable as of 10-25-2026 (Baseline) and with this
patch series. To minimize variation in the data, I made these changes to my
performance measurement methodology:

1) Reduced the number of usemem processes to 2. Each process tried to allocate
   2400M, in a 3G cgroup memory.high budget, effectively accomplishing a 56.25%
   over-commit.

2) Increased the runtime of the workload to ~9 minutes by enabling PMD THP,
   i.e., 2048kB mTHP folios.

3) The use of PMD THP forces zswap_store()/zswap_compress() latency to be in the
   critical path, and thus enables very reliable measurements with bpftrace.

4) I used lhist() instead of hist() in bpftrace to gather latencies at a finer
   level of granularity and accuracy.

Testing was done on a Chromebook with a QEMU "vng" VM running in Crostini.

Chromebook Diagnostics reports:
  Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
  RAM: 16GB

vng setup:
         Memory: 7G
           Swap: 3G
    Pinned CPUs: 2 (E-Cores: 2,3)

zswap compressor:
  ZSTD

mTHP enabled:
  2048kB (PMD THP)

I used the help of an LLM to write the bpftrace data post-processing scripts
that generate latency percentiles.

vm-scalability/usemem setup:

  cgroup memory.high: 3G
  2 usemem processes, each allocates 2400M anonymous memory, reads the
  Silesia dataset [1] from a pre-fork-allocated buffer into the 2400M,
  writes to each unsigned long in the 2400M, sleeps for 10 sec, then
  frees the memory and exits.

    usemem -w --read-silesia -O -b 1 -s 10 -n 2 2400M

 usemem metrics are reported from a single run after starting the QEMU VM.
 Further, I have tabulated the bpftrace p50/p95/p99 latencies with these labels:

 "zswap_store_higher_order":
    zswap_store() of PMD folios.

 "zswap_store_order_0":
    zswap_store() of order-0 folios.

 "zswap_batch_compress_per_page":
    zswap_compress() per-page latency of store batches generated from PMD
    folios.

 "zswap_single_compress_per_page":
    zswap_compress() per-page latency of order-0 folios.

 ----------------------------------------------------------------------------
 usemem                       Baseline      zswap        zswap   Change with
 PMD THP                   mm-unstable      store     compress      compress
                            10-25-2026   batching     batching      batching
                                        (patch 6)    (patch 8)          %
 ----------------------------------------------------------------------------
 usemem process 1                6,353      7,240        7,428
  Throughput (KB/s)

 usemem process 2                6,352      7,236        7,422
  Throughput (KB/s)

 Average Throughput (KB/s)       6,353      7,238        7,425        17%
 ----------------------------------------------------------------------------
 usemem process 1              484,580    308,903      257,230
  Time to free memory (usecs)

 usemem process 2              518,928    438,585      446,958
  Time to free memory (usecs)

 Average Time to               501,754    373,744      352,094       -30%
  Free Memory (usecs)
 -------------------------------------------------------------------------------

 -------------------------------------------------------------------------------
 usemem                          Baseline        zswap        zswap       Change
 PMD THP                      mm-unstable        store     compress         with
 BPFTRACE                      10-25-2026     batching     batching     compress
                                             (patch 6)    (patch 8)     batching
						                            (ns)
 -------------------------------------------------------------------------------
 zswap_batch_compress_per_page (ns):
                         p50                                 40,086        1,569
                         p95                                 54,689      -64,505
                         p99                                 83,248      -88,488
 -------------------------------------------------------------------------------
 zswap_single_compress_per_page (ns):
                         p50       38,517       38,352       36,650       -1,867
                         p95      119,194      121,174      133,678       14,484
                         p99      171,736      158,601      169,010       -2,726
 -------------------------------------------------------------------------------
 zswap_store_higher_order (ns):
                         p50   21,012,222   21,322,885   20,176,667     -835,556
                         p95   25,643,500   26,204,375   24,485,000   -1,158,500
                         p99   28,567,400   38,577,750   26,158,000   -2,409,400
 -------------------------------------------------------------------------------
 zswap_store_order_0 (ns):
                         p50       37,601       36,994       37,568          -33
                         p95      123,731      137,034      128,366        4,635
                         p99      159,965      169,282      175,618       15,653
 -------------------------------------------------------------------------------
 vmstat summary:
 -------------------------------------------------------------------------------
 zswpin                         1,104,226      993,412    1,091,146
 zswpout                        1,688,181    1,582,664    1,669,671
 2048kB-alloc                       2,500        2,505        2,500
 2048kB-zswpout                     1,535        1,535        1,535
 2048kB-swpout-fallback               927          929          875
 -------------------------------------------------------------------------------

 zswap compress batching improves on both, zswap_store() latency and
 zswap_compress() latency wrt the baseline, pretty consistently; except for p50
 batch compress latency which can be optimized further in subsequent
 patches. The batching framework established in this series allows us to make
 locking and bulk-processing improvements in each stage of zswap_store(). One of
 the ideas that has been showing very promising results is to replace zsmalloc
 with SLUB compressed caches and will be submitted separately. This is expected
 to resolve the p50 batch compress latency issue since it will be directly
 optimizing zswap_update_entries().

 The speedup with zswap store batching of large folios has a propelling effect
 on other parts of mm, especially, by enabling large folios to be swapped out
 without splitting, as the data shows. This enables other mm components that are
 optimized for large folios, such as munmap(), folio refcounts/mapcounts
 updates, PTE invalidation upon freeing memory, zswap_invalidate(); which
 benefit from xarray offsets/range continuity. As a result, subsequent large
 folio swapouts are more likely to find contiguous swap slots, there are fewer
 large folio splits during reclaim and the cycle continues. As the data
 demonstrates, this directly contributes to more memory over-commit
 opportunity.

Architectural considerations for the zswap batching framework:
==============================================================
The zswap batching framework is designed to be hardware-agnostic.
It can be leveraged by any hardware accelerator or software-based
compressor.

Potential future clients of the batching framework:
===================================================
This patch-series demonstrates the performance benefits of compression
batching when used in zswap_store() of large folios. Compression
batching can be used for other use cases such as batching compression in
zram, batch compression of different folios during reclaim, kcompressd,
file systems, etc. Decompression batching can be used to improve
efficiency of zswap writeback (Thanks Nhat for this idea), batching
decompressions in zram, etc.

[1]: https://wanos.co/assets/silesia.tar

Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 178 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 112 insertions(+), 66 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 4476fb4aeb5f..2831284cfc90 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -504,12 +504,18 @@ static int __must_check zswap_pool_tryget(struct zswap_pool *pool)
 }
 
 /* The caller must already have a reference. */
-static void zswap_pool_get(struct zswap_pool *pool)
+static void __maybe_unused zswap_pool_get(struct zswap_pool *pool)
 {
 	percpu_ref_get(&pool->ref);
 }
 
-static void zswap_pool_put(struct zswap_pool *pool)
+/* The caller must already have a reference. */
+static inline void zswap_pool_get_many(struct zswap_pool *pool, u8 nr)
+{
+	percpu_ref_get_many(&pool->ref, nr);
+}
+
+static inline void zswap_pool_put(struct zswap_pool *pool)
 {
 	percpu_ref_put(&pool->ref);
 }
@@ -1668,25 +1674,13 @@ static void shrink_worker(struct work_struct *w)
 **********************************/
 
 /*
- * Store multiple pages in @folio, starting from the page at index @start up to
- * the page at index @end-1.
+ * Functions called by zswap_store(), that operate on batches of pages.
  */
-static bool zswap_store_pages(struct zswap_store_context *zc,
-			      long start,
-			      long end,
-			      struct zswap_pool *pool,
-			      struct obj_cgroup *objcg)
+static inline void zswap_init_entries(struct zswap_store_context *zc,
+				      struct zswap_pool *pool,
+				      struct obj_cgroup *objcg)
 {
-	u8 i, store_fail_idx = 0;
-	bool ret;
-
-	zc->nr_pages = end - start;
-	zc->folio_start = start;
-
-	VM_WARN_ON_ONCE(zc->nr_pages <= 0 || zc->nr_pages > ZSWAP_MAX_BATCH_SIZE);
-
-	if (unlikely(!zswap_entries_cache_alloc_batch(zc, GFP_KERNEL)))
-		return false;
+	u8 i;
 
 	/*
 	 * We co-locate entry initialization as much as possible here to
@@ -1694,9 +1688,9 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 	 */
 	for (i = 0; i < zc->nr_pages; ++i) {
 		/*
-		 * Set pool_idx before the xa_store() below publishes the entry, or a
-		 * concurrent reader could resolve a stale pool_idx left by slab reuse
-		 * to an unrelated live pool.
+		 * Set pool_idx before the xa_store() in zswap_tree_stores()
+		 * publishes the entry, or a concurrent reader could resolve a
+		 * stale pool_idx left by slab reuse to an unrelated live pool.
 		 */
 		zc->entries[i]->pool_idx = pool->idx;
 		zc->entries[i]->swpentry = folio_swap_entry(zc->folio,
@@ -1706,27 +1700,17 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 		zc->entries[i]->nid = zc->nid;
 		INIT_LIST_HEAD(&zc->entries[i]->lru);
 	}
+}
 
-	/*
-	 * Locking the comp_ctx mutex once per store batch results in better
-	 * performance as compared to locking per compress batch.
-	 */
-	zc->comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
-	mutex_lock(&zc->comp_ctx->areq.mutex);
-
-	ret = zswap_compress(zc);
-
-	mutex_unlock(&zc->comp_ctx->areq.mutex);
-
-	if (unlikely(!ret))
-		goto compress_failed;
+static bool zswap_tree_stores(struct zswap_store_context *zc)
+{
+	struct zswap_entry *old;
+	u8 i, store_fail_idx = 0;
 
 	for (i = 0; i < zc->nr_pages; ++i) {
-		struct zswap_entry *old, *entry = zc->entries[i];
-
-		old = xa_store(swap_zswap_tree(entry->swpentry),
-			       swp_offset(entry->swpentry),
-			       entry, GFP_KERNEL);
+		old = xa_store(swap_zswap_tree(zc->entries[i]->swpentry),
+			       swp_offset(zc->entries[i]->swpentry),
+			       zc->entries[i], GFP_KERNEL);
 		if (unlikely(xa_is_err(old))) {
 			int err = xa_err(old);
 
@@ -1734,13 +1718,11 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 			zswap_reject_alloc_fail++;
 			/*
 			 * Entries up to this point have been stored in the
-			 * xarray. zswap_store() will erase them from the xarray
-			 * and call zswap_entry_free(). Local cleanup in
-			 * 'store_pages_failed' only needs to happen for
-			 * entries from [@i to @nr_pages).
+			 * xarray. Local cleanup in 'tree_store_failed' needs to
+			 * erase entries up until now.
 			 */
 			store_fail_idx = i;
-			goto store_pages_failed;
+			goto tree_store_failed;
 		}
 
 		/*
@@ -1750,24 +1732,30 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 		 */
 		if (unlikely(old))
 			zswap_entry_free(old);
+	}
 
-		/*
-		 * The entry is successfully compressed and stored in the tree,
-		 * and further failures will be cleaned up in zswap_store().
-		 * Grab refs to the pool and objcg, charge zswap memory, and
-		 * increment zswap_stored_pages. The opposite actions will be
-		 * performed by zswap_entry_free() when the entry is removed
-		 * from the tree.
-		 */
-		zswap_pool_get(pool);
-		if (objcg) {
-			obj_cgroup_get(objcg);
-			obj_cgroup_charge_zswap(objcg, entry->length);
-		}
-		atomic_long_inc(&zswap_stored_pages);
-		if (unlikely(entry->length == PAGE_SIZE))
+	return true;
+
+tree_store_failed:
+	for (i = 0; i < store_fail_idx; ++i)
+		xa_erase(swap_zswap_tree(zc->entries[i]->swpentry),
+			 swp_offset(zc->entries[i]->swpentry));
+	return false;
+}
+
+static inline void zswap_account_stores(struct zswap_store_context *zc,
+					struct zswap_pool *pool,
+					struct obj_cgroup *objcg)
+{
+	size_t total_batch_comp_length = 0;
+	u8 i;
+
+	for (i = 0; i < zc->nr_pages; ++i) {
+		if (unlikely(zc->entries[i]->length == PAGE_SIZE))
 			atomic_long_inc(&zswap_stored_incompressible_pages);
 
+		total_batch_comp_length += zc->entries[i]->length;
+
 		/*
 		 * We finish by adding the entry to the LRU while it's already
 		 * in xarray. This is safe because:
@@ -1778,20 +1766,78 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 		 *    The publishing order matters to prevent writeback from seeing
 		 *    an incoherent entry.
 		 */
-		if (likely(entry->length))
-			zswap_lru_add(entry);
+		if (likely(zc->entries[i]->length))
+			zswap_lru_add(zc->entries[i]);
 	}
 
+	/*
+	 * The entry is successfully compressed and stored in the tree,
+	 * and further failures will be cleaned up in zswap_store().
+	 * For the batch, grab refs to the pool and objcg, charge zswap memory,
+	 * and increment zswap_stored_pages by @zc->nr_pages. The opposite
+	 * actions will be performed by zswap_entry_free() when the entry is
+	 * removed from the tree.
+	 */
+	zswap_pool_get_many(pool, zc->nr_pages);
+	if (objcg) {
+		obj_cgroup_get_many(objcg, zc->nr_pages);
+		obj_cgroup_charge_zswap(objcg, total_batch_comp_length);
+	}
+	atomic_long_add(zc->nr_pages, &zswap_stored_pages);
+}
+
+/*
+ * Store multiple pages in @folio, starting from the page at index @start up to
+ * the page at index @end-1.
+ */
+static bool zswap_store_pages(struct zswap_store_context *zc,
+			      long start,
+			      long end,
+			      struct zswap_pool *pool,
+			      struct obj_cgroup *objcg)
+{
+	bool ret;
+	u8 i;
+
+	zc->nr_pages = end - start;
+	zc->folio_start = start;
+
+	VM_WARN_ON_ONCE(zc->nr_pages <= 0 || zc->nr_pages > ZSWAP_MAX_BATCH_SIZE);
+
+	if (unlikely(!zswap_entries_cache_alloc_batch(zc, GFP_KERNEL)))
+		return false;
+
+	zswap_init_entries(zc, pool, objcg);
+
+	/*
+	 * Locking the comp_ctx mutex once per store batch results in better
+	 * performance as compared to locking per compress batch.
+	 */
+	zc->comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
+	mutex_lock(&zc->comp_ctx->areq.mutex);
+
+	ret = zswap_compress(zc);
+
+	mutex_unlock(&zc->comp_ctx->areq.mutex);
+
+	if (unlikely(!ret))
+		goto compress_failed;
+
+	ret = zswap_tree_stores(zc);
+
+	if (unlikely(!ret))
+		goto store_pages_failed;
+
+	zswap_account_stores(zc, pool, objcg);
+
 	return true;
 
 store_pages_failed:
-	for (i = store_fail_idx; i < zc->nr_pages; ++i)
+	for (i = 0; i < zc->nr_pages; ++i)
 		zs_free(pool->zs_pool, zc->entries[i]->handle);
 
 compress_failed:
-	zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
-				       zc->nr_pages - store_fail_idx);
-
+	zswap_entries_cache_free_batch(zc->entries, zc->nr_pages);
 	return false;
 }
 
-- 
2.39.5


