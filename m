Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8681E6B275
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 05:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3816B0089; Tue, 23 Dec 2025 00:48:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877886B008A; Tue, 23 Dec 2025 00:48:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7835E6B008C; Tue, 23 Dec 2025 00:48:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B27A6B0089
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:48:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E33291604B9
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:48:51 +0000 (UTC)
X-FDA: 84249656862.29.A1E84BE
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id E91E320004
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:48:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=g6gq2CKe;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766468930; a=rsa-sha256;
	cv=none;
	b=SYT5CH71uvWcFPZV77rru02WGb4fCZBsHiPUMC2aTml0o4bs2F5jGMs7HPUg1uRP7RIqTw
	PHsLmYZ/L8KsYDyNFFwO0+pNHoZMIjTF9hRR1xGsiQBH977XYxWkIlm1e5sUxABZZfadIL
	XCdQRLnVJ6iSXXuIe+HjclyMr+pr93Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=g6gq2CKe;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766468930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSFx6Rnw8Uesz11I46fNYvPpzwOjE58x5E7aQ6mIcqg=;
	b=JdpgZSP/r947/FqV6MxgY/iDi5JtSoWi2jCBuiLNurXYFN8nCu3KRI0GKXkH1a/Wui50/T
	Zx9GsZb+dN2bRmluRk638cRlTtnFsYauzXMxVUaGJO6lqfulNYSyu9Z60juLGt6+C9G3oG
	IPIb+JoKgOdEh+lHGzQgau3qWP7QnUM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766468927; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=MSFx6Rnw8Uesz11I46fNYvPpzwOjE58x5E7aQ6mIcqg=;
	b=g6gq2CKeFqVx4y++CgV+ALVWKUJ8AELl0QykvoEhHpYuDyEpV3ILTu4L/RzrJQmueNpZvwToFgURtm3ciDewiUoBPvpiCcD625wAWp9ULCQJnpmc5zAGRPFyTeJKpkbgZ9Wd2CE5b3Fxsg1SyxJyPGo3kZV8HB4I9QQcjqK2uaw=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvWSzFR_1766468925 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Dec 2025 13:48:45 +0800
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
Subject: [PATCH v4 1/5] mm: rmap: support batched checks of the references for large folios
Date: Tue, 23 Dec 2025 13:48:35 +0800
Message-ID: <e9ff5fa689740f3b6f3ed1c1ec0e3244f20c1f06.1766455378.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
References: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E91E320004
X-Stat-Signature: 3qc1gwsb1ficjc5kprsyqkssus5f14c3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766468929-288142
X-HE-Meta: U2FsdGVkX1+G6DcOCKL535KqzLzLFHawfcC4Pn12YpPtwpl0JSi8w5yJ1VPnn5duC1DOwx86PvjDXg5M457vt/ezTa3wlHDszPWHNLeBHgc+yBOW8k2oNfi8bv0dx9esWBJde+qySpmytocewPbAIpnZjb6fdv0k4y+8y2wTIhLNVS95j0WJq8gYK1smWcV0AZ9W21yehu7TsvR1zaHnuIM02axDcuJeqzt2IaFvaQ71TnuQFDespBp41ucNULTWN/f6DgDGjrkkRtmDD2Iy58j28WyA2+2gboXKab50fpEKGqnPkTcPMCggpbtzV8kU37dZRV5M+fGfXMz4SD0tjJLthYcri+Ne3oAMZ7at0tfYD1nZC5hEaOToFKmfYJRh5jWaur6T0Il1bthorikMWz+3VKRxHThEELx5qvDZvXjg5kROzxiBckCsn9hUq2Z4LBV8+MX3G/YCwoD6oaDVIdvtv5ptNIhIOdTMGAtc8d5wXI13EOTQpADI94lN8sdarkG7KH/7N6WgjYYKhd8CgsjPDZeP9lIAP29qMCquOpaPfmSSS9VpJQ35YwvTp3N318kuVa6JrlsFS6e4ySnrpZsA6LblD7kOYAd1VqTACbW6c1V2tD4DTdjbX644u3ZnR32U7FbQFk2Se6n7L6ueP7IIE5V05oXMBs/LGRtj+kzvDYsLmWb+Viy9V5mZsYg5jvDFTKNtIss/WSLxk7czCDPjD9aa/JR/3rfkTUdQoCqXFdU+LsANr+6w9ZpkkHXK1pxk+nC9FgbhT36Wbl+4saf1Wu67ApZfAdlDluw5LGn5Wzq6l2Q5HIEjRHVSesspLP9Zfy9WX6Ia/lA+jO7U2PUs+NIupxnCd3zE7BkoGdYYfR6B6RE/IsbcYD+t+/U7vIRpbzCHwVLhSwmxYmKI9XLW4HsdLlypfCQaPlLKjo3U+XAHhUdc+/kB3NEdmx1yzEpgA5lYSlwn0IKOvnY
 DJ/u1jRz
 tXgtnp7NwEUPE8JzPUMVg5EwudSQy/0OdCAaE+AUCq43P094id6WBMFRbwBSmgSmuCdI3eY6cKySf4dyWO7H6zTkYm2m90y4E3TG4W+KqT7OK8fLH2YxphVi5N4Z3+URUn7xhGEZ+wnHw0ouuuhh7pwZM9V3gXzXRKSwH6S3leX9CrAla6RN9MnR/E9dZ10uEp7Tlz/rJGK6Wo6RLrvLN9Y1aJbuXNU6O5daNH1LZWGHmyWMz+uQZWHrP21pcjOlS+P5MaCb0qVkIFvBCFdsjJ6/yjlelkcsYMGUY
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
index d1094c2d5fb6..dbbdcef4abf1 100644
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
+						  ___nr * PAGE_SIZE);	\
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
index 2f0dd3a4ace1..fcf7a7820061 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1087,6 +1087,41 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
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


