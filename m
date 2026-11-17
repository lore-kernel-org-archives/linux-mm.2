Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7AF606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KnjddYz5
Received: by kanga.kvack.org (Postfix)
	id C33866B00EF; Tue, 17 Nov 2026 02:00:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4326B05B0; Tue, 17 Nov 2026 02:00:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFA996B05B1; Tue, 17 Nov 2026 02:00:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BDEC6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:00:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E1D640343
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:00:57 +0000 (UTC)
X-FDA: 85443713754.08.468D5F6
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 24478C000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:00:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KnjddYz5;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794898855;
	b=MlVbE5kcWixCalqGtqcdeA0WVSQxHG73bEFTHcGE4/oP5cHgXLJIsFFUfUWywxf2dXjoql
	Utj8gyRr3abNZkSIfrTHQFS02wdqMLPWtHyekh83d3XCt8nFk4z5niUY1ONTxpL9FIdDvD
	SNJ1VzWctSAenVw5w52NhICreyd9Huo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794898855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1YXPcLXzICaGPRz8rHCfa6s3tChPEmNKPoNy40HFGsk=;
	b=6LlRzXu4xhg2DthNY4J4C5Wp/iOdz5TD1zF8T1wuqwvzhVAjEWbPAmTqvL0QM33s1eG1NZ
	zavSARZBAwILUXvSIL70XsjOUzQquL/NE/rgIJV0ZVQAiShI9pz6XVgfe9czXDxn6QRHey
	wY6nF6y4brOAnOUl0bAvbxXfOPEI90s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KnjddYz5;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794898850; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=1YXPcLXzICaGPRz8rHCfa6s3tChPEmNKPoNy40HFGsk=;
	b=KnjddYz5xKIXC9p4vzC4vnRKCM4I5y6dpuTBpcAt7Sq1X+O/6C5qWQPniDQkrdO4DUM7PRybpd6tldrXN60wiPzwT6rGlv8M6fBjFhUAf6xXdONRjKqyM1cOx0KlqYvFH9JG11gR9GMrYc79nr+o+Oewt7TzHbfUOjww0Qe3Kls=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XEyG6TV_1794898846;
Received: from localhost.localdomain(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEyG6TV_1794898846 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Nov 2026 15:00:48 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm: use memory barriers for non PMD-sized folios to sync
Date: Tue, 17 Nov 2026 15:00:30 +0800
Message-ID: <6274e62645b9f176dd10d7a79e86b900a39cec5f.1794898535.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 24478C000A
X-Rspam-User:
X-Stat-Signature: fbgexpx8z7s51abwiosxsb4zede1nfaa
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794898853-97784
X-HE-Meta: U2FsdGVkX18n4h2Jl8FUz+sNjSCGKLhtcltNRF1vaPpAYT+lkz+r3eqee/XDjolKm6jRHwMSc5A+1N0vcBPTB8mec/e7TYHyj2v92/bFELPXphk2495zg+TYT/AQPQ5yMSndHlu+cih4DWcXb9bfneEmWq16tGNQ9cIJjr06FRh+5OjzSyyvE74ITwKnuS+07md7jRNw4Ripb+UlzqCkY2b/cCppvv8Ci8HcbLvjYjbJMsXZlCW8RdT1HQVr7e1MhP7VPsls16u8p33ZJbWfnNIwIzJ6Y33BAH6svHheIwkwtWYCEL9JvjflKxnnpV6636nK4XdeXKeBPd6YqV8oRzqwUGNc6IDqD9XbVcskDphMaXEC+8GcHGycx+wWq6zPzXi8Wh/CEbh7MmujyBISg6sRE42ncIRH+GScFcSuvMPlPKdAJRjhQRx9uO82bzpwx46Uj3/4/Sli9plCb0s7DafJOnCIaGgGKtZ7dkBL2B0+ee7BOa5W5fl8/KApzojWitz7U17iCgjDEkB2ghFAb6RgHrCl84EU4JudE1R5fgDDEUvA+M7BJPKZfbMS2m2qlyV1U81XZN5+vvmtVq5Xbu9B2q7gZv0LTEcmRbkKYQaMwUAshGzNxJntepl2XYSX99e3LLOXIwXVvvzS0Q0P5yyJrkcom6tJVqKpa7Y39+3CWGibyt9Gd2XO3FQSiJrVxeumYRytf1hy6s1RWuoFWEEM6amTOgay/2LPcecG6nLRw+w92FkvdfRsN9lIfzVsy5eZcu8WQqiGz0bQq/i48bUQkUl1WS8zjz4VtuVkWEnVhTkDcVDVwQrjZisjDNuETEbAiaTdQsadaVRj1cWYVsKxiz6E8GUmN0/4uetkd8gxMYyyiThL8F0LMTJ2UYb8SppSiljARQ1MNEZOdCrS6kmlDp5Mt6XkO8wWnRw4FnWMFZ7vo7tNh0F+gHSA3BHPx8kAPNsC56IoeJwhOX9
 A213DeTt
 UMPeApV5klwrFChCKvq39gnLoXVjJsQAeFPYqZPPzPpWGET5zFgWmgYhoOK98lIMZMO3DRQLfZV8PJamrJGiaAvosBJfAagvRrIYDhEGs90L3NgRtpHUfyqCADdZNgY8oc6lv1y2TSQXg7jbPk1XyWkvu53brsPSQp8cn2J25M3HasNPhDxKABfnmKH3TYr/dXLt6nrpO5/eLrAo77e4YoOC4zRcvMDjNwiG3EcUPUw+s3QMveNJSHQB5h1awC59Jo4ny6RQ/JYFL+786oJaGgf5gjtrj8MIFQbkc1dF364eMrWzz65NUS8388VHr4B1eGLYVxcgrPZsLb3syjX767cE6OFaM8MS5NWbgFoR2VcGNuA9Nan6zU1hdumgNoEDu6kHWYjWGwMUerEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
uses PMD lock via sync_with_folio_pmd_zap() to synchronize when a cleared
PMD is found while unmapping a folio.

However, for non PMD-sized folios, the only PMD clear that can race with
this unmap is PTE table reclaim, which clears the PMD only after the rmaps
for the table have been removed. This is plain message passing, and taking
the PMD lock is more than needed, like I did in the previous patch[1].

Without barriers, the walker can observe the cleared PMD but a stale
mapcount on weakly ordered architectures:

CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
================================    ================================
folio_lock()
                                    lock(ptl)
                                    clear PTEs
                                    remove rmaps   /* W mapcount */
[mapcount load satisfied early,
 folio still mapped]
                                    pmd_clear()    /* W pmd */
                                    unlock(ptl)
pmdp_get_lockless() -> none         /* R pmd */
skip the PMD
folio_mapped() -> true              /* R mapcount, stale */
unmapping assumed to have failed

Pairing an smp_wmb() before the PMD clear with an smp_rmb() after the
PMD read forbids this outcome:

CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
================================    ================================
                                    remove rmaps   /* W mapcount */
                                    smp_wmb()
                                    pmd_clear()    /* W pmd */
pmdp_get_lockless() -> none         /* R pmd */
smp_rmb()
folio_mapped()                      /* R mapcount */

If R pmd observes W pmd, R mapcount must observe W mapcount, so
folio_mapped() no longer reports the removed mappings.

Pass a 'folio' parameter to sync_with_folio_pmd_zap(), allowing us to
skip those pfn walkers: pfn_mkclean_range and mapping_wrprotect_range,
which don't need synchronization.

Similarly, skip sync for page_mapped_in_vma() since the subsequent
operations don't check the folio's mapcount.

No changes for PMD-sized folios unmapping.

[1] https://lore.kernel.org/all/542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com/
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Changes from v1:
 - Pass in a folio for sync_with_folio_pmd_zap(), per David.
---
 include/linux/rmap.h |  2 ++
 mm/internal.h        | 26 ++++++++++++++++++++++----
 mm/memory.c          | 12 ++++++++++--
 mm/page_vma_mapped.c |  4 ++--
 4 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 74cca0e3c726..62e7341de179 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -862,6 +862,7 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 #define PVMW_PGTABLE_CROSSED	(1 << 16)
 
 struct page_vma_mapped_walk {
+	struct folio *folio;
 	unsigned long pfn;
 	unsigned long nr_pages;
 	pgoff_t pgoff;	/* Only meaningful if nr_pages > 1 and not a KSM walk */
@@ -876,6 +877,7 @@ struct page_vma_mapped_walk {
 
 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
 	struct page_vma_mapped_walk name = {				\
+		.folio = _folio,					\
 		.pfn = folio_pfn(_folio),				\
 		.nr_pages = folio_nr_pages(_folio),			\
 		.pgoff = folio_pgoff(_folio),				\
diff --git a/mm/internal.h b/mm/internal.h
index cd3675c044e0..ad7e051cb198 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -592,6 +592,7 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
  * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
  * @mm: The mm_struct.
  * @pmdp: Pointer to the pmd that was found to be pmd_none().
+ * @folio: The folio being zapped.
  *
  * When we find a pmd_none() while unmapping a folio without holding the PTL,
  * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
@@ -600,13 +601,30 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
  * against later mapcount reads. Skipping the PMD without synchronization
  * could make folio unmapping code assume that unmapping failed.
  *
- * Wait for concurrent zapping to complete by grabbing the PTL.
+ * Wait for concurrent zapping to complete by grabbing the PTL for PMD-sized
+ * folios, otherwise smp_rmb() is sufficient.
  */
-static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
+static inline void sync_with_folio_pmd_zap(struct mm_struct *mm,
+		pmd_t *pmdp, struct folio *folio)
 {
-	spinlock_t *ptl = pmd_lock(mm, pmdp);
+	if (folio_test_pmd_mappable(folio)) {
+		spinlock_t *ptl = pmd_lock(mm, pmdp);
 
-	spin_unlock(ptl);
+		spin_unlock(ptl);
+		return;
+	}
+
+	/*
+	 * For non PMD-sized folios zapping, concurrent zap_empty_pte_table()
+	 * may clear the PMD after the rmaps for the table have been removed,
+	 * but later mapcount reads could still be observed before the PMD
+	 * read, making the folio appear to be still mapped after unmapping.
+	 * Order the PMD read before later mapcount reads, so that observing
+	 * the cleared PMD implies observing the rmap removals.
+	 *
+	 * Pairs with smp_wmb() in zap_pte_range().
+	 */
+	smp_rmb();
 }
 
 struct zap_details;
diff --git a/mm/memory.c b/mm/memory.c
index 529a9189e426..dcf205175f71 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2054,8 +2054,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	 * Clear the PMD after the rmaps for the table have been removed, in case
 	 * an incorrect mapcount is observed after unmapping the folio.
 	 */
-	if (can_reclaim_pt && direct_reclaim && addr == end)
+	if (can_reclaim_pt && direct_reclaim && addr == end) {
+		/*
+		 * rmap changes need to be observed before page tables get zapped.
+		 *
+		 * Pairs with smp_rmb() in sync_with_folio_pmd_zap().
+		 */
+		smp_wmb();
 		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
+	}
 	pte_unmap_unlock(start_pte, ptl);
 
 	/*
@@ -2110,7 +2117,8 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 			/* fall through */
 		} else if (pmd_none(*pmd)) {
 			if (details && details->single_folio)
-				sync_with_folio_pmd_zap(tlb->mm, pmd);
+				sync_with_folio_pmd_zap(tlb->mm, pmd,
+							details->single_folio);
 			addr = next;
 			continue;
 		}
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index a931243ca42b..9b72ac408c70 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -294,8 +294,8 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		} else if (!pmd_present(pmde)) {
-			if (pvmw->flags & PVMW_SYNC)
-				sync_with_folio_pmd_zap(mm, pvmw->pmd);
+			if ((pvmw->flags & PVMW_SYNC) && pvmw->folio)
+				sync_with_folio_pmd_zap(mm, pvmw->pmd, pvmw->folio);
 
 			goto next_pmd;
 		}
-- 
2.47.3


