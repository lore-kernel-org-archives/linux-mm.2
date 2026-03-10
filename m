Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CAFDFCC9D4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 07:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C5AF6B0095; Tue, 10 Mar 2026 03:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87C816B0096; Tue, 10 Mar 2026 03:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79C586B0098; Tue, 10 Mar 2026 03:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2236B0095
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:31:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A12BB7285
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:31:26 +0000 (UTC)
X-FDA: 84529332972.08.1284217
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 95411140007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:31:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773127884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1rfwIL83JExvpklptFY4LpE1LFU0UT9Iqt2a+tWjHf0=;
	b=PPmASpOZeD9EyXyKThYjy2xyIrj5HbGCSaldDtDTTcGeiXoUNDhQpMYN+WRSMMHXuo9qPR
	2Emz3Vu4MqPKJXTqY8gg/O7iiwZHpFY6q7+NyHLKqSbmlkYp5EeA/vx4HE+FyaZUuW8siR
	VFrjbOa+Vi9ZdE8P9RDMrDo6NnAleEA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773127884; a=rsa-sha256;
	cv=none;
	b=kKqSxKLeMt/L9AuPbQVW09jcvNHhmh19AuAYisfL85DcH0bCGziyKqq63fPnRxPEolzvL/
	oAn+f3eXConZ/EHiwof/XzLT1rzkUFbR6Yj9PBokidlbnweDY6QNI8N0jJl0cBErg2+L/W
	BfPONES4CEHOg3NDk9qtxRqSoM71IBQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A178A1756;
	Tue, 10 Mar 2026 00:31:17 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 075CF3F73B;
	Tue, 10 Mar 2026 00:31:14 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: weixugc@google.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	ziy@nvidia.com,
	kas@kernel.org,
	willy@infradead.org,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH 4/9] mm/memory: Batch set uffd-wp markers during zapping
Date: Tue, 10 Mar 2026 13:00:08 +0530
Message-Id: <20260310073013.4069309-5-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260310073013.4069309-1-dev.jain@arm.com>
References: <20260310073013.4069309-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 95411140007
X-Stat-Signature: b8ub9pk9xy3cmg9umasm45htke69myt9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773127884-107548
X-HE-Meta: U2FsdGVkX19h4KY0I7oD4qd9UvMzY4fNl1B+pE81CTAUd/Mzyvv2M+Rw/TtUd4fSka5gDBWrrBjft7hyWQkQhkYSdLXYzqWdtrqOTMJsTea0SnqTvLbClluVTF3H2RtSc8Vb3ZAVd7hGRYaFA/6QdJRk0aCKiuk2fN/TM/lrkPmr/4bZi/msWVupaechRkcqUKem+VqpKed52I7ROKfT2hPIGkRGgiD1sO2soar7xLE0nwcxuPCMy/bGTsoV27Y2lbOgBSO9AU2o8qb8vPPMW5jK1B57HbA9Wc4bX5cMK/bpl/4D6kFpyq2ulpmVoMU1+MgvQLrBEQQowSIgAjsyLr5KZEjGUiw9xGODSbkpFIt4i+1QEKv0GDQSMzEggNWlYnmlYVS6N5MZW/ZJZUbNKdXceIjM6kZhBSvn96IKgLHJxbSCtLBsBK5t2w+sHF5Kw/5NqOkrfOlCoxba0gMxySEDUTTmzhuU+5o4JJdDWJS9ksfYfUNUyet/0gFlDSTU/RQqCzepf6Km3EerwxyLLv7fQdNUzV1wAe0ZsURvmTx9Y6/1tO/wPBJXaFRfd5jaYTFZAKikE0HKyjmvPt/zrxHkRxAA68f/zHw5O1q8sBsu3WO54QPmapSivXXROFnRi9uAfrhTMefthiaTAYpCCdf3+Dh1x+TtcW554gr5rOqQesstgL0MGpJA60Mk8hAL2rup8I/gH67vxJD9ZosZdEBZSrFBN2YEFGOf9cDDtToaBcSkjJCe9HldynUfD+o6M96P3OsnojM3qA/Zy4p176T99Zo3ZOt5USGpSkyi09NPvBayIzSa55PhBwPaBP0aXcSoGu/9hrUT0RmYXhees3GnksuCrSypbHsm84FZDUxfnsyLKvtFNcilFJcg+3z/CiOy1bpEUiypWz9fIZYMJ9LpmmSR7yY+xVzAvZb34nMVIMBUrUBSIMs1h4aOFkzR1pcEhRgVZf/BWjjY6bB
 NWPeLWVu
 Onety37WBGs8qdghaBYZ8JT1AWgparqquKKh3JIpkFXQ5EjqlilXr6+QjYbZvNz07kjDrPGfiAhGzADFD0W3tySJN47GeWMq4aPOIEtWR0bhPLAgsicnbpt0jEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for the next patch, enable batch setting of uffd-wp ptes.

The code paths passing nr > 1 to zap_install_uffd_wp_if_needed() produce
that nr through either folio_pte_batch or swap_pte_batch, guaranteeing that
all ptes are the same w.r.t belonging to the same type of VMA (anonymous
or non-anonymous, wp-armed or non-wp-armed), and all being marked with
uffd-wp or all being not marked.

Note that we will have to use set_pte_at() in a loop instead of set_ptes()
since the latter cannot handle present->non-present conversion for
nr_pages > 1.

Convert documentation of install_uffd_wp_ptes_if_needed to kerneldoc
format.

No functional change is intended.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/mm_inline.h | 37 +++++++++++++++++++++++--------------
 mm/memory.c               | 20 +-------------------
 mm/rmap.c                 |  2 +-
 3 files changed, 25 insertions(+), 34 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ad50688d89dba..d69b9abbdf2a7 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -560,21 +560,30 @@ static inline pte_marker copy_pte_marker(
 	return dstm;
 }
 
-/*
- * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
- * replace a none pte.  NOTE!  This should only be called when *pte is already
+/**
+ * install_uffd_wp_ptes_if_needed - install uffd-wp marker on PTEs that map
+ *				    consecutive pages of the same large folio.
+ * @vma: The VMA the pages are mapped into.
+ * @addr: Address the first page of this batch is mapped at.
+ * @ptep: Page table pointer for the first entry of this batch.
+ * @pteval: old value of the entry pointed to by ptep.
+ * @nr: Number of entries to clear (batch size).
+ *
+ * If the ptes were wr-protected by uffd-wp in any form, arm special ptes to
+ * replace none ptes.  NOTE!  This should only be called when *pte is already
  * cleared so we will never accidentally replace something valuable.  Meanwhile
  * none pte also means we are not demoting the pte so tlb flushed is not needed.
  * E.g., when pte cleared the caller should have taken care of the tlb flush.
  *
- * Must be called with pgtable lock held so that no thread will see the none
- * pte, and if they see it, they'll fault and serialize at the pgtable lock.
+ * Context: The caller holds the page table lock.  The PTEs map consecutive
+ * pages that belong to the same folio.  The PTEs are all in the same PMD
+ * and the same VMA.
  *
- * Returns true if an uffd-wp pte was installed, false otherwise.
+ * Returns true if uffd-wp ptes were installed, false otherwise.
  */
 static inline bool
-pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
-			      pte_t *pte, pte_t pteval)
+install_uffd_wp_ptes_if_needed(struct vm_area_struct *vma, unsigned long addr,
+			      pte_t *pte, pte_t pteval, unsigned int nr)
 {
 	bool arm_uffd_pte = false;
 
@@ -604,13 +613,13 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 	if (unlikely(pte_swp_uffd_wp_any(pteval)))
 		arm_uffd_pte = true;
 
-	if (unlikely(arm_uffd_pte)) {
-		set_pte_at(vma->vm_mm, addr, pte,
-			   make_pte_marker(PTE_MARKER_UFFD_WP));
-		return true;
-	}
+	if (likely(!arm_uffd_pte))
+		return false;
 
-	return false;
+	for (int i = 0; i < nr; ++i, ++pte, addr += PAGE_SIZE)
+		set_pte_at(vma->vm_mm, addr, pte, make_pte_marker(PTE_MARKER_UFFD_WP));
+
+	return true;
 }
 
 static inline bool vma_has_recency(const struct vm_area_struct *vma)
diff --git a/mm/memory.c b/mm/memory.c
index 38062f8e11656..768646c0b3b6a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1594,29 +1594,11 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 			      unsigned long addr, pte_t *pte, int nr,
 			      struct zap_details *details, pte_t pteval)
 {
-	bool was_installed = false;
-
-	if (!uffd_supports_wp_marker())
-		return false;
-
-	/* Zap on anonymous always means dropping everything */
-	if (vma_is_anonymous(vma))
-		return false;
-
 	if (zap_drop_markers(details))
 		return false;
 
-	for (;;) {
-		/* the PFN in the PTE is irrelevant. */
-		if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval))
-			was_installed = true;
-		if (--nr == 0)
-			break;
-		pte++;
-		addr += PAGE_SIZE;
-	}
+	return install_uffd_wp_ptes_if_needed(vma, addr, pte, pteval, nr);
 
-	return was_installed;
 }
 
 static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
diff --git a/mm/rmap.c b/mm/rmap.c
index a61978141ee3f..a7570cd037344 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2235,7 +2235,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
+		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, 1);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
-- 
2.34.1


