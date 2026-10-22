Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF3D6606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 07:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bBFKOg2+
Received: by kanga.kvack.org (Postfix)
	id DADE16B02B1; Thu, 22 Oct 2026 03:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85F26B02B3; Thu, 22 Oct 2026 03:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74D36B02B4; Thu, 22 Oct 2026 03:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0E26B02B1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:32:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 22CC31A0237
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:32:33 +0000 (UTC)
X-FDA: 85349444586.19.96E630E
Received: from mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf27.hostedemail.com (Postfix) with ESMTP id ABEC340002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:32:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bBFKOg2+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792654351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shS6wb4SxltOTjdgk1Wlp7Kf8IQyAouUieYOJaXFqOM=;
	b=AoGzAh8zoHeGc/GYc6MGKutRxZRYft3b3dU5rQ+WKLk2DdT2ut2qB1zy1G6Lb/JNVZLG2h
	YbOucpxBsjIWsagymJb/3mwqzImf8syb7Vcsj5moZoSXwbobxe/OvNiAfFhAIM93OYZkRy
	QMQG4ujMOH5zQryFdDy2kSrDQDyzVmQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bBFKOg2+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792654351;
	b=ZXIOmYDsX0QTiTfU5YStBCuTfwZSUlIKZZxqLPlL2MiXTbvlw4fmBAeS+hLX7sMuHAfRoL
	z4pL5hebaVp02vIRbDmeidBl63ZV4T3bOa1nt/LVz9FclkuJyUrTOS4b0zpmoyzDhnJe5i
	E30IIv6nTpf+89WRr8nAzSF0fGGHyw8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4qCDIHcFOvOripPLAZTCjyU1r8ZVx1IqYJGTBjnYmRA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792654349; v=1; x=1793259149;
 b=bBFKOg2+qDahAv1qC389H7IhpDH6QEhO3gi4oe+02KR9WvZclof1JxMmaIdknjrjzkdINb+l
 QEZbl+LGQuRapWfClApfYRKgk7pxeWgeonrNENuREE++FF21+VSGH5JtvK+fVUL334L4A7zyMLh
 2/SfmbQQU/LkjpTXdTcMRChg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5a2389d28bf66d2c;
	Thu, 22 Oct 2026 07:32:29 +0000
X-Mizu-Trace-ID: 5a2389d28bf66d2c
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	david@kernel.org,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	azpijr@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 4/5] mm: hugetlb: avoid recursive CMA allocation during migration
Date: Thu, 22 Oct 2026 15:31:48 +0800
Message-ID: <35120f1e65b135ebc7885a85bb39baab90882820.1792651104.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1792651104.git.zhengqi.arch@bytedance.com>
References: <cover.1792651104.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ABEC340002
X-Stat-Signature: 6xixcka7xsom7yfn7kwmi17fk44ypdjc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792654350-179907
X-HE-Meta: U2FsdGVkX18b8PbOorK9b+5tchtoMNjmDQEzox0vmb6tN3sAWiBtL4gYfbSwuKIv/fmM74QJkbK4h2+S4z1FSXCZZdPLt0B9rTdTIvtgsUtcZ+Z72HkyCtM8keGGHZ6mEDJ0MomhDTy8sgjNoeexTyKDLGgsHp6dOILf/W3dUMLB8vC/KYrfxBffkr/BGTUYgz+n/mWyh1orNEFuK32SqZqCEk4fCPlRak6rcnqXcPg/u38shokoaV1LHt283V2GlF1Lcf9ovBKBSLDwURGrzV7DN2lnbYwGIEU3b5WsAE/uQwdLIyovCG1VdHzB9QxlnNnZGjDI+TriN3/+PILOB1C8xFVLtblDd44jlUytR/8k6SLAZcqOev5aCQ9N1OGE5dYAMUOHgbBlpR790uynZ24xHM5ccKc9sOLaWClbR+lG5ZOi2VeyaR2v2O1xdekLcMSialMjYtuyJfGY0g3yoHzSQNlUbjSBhyL4db0mxblRSRsxmA73js5x0EaniucNehrJf3zDjyBNxkkfh1/4ZUC87qmNIQxKD4obYSM2MWsBkN3kSCPt+zvPGuZG1zjo8mVCtH439tj7m5WEdHBwQqPn6vlAjAyWGGOBlaMFYerxgCi4CLbVE4FS8AjS+ryEOnNEBIVhp5qEjHuC/pbwrn5UEMqMNMsRSwOTM5giMg11OPaWDrqTNiK1sUaB87iVPjemSv9KqGOC7Fy0dWx7AXshLPeFKbSYCvsqXI0HBFjG3VEC08OvDBr4qjFB9bajZOiurSSSXyavVc+enW3DIvlgnZ9ARY5zNMLqxKGpMxiEirnzuKz50HIQduXTtIlnZ/Wvid+mV/LuVeI1azgt2WF5eMN1oHrMJrCjPeXMDVUlYwiozdNfpuhsPWr3QrdLKjZwU3Ki9ZscJAt6dfZDcCsM35lsanyWYstmfHkxSMOzjtLmFO0uC1ZVMcpF8H41r5vzUVVB7Ze7S0Mv9Dr
 7J7Ebg1k
 A/iINoUCFhMwXsiNKRKh7FdfEQJIOyFH705W1d+ur3zwQjiIrrfZei2XeF+np3NFgCH6WgucTMDxaB+mJFFZ+3LJK+KYVGXr+XdPyrhp2zrMox7g+HRkpYi7LCCCWF76ZGWQKzoARm9eyeNspaOurP7EiKwbVkBw715IKic7rgrn8vRK/gGndW6pUQlJamGVZ5UrToHRcbbWCceYIUMDhruQI0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

Contiguous allocation can migrate allocated HugeTLB folios or replace free
HugeTLB folios while holding a CMA allocation mutex. Allocating a
replacement through CMA would recurse into that allocation path once
non-gigantic HugeTLB pages can use CMA.

Pass allow_cma through the migration and fresh allocation helpers, and
disable it for MR_CONTIG_RANGE and free folio replacement. Move the CMA
attempt into the common allocation path, retaining the gigantic size
restriction. Honor hugetlb_cma_only even when allow_cma is false.

The existing gigantic migration restriction is unchanged.

Assisted-by: LLM
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/hugetlb.h |  4 +--
 mm/hugetlb.c            | 69 +++++++++++++++++++++--------------------
 mm/mempolicy.c          |  2 +-
 mm/migrate.c            |  3 +-
 4 files changed, 40 insertions(+), 38 deletions(-)

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
index 6b08074d11f52..c1a8d00be11ac 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1362,18 +1362,8 @@ static struct folio *dequeue_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
 static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask)
 {
-	struct folio *folio;
-
-	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nodemask);
-	if (folio)
-		return folio;
-
-	if (hugetlb_cma_exclusive_alloc(order))
-		return NULL;
-
-	folio = (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
-							  nid, nodemask);
-	return folio;
+	return (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
+							 nid, nodemask);
 }
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
 static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask, int nid,
@@ -1841,37 +1831,47 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 
 static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		gfp_t gfp_mask, int nid, nodemask_t *nmask,
-		nodemask_t *node_alloc_noretry)
+		nodemask_t *node_alloc_noretry, bool allow_cma)
 {
-	struct folio *folio;
+	struct folio *folio = NULL;
 	int order = huge_page_order(h);
 
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
-	if (order_is_gigantic(order))
-		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
-	else
-		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
-						 node_alloc_noretry);
+	if (allow_cma && order_is_gigantic(order))
+		folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nmask);
+	if (!folio) {
+		if (hugetlb_cma_exclusive_alloc(order))
+			return NULL;
+
+		if (order_is_gigantic(order))
+			folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
+		else
+			folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
+							 node_alloc_noretry);
+	}
+
 	if (folio)
 		init_new_hugetlb_folio(folio);
+
 	return folio;
 }
 
 /*
- * Common helper to allocate a fresh hugetlb folio. All specific allocators
- * should use this function to get new hugetlb folio
+ * Common helper to allocate a fresh hugetlb folio. All special allocators
+ * should use this function to get new hugetlb folio.
  *
  * Note that returned folio is 'frozen':  ref count of head page and all tail
  * pages is zero, and the accounting must be done in the caller.
  */
 static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
-		gfp_t gfp_mask, int nid, nodemask_t *nmask)
+		gfp_t gfp_mask, int nid, nodemask_t *nmask, bool allow_cma)
 {
 	struct folio *folio;
 
-	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
+	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL,
+					       allow_cma);
 	if (folio)
 		hugetlb_vmemmap_optimize_folio(h, folio);
 	return folio;
@@ -1911,7 +1911,7 @@ static struct folio *alloc_pool_huge_folio(struct hstate *h,
 		struct folio *folio;
 
 		folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, node,
-					nodes_allowed, node_alloc_noretry);
+					nodes_allowed, node_alloc_noretry, true);
 		if (folio)
 			return folio;
 	}
@@ -2103,7 +2103,7 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 		goto out_unlock;
 	spin_unlock_irq(&hugetlb_lock);
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, true);
 	if (!folio)
 		return NULL;
 
@@ -2139,14 +2139,14 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 }
 
 static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
-				     int nid, nodemask_t *nmask)
+				     int nid, nodemask_t *nmask, bool allow_cma)
 {
 	struct folio *folio;
 
 	if (hstate_is_gigantic(h))
 		return NULL;
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, allow_cma);
 	if (!folio)
 		return NULL;
 
@@ -2219,7 +2219,8 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 
 /* folio migration callback function */
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask, gfp_t gfp_mask, bool allow_alloc_fallback)
+		nodemask_t *nmask, gfp_t gfp_mask, bool allow_alloc_fallback,
+		bool allow_cma)
 {
 	struct folio *folio = NULL;
 
@@ -2238,7 +2239,7 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 			gfp_mask |= __GFP_THISNODE;
 
 		folio = alloc_migrate_hugetlb_folio(h, gfp_mask, preferred_nid,
-						    nmask);
+						    nmask, allow_cma);
 	}
 
 	if (folio)
@@ -2722,8 +2723,8 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 		if (!new_folio) {
 			spin_unlock_irq(&hugetlb_lock);
 			gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
-			new_folio = alloc_fresh_hugetlb_folio(h, gfp_mask,
-							      nid, NULL);
+			new_folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
+							      NULL, false);
 			if (!new_folio)
 				return -ENOMEM;
 			goto retry;
@@ -3443,13 +3444,13 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 			gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 
 			folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
-					&node_states[N_MEMORY], NULL);
+					&node_states[N_MEMORY], NULL, true);
 			if (!folio && !list_empty(&folio_list) &&
 			    hugetlb_vmemmap_optimizable(h)) {
 				prep_and_add_allocated_folios(h, &folio_list);
 				INIT_LIST_HEAD(&folio_list);
 				folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
-						&node_states[N_MEMORY], NULL);
+						&node_states[N_MEMORY], NULL, true);
 			}
 			if (!folio)
 				break;
@@ -6357,7 +6358,7 @@ static struct folio *alloc_hugetlb_folio_vma(struct hstate *h,
 	 * consuming a reservation. Set the alloc_fallback to false to indicate
 	 * that breaking the per-node hugetlb pool is not allowed in this case.
 	 */
-	folio = alloc_hugetlb_folio_nodemask(h, node, nodemask, gfp_mask, false);
+	folio = alloc_hugetlb_folio_nodemask(h, node, nodemask, gfp_mask, false, true);
 	mpol_cond_put(mpol);
 
 	return folio;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0884c629670dd..a99ab927cd81a 100644
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


