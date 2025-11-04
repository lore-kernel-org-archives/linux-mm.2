Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88863CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31AE8E0118; Tue,  4 Nov 2025 04:55:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70628E0128; Tue,  4 Nov 2025 04:55:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10EF8E0118; Tue,  4 Nov 2025 04:55:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46E9A8E0118
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:55:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0133D1A029F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:55:58 +0000 (UTC)
X-FDA: 84072468438.19.B715F21
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf22.hostedemail.com (Postfix) with ESMTP id ACFADC0006
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:55:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="noUJS/gn";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762250157; a=rsa-sha256;
	cv=none;
	b=eK4muqC52olfXjTm0nOd9CqJj1qxTlpn0E3eoO9uufrr0m1OnBF+BhbVPJGzVDbyfhTyKG
	mRhrRSrrNdfmj1bA/92eGYKhFLSPghW8Gn7U8eoqSxRaqDcPjHg8vZaW3TDACixjrVgxWM
	skLa+bPDFOAziEgp6tcxWjpojWBcWVw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="noUJS/gn";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762250157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMlfAlUP9v3JsGfjULVG+gf8uvtLv81h4yynv7rUlLA=;
	b=CVfkrBUs10TraYwBV/U8FkbTlYfCUexzLWoVwMJVe0LrhSM/udTd+CR9xjf4d2FgAbpPvf
	mE4oVwT7YkJgoyqueN1Kh0R9BUsE6JOF5RyRnZJKp25/EitsMKnqxDqdmuM+8lDx7uESQK
	Ll0JMdeejZDYrxm5OLSgiq7gqRjPkRk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762250153; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=VMlfAlUP9v3JsGfjULVG+gf8uvtLv81h4yynv7rUlLA=;
	b=noUJS/gnbyFqAe42NNP5aYYGdKZGanuz1EkLWJMgusnFANWTqoZiOC4joVJXyH/C7Y801kXRLGk60FLL9qtjdSX8AboCqOLo57Jc3hFhGJbP3qSWtk2sx5ga04Wy0SvAtiJ+CH9qEFibF6JKs08QN/7zVmYADBOcJBydcYK5q8E=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WrgsU9w_1762250152 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 04 Nov 2025 17:55:52 +0800
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
Subject: [PATCH -v4 2/2] arm64, tlbflush: don't TLBI broadcast if page reused in write fault
Date: Tue,  4 Nov 2025 17:55:16 +0800
Message-Id: <20251104095516.7912-3-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251104095516.7912-1-ying.huang@linux.alibaba.com>
References: <20251104095516.7912-1-ying.huang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ACFADC0006
X-Stat-Signature: akye4ugd47fwnuzwjpgceaofb84um5zq
X-HE-Tag: 1762250156-126462
X-HE-Meta: U2FsdGVkX1+hYs250cgZvdQ2KGdwzVTboptwlIzfY1uxjmFStuk0lrl4ZrrIPfzJ9aEIPhvWtdQSfrk+VWVMQV7RmdPZzD6sho3x4aW8QSBUVRhzTZsntu2yaMGEUda8pmNb9T9RfIkgrf44oT+2cjZs2rrJVBX3b2tl0rSru+VOOfdggj6ugw0BBjJrjuleZKrpg86rLhekkmW4yRz56ghslHeNYr6hqOCEpbFX/Z/rcgtMGLB07AaUxpkXlGcuU6FteMlUUcO91CyyYw+5lcX0lPB8eB25WmQuSWr/0FvOTWQUC4xWiNScjU4rQBfb3OpATiVx+PD0Q6zZ5LY1EbGuiNFJTjl04/gYHbw9nW1S48625eyzim+w/3JqDXoRLkiA5c8VxFERgb5dyBlu/ZPEZIdH6O+pyyfjM8+WpPAXyhrW4cJe90zBP3QonF7BMPBDMHDHBt63RIyulaB15IIyJ7QVrg/ATvrJJPRPb+SG2uf/zjsYnxZJ6QB3bTEkK5wjnmExVpSLZ3L7Rs9FmKI4MdHSDPv220zRxbG+uNH2bn6HdiTIeXtD4P1Dzab/iRqD9d7NlX091p4ipZ+mxAKAXf1luRsyjai5s85JI5clYkEf7U3vGmPz8deFuLaW8vq7+Ng0qKaWB6qUy4ybW1W23y75XOKUl1yAjM3rqgJBH86oymz+J5aJTdg/IU0KarrF4PrujxVboQH+3IVtOLxmzPr1etA6jdEYAVkVkcjENO6VMgYVBLc580U87nAqyCAZxC71bJZ4b4aQiFlZsNw+YFZdv/XlznWWJT3pcKlb0Y76xT8g/P5T+37Za/7yzO+YncK0DUbveAuEjeXWqhON/I9ZTCO/EoQxQfHCz8rKckzPsZKJZh960ePLVKy5FfoT5GKaSRCbqJxjY7+3pnecHFsvQwHpMUSi4rycz/rBNa0pqSZ+3GogB2Uqi4sZFdKcvia3O4f8Qjl9aWS
 b44W3rcn
 Dsu6TjG+oCwt0z+UAsW2RjhuPRvDIEj6Zkm1MSgkFrrMYixq3AMqjU2juk2u2gRhpZV0/gEKkHQdfamsg3fU/0yUxQIt/NcnJWw3al6nheBFAZ8fjoPFQDv/ZTAfhdD3bUFYSf3RD7zF6FprNf8CW78tMBN3ak5lOigHcDbZ5vnly6Oklk/Fd/ACr+DrKlJLLDalMgnN8vPKid9eHeL2ZmIWKXpaV1KUrkmLGfWS29tpRND/ZnkoqSI1Ugr+/r697tup5xnRSmEURCSn3mvIAXYGyMZTHmqiF8fEtEP1RZ6ZPDz2VBj3EjAinTWOiaZWAHkNU6YFs8r0RHf5ZbaSarN0t4/1RUAxvA/28YmNKEHVnkEmYzg0FGZeXk2yisrMuiebzSkSFJhfF0709HMXuFbOBaLihsPY/wG6BrBA2d5AXS1ZdqAssiyONPi2vhA7sgpQnuZA2oJJhrAiNWw1zFfGPSuolfkB9hkgqkBAtZR/UYHBTD2X1LITdmUchS0dgk5cCSAUFZ3GG3BDmyUCV+GKyzlEzm61Ftu0nstDauxS2VgjcYOZfFjG/LFfoD9nFVSgqp1CBemSCIEjvmZxsP/bAZy/CVcK+6MuVVRY6oYoRE0S1oPJgPpOgZ2P377EorjXHJ0m2Xudk7SeqoOF4JjXFUahjT7erE7r3BALAi2h7QgdSc2L6tVuI/bxiA5MsGHKmkcq7kZFWGxEazgaF21iMVI3baPKWah95
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
 arch/arm64/mm/fault.c             |  2 +-
 4 files changed, 67 insertions(+), 8 deletions(-)

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


