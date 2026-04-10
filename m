Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77574E9907D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3FCE6B0093; Fri, 10 Apr 2026 06:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0106B0095; Fri, 10 Apr 2026 06:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7FA6B0096; Fri, 10 Apr 2026 06:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B9A1C6B0093
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:32:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 670561A04E7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:32:58 +0000 (UTC)
X-FDA: 84642283236.15.7EA8E16
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id A1056100002
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:32:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b6+PS95B;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775817176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/5NhYRhCl03q3pihSWe7ft1L9If9GlP2tUY3dmxXxE=;
	b=bo8BX+lSWM0baTbICO7YRinJXNFTcbBx6N11jBL/SiLOecbm6wWdWxm4AZPNChiDmug/Vg
	Z5Ieqic+QVlnliXgumGMY4XauVQUqP64va4Dzrvr/NDjmrsic2kpOGPVe1o1KWwLtOxD2L
	HTmmXKdBKoHLK/+CntCYFJk6DdN+LMU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b6+PS95B;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775817176; a=rsa-sha256;
	cv=none;
	b=WIw78sOHzqscquHs/1ANl7iy+CHN6ClZBvnjJkdXHJFHx9LaXMBU22AzgoAplwPtaoBFQR
	GEnI20AQydeOX44Z/H86OJs9yx3ztSaAU3Ig8ZNIWSkuQslUjbduW4a9vWys8OokiWwnwu
	CMao7YjVrHRc9c5yBaY3Ba3VHchLSSo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0EBBE2682;
	Fri, 10 Apr 2026 03:32:50 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 92EFB3FAF5;
	Fri, 10 Apr 2026 03:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775817175; bh=caKXDhVV7OSoFkbvLj/dPJkPGoMKHBzSGDJtbDEn0Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6+PS95BFzLUjvFSdizyN/iTJgGePZWWNKL7DzMAc+OfVgATLlrKI08QXy64iceAK
	 XgPjoTcY6qT13gn1dOcGbCFa2UQa0W6IqGGg+D5l5PHTNCCZjqioviSd7oopUC5FqV
	 SdLSw1d9FJ0kuBbPlvxMvfWsxe272DAdl+3S+srU=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2 4/9] mm/memory: Batch set uffd-wp markers during zapping
Date: Fri, 10 Apr 2026 16:01:59 +0530
Message-Id: <20260410103204.120409-5-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260410103204.120409-1-dev.jain@arm.com>
References: <20260410103204.120409-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A1056100002
X-Stat-Signature: cj1pwek5u43nk34ysr45qno9q1aewj1n
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775817176-505094
X-HE-Meta: U2FsdGVkX1/UkZ0MVBegODPhV0wmKi5fBoeslfyP/rSB5P7E/HKYn/CX9Q5+fv7g0w6k3MsuuPLi7aPCp+kYkVNDWSrdbnHLBFkmF64tVfItwT4tXMSNaAp1ZZdvgTx8H5s5DUobhx6IBBtQ0/dzbYAGgCvTe9gmlNNzDWiCfJThY9JAlJDscWc7VxXN7cYwtFZwmGQSPlU+cm7yqzZQOKCi87DwRp3rGi1kl03wReqVcMTgvqpF4p9ymE6uydKiI9FEyMoptZPl4Qm7ip/gXwkzPcAXBAC1m6EuP6kZvvGMpxSEwk1S2DEaRBwXjZq4JoMQlf5UekdNhfEhUyrAcxCn/jV/+mEUtv2F4CA1KvBv04CRSojO8knuoWxcNxQISqlr16oLQZeTRrmZfl79GxytiTU1cTOtlRcPt2b2INZfozl4SsMS1vecD3dyhAvZefQN9EzF5I8IR149gWBs5dgfNUPSanG6Z9LEASWIMZ+N7c1wEbg2cZfVctacI49mp9HQyhYjypXV51NPd6Oe6vJBKUnw8+zSuUKvJ/F8FvWBKeFPt9YRBq8I4jEAeA2/GmqRkwIzOB+QAhN1pd792MbbUkBocNb80+QC+0J7q+tAWDBjaduRglLBht80q3PZD7d8UuENbtRrGoxTYVRmNmDNGj1MmA22lr3XaNpP1N9EnsJP1L7avwzk5cyWufTU32TYQBr1no+mKWjYiE8RyXwyoY2lhw1Mxe+P6eVGAA2YlzbsI7mtIeJFrM0WMWD7Qz7AD+WGcg/n5yP9u/qd9w8vx1GGF/CKQzDOFF+A6SMBR89H117F1rDMQW/DBQWBezK4Okq5su0SFAaRgunJ/7AzBroaE2S3e3Aoes/tK+FGE6sdXncXUMGorf3We5BBbOU0zH2jLveG4jy9MFXj1xnvJczqhon8O2Rtac3lMz0taRZCmCOR5UZ6B2iObVPfaMIkyhZ/BpKKVzWPsjQ
 09ofPJS4
 vAx0LZkihNoo7HkmAjl+feiT+jD6lDPPsfuQoCARAQ9VxY6pshqOCXYNx52FgOR+PXWlWnmQGgIMENNq3IEFLzoOZgcT+Hv7GFeYAsSj+FtHQ+3VA9+ZfSPX/B23+bMCFY3DrftytecIBqGeyPFMGdyQW2YS2UgWtV7V1G7m03409vw3Z8CIyGX8qC+kaKzCL2JbxxXczEkujGm3S7cDWEE15ggol4rSZLAJ9pc9uV7dhouzNuRCZJiU1TA==
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
 include/linux/mm_inline.h | 32 ++++++++++++++++++++------------
 mm/memory.c               | 20 +-------------------
 mm/rmap.c                 |  2 +-
 3 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index a171070e15f05..20c34d14ad539 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -566,9 +566,17 @@ static inline pte_marker copy_pte_marker(
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
+ * @nr_ptes: Number of entries to clear (batch size).
+ *
+ * If the ptes were wr-protected by uffd-wp in any form, arm special ptes to
+ * replace none ptes.  NOTE!  This should only be called when *pte is already
  * cleared so we will never accidentally replace something valuable.  Meanwhile
  * none pte also means we are not demoting the pte so tlb flushed is not needed.
  * E.g., when pte cleared the caller should have taken care of the tlb flush.
@@ -576,11 +584,11 @@ static inline pte_marker copy_pte_marker(
  * Must be called with pgtable lock held so that no thread will see the none
  * pte, and if they see it, they'll fault and serialize at the pgtable lock.
  *
- * Returns true if an uffd-wp pte was installed, false otherwise.
+ * Returns true if uffd-wp ptes were installed, false otherwise.
  */
 static inline bool
-pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
-			      pte_t *pte, pte_t pteval)
+install_uffd_wp_ptes_if_needed(struct vm_area_struct *vma, unsigned long addr,
+			      pte_t *pte, pte_t pteval, unsigned long nr_ptes)
 {
 	bool arm_uffd_pte = false;
 
@@ -610,13 +618,13 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
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
+	for (int i = 0; i < nr_ptes; ++i, ++pte, addr += PAGE_SIZE)
+		set_pte_at(vma->vm_mm, addr, pte, make_pte_marker(PTE_MARKER_UFFD_WP));
+
+	return true;
 }
 
 static inline bool vma_has_recency(const struct vm_area_struct *vma)
diff --git a/mm/memory.c b/mm/memory.c
index ea65685711311..eef144fa293d4 100644
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
index fa5d6599dedf0..20e1fb81c33fc 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2263,7 +2263,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
+		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, 1);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
-- 
2.34.1


