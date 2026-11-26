Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0759D606A685
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XzEl8tFs
Received: by kanga.kvack.org (Postfix)
	id 28D726B0613; Thu, 26 Nov 2026 06:22:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2653B6B0614; Thu, 26 Nov 2026 06:22:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B906B0615; Thu, 26 Nov 2026 06:22:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E26D56B0613
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:22:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B08D40D5A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:22:32 +0000 (UTC)
X-FDA: 85477032144.25.0E05F14
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id AB9DC40004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:22:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XzEl8tFs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692150;
	b=CUPogoNJp4sDJ/NZcNDvctUHYRNODTI0qDpl2GI63TDELJHk7h5eN1ABnSgbygVbaRuthv
	eNrKq5AIieQ53fdhoMU8bTFQ3R4nQiyeQ/mfwFEXehbjEnVFsQHss2aDnGbuRj+h40nd3f
	aBLtLZ68se1kOMbhLqeMRc5RKfkJa28=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vTUzC6jse1/uWBZS2E4r76zLClqKhduPa+hgi40lrUo=;
	b=5ywK4KL74Zb8CwOj+Mgq3FKO7+Hwtk3hBe9Nau5jkkQ9kpJOmbyxf7Soyu6X76UV54GDp7
	e4OeYf/PXTiKc+VhOa1Ov7b3MRWonm8vYgQkiEP+OltCXCinVFHt74XIxMqfbkAw22WABk
	6gR8uAPkeELarb2wJ2spFpJ9qa5Ob8k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XzEl8tFs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3ED2B61DA3;
	Thu, 26 Nov 2026 11:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D262B1F0093E;
	Thu, 26 Nov 2026 11:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692149;
	bh=vTUzC6jse1/uWBZS2E4r76zLClqKhduPa+hgi40lrUo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XzEl8tFsXVj9BAAaIUtUGRinOitdJkT0iWw23K1beI9eLYMWSr5Ym3ud2iOjYrznO
	 aLhLxjvRPw3yiT6bbIslM+V6XpUHc+RqVkx5Cb/ipMIL9dFeLMTRot29bRlxe687Pq
	 E9TVxowbXa6Yf1UZn4VTf+dFXfJzV9TqlAnUiouHRmSeOFmgsOj3GJYF3p5/MA0TP1
	 AiOiruVIht3ba+gCJKbn3bPelvZZFU3VjdvIQBZi8hhh9caJRyIRtAR+KgLFgtBUSx
	 fWWEefDszLbQ5S4h6JmVi1EUHxSe+9zWJrd8gDyuj83zYka5hcI0Aq2zcbJjASfmK1
	 sGbbZv0lKcSSQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:15:03 +0200
Subject: [PATCH RFC v2 50/54] arm64: use the generic CPA core
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-50-723f1e33c3d8@kernel.org>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB9DC40004
X-Rspam-User:
X-Stat-Signature: 8q1a7oxeecpyypi6q3aec37atx6jchw4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795692150-527175
X-HE-Meta: U2FsdGVkX18BBwW913EaO2NIAPqp5LP/y2uOcyl0vY+l11VzstcCJ1ZqEs8/sua/98JEEjxzbbbcZ+zHS0C/LOFKEIP+H1UwegeonoJ9rhxzKzcoZ3lS26Kev1gSyNRfG6AQy6GqDKN8QC4cvbAQy+3KGsHk8ixkiQNWuksrtwNZSPNnxDNMb8E2fUecJvP7KrifcXhMw+n0gB9ONEm4bNOGaCsHPVld5v+2ckMWI+ankuP/zKDmSyuhgR70+U53GjhE+jNURDQ5ojQvxHAL554U9MPk0sKZqZPFudsBIm0/RyJaMpb5raXdmfNqqWvXbd7epPEE0VzTtJxepC0h2WrQuwUb+wd46ZYQJBzsJIKHsw+qAG7SSihpe6OP7KENN0aJfwazHq8S19uPrNybxGBoj0Wql2QcWUDx6iy869UI9UIuUsVJxWqQcwmLNBtWz2VUUFSKUVFK6c0/K7kqqgEE7kedQFsdC8P5L/YuS4ptGAIzp+McpQQPmQvbSLFaGbghke5fMITq0+wYPlhg41jzt8+YkJQvV2pJsqhlirMzE9+YHUwNe7bd1kek1cBHHccrtXPk7dL1BucAGV2cMvyXsAe+CwlePxzbGrTkNgIcH1790L6+M493f64wjiRwqUoA0vpBNKIxfXs69dokP2SnFpzwOY04Jkmv8oMiAuk0LHfWMwxXQJZph8V984NXF0ikmEEP/2fwdzsNNm5z5n+5pVCxPFT2jhqfIyGZXn65mBoeLlK14Ewv0m6UAA6s0rZfUlutbdXFjqCx2VRXsCyIgq4004ClIsK0BYXbWAfA+pgCYcE4kpIBlt8XRm1NnSMYBAGeiw1CPPfFntDCqNtD+E0dhZcMTquydfeN9zYeckc0Pud/kZrS3XgZDqK4stFrAsZHTY3KEuOjVJerRegdi5AImwB8TbEyp+M5nhbfsqMat9xKtdit7n6DkAZZ7HiRDN5I8FRDBmnqovz
 9dfmu15o
 VEJu2hLJC2nTzaS8MrHK5+YW4bMLt+vWN3vygWx/sw2QlUU/II1POJnlIk3Xrs0emJ0SEAlYo/pWe8h57kH7bQCcYjxRPG6DlvTpA1RyURY291ioNB5mmt2lZFrqv0GVFgJ5wpSpZaNiZ13oeywjuYxHVyQeEPKrrL6CtKX0mrCwKf16zFr1jhIhSuoHyy5WKXoEmHHeGspZZwE9Z9KSuE7gjGTmhGxnXOtuLFP51PVGPmsJ9i6/vYpWNuI1OUVFho/cOahbY5ls7wLoTFGBmRDw5kGhEMGKWCSNdiXExXrdDLAICiyh00uRkdkZBqNjfh0ePhvKksSkwNE4Rxoh2jhG8BU1n00B0AUuDVeOqwhvzW4NlRcJ2wqO5o3dwxJBMrtDex/9gax9xdaBKCUsDuPBBgbkkXzB/YoTGNsQVPjAY3HWwv3O8fuoXKui4gPVxK64nlQv6sE2P9bWK6VxKbGBM93TmB5cxTosF8qPG/ufA5FsXi0S244R6jzkKhb0wuZ3Xtt1vLm9N9LvE7E35qxzXsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

arm64 implementation of set_memory_*() APIs has a few shortcomings:

* the page table walk that changes kernel page protections is preceded by
  another walk that splits the mappings at both ends of a request down to
  base pages, whether the request needs that or not
* the linear alias of a vmalloc area is changed and flushed page by page
* set_memory_*() refuse anything but a single VM_ALLOC area, a check that
  dates from when a live mapping could not be split at all and makes arm64
  the odd one out among the architectures

The availability of the generic CPA core makes arm64's implementation of
set_memory_*() APIs unnecessary and it can be replaced with several hooks
required by CPA core.

This way the core can manage the policy decisions and the architecture only
has to take care of the page table manipulation.

Switch to the generic CPA core and its set_memory() entry points.
For arm64 this means that:

* set_memory_*() accept any kernel mapping; a request that needs a split
  arm64 cannot do fails with a warning and -EINVAL
* a contiguous block of entries is kept or changed like a large page; its
  entries are rewritten one by one, so the block has mixed permissions for
  a few stores, the same window every change has before its TLB flush
* the linear alias follows read-only and read-write changes when
  rodata_full is set, as before, for any mapping of RAM
* a request and its aliases run in one lazy MMU section
* requests are serialized by the core; the old walk ran without a lock
* KFENCE and debug_pagealloc change the linear map with interrupts disabled
  and keep a lockless set_memory_valid()
* the linear alias of data and bss, which may use block mappings, is mapped
  and unmapped for hibernation by a request of its own

The mappings at both ends of a request are still split to base pages before
the walk, so the core does not split yet.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm64/Kconfig                  |   1 +
 arch/arm64/include/asm/pageattr.h   |  18 ++
 arch/arm64/include/asm/set_memory.h |   2 -
 arch/arm64/mm/mmu.c                 |  21 +-
 arch/arm64/mm/pageattr.c            | 387 +++++++++++++++++++-----------------
 5 files changed, 246 insertions(+), 183 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9b08b2457a55..846fae788b3c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -138,6 +138,7 @@ config ARM64
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
 	select GENERIC_LIB_DEVMEM_IS_ALLOWED
+	select GENERIC_PAGEATTR
 	select GENERIC_PCI_IOMAP
 	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
diff --git a/arch/arm64/include/asm/pageattr.h b/arch/arm64/include/asm/pageattr.h
new file mode 100644
index 000000000000..9634cb523298
--- /dev/null
+++ b/arch/arm64/include/asm/pageattr.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_PAGEATTR_H
+#define __ASM_PAGEATTR_H
+
+#define cpa_is_direct_map(addr)	__is_lm_address(__tag_reset(addr))
+
+int arch_cpa_process_alias(struct cpa_data *cpa);
+#define arch_cpa_process_alias arch_cpa_process_alias
+
+void arch_cpa_enter(void);
+#define arch_cpa_enter arch_cpa_enter
+
+void arch_cpa_leave(void);
+#define arch_cpa_leave arch_cpa_leave
+
+int arm64_change_page_attr(struct cpa_data *cpa);
+
+#endif /* __ASM_PAGEATTR_H */
diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 0091ba12200e..4c4ca9cd50c8 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -11,8 +11,6 @@ bool can_set_direct_map(void);
 
 int set_memory_valid(unsigned long addr, int numpages, int enable);
 
-int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
-int set_direct_map_default_noflush(struct page *page, unsigned int numpages);
 bool kernel_page_present(struct page *page);
 
 int set_memory_encrypted(unsigned long addr, int numpages);
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 0f96efea9057..c8f3961b4555 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/kexec.h>
+#include <linux/pageattr.h>
 #include <linux/libfdt.h>
 #include <linux/mman.h>
 #include <linux/nodemask.h>
@@ -1078,9 +1079,23 @@ static void __init __map_memblock(phys_addr_t start, phys_addr_t end,
 
 static void mark_linear_data_alias_valid(bool valid)
 {
-	set_memory_valid((unsigned long)lm_alias(__init_end),
-			 (unsigned long)(__bss_stop - __init_end) / PAGE_SIZE,
-			 valid);
+	pgprot_t valid_prot = __pgprot(PTE_PRESENT_VALID_KERNEL);
+	pgprot_t invalid_prot = __pgprot(PTE_PRESENT_INVALID);
+	struct cpa_data cpa = {
+		.addr = (unsigned long)lm_alias(__init_end),
+		.numpages = (__bss_stop - __init_end) / PAGE_SIZE,
+		.mask_set = valid ? valid_prot : invalid_prot,
+		.mask_clr = valid ? invalid_prot : valid_prot,
+		.flags = CPA_REQ_NO_CHECK_ALIAS,
+	};
+	int ret;
+
+	ret = split_kernel_leaf_mapping(cpa.addr,
+					cpa.addr + cpa.numpages * PAGE_SIZE);
+	if (WARN_ON_ONCE(ret))
+		return;
+
+	arm64_change_page_attr(&cpa);
 }
 
 static int arm64_hibernate_pm_notify(struct notifier_block *nb,
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index de7bf95003ea..14a791b8e645 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -8,7 +8,7 @@
 #include <linux/mem_encrypt.h>
 #include <linux/sched.h>
 #include <linux/vmalloc.h>
-#include <linux/pagewalk.h>
+#include <linux/pageattr.h>
 
 #include <asm/cacheflush.h>
 #include <asm/pgtable-prot.h>
@@ -16,75 +16,94 @@
 #include <asm/tlbflush.h>
 #include <asm/kfence.h>
 
-struct page_change_data {
-	pgprot_t set_mask;
-	pgprot_t clear_mask;
-};
-
-static ptval_t set_pageattr_masks(ptval_t val, struct mm_walk *walk)
+void arch_cpa_decode_leaf(struct cpa_leaf *leaf)
 {
-	struct page_change_data *masks = walk->private;
+	enum pgtable_level level = leaf->level;
+	pte_t pte = __ptep_get(leaf->kpte);
+	pteval_t prot, ns_shared;
+	unsigned int nr;
+
+	if (pte_cont(pte)) {
+		nr = level == PGTABLE_LEVEL_PTE ? CONT_PTES : CONT_PMDS;
+		leaf->kpte = PTR_ALIGN_DOWN(leaf->kpte, nr * sizeof(pte_t));
+		leaf->size *= nr;
+		leaf->addr &= ~(leaf->size - 1);
+		pte = __ptep_get(leaf->kpte);
+	}
 
 	/*
-	 * Some users clear and set bits which alias each other (e.g. PTE_NG and
-	 * PTE_PRESENT_INVALID). It is therefore important that we always clear
-	 * first then set.
+	 * The NS shared bit of a Realm is an address bit that selects the
+	 * unprotected alias of the same memory.
 	 */
-	val &= ~(pgprot_val(masks->clear_mask));
-	val |= (pgprot_val(masks->set_mask));
+	ns_shared = pte_val(pte) & PROT_NS_SHARED;
+	pte = __pte(pte_val(pte) & ~ns_shared);
+
+	switch (level) {
+	case PGTABLE_LEVEL_PTE:
+		leaf->pfn = pte_pfn(pte);
+		break;
+	case PGTABLE_LEVEL_PMD:
+		leaf->pfn = pmd_pfn(pte_pmd(pte));
+		break;
+	default:
+		leaf->pfn = pud_pfn(pte_pud(pte));
+		break;
+	}
 
-	return val;
+	prot = pgprot_val(pte_pgprot(pte)) | ns_shared;
+	leaf->prot = __pgprot((prot & ~PTE_TYPE_MASK) | (prot & PTE_VALID));
 }
 
-static int pageattr_pud_entry(pud_t *pud, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
+void arch_cpa_modify_leaf(struct cpa_leaf *leaf, pgprot_t prot)
 {
-	pud_t val = pudp_get(pud);
-
-	if (pud_leaf(val)) {
-		if (WARN_ON_ONCE((next - addr) != PUD_SIZE))
-			return -EINVAL;
-		val = __pud(set_pageattr_masks(pud_val(val), walk));
-		set_pud(pud, val);
-		walk->action = ACTION_CONTINUE;
-	}
+	unsigned int nr = leaf->size / pgtable_level_size(leaf->level);
+	enum pgtable_level level = leaf->level;
+	pteval_t val = pgprot_val(prot);
+	unsigned long pfn = leaf->pfn;
+	pte_t *kpte = leaf->kpte;
+	unsigned long pfninc;
+	unsigned int i;
 
-	return 0;
-}
+	pfninc = pgtable_level_size(level) >> PAGE_SHIFT;
 
-static int pageattr_pmd_entry(pmd_t *pmd, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
-{
-	pmd_t val = pmdp_get(pmd);
-
-	if (pmd_leaf(val)) {
-		if (WARN_ON_ONCE((next - addr) != PMD_SIZE))
-			return -EINVAL;
-		val = __pmd(set_pageattr_masks(pmd_val(val), walk));
-		set_pmd(pmd, val);
-		walk->action = ACTION_CONTINUE;
-	}
+	if (level == PGTABLE_LEVEL_PTE)
+		val |= PTE_TYPE_PAGE & ~PTE_VALID;
+	prot = __pgprot(val);
 
-	return 0;
+	/*
+	 * The entries of a contiguous block are rewritten one by one, so the
+	 * block has mixed permissions until the last store, as any mapping has
+	 * until the TLB flush of the request.
+	 */
+	for (i = 0; i < nr; i++, pfn += pfninc) {
+		switch (level) {
+		case PGTABLE_LEVEL_PTE:
+			__set_pte(kpte + i, pfn_pte(pfn, prot));
+			break;
+		case PGTABLE_LEVEL_PMD:
+			set_pmd((pmd_t *)kpte + i, pfn_pmd(pfn, prot));
+			break;
+		default:
+			set_pud((pud_t *)kpte + i, pfn_pud(pfn, prot));
+			break;
+		}
+	}
 }
 
-static int pageattr_pte_entry(pte_t *pte, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
+void arch_cpa_flush(struct cpa_data *cpa)
 {
-	pte_t val = __ptep_get(pte);
-
-	val = __pte(set_pageattr_masks(pte_val(val), walk));
-	__set_pte(pte, val);
+	/*
+	 * If the memory is being switched from present-invalid to valid without
+	 * changing any other bits then a TLBI isn't required as a non-valid
+	 * entry cannot be cached in the TLB.
+	 */
+	if (pgprot_val(cpa->mask_set) == PTE_PRESENT_VALID_KERNEL &&
+	    pgprot_val(cpa->mask_clr) == PTE_PRESENT_INVALID)
+		return;
 
-	return 0;
+	cpa_flush_tlb_kernel_range(cpa);
 }
 
-static const struct mm_walk_ops pageattr_ops = {
-	.pud_entry	= pageattr_pud_entry,
-	.pmd_entry	= pageattr_pmd_entry,
-	.pte_entry	= pageattr_pte_entry,
-};
-
 bool rodata_full __ro_after_init = true;
 
 bool can_set_direct_map(void)
@@ -102,177 +121,189 @@ bool can_set_direct_map(void)
 		arm64_kfence_can_set_direct_map() || is_realm_world();
 }
 
-static int update_range_prot(unsigned long start, unsigned long size,
-			     pgprot_t set_mask, pgprot_t clear_mask)
+/*
+ * If we are manipulating read-only permissions, apply the same
+ * change to the linear mapping of the pages that back this VM area.
+ */
+int arch_cpa_process_alias(struct cpa_data *cpa)
 {
-	struct page_change_data data;
+	pteval_t prot = pgprot_val(cpa->mask_set) | pgprot_val(cpa->mask_clr);
+	unsigned long vaddr = cpa_addr(cpa, cpa->curpage);
+	struct cpa_data alias_cpa;
+	unsigned long alias;
 	int ret;
 
-	data.set_mask = set_mask;
-	data.clear_mask = clear_mask;
+	if (!rodata_full || !(prot & PTE_RDONLY))
+		return 0;
 
-	ret = split_kernel_leaf_mapping(start, start + size);
+	/* Memory that is not RAM, like ioremap(), has no linear map alias. */
+	if (cpa_is_direct_map(vaddr) || !pfn_valid(cpa->pfn))
+		return 0;
+
+	alias = (unsigned long)page_address(pfn_to_page(cpa->pfn));
+	ret = split_kernel_leaf_mapping(alias,
+					alias + cpa->numpages * PAGE_SIZE);
 	if (WARN_ON_ONCE(ret))
 		return ret;
 
-	lazy_mmu_mode_enable();
+	alias_cpa = *cpa;
+	alias_cpa.addr = alias;
+	pgprot_val(alias_cpa.mask_set) &= PTE_RDONLY | PTE_WRITE;
+	pgprot_val(alias_cpa.mask_clr) &= PTE_RDONLY | PTE_WRITE;
 
-	/*
-	 * The caller must ensure that the range we are operating on does not
-	 * partially overlap a block mapping, or a cont mapping. Any such case
-	 * must be eliminated by splitting the mapping.
-	 */
-	ret = walk_kernel_page_table_range_lockless(start, start + size,
-						    &pageattr_ops, NULL, &data);
-	lazy_mmu_mode_disable();
+	ret = cpa_change_alias(cpa, &alias_cpa);
+	if (alias_cpa.state & CPA_ST_FLUSHTLB)
+		arch_cpa_flush(&alias_cpa);
 
 	return ret;
 }
 
-static int __change_memory_common(unsigned long start, unsigned long size,
-				  pgprot_t set_mask, pgprot_t clear_mask)
-{
-	int ret;
-
-	ret = update_range_prot(start, size, set_mask, clear_mask);
-
-	/*
-	 * If the memory is being switched from present-invalid to valid without
-	 * changing any other bits then a TLBI isn't required as a non-valid
-	 * entry cannot be cached in the TLB.
-	 */
-	if (pgprot_val(set_mask) != PTE_PRESENT_VALID_KERNEL ||
-	    pgprot_val(clear_mask) != PTE_PRESENT_INVALID)
-		flush_tlb_kernel_range(start, start + size);
-	return ret;
-}
+static const struct cpa_op_prot cpa_ops[CPA_OP_NR] = {
+	[CPA_OP_RO]	= { .set = __pgprot(PTE_RDONLY),
+			    .clr = __pgprot(PTE_WRITE) },
+	[CPA_OP_RW]	= { .set = __pgprot(PTE_WRITE),
+			    .clr = __pgprot(PTE_RDONLY) },
+	[CPA_OP_X]	= { .set = __pgprot(PTE_GP),
+			    .clr = __pgprot(PTE_PXN) },
+	[CPA_OP_NX]	= { .set = __pgprot(PTE_PXN),
+			    .clr = __pgprot(PTE_GP) },
+	[CPA_OP_ROX]	= { .set = __pgprot(PTE_RDONLY | PTE_GP),
+			    .clr = __pgprot(PTE_WRITE | PTE_PXN) },
+	[CPA_OP_DIRECT_MAP_INVALID] = {
+		.set = __pgprot(PTE_PRESENT_INVALID),
+		.clr = __pgprot(PTE_VALID | PTE_NG),
+	},
+	[CPA_OP_DIRECT_MAP_DEFAULT] = {
+		.set = __pgprot(PTE_VALID | PTE_NG | PTE_WRITE),
+		.clr = __pgprot(PTE_PRESENT_INVALID | PTE_RDONLY),
+	},
+};
 
-static int change_memory_common(unsigned long addr, int numpages,
-				pgprot_t set_mask, pgprot_t clear_mask)
+int arch_cpa_prepare(struct cpa_data *cpa, enum cpa_op op)
 {
-	unsigned long start = addr;
-	unsigned long size = PAGE_SIZE * numpages;
-	unsigned long end = start + size;
-	struct vm_struct *area;
+	unsigned long start = PAGE_ALIGN_DOWN(cpa->addr);
+	unsigned long end = start + cpa->numpages * PAGE_SIZE;
 	int ret;
 
-	if (!PAGE_ALIGNED(addr)) {
-		start &= PAGE_MASK;
-		end = start + size;
-		WARN_ON_ONCE(1);
-	}
-
-	/*
-	 * Kernel VA mappings are always live, and splitting live section
-	 * mappings into page mappings may cause TLB conflicts. This means
-	 * we have to ensure that changing the permission bits of the range
-	 * we are operating on does not result in such splitting.
-	 *
-	 * Let's restrict ourselves to mappings created by vmalloc (or vmap).
-	 * Disallow VM_ALLOW_HUGE_VMAP mappings to guarantee that only page
-	 * mappings are updated and splitting is never needed.
-	 *
-	 * So check whether the [addr, addr + size) interval is entirely
-	 * covered by precisely one VM area that has the VM_ALLOC flag set.
-	 */
-	area = find_vm_area((void *)addr);
-	if (!area ||
-	    ((unsigned long)kasan_reset_tag((void *)end) >
-	     (unsigned long)kasan_reset_tag(area->addr) + area->size) ||
-	    ((area->flags & (VM_ALLOC | VM_ALLOW_HUGE_VMAP)) != VM_ALLOC))
-		return -EINVAL;
-
-	if (!numpages)
+	/* Nothing in the linear map is invalid without can_set_direct_map() */
+	if ((op == CPA_OP_DIRECT_MAP_INVALID ||
+	     op == CPA_OP_DIRECT_MAP_DEFAULT) && !can_set_direct_map())
 		return 0;
 
-	/*
-	 * If we are manipulating read-only permissions, apply the same
-	 * change to the linear mapping of the pages that back this VM area.
-	 */
-	if (rodata_full && (pgprot_val(set_mask) == PTE_RDONLY ||
-			    pgprot_val(clear_mask) == PTE_RDONLY)) {
-		unsigned long idx = ((unsigned long)kasan_reset_tag((void *)start) -
-				     (unsigned long)kasan_reset_tag(area->addr))
-				    >> PAGE_SHIFT;
-		for (; numpages; idx++, numpages--) {
-			ret = __change_memory_common((u64)page_address(area->pages[idx]),
-						     PAGE_SIZE, set_mask, clear_mask);
-			if (ret)
-				return ret;
-		}
-	}
+	ret = split_kernel_leaf_mapping(start, end);
+	if (WARN_ON_ONCE(ret))
+		return ret;
+
+	cpa_init_op(cpa, &cpa_ops[op]);
 
 	/*
-	 * Get rid of potentially aliasing lazily unmapped vm areas that may
-	 * have permissions set that deviate from the ones we are setting here.
+	 * A valid kernel entry has nG only with nG mappings and GP only with
+	 * BTI, see PTE_MAYBE_NG and PTE_MAYBE_GP.
 	 */
-	vm_unmap_aliases();
+	if (!arm64_use_ng_mappings &&
+	    (pgprot_val(cpa->mask_set) & PTE_VALID))
+		pgprot_val(cpa->mask_set) &= ~PTE_NG;
+	if (!system_supports_bti_kernel())
+		pgprot_val(cpa->mask_set) &= ~PTE_GP;
 
-	return __change_memory_common(start, size, set_mask, clear_mask);
+	return 0;
 }
 
-int set_memory_ro(unsigned long addr, int numpages)
+void arch_cpa_enter(void)
 {
-	return change_memory_common(addr, numpages,
-					__pgprot(PTE_RDONLY),
-					__pgprot(PTE_WRITE));
+	lazy_mmu_mode_enable();
 }
 
-int set_memory_rw(unsigned long addr, int numpages)
+void arch_cpa_leave(void)
 {
-	return change_memory_common(addr, numpages,
-					__pgprot(PTE_WRITE),
-					__pgprot(PTE_RDONLY));
+	lazy_mmu_mode_disable();
 }
 
-int set_memory_nx(unsigned long addr, int numpages)
+static int set_valid_pte(pte_t *ptep, unsigned long addr, void *data)
 {
-	return change_memory_common(addr, numpages,
-					__pgprot(PTE_PXN),
-					__pgprot(PTE_MAYBE_GP));
-}
+	struct cpa_op_prot *prot = data;
+	pte_t pte = __ptep_get(ptep);
 
-int set_memory_x(unsigned long addr, int numpages)
-{
-	return change_memory_common(addr, numpages,
-					__pgprot(PTE_MAYBE_GP),
-					__pgprot(PTE_PXN));
+	/*
+	 * Some users clear and set bits which alias each other (e.g. PTE_NG and
+	 * PTE_PRESENT_INVALID). It is therefore important that we always clear
+	 * first then set.
+	 */
+	pte = clear_pte_bit(pte, prot->clr);
+	pte = set_pte_bit(pte, prot->set);
+	__set_pte(ptep, pte);
+
+	return 0;
 }
 
+/*
+ * KFENCE and debug_pagealloc change the linear map with interrupts
+ * disabled. Their pages are mapped with PTEs that nothing splits or
+ * collapses.
+ */
 int set_memory_valid(unsigned long addr, int numpages, int enable)
 {
-	if (enable)
-		return __change_memory_common(addr, PAGE_SIZE * numpages,
-					__pgprot(PTE_PRESENT_VALID_KERNEL),
-					__pgprot(PTE_PRESENT_INVALID));
-	else
-		return __change_memory_common(addr, PAGE_SIZE * numpages,
-					__pgprot(PTE_PRESENT_INVALID),
-					__pgprot(PTE_PRESENT_VALID_KERNEL));
+	unsigned long size = PAGE_SIZE * numpages;
+	struct cpa_op_prot prot;
+	int ret;
+
+	if (enable) {
+		prot.set = __pgprot(PTE_PRESENT_VALID_KERNEL);
+		prot.clr = __pgprot(PTE_PRESENT_INVALID);
+	} else {
+		prot.set = __pgprot(PTE_PRESENT_INVALID);
+		prot.clr = __pgprot(PTE_PRESENT_VALID_KERNEL);
+	}
+
+	ret = apply_to_existing_page_range(&init_mm, addr, size, set_valid_pte,
+					   &prot);
+
+	/*
+	 * If the memory is being switched from present-invalid to valid without
+	 * changing any other bits then a TLBI isn't required as a non-valid
+	 * entry cannot be cached in the TLB.
+	 */
+	if (!enable)
+		flush_tlb_kernel_range(addr, addr + size);
+
+	return ret;
 }
 
-int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages)
+/*
+ * Unlike set_memory_*(), the arm64 users of the core don't purge the
+ * lazily freed vmap aliases first.
+ */
+int arm64_change_page_attr(struct cpa_data *cpa)
 {
-	pgprot_t clear_mask = __pgprot(PTE_PRESENT_VALID_KERNEL);
-	pgprot_t set_mask = __pgprot(PTE_PRESENT_INVALID);
+	int ret;
 
-	if (!can_set_direct_map())
-		return 0;
+	arch_cpa_enter();
+	ret = change_page_attr_noflush(cpa);
+	arch_cpa_leave();
+
+	if (cpa->state & CPA_ST_FLUSHTLB)
+		arch_cpa_flush(cpa);
 
-	return update_range_prot((unsigned long)page_address(page),
-				 PAGE_SIZE * numpages, set_mask, clear_mask);
+	return ret;
 }
 
-int set_direct_map_default_noflush(struct page *page, unsigned int numpages)
+static int __change_memory_common(unsigned long start, unsigned long size,
+				  pgprot_t set_mask, pgprot_t clear_mask)
 {
-	pgprot_t set_mask = __pgprot(PTE_PRESENT_VALID_KERNEL | PTE_WRITE);
-	pgprot_t clear_mask = __pgprot(PTE_PRESENT_INVALID | PTE_RDONLY);
+	struct cpa_data cpa = {
+		.addr = start,
+		.numpages = size >> PAGE_SHIFT,
+		.mask_set = set_mask,
+		.mask_clr = clear_mask,
+		.flags = CPA_REQ_NO_CHECK_ALIAS,
+	};
+	int ret;
 
-	if (!can_set_direct_map())
-		return 0;
+	ret = split_kernel_leaf_mapping(start, start + size);
+	if (WARN_ON_ONCE(ret))
+		return ret;
 
-	return update_range_prot((unsigned long)page_address(page),
-				 PAGE_SIZE * numpages, set_mask, clear_mask);
+	return arm64_change_page_attr(&cpa);
 }
 
 int __set_memory_enc_dec(unsigned long addr, int numpages, bool encrypt)

-- 
2.53.0


