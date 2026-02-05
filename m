Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D28C9E91298
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 08:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D38DC6B0089; Thu,  5 Feb 2026 03:56:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC2E6B0092; Thu,  5 Feb 2026 03:56:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B91746B0093; Thu,  5 Feb 2026 03:56:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A32686B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:56:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4DFB013AE83
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:56:31 +0000 (UTC)
X-FDA: 84409796982.14.0DA756A
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id C702E14000B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:56:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QD9LvZzW;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770281789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XzTKiZnV6r6pGRAN1Vi+8TF/Bjdg4KcZcIvONSYE8GM=;
	b=DlX2dN0qBxy+iflfGhooO2GS1dCoB6GHrIytLs6qiP17H8bc25xRaX8CWj+5C3y6F7Hw5+
	Z4LCvueBMNxoriNsklwLGYiYUYfninofk3nz24tSgx19gwbqXz/lrGyu5J49NUqbZKy1Kt
	P1Q0iPz0NuyuAJbSJcgGNl1tofZnoRc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QD9LvZzW;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770281789; a=rsa-sha256;
	cv=none;
	b=lpu1/lPUCQG2orrhb3ZjpufudW0wbg/Dho2mQnBDTHuLBVoKZS89eNBbtOJ5hKNm4cn0Ov
	JuVij4Aab01U5KK9/KQBHzRu+hxVCdFkHcz9y3ClJKGEKjXK0CiosKtrAo/qtEbtqeDlk+
	MfkrKs25Ua9sQ7eab3d9TpY+1Xb0l0g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770281785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XzTKiZnV6r6pGRAN1Vi+8TF/Bjdg4KcZcIvONSYE8GM=;
	b=QD9LvZzWlQuxVXIzqUKWUAiV0Ob0NmKPCkZu/Aexlt5DbnpLFtLgVX8smP6J3XDdA0S2T5
	PecjzAQloMBEMhrmGQmyOjQLCODWtP6/UnyJNRizFY2hu9AVnSbaQV2/qUFURTyrZ4C3P6
	tgs75uji3qHzuvotgw9fptTeNstR0jI=
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
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 00/31] Eliminate Dying Memory Cgroup
Date: Thu,  5 Feb 2026 16:54:29 +0800
Message-ID: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: cpqgk3w64g3dw46e8q86nwyt3xctdgwr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C702E14000B
X-HE-Tag: 1770281787-456454
X-HE-Meta: U2FsdGVkX19UpLSqB7j4eTqLtOWXou7coSCrsKhbEYLxfgn4iWkw6JeIx9vRMz82pzSZWjOc/iLZ1PHN/fyF74gmBpeMaTr+Dew2XDAOVjBODVHWoI1FxCiDvMZp6Gn3TAcXGfe/5Ij6XONHHbSwxHMJ7inCEkACv2tS0iAAEuWLta7pOo5RER48uv631gjjUbYK0v9sUkHGxDULwwcO5k8xp8o0Uzj/CZSJZxHHjZkUW+6uDzV37ThD6m9YbNqMd9EOSRlSNidPMRd0T/CB2c/JfMvpZQIHwUMLl2kTb2z1IqTlqFYD+z3AcQBRaJFcRipcAxjeUGntpdG8rL+K889cufoOtHi0x2C9TrKnSEM4IzNZ35ErjPM5u8jz6vnMCtn35rlq4LV5rcKhEI0+xXB/jN2tt9balct/wW+6fh65z4/cnleq2ZlTBuUzN1BHoNCrfrx3kV4T+u9iP2XXX8Tb0CZHqO48+5qHV2+RMGCmj0Y6hP0tPWdnuHnIjJMVW+dx2aADrWcD2DbaNlk90O3moGeiIx5+z/+y1yDgj1ZvfLl8T334J8Wu6Ex6gslNNR9iiqUAItd+mKLHaxhduxHhsl0s6IPi898Kz9b4ALyhnl8iLZuaK4A+DezOOxwvsKqJVNMc8f/3M1/6Mg+7X0Dt6Oe4ef9z8ix0E/GOd95EZ9co0pJkLpVhaxUlnf2Z+G19qAUButMI9husX2XB1dA9B6R5ROa+bTUbj+0Zf6H0m5yF0pHCDMeakK/cTpn1GxbGyI7zA4f41rdgT20+9tNc+5YS1wd/nyz9eaDRk2Y7n/OlS2+slUgvLV11CkUiCV+fh5fldSPFiPNjUUKjRudkVAj1CzcsPAbAJy7KGvU3u0pZ+rSad16OlOM6KQ1H8HcwSRRJKsney0jlbq5znQpIxm3hQvZ5gOX0qH58E0Z2K/U4fUo3i+iDKNJSldNAdZRQ7MMfsfgP0/ZF699
 Yw5SV8sQ
 SRSmdL2xNDKEZl7ztdZ7MH10WYPfKChru6N1+lIRO4VJtSb/ScPYyZWLms88YsmypfIOYVDpmnG6I6yOMDrMEqdS4Vxye52aCpi4uMm/1oU+au7rqDlxz1BALNqThUW72e6Vcej30TZ5ZTPCLGc1A3wGsTR69/tsgpigexwh06ybYjdaix+8gmVXIlYB3u45O4haqgtcEyiH/0zZtQjSYNEt+sBa7iMPfWyUmgaFrDYJXBHitloqTdH66fVbGCVM18nYGlx2FjBsz6fCx4MKEyGuH0Apw96qlyO2n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

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

Qi Zheng (9):
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

 fs/buffer.c                      |   4 +-
 fs/fs-writeback.c                |  22 +-
 include/linux/memcontrol.h       | 177 +++++-----
 include/linux/mm_inline.h        |   6 +
 include/linux/mmzone.h           |  16 +
 include/linux/swap.h             |  25 +-
 include/trace/events/writeback.h |   3 +
 kernel/cgroup/cgroup.c           |   8 +-
 mm/compaction.c                  |  43 ++-
 mm/huge_memory.c                 |  22 +-
 mm/memcontrol-v1.c               |  31 +-
 mm/memcontrol-v1.h               |   3 +
 mm/memcontrol.c                  | 554 +++++++++++++++++++++----------
 mm/migrate.c                     |   2 +
 mm/mlock.c                       |   2 +-
 mm/page_io.c                     |   8 +-
 mm/percpu.c                      |   2 +-
 mm/shrinker.c                    |   6 +-
 mm/swap.c                        |  63 +++-
 mm/vmscan.c                      | 293 +++++++++++-----
 mm/workingset.c                  |  30 +-
 mm/zswap.c                       |   5 +
 22 files changed, 909 insertions(+), 416 deletions(-)

-- 
2.20.1


