Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34329CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72EDD8E0003; Wed, 22 Oct 2025 21:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B29E8E0022; Wed, 22 Oct 2025 21:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F9E8E0003; Wed, 22 Oct 2025 21:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2ED4A8E001D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:35:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8A96140921
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:35:56 +0000 (UTC)
X-FDA: 84027662712.22.E3562AA
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf02.hostedemail.com (Postfix) with ESMTP id 398F680004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:35:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KQg32dOJ;
	spf=pass (imf02.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761183355; a=rsa-sha256;
	cv=none;
	b=LCjKUn+5CbixFG+qKSjK5VzTbTEO7aN6VWQpRU1V2jObbpicKwZ8ZCpxF0ghlEPC+N3N+f
	AxzspV+YTFnY7bBaDUNnTiMRzwvApG2Vc7h3HbB1WkS+Rh8cduCXx7zZU0KJgYZxTYHnsS
	seKH0TV8bk4fTN/tG/zyZ6sZCBkc4gM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KQg32dOJ;
	spf=pass (imf02.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761183355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=coTGbCOnn82yD3SC9CFm+0aCscvZEVrA7rCNfjW8hV4=;
	b=hqO7Q+YFctDyqb/5RypsPq8FN18joyrdQIOlYjatiGYsKbdBXLOshSNfbIMs7q8Vtrt+bP
	IJ0HZzCAAf2LKHbU+6LHnNaYFJ8Qj6svpyDw/jDDmUPmtxKuhcaAkRlwssSytUE5eBTLdO
	7QfU+P+sJfEGpcyC5odOya0ntMwn4Iw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761183351; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=coTGbCOnn82yD3SC9CFm+0aCscvZEVrA7rCNfjW8hV4=;
	b=KQg32dOJNSj0XbXps4ePEJ9CjY7kRc4X6ns1T47pff1Lhhe7TY5lJMujYfCbP4agbzTZpR4GD/+mCKx5oGB9yRB+djvFku4W50pcaiF+Md3uk9sMQM1DnkfwF5Hwb5J3ZRaCL4Na0qC1k3ev3BjNodzaOQDRNDkFJkpTZTZrHtw=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqogSi6_1761183350 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Oct 2025 09:35:50 +0800
From: Huang Ying <ying.huang@linux.alibaba.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Yin Fengwei <fengwei_yin@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH -v3 1/2] mm: add spurious fault fixing support for huge pmd
Date: Thu, 23 Oct 2025 09:35:23 +0800
Message-Id: <20251023013524.100517-2-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251023013524.100517-1-ying.huang@linux.alibaba.com>
References: <20251023013524.100517-1-ying.huang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7bbyd5w3w66bofqk77bwtagmzxcepmxe
X-Rspamd-Queue-Id: 398F680004
X-Rspamd-Server: rspam09
X-HE-Tag: 1761183353-494835
X-HE-Meta: U2FsdGVkX1+1K5CwAPLFfXHFEZoN0vXb9pOXUhhpKgPdzuP6gNr5BWA0cgtgUwoc+d05IH9rkYWBBFIrnG5d976+Ns/GvYY8fELGZdNSUgM0HSfd7ogIZbCxMYycgY02wA57EWLwKiTaasgzN/WUFdROzsqmQ2rmYvo03d47LaMUcz3CPGbita2YOKPLXf+JU5lQeQL2Rl7wxqt0Cp9I5ANgrVF50qUDfdD12/x88Cq8AYywQH+Tek73u/mxb6F53AiuGbXLX8bEKpdAKbFc0MxRtNI7LxjZ4CPlWsbC+an+kU23ph3vml4OEAjFmpkQQH13Qp/kswVQxFJ+jYLEqSErOlYzprZrTFWs7jtB5P6dn/kqK7AaR7INBa4aIez0v0LjLSVs1CdEE7+HV1wJ0bh7yqFG9U98qo3+n2cXq9a2sVSyhzBSRTCP7c6w9DxxxuZj1ZBZRME9uT14ukkH2b54rd7ty32SjXtO73BlYfglNiV0wZrpXXkzztIPSCJ9ADeBmdHJ8qLeRH6IO8o/QKEbgDgv7nYdOglu5Ql7ZcgWyP5ulbFJHjnbMhiZ8B1ZVF8RnfCgF/pr8Y/sVzBwgAGL3I5PgJlvHnkUZ1MLjGfm97y4q2jpUx1Bztge7d7hIBAahhKfYacHYwZiGtr6lrc559JP9rV54rT/xwBrKqM4/dG/HoOXrFxIbFz24wAywKsM6OG6Zaha3nlHIyPi/rtNfxDAeLc4flWvVpiXUI5ngW1FVjv/6ix8tQLqwHIXnoqd8gpZUI4ZNTMh6HrJy4/Dwj6uzpcwHh1fs8c+oHNcrL1N/3+dAzWxjw5ZBLHukbDzat5Wikzrrm3fXqJ1urPrsWp0W1TyzeVoKwdsAJRJYpqtc7O4+WCqbAqy6mGGNa5rd7JVSd2+da3UFUcBr7hOexxRJy81Hcy7/Tv+oesOIWPbvrZTykeTQN9K6eGq7TJ86FdEtHlvApBNt7v
 ONHUtP/k
 8zIp/Xk5pLs2q/SvxUNxxpgY/OpMlZ1d9JiuBkfwQT24kfei74IhqjYx22r4TZWQCVvgwvW/DizSLjkuKCN8ozy0U2milFlXOmD2UWppAP5Ce1ZtPbJdbvGCSifcZwIn+bxVF+yblol9WVUF6D+J5UKIA9J0rWTTrtlrY48j0VJh8Z0D68OQ0wChKFQMhSB7F9i4ZhduSQTxTeP1BhhmDZT8RlgKkh5GHW1IiCtBK21EzW06IeDhK+VJII5iF+I36kl319jOV10sACJnUObpVw2PBDFSJ4ZViXBlOt8juiXaCgWU7n8GSPoeMFBTXbPX4AhnqGXdQ32HIyWKmeOvJvbhUmC9seFTTCbbchBKII7LQD26aQFNL2NmhRJRGbfzynPEXmW/B/qTwZxHQD/N5fmO+5X438VHzl8ndpe9t6Bt8PSn8BcivINa/SpNzLkFEVb5BoNwWpziVrcXPMONbpipG1VUCbIDgJykrBrWW1wArvnKGuBw6/0FNYr/Q4AZgdq1A5q6VeozIU2+De4s7SYCyXGhKl2j/DtObn3z7wpq3YRr97ei5QM3lJmxHgRvIMI32wUIGFmWTrqnFIASmjaoEDJ5v1oJednZQeQXBbxDCS04KnMELTtaVc5/FlHBRwys+Z2E3B1Nf6dExHv2MGXqY3lcw4phhHcyxmNCnRk68zL/wehmPsql6YXMWwTiGNpeP84IHFstJf2Il3X5mo4jOZgIeDpz8tgOej/fxLKJ1I3LNDkHqdxgWVsSXYZbpmci4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page faults may be spurious because of the racy access to the page
table.  For example, a non-populated virtual page is accessed on 2
CPUs simultaneously, thus the page faults are triggered on both CPUs.
However, it's possible that one CPU (say CPU A) cannot find the reason
for the page fault if the other CPU (say CPU B) has changed the page
table before the PTE is checked on CPU A.  Most of the time, the
spurious page faults can be ignored safely.  However, if the page
fault is for the write access, it's possible that a stale read-only
TLB entry exists in the local CPU and needs to be flushed on some
architectures.  This is called the spurious page fault fixing.

In the current kernel, there is spurious fault fixing support for pte,
but not for huge pmd because no architectures need it. But in the
next patch in the series, we will change the write protection fault
handling logic on arm64, so that some stale huge pmd entries may
remain in the TLB. These entries need to be flushed via the huge pmd
spurious fault fixing mechanism.

Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/huge_mm.h |  2 +-
 include/linux/pgtable.h |  4 +++
 mm/huge_memory.c        | 33 ++++++++++++++--------
 mm/internal.h           |  2 +-
 mm/memory.c             | 62 ++++++++++++++++++++++++++++++-----------
 5 files changed, 73 insertions(+), 30 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f327d62fc985..887a632ce7a0 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -11,7 +11,7 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
-void huge_pmd_set_accessed(struct vm_fault *vmf);
+bool huge_pmd_set_accessed(struct vm_fault *vmf);
 int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
 		  struct vm_area_struct *vma);
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 32e8457ad535..ee3148ef87f6 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1232,6 +1232,10 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 #define flush_tlb_fix_spurious_fault(vma, address, ptep) flush_tlb_page(vma, address)
 #endif
 
+#ifndef flush_tlb_fix_spurious_fault_pmd
+#define flush_tlb_fix_spurious_fault_pmd(vma, address, pmdp) do { } while (0)
+#endif
+
 /*
  * When walking page tables, get the address of the next boundary,
  * or the end address of the range if that comes earlier.  Although no
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1b81680b4225..6a8679907eaa 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1641,17 +1641,30 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 EXPORT_SYMBOL_GPL(vmf_insert_folio_pud);
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
-void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
+/**
+ * touch_pmd - Mark page table pmd entry as accessed and dirty (for write)
+ * @vma: The VMA covering @addr
+ * @addr: The virtual address
+ * @pmd: pmd pointer into the page table mapping @addr
+ * @write: Whether it's a write access
+ *
+ * Return: whether the pmd entry is changed
+ */
+bool touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 	       pmd_t *pmd, bool write)
 {
-	pmd_t _pmd;
+	pmd_t entry;
 
-	_pmd = pmd_mkyoung(*pmd);
+	entry = pmd_mkyoung(*pmd);
 	if (write)
-		_pmd = pmd_mkdirty(_pmd);
+		entry = pmd_mkdirty(entry);
 	if (pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
-				  pmd, _pmd, write))
+				  pmd, entry, write)) {
 		update_mmu_cache_pmd(vma, addr, pmd);
+		return true;
+	}
+
+	return false;
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
@@ -1841,18 +1854,14 @@ void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
 }
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
-void huge_pmd_set_accessed(struct vm_fault *vmf)
+bool huge_pmd_set_accessed(struct vm_fault *vmf)
 {
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 
-	vmf->ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
 	if (unlikely(!pmd_same(*vmf->pmd, vmf->orig_pmd)))
-		goto unlock;
-
-	touch_pmd(vmf->vma, vmf->address, vmf->pmd, write);
+		return false;
 
-unlock:
-	spin_unlock(vmf->ptl);
+	return touch_pmd(vmf->vma, vmf->address, vmf->pmd, write);
 }
 
 static vm_fault_t do_huge_zero_wp_pmd(struct vm_fault *vmf)
diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..27ad37a41868 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1402,7 +1402,7 @@ int __must_check try_grab_folio(struct folio *folio, int refs,
  */
 void touch_pud(struct vm_area_struct *vma, unsigned long addr,
 	       pud_t *pud, bool write);
-void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
+bool touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 	       pmd_t *pmd, bool write);
 
 /*
diff --git a/mm/memory.c b/mm/memory.c
index 74b45e258323..6e5a08c4fd2e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6115,6 +6115,45 @@ static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
 	return VM_FAULT_FALLBACK;
 }
 
+/*
+ * The page faults may be spurious because of the racy access to the
+ * page table.  For example, a non-populated virtual page is accessed
+ * on 2 CPUs simultaneously, thus the page faults are triggered on
+ * both CPUs.  However, it's possible that one CPU (say CPU A) cannot
+ * find the reason for the page fault if the other CPU (say CPU B) has
+ * changed the page table before the PTE is checked on CPU A.  Most of
+ * the time, the spurious page faults can be ignored safely.  However,
+ * if the page fault is for the write access, it's possible that a
+ * stale read-only TLB entry exists in the local CPU and needs to be
+ * flushed on some architectures.  This is called the spurious page
+ * fault fixing.
+ *
+ * Note: flush_tlb_fix_spurious_fault() is defined as flush_tlb_page()
+ * by default and used as such on most architectures, while
+ * flush_tlb_fix_spurious_fault_pmd() is defined as NOP by default and
+ * used as such on most architectures.
+ */
+static void fix_spurious_fault(struct vm_fault *vmf,
+			       enum pgtable_level ptlevel)
+{
+	/* Skip spurious TLB flush for retried page fault */
+	if (vmf->flags & FAULT_FLAG_TRIED)
+		return;
+	/*
+	 * This is needed only for protection faults but the arch code
+	 * is not yet telling us if this is a protection fault or not.
+	 * This still avoids useless tlb flushes for .text page faults
+	 * with threads.
+	 */
+	if (vmf->flags & FAULT_FLAG_WRITE) {
+		if (ptlevel == PGTABLE_LEVEL_PTE)
+			flush_tlb_fix_spurious_fault(vmf->vma, vmf->address,
+						     vmf->pte);
+		else
+			flush_tlb_fix_spurious_fault_pmd(vmf->vma, vmf->address,
+							 vmf->pmd);
+	}
+}
 /*
  * These routines also need to handle stuff like marking pages dirty
  * and/or accessed for architectures that don't do it in hardware (most
@@ -6196,23 +6235,11 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 	}
 	entry = pte_mkyoung(entry);
 	if (ptep_set_access_flags(vmf->vma, vmf->address, vmf->pte, entry,
-				vmf->flags & FAULT_FLAG_WRITE)) {
+				vmf->flags & FAULT_FLAG_WRITE))
 		update_mmu_cache_range(vmf, vmf->vma, vmf->address,
 				vmf->pte, 1);
-	} else {
-		/* Skip spurious TLB flush for retried page fault */
-		if (vmf->flags & FAULT_FLAG_TRIED)
-			goto unlock;
-		/*
-		 * This is needed only for protection faults but the arch code
-		 * is not yet telling us if this is a protection fault or not.
-		 * This still avoids useless tlb flushes for .text page faults
-		 * with threads.
-		 */
-		if (vmf->flags & FAULT_FLAG_WRITE)
-			flush_tlb_fix_spurious_fault(vmf->vma, vmf->address,
-						     vmf->pte);
-	}
+	else
+		fix_spurious_fault(vmf, PGTABLE_LEVEL_PTE);
 unlock:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	return 0;
@@ -6309,7 +6336,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 				if (!(ret & VM_FAULT_FALLBACK))
 					return ret;
 			} else {
-				huge_pmd_set_accessed(&vmf);
+				vmf.ptl = pmd_lock(mm, vmf.pmd);
+				if (!huge_pmd_set_accessed(&vmf))
+					fix_spurious_fault(&vmf, PGTABLE_LEVEL_PMD);
+				spin_unlock(vmf.ptl);
 				return 0;
 			}
 		}
-- 
2.39.5


