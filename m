Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C448E81BCC
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5D56B0093; Mon,  9 Feb 2026 09:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01DA6B0096; Mon,  9 Feb 2026 09:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02226B0099; Mon,  9 Feb 2026 09:07:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6DB6B0093
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:07:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55B40879FF
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:07:53 +0000 (UTC)
X-FDA: 84425096826.14.ED4619A
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf06.hostedemail.com (Postfix) with ESMTP id EB920180017
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:07:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pneERAOT;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770646071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svMvxcoEOwnxfPjspg+UHyXyu7rjBpbk7PZIuf8LnPs=;
	b=zL6Zmh6ZoVIMHqS9Jk5wTZ6DFBO+ckVGivebn6djiiIfeCSbHrTHZNTx0Kfgq+5mCyAHmm
	WZMBqPRukMkc+40RsOnReERmyz44DV4PWD3YIPIvSSwSnzx8iAnw1IN5Tg6ftNR1jSBcVy
	n2HxbSd28U5R7pWMr1+yXvYAyHB6zvc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pneERAOT;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770646071; a=rsa-sha256;
	cv=none;
	b=UQXJmf92afRuSoZbY9svgX0mvuxlrSHkdYR03DvEIkEbWLoPk7ZWi8qP37KMPacv6/VW4u
	B7Kj0+QRrfGGfpDad9QxzkGDDhSYgBHXuJXMK3V01avP9ludKFutLH64ZFroX1D3ho3Ec2
	SV+ynLgF6pIYJ/KPeL4Rh9ZtnHelmyI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770646060; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=svMvxcoEOwnxfPjspg+UHyXyu7rjBpbk7PZIuf8LnPs=;
	b=pneERAOTivNHaJQTqFGXweahV9+GcETQkGa7hCrhrq1Wow4qM95CX75jQ9hiL7EYMsPEXdRNy34o64v70pMD0ZPOS5aC3rBV2NWF2Mv075ZLVmKjDtStFvcPWRREH4hlPKkzA+Htfqzw6DHltro+/j45hAFi34mZpz0jKmxVfAg=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WytHTQS_1770646058 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Feb 2026 22:07:38 +0800
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
Subject: [PATCH v6 1/5] mm: rmap: support batched checks of the references for large folios
Date: Mon,  9 Feb 2026 22:07:24 +0800
Message-ID: <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB920180017
X-Stat-Signature: cydf1aayurpqeob5xrd3zqictdynx9d7
X-Rspam-User: 
X-HE-Tag: 1770646070-152268
X-HE-Meta: U2FsdGVkX19kx7T4I0Dzf87AzphwJkbigFpdwsQzXmJgR+LkUe05s8HqdusWKr/zKd29AQ9575HmV9s9l/tLuCcw3nnHrtmmywYBG7v8qIWmkoorQ1jf6WH+mCfkNWU38O7wxkxdbbnsyaIeokjCWstMMDjPZ+Yn00Nus4JKPr5YpwYXdtf3JGoCfRlfr+++ur0CdzWsy2zxpqnAd3iblUIHoU631XDqv1a3GaodkUd5ULj0A2he4RsCaU8nzgpGBaTSjxSxQ73ZS97ZeWBYUH8d5Y5jPIrxsZiCv2McN4R6SbaQ5f3wZBRw4e77c/cpeghKAmd23tVUO4+sAT7yLkSaLaP6fvixgXCCuQprNgk6rwM2FlLT9zmdE7WbrxsGhlhE+0NHGF8ZQ3zPhb1SEnIjTLIzZEiojX0d6w2r39kp5/l6wTFddOnVSfiSezAqvV/UsCF7wheM2Ac0qDufrk7apPdpVfo9HLzlEe/53RgDRs9bFB4iwtqtnJzN4Jmbo7wV2Bekde4mq6wOPr5O3LIKeYGR7DsVrO0pv0S1zuePKfiWxtYZqogSlHiwL/Qps8p5jm+ZKz4SR4nwfoagieej3x/goK7EboFmq0ofbu0LnnurVUoCoVfhkFsTKbHv/GVMYU9/j1QW2WbLpUmpp2mzcewwhcds2cqCnWjWjQH1Td2ASEOoPKcswakJ/yqhepXzn1cANycpYv1aIzI+i9fY7s0BAoSuEkXyQBekpXHRHs9P7Wb6CJymGICqUUWhDsh3VpjqO+5KA1XjNUjeoIr+wu26N+tk8cp98R650bi8cHNdp2DwdwIf1GibpznXQO3KYE0DKpEwN7AaFKVLGlDFkqFyl+B6S8Z5Av4BrKFZ7GhKGVbrV712ecGD0VSppvYA3CqjNLWFkOkqutOiYEgzWUczJSY2xmDNE2areHH0OeSf4ou1dcY6IK5Z6Kxj
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

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/mmu_notifier.h |  9 +++++----
 include/linux/pgtable.h      | 35 +++++++++++++++++++++++++++++++++++
 mm/rmap.c                    | 28 +++++++++++++++++++++++++---
 3 files changed, 65 insertions(+), 7 deletions(-)

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
index 21b67d937555..a50df42a893f 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1068,6 +1068,41 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 }
 #endif
 
+#ifndef clear_flush_young_ptes
+/**
+ * clear_flush_young_ptes - Mark PTEs that map consecutive pages of the same
+ *			    folio as old and flush the TLB.
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
+		unsigned long addr, pte_t *ptep, unsigned int nr)
+{
+	int young = 0;
+
+	for (;;) {
+		young |= ptep_clear_flush_young(vma, addr, ptep);
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
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
index a5a284f2a83d..8807f8a7df28 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -913,9 +913,11 @@ static bool folio_referenced_one(struct folio *folio,
 	struct folio_referenced_arg *pra = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	int ptes = 0, referenced = 0;
+	unsigned int nr;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
+		nr = 1;
 
 		if (vma->vm_flags & VM_LOCKED) {
 			ptes++;
@@ -960,9 +962,21 @@ static bool folio_referenced_one(struct folio *folio,
 			if (lru_gen_look_around(&pvmw))
 				referenced++;
 		} else if (pvmw.pte) {
-			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte))
+			if (folio_test_large(folio)) {
+				unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
+				unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
+				pte_t pteval = ptep_get(pvmw.pte);
+
+				nr = folio_pte_batch(folio, pvmw.pte,
+						     pteval, max_nr);
+			}
+
+			ptes += nr;
+			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
 				referenced++;
+			/* Skip the batched PTEs */
+			pvmw.pte += nr - 1;
+			pvmw.address += (nr - 1) * PAGE_SIZE;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
 						pvmw.pmd))
@@ -972,7 +986,15 @@ static bool folio_referenced_one(struct folio *folio,
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


