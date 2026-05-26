Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6279FCD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C76816B0098; Tue, 26 May 2026 02:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C27D16B0099; Tue, 26 May 2026 02:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3D866B009B; Tue, 26 May 2026 02:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FCDF6B0098
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:37:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 642A91402B1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:37:37 +0000 (UTC)
X-FDA: 84808614954.26.48847D3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id B9AEB100005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:37:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ixieteNT;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779777455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4N3hwYLSkXbxPRbQp1hYA6wKfh2VAJdfEtMNmqBA+O0=;
	b=RCBzYjKW0hrQImBd0bLu0+s/450Qx9RHeUAUAlcJEJkG9ne/Wk8+yFnmrhn3Ub581RONXc
	3qcgtQBS3PrhJ7oalYV5/d+T4aUSlyVUBwNwfbGi3tUybmnEeOFtNxPyKRTdUSC1FCp1fo
	uXNu0JMdJyxXJhvOOLaoEOquK0VatjQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779777455; a=rsa-sha256;
	cv=none;
	b=fuT1PqxNw8ldBuZIpewP0aVuw6T0fJpnwkDXiiekdW4EmDRx7Du0xmODeDQwYHfZ0LSxlq
	gpXTJzgiN0yAabtZ2NWyqDaegsrMJigm9seg49T0Wgq475HVE5k9+pJMMO1TUGWW+ijKQL
	XVAKh02YmhrkJ8+/H+fOWHBo3ZBf9NM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ixieteNT;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C861816F8;
	Mon, 25 May 2026 23:37:29 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 339BD3F7D8;
	Mon, 25 May 2026 23:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779777454; bh=s2G7rZGj9dnI4GOUaOVUtLXJX38iPpYsyXE519Mg9jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixieteNT5AHRreFsKcE8P0vQ1MhVjUa9aWKpq7LXhzzWKF7m9BufjxIQnMhHIhZId
	 kZ248APRVGyJ+RKaf3O2CKfRkeF7hnVHu/MhtmAKGE7SycI9p8uJL+EX35NzhynWNU
	 XqLgKTS4Bhd5twszpcS5UTZPpbPKJ064cL/ihVcM=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 04/12] mm/memory: Batch set uffd-wp markers during zapping
Date: Tue, 26 May 2026 12:06:27 +0530
Message-Id: <20260526063635.61721-5-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526063635.61721-1-dev.jain@arm.com>
References: <20260526063635.61721-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B9AEB100005
X-Stat-Signature: gw9et3gdxcibgaipegqrxy7jyp5xsu76
X-Rspamd-Server: rspam06
X-HE-Tag: 1779777455-70828
X-HE-Meta: U2FsdGVkX1+PVekNAC3T17y7Eeh0/vaZ6Up7zcyF6PcM7Vw60wGfx27GHSoqDObrK1xEhTB2FwrhRlHXkiShW8Ksl95fSA3j0kiSTImqaBIQJ6JbXdAKxt8Qxo8+wnQzg0pNI5LF8w9zSJEriWYpOxR/ZGC4JbK0otjzVIFKiVGO+XzCZHLRfxu8gXkGaVQtM7CPz5JQLomYXn+Jvr6QL0CmkMqlZ44Br+07OM18Esi150uNOd0A+A1LjZnjcEbCDWKpfjPd7NIHnfUE9IEVYbrC3zTaDhBhkKuKTy64iPpj/CnCOShx1StHuX3AWhphDbCK54Spm1NFTVTbNKiHnfa9daCLvWPtnWAb7cHcYa9r5HUDSKuA2gxwKmroEJ8R+HRDhSkubcX+o/4sNjSHubHs6Zr2C+yKgOxSLoIQxTh3xAmZjz2w4jPlRSPehhh27GNvVmY7M2qt9uVnTLU6Af4YtDSoqQlQ/YLTFUqicAJq1XwQfdimZB0iGJncPRZshPWORs/DiV490YskEX++XCGDaf9oa841XHaIEhlNfwkv4kovMwRkHMYRHNFW0ZrbSHlzF/TdBej3aXDiFETXPRY1PR4LR6O06LgFXcsnCa72opPDLvV2/niLMBgoG+rIAkEKt0bkW4ZHOHK6LQAhIq2ZHxFSqMaNNJagm/Qmat9uTDaQviK0JwT99/IOzPC6LaprFzCmAou1PSqdjFeTvqWmh6ep/nQPBBvX0dRhBRXrhVajKO2roJm7bT5b3PjKoRrDumPO5ULLz6AIEb9KeWW1hOwYKJBmBMoJMZT8FDBQbQymEsoJTaOy1C8L7Xq3Ar/A29igth9Kw7DBf0nbq1Gb7NCjjd/ZIVBWxnK1xu/ns7y2MEZugLXcPhsEH40YgTC81HZKCDGVANccgVotmVPr3yETrXVNTi98bGjZg/w3YYmm2OKfDeJt3eWflzSn3BdvD6BAj+JXUghU+4I
 DVBoflNM
 cqrDAGfJ995nahbu5ioh0+189K17MnjhMW0KQQd4ShxjoJp6BqmdiLOPT0ys3xr0Vj0OSDF5IkJx2n/G+FN6fmaWF6qPOdUU466wq3+TjRsElqKhCPk9pFnAczj0Rn92KMrYkuLVfV/8mrxlrze7TSjGBGdyItMtPvHPbxq3D/ITT7IjMiG1vGW3Fby3wn/xX0H0EKLRuD1M2QoQpnUUbtTDLhvgSVpgsrO2+Ea9Qr/ogzGkRhWlA3sirdTUHBMORaQKWsXLepkCX59iyvTyWP46Zgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for the next patch, enable batch setting of uffd-wp ptes.

The code paths passing nr > 1 to zap_install_uffd_wp_if_needed() produce
that nr through either folio_pte_batch or swap_pte_batch, therefore
batching is correct:

1) all ptes belong to the same type of VMA (anonymous or non-anonymous,
   wp-armed or non-wp-armed)

2) all ptes being marked with uffd-wp or all being not marked (same is the
   case with the pte_swp_uffd_wp_any check)

3) uffd_supports_wp_marker() is independent of the function parameters

Note that we will have to use set_pte_at() in a loop instead of set_ptes()
since the latter cannot handle present->non-present conversion for
nr_pages > 1.

Rename the function to cond_install_uffd_wp_ptes, and convert the
documentation to kerneldoc format.

Move the function to memory.c since this has grown too long to be kept
in mm_inline.h, while retaining the inline hint.

Rename pte->ptep and pteval->pte.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/mm.h        |  4 ++
 include/linux/mm_inline.h | 53 -------------------------
 mm/memory.c               | 81 ++++++++++++++++++++++++++++++---------
 mm/rmap.c                 |  2 +-
 4 files changed, 67 insertions(+), 73 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 31e27ff6a35fa..3169bd6d69f5a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5216,4 +5216,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
 		struct vm_area_struct *vma, unsigned long addr,
 		bool uffd_wp);
 
+bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma, unsigned long addr,
+		pte_t *ptep, pte_t pte, unsigned long nr_ptes);
+
+
 #endif /* _LINUX_MM_H */
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index a171070e15f05..1a65c2bda2398 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -566,59 +566,6 @@ static inline pte_marker copy_pte_marker(
 	return dstm;
 }
 
-/*
- * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
- * replace a none pte.  NOTE!  This should only be called when *pte is already
- * cleared so we will never accidentally replace something valuable.  Meanwhile
- * none pte also means we are not demoting the pte so tlb flushed is not needed.
- * E.g., when pte cleared the caller should have taken care of the tlb flush.
- *
- * Must be called with pgtable lock held so that no thread will see the none
- * pte, and if they see it, they'll fault and serialize at the pgtable lock.
- *
- * Returns true if an uffd-wp pte was installed, false otherwise.
- */
-static inline bool
-pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
-			      pte_t *pte, pte_t pteval)
-{
-	bool arm_uffd_pte = false;
-
-	if (!uffd_supports_wp_marker())
-		return false;
-
-	/* The current status of the pte should be "cleared" before calling */
-	WARN_ON_ONCE(!pte_none(ptep_get(pte)));
-
-	/*
-	 * NOTE: userfaultfd_wp_unpopulated() doesn't need this whole
-	 * thing, because when zapping either it means it's dropping the
-	 * page, or in TTU where the present pte will be quickly replaced
-	 * with a swap pte.  There's no way of leaking the bit.
-	 */
-	if (vma_is_anonymous(vma) || !userfaultfd_wp(vma))
-		return false;
-
-	/* A uffd-wp wr-protected normal pte */
-	if (unlikely(pte_present(pteval) && pte_uffd_wp(pteval)))
-		arm_uffd_pte = true;
-
-	/*
-	 * A uffd-wp wr-protected swap pte.  Note: this should even cover an
-	 * existing pte marker with uffd-wp bit set.
-	 */
-	if (unlikely(pte_swp_uffd_wp_any(pteval)))
-		arm_uffd_pte = true;
-
-	if (unlikely(arm_uffd_pte)) {
-		set_pte_at(vma->vm_mm, addr, pte,
-			   make_pte_marker(PTE_MARKER_UFFD_WP));
-		return true;
-	}
-
-	return false;
-}
-
 static inline bool vma_has_recency(const struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))
diff --git a/mm/memory.c b/mm/memory.c
index 0c9d9c2cbf0e0..767c033e95da9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1599,6 +1599,67 @@ static inline bool zap_drop_markers(struct zap_details *details)
 	return details->zap_flags & ZAP_FLAG_DROP_MARKER;
 }
 
+/**
+ * cond_install_uffd_wp_ptes - install uffd-wp marker after clearing PTEs
+ *			       that mapped consecutive pages of the same
+ *			       large folio.
+ * @vma: The VMA the pages are mapped into.
+ * @addr: Address the first page of this batch is mapped at.
+ * @ptep: Page table pointer for the first entry of this batch.
+ * @pte: old value of the entry pointed to by ptep.
+ * @nr_ptes: Number of entries to clear (batch size).
+ *
+ * If the ptes were wr-protected by uffd-wp in any form, arm special ptes to
+ * replace none ptes.  NOTE!  This should only be called when *pte is already
+ * cleared so we will never accidentally replace something valuable.  Meanwhile
+ * none pte also means we are not demoting the pte so tlb flushed is not needed.
+ * E.g., when pte cleared the caller should have taken care of the tlb flush.
+ *
+ * Must be called with pgtable lock held so that no thread will see the none
+ * pte, and if they see it, they'll fault and serialize at the pgtable lock.
+ *
+ * Returns true if uffd-wp ptes were installed, false otherwise.
+ */
+inline bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma, unsigned long addr,
+		pte_t *ptep, pte_t pte, unsigned long nr_ptes)
+{
+	bool arm_uffd_pte = false;
+
+	if (!uffd_supports_wp_marker())
+		return false;
+
+	/* The current status of the pte should be "cleared" before calling */
+	WARN_ON_ONCE(!pte_none(ptep_get(ptep)));
+
+	/*
+	 * NOTE: userfaultfd_wp_unpopulated() doesn't need this whole
+	 * thing, because when zapping either it means it's dropping the
+	 * page, or in TTU where the present pte will be quickly replaced
+	 * with a swap pte.  There's no way of leaking the bit.
+	 */
+	if (vma_is_anonymous(vma) || !userfaultfd_wp(vma))
+		return false;
+
+	/* A uffd-wp wr-protected normal pte */
+	if (unlikely(pte_present(pte) && pte_uffd_wp(pte)))
+		arm_uffd_pte = true;
+
+	/*
+	 * A uffd-wp wr-protected swap pte.  Note: this should even cover an
+	 * existing pte marker with uffd-wp bit set.
+	 */
+	if (unlikely(pte_swp_uffd_wp_any(pte)))
+		arm_uffd_pte = true;
+
+	if (likely(!arm_uffd_pte))
+		return false;
+
+	for (int i = 0; i < nr_ptes; ++i, ++ptep, addr += PAGE_SIZE)
+		set_pte_at(vma->vm_mm, addr, ptep, make_pte_marker(PTE_MARKER_UFFD_WP));
+
+	return true;
+}
+
 /*
  * This function makes sure that we'll replace the none pte with an uffd-wp
  * swap special pte marker when necessary. Must be with the pgtable lock held.
@@ -1610,29 +1671,11 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
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
+	return cond_install_uffd_wp_ptes(vma, addr, pte, pteval, nr);
 
-	return was_installed;
 }
 
 static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
diff --git a/mm/rmap.c b/mm/rmap.c
index 12bbee57f20da..6a0b43856d6c0 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2288,7 +2288,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
+		cond_install_uffd_wp_ptes(vma, address, pvmw.pte, pteval, 1);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
-- 
2.34.1


