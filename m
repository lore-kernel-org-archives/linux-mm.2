Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E460606A329
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fvGXWZv+
Received: by kanga.kvack.org (Postfix)
	id 680456B05F7; Thu, 26 Nov 2026 06:20:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657EA6B05F8; Thu, 26 Nov 2026 06:20:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56D5B6B05F9; Thu, 26 Nov 2026 06:20:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1666B05F7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:20:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A00261603BC
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:20:18 +0000 (UTC)
X-FDA: 85477026516.09.F4AD74B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id DC8F3100005
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:20:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fvGXWZv+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692017;
	b=LBpSzSvLOyRdnHlkfcBRNuQs0Ov99lzHE1ywfm2/7ZHrHE3sNZazqvxr9lGC+z7DU7SaxK
	Fb3d/snhZVEAYjXaEebbEq8cROGqBqVmoXYe5mIrqUorxPnGWXGGr7Vi+KqgUxpMhpkUP/
	tEXJ7+usqahGSwVtgLjy5NvlspWTC7c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITguBAtaeU1JouI5XylgxXLQvJx8CTSOCOcbVUzTjd8=;
	b=bWs3pQiFFv9wLcmIfUnGX6sHMfp+ul786Le9yZba3IITG7S8RtFerwx3rWO6prBVtF6CQa
	9hlcvqfM14DCVMEWwGznPPNdUI/NIgmuHmYCI1DyObOVeQJx7iVKWDq+lNqZt/no17nbNC
	ngN4sfmb29CFCHlgyBOmbLXJCMZTteQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fvGXWZv+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F84F4588F;
	Thu, 26 Nov 2026 11:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962C01F00A3D;
	Thu, 26 Nov 2026 11:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692016;
	bh=ITguBAtaeU1JouI5XylgxXLQvJx8CTSOCOcbVUzTjd8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fvGXWZv+8pi99qzU7b5EhDoIXdzzJsiCfHc+1Zlntkr3m3pkhun1WINtqz4rdzsie
	 jziiCB0LdrTQeKoKP+cu5R80r2pIsX/Y0JsIKlz5jTCWUHlJ5PjjGI7kbGWq6SQUBC
	 OH/NSmXziwPx8bzuosEs4237MSu29h0F0RtcX8jYgwEoV/Vjg9phJULHmw3gJouIze
	 9hIqTpIOLEN8A567d+YKTz+F7fcaL7zu2Hm9VGG6vowtOIjNt2ZwOa9fzC16hdBprX
	 fyURUQ8TtPloWpWF1yAFJ3g1MUNAfNtlp8BhC8QfIDp8DVvIbbD1Do5rDdAqZmpJqT
	 FPBg70e6baOtw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:49 +0200
Subject: [PATCH RFC v2 36/54] LoongArch: use the generic CPA core
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-36-723f1e33c3d8@kernel.org>
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
X-Stat-Signature: bo6he6ocqu4u96uxe43ts8s3bbu71e7b
X-Rspamd-Queue-Id: DC8F3100005
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795692016-821283
X-HE-Meta: U2FsdGVkX1+Wo1BLXeDtbbA1PmvfDsWkDTAgYexP5SQTeyHPOt6I8NoPqjMrTRg1Hm9gN9EgPTQu2iqi+0A5brA/RhafitHDhWlEewdlRovMaSsGd6/tgadoiN1rod2uCxwthk41D1vFAk5AWNxb1iSVk7oUeK0WBgf9/0XLIYfqyg0fTSZZ85EuNQwxrIHwM7nTbhOFburyKBVt53P3Jz5nyCKdVPPGUheG9vwh9JB9E382Jk9L4mVZF5TWiNxzajTXf4vwwVySxUivgKhGfwtP5wG4oDxPXGPeF4QlG+0dYVO20rYC9O4uk34qagJvj0Q6g+3hMTgNXFHBDp35w4/uzWb7dTZqO7LjgC2sL093jrCrWiIXP4PUZpvOMzXJxYvTS1FfGi4vIfqnuZ6i0RGzoTG9srwlihgGraC7DXzfF2lcfri3QsUktKSi4BZTFJ+4QBhunJg52iSUifnnabJHteoaekT7ourdhH/xfBR6ZDNOFIMQFqddoGjVo10HJEortOwoUHEamFLO+qL4KCVDgI9LrZNxDG1JE+lDZxfQyTV1vhsBhaVF6GXrtqTWQ6PlkRyIYQ8zGKjnpzRhIc+zS5dvoAT8qjPzPUP4gW/POzLwNg1LmToPIza57rsgj9Ht7Ogd0DWWsXNzdlhetmOcJb2vrQTTIONoeo+r4rI3TmZgQjguo90m+wnny6msUJoaty0U/z1KmGwAZ1rgJyqV5xYFKWJdOn53DQyLemSO9i923KoIoMcoJRvCxaabUC3+2lt9se06M9CIzC/DVkiSjXOfGJ4kWpjWNLMT4B53EL5F0cgdQEsaU5AaqbpY7UD2K99KwVTNmHJ7tPRglIAh244YCYyLOWA0mv08415Xny8i4tNOlbVbP3gsC5dPp7wWgvwohhpG7hkuRd9iZxCibhkv8LjenDWQ46D7sabsRgVjYknccZWm6fIF8xcQ4VlZ7kbAq3q2Vv39QDH
 Ut/Z5yJH
 6u3TREqpih06DL5ZLH+dn6Afg2TDaJZ8aRMJLtWRky3qRIS5L5BaMzsXmHxEl++1qr/qhXViOkHEP5bZPjOwaJdev354vcNemgOSMYzYVKlXjPMDJVQJVPvKjLJ1L6B5j94Wh7TLeGPV6ICRl2dBhcH0x8kSdff8DZMpXye6Mt5reH7LxTF8GNmiTgDk/pnMVSzkB3f05BJEfRQb7w32QNhbWZCR+ER2k7ia+2B9NT4Vf6Dge2szLbMv9yZgQ5WFygqe8GpRevfScqezcee5taDWDArRPr/eO9No6SzDY+MDG+vmZF+UPEhkLp3AM4xjleL6Zlp1VBdrv3F1v8unSu1gS3k71FxX8gagrzL/YeLCkOzibgATMXd6hK8wZw2UrN8X/enlqtJFB+uuSaHtZ4VlkPNXZpFiuieFBA+t1gpuhb4W9Qz+bT/vVZuvwuGo2macs/ip5IH8mds8iw2RlLK5C7M1bwxC9/8QB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The availability of the generic CPA core makes LoongArch's implementation
of set_memory_*() APIs unnecessary.

The page table walk in arch/loongarch/mm/pageattr.c can be replaced with
several simple hooks required by CPA core.

This way the core can manage the policy decisions and the architecture only
has to take care of the page table manipulation.

Switch to the generic CPA core and its set_memory() entry points.
For LoongArch this means that:

* an empty entry in the range is reported with a warning and -EFAULT
* nothing is written or flushed when nothing changes
* a request that fails flushes the entire TLB
* set_memory_rox() is a single request instead of set_memory_ro() followed
  by set_memory_x()
* requests are serialized by the core, rather than by the init_mm write
  lock
* lazily unmapped vmap areas are purged before a request, so that they do
  not keep stale TLB entries with the old protection

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/loongarch/Kconfig                  |   1 +
 arch/loongarch/include/asm/set_memory.h |   8 +--
 arch/loongarch/mm/pageattr.c            | 102 ++++++++------------------------
 3 files changed, 28 insertions(+), 83 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index bad699e2847f..455a72b8669d 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -107,6 +107,7 @@ config LOONGARCH
 	select GENERIC_LIB_LSHRDI3
 	select GENERIC_LIB_UCMPDI2
 	select GENERIC_LIB_DEVMEM_IS_ALLOWED
+	select GENERIC_PAGEATTR
 	select GENERIC_PCI_IOMAP
 	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
diff --git a/arch/loongarch/include/asm/set_memory.h b/arch/loongarch/include/asm/set_memory.h
index 64c7f942e8ec..5496a3ee27da 100644
--- a/arch/loongarch/include/asm/set_memory.h
+++ b/arch/loongarch/include/asm/set_memory.h
@@ -6,12 +6,6 @@
 #ifndef _ASM_LOONGARCH_SET_MEMORY_H
 #define _ASM_LOONGARCH_SET_MEMORY_H
 
-/*
- * Functions to change memory attributes.
- */
-int set_memory_x(unsigned long addr, int numpages);
-int set_memory_nx(unsigned long addr, int numpages);
-int set_memory_ro(unsigned long addr, int numpages);
-int set_memory_rw(unsigned long addr, int numpages);
+#include <asm-generic/set_memory.h>
 
 #endif /* _ASM_LOONGARCH_SET_MEMORY_H */
diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
index 11cea93c7415..a90380b387d3 100644
--- a/arch/loongarch/mm/pageattr.c
+++ b/arch/loongarch/mm/pageattr.c
@@ -3,100 +3,50 @@
  * Copyright (C) 2024 Loongson Technology Corporation Limited
  */
 
-#include <linux/pagewalk.h>
+#include <linux/pageattr.h>
 #include <linux/pgtable.h>
 #include <asm/set_memory.h>
 #include <asm/tlbflush.h>
 
-struct pageattr_masks {
-	pgprot_t set_mask;
-	pgprot_t clear_mask;
-};
-
-static unsigned long set_pageattr_masks(unsigned long val, struct mm_walk *walk)
-{
-	unsigned long new_val = val;
-	struct pageattr_masks *masks = walk->private;
-
-	new_val &= ~(pgprot_val(masks->clear_mask));
-	new_val |= (pgprot_val(masks->set_mask));
-
-	return new_val;
-}
-
-static int pageattr_pte_entry(pte_t *pte, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
+void arch_cpa_decode_leaf(struct cpa_leaf *leaf)
 {
-	pte_t val = ptep_get(pte);
-
-	val = __pte(set_pageattr_masks(pte_val(val), walk));
-	set_pte(pte, val);
+	pte_t pte = ptep_get(leaf->kpte);
 
-	return 0;
+	leaf->pfn = pte_pfn(pte);
+	leaf->prot = pte_pgprot(pte);
 }
 
-static int pageattr_pte_hole(unsigned long addr, unsigned long next,
-			     int depth, struct mm_walk *walk)
+void arch_cpa_modify_leaf(struct cpa_leaf *leaf, pgprot_t prot)
 {
-	return 0;
+	set_pte(leaf->kpte, pfn_pte(leaf->pfn, prot));
 }
 
-static const struct mm_walk_ops pageattr_ops = {
-	.pte_entry = pageattr_pte_entry,
-	.pte_hole = pageattr_pte_hole,
-	.walk_lock = PGWALK_RDLOCK,
-};
-
-static int __set_memory(unsigned long addr, int numpages, pgprot_t set_mask, pgprot_t clear_mask)
+void arch_cpa_flush(struct cpa_data *cpa)
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
+	if (cpa->state & CPA_ST_FLUSH_ALL) {
+		flush_tlb_all();
+		return;
+	}
 
-	return ret;
+	cpa_flush_tlb_kernel_range(cpa);
 }
 
-int set_memory_x(unsigned long addr, int numpages)
-{
-	if (addr < vm_map_base)
-		return 0;
-
-	return __set_memory(addr, numpages, __pgprot(0), __pgprot(_PAGE_NO_EXEC));
-}
-
-int set_memory_nx(unsigned long addr, int numpages)
-{
-	if (addr < vm_map_base)
-		return 0;
-
-	return __set_memory(addr, numpages, __pgprot(_PAGE_NO_EXEC), __pgprot(0));
-}
+static const struct cpa_op_prot cpa_ops[CPA_OP_NR] = {
+	[CPA_OP_RO]	= { .clr = __pgprot(_PAGE_WRITE | _PAGE_DIRTY) },
+	[CPA_OP_RW]	= { .set = __pgprot(_PAGE_WRITE | _PAGE_DIRTY) },
+	[CPA_OP_X]	= { .clr = __pgprot(_PAGE_NO_EXEC) },
+	[CPA_OP_NX]	= { .set = __pgprot(_PAGE_NO_EXEC) },
+	[CPA_OP_ROX]	= { .clr = __pgprot(_PAGE_WRITE | _PAGE_DIRTY |
+					   _PAGE_NO_EXEC) },
+};
 
-int set_memory_ro(unsigned long addr, int numpages)
+int arch_cpa_prepare(struct cpa_data *cpa, enum cpa_op op)
 {
-	if (addr < vm_map_base)
+	/* The direct mapping windows below vm_map_base have no page tables */
+	if (cpa->addr < vm_map_base)
 		return 0;
 
-	return __set_memory(addr, numpages, __pgprot(0), __pgprot(_PAGE_WRITE | _PAGE_DIRTY));
-}
+	cpa_init_op(cpa, &cpa_ops[op]);
 
-int set_memory_rw(unsigned long addr, int numpages)
-{
-	if (addr < vm_map_base)
-		return 0;
-
-	return __set_memory(addr, numpages, __pgprot(_PAGE_WRITE | _PAGE_DIRTY), __pgprot(0));
+	return 0;
 }

-- 
2.53.0


