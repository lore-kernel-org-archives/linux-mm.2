Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDEAF1090223
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 13:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B55E6B04AE; Thu, 19 Mar 2026 09:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34F26B04B0; Thu, 19 Mar 2026 09:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6726B04B1; Thu, 19 Mar 2026 09:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA0176B04AE
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:00:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B1FC1DBA9
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:30 +0000 (UTC)
X-FDA: 84562821420.08.A0C23B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id F0AB4180007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WSXkbGTR;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773925229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0lgokRaBEkLHrq1tFVIfPh9oQP9LieKBSL5tqqooneI=;
	b=67rYgykXRucqXQ19cMHjYtc/iDYi75C81znsxuZ2Rlm8ECqbgJUu5fSL5gqdehyMvW8SXC
	/HocZJvWJHz8GrMwBuCQpPQFBcB6Fm66I6f3Dh8sMVrkDR3Nmu08aTZHpFUGWJ+V09xQyH
	5jFW1Q/o9sKikUgDFTZBEU15DJ9L06M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WSXkbGTR;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773925229; a=rsa-sha256;
	cv=none;
	b=nLUw42RhItJGRez/v4FDGIXZbKmKcTCLL2S9UoZ0ij5wNHMmOWD8HPr65EU5eiTe5x0nJi
	KSdlW98hgZaDwSiGTHPU8MwL3ctAa8IXkNH63NziPbRrait0iexGlmHSiYx7MpU9bYUsEX
	gzvUG8PZT8KuEpz1SMzsnDnM73u0Vq0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 28FC740352;
	Thu, 19 Mar 2026 13:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6DDC2BCB0;
	Thu, 19 Mar 2026 13:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773925228;
	bh=t/SrKTG4kMRLxaTGO20BsEclVU9dVXYVk3URzvbrQs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSXkbGTR1C0mZT5R2EFaMEy7BXk4JQvJ2+6WDcLJY2aTirOp/RjlafU1yXGnyePDq
	 td0/sLLjeF2fetOYnqUIoxG5pISvY3vcWs0ccAqAwbHTe70Vrs06ePfXbxEITsGOHD
	 5j+jPg9rdDdWYuUvGn2X9w3TFHh7JhDrg0WFq8Rz84TnWuQrHr+bPEgMlz7navbVvO
	 lSFgH7WFj7Rkm3h6yJ6u2k5ifWk9/F+UB8n2+Ozyabso9SN5VMIacHXChZdk7Eg9Zs
	 iVgcVRRkjuSYdF8WxoCaIgt5O+tWu60T3NcV9XkaO+FdD/0C+9sqpvStLlXQBJN60D
	 irU2ZeSW5w7RQ==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/9] mm/huge_memory: have zap_huge_pmd return a boolean, add kdoc
Date: Thu, 19 Mar 2026 13:00:09 +0000
Message-ID: <8bb854291383ff4713427e6d903d6d79435eb153.1773924928.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773924928.git.ljs@kernel.org>
References: <cover.1773924928.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F0AB4180007
X-Rspamd-Server: rspam08
X-Stat-Signature: msdirftamzmsadjqfrjxnh5b6z7p85tx
X-HE-Tag: 1773925228-253427
X-HE-Meta: U2FsdGVkX1+abcmr9eZggtxjKx5iT1tTDTePpTuDp8lu142aArC8VoU/G+94WHFGH/Ji0edOCz83FGcLzvgWVM8DEzk9SMCdKeJebMk2W0H9jyd91++zUO7GGyz4q1kBDCpJARNNYqmc1m9gXhtOKJsXpfPoYkzQIe0IESla55GBj3UwkKF9dOXZ/NUZjMgFOyMmw0dwACgf1V+4pA7HsJpy3WWQMbHGVI6yy1g3A+WZbwzNyW1G+o4QH7peIJjNxoAP2pKJ02S11TjdBT4uN/V8paGD95R31+9dlnTirTAYXYtiPln8zmZpFzyQgcSwDGraNmnoUjvJpgO1Q18qidy76yXmVZI4RKSEBdiLPTwYbWL5Xjc3ZcF+tbDd2C1xey0epJBpxC/IK0BMIsVlC3lg3e1g8atZ6EnE6FsPa9ypn9TBHoI3qDrIMTo2JlPWImPpgu8USlG02nC8uPEldHyIYjqTEy3qlutUfBZL2oS77qq5w/ddZcjSr2x7kZBTsTakGR94Q9Hlc4mB/UeYqN0aym7rRA8qN9yfVw3qcoN1CH9SzUPLNoiaKxC34xX0ip973zR8miV8ogNfrS/ptdtcuRxEmq4sNf0T9sq4+KiKkQXJbURmt9FvXNPt73Jxx0tY2ezYhUplbtHlKTHAP1evfdhETLK9SsJxUWTdxKr9Pp9CWKlvGyMhB3K09gg24oLSC8QHoMELu9QHA3oWiHSkfOIH+hdet16F2mFB8mER3JFGoq3n36QYM/rpg7rRb1otgGfVvrfsC1Al54zcWobJYuWa6UKvU+Nzy4/0eR914F9KYvqRIVJS+xuYMov+7Qa7B2DA7LKyP5LocRQ+m7JNNSdBYF4tNbVNHXs0gT4pWnrEK9JqKTpMyeGMADPHv/eDZwIprGmBk5ab+NPmfUUuEz+jo/+DYzE8imPApg9NkJQOG3XOYLmR27zxvTYt0IFVxecrhSAR/LSI5h/
 4LsLzaQX
 uRrhE98/szc5/oGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to use the ancient approach of returning an integer here,
just return a boolean.

Also update flush_needed to be a boolean, similarly.

Also add a kdoc comment describing the function.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/huge_mm.h |  4 ++--
 mm/huge_memory.c        | 23 ++++++++++++++++-------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 61fda1672b29..2949e5acff35 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -27,8 +27,8 @@ static inline void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
 vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf);
 bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			   pmd_t *pmd, unsigned long addr, unsigned long next);
-int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pmd_t *pmd,
-		 unsigned long addr);
+bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pmd_t *pmd,
+		  unsigned long addr);
 int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma, pud_t *pud,
 		 unsigned long addr);
 bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4ebe1f19341e..bba1ba1f6b67 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2418,11 +2418,20 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 	mm_dec_nr_ptes(mm);
 }
 
-int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
+/**
+ * zap_huge_pmd - Zap a huge THP which is of PMD size.
+ * @tlb: The MMU gather TLB state associated with the operation.
+ * @vma: The VMA containing the range to zap.
+ * @pmd: A pointer to the leaf PMD entry.
+ * @addr: The virtual address for the range to zap.
+ *
+ * Returns: %true on success, %false otherwise.
+ */
+bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
 	struct folio *folio = NULL;
-	int flush_needed = 1;
+	bool flush_needed = true;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
 
@@ -2430,7 +2439,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	ptl = __pmd_trans_huge_lock(pmd, vma);
 	if (!ptl)
-		return 0;
+		return false;
 	/*
 	 * For architectures like ppc64 we look at deposited pgtable
 	 * when calling pmdp_huge_get_and_clear. So do the
@@ -2445,13 +2454,13 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-		return 1;
+		return true;
 	}
 	if (is_huge_zero_pmd(orig_pmd)) {
 		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-		return 1;
+		return true;
 	}
 
 	if (pmd_present(orig_pmd)) {
@@ -2465,7 +2474,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
 		folio = softleaf_to_folio(entry);
-		flush_needed = 0;
+		flush_needed = false;
 
 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
@@ -2499,7 +2508,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (flush_needed)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
 
-	return 1;
+	return true;
 }
 
 #ifndef pmd_move_must_withdraw
-- 
2.53.0


