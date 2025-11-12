Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0203CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 01:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075BF8E0010; Tue, 11 Nov 2025 20:38:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025E08E0008; Tue, 11 Nov 2025 20:38:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09168E0010; Tue, 11 Nov 2025 20:38:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB82F8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:38:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6344A87E70
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 01:38:53 +0000 (UTC)
X-FDA: 84100246146.30.F857E98
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3BF8E140007
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 01:38:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LXM0CK+8;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762911531; a=rsa-sha256;
	cv=none;
	b=tVSvyq7hnWiOze0g/M8sioaZmkk3WCu4XneqIk2WHa373o2MDkLuNHGsUEZm6DSoE0zitQ
	ua4BGfrXV0LGFuv2oReDRGE1oNwgUtJo1q1Y0DwAJkNlCkdg4t7NjDngUnmlxpOoYAyUtV
	yC8OILJMrnXQI+AobM1YoAcUJdM2Xu4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LXM0CK+8;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762911531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=na5gxhjJoOyHwtyIYzc9OFiJbyudA6K7ZwaxzwkGzmw=;
	b=fyx8TVAmNT+qw/4jZi1W5QY/TqD1kalb7HWUdj9EBndIrNptwF3R3OelgvVx7TsvfaHR3i
	5lFTnoMArVTFJsaAy6IanuRBkQZdeVkEGhA46Xm+/e8JDjEBEqL6ZpYM2FAZscLIklQiNj
	Ic5+f3AmMBrk4gzlc1UmR0IfE0ks9U0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762911528; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=na5gxhjJoOyHwtyIYzc9OFiJbyudA6K7ZwaxzwkGzmw=;
	b=LXM0CK+8mFGinTJRn2g+pmFWJ2E19D1LV6fWAsbPKGROWHUl9i85dZH2tPk4Fq9zZjTxnSTzkqxnGB1Oq6EwmwUSn/iVOjbhDR7khiUXe9rHB99cKGCr9c9FMMmOCUW2VCMU1O8IehxexCjl8OKigyljj1oq37ySBE7HigYE3d4=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WsEIP3T_1762911526 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 12 Nov 2025 09:38:46 +0800
From: Huang Ying <ying.huang@linux.alibaba.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Dev Jain <dev.jain@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Yin Fengwei <fengwei_yin@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH -v5 2/2] arm64, tlbflush: don't TLBI broadcast if page reused in write fault
Date: Wed, 12 Nov 2025 09:38:22 +0800
Message-Id: <20251112013822.54334-3-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251112013822.54334-1-ying.huang@linux.alibaba.com>
References: <20251112013822.54334-1-ying.huang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3BF8E140007
X-Stat-Signature: 53xosuo8nqcies7cq3459jquq4771pes
X-HE-Tag: 1762911530-514232
X-HE-Meta: U2FsdGVkX1/9Z6m/Chne++iH2guineZLfEJV5mt+/oQJH5nncDg8bc3tZw7A1Gj9bujgqBUTzhHczyyveyjvMaA9dVOpgee3dG/KPbEuhO7BDRDD0Xrj07m8cm7J05eTcG4CyXoNIYnYUvbNPHNih2nvSEC+nNf5e2lRRra0tCcfRqMc8tPWyW2EKfBSQ1to2zEdU+H/T+OqJ/iqePR7ieTYvtrl3qR+HES3CKqs+ZF2ymaWlnfoDYtLm79M34QAPm6650jBW1MbS55kCs5fH3Z6ZdCHLphr3zGP83gjlRsUWeR9kp7H6EZ9J18WLn/+6S974Wwgx6ArRm03JlI6QFAZgOVTsltoXVhQXYeVcvxjMoa3hqpXW55uAL4qz9ebLpYzAeI2AP2PF/ng++7v516I90Ss81k/dJaJGtc+dChhJ+9goOTXNRXNY1xxgnrqwLT/QLDNabKjNrcBY62hIJSVM3CFi7gQ1oFa25x5A7cSSk1VfrkRTXxUIWxR9Id54X6BN8KwcDWMTlszXpaowTyimARH/8Jv9GZvNZcYCELQ4vVSUTGsoU74Uyw3oZSHV/wn9RnlY6d9zOF/VapVo5hgEa5kwbKAxWRIuHc3FPfzT6dak5E5QGAdcWWfOoBXV6UBubjkz6wKeo0K1PIkhbRq1vOLrfqhXAb8ZoYiE6eWPTvQD/s/oCdXui4OE3J6MFM0C46saWKXJi6dGqoy6KmxXvQG0eocWsmLB4ZbteRxtdTs7SXvF748n6SoWzNjEI106oy73UOAreZR+EsZ4dAyAbHRwyXLOg6WJWK6Tq7HmiirRKC+eWwNbMr2Lc50Jbg7eFsn7LN3GsZhwf6ehbmwEBjHqvkURD03D6wsFcXlc4lcszvcaUpbKYBReBcf5jQ3pcHi1zg5IHNbKfkTu30jfQz6C6nWHt0NbpPAoZr6+JRMGvr6X06Idv0vbGHJZ5wZk7Ez/incwU9Nk+h
 xinPEdgG
 kCD96vfAztuOh8xfniHaaa5phf0FfheCHtf0D5Vi16sTTH0TsK25Z0RKTj8XtuhXHYMOGDmMRY6Sr0Gb5UMZJGyDRphFa2baibtCDpZk8MhWBc7fp4tZfZ8ucXnPx2KAyqXJiQ3WGrMZeQJtUXiOQFxc6CLDlXBXYIH4ky6+yB18C9gA3fE6OYd22B+AJ/H43DhtnOo7KKLw2firCByAWnDkuGshmUosRjM4bwHZe6BPjtWCHYaQrpB7ZCS8SOXofjbyFkpjSfQjq1rW/8+9Gl+O38L0fi2dt3pEXTU80Zf3jy/iCwaUtJyOtqbfoFTSQIWoFDYI3uo6upYxtv4Nb5IIPKfNlZfg3bMLE8a+jOzCt5gO3bUzTYkaP89ASceasRZkr+ZhCVjH72d0TQXKt7DCb208neX0HbaGCbI2GW31EdxuAGOlIN3O2GDnP1ySbLBLb+0H/037eI21yzTZYk0B8gtR8ed4ml+r+Q+UMG2QHcAIGi9vV/KC44Xihv7Yk0SBU5DGnJVq0vmdum9c2KOAhqTRgi0yvB9YrnxTvQAibSP5Og1JtQlaiiIgy9iozdMEZTr3lSniUsjhcQGBQGnANDu16fzs3ocLS9c4g4YVHeodUw5bzKL8Uzc2GXrMAmx4W9dLmoW4bQ3sNJviHrACEQZBXRS0koyz/DZXWkPeoHvnBC5on7/xFTaaFA9MxruqLfOCtVzu4FXD3at1s7Z5olquw88yFCT3X
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
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Dev Jain <dev.jain@arm.com>
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
 arch/arm64/mm/fault.c             |  8 +++--
 4 files changed, 72 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 0944e296dd4a..9e1ff5195bde 100644
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
index 18a5dc0c9a54..682a01df71d2 100644
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
 
+static inline void __local_flush_tlb_page_nonotify_nosync(struct mm_struct *mm,
+							  unsigned long uaddr)
+{
+	unsigned long addr;
+
+	dsb(nshst);
+	addr = __TLBI_VADDR(uaddr, ASID(mm));
+	__tlbi(vale1, addr);
+	__tlbi_user(vale1, addr);
+}
+
+static inline void local_flush_tlb_page_nonotify(struct vm_area_struct *vma,
+						 unsigned long uaddr)
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
index d816ff44faff..4ecdfa6bcdbb 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -233,9 +233,13 @@ int __ptep_set_access_flags(struct vm_area_struct *vma,
 		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
 	} while (pteval != old_pteval);
 
-	/* Invalidate a stale read-only entry */
+	/*
+	 * Invalidate the local stale read-only entry.  Remote stale entries
+	 * may still cause page faults and be invalidated via
+	 * flush_tlb_fix_spurious_fault().
+	 */
 	if (dirty)
-		flush_tlb_page(vma, address);
+		local_flush_tlb_page(vma, address);
 	return 1;
 }
 
-- 
2.39.5


