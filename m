Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C16606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=uidMCwNS
Received: by kanga.kvack.org (Postfix)
	id DFB356B05BB; Wed, 11 Nov 2026 01:06:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD35C6B05BC; Wed, 11 Nov 2026 01:06:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC38B6B05BD; Wed, 11 Nov 2026 01:06:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0C556B05BB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:06:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11AA4160172
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:06:57 +0000 (UTC)
X-FDA: 85421804874.25.8069C13
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf31.hostedemail.com (Postfix) with ESMTP id E4EA420003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:06:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uidMCwNS;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794377215;
	b=JjjS4lVOxKW3oWXNcglwLXAgMa6fgyPT54B2tS2ql2iBceH5Gn5m4+IXfn20WBTlh0OSGC
	Ncqs5xIWxK9h63qqIecHyDVhvJfuZdV7ni3akY+m51UqbVdtAf466zIymBDp85935EV1j3
	DjDrKCuAReywv+qJai20P/kp7Jkcvb4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794377215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=s92FQZqziYdPkK0Z14gXxUm+Jr8xarhyobVXri/rOeU=;
	b=osPsh6cgkcmPKVIZN+VMzRrO6TfYzfFfXFlliV+CkrLeAtxrDl8fMzd9cUPTXh0V8W2ZZC
	5Hj/4FK0c2z9gEmrLXwv6Y9Mp+dVaaSuD9oUv/PN9guKMlX3OX6hVzm+IW331D+tO7OUyR
	HCPYNK0pIvAg+KEpWom7wR7QL8f2V9k=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uidMCwNS;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794377211; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=s92FQZqziYdPkK0Z14gXxUm+Jr8xarhyobVXri/rOeU=;
	b=uidMCwNSaSVuBG5bMvsiok5FwgQ8xHhiWhklCmVazWoRgQZWPtdoLPllntIWOHTeqfgfSUKS8hvmEdi9Qr4FFLFeMAnx1/AQFlGVAxoBVbG31Z+Rp1nMI/3TUg29EVgKYmYb0lXearyfjNM/RZ/DslrHAuj+jxRJvHHcSkiXq5g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XEXp.ui_1794377209;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEXp.ui_1794377209 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Nov 2026 14:06:50 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	qi.zheng@linux.dev,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: use memory barriers for non PMD-sized folios to sync
Date: Wed, 11 Nov 2026 14:06:39 +0800
Message-ID: <09736bc2e01bec0ca7436733078c82c7e0cc6627.1794376686.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E4EA420003
X-Rspamd-Server: rspam12
X-Stat-Signature: c3c84eq48kr41bwa35698oxcuzn9hkns
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794377213-252198
X-HE-Meta: U2FsdGVkX1+6RTtXvHe610pRHjx3/jcxu8Ho+tVBV42YuN/gJTDWgpeizlQzrpXc/SDDaMRNeUgkdAf+Fr3h/05KscyDlCPP7/rAL2Z92n9TYhYj5WVggJaz6kNU00Un0xDrr5PfMkfJ2TxrunUgzIBT3tYGZK6Qkxf6sBqiLRha2oFhcO7ggejFOIub/OM9CLqF6c2WQqcEjBgDc4i6ldvxSQ6LdhBXUB40Wmf0+GtSbLj6jrHwVB92X/EJc8u4cTIPCECk8ca0kvxbDOydyAcAdaswXQ9yBC2hvWUKCMca4jMIh/V3IMttbcFDFtv7dnVCqS45QuZIM0LDGEshtODG20UDI1kwUVsf9QtUxVHMQcvNxUXVQ+iqu9aTZm/HH+jL9MuEn4acpm0vFlFuMH51K0C/PMbDYfYBFMoOJHgbjQFJ06GA50f1B4Xprt9F/cm/LljRaMFKWSShIZadX6PHaO6YVoP2Vg8I4nhffPEJro57AH1BQ90wuBivcnJw5zbAIaM+QKmgBPJVp/jM002fcli74+zyKaKTeTZtJn8BuwNIjlFYQ86LSHsvGZm0yaExzMI2aEt5RyVTM5NfOTdpv2j1GyZn4ZcEGVP9BHdd3sl0pTEHEGDm1J0dLU6o1eatvcL0hsCTrwWuvZe4hE1kF1W2DQmwqfPVAF91AqSZ1hcAgNPrDP3V07kogp8Ajn0ruGXxUsH1kPaAV0ZX5Ym30mg+Zufo2MEM6bCtXj+c+sRBBGS+GmIWfNmBS0N4WvIsrvbAeHybWk58IGmQBfvHP3DjhZC3Cphbreq1S1IouxdnBzcEDhblFhp50NRLuSJLQ28GaPbkU5PFofqRU9xFqsei0ZyQPtLa5tRKNijg6URb+wwuk1YCeZf0+L9//qTYlfNiexVk8eV9n6qWNtf/ucc9SQPv/fF/0agQq9wNcZcKgOmykWyaTNb3UODuhoJRiKTdLLcu21fv9wV
 JktJ1+Mk
 V/Jmwqu+OKm5VEaUOtEE/HZ9b5qksbRQb80UhYz61PdnWoSu+yh92rt6SDYpp4k3fFPsPIRKnGe/WomjoKFAfXADXi4Gzlp67PMcOYfVN8pgRRoEc8nokYPpizpil/ySdefPOjRExUfpbUQvsDa/cATcku5Tkwi2UO0IfXd1PReINy8qC364+yiyHJdTQkdAB4GgKStsM8WMeJRGvkEgN8RmrLK3Nq7Mlv35pSKLME0AZt+zVhS/9xPrlGuFMuynfzKezTc5Pg+TSwCsNkDET2Z4k1Nqn4Q/w8lhxAEmMLXTCKatxParWkB9EQpLW9xzhvBSFDgv+oO9arGqmwbhDFLPCvbIgaoEEVApY4UBlFIlteFk1ZdwC4p+AfI+beGjX58+JYd/eiOSVstWgrfBx01ARsGDnTtZqaWePRY0YCEHsFFU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
uses PMD lock via sync_with_folio_pmd_zap() to synchronize when a cleared
PMD is found while unmapping a folio.

However, for non PMD-sized folios, the cleared PMD can only come from
PTE table reclaim, which clears the PMD only after the rmaps for the
table have been removed. This is plain message passing, and taking
the PMD lock is more than needed, like I did in the previous patch[1].

Without barriers, the walker can observe the cleared PMD but a stale
mapcount on weakly ordered architectures:

CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
================================    ================================
folio_lock()
                                    lock(ptl)
                                    clear PTEs
                                    remove rmaps   /* W mapcount */
[mapcount load satisfied early,
 folio still mapped]
                                    pmd_clear()    /* W pmd */
                                    unlock(ptl)
pmdp_get_lockless() -> none         /* R pmd */
skip the PMD
folio_mapped() -> true              /* R mapcount, stale */
unmapping assumed to have failed

Pairing an smp_wmb() before the PMD clear with an smp_rmb() after the
PMD read forbids this outcome:

CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
================================    ================================
                                    remove rmaps   /* W mapcount */
                                    smp_wmb()
                                    pmd_clear()    /* W pmd */
pmdp_get_lockless() -> none         /* R pmd */
smp_rmb()
folio_mapped()                      /* R mapcount */

If R pmd observes W pmd, R mapcount must observe W mapcount, so
folio_mapped() no longer reports the removed mappings.

No changes for PMD-sized folios unmapping.

[1] https://lore.kernel.org/all/542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com/
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/internal.h        | 26 ++++++++++++++++++++++----
 mm/memory.c          | 12 ++++++++++--
 mm/page_vma_mapped.c |  2 +-
 3 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index cd3675c044e0..a277bf4841f8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -592,6 +592,7 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
  * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
  * @mm: The mm_struct.
  * @pmdp: Pointer to the pmd that was found to be pmd_none().
+ * @nr_pages: The number of pages in the folio.
  *
  * When we find a pmd_none() while unmapping a folio without holding the PTL,
  * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
@@ -600,13 +601,30 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
  * against later mapcount reads. Skipping the PMD without synchronization
  * could make folio unmapping code assume that unmapping failed.
  *
- * Wait for concurrent zapping to complete by grabbing the PTL.
+ * Wait for concurrent zapping to complete by grabbing the PTL for PMD-sized
+ * folios, otherwise smp_rmb() is sufficient.
  */
-static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
+static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp,
+		unsigned int nr_pages)
 {
-	spinlock_t *ptl = pmd_lock(mm, pmdp);
+	if (nr_pages >= HPAGE_PMD_NR) {
+		spinlock_t *ptl = pmd_lock(mm, pmdp);
 
-	spin_unlock(ptl);
+		spin_unlock(ptl);
+		return;
+	}
+
+	/*
+	 * For non PMD-sized folios zapping, concurrent zap_empty_pte_table()
+	 * may clear the PMD after the rmaps for the table have been removed,
+	 * but later mapcount reads could still be observed before the PMD
+	 * read, making the folio appear to be still mapped after unmapping.
+	 * Order the PMD read before later mapcount reads, so that observing
+	 * the cleared PMD implies observing the rmap removals.
+	 *
+	 * Pairs with smp_wmb() in zap_pte_range().
+	 */
+	smp_rmb();
 }
 
 struct zap_details;
diff --git a/mm/memory.c b/mm/memory.c
index fe72e66c9c2e..1ee286cdd3af 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2054,8 +2054,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	 * Clear the PMD after the rmaps for the table have been removed, in case
 	 * an incorrect mapcount is observed after unmapping the folio.
 	 */
-	if (can_reclaim_pt && direct_reclaim && addr == end)
+	if (can_reclaim_pt && direct_reclaim && addr == end) {
+		/*
+		 * rmap changes need to be observed before page tables get zapped.
+		 *
+		 * Pairs with smp_rmb() in sync_with_folio_pmd_zap().
+		 */
+		smp_wmb();
 		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
+	}
 	pte_unmap_unlock(start_pte, ptl);
 
 	/*
@@ -2110,7 +2117,8 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 			/* fall through */
 		} else if (pmd_none(*pmd)) {
 			if (details && details->single_folio)
-				sync_with_folio_pmd_zap(tlb->mm, pmd);
+				sync_with_folio_pmd_zap(tlb->mm, pmd,
+						folio_nr_pages(details->single_folio));
 			addr = next;
 			continue;
 		}
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index a931243ca42b..d793ad0c5364 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -295,7 +295,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			pvmw->ptl = NULL;
 		} else if (!pmd_present(pmde)) {
 			if (pvmw->flags & PVMW_SYNC)
-				sync_with_folio_pmd_zap(mm, pvmw->pmd);
+				sync_with_folio_pmd_zap(mm, pvmw->pmd, pvmw->nr_pages);
 
 			goto next_pmd;
 		}
-- 
2.47.3


