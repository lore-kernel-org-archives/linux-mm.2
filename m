Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2842AD64086
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC896B0005; Wed, 17 Dec 2025 02:28:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A956B0089; Wed, 17 Dec 2025 02:28:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7690C6B008A; Wed, 17 Dec 2025 02:28:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5FADF6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:28:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04F1E5B881
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:28:28 +0000 (UTC)
X-FDA: 84228135138.01.9A66497
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 32148140006
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:28:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mv7b+fo4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956507; a=rsa-sha256;
	cv=none;
	b=BxqoJwRFgZ67E2G213dydd9qvx0Fjezq1RFPWZrmfjeOaqhRW10dNLr6gYhfKbNmPbJ68i
	P4R1gdWj4Nn3nB8ZAEOsJZzkWSX4QL+Muq7pcMruKld+B1r2o10MwqlBCQQO33WOlKwyTq
	dZ7t4wcXMn8U8UB9+XTl+JA6kaGz42w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mv7b+fo4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gx6upDD6v3Dk8s5pcTpWHLq0mYHA2xIgZ/4+vliktWQ=;
	b=LV7ihNl2RYyZcfV5KCdDkyso84X1A6GLhHogndscrwentR3dVL/AM0jUKgYDjMtog9vMKq
	zpb6Lr5g3bNcO78bvuNEgfmBnItcu3jV9iw+i7PIxGMifG+zv8iUO12T/K6nobUqkKYFOk
	1C0cEE8SBxva9mJYsM36cRCb7+yadlQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gx6upDD6v3Dk8s5pcTpWHLq0mYHA2xIgZ/4+vliktWQ=;
	b=Mv7b+fo4Q0Dn0sdQvSFMitITGSnnFVyyfDRgY0uksIpbmXLjzL6DlhgbYty5CCPNThdFan
	7NILoeztCcwjGNVMtVa8wGN+7cRa/7aXYE2fHqYYB4YcidBVSn50Vxpjgpxd9bIHbnDIr1
	x5/QFtR06VTg9JVJMyAA04U7ftv70LU=
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
Subject: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Date: Wed, 17 Dec 2025 15:27:24 +0800
Message-ID: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 32148140006
X-Stat-Signature: 137dip798f863uphquodbu6zzm9d99h7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765956506-630484
X-HE-Meta: U2FsdGVkX19xDQe6AzN+t+c5VjwuXY3HiZShZB/zT7FWE5LXDeW3rz7v0mb2Ywia/Rs7+/VgdxGDssdvpM1IydhAyjtsljsYrWBZQ/VbwBdagzfX2snrv2d3uUXFQOsGR7PbfUhvSsaRqQWFaiLkFsGyBqWVAuZMCr426yMWq8PLoUyfa5U+ncV8kieaWOfyUmonepRboR2ie9/7wkCCxkW+/H+5w2ry50ljbAWsPOysHco8OT1ShZUILZpAqvhjzmy52n5ThsISj8kGIiYGAK8Q8qZXBMnqu3mAxVJu9KNd8d1AINtRORjiXl77r/AOi1DJKfbpgjAez+U5vDxn6B9A92kf5tvnZ6UXRU7Ei+SCaYWHodg6aRg9xhRUR2aIIAYej5eRAY1F6YoaySEQntIpxzpU9cfCkbvKzy2ADIpfSbZelhvQ6tQaVF7N2AaNxww5WFtjW4G2BO+80Ai3f0XEpe8LnxSskfWlCE1cBbw0ORDcsjbbd2l6/JQ0CBE6MokfkiEvrSKBlfhI7nUP76D/6LUzXZGpEU6YvpWvi2Qhw4fwD+H66dCchVzwc1lB68cdi9mVZl/0u3NU28LRgbOY/90/BSFoT2ffYKTugAYZnIPXcVu+h1XYPUm+7Xl5NTAtJyCpOjv08QLPkxzRj7/jlE6jgvVmxOE47pWFQ6q0vjkIjrq75s2w8vxxsCYVX5bZbqqHeN3M3w8lqeJfjltueMHJcGYcPSuqfieTwrUuJjiEwmSralaHeZVUsQPdvJm8nhDKVO92SGf0AgjsLpI+yAzAuqzv9xkKHEjI9RwR113IU3qihteiY/bcG/uSbwGwGto7e3ySNXd1/ToO8j3k0NU807uGVSI0uYZd7+O0+jNH0eu9fRxccu9wAJS8ETVQjeRHNc8MoF7/e/9FG23fc5Yz28R9cZjrmib7Zai4SG6X9DTx4NPl/KYzyRJnB3zNpY68t8JEJHlie4F
 L4kU2flr
 fSqQ5H0YEk4yVukDaD4nPJmLGMHqEDqOHNG9eumnfxVpayB24MSryPtoX358BKmqbv8LaB8aZNxdFz2gzhQJiuVXqRmUgn9OoZtcYw8XzLeqVWOfgMq6mNDBd6g4ogMxGh06xd08DoHvUZLHy2+lj2XfQM7xoSwhL4ixBjqpg+gTNWyvw9BWQdAWJ95f/ss+MjkP9PHConzMrMLju1/4EWdO3wMXXl3A3qwNWCHo4TQxBarOMZNJPx9Fj/ipJdK3cC9bR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

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

Qi Zheng (6):
  mm: vmscan: prepare for the refactoring the move_folios_to_lru()
  mm: thp: prevent memory cgroup release in
    folio_split_queue_lock{_irqsave}()
  mm: zswap: prevent memory cgroup release in zswap_compress()
  mm: vmscan: prepare for reparenting traditional LRU folios
  mm: vmscan: prepare for reparenting MGLRU folios
  mm: memcontrol: refactor memcg_reparent_objcgs()

 fs/buffer.c                      |   4 +-
 fs/fs-writeback.c                |  22 +-
 include/linux/memcontrol.h       | 159 ++++++------
 include/linux/mm_inline.h        |   6 +
 include/linux/mmzone.h           |  20 ++
 include/trace/events/writeback.h |   3 +
 mm/compaction.c                  |  43 +++-
 mm/huge_memory.c                 |  18 +-
 mm/memcontrol-v1.c               |  15 +-
 mm/memcontrol.c                  | 405 ++++++++++++++++++-------------
 mm/migrate.c                     |   2 +
 mm/mlock.c                       |   2 +-
 mm/page_io.c                     |   8 +-
 mm/percpu.c                      |   2 +-
 mm/shrinker.c                    |   6 +-
 mm/swap.c                        |  20 +-
 mm/vmscan.c                      | 267 ++++++++++++++++----
 mm/workingset.c                  |  26 +-
 mm/zswap.c                       |   5 +
 19 files changed, 677 insertions(+), 356 deletions(-)

-- 
2.20.1


