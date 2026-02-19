Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9566AC531EA
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73B146B0089; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58FD86B0093; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CCFF6B008A; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1B6F6B0089
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:42:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5694BBEC3
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:10 +0000 (UTC)
X-FDA: 84462832020.06.55FB857
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DBF3D1A000C
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rGlOZxrj;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771544528;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9qSO4pqXhaIe1JZvcGwJy5N6gC4MInAtM5nePCaixA=;
	b=iEUlodO8jbvFX9aSIIDL2AJJF7TQ5e2S52mF/7f9wnnYUzXD1fCVGGny9DNQ4oM6ziZKT/
	+no2CzzUIxad6Gqfs4tnzQtUA7lmWP0M9oudEH9PfoMVxq8RgG2ezk1ZGrnsSgevj8Nce6
	EIjt2lhGxN1hk7uFE6d9PSLqISgig2o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771544528; a=rsa-sha256;
	cv=none;
	b=YgK5P5zqV8hK1RySIFkfVggIds3s0KsBxgP3ydypC0d32Jt3gzaiC6HooneJ8VufjLf4hA
	vPKflhIBsTxK8yiuag1zc0bZqmMsK0Q4rF66WMJrSObvD+EJXZYqCsCVQgqM5cXDX7ZW6V
	A+lN1hA57mrhLgUcqqIm1RiUrhosCbQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rGlOZxrj;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 07F7E61843;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BBD16C2BC9E;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544527;
	bh=IyPbPri7CX9GB9ElQqKtYupl/DO1oV0ntplpsuoO26M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rGlOZxrjUUbEbocvIWQJL5OUnMKQ82iiddmBFy7bqyEsx2vHK6VcxkxgoIxPW6Tq4
	 Hef4l34HceK3MkuSYA+62O3ejlrl1CXpHLq0TlTWuLctL2s7vlpZJZFDAD8WHMLeJy
	 4trW5/RJYMIHylk0U6rnohnL5AhOIpCzmIcAoGfujAnNPB7KCCsfipuvmSTbC53DUx
	 eZFjpy5zu3Zd5t0x6ZJ2QJ167AKPT+Lg4/505fUlAYyw1YEft+h69gMhY3uKa/VRFb
	 +svFQj7PNnDqhTsWiw4+8M/pqWEPBbF9e8abEhUK2vtSqlhwNoVfk4/+GkpUdPXIdT
	 Q0O0CA0Epi52Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0974C531EC;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 20 Feb 2026 07:42:08 +0800
Subject: [PATCH RFC 07/15] memcg, swap: defer the recording of memcg info
 and reparent flexibly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-swap-table-p4-v1-7-104795d19815@tencent.com>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
In-Reply-To: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771544524; l=21986;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=N4eG7UwpOV73KkZjg7SfKoYbB1/U5wsQN6FM7xZMnN0=;
 b=L/TS1LIkjpq+Vev1o2AIE5orrNSx1hnsyAXzgwsEd0IOlMphL9qo415nR5XllR+SY+cty9Op7
 OolC2HsaQP5Bo/NuKjTGkfgpmh8T1WZtjS9xwmynQELKXWIbAPfpwKr
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam09
X-Stat-Signature: xi7jugsjwienttty7pwkgd7pyo18w8mj
X-Rspamd-Queue-Id: DBF3D1A000C
X-Rspam-User: 
X-HE-Tag: 1771544528-442565
X-HE-Meta: U2FsdGVkX1+GrKkvV8X2IaRMo+6zD//kGCR09UwoGxe+gFG+2vMpSniknzLQtNVGJPkPjaSC6gAEthlMokFc10MOS31J5tJ+Jk6G5sgedl9R3Yzi0zytpGtSSWPHQjojpA2NKTpnK+vjmY4SymQh+CD+y4zSeQTSwGUpD6ovyhNivMqV5AqoccjOrPQgN2xPVVLKnXI/OMCKklWrOD7trxSiIEG+8FyQPMQRnQYvQu9pCuxh00ddqqrrjY9ffIoevDLYm4atbRnqz60EhbBXi72ICGqfN5lnRx175/kAgMrT2O1pQ1NLTfmHuzqNw4IyuXmC0nGK54h+5V911TC2KkY7H4A6HG12JWwa95kgHV3DbDW6KVF7RSkAVkLzXazMwrVx/lBJ4QXfDjqjr07rn/8XskamkOHi1WjSH6iuC4XZDwmSAcw5sItypKPNvAg2DCshkeB9sCkE58kGlO1YJoLM4K+Er3Jn701UemK8xr4sm8bwdlRnE7EN7ozpLafIQsvCKMrlOcx8o1KpvUtQ0hPB+6nWvpbb1epJrFhNLGB/vYAaDJym5tx3sf/uhf7wy+z9CYK8KnYUydtC5IOSFXZuE00M8XKLU7dxSgXa6BldSVdYSnXyrnxJ8xtNer5D62W6ccMDoiwtvlitHUqGt2p+xuimrY6sFWvesm/b1rEmOyjuP7Lqny/OsnLRGZ3dqnXx6HljLuQyla1VAjpGMzf5Rqov2touxsj0eTKNbBFaLcEszdCUCdozdVSdi6KOslyAXVOaJ1/pg2qWERcEOk7EOQSDVs3TL2jqo62P/7aM/AmZK0A8iBGqZdPPAN0YEOVt99SxHbJPTv5EliN1yx1QXFGwDQ/hB4b3H58Iuqa98v8G40F7xx2efnv662d9MQFqrpOtHAyydsGLKLtXMtacW6GiLZYUfRj42njaWGuKhgYSj2BU1VYhoS+FHFJR8oqeRp2zKGrL+iNucum
 Hh2idbNL
 aASI9onK8ZCyNGk20fcSIXWsEQptuDq5mccGI3Wgg9S1FixCIv9Mj24tSkxEFMHdVNLFZabPdHak9u6JTkTpbL0Bjnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To make sure folio->swap always belongs to folio->memcg, when doing the
charge, charge against folio->memcg. Defer the recording of swap cgroup
info, do a reparent, and record the nearest online ancestor on swap cache
removal only.

Then, a folio is in the swap cache, and the folio itself is owned by the
memcg. Hence, through the folio, the memcg also owns folio->swap. The
extra pinning of the swap cgroup info record is not needed and can be
released.

This should be fine for both cgroup v2 and v1. There should be no
userspace observable behavior.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h |   8 ++--
 include/linux/swap.h       |  24 +++++++++--
 mm/memcontrol-v1.c         |  77 ++++++++++++++++-----------------
 mm/memcontrol.c            | 104 ++++++++++++++++++++++++++++++++-------------
 mm/swap.h                  |   6 ++-
 mm/swap_cgroup.c           |   5 +--
 mm/swap_state.c            |  26 +++++++++---
 mm/swapfile.c              |  15 +++++--
 mm/vmscan.c                |   3 +-
 9 files changed, 173 insertions(+), 95 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 70b685a85bf4..0b37d4faf785 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1896,8 +1896,8 @@ static inline void mem_cgroup_exit_user_fault(void)
 	current->in_user_fault = 0;
 }
 
-void memcg1_swapout(struct folio *folio, swp_entry_t entry);
-void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages);
+void memcg1_swapout(struct folio *folio, struct mem_cgroup *swap_memcg);
+void memcg1_swapin(struct folio *folio);
 
 #else /* CONFIG_MEMCG_V1 */
 static inline
@@ -1926,11 +1926,11 @@ static inline void mem_cgroup_exit_user_fault(void)
 {
 }
 
-static inline void memcg1_swapout(struct folio *folio, swp_entry_t entry)
+static inline void memcg1_swapout(struct folio *folio, struct mem_cgroup *_memcg)
 {
 }
 
-static inline void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
+static inline void memcg1_swapin(struct folio *folio)
 {
 }
 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0effe3cc50f5..66cf657a1f35 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -580,12 +580,22 @@ static inline int mem_cgroup_try_charge_swap(struct folio *folio,
 	return __mem_cgroup_try_charge_swap(folio, entry);
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
+}
+
+struct mem_cgroup *__mem_cgroup_swap_free_folio(struct folio *folio,
+					       bool reclaim);
+static inline struct mem_cgroup *mem_cgroup_swap_free_folio(struct folio *folio,
+							    bool reclaim)
+{
+	if (mem_cgroup_disabled())
+		return NULL;
+	return __mem_cgroup_swap_free_folio(folio, reclaim);
 }
 
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
@@ -597,11 +607,17 @@ static inline int mem_cgroup_try_charge_swap(struct folio *folio,
 	return 0;
 }
 
-static inline void mem_cgroup_uncharge_swap(swp_entry_t entry,
+static inline void mem_cgroup_uncharge_swap(unsigned short id,
 					    unsigned int nr_pages)
 {
 }
 
+static inline struct mem_cgroup *mem_cgroup_swap_free_folio(struct folio *folio,
+							    bool reclaim)
+{
+	return NULL;
+}
+
 static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	return get_nr_swap_pages();
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index a7c78b0987df..038e630dc7e1 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -606,29 +606,21 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
 /**
  * memcg1_swapout - transfer a memsw charge to swap
  * @folio: folio whose memsw charge to transfer
- * @entry: swap entry to move the charge to
- *
- * Transfer the memsw charge of @folio to @entry.
+ * @swap_memcg: cgroup that will be charged, must be online ancestor
+ *              of folio's memcg.
  */
-void memcg1_swapout(struct folio *folio, swp_entry_t entry)
+void memcg1_swapout(struct folio *folio, struct mem_cgroup *swap_memcg)
 {
-	struct mem_cgroup *memcg, *swap_memcg;
+	struct mem_cgroup *memcg;
 	unsigned int nr_entries;
+	unsigned long flags;
 
-	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
-	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
-
-	if (mem_cgroup_disabled())
-		return;
-
-	if (!do_memsw_account())
-		return;
+	/* The folio must be getting reclaimed. */
+	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 
 	memcg = folio_memcg(folio);
 
 	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
-	if (!memcg)
-		return;
 
 	/*
 	 * In case the memcg owning these pages has been offlined and doesn't
@@ -636,14 +628,15 @@ void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 	 * ancestor for the swap instead and transfer the memory+swap charge.
 	 */
 	nr_entries = folio_nr_pages(folio);
-	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
-	swap_cgroup_record(folio, mem_cgroup_private_id(swap_memcg), entry);
-
 	folio_unqueue_deferred_split(folio);
-	folio->memcg_data = 0;
 
+	/*
+	 * Free the folio charge now so memsw won't be double uncharged:
+	 * memsw is now charged by the swap record.
+	 */
+	folio->memcg_data = 0;
 	if (!mem_cgroup_is_root(memcg))
 		page_counter_uncharge(&memcg->memory, nr_entries);
 
@@ -653,33 +646,34 @@ void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 		page_counter_uncharge(&memcg->memsw, nr_entries);
 	}
 
-	/*
-	 * Interrupts should be disabled here because the caller holds the
-	 * i_pages lock which is taken with interrupts-off. It is
-	 * important here to have the interrupts disabled because it is the
-	 * only synchronisation we have for updating the per-CPU variables.
-	 */
+	local_irq_save(flags);
 	preempt_disable_nested();
-	VM_WARN_ON_IRQS_ENABLED();
 	memcg1_charge_statistics(memcg, -folio_nr_pages(folio));
 	preempt_enable_nested();
+	local_irq_restore(flags);
 	memcg1_check_events(memcg, folio_nid(folio));
 
 	css_put(&memcg->css);
 }
 
 /*
- * memcg1_swapin - uncharge swap slot
- * @entry: the first swap entry for which the pages are charged
- * @nr_pages: number of pages which will be uncharged
+ * memcg1_swapin - uncharge memsw for the swap slot on swapin
+ * @folio: the folio being swapped in, already charged to memory
  *
  * Call this function after successfully adding the charged page to swapcache.
- *
- * Note: This function assumes the page for which swap slot is being uncharged
- * is order 0 page.
+ * The swap cgroup tracking has already been released by
+ * mem_cgroup_swapin_charge_folio(), so we only need to drop the duplicate
+ * memsw charge that was placed on the swap entry during swapout.
  */
-void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
+void memcg1_swapin(struct folio *folio)
 {
+	struct mem_cgroup *memcg;
+	unsigned int nr_pages;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_memcg_charged(folio), folio);
+
 	/*
 	 * Cgroup1's unified memory+swap counter has been charged with the
 	 * new swapcache page, finish the transfer by uncharging the swap
@@ -692,14 +686,15 @@ void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
 	 * correspond 1:1 to page and swap slot lifetimes: we charge the
 	 * page to memory here, and uncharge swap when the slot is freed.
 	 */
-	if (do_memsw_account()) {
-		/*
-		 * The swap entry might not get freed for a long time,
-		 * let's not wait for it.  The page already received a
-		 * memory+swap charge, drop the swap entry duplicate.
-		 */
-		mem_cgroup_uncharge_swap(entry, nr_pages);
-	}
+	if (!do_memsw_account())
+		return;
+
+	memcg = folio_memcg(folio);
+	nr_pages = folio_nr_pages(folio);
+
+	if (!mem_cgroup_is_root(memcg))
+		page_counter_uncharge(&memcg->memsw, nr_pages);
+	mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
 }
 
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b2898719e935..d9ff44b77409 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4804,8 +4804,8 @@ int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry)
 {
 	struct mem_cgroup *memcg, *swap_memcg;
-	unsigned short id, parent_id;
 	unsigned int nr_pages;
+	unsigned short id;
 	int ret;
 
 	if (mem_cgroup_disabled())
@@ -4831,37 +4831,31 @@ int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 	if (ret)
 		goto out;
 
+	/*
+	 * On successful charge, the folio itself now belongs to the memcg,
+	 * so is folio->swap. So we can release the swap cgroup table's
+	 * pinning of the private id.
+	 */
+	swap_cgroup_clear(folio->swap, nr_pages);
+	mem_cgroup_private_id_put(swap_memcg, nr_pages);
+
 	/*
 	 * If the swap entry's memcg is dead, reparent the swap charge
 	 * from swap_memcg to memcg.
-	 *
-	 * If memcg is also being offlined, the charge will be moved to
-	 * its parent again.
 	 */
 	if (swap_memcg && memcg != swap_memcg) {
-		struct mem_cgroup *parent_memcg;
-
-		parent_memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
-		parent_id = mem_cgroup_private_id(parent_memcg);
-
-		WARN_ON(id != swap_cgroup_clear(entry, nr_pages));
-		swap_cgroup_record(folio, parent_id, entry);
-
 		if (do_memsw_account()) {
-			if (!mem_cgroup_is_root(parent_memcg))
-				page_counter_charge(&parent_memcg->memsw, nr_pages);
+			if (!mem_cgroup_is_root(memcg))
+				page_counter_charge(&memcg->memsw, nr_pages);
 			page_counter_uncharge(&swap_memcg->memsw, nr_pages);
 		} else {
-			if (!mem_cgroup_is_root(parent_memcg))
-				page_counter_charge(&parent_memcg->swap, nr_pages);
+			if (!mem_cgroup_is_root(memcg))
+				page_counter_charge(&memcg->swap, nr_pages);
 			page_counter_uncharge(&swap_memcg->swap, nr_pages);
 		}
 
-		mod_memcg_state(parent_memcg, MEMCG_SWAP, nr_pages);
+		mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 		mod_memcg_state(swap_memcg, MEMCG_SWAP, -nr_pages);
-
-		/* Release the dead cgroup after reparent */
-		mem_cgroup_private_id_put(swap_memcg, nr_pages);
 	}
 out:
 	css_put(&memcg->css);
@@ -5260,33 +5254,32 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 		return 0;
 	}
 
-	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
-
+	/*
+	 * Charge the swap counter against the folio's memcg directly.
+	 * The private id pinning and swap cgroup recording are deferred
+	 * to __mem_cgroup_swap_free_folio() when the folio leaves the
+	 * swap cache.  No _id_get_online here means no _id_put on error.
+	 */
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_private_id_put(memcg, nr_pages);
 		return -ENOMEM;
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
-	swap_cgroup_record(folio, mem_cgroup_private_id(memcg), entry);
-
 	return 0;
 }
 
 /**
  * __mem_cgroup_uncharge_swap - uncharge swap space
- * @entry: swap entry to uncharge
+ * @id: private id of the mem_cgroup to uncharge
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
@@ -5302,6 +5295,59 @@ void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 	rcu_read_unlock();
 }
 
+/**
+ * __mem_cgroup_swap_free_folio - Folio is being freed from swap cache.
+ * @folio: folio being freed.
+ * @reclaim: true if the folio is being reclaimed.
+ *
+ * For cgroup V2, swap entries are charged to folio's memcg by the time
+ * swap allocator adds it into the swap cache by mem_cgroup_try_charge_swap.
+ * The ownership of folio->swap to folio->memcg is constrained by the folio
+ * in swap cache. If the folio is being removed from swap cache, the
+ * constraint will be gone so need to grab the memcg's private id for long
+ * term tracking.
+ *
+ * For cgroup V1, the memory-to-swap charge transfer is also performed on
+ * the folio reclaim path.
+ *
+ * It's unlikely but possible that the folio's memcg is dead, in that case
+ * we reparent and recharge the parent. Recorded cgroup is changed to
+ * parent too.
+ *
+ * Return: Pointer to the mem cgroup being pinned by the charge.
+ */
+struct mem_cgroup *__mem_cgroup_swap_free_folio(struct folio *folio,
+					       bool reclaim)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+	struct mem_cgroup *memcg, *swap_memcg;
+	swp_entry_t entry = folio->swap;
+	unsigned short id;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_memcg_charged(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
+
+	/*
+	 * Pin the nearest online ancestor's private id for long term
+	 * swap cgroup tracking.  If memcg is still alive, swap_memcg
+	 * will be the same as memcg. Else, it's reparented.
+	 */
+	memcg = folio_memcg(folio);
+	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
+	id = mem_cgroup_private_id(swap_memcg);
+	swap_cgroup_record(folio, id, entry);
+
+	if (reclaim && do_memsw_account()) {
+		memcg1_swapout(folio, swap_memcg);
+	} else if (memcg != swap_memcg) {
+		if (!mem_cgroup_is_root(swap_memcg))
+			page_counter_charge(&swap_memcg->swap, nr_pages);
+		page_counter_uncharge(&memcg->swap, nr_pages);
+	}
+
+	return swap_memcg;
+}
+
 long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	long nr_swap_pages = get_nr_swap_pages();
diff --git a/mm/swap.h b/mm/swap.h
index 80c2f1bf7a57..da41e9cea46d 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -287,7 +287,8 @@ struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry);
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
-			    struct folio *folio, swp_entry_t entry, void *shadow);
+			    struct folio *folio, void *shadow,
+			    bool charged, bool reclaim);
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 				struct folio *old, struct folio *new);
 
@@ -459,7 +460,8 @@ static inline void swap_cache_del_folio(struct folio *folio)
 }
 
 static inline void __swap_cache_del_folio(struct swap_cluster_info *ci,
-		struct folio *folio, swp_entry_t entry, void *shadow)
+		struct folio *folio, void *shadow,
+		bool charged, bool reclaim)
 {
 }
 
diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
index de779fed8c21..b5a7f21c3afe 100644
--- a/mm/swap_cgroup.c
+++ b/mm/swap_cgroup.c
@@ -54,8 +54,7 @@ static unsigned short __swap_cgroup_id_xchg(struct swap_cgroup *map,
 /**
  * swap_cgroup_record - record mem_cgroup for a set of swap entries.
  * These entries must belong to one single folio, and that folio
- * must be being charged for swap space (swap out), and these
- * entries must not have been charged
+ * must be being charged for swap space (swap out).
  *
  * @folio: the folio that the swap entry belongs to
  * @id: mem_cgroup ID to be recorded
@@ -75,7 +74,7 @@ void swap_cgroup_record(struct folio *folio, unsigned short id,
 
 	do {
 		old = __swap_cgroup_id_xchg(map, offset, id);
-		VM_BUG_ON(old);
+		VM_WARN_ON_ONCE(old);
 	} while (++offset != end);
 }
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 0a2a4e084cf2..40f037576c5f 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -251,7 +251,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	if (mem_cgroup_swapin_charge_folio(folio, vmf ? vmf->vma->vm_mm : NULL,
 					   gfp, entry)) {
 		spin_lock(&ci->lock);
-		__swap_cache_del_folio(ci, folio, shadow);
+		__swap_cache_del_folio(ci, folio, shadow, false, false);
 		spin_unlock(&ci->lock);
 		folio_unlock(folio);
 		folio_put(folio);
@@ -260,7 +260,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	}
 
 	/* For memsw accouting, swap is uncharged when folio is added to swap cache */
-	memcg1_swapin(entry, 1 << order);
+	memcg1_swapin(folio);
 	if (shadow)
 		workingset_refault(folio, shadow);
 
@@ -319,21 +319,24 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp_mask,
  * __swap_cache_del_folio - Removes a folio from the swap cache.
  * @ci: The locked swap cluster.
  * @folio: The folio.
- * @entry: The first swap entry that the folio corresponds to.
  * @shadow: shadow value to be filled in the swap cache.
+ * @charged: If folio->swap is charged to folio->memcg.
+ * @reclaim: If the folio is being reclaimed. When true on cgroup v1,
+ *           the memory charge is transferred from memory to swap.
  *
  * Removes a folio from the swap cache and fills a shadow in place.
  * This won't put the folio's refcount. The caller has to do that.
  *
- * Context: Caller must ensure the folio is locked and in the swap cache
- * using the index of @entry, and lock the cluster that holds the entries.
+ * Context: Caller must ensure the folio is locked and in the swap cache,
+ * and lock the cluster that holds the entries.
  */
 void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
-			    swp_entry_t entry, void *shadow)
+			    void *shadow, bool charged, bool reclaim)
 {
 	int count;
 	unsigned long old_tb;
 	struct swap_info_struct *si;
+	swp_entry_t entry = folio->swap;
 	unsigned int ci_start, ci_off, ci_end;
 	bool folio_swapped = false, need_free = false;
 	unsigned long nr_pages = folio_nr_pages(folio);
@@ -343,6 +346,15 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
 
+	/*
+	 * If the folio's swap entry is charged to its memcg, record the
+	 * swap cgroup for long-term tracking before the folio leaves the
+	 * swap cache.  Not charged when the folio never completed memcg
+	 * charging (e.g. swapin charge failure, or swap alloc charge failure).
+	 */
+	if (charged)
+		mem_cgroup_swap_free_folio(folio, reclaim);
+
 	si = __swap_entry_to_info(entry);
 	ci_start = swp_cluster_offset(entry);
 	ci_end = ci_start + nr_pages;
@@ -392,7 +404,7 @@ void swap_cache_del_folio(struct folio *folio)
 	swp_entry_t entry = folio->swap;
 
 	ci = swap_cluster_lock(__swap_entry_to_info(entry), swp_offset(entry));
-	__swap_cache_del_folio(ci, folio, entry, NULL);
+	__swap_cache_del_folio(ci, folio, NULL, true, false);
 	swap_cluster_unlock(ci);
 
 	folio_ref_sub(folio, folio_nr_pages(folio));
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7e7614a5181a..c0169bce46c9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1703,6 +1703,7 @@ int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
+	struct swap_cluster_info *ci;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
@@ -1737,8 +1738,12 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
-		swap_cache_del_folio(folio);
+	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap))) {
+		ci = swap_cluster_lock(__swap_entry_to_info(folio->swap),
+				       swp_offset(folio->swap));
+		__swap_cache_del_folio(ci, folio, NULL, false, false);
+		swap_cluster_unlock(ci);
+	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
 		return -ENOMEM;
@@ -1879,6 +1884,7 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 				 unsigned int ci_start, unsigned int nr_pages)
 {
 	unsigned long old_tb;
+	unsigned short id;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
 	unsigned long offset = cluster_offset(si, ci) + ci_start;
 
@@ -1892,7 +1898,10 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		__swap_table_set(ci, ci_off, null_to_swp_tb());
 	} while (++ci_off < ci_end);
 
-	mem_cgroup_uncharge_swap(swp_entry(si->type, offset), nr_pages);
+	id = swap_cgroup_clear(swp_entry(si->type, offset), nr_pages);
+	if (id)
+		mem_cgroup_uncharge_swap(id, nr_pages);
+
 	swap_range_free(si, offset, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 44e4fcd6463c..5112f81cf875 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -759,8 +759,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		memcg1_swapout(folio, swap);
-		__swap_cache_del_folio(ci, folio, swap, shadow);
+		__swap_cache_del_folio(ci, folio, shadow, true, true);
 		swap_cluster_unlock_irq(ci);
 	} else {
 		void (*free_folio)(struct folio *);

-- 
2.53.0



