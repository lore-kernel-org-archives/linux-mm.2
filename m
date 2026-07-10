Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80D2AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 10:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7617D6B008C; Fri, 10 Jul 2026 06:50:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738B86B0092; Fri, 10 Jul 2026 06:50:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676CE6B0095; Fri, 10 Jul 2026 06:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA086B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:50:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4B7C1C3B1A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:50:38 +0000 (UTC)
X-FDA: 84972548556.23.15921CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 13BA81C0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:50:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JmZNNSbH;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783680637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGqyGr0qnRTIfiiGAnTHRi5kH6FwiwHXP6bOvfynGCo=;
	b=0tDcsI9MQs/7OKlWnqMW86fQIifHuUshAkRtRObpJH3ssF9j0m9Nwjecg+1q3C5iv3X1j8
	3Rj3qnEtU262kgSRX1oQZYB0NWZ0lmkztqPOSTPyya+6qX4pPbZYhmZMAWl8ihx73HhioJ
	qTONyrG6d9T1tJxyXyGpDoXAx2ga7pM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JmZNNSbH;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783680637;
	b=ijmqcpzqLa7rlQG9KvquBI/9hXsrRJDSlL/U/KgYJWL29bEUITPjWOBI64J3wXkwA3YZQn
	t4FP6Hh/VNzjGkW+mAr6hU9RZ6tUJ8QZS5GCkTlpyB0sZWxE/CjQAKLYEJV1YQpCu7ogxX
	6qOF8mJMxLCIvcTff0TAtYOOImgMWWE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58BEE43A68;
	Fri, 10 Jul 2026 10:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9211F00A3E;
	Fri, 10 Jul 2026 10:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783680636;
	bh=RGqyGr0qnRTIfiiGAnTHRi5kH6FwiwHXP6bOvfynGCo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JmZNNSbH/uAipSKatNpg4FnEQbUwcHdCZSv701esMqRR3r8BM+UhuuuWLJuEAWjdk
	 72he/8SBrZgAkncvyWiOyZ6S6o2zfQoe6YMJielBWMPC6MJMEaUPq9cq++2oMTzOTh
	 /uBhg20EHpETD8G6t/QE+62EVjU4iG6ocqI4EEfuBgZqc4P+7BiPIkPv4FbmAnmFQZ
	 Uyq6spnfkbpD62VLoOeieQ53HxX1Kfvkadpi1i0Qzt/lRxKTYd5CnS/RlVStiTrZIv
	 Z6T9z+01QAo/tfg46P158UenzJmqlbKD5VozoUGVPFPeq0z3X2qST/X2cz8A99xi6p
	 zsu3tF8GYWpxw==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 11:49:19 +0100
Subject: [PATCH 2/2] Revert "arm64: Enable vmalloc-huge with ptdump"
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-series-vmap-race-fix-v1-2-5b3794c113fe@kernel.org>
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
In-Reply-To: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: David Carlier <devnexen@gmail.com>, Dev Jain <dev.jain@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Lorenzo Stoakes <ljs@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=6588; i=ljs@kernel.org;
 h=from:subject:message-id; bh=KKdm5bAQRJs2wjkGqqkWHkasEM5SGHceCFsCIrr8Hcg=;
 b=kA0DAAoWz53NioHifxQByyZiAGpQzmeg1CaSle+pPvfiKTwM/FWk0TrLLYlVO+z7s1Tq/yiEW
 oh1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmpQzmcACgkQz53NioHifxRtygD8DDHr
 qmflY8u1wL4+uyFP5fvhkVw7x4O8NIfxOS7QtO8BANpixWKzzYzSoiOqNyTQDyQhFPD7JVB4JZk
 rV+AmjL0P
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 13BA81C0002
X-Stat-Signature: 4qkpgnhbwyq33whpytafrx5jdosh1yf7
X-HE-Tag: 1783680636-515025
X-HE-Meta: U2FsdGVkX192Q9lC61/8B7q4OxoXAc4olpOk+QljaWP8Rj4RErkpNaFRXjDHJXqzcu83PmnsTugL3N2d9ldvbVxDbxDEGPGR2TqgpDEEZfOXrN7ZnLTQ6aeq8eVqel19E1lhACS+dwYwy9uNCoSq2fM92wJnipewzFPE7oDCzOtBp2joCE7///5dgPRlwGtfK47MB7EkrrJPi9xxzT47xszvYITTStmigQckb2uvWtCsYR2c7HSrrhpXTYmvp9NL5QNHu6F5WnhJHHbtTAHk7tpZXNMsU6vvvV2uY1XKoHUlNPx3P+wNsnmpbjzQXuNsKHpPqP1KON6oSbzUDW51hbSB6IoeLeJ3PnjXN0vaCPmx9v2ESl6wijB36MPOIDEmdhDFVoVtrxUlW7pykUgbzXSbh0UgSJntRU5DQ5fa2KJtscDmu5QvuWNNtop3G1/7VY4cZfadNE2DwvCgc6a4tE7mFGjUx9SGoQMDhratnRoNprCLgEJY9ioIE8NcGANpUD0FTZrPvSIgqqI/5LhxKi89UzwTN2tWfrqSCEK2cl20nxMEDZwXmFPUCtUfKctiEcT0y6yv7K3pgm4UnmJwvmwGHIHqEh0INju7DhlonQ2WLuJIuJ0d8OOUHyq4orYd8YshkGpznZxC9UEINzkmMWgGGBTH2lwWsUZyH5o23dAbMRvxE3alt17GksGUZBfYnoNT8tT4mfPEsPkvPBjYFSbFsGPBx5qwt8RUjc+zw1LgC7pRwTMiCXRL0lEdXF897SyHjDnGOX4z4zAaOm4MTofwwnjklOH8EFjdC67NuWhPdbVPnmeSNUIWRnGY4Tj5ovji8R8PJTQSKu1zfOxcQmRee3r993TRqPmINRGotOuQSjEo5sQ9ZzdPjpw7hvxGzsyo66PnyBKIlaHqjsAW0jzEJbOhcUyWjGfML6AVxmpTyHvW1CfYWDAIEoVFwTBuDUyTSofNWhZnlDcQqk2
 b8b/FkAM
 fO+lqQOBtNt8TuvFRXki9fWC95IudC/kx//xgUARoJzt7o8EsNNWRIJ4VXA4OI//0HljqxpNtdUoOT16YHLYVV+8Y/F2P0sQxjIgWtTd7UuqidnuoKNUMUwj6DoDEQnIykXaZg33cX5U8iGgljgYlsfmap67RVU8aaQ/09vlQ/D0cuy6heuc1ZjWk2G+4o7OvspfZidZjUJ6qgNsGhXj5VCeLXElOfsbyb9Rql+SbfL0xTKdX1oHGmqvCBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This partially reverts commit fa93b45fd397 ("arm64: Enable vmalloc-huge
with ptdump"), retaining vmalloc-huge support but eliminating the now
redundant mitigation against a race between huge vmap page table freeing
and ptdump, as this issue has now been fixed at core.

We also simultaneously remove the arm64 ifdeffery when acquiring the mmap
read lock upon vmap huge page table promotion as it is no longer required.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 arch/arm64/include/asm/ptdump.h |  2 --
 arch/arm64/mm/mmu.c             | 43 ++++-------------------------------------
 arch/arm64/mm/ptdump.c          | 11 ++---------
 mm/vmalloc.c                    | 15 +++-----------
 4 files changed, 9 insertions(+), 62 deletions(-)

diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index 5b374a6ab34a..50a195eda8ed 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -7,8 +7,6 @@
 
 #include <linux/ptdump.h>
 
-DECLARE_STATIC_KEY_FALSE(arm64_ptdump_lock_key);
-
 #ifdef CONFIG_PTDUMP
 
 #include <linux/mm_types.h>
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index f2be501468ce..f723bcf68174 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -49,8 +49,6 @@
 #define NO_CONT_MAPPINGS	BIT(1)
 #define NO_EXEC_MAPPINGS	BIT(2)	/* assumes FEAT_HPDS is not used */
 
-DEFINE_STATIC_KEY_FALSE(arm64_ptdump_lock_key);
-
 u64 kimage_voffset __ro_after_init;
 EXPORT_SYMBOL(kimage_voffset);
 
@@ -1857,8 +1855,7 @@ int pmd_clear_huge(pmd_t *pmdp)
 	return 1;
 }
 
-static int __pmd_free_pte_page(pmd_t *pmdp, unsigned long addr,
-			       bool acquire_mmap_lock)
+int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
 {
 	pte_t *table;
 	pmd_t pmd;
@@ -1870,25 +1867,13 @@ static int __pmd_free_pte_page(pmd_t *pmdp, unsigned long addr,
 		return 1;
 	}
 
-	/* See comment in pud_free_pmd_page for static key logic */
 	table = pte_offset_kernel(pmdp, addr);
 	pmd_clear(pmdp);
 	__flush_tlb_kernel_pgtable(addr);
-	if (static_branch_unlikely(&arm64_ptdump_lock_key) && acquire_mmap_lock) {
-		mmap_read_lock(&init_mm);
-		mmap_read_unlock(&init_mm);
-	}
-
 	pte_free_kernel(NULL, table);
 	return 1;
 }
 
-int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
-{
-	/* If ptdump is walking the pagetables, acquire init_mm.mmap_lock */
-	return __pmd_free_pte_page(pmdp, addr, /* acquire_mmap_lock = */ true);
-}
-
 int pud_free_pmd_page(pud_t *pudp, unsigned long addr)
 {
 	pmd_t *table;
@@ -1904,36 +1889,16 @@ int pud_free_pmd_page(pud_t *pudp, unsigned long addr)
 	}
 
 	table = pmd_offset(pudp, addr);
-
-	/*
-	 * Our objective is to prevent ptdump from reading a PMD table which has
-	 * been freed. In this race, if pud_free_pmd_page observes the key on
-	 * (which got flipped by ptdump) then the mmap lock sequence here will,
-	 * as a result of the mmap write lock/unlock sequence in ptdump, give
-	 * us the correct synchronization. If not, this means that ptdump has
-	 * yet not started walking the pagetables - the sequence of barriers
-	 * issued by __flush_tlb_kernel_pgtable() guarantees that ptdump will
-	 * observe an empty PUD.
-	 */
-	pud_clear(pudp);
-	__flush_tlb_kernel_pgtable(addr);
-	if (static_branch_unlikely(&arm64_ptdump_lock_key)) {
-		mmap_read_lock(&init_mm);
-		mmap_read_unlock(&init_mm);
-	}
-
 	pmdp = table;
 	next = addr;
 	end = addr + PUD_SIZE;
 	do {
 		if (pmd_present(pmdp_get(pmdp)))
-			/*
-			 * PMD has been isolated, so ptdump won't see it. No
-			 * need to acquire init_mm.mmap_lock.
-			 */
-			__pmd_free_pte_page(pmdp, next, /* acquire_mmap_lock = */ false);
+			pmd_free_pte_page(pmdp, next);
 	} while (pmdp++, next += PMD_SIZE, next != end);
 
+	pud_clear(pudp);
+	__flush_tlb_kernel_pgtable(addr);
 	pmd_free(NULL, table);
 	return 1;
 }
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 1c20144700d7..5a76c59b5ada 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -283,13 +283,6 @@ void note_page_flush(struct ptdump_state *pt_st)
 	note_page(pt_st, 0, -1, pte_val(pte_zero));
 }
 
-static void arm64_ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm)
-{
-	static_branch_inc(&arm64_ptdump_lock_key);
-	ptdump_walk_pgd(st, mm, NULL);
-	static_branch_dec(&arm64_ptdump_lock_key);
-}
-
 void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
 {
 	unsigned long end = ~0UL;
@@ -318,7 +311,7 @@ void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
 		}
 	};
 
-	arm64_ptdump_walk_pgd(&st.ptdump, info->mm);
+	ptdump_walk_pgd(&st.ptdump, info->mm, NULL);
 }
 
 static void __init ptdump_initialize(void)
@@ -360,7 +353,7 @@ bool ptdump_check_wx(void)
 		}
 	};
 
-	arm64_ptdump_walk_pgd(&st.ptdump, &init_mm);
+	ptdump_walk_pgd(&st.ptdump, &init_mm, NULL);
 
 	if (st.wx_pages || st.uxn_pages) {
 		pr_warn("Checked W+X mappings: FAILED, %lu W+X pages found, %lu non-UXN pages found\n",
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 9d0f1fdd6af3..537ff7b3c412 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -170,10 +170,7 @@ static int vmap_try_huge_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
 	 * Therefore, acquire the mmap read lock to prevent use-after-free when
 	 * freeing page tables.
 	 */
-#ifndef CONFIG_ARM64
-	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
-#endif
-	{
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm) {
 		if (!pmd_free_pte_page(pmd, addr))
 			return 0;
 		return pmd_set_huge(pmd, phys_addr, prot);
@@ -230,10 +227,7 @@ static int vmap_try_huge_pud(pud_t *pud, unsigned long addr, unsigned long end,
 		return pud_set_huge(pud, phys_addr, prot);
 
 	/* See comment in vmap_try_huge_pmd(). */
-#ifndef CONFIG_ARM64
-	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
-#endif
-	{
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm) {
 		if (!pud_free_pmd_page(pud, addr))
 			return 0;
 		return pud_set_huge(pud, phys_addr, prot);
@@ -290,10 +284,7 @@ static int vmap_try_huge_p4d(p4d_t *p4d, unsigned long addr, unsigned long end,
 		return p4d_set_huge(p4d, phys_addr, prot);
 
 	/* See comment in vmap_try_huge_pmd(). */
-#ifndef CONFIG_ARM64
-	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
-#endif
-	{
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm) {
 		if (!p4d_free_pud_page(p4d, addr))
 			return 0;
 		return p4d_set_huge(p4d, phys_addr, prot);

-- 
2.55.0


