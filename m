Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08BCECCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 10:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 123EB6B009D; Fri, 16 Oct 2026 06:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ADA96B009E; Fri, 16 Oct 2026 06:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2CA46B009F; Fri, 16 Oct 2026 06:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C49076B009D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:08:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5232640396
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:08:31 +0000 (UTC)
X-FDA: 85328064822.19.6F99EB4
Received: from mta0.migadu.com (out-193.mta0.migadu.com [91.218.175.193])
	by imf28.hostedemail.com (Postfix) with ESMTP id 60219C0006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:08:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MJdy8v8L;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792145309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJKHkpTkx8uNqf8JwXmfJSmLb18HReEMfoReAMXwoFI=;
	b=exdePNFpgE9W+9hR8YvKFBuWLAxy3Ib1ggXv8pgpouWY71EYlc/TDsFbn9VPeB7klNJlMo
	Zi7leSnFMfUpa1EaE8vxKTIii9+qF6bYkTVNbGTssxdJs85oL6WIScmlkgGAPHOJ/LIGu1
	dbUx/btAIxrUAkZBGs2lpjdZxq7D2/U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792145309;
	b=ohpOmaIyKpevuz+gQWCABvVrxq5g6UwjVJQT4GESLZ/v3LNgy8PlUs0Debbfravtn6TrFE
	u6eRItU/Ns6314GrhEx64XLe4FgVN05Y2qYnzTlp+dkf6y01HwbtVs6lOLS6gwQhZJp94z
	qRCMWoF8D2mAmaY+SvJccPQXow4iRkw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MJdy8v8L;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VkaQ74nVvNMSjZ0m5Mv4ONFzqQIhNe/gV0/4kSU6DVw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792145308; v=1; x=1792750108;
 b=MJdy8v8L7aMfuySAWzz/3PRWNtxCxaX8NJesYtJuur+vAIUmg0xr6zMABpDAcxlXggiNZbTi
 9s86GBlsvChdsp0mbpOAKVtfsclQpCNWEF8itQ8oRBXFJ3TrFt0js2vZJeCMfrBXdQsN+mYjiR7
 ElxCEhYlb/d5SgR8sgdMQVqY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2bce104875b9a9d6;
	Fri, 16 Oct 2026 10:08:28 +0000
X-Mizu-Trace-ID: 2bce104875b9a9d6
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 4/5] mm: hugetlb: avoid recursive CMA allocation during migration
Date: Fri, 16 Oct 2026 18:07:35 +0800
Message-ID: <d145aeb815b318ddd4dd9058d20038acfe5dc1bb.1792136742.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1792136742.git.zhengqi.arch@bytedance.com>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 60219C0006
X-Rspam-User: 
X-Stat-Signature: y8irpjh5sai53qmzdu38mnyfq1xphqb6
X-HE-Tag: 1792145309-616288
X-HE-Meta: U2FsdGVkX18kaCS8bMKekEQ3WMNC+VLBrHsGxuScD8h8oGTZV0qfdNu/ipEWwagnJ8dFMnLrfht1a7CFX60t8+wjqLvLqxtZj2mteFDYjgQHfJ+5Jj4t6g+EomO6thlnT9lzTWL4RZdCwNGEN/lJoNQxjFbvM1a74uGNVYrOtRIJevYURsSMPp/uvYEew0AdE6B3ua+S8uW/5a6h782YOOO6P3jsu5CwCC8gQgGeY6FgQQuSOE5YNGnpieURKkT6miwTSqhtlaFnA/eaFGuq6cc+0vT9hlFTxw7dw3oT6/2cK6+yy4WUEFgyYXPoPlOisknX7dTsM/a28pYfo34y6K9PYdBg4Kq3DYVCPv3LfyX7loeTd2MUtoDGSvvtVu5fSmUytviCa4fHzH12FjD8dBTO045T/8PpzOJdfHxRWInFT3dLrFm49h/OJQArS09RTqSN+M7TbNTswskRMHbjH+9ruZKNOddNdh+XCU2l0ErNp9Y/Vd4Tl5oBQTKhAFxzJ7c0vsOfU4hH/8HmtmAyZbZesEcrwwUYpgmyvz24EdJV8cr4SlFqKNEw8SEhOlJh5L8VG0FjWSQ+eZ43rkfl0e/eK1MOivVqGM2zZ9azwJvM23v4y3J2tFuqVrpgG4SNNF/SuFXJS6QWYq5eNkWo/nEudN+EFGyi3gyWcg6zk8zltZq5RwPkFfjvUOzuS7L/4v73RfEbMTGsVZ9MuupZVmyDUkezvMBpxNyzLqmGzD+5zfcVlYhlKYep2FkFVHcxE1JCk68nzNIlKNM0KESP81JRMDjF5PjoT5x+7eunvWOboqvRbDMsK2gmnBgTB1IWbEAEgPu3ckH53WQft7GDzlHo8uJhsEjaPWL528qtuy1dN+w4nQLx8o2L4YDPXYqhNCPFCEl3J//QKRe0RWLLgcZfVGQX9RUA+7cnxSba9IqU2k8ytSSQgTVlbFX78SGQl67NTOtXpIPQCDK8XBb
 AMw/cw8G
 811EujFigIuT5h+zPaxyZpX2QY/LDzyW9x0sQ7A2f2ByOJxLHFnjWilqerpIucnd9q/foMNobXVAzSscfls58FsqWXX8G2lek85ewDpNlvjrNEyQdulHGoVyKKY8OWGQGqnegpj7uLYZCf7LGWPdw7x4CarTuaCwEExE/DqdjWrkdH470dWAJC38UZFJudnNow6d3h2z8GB1K8A9e+QO7iHIKAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Contiguous allocation can migrate allocated HugeTLB folios or replace free
HugeTLB folios while holding a CMA allocation mutex. Allocating a
replacement through CMA would recurse into that allocation path once
non-gigantic HugeTLB pages can use CMA.

Add a fresh allocation helper that bypasses CMA, and use it for free folio
replacement. Pass an explicit allow_cma argument through the migration
allocation API and disable it for MR_CONTIG_RANGE. Honor hugetlb_cma_only
by failing fresh allocation when the corresponding size requires CMA.

The existing gigantic migration restriction is unchanged.

Assisted-by: LLM
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/hugetlb.h |  4 ++--
 mm/hugetlb.c            | 45 ++++++++++++++++++++++++++++++++---------
 mm/mempolicy.c          |  2 +-
 mm/migrate.c            |  3 ++-
 4 files changed, 41 insertions(+), 13 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 5029c72418631..38612f7b3478f 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -736,7 +736,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
-				bool allow_alloc_fallback);
+				bool allow_alloc_fallback, bool allow_cma);
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 					  nodemask_t *nmask, gfp_t gfp_mask);
 
@@ -1172,7 +1172,7 @@ alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 static inline struct folio *
 alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 			nodemask_t *nmask, gfp_t gfp_mask,
-			bool allow_alloc_fallback)
+			bool allow_alloc_fallback, bool allow_cma)
 {
 	return NULL;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9d569eae852c5..218fbaee6f7e5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1860,8 +1860,7 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 }
 
 /*
- * Common helper to allocate a fresh hugetlb folio. All specific allocators
- * should use this function to get new hugetlb folio
+ * Common helper to allocate a fresh hugetlb folio.
  *
  * Note that returned folio is 'frozen':  ref count of head page and all tail
  * pages is zero, and the accounting must be done in the caller.
@@ -1877,6 +1876,30 @@ static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
 	return folio;
 }
 
+/*
+ * Contiguous allocation can replace or migrate hugetlb pages while holding
+ * a CMA allocation mutex. Do not recurse into CMA to allocate replacements.
+ */
+static struct folio *alloc_fresh_hugetlb_folio_nocma(struct hstate *h, gfp_t gfp_mask,
+						     int nid, nodemask_t *nmask)
+{
+	struct folio *folio;
+	unsigned int order = huge_page_order(h);
+
+	if (hugetlb_cma_exclusive_alloc(order))
+		return NULL;
+
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
+
+	folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask, NULL);
+	if (folio) {
+		init_new_hugetlb_folio(folio);
+		hugetlb_vmemmap_optimize_folio(h, folio);
+	}
+	return folio;
+}
+
 void prep_and_add_allocated_folios(struct hstate *h,
 				   struct list_head *folio_list)
 {
@@ -2139,14 +2162,17 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 }
 
 static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
-				     int nid, nodemask_t *nmask)
+				     int nid, nodemask_t *nmask, bool allow_cma)
 {
 	struct folio *folio;
 
 	if (hstate_is_gigantic(h))
 		return NULL;
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	if (allow_cma)
+		folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	else
+		folio = alloc_fresh_hugetlb_folio_nocma(h, gfp_mask, nid, nmask);
 	if (!folio)
 		return NULL;
 
@@ -2219,7 +2245,8 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 
 /* folio migration callback function */
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask, gfp_t gfp_mask, bool allow_alloc_fallback)
+		nodemask_t *nmask, gfp_t gfp_mask, bool allow_alloc_fallback,
+		bool allow_cma)
 {
 	struct folio *folio = NULL;
 
@@ -2238,7 +2265,7 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 			gfp_mask |= __GFP_THISNODE;
 
 		folio = alloc_migrate_hugetlb_folio(h, gfp_mask, preferred_nid,
-						    nmask);
+						    nmask, allow_cma);
 	}
 
 	if (folio)
@@ -2722,8 +2749,8 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 		if (!new_folio) {
 			spin_unlock_irq(&hugetlb_lock);
 			gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
-			new_folio = alloc_fresh_hugetlb_folio(h, gfp_mask,
-							      nid, NULL);
+			new_folio = alloc_fresh_hugetlb_folio_nocma(h, gfp_mask,
+								    nid, NULL);
 			if (!new_folio)
 				return -ENOMEM;
 			goto retry;
@@ -6333,7 +6360,7 @@ static struct folio *alloc_hugetlb_folio_vma(struct hstate *h,
 	 * consuming a reservation. Set the alloc_fallback to false to indicate
 	 * that breaking the per-node hugetlb pool is not allowed in this case.
 	 */
-	folio = alloc_hugetlb_folio_nodemask(h, node, nodemask, gfp_mask, false);
+	folio = alloc_hugetlb_folio_nodemask(h, node, nodemask, gfp_mask, false, true);
 	mpol_cond_put(mpol);
 
 	return folio;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 70298fded1b4a..b59b8c73b8ce3 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1471,7 +1471,7 @@ static struct folio *alloc_migration_target_by_mpol(struct folio *src,
 		gfp = htlb_alloc_mask(h);
 		nodemask = policy_nodemask(gfp, pol, ilx, &nid);
 		return alloc_hugetlb_folio_nodemask(h, nid, nodemask, gfp,
-				htlb_allow_alloc_fallback(MR_MEMPOLICY_MBIND));
+				htlb_allow_alloc_fallback(MR_MEMPOLICY_MBIND), true);
 	}
 
 	if (folio_test_large(src))
diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f8..670556bf5de2c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2213,7 +2213,8 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 		gfp_mask = htlb_modify_alloc_mask(h, gfp_mask);
 		return alloc_hugetlb_folio_nodemask(h, nid,
 						mtc->nmask, gfp_mask,
-						htlb_allow_alloc_fallback(mtc->reason));
+						htlb_allow_alloc_fallback(mtc->reason),
+						mtc->reason != MR_CONTIG_RANGE);
 	}
 
 	if (folio_test_large(src)) {
-- 
2.54.0


