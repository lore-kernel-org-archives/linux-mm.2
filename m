Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83771606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q0Xkhg1T
Received: by kanga.kvack.org (Postfix)
	id 659EA6B05FF; Thu, 26 Nov 2026 06:20:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631A46B0600; Thu, 26 Nov 2026 06:20:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520806B0601; Thu, 26 Nov 2026 06:20:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8186B05FF
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:20:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B99D0120CEA
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:20:47 +0000 (UTC)
X-FDA: 85477027734.19.0D129BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 17AE520002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:20:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q0Xkhg1T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692046;
	b=t76K6ycphADNOg9dFA/FNs4UA2o0Ot5WrwkOy9tzE7mdTtjgOIHdP+xdBIIW0gcNKYEfy/
	hfq1a4EP3wYJ24/O1HxLni1leIlzFswyqODargNl4jVCAuYDQm8ZbfCgw0VI0SpPOmmbw8
	3fydkkmH67+Z4gg4uN8zuCMSx0BT3GQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2eqedx79FOGytQwfFsw3rLLlGoNSMXbaKddEvY8fQE0=;
	b=KztpmGYbnPo19icD2mdIYDWBRgKssp8O6T6EgNf9iXB9raCCGrcBo3Ei9uapFcXSDPtTYl
	j/zMrZ8W5uredljqF03w/Ho5teyxopY6xT9moy2SbHR+lBwvfYKlquZDBS+/5zkry8dYbA
	090YxUMzgNbhqW/8dCDNU5hzP8veAIM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q0Xkhg1T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9957663364;
	Thu, 26 Nov 2026 11:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FC21F01562;
	Thu, 26 Nov 2026 11:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692045;
	bh=2eqedx79FOGytQwfFsw3rLLlGoNSMXbaKddEvY8fQE0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Q0Xkhg1TUF8rTMMI4BbrKu/g9CRAgi+on2guJ3KisSOOEAiojVW0mcSOnNl5BB8SQ
	 JVJNq/pCFyCujNJgHRK2pMnqLOc/lz1KCam2t+yw1HZ2pFhF9LAitckRcDQR8yh5UX
	 c+hdX/CidQJPUepbr2BONoM03B5FXPMydL0gdU4Y9e9aq5jHa/08DntWjDfKG1pMiZ
	 YGTNiNG+/lWMq/ut9hRrfKKLkQYbq6JqVG8BWKQWS8hdwzG/79G9KDWRtKYYZDlAol
	 mBBpDcrNQMQXJFefCr3YUfJY0XRu5+oViv1/0wGsLdbmH3GCrKqjwyb1DZqrfY5uQx
	 a0BT0tND+Wlgg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:52 +0200
Subject: [PATCH RFC v2 39/54] powerpc: use the generic CPA core
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-39-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 17AE520002
X-Stat-Signature: ag9pqt59n8n1gcj73ica6bptnxdo8rx6
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795692045-656049
X-HE-Meta: U2FsdGVkX19ye6PQC0Ws/nBhjnbHunqg74/uXWMaT7VRbpqXdv0be+xlAIH1OKyP4a5ZVDZzQ0yRHz9YJlWh2cv4etdHb9O4mViNrAq3ltXL4Csyj5q6mxqug5DooVAswRsCFZb2vt11NoMAbzzOixtq4qrd512vUWgQ5M47cN6NedQNqos90DQa1SkS1+90YZf/Fb4Pf00+YDtsA8f5gqNxSqgYOP5+12wC5NFc0kvhEwTReOtJqS/TQfDZ7saNuLpsAh3PoOMY658InOlLKyhH16npP9fYb79IkxDkjfgBNghBk3DZcxW1TT25GkT5s4w3h3f4SRMlaMOFn7mXHD5g5sxkk/wlnqJoyJrGRuMupFOmUa8v4OYFAnA0N33ilbQktQjjO9LheQEXgVmlou5HlXuW7WrF5whUFz7LXBM8sWy1Q5ZXT1GjksOlcfy3u7CMsI3fxCaPgq/Wa6zpPXZwBfTprP3QYzmallS1xIotO3A1y/usjqpNhK2xJ2BlBMsTHqGYpqosWzOyLJn5aFanC14X2dRM2Gb96vgyGq3FGf592pUfYRx4GWD66XEexzSnLZZRgehi2voQPBYBE6+DlFpcQznAAYZpcAaXug1S0OQxZd/8P7WdXPU8iwVICGzv6a+6iYlBzqf2wlNcEvNBAbVqT2/WHIcSlEb3X2jMNWslZRbMPzUHOnb783sk8satE8FK4l+01s/YUgpmieFNgdnrfdhqZaL2Y04GO2R0Fd7reJT7k48pyPduvIB2nmHSLhBBw8fBBEXWxV4X6boiAc9hlRoTnZ7T+6arQ+7oc+0HaQiqzksSJfVBTj1jd0w/u6D2c25XkaRWtsfQjo1JXmZS/qFlalelaj5xDf3ktl9rHh47DUPt7h7Q9WAmce4pMrBDtDkB8/pkuk4Wge4l072Va07F8kraG3Bhm8QK41ezAZhPcR2kXFb3Oc/T6uM0mEoqwsLBH2XSPXH
 hAwpX74W
 DRHdBxY/D++fuR8/6paZ8Z009hmE3ye+GvksmN3VGJ+bHeQE5iOrBajvllz3AMVQN/55UeXL2aKymYFPXdk2hyaTG6MiFd3bUq2ZPoiofScbGZoqHDHtsO74bj+ztVD3BXvtSIkJBXdY7jQED2+ehDnA0ir3ps1lyr8gT720yG9V+MwvxjZ7hs6f7D4wNB3dXS+OpdcUPjBA8hom2E0y4riLMuBXUWlvD7TM3lEYSaGGzPcSoLnYEbMOk88WhXfYFBv3hIf9EBt5Ul7hm3mirHUuBMJ+1Neq3XCH1r3zWFe6risA+GYUpqiF3UcyQao3U9jZBpb4dQPmmZS1x3fHmHqj8dkV1mutl/0B35ECXd/IoYPHYO1aD8uA6yA/jLga8a4K3SBatO6mvs1yDF7GokHTf+sAuTMwcHBbbGFcfMXgR9+hA/Y9BwZsZPjUe2O21Ex41H4w/1OoOkTIF/BdLMzhTFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

powerpc changes kernel page protections with apply_to_existing_page_range()
and a callback that updates one PTE and flushes it.

A request flushes the TLB once for every page, and large mappings cannot be
changed at all, so huge vmalloc ranges are refused up front.

On hash, only the start of a request is checked to be in the vmalloc or the
I/O region.

The availability of the generic CPA core makes powerpc's implementation of
set_memory_*() APIs unnecessary and it can be replaced with several hooks
required by the CPA core.

This way the core can manage the policy decisions and the architecture only
has to take care of the page table manipulation.

Switch to the generic CPA core and its set_memory() entry points.
For powerpc this means that:

* the TLB is flushed once per request, after a ptesync on radix
* a large mapping is changed in place when a request covers it entirely; a
  request for a part of it fails with a warning and -EINVAL, because
  powerpc cannot split
* huge vmalloc ranges are no longer refused up front; on 8xx a 16K, 512K or
  8M page changes as one
* on hash, the whole request has to be in the vmalloc or the I/O region
* an empty PTE in a vmalloc range is reported with a warning and -EFAULT
  where the old walk skipped it
* requests are serialized by the core; the old walk ran without a lock
* lazily unmapped vmap areas and unused kmaps are purged before a request,
  so that they do not keep stale mappings or TLB entries with the old
  protection; set_memory_*() may now sleep there

The hooks decode an entry with pte_pfn() and pte_pgprot(), which work for
the leaves of every level on book3s64, and write it with pte_update(),
which keeps the bits the hardware updates and removes the hash page table
entry where there is one.

On 8xx the decode hook extends a leaf to its block with __pte_leaf_size(),
and pte_update() writes the whole block. An 8M page spans two page tables,
and pte_update() takes it by its first PMD entry.

__kernel_map_pages() runs in the page allocator with interrupts disabled.
It keeps changing the PTEs with apply_to_existing_page_range(), now with
one flush per call. It was the only user of set_memory_np() and
set_memory_p(), so they are removed.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/powerpc/Kconfig                  |   1 +
 arch/powerpc/include/asm/set_memory.h |  46 +---------
 arch/powerpc/mm/pageattr.c            | 160 +++++++++++++++++++---------------
 3 files changed, 94 insertions(+), 113 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index c3b6cd655606..fbe3a3abeea8 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -211,6 +211,7 @@ config PPC
 	select GENERIC_IOREMAP
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
+	select GENERIC_PAGEATTR
 	select GENERIC_PCI_IOMAP		if PCI
 	select GENERIC_SMP_IDLE_THREAD
 	select HAS_IOPORT			if PCI
diff --git a/arch/powerpc/include/asm/set_memory.h b/arch/powerpc/include/asm/set_memory.h
index 9c8d5747755d..d049d48157a0 100644
--- a/arch/powerpc/include/asm/set_memory.h
+++ b/arch/powerpc/include/asm/set_memory.h
@@ -2,50 +2,6 @@
 #ifndef _ASM_POWERPC_SET_MEMORY_H
 #define _ASM_POWERPC_SET_MEMORY_H
 
-#define SET_MEMORY_RO	0
-#define SET_MEMORY_RW	1
-#define SET_MEMORY_NX	2
-#define SET_MEMORY_X	3
-#define SET_MEMORY_NP	4	/* Set memory non present */
-#define SET_MEMORY_P	5	/* Set memory present */
-#define SET_MEMORY_ROX	6
-
-int change_memory_attr(unsigned long addr, int numpages, long action);
-
-static inline int __must_check set_memory_ro(unsigned long addr, int numpages)
-{
-	return change_memory_attr(addr, numpages, SET_MEMORY_RO);
-}
-
-static inline int __must_check set_memory_rw(unsigned long addr, int numpages)
-{
-	return change_memory_attr(addr, numpages, SET_MEMORY_RW);
-}
-
-static inline int __must_check set_memory_nx(unsigned long addr, int numpages)
-{
-	return change_memory_attr(addr, numpages, SET_MEMORY_NX);
-}
-
-static inline int __must_check set_memory_x(unsigned long addr, int numpages)
-{
-	return change_memory_attr(addr, numpages, SET_MEMORY_X);
-}
-
-static inline int __must_check set_memory_np(unsigned long addr, int numpages)
-{
-	return change_memory_attr(addr, numpages, SET_MEMORY_NP);
-}
-
-static inline int __must_check set_memory_p(unsigned long addr, int numpages)
-{
-	return change_memory_attr(addr, numpages, SET_MEMORY_P);
-}
-
-static inline int __must_check set_memory_rox(unsigned long addr, int numpages)
-{
-	return change_memory_attr(addr, numpages, SET_MEMORY_ROX);
-}
-#define set_memory_rox set_memory_rox
+#include <asm-generic/set_memory.h>
 
 #endif
diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
index ac22bf28086f..a2da183aa575 100644
--- a/arch/powerpc/mm/pageattr.c
+++ b/arch/powerpc/mm/pageattr.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/mm.h>
+#include <linux/pageattr.h>
 #include <linux/vmalloc.h>
 #include <linux/set_memory.h>
 
@@ -16,109 +17,132 @@
 
 #include <mm/mmu_decl.h>
 
-static pte_basic_t pte_update_delta(pte_t *ptep, unsigned long addr,
-				    unsigned long old, unsigned long new)
+void arch_cpa_decode_leaf(struct cpa_leaf *leaf)
 {
-	return pte_update(&init_mm, addr, ptep, old & ~new, new & ~old, 0);
+	pte_t pte = ptep_get(leaf->kpte);
+	unsigned long size, nr;
+	pmd_t *pmdp;
+
+	/*
+	 * A 16K or 512K page of 8xx is a contiguous block of entries in one
+	 * page table, each mapping its part of the page. An 8M page spans two
+	 * tables, and pte_update() takes it by its first PMD entry.
+	 */
+	if (IS_ENABLED(CONFIG_PPC_8xx) && leaf->level == PGTABLE_LEVEL_PTE) {
+		size = __pte_leaf_size(pmdp_get(pmd_off_k(leaf->addr)), pte);
+		if (size > PAGE_SIZE && size < PMD_SIZE) {
+			nr = size / PAGE_SIZE;
+			leaf->kpte = PTR_ALIGN_DOWN(leaf->kpte,
+						    nr * sizeof(pte_t));
+			leaf->size = size;
+			leaf->addr &= ~(size - 1);
+			pte = ptep_get(leaf->kpte);
+		} else if (size > PMD_SIZE) {
+			leaf->size = size;
+			leaf->addr &= ~(size - 1);
+			pmdp = pmd_off_k(leaf->addr);
+			pte = ptep_get(pte_offset_kernel(pmdp, leaf->addr));
+			leaf->kpte = (pte_t *)pmdp;
+		}
+	}
+
+	leaf->pfn = pte_pfn(pte);
+	leaf->prot = pte_pgprot(pte);
 }
 
-/*
- * Updates the attributes of a page atomically.
- *
- * This sequence is safe against concurrent updates, and also allows updating the
- * attributes of a page currently being executed or accessed.
- */
-static int change_page_attr(pte_t *ptep, unsigned long addr, void *data)
+void arch_cpa_modify_leaf(struct cpa_leaf *leaf, pgprot_t prot)
 {
-	long action = (long)data;
-
-	addr &= PAGE_MASK;
-	/* modify the PTE bits as desired */
-	switch (action) {
-	case SET_MEMORY_RO:
-		/* Don't clear DIRTY bit */
-		pte_update_delta(ptep, addr, _PAGE_KERNEL_RW & ~_PAGE_DIRTY, _PAGE_KERNEL_RO);
-		break;
-	case SET_MEMORY_ROX:
-		/* Don't clear DIRTY bit */
-		pte_update_delta(ptep, addr, _PAGE_KERNEL_RW & ~_PAGE_DIRTY, _PAGE_KERNEL_ROX);
-		break;
-	case SET_MEMORY_RW:
-		pte_update_delta(ptep, addr, _PAGE_KERNEL_RO, _PAGE_KERNEL_RW);
-		break;
-	case SET_MEMORY_NX:
-		pte_update_delta(ptep, addr, _PAGE_KERNEL_ROX, _PAGE_KERNEL_RO);
-		break;
-	case SET_MEMORY_X:
-		pte_update_delta(ptep, addr, _PAGE_KERNEL_RO, _PAGE_KERNEL_ROX);
-		break;
-	case SET_MEMORY_NP:
-		pte_update(&init_mm, addr, ptep, _PAGE_PRESENT, 0, 0);
-		break;
-	case SET_MEMORY_P:
-		pte_update(&init_mm, addr, ptep, 0, _PAGE_PRESENT, 0);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
+	unsigned long old = pgprot_val(leaf->prot), new = pgprot_val(prot);
 
+	pte_update(&init_mm, leaf->addr, leaf->kpte, old & ~new, new & ~old,
+		   leaf->size > PAGE_SIZE);
+}
+
+void arch_cpa_flush(struct cpa_data *cpa)
+{
 	/* See ptesync comment in radix__set_pte_at() */
 	if (radix_enabled())
 		asm volatile("ptesync": : :"memory");
 
-	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
-
-	return 0;
+	cpa_flush_tlb_kernel_range(cpa);
 }
 
-int change_memory_attr(unsigned long addr, int numpages, long action)
+#define CPA_OP_TRANS(old, new)	{ .set = __pgprot((new) & ~(old)),	\
+				  .clr = __pgprot((old) & ~(new)) }
+
+static const struct cpa_op_prot cpa_ops[CPA_OP_NR] = {
+	/* Don't clear DIRTY bit */
+	[CPA_OP_RO]	= CPA_OP_TRANS(_PAGE_KERNEL_RW & ~_PAGE_DIRTY,
+				       _PAGE_KERNEL_RO),
+	[CPA_OP_RW]	= CPA_OP_TRANS(_PAGE_KERNEL_RO, _PAGE_KERNEL_RW),
+	[CPA_OP_X]	= CPA_OP_TRANS(_PAGE_KERNEL_RO, _PAGE_KERNEL_ROX),
+	[CPA_OP_NX]	= CPA_OP_TRANS(_PAGE_KERNEL_ROX, _PAGE_KERNEL_RO),
+	/* Don't clear DIRTY bit */
+	[CPA_OP_ROX]	= CPA_OP_TRANS(_PAGE_KERNEL_RW & ~_PAGE_DIRTY,
+				       _PAGE_KERNEL_ROX),
+};
+
+int arch_cpa_prepare(struct cpa_data *cpa, enum cpa_op op)
 {
-	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
-	unsigned long size = numpages * PAGE_SIZE;
-
-	if (!numpages)
-		return 0;
-
-	if (WARN_ON_ONCE(is_vmalloc_or_module_addr((void *)addr) &&
-			 is_vm_area_hugepages((void *)addr)))
-		return -EINVAL;
-
 #ifdef CONFIG_PPC_BOOK3S_64
+	unsigned long end = cpa->addr + cpa->numpages * PAGE_SIZE;
+
 	/*
 	 * On hash, the linear mapping is not in the Linux page table so
-	 * apply_to_existing_page_range() will have no effect. If in the future
-	 * the set_memory_* functions are used on the linear map this will need
+	 * changing its protections has no effect. If in the future the
+	 * set_memory_* functions are used on the linear map this will need
 	 * to be updated.
 	 */
-	if (!radix_enabled()) {
-		int region = get_region_id(addr);
+	if (!radix_enabled() && cpa->numpages) {
+		int region = get_region_id(cpa->addr);
+		int end_region = get_region_id(end - 1);
 
-		if (WARN_ON_ONCE(region != VMALLOC_REGION_ID && region != IO_REGION_ID))
+		if (WARN_ON_ONCE((region != VMALLOC_REGION_ID &&
+				  region != IO_REGION_ID) ||
+				 end_region != region))
 			return -EINVAL;
 	}
 #endif
 
-	return apply_to_existing_page_range(&init_mm, start, size,
-					    change_page_attr, (void *)action);
+	cpa_init_op(cpa, &cpa_ops[op]);
+
+	return 0;
 }
 
 #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KFENCE)
 #ifdef CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC
+static int change_present(pte_t *ptep, unsigned long addr, void *data)
+{
+	if (data)
+		pte_update(&init_mm, addr, ptep, 0, _PAGE_PRESENT, 0);
+	else
+		pte_update(&init_mm, addr, ptep, _PAGE_PRESENT, 0, 0);
+
+	return 0;
+}
+
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	int err;
 	unsigned long addr = (unsigned long)page_address(page);
+	unsigned long size = numpages * PAGE_SIZE;
 
 	if (PageHighMem(page))
 		return;
 
-	if (IS_ENABLED(CONFIG_PPC_BOOK3S_64) && !radix_enabled())
+	if (IS_ENABLED(CONFIG_PPC_BOOK3S_64) && !radix_enabled()) {
 		err = hash__kernel_map_pages(page, numpages, enable);
-	else if (enable)
-		err = set_memory_p(addr, numpages);
-	else
-		err = set_memory_np(addr, numpages);
+	} else {
+		err = apply_to_existing_page_range(&init_mm, addr, size,
+						   change_present,
+						   (void *)(long)enable);
+
+		/* See ptesync comment in radix__set_pte_at() */
+		if (radix_enabled())
+			asm volatile("ptesync": : :"memory");
+
+		flush_tlb_kernel_range(addr, addr + size);
+	}
 
 	if (err)
 		panic("%s: changing memory protections failed\n", __func__);

-- 
2.53.0


