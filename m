Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40714CD4F47
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 15:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517556B008C; Sun, 17 May 2026 11:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6AC6B0096; Sun, 17 May 2026 11:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207AC6B008C; Sun, 17 May 2026 11:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C7F526B0096
	for <linux-mm@kvack.org>; Sun, 17 May 2026 11:39:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9427216108C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:39:52 +0000 (UTC)
X-FDA: 84777322224.07.25F924E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7DB611C0009
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:39:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oukHjeUp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779032390;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OqgeZPXS/DZU+zno7b32MgZMG6XElOlzitxBcFTd30g=;
	b=nhU1B1CO+hFB8WEoj2bcvYdo8MZyqAshEI3QloxCe/Sy0h9aHLq7IsrWBEVLSAQrG209mQ
	tEwZgSJ4Q0C1+I5qK3jEhxuaqEHxKwu5PCLhkZ/xsMqWUvwGRXRKmdsX3jB0It9NGjDGnf
	EGxQRLT6iryEnQI3luKV3DOPVVSuVpg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779032390; a=rsa-sha256;
	cv=none;
	b=g5f7IaGQlCKXlXVhx6PKO6ypxT47ds+JByGYHz19cyXzvdJvQbOPXGLSPGteFFiJ5ht3BM
	R3jSqscouCiEawgPEvYVJYgpWQbfMhubTVtHIn5+HXd/HBPffFzrBPJPyGcm40MNYTMNd3
	l/fmAo0BmU2yzWw4PloM52vJ5PzRViA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oukHjeUp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E9A0445DE;
	Sun, 17 May 2026 15:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE0E4C2BD01;
	Sun, 17 May 2026 15:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779032389;
	bh=mOw4KFzfxUHWUyGfuj/p8RfUV/fSZEnDA0Q9EKIRo5o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=oukHjeUpKe3pSDHFeLQDMlMpP7kPZw6AJvO3zD5P3pDNZKr159UjfFM/M7d65R0b9
	 FUDJT7s3015qf93qY2UBr8eijJO0uy1932eto4ejk0DiyOR6HcHBxnxXAMsDyq7h4a
	 mSHi6PHqmgOigvwYoMtke3KNP7YUtmJl4ar4SR8QkP76x9eTq7kAlDjdqSQQDwS4dv
	 CISzETlDznAelEA0p2XjOrQuKP9469Kvq1C6cjT37WzWgoubj2v70R4cy3+rqTw8cw
	 +cC+WcgR3Yh0FMLlIKv5Gl4ds829j0n6NTzo8YYMuFnLX4QZ3mqbYrtQ+1bHPw/tst
	 E9R74M5PSmNIA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2231CD4F4D;
	Sun, 17 May 2026 15:39:48 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 17 May 2026 23:39:44 +0800
Subject: [PATCH v5 05/12] mm, swap: unify large folio allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260517-swap-table-p4-v5-5-88ae43e064c7@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779032386; l=19387;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Ly9lgjUrp+SrzpzuAxH3h8JdaIdG/IvtELS2basb0ss=;
 b=VGeN7fJjoBLwaEjbI3AggzHCcSHLv18i4S0u4Y36cmeBgdxSQ6zJLbjfWg0/iZOyn/PnHLKN7
 AaP7cYhwoOzCckjeD9REntUbvFwX/NId5SRgK+3t6TrK+PK+HMino8s
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DB611C0009
X-Rspamd-Server: rspam04
X-Stat-Signature: pmrxjbr8ocinq6xguiye3f8m3tpkp1wx
X-HE-Tag: 1779032390-710787
X-HE-Meta: U2FsdGVkX1+aIATA5Oc1vJN7n1GTi2JKB+9g0b0eHU1A6cMvg1wn6g1LrCrtZG+yfMqAUVpc1AdqsvGXkRrLKDPjRolZGrjD79jtNNOw9WPxuyftpk1n/k1BOEMdgiQSvfHlOIQb/9vtVLmiU5La0tn9HlIngp1vR4P0cZSF/WbIGVKx2FclT2O/n9prDyyf18+Pz8i1S31osMjReC0TAYX1C7BC2oAhoekdujWUZwR+Srs7ldq5sy0SL2F+m/Gr8hNTPQSsHdptlNvrB4Fw9RYIoRO3xGukAFcozXOLV7RL0ntWIAPyvGXgj3C/zCNhZT46MU/ldQEOATo/7meBhHa3BVB3O3GvnvVBvUnaMlFZ3yN9N6UTYCo6CsQfHQ/xbXIulgw81tu/RCoqJyzNdRJYGyZk81Dtjn3sHbY0BAYxL07cj+y8iYAgDm9a8vM5rhNRiDeGOY2xqucFSKzC25Lsebs6CuET97tcXnofCAPP5SsT45rQpCTIrdwE/Wi1azKtLkJvsSKt6mBuDbed7EfT2QYzrNjItVRP3EDZMGC5KOCBc0RwSVJzBclFzbmZmBGkVyUEwKrguWB0opkzzr9e1bdhL44x38FI1x/za+SzAA35DFqjm/fc8u500IzDd88KefxvVxyI6oBvASW4IcdnkeOu80mSnFpUW6+yajpwfCyl6NEXlOqpFNaMysFBNuaWC7r4tTHtI9Yu6HX6scn0CEhdbCL3BVLGKEIa+AS93Su9NXmz0lBFCOXLr2DLqAJS5kSPqkc9tNfIUod9fc+QEeevr89cNcY9oIDrYSDE3Ef39LaNBasujAHB2RliBpX5G9mxxcpVyawKdsnCh1gVu05Prc+00UURQfKDSFovlWdWNIHLYV5dV1s/yzTAl97U83HvMg6ML8BU4U4kz4vnPWQCTOBmaKcbECTa0nBZU9SdCUmetpBlK0z6Jb3M3CEQCSa2uTjPumG+Rb6
 WRDIe6oc
 U5RvV9f1YJDoPlhfpUOYes0XQagHxoyvaFJfEZC5lBVpye3/aYT5BKQDWPDaZCTtUS7VtwIQJHdVhV2Xo1KMn30rHUiZSmTe1N0r03+hMafMEnClpDjqjLLvHgHr3Iau4SB5hcJZJDTlmx4686WHt17PDUO5oxMBlKxwnQVYDbnwjajzTWOTF/cT+TaV0Thq330k42NoNMC10KqwdffJXSdkWikYuVxARs3O+7MtxGoH8Z5jpJvUSeKa6CiEHB4U+c205pejTWL09z1h8bf2kmiFX73OUduqd8whBRv7znyx7znUtHr0dX/WaKr7odoaxFBtZnB/UwrCtFkFfUSkEOFaTd2kDzkt6XCZOXGwQe/zzxhu/1kFJzAV+tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now that direct large order allocation is supported in the swap cache,
both anon and shmem can use it instead of implementing their own methods.
This unifies the fallback and swap cache check, which also reduces the
TOCTOU race window of swap cache state: previously, high order swapin
required checking swap cache states first, then allocating and falling
back separately. Now all these steps happen in the same compact loop.

Order fallback and statistics are also unified, callers just need to
check and pass the acceptable order bitmask.

There is basically no behavior change. This only makes things more
unified and prepares for later commits. Cgroup and zero map checks can
also be moved into the compact loop, further reducing race windows and
redundancy

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c     |  80 +++++++------------------------
 mm/shmem.c      | 102 +++++++++++++---------------------------
 mm/swap.h       |  30 ++----------
 mm/swap_state.c | 143 ++++++++++----------------------------------------------
 mm/swapfile.c   |   3 +-
 5 files changed, 79 insertions(+), 279 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0c9d9c2cbf0e..da891bcce59c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4609,26 +4609,6 @@ static vm_fault_t handle_pte_marker(struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
 
-static struct folio *__alloc_swap_folio(struct vm_fault *vmf)
-{
-	struct vm_area_struct *vma = vmf->vma;
-	struct folio *folio;
-	softleaf_t entry;
-
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vmf->address);
-	if (!folio)
-		return NULL;
-
-	entry = softleaf_from_pte(vmf->orig_pte);
-	if (mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
-					   GFP_KERNEL, entry)) {
-		folio_put(folio);
-		return NULL;
-	}
-
-	return folio;
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
  * Check if the PTEs within a range are contiguous swap entries
@@ -4658,8 +4638,6 @@ static bool can_swapin_thp(struct vm_fault *vmf, pte_t *ptep, int nr_pages)
 	 */
 	if (unlikely(swap_zeromap_batch(entry, nr_pages, NULL) != nr_pages))
 		return false;
-	if (unlikely(non_swapcache_batch(entry, nr_pages) != nr_pages))
-		return false;
 
 	return true;
 }
@@ -4687,16 +4665,14 @@ static inline unsigned long thp_swap_suitable_orders(pgoff_t swp_offset,
 	return orders;
 }
 
-static struct folio *alloc_swap_folio(struct vm_fault *vmf)
+static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long orders;
-	struct folio *folio;
 	unsigned long addr;
 	softleaf_t entry;
 	spinlock_t *ptl;
 	pte_t *pte;
-	gfp_t gfp;
 	int order;
 
 	/*
@@ -4704,7 +4680,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	 * maintain the uffd semantics.
 	 */
 	if (unlikely(userfaultfd_armed(vma)))
-		goto fallback;
+		return 0;
 
 	/*
 	 * A large swapped out folio could be partially or fully in zswap. We
@@ -4712,7 +4688,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	 * folio.
 	 */
 	if (!zswap_never_enabled())
-		goto fallback;
+		return 0;
 
 	entry = softleaf_from_pte(vmf->orig_pte);
 	/*
@@ -4726,12 +4702,12 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 					  vmf->address, orders);
 
 	if (!orders)
-		goto fallback;
+		return 0;
 
 	pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
 				  vmf->address & PMD_MASK, &ptl);
 	if (unlikely(!pte))
-		goto fallback;
+		return 0;
 
 	/*
 	 * For do_swap_page, find the highest order where the aligned range is
@@ -4747,29 +4723,12 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 
 	pte_unmap_unlock(pte, ptl);
 
-	/* Try allocating the highest of the remaining orders. */
-	gfp = vma_thp_gfp_mask(vma);
-	while (orders) {
-		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
-		if (folio) {
-			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
-							    gfp, entry))
-				return folio;
-			count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
-			folio_put(folio);
-		}
-		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
-		order = next_order(&orders, order);
-	}
-
-fallback:
-	return __alloc_swap_folio(vmf);
+	return orders;
 }
 #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
-static struct folio *alloc_swap_folio(struct vm_fault *vmf)
+static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
 {
-	return __alloc_swap_folio(vmf);
+	return 0;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -4875,23 +4834,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (folio)
 		swap_update_readahead(folio, vma, vmf->address);
 	if (!folio) {
-		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
-			folio = alloc_swap_folio(vmf);
-			if (folio) {
-				/*
-				 * folio is charged, so swapin can only fail due
-				 * to raced swapin and return NULL.
-				 */
-				swapcache = swapin_folio(entry, folio);
-				if (swapcache != folio)
-					folio_put(folio);
-				folio = swapcache;
-			}
-		} else {
+		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
+		if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+			folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
+					    thp_swapin_suitable_orders(vmf) | BIT(0),
+					    vmf, NULL, 0);
+		else
 			folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, vmf);
-		}
 
-		if (!folio) {
+		if (IS_ERR_OR_NULL(folio)) {
 			/*
 			 * Back out if somebody else faulted in this pte
 			 * while we released the pte lock.
@@ -4901,6 +4852,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			if (likely(vmf->pte &&
 				   pte_same(ptep_get(vmf->pte), vmf->orig_pte)))
 				ret = VM_FAULT_OOM;
+			folio = NULL;
 			goto unlock;
 		}
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 6edb23b41bac..77a3e28e5160 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -159,7 +159,7 @@ static unsigned long shmem_default_max_inodes(void)
 
 static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			struct folio **foliop, enum sgp_type sgp, gfp_t gfp,
-			struct vm_area_struct *vma, vm_fault_t *fault_type);
+			struct vm_fault *vmf, vm_fault_t *fault_type);
 
 static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
 {
@@ -2017,68 +2017,32 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
 }
 
 static struct folio *shmem_swap_alloc_folio(struct inode *inode,
-		struct vm_area_struct *vma, pgoff_t index,
+		struct vm_fault *vmf, pgoff_t index,
 		swp_entry_t entry, int order, gfp_t gfp)
 {
+	pgoff_t ilx;
+	struct folio *folio;
+	struct mempolicy *mpol;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct folio *new, *swapcache;
-	int nr_pages = 1 << order;
-	gfp_t alloc_gfp = gfp;
-
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-		if (WARN_ON_ONCE(order))
-			return ERR_PTR(-EINVAL);
-	} else if (order) {
-		/*
-		 * If uffd is active for the vma, we need per-page fault
-		 * fidelity to maintain the uffd semantics, then fallback
-		 * to swapin order-0 folio, as well as for zswap case.
-		 * Any existing sub folio in the swap cache also blocks
-		 * mTHP swapin.
-		 */
-		if ((vma && unlikely(userfaultfd_armed(vma))) ||
-		     !zswap_never_enabled() ||
-		     non_swapcache_batch(entry, nr_pages) != nr_pages)
-			goto fallback;
 
-		alloc_gfp = thp_shmem_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
-	}
-retry:
-	new = shmem_alloc_folio(alloc_gfp, order, info, index);
-	if (!new) {
-		new = ERR_PTR(-ENOMEM);
-		goto fallback;
-	}
+	if ((vmf && unlikely(userfaultfd_armed(vmf->vma))) ||
+	     !zswap_never_enabled())
+		order = 0;
 
-	if (mem_cgroup_swapin_charge_folio(new, vma ? vma->vm_mm : NULL,
-					   alloc_gfp, entry)) {
-		folio_put(new);
-		new = ERR_PTR(-ENOMEM);
-		goto fallback;
-	}
+again:
+	mpol = shmem_get_pgoff_policy(info, index, order, &ilx);
+	folio = swapin_sync(entry, gfp, BIT(order), vmf, mpol, ilx);
+	mpol_cond_put(mpol);
 
-	swapcache = swapin_folio(entry, new);
-	if (swapcache != new) {
-		folio_put(new);
-		if (!swapcache) {
-			/*
-			 * The new folio is charged already, swapin can
-			 * only fail due to another raced swapin.
-			 */
-			new = ERR_PTR(-EEXIST);
-			goto fallback;
-		}
+	if (!IS_ERR(folio))
+		return folio;
+
+	if (order) {
+		order = 0;
+		goto again;
 	}
-	return swapcache;
-fallback:
-	/* Order 0 swapin failed, nothing to fallback to, abort */
-	if (!order)
-		return new;
-	entry.val += index - round_down(index, nr_pages);
-	alloc_gfp = gfp;
-	nr_pages = 1;
-	order = 0;
-	goto retry;
+
+	return folio;
 }
 
 /*
@@ -2265,11 +2229,12 @@ static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
  */
 static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			     struct folio **foliop, enum sgp_type sgp,
-			     gfp_t gfp, struct vm_area_struct *vma,
+			     gfp_t gfp, struct vm_fault *vmf,
 			     vm_fault_t *fault_type)
 {
 	struct address_space *mapping = inode->i_mapping;
-	struct mm_struct *fault_mm = vma ? vma->vm_mm : NULL;
+	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
+	struct mm_struct *fault_mm = vmf ? vmf->vma->vm_mm : NULL;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	swp_entry_t swap;
 	softleaf_t index_entry;
@@ -2310,20 +2275,19 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (!folio) {
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			/* Direct swapin skipping swap cache & readahead */
-			folio = shmem_swap_alloc_folio(inode, vma, index,
-						       index_entry, order, gfp);
-			if (IS_ERR(folio)) {
-				error = PTR_ERR(folio);
-				folio = NULL;
-				goto failed;
-			}
+			folio = shmem_swap_alloc_folio(inode, vmf, index,
+						       swap, order, gfp);
 		} else {
 			/* Cached swapin only supports order 0 folio */
 			folio = shmem_swapin_cluster(swap, gfp, info, index);
-			if (!folio) {
+		}
+		if (IS_ERR_OR_NULL(folio)) {
+			if (IS_ERR(folio))
+				error = PTR_ERR(folio);
+			else
 				error = -ENOMEM;
-				goto failed;
-			}
+			folio = NULL;
+			goto failed;
 		}
 		if (fault_type) {
 			*fault_type |= VM_FAULT_MAJOR;
@@ -2471,7 +2435,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 
 	if (xa_is_value(folio)) {
 		error = shmem_swapin_folio(inode, index, &folio,
-					   sgp, gfp, vma, fault_type);
+					   sgp, gfp, vmf, fault_type);
 		if (error == -EEXIST)
 			goto repeat;
 
diff --git a/mm/swap.h b/mm/swap.h
index 6774af10a943..8e57e9431624 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -300,7 +300,8 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
 		struct mempolicy *mpol, pgoff_t ilx);
 struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
 		struct vm_fault *vmf);
-struct folio *swapin_folio(swp_entry_t entry, struct folio *folio);
+struct folio *swapin_sync(swp_entry_t entry, gfp_t flag, unsigned long orders,
+			   struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx);
 void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 			   unsigned long addr);
 
@@ -334,24 +335,6 @@ static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
 		return find_next_bit(sis->zeromap, end, start) - start;
 }
 
-static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
-{
-	int i;
-
-	/*
-	 * While allocating a large folio and doing mTHP swapin, we need to
-	 * ensure all entries are not cached, otherwise, the mTHP folio will
-	 * be in conflict with the folio in swap cache.
-	 */
-	for (i = 0; i < max_nr; i++) {
-		if (swap_cache_has_folio(entry))
-			return i;
-		entry.val++;
-	}
-
-	return i;
-}
-
 #else /* CONFIG_SWAP */
 struct swap_iocb;
 static inline struct swap_cluster_info *swap_cluster_lock(
@@ -433,7 +416,9 @@ static inline struct folio *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
 	return NULL;
 }
 
-static inline struct folio *swapin_folio(swp_entry_t entry, struct folio *folio)
+static inline struct folio *swapin_sync(
+	swp_entry_t entry, gfp_t flag, unsigned long orders,
+	struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx)
 {
 	return NULL;
 }
@@ -493,10 +478,5 @@ static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
 {
 	return 0;
 }
-
-static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
-{
-	return 0;
-}
 #endif /* CONFIG_SWAP */
 #endif /* _MM_SWAP_H */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 0adb0565bbb1..98c8691826fb 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -238,43 +238,6 @@ void __swap_cache_add_folio(struct swap_cluster_info *ci,
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 }
 
-/**
- * swap_cache_add_folio - Add a folio into the swap cache.
- * @folio: The folio to be added.
- * @entry: The swap entry corresponding to the folio.
- * @shadowp: If a shadow is found, return the shadow.
- *
- * Add a folio into the swap cache. Will return error if any slot is no
- * longer a valid swapped out slot or already occupied by another folio.
- *
- * Context: Caller must ensure @entry is valid and protect the swap device
- * with reference count or locks.
- */
-static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-				void **shadowp)
-{
-	int err;
-	void *shadow = NULL;
-	struct swap_info_struct *si;
-	struct swap_cluster_info *ci;
-	unsigned long nr_pages = folio_nr_pages(folio);
-
-	si = __swap_entry_to_info(entry);
-	ci = swap_cluster_lock(si, swp_offset(entry));
-	err = __swap_cache_add_check(ci, entry, nr_pages, &shadow);
-	if (err) {
-		swap_cluster_unlock(ci);
-		return err;
-	}
-
-	__swap_cache_add_folio(ci, folio, entry);
-	swap_cluster_unlock(ci);
-	if (shadowp)
-		*shadowp = shadow;
-
-	return 0;
-}
-
 static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
 				      struct folio *folio,
 				      swp_entry_t entry, void *shadow)
@@ -650,51 +613,6 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 	}
 }
 
-/**
- * __swap_cache_prepare_and_add - Prepare the folio and add it to swap cache.
- * @entry: swap entry to be bound to the folio.
- * @folio: folio to be added.
- * @gfp: memory allocation flags for charge, can be 0 if @charged if true.
- * @charged: if the folio is already charged.
- *
- * Update the swap_map and add folio as swap cache, typically before swapin.
- * All swap slots covered by the folio must have a non-zero swap count.
- *
- * Context: Caller must protect the swap device with reference count or locks.
- * Return: 0 if success, error code if failed.
- */
-static int __swap_cache_prepare_and_add(swp_entry_t entry,
-					struct folio *folio,
-					gfp_t gfp, bool charged)
-{
-	void *shadow;
-	int ret;
-
-	__folio_set_locked(folio);
-	__folio_set_swapbacked(folio);
-
-	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry)) {
-		ret = -ENOMEM;
-		goto failed;
-	}
-
-	ret = swap_cache_add_folio(folio, entry, &shadow);
-	if (ret)
-		goto failed;
-
-	memcg1_swapin(entry, folio_nr_pages(folio));
-	if (shadow)
-		workingset_refault(folio, shadow);
-
-	/* Caller will initiate read into locked folio */
-	folio_add_lru(folio);
-	return 0;
-
-failed:
-	folio_unlock(folio);
-	return ret;
-}
-
 static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 					   struct mempolicy *mpol, pgoff_t ilx,
 					   struct swap_iocb **plug, bool readahead)
@@ -705,7 +623,6 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-
 		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
@@ -722,49 +639,37 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 }
 
 /**
- * swapin_folio - swap-in one or multiple entries skipping readahead.
- * @entry: starting swap entry to swap in
- * @folio: a new allocated and charged folio
+ * swapin_sync - swap-in one or multiple entries skipping readahead.
+ * @entry: swap entry indicating the target slot
+ * @gfp: memory allocation flags
+ * @orders: allocation orders
+ * @vmf: fault information
+ * @mpol: NUMA memory allocation policy to be applied
+ * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
  *
- * Reads @entry into @folio, @folio will be added to the swap cache.
- * If @folio is a large folio, the @entry will be rounded down to align
- * with the folio size.
+ * This allocates a folio suitable for given @orders, or returns the
+ * existing folio in the swap cache for @entry. This initiates the IO, too,
+ * if needed. @entry is rounded down if @orders allow large allocation.
  *
- * Return: returns pointer to @folio on success. If folio is a large folio
- * and this raced with another swapin, NULL will be returned to allow fallback
- * to order 0. Else, if another folio was already added to the swap cache,
- * return that swap cache folio instead.
+ * Context: Caller must ensure @entry is valid and pin the swap device with refcount.
+ * Return: Returns the folio on success, error code if failed.
  */
-struct folio *swapin_folio(swp_entry_t entry, struct folio *folio)
+struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
+			   struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx)
 {
-	int ret;
-	struct folio *swapcache;
-	pgoff_t offset = swp_offset(entry);
-	unsigned long nr_pages = folio_nr_pages(folio);
-
-	entry = swp_entry(swp_type(entry), round_down(offset, nr_pages));
-	for (;;) {
-		ret = __swap_cache_prepare_and_add(entry, folio, 0, true);
-		if (!ret) {
-			swap_read_folio(folio, NULL);
-			break;
-		}
+	struct folio *folio;
 
-		/*
-		 * Large order allocation needs special handling on
-		 * race: if a smaller folio exists in cache, swapin needs
-		 * to fall back to order 0, and doing a swap cache lookup
-		 * might return a folio that is irrelevant to the faulting
-		 * entry because @entry is aligned down. Just return NULL.
-		 */
-		if (ret != -EEXIST || nr_pages > 1)
-			return NULL;
+	do {
+		folio = swap_cache_get_folio(entry);
+		if (folio)
+			return folio;
+		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
+	} while (PTR_ERR(folio) == -EEXIST);
 
-		swapcache = swap_cache_get_folio(entry);
-		if (swapcache)
-			return swapcache;
-	}
+	if (IS_ERR(folio))
+		return folio;
 
+	swap_read_folio(folio, NULL);
 	return folio;
 }
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 08309c1dafa3..4e5a54769e81 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1827,8 +1827,7 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
  *   do_swap_page()
  *     ...				swapoff+swapon
  *     swap_cache_alloc_folio()
- *       swap_cache_add_folio()
- *         // check swap_map
+ *       // check swap_map
  *     // verify PTE not changed
  *
  * In __swap_duplicate(), the swap_map need to be checked before

-- 
2.54.0



