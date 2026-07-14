Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 087AEC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10ACD6B00D5; Tue, 14 Jul 2026 10:07:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2C06B00D6; Tue, 14 Jul 2026 10:07:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A626B00D7; Tue, 14 Jul 2026 10:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D07846B00D5
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:07:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 64924403EB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:07:47 +0000 (UTC)
X-FDA: 84987560574.10.928E6AD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 79B9DC000D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:07:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dz+aSvQ4;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784038065;
	b=PClqZBbDsmAPYUThdV7i3bbBtVZgzpLk1rV9mUUqdG4l/U7fL5A58zgNYV6gLiCG2R+0OT
	rs/c3UesgGgyUstKUdOsHIudn05RjGEs9EwLAl0A5Dj6Eh08GaanfmLqYDPyueQM+gIMY1
	FbQE2ezGKG/QhiCHdPLz+t+e439hVDs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dz+aSvQ4;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784038065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QijdDTjMkAjvjZJxIvdsoZwXayQlCL9Ojr4kYYybSUU=;
	b=UVNJoK1jJaW8OKIZY+DPt9mxPL26oaapLhI48fq5zRhlJaM7SlhJrLXl52vKJznGvymDmo
	ztW/kmjZTP1G6VBn2tJFNlr45YBcebsMmAujm3epQ6JdvMU03xeY0ZmOJFsf+rMl9EZpgS
	Afvqz/JpCGdFgg3Otca5D+ZW9GnVWPY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76CF11D34;
	Tue, 14 Jul 2026 07:07:40 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C05B3F7B4;
	Tue, 14 Jul 2026 07:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784038064; bh=eNgm2wK/htg6bJpbLSoGRu/x8u/9VaQ86dX9GXxA/zM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dz+aSvQ4IIcP5/jB1TnLsl+9MnbX6Bwx+0Lqjr8x5S3Rd06ehciwldTY2ZsmAHOfx
	 2p1hk4Zezbl29IQIBcUEBscEe0HFjjITDWWe4jQ+rPyb/sbhmBJo91kiol4raAMUFc
	 aSB5BRahC2yYplDRD719ZRvsn/Bk4aIHLvc9u2go=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:04:09 +0100
Subject: [PATCH 20/22] arm64: mm: drop ctor/dtor calls for kernel page
 tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-20-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=9717;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=eNgm2wK/htg6bJpbLSoGRu/x8u/9VaQ86dX9GXxA/zM=;
 b=5eP0RdQOzgReDDpM+wlyav4lmQqmzUAUIXx1RW3HbowrbhPLxRPz5GfX/Bq9XXmijz2/LPmIY
 buMwtuXHOIlAyPhXdjAIkFQlvZ539XeVYb71j+kHGgtFElURkk2a/ok
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79B9DC000D
X-Stat-Signature: i1za5h68kwwty1e961wadoctpgwmk8jp
X-HE-Tag: 1784038065-394402
X-HE-Meta: U2FsdGVkX1+w9yLBCIH4XXLool/qx9J77QGkNvI7tDNYhXqvyzfy5tXmBXGR4rUhhbL1iDv1LtLAyoyTml031F1K5gOCDk+MFdwThGthZoK4/+9gPoCBkky1XVHJAzzLgZUSFH80KXTD077ET5Rc+hgMmGg8otku6RaOYiDGxKOZ+jk6y2fqWxfzru8CFiJLp0tDynRqQJzJ4GcHBdVDLXsEsHU1o04Goe4yZ6bvlxU8M66LvtccofVPuGQ0C8SdGZz2pWV11cIRU99L8g992TQRxwAGLWC9QhELnjS4CmpSclhFgrCaxWX9ljTTTvHX0zZMgDVz6Arp8L077xxP9H2xuTc2WhZr9TvOeAiy0a+otlerjpN+FgYWJexkjm2mKe7nEcmQA7xw9Wpd5+SCKeb1BqK1H+KarN9hDzQr0+t1T2Q+7FM4l5XyFZUDGF3XrKDy4kCJwJJZ1yra6UbW7u9RT3CCDw9Ijme8xE0gbYRM36zIrMGGwlDtYoT/3DzBOpp1aP2i2gEMFKjWQ5aEjeJCJMJUgQf/cDY43p5+RhUFrUuZqZsSzgekAqcaDfAjpwk5WRMwzFUMfN5gfUH1rNDf/GUMkyZ95joo1VYHs1EUVmTcuxpQ7tMet76gYS8M8Lq7PNmJHYdPNsxOUxKpNN781bisNQg0U7te4/L+sKEAwo1RyXmNO1cypKGGH/O+Xrzp0rnF5cGoZDeVFbLz9TdpVc7VyTbtvQggIDAkaJg78plRkSWmm56uvwbYJYtRqp7iaQlysEHsX5cCQ3GO/j3ytgMX7ULEsdVE1mIy8tU/ej1FU9blXNyi3g8cNlh96lXUtA7zoPUliEwLSYHO18uft55oBlUGUgAn2BVBwdo1Apk7qaDIou0dUmI+NLT+TQbbs2jnRfVNFRsNqJhG9UFvb6zOSJAXmrZjW8GwF2NVgWerAi/SzUL9wiF0EP+JYfKEMwe1ttCv0S/T2vz
 kKoh/Fcj
 NEJG5B3NriX5vSUYL3OJEsRF/yA/5hQAA3qPPOQRQ3WRR0y1FRPe06WCFHYCFGepne+QAnTIxqc29B62W1wTrIjLvspndWVE0v1MNRTjZ+Cxz1sPWwBaPnfqDxDynEnG8OoSFfelh7Zjvbhxcmt9u1UgjRvGLk2v84YDMeK1WM3qy6xjYbApKihgMaPKL7MWaJbmNJ/wWTjjZDp525OiG09fG3bWKAdoTtqAdTtsqRQYFNwJnPG4yeRId2yVzRF+U4AH26TN1PyJht0+yUuT4dz0NgAnakgHuX1M9DuGL1QvpWLTbgahQgY6m/X3gkU4nJGZU6dW0nigB+J8=
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

Since we no longer need the owning mm or page table level when
allocating them, we can also remove both the init_mm/special_mm
wrappers and the pgtable_level callback argument.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/mm/mmu.c | 82 +++++++++++++++--------------------------------------
 1 file changed, 23 insertions(+), 59 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index f723bcf68174..f1400c6f68ba 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -103,7 +103,7 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 }
 EXPORT_SYMBOL(phys_mem_access_prot);
 
-static phys_addr_t __init early_pgtable_alloc(enum pgtable_level pgtable_level)
+static phys_addr_t __init early_pgtable_alloc(void)
 {
 	phys_addr_t phys;
 
@@ -195,7 +195,7 @@ static bool pte_range_has_valid_noncont(pte_t *ptep)
 static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 			       unsigned long end, phys_addr_t phys,
 			       pgprot_t prot,
-			       phys_addr_t (*pgtable_alloc)(enum pgtable_level),
+			       phys_addr_t (*pgtable_alloc)(void),
 			       int flags)
 {
 	unsigned long next;
@@ -210,7 +210,7 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 		if (flags & NO_EXEC_MAPPINGS)
 			pmdval |= PMD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
-		pte_phys = pgtable_alloc(PGTABLE_LEVEL_PTE);
+		pte_phys = pgtable_alloc();
 		if (pte_phys == INVALID_PHYS_ADDR)
 			return -ENOMEM;
 		ptep = pte_set_fixmap(pte_phys);
@@ -251,7 +251,7 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 
 static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 		    phys_addr_t phys, pgprot_t prot,
-		    phys_addr_t (*pgtable_alloc)(enum pgtable_level), int flags)
+		    phys_addr_t (*pgtable_alloc)(void), int flags)
 {
 	unsigned long next;
 
@@ -303,7 +303,7 @@ static bool pmd_range_has_valid_noncont(pmd_t *pmdp)
 static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 			       unsigned long end, phys_addr_t phys,
 			       pgprot_t prot,
-			       phys_addr_t (*pgtable_alloc)(enum pgtable_level),
+			       phys_addr_t (*pgtable_alloc)(void),
 			       int flags)
 {
 	int ret;
@@ -322,7 +322,7 @@ static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 		if (flags & NO_EXEC_MAPPINGS)
 			pudval |= PUD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
-		pmd_phys = pgtable_alloc(PGTABLE_LEVEL_PMD);
+		pmd_phys = pgtable_alloc();
 		if (pmd_phys == INVALID_PHYS_ADDR)
 			return -ENOMEM;
 		pmdp = pmd_set_fixmap(pmd_phys);
@@ -361,7 +361,7 @@ static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 
 static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 			  phys_addr_t phys, pgprot_t prot,
-			  phys_addr_t (*pgtable_alloc)(enum pgtable_level),
+			  phys_addr_t (*pgtable_alloc)(void),
 			  int flags)
 {
 	int ret = 0;
@@ -376,7 +376,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 		if (flags & NO_EXEC_MAPPINGS)
 			p4dval |= P4D_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
-		pud_phys = pgtable_alloc(PGTABLE_LEVEL_PUD);
+		pud_phys = pgtable_alloc();
 		if (pud_phys == INVALID_PHYS_ADDR)
 			return -ENOMEM;
 		pudp = pud_set_fixmap(pud_phys);
@@ -428,7 +428,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 
 static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 			  phys_addr_t phys, pgprot_t prot,
-			  phys_addr_t (*pgtable_alloc)(enum pgtable_level),
+			  phys_addr_t (*pgtable_alloc)(void),
 			  int flags)
 {
 	int ret;
@@ -443,7 +443,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 		if (flags & NO_EXEC_MAPPINGS)
 			pgdval |= PGD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
-		p4d_phys = pgtable_alloc(PGTABLE_LEVEL_P4D);
+		p4d_phys = pgtable_alloc();
 		if (p4d_phys == INVALID_PHYS_ADDR)
 			return -ENOMEM;
 		p4dp = p4d_set_fixmap(p4d_phys);
@@ -480,7 +480,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 static int __create_pgd_mapping_locked(pgd_t *pgdir, phys_addr_t phys,
 				       unsigned long virt, phys_addr_t size,
 				       pgprot_t prot,
-				       phys_addr_t (*pgtable_alloc)(enum pgtable_level),
+				       phys_addr_t (*pgtable_alloc)(void),
 				       int flags)
 {
 	int ret;
@@ -513,7 +513,7 @@ static int __create_pgd_mapping_locked(pgd_t *pgdir, phys_addr_t phys,
 static int __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 				unsigned long virt, phys_addr_t size,
 				pgprot_t prot,
-				phys_addr_t (*pgtable_alloc)(enum pgtable_level),
+				phys_addr_t (*pgtable_alloc)(void),
 				int flags)
 {
 	int ret;
@@ -529,7 +529,7 @@ static int __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 static void early_create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 				     unsigned long virt, phys_addr_t size,
 				     pgprot_t prot,
-				     phys_addr_t (*pgtable_alloc)(enum pgtable_level),
+				     phys_addr_t (*pgtable_alloc)(void),
 				     int flags)
 {
 	int ret;
@@ -540,55 +540,20 @@ static void early_create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 		panic("Failed to create page tables\n");
 }
 
-static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm, gfp_t gfp,
-				       enum pgtable_level pgtable_level)
+static phys_addr_t pgd_pgtable_alloc_gfp(gfp_t gfp)
 {
 	/* Page is zeroed by init_clear_pgtable() so don't duplicate effort. */
 	struct ptdesc *ptdesc = pagetable_alloc(gfp & ~__GFP_ZERO, 0);
-	phys_addr_t pa;
 
 	if (!ptdesc)
 		return INVALID_PHYS_ADDR;
 
-	pa = page_to_phys(ptdesc_page(ptdesc));
-
-	switch (pgtable_level) {
-	case PGTABLE_LEVEL_PTE:
-		BUG_ON(!pagetable_pte_ctor(mm, ptdesc));
-		break;
-	case PGTABLE_LEVEL_PMD:
-		BUG_ON(!pagetable_pmd_ctor(mm, ptdesc));
-		break;
-	case PGTABLE_LEVEL_PUD:
-		pagetable_pud_ctor(ptdesc);
-		break;
-	case PGTABLE_LEVEL_P4D:
-		pagetable_p4d_ctor(ptdesc);
-		break;
-	case PGTABLE_LEVEL_PGD:
-		VM_WARN_ON(1);
-		break;
-	}
-
-	return pa;
-}
-
-static phys_addr_t
-pgd_pgtable_alloc_init_mm_gfp(enum pgtable_level pgtable_level, gfp_t gfp)
-{
-	return __pgd_pgtable_alloc(&init_mm, gfp, pgtable_level);
-}
-
-static phys_addr_t __maybe_unused
-pgd_pgtable_alloc_init_mm(enum pgtable_level pgtable_level)
-{
-	return pgd_pgtable_alloc_init_mm_gfp(pgtable_level, GFP_PGTABLE_KERNEL);
+	return page_to_phys(ptdesc_page(ptdesc));
 }
 
-static phys_addr_t
-pgd_pgtable_alloc_special_mm(enum pgtable_level pgtable_level)
+static phys_addr_t pgd_pgtable_alloc(void)
 {
-	return  __pgd_pgtable_alloc(NULL, GFP_PGTABLE_KERNEL, pgtable_level);
+	return pgd_pgtable_alloc_gfp(GFP_PGTABLE_KERNEL);
 }
 
 static void split_contpte(pte_t *ptep)
@@ -609,7 +574,7 @@ static int split_pmd(pmd_t *pmdp, pmd_t pmd, gfp_t gfp, bool to_cont)
 	pte_t *ptep;
 	int i;
 
-	pte_phys = pgd_pgtable_alloc_init_mm_gfp(PGTABLE_LEVEL_PTE, gfp);
+	pte_phys = pgd_pgtable_alloc_gfp(gfp);
 	if (pte_phys == INVALID_PHYS_ADDR)
 		return -ENOMEM;
 	ptep = (pte_t *)phys_to_virt(pte_phys);
@@ -656,7 +621,7 @@ static int split_pud(pud_t *pudp, pud_t pud, gfp_t gfp, bool to_cont)
 	pmd_t *pmdp;
 	int i;
 
-	pmd_phys = pgd_pgtable_alloc_init_mm_gfp(PGTABLE_LEVEL_PMD, gfp);
+	pmd_phys = pgd_pgtable_alloc_gfp(gfp);
 	if (pmd_phys == INVALID_PHYS_ADDR)
 		return -ENOMEM;
 	pmdp = (pmd_t *)phys_to_virt(pmd_phys);
@@ -1035,7 +1000,7 @@ void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	early_create_pgd_mapping(mm->pgd, phys, virt, size, prot,
-				 pgd_pgtable_alloc_special_mm, flags);
+				 pgd_pgtable_alloc, flags);
 }
 
 static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
@@ -1249,7 +1214,7 @@ static void __init declare_vma(struct vm_struct *vma,
 
 static phys_addr_t kpti_ng_temp_alloc __initdata;
 
-static phys_addr_t __init kpti_ng_pgd_alloc(enum pgtable_level pgtable_level)
+static phys_addr_t __init kpti_ng_pgd_alloc(void)
 {
 	kpti_ng_temp_alloc -= PAGE_SIZE;
 	return kpti_ng_temp_alloc;
@@ -1357,7 +1322,7 @@ static int __init map_entry_trampoline(void)
 	memset(tramp_pg_dir, 0, PGD_SIZE);
 	early_create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS,
 				 entry_tramp_text_size(), prot,
-				 pgd_pgtable_alloc_init_mm, NO_BLOCK_MAPPINGS);
+				 pgd_pgtable_alloc, NO_BLOCK_MAPPINGS);
 
 	/* Map both the text and data into the kernel page table */
 	for (i = 0; i < DIV_ROUND_UP(entry_tramp_text_size(), PAGE_SIZE); i++)
@@ -1445,7 +1410,6 @@ static void free_hotplug_page_range(struct page *page, size_t size,
 
 static void free_hotplug_pgtable_page(struct page *page)
 {
-	pagetable_dtor(page_ptdesc(page));
 	free_hotplug_page_range(page, PAGE_SIZE, NULL);
 }
 
@@ -1958,7 +1922,7 @@ int arch_add_memory(int nid, u64 start, u64 size,
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	ret = __create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
-				   size, params->pgprot, pgd_pgtable_alloc_init_mm,
+				   size, params->pgprot, pgd_pgtable_alloc,
 				   flags);
 	if (ret)
 		goto err;

-- 
2.51.2


