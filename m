Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07C22C4450C
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 042D56B00B7; Tue, 14 Jul 2026 10:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A916B00B9; Tue, 14 Jul 2026 10:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73056B00BA; Tue, 14 Jul 2026 10:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C17506B00B7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:05:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57B4A1A0408
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:05:51 +0000 (UTC)
X-FDA: 84987555702.19.00DE5D2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 87215140011
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:05:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J3x7thz6;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2FKZ3XNFEytxwIypQEaTGz4aBKlj8CjSZVpVOVmWyTY=;
	b=MlJvRXYCUgAg7OJVC0sT+IDe+wqNN1Ox9q+uhzdurQBfxMa1AAwH8FY1KCs9CraPF0dQJN
	5nYgfLRAlJUx46mWIDqmPUbGtAq/O8aCr9kokjYNFkAq/KpwzBLNtzXn9Dlnzr+rZZC2xe
	Ygq73fuduID7BeO/PXC1h3CWbX0qY2A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J3x7thz6;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037949;
	b=LAoH4TIs7ET4ZgggwjwJVhYWmHeBR18GljXuUf6zlK7qdKbdNYnVc3DhOoTEfbZsBfMqin
	ZIFTwtp4RiysB91R+id6wPiUhNyRTbiIy/Sq78T4NAW48NYLAkp19vhAbsggLXvOddpNxi
	ktFG1ekSg8YPKoXTqPR//NNjOvOA+Qw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 887551516;
	Tue, 14 Jul 2026 07:05:44 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 656AE3F7B4;
	Tue, 14 Jul 2026 07:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037948; bh=81hPHNKy6+kTl2+35lvgI+YoSAV+lxYrdESi+BeMQ9o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=J3x7thz6DDIFd0T672gJo0MMnvLqrsR4ffqXjRuw6y/FJl0Sv4brx2AvsrenCXyub
	 hNeHOpm1dGW6Ol7r4E98ejCd2H2xHFjmSYxf0TFC/EKx6I3nhvG3tmBb0uG3LlhJwX
	 CsqR3L3Byysgiom9B50gJLtZIUOotRrLJXVN3jH4=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:54 +0100
Subject: [PATCH 05/22] arm64: mm: use mm_is_kernel() for kernel mm checks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-5-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=3632;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=81hPHNKy6+kTl2+35lvgI+YoSAV+lxYrdESi+BeMQ9o=;
 b=x1sfUWl36JCNbyA4SXGcEWPKjJ2W9GBoHx+AU6SimhVKBjyOGOssy6XRkSm07LMGEZVJbSnP4
 NXfCyMO7l0VD8qsDQe1L21uTIP7w+5/eot3+ExiUATLVcbhzhw7kG6L
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 87215140011
X-Stat-Signature: feg69nwomz867of7faurxb941g17ez4e
X-HE-Tag: 1784037949-608438
X-HE-Meta: U2FsdGVkX18bVK9xKRPJpWBcYG4wgCBSskVIZFYETnlqohwGzpdJpF22+9/+rC56vTOhTruNhSbPG/fl8yu6aeGCCcu1acTuYSBqbKW4Z144pjrqPddHWSf1Hyx+w1K7AxKy5IJp+Tu+twk5nVPVTanDM/vBwTOCjrZHcKoC+GZBWPZWrem/2B0QUpHmc9SvJIVVZNab35MWBhkDraa0AVShUdBCpo83xGUZXEBpdWar/5K6UGchJBtB5WXoiFefhLuDAfauOMj5SEVbVeV70+jeSleLFkaEOzukBExFJibbnwZJRCeWE79iLJVn8Ikmbqc62L5rVli+lPMumcLqj5TnK9tgSZb3KjxQsUFsh3a5645So9uXb6HiC9vibZNqvxwD1Z/lv/LvflvdmpNWb62XIDtAF1A1Suw70+1bCHyTa98k3HB1GptpeJ869KEEtCd6DcgySZt91i0TovGlUMDXcpaJYHOMIfMkjzpQFwBcdXTirCLvBgcYNlbxbVqATc5lD6J+zFkTcLUPbys4f9iuAmEel0PL50NIBjy1oEKH8zTvuO3s5Eupxzdf2MKQiGbwsMh/TfIqGt/Uum683lfRbOPwz9RfkV28olXV2YpXu6eGdkv7fMnhkjIuZa5NCpb8Feaie9g+qMiuPAmVfUzLqUDclf45Z8bTtRU0H8a/YhCHdsaHSmjrclV1daIwU91hVU9ZRx5ivM+YP3HoSTkFMq06t9rWfSh7w3Rw4f7+2s37TKMJZ1AQoglRowWY7N3akAyE5iWewX88cbicIqkffSg6qPqYQZ2AXKx4RK/pF09GCLDHfxqUFfCxkEs1+L0h8cBCK5rZG/AKvrEPlChIthu5UxX4UbjFybszonp++b3sKwLmSQdgUa4ISwikv7dDnDnUwlKTyq2tErui3zCHqRjU2uO11xksdxIb4qIkflqkkG/lDyrXcnPPkdiMq/IRtNLPBmbhav3CQi9
 qgDxzO0f
 p4j4rDvqDe755htBCnyljgYNcg7mCTveRS80DczQitgvwJvjC9XFwAVIQtJMCmi11LN7b+QrSSF2mrvXwySgZebNzhuGnE40U0FAM97HETG2jlYL0+jiiYiqrg4xNzoxCbS6tDZG5B5rFxqZi4ycez3f8Im2EY3e9BU6IXHZIEmjyvwrjKCEelqip0a3hFaHMK0c46LwW1ebi11dxR4pGfiB7Qn/Evh9V7WXLaBL+peoTbK4o7APtFHEFoFibgIU7LTGzsA32GkbdU3LpMZ9JpTswVxzso4+RXF05jkjE4SzkXvmAHv4wdu3Ac4W2ZGdnxxoHHBirGhsqXkcEaXWXeg8V+VNUE0PC8uKglVBgI5zPLdOT34nre7YrnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new MMF_KERNEL flag identifies kernel-owned mm's. Checking the
flag with mm_is_kernel() is preferred over comparing directly
against &init_mm.

In some cases, such as show_pte(), the handling is truly specific to
init_mm and we leave those comparisons with &init_mm unchanged.

No functional change, as only init_mm has MMF_KERNEL set for now.

mm_is_user() will eventually be replaced with !mm_is_kernel(), once
efi_mm is also marked with MMF_KERNEL.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgalloc.h | 10 +++++-----
 arch/arm64/mm/contpte.c          |  2 +-
 arch/arm64/mm/hugetlbpage.c      |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index 1b4509d3382c..33db4fa3c619 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -30,7 +30,7 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmdp)
 {
 	pudval_t pudval = PUD_TYPE_TABLE | PUD_TABLE_AF;
 
-	pudval |= (mm == &init_mm) ? PUD_TABLE_UXN : PUD_TABLE_PXN;
+	pudval |= mm_is_kernel(mm) ? PUD_TABLE_UXN : PUD_TABLE_PXN;
 	__pud_populate(pudp, __pa(pmdp), pudval);
 }
 #else
@@ -52,7 +52,7 @@ static inline void p4d_populate(struct mm_struct *mm, p4d_t *p4dp, pud_t *pudp)
 {
 	p4dval_t p4dval = P4D_TYPE_TABLE | P4D_TABLE_AF;
 
-	p4dval |= (mm == &init_mm) ? P4D_TABLE_UXN : P4D_TABLE_PXN;
+	p4dval |= mm_is_kernel(mm) ? P4D_TABLE_UXN : P4D_TABLE_PXN;
 	__p4d_populate(p4dp, __pa(pudp), p4dval);
 }
 
@@ -81,7 +81,7 @@ static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgdp, p4d_t *p4dp)
 {
 	pgdval_t pgdval = PGD_TYPE_TABLE | PGD_TABLE_AF;
 
-	pgdval |= (mm == &init_mm) ? PGD_TABLE_UXN : PGD_TABLE_PXN;
+	pgdval |= mm_is_kernel(mm) ? PGD_TABLE_UXN : PGD_TABLE_PXN;
 	__pgd_populate(pgdp, __pa(p4dp), pgdval);
 }
 
@@ -108,7 +108,7 @@ static inline void __pmd_populate(pmd_t *pmdp, phys_addr_t ptep,
 static inline void
 pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmdp, pte_t *ptep)
 {
-	VM_BUG_ON(mm && mm != &init_mm);
+	VM_BUG_ON(mm && !mm_is_kernel(mm));
 	__pmd_populate(pmdp, __pa(ptep),
 		       PMD_TYPE_TABLE | PMD_TABLE_AF | PMD_TABLE_UXN);
 }
@@ -116,7 +116,7 @@ pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmdp, pte_t *ptep)
 static inline void
 pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pgtable_t ptep)
 {
-	VM_BUG_ON(mm == &init_mm);
+	VM_BUG_ON(mm_is_kernel(mm));
 	__pmd_populate(pmdp, page_to_phys(ptep),
 		       PMD_TYPE_TABLE | PMD_TABLE_AF | PMD_TABLE_PXN);
 }
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index 2de12656b4d8..ad5c04cf66ff 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -18,7 +18,7 @@ static inline bool mm_is_user(struct mm_struct *mm)
 	 */
 	if (unlikely(mm_is_efi(mm)))
 		return false;
-	return mm != &init_mm;
+	return !mm_is_kernel(mm);
 }
 
 static inline pte_t *contpte_align_down(pte_t *ptep)
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 25f04d01aabe..4d054fadf51c 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -212,7 +212,7 @@ static void clear_flush(struct mm_struct *mm,
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
 		__ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		flush_tlb_kernel_range(saddr, addr);
 	else
 		__flush_hugetlb_tlb_range(&vma, saddr, addr, pgsize, TLBF_NOWALKCACHE);

-- 
2.51.2


