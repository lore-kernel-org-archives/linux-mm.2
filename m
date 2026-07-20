Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 668E0C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 11:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391AF6B00AE; Mon, 20 Jul 2026 07:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31BE26B00B0; Mon, 20 Jul 2026 07:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3EB6B00B2; Mon, 20 Jul 2026 07:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB2136B00AE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:12:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72C43160133
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:12:18 +0000 (UTC)
X-FDA: 85008891156.29.F85CA8A
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5CDB912000C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:12:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dD3FoSJx;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784545936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kx0HHACCJBu4qLsNxTSVWqhiiV39FZzOaFUJs4a+Yho=;
	b=cofXWh7RHdyfh5Hd18BxW/teoQ52hfykihKyAYjT8Nvb2/qbKD1mF05MWQUDbdz+sjSw00
	33thgAzEs+ikLLN8wuPQSiu+V+xf0WbT7w4DybfpLptuJsC5lDQDekephKhkkERHO8eFLM
	jYCJ5GeGfSp49Lzn/yF75THPjd9oFY8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dD3FoSJx;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784545936;
	b=ratspYOriINpuztZS6OxVhkTnti/AWc14vLblABCjoOj6aMB4PzGuZzR+wj8nt93wFjVX8
	X1nn3mpi4AsT9o31NwvwR3o/rUTIoBYvaK77FfuHEqxhojUgGnn5VUcZQ/uU9gv9GdstRe
	ePj3xMAVxzsiUNsESrVUkDDW6Kc+Mcw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784545931; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Kx0HHACCJBu4qLsNxTSVWqhiiV39FZzOaFUJs4a+Yho=;
	b=dD3FoSJxl/FcgXvy3d/ubJ0Ggf0sQmD0LZ7KLcoKxs1XCt7VJVzZAk3vln0yO+Oq9opKjG5vYxdTY+krUC4XLtXKxYdYMNXEdrpHJLWaV3xCMVuxYAokZdkTbE3eIPF9OMuqscAliapAuyuqGPVCW5ZWhp+F/wkWR5D+Y9euTbU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X7THEvM_1784545929;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7THEvM_1784545929 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Jul 2026 19:12:10 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org
Cc: riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	mhocko@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/3] mm: vmscan: convert folio_referenced() to use vma_flags_t
Date: Mon, 20 Jul 2026 19:12:00 +0800
Message-ID: <2bd39e16ec19e3e3c4716aa9a1a25775c26cac57.1784509721.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1784509721.git.baolin.wang@linux.alibaba.com>
References: <cover.1784509721.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5CDB912000C
X-Rspam-User: 
X-Stat-Signature: ipk153omj3k7x3oku5bde71ifhj6198t
X-HE-Tag: 1784545933-805236
X-HE-Meta: U2FsdGVkX1/88YaDXMUjF5YfEn+0+mepe1Ba32PrV3f5ewx4mpGMraOCqredjJ1JgBcX4/9wNqagxYrxtRgpMvI4QUKNkH7hpinwNuM+Kcs4k78+iF73+0nL9GOt12qnRK7mST01ypJaL1peSQPMKxooILQIIx0FKXhRxgFZX/NB2xsXtTu1o1pLyCA69ehuaUcMckyEEVEi1uNV3hb8zNoVxj0428z98Mg8ttj+oL+E5zoWkckmVR7U4J7lmeM89/2atM0iC8VE6GlGtCZiOb/1h3gORgezNwOcQGLmkh80OjCRD7Xvwn6qus4raZqL5Jm9bktqma5u9kGoQDmr/Bf91jzKRcMdIb8HMjFudenlDwGaDOgEMBQupHdnIln+yN2Ht9GJZUG8t4Ct4bQ7ojlBZQdQ5gTlvMkWE3wxRuMfAOkna9jrT9L7Ub/+2QTAbx5ogipbEyhSrfMKOSTo07JLokgLOIKDW4rN/ubG9Ym57xymzbK2puo6i3LoY0H8CdkUdE4Q5ifHmUiDjgumu8iHvvfUIBbC9KErNODv0dqHn8RDxyth+BRFFzbfjWM9Y4zBbQE1SanDTvUyXT4Q8YS9fVOV1dxpPluNjLrMqgc7co59d9mR0eGK7e7x0gx2NtjLOn6nXIx991XkGE4J7YmAzXnETPVZNIwxK3ydX9fgSomyWnDCK/Pay/cDFVw+X7Lls5R8iBJ/r668vJXVlS/IuD7a5lxiXpnSqq+hSkarcr7DQeNZxMskR6HTF1RkS7KIWQiqcw/6kxdq5WHvaoxZhZ5panNOdO+gjE929LhcMkgQs2TDwJqXNnUQnUxlvcTwi7b6Jd2pjyL6P/g/I4UVynMnGlryvuChAVtK9xFC3PuvllR04joEV1T94F33b661k1AV1X+EeWi22yVNWlrSJ3TBj2nl0RyDGhm5ePO4126kgoBRGpwgP0tfatDwgQWcIaj0wovcswycCWM
 UKOXFt2S
 I68CiDGIMYZS12/SYTOSuzayXXhVvArCQd4+BqwYc4YWnSdERZg1O5KEsG/oP+D7VqLwBhjYTAF1ZdCWQsZ6MqoSj8WtWU7PL+0ATI7ouuTlFlOx0i+ZJJBpiQpdklpH/zbSG02gjG1UV09nKAus7oJVp4/c5bRhoYY+TD9nuNnXiuxv5joBXaGtDOkB+U9/H5/jf1ElokbOhBzOs0mLu4qMBu+fqhd8MNqmcn798QZBYAzdhXQe13CLiu+YCO+piYBJBVGpt6S7e8oxNuWu909T43a6/gMc/eBEdWgThj4tCVN3blRPvukcf7Uiljk1kMw/PJXg1E5P7MLTaDOjX2ofZBy0lblXjgiRk5EbAKJaWTblsk4ETGiRHJ3vqvHlPYbRVercWcMR2bOVFmTcLwYMnkCUx00+JIuazIE/WYpTI7T8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace use of the legacy vm_flags_t flags with vma_flags_t values for
folio_referenced() and related logic. This is also a preparation for the
following changes.

No functional changes.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
---
 include/linux/rmap.h |  7 +++----
 mm/rmap.c            | 19 +++++++++++--------
 mm/vmscan.c          | 14 +++++++-------
 3 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f00..e090aa09825d 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -843,7 +843,7 @@ static inline int folio_try_share_anon_rmap_pmd(struct folio *folio,
  * Called from mm/vmscan.c to handle paging out
  */
 int folio_referenced(struct folio *, int is_locked,
-			struct mem_cgroup *memcg, vm_flags_t *vm_flags);
+		struct mem_cgroup *memcg, vma_flags_t *vma_flags);
 
 void try_to_migrate(struct folio *folio, enum ttu_flags flags);
 void try_to_unmap(struct folio *, enum ttu_flags flags);
@@ -975,10 +975,9 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 #define anon_vma_prepare(vma)	(0)
 
 static inline int folio_referenced(struct folio *folio, int is_locked,
-				  struct mem_cgroup *memcg,
-				  vm_flags_t *vm_flags)
+		struct mem_cgroup *memcg, vma_flags_t *vma_flags)
 {
-	*vm_flags = 0;
+	vma_flags_clear_all(vma_flags);
 	return 0;
 }
 
diff --git a/mm/rmap.c b/mm/rmap.c
index ad820fe86f7d..73c2fe2d1946 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -907,7 +907,7 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
 struct folio_referenced_arg {
 	int mapcount;
 	int referenced;
-	vm_flags_t vm_flags;
+	vma_flags_t vma_flags;
 	struct mem_cgroup *memcg;
 };
 
@@ -926,7 +926,7 @@ static bool folio_referenced_one(struct folio *folio,
 		address = pvmw.address;
 		nr = 1;
 
-		if (vma->vm_flags & VM_LOCKED) {
+		if (vma_test(vma, VMA_LOCKED_BIT)) {
 			ptes++;
 			pra->mapcount--;
 
@@ -947,7 +947,7 @@ static bool folio_referenced_one(struct folio *folio,
 			/* Restore the mlock which got missed */
 			mlock_vma_folio(folio, vma);
 			page_vma_mapped_walk_done(&pvmw);
-			pra->vm_flags |= VM_LOCKED;
+			vma_flags_set(&pra->vma_flags, VMA_LOCKED_BIT);
 			return false; /* To break the loop */
 		}
 
@@ -1015,8 +1015,11 @@ static bool folio_referenced_one(struct folio *folio,
 		referenced++;
 
 	if (referenced) {
+		vma_flags_t vma_flags = vma->flags;
+
 		pra->referenced++;
-		pra->vm_flags |= vma->vm_flags & ~VM_LOCKED;
+		vma_flags_clear(&vma_flags, VMA_LOCKED_BIT);
+		vma_flags_set_mask(&pra->vma_flags, vma_flags);
 	}
 
 	if (!pra->mapcount)
@@ -1054,7 +1057,7 @@ static bool invalid_folio_referenced_vma(struct vm_area_struct *vma, void *arg)
  * @folio: The folio to test.
  * @is_locked: Caller holds lock on the folio.
  * @memcg: target memory cgroup
- * @vm_flags: A combination of all the vma->vm_flags which referenced the folio.
+ * @vma_flags: A combination of all the vma->flags which referenced the folio.
  *
  * Quick test_and_clear_referenced for all mappings of a folio,
  *
@@ -1062,7 +1065,7 @@ static bool invalid_folio_referenced_vma(struct vm_area_struct *vma, void *arg)
  * the function bailed out due to rmap lock contention.
  */
 int folio_referenced(struct folio *folio, int is_locked,
-		     struct mem_cgroup *memcg, vm_flags_t *vm_flags)
+		struct mem_cgroup *memcg, vma_flags_t *vma_flags)
 {
 	bool we_locked = false;
 	struct folio_referenced_arg pra = {
@@ -1078,7 +1081,7 @@ int folio_referenced(struct folio *folio, int is_locked,
 	};
 
 	VM_WARN_ON_ONCE_FOLIO(folio_is_zone_device(folio), folio);
-	*vm_flags = 0;
+	vma_flags_clear_all(vma_flags);
 	if (!pra.mapcount)
 		return 0;
 
@@ -1092,7 +1095,7 @@ int folio_referenced(struct folio *folio, int is_locked,
 	}
 
 	rmap_walk(folio, &rwc);
-	*vm_flags = pra.vm_flags;
+	vma_flags_set_mask(vma_flags, pra.vma_flags);
 
 	if (we_locked)
 		folio_unlock(folio);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b7ef032e78a0..11357b86ba2c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -861,16 +861,16 @@ static enum folio_references folio_check_references(struct folio *folio,
 						  struct scan_control *sc)
 {
 	int referenced_ptes, referenced_folio;
-	vm_flags_t vm_flags;
+	vma_flags_t vma_flags;
 
 	referenced_ptes = folio_referenced(folio, 1, sc->target_mem_cgroup,
-					   &vm_flags);
+					   &vma_flags);
 
 	/*
 	 * The supposedly reclaimable folio was found to be in a VM_LOCKED vma.
 	 * Let the folio, now marked Mlocked, be moved to the unevictable list.
 	 */
-	if (vm_flags & VM_LOCKED)
+	if (vma_flags_test(&vma_flags, VMA_LOCKED_BIT))
 		return FOLIOREF_ACTIVATE;
 
 	/*
@@ -914,7 +914,7 @@ static enum folio_references folio_check_references(struct folio *folio,
 		/*
 		 * Activate file-backed executable folios after first usage.
 		 */
-		if ((vm_flags & VM_EXEC) && folio_is_file_lru(folio))
+		if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio))
 			return FOLIOREF_ACTIVATE;
 
 		return FOLIOREF_KEEP;
@@ -2063,7 +2063,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 {
 	unsigned long nr_taken;
 	unsigned long nr_scanned;
-	vm_flags_t vm_flags;
+	vma_flags_t vma_flags;
 	LIST_HEAD(l_hold);	/* The folios which were snipped off */
 	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
@@ -2107,7 +2107,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 
 		/* Referenced or rmap lock contention: rotate */
 		if (folio_referenced(folio, 0, sc->target_mem_cgroup,
-				     &vm_flags) != 0) {
+				     &vma_flags) != 0) {
 			/*
 			 * Identify referenced, file-backed active folios and
 			 * give them one more trip around the active list. So
@@ -2117,7 +2117,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 			 * IO, plus JVM can create lots of anon VM_EXEC folios,
 			 * so we ignore them here.
 			 */
-			if ((vm_flags & VM_EXEC) && folio_is_file_lru(folio)) {
+			if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio)) {
 				nr_rotated += folio_nr_pages(folio);
 				list_add(&folio->lru, &l_active);
 				continue;
-- 
2.47.3


