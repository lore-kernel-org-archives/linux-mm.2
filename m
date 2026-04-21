Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC10BF327A8
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 06:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A0D6B009F; Tue, 21 Apr 2026 02:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F3B6B0099; Tue, 21 Apr 2026 02:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263BE6B0099; Tue, 21 Apr 2026 02:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F18916B009E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:17:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE165E5A35
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:17:00 +0000 (UTC)
X-FDA: 84681555000.19.76D1CAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A0CC516000C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:16:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RmwfGngL;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776752218; a=rsa-sha256;
	cv=none;
	b=dhZ7zJ2eJQ2pFpHOukPQLjdTENOhVPY9gxJ6xKaPdloqqLIY2UixgvJ31kecCL48EeoFS6
	M5dipmIImMRGCR7n9nKti+2PYLzI2PF1V2QE4hl6yiME1JJh/wdLBc1u+FN6sIYKnnCLo6
	p7HnBNIArATo5nE+Q5PHak1xENCr4QE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RmwfGngL;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776752218;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JeDtZUn/HHN1NZaHuSQ5ZHMBGDeCYIu5SoUEUFZA6F4=;
	b=dbeSz0tY9w9KVjvufLPm2n9hRTIqotSrBtlSsJBu9JBsxg4B9zTgyT+XmElVdefKLKxDAZ
	PWy5CIUornLzFqkOzJW67x1NqIIiy4NRlgCNSytsvBADPT2PhRAZlG0p8CzWlfa4PoCON9
	ilX3larI5efI1SpHKTtG/dPkk6T+G0s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 404E644721;
	Tue, 21 Apr 2026 06:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8B0AC2BCC9;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776752214;
	bh=ii4eNi+HGLSGWmW807v719F6mlBFZF5sIaNrPx6kt6I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RmwfGngLp2MxC8dPC6E5qRge/m8z8q+gvzCNaIuhDXZOUx7N1+nqHdVTgLFNLD9IT
	 HK+Ye3f4D0oJSPLnOgfkYP6ymZs0jEJazHIbD9bz0yL042Zp2HfKqFitXEySN44iIV
	 9DdYVwJBwdkU0/kuX53VEwJutdp91NAzUXVQbXkxxXIN+7/RYFUGLBrWtF7x1xHpGe
	 1fBNpY60MV7qIZgZWpwjFzjD1LALQki2qIEf00M65q92di6YWQU0Rijw8FIeMgZ1zs
	 VLoo3HEQDoXyQaM5s0zdnFeR08xEOgPeyo64a4bSdKOyMzo5bbtmFLhY3hR6bl3ahU
	 22DyGnH+hWUbw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD290F327A8;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 21 Apr 2026 14:16:55 +0800
Subject: [PATCH v3 11/12] mm/memcg: remove no longer used swap cgroup array
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260421-swap-table-p4-v3-11-2f23759a76bc@tencent.com>
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
In-Reply-To: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
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
 Suren Baghdasaryan <surenb@google.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776752211; l=10117;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ppIhGS0NlLSPFGDYJww24Goq8o6nr+DiP92H/nyw9tY=;
 b=5DvDTNWo2CN0EEksYUTNAMO/aDdkredzpXLvj/OgmD72UbaXJTOywTQZSpUm6hbiCP4pT/FkS
 83NKCR9yT1JChGbWHNMuNgFBT2IHNnONQfYUVtcqf6opj0MimE93yQN
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: A0CC516000C
X-Stat-Signature: g969mimcrarjxbospuz9khxz9mwt9osp
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776752218-429725
X-HE-Meta: U2FsdGVkX18B8SO79AdLSsCOnRsxuEmzxEzb8Rp2vkn4HyHyy9u5TFweT+Q3cpYLekonSGpDBNOrpMsYxDhnRw8j3KMJBcm3ZLUMR8WR5HAC8gPl8l9tCgKG2LBbydNEuRrHSBa1JoAk2Rk1Po1QGRyy+uyUqCktXIN6mEPUtNM6pD9FKnNXkXz+W2uaf7QTxfX0l2kDLHF0ZaWZAx/z6YrAho0nBAD56gOP4bqoIXqVPQPniOx8TcT/dBrqvgY3bdR1g3UZhxh1zeRjSEO6pU/zhtJCqFLnFc77e7KISulNVsfjWj7rj+6ecmKw6V0lVULcXEw3Dy35car5TcVCrIfqdKhZCmWcJoiNlG6XVx3LzDPuAREVdtpjN8fFoWRonHdXVh3E1GF8cYC+Zni40a6dXJUyvDGPvhVdR75cqg0cvSSjeho3E3A2MTFY+eq2+SaJV7A1Zko6Zs3xmguC0hbQXNsj9DYn7CoxlIF1Ux0L8pIuwIOtEU3AAFe0iDMPJXtSFI+4iZplcfnx/0hU5x71GdDiwIBgUsmTm4kFMF0z6ezcP19L7NVOvUZ7khwMpllMU1nP1cMOAeU7zgOUos7ddEh5EghVAtLHTARgx+L0IstyZj8O4G0WlXQ0jpqgBghPRAY97HTtTn2FRe1q4nyxy+lya1MXzamGns0RLkk3+dFllSr8sJozNEclgZukPCPN1nZXlfkRbwEmEQ35mj0zH5p+3WifaSqmM6P4gtU770b1WHhXMBfUP1Q92AGx0f+UUXDZ06rcLDxSRpCnwa23mMO23XgaNNrbPAPm5T2TXqbQyyb/GnyPKZBE3dZMYOwIPImpLC3nsrIlJI4e8oXf9JKmcrhaBZa0h7RcYVbmdo699++ppURRYhpi1Pz7zq9r8u/n6sEPmr6ezEj1Ma1wbjhA2B4EH9sTJA3MMUnYpQVHrAYIdt8FrdFg0E1HqMaZjqWHoF3DNWDGBSs
 slwUqGCp
 7Px3ixsB9U1gxGCIHxeidtNxlpdkWNYM/wMt9pU3LhW0lxDj8Hebe/2mA+DQUo/1Ex1BaDNvwRjiY0UUfnM+HdZcPDg8MwcX+CM5RWIoFMXoxUplN13gHb2UYXKOgXEB/5dd8yJItHER208RjzESKuLnm9/oeoPXAsYGiuD0YpyXBKVZlOW7kmeDAXE8a6Cnu+79XVZNnb6ZU9d05sUGG4pPwpPkubRlec7AbEKdEJbjNCIwVr47KNDRMQsEtJaPZVJSYigY0guFKXSGQPJ46RPjzJeUPecr4HY6qg52CFQAUAMFPB/traWE9HXkfoMwtppJTUOuL3N1alw5sYg42p0t4PdmSnBMNKl6FSI1ixBOiVjMpLkoc/ECB7LvqJCT3fku06csiRGVHL4UWbmbSDGILEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now all swap cgroup records are stored in the swap cluster directly,
the static array is no longer needed.

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
index 76d8291237be..217d98c89275 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6565,7 +6565,6 @@ F:	mm/memcontrol.c
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
index 193c8eb73be7..12165fd32529 100644
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
index edf4cb36728e..2172920e68d1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -45,7 +45,6 @@
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
-#include <linux/swap_cgroup.h>
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
@@ -3136,8 +3135,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->global_cluster = NULL;
 	kvfree(zeromap);
 	free_swap_cluster_info(cluster_info, maxpages);
-	/* Destroy swap account information */
-	swap_cgroup_swapoff(p->type);
 
 	inode = mapping->host;
 
@@ -3668,10 +3665,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (error)
 		goto bad_swap_unlock_inode;
 
-	error = swap_cgroup_swapon(si->type, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	/*
 	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
 	 * be above MAX_PAGE_ORDER incase of a large swap file.
@@ -3782,7 +3775,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->global_cluster = NULL;
 	inode = NULL;
 	destroy_swap_extents(si, swap_file);
-	swap_cgroup_swapoff(si->type);
 	free_swap_cluster_info(si->cluster_info, si->max);
 	si->cluster_info = NULL;
 	kvfree(si->zeromap);

-- 
2.53.0



