Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C26FDC44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852566B00B8; Tue, 21 Jul 2026 12:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A816B00BA; Tue, 21 Jul 2026 12:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73F636B00BB; Tue, 21 Jul 2026 12:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 492196B00B8
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:25:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB53C1C00BE
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:25:40 +0000 (UTC)
X-FDA: 85013309640.18.3D2925E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3E3D640009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:25:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XqqN/bFC";
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lKuouZUWiliqEzvX8jfxO0D9kZmdP2LG9G/fLlb9XgA=;
	b=sCgNR49c0zY+wJa88gTA+e8j6tN4Tm24MRQvuTVxVI7HAPkkuHYf6Wlavo/0Blf3BL06og
	tg71n8SRKzKeh6EdMbtlB0xlmKda5/o2bFwYgHHWtre/K6020FjkuSCcYFbc6pJy3WjwAF
	UYAGChtrcm4ErCYOgRs/CfvLQrkfo3I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XqqN/bFC";
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651139;
	b=VmXqGwEqa4iTUYXALRAUTK9xZt7pV+pxXkLAnceXjqVpBPPhoXerkmOcVN2EfxBQHX8Twz
	JmkPEed5wERXhNfsqaN1ET9mYcNSIuGXyEgCnAXYsTHpcwsqpTbRoH20PR+DrYFCkEFhcc
	ycAQt6QOAytvwlmT/bwdx4g1bkYXkO8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C136E600D8;
	Tue, 21 Jul 2026 16:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E101F00A3A;
	Tue, 21 Jul 2026 16:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651138;
	bh=lKuouZUWiliqEzvX8jfxO0D9kZmdP2LG9G/fLlb9XgA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XqqN/bFCEPGUlYCwRNRdBPSDSK0cgIhKI+bK8TfQDSaAjxE9/lHYrZMMUWfkHMSWY
	 nG2SvVJId1EkJR1gaBcUUnSV79qPEpQBx5OpYrOns8MOcAvbUFbT2vscElhtvy892T
	 heN+vKkj4PGk+b0JKDOtAAUNrSciSraGStWY0mP8raDsoIYw3UaGbTeqZoSk7Wx1MR
	 Hm6CW28FnuJxWvv0gPd9Tvwr1jFBCjcOzdO1j2TeQ2G13nGQ+a4IA/iTYXG3hJNJiZ
	 IRks7sQk8MZOlcU+L1BzkweWP/kns90bnbxZQnn5Je2jcAbfxSeKxzREtuHG1NpXR+
	 yfGTvQlzK5VMQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:40 +0300
Subject: [PATCH RFC 17/18] loongarch: convert set_memory to the generic CPA
 implementation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-17-2c1fc62306b3@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <jackmanb@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3E3D640009
X-Stat-Signature: ekmi19xsjb614bch67kxng318yszp7oz
X-HE-Tag: 1784651139-836584
X-HE-Meta: U2FsdGVkX1+Z/Wm2h2xen3tYk5pOZNsM6MDg/4p0Kw05IwAjWRLFez65ReBBVkb2eU9yjQX/09uMW19K2qCP7+uXiWLh5V6klTfl/+hLSMTqTDkZvb1Y2y4g/fZHOWmwbs3d1Xcq/up8sWCD5TdhvNm5xwoInOHq9HJc5tzLGb66VLm1ol8f9IXBbVZdWKBRQEBk03PX2K3SmYtmUbCFYAIE5dU0wAa68suzXBvTLotDO0dtAL4K2eU2Aw59DEdUDfuz6ANoN5Ibo7+3ceeyGP88l2tY/s2QNGrhfYCltfhMfjYui3yKI6Jknnp1ajqq4waiJTdbklbpa3P4Esp8ebbGHO3ic0AMzoOLSEleCoiGy+XqrSlPJkO3Jhh8r5Gj7/XqlbiKQ4wVt/NeE2FZKW2jTVeaoqTTUvhCH4qUbP0By8qu5bQl8fBS5Iw6BXYYUTs2im5aWeg8ZYC9IsXpEowA+BP+YTjoMpmEHUZ08tgV5XTdnIojufB1/S+eEdHd9CuG1C13xb5/q8jYIwZMgoqAajqXn/qrapzgpHtlqYLhtICl+vkbmxMOa9x696pkikmh6cYpxIT/v35Pm3bxcyJJtBf5BvfHFuyPGEe9kesEFNAkOpttiQaHKlQ/mKRqCF1Sy0BnUYWN1XHTOMnWyaYdNdAHmhRKfLOYvdrKROEIwadpK7zdA7jpvkqjuNXBE21QxU943rd2XKsN3IldqB55IvO1NhgI8OmpQlFM5ZcifQ7JHkRhDvzdOI+x+/C0VsFnqtDhFiuJgshaGFNRAudn0SoNq3R3wYdarlhbF7Bzc+1ZrQpMgETUeFi1TGE9gqn0vu4dpxulx0rqCGbFgKOOWXqZ7f8gc4YDWqX6gsDwUYMMSRCh+sN7mrnCWa/iyEGHY6r7B29qXl2PHELl7u/bqbS1d0+2EhYJwKq+od/qE9Je+5OCcXD5trkgnfT2N7WQmk7/J76t7epxxf3
 499jBE7a
 bfWgvCmZ8/9hG/BR8A9s5LPN0Iq46VLOUZMzz2aTVIG1TaqgDLrkMbKuIY+/aRr2zM2S8wCMDw7xPl0wd5nbvUrQpDiWLbHJQamINnPtQHSCzdFHmIjzDDVaYgTjef/7Erhru78Wh3FEKogy76UDg5C6zl5jsTOSp3HInRodjyV8phOQSIMEbuC475XatKRlJJaUb6W+h1coFF1LwOtu7yI4aWa45uZAvs6CUZdnfG9sx6nLuOZAWU3b/PKyO2z++5GANj9N1hqS0tMjbVbqPN+sAFGkh0ulw16E26+J9HI7A06deuim0uR9Ym5cTtxb/qSWP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the pageattr_ops based page table walk in
arch/loongarch/mm/pageattr.c with the common change_page_attr() loop,
implement the required architecture hooks and opt-in for
CONFIG_GENERIC_SET_MEMORY.

Instead if pre-splitting large pages with split_linear_mapping() use
loongarch-specific implementation of arch_should_split_large_page() and
arch_split_large_page().

Assisted-by: Copilot:claude-opus-4.8
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/loongarch/Kconfig                  |   1 +
 arch/loongarch/include/asm/pgtable.h    |  42 ++++++++
 arch/loongarch/include/asm/set_memory.h |   9 ++
 arch/loongarch/mm/pageattr.c            | 173 ++++++++++----------------------
 4 files changed, 106 insertions(+), 119 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index d8d252325017..1bfa94797b1b 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -109,6 +109,7 @@ config LOONGARCH
 	select GENERIC_LIB_DEVMEM_IS_ALLOWED
 	select GENERIC_PCI_IOMAP
 	select GENERIC_SCHED_CLOCK
+	select GENERIC_SET_MEMORY
 	select GENERIC_SMP_IDLE_THREAD
 	select GPIOLIB
 	select HAS_IOPORT
diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 223528c04d73..377bef0894d7 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -638,6 +638,48 @@ static inline long pmd_protnone(pmd_t pmd)
 #define pmd_leaf(pmd)		((pmd_val(pmd) & _PAGE_HUGE) != 0)
 #define pud_leaf(pud)		((pud_val(pud) & _PAGE_HUGE) != 0)
 
+#define pgd_write pgd_write
+static inline int pgd_write(pgd_t pgd)
+{
+	return !!(pgd_val(pgd) & _PAGE_WRITE);
+}
+
+#define p4d_write p4d_write
+static inline int p4d_write(p4d_t p4d)
+{
+	return !!(p4d_val(p4d) & _PAGE_WRITE);
+}
+
+#define pud_write pud_write
+static inline int pud_write(pud_t pud)
+{
+	return !!(pud_val(pud) & _PAGE_WRITE);
+}
+
+#define pgd_exec pgd_exec
+static inline int pgd_exec(pgd_t pgd)
+{
+	return !(pgd_val(pgd) & _PAGE_NO_EXEC);
+}
+
+#define p4d_exec p4d_exec
+static inline int p4d_exec(p4d_t p4d)
+{
+	return !(p4d_val(p4d) & _PAGE_NO_EXEC);
+}
+
+#define pud_exec pud_exec
+static inline int pud_exec(pud_t pud)
+{
+	return !(pud_val(pud) & _PAGE_NO_EXEC);
+}
+
+#define pmd_exec pmd_exec
+static inline int pmd_exec(pmd_t pmd)
+{
+	return !(pmd_val(pmd) & _PAGE_NO_EXEC);
+}
+
 /*
  * We provide our own get_unmapped area to cope with the virtual aliasing
  * constraints placed on us by the cache architecture.
diff --git a/arch/loongarch/include/asm/set_memory.h b/arch/loongarch/include/asm/set_memory.h
index 55dfaefd02c8..6ffb4fe5a75b 100644
--- a/arch/loongarch/include/asm/set_memory.h
+++ b/arch/loongarch/include/asm/set_memory.h
@@ -19,4 +19,13 @@ int set_direct_map_default_noflush(struct page *page);
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 
+/*
+ * The direct map is a fixed address window that is not backed by page tables,
+ * so a page never has a second mapping whose protection must be synchronised.
+ */
+static inline bool cpa_should_update_alias(unsigned long vaddr, unsigned long pfn)
+{
+	return false;
+}
+
 #endif /* _ASM_LOONGARCH_SET_MEMORY_H */
diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
index 614ccc7afccb..4500769ccf6a 100644
--- a/arch/loongarch/mm/pageattr.c
+++ b/arch/loongarch/mm/pageattr.c
@@ -4,126 +4,83 @@
  */
 
 #include <linux/memblock.h>
-#include <linux/pagewalk.h>
+#include <linux/mm.h>
 #include <linux/pgtable.h>
+#include <linux/set_memory.h>
 #include <asm/set_memory.h>
 #include <asm/tlbflush.h>
 
-struct pageattr_masks {
-	pgprot_t set_mask;
-	pgprot_t clear_mask;
-};
-
-static unsigned long set_pageattr_masks(unsigned long val, struct mm_walk *walk)
+static unsigned long set_pageattr_masks(struct cpa_data *cpa, unsigned long val)
 {
-	unsigned long new_val = val;
-	struct pageattr_masks *masks = walk->private;
-
-	new_val &= ~(pgprot_val(masks->clear_mask));
-	new_val |= (pgprot_val(masks->set_mask));
+	val &= ~pgprot_val(cpa->mask_clr);
+	val |= pgprot_val(cpa->mask_set);
 
-	return new_val;
+	return val;
 }
 
-static int pageattr_pgd_entry(pgd_t *pgd, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
+int arch_should_split_large_page(struct cpa_data *cpa, struct cpa_split_data *sd)
 {
-	pgd_t val = pgdp_get(pgd);
-
-	if (pgd_leaf(val)) {
-		val = __pgd(set_pageattr_masks(pgd_val(val), walk));
-		set_pgd(pgd, val);
-	}
-
-	return 0;
-}
+	pte_t old = ptep_get(sd->kpte);
+	unsigned long val = pte_val(old);
+	unsigned long new_val = set_pageattr_masks(cpa, val);
 
-static int pageattr_p4d_entry(p4d_t *p4d, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
-{
-	p4d_t val = p4dp_get(p4d);
+	cpa->pfn = pte_pfn(old) + ((sd->address & (sd->psize - 1)) >> PAGE_SHIFT);
 
-	if (p4d_leaf(val)) {
-		val = __p4d(set_pageattr_masks(p4d_val(val), walk));
-		set_p4d(p4d, val);
+	if (new_val != val) {
+		set_pte(sd->kpte, __pte(new_val));
+		cpa->flags |= CPA_FLUSHTLB;
 	}
 
 	return 0;
 }
 
-static int pageattr_pud_entry(pud_t *pud, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
+int arch_split_large_page(struct cpa_data *cpa, struct cpa_split_data *sd)
 {
-	pud_t val = pudp_get(pud);
-
-	if (pud_leaf(val)) {
-		val = __pud(set_pageattr_masks(pud_val(val), walk));
-		set_pud(pud, val);
-	}
+	WARN_ON_ONCE(1);
 
-	return 0;
+	return -EINVAL;
 }
 
-static int pageattr_pmd_entry(pmd_t *pmd, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
+void arch_change_pte(struct cpa_data *cpa, unsigned long address,
+		     pte_t *kpte, pte_t old_pte, bool nx, bool rw)
 {
-	pmd_t val = pmdp_get(pmd);
+	unsigned long val = pte_val(old_pte);
+	pte_t new_pte = __pte(set_pageattr_masks(cpa, val));
 
-	if (pmd_leaf(val)) {
-		val = __pmd(set_pageattr_masks(pmd_val(val), walk));
-		set_pmd(pmd, val);
-	}
+	cpa->pfn = pte_pfn(old_pte);
 
-	return 0;
+	if (pte_val(old_pte) != pte_val(new_pte)) {
+		set_pte(kpte, new_pte);
+		cpa->flags |= CPA_FLUSHTLB;
+	}
 }
 
-static int pageattr_pte_entry(pte_t *pte, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
+int arch_cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
+			   int primary)
 {
-	pte_t val = ptep_get(pte);
-
-	val = __pte(set_pageattr_masks(pte_val(val), walk));
-	set_pte(pte, val);
+	/*
+	 * The direct map has no page tables and vmalloc ranges may contain
+	 * holes. Both are silently skipped.
+	 */
+	cpa->numpages = 1;
 
 	return 0;
 }
 
-static int pageattr_pte_hole(unsigned long addr, unsigned long next,
-			     int depth, struct mm_walk *walk)
+int arch_cpa_process_alias(struct cpa_data *cpa)
 {
 	return 0;
 }
 
-static const struct mm_walk_ops pageattr_ops = {
-	.pgd_entry = pageattr_pgd_entry,
-	.p4d_entry = pageattr_p4d_entry,
-	.pud_entry = pageattr_pud_entry,
-	.pmd_entry = pageattr_pmd_entry,
-	.pte_entry = pageattr_pte_entry,
-	.pte_hole = pageattr_pte_hole,
-	.walk_lock = PGWALK_RDLOCK,
-};
-
-static int __set_memory(unsigned long addr, int numpages, pgprot_t set_mask, pgprot_t clear_mask)
+void arch_cpa_flush(struct cpa_data *cpa, int err)
 {
-	int ret;
-	unsigned long start = addr;
-	unsigned long end = start + PAGE_SIZE * numpages;
-	struct pageattr_masks masks = {
-		.set_mask = set_mask,
-		.clear_mask = clear_mask
-	};
-
-	if (!numpages)
-		return 0;
-
-	mmap_write_lock(&init_mm);
-	ret = walk_kernel_page_table_range(start, end, &pageattr_ops, NULL, &masks);
-	mmap_write_unlock(&init_mm);
-
-	flush_tlb_kernel_range(start, end);
+	if (err || cpa->force_flush_all ||
+	    (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))) {
+		flush_tlb_all();
+		return;
+	}
 
-	return ret;
+	flush_tlb_kernel_range(*cpa->vaddr, *cpa->vaddr + cpa->numpages * PAGE_SIZE);
 }
 
 int set_memory_x(unsigned long addr, int numpages)
@@ -131,7 +88,7 @@ int set_memory_x(unsigned long addr, int numpages)
 	if (addr < vm_map_base)
 		return 0;
 
-	return __set_memory(addr, numpages, __pgprot(0), __pgprot(_PAGE_NO_EXEC));
+	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_NO_EXEC), 0);
 }
 
 int set_memory_nx(unsigned long addr, int numpages)
@@ -139,7 +96,7 @@ int set_memory_nx(unsigned long addr, int numpages)
 	if (addr < vm_map_base)
 		return 0;
 
-	return __set_memory(addr, numpages, __pgprot(_PAGE_NO_EXEC), __pgprot(0));
+	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_NO_EXEC), 0);
 }
 
 int set_memory_ro(unsigned long addr, int numpages)
@@ -147,7 +104,7 @@ int set_memory_ro(unsigned long addr, int numpages)
 	if (addr < vm_map_base)
 		return 0;
 
-	return __set_memory(addr, numpages, __pgprot(0), __pgprot(_PAGE_WRITE | _PAGE_DIRTY));
+	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_WRITE | _PAGE_DIRTY), 0);
 }
 
 int set_memory_rw(unsigned long addr, int numpages)
@@ -155,46 +112,22 @@ int set_memory_rw(unsigned long addr, int numpages)
 	if (addr < vm_map_base)
 		return 0;
 
-	return __set_memory(addr, numpages, __pgprot(_PAGE_WRITE | _PAGE_DIRTY), __pgprot(0));
+	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_WRITE | _PAGE_DIRTY), 0);
 }
 
 bool kernel_page_present(struct page *page)
 {
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
+	unsigned int level;
 	unsigned long addr = (unsigned long)page_address(page);
+	pte_t *pte;
 
 	if (addr < vm_map_base)
 		return memblock_is_memory(__pa(addr));
 
-	pgd = pgd_offset_k(addr);
-	if (pgd_none(pgdp_get(pgd)))
-		return false;
-	if (pgd_leaf(pgdp_get(pgd)))
-		return true;
-
-	p4d = p4d_offset(pgd, addr);
-	if (p4d_none(p4dp_get(p4d)))
-		return false;
-	if (p4d_leaf(p4dp_get(p4d)))
-		return true;
-
-	pud = pud_offset(p4d, addr);
-	if (pud_none(pudp_get(pud)))
-		return false;
-	if (pud_leaf(pudp_get(pud)))
-		return true;
-
-	pmd = pmd_offset(pud, addr);
-	if (pmd_none(pmdp_get(pmd)))
+	pte = lookup_address(addr, &level);
+	if (!pte)
 		return false;
-	if (pmd_leaf(pmdp_get(pmd)))
-		return true;
 
-	pte = pte_offset_kernel(pmd, addr);
 	return pte_present(ptep_get(pte));
 }
 
@@ -205,7 +138,8 @@ int set_direct_map_default_noflush(struct page *page)
 	if (addr < vm_map_base)
 		return 0;
 
-	return __set_memory(addr, 1, PAGE_KERNEL, __pgprot(0));
+	return change_page_attr_set_clr(&addr, 1, PAGE_KERNEL,
+					__pgprot(0), 0, 0, NULL);
 }
 
 int set_direct_map_invalid_noflush(struct page *page)
@@ -215,7 +149,8 @@ int set_direct_map_invalid_noflush(struct page *page)
 	if (addr < vm_map_base)
 		return 0;
 
-	return __set_memory(addr, 1, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
+	return change_page_attr_clear(&addr, 1,
+				      __pgprot(_PAGE_PRESENT | _PAGE_VALID), 0);
 }
 
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
@@ -234,5 +169,5 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 		clear = __pgprot(_PAGE_PRESENT | _PAGE_VALID);
 	}
 
-	return __set_memory(addr, nr, set, clear);
+	return change_page_attr_set_clr(&addr, nr, set, clear, 0, 0, NULL);
 }

-- 
2.53.0


