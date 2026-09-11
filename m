Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E92D8C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8A836B0095; Fri, 11 Sep 2026 05:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3BC26B0096; Fri, 11 Sep 2026 05:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B3E6B0098; Fri, 11 Sep 2026 05:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A27E6B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:20:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4DB412017E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:20:23 +0000 (UTC)
X-FDA: 85200935526.18.E40562D
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id 07DFC1C0008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:20:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789118422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=CEM5r8+sI6rPviTbXxLUEaQ7XxarlPI77nzUSlo95n0=;
	b=1b/mF0/9hw0wKrJwuNVlZGwwh3OfVEeO95D4JKaryGxaO0Ae04L0oAszxJnjlorN61xGuE
	+Rxecp6m8foJP9Am2g6O/ZKZnpy1VBGA9XqA5ThC9yrTGa7jBNG9MjgECtmApBjiG8Sx9n
	P5Aw5TuGYcLXxUaX8VmtTZfViSq+joc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789118422;
	b=ODWflQMT/WIZy2sWWW9sL7Q3vQ66idw0hWEckSRxtg5aMiWOMg9FRkTcBia7/j2Wj9qnqT
	G8bZYSbxcNIlX1kWj9URMQXyXT/Ln6QSGQaeYg95rP9HaJFTFQHXviMWKs6H5WMiNQRQ4B
	TfNOMLQJ7zSZgL0FhDuqsLDt/MpUqyU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id C948D3E972;
	Fri, 11 Sep 2026 09:20:13 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v4 0/3] mm: fix workingset refaults in the zswap writeback path
Date: Fri, 11 Sep 2026 11:20:04 +0200
Message-ID: <20260911092012.92399-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGzWbzMA5QZanrT8MgC66CDhbKxneLy9Ay/yxMlFVji2OLfhXWQPDvA1tdKqdI4htUQ8rGaY98avqsZNnswh6aMbdwtiezvc7z1tC/Owq0KcV4QllV1SC7O7vY4OsviYvKSYizj54HeiO5NtcHBPpIsNQ0cLcmY0VU+o2O9iLuLxN7Y58cOu9EHyl2cmQQLPtCZYwGCRKbz/GfbYlc6SmLlTs6HausImgU1yP0ti3L7sYEczYM5t5PzUTriKDLL3/Z1DbMXKeHgViDpSRIzpVfSFaFCNhfltK/w6Mqub6XWyQi7gjVWslDKhbP14+qYeF75e07YklW7BqLi4wijPvvvQ723VilEeyZd7lSAC1kK7tTvIXyAMQSpfqkIMBNwjlYc3WYIsgcdMqQOnYRWoqsmjBVxxDQeKRx3CpID/k0CjMNF4JNxGWS/rq//O2xLW3X5zrhPArR822rbcvyjhlCYjv+VqRXWZ8jcO3pwiAi3IiYre4qWQzkVwJ/hyasSRSWPlMgCkG7ViBCiMUB4sNXQkgw8Cbw1ZZg0+sBDAMa8Fu1Cx+fRQ/3ft4K+XjCIUj+AbuYv+z7v6avh8T+2h3k4ls7WoYMLFIQnJeHljZT+jUcQm98qltouk18n50Cp4vJU0ts3FwUH8YjQRnWq0ldVApoFk9Mf3kwZg7He33ORXA
X-GND-State: clean
X-GND-Score: -100
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 07DFC1C0008
X-Stat-Signature: sftkx5jfg759kjq5k5htic7g5ficwozp
X-Rspam-User: 
X-HE-Tag: 1789118421-738250
X-HE-Meta: U2FsdGVkX18sPdNwtEJYEcHgJVBu90sqE0WZtXZsvO2M5siU+Nq2ZcCtaG3YtoJ7A+iEE05S8N1ud5SKKQ4MhqAC1Gpit21gjHP/73TRpbVfv6QTgTPN/eWERYsVRgRJrQgO/P+qeClyaHu+bjeko/GUMgrVeEn8l+jk85fFuy4Kh4wJ9E5MbBp+pdMJqd+kzytpi1iTcijNdUEs0hyHV/HkbylMqvp/kK3kPad5u8K80pQy3WmAX3ZhnIXGm0AtZYORWF4go+6C3LKoLv0XytsbMtSQWDJFXPCrA6wC7tt8b6snhLQWqJdRZfZkamipXv0KzFluL+PanmSGBjttdJjenUDi29g8o+zL5n+kvvlywgVJ29u+Al8Cq0r5AnbAH2cyJN4gGndbpqv/XaAFB5utZ4l6JDy8+xQByUM3QlNnpSeOCeMG8G2I1cU2DI0ZM7Si29QXKVdF8cm5DPI5FWXSehRtYm4yOGBSHuITURCF+PLJpzACeYlttwx3hzXxk0w9UJ4IO7Mw1eJ/znS1Zpc/okejJLb3krqddyRchF5LxOBGVTLdz1WjM0hjj8yFZIuS4bHSU05/tf11gRPdlazO8Oq+rWPU0utmcQJWfbnmeny1Ym0FeReWGE8YcJYKF9EJ+pq9EUyFtixYJm0gRpdA6L5aFUJPHxW4FvDwmnbOplj6U7D8wXvxzofIKAHp9AM8l5edj+tXbdM6+atTTtDJs1HBt/GfQTragbtxh0y5BB0dvTRep021Ad6i9u4QjVeJEdr9e3CTdo8x2RWj40ZXYd0uX2PYqT/Jh93NrAiKz9XZjpgTIxmRk8nN06nyIe0PFecH3PM8jID/mAaO/hv5Rj0bCFk/8i6TaGP3OejN1Um1UXFJ99ER5eCLDwiv5mZvZDaleigl47uhPwtQ9BeAD4PYgvZfXxS2LlJbm23daqSvvz6BypQF/16xS7RY4081RIo+hBmgHdbbqJl
 ywFijRto
 tjUOyytf9/YesFWbQxu6LAsuPcEv51m/bnkN6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Note: patch 1 also appears as patch 1 of the zswap dropbehind series [1].
It is the same change. Both series need it and both are meant to apply on
their own, so it is posted in each; whichever lands first, the other
should drop it.

When an anonymous folio is reclaimed, workingset_eviction() stores a
"shadow" (the eviction cookie) in the swap slot so that a later swap-in
can be recognised as a refault and, if the refault distance is short
enough, the page can be re-activated. This is how anon workingset/refault
detection has worked since commit aae466b0052e ("mm/swap: implement
workingset detection for anonymous LRU").

zswap writeback breaks this in two independent ways:

  - Over-count at writeback: the shrinker allocates a buffer folio in the
    swap cache, and the allocation path counts that folio as a refault.

  - Lost eviction cookie at reclaim: adding the buffer to the swap cache
    overwrites the slot's shadow, so the original cookie is lost; when the
    buffer folio is finally reclaimed a fresh, inaccurate cookie is minted
    in its place.

This series preserves the shadow within zswap itself, without any new
swap-table or swap-slot state. At writeback, instead of erasing the freed
zswap entry, the captured shadow is parked in the zswap tree in its place,
so it outlives the writeback buffer folio.

Finally, the refault evaluation is moved out of the swap-cache allocator
into the swap-in callers, so allocating the writeback buffer is no longer
miscounted as a refault.

Results
-------

Measured with a sysbench OLTP (MariaDB) workload in a memory cgroup sized
so the dataset and InnoDB buffer pool both overcommit it, with the zswap
shrinker on so entries are continuously written back to an NVMe swap
device (classic LRU; MGLRU off). Anon workingset counters over the
measured window, baseline vs this series, mean +/- stddev over 10 runs:

  workingset_refault_anon    383,242 +/- 59,345  ->  199,355 +/- 27,042   -48%
  workingset_activate_anon    54,890 +/- 11,742  ->   22,607 +/-  3,118   -59%
  workingset_restore_anon     16,212 +/-  4,590  ->    7,599 +/-  1,190   -53%

Writeback volume is comparable (zswpwb 183k +/- 16k -> 178k +/- 15k), so
the reduction is not from doing less work. Normalised per transaction the
reduction holds (-53%/-49%/-39%) while the swap work per transaction is
unchanged. A kernel build under the same pressure moves all three
counters in the same direction.

The run-to-run variance of these counters drops as well.

Throughput is unaffected: over the same 10 runs, transactions/s is
18.50 +/- 1.08 -> 18.65 +/- 0.94, i.e. +0.8% with a 95% confidence
interval of +/- 7.7%.

Changes in v4:
- Usama pointed out that patch 1's changelog referred to "the next patch"
  and to the "upcoming" dropbehind series, which does not work for a patch
  posted in two series. Both references are gone.
- Kunwu Chan pointed out that mm/swapfile.c still refers to the function
  by its old name in a comment; patch 1 renames it there too.
- Usama pointed out that reading the slot's shadow in the swap-in path
  before allocating races: the allocation can sleep, so another swap-in
  can install a folio, have it reclaimed and leave a newer shadow behind,
  and this caller would then win the insertion but refault against the
  stale snapshot. __swap_cache_alloc_folio() now hands the shadow back
  from __swap_cache_add_check(), which captures it under ci->lock at the
  point the displacing insertion succeeds. zswap writeback took the same
  racy snapshot and now uses the same output.

Changes in v3:
- David pointed out that the boolean added to workingset_refault() in v2
  makes the calling code hard to read. The boolean is now internal to
  mm/workingset.c and the callers use workingset_refault() or
  workingset_refault_lru_managed(), the same way remove_mapping() and
  remove_mapping_reclaim() do. The three existing callers are left
  untouched.
- zswap_writeback_entry() now restores the shadow into the slot on the
  error paths taken after the buffer was allocated: the allocation had
  already overwritten it and nothing was parked yet, so it was lost.
- Dropped the "if (!shadow) shadow = ZSWAP_WRITEBACK_NO_SHADOW" fallback,
  which can never be taken: the swap table already marks a swapped out
  slot with xa_mk_value(0), so swap_cache_get_shadow() never returns NULL
  for one.
- Rebased on mm-new.

Changes in v2:
- Sashiko pointed out that v1 evaluated the refault after folio_add_lru(),
  which picks the MGLRU generation before PG_workingset is set. Patch 1
  now moves the LRU insertion out of the swap cache allocator so the
  refault is evaluated before it, as it was originally.
- Sashiko also pointed out that a failed writeback redirties the buffer
  and leaves it in the swap cache with its shadow still parked, so a
  later zswap_store() on it would hand the parked value to
  zswap_entry_free(). zswap_store() now bails out for such a folio:
  writeback already decided that data belongs on disk, so it is written
  there instead of being compressed again, which also keeps the parked
  shadow intact until the folio leaves the swap cache.
- The buffer folio a swap-in consumes is already on the LRU, so the
  refault there cannot activate it by setting PG_active: that leaves the
  flag disagreeing with the list the folio is on, which shows up as an
  mm/memcontrol.c lru_size underflow when it is freed. Such a folio is now
  activated with folio_activate() instead. One still sitting in a per-CPU
  batch cannot be moved safely and just misses the activation; a counter
  on that path measured 0.0007% of the activations over a 10 run test.
  This is only needed because zswap writeback still puts its buffer on the
  LRU: once it stops doing so, workingset_refault_lru_managed() has no
  caller left and can go away.

[1] https://lore.kernel.org/linux-mm/20260825135209.3135169-2-alex@ghiti.fr/

v1: https://lore.kernel.org/all/20260817144622.137133-1-alex@ghiti.fr/
v2: https://lore.kernel.org/linux-mm/20260821093606.2231216-1-alex@ghiti.fr/
v3: https://lore.kernel.org/linux-mm/20260825172604.3243589-1-alex@ghiti.fr/

Alexandre Ghiti (3):
  mm: swap: move LRU insertion out of the swap cache allocator
  mm: swap: refault on swap-in, not in the swap cache allocator
  mm: zswap: preserve the workingset shadow across writeback

 include/linux/zswap.h |  12 +++++
 mm/internal.h         |   1 +
 mm/memory.c           |   5 ++
 mm/shmem.c            |   5 ++
 mm/swap.h             |   7 +--
 mm/swap_state.c       |  52 +++++++++++++++-----
 mm/swapfile.c         |   2 +-
 mm/vmscan.c           |   4 +-
 mm/workingset.c       |  60 ++++++++++++++++++-----
 mm/zswap.c            | 108 ++++++++++++++++++++++++++++++++++++++++--
 10 files changed, 224 insertions(+), 32 deletions(-)


base-commit: 1a46b1e97bde62afa7d925bb0dcd9f9748a1d7c3
-- 
2.53.0-Meta


