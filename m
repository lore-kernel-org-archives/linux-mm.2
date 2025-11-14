Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A5B7CDE03C
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222C68E0010; Fri, 14 Nov 2025 03:54:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 187C38E0012; Fri, 14 Nov 2025 03:54:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1B88E0011; Fri, 14 Nov 2025 03:54:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDFFE8E0010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:54:28 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 883021A02E7
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:54:28 +0000 (UTC)
X-FDA: 84108601416.22.19712E9
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1007E140009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:54:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fBEUcR+3;
	spf=pass (imf09.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763110466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kydea2ERvGOkNHgKcrHhLqiFo8q78ufRCZwLw/rrafc=;
	b=B+ItjRLzzw4V+D1d2VgwUJaZBUzkQoJF9doR45YA6ME5s/3ZoIbaVNlWMDWXmQ24YqzOnc
	3LsWea9I8GHIhot1h34MnZ+wRNoPQTpKPQWbh8L8QPl+mz247idfCCP0NDCwjhyFFB/yMi
	uUj85lbl4uypNlrqu3QLkbhBJ6AUc5o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763110466; a=rsa-sha256;
	cv=none;
	b=WJYGQJR73wMdUKW/joNbAMdMD3JTjbtvEhT1tjeLK3ZgTOUJI1CvrowEaPGaD2i/FVEQF0
	6l5D/wL7y9nZEDgS4KRWk/BbIEHINUUP5MdNWJx1r5W2Xmi4J1LZRTtdhpzVCQE0fZLJNb
	OeCjntD2cA68altZbmJXiYuWQBNuEGE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fBEUcR+3;
	spf=pass (imf09.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763110463; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Kydea2ERvGOkNHgKcrHhLqiFo8q78ufRCZwLw/rrafc=;
	b=fBEUcR+3ndqVa0BGQdnaVS7TiXrVJBkZaNwjB+Iz8lxEWo0MkWL5IOaCjBNziUb5i3P5GFH+nqu9vPL3NUFqqLSbitTXVHpYAcEaJ4vdSN+prXI+LzEFAnaPMk8QROzeXqgHQr7tOR2b45jy0lgfyzwR/XXjJMOCDkTW+kSHBKw=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WsMaAai_1763110461 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 14 Nov 2025 16:54:21 +0800
From: Huang Ying <ying.huang@linux.alibaba.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
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
Subject: [PATCH -v6 2/2] arm64, tlbflush: don't TLBI broadcast if page reused in write fault
Date: Fri, 14 Nov 2025 16:54:03 +0800
Message-Id: <20251114085403.101552-3-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251114085403.101552-1-ying.huang@linux.alibaba.com>
References: <20251114085403.101552-1-ying.huang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pitipkbotj6yg4wywjmsayzb8z4djg6i
X-Rspam-User: 
X-Rspamd-Queue-Id: 1007E140009
X-Rspamd-Server: rspam01
X-HE-Tag: 1763110465-485954
X-HE-Meta: U2FsdGVkX18nnVFHx/ZNMazNyqX2JucivNsfph3zbZsDwqynqvjSCWWad/wsHkPqjil0LUprtkoPLhEjaDUZaY8GRxlskK/LC6IEXIB59ketuQwQmbYa/mkUUKTCnq0t1U0bWX2n2UFLH0W6H+Ih/JJj93cJZIMb3VRwIB74SBYvg8QOOdqif6sLq94uV2uNFPAcCo4+UHcXAY1DVALPcgQGYJRTtG4rC0w4TcClTo2w3KHpV5ROSr35mDvzkB0bFVp+8DN1Lh4evwORxYVYbToYAzrnBvV0nGswSKrgzzoce98LWGAkEO2T7KZpPFPHu28h7Ve7b3PGZ/DDYC7ZD/9/vKRda/84NJ0Osyo22U3k/S+QRHmVp3iJEtT4BienObzGnZiNxNSBmZSq/DcY0/yrCdnq+kx0STAe/SFODdt2HrZrlp2Fsa67tSy8gtFFSMr9O/HgBZaAsq0GVhZrWLLP6YnpWqojWR3zhh7BlQ6ITwWyCnCVgK00VTB7u0bQGtNrRiq/OjsGt9h3Z2Oh0sA+OIbYawq7dMENTgzn+tr0SKPFRidaWiNOshN+x2AvxJQegNVVEDdawgTLvdcbVvD+e0RA4gMfhVvNCjMvkIuLoT/XWep6flOdSvITvjXtTVVTxjTjEk5vwZC6irf0zOsdqmrb6xGqhuZS9rhYvlJda3d31+8/6Bnpf6rExQ7bd2+A6iv4Dl80FBsrobOElyjt7MCmTgzZYvELy/oJC66fWIBOZ+cOOi7iS++jfLsNbtJr/40maIJg5KG4m1T28e9BcJgVeHhvPILlZ44lwTZeikLInRabLr9Y1AFpqCZwhctISeONd1ED0yf6/CGwVjK5qpnnpFjLW8cMFaHBT3UsnK2I8OS2iiIEAkcDCxULNneCX8avqttKEQCF3FeYQr6oabw4cdanPvpm0BGtt0XlMMZxygJA1T+eOnaP0ViBf3hzOw/uUJmJcMEWkWJ
 8PVzEplY
 +QWppiOg2yi7YZ+zIpmhRQmpu93EnKT831L2YL6Rqs8kdHWVnqYQ+kedAdPq/adDcVOKm8nprES7hVWH1ZK9do34JbmB9+A9XdSdtdo1Ik7n2B1eiYcpbJHlK9Duc+QmEmpTbqsruUexTzH3zl+0W/ot8KqdiTvs5iAvajvlHgzHwahzpBMkIDtGMQjN5rymOqBE7FoeTlD4Z6BNdH3dnGxDsgqTPQfWNNeKmE9jjFGozFJCN5VD+kg0uSsQYUj2EeoO+ctupg+DutWJzyVIGUldhXO0+JZCdsT26FpVnhUtU8xC1aryoBt8wXrbh8qesa/Fnhv5FUgtrhMrtnkC+QcOGbt3zwb98mauvGHBONJrkhO7UUrrOipXHg51jWOM9clrlSaucGz/+cvWb+Bx+GVeaIuKrwzE3AdLnOw+Z6qeCno0/MnTzpqWJewn3Mw6TOQTqellRIeDwNdxSUGbMJESrEYDVr/pRB70HROnVIP2weX0vGJpJlDNNCvsrONwYUd7fUMu/Vz62YaIX+Racl3u7czjXrWqSbJH7PZnM9Aqze3Fx4SFokcuaKYN5enus+CfI982TCyp5RiSFpgQUbaHAv4qfvaXHQKRsUGmZVB9EBN9TUPaB2CAdEZZws0ot2oLSqxH/SCDL8rsNSBlFyGE3VG6V5RzbiuOw5rgUE1bolamvPehVutZ1sBGFEGLHXspBx/UJjFa0DyOEMZWitKLpCPO+vgPxk08U
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
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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


