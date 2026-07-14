Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6863BC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D7916B00D8; Tue, 14 Jul 2026 10:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AFD36B00D9; Tue, 14 Jul 2026 10:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DEB6B00DA; Tue, 14 Jul 2026 10:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1256B00D8
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:08:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AEAFC1603C5
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:08:02 +0000 (UTC)
X-FDA: 84987561204.19.1953CE9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id E814040012
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:08:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="EkfHX0/w";
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784038081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PgBLbpLiEYzDjQhJ7FzzEMp+Q8osAIwanXh8jn8DfPQ=;
	b=8UnA+VyA241JoqS3VzLScioEgIj0J0UJrPtykap/tcLiPTeOBoypWFJ9GY5vI8r0QlaoRO
	dJWvyEx+edGc+TQq0DFhTIJfD2SEtvz6ifmUb7aBUOwL3YHWz9aHVd9rGybxvY37HcuQmo
	Ky3tNiJtYqMykXWJuegyiTXMNqCJfuc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="EkfHX0/w";
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784038081;
	b=ljMftp3x5c3EO7w3Ga61t4smfr5MxFphBQr8COEC6E7cf9aJR3k3sH9NfMHpyiIUDm/bDw
	M6v8JprCKa9DdOHGMhJ7MNk6VfIiuAzF7LqNaTg+VJVDg+gZbd3meG2FxFLUbxJlmyVfUW
	osKAoqQNfJW2eHpvJ5Q5dWuCLd2qy9U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E488C1E2F;
	Tue, 14 Jul 2026 07:07:55 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB5033F7B4;
	Tue, 14 Jul 2026 07:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784038080; bh=DQUlXrijxnSdwAI1lj2qunwwpXAiVnOlOXfc6mAyMUQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=EkfHX0/wndT2DrIlt77R9MduZMLLVHV6MiJ4gGI5CEH0EicTnVS43outHXqKb+9XR
	 AJo1EcRXTyEDah4neKxKZTW1aJvelDeHIKrOeiwCxZJanpWn/hzIrUIMMzTmeF4J8v
	 WK5pqK4bemQaUXT1hIibNUiLONKFHv36szPAaSA8=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:04:11 +0100
Subject: [PATCH 22/22] riscv: mm: drop ctor/dtor calls for kernel page
 tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-22-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=5346;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=DQUlXrijxnSdwAI1lj2qunwwpXAiVnOlOXfc6mAyMUQ=;
 b=SSTFSwZEfFo/6gx/poI9v6VwC/hohk7MtYN3kR3x0tI9+lk1TLQ5HYY8/tkfxij+JZ0fxXtY7
 dmntRxFz1BYAc9h9Vd7P6X3RSa/wxA0dmIO24BbUkIFbso++KHmSKGI
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E814040012
X-Stat-Signature: k4sm89pagymm4zp583c94h6jaafqcn95
X-HE-Tag: 1784038080-499946
X-HE-Meta: U2FsdGVkX1/ZVMz8y6vw+RjeJbO/1utde+JLdX3V1Bmw9NsLeJvUZWIL7P6uMZQWQRTWJGC2HtlqWVzChDE6h3C25K/TeNlD4NUiN7n4bsaIK3FUjciSFvSbLT7ugol8LBwgsdOw1S9LdkhYWw/3SbfCbK2BPq63uMfXcJ5ExZMaUqv122KkNgRP9qnNVoBideJE3b1gaDGMPhqUdVmLytrZioZORs00ir1JcgHVfeyFsNt8/TSJ5lraR9j/PHaiRwWZb2mANdL1EZ0CKXdbfOmh326SEvb/2urUsx35g673J5PW5g4ymG1lHDmemjso9/bcyMA12eQGMDAJjBudd87dr5bE2P8tK6r+CBLvA3j4++V96tPB6ZdNy558C7luS8fe2k47JiTjK/wMtO5+ozHZ5IXWiy+xlYX1cCHkbxEtgMVOxpyuRm2P61bTkMNBs5lQamNdtwrMW+Tj1d6W+rpi/9LJzTPsZPPBf93PkZCet9BqqxtznFyHTXLG0mUIMNn5xLw4aX3/I0s5ebF3o2ZdyDLlUsagDGou6nqWJfLsYICPHYCwX8Aa1jw4q0hhEWD+stGX4HNckiZtTjvdGJELEOPPH/F4x//4Xmy1Yk8QB2HQz28qZ6yXjBCQxV4kyGSsv2Axj0Hs7AGvsKNRqIPjtv4+tXruifiZyN5mqCeilsDDH9bZW12ZumUk2WQYFI6n/9OVseKFp9u6hLIVmTchM+TaaVInnNtTamIc5IdKGK01c/1D++quxUzMGEMQXtmlCXvRP/tYb9YnvCyyQa3VxcDdLpeoQsPaR6RJ6TyB5Z07J4IqtTWCWQjG7W9I0hIrTCn5tmBXZ621VaGrqDM2kMbPUS0q5qJV51DbkziI4XyF2BqS2L7x1ICb0jpq/k823V+0l469RGH2I+8YKPkwwX6mndwpl2jSm6owgH+QNJYPWDM4HZq71lv5kNr/SJ+iXZm8KA6zeCV4NdH
 k0+dhO5A
 Sh+7K/DH0uG7AVwSyNiR0Ej78SZbAeZ4YZs8B3Zbbm0zd6lwc/APVH4zEumJH+PNVEergdHyeJlOnfa6WBBJelu/+nboVoQ5wCDqOLLC5PX7qRpJsk4z4/xcWd29enPUA1XW99d+2hr2WzozEwUbqIlOShLarNwD3EuK1ThrlVdosnM60OztoAAhTWdXj9+jL72uSiDsDkeY4AC1101Om0vdL9HBR4nFpP6XCSsfKDTVSt4PouH0fGc4AfrF0BchozIdIDUs8TehOD4gLJmLw9/+kvFFe4xWzGYrF2B6cCAH7+aUPlsfOFzelQOKWh3HY1Rv2ejI6bgwbcUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks to recent changes:

* pagetable_*_ctor() and pagetable_dtor() do nothing for kernel page
  tables.

* efi_mm is also treated like a kernel mm by the page table logic,
  including ctors.

We can therefore drop the calls to ctors when allocating special
kernel page tables in mmu.c, as well as the dtor call when freeing
hotplug page tables.

The alloc_*_late() helpers are all identical after removing the ctor
calls, so replace them with alloc_pgtable_late().

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/riscv/mm/init.c | 63 ++++++++++++----------------------------------------
 1 file changed, 14 insertions(+), 49 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 5b1b3c88b4d1..e823662be256 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -382,6 +382,14 @@ void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot)
 	local_flush_tlb_page(addr);
 }
 
+static phys_addr_t __meminit alloc_pgtable_late(uintptr_t va)
+{
+	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+
+	BUG_ON(!ptdesc);
+	return __pa(ptdesc_address(ptdesc));
+}
+
 static inline pte_t *__init get_pte_virt_early(phys_addr_t pa)
 {
 	return (pte_t *)((uintptr_t)pa);
@@ -412,19 +420,6 @@ static inline phys_addr_t __init alloc_pte_fixmap(uintptr_t va)
 	return memblock_phys_alloc(PAGE_SIZE, PAGE_SIZE);
 }
 
-static phys_addr_t __meminit alloc_pte_late(uintptr_t va)
-{
-	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL, 0);
-
-	/*
-	 * We do not know which mm the PTE page is associated to at this point.
-	 * Passing NULL to the ctor is the safe option, though it may result
-	 * in unnecessary work (e.g. initialising the ptlock for init_mm).
-	 */
-	BUG_ON(!ptdesc || !pagetable_pte_ctor(NULL, ptdesc));
-	return __pa((pte_t *)ptdesc_address(ptdesc));
-}
-
 static void __meminit create_pte_mapping(pte_t *ptep, uintptr_t va, phys_addr_t pa, phys_addr_t sz,
 					 pgprot_t prot)
 {
@@ -479,15 +474,6 @@ static phys_addr_t __init alloc_pmd_fixmap(uintptr_t va)
 	return memblock_phys_alloc(PAGE_SIZE, PAGE_SIZE);
 }
 
-static phys_addr_t __meminit alloc_pmd_late(uintptr_t va)
-{
-	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL, 0);
-
-	/* See comment in alloc_pte_late() regarding NULL passed the ctor */
-	BUG_ON(!ptdesc || !pagetable_pmd_ctor(NULL, ptdesc));
-	return __pa((pmd_t *)ptdesc_address(ptdesc));
-}
-
 static void __meminit create_pmd_mapping(pmd_t *pmdp,
 					 uintptr_t va, phys_addr_t pa,
 					 phys_addr_t sz, pgprot_t prot)
@@ -544,15 +530,6 @@ static phys_addr_t __init alloc_pud_fixmap(uintptr_t va)
 	return memblock_phys_alloc(PAGE_SIZE, PAGE_SIZE);
 }
 
-static phys_addr_t __meminit alloc_pud_late(uintptr_t va)
-{
-	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL, 0);
-
-	BUG_ON(!ptdesc);
-	pagetable_pud_ctor(ptdesc);
-	return __pa((pud_t *)ptdesc_address(ptdesc));
-}
-
 static p4d_t *__init get_p4d_virt_early(phys_addr_t pa)
 {
 	return (p4d_t *)((uintptr_t)pa);
@@ -582,15 +559,6 @@ static phys_addr_t __init alloc_p4d_fixmap(uintptr_t va)
 	return memblock_phys_alloc(PAGE_SIZE, PAGE_SIZE);
 }
 
-static phys_addr_t __meminit alloc_p4d_late(uintptr_t va)
-{
-	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL, 0);
-
-	BUG_ON(!ptdesc);
-	pagetable_p4d_ctor(ptdesc);
-	return __pa((p4d_t *)ptdesc_address(ptdesc));
-}
-
 static void __meminit create_pud_mapping(pud_t *pudp, uintptr_t va, phys_addr_t pa, phys_addr_t sz,
 					 pgprot_t prot)
 {
@@ -1003,14 +971,14 @@ static void __init pt_ops_set_fixmap(void)
  */
 static void __init pt_ops_set_late(void)
 {
-	pt_ops.alloc_pte = alloc_pte_late;
+	pt_ops.alloc_pte = alloc_pgtable_late;
 	pt_ops.get_pte_virt = get_pte_virt_late;
 #ifndef __PAGETABLE_PMD_FOLDED
-	pt_ops.alloc_pmd = alloc_pmd_late;
+	pt_ops.alloc_pmd = alloc_pgtable_late;
 	pt_ops.get_pmd_virt = get_pmd_virt_late;
-	pt_ops.alloc_pud = alloc_pud_late;
+	pt_ops.alloc_pud = alloc_pgtable_late;
 	pt_ops.get_pud_virt = get_pud_virt_late;
-	pt_ops.alloc_p4d = alloc_p4d_late;
+	pt_ops.alloc_p4d = alloc_pgtable_late;
 	pt_ops.get_p4d_virt = get_p4d_virt_late;
 #endif
 }
@@ -1488,7 +1456,6 @@ static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
 			return;
 	}
 
-	pagetable_dtor(ptdesc);
 	if (PageReserved(page))
 		free_reserved_page(page);
 	else
@@ -1496,7 +1463,7 @@ static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
 	pmd_clear(pmd);
 }
 
-static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud, bool is_vmemmap)
+static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud)
 {
 	struct page *page = pud_page(*pud);
 	struct ptdesc *ptdesc = page_ptdesc(page);
@@ -1509,8 +1476,6 @@ static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud, bool is_vmemm
 			return;
 	}
 
-	if (!is_vmemmap)
-		pagetable_dtor(ptdesc);
 	if (PageReserved(page))
 		free_reserved_page(page);
 	else
@@ -1634,7 +1599,7 @@ static void __meminit remove_pud_mapping(pud_t *pud_base, unsigned long addr, un
 		remove_pmd_mapping(pmd_base, addr, next, is_vmemmap, altmap);
 
 		if (pgtable_l4_enabled)
-			free_pmd_table(pmd_base, pudp, is_vmemmap);
+			free_pmd_table(pmd_base, pudp);
 	}
 }
 

-- 
2.51.2


