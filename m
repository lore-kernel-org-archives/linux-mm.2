Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2032D711CA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639FC6B0089; Fri, 19 Dec 2025 01:03:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57BE26B008A; Fri, 19 Dec 2025 01:03:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC506B008C; Fri, 19 Dec 2025 01:03:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1609C6B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:03:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BDB39140359
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:03:09 +0000 (UTC)
X-FDA: 84235177698.14.935A417
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf30.hostedemail.com (Postfix) with ESMTP id 87C8C80002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:03:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N+vQa3+C;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766124188; a=rsa-sha256;
	cv=none;
	b=gWlUi0LjM88iojHBfiuReohAV5BbTyw2+wjSKWbXEGgkw2hD8K/BZI8mhrJYU5YFK3niND
	Yzm1H7TC2+l3vAItBc7XnkPJN0i22kMLcNpAQPbltiEgUaIXCncxpBd1k+9jS57073Q6CD
	3XOtSYN41AFuyU91zjt16mcJ9aA7R2U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N+vQa3+C;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766124188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9nk8p1gEgDEfDsl6eOexaGSc82IGm5TOYQhnxb8huI=;
	b=3w/3uwZ+086yAbdabcsOe/sqFESKM68uASw64NE9UbrpouwNUQ/WGfWbD6yC/5avKfdSWc
	SB88eriQ4DaMl8mPZzhHQDiHaFm/zomLYvVkrQQmKY6SanjqJRGpdolKeg1xhxBK/ARXzk
	h1V/88GOJTYrAMwr5cI44aSXfxxRQdk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766124184; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=q9nk8p1gEgDEfDsl6eOexaGSc82IGm5TOYQhnxb8huI=;
	b=N+vQa3+CY9EQX1pBOKhWqQXucXq3g5BrgHQf+CAD6xJmLvZjTTxKs6F6VlKDdXfvrjsSf3SXt82G7kI7tiFkpZ998I5EP4jWtoJoeWM9CzdThyiF0PnIOAR7MU6Bq48Yx0FLnuKOQuMA5yhPg0tBeZvH2Yf5aWL0ge+43dkTHLA=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvBZ2GG_1766124182 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Dec 2025 14:03:03 +0800
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
Subject: [PATCH v3 1/5] mm: rmap: support batched checks of the references for large folios
Date: Fri, 19 Dec 2025 14:02:51 +0800
Message-ID: <24b9d33acad627997febe9b61d398fc53739a333.1766121341.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1766121341.git.baolin.wang@linux.alibaba.com>
References: <cover.1766121341.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 87C8C80002
X-Rspamd-Server: rspam04
X-Stat-Signature: 1t8qrpys654a1sctidkbh8eqh71t3fnq
X-HE-Tag: 1766124187-10507
X-HE-Meta: U2FsdGVkX197JdEpmHTGyvuWp8ctI1wYgjJOLdwN9GYH/Jzo6lL5/NkXKvYWs/ks9qvIWnJxRxSGWCRiKuXeYRcJKezmGg027jbCAlgW3yhz3LZ8w8SmGXz07cPxJ0YXzMoQUBWwF6wT8pOKL2WxzctnnZSn+cUdpZhBNIX5QO+hM/mOi2sL0QGzYUUUL5LlZjyK35cs56OKOhc6ZNW2ZhQz4EYBvO6EnwEU5EHopq8xfYLYh/+Rp9BFwYvLSbnNGN8pWApQuWCRsmST3wX8HJh8aey9godm3rmpHaMuNHD7uEEkKHiJB1pOBRSSv27Y4cn8yVIKmnbLp0IS422o8rR7SS7OSDPKk90PO0CdnPciZCqd7q0Z68JTlFr89LK76/ycH0nBRJsCboCOo2fksjByWNLYQ/ZPqsWHUJ/TS1OQ9J2v64bjreso1WFeHbf/sMeszij4kaW0l/aD1+v0iOTE2rVNttP8JqkPblk67JlnhFXB43Ccf2ycjOalJqrb7AZ/RTf+6hPdTm180wfHCwqO0yOm/T0rBHiWtVWA0qxqOrx99wZ2HyBnU7q0oIG9eIlOcP30O/TU9Zk0xw0a9ZlKHAi1BC3vxySuaqCG5WyJyP2k1Ed9uWi1eWqw5nbFPAr9hsguomV97R/DqInl5pQMC28GPPsraExRxfc56zGT18VEz1WWpSxzZT+YLEOYxwQ1C9JQbH9D6mw67/D0EKCmNtEXhqYWGsPcQ3BtQUI/r2E1cJobSa4azEV6ka44ybQJk9825FfE64hmg8gG+ufU8Wr1sKw/84HxwlNTF7GOJp09YR2rnoPNk3zTvkn2ic6Yft/ohUDrVzeoir5ujv9ek1tHQvK4+KKcOrs2kf4RXpFBIeDUnDBD0G4VTB3tEb3Tm+QbAwmfMuJCpkDnm4GUIwmZj8/1JqaCrT+VL/atmqsE9350zPiszAt2MVqvgfmqEi9H6QTm2pSOBRk
 c+w/v4bh
 AAFYIteJ9zsb7Ru2KW+wA0T6mIoaltdByP6JHZJF7iQyFsPhQMCvYr8zfymMlu8m3DNAg8vcboHPvg9M+WPWhojqydo4u8rRXGnyFH4TfLwzgbZG3FjWuDXOpDDEnePp6R5dViphgWbCUHmU2gLc3jewWXwtOLiN31JvXm7FGhPFVLdtXr7UIqaDGQV2J9GYgRMu4D6Gy7tuM9tOAjNuR91CQzjgkgIgooZJq6dcGnyiH5iDZHOeaf2kQkQNYHCJCRKH2Dq29HfZHxMTBOI2W0hRq2VjEwzrC712V
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

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/mmu_notifier.h |  9 +++++----
 include/linux/pgtable.h      | 35 +++++++++++++++++++++++++++++++++++
 mm/rmap.c                    | 29 +++++++++++++++++++++++++++--
 3 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index d1094c2d5fb6..be594b274729 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
 	range->owner = owner;
 }
 
-#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
+#define ptep_clear_flush_young_notify(__vma, __address, __ptep, __nr)	\
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
+						nr * PAGE_SIZE);	\
 	__young;							\
 })
 
@@ -650,7 +651,7 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
 
 #define mmu_notifier_range_update_to_read_only(r) false
 
-#define ptep_clear_flush_young_notify ptep_clear_flush_young
+#define ptep_clear_flush_young_notify clear_flush_young_ptes
 #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
 #define ptep_clear_young_notify ptep_test_and_clear_young
 #define pmdp_clear_young_notify pmdp_test_and_clear_young
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index b13b6f42be3c..7e659f4171e2 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -947,6 +947,41 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
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
+	int young;
+
+	young = ptep_clear_flush_young(vma, addr, ptep);
+	while (--nr) {
+		ptep++;
+		addr += PAGE_SIZE;
+		young |= ptep_clear_flush_young(vma, addr, ptep);
+	}
+
+	return young;
+}
+#endif
+
 /*
  * On some architectures hardware does not set page access bit when accessing
  * memory page, it is responsibility of software setting this bit. It brings
diff --git a/mm/rmap.c b/mm/rmap.c
index d6799afe1114..a0fc05f5966f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -827,9 +827,11 @@ static bool folio_referenced_one(struct folio *folio,
 	struct folio_referenced_arg *pra = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	int ptes = 0, referenced = 0;
+	unsigned int nr;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
+		nr = 1;
 
 		if (vma->vm_flags & VM_LOCKED) {
 			ptes++;
@@ -874,9 +876,24 @@ static bool folio_referenced_one(struct folio *folio,
 			if (lru_gen_look_around(&pvmw))
 				referenced++;
 		} else if (pvmw.pte) {
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
 			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte))
+						pvmw.pte, nr))
 				referenced++;
+			/* Skip the batched PTEs */
+			pvmw.pte += nr - 1;
+			pvmw.address += (nr - 1) * PAGE_SIZE;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
 						pvmw.pmd))
@@ -886,7 +903,15 @@ static bool folio_referenced_one(struct folio *folio,
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


