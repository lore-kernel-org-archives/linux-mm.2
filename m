Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE34FF327AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 06:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68276B0092; Tue, 21 Apr 2026 02:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6376B0095; Tue, 21 Apr 2026 02:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0F96B0096; Tue, 21 Apr 2026 02:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E25E6B0092
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:16:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 397711A0C43
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:16:58 +0000 (UTC)
X-FDA: 84681554916.08.AEAB44A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 300CC8000E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:16:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WpxEnVUM;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776752216;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rWWTlByF0ACQ29AI684ERDy86HJzFez6NIUkEuVQ2m0=;
	b=ytXV8Oy5qPXmrT2ebZ9yH9IJwTbRFzIBxJ8C9ICzPUdxHoaX6E0YwX4vXwqQYPvYNC8GP2
	md3m8+wHdGOKpBLmKAfpre3b10ISg06QFSq+CdDLKC3L6KdTkOLcjOww1nBXti6kF4+8HF
	ApU5vu6IZ+mnrKjWCp9AU70BVJ8OWeM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WpxEnVUM;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776752216; a=rsa-sha256;
	cv=none;
	b=Hp2W5CT/vg0S6Sp+G2PxJqRJjQ2r5CGZX3YXpnrN6lxVzE9vaGqw0xBCSCqTNRP/hQBIwc
	5S49XtgUT9oaKQKDPGBK6/Il3DZ652OUjij+3k0nZZFW2qlAKtpfPSZ2mLQ1wAJhdxIofI
	IwR3S/MfpPVlpgRVJpMOdIJxfkLtHQM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DDAD843F25;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8544DC2BD04;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776752214;
	bh=NW1oKKMYENCAmsCbaFyiPmLlS3S1VBvKWWbwodzZ4G8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WpxEnVUMYWP1pjGc0fL0MSXtrkHsgr/ygrqRDo5aI6+B+Ta1GCEcFWifxv5oIHJOx
	 y7jf3fzZHU+oObiSR5WZaEHHH2QN2Fcv1ZVC6dwoK+fjqCBvKJ6inTXsHXP5eiv1X/
	 rVITvQnSTV4eUpLSpKH4oydTEylhCc8FoSJR/ugRR3QikDs5HVJhcHTpYYzmWgshQO
	 NulNK9/cyN9Rj4ViFjWUAYEDvLLugGbLy1dfD/A0F362i1RylDlBy2Fhxtd0C+mli/
	 TnX7TcGgyqINK8/F+4x7cV1I84H5IWfOPoKHSxh0Ic4J8alp0jY8gFzrsa7oxSjJrC
	 LAcpMttF2g2xQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70BAFF327A8;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 21 Apr 2026 14:16:50 +0800
Subject: [PATCH v3 06/12] mm/memcg, swap: tidy up cgroup v1 memsw swap
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260421-swap-table-p4-v3-6-2f23759a76bc@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776752211; l=9755;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Nc2fixaBYkuPmtXYSLWP6dUczDBCNXQ/EuFrbwTRZhg=;
 b=fek0zHkFuapCitFRReMK/pTPatvx/qkoxB8cBvZHSLqoZotZB6gEiDZcIY2Cl8NCAGRtH+s+m
 Wdui6Ec5GCgBTLaMqJwau6x8GVf2CAqWvJf8B7obh8ZeyVNpFaL23v7
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 300CC8000E
X-Stat-Signature: yo9oems3879q1j53hrjpa73bpuqq79pr
X-Rspam-User: 
X-HE-Tag: 1776752215-377672
X-HE-Meta: U2FsdGVkX189Y/GP+CFD1CfVbSLv3+lANFjh/LwAsFRLDgNLvis/f+8fzCgsalsysAhHLTqN7C8NEtRtXaVWHkb6Yv7L9VJARQbTvHlGk+yXko5gds+nYmcfuXqqfCW4eIz3Sf10i9VLlqnH+o9zSm7cN+cEmMnVoXBmUMvoGeKwR122x1nb9LdqxUkqGogJo2a/NFaO9n0QFiiz+55/BaqleTslfD1fAAKQS9/YsYTSKIoQ+aI5H4hSIPNKCM/xpqReamZm9BKxEiZZWZlj6hmKTMX0/A0w5mcqzDNJogMM353Pxz6FjbLzeFN+rupByQwUSdk+tVYo2RwSUE8KtMRzUeVhvCelc7pwEjn9AlgSlSDaSaLMhQf69oeClTn0VJBrdjzFH3XuitEWBzj2g/RLKtuN50T6M+Z49GZmQZtjLfgDf3O/qaf7X2zZmgiUoVeEZdeoC4xe4iFaynVzuGh+2StM6DC/FRBlMCk+r2lcS7gaZXe/gsXxqFRE46nUhBvMPHaTC+hpgx7vij0C/Vft64Oa+oLckHLZfEgIaVLkRr2+bXXjjtxMeGmUP2f5iU3Nf8i0kWgBY5TRC/61eErL6Go9GWb9Tx8DPoPfff9as3YlyaBIMtJWZsh+ggxcONLNH1tJ6stCK4nZdmJmBl3ovhSluSPzlQ8fpAGG5JYP2r2zcT/IvbIvuyk7pycJrt3Cdug0Z9LdZepfpPxsB0XQPTHyEa6A6LJB57TQkWrTiV6Dzniy08WX+nm8ZGd4rCcbDwRK9JP8hugAoA3xncQg922r4UIanI9XL/I8BGNK0tLSKzXv/Nu4GUqaBLSCX7Qcz1xOzfwnQvG6nycnWecrqaWsbr4ITUwxpDRrqkA7ZoJpxGwqkBi2zHr5IukAL0RHF81G+mppY7081Pp1PAfms0Ir7VUfco1y9iV+C/ryplpZWNiSYeacGd9zudoVGY4CVGn2p4FXeliDWqB
 3mhUGivh
 fIEDEClgFx3bQ26gQqvOjJ4PWw65p50Sgl+TnXKRu8DwfrQuzMeVmGc0i0myY9PRasXOKklvqDIaqd1rSMyrvxwoV56/V7giXRcN2hgiwMt8yPnuJBELHSsS4H/QoTL83k9aJ42wl5lFKr5F+JQvfE0gwIZLu3cJVaW7o2EUqPYo/GiOytDEn2LeTng39PloMT9Ka6+ZrxLuk4uNKrIatYZR0v1uW0nbB/z+9rsTwW32d9P9J5e3La3SC5IAaLpovG8RzaQe2Xxe8iUZyrSyb0sED0Wo25+a5C66+e4RC3WpJ4c+SZ0VEYuXlJcET5fL3feP6Wd4mXtNyMh8dlYea2N45SI/qXHZXoXY0n2AyzyWuUoOvtFsmLd5m3Uu7CdQZgbzDDmQR7jnUmEZSQvZL48MJtQ==
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
index 6ebd062bcece..12b290d43e45 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -451,8 +451,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	/* For memsw accounting, swap is uncharged when folio is added to swap cache */
-	memcg1_swapin(entry, 1 << order);
+	/* memsw uncharges swap when folio is added to swap cache */
+	memcg1_swapin(folio);
 	if (shadow)
 		workingset_refault(folio, shadow);
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2e384d1c78c3..e1ad77a69e54 100644
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



