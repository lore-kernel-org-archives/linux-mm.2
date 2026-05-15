Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E3A4CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3406B00A9; Fri, 15 May 2026 05:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC4B6B00A6; Fri, 15 May 2026 05:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E85B6B00A8; Fri, 15 May 2026 05:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6496B00A5
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:54:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCD72160B3D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:27 +0000 (UTC)
X-FDA: 84769194174.08.4A710C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D6E76160006
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uHscEP2W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838866;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M8aDXGabIYLTzmKjMBo/myloR7hHDoqPZaQhVAZl000=;
	b=AfHCT40mGfG5YAF0zuL9uiojZuXvqgmS5r3+b+1xjFoAuqrCNCYWv4QKyx/72hPiBstVbg
	VrJzmGv1rB3o50zXMjlAy3O9dnE3Drp6xQpXpT2hvAvMOWTYGkQAoXD7OPPz2oWvzs9cGW
	LiHBYs0rYGARMTHyHSSE7uyIRIMbFqk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838866; a=rsa-sha256;
	cv=none;
	b=0jRlCk4a0bqzDeH80zVacgPM3uzWkZ0lytM4sVp1lVTm8Nn/Vr2o8131lTfJmQfFKp+h2D
	g/UYpZPAiS5Ez4I/JLicjEzIo1GWcz2fDcHytT1d/Y/VjTETNEJIqPlr/JvvQyC5wsRdAv
	BoDmTOBuPoRtqWnnZmmGq3XMC/DSKEY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uHscEP2W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E8AF44720;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A6F5C2BCB8;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778838862;
	bh=c4SFAPcxZwz5Ba3uenU/t9iGGz6xSyhO6FGkG2QqSKc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=uHscEP2WH6dCfLcyqkic8z6vwzoqKfS5qzNPwRx+/wuSzDT9V1FwSMrDXh+yYfqgN
	 EbejUEghADZB4Jqp7Qsn2YQomwpqeUeu8kQ3LumlzCdwF6RWHWECOrh9X1JCQ1bgTk
	 xmyys8wJCePuKDk1ec6lGwVNn7FmobJbYFC8FJA0MLZyDhDHajiYg0u/dP4FI6v6q5
	 HVvxpKCyNbH21uxZ3Nc+uDvFz3LYCa1NM6ypAlk5XTXKG7c/55mWEhVUYidnsHp9bT
	 YXGsFmHcMlMN6kmXK68iRSW4Y0/75p5zBnBU3EhTc4lPQf54VNTPKVIxZs2njA+w1e
	 MndXj4gWZ9u6A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4CDCD343F;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 15 May 2026 17:54:21 +0800
Subject: [PATCH v4 08/12] mm, swap: delay and unify memcg lookup and
 charging for swapin
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-swap-table-p4-v4-8-f1b49e845a8d@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778838859; l=7826;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=+AoQyWw1XmcntS40QznLMO6964tHE7aT+vEP1Ajpd7o=;
 b=OcFUwzH+OamBY2FVyDHghFeJklAwAr5LtA0pLthHoocbtIe5SnQkz2/X4EOAq2Wqk87dJFRYe
 GagJvhrSXuhAMKyJRMSFxCU536tyOenR2/tBMRwjOWLuPmQdrLjyoBZ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6E76160006
X-Stat-Signature: wqc8qs89ica6mzu1azqa18oi8p9bb54w
X-Rspam-User: 
X-HE-Tag: 1778838865-844700
X-HE-Meta: U2FsdGVkX18pKZrEeWG+YTjJb30G2MyyX0OgUcl4oKhmkitUoFT3Xp6BSF5ciKvN8OiPJIC5NL5Ds4oSvoNhMOPCQc3eBSdTw6rmoEux6iT2BxGZWbqXEeZtZelM3jDbAz9qBvS3G3g9/AP8zDC9xDutt1LoM7RC/pcXvXBcpyT+RxfoGQ7JGgBBJSiI8g1Dd9JtSdztMFqdPtATPpxon/DEd9e0+vm5S4AkalusJ6KX6skRP7bjEecqlwD3Hqz4PydTUNbpRyJMLv3n9imDUd7gDae3aRh/DV5s0to1XKcSHmkmMQF778LPHiWxtHyr4qq2i3ONa5MnvS9btbBdl25OzNeEaVVeQ5LVDO5QnDwZql4hI5UvNBKYq3Q/BWlkS1nrm5Nya22qrhiOEZx0zKqVFPLVMOdFfn96TRk6IH0Nr3Ojfk9PS736VCYkimW7E1ofvf13JVHahDyU2kDrm/qjJO04wHOVplk2JK7l0ulh84kiJBAVlg3s/oJneySuu8oP6O0BFBUujUNz1DioMG7bL28CIk3KxWBzBVuPamooG16Yz69lk/t0cSC2NP+YEblwTg0REMstpqbN2QDQlTMNWN5bdyrdLT13IIAjoe68Rb/AgYmHiNmAZGRfokV9YlSxvLiTWfMj+Epdu1/FOqE0mEkKAN5Ce4k3Pyxmwj1mHUGSoTIfdNH9hnbFKiFX+zh5sM1OkXzfhUA4byKAB4Z9Ku4yp7V/bQl9H6bpyyXb6wkZu58Z6FJbdJ0on1VSPg+VwWFcNMORLXFRhbP7XQainhE5QrYN0IKG+nPuR1rJH71sHU3aDY43AtroHWBFxHsrWC2uarwFjUTJJRm436ldsm/KcALLl5U3Yp3yDaKzErnnmLMqOcJNbQTkkkS8eHqYpBHd/jfOMiUgucY1eDqXutBnYxik2PJa5wxzYkRhZ3kNSwA4PSy1nv2zJzZLZRQAKEn3nluScgOU2sH
 vqE3sOsc
 kYaZwlcwGo3VSu/Q75W0LipCnex0d4kxrmz20evrSfkyRAfVfT6W1puZ44riSM9SwyOhkyR4aVNTAO2DQl8sXJC7zNx1/DTwUmNYelywpkx/zy12zLxnYtSIWnAH/udUbW8SEYLtdI/s3XsXm7FqUiYcJlxUytn5G5+s6v+efNw9DvmYPyvq/HQchyRhk/7RDCGdl8ZiCmu2Lp6+K8hSuHQTio4iGMu3ba6Y2IEwSk05ioPJjdDVevqCadWY8Rm29m3GrLImTb7K/A7HDyyf9xNlhGuTeF49tn0h92FFbhjRfQkqUpOnj09xhJqdwsMF4+sDTVTgybuzTRQ/5Yv1iys4QmkLODDD5wd7R9Uc33p76rwGFlc0KW2Wskt30oNXqJVUGSA15XEfilTkMNjV2yd7r6vLLqrPgDb9pNpNqxRbVhZw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of checking the cgroup private ID during page table walk in
swap_pte_batch(), move the memcg lookup into __swap_cache_add_check()
under the cluster lock.

The first pre-alloc check is speculative and skips the memcg check since
the post-alloc stable check ensures all slots covered by the folio
belong to the same memcg. It is very rare for contiguous and aligned
entries across a contiguous region of a page table of the same process
or shmem mapping to belong to different memcgs.

This also prepares for recording the memcg info in the cluster's table.
Also make the order check and fallback more compact.

There should be no user-observable behavior change.

Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h |  6 +++---
 mm/internal.h              | 10 +---------
 mm/memcontrol.c            | 10 ++++------
 mm/swap_state.c            | 28 +++++++++++++++++++---------
 4 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d08128de1fd..a013f37f24aa 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -646,8 +646,8 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
 
 int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
 
-int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
-				  gfp_t gfp, swp_entry_t entry);
+int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
+				   struct mm_struct *mm, gfp_t gfp);
 
 void __mem_cgroup_uncharge(struct folio *folio);
 
@@ -1137,7 +1137,7 @@ static inline int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp)
 }
 
 static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
-			struct mm_struct *mm, gfp_t gfp, swp_entry_t entry)
+		 unsigned short id, struct mm_struct *mm, gfp_t gfp)
 {
 	return 0;
 }
diff --git a/mm/internal.h b/mm/internal.h
index 5a2ddcf68e0b..9d2fec696bd6 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -451,24 +451,16 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 {
 	pte_t expected_pte = pte_next_swp_offset(pte);
 	const pte_t *end_ptep = start_ptep + max_nr;
-	const softleaf_t entry = softleaf_from_pte(pte);
 	pte_t *ptep = start_ptep + 1;
-	unsigned short cgroup_id;
 
 	VM_WARN_ON(max_nr < 1);
-	VM_WARN_ON(!softleaf_is_swap(entry));
+	VM_WARN_ON(!softleaf_is_swap(softleaf_from_pte(pte)));
 
-	cgroup_id = lookup_swap_cgroup_id(entry);
 	while (ptep < end_ptep) {
-		softleaf_t entry;
-
 		pte = ptep_get(ptep);
 
 		if (!pte_same(pte, expected_pte))
 			break;
-		entry = softleaf_from_pte(pte);
-		if (lookup_swap_cgroup_id(entry) != cgroup_id)
-			break;
 		expected_pte = pte_next_swp_offset(expected_pte);
 		ptep++;
 	}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a28a68eed7ba..4f940cf22ffe 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5070,27 +5070,25 @@ int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
 
 /**
  * mem_cgroup_swapin_charge_folio - Charge a newly allocated folio for swapin.
- * @folio: folio to charge.
+ * @folio: the folio to charge
+ * @id: memory cgroup id
  * @mm: mm context of the victim
  * @gfp: reclaim mode
- * @entry: swap entry for which the folio is allocated
  *
  * This function charges a folio allocated for swapin. Please call this before
  * adding the folio to the swapcache.
  *
  * Returns 0 on success. Otherwise, an error code is returned.
  */
-int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
-				  gfp_t gfp, swp_entry_t entry)
+int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
+				   struct mm_struct *mm, gfp_t gfp)
 {
 	struct mem_cgroup *memcg;
-	unsigned short id;
 	int ret;
 
 	if (mem_cgroup_disabled())
 		return 0;
 
-	id = lookup_swap_cgroup_id(entry);
 	rcu_read_lock();
 	memcg = mem_cgroup_from_private_id(id);
 	if (!memcg || !css_tryget_online(&memcg->css))
diff --git a/mm/swap_state.c b/mm/swap_state.c
index cdb7859eb502..75339640160a 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -142,17 +142,21 @@ void *swap_cache_get_shadow(swp_entry_t entry)
  * @ci: The locked swap cluster
  * @targ_entry: The target swap entry to check, will be rounded down by @nr
  * @nr: Number of slots to check, must be a power of 2
- * @shadowp: Returns the shadow value if one exists in the range.
+ * @shadowp: Returns the shadow value if one exists in the range
+ * @memcg_id: Returns the memory cgroup id, NULL to ignore cgroup check
  *
  * Check if all slots covered by given range have a swap count >= 1.
- * Retrieves the shadow if there is one.
+ * Retrieves the shadow if there is one. If @memcg_id is not NULL, also
+ * checks if all slots belong to the same cgroup and return the cgroup
+ * private id.
  *
  * Context: Caller must lock the cluster.
  * Return: 0 if success, error code if failed.
  */
 static int __swap_cache_add_check(struct swap_cluster_info *ci,
 				  swp_entry_t targ_entry,
-				  unsigned long nr, void **shadowp)
+				  unsigned long nr, void **shadowp,
+				  unsigned short *memcg_id)
 {
 	unsigned int ci_off, ci_end;
 	unsigned long old_tb;
@@ -172,19 +176,24 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 		return -EEXIST;
 	if (!__swp_tb_get_count(old_tb))
 		return -ENOENT;
-	if (swp_tb_is_shadow(old_tb) && shadowp)
+	if (shadowp && swp_tb_is_shadow(old_tb))
 		*shadowp = swp_tb_to_shadow(old_tb);
+	if (memcg_id)
+		*memcg_id = lookup_swap_cgroup_id(targ_entry);
 
 	if (nr == 1)
 		return 0;
 
+	targ_entry.val = round_down(targ_entry.val, nr);
 	ci_off = round_down(ci_off, nr);
 	ci_end = ci_off + nr;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
 		if (unlikely(swp_tb_is_folio(old_tb) ||
-			     !__swp_tb_get_count(old_tb)))
+			     !__swp_tb_get_count(old_tb) ||
+			     (memcg_id && *memcg_id != lookup_swap_cgroup_id(targ_entry))))
 			return -EBUSY;
+		targ_entry.val++;
 	} while (++ci_off < ci_end);
 
 	return 0;
@@ -400,6 +409,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	swp_entry_t entry;
 	struct folio *folio;
 	void *shadow = NULL;
+	unsigned short memcg_id;
 	unsigned long address, nr_pages = 1UL << order;
 	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
 
@@ -408,7 +418,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
 	/* Check if the slot and range are available, skip allocation if not */
 	spin_lock(&ci->lock);
-	err = __swap_cache_add_check(ci, targ_entry, nr_pages, NULL);
+	err = __swap_cache_add_check(ci, targ_entry, nr_pages, NULL, NULL);
 	spin_unlock(&ci->lock);
 	if (unlikely(err))
 		return ERR_PTR(err);
@@ -431,7 +441,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
 	/* Double check the range is still not in conflict */
 	spin_lock(&ci->lock);
-	err = __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow);
+	err = __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow, &memcg_id);
 	if (unlikely(err)) {
 		spin_unlock(&ci->lock);
 		folio_put(folio);
@@ -443,8 +453,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	__swap_cache_do_add_folio(ci, folio, entry);
 	spin_unlock(&ci->lock);
 
-	if (mem_cgroup_swapin_charge_folio(folio, vmf ? vmf->vma->vm_mm : NULL,
-					   gfp, entry)) {
+	if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
+					   vmf ? vmf->vma->vm_mm : NULL, gfp)) {
 		spin_lock(&ci->lock);
 		__swap_cache_do_del_folio(ci, folio, entry, shadow);
 		spin_unlock(&ci->lock);

-- 
2.54.0



