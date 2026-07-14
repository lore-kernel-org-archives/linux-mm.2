Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2141C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E1E16B00C1; Tue, 14 Jul 2026 10:06:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B9256B00C3; Tue, 14 Jul 2026 10:06:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A7E96B00C4; Tue, 14 Jul 2026 10:06:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E81C6B00C1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:06:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E73EA1A03FE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:06:29 +0000 (UTC)
X-FDA: 84987557298.04.9627F8B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 27A281C000F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:06:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Vw/Dcaip";
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W11OhnWcGHVOZmGTaRtReQ7d9g+T7FOsV0FghI7A38A=;
	b=xZ3tf7FDHoZ/toXt6eAQq9FL3klbPEiqgcLn4kOVQcfrvNlE3MeHg9VFD0WwVph+SIV7Bl
	MMFNj1DnvmpCCkO2YOSOihKWgLnuXkbiYArk6qn//n/YW5zzgdAxy1jwpxKQLzmSvdw4Rq
	xRA58DKMEcBGw3XkD6o6Z7Njdf+pws0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037988;
	b=vt1rK7EoTE0n3zwI43kyY5A8zMg6MxIGeexQSeiqjsLd2iMvLxf62o2CyRnS5tF9nSxWbv
	QNRp/SrcHdqdCoJX0Gy215sB3H9gJXQ9lwx/DfSX4Vh0ZuZ2Xr9osqRB0dHj7DMGD32rnf
	l4WogkCXcs30CNnMgrtWS+s8ulM1ZVs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Vw/Dcaip";
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 357EF1BCA;
	Tue, 14 Jul 2026 07:06:23 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D7CA3F7B4;
	Tue, 14 Jul 2026 07:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037987; bh=0Ls2F5YWtI+Ww29NmMlh3ILvDXBv7NqjYutzPTWlWAY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Vw/DcaipPFO7n11+mYGQ7sNvjiW4bDFKvxM87pb4Zb7kuc57MeI8Zk26C7/35oDk9
	 zqUNmHcLyquGe9NI65E4Her4eCylK5913yMxY4xf0bE1WBcJGqN4rBz8A8PaHgPJxY
	 8H47S03cWv8hSaCgq8C8KHighveKeuoCTTOKDHQY=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:59 +0100
Subject: [PATCH 10/22] sparc: mm: use mm_is_kernel() for kernel mm checks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-10-44be8a7685d7@arm.com>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
To: linux-mm@kvack.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, 
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, 
 x86@kernel.org, tboot-devel@lists.sourceforge.net, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=3538;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=0Ls2F5YWtI+Ww29NmMlh3ILvDXBv7NqjYutzPTWlWAY=;
 b=VJPLQX/cB8CHz8XN2ewL2VVdeyfHItZBmFDR5s9RbTft/6Q4d42mZh1rja83yviws3jmyIGiU
 WKKijSfDJjoB4fJ0orVPQbnc54Akn8lFl91qUqv6PDas/mRRckHwzdj
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27A281C000F
X-Stat-Signature: j3fy9jft7epin9xoobqetxtkuixuamq5
X-HE-Tag: 1784037988-761825
X-HE-Meta: U2FsdGVkX1/8zseV9KV37wY+jHFJwBaT7H5IF5I8mH5tQ8Etbg2TXLN9/XL6QmmD8HJ4PYWIl9d5oVjdViGWQozqo/8GChMwOWReZbx6gbTCSFgvfI5hzXbXIs+P9oekhgE1Mazq3/sWNNxDM71z2eDy//4iUHDDBTA5yINhcuqVo+OhV1aNsyHtEh5RncMhmjWMCtxoq4XLD7eYOh4SzyJNiQSGpEcjmJdsz85dOIqFPBY9y5u18dm0hh1nwvfU1vWbHAsDton19BEZWSkUQ/+aZKAtdQeyHOSJROo+26A2POUc62RL8yXjCEbtkg4UxWTIwYstIdoh5dz3+PZFu67za5wf1qMU8uzbY7/9dWB8s9jXRxkRkktck/YrWJud+639f7zSGK3UGPFImea2U9xir43ITEGy4eY0rwDhN4tlB1c4d/x1CBhKiT/ET7b3tmFLiCiuZ6xXdB4LtS52jU4bwJOMZv28ZoMAgD8sDk1/yOTU2YGiywXIsA2lPLqD5CBrED/Zzr2NSauGm8DtODJhia2KWM03psx+haWQMOhv58BT7xo2QXNJGVGipMQ4RP0z62adPPCc3G6bZq/tJr5U3ZlMiD2/y8VR6WI6VDJUAXJHNbzN1dVm2quYnXFb5BfwQQeBHKrafNcq4wOA/wg7zYGHZDllnl23P+WVPyqabXYCyPb88ClQ43pancNbHIWTlztlOw1xmIbgc8Kt4AiN8XyZacCC+WBahLxgttFaJiqHlrgbYg5aDxh1PnQzs/GD8wYn9Frym9dg3Sdz9o59gr362R3uSfjXQxC+gC7eRMWJNAC8pTeO6+Yf0sQgWdO8FBpRMdDf6/u4iV2uJbYzNhbj9SPDSQu6NEazwfWI0A3ERtiw/NvUlSqbyGn9fJt4bhnGu8FKpDQomebUzo6NrCBTIS8hZvEUux68oB6BkdjPVgLN3wjUL3qM27i5yhjFs+BEsJvqHuwpr9J
 h/7LCTcK
 30Z+qd9stfwA7kRQqOe0YqzyRlueDIn9BOPNlnOstd581rWiHQbCZ3t7IFvAqadfb4eIERAbHlIIzhOYg7OVgALEp4BEA5eVjc2s9uHwLa8t8W5fhxtYqzeTpLYFRDSks9WO5k1nnDC5gaaLpaVzT0t3wLXkeuQZcxG2dFuU2l+IhfHEbC7E/aPLkdGlrPzkxKVnDn8CzPE+fc8oAdhWSTtNI1ihK1u47Uwp8h6hePHjck5IrOg1F+qKe2vJp9k5Amx+fGrteFaSVZOLxqlDGXOqiJEVhsAr70aOq5of6Z05U6U6iEYN3Nh0G7v10kl2Ifh0wXRLfKMkiKuBHLrrJK9zP2sJI0D36ub5SLLIpx1LIgiiGKjl+kmoCdJqsJpFeh3mr++OUx2Vs1DDr/q7RROU7DHUAG+rre8UF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new MMF_KERNEL flag identifies kernel-owned mm's. Checking the
flag with mm_is_kernel() is preferred over comparing directly
against &init_mm.

No functional change, as only init_mm has MMF_KERNEL set for now.

pgtable_64.h previously forward-declared init_mm to avoid pulling
in mm_types.h. It seems that including mm_types.h is not causing
troubles any more, so we can also use mm_is_kernel() there and drop
the forward declaration.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/sparc/include/asm/mmu_context_64.h | 2 +-
 arch/sparc/include/asm/pgtable_64.h     | 6 ++----
 arch/sparc/mm/init_64.c                 | 2 +-
 arch/sparc/mm/tlb.c                     | 2 +-
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/sparc/include/asm/mmu_context_64.h b/arch/sparc/include/asm/mmu_context_64.h
index 78bbacc14d2d..e88bc61aeb04 100644
--- a/arch/sparc/include/asm/mmu_context_64.h
+++ b/arch/sparc/include/asm/mmu_context_64.h
@@ -83,7 +83,7 @@ static inline void switch_mm(struct mm_struct *old_mm, struct mm_struct *mm, str
 	int cpu = smp_processor_id();
 
 	per_cpu(per_cpu_secondary_mm, cpu) = mm;
-	if (unlikely(mm == &init_mm))
+	if (unlikely(mm_is_kernel(mm)))
 		return;
 
 	spin_lock_irqsave(&mm->context.lock, flags);
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 0837ebbc5dce..960f8bf1ec5a 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -86,6 +86,7 @@ extern unsigned long VMALLOC_END;
 #define vmemmap			((struct page *)VMEMMAP_BASE)
 
 #include <linux/sched.h>
+#include <linux/mm_types.h>
 #include <asm/tlbflush.h>
 
 bool kern_addr_valid(unsigned long addr);
@@ -885,9 +886,6 @@ static inline unsigned long pud_pfn(pud_t pud)
 #define p4d_set(p4dp, pudp)	\
 	(p4d_val(*(p4dp)) = (__pa((unsigned long) (pudp))))
 
-/* We cannot include <linux/mm_types.h> at this point yet: */
-extern struct mm_struct init_mm;
-
 /* Actual page table PTE updates.  */
 void tlb_batch_add(struct mm_struct *mm, unsigned long vaddr,
 		   pte_t *ptep, pte_t orig, int fullmm,
@@ -903,7 +901,7 @@ static void maybe_tlb_batch_add(struct mm_struct *mm, unsigned long vaddr,
 	 * SUN4V NOTE: _PAGE_VALID is the same value in both the SUN4U
 	 *             and SUN4V pte layout, so this inline test is fine.
 	 */
-	if (likely(mm != &init_mm) && pte_accessible(mm, orig))
+	if (likely(!mm_is_kernel(mm)) && pte_accessible(mm, orig))
 		tlb_batch_add(mm, vaddr, ptep, orig, fullmm, hugepage_shift);
 }
 
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 103db4683b16..e0b678349e3a 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -788,7 +788,7 @@ static void mmu_context_wrap(void)
 		 */
 		mm = per_cpu(per_cpu_secondary_mm, cpu);
 
-		if (unlikely(!mm || mm == &init_mm))
+		if (unlikely(!mm || mm_is_kernel(mm)))
 			continue;
 
 		old_ctx = mm->context.sparc64_ctx_val;
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index 6d9dd5eb1328..47083c287a94 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -179,7 +179,7 @@ static void tlb_batch_pmd_scan(struct mm_struct *mm, unsigned long vaddr,
 static void __set_pmd_acct(struct mm_struct *mm, unsigned long addr,
 			   pmd_t orig, pmd_t pmd)
 {
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		return;
 
 	if ((pmd_val(pmd) ^ pmd_val(orig)) & _PAGE_PMD_HUGE) {

-- 
2.51.2


