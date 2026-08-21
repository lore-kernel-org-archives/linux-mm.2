Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE248C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 09:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B35396B009D; Fri, 21 Aug 2026 05:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0D186B009F; Fri, 21 Aug 2026 05:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4A0D6B00A0; Fri, 21 Aug 2026 05:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 798B46B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:36:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2A69160403
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:36:22 +0000 (UTC)
X-FDA: 85124771004.03.E9B8698
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1204EC0009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:36:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787304981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=SLru8MrF2SEQsVB5FqWQSfwnQd+Ld91blrofOXKzXok=;
	b=hd+8kTdm9klZ6tWUwnfKEQkX4wyAkIV+znYspbkidGqqw/qYEXnXVUsI0eIIuR7DJGXiSW
	q6FgDPMHIH37NNn1C3SXUuy1u/u3c98H0dbozo5YK8RRximoV+12qsZb1/tDAXmIMSibd8
	l/28g6NthsX9s+/LCuczp6EKgDzVsbw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787304981;
	b=3xonrNIsp0T5vtCWlkHH9pGw5zfnHv2Fv1AZOEhdAJcgK/JiY+g5h2LQ4gqbhEMLKxNiBj
	FN0plRKA2NqIRZZIA0e5KAu8yKnnrzMOmksIwc7lO29WDEUeV6kCwW+bEpnh0uuOoVnh2L
	4nkFb6xay76YcFRYn28a5mikpWqmtBo=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 6D1173EBFB;
	Fri, 21 Aug 2026 09:36:13 +0000 (UTC)
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
Subject: [PATCH v2 0/3] mm: fix workingset refaults in the zswap writeback path
Date: Fri, 21 Aug 2026 11:35:53 +0200
Message-ID: <20260821093606.2231216-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTEwviCPbXa1ZFZrUw0z7vH+1sFbSyo6tBkRxuTOwcpP8IdG78gK1MRr9L5+b353EgbpEhzGjjb/UmhK+ght2Fq4jMM1MCplTNGIEwhWvuUWjioGGeFKxfwvCjhdNoxcEy/nZJL26mooNs74ibmQHPpvOVtiBIMsTTy6eihdyatMqNlJ6/RFaeXrjTCzWIQ4V1zLlT5F3c730DjMZeYqx/ijpTjdM7q9eC/di+87qwWsFmiQwPk+Ze8EO/6U7n9BTUvywKEHPDwF3pjJDSoIQD71M4kPkw9bYERm6tF63fbVf67+Uf311uJjy5o7eFlOG/xXf62oJb1qU+VMhsm61us/XRJyt/lA1M9BzFryjYe1ln13ApESlmozrlz+4nXNCf0Z0K7pD861p27oEcelHsTMxxcICI8pPqJtOkVwZdrD8JPbGUQFJIL9SQLFX2nvd8hpuIGqdQ5gF3Y0GQDrXUr+Me2V/anO+ZT8rRiW1I4PD78phUVIzpVGTvTV6qcmF4T7pzXd4dIfRS5/Z9a8RA8SX68XENhEQVQaPNQnGIVgt9bo6gjj9xSkpAt+4sKrQSdKgRZX3WabVpD+o4bCBG1JPha2CMu55BCoRy3Z+1upnAL4NpTJTlp9LPkno8ykyrB4mw3nFKZ7q9F0CNBoCmaWLkYLfOYicu4lsXkgn3PJXw
X-GND-State: clean
X-GND-Score: -100
X-Rspam-User: 
X-Stat-Signature: b9pnq7hqxtfsn6hdqys79zqqwhq1hcdt
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1204EC0009
X-HE-Tag: 1787304980-681108
X-HE-Meta: U2FsdGVkX19r4EvOoVpaED9bdPuux8oUHbPBxfr6thqbV7EN3OrmCSpfWnG29L/IdD0QHILVszr5g/QP7jn31wvdZIjda9RsThqgxOmGMD9KH6LkSWIfFwpmoeoFk1N2ITc4vcQqZwxSgFAq0jy9uAModnirx/UVsxxgUzJFmhCRu7YpC1QCIk8KfJnGRIOFpMPQnBCGYXo8oLwsyrQIm9UydukYjiUD5Tw7MdM2HnJW/D0ef4WutK5NDl+M/rTP//UwkvpMoaPyNz0Bh+bSKzgwBYoIvV92ATyCHXnw9xkW48+cCco0tmu6H4XTQ17uyBZcJgdIU5iF4mRxKyrVIeSUiOxS9suqaLJnW6uGNOOBo8jYcmvZKmXafwTzwzWPAYgFkFTvlaJPFi1jQb1C+75E9PmjLo4pCzOIg/wuNAweLXiAjGU20idmq4M+wiyrwo3oJEss46w0DZJg6wTIr7c1v1I7IWU3Q+GyGOhzAGYS9aqsqZu7MvAgndyxTn36rjBlXJ8gmKauZ2q8s6eqS4xlc+hEvRcLcsTFimNmhXai5wjL+CJNa4Z7JORbMbAt2dV4DonqTYvXb8eEe8vATOd0eKx8hPn6qasXnkvgPRWR89Xa5Mj85vnxwiMw6yLE1dYOiZxVf4mCtMUjMLyOdRqGdzCPDhSjh+lx402nbT86J+b6CpKo0vaZtJ499ryW7kLwRqMkWhRg9D/N+JAhKTV7pxxuHyVuhaqbLE5icIze7xC+t9yTgC/xUPDnht4URautQhiIQ01tSZokL0BM/zzIuQr8BaRx44VB43W9JsFDfa76M4/MBMcMiX7OLXc9Oasot80hBJnFF5P8zjuKJd0bkFSQPUV2riCUhDD7zJH47ET4admWUC+nkUawyavSWishXUzaBP1ulnCCFlmpjlKLwpiJ+kZ4ut+c+6Y+xzJ6O+TDb5FUBX03lmdO6Y0ZRawxBGbfHBbXCCSEWXu
 dv0bky2F
 3Fin4II9GDbe8PHK2ytX9pcw2I8XcTVXsChyO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
  mm/memcontrol.c lru_size underflow when it is freed. workingset_refault()
  now takes whether the caller has already put the folio on the LRU and
  uses folio_activate() in that case. A folio still sitting in a per-CPU
  batch cannot be moved safely and just misses the activation; a counter
  on that path measured 0.0007% of the activations over a 10 run test.
  This is only needed because zswap writeback still puts its buffer on the
  LRU: once it stops doing so, every caller passes false and the argument
  can go away.
- Patch 1 is shared with the zswap dropbehind series; whichever lands
  first, the other should drop it.

v1: https://lore.kernel.org/all/20260817144622.137133-1-alex@ghiti.fr/

Alexandre Ghiti (3):
  mm/swap: move LRU insertion out of the swap cache allocator
  mm/swap: refault on swap-in, not in the swap cache allocator
  mm/zswap: preserve the workingset shadow across writeback

 include/linux/swap.h  |  2 +-
 include/linux/zswap.h | 12 ++++++
 mm/filemap.c          |  2 +-
 mm/memory.c           |  5 +++
 mm/shmem.c            |  5 +++
 mm/swap.h             |  6 +--
 mm/swap_state.c       | 50 +++++++++++++++++-----
 mm/vmscan.c           |  4 +-
 mm/workingset.c       | 16 ++++++--
 mm/zswap.c            | 96 +++++++++++++++++++++++++++++++++++++++++--
 10 files changed, 176 insertions(+), 22 deletions(-)


base-commit: 626acb37cd445144f321f1b64cac9a93760fa716
-- 
2.53.0-Meta


