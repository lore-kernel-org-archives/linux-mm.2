Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC0CFCE7A8E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04D158E0002; Fri, 14 Nov 2025 03:54:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3F928E0010; Fri, 14 Nov 2025 03:54:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C858E0002; Fri, 14 Nov 2025 03:54:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CE9338E0011
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:54:28 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7FDDE1602DA
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:54:28 +0000 (UTC)
X-FDA: 84108601416.25.98FB189
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf26.hostedemail.com (Postfix) with ESMTP id 35E20140003
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:54:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=glpoVYb0;
	spf=pass (imf26.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763110466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2fr40Pgn9Dt7+PEH5DS8QgOv7O11/Mnrdwz440EHayc=;
	b=rlO6mGIW5pxRFD/kXD/CykM9tlbNMGMEiIhYQAVNfiP/5c5dN1qTrkKJ3RG6czeTkFEpIo
	5FidgI+A0CtuJhZ7jA5kCG1ZD1CZVO0bsG8iYBz0FaumS5M28rZmM1pLj3LGwZto+HLEQ5
	Hp3MMvskcvUScE9rBfuWtzX7Yd4E5Fk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763110466; a=rsa-sha256;
	cv=none;
	b=s5RnTNtlYE1xHBLohUTDWss29EmBb5/dJqWeRwqp9vEBHd1YUG1/+ztYE5MgeOPK0jqoK1
	pvMPWs9Lg1buR4DI60oqPsGzt/sXS8rKBNM0FhGrC8bWhIcesWYcm9Fc7MKq5TC4mbKiMp
	6I0tGaQtHwsxtYlcMUM5nk/X9nI3cDM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=glpoVYb0;
	spf=pass (imf26.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763110462; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=2fr40Pgn9Dt7+PEH5DS8QgOv7O11/Mnrdwz440EHayc=;
	b=glpoVYb0feAjfn82dTVea/8IDEUYq9dhA2i7PL/KjOqx6bCMEfdR9c9N2CwbweGB69EuwZuqEnZJH5U5cbPNZ2Xxau6H73juXsAllldKJRIkQtRS+YAt80IQ75ApnkcRWa7jwTlOIMyxbDuHG1LwIaIFXp3eo24thOiJtyQu3Kk=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WsMaAaK_1763110460 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 14 Nov 2025 16:54:20 +0800
From: Huang Ying <ying.huang@linux.alibaba.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
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
Subject: [PATCH -v6 1/2] mm: add spurious fault fixing support for huge pmd
Date: Fri, 14 Nov 2025 16:54:02 +0800
Message-Id: <20251114085403.101552-2-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251114085403.101552-1-ying.huang@linux.alibaba.com>
References: <20251114085403.101552-1-ying.huang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z9utzr71x1nqiz5i18fiozxjbkak1xkm
X-Rspam-User: 
X-Rspamd-Queue-Id: 35E20140003
X-Rspamd-Server: rspam01
X-HE-Tag: 1763110465-249523
X-HE-Meta: U2FsdGVkX1/jGMwfMrTraXYgjoei6vTqn9Jq/yX+IyHk2LJASf0cV7mMDEBqFqv8EPtspMLNerk3+/labJtY5K+FiaF3UyB8fMFMbHpJOa3W32QL/LYY45rm1q+CO6iRku0s4ib2WFhsGt5IlSijQlRUfNF4htoOa8buiZr/Ds8CaSosNuTpyDsTw1EbQAqdsIfP6G2Yhac50nO/MtQfitIbqHxuqnFZ+6z74VJfmycC2aHu7Brdpvw8BQcWFOxXyZXBvIIYT8CQakDEENl9W2+abQ534Y0iQmOF7pJQLJkSQU+b47xvkyUL9NysmfzyXmQjDRxUw3xu17WXR/f9KzsSXJXdHqZJIv+NYqq91CP5rI2ic+0j36uOA4vIMxdJQeRvs9O6xbqP0LtkRJnOCKA8lEUlokpZlMIuGJI4iQ2Xskn8OvQd0n+SB/D6fplhHwqRknnoBOY6SyzrlxpUcdQXMNMmFSOeTMeWkqe/HjPkPU1qA+VnEmRHG9BCKTf8A1g8198NJvEsjNn+EA5HgggJVrbt/YzEsfhQ+G3z5A639w/bAqVLaHm9j7e/AOpOGp5U60mSlv3DX3sv2SGRlquuCtBS45l/d9oP8HgR/MK6Cg8llNSS04E0BKmDYvcxcmzBHjGIrIPfCM5GM01BC8GeI3dkodK0AelWUh8SveYVa2YSzAw1SzvKQJj+0bggQuNRzjQ52RPUyUElcdpVn1vIPNo/W/Xg4bTW1LHZSeLHawC3JU1FAAJLxNZGcR/cWEoHXy+aJWGrATMBerW5/uI9PmKXtHsTPAdYx3rUwwF4pcz5MsYwpITbUdInvm74eYNHLjuMZv07qSsl8mV1uyDmpU5C08yB5v95FlFI2aPjk+5qBv5h/Wu9425fmBb6CsvGB5hcXM+2UF7lCNXARYs/53ivAop67WON/yrbGQgXQeZq0nKU/5w8JnzToA4xzCtRAnyxeDYL+7QwzIE
 9sQ4A5IN
 Fr4ulUa7NzGtEEXmMGOlv28PNDg1+t9A58IxNrQCMh9oruvCLxEkULZYOXCZbqJApya/NaU590Pzu4X0Di3osxE/xkqNbIbucQEuk4mRGZbI1ZsFoXaSJedszkv65uuu2Xg3lgPYEkzOIfhbrROnXMl8GqWws2eek/bR7958S6Ks+L+YWqqtDemm8vGESUcjZfyD3oHk1OtbzDViO4tjaGX3gM+v5U8W9BeGG7q1gN4GhNWCx2UmaDe7qLqwHIKzI/RrJ0opvqCS0XcEzcyQ/sy41pddIaepWXvZjJsYH2EvK7lkNhOomTM08N66tSANuR5JGBF9Ozjn06RONQ1Di15hWcovVvXveJKWjSgEeK+XtDH1ceUAdqsXxWgxww3ierjtFYHIUitg2xpZ4PAfNsKcf6X+2zVXg6m21hAEOi58UY6EQpbkwXXBxu2Nq95l7E/TpgZ1VP860rj2KHL69KbISVbuf4ErxsIKP4EJ0DwOKXUctn0RLUpun7cxW6WDU21InFqX1EoHWTxA8pkA6W/1fni8HjYqlP+NGfycMxQ91poXr0IpsSwQcu1DvUQHcmO6T1eN2JHq2nRzo0WZw1GNmXvVZs2lGNFgsKNkC76sBh5D1lfmIMsa9+qmPqDi6RfrhxJAxTt14Re3sVMuCAHFzB7/26Q8pGzvHoYz+5nANcZ6WHOuXQeC51T1Z45QqOS9k9orVdgrzVPWkZESdUNPu5rhXW5p9w6GEUc9N1rmbsg2/I4Bdd6Cj98uAlj5iZMH0
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
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
index 1d1b74950332..c7aeb639d063 100644
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


