Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D681CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6711B6B00A5; Fri, 15 May 2026 05:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64EE36B00A6; Fri, 15 May 2026 05:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D8E6B00A9; Fri, 15 May 2026 05:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2144C6B00A6
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:54:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9B881C070D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:27 +0000 (UTC)
X-FDA: 84769194174.05.8351A32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D9E754000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H3TJ/nkV";
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838866;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=073DaSLLs4r1ie08ipunJIi1EtIPqkcZ8Uz8qB/9Ibc=;
	b=drtm4d+qgLPu3Zc0HAOKwrVBj97vn95pAJxa74hXlVzbdugKsE0dwBEqsRgpr8+ZDdTBnW
	NPAqRaEbYC5xd/GIl5qlEMwHeFlcTaB3tZ6SdTFXauvSuZGF/n9yzKI859NW0ZXJ3jyasa
	H6VoKC1DxyQjU7VIPJiQqGcEZWLMR+Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H3TJ/nkV";
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838866; a=rsa-sha256;
	cv=none;
	b=X1wEMAawG9UL5httd28ibHd8SHD17gesSrQTcWXbpF5O+YAEwF7t8afAlgCIVRJdEdeLhh
	jud5v4l7OmwT6AeaDv0nNbiDQAisfWMFjma2BKVs2ve73HSIOY5JzZuK92NKXmDUhmT9wf
	oOhpnS5/T2ASNKXnctDv0MQYqV3pfVo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF4CD442B8;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 948A6C2BCFF;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778838862;
	bh=yGvnZGsm49ieaEy1P65cpRxDGwB0e/972Jb+fgbhqgY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=H3TJ/nkVxFFYXjMd11chbsKd6Ls4KK+NoKRvbzgMMDfSuL4zEEglhlluLtzDtlON2
	 WQ+Q4a22shnr6eZfr54+JyU1/UGbxgxgYAdPx+kTtkUmhQl0VehYOUK9ralHD35yT9
	 ww6co/XVfAcqN27JpTUjvlIXicLDa9aCx7j/NjGsjGFIY8FGXrY8PNbz4Xc+bb5ui1
	 kcwQhFpiZFjcsgx6caG+2MGsLVzI6Pq/gIRvujNPp/5VSiB5avXJkg7qxBYD5qeujp
	 GVIPsl4Oa5HcHxYbG9dcauck6SDJvZRkHCU+W+PH9tj5sG4tqLwYYtlcDmfQxZvcuV
	 7FjGe/4itBjlw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869C7CD4F3D;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 15 May 2026 17:54:24 +0800
Subject: [PATCH v4 11/12] mm/memcg: remove no longer used swap cgroup array
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-swap-table-p4-v4-11-f1b49e845a8d@tencent.com>
References: <20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com>
In-Reply-To: <20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com>
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
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778838859; l=10199;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ta79Avu/thElyBUdmQaqOrzxqO0x3dOx+PK/95QYg2I=;
 b=6r71sOHpiRTcvYkNIjeb1V097DQ4mqjWmuunA/VnBBbSXqcME2+dIM3+lo/+K/bZxOk1jcg+x
 QJouS5hahkcDhcIkdjer1hS1WtEptXnLjiNhQLhqvntpypkCp4XItma
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: j4gxz6bttibkoy46q7r5kg5zjhqxienj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D9E754000A
X-Rspam-User: 
X-HE-Tag: 1778838865-421109
X-HE-Meta: U2FsdGVkX19QZunGkFdu5dY/fO6bYPM/p60qbc7ElVrNQy+SDP3+NXFrL8Luk3e2lp2VZnQpGo9ov6yti/g7zb56qrIq750uVCek+2oG4dUeeFGqxSJber/ujaU77bYq4Ka2aE7g7ck27ZP9bK9qUGHm4hHixWVZZdWYKPWDEG2bdhwNLJQV/IFCs0z4qpmbyrunl9GB6M9ttjy81cySanb1B87tsEgQMWbNVW9Z8S77otESzKJHbQomKZ29hX3wMBl6LVPHqDR01v+D6dh6J9YldEfUjy/Fzzddp3RYRhYr/XFk3tzF9wo09gEB76bQBQ0gnBrvGz+w+2GCDd1orv81t+rKGhK9i1JO3k/LeGdVCjsiDgdp9hCWMdHDvhrDjPgXeMB0F7yItv8wEY+5jOSdhdxuoj/I4esMRYTYg6s71CuHJBB1R+IMD2XsIF3T3sLjZ/RIDVjtc41Mxi4dHsaa+QYdh2AvAqrnjJMmBimLsmbYRmZiZ7ikxU39BwkLrgbqgH6FOeJrWHvYUUGA3CGy5ep8Q1d6rBFXyoX0PmSzbQtOsvBkNoC3C0e2sWi5hkJKzflyEbjJ0SYB0OFHAhAdQRUrtx/QDbupcBTP42pXtWN+j45jMn55KOpWXY5fLE7UYtK7+popZV/GnuHjFEp17BzHOt6Cj6z9NA51dm72orUysXzi4WdvL++Kxwl6/rDz/EHNb/zGX6xl18E+oszEBDh/CgNA5MaDMlj/cGjgzbiPPPq7I+rKlWk3zJ1lByiJyazrBe6sKeDJ8tWcAf3U6ehoahhU5HFA0rra4QASkT/5pTO7Ty4TJ6XLJBUeF2iQ2dAwwDW0iyPXwueF2nkj3ktVxY7pmLa+M9Lir8cJ8dVWG00sh0xfmy8jNlMZ32Vh2r38jmbcWFWxM3yjcG3u/4OzQO0GFhDpwG1SKFJrdD8JpvISzs7sGr6DIXVyHYYkx0kXEvbUi2EAjlw
 xqgKDys9
 QJ6YaaEE/upyJjPxktof/I5IMbR2KBSCOpoX0bx8n2OYbcJfQ3kRvQjRACpzaUU8IFza00Vzk5LNH9FcoVg29iIv/Tz6SMVQTuvAHQrRajT5PyZjROkKCvNFSMmRYNv1FU9q3hWXaxZJm41AnzqwKpZzz5evI+oR7RZ82n/9NZULdeKo4sd3J5PQA+6oS5768b02kle8eiTZ/VsABF2t5IKwYoeng9aRcfp4DlnroCxjQrFaCfgoUh9VNLdWmDqLjjjtD3hTRIhRiwb4Gk2kzxLYALmhLSL+RCskZ37pA8fqWH5YFzKuTG/OscWZeIZJq6iPikhwanLPEaEQJCajDO7cBPF2rjouuwDYju1C4DYYgp1oRjtZb266iM3LmsPeIzY2VRU0YG9wiVaReTIG3eX4SqhX+hA/BBXOy7gVGzAvwSAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now all swap cgroup records are stored in the swap cluster directly,
the static array is no longer needed.

Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 MAINTAINERS                 |   1 -
 include/linux/swap_cgroup.h |  47 ------------
 mm/Makefile                 |   3 -
 mm/internal.h               |   1 -
 mm/memcontrol-v1.c          |   1 -
 mm/memcontrol.c             |   1 -
 mm/swap_cgroup.c            | 174 --------------------------------------------
 mm/swapfile.c               |   8 --
 8 files changed, 236 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0116eb99b708..9be179722d42 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6564,7 +6564,6 @@ F:	mm/memcontrol.c
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
index 9d2fec696bd6..7646ecb9d621 100644
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
index 494e7b9adc60..08be1a752c2e 100644
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
index b5c267a061a9..039e9bc8971c 100644
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
index 95c38e54dd58..000000000000
--- a/mm/swap_cgroup.c
+++ /dev/null
@@ -1,174 +0,0 @@
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
-	if (unlikely(!ctrl->map))
-		return 0;
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
index ae14d4049e4b..095e9c953e49 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -45,7 +45,6 @@
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
-#include <linux/swap_cgroup.h>
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
@@ -3200,8 +3199,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->global_cluster = NULL;
 	kvfree(zeromap);
 	free_swap_cluster_info(cluster_info, maxpages);
-	/* Destroy swap account information */
-	swap_cgroup_swapoff(p->type);
 
 	inode = mapping->host;
 
@@ -3732,10 +3729,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (error)
 		goto bad_swap_unlock_inode;
 
-	error = swap_cgroup_swapon(si->type, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	/*
 	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
 	 * be above MAX_PAGE_ORDER incase of a large swap file.
@@ -3846,7 +3839,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->global_cluster = NULL;
 	inode = NULL;
 	destroy_swap_extents(si, swap_file);
-	swap_cgroup_swapoff(si->type);
 	free_swap_cluster_info(si->cluster_info, si->max);
 	si->cluster_info = NULL;
 	kvfree(si->zeromap);

-- 
2.54.0



