Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07CD7D29FEF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2BD6B0005; Wed, 14 Jan 2026 06:27:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680646B0088; Wed, 14 Jan 2026 06:27:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C676B0089; Wed, 14 Jan 2026 06:27:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4223B6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:27:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D89BF16048B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:27:44 +0000 (UTC)
X-FDA: 84330344448.25.AB1CC6B
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 52A8A18000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:27:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PDSoOYS0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390063; a=rsa-sha256;
	cv=none;
	b=iTw+9fWTKcLli2nWedv7u7IjyEsfwg7H6U7oKrhTEB+VEXSpUErCwskzXfhPOloZ7xbX/b
	OIGjklmzCU1RHDn/AwJtdvA7z3c+K1RWwT94d6ehE16UfHF5BOChgXtThtm9kXgAXIr9rG
	B9Pgpn0q4osJYoTHTHb1FnJRZpuqmkI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PDSoOYS0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EJ0NLkl3WbQqzA9g/N1WxzWPmbIAe8I0MVoMjqxcwe4=;
	b=WnEaXGeYQTteFPmJLOm9/ATV/f1IyZw7hbVkHaSuQ5VN2SDPW4tzS1jiTg/0tA7ZmXu2r9
	HNYXLvV54yWf9FljoekTRLmt5JQpBiChwoF+9vsPsyeApnZ6WjEg9jKwWo2hrupCs9/NNn
	9gwG6OoSY1yCZl7uBBBwJ9sK1iTz7zI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EJ0NLkl3WbQqzA9g/N1WxzWPmbIAe8I0MVoMjqxcwe4=;
	b=PDSoOYS0fRemSPYzitxZGZ5SgEjzEK/iiZK7vWu5r3EXZDmTK+mbnJK5J2LADv2fZtmIZf
	e2bCXKU6VpPm2IIWG0GLYlhTnoevMr+ctItq4znbkfavhS6yjLLUA0oDiubVx0Qi8VINvY
	pAS9rEHtUVlUl7QI9X49qsJ2di9aymw=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 00/30] Eliminate Dying Memory Cgroup
Date: Wed, 14 Jan 2026 19:26:43 +0800
Message-ID: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 52A8A18000D
X-Stat-Signature: 945eimfu9sgbfqipdyszhb154otw6uz5
X-Rspam-User: 
X-HE-Tag: 1768390061-253502
X-HE-Meta: U2FsdGVkX1/35t2E8zHjRby2ev6YlmOr2Jp/9gogKXIIUt2Pf2mglVdWMF+tbVEGYFwyE5rjr33tfI4Qel5qGn8XSV4BGqj4xJSNDbjAQEBMJyU22y/aARdROJc7/V6u5L5FYVh/s/vX0EF0TMH9Di+wB87GMdTdJu252Cr1WLDxcaGrCMonfndpA1yNfl/9b/Vuwu9zxuV+EcSTjTb5ObqhI+ImH/X4PLsQz+lD1XHnsK37I6/fmrR0vs73S/ZpmqdeMGPWbgnqkbIpP//WgG0Wj2DaD46g03z6JX40AyjvP4TJEILQB+rOYh7LOcfzkBIYZ0wiCv49L8YNxoV2Ovxin25JxDR/1yDnuZA49c7YwJSr9LkbRbzhPytq3dDQbIZvsOYg8yw0dU7h3mHgesjhJDReWS2mx2lrcXT4TwJCGxyQuURkpAZ90mBAa1exy5Q56dwtB9+lqiTQUdTYC8M96AGPUsUopNwCIW5GdpEknj0OdSZvZgr2jyeFVNTTpSlwXVAzi/dlhG6YEiNeCkKwtd0RossX1plI7/IUHreUV3rHaVz6UsdhMUITfidw/5eubMgchJeSc8N77pdIVRzb3ARBBxsh/j4DlLueBGudYYqZ69Ll5Xjm9+D5B+ZSOUKgMF4rXvPZkl27lB4uA8VMUgBoOwudMGw3l+88ow6M4gWLhRCmGKFrr26OZBrzF23WiE0V3BEpKlqCaAmNWzLJ62Uf8KinqDi805saAJ5j5ZuCQs9vWnlAQTMBovqVOIXt9xJ8y1TCG+PLWfVpfNsUZwGM2mHr9Gpiw5gXF65HyXb3YILE4OEXDDqChHdyq9diBftxOuw4y2C+9Wnmdy4LU7b2Tcj2AwgZJ2mFV62drMcAIvClts4ocxNPmsN132WcZYytUNm64POzdq7FghNPfGH3QLmnMnUrx7pz5kfdPRWHpEmMcyr05tlNM0SV0hePeAxKbGcneCK7Uwz
 nxNOLSOy
 9gL2dFV93jT/6YVYQa77DnIqhBc93PaPLnDGCWr5RGBVRbAI6u4aNT2pP1w/hh72rn4JXagZlqH8onEMusq4L6YyoxGwR8mSSts8YW/t7CcupliO/UBCK/Ek/tnuz+up18dzH7ihKwKzPudDNlwkSUWUrxKtbAe8CokKeWxhv2t2hsbRb4wdR7SRpsbvWIdkE0wW2Bkg4PYNrvGJ4SSK4KTk0ZQ+wslfHu6Z+/c/uj8221Czix3SJneIL8BABFNqDtpYX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Changes in v3:
 - modify the commit message in [PATCH v2 04/28], [PATCH v2 06/28],
   [PATCH v2 13/28], [PATCH v2 24/28] and [PATCH v2 27/28]
   (suggested by David Hildenbrand, Chen Ridong and Johannes Weiner)
 - change code style in [PATCH v3 8/30], [PATCH v3 15/30] and [PATCH v3 27/30]
   (suggested by Johannes Weiner and Shakeel Butt)
 - use get_mem_cgroup_from_folio() + mem_cgroup_put() to replace holding rcu
   lock in [PATCH v3 14/30] and [PATCH v3 19/30]
   (pointed by Johannes Weiner)
 - add a comment to folio_split_queue_lock() in [PATCH v3 17/30]
   (suggested by Shakeel Butt)
 - modify the comment above folio_lruvec() in [PATCH v3 24/30]
   (suggested by Johannes Weiner)
 - fix rcu lock issue in lru_note_cost_refault()
   (pointed by Shakeel Butt)
 - add [PATCH v3 28/30] to fix non-hierarchical memcg1_stats issues
   (pointed by Yosry Ahmed)
 - fix lru_zone_size issue in [PATCH v2 24/28] and [PATCH v2 25/28]
 - collect Acked-bys and Reviewed-bys
 - rebase onto the next-20260114

Changes in v2:
 - add [PATCH v2 04/28] and remove local_irq_disable() in evict_folios()
   (pointed by Harry Yoo)
 - recheck objcg in [PATCH v2 07/28] (pointed by Harry Yoo)
 - modify the commit message in [PATCH v2 12/28] and [PATCH v2 21/28]
   (pointed by Harry Yoo)
 - use rcu lock to protect mm_state in [PATCH v2 14/28] (pointed by Harry Yoo)
 - fix bad unlock balance warning in [PATCH v2 23/28]
 - change nr_pages type to long in [PATCH v2 25/28] (pointed by Harry Yoo)
 - incease mm_state->seq during reparenting to make mm walker work properly in
   [PATCH v2 25/28] (pointed by Harry Yoo)
 - add [PATCH v2 18/28] to fix WARNING in folio_memcg() (pointed by Harry Yoo)
 - collect Reviewed-bys
 - rebase onto the next-20251216

Changes in v1:
 - drop [PATCH RFC 02/28]
 - drop THP split queue related part, which has been merged as a separate
   patchset[2]
 - prevent memory cgroup release in folio_split_queue_lock{_irqsave}() in
   [PATCH v1 16/26]
 - Separate the reparenting function of traditional LRU folios to [PATCH v1 22/26]
 - adapted to the MGLRU scenarios in [PATCH v1 23/26]
 - refactor memcg_reparent_objcgs() in [PATCH v1 24/26]
 - collect Acked-bys and Reviewed-bys
 - rebase onto the next-20251028

Hi all,

Introduction
============

This patchset is intended to transfer the LRU pages to the object cgroup
without holding a reference to the original memory cgroup in order to
address the issue of the dying memory cgroup. A consensus has already been
reached regarding this approach recently [1].

Background
==========

The issue of a dying memory cgroup refers to a situation where a memory
cgroup is no longer being used by users, but memory (the metadata
associated with memory cgroups) remains allocated to it. This situation
may potentially result in memory leaks or inefficiencies in memory
reclamation and has persisted as an issue for several years. Any memory
allocation that endures longer than the lifespan (from the users'
perspective) of a memory cgroup can lead to the issue of dying memory
cgroup. We have exerted greater efforts to tackle this problem by
introducing the infrastructure of object cgroup [2].

Presently, numerous types of objects (slab objects, non-slab kernel
allocations, per-CPU objects) are charged to the object cgroup without
holding a reference to the original memory cgroup. The final allocations
for LRU pages (anonymous pages and file pages) are charged at allocation
time and continues to hold a reference to the original memory cgroup
until reclaimed.

File pages are more complex than anonymous pages as they can be shared
among different memory cgroups and may persist beyond the lifespan of
the memory cgroup. The long-term pinning of file pages to memory cgroups
is a widespread issue that causes recurring problems in practical
scenarios [3]. File pages remain unreclaimed for extended periods.
Additionally, they are accessed by successive instances (second, third,
fourth, etc.) of the same job, which is restarted into a new cgroup each
time. As a result, unreclaimable dying memory cgroups accumulate,
leading to memory wastage and significantly reducing the efficiency
of page reclamation.

Fundamentals
============

A folio will no longer pin its corresponding memory cgroup. It is necessary
to ensure that the memory cgroup or the lruvec associated with the memory
cgroup is not released when a user obtains a pointer to the memory cgroup
or lruvec returned by folio_memcg() or folio_lruvec(). Users are required
to hold the RCU read lock or acquire a reference to the memory cgroup
associated with the folio to prevent its release if they are not concerned
about the binding stability between the folio and its corresponding memory
cgroup. However, some users of folio_lruvec() (i.e., the lruvec lock)
desire a stable binding between the folio and its corresponding memory
cgroup. An approach is needed to ensure the stability of the binding while
the lruvec lock is held, and to detect the situation of holding the
incorrect lruvec lock when there is a race condition during memory cgroup
reparenting. The following four steps are taken to achieve these goals.

1. The first step  to be taken is to identify all users of both functions
   (folio_memcg() and folio_lruvec()) who are not concerned about binding
   stability and implement appropriate measures (such as holding a RCU read
   lock or temporarily obtaining a reference to the memory cgroup for a
   brief period) to prevent the release of the memory cgroup.

2. Secondly, the following refactoring of folio_lruvec_lock() demonstrates
   how to ensure the binding stability from the user's perspective of
   folio_lruvec().

   struct lruvec *folio_lruvec_lock(struct folio *folio)
   {
           struct lruvec *lruvec;

           rcu_read_lock();
   retry:
           lruvec = folio_lruvec(folio);
           spin_lock(&lruvec->lru_lock);
           if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
                   spin_unlock(&lruvec->lru_lock);
                   goto retry;
           }

           return lruvec;
   }

   From the perspective of memory cgroup removal, the entire reparenting
   process (altering the binding relationship between folio and its memory
   cgroup and moving the LRU lists to its parental memory cgroup) should be
   carried out under both the lruvec lock of the memory cgroup being removed
   and the lruvec lock of its parent.

3. Finally, transfer the LRU pages to the object cgroup without holding a
   reference to the original memory cgroup.

Effect
======

Finally, it can be observed that the quantity of dying memory cgroups will
not experience a significant increase if the following test script is
executed to reproduce the issue.

```bash
#!/bin/bash

# Create a temporary file 'temp' filled with zero bytes
dd if=/dev/zero of=temp bs=4096 count=1

# Display memory-cgroup info from /proc/cgroups
cat /proc/cgroups | grep memory

for i in {0..2000}
do
    mkdir /sys/fs/cgroup/memory/test$i
    echo $$ > /sys/fs/cgroup/memory/test$i/cgroup.procs

    # Append 'temp' file content to 'log'
    cat temp >> log

    echo $$ > /sys/fs/cgroup/memory/cgroup.procs

    # Potentially create a dying memory cgroup
    rmdir /sys/fs/cgroup/memory/test$i
done

# Display memory-cgroup info after test
cat /proc/cgroups | grep memory

rm -f temp log
```

Comments and suggestions are welcome!

Thanks,
Qi

[1].https://lore.kernel.org/linux-mm/Z6OkXXYDorPrBvEQ@hm-sls2/
[2].https://lwn.net/Articles/895431/
[3].https://github.com/systemd/systemd/pull/36827

Muchun Song (22):
  mm: memcontrol: remove dead code of checking parent memory cgroup
  mm: workingset: use folio_lruvec() in workingset_refault()
  mm: rename unlock_page_lruvec_irq and its variants
  mm: vmscan: refactor move_folios_to_lru()
  mm: memcontrol: allocate object cgroup for non-kmem case
  mm: memcontrol: return root object cgroup for root memory cgroup
  mm: memcontrol: prevent memory cgroup release in
    get_mem_cgroup_from_folio()
  buffer: prevent memory cgroup release in folio_alloc_buffers()
  writeback: prevent memory cgroup release in writeback module
  mm: memcontrol: prevent memory cgroup release in
    count_memcg_folio_events()
  mm: page_io: prevent memory cgroup release in page_io module
  mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
  mm: mglru: prevent memory cgroup release in mglru
  mm: memcontrol: prevent memory cgroup release in
    mem_cgroup_swap_full()
  mm: workingset: prevent memory cgroup release in lru_gen_eviction()
  mm: workingset: prevent lruvec release in workingset_refault()
  mm: zswap: prevent lruvec release in zswap_folio_swapin()
  mm: swap: prevent lruvec release in lru_gen_clear_refs()
  mm: workingset: prevent lruvec release in workingset_activation()
  mm: memcontrol: prepare for reparenting LRU pages for lruvec lock
  mm: memcontrol: eliminate the problem of dying memory cgroup for LRU
    folios
  mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers

Qi Zheng (8):
  mm: vmscan: prepare for the refactoring the move_folios_to_lru()
  mm: thp: prevent memory cgroup release in
    folio_split_queue_lock{_irqsave}()
  mm: zswap: prevent memory cgroup release in zswap_compress()
  mm: do not open-code lruvec lock
  mm: vmscan: prepare for reparenting traditional LRU folios
  mm: vmscan: prepare for reparenting MGLRU folios
  mm: memcontrol: refactor memcg_reparent_objcgs()
  mm: memcontrol: prepare for reparenting state_local

 fs/buffer.c                      |   4 +-
 fs/fs-writeback.c                |  22 +-
 include/linux/memcontrol.h       | 187 ++++++------
 include/linux/mm_inline.h        |   6 +
 include/linux/mmzone.h           |  20 ++
 include/linux/swap.h             |  20 ++
 include/trace/events/writeback.h |   3 +
 mm/compaction.c                  |  43 ++-
 mm/huge_memory.c                 |  22 +-
 mm/memcontrol-v1.c               |  31 +-
 mm/memcontrol-v1.h               |   3 +
 mm/memcontrol.c                  | 472 ++++++++++++++++++++-----------
 mm/migrate.c                     |   2 +
 mm/mlock.c                       |   2 +-
 mm/page_io.c                     |   8 +-
 mm/percpu.c                      |   2 +-
 mm/shrinker.c                    |   6 +-
 mm/swap.c                        |  61 +++-
 mm/vmscan.c                      | 280 +++++++++++++-----
 mm/workingset.c                  |  25 +-
 mm/zswap.c                       |   5 +
 21 files changed, 835 insertions(+), 389 deletions(-)

-- 
2.20.1


