Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CDCDF357DB
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D7386B0005; Wed, 25 Feb 2026 02:49:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68E0E6B0088; Wed, 25 Feb 2026 02:49:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BA746B008A; Wed, 25 Feb 2026 02:49:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 498666B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:49:42 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC63DC1D37
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:49:41 +0000 (UTC)
X-FDA: 84482204562.12.AED5419
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 36ED6C000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:49:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gthI7paU;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772005780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VCxg7NgM2LDq4e9k0AtZ4iU6ry0kPMJ5QI3Tfg+syuk=;
	b=vzDVtMAHJyEs9vrX9BgMnIMdNluHs4QjTw1NUVdeuyY7pN+nJ1xK0/bOuFlf9oly11eM/C
	rWy44MIP/Jua3OeK/S0gd31mRjV1darheNy0e4xNIWkW3x25nm++u0Tdu4yc7IOPLCqILG
	ZQ+lpY+G1A/0i1dzgUpilSuLdUtlEu0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gthI7paU;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772005780; a=rsa-sha256;
	cv=none;
	b=QQj6X2ZvMPdl6ZewimyFo8AGv/ge7/c8in4U8CtibFT0XJRmp+RM4eDyaVJQFPA+v2QMGk
	WHAD1bbtmfbt6e/2iBGzeX3dJLEJTQScuMYD/viMOmBcP0pGIiq8J/GFYE+F5wr/6+VXiD
	S9fbWGKp19yiDbp5HtlkHZuSAANYVPQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772005777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VCxg7NgM2LDq4e9k0AtZ4iU6ry0kPMJ5QI3Tfg+syuk=;
	b=gthI7paU9xez6XU/jDo30rhRLR9Oge7fTJ7c4xSlxweS6wjbEjTVQWXkxEUPU5TQnR3FtK
	LV8jU2wrEQ24TbTw+ZGqztmlsBbDKL1UqVHF9/nM3syqEMAt9CsDkmOpYRX7cDARocdG4X
	1vJhvE2kzreucNYVYOEVb9cEb0tLlwI=
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
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 00/32] Eliminate Dying Memory Cgroup
Date: Wed, 25 Feb 2026 15:48:33 +0800
Message-ID: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fao8xfjmwwoa773bcwnapi54w19798oc
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 36ED6C000A
X-HE-Tag: 1772005779-883397
X-HE-Meta: U2FsdGVkX1/yRdBKC9j+9bXWbumxECdJcCqr94xPGAcJfrNZjFw9QTA4NG2bOvHrobh9UmTP15LJm+1yi/qWLhevhLaqteR8NAx/NxweZdhcCpBMglrEeVtI+5NEsMOVY/U4WDUQYM1+PzmmOBzJ04907C+HEtvs9ZSs6q5inxsOkLJvyKG/y8JWyxYf+BSoo9n53hNW6E6/On07rRvj5EWDaftaNTGN16sSOXDpIRVadWpW9t5LVqaDO1sxl/qbSR0KUIkhZZelkLmbhvjepbVO4J464OK9NQ11KLkUVbqWtHOrmC3KFsv6LotYUDXCoXe53uNnPMkgvdFUnAxQY6bQUHgRyBQSzyROFCtmzgb7fQfNQI/SjxYDJiBjYnzYYwEsRx9Job2qVxQewnchn7SYtUK70uMCiVsITB+8t1ybt0CxePVYa1aq3V3QiKE3h88U3c3EeVl138CEa/bE+ye7FwRdARYvY5L9l7IaBojz1JyJdlqgyB3AffSkBixcXe72vKAAISDpKZigYlG4aLAqeLA6LH8wguM/aUCSGBPk03FFvIqzBZ/7Duisbp4cY0WbT8t4ApaC/HNT0cXQ8+hJ3gYicotZbqfbO/7KSUlTVfleyaD+OvY3lRUkWjjlanxQrGlqqoGYx+L9VO7/A6m3VYKTsg6n4wzgkY0x3/mX5gEVMb2MgnzgVxG2kbGNb0EEIH8f3U/5e5I04rOn984xT8/C/hmlY2ZMPpMmkv8wFUb74kCVLpDSLtnzzTFDlWmwv9O48g74w7BBMIVa/NOBv6ft6EjQvLGc7Rxsd1APvdxY6tG2qVbzLzKPvtXBJG88sbb03qLsYlQgdpPofCMVs57w2x+PoOhHnddNEOcTroWmNl8e2Z4cTJsHuRtrb0b1zkfTO5LPJkpJgeOokTrcTBcNJh+jjcJKu3F+uOb2OxyW3d9MsE5A0m4aHKlnQhHVDoWfX5wuk/Iphu9
 mcnczEZF
 8yLBpOTudGl6D6AkcT6tDACF+1SilxWF/ir+PcdJmBVwTDdEkNy49/VEIsGxFC47pxF0NXuH6MGdrUUkRrUWE+RGvK+j5pIKT8dnMQ9cfmNmkcSuDJrgm3Xuf7x2YO71r38Pv8lHQUVBx0jsZVWA0bQ0LddsBy1ZObiSNrVoO3qZj1oGl+1hGIdT5q/7Ti0uaHBnryrGYUWATHbWJUk3Q6vK5GoFK0+WC88uTAD8KBz+qsD406iSBkd0u10kVi2wYSvYKU6R4vbIFKrMCZHjBCuAOQ2+LVSzJ2prC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Changes in v5:
 - fix build error in [PATCH v4 24/31] (reported by kernel test robot)
 - move the declaration of reparent_memcg_state_local() and
   reparent_memcg_lruvec_state_local() into mm/memcontrol-v1.h file.
   (suggested by Shakeel Butt, and due to some function dependencies, I keep
    reparent_memcg_lruvec_state_local() in place)
 - convert objcg to be per-memcg per-node type
 - hold the per-node lru locks to reparent per-node objcg and lru folios, which
   fix the potential lockdep warning
   (pointed by Usama Arif and suggested by Shakeel Butt)
 - use try_charge_memcg() directly in charge_memcg()
   (suggested by Shakeel Butt)
 - collect Acked-bys
 - rebase onto the next-20260224

Changes in v4:
 - fix commit message in [PATCH v3 23/30] (pointed by Baoquan He)
 - move lruvec_lock_irq() and firends to mm/memcontrol.c to fix the compilation
   error in [PATCH v4 24/31] (reported by LKP)
 - include parent_lruvec() within the RCU lock in lru_note_cost_unlock_irq() in
   [PATCH v4 24/31] (pointed by Harry Yoo)
 - move the declaration of lru_reparent_memcg() to swap.h
   (suggested by Muchun Song)
 - fix lru size update logic in lru_gen_reparent_memcg() in [PATCH v4 26/31]
   (pointed and suggested by Harry Yoo)
 - add [PATCH v4 28/31] to use lruvec_lru_size() to get the number of lru pages
   in count_shadow_nodes() (suggested by Shakeel Butt)
 - fix reparenting logic of lruvec_stats->state_local in [PATCH v4 29/31]
   (pointed by Shakeel Butt)
 - change these non-hierarchical stats to atomic_long_t type to avoid race
   between mem_cgroup_stat_aggregate() and reparent_state_local() in
   [PATCH v4 29/31]
 - make css_killed_work_fn() to be called in rcu work, and use rcu lock +
   CSS_IS_DYING check to avoid race between
   mod_memcg_state()/mod_memcg_lruvec_state()
   (suggested by Shakeel Butt)
 - collect Acked-bys and Reviewed-bys
 - rebase onto the next-20260128

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

Qi Zheng (10):
  mm: vmscan: prepare for the refactoring the move_folios_to_lru()
  mm: thp: prevent memory cgroup release in
    folio_split_queue_lock{_irqsave}()
  mm: zswap: prevent memory cgroup release in zswap_compress()
  mm: do not open-code lruvec lock
  mm: vmscan: prepare for reparenting traditional LRU folios
  mm: vmscan: prepare for reparenting MGLRU folios
  mm: memcontrol: refactor memcg_reparent_objcgs()
  mm: workingset: use lruvec_lru_size() to get the number of lru pages
  mm: memcontrol: prepare for reparenting non-hierarchical stats
  mm: memcontrol: convert objcg to be per-memcg per-node type

 fs/buffer.c                      |   4 +-
 fs/fs-writeback.c                |  22 +-
 include/linux/memcontrol.h       | 191 ++++++-----
 include/linux/mm_inline.h        |   6 +
 include/linux/mmzone.h           |  17 +
 include/linux/sched.h            |   2 +-
 include/linux/swap.h             |  25 +-
 include/trace/events/writeback.h |   3 +
 kernel/cgroup/cgroup.c           |   8 +-
 mm/compaction.c                  |  43 ++-
 mm/huge_memory.c                 |  22 +-
 mm/memcontrol-v1.c               |  31 +-
 mm/memcontrol-v1.h               |   8 +
 mm/memcontrol.c                  | 562 ++++++++++++++++++++-----------
 mm/migrate.c                     |   2 +
 mm/mlock.c                       |   2 +-
 mm/page_io.c                     |   8 +-
 mm/percpu.c                      |   2 +-
 mm/shrinker.c                    |   6 +-
 mm/swap.c                        |  59 +++-
 mm/vmscan.c                      | 273 +++++++++++----
 mm/workingset.c                  |  30 +-
 mm/zswap.c                       |   5 +
 23 files changed, 904 insertions(+), 427 deletions(-)

-- 
2.20.1


