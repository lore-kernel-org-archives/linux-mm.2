Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCD1DF8D766
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 18:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23396B00B0; Thu, 16 Apr 2026 14:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F436B00B3; Thu, 16 Apr 2026 14:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A816B00B5; Thu, 16 Apr 2026 14:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 236576B00B2
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:34:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2655BC04F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:34:49 +0000 (UTC)
X-FDA: 84665270298.15.8E120B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D976D14001A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:34:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jJK5+6HP;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776364488;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B2YJ5KCLkPzK/Zf1ucoMCTcueNdLs/gV21WA443S5uQ=;
	b=cOX9V8Ey2wThp5odjsCW8oSRnT4dViCadCNEOaAlD+K+Lnvs+EXuNTxAhAgmARgnKFzl2O
	DBc/u17J04Q3ju0hEakGGvYicss23QWBtVjAMbc0b9Yq8iRK+75e2aTcb6EyKtrCT+rrRM
	wUw8amB5+GmucwzhMECPaA+2EfKTbGs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jJK5+6HP;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776364488; a=rsa-sha256;
	cv=none;
	b=UEMItv/nGvVwKW7OGv7VMbaM8syLWaR29fMcDOynWXkJP9uwML/xe1CnmrcVE+LMvRanli
	4k4iZ9oyT8aoaj1qBLxvbWqDht0G4Z7T8na+Aoak6oaIiaDvwIvqnC8eHYQjoo2N79DxGt
	rDQ/JNCzPYJzrM2FXqgyBAHU9f+XDoo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E58BF44717;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8E94C4AF12;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776364483;
	bh=ySvL3CYudJ5Mec7aZtOE0gSCmCUIzFqGDyOksKJLkEI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jJK5+6HPfQgAyXL7aoiNW0+gGOVckRf4nh8cCK2fG1PuBIxA7wLJQ+b0nn5bIHamW
	 5AYYGYu1Ggz0ldYAW/sBGoYmDMk95hDGpZ0/ndpoPlw6a9FPtDyDslcGMgYNhU/K+D
	 JYBLR688+BitTSwx3lO8/EJfKbQ3dMMDRQo9KP1JueKUz0OvU7/PqeeIXRV3KrhG4G
	 fP2d3dZF5hcL8Y7vf+3Pg6G4AJ0qXa9vwqbJuq8gx+T2EKkBmuIqvm/dIMHtIIQT+Q
	 40lmiegX7P+q7PInZuf3nELLAp+0F6KnxPBYXM778ipsD0UNwtuVrYO1wljMZ5Nm0s
	 FqLWqsQbxfO7A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD61FF8D766;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 17 Apr 2026 02:34:40 +0800
Subject: [PATCH v2 10/11] mm/memcg: remove no longer used swap cgroup array
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260417-swap-table-p4-v2-10-17f5d1015428@tencent.com>
References: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
In-Reply-To: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776364480; l=10121;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=dDVYF4bq+qhEs2L8GOWU8vBbhrkUU3PY225ZFin1M1c=;
 b=EUmwNjHEsXpJCEbE8aaQRvBAZBor6OiWMkmhz90hz1lSdXbIqLRZCFzTHagZFmLWdYR0g7YXs
 z4UQ3E6iILJD3DsfImW3Csf0LHOnoonuk1cpjdW6zfx5z0UIFPjbiJX
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 5zfecizi5ohrjjd3t1yyx68an9bq4cbe
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D976D14001A
X-HE-Tag: 1776364487-650864
X-HE-Meta: U2FsdGVkX1+ivYDe6D3xzvCsqojkDt1RtXa5KsmjiFxqNB5B+BQVtyrI4Gn3VhXVlu1VyBH16gnBUDXH8f6pT7qGQY5rkqHTznoTjwi+cqBbRHX53HgO4+YavQK5/e05zzsNjI9DpnmvPV7g/j7Qv6Sf3XRNqgpACbYqxw/x/Nv7VcCLu9WSEUuk5AgipVU4XZkQGDtxmb7srmKKXQP1s+hcRwX9s/hevzuqYUU2UdxvhFTa+kMxvnlAzM9/EV71/IXeFdPJdzPVXTyd87i2ezKnBbU4x50D7FWsvDsZMSxyA5WCAtNEw8BWvOSOIVJLTpZmKeC7i4e1w9JAtqQuU6Yn8YHF37LKAQZmVG7Y0oJXclUSEbeyFEzvwwASP1uBHz6m+t79SKZNDFB+f8u6iyVTWRdLIIMH1OXsz67qFZxTtkt+leJ6XhuPbT7S3sVL74cGr9CzoJaD9Trbp6e6a+oVqnQB1V1C6z4MT5OXxZEC7ufCGy2p7AQDl55eN5cbSFs4P2A3VgJ1EooDqf91SqFNA7BfnwI4Luch8rD4oKoIJ3xLj8Bry0LxgZoHbTDGspqyparCdb8ZOBrvYI5vG+ShwkfvGcDcUKhgz89SQ0M07ciEcTWayR3feNBmoHEclIaRHPa+1fM2u/Nf/mchy4U02diOkYxz2Q7qcTroVE3ExnoGbfS0z3FJ9DJWIavkuKg99KFD3vwNc7bNvWkE6FvE5lqCNdMb7DkxV2xoqdM0aI4JGiHiKYeQc0lZ/21gSNqT1o3bQoN9XdVdS0WJtuuObh/F9cte1miDqUg7ZIwqH281q3Sea2pT3FD5ESwnEtZFamzKhrAsBqKggQILWqgMv5jLNW3JfWySR3EeM4fZxqWYUSKVH4EZMl93lXYHnVEl+JJwhXs0QHexH8Q2lAdsm4GfPDWGeuPr8722AFKfqDDUn5DDXSw+Z8/HSpFEbSEGIcYoYqiKlDRYw6n
 O5z0DIdk
 WidLgJ0McyL94uydKBfAEzGdK1RJgneQEEjX2TY7nwNyxh+ZgPlCTqXTBvglguyKDVTBu6QEiY2k4oLtu48W7yFzABi6OdteAEKK1kUwawvXisxIZ08Pdix71CgCO3EEOMrd1nbd4foUEinAf0ZnjPQQI9HFDMsBlF5qQ6ApIM5R9zzzYOJ213QumRiRXbhWpAKBbbz7yEn7a3hVJl08gl2lD+GCuwUg82dItqnjHCEmOm3CzzOaMUvhNveuo7HWycj6RWvnZ3lQnZSl+A3Y3BRDB84YQeI8mHkjwPOHFERJPHuB6xug5PIWbcYxG/JUEvQ3Eu6MmHz11eU6TNfdCdd0GX6NGPOYuoOcQFdLgnSHVKBuSCR69YuWvvroFuNPPGaUX9ClqDdmlIcV884jUcGQEcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now all swap cgroup records are stored in the swap cluster directly,
no more need for a static array for that.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 MAINTAINERS                 |   1 -
 include/linux/swap_cgroup.h |  47 ------------
 mm/Makefile                 |   3 -
 mm/internal.h               |   1 -
 mm/memcontrol-v1.c          |   1 -
 mm/memcontrol.c             |   1 -
 mm/swap_cgroup.c            | 172 --------------------------------------------
 mm/swapfile.c               |   8 ---
 8 files changed, 234 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ab54a9c77603..b34f39cbe3ec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6567,7 +6567,6 @@ F:	mm/memcontrol.c
 F:	mm/memcontrol-v1.c
 F:	mm/memcontrol-v1.h
 F:	mm/page_counter.c
-F:	mm/swap_cgroup.c
 F:	samples/cgroup/*
 F:	tools/testing/selftests/cgroup/memcg_protection.m
 F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
diff --git a/include/linux/swap_cgroup.h b/include/linux/swap_cgroup.h
deleted file mode 100644
index 91cdf12190a0..000000000000
--- a/include/linux/swap_cgroup.h
+++ /dev/null
@@ -1,47 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __LINUX_SWAP_CGROUP_H
-#define __LINUX_SWAP_CGROUP_H
-
-#include <linux/swap.h>
-
-#if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-
-extern void swap_cgroup_record(struct folio *folio, unsigned short id, swp_entry_t ent);
-extern unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents);
-extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
-extern int swap_cgroup_swapon(int type, unsigned long max_pages);
-extern void swap_cgroup_swapoff(int type);
-
-#else
-
-static inline
-void swap_cgroup_record(struct folio *folio, unsigned short id, swp_entry_t ent)
-{
-}
-
-static inline
-unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents)
-{
-	return 0;
-}
-
-static inline
-unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
-{
-	return 0;
-}
-
-static inline int
-swap_cgroup_swapon(int type, unsigned long max_pages)
-{
-	return 0;
-}
-
-static inline void swap_cgroup_swapoff(int type)
-{
-	return;
-}
-
-#endif
-
-#endif /* __LINUX_SWAP_CGROUP_H */
diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244e..eff9f9e7e061 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -103,9 +103,6 @@ obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
-ifdef CONFIG_SWAP
-obj-$(CONFIG_MEMCG) += swap_cgroup.o
-endif
 ifdef CONFIG_BPF_SYSCALL
 obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
 endif
diff --git a/mm/internal.h b/mm/internal.h
index 32de9f3a9fa0..164c7f0a6a98 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -17,7 +17,6 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
-#include <linux/swap_cgroup.h>
 #include <linux/tracepoint-defs.h>
 
 /* Internal core VMA manipulation functions. */
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index ff49337a61a3..c2a39ae1fd69 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -5,7 +5,6 @@
 #include <linux/mm_inline.h>
 #include <linux/pagewalk.h>
 #include <linux/backing-dev.h>
-#include <linux/swap_cgroup.h>
 #include <linux/eventfd.h>
 #include <linux/poll.h>
 #include <linux/sort.h>
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 43a7b25da37e..493aff40df0c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -54,7 +54,6 @@
 #include <linux/vmpressure.h>
 #include <linux/memremap.h>
 #include <linux/mm_inline.h>
-#include <linux/swap_cgroup.h>
 #include <linux/cpu.h>
 #include <linux/oom.h>
 #include <linux/lockdep.h>
diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
deleted file mode 100644
index de779fed8c21..000000000000
--- a/mm/swap_cgroup.c
+++ /dev/null
@@ -1,172 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/swap_cgroup.h>
-#include <linux/vmalloc.h>
-#include <linux/mm.h>
-
-#include <linux/swapops.h> /* depends on mm.h include */
-
-static DEFINE_MUTEX(swap_cgroup_mutex);
-
-/* Pack two cgroup id (short) of two entries in one swap_cgroup (atomic_t) */
-#define ID_PER_SC (sizeof(struct swap_cgroup) / sizeof(unsigned short))
-#define ID_SHIFT (BITS_PER_TYPE(unsigned short))
-#define ID_MASK (BIT(ID_SHIFT) - 1)
-struct swap_cgroup {
-	atomic_t ids;
-};
-
-struct swap_cgroup_ctrl {
-	struct swap_cgroup *map;
-};
-
-static struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
-
-static unsigned short __swap_cgroup_id_lookup(struct swap_cgroup *map,
-					      pgoff_t offset)
-{
-	unsigned int shift = (offset % ID_PER_SC) * ID_SHIFT;
-	unsigned int old_ids = atomic_read(&map[offset / ID_PER_SC].ids);
-
-	BUILD_BUG_ON(!is_power_of_2(ID_PER_SC));
-	BUILD_BUG_ON(sizeof(struct swap_cgroup) != sizeof(atomic_t));
-
-	return (old_ids >> shift) & ID_MASK;
-}
-
-static unsigned short __swap_cgroup_id_xchg(struct swap_cgroup *map,
-					    pgoff_t offset,
-					    unsigned short new_id)
-{
-	unsigned short old_id;
-	struct swap_cgroup *sc = &map[offset / ID_PER_SC];
-	unsigned int shift = (offset % ID_PER_SC) * ID_SHIFT;
-	unsigned int new_ids, old_ids = atomic_read(&sc->ids);
-
-	do {
-		old_id = (old_ids >> shift) & ID_MASK;
-		new_ids = (old_ids & ~(ID_MASK << shift));
-		new_ids |= ((unsigned int)new_id) << shift;
-	} while (!atomic_try_cmpxchg(&sc->ids, &old_ids, new_ids));
-
-	return old_id;
-}
-
-/**
- * swap_cgroup_record - record mem_cgroup for a set of swap entries.
- * These entries must belong to one single folio, and that folio
- * must be being charged for swap space (swap out), and these
- * entries must not have been charged
- *
- * @folio: the folio that the swap entry belongs to
- * @id: mem_cgroup ID to be recorded
- * @ent: the first swap entry to be recorded
- */
-void swap_cgroup_record(struct folio *folio, unsigned short id,
-			swp_entry_t ent)
-{
-	unsigned int nr_ents = folio_nr_pages(folio);
-	struct swap_cgroup *map;
-	pgoff_t offset, end;
-	unsigned short old;
-
-	offset = swp_offset(ent);
-	end = offset + nr_ents;
-	map = swap_cgroup_ctrl[swp_type(ent)].map;
-
-	do {
-		old = __swap_cgroup_id_xchg(map, offset, id);
-		VM_BUG_ON(old);
-	} while (++offset != end);
-}
-
-/**
- * swap_cgroup_clear - clear mem_cgroup for a set of swap entries.
- * These entries must be being uncharged from swap. They either
- * belongs to one single folio in the swap cache (swap in for
- * cgroup v1), or no longer have any users (slot freeing).
- *
- * @ent: the first swap entry to be recorded into
- * @nr_ents: number of swap entries to be recorded
- *
- * Returns the existing old value.
- */
-unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents)
-{
-	pgoff_t offset, end;
-	struct swap_cgroup *map;
-	unsigned short old, iter = 0;
-
-	offset = swp_offset(ent);
-	end = offset + nr_ents;
-	map = swap_cgroup_ctrl[swp_type(ent)].map;
-
-	do {
-		old = __swap_cgroup_id_xchg(map, offset, 0);
-		if (!iter)
-			iter = old;
-		VM_BUG_ON(iter != old);
-	} while (++offset != end);
-
-	return old;
-}
-
-/**
- * lookup_swap_cgroup_id - lookup mem_cgroup id tied to swap entry
- * @ent: swap entry to be looked up.
- *
- * Returns ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
- */
-unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
-{
-	struct swap_cgroup_ctrl *ctrl;
-
-	if (mem_cgroup_disabled())
-		return 0;
-
-	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
-	return __swap_cgroup_id_lookup(ctrl->map, swp_offset(ent));
-}
-
-int swap_cgroup_swapon(int type, unsigned long max_pages)
-{
-	struct swap_cgroup *map;
-	struct swap_cgroup_ctrl *ctrl;
-
-	if (mem_cgroup_disabled())
-		return 0;
-
-	BUILD_BUG_ON(sizeof(unsigned short) * ID_PER_SC !=
-		     sizeof(struct swap_cgroup));
-	map = vzalloc(DIV_ROUND_UP(max_pages, ID_PER_SC) *
-		      sizeof(struct swap_cgroup));
-	if (!map)
-		goto nomem;
-
-	ctrl = &swap_cgroup_ctrl[type];
-	mutex_lock(&swap_cgroup_mutex);
-	ctrl->map = map;
-	mutex_unlock(&swap_cgroup_mutex);
-
-	return 0;
-nomem:
-	pr_info("couldn't allocate enough memory for swap_cgroup\n");
-	pr_info("swap_cgroup can be disabled by swapaccount=0 boot option\n");
-	return -ENOMEM;
-}
-
-void swap_cgroup_swapoff(int type)
-{
-	struct swap_cgroup *map;
-	struct swap_cgroup_ctrl *ctrl;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	mutex_lock(&swap_cgroup_mutex);
-	ctrl = &swap_cgroup_ctrl[type];
-	map = ctrl->map;
-	ctrl->map = NULL;
-	mutex_unlock(&swap_cgroup_mutex);
-
-	vfree(map);
-}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5511cdbd2ccf..0753a62ebc25 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -45,7 +45,6 @@
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
-#include <linux/swap_cgroup.h>
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
@@ -3173,8 +3172,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->global_cluster = NULL;
 	kvfree(zeromap);
 	free_swap_cluster_info(cluster_info, maxpages);
-	/* Destroy swap account information */
-	swap_cgroup_swapoff(p->type);
 
 	inode = mapping->host;
 
@@ -3705,10 +3702,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (error)
 		goto bad_swap_unlock_inode;
 
-	error = swap_cgroup_swapon(si->type, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	/*
 	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
 	 * be above MAX_PAGE_ORDER incase of a large swap file.
@@ -3819,7 +3812,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->global_cluster = NULL;
 	inode = NULL;
 	destroy_swap_extents(si, swap_file);
-	swap_cgroup_swapoff(si->type);
 	free_swap_cluster_info(si->cluster_info, si->max);
 	si->cluster_info = NULL;
 	kvfree(si->zeromap);

-- 
2.53.0



