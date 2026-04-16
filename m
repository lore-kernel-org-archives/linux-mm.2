Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC2E6F8D755
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 18:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289886B00A0; Thu, 16 Apr 2026 14:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23AB86B00A1; Thu, 16 Apr 2026 14:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1290C6B00A2; Thu, 16 Apr 2026 14:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F1A936B00A0
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:34:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B9AB61A09F1
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:34:46 +0000 (UTC)
X-FDA: 84665270172.26.07351C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C735C140002
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:34:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mYS3761C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776364484;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGATD39YIHuZCEfXUAEUUF9c/hmc/78bxMHkkRlK8rs=;
	b=M0M9IL1uf0F2jpDmlytCY28OulVJq6z1uxzNG5MnarakaTLSK0BzuO6E1b82zi3jekjJiR
	R98B+gLqfUezYoxXb64apAbq/Thngir1V5cCksX3QKOcgejqGZMgoycquqCNuJvHLNgtcn
	KJV54XZE9BX3ocy5tvTOgWT/psea0Q4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mYS3761C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776364484; a=rsa-sha256;
	cv=none;
	b=J3416QvA31QpsR23pJQ8W5MjYi+1FjXnl2gb3jJm7P2afeX9klUFIKjt5IrbdTDPACYDJx
	iPtiSQUapv8nWDXtmloVxHRN1qAn9e2XxsOUircja00yXW3OKZxbPcqKUCgWoz0wDk4jz7
	m3PyKUkfYBnugMs4lb6hZ8FcAJf6bL4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DBD976013D;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6902CC2BCB9;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776364483;
	bh=keQ1BeBAXWAO94uttblsSu08pS8n950oDEWAKxtRsGo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mYS3761CAGwp1QxCRdV/asgz1qniNUep9VuxE0Cdh8aRXAPUH4aRurGBCjcdnMUEs
	 /1hnPSyJIBw87N0yN6h5QlwVR8GphcUv5MCHidvyiAekDJTEq5DSMcJiNKaEWR1518
	 KmfKiwF6P4vHX++gdYm7PUquEc6InA4E7TvT1oy3lzBBlsu3Wv6oGJf4BqzLzTJodh
	 lJ8CY5FhlKRNGUWKXNoeJ85oGGnzd4Rr1jYS7L1CLavA0UZq5TnD1oYC6WDN1aPBhR
	 1/3HR4Hf2eaBJNGMMmPv/V3zMlNk0utlV3Lkhg2jAQhWgyetnu8IGRAjkIQZMEdkIx
	 xOtn4++fVH7qA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1E3F8D766;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 17 Apr 2026 02:34:36 +0800
Subject: [PATCH v2 06/11] mm/memcg, swap: tidy up cgroup v1 memsw swap
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260417-swap-table-p4-v2-6-17f5d1015428@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776364480; l=9754;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=xo/FLhG0Zbwo5uMzzJWgjALtV/uD9D6v6Ay7XRQhtEw=;
 b=FQZxi+0cO3HgDmbqTPj3oBgrae4/YkO2A+YKxyl7e1zvTiBVpYQ+U6bSpAn1Lg/XpnWU5a3RP
 ndSSuOOi24UD20L9yzINX3wuV68CsYC4qioqq60LeN8P6i22NCGBRPS
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C735C140002
X-Stat-Signature: fbek78fo6bh38uxwhrfrk87kwfw599g9
X-HE-Tag: 1776364484-596515
X-HE-Meta: U2FsdGVkX1/Dxp+Y1XSR/w5Q/AUL8UXA56BsZxl89tFUw9RsIF/wsMzMZEyNiqkylLpNe7hMkDl/1MIPJMt/91JF4c4943o9gptrql3E8J4H5gnfm1Z1Q5Sh3xyT29QOVPinXHPi/ZgCpSG6FBxKhtz0Lf/q1hyCtzTjbKvTpW9aCBOgqknTidQ/wseEQXk1xnA863IB9BDZFF149sKC9elMJiIdrQuSK6r8kQQ7dmcGzT9J6moUJ9TqYKFNd21TpFFQ+pSSlbmo1y4k7ieTCj+FTb1Z0rliUHCCLsVAhuswlfbk5ImwceOqYRq7Ov2mJXV0XJOJeUCtt3Boo5q1J0Krnr1NqLZp0Z+ArW+4Xct2RB4cg+3Q0ztge6ZWW3UXiYzL+ZfS+1doMaDZeixwJ4j7n/6vFLgAGhYN1hoFvfreSDR+RdqH6Yb4NAw+YjOfSabBK/Sog3CC+B9R7dsQnqiug9MsLLG3uZm1rJKDaEuLaFmrJqdIbKRwBdl4DqgYd63Law1Lvf9kD1/tsw2krdt36kJ2xs54t0yM7eIb3G0khj7/tEk/wYL12x1h32zYA5suxlNGp+RufDHLzdXnNXLwjTXfR8+qLrkq/mfGzhfi7lb3cyJTwCyCmOPD6oVw8zj6I8GN6ZhyxYUfPCOm83hIHv48SZhjhI/LiC87kPeHkefW/n4ie7VV85/QRJxYt12OeAkeG6CWJa3bE/UHQ1CkuBiQGPmttq2fc1nMxDHmdfbP1xPrYS5Fn7tGEDUR4XaGGhP412wyVmwHv0P+pq5B4+jqtlWoOoRJCiCSCCWa7VnFkr0denJC3In3LSuItmhOMQtlg6bRNb9pwDhTNsK7QWnRC5i7AbmKMX/jADMumn9PF/Nkag0uTxZ5X0RXMLpM3LVskoLyL5/4fE637/TYkvZcjuXTORjeVcs5SKbSbg7SPc074lzVm2DLA6cpBg5yhnK6GJui3cN9FI9
 p4DIm3pj
 zSr6wcMwmOhFi06Jx14YCboFToYugiSifIUM8DmbQyo9av30yLW+WZYYNE9Jaw2k6D5/ZwHku0JsO2lFRaeC5KOlz2ta/YH4SVLQPaPH+hYLfy0LFNIMfgk4BtKmPjpZS8ofe/jN+lYDj8AbvyiaZcOWijo9fMNqD6uUmuASB5kkT/pfKd06XJow87N8Il8qjJmg6mSry844bJBOzFvrlNOjWOE0mc1y013Fgg+TTqxQytsbBWf+tDhfW1A9hVaimOJkXmr86PA+eArKldNQrf1bb02R8s5tfREZlui71HCVYVMok8De8YDCMHD5kzyIqxKcSeP24TG6lnyCjzAxJyWZrKKMceRcTQRveXf9lRkP20QL55a3CKBuR03K4EE2TvJ0ARDWX39NoBuJc/8YPNJv4GA==
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
index 1930f81e6be4..f2949f5844a6 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -574,13 +574,12 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
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
@@ -594,8 +593,7 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_p
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
index 970e077019b7..9630e283cf25 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4431,7 +4431,7 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 
 	/*
 	 * Exclude swapcache: originally to avoid a corrupt deferred split
-	 * queue. Nowadays that is fully prevented by memcg1_swapout();
+	 * queue. Nowadays that is fully prevented by __memcg1_swapout();
 	 * but if page reclaim is already handling the same folio, it is
 	 * unnecessary to handle it again in the shrinker, so excluding
 	 * swapcache here may still be a useful optimization.
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 433bba9dfe71..c8579395ed80 100644
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
+ * to be freed, and caller must disable IRQ.
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
index c3d98ab41f1f..c7df30ca5aa7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5456,13 +5456,12 @@ int __init mem_cgroup_init(void)
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
@@ -5479,7 +5478,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
-	if (!entry.val) {
+	if (!folio_test_swapcache(folio)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		rcu_read_unlock();
 		return 0;
@@ -5498,7 +5497,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
-	swap_cgroup_record(folio, mem_cgroup_private_id(memcg), entry);
+	swap_cgroup_record(folio, mem_cgroup_private_id(memcg), folio->swap);
 
 	return 0;
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 21358ed17aeb..af50e6a21850 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -454,8 +454,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	/* For memsw accounting, swap is uncharged when folio is added to swap cache */
-	memcg1_swapin(entry, 1 << order);
+	/* memsw uncharges swap when folio is added to swap cache */
+	memcg1_swapin(folio);
 	if (shadow)
 		workingset_refault(folio, shadow);
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3aec76d93075..2211d290ae95 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1730,7 +1730,7 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
+	if (unlikely(mem_cgroup_try_charge_swap(folio)))
 		swap_cache_del_folio(folio);
 
 	if (unlikely(!folio_test_swapcache(folio)))
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bd1b1aa12581..63d06930d8e3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -739,7 +739,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		memcg1_swapout(folio, swap);
+		__memcg1_swapout(folio);
 		__swap_cache_del_folio(ci, folio, swap, shadow);
 		swap_cluster_unlock_irq(ci);
 	} else {

-- 
2.53.0



