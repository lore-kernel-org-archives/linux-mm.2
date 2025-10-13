Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51876CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 09:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494828E0002; Mon, 13 Oct 2025 05:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443B28E0026; Mon, 13 Oct 2025 05:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381928E0002; Mon, 13 Oct 2025 05:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 16A2E8E0026
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:21:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE604119931
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:21:33 +0000 (UTC)
X-FDA: 83992548066.29.142FB75
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4AE1F80014
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:21:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yY4ZrO1V;
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760347292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7wLOTWZ+WWqSVJaeLdV/JRD7YxTP+JiifLk05aZ72U=;
	b=3XSNFE9Xtv0dTcsaJqTq2+WNChEkmkb6h/QVFIU5WT7Gi5t8q+doccD2thzt1buct7XtRU
	rXzXFY7rueJ28zIGWLosy1orEyL1cq+aR1vmcHK6eLBp/OS6cnzazqGct1HWngu4bU03DH
	oA20kE6IhDpsjA/iudaVY34PiyKqn4U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760347292; a=rsa-sha256;
	cv=none;
	b=k4g3b+AhgKL6MEZY+VFXr7rxgwzPIRoqEBoEiLY0qmFp9IIlLKfs2TWM2hgWULc6En4XTg
	foHhZf6GhtphEw2liTDSYmNhbzc9zG9DHAG4o1d0A4Kweq6NCXzoZGqTffrL49lrWT0WN9
	Xy2ptJ7zyw7W/J79bJMhgYLzlZdeYew=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yY4ZrO1V;
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760347288; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=A7wLOTWZ+WWqSVJaeLdV/JRD7YxTP+JiifLk05aZ72U=;
	b=yY4ZrO1VJ7KzQCs4lXpmBbzWRFZljvODU+Z3JiPSCmcTfSUTjP+WWWgSIAQG4D+2+PZ/33fL1KuVFSUVaD7Bpd+tUXFzoXsuSyLfsaplrH8SVS1khwHIXOzMz3eh55aMCAJHWRxkuQBqkuB89XJUxwkIh1MS2xw5ErSXtOZlWtU=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wq1nihE_1760347286 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 13 Oct 2025 17:21:26 +0800
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
	Yicong Yang <yangyicong@hisilicon.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Yin Fengwei <fengwei_yin@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH -v2 2/2] arm64, tlbflush: don't TLBI broadcast if page reused in write fault
Date: Mon, 13 Oct 2025 17:20:38 +0800
Message-Id: <20251013092038.6963-3-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 9cogbr7r6edt741q8orf9hnyf4eek5mf
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AE1F80014
X-HE-Tag: 1760347290-805992
X-HE-Meta: U2FsdGVkX195G0wAqa86IVTU48RILfWRAwGPw3y0psEpEgfBurqKz7MQzNotu77pr6yhFPBGCcjsW671YSj9QKXdYTglpiJpd2UrvRq9tVSWz7277iB77vhXByuMOC+B0A0P0F0D3E+kp9+LzdPD4mbbqES7joDFGm6bnlggcMPwUWg37vCDZhnGnGI3MJpT0F+uhAqJTOKJO4bMo0Ju/57pnIRE7Pm7g1fvyZ2A6TyuLzX9kMXSUrzPBqlFnyPbPKESFwG4QDdLLAaCE046uGZsJJNjNva7jZ7M41/Rhfg4WId567lq8qhHwMrSLDIeblrpYEExizawjMmMCOcHHAX8O4WG/Arq3YdPe5f6b7vb/gOx9SmIzrldUHY4goEMxNrXYqWdpDplI8E094mEysAo3lbmS6QYgSAz68NJKdGXQ+HoLKrvsE8chYi7uHMs1dSumz6N7E9N2GMqo8ebn5dPdDDwqd12cGrFEbin7A4DKSorzER6KLLMSVJcqKQZ83qy3iMlX2UflMdFDaCrHS7jqnHD6LRbS7WngvbYHtWIoRCV/lVUCju0v0ClF9F1jucXzJaYd82nR1n7x6H/oTdSL2ZwAsSMTxyNhYmVJlcBtITZoKTRpLQfJvk/FjxFeJ6rXsRUt9BNtAfPqOVyzg3GLESra1GJb4GcchmpHDkryK/M9TC2g7yJB9T1zFPi/7BsgqWHESKHQmCZiSa7pteLu8rz+USsamcgBGQ2CWz4Kw1SF4PIdC4JhxxYmgLENH6CS17B1wQelzAfM+0i4vH+Daz4BpUJaNDajhPL78puquv06kgpIUF4uCjjtc4PNssiThyMmyrwiMZi3If7pcqRFhHDYtagxTYd0ndQFxBpIa1qTmRd7q+0dFM10xRW0y/Jutyh+CrKbzNc8cPZKOwM0YLSYpI7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A multi-thread customer workload with large memory footprint uses
fork()/exec() to run some external programs every tens seconds.  When
running the workload on an arm64 server machine, it's observed that
quite some CPU cycles are spent in the TLB flushing functions.  While
running the workload on the x86_64 server machine, it's not.  This
causes the performance on arm64 to be much worse than that on x86_64.

During the workload running, after fork()/exec() write-protects all
pages in the parent process, memory writing in the parent process
will cause a write protection fault.  Then the page fault handler
will make the PTE/PDE writable if the page can be reused, which is
almost always true in the workload.  On arm64, to avoid the write
protection fault on other CPUs, the page fault handler flushes the TLB
globally with TLBI broadcast after changing the PTE/PDE.  However, this
isn't always necessary.  Firstly, it's safe to leave some stall
read-only TLB entries as long as they will be flushed finally.
Secondly, it's quite possible that the original read-only PTE/PDEs
aren't cached in remote TLB at all if the memory footprint is large.
In fact, on x86_64, the page fault handler doesn't flush the remote
TLB in this situation, which benefits the performance a lot.

To improve the performance on arm64, make the write protection fault
handler flush the TLB locally instead of globally via TLBI broadcast
after making the PTE/PDE writable.  If there are stall read-only TLB
entries in the remote CPUs, the page fault handler on these CPUs will
regard the page fault as spurious and flush the stall TLB entries.

To test the patchset, make the usemem.c from vm-scalability
(https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git).
support calling fork()/exec() periodically (merged).  To mimic the
behavior of the customer workload, run usemem with 4 threads, access
100GB memory, and call fork()/exec() every 40 seconds.  Test results
show that with the patchset the score of usemem improves ~40.6%.  The
cycles% of TLB flush functions reduces from ~50.5% to ~0.3% in perf
profile.

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
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 arch/arm64/include/asm/pgtable.h  | 14 +++++---
 arch/arm64/include/asm/tlbflush.h | 56 +++++++++++++++++++++++++++++++
 arch/arm64/mm/contpte.c           |  3 +-
 arch/arm64/mm/fault.c             |  2 +-
 4 files changed, 67 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index aa89c2e67ebc..35bae2e4bcfe 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -130,12 +130,16 @@ static inline void arch_leave_lazy_mmu_mode(void)
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /*
- * Outside of a few very special situations (e.g. hibernation), we always
- * use broadcast TLB invalidation instructions, therefore a spurious page
- * fault on one CPU which has been handled concurrently by another CPU
- * does not need to perform additional invalidation.
+ * We use local TLB invalidation instruction when reusing page in
+ * write protection fault handler to avoid TLBI broadcast in the hot
+ * path.  This will cause spurious page faults if stall read-only TLB
+ * entries exist.
  */
-#define flush_tlb_fix_spurious_fault(vma, address, ptep) do { } while (0)
+#define flush_tlb_fix_spurious_fault(vma, address, ptep)	\
+	local_flush_tlb_page_nonotify(vma, address)
+
+#define flush_tlb_fix_spurious_fault_pmd(vma, address, pmdp)	\
+	local_flush_tlb_page_nonotify(vma, address)
 
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 18a5dc0c9a54..651b31fd18bb 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -249,6 +249,18 @@ static inline unsigned long get_trans_granule(void)
  *		cannot be easily determined, the value TLBI_TTL_UNKNOWN will
  *		perform a non-hinted invalidation.
  *
+ *	local_flush_tlb_page(vma, addr)
+ *		Local variant of flush_tlb_page().  Stale TLB entries may
+ *		remain in remote CPUs.
+ *
+ *	local_flush_tlb_page_nonotify(vma, addr)
+ *		Same as local_flush_tlb_page() except MMU notifier will not be
+ *		called.
+ *
+ *	local_flush_tlb_contpte_range(vma, start, end)
+ *		Invalidate the virtual-address range '[start, end)' mapped with
+ *		contpte on local CPU for the user address space corresponding
+ *		to 'vma->mm'.  Stale TLB entries may remain in remote CPUs.
  *
  *	Finally, take a look at asm/tlb.h to see how tlb_flush() is implemented
  *	on top of these routines, since that is our interface to the mmu_gather
@@ -282,6 +294,33 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
 	mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
 }
 
+static inline void __local_flush_tlb_page_nonotify_nosync(
+	struct mm_struct *mm, unsigned long uaddr)
+{
+	unsigned long addr;
+
+	dsb(nshst);
+	addr = __TLBI_VADDR(uaddr, ASID(mm));
+	__tlbi(vale1, addr);
+	__tlbi_user(vale1, addr);
+}
+
+static inline void local_flush_tlb_page_nonotify(
+	struct vm_area_struct *vma, unsigned long uaddr)
+{
+	__local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
+	dsb(nsh);
+}
+
+static inline void local_flush_tlb_page(struct vm_area_struct *vma,
+					unsigned long uaddr)
+{
+	__local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
+	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, uaddr & PAGE_MASK,
+						(uaddr & PAGE_MASK) + PAGE_SIZE);
+	dsb(nsh);
+}
+
 static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
 					   unsigned long uaddr)
 {
@@ -472,6 +511,23 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 	dsb(ish);
 }
 
+static inline void local_flush_tlb_contpte_range(struct vm_area_struct *vma,
+						 unsigned long start, unsigned long end)
+{
+	unsigned long asid, pages;
+
+	start = round_down(start, PAGE_SIZE);
+	end = round_up(end, PAGE_SIZE);
+	pages = (end - start) >> PAGE_SHIFT;
+
+	dsb(nshst);
+	asid = ASID(vma->vm_mm);
+	__flush_tlb_range_op(vale1, start, pages, PAGE_SIZE, asid,
+			     3, true, lpa2_is_enabled());
+	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, start, end);
+	dsb(nsh);
+}
+
 static inline void flush_tlb_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end)
 {
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index c0557945939c..0f9bbb7224dc 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -622,8 +622,7 @@ int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
 			__ptep_set_access_flags(vma, addr, ptep, entry, 0);
 
 		if (dirty)
-			__flush_tlb_range(vma, start_addr, addr,
-							PAGE_SIZE, true, 3);
+			local_flush_tlb_contpte_range(vma, start_addr, addr);
 	} else {
 		__contpte_try_unfold(vma->vm_mm, addr, ptep, orig_pte);
 		__ptep_set_access_flags(vma, addr, ptep, entry, dirty);
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index d816ff44faff..22f54f5afe3f 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -235,7 +235,7 @@ int __ptep_set_access_flags(struct vm_area_struct *vma,
 
 	/* Invalidate a stale read-only entry */
 	if (dirty)
-		flush_tlb_page(vma, address);
+		local_flush_tlb_page(vma, address);
 	return 1;
 }
 
-- 
2.39.5


