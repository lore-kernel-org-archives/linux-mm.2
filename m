Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A704FC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 12:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B84B36B008C; Fri, 11 Sep 2026 08:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36C06B0092; Fri, 11 Sep 2026 08:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4D6B6B0093; Fri, 11 Sep 2026 08:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7EA6B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:13:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 053651401B3
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:13:52 +0000 (UTC)
X-FDA: 85201372746.09.4E5AEF3
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1382F1C0006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:13:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789128831;
	b=mOGwk9CYgstKzYFYLB/GHpWfp0i5rq/F+NGc6iKl0cCOoGUPfW5mEv+ShPAeZrylNplgrW
	je48BT0oH0DJJqgkj2cEAVN0pucrVT7+fvmqIySe84aJXT/y/jVsFoswq6E/CFA9up/vFG
	jRVnShF86Cu3SsYsguvOSHucr6oUP7E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789128831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=rn/YBtUpZZ8AkspJ6DdxZiLrKd0D14X6TxHr27FGusA=;
	b=ykOzCadVW23q2umh2hSV6khYF68Mbfc+hdiBtGkbtVRErfxiKck0oxno+QifLmOmido+De
	HIJvFF0PIwBWytb/2/nBPcuJfwUPMSRge/F7QsZWhNWfbMKgSXKchXtd5EDZYo08fgYPlt
	lpA1u6WB7W59UqOxLa+7XOMDosEOgno=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 8B5253ED66;
	Fri, 11 Sep 2026 12:13:43 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Tal Zussman <tz2294@columbia.edu>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v5 0/3] mm: zswap: free cold writeback folios promptly
Date: Fri, 11 Sep 2026 14:13:27 +0200
Message-ID: <20260911121341.178028-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTF0WDL/f2k4cldBYDI+o9ZlYZps9V5cGp5Dpt9NPc7WStEtPmZ9SunsNMcl5f5thdTuCuG9K0248RgfLILvM3hGdPquOA7FnXSIshisq3TyNM8nACRF1+b1sQ5OCl7/LnepdASXoR9KDQJTDxlyuzVtd4sEya4b6Efef64T6aJYJnlXKeQK3hIiRpsBJY/2xBJtGolzCQPrlMgA7Zfjq0ZSHW/nWz1A9MFppkf8aAqayEKKbXgGSSw6oXQH0y8kS2wL/9AWfYUqAIztqKXrxpEPGc9+77dyUwsml+BQt1B33dT/zrHHy5Pefin4GXVaHCli1dAHesCThK4k0BxZac2XsPoMgAqSMIGIJufU/baAYk2y9kd1HsKZAqb8+RQQQqIWMED9asKAKCEUASo/pIrPfo9Rb1+nPPV+6hryCg6wnEbn5pqtBalFPFpCVXgcyuFC1Xe3/tXVIXXAHT25IQC9QUVHPKNZnn8VqiB1GD4lZ4jNfmuNQFh2Mo0mA3OPEoai+9YPfwNQGiS/y6ouPi15RjaG6dRWfXl3JhDbVEIW1yy8/xmjtgIiZRC8JFErKrTLq6RvivCG2T49VCO0U24B9jVWmfxsWdEDDJ5iDn8WdzzRaauhTFnLUEO+qK1ebXGp+DLK2NjatpcSINaygrwzBTcvR9jPIvCLJOFI34HidQ
X-Rspam-User: 
X-Rspamd-Queue-Id: 1382F1C0006
X-Stat-Signature: rkoj63scxteuu3wezox9fhyjn3ss5qug
X-Rspamd-Server: rspam01
X-HE-Tag: 1789128830-221822
X-HE-Meta: U2FsdGVkX18a4tsd2V60BMUTQplFjd2N9OHzGvFTgO552/eBrMNX950/e2jckq/ET2Dtt7yQuaiTNJWcH/YlIhy41LUcwccPZSK8t6WfR2F5NBBhviR2nSJRpyqHvYoBfZ2tIgzeS2gVSMSMtCe61C4i1BVDIRUu/PJqdmmGL8Qz6JXolkU7FTKOpsH30UuQ01mPkOIyUcs/Eh8o2LEcd/emtVTNtyzlNF3RZCQ/tVdgRRs9MrTIfEFpx4uIAl8ozHF5OeRpyM+xGx5PLq12UMzMh5uBFC+kQWXiF8u3kfR+g0mnfU1sQtou3jF7oAh/wcNN+QdK0KIv/J1VkoJ+4NA7gzjpxVAsozHUoHqbVyfRKOPT2mRAN6RTL2XyFAnkUsbMK5GqWioELfmyiiIXRfcRz/v2jKVSmIT23yxhGcOYjSlkNeWRmaJFiHRPfIi/J8Q2efgc3sblw7QSHaakPZ8FfdKjdGqKNwfx378Sw/TP0Eh4SBgWbG9S3UTEbXAhQeTMRfrYK5T5KLNzvSNzsiHWBgGsLoo70Qe8pniFOTodIDQ4orIKn67gNDLb72MVKkmdN6c3bL0k86wuMXRLwX3gDd5p5ljjSU7J94X7oOU+bOsWCaRMyVsQKaj7uTjUNR0aKYuRGI3WyxTc1kttsIqJ9bX7lPZTDZWUY95glP2QD1kJa64JDnPi9338Y+nMvB24XlhYzc3C3wpmelPOBBbPwlIoxTlaG9/LTmb+HGADRURjrIyaIyqzoaB9cHQuAi0+WEg65tSlxyYF57pFzbHEYK3Bw3+L1BwZpP330+tO5+YoWIADfdUi3zbZs9Ud3SJANpxFkgoZEgT4QSGgWHJDN8vdqD4IW7ElpQM/R+ySbDBr2DDFeu8ZtRJYiMKVkykDHeILM8ec6NDKb/IRiCibkoI9OgvCbSTC+/fyqT1bNgIJjr6NReyYy9nO07nB63Y4WhSErr/Q+LFmxVE
 n5cm5bzG
 uaJGt04BB7zc8EtymVZNlMftx5jHYqIOyXt16rToSgvyAmY9rBes0YlujnaZ+DHYba0i9N6UCJE1Y/jFkKTaMQDPi1N1f59F/7dHkN0XI/1Pqyx0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When zswap writes an entry back, it allocates an order-0 swap cache folio,
decompresses into it, and issues the write. The folio is cold by
construction, yet today it is left on the LRU for page reclaim to find and
free later. That wastes a reclaim scan and keeps cold memory resident
longer than necessary.

Rather than implement this in zswap, extend the existing dropbehind
mechanism to swap cache folios and have zswap opt into it (Yosry). A
PG_dropbehind folio is already dropped from its cache once writeback
completes instead of being left for reclaim; for a swap cache folio that
"drop" is removing it from the swap cache.

  Patch 1 - move LRU insertion out of the swap cache allocator into its
            callers, so zswap writeback can allocate off the LRU.

  Patch 2 - drop dropbehind swap cache folios on writeback completion.

  Patch 3 - zswap allocates its writeback folio off the LRU and marks it
            dropbehind, opting into the mechanism above.

Note: patch 1 also appears as patch 1 of the zswap writeback refault
series [1]. It is the same patch. Both series need it and both are meant
to apply on their own, so it is posted in each; whichever lands first, the
other should drop it.

This version is based on mm-stable. v4 was based on Linus' tree because
Tal Zussman's BIO_COMPLETE_IN_TASK work had not reached the mm tree yet;
it has since, so that detour is no longer needed. Thanks to Matthew and
Barry for pointing that series out!

v1: https://lore.kernel.org/linux-mm/20260718093723.153324-1-alex@ghiti.fr/
v2: https://lore.kernel.org/linux-mm/20260727143618.1582318-1-alex@ghiti.fr/
v3: https://lore.kernel.org/linux-mm/20260818163221.589352-1-alex@ghiti.fr/
v4: https://lore.kernel.org/linux-mm/20260825135209.3135169-1-alex@ghiti.fr/

[1] https://lore.kernel.org/linux-mm/20260911092012.92399-1-alex@ghiti.fr/

Changes in v5:
- Rebase from Linus' tree onto mm-stable, which now carries Christoph's
  swap_io_ctx work. __swap_writepage() takes a swap_io_ctx and the bio is
  built by swap_bdev_submit_write() from a batch of folios, so patch 2 sets
  BIO_COMPLETE_IN_TASK there instead of in the old per-folio async helper.
  The bio can hold several folios, so the flag is set if any of them is
  dropbehind; only the asynchronous branch needs it, as SWP_SYNCHRONOUS_IO
  already completes in task context. Patch 3 follows the new
  __swap_writepage() + swap_write_submit() pair.
- Patch 3: clear PG_active on the writeback folio after allocation.
  __swap_cache_alloc_folio() evaluates a refault, which can set PG_active;
  with the folio kept off the LRU nothing clears it again and the folio is
  freed with a PAGE_FLAGS_CHECK_AT_FREE flag set. This goes away once the
  refault evaluation moves out of the swap cache allocator in [1].
- Patch 2: rename remove_mapping_reclaim() to remove_mapping_set_shadow().
  Storing the workingset eviction shadow is the only thing that sets it
  apart from remove_mapping(), so name it after that rather than after the
  caller that historically did it (Nhat).
- Patch 3: the success path now returns directly, so the "if (ret)" in the
  error path is dead and the label is only reached on failure. Drop the
  check and rename the label from "out" to "err". Thanks Yosry for
  spotting this!
- Patch 1: take the version from the zswap writeback refault series [1],
  which is where it has seen the most review. The changelog now describes
  both users of the change instead of only this one, and it picks up the
  stale swap_cache_alloc_folio() comment fix in mm/swapfile.c (Kunwu). The
  two copies are now identical apart from the base they apply to.
- Collect Reviewed-by tags. Thanks to Kunwu and Nhat for the careful
  reviews, and to Usama for the ack on patch 1!

Changes in v4:
- Rebase on BIO_COMPLETE_IN_TASK: set it on dropbehind swap writeback like
  the file dropbehind paths do, and drop the folio directly from
  folio_end_writeback(). This removes the per-CPU llist, the workqueue and
  the reuse of folio->lru as the list node.
- zswap now drops its folio reference before starting writeback, so the
  swap cache holds the only one and remove_mapping() sees the refcount it
  expects. This fixes the drop on synchronous-IO devices and the race
  Sashiko reported, where the drop could run before zswap released its
  reference and fall back to the LRU. Verified on zram (the only
  SWP_SYNCHRONOUS_IO backend I have): over ~6.7M writebacks per run, 99.999%
  of the folios are dropped, and the refcount fallback fires 37-50 times.
- Use remove_mapping_reclaim() rather than adding a boolean argument to
  remove_mapping(), which keeps the calling code readable (David). This also
  leaves the existing remove_mapping() callers untouched.
- Patch 1: correct the changelog. The folio has to stay off the LRU because
  folio_add_lru() leaves a reference in the per-CPU LRU batch, not because
  of the free-time page-flag checks. Measured on zram, adding the folio to
  the LRU instead drops the freed rate from 99.999% to 2.7%.

Changes in v3:
- Drop the synchronous-IO special case in zswap writeback (Yosry, Nhat).
- Use mem_cgroup_tryget()/mem_cgroup_put(): struct mem_cgroup is only
  defined under CONFIG_MEMCG, so css_tryget()/css_put() failed to build
  with CONFIG_MEMCG=n.

Changes in v2:
- Make swap dropbehind a generic core-mm mechanism that zswap opts into,
  rather than a zswap-specific implementation (Yosry).
- Allocate off the LRU by moving folio_add_lru() out of the swap cache
  allocator into its callers; rename it to __swap_cache_alloc_folio()
  (Kairui).
- Skip the folio in the free path if it is still under writeback (Nhat).

Results
-------
Paired baseline vs series on async swap (NVMe). Each
workload runs confined to a memory cgroup (memory.max) small enough to force
zswap shrinker writeback.

Kernel build (defconfig, make -j4; memory.max = 600M):

  metric            baseline       series      delta
  pgrotated           441028         2521     -99.4%
  pgsteal_direct     3524343      2869004     -18.6%
  pgscan_direct      8393791      7765008      -7.5%
  zswpwb              705129       699019      -0.9%
  build time (s)        1155         1114      -3.6%

Of the 699019 folios written back, 698990 (99.996%) were freed promptly on
writeback completion; only 28 fell back to reclaim.

MySQL/OLTP (sysbench, 10 tables x 1M rows, 512M buffer pool, 8 threads, 300s;
memory.max = 256M):

  metric            baseline       series      delta
  transactions/s      153.87       163.30      +6.1%
  p95 latency (ms)    157.42       145.82      -7.4%
  avg latency (ms)     52.09        49.05      -5.9%
  pgrotated           743738        22460     -97.0%
  pgsteal_direct     6886490      5445278     -20.9%
  pgscan_direct     13462510     10820730     -19.6%

Future work
-----------
Barry suggested extending this to MADV_PAGEOUT and general reclaim. I
prototyped dropbehind for all reclaimed swap folios and it regressed
sysbench OLTP throughput by ~15% on NVMe swap: dropping the swap cache
immediately turns cheap in-cache refaults into disk reads and collapses
swap readahead clustering. Neither blk-wbt, mq-deadline nor a PG_workingset
gate recovered it. MADV_PAGEOUT alone may still be worth it, since there
userspace has explicitly declared the range cold, but I have not measured
that case in isolation yet.

Alexandre Ghiti (3):
  mm: swap: move LRU insertion out of the swap cache allocator
  mm: swap: drop dropbehind swap cache folios on writeback completion
  mm: zswap: drop cold writeback folios via swap dropbehind

 include/linux/swap.h |  6 +++++
 mm/filemap.c         | 19 ++++++++++++++
 mm/page_io.c         |  9 +++++++
 mm/swap.h            |  6 ++---
 mm/swap_state.c      | 62 ++++++++++++++++++++++++++++++++++++++------
 mm/swapfile.c        |  2 +-
 mm/vmscan.c          | 49 +++++++++++++++++++++++++++-------
 mm/zswap.c           | 36 +++++++++++++++++--------
 8 files changed, 156 insertions(+), 33 deletions(-)


base-commit: 0d9ff90a5422cc7509258aaaba1e7481df4d332a
-- 
2.53.0-Meta


