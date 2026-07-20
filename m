Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9426C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 06:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9786B008C; Mon, 20 Jul 2026 02:55:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A646B0092; Mon, 20 Jul 2026 02:55:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68DE6B0093; Mon, 20 Jul 2026 02:55:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 777466B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:55:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF2D8120791
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:55:37 +0000 (UTC)
X-FDA: 85008244314.28.5FA9538
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 32251A0007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:55:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LFg3vQ0z;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784530536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PtzJ2Kc/S3VerbI4RCMXlRMVnkg0C3x6hvpk1HPK/Z0=;
	b=Gk21FWw5EcxKzJrStWEIoXNfHzpu372hfJaCPgd9ZaqEH0tvx2Wsa0PUL5hAUraZ6GW97m
	HRm0u8radqXmZyBaYLRKJij6cF3ZFuuF4TTOWtDSYV25ccnCebH72VxQNwZt4FxNm5w//f
	/RyEB/Ja8TR9aTYpHtnu83pW41DZrdc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LFg3vQ0z;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784530536;
	b=O/oB6IVsomRqY74kAHrA0eJB6ej0KO34EORzH50pGvesBcaA3iv4p1B/c1MpTTYsTZe+LG
	mRnLyJla2NdGAF3+ymBL1GCpGJPDDnTuKQahs4Lyks/XYNp65XIcN2yX1wDRO4pYarib1K
	DakEZI+X+ojCLhu8GiU8Vp2pO/Eeg6M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E81A61476;
	Sun, 19 Jul 2026 23:55:30 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 050FD3F66F;
	Sun, 19 Jul 2026 23:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784530535; bh=ked3BDcGYDpvXw7eNGYa4GCDwM9ERmQ/SIgaGlKW6Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFg3vQ0zClOXjP/YUj6Ru9ICRSn7R1j2oqc4shwEXq3xguWXJodF6dFMpacxMyFGc
	 pz/BCAWzVAGCiG+GAGZLNhsWmUkDYrTRnW+lnnfD2t7IRdELSniFNhjpuDPZIL11dI
	 JNFPa9hnzLEBCDSVV+JinCyuAVIxGA1op3SJ2GhY=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 2/3] mm/memory: batch set uffd-wp markers during zapping
Date: Mon, 20 Jul 2026 06:55:06 +0000
Message-ID: <20260720065508.2695106-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260720065508.2695106-1-dev.jain@arm.com>
References: <20260720065508.2695106-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 32251A0007
X-Stat-Signature: e1dmdgqg6x1beof3hhh15z1p511ajb39
X-Rspam-User: 
X-HE-Tag: 1784530536-420254
X-HE-Meta: U2FsdGVkX1/QLlff/ToVj16LnY2UB3S3Um7cWGy4oOIuimW6PGe0Ffq/8Q1Ff88vPLCECKTXU0waO72A/ndFmhZXjl0vC/ig4+awVzruqZB5iWZfAOvTj5xnuQpuwwcBVcMcCYmXdktsGc/01N6ZB2xFrLF/XUsRDxcpPpoEk3zZ/Eaqh86N7W/5VfKEVxj+hijCjkyOHFA/RvKaeXBqa9jc0DsML9COF/3JHltPeq8xBHC+FjxO3/gDu7ZCihsPYHrQQv19dXbwAKFNHI0HVF/5IZBOxyXj4cX8OZbazuIzOm8TKxQh4YXmWxaJt5S2asnJS1fIjP4nUxcVCl1y6gPjtrqynoYVHDZ/VHUU7mwD80C8N4o95aQtr1dCCc2vRdyAncrY/TDZqSEfI1A/4st+kf9eQR/Q5vlUM3CyAJn2jatjXZaJ4/QKvoSA0bDK/UBxe+pqHGDSc3xZSb2P+vgz/RxFlUr1BJ12iZG+umi9enl2EAaLpEQ70vuiqCYZNYuClYPApRaC4ruNXej8mQM/ShwmGoylNzMGGmzNHBy8CgeTbJMnitsWaSICyHfowCNthwtals5U1edGTZTEbwDuVS75kpn4TzfOFXeYw91kewuiaM2xSxQQ2AVi4bqk8r0rfAiE3kvW5fBcCrIoQr4NfPp/m/HpN/xr0sE0NFtVMloLE6FMqVq/vDz1fqVw5Edd/Xra0MSMdB4LHpOrY2qqHC0TvOwzLZevp9OtBefgRHChwaJtiflrcGam0Vysu12b17s6sGzQyXVnDb4SVspNx4Yu5BfJPDHHzPLC2vm2qJ2DhvuWyrfe+NEa2S+H55/pkhJfin/ehbTTn1YI2C8Vtk3M0SeFE2y6w8HreGym8ColB9NvV7IEZyLy21p7xXvTOsIk5Pfk25xwQyPlkqqyGPjcWXk/AGmhR/Wwh9VgJRdf4MoZO+SP1tkAC/AYI7+9a37UQLtqg9weWcA
 PbQJtngN
 pH1H6r0s8VxjqzU9m5SrtvMFtV/jJh9JngFkIoh6LwpR2gzzIbUiOkkOwwqEW5ypq7mIy2FnROkxK9jFMzS18jks/iUSiwk6DY7zoLQA089Gszzljfyl94OmzcEw9rEwMrjPeFgWuF1KdGtVUpXNIfBoOcveqGVmI/rtKEWZQig3zYnjI6TYA7pTxzS5enXvvjzF9bcwc7RxsAQX92ulimbNkTp/UulUVTX0Y6PYB3rOvKjeIOtcCgWERpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable batch setting of uffd-wp PTE markers.

The code paths passing nr > 1 to zap_install_uffd_wp_if_needed() produce
that nr through either folio_pte_batch() or swap_pte_batch(), therefore
batching is correct:

1) All PTEs belong to the same type of VMA: anonymous or non-anonymous,
   wp-armed or non-wp-armed.

2) All PTEs are either marked with uffd-wp or not marked with uffd-wp;
   the same applies to the pte_swp_uffd_any() check.

3) uffd_supports_wp_marker() is independent of the function parameters.

Use set_pte_at() in a loop instead of set_ptes(), because set_ptes()
cannot handle nonpresent to nonpresent conversion for nr_pages > 1.

Rename the helper to cond_install_uffd_wp_ptes().

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/internal.h |  5 +++--
 mm/memory.c   | 61 +++++++++++++++++++++------------------------------
 mm/rmap.c     |  2 +-
 3 files changed, 29 insertions(+), 39 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index b6a3589a61c1a..0f49cff67a2b8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -276,8 +276,9 @@ void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
 
 #ifdef CONFIG_MMU
 
-bool pte_install_uffd_wp_if_needed(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, pte_t pte);
+bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t pte,
+		unsigned long nr_ptes);
 
 static inline void get_anon_vma(struct anon_vma *anon_vma)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 6c0c4c774674a..d2f14ba2261cd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1676,27 +1676,29 @@ static inline bool zap_drop_markers(struct zap_details *details)
 }
 
 /**
- * pte_install_uffd_wp_if_needed - install uffd-wp marker after clearing a PTE
- * @vma: The VMA the page is mapped into.
- * @addr: Address the page is mapped at.
- * @ptep: Page table pointer for this entry.
+ * cond_install_uffd_wp_ptes - install uffd-wp markers after clearing PTEs
+ * @vma: The VMA the pages are mapped into.
+ * @addr: Address the first page of this batch is mapped at.
+ * @ptep: Page table pointer for the first entry of this batch.
  * @pte: Old value of the entry pointed to by @ptep.
+ * @nr_ptes: Number of entries to install.
  *
- * If the PTE was write-protected by uffd-wp in any form, arm a special PTE
- * to replace a none PTE. NOTE! This should only be called when the PTE is
+ * If the PTEs were write-protected by uffd-wp in any form, arm special PTEs
+ * to replace none PTEs. NOTE! This should only be called when the PTEs are
  * already cleared so we will never accidentally replace something valuable.
- * Meanwhile none PTEs also mean we are not demoting the PTE so a TLB flush is
- * not needed. E.g., when the PTE was cleared, the caller should have taken care
- * of the TLB flush.
+ * Meanwhile none PTEs also mean we are not demoting the PTEs so a TLB flush is
+ * not needed. E.g., when the PTEs were cleared, the caller should have taken
+ * care of the TLB flush.
  *
  * Must be called with the page table lock held so that no thread will see the
- * none PTE, and if they see it, they'll fault and serialize at the page table
+ * none PTEs, and if they see them, they'll fault and serialize at the page table
  * lock.
  *
- * Returns true if an uffd-wp PTE was installed, false otherwise.
+ * Returns true if uffd-wp PTEs were installed, false otherwise.
  */
-bool pte_install_uffd_wp_if_needed(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, pte_t pte)
+bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t pte,
+		unsigned long nr_ptes)
 {
 	bool arm_uffd_pte = false;
 
@@ -1726,13 +1728,19 @@ bool pte_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 	if (unlikely(pte_swp_uffd_any(pte)))
 		arm_uffd_pte = true;
 
-	if (unlikely(arm_uffd_pte)) {
+	if (likely(!arm_uffd_pte))
+		return false;
+
+	for (;;) {
 		set_pte_at(vma->vm_mm, addr, ptep,
 			   make_pte_marker(PTE_MARKER_UFFD_WP));
-		return true;
+		if (--nr_ptes == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
 	}
 
-	return false;
+	return true;
 }
 
 /*
@@ -1746,29 +1754,10 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
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
-
-	return was_installed;
+	return cond_install_uffd_wp_ptes(vma, addr, pte, pteval, nr);
 }
 
 static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
diff --git a/mm/rmap.c b/mm/rmap.c
index 73c2fe2d19462..abeb8e7ceba17 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2348,7 +2348,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
+		cond_install_uffd_wp_ptes(vma, address, pvmw.pte, pteval, 1);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
-- 
2.43.0


