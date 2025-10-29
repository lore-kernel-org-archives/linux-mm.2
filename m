Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 927B6CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEFF68E0093; Wed, 29 Oct 2025 11:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7258E0045; Wed, 29 Oct 2025 11:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05168E0093; Wed, 29 Oct 2025 11:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C01D08E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:59:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BC131A08B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:00 +0000 (UTC)
X-FDA: 84051610440.20.49F7FDE
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 85C7FC000D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:58:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="a/A97KCd";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753538; a=rsa-sha256;
	cv=none;
	b=rTCXY1kTUjyWUCIaazg9Y+H8367761aWpkmYjxtPuVKM54plCcyopxVhApZAP08hGr6dOE
	w1i/rRGMbLPuAKngGRIKIBFoHnDDnBncFpVm0+bi3g7GwxtblBiVJ7acYmvaPQzLtqRu/I
	kcqtMed7R3PMQZXeM8DCSSML/M6xHB0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="a/A97KCd";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Rp6UONa4RQroT/DFseWBOqeBQbwX964QzeqYggw97rk=;
	b=ABv3A4GPgJI1DcMSsu9qWEaCRsCmRxx8PFci1ZFCWHblnegcg+85q4/N55BD+Uw/ZsnPAY
	GwyH7vtOtYstfzUCOYbERNZjaQXDKBLQo8Me6VoF8gPgNTm2wxnu2TFb4A5Uu/Mvh6UzRK
	MSPI+2lrRD/4/Wy9FQGzKz2Mf+9+DNI=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-32ec291a325so63521a91.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753537; x=1762358337; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Rp6UONa4RQroT/DFseWBOqeBQbwX964QzeqYggw97rk=;
        b=a/A97KCdaJ9InPTDb2HPJJS2pdzVYmJTaqljQDMJrxAoTSvBFNBamog0+404jdH2xE
         Z8X/imgmA2XyI/BKFff4H/9tTX+A1o6n2LRXo9BEF2n18iF/A5FtQmjkFX7rYrCy5rat
         l6kH3KQCYgL/aT1lMWltgrAySxr5JeircF7hyVnxVsKtS4Eo8KktxFW/6S9G+AWRe3PR
         mYF39Z39TTBeoWOFvx2eIHTPpajmwfAYiBgx2+PEM+IOpemSL3Mh0vzERiCeFh6LvhG1
         yuo61S9basNlrIJUvfCheNCEXCRwR3CuFvGioz3EzD0CeRQ9Y833rcfVPAPcQjRhx35R
         66BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753537; x=1762358337;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rp6UONa4RQroT/DFseWBOqeBQbwX964QzeqYggw97rk=;
        b=r2RKKJHwOl0fePszVqA3H73aa4xLbkIXNppws/yrDAGWK2grFV/tATXSt1f0QCjl+l
         jq+JSb5ialc/xvTQZEG2FKlM5OBRAH8r5pQf1Wk2Ek3PgNS7J0ms/+lH5Zid29Zm8qxP
         YcCWmeJwm5oSywokYlzUD7csx3RYeJtt82aXRsChcuOHoA6OnrxHtFjA8CuiX8dZXsH5
         zlLgdnOcPL7W610/n27XY8pqwksaLk1ZRbW4a/L0GQfXduLVI+qRDUL8DygEqDrvhuRs
         wJCLLhiu47aYfoKezBO/z1RHQqvCY5j6jUJrJW7eY2bmFHlAqqL0UZ85Be3bUb6Mh1uU
         G5rw==
X-Gm-Message-State: AOJu0YxQjacDu6+lQVcsuXuohfNldMTqOsQ62crpl3r+i+9auyBzQrGv
	LmvDqBrnps/DdSbGHEHItaiWIYqCvfT9pkJJO1csFq3P6bpITX2lAGm4
X-Gm-Gg: ASbGncvXL4dexTm5REIGCcxIi4PLNsuEOAXojPF1G6SYQ7+Tm/tnYxv3uZzFLHO8kxa
	v/Rh1CosAGPhI315zxZz5CAcVn9RNfyNrQ5BYqtwjoIR9W/eSY4JHYkmw5Y3NPNGZJ7kG6Azf0l
	/vW6TvOTNRyL2nn7eWzxp7vhn9pMyq9nS4cJ0kvtrTE2N1C4CXo5r5XgmItjQbOo6VJOHRBx+sv
	0ZFbDhgSfVUoqEpGwihT0Z9h1VuV+zF8/nwnF1Yw2Vc6G445I1jYbytQQ1YfME7+Q5BsfapWROE
	YJ491CdL1sGNL5IBkpoUVgRoVbpsYFg2b6UfNzy06DuOunMUIwfB4+wVzwFZhJiK1aR3EabFVel
	qmlrl5ERKmPURFd3l+iYBZ8V3b/6QSCavnNw8IfiBNTzwNhNwLml2ltTmEayqzRpgTXlsUFI53t
	qbPQmCm+bO6Q==
X-Google-Smtp-Source: AGHT+IENxrO2rFfWZghD173MYTy/76Go4Z1vLaGV7TWb3mCr4J57kgcgIdVFq3BvAFIGNQG/Gx7HsQ==
X-Received: by 2002:a17:90b:2dc9:b0:33b:bf8d:616f with SMTP id 98e67ed59e1d1-3403a2a202bmr4241835a91.20.1761753537047;
        Wed, 29 Oct 2025 08:58:57 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.08.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:58:56 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Subject: [PATCH 00/19] mm, swap: never bypass swap cache and cleanup flags
 (swap table phase II)
Date: Wed, 29 Oct 2025 23:58:26 +0800
Message-Id: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKI5AmkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDAwNz3eLyxALdksSknFTdAiNd8xRjAwuzVNNkY4tEJaCegqLUtMwKsHn
 RsbW1ANdUNh5fAAAA
X-Change-ID: 20251007-swap-table-p2-7d3086e5c38a
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@redhat.com>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Huang, Ying" <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Stat-Signature: qp4msbse41kbjdj4n33zqoozpap1sahr
X-Rspamd-Queue-Id: 85C7FC000D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761753538-169271
X-HE-Meta: U2FsdGVkX19kLMhrGQRvLBUsCl/EGzTpgd5f2emxoVgppHtWJXVEOug6LWKYA1zljtjcIRKTH6aPCUhlGo7ypbwb1J4IerZAtQgpIY62ESCYeERylY2ocKXrA13KNMKg+/GKvWyRKT0slQ0Kii1L/pCRZQm+PUpodDI3s1les/f4j4KP4Ekg23n3vp0I2IwLYwqypSoCzA1WMGyyEdNow9AvvD57FOsJx6hnyEUwBD7yk6OqY6CiDx11KKIg3Rl+juicrztp2J2qoX06h5NPWtk8CdgppZ4FeJ9o2SBfWGPunuYHPfOsYMunGFRH69o2ihmrYp9AMKDHCoP8Uolq6Mz0ydDxxaGLMlgiCD16zXvHkM+lsLQTEGpRces2AthWxVIor+jXOAeSpsjs5dpmBzZX8aovNkC/xTnWDz6dVRXUJyZx60mCzd0l0lcKU/GWNyjG9Kuz3M1pHj9PQbAcdKjvnTpv9+RgIQwPQDTmy64pVhjZWH+KZHlxEQZQaK1YUT/AogncPtHXj/RL4o+HeUqzd0jqhgWYZgmA1DFRdjK4fxflfPCKoDCquPA4v+oD7QOJaTQWWdXMKUK++tINzWTqWKR9eQlMiY8OOvlQoFhzEWSdzApWRf8cjJNh3HqYkZIhWGu971hjK1m2ijpdNTUfGLeuLvp21BxTy0CuBhPyhSwuHim90kRVBXLLF5mHW4pGs5Nn0vrLcgTL4exyj6kbDPSqsrrj0UA8bAW/fdQF3BaCrSdEoSB5FHq4hQ25FV1qXw1SHu2sbmAHp2mPn3SQrzfM0MJ9AU2+z/ivAQ2ANA8qNFRzEBrG5oauKbaPfpJBK1icFY48WgFHAVs5q87ZKQesvqlNFLzq8ZC+N8el7ICjPLR7iUQiXjJ7whsoA4eOTK672y+dCVGlQWZVULmaemLBTVgcHRQPdIXmuo82atVjbZ5JpIVBWSloYgjeyRMHWurrYXsX1dBETk1
 CMzua6s/
 0g+Cws1whu8Q4oKKUds9oVDP71OflUxSNLezxbew18ska6K4DX1DjdEWaBEgN+cAv9HbvgL6sbZ9/dcWLS+V5b5hmqvElQKOM/1gunJhLYmO5ydsUjnMmHxWGh6PrR7Ms5JJcSLx+wAXHLbSyV0xrTSYKRB4JafXu5ASjpI9F8thjDQt7wfd7ruWOgPjJWQ1pd9+G3UBn1sTHvvoirLerpCd8QO1XcSnIN4e3WRo62hdDvy6cq/NoxgbB4IWHwc6qCadce6DjM+1Ocfftr1cOJ2UjDkyUaSRxhQIaeyDksoiyIbtYRLlVE0yuiF9HhzMjshsP091/xhZIXAtKtV+SPqUxIBatd+25vjiq5dGRTYPIU3NaSBhbyBBsLEaoRB2es5EZBEZGZIdnnOlsiP+pjYGS//O7z2hums5fnTzeL8nt8zejd7FTiSoJtzMRHS6YuAe56fRkNh6ZRYTk5CKROsotQQNYfhcu8BTQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series removes the SWP_SYNCHRONOUS_IO swap cache bypass code and
special swap bits including SWAP_HAS_CACHE, along with many historical
issues. The performance is about ~20% better for some workloads, like
Redis with persistence. This also cleans up the code to prepare for
later phases, some patches are from a previously posted series.

Swap cache bypassing and swap synchronization in general had many
issues. Some are solved as workarounds, and some are still there [1]. To
resolve them in a clean way, one good solution is to always use swap
cache as the synchronization layer [2]. So we have to remove the swap
cache bypass swap-in path first. It wasn't very doable due to
performance issues, but now combined with the swap table, removing
the swap cache bypass path will instead improve the performance,
there is no reason to keep it.

Now we can rework the swap entry and cache synchronization following
the new design. Swap cache synchronization was heavily relying on
SWAP_HAS_CACHE, which is the cause of many issues. By dropping the usage
of special swap map bits and related workarounds, we get a cleaner code
base and prepare for merging the swap count into the swap table in the
next step.

Test results:

Redis / Valkey bench:
=====================

Testing on a ARM64 VM 1.5G memory:
Server: valkey-server --maxmemory 2560M
Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get

        no persistence              with BGSAVE
Before: 460475.84 RPS               311591.19 RPS
After:  451943.34 RPS (-1.9%)       371379.06 RPS (+19.2%)

Testing on a x86_64 VM with 4G memory (system components takes about 2G):
Server:
Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get

        no persistence              with BGSAVE
Before: 306044.38 RPS               102745.88 RPS
After:  309645.44 RPS (+1.2%)       125313.28 RPS (+22.0%)

The performance is a lot better when persistence is applied. This should
apply to many other workloads that involve sharing memory and COW. A
slight performance drop was observed for the ARM64 Redis test: We are
still using swap_map to track the swap count, which is causing redundant
cache and CPU overhead and is not very performance-friendly for some
arches. This will be improved once we merge the swap map into the swap
table (as already demonstrated previously [3]).

vm-scabiity
===========
usemem --init-time -O -y -x -n 32 1536M (16G memory, global pressure,
simulated PMEM as swap), average result of 6 test run:

                           Before:         After:
System time:               282.22s         283.47s
Sum Throughput:            5677.35 MB/s    5688.78 MB/s
Single process Throughput: 176.41 MB/s     176.23 MB/s
Free latency:              518477.96 us    521488.06 us

Which is almost identical.

Build kernel test:
==================
Test using ZRAM as SWAP, make -j48, defconfig, on a x86_64 VM
with 4G RAM, under global pressure, avg of 32 test run:

                Before            After:
System time:    1379.91s          1364.22s (-0.11%)

Test using ZSWAP with NVME SWAP, make -j48, defconfig, on a x86_64 VM
with 4G RAM, under global pressure, avg of 32 test run:

                Before            After:
System time:    1822.52s          1803.33s (-0.11%)

Which is almost identical.

MySQL:
======
sysbench /usr/share/sysbench/oltp_read_only.lua --tables=16
--table-size=1000000 --threads=96 --time=600 (using ZRAM as SWAP, in a
512M memory cgroup, buffer pool set to 3G, 3 test run and 180s warm up).

Before: 318162.18 qps
After:  318512.01 qps (+0.01%)

In conclusion, the result is looking better or identical for most cases,
and it's especially better for workloads with swap count > 1 on SYNC_IO
devices, about ~20% gain in above test. Next phases will start to merge
swap count into swap table and reduce memory usage.

One more gain here is that we now have better support for THP swapin.
Previously, the THP swapin was bound with swap cache bypassing, which
only works for single-mapped folios. Removing the bypassing path also
enabled THP swapin for all folios. It's still limited to SYNC_IO
devices, though, this limitation can will be removed later. This may
cause more serious thrashing for certain workloads, but that's not an
issue caused by this series, it's a common THP issue we should resolve
separately.

Link: https://lore.kernel.org/linux-mm/CAMgjq7D5qoFEK9Omvd5_Zqs6M+TEoG03+2i_mhuP5CQPSOPrmQ@mail.gmail.com/ [1]
Link: https://lore.kernel.org/linux-mm/20240326185032.72159-1-ryncsn@gmail.com/ [2]
Link: https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmail.com/ [3]

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Kairui Song (18):
      mm/swap: rename __read_swap_cache_async to swap_cache_alloc_folio
      mm, swap: split swap cache preparation loop into a standalone helper
      mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO
      mm, swap: always try to free swap cache for SWP_SYNCHRONOUS_IO devices
      mm, swap: simplify the code and reduce indention
      mm, swap: free the swap cache after folio is mapped
      mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_IO
      mm, swap: swap entry of a bad slot should not be considered as swapped out
      mm, swap: consolidate cluster reclaim and check logic
      mm, swap: split locked entry duplicating into a standalone helper
      mm, swap: use swap cache as the swap in synchronize layer
      mm, swap: remove workaround for unsynchronized swap map cache state
      mm, swap: sanitize swap entry management workflow
      mm, swap: add folio to swap cache directly on allocation
      mm, swap: check swap table directly for checking cache
      mm, swap: clean up and improve swap entries freeing
      mm, swap: drop the SWAP_HAS_CACHE flag
      mm, swap: remove no longer needed _swap_info_get

Nhat Pham (1):
      mm/shmem, swap: remove SWAP_MAP_SHMEM

 arch/s390/mm/pgtable.c |   2 +-
 include/linux/swap.h   |  77 ++---
 kernel/power/swap.c    |  10 +-
 mm/madvise.c           |   2 +-
 mm/memory.c            | 270 +++++++---------
 mm/rmap.c              |   7 +-
 mm/shmem.c             |  75 ++---
 mm/swap.h              |  69 +++-
 mm/swap_state.c        | 341 +++++++++++++-------
 mm/swapfile.c          | 849 +++++++++++++++++++++----------------------------
 mm/userfaultfd.c       |  10 +-
 mm/vmscan.c            |   1 -
 mm/zswap.c             |   4 +-
 13 files changed, 840 insertions(+), 877 deletions(-)
---
base-commit: f30d294530d939fa4b77d61bc60f25c4284841fa
change-id: 20251007-swap-table-p2-7d3086e5c38a

Best regards,
-- 
Kairui Song <kasong@tencent.com>


