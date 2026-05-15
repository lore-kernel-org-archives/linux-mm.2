Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F06C0CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364646B00A3; Fri, 15 May 2026 05:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1185F6B00A2; Fri, 15 May 2026 05:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D263C6B00A2; Fri, 15 May 2026 05:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B75926B009F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:54:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71B1D1C0687
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:25 +0000 (UTC)
X-FDA: 84769194090.16.06C8E5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8340780002
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k+uv+ZUB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838863;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5gHn4YalH+hJ5VC8D3EZPqpzmjdHmq/KvxbLYr/jBkk=;
	b=Jg3Yak3BZ6s5OFiESucb0n6+dV9HLDeraT62/RzFAURK2UYaf17TEUMJcxj8nSwH3RTj9p
	btxFjd+BoM4zNfjXPF3C3lYZoXaNbZTAgwzwdlt50H2+prh0gyXtyy+eEeU1IJ/Rg8nq6h
	3z3TWw1bESRKG+3N0t5e2kfxREA4qjk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838863; a=rsa-sha256;
	cv=none;
	b=mNMoiB2pE51ggq6EH9+TBwLzw3vSLflW23ZV040rShTOjlzPsuOHSWOIWp+Y0zbK3bMMwk
	BBqO5N+URCG4C1scPWPH1dSxN2YY5ezCPwVdBJBdy+lLJ9eEZcnG52s66t9TmJRMEa/nZm
	tt3rkxmshxS4bk9br33LdRL3dUg3i+U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k+uv+ZUB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B06406133B;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C9DCC2BCB7;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778838862;
	bh=Za7u5bIOTRsDBgq6wJLHQbGJ0PN/34sxnPz3OT4cYlI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=k+uv+ZUB6AK2TDEIyvD9q9Ne/X1wVSuX5TA4G85Z1K4Bn11SITtd6mm0eHAOVOUZl
	 L4xI2STw6TlUsaVVwd8iqjxRsXUxA8Naf1wtP/OB9Xaeaz/wpTcaLeqeXGzFalXbvw
	 KIScEnILlXG5Um3AVAsK9LgTXy5/n/kaBz3vP09C3Lq1FNvKerd6nsJJywunev0jgk
	 VEKIZpl3UTZo3k0+ZNIyQw0/ut4YhSrKzmy4TyE8bqYSXmY4jMuCRJZL9ulQmCpXJs
	 1jT4atLT0t2/FUzckdRXYPBIyjke5rOnDAZRTcGxXiAcDKIJiuOKsYl7mEcYM2eaj5
	 hn/FUhU2ZDAsw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 741D1CD343F;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 15 May 2026 17:54:23 +0800
Subject: [PATCH v4 10/12] mm/memcg, swap: store cgroup id in cluster table
 directly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-swap-table-p4-v4-10-f1b49e845a8d@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778838859; l=15426;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=R6XhjfC+DEieXnNXn31irf3vAbX4f0msOlcNMk8Rggk=;
 b=sTdgusN/QATDh11pzFJMSFTap8jjCj6eyc4jhoLdeecxQinYVXl+oXyBuQpxskn7eapNVnT9M
 zuITCJRVMWtATGsU4jG0rVZUilDEQvaulrAmU03McWOTrIOKQFvVGbx
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 8340780002
X-Rspamd-Server: rspam04
X-Stat-Signature: zw5i1hmfag5h49cg8i4ktcybocofhyf5
X-HE-Tag: 1778838863-295671
X-HE-Meta: U2FsdGVkX181XLH8x5Vasb4jiuDeOXERBkV/Ve1BmqP8n1SVUHlKSO4R7S4Cfsp7Y35b8h42iKcRAbCwFYiAKTd7D0RlhN7ytjjVs8zq4E+ZDAKyEJJKdnPmZ5KHH9TJvMEBkn/GHS2EYw4JvIHsrzlPF/MKefXuXPh03ZBBTjiJnKk77gH/5gWw7aN+wRvGb4VLeZqLxnYRm4ZQl4NCFw/jSOwd6+k4BxuFrfKlg1soX+CZxZLvdHT3tPLy1A2GG7JgBLiQsPb96Xv87NWo8t5oNTFzZ4isp+NT84RCxr7KzNikClLWB0ZcuJ9FaN1V5wd0EyNPIkID8Jmsa3TPiIEWUO5oinC0mZE3b8Ru5K/pHgLWdWLGmeGFQP9jJTycdYkQ/IHacmYfHuZ+2r7Ba/DUJQopl+bLSvhmJjqcfkk2CdGmE73psjKJT5I7dyIZdO3e6eyPEvSk51Pqx6AKau7Sonqh7CoFj/728V+ZO3Is0g0JTT1xrzxgteosXeJ6VOtB2n/b9TZTnlzciRGnJDoggN66ARtGjSgY3QX5Dx4H/FnzjCzAtr9yThCsixTnX9JxVH9pfipZFQRQyMgnbnFC5BRwJd3euI1tgBOixYilSkpqcSFu0cpOkS6r/PvkDvkTOhCNEtsAt2Qt4JQJgVgoW+qQQRPDrcmLew880CbRV8vgxCg5c9dTbNe71laErBmuEqZr43i6CMnDnvgPhoKc5DyICAaD9klQVYn5PNII26Fq2cXuIjay5jJ7YhrtUxjpHn3xgDJYY7m5Mewhkodt/5vdA8EiryuJpFaK/95s7skkNeZDzVpcFO+YWM3rnIp8d7mzcpCHYEjpVelsDW9aJU9UIIPa4wgd+RZN+DCFzqH/CEjSLmxlm3Ls+eR2v1wb0wxb9+rcAhElaa+Arw2qVJjXf2XSJvx8AjSGmoKQxSTcheobxWA9ZPSNc2SQMuFu3RziqOKSa0e+dUT
 Wrf+ffJz
 ikOIjFVV53w3JGd6YFiL16SqjWKXjpAi4owxlvRNfyMuyiDAahA9GxBCRi/oKcHI5vSnjLptaBox6i1FTo2dF/AVL3inGxIDHe88uINdwvR8uOpLFpwmfSWwe8HraMEbIWrBaPD7UOmz3QuHN0kN0UgJCFlNwqSdD8jYU9ywTB8R2etTJvVj/c881GJVpk+D149MYdh6SIYVfvUb4Ci+QFQBvBLdzo95qbg/bk10HrmQ+X/O6UaGOs92s6dqi/LolOhi9YquRnH1ZT8f3Arhslw5s7FmWMuPh9UQcMT/dA9Pa+j1UZRG/fPBPOmmT1UyDG9SCF8RekBFD9gdIrB+0a6UKzCEHY4CRiiueKsGdx0z3xV6RHhDWRVvQ/6RHMqgAnKGOCOfphVnDDkdG2aTI4AqdQNLp15ScttDDj5YeKmPzUuM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Drop the usage of the swap_cgroup_ctrl, and use the dynamic cluster
table instead.

The per-cluster memcg table is 1024 / 512 bytes on most archs, and does
not need RCU protection: the cgroup data is only read and written under
the cluster lock. That keeps things simple, lets the allocation use
plain kmalloc with immediate kfree (no deferred free), and keeps
fragmentation acceptable.

Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h |  6 +++--
 include/linux/swap.h       |  8 +++---
 mm/memcontrol-v1.c         | 42 +++++++++++++++++++-----------
 mm/memcontrol.c            | 13 ++++++----
 mm/swap.h                  |  4 +++
 mm/swap_state.c            |  6 ++---
 mm/swap_table.h            | 64 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/swapfile.c              | 37 ++++++++++++++++++---------
 mm/vmscan.c                |  2 +-
 9 files changed, 139 insertions(+), 43 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a013f37f24aa..bf1a6e131eca 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -29,6 +29,7 @@ struct obj_cgroup;
 struct page;
 struct mm_struct;
 struct kmem_cache;
+struct swap_cluster_info;
 
 /* Cgroup-specific page state, on top of universal node page state */
 enum memcg_stat_item {
@@ -1899,7 +1900,7 @@ static inline void mem_cgroup_exit_user_fault(void)
 	current->in_user_fault = 0;
 }
 
-void __memcg1_swapout(struct folio *folio);
+void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci);
 void memcg1_swapin(struct folio *folio);
 
 #else /* CONFIG_MEMCG_V1 */
@@ -1929,7 +1930,8 @@ static inline void mem_cgroup_exit_user_fault(void)
 {
 }
 
-static inline void __memcg1_swapout(struct folio *folio)
+static inline void __memcg1_swapout(struct folio *folio,
+		struct swap_cluster_info *ci)
 {
 }
 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6b3acdf9bdd4..203bbe23ba1f 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -584,12 +584,12 @@ static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 	return __mem_cgroup_try_charge_swap(folio);
 }
 
-extern void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages);
-static inline void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
+extern void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages);
+static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 {
 	if (mem_cgroup_disabled())
 		return;
-	__mem_cgroup_uncharge_swap(entry, nr_pages);
+	__mem_cgroup_uncharge_swap(id, nr_pages);
 }
 
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
@@ -600,7 +600,7 @@ static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 	return 0;
 }
 
-static inline void mem_cgroup_uncharge_swap(swp_entry_t entry,
+static inline void mem_cgroup_uncharge_swap(unsigned short id,
 					    unsigned int nr_pages)
 {
 }
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 36c507d81dc5..494e7b9adc60 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -14,6 +14,7 @@
 
 #include "internal.h"
 #include "swap.h"
+#include "swap_table.h"
 #include "memcontrol-v1.h"
 
 /*
@@ -606,14 +607,15 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
 /**
  * __memcg1_swapout - transfer a memsw charge to swap
  * @folio: folio whose memsw charge to transfer
+ * @ci: the locked swap cluster holding the swap entries
  *
  * Transfer the memsw charge of @folio to the swap entry stored in
  * folio->swap.
  *
- * Context: folio must be isolated, unmapped, locked and is just about
- * to be freed, and caller must disable IRQs.
+ * Context: folio must be isolated, unmapped, locked and is just about to
+ * be freed, and caller must disable IRQs and hold the swap cluster lock.
  */
-void __memcg1_swapout(struct folio *folio)
+void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 {
 	struct mem_cgroup *memcg, *swap_memcg;
 	struct obj_cgroup *objcg;
@@ -646,7 +648,8 @@ void __memcg1_swapout(struct folio *folio)
 	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
-	swap_cgroup_record(folio, mem_cgroup_private_id(swap_memcg), folio->swap);
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
+			  mem_cgroup_private_id(swap_memcg));
 
 	folio_unqueue_deferred_split(folio);
 	folio->memcg_data = 0;
@@ -661,8 +664,7 @@ void __memcg1_swapout(struct folio *folio)
 	}
 
 	/*
-	 * Interrupts should be disabled here because the caller holds the
-	 * i_pages lock which is taken with interrupts-off. It is
+	 * The caller must hold the swap cluster lock with IRQ off. It is
 	 * important here to have the interrupts disabled because it is the
 	 * only synchronisation we have for updating the per-CPU variables.
 	 */
@@ -677,7 +679,7 @@ void __memcg1_swapout(struct folio *folio)
 }
 
 /**
- * memcg1_swapin - uncharge swap slot
+ * memcg1_swapin - uncharge swap slot on swapin
  * @folio: folio being swapped in
  *
  * Call this function after successfully adding the charged
@@ -687,6 +689,10 @@ void __memcg1_swapout(struct folio *folio)
  */
 void memcg1_swapin(struct folio *folio)
 {
+	struct swap_cluster_info *ci;
+	unsigned long nr_pages;
+	unsigned short id;
+
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 
@@ -702,14 +708,20 @@ void memcg1_swapin(struct folio *folio)
 	 * correspond 1:1 to page and swap slot lifetimes: we charge the
 	 * page to memory here, and uncharge swap when the slot is freed.
 	 */
-	if (do_memsw_account()) {
-		/*
-		 * The swap entry might not get freed for a long time,
-		 * let's not wait for it.  The page already received a
-		 * memory+swap charge, drop the swap entry duplicate.
-		 */
-		mem_cgroup_uncharge_swap(folio->swap, folio_nr_pages(folio));
-	}
+	if (!do_memsw_account())
+		return;
+
+	/*
+	 * The swap entry might not get freed for a long time,
+	 * let's not wait for it.  The page already received a
+	 * memory+swap charge, drop the swap entry duplicate.
+	 */
+	nr_pages = folio_nr_pages(folio);
+	ci = swap_cluster_get_and_lock(folio);
+	id = __swap_cgroup_clear(ci, swp_cluster_offset(folio->swap),
+				 nr_pages);
+	swap_cluster_unlock(ci);
+	mem_cgroup_uncharge_swap(id, nr_pages);
 }
 
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4f940cf22ffe..b5c267a061a9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -64,6 +64,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
 #include "internal.h"
+#include "swap_table.h"
 #include <net/sock.h>
 #include <net/ip.h>
 #include "slab.h"
@@ -5470,6 +5471,7 @@ int __init mem_cgroup_init(void)
 int __mem_cgroup_try_charge_swap(struct folio *folio)
 {
 	unsigned int nr_pages = folio_nr_pages(folio);
+	struct swap_cluster_info *ci;
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
@@ -5503,22 +5505,23 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
-	swap_cgroup_record(folio, mem_cgroup_private_id(memcg), folio->swap);
+	ci = swap_cluster_get_and_lock(folio);
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
+			  mem_cgroup_private_id(memcg));
+	swap_cluster_unlock(ci);
 
 	return 0;
 }
 
 /**
  * __mem_cgroup_uncharge_swap - uncharge swap space
- * @entry: swap entry to uncharge
+ * @id: cgroup id to uncharge
  * @nr_pages: the amount of swap space to uncharge
  */
-void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
+void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 {
 	struct mem_cgroup *memcg;
-	unsigned short id;
 
-	id = swap_cgroup_clear(entry, nr_pages);
 	rcu_read_lock();
 	memcg = mem_cgroup_from_private_id(id);
 	if (memcg) {
diff --git a/mm/swap.h b/mm/swap.h
index 8e57e9431624..5b2f095fff6e 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -5,6 +5,7 @@
 #include <linux/atomic.h> /* for atomic_long_t */
 struct mempolicy;
 struct swap_iocb;
+struct swap_memcg_table;
 
 extern int page_cluster;
 
@@ -38,6 +39,9 @@ struct swap_cluster_info {
 	u8 order;
 	atomic_long_t __rcu *table;	/* Swap table entries, see mm/swap_table.h */
 	unsigned int *extend_table;	/* For large swap count, protected by ci->lock */
+#ifdef CONFIG_MEMCG
+	struct swap_memcg_table *memcg_table;	/* Swap table entries' cgroup record */
+#endif
 	struct list_head list;
 };
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 75339640160a..c899d1d69b52 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -179,21 +179,19 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	if (shadowp && swp_tb_is_shadow(old_tb))
 		*shadowp = swp_tb_to_shadow(old_tb);
 	if (memcg_id)
-		*memcg_id = lookup_swap_cgroup_id(targ_entry);
+		*memcg_id = __swap_cgroup_get(ci, ci_off);
 
 	if (nr == 1)
 		return 0;
 
-	targ_entry.val = round_down(targ_entry.val, nr);
 	ci_off = round_down(ci_off, nr);
 	ci_end = ci_off + nr;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
 		if (unlikely(swp_tb_is_folio(old_tb) ||
 			     !__swp_tb_get_count(old_tb) ||
-			     (memcg_id && *memcg_id != lookup_swap_cgroup_id(targ_entry))))
+			     (memcg_id && *memcg_id != __swap_cgroup_get(ci, ci_off))))
 			return -EBUSY;
-		targ_entry.val++;
 	} while (++ci_off < ci_end);
 
 	return 0;
diff --git a/mm/swap_table.h b/mm/swap_table.h
index 8415ffbe2b9c..b4e1100f8296 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -11,6 +11,11 @@ struct swap_table {
 	atomic_long_t entries[SWAPFILE_CLUSTER];
 };
 
+/* For storing memcg private id */
+struct swap_memcg_table {
+	unsigned short id[SWAPFILE_CLUSTER];
+};
+
 #define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) == PAGE_SIZE)
 
 /*
@@ -247,4 +252,63 @@ static inline unsigned long swap_table_get(struct swap_cluster_info *ci,
 
 	return swp_tb;
 }
+
+#ifdef CONFIG_MEMCG
+static inline void __swap_cgroup_set(struct swap_cluster_info *ci,
+		unsigned int ci_off, unsigned long nr, unsigned short id)
+{
+	lockdep_assert_held(&ci->lock);
+	VM_WARN_ON_ONCE(ci_off >= SWAPFILE_CLUSTER);
+	if (WARN_ON_ONCE(!ci->memcg_table))
+		return;
+	do {
+		ci->memcg_table->id[ci_off++] = id;
+	} while (--nr);
+}
+
+static inline unsigned short __swap_cgroup_get(struct swap_cluster_info *ci,
+					       unsigned int ci_off)
+{
+	lockdep_assert_held(&ci->lock);
+	VM_WARN_ON_ONCE(ci_off >= SWAPFILE_CLUSTER);
+	if (unlikely(!ci->memcg_table))
+		return 0;
+	return ci->memcg_table->id[ci_off];
+}
+
+static inline unsigned short __swap_cgroup_clear(struct swap_cluster_info *ci,
+						 unsigned int ci_off,
+						 unsigned long nr)
+{
+	unsigned short old = __swap_cgroup_get(ci, ci_off);
+
+	if (!old)
+		return 0;
+	do {
+		VM_WARN_ON_ONCE(ci->memcg_table->id[ci_off] != old);
+		ci->memcg_table->id[ci_off++] = 0;
+	} while (--nr);
+
+	return old;
+}
+#else
+static inline void __swap_cgroup_set(struct swap_cluster_info *ci,
+		unsigned int ci_off, unsigned long nr, unsigned short id)
+{
+}
+
+static inline unsigned short __swap_cgroup_get(struct swap_cluster_info *ci,
+					       unsigned int ci_off)
+{
+	return 0;
+}
+
+static inline unsigned short __swap_cgroup_clear(struct swap_cluster_info *ci,
+						 unsigned int ci_off,
+						 unsigned long nr)
+{
+	return 0;
+}
+#endif
+
 #endif
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7740ba99f87e..ae14d4049e4b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -423,7 +423,12 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 {
 	struct swap_table *table;
 
-	table = (struct swap_table *)rcu_dereference_protected(ci->table, true);
+#ifdef CONFIG_MEMCG
+	kfree(ci->memcg_table);
+	ci->memcg_table = NULL;
+#endif
+
+	table = (struct swap_table *)rcu_access_pointer(ci->table);
 	if (!table)
 		return;
 
@@ -441,6 +446,7 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 {
 	struct swap_table *table = NULL;
 	struct folio *folio;
+	int ret = 0;
 
 	/* The cluster must be empty and not on any list during allocation. */
 	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
@@ -458,7 +464,19 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 		return -ENOMEM;
 
 	rcu_assign_pointer(ci->table, table);
-	return 0;
+
+#ifdef CONFIG_MEMCG
+	if (!mem_cgroup_disabled()) {
+		VM_WARN_ON_ONCE(ci->memcg_table);
+		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
+		if (!ci->memcg_table)
+			ret = -ENOMEM;
+	}
+#endif
+	if (ret)
+		swap_cluster_free_table(ci);
+
+	return ret;
 }
 
 /*
@@ -483,6 +501,7 @@ static void swap_cluster_assert_empty(struct swap_cluster_info *ci,
 			bad_slots++;
 		else
 			WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
+		WARN_ON_ONCE(__swap_cgroup_get(ci, ci_off));
 	} while (++ci_off < ci_end);
 
 	WARN_ON_ONCE(bad_slots != (swapoff ? ci->count : 0));
@@ -1861,12 +1880,10 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 				 unsigned int ci_start, unsigned int nr_pages)
 {
 	unsigned long old_tb;
-	unsigned int type = si->type;
 	unsigned short batch_id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
 	unsigned long ci_head = cluster_offset(si, ci);
 	unsigned int batch_off = ci_off;
-	swp_entry_t entry;
 
 	VM_WARN_ON(ci->count < nr_pages);
 
@@ -1884,21 +1901,17 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		 * Uncharge swap slots by memcg in batches. Consecutive
 		 * slots with the same cgroup id are uncharged together.
 		 */
-		entry = swp_entry(type, ci_head + ci_off);
-		id_cur = lookup_swap_cgroup_id(entry);
+		id_cur = __swap_cgroup_clear(ci, ci_off, 1);
 		if (batch_id != id_cur) {
 			if (batch_id)
-				mem_cgroup_uncharge_swap(swp_entry(type, ci_head + batch_off),
-							 ci_off - batch_off);
+				mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
 			batch_id = id_cur;
 			batch_off = ci_off;
 		}
 	} while (++ci_off < ci_end);
 
-	if (batch_id) {
-		mem_cgroup_uncharge_swap(swp_entry(type, ci_head + batch_off),
-					 ci_off - batch_off);
-	}
+	if (batch_id)
+		mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
 
 	swap_range_free(si, ci_head + ci_start, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 924c84326551..ca4533eba701 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -737,7 +737,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		__memcg1_swapout(folio);
+		__memcg1_swapout(folio, ci);
 		__swap_cache_del_folio(ci, folio, swap, shadow);
 		swap_cluster_unlock_irq(ci);
 	} else {

-- 
2.54.0



