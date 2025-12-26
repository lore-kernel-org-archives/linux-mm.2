Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C20E82CDE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 06:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90AF6B0088; Fri, 26 Dec 2025 01:08:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68626B008C; Fri, 26 Dec 2025 01:08:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7BCA6B0088; Fri, 26 Dec 2025 01:08:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B51E56B0088
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 01:08:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C57B5C46B
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:08:14 +0000 (UTC)
X-FDA: 84260592108.30.4ED6239
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1A211180003
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:08:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vnS+3iCv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766729292; a=rsa-sha256;
	cv=none;
	b=ULX9EFQHsn4Tvz/e6qJWloZ/S5WmrqknIhylSeleSau72tmMkcrhI/VzWG7bAuWDp64SNJ
	tZAKqDY+lggcJDNmmQNMm1oOcUfEUQa4v9hWgSiLNNWJq4Aa988jHWt70ugJijCqQPaqwh
	GHbcw2nxc3uJIhvHzs50hkt/2uvQWyY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vnS+3iCv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766729292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQOblmo1Xq9Mi6sOjwcZDMqeM3HaJgfSORShcGuHoSU=;
	b=zmc7Yxo+l1cfyNcIw0FGLYwcrRliRPO4xJLwO5cVeCqXcJ3v9+VFoKdSLKq9aBxhxT0mTh
	8I7WNc3LwT1vw64h6DoOLvq+67Xi+q6NG+Ck4LtxQXGxyv2MI9ZkGjr3NH4dMRhK54SPPG
	Xn1q9omYVBLa06TO42iG38ipI5TaZwQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766729288; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=nQOblmo1Xq9Mi6sOjwcZDMqeM3HaJgfSORShcGuHoSU=;
	b=vnS+3iCvjs3clh6XTawuuD4lIJTLS7pDaqG5A5AZTg5ebZkf4W0ncmLcnbHQxm4UWkwnb22ZIot/GseB0htrHEkgKN9E+5uJDiNHU3MsCaZvlAM5OSXCxZNLLDcUvVbrIxkrGbmd0Qrn7Qd37IaYgCrO0n949cedMpmO67UiOXc=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvgaV0W_1766729286 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Dec 2025 14:08:07 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: lorenzo.stoakes@oracle.com,
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
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/5] mm: rmap: support batched checks of the references for large folios
Date: Fri, 26 Dec 2025 14:07:55 +0800
Message-ID: <18b3eb9c730d16756e5d23c7be22efe2f6219911.1766631066.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1A211180003
X-Rspamd-Server: rspam03
X-Stat-Signature: iehukuxjnuoetsj118umc3494h1oznjs
X-Rspam-User: 
X-HE-Tag: 1766729290-370250
X-HE-Meta: U2FsdGVkX19+gbCZwFZIUL8zC+8Y53tyWZKDynvgttwaRhISWuedAP2wa20cguWPBLRvfC7656dyQGlYZZAsl0MSd5vL+i6Hcj8lACP6dC4GUFR1sQSbQWjtvq8M04CWrmM0QYwZ+HUzD5FHgKwj/0CY/iCLTvNFGlh+9HFA/31CZOJQu28ABsE+Op5CoHCK9CigxRXebLKDFMdpqE93FiIQzu8KSf28DuJRWXTSYIUfskBbedCdAbCHw7HWOjvlGIPfT1dXbeu8LdyZ0x0kS8wUOwN+5QtbqsQQ1V36xG0AbliaGOE8YL39mVq4ShCql1uWz2UJomBR+IGVo3GvGaqlCkZ3FAJ2nU5RiOc/YUwSmEVdwWH+DJaDSj+Pt32TskL2jJ3J62tmY2uywAdXceDTdBWlWRK2QOaqL8htpHmh7WdzAq5fof15eY06+CHG5y5w+oNTYdbfQFL0MxmspGYHW/svwGnBGGfS4FlwcHZ/ORQ4ycuwPfyjaqbJKul+mzerQxm/qCNs7aJB/amKPp25JV7IjKfP+GbfRnaV7B3tnCgIdVK0HyAYyN4mnnSggQGj+CGBNmROcrZbXyZbfEP70ubo61cFPs4qDzT+WzfDXDpRXgf1KVJq8it+8j6J553MYoeapM7pCJ/iXDhKaRQZSS7V0vz+RS+rhDlYrUVSZfGV+Hh5RyABds8GiT05brUKYpPedCb6SLuEw5doYMos4T9eDGsMinB6fY2YGBdmqP5YjyDoZ2CQ6Zef+oGg/VOcXRmC9EhmYvVrqMso+lcf6NRAwpR4M7FQ8FLzkK9biRz2BtgnJjlxaOWt2KE7LOLNvBgjy5o4pqw405fqsSF73TsQGziycDEQavgWiGrizHIxDCGOz1iBl6/OyzhWCbOIzr/TvvM9UfG7afLcydlbapshxXf66iTsu+1hE2C8XUxhetsimWwpfjDiemKiAH1B6OwI48KyOgFRigD
 nIo3wPgr
 RF7u2JULQWx3Yzhv4KccD/XHvjS30L5CGucsDDKgDgcC1Gja2vD5SGrgMBZzQiJ9hLKquDnqhSGiVWl+Wogms6tysb+DGluBwGwEmVAE9kuzDB4NA1/Goq8AzunnkgrB4ymdGOkhvTIyJDZPpEAKYY1mj/kG6+WgN8YeMt2GPlAWSLR7EUiePCupgRo1hm6CRkSmiHV08Z4Xp8wJ8/JNHf1Y79s2XIGMj6tqiSi9Q0QwxoCEdHAe6/Uw+BSmlbdw3snJqa+yLhOgWRONdgpiDTKc5aZEHu08RXRcnwoKMg8tM084LAfeCF1zohJj4W6DOXvzO0HDDozDXyNTsi0qT1LDeS1Yc/gpC5EwN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, folio_referenced_one() always checks the young flag for each PTE
sequentially, which is inefficient for large folios. This inefficiency is
especially noticeable when reclaiming clean file-backed large folios, where
folio_referenced() is observed as a significant performance hotspot.

Moreover, on Arm64 architecture, which supports contiguous PTEs, there is already
an optimization to clear the young flags for PTEs within a contiguous range.
However, this is not sufficient. We can extend this to perform batched operations
for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).

Introduce a new API: clear_flush_young_ptes() to facilitate batched checking
of the young flags and flushing TLB entries, thereby improving performance
during large folio reclamation. And it will be overridden by the architecture
that implements a more efficient batch operation in the following patches.

While we are at it, rename ptep_clear_flush_young_notify() to
clear_flush_young_ptes_notify() to indicate that this is a batch operation.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/mmu_notifier.h |  9 +++++----
 include/linux/pgtable.h      | 31 +++++++++++++++++++++++++++++++
 mm/rmap.c                    | 31 ++++++++++++++++++++++++++++---
 3 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index d1094c2d5fb6..07a2bbaf86e9 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
 	range->owner = owner;
 }
 
-#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
+#define clear_flush_young_ptes_notify(__vma, __address, __ptep, __nr)	\
 ({									\
 	int __young;							\
 	struct vm_area_struct *___vma = __vma;				\
 	unsigned long ___address = __address;				\
-	__young = ptep_clear_flush_young(___vma, ___address, __ptep);	\
+	unsigned int ___nr = __nr;					\
+	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
 	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
 						  ___address,		\
 						  ___address +		\
-							PAGE_SIZE);	\
+						  ___nr * PAGE_SIZE);	\
 	__young;							\
 })
 
@@ -650,7 +651,7 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
 
 #define mmu_notifier_range_update_to_read_only(r) false
 
-#define ptep_clear_flush_young_notify ptep_clear_flush_young
+#define clear_flush_young_ptes_notify clear_flush_young_ptes
 #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
 #define ptep_clear_young_notify ptep_test_and_clear_young
 #define pmdp_clear_young_notify pmdp_test_and_clear_young
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 2f0dd3a4ace1..eb8aacba3698 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1087,6 +1087,37 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 }
 #endif
 
+#ifndef clear_flush_young_ptes
+/**
+ * clear_flush_young_ptes - Clear the access bit and perform a TLB flush for PTEs
+ *			    that map consecutive pages of the same folio.
+ * @vma: The virtual memory area the pages are mapped into.
+ * @addr: Address the first page is mapped at.
+ * @ptep: Page table pointer for the first entry.
+ * @nr: Number of entries to clear access bit.
+ *
+ * May be overridden by the architecture; otherwise, implemented as a simple
+ * loop over ptep_clear_flush_young().
+ *
+ * Note that PTE bits in the PTE range besides the PFN can differ. For example,
+ * some PTEs might be write-protected.
+ *
+ * Context: The caller holds the page table lock.  The PTEs map consecutive
+ * pages that belong to the same folio.  The PTEs are all in the same PMD.
+ */
+static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep,
+					 unsigned int nr)
+{
+	int i, young = 0;
+
+	for (i = 0; i < nr; ++i, ++ptep, addr += PAGE_SIZE)
+		young |= ptep_clear_flush_young(vma, addr, ptep);
+
+	return young;
+}
+#endif
+
 /*
  * On some architectures hardware does not set page access bit when accessing
  * memory page, it is responsibility of software setting this bit. It brings
diff --git a/mm/rmap.c b/mm/rmap.c
index e805ddc5a27b..985ab0b085ba 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -828,9 +828,11 @@ static bool folio_referenced_one(struct folio *folio,
 	struct folio_referenced_arg *pra = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	int ptes = 0, referenced = 0;
+	unsigned int nr;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
+		nr = 1;
 
 		if (vma->vm_flags & VM_LOCKED) {
 			ptes++;
@@ -875,9 +877,24 @@ static bool folio_referenced_one(struct folio *folio,
 			if (lru_gen_look_around(&pvmw))
 				referenced++;
 		} else if (pvmw.pte) {
-			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte))
+			if (folio_test_large(folio)) {
+				unsigned long end_addr =
+					pmd_addr_end(address, vma->vm_end);
+				unsigned int max_nr =
+					(end_addr - address) >> PAGE_SHIFT;
+				pte_t pteval = ptep_get(pvmw.pte);
+
+				nr = folio_pte_batch(folio, pvmw.pte,
+						     pteval, max_nr);
+			}
+
+			ptes += nr;
+			if (clear_flush_young_ptes_notify(vma, address,
+						pvmw.pte, nr))
 				referenced++;
+			/* Skip the batched PTEs */
+			pvmw.pte += nr - 1;
+			pvmw.address += (nr - 1) * PAGE_SIZE;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
 						pvmw.pmd))
@@ -887,7 +904,15 @@ static bool folio_referenced_one(struct folio *folio,
 			WARN_ON_ONCE(1);
 		}
 
-		pra->mapcount--;
+		pra->mapcount -= nr;
+		/*
+		 * If we are sure that we batched the entire folio,
+		 * we can just optimize and stop right here.
+		 */
+		if (ptes == pvmw.nr_pages) {
+			page_vma_mapped_walk_done(&pvmw);
+			break;
+		}
 	}
 
 	if (referenced)
-- 
2.47.3


