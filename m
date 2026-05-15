Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 257F3CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8D66B00A1; Fri, 15 May 2026 05:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E026B00A0; Fri, 15 May 2026 05:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E566B00A6; Fri, 15 May 2026 05:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 16A116B00A7
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:54:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CDA88A0435
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:25 +0000 (UTC)
X-FDA: 84769194090.08.443CCE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BB58740007
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EOc1qSOe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838864;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ac1eWnL5jrnX1N85dCAjyZB1MrMYVvdk5ScDUUfaTug=;
	b=TG2re9ajFcKBPakUmUed+HyYUGBWoR8chmmyAsvCZDPZl1CK8pY0zwOfpKVOPiSg7ftHYl
	MsQc4my2lNK432lLIhX1+fOfjBksGhMJ6CK1JKjc0j2ud+JroyYoZqa4+kMyKItNZo2Ttz
	SMcLtayVyQPwh4t6fznUeQro7pKCgLw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838864; a=rsa-sha256;
	cv=none;
	b=odTbszMLGhVlGPfVdKyHpbVHx8HBpU/c3yKJ3EQsyfV59nKdBW8ZR7AA2W7pOLND1bRqsN
	jlYfLPG5j/qgK2l/Ibsl24ZB6WI6KLa8z5eSCk6AKX0nBWuKh2+Uz6kNhO5Jk9UGPh20Zv
	govqsJxWpLdxd77VG6TcRCbzImE44nc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EOc1qSOe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 72BCC4456F;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36038C32786;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778838862;
	bh=WmG+ftRsv4kBv91IxwUQa1+fY2YN8g7o+B8cxtNdqPs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EOc1qSOeE7iB7TynFysblHFNKjcsfgRfv17BfHyn5errUnjOUTg/F89mbm1SRinmZ
	 AMkxnllQwRISkVeUkD/WAq7xyPsO//acN0Rf6/eMSeL7VTYARUZZCi4VxVlk1mOq+9
	 4bfWQhxZe8tdd6oQdj2bAJzgZpCkjDfr5wADYfFKhQUAo0nVQcn3QjNpADVKpUqqJa
	 45ho3QFt2/xF5pbd5ihVCR8ttOAjRktljBC7QLjs51R4KU+gfuUQ+grXVpffF/D+7G
	 n/6RCrYYuCk1TfS7bZhHRMybz6H9xqlBuXPhH/9ww8Zm2mPkP10paTmHLCixhFxXNZ
	 YMSXIM8uCLzvQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFCACD343F;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 15 May 2026 17:54:19 +0800
Subject: [PATCH v4 06/12] mm/memcg, swap: tidy up cgroup v1 memsw swap
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-swap-table-p4-v4-6-f1b49e845a8d@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778838859; l=9795;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=MmiietjjZiCHZLwKGhcLjr08yePIexfJK5gM24TD2a0=;
 b=yOvHW5VoKzryaKUOJeQyhoaKBYpfXQNuz+OK5Ob7BDQAif6vLRr8jpFg9hQW3ObwOKXsn9yOj
 xADnhl2TdrHCXU0ER3dNhzkjK4g+90sxn+VMsUagl/w3+FalFC0NKPQ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: BB58740007
X-Rspamd-Server: rspam04
X-Stat-Signature: ipszgnb6ed9iqiybm4mz6bspcnow44gk
X-HE-Tag: 1778838863-370933
X-HE-Meta: U2FsdGVkX1+pboZSmVFxOfubykuixmav74qVsiyzj8CNumo4kVh20y136pb9nO8Pe/nvmlyfdHqspcoVx23re/ysKoM8Q+i8wV719HMFhDlYUoudGt1QDjPUL/D/DAEM38TRl4azkNG2er6YolOLVGKOsQy8SF6IYzkQDK4gLw0tmnPHo/ZIGQZplkaxq1pjAodi6gHrBh0iIgAp1c3ZuZIxpc3OlxjfKLcbRmWH6Db4Sm3TPIwoH5d+7/1WLcogJ5O0A/u5GrY3a2z4Y5E44+hQ9oT+l6tlzENb1oSYBMCgFAVkYL7zuM/p94+KUP4lSuWBs09/mxezRID+R3Yw78Ah7fZeCr/4jOZUmAjM+ZEEBRUhIW/krE3cJdB+DPgs991LWbnLH0Ijob1RGu97jKG0lPSoogoRQENYVPoA5HWJXFwzKCR4vbeZVqGwhkYTMcUjy42I/Gj3dpK79XPmiSQvbCvM78su6uX2ckqdIBz8ArX8h7r6B55u8FUEU/pbgo8lzgbQWzo4ZRBPEmslabc8aL+DL6ljdqKpsqhGSpZj1Znikg5OTa4ne/XdtBqUaV1zi+7kAv5dNFNFrksStAkYGrgm8koYr53ZS+vRQgDHKZwoxIy1wHVksQeUaCFDzpx9uwXaqbXAVdn9GsvA6LAkiNL7/L1qQADXcC/zGy7qEBBuSaF7eteUia2JwGC866yOoluQ86Vi2I0zzqQNa+kBEB2J3NkDTTCd+nOiGRKg9TzLCuEkkA76eonxQspy3Q2gEzk1I0zND7+rd3to/P1kw9ntA9BthiHATByeqiIQcVr0riJha4GnjsoKbz7NVwYQY7uRCPdHA3eA5hggSeAKrM8A9aCQUHHoBC5u+4czguQtY+CA/FgyWUgDUZkXHOzM7VTVItaNHgdBCPGqVu84kyml7PanNeULDSfURhr3NR7efKSBHjLRUfig6GNIkMxKEGH/DgrsTQ6l26M
 p0pZGGgJ
 DQXhoPDi93g8fk/thVCOOAVw3j3AGlQ8Q8Jx8JknLenWcyxrWzAxw6VsrRXLdvvg+LmLRqTpdnbDcth0+wraH7AL5wnBLE5vHQ5qvdtU080Zatyj8au/2NyNvxtIzuhvdl4KmRBMsfuJlISbAaULWWMMO+Ja8y4FBphcmPxAT+nHyPxg5RXmEePkpMrfsL2RFBmEUyItbPwA0asyOpb2s00PMw+3uafoLAHyhPpczzyHvOC1didhLANjcGSIFwEaB661cYW845kcDOAJKzDRRzcuGUIJImMTDKRIPCp1o7lhc2mXGwPTp/RIl3Mlo/JkqsFCPXqLv0LERheGeQW9uTr5wOU6f2l50k4kEDChEKKLt/3cp8+QfSCJQF9PtOWeDIGgc9as1/zk362Pw5q5G5WRcCksBOXirNMoZk4LX3e6aD5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The cgroup v1 swap helpers always operate on swap cache folios whose
swap entry is stable: the folio is locked and in the swap cache. There
is no need to pass the swap entry or page count as separate parameters
when they can be derived from the folio itself.

Simplify the redundant parameters and add sanity checks to document
the required preconditions.

Also rename memcg1_swapout to __memcg1_swapout to indicate it requires
special calling context: the folio must be isolated and dying, and the
call must be made with interrupts disabled.

No functional change.

Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h |  8 ++++----
 include/linux/swap.h       | 10 ++++------
 mm/huge_memory.c           |  2 +-
 mm/memcontrol-v1.c         | 33 ++++++++++++++++++++-------------
 mm/memcontrol.c            |  9 ++++-----
 mm/swap_state.c            |  4 ++--
 mm/swapfile.c              |  2 +-
 mm/vmscan.c                |  2 +-
 8 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index dc3fa687759b..7d08128de1fd 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1899,8 +1899,8 @@ static inline void mem_cgroup_exit_user_fault(void)
 	current->in_user_fault = 0;
 }
 
-void memcg1_swapout(struct folio *folio, swp_entry_t entry);
-void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages);
+void __memcg1_swapout(struct folio *folio);
+void memcg1_swapin(struct folio *folio);
 
 #else /* CONFIG_MEMCG_V1 */
 static inline
@@ -1929,11 +1929,11 @@ static inline void mem_cgroup_exit_user_fault(void)
 {
 }
 
-static inline void memcg1_swapout(struct folio *folio, swp_entry_t entry)
+static inline void __memcg1_swapout(struct folio *folio)
 {
 }
 
-static inline void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
+static inline void memcg1_swapin(struct folio *folio)
 {
 }
 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index aa89e1d30a77..6b3acdf9bdd4 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -576,13 +576,12 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry);
-static inline int mem_cgroup_try_charge_swap(struct folio *folio,
-		swp_entry_t entry)
+int __mem_cgroup_try_charge_swap(struct folio *folio);
+static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	return __mem_cgroup_try_charge_swap(folio, entry);
+	return __mem_cgroup_try_charge_swap(folio);
 }
 
 extern void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages);
@@ -596,8 +595,7 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_p
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
-static inline int mem_cgroup_try_charge_swap(struct folio *folio,
-					     swp_entry_t entry)
+static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 {
 	return 0;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c565b2a651e0..42b86e8ab7c0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4430,7 +4430,7 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 
 	/*
 	 * Exclude swapcache: originally to avoid a corrupt deferred split
-	 * queue. Nowadays that is fully prevented by memcg1_swapout();
+	 * queue. Nowadays that is fully prevented by __memcg1_swapout();
 	 * but if page reclaim is already handling the same folio, it is
 	 * unnecessary to handle it again in the shrinker, so excluding
 	 * swapcache here may still be a useful optimization.
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 433bba9dfe71..36c507d81dc5 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -604,18 +604,23 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
 }
 
 /**
- * memcg1_swapout - transfer a memsw charge to swap
+ * __memcg1_swapout - transfer a memsw charge to swap
  * @folio: folio whose memsw charge to transfer
- * @entry: swap entry to move the charge to
  *
- * Transfer the memsw charge of @folio to @entry.
+ * Transfer the memsw charge of @folio to the swap entry stored in
+ * folio->swap.
+ *
+ * Context: folio must be isolated, unmapped, locked and is just about
+ * to be freed, and caller must disable IRQs.
  */
-void memcg1_swapout(struct folio *folio, swp_entry_t entry)
+void __memcg1_swapout(struct folio *folio)
 {
 	struct mem_cgroup *memcg, *swap_memcg;
 	struct obj_cgroup *objcg;
 	unsigned int nr_entries;
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 
@@ -641,7 +646,7 @@ void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
-	swap_cgroup_record(folio, mem_cgroup_private_id(swap_memcg), entry);
+	swap_cgroup_record(folio, mem_cgroup_private_id(swap_memcg), folio->swap);
 
 	folio_unqueue_deferred_split(folio);
 	folio->memcg_data = 0;
@@ -671,18 +676,20 @@ void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 	obj_cgroup_put(objcg);
 }
 
-/*
+/**
  * memcg1_swapin - uncharge swap slot
- * @entry: the first swap entry for which the pages are charged
- * @nr_pages: number of pages which will be uncharged
+ * @folio: folio being swapped in
  *
- * Call this function after successfully adding the charged page to swapcache.
+ * Call this function after successfully adding the charged
+ * folio to swapcache.
  *
- * Note: This function assumes the page for which swap slot is being uncharged
- * is order 0 page.
+ * Context: The folio has to be in swap cache and locked.
  */
-void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
+void memcg1_swapin(struct folio *folio)
 {
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
 	/*
 	 * Cgroup1's unified memory+swap counter has been charged with the
 	 * new swapcache page, finish the transfer by uncharging the swap
@@ -701,7 +708,7 @@ void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
 		 * let's not wait for it.  The page already received a
 		 * memory+swap charge, drop the swap entry duplicate.
 		 */
-		mem_cgroup_uncharge_swap(entry, nr_pages);
+		mem_cgroup_uncharge_swap(folio->swap, folio_nr_pages(folio));
 	}
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d978e18b9b2d..a28a68eed7ba 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5464,13 +5464,12 @@ int __init mem_cgroup_init(void)
 /**
  * __mem_cgroup_try_charge_swap - try charging swap space for a folio
  * @folio: folio being added to swap
- * @entry: swap entry to charge
  *
- * Try to charge @folio's memcg for the swap space at @entry.
+ * Try to charge @folio's memcg for the swap space at folio->swap.
  *
  * Returns 0 on success, -ENOMEM on failure.
  */
-int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
+int __mem_cgroup_try_charge_swap(struct folio *folio)
 {
 	unsigned int nr_pages = folio_nr_pages(folio);
 	struct page_counter *counter;
@@ -5487,7 +5486,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
-	if (!entry.val) {
+	if (!folio_test_swapcache(folio)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		rcu_read_unlock();
 		return 0;
@@ -5506,7 +5505,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
-	swap_cgroup_record(folio, mem_cgroup_private_id(memcg), entry);
+	swap_cgroup_record(folio, mem_cgroup_private_id(memcg), folio->swap);
 
 	return 0;
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index f177c4b3ea7a..cdb7859eb502 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -455,8 +455,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	/* For memsw accounting, swap is uncharged when folio is added to swap cache */
-	memcg1_swapin(entry, 1 << order);
+	/* memsw uncharges swap when folio is added to swap cache */
+	memcg1_swapin(folio);
 	if (shadow)
 		workingset_refault(folio, shadow);
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4e5a54769e81..5c8bb15719bf 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1731,7 +1731,7 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
+	if (unlikely(mem_cgroup_try_charge_swap(folio)))
 		swap_cache_del_folio(folio);
 
 	if (unlikely(!folio_test_swapcache(folio)))
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b3e555561417..924c84326551 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -737,7 +737,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		memcg1_swapout(folio, swap);
+		__memcg1_swapout(folio);
 		__swap_cache_del_folio(ci, folio, swap, shadow);
 		swap_cluster_unlock_irq(ci);
 	} else {

-- 
2.54.0



