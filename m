Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 700A7EC112B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 01:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6606B0092; Mon, 23 Feb 2026 20:56:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A72E6B0095; Mon, 23 Feb 2026 20:56:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E7C6B0092; Mon, 23 Feb 2026 20:56:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1AC96B0092
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:56:36 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD9ABC1AAF
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:56:36 +0000 (UTC)
X-FDA: 84477685992.16.09B2828
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6906112000E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:56:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pf2ZUw06;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771898195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUAU3X7Xx15v27pYap676B43gvtts/Dbo0nCLQJ/8ZQ=;
	b=2v1GFvSAbERCA3DBMwHIlGo7/wpRXuUPAUGSgoT8W+VmfiG/SmGoHlANQZnOehfLcqUwwI
	2fqVDjHxS+iMDAGvQUSyn+ydIi1CjNN+opB323A0/CG42GzIgPT/7lu4nBSaI1+1eam+/F
	gLQD/mhsyOWLQa0dWuDYeZ0TRCrSDvs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771898195; a=rsa-sha256;
	cv=none;
	b=uU18GXYngUjlNA5KfEGnn7E0v2JgmVPMuv0eHl8wJxvzDAMlAskueIF2+doRyuZ3bggK7r
	y3r2LrEvvXNAPPmM06Lvg55tcXyyi0M9jXzlo/A+nLaJTp4PgLAhY6TBxhNvVkhmwjBCcr
	V1xr8siZzlkUkiGYcni2xqJqCw0Zq3c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pf2ZUw06;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771898189; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=vUAU3X7Xx15v27pYap676B43gvtts/Dbo0nCLQJ/8ZQ=;
	b=pf2ZUw06lvXyx+NTLcAqjuBzg1PjRJypi4+2r6eVrc1bkMr4+cjbZx5DQvVasXRCihdQDQXxw7hTfyZuJ1ZEfphtrfqytw+V0yNWUOo6p8zJ/EEUzIghCng1ISiNBKVvWo5Fa0rUnpwFwI0BT+aFxojIkG7Aqm7ZBY83C2V0tzg=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wzhs.qI_1771898188 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Feb 2026 09:56:28 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] mm: support batched checking of the young flag for MGLRU
Date: Tue, 24 Feb 2026 09:56:07 +0800
Message-ID: <84d2426c63c1eafeaa0cfbad7c5cc11e9c11b980.1771897150.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6906112000E
X-Stat-Signature: 4wneoiii8xa16cbz6og6bq5655tjm4ps
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771898194-204151
X-HE-Meta: U2FsdGVkX1+2zr2JVdAgeBUuXCbUrsQrgw0xEGy73RMDoEYAfgqDsvWKLpcDmiwm55qo0PJZpXqra7HTs16XuxEI2fNRgiiummA58DwnjLglxDUzh8v07X4FJ9fKwPHd5KVG16KBl4QYIihMAPI1HD04LtsvFnXchR0nUBzwb1ShbcI0QiKZVHGBdnsH8bsMHI2GFR+7HUNxcZAAgUmDmH/UTZHz4umUG8LQK/4MNpukoG3OqyznnT9ZPoFEJcCoDkIaMIJ8pPu6+r+jHRPXJD8TOrZrfqWPSJ1Ku7lfOe1GbDypMEafqq0PC79HnZ7ETKRapviDPuwuRqBeye3zQzDskzFK7aCw4lBp6fc9aghK2k2z3TnhJseGSnJ53OCxBJ8SuRuKaC1jHDfSg4D3z/m8Cb0gWbIgQGoH3EiiLle+Dej0P84ZCY3iFGW0HmXTk44ZERRP6v437GQXgTs5N1pf9FBHHsnDCDsmM80aY4Mbhu8BlxKGoFEJ3h+l+uLkWy0yE6+3Y3Dj1U/ibUAjrbmgO6QxMf2x5GvYaIgPLjirlLGKusegaYdSwqkRn4gqbKBgOILykaGoIoc7wCVPgq2+YRKl8OyX3I6S26Wjqp29pK3V6nsxkYZfBIlEONy8wQS9TaW9Mjv/aByWif2rnHAQ07NORU6JsTtVZoYbH5nhuez1q1eCh5qEFQHSsnCNmFKGGn2WuNCw6CsjtBoLwPja+H4z3im+peWpWZE0uyVQmf1ATjOYLwq+DqOhQQX5mYSlE0ON/QT/mLNOucDE+iEPldAnE0ZNEn7Ix5XkZMrJ0O8Tl2P8U4vlFMmaoKooruiCTzaHAGsYc4bacPMmdqPmsEB3a/gw+ko5xs2L/GjIN0/BW3a/mLQroKEVGvuwAY5cKsJ8ydFEttN5t6nsUi4W7uYGnRtYg2HhCFL58GqJ5H5sEshP4O0NCiG2RPj7IhgfZsRHI6k/PYlHw7n
 g8enjrOg
 kYu/Lz6Y90SCvApvdSBW/0XiNC7hAzEZkH1dogV60e/3L+lQJ6O2c87zonM5MCqopXPhBk/Bzx1KXZiqNqovbYQC/HxQTTs2B5Tz8bOJf+KkHyvLJ71HvLUbikfGXoDtbe0Ma3lGaScaPdwuT53Z5EDTkXlYJQ8xaxJabpRH38+Y+5f4v8iMs4cOJS312H3AM3T0puUaQVl5zVXjyReqHhJRrgOveqkecmaWDKNGoBDmwn+4sYzln6A1c2EtJr3eNxIvob4CeHxSOYPbLeaqT+7EjbO6ywgfv+RhX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the batched helper clear_young_ptes_notify() to check and clear the
young flag to improve the performance during large folio reclamation when
MGLRU is enabled.

Meanwhile, we can also support batched checking the young and dirty flag
when MGLRU walks the mm's pagetable to update the folios' generation
counter. Since MGLRU also checks the PTE dirty bit, use folio_pte_batch_flags()
with FPB_MERGE_YOUNG_DIRTY set to detect batches of PTEs for a large folio.

Then we can remove the ptep_clear_young_notify() since it has no users now.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/mmzone.h |  5 +++--
 mm/internal.h          | 12 ------------
 mm/rmap.c              | 30 ++++++++++++++++--------------
 mm/vmscan.c            | 37 +++++++++++++++++++++++++++++--------
 4 files changed, 48 insertions(+), 36 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index db41b18a919d..de9fee4244d9 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -630,7 +630,7 @@ struct lru_gen_memcg {
 
 void lru_gen_init_pgdat(struct pglist_data *pgdat);
 void lru_gen_init_lruvec(struct lruvec *lruvec);
-bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw);
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int batched);
 
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
 void lru_gen_exit_memcg(struct mem_cgroup *memcg);
@@ -649,7 +649,8 @@ static inline void lru_gen_init_lruvec(struct lruvec *lruvec)
 {
 }
 
-static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw,
+				       unsigned int batched)
 {
 	return false;
 }
diff --git a/mm/internal.h b/mm/internal.h
index 1b59be99dc3f..4e8d37570f46 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1824,12 +1824,6 @@ static inline int clear_young_ptes_notify(struct vm_area_struct *vma,
 	return young;
 }
 
-static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
-					  unsigned long addr, pte_t *ptep)
-{
-	return clear_young_ptes_notify(vma, addr, ptep, 1);
-}
-
 static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
 					  unsigned long addr, pmd_t *pmdp)
 {
@@ -1847,12 +1841,6 @@ static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
 #define clear_young_ptes_notify	test_and_clear_young_ptes
 #define pmdp_clear_young_notify	pmdp_test_and_clear_young
 
-static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
-					  unsigned long addr, pte_t *ptep)
-{
-	return test_and_clear_young_ptes(vma, addr, ptep, 1);
-}
-
 #endif /* CONFIG_MMU_NOTIFIER */
 
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/rmap.c b/mm/rmap.c
index be785dfc9336..1c147251ae28 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -958,25 +958,21 @@ static bool folio_referenced_one(struct folio *folio,
 			return false;
 		}
 
+		if (pvmw.pte && folio_test_large(folio)) {
+			unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
+			unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
+			pte_t pteval = ptep_get(pvmw.pte);
+
+			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
+			ptes += nr;
+		}
+
 		if (lru_gen_enabled() && pvmw.pte) {
-			if (lru_gen_look_around(&pvmw))
+			if (lru_gen_look_around(&pvmw, nr))
 				referenced++;
 		} else if (pvmw.pte) {
-			if (folio_test_large(folio)) {
-				unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
-				unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
-				pte_t pteval = ptep_get(pvmw.pte);
-
-				nr = folio_pte_batch(folio, pvmw.pte,
-						     pteval, max_nr);
-			}
-
-			ptes += nr;
 			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
 				referenced++;
-			/* Skip the batched PTEs */
-			pvmw.pte += nr - 1;
-			pvmw.address += (nr - 1) * PAGE_SIZE;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
 						pvmw.pmd))
@@ -995,6 +991,12 @@ static bool folio_referenced_one(struct folio *folio,
 			page_vma_mapped_walk_done(&pvmw);
 			break;
 		}
+
+		/* Skip the batched PTEs */
+		if (nr > 1) {
+			pvmw.pte += nr - 1;
+			pvmw.address += (nr - 1) * PAGE_SIZE;
+		}
 	}
 
 	if (referenced)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 728868c61750..d83962468b2e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3494,6 +3494,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int gen = lru_gen_from_seq(max_seq);
+	unsigned int nr;
 	pmd_t pmdval;
 
 	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
@@ -3512,11 +3513,13 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 
 	lazy_mmu_mode_enable();
 restart:
-	for (i = pte_index(start), addr = start; addr != end; i++, addr += PAGE_SIZE) {
+	for (i = pte_index(start), addr = start; addr != end; i += nr, addr += nr * PAGE_SIZE) {
 		unsigned long pfn;
 		struct folio *folio;
-		pte_t ptent = ptep_get(pte + i);
+		pte_t *ptep = pte + i;
+		pte_t ptent = ptep_get(ptep);
 
+		nr = 1;
 		total++;
 		walk->mm_stats[MM_LEAF_TOTAL]++;
 
@@ -3528,7 +3531,14 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (!folio)
 			continue;
 
-		if (!ptep_clear_young_notify(args->vma, addr, pte + i))
+		if (folio_test_large(folio)) {
+			unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
+
+			nr = folio_pte_batch_flags(folio, NULL, ptep, &ptent,
+						   max_nr, FPB_MERGE_YOUNG_DIRTY);
+		}
+
+		if (!clear_young_ptes_notify(args->vma, addr, ptep, nr))
 			continue;
 
 		if (last != folio) {
@@ -4186,7 +4196,7 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
  * the PTE table to the Bloom filter. This forms a feedback loop between the
  * eviction and the aging.
  */
-bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int batched)
 {
 	int i;
 	bool dirty;
@@ -4205,11 +4215,13 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
 	int gen = lru_gen_from_seq(max_seq);
+	unsigned int nr;
+	pte_t *ptep;
 
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
 
-	if (!ptep_clear_young_notify(vma, addr, pte))
+	if (!clear_young_ptes_notify(vma, addr, pte, batched))
 		return false;
 
 	if (spin_is_contended(pvmw->ptl))
@@ -4243,10 +4255,12 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 
 	pte -= (addr - start) / PAGE_SIZE;
 
-	for (i = 0, addr = start; addr != end; i++, addr += PAGE_SIZE) {
+	for (i = 0, addr = start, ptep = pte; addr != end;
+	     i += nr, ptep += nr, addr += nr * PAGE_SIZE) {
 		unsigned long pfn;
-		pte_t ptent = ptep_get(pte + i);
+		pte_t ptent = ptep_get(ptep);
 
+		nr = 1;
 		pfn = get_pte_pfn(ptent, vma, addr, pgdat);
 		if (pfn == -1)
 			continue;
@@ -4255,7 +4269,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 		if (!folio)
 			continue;
 
-		if (!ptep_clear_young_notify(vma, addr, pte + i))
+		if (folio_test_large(folio)) {
+			unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
+
+			nr = folio_pte_batch_flags(folio, NULL, ptep, &ptent,
+						   max_nr, FPB_MERGE_YOUNG_DIRTY);
+		}
+
+		if (!clear_young_ptes_notify(vma, addr, ptep, nr))
 			continue;
 
 		if (last != folio) {
-- 
2.47.3


