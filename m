Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 475F2CD1297
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 01:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2112E8E0002; Tue, 11 Nov 2025 20:38:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0848E0012; Tue, 11 Nov 2025 20:38:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4E68E0002; Tue, 11 Nov 2025 20:38:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC1698E0008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:38:57 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F99D5801B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 01:38:53 +0000 (UTC)
X-FDA: 84100246146.05.1029DE9
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf07.hostedemail.com (Postfix) with ESMTP id 287344000D
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 01:38:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tMDXmwB4;
	spf=pass (imf07.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762911531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/xXceKPMp8UFg2aPwvJeptDALB/4lrD/age8qUK3AD0=;
	b=LPQ1vc1On+G8DbTvFRnKpLc4cTM9Ipf69NDxcUB2CtDhpG767A1tqQJgY1k5YEwflnECVt
	6hQ25mLItG8tZTD5/Hvmt0TOGjBOndIbj4i9o+oP8kocHOWdnQr1hzNi+AdG+3Os/VNR2o
	ZbQet1cz6odi/fDAq0jAdUKJJMKOBfU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762911531; a=rsa-sha256;
	cv=none;
	b=tZi/Y6vnuNsUMcl7wbNOehrLOTGQzDh8pZ8E/RV4KNfoTjCMm/72XJrkaY39msNHhYaWoA
	gUC+1MQMe2cW+XtKHQ4nE30amd2XHwmylQWr1S6ty0nDSEELwG/5Y/IZrpFAXExZCKoN0k
	d4L/9ppNU4a+BK2H1ggN+Ew7aO0OuBc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tMDXmwB4;
	spf=pass (imf07.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762911527; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=/xXceKPMp8UFg2aPwvJeptDALB/4lrD/age8qUK3AD0=;
	b=tMDXmwB4sKQYZqo3MiqzBn6qOuQE5KAqwu6HHK2eWhKcq9Su0Qm8t08VcHVg2u5YhdmVblmq1hGbAMojvcjsjTmJLrbvFy54NcejF2osMGoeVpA5Wtl/exSq5t/zbU/E2SU1M+ANhP+zZAaNfcDCjU6DxurDJQR/kUczXOzB41Y=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WsEIP2t_1762911525 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 12 Nov 2025 09:38:45 +0800
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
Subject: [PATCH -v5 1/2] mm: add spurious fault fixing support for huge pmd
Date: Wed, 12 Nov 2025 09:38:21 +0800
Message-Id: <20251112013822.54334-2-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251112013822.54334-1-ying.huang@linux.alibaba.com>
References: <20251112013822.54334-1-ying.huang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ygtcj8osbmb5yjjirbo916dntjjceibf
X-Rspam-User: 
X-Rspamd-Queue-Id: 287344000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1762911529-648285
X-HE-Meta: U2FsdGVkX18OHaVsi7qPnWqh9106z/UufjGq+AVWNSNSu317buMtGx1kQUGnYAla4aaieLHwYM4tx1iN4g7gYQCAy5ytXav406IiuXUifJw1KEfUeLnp9Tcp/+Nthzg3UdnMGfDmEnKn1PdJ70nUq363MIJ/xRgHHRW1/Xc9kU3nJJrObh88XHlbZn77X8sW1bEiPgtMa+Sc0tUIJit82xPf5N79S23QC3MGEuc4l59kMTfL4q3bc0/EPdgsb+YJDsdX1YkhGi6JmkEAn1QVpIRMuf5BuAsLdgutu/CaY7rqy1EjimZK4Yy1fxH5H5j0DuG+Rivp6cpXibVOm0AlMEupy+mbrV8sqQJBfX5itX5l2SpsGEKtYhn6gGf5PL5dqT5VOzCzJk/x8e0qAeQVwpptlKIROllScfZTzMwYdNiXjqIEebJUeWczyminml9j1H6pCHaYfI6oQ1e3zJfwy4TyhBpCAyKKgLdHNggBa3p0MUZmSCmH/n8216b4WdnFVuIdTXdjom37o0MnhplGHyB0dqcaO8DQtRsiJHg1w3OjbfcR2Aly3H6XGtjAQGDNeIXxsoQH/ZFihGXDZyBDoni3XwoJ84Lu3rW/o5YMZbBVHiEBwNvRR42ehOTI8qazVcdiih+qUe1azWUis/9utx1dvTOnl6Gpn/aEyuOrZOfLD15fcbQSciQoWRsU3EL2LR6v//2eQ9NTlq30oQOkM+SI9kL+AZFfwKfK6VRCRXvP7q4ZBTrPJgGiENI3G3j4XMl4dZP30zKZo7KXrdcJ+eM9dHcLdOq8CYkynU+sSrSrEjsnehUfYwngXU4ePLb2JBTKCbV+E+JP7Qx3W8N1mOdTpeRRKPRpvLtWLB3B5hdrfIM0mAt+l6TDsS19PAnv0fx+4VR5PWujzuQuZSCc5I6hi+JdlChqXIWfEG2Ze2hXgFaCiqOJCdVGyPcHGoizT9ZhPQHsnTDISA0dbYh
 kVxGYFzn
 Uf1++CXMSaWPsrWUOcRn9SCxmHH66v2yZUovRqd+2yDIBwbht+Gvk2cpu/vEymvGZwQWgex2cUZn7E3wISsJ7byV3pZTrtnC234akzsRLCjZMdF3L8YGgkmdtDQrp781sbKYjpuJHXtQ1RTZKiZqVYY72J0eCjMUQsxpFZqmldYGpxn+h0JfXfQTwOvm88llx7njmWrd3YMAat3pE/oY3Bn3UG5xReSYz9lAvd8OE3tsbqCCZLSLruvZpus/gTjpMh3oNV2hWTxRe/gpOUNwIQJN8Z5yYYmDIfah/lpunyLuz9jqNiFvH5kRYXJHFw7wuQwMzSz0zKA4blVVTh96FUBVpxplQV2IZuhAJDgxb/iy/ZVxF7DVVvudgQoFy0IZ7oTUbBCDtMRa19ROExSQGYuIXoorNV7Jegt/cJtvMiPg2Yn7wt+yWwiMs2dwcdxdBF7P8bQa2B6ZAUutrEcEqdPglRnCrNHdANql47X5ASrnytcYNfIEERF/I2y3raPca2lREh3+yN2YK9oS9dooqtVid+5fMhAsXqLYgzoJswQjkPHodkeBFm2GW3j3HVrTw12IQr2rf/epyX22snA4vsw3hArRv6tsZ+gvCLv2VpQc7hdiKyblj0lFoFiUaDlpY9wMbM8UcFXfR5xLTYIG+fFSPNB4rH3rIS1VGplpeXMVIRah7HMt7qYOnC8m3pkTLvgShxmdTSPbedS3Gd5AWi/V/3IRktkxhfQCk1UF9uvZVO5ifFp84ai4wPtGPzxbdvr61
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
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
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


