Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8418ECD4F4A
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 15:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40086B00A0; Sun, 17 May 2026 11:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1786B009F; Sun, 17 May 2026 11:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8222D6B00A0; Sun, 17 May 2026 11:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 334266B009E
	for <linux-mm@kvack.org>; Sun, 17 May 2026 11:39:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0CB41C04D5
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:39:54 +0000 (UTC)
X-FDA: 84777322308.28.0BFF415
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C25754000D
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:39:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OrOM3DO2;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779032392;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUb/wDTncbWA3KU8KRzZi82VJDYEpcpMYIbNOPcYaww=;
	b=T8gXjzlKHNSFphMXb26B/3vX9DjV3ASgbrbKwlMaETI/isamt+6ajko9cwSNIjIF3YWV7H
	g4xSdoAYpo+hTnFeboZ6JaNLT6ENnBOH0frg3bEoz09xIttzE/AmmJrGYo2+YjInmqqGEu
	fZvZPoZ72MniczYvL7UAJp7e/B9SBFQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OrOM3DO2;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779032392; a=rsa-sha256;
	cv=none;
	b=7V+JN0yb7wt68le9ChoDuMMgT0ke+/aQ0TiIQeaLpJtMAXRy0z0K+3KQ2lODpJ9ZC4zzpl
	DV4O6JlpPoFpkPNFabwk2Rm1Q9ZwT95z2dtYRGnl2wFxDqA2K2ywIKZvTcstZq6lXaeRvv
	pf1OK6VJ7caJuIRxLaw2MYhPZMx00W0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 307B0445E5;
	Sun, 17 May 2026 15:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D97AC2BCFD;
	Sun, 17 May 2026 15:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779032389;
	bh=ywsc30h0pTm+0AkzKZFg/ZB6sIicQ6hYTTCBSgZ6DLU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OrOM3DO2RP6CNRzGi0gTw5Meh8zh9zGkh0Dugc17AyavRrzo1KJBuYsVUkHaPHQrd
	 ICNW8cdqMeCsZ4nNq0OX/CxGLpNULIqbl8Do+pYSaSevlp/AvEa6SEZZcDQMoAxZrn
	 iOCAnu6uWZXm0D4p3thDf2MVn76GJtInzLK+B1o53xPzFFaWTcvpFxbOnvK7+YIMua
	 9I2+M/HG7e0sxMevLoCxaiewcc6YW3KRcATZlUjUcgcHpxTVBNJEevMotNAh9YhVhn
	 qCClJ9DAvkukF/8PZ5QVxGbbd9SGO5yrEV4yKRtZCo0nXsE7W9Zif9PB1LzehpH2nK
	 7qJ11Lg9vWh3w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04059CD4F47;
	Sun, 17 May 2026 15:39:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 17 May 2026 23:39:45 +0800
Subject: [PATCH v5 06/12] mm/memcg, swap: tidy up cgroup v1 memsw swap
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260517-swap-table-p4-v5-6-88ae43e064c7@tencent.com>
References: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
In-Reply-To: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
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
 Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779032386; l=9795;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=gCgUUE/Etfz8T9X0Mywmw2qi0UZBkmFa6lWPz7BcjGo=;
 b=zSehdC7R81v31OVC9Y5cQntcQByyo/27QgkaU/0kJ+Ss/mYlUb4eBRTiM0MtTVnh5TTV5GRbp
 h9jcqFma61UDq9qXqQV5/Jm2JBtOrvWK7radt5LhwjGxhF+dsYeJkqS
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C25754000D
X-Rspam-User: 
X-Stat-Signature: sh9w51gfo6eqzbyuz9i5miczz93cuqzx
X-HE-Tag: 1779032392-715745
X-HE-Meta: U2FsdGVkX186JC21vexA1uYAeKOPo6YcIPTa3F3YHH1Oaj3DRotYAJ4tyKwLC2aXePoNieelSdkeSbVlv1uFEQZ4j8D6yN9vExO5x+G+Lf9CRObGC6dYJDrDrZyl0jd/ZWBAyPjU2GLAG0n60NmK949TI9y4V9vDnYg/kmPUUMWJLdSFC1+GZ64m6rPcuLX+0oVCaHneWW6dGejO6wUToDGWcuYf7dUS4sto58T7WPTQYKkFvL7etXDZuinqUQIo7dAsVpUDd+EuS5NfwliSE7qGWCU5HpRU22vWEqoEw3+npITjYCGDxlm+aR+BlMiu4eHfMbZXZYvFwhKyGY+/3HTbf/8S84mn8Ew4brsS/2Phi6hM4JXRFctvOCjQvFbf2fEC7It6JaTgBmpS/Y06NGQsbMYJmXBCg7aANpyQ0GN7bMOckbnaxQ9ugVwUUwhBVGBUJWtWJalIHqB6t/7kFIbEgpBYFNmXJFwDkmJNPWe/SCgKacQikDrnLJpL+Kx5T6CEA6MJxk+eGXohkp2vEZKxCIRtrH2fC+3EyW2aa2hjGd9lhXN7oDvt6D+I0OPYxGrG0W4erAHUGVxlloiKkPPEcOT5duMQqhU5jWtKyOAYd4zPey2GE3KOYuKAWHIeTMVjdvQsoJebFzStS9YqYbIX5dTTljBSBhHt0YxLzsIC4iX6V6fP4IYjrXshI6nhpRGUCZ82CFYlbBOn3R9fAcpDIV8z5krJzwARGDGAhTggGz/eAkK9fSp7N7IrFuKP5iY5gK959yge1XGyJQvinKhQ3LlknkN7a0hoXthedS1OkEsB27ZFOpY1yPdEKgbmk31+vhRZOWJaMJ0nY8uM25FGQvX5pHiWmrSKxG8gZ1wueiHv9PGherRptJy8YLcIBIM4MVnQUw+CC8gdVnGBlT+G1bQNZ4E7OgiH8J5CP/2RJvzEaCLAxdX80m+OQdd1y0tGMzOz6BvwPxTXl+z
 6AuyQJ1y
 CD1EnX5b1GfjiK4FlpH/ATZ1lj7cxOQwEbF4OvEwPvUlUszy67DnDqRmhJ50u8UyNWPlt4qLk73KTJgm/mWfH/5naEQMarU9Nmi3rbltL5JNv1wocz6woWnxaac+cuJQY4ejvAh9AdxqF61S4kp5cM2BNiLHl/z6gc4miX4RXVsB9pyKCftgBFIxbH5m7PbhgoPkgZYN2MXc0lb8IPoWjqHiFn7ZyiEkwqgGrrnUievuSu1yePxdGQ4umF5GMVlZMLOBf2c6K181vetWyMTMYnlHLuopm2ep1fCncZzcJqDx/qKtn3mDCXIv0NkNGeP37s57YcA49Ct7j+obOdaXea3rPaajShE49Gr4vRxCcM3H9CldqhjK0ofLPl5nF5P2zCa79goRbwndS8M6NO+jPKf6V4/9dT62sLW3Nwp82ZPJHMzw=
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
index 98c8691826fb..7a80494fa37f 100644
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



