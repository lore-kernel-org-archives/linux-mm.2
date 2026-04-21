Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB0CEF327AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 06:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AE396B0099; Tue, 21 Apr 2026 02:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54B326B009E; Tue, 21 Apr 2026 02:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39D366B00A1; Tue, 21 Apr 2026 02:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF4806B009B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:17:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C285D8CF69
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:17:00 +0000 (UTC)
X-FDA: 84681555000.12.2EDDD5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B89FC140002
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:16:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kkBcnAyk;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776752218;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Z8VOvKmyDBcmA71pXKMCtNsOQ367srvgYyMEj43eJk=;
	b=yzNEpRbPL42ZPf8PtOGaUHgiISG1Za62djmb2kSgvq8snYXUqSVpOs/ROrJoLcWY5mr81y
	ZxrgTZhThkE67jtz6bpeSW8GMdIYF8lXs5oFGUVHxMSJCrsD88VxWjlFUnWbZHBS8cG/cU
	yXyv9UTEbJxcAkDqkRbDd+jqNHckxds=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kkBcnAyk;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776752218; a=rsa-sha256;
	cv=none;
	b=AXXBSFQA+hIJhn96h5DcGpUTBSiWXu0y4nmNxndhdHagkqlYVUAotb23inU0/CVdgQJ8WH
	PxH4UPyOFwzZisdm+miab/xCCt9PNH1GGdbKIFR31RzmNOCDIgiQDzHPF5LDMKYR6s/JPz
	6vVcIzZbyfM5PCpKiJhJPQCtbFRLTSQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B481446F7;
	Tue, 21 Apr 2026 06:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6DD4C4AF0B;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776752214;
	bh=PlzncJfQNFjdUMXyth90oRU2KFUzgWZz7MGCiTQVVgA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kkBcnAykqJbcmE8MDbY6mpCC9n6uf2EZwPXA7/dKWPc0lmv81gJfu8WG9H5yUXM98
	 MEu/RfWpz9DKIyZSJxWkHOOsr1CtrNhovOFDx5ky5I8UUmIjV74fDj3y3/Ccr0u4ju
	 iWu41YsflNAxUtqkLuJRhgpeH7z8ZXkL2kbhnbT4bgJmNzPMBlTtsqhOMOPofwvDwT
	 JJGfQXkAWm4I5AnUuKlQOgU2EFQ6cWgeBp9NditM2CXzDM9shY3DOOLwjsnfevPSfQ
	 FN1p09qICsPhFPIMdoc6aocNwfzfaZtDX58eCUVyzl55ZAool9ivuQitdf7tb9sheT
	 +Mka9ZIvD4lbg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2B4F327AD;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 21 Apr 2026 14:16:54 +0800
Subject: [PATCH v3 10/12] mm/memcg, swap: store cgroup id in cluster table
 directly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260421-swap-table-p4-v3-10-2f23759a76bc@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776752211; l=15097;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=GDNJvZd9jKkeZPU5tNtzh1bfN+1CNsOhbeDPGAt1qAg=;
 b=N3e47p2Dqgj6HQuYsv788ntodJW8wyh5KFNmjmY7W+3p2leFTo6SMVaPzyB+szjODm8g6FNv9
 aGWfLXccH8ZDdIEv/VjZhb0RVFmhujCd28JfO7FII5afBXkoXL1+Cbz
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B89FC140002
X-Stat-Signature: 1r39ttdkpo4aoakzzu849y7z1u73kuy1
X-Rspam-User: 
X-HE-Tag: 1776752218-279233
X-HE-Meta: U2FsdGVkX1+Ym8coP2l0SC7JKHa0cBRG5JJYMtQ1giuJOq9Xgkmu7+ipv9/p5U+UyOX5NB+o/HBqjimuaDAVBTvHyYkeDvnyVPobjF+3YoGz+RuVhpVv/Io7RW+Vdc0tEoClDGD4Vo8P03yyCbpZTrcPP2y/cbNciL8TYLk/kF0NmOybSu06iF5XcGTatMtykW+7x0uKq3lwCEvH9OCnzSalqinYu1UAPTODt2rXgs7HLHZK4Ee7XiiTR63McfgVMfPN09ItgqMYDMHNrM0DJoLgDfe0Q9xXVAlqkGelgM0Bj6rYeRRo3xhktBzYaTWsL7/9pG4ZcLgk76LmjADnA1aQOKeWOYGyZjcyWExBiza/Hg2xUcQkJhBef/wcy4GVTKgFapzOYCWlFXfbmwMVx13FETdcMSXCEh6REnDmBjGijPHFb37fOdOmkVJeqJTqkpNrPJAiC0jpxc5uZ7Rccjq/baioYcAHe2LbifxYTGh3dkmDUVC+F3C6NwlhJMrx/pA4DyrubjDbaXbQ7yr4rZYMJ6wKHsdjrjaULNjEO7JkiBNUPv7SH4KTxL3ZrarkODndHSyfGYBXub93A1S4mziMPXoEIXI3ss4HU+VhQvS9BlPFfQtV4xF/JAb4Vdh4AN8D924nzt9liHcUfZF9nkQHoMSsYkkur+h/+HouCs0XiMcFoiffOWiPx1ihtVPO3sOlVqpg6AjfKRX6JaSRt22qXIZ2iLExum9lGKKzZVrCLNO220AU+6HEVCk64phi0Twtu4hrlgeWZl7NM9Dxt8Yt1B1FiTf9ofyzdYzNRMB+FDCK6QgKl6liEZXldcyN2gOcl8fELTMgUKpkHStnZ32OIA29ecZBvxQwHnceXsrdXaLxwcZnkSlucak99xHvZfOep4gMsn7FI6dUgfZscojYryLZa8f7crThQ8qUtxXjDdH64BTlCq+Y7vV/fwWtINS+ubS8bk+MVs5ChZX
 S11XT6CC
 LQeRvWukSQQf2Oaynb/NJaoZX9CRfK3JbcaccSfiI4KLULuYNGkKSTnRjbgIrPsXuV5Y0EFMIRucYjX/sMCGI2q79CZ4ZqqB56XkEHg5FImOhIMUBbUj1qZ+ZanoWQX9DohJUKUIWLD9Ekfdab6+WS/bW9CdSf9Q5oLev/6sMrHw7TEjkRFjTb+Wj0zF9O5t39cEx/1LzVXZ0PX0aUCMFNkiqf8wrQsMdCuAkGNmoNBao5jTby2KLc86LZ1QHwafId4YF0r1AiC7g6xVSBOaczN2VeU/+X5IW1OVfRDp7GY+Q60udfRs8jho+lnYbti720ztaOVi6nYf1snoYfS530sBe6K8rJOcv8INMpqEYh1XaPXd+H2jufR5IOoW9KejLOKifgTBLpwzavZh4RPm62F1QAA==
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h |  6 ++++--
 include/linux/swap.h       |  8 +++----
 mm/memcontrol-v1.c         | 42 +++++++++++++++++++++++-------------
 mm/memcontrol.c            | 14 +++++++-----
 mm/swap.h                  |  4 ++++
 mm/swap_state.c            |  6 ++----
 mm/swap_table.h            | 54 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/swapfile.c              | 35 +++++++++++++++++++-----------
 mm/vmscan.c                |  2 +-
 9 files changed, 128 insertions(+), 43 deletions(-)

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
index f2949f5844a6..57af4647d432 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -582,12 +582,12 @@ static inline int mem_cgroup_try_charge_swap(struct folio *folio)
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
@@ -598,7 +598,7 @@ static inline int mem_cgroup_try_charge_swap(struct folio *folio)
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
index 641706fa47bf..193c8eb73be7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -64,6 +64,8 @@
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
 #include "internal.h"
+#include "swap.h"
+#include "swap_table.h"
 #include <net/sock.h>
 #include <net/ip.h>
 #include "slab.h"
@@ -5462,6 +5464,7 @@ int __init mem_cgroup_init(void)
 int __mem_cgroup_try_charge_swap(struct folio *folio)
 {
 	unsigned int nr_pages = folio_nr_pages(folio);
+	struct swap_cluster_info *ci;
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
@@ -5495,22 +5498,23 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
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
index 80c2f1bf7a57..e4ac7dbc1080 100644
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
index 86d517a33a55..71a3f128fcf0 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -176,21 +176,19 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
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
index 8415ffbe2b9c..b2b02ee161b1 100644
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
@@ -247,4 +252,53 @@ static inline unsigned long swap_table_get(struct swap_cluster_info *ci,
 
 	return swp_tb;
 }
+
+#ifdef CONFIG_MEMCG
+static inline void __swap_cgroup_set(struct swap_cluster_info *ci,
+		unsigned int ci_off, unsigned long nr, unsigned short id)
+{
+	lockdep_assert_held(&ci->lock);
+	VM_WARN_ON_ONCE(ci_off >= SWAPFILE_CLUSTER);
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
+	return ci->memcg_table->id[ci_off];
+}
+
+static inline unsigned short __swap_cgroup_clear(struct swap_cluster_info *ci,
+						 unsigned int ci_off,
+						 unsigned long nr)
+{
+	unsigned short old = ci->memcg_table->id[ci_off];
+
+	__swap_cgroup_set(ci, ci_off, nr, 0);
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
index 2d16aa89a4fd..edf4cb36728e 100644
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
@@ -458,7 +464,17 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 		return -ENOMEM;
 
 	rcu_assign_pointer(ci->table, table);
-	return 0;
+
+#ifdef CONFIG_MEMCG
+	if (!ci->memcg_table)
+		ci->memcg_table = kzalloc(sizeof(*ci->memcg_table), gfp);
+	if (!ci->memcg_table)
+		ret = -ENOMEM;
+#endif
+	if (ret)
+		swap_cluster_free_table(ci);
+
+	return ret;
 }
 
 /*
@@ -483,6 +499,7 @@ static void swap_cluster_assert_empty(struct swap_cluster_info *ci,
 			bad_slots++;
 		else
 			WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
+		WARN_ON_ONCE(__swap_cgroup_get(ci, ci_off));
 	} while (++ci_off < ci_end);
 
 	WARN_ON_ONCE(bad_slots != (swapoff ? ci->count : 0));
@@ -1860,12 +1877,10 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 				 unsigned int ci_start, unsigned int nr_pages)
 {
 	unsigned long old_tb;
-	unsigned int type = si->type;
 	unsigned short id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
 	unsigned long offset = cluster_offset(si, ci);
 	unsigned int ci_batch = ci_off;
-	swp_entry_t entry;
 
 	VM_WARN_ON(ci->count < nr_pages);
 
@@ -1883,21 +1898,17 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		 * Uncharge swap slots by memcg in batches. Consecutive
 		 * slots with the same cgroup id are uncharged together.
 		 */
-		entry = swp_entry(type, offset + ci_off);
-		id_cur = lookup_swap_cgroup_id(entry);
+		id_cur = __swap_cgroup_clear(ci, ci_off, 1);
 		if (id != id_cur) {
 			if (id)
-				mem_cgroup_uncharge_swap(swp_entry(type, offset + ci_batch),
-							 ci_off - ci_batch);
+				mem_cgroup_uncharge_swap(id, ci_off - ci_batch);
 			id = id_cur;
 			ci_batch = ci_off;
 		}
 	} while (++ci_off < ci_end);
 
-	if (id) {
-		mem_cgroup_uncharge_swap(swp_entry(type, offset + ci_batch),
-					 ci_off - ci_batch);
-	}
+	if (id)
+		mem_cgroup_uncharge_swap(id, ci_off - ci_batch);
 
 	swap_range_free(si, offset + ci_start, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 63d06930d8e3..50d87ff58f86 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -739,7 +739,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		__memcg1_swapout(folio);
+		__memcg1_swapout(folio, ci);
 		__swap_cache_del_folio(ci, folio, swap, shadow);
 		swap_cluster_unlock_irq(ci);
 	} else {

-- 
2.53.0



