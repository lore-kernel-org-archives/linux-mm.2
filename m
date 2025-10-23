Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E64F1CCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 907F28E0021; Wed, 22 Oct 2025 21:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8878A8E001D; Wed, 22 Oct 2025 21:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5542A8E0021; Wed, 22 Oct 2025 21:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6D48E000B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:35:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C333848F35
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:35:56 +0000 (UTC)
X-FDA: 84027662712.29.A77C4C2
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 802C2180006
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:35:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=S3cKaMM2;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761183355; a=rsa-sha256;
	cv=none;
	b=nysvCP/iWA9QYNBCVFCBVnnEa6MyQFqon9gudEw1bgvqn+ingHCaLEoJdpBaw1lcIV/Hui
	tHy5fYDE0lQjvbTlDlxAr36d5fIz7A/thDIsoiwEYat+Fiy5lvCsLsscAWQeOYe5U1xPUl
	l5z+VNfriURuMd4S/VLZRaU94TVfUH0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=S3cKaMM2;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761183355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZoFZJoxb9y1LZCkJZmtsvoXzYL6A98kvYGf4H0CrGo=;
	b=sfmiO6JUAyUrUm/xWchYalxBJ/2rPIb3KNvnmRgA+lO+KcAqN1hmnPnQ1wR1pip2eTaprZ
	+4nYpOHTzEnKxmpH+sMb2/S78zWtNma96kcuf5/IFi6QOy59fhP9MzcdeYe+eH9ecQNCAt
	FFIN8Ht9e+muolYx1O9XwjouZCa3uGo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761183351; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=xZoFZJoxb9y1LZCkJZmtsvoXzYL6A98kvYGf4H0CrGo=;
	b=S3cKaMM2tt1+ZEXKfeT+R5KCrldqOtm90skSeFXrnP9FpErDMnrBc2PCv0tYfl52D3fSvQm19i68kM9ffhcWTRNKp5XOskp/Gd62D2x0jwoZAhSHZUbry57qqd9OshagSKDnLohTnmiV33u47G03AZFKjQPVDUVLkK6R1IwH8NU=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqogSiG_1761183350 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Oct 2025 09:35:51 +0800
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
Subject: [PATCH -v3 2/2] arm64, tlbflush: don't TLBI broadcast if page reused in write fault
Date: Thu, 23 Oct 2025 09:35:24 +0800
Message-Id: <20251023013524.100517-3-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251023013524.100517-1-ying.huang@linux.alibaba.com>
References: <20251023013524.100517-1-ying.huang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cqbq3qno8m4op3nxgdpyfu955ggccdo7
X-Rspamd-Queue-Id: 802C2180006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761183354-560357
X-HE-Meta: U2FsdGVkX1+i53+Qs8QXkPB+5N59q12KBc8d8nIFQU0X9qhaD0HwkJhyJUw5NEp1zW2/u0W9CEmDiaYGjIUSo4uybgqfIWODywCH8AOhEuJZ7cdRgmIFh4iPuAr66+5dj/ae2hPBoaybX1WuuhOdxvo3KFXZp/N9r+ojDNYPhZNy9vg9RtJCs07AcNEDJB/pB2mWYLISJHAiD6s8TZNeJdQ08KvGW1QlHhmWdF2t+pkAoFWRmwHFmZPntZmvqz5Hw3OarLY7V3erhCp9EdhTPMzWPgxTTX8ptM7CE81PNFFxIZYEHaCDfZUdaVELT6chQn9PvIMvFF85H0NuSpD2oCXmiKwuaWjLfikI96O+6Ymnk57e/oHvRLT/XjFrzne4iGpXfOU5LwaMTjPMGFcpYggeyHCUTN2HJDRvNxcN+BXqbGnRTtgUn5pVJsT+dNJ1p+jZPiq4P3EZ4JiSaVM9SOzMk7vMl+jGs82W4lyb6FySaGmdIS3oYDrsy2tp4VgSUmNNHQkIWvA4l/bTvksMsJzGGxKqKxWBhtJaT7+Mp4FHEBYglwqwn3qdznfdoMHij87sJp3slkt0hh+uc0tpxiZxrR+fjchSdBCFfNLvS747lAavbOBPVRM4d+Ims68KFvAGoRQUXLZhbZWtrrm1L+YhpX3PwZD+PZei4eauyvx8WQCUDtJmIuuaLT2rEczXcS+xonzJofCQyWbPHs0bi/bvptkbjSAZpGzmIeIAHrzueSTtpacsba87hYRHCI/jH37osEX5pyVSxT18ID5+fmG5Z5tLw0o+q4bA2ETYt6XNXDpE92MYpPqLAmxWmY+loJnLS+WfoumnqVNdDiaRNyn4rg8FfZfP3z8TREkUPS1KLLxOCwICCkscmOkZ8LsObV9/8Ds7tE920BlVp9qKuC8ElknuoL59aj3oO2GYPPsZ1LabfC4u2PrATlDqGkyxPTF4e9+hJypRj3XCA+V
 +LkWkbE1
 EOpP6gnq35EKtZieKiHezPuAYfHD6JOX28JW4l6zaggHcem2m20qI/k0rkrGxrj7qgjEp5hzBUILkXuMYBGBLLJvPsdVYPFwAKZibnWcjRqOxo/z1lTJeBheYUq+dDcTZzLQne3QBDK/9gYii6nBCRXIuwqSh2/FDH/vsCVwuI5lsse5+gHyFZ2R/lY0H0QaU/PJZ/OY8U4Rvqjc44jCbARHZ7P87FsKyBW8eUVTUA8j7GPMtnQah4S5y94cIxNRx2Bv5JUgGFQLJyb6Wo07ERa75IyiO+JUHLmkBRRirgru9hd3QUxSHYY6LcJvub8LbFQvPTb5OBYxj+dfz5rcnOKcucZXB8wCHEpwXxJGGR8gytruEu1KoSSGQ4FoC635VLi0ix+Z7z0psae2tD0MAbPV4RhaO9RrdDHneNTWFuLEs3ffUe0EqFsn172uU3ruhRV2dDwEk/M2PFDJQ82AbilN4sKF++vI0P3XwZ5OMW/rnDjCtUcOOl9Yn7jm5mYLezC+/xTDbFVJ4voNOMjspbHvcHCtGaodPoWCoRQ/AgZIOx8CfKActXirvcnhLbtwvF915IvbGC1fY9DMegaXy4O2e+i5OjIYqq9T1aTmKl6XRZ9+b8NLcwPBMcM1Y83ValbTH07mNU8cqXPyu4O2IG8hXdfc+wqfkU0GEGk1s954volQ0Qx23yl2FpL2KzPnZUDn4ZEwtp24It+4jM1tWkTgR5haXGL5SWW4O
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
isn't always necessary.  Firstly, it's safe to leave some stale
read-only TLB entries as long as they will be flushed finally.
Secondly, it's quite possible that the original read-only PTE/PDEs
aren't cached in remote TLB at all if the memory footprint is large.
In fact, on x86_64, the page fault handler doesn't flush the remote
TLB in this situation, which benefits the performance a lot.

To improve the performance on arm64, make the write protection fault
handler flush the TLB locally instead of globally via TLBI broadcast
after making the PTE/PDE writable.  If there are stale read-only TLB
entries in the remote CPUs, the page fault handler on these CPUs will
regard the page fault as spurious and flush the stale TLB entries.

To test the patchset, make the usemem.c from
vm-scalability (https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git).
support calling fork()/exec() periodically.  To mimic the behavior of
the customer workload, run usemem with 4 threads, access 100GB memory,
and call fork()/exec() every 40 seconds.  Test results show that with
the patchset the score of usemem improves ~40.6%.  The cycles% of TLB
flush functions reduces from ~50.5% to ~0.3% in perf profile.

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
 arch/arm64/include/asm/pgtable.h  | 14 +++++---
 arch/arm64/include/asm/tlbflush.h | 56 +++++++++++++++++++++++++++++++
 arch/arm64/mm/contpte.c           |  3 +-
 arch/arm64/mm/fault.c             |  2 +-
 4 files changed, 67 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index aa89c2e67ebc..25b3c31edb6c 100644
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
+ * path.  This will cause spurious page faults if stale read-only TLB
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
index 18a5dc0c9a54..5c8f88fa5e40 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -249,6 +249,19 @@ static inline unsigned long get_trans_granule(void)
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
+ *	local_flush_tlb_contpte(vma, addr)
+ *		Invalidate the virtual-address range
+ *		'[addr, addr+CONT_PTE_SIZE)' mapped with contpte on local CPU
+ *		for the user address space corresponding to 'vma->mm'.  Stale
+ *		TLB entries may remain in remote CPUs.
  *
  *	Finally, take a look at asm/tlb.h to see how tlb_flush() is implemented
  *	on top of these routines, since that is our interface to the mmu_gather
@@ -282,6 +295,33 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
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
@@ -472,6 +512,22 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 	dsb(ish);
 }
 
+static inline void local_flush_tlb_contpte(struct vm_area_struct *vma,
+					   unsigned long addr)
+{
+	unsigned long asid;
+
+	addr = round_down(addr, CONT_PTE_SIZE);
+
+	dsb(nshst);
+	asid = ASID(vma->vm_mm);
+	__flush_tlb_range_op(vale1, addr, CONT_PTES, PAGE_SIZE, asid,
+			     3, true, lpa2_is_enabled());
+	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, addr,
+						    addr + CONT_PTE_SIZE);
+	dsb(nsh);
+}
+
 static inline void flush_tlb_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end)
 {
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index c0557945939c..589bcf878938 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -622,8 +622,7 @@ int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
 			__ptep_set_access_flags(vma, addr, ptep, entry, 0);
 
 		if (dirty)
-			__flush_tlb_range(vma, start_addr, addr,
-							PAGE_SIZE, true, 3);
+			local_flush_tlb_contpte(vma, start_addr);
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


