Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E01AC1099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5698A6B00A0; Fri, 20 Mar 2026 14:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540FD6B00A1; Fri, 20 Mar 2026 14:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4580F6B00A5; Fri, 20 Mar 2026 14:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31BF86B00A0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:07:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F239A1B7458
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:44 +0000 (UTC)
X-FDA: 84567224448.26.EA0A937
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 180AE160003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G9T35OO2;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Q1SKJtbm+b3Pnm2CSjpsptVr4eUf++FErNWM/81VzA=;
	b=nj9Vn6VShMut+W82HOPqSL4SOAPUtkD7tmlIBQVryOxJp57PzkABhvpBNuXyBwL8MsRBjN
	Z4bvW92DVMcGEP/dWCtEPgj1RTAHPp6kgBFNOWLQ9davOu9VcmgtwvLPHmjcH1NOEHwuJT
	DK9P1okaAwWI38eJmEkIwstO4QgxlGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030063; a=rsa-sha256;
	cv=none;
	b=hKZ+9y6HOVBpHIKFuhoNG4oMnmIbL4sM2qHOB/BU+/q4KMldSMzoftvuspsUNiQvsIuHYT
	A5NHttussPrnZREITDCIm4ksGIo8huw9NEcZ1GCkStnAl036xabGaVvTV4XHG52j/iyQyU
	Gh15jypsOITjxTOQUBd+mBermy1PMOU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G9T35OO2;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EEFC43DC0;
	Fri, 20 Mar 2026 18:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648EBC2BC87;
	Fri, 20 Mar 2026 18:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030062;
	bh=amPSkQMTzSQojPGe7/NnBN/jpbTA7AJ3qnkGmEg1DZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9T35OO2fy9XN0A+O0UjchlBJ4cTGUO0KfKGNpyrYzh8Y4kncNgv0tzdzpIN0BhNc
	 RvyEFjm5KVMdkfaUv0p5DgB3VFIbND1GGr3hOKcXwMu/X4nEyqbmk/XAJGAH3Fz9RT
	 l2eDjHpESSpFmx5ps9dDI2INm9Md+bSRWTzaOC0z6wWcLV4C2a70mOM/bbq10sRTjw
	 nvZl9TKFO/fAJLrMfNrBMOkgIy4wOWZQb1PmfQMF43gsTbkmxawHrihVGv6za557d4
	 eJWb/c7GZuAuZLg5eYJcOwS0HvLLlbntVNU9o/6lKrBHORDPTtaeKlvaQq8++SoO2g
	 xLF/SYzXxGKiQ==
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
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 03/13] mm/huge_memory: have zap_huge_pmd return a boolean, add kdoc
Date: Fri, 20 Mar 2026 18:07:20 +0000
Message-ID: <132274566cd49d2960a2294c36dd2450593dfc55.1774029655.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774029655.git.ljs@kernel.org>
References: <cover.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 180AE160003
X-Stat-Signature: og9yrgb3fww8xcthbmco4jj9ddcxc3q7
X-HE-Tag: 1774030062-565799
X-HE-Meta: U2FsdGVkX1+Y6w5L0U+IVNrL4LeADTcP4aESNeAXwYmCAE3fTVniSiEBzzdzZ2Cu1DlHg+zlBroVzZRmKGaRvkGyC4cqD+fOwLxd5ybB0ykk8JFsWZkEsSGpoAq7r2IdhCNqyRh2vir9pueuO2TnjFysZNMCbBLnUkJTxNdk7RvI8t23iRDnY9eWG3PUSLQcdPynenbbr/zGU1oylN8kpYwVo2JFOkjjSULj6FJGC+hFERZ7E5mDE/jhRnwAQRjQJuzKbtmdebjRdag60es+afHY+T7/Dd/xc++jbOlMiKJol5G4y36hdpxyEfriUbpETiJzkFxNV8FT8QtWSD8G/IITLMo3zepuFElYlTtRRMuu9yzGSmsiT+y+zX1/j+DM1+4k284HgRXTAkWdiUrftZRUNcKuRtbqV/8f8DT+oqUBj+A6+mBUW9m6zEPdzPWQQLWgdEUY5vSiITfP4gWJP7yNmkK3M1RqTjCqCRtxhfUznggRQ7C8KQLQiDfUOW0ILmIVCNwGwE/tEUeHKjII8uSs9IsQMt6iVpW383D3VqkFTQIP+dTuV2O7qgVb4RuoD4pjzKUCZ5jAeM/eyFpogCV2lb7nemstLajUUOlkA5viEe3Ami09jH4heGBBJL/Up9Jeh5LidGbV1UZKZIWnTcT3oLO1SPy4jc5VJCl/xi8WjhlxItVkdPD3A+W5EVuVnHBMUZv+B2g/ghoQGB63zhht6MCmtfLL78pZM7eCXbhnmGMpybQegU77dYaSzRiMA3rIAGSFxEcU/QvufKEkGAMaEoo08bNy5kUg9VNI4oeRjD2DYSfglFm/Bueap0K/FaDBgfwWFSLCUq+aKH8N4yAqOhOLqu3RnVsBh/q/Wfk4KP0FDTCQSUbyFESkq6RvLB5kGAde6hz4tS1x11clI+ajwdtf82vr0qasCgr+hQ6nevHAEPWWiyedrrKeKhVl52+CrnscAEgwCBzwJyN
 sRe5FwAC
 0ITYkaiF1tZJSMdiTJu2MkDnqR2pAvXeOevHZHBXjML8BFPeeQZjqHSwi9QjJMBid1W/KvYLrBudeHJl6VKXncP6yLA9j4oq22dsmRwghM9ZCOMAYWJUS2gUXgepdCE36wjHd27wZvSeCXp30d8rSILxPcaGLveaJbdKtqHV+FRvicNcv5qYSJGXciUHzG/EEggL9rBAilTOqoG4eDfJqHKA8GouKxz3LTGdprLZrxWidepDh0Amds2gL2PwTf7w44Yenm1mOGArYhmwmAaoBmBfo1cgllSLOglVl3R74sJfVqPLeWlnUud3EsveseIN1+5LzylQEAvKzjlslsACsDf8EZ4BOz405fBiat44V45hdRY5BEWYhHEmpnrClJr1Y98oDHllJYssxbGvSvUjZ8xahRg==
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

No functional change intended.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/huge_mm.h |  4 ++--
 mm/huge_memory.c        | 23 ++++++++++++++++-------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index af726f0aa30d..1258fa37e85b 100644
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
index 4e8df3a35cab..3c9e2ebaacfa 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2325,11 +2325,20 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
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
 
@@ -2337,7 +2346,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	ptl = __pmd_trans_huge_lock(pmd, vma);
 	if (!ptl)
-		return 0;
+		return false;
 	/*
 	 * For architectures like ppc64 we look at deposited pgtable
 	 * when calling pmdp_huge_get_and_clear. So do the
@@ -2352,13 +2361,13 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2372,7 +2381,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
 		folio = softleaf_to_folio(entry);
-		flush_needed = 0;
+		flush_needed = false;
 
 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
@@ -2406,7 +2415,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (flush_needed)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
 
-	return 1;
+	return true;
 }
 
 #ifndef pmd_move_must_withdraw
-- 
2.53.0


