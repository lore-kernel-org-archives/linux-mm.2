Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44C66C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 400AF6B00C3; Tue, 14 Jul 2026 13:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38AF16B00C7; Tue, 14 Jul 2026 13:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27A4C6B00C8; Tue, 14 Jul 2026 13:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2CB26B00C3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:25:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74F2514041A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:25:16 +0000 (UTC)
X-FDA: 84988058232.12.1B3F558
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9DCD720007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:25:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PC17pXS2;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784049914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6X5YMXpvKlN1rtFZuXWP5ezzGqrHft5cjQkbgIqQagg=;
	b=rS686VjN5lCbQmNqyboiIxbuS3QdlFPxdM8jW9+wRX7NYTzE+TMvXmXJi0GoaRfPuG7+fY
	1CSiCl3cnc3vNIrLzBwtd0PMS7O1E3ljZwN5WokpTpx2Iu+7nCmsTodJz9kPvOZLJUmH6f
	JemOck9cwCyv8QyOsUiRrXRPR4KyGLI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784049914;
	b=SPaPwgMU/J630K61ATGMP86791ce2Fr0KNvvCCwHkQOWZRo9j7jmSpOtrZ3E+HCH+boAc3
	FRusAeWcx5UhAfW4+rJwkERDWhjuCW2KL70kf4OAtpYJzZX03rwnsrMxJkV3Uts7YAZNpH
	7mAuPyVtZK41tnXeoeNayFDWezcRikI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PC17pXS2;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA16C4399B;
	Tue, 14 Jul 2026 17:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279171F00A3A;
	Tue, 14 Jul 2026 17:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784049913;
	bh=6X5YMXpvKlN1rtFZuXWP5ezzGqrHft5cjQkbgIqQagg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PC17pXS2WHaTYBIL1Slqx4PrZnyY8dMc2smCQYBF/0yu4Wi4jL/xj6gSsjw9azwsH
	 h2PBo0E+0nEYjR6EkiARz92BXhIqmjmW4a6zK34FpYcajUMzqcWO7elmfDzKcaoqr7
	 dsgozGajBE7ht5bjTWhV9wjAMcphziVzf5Wcuoh1s1jsrCx8EIiwXgedkDdnqhJv/y
	 KyApJKXEtaOZR2x9QFGqMRtDHMBG3iTiLsarzRks95WAQ6NzX5+pCm4pDlv19UfUKt
	 ZtJx4I31XHtkTgIb9cpQS7AVdPrHfrSmd0TmDewmewNFNK/PJKo1UzNVdV3ivRcQKH
	 uERmQC+kxoAVA==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Tue, 14 Jul 2026 18:24:26 +0100
Subject: [PATCH mm-hotfixes v3 4/4] arm64: remove redundant concurrent
 ptdump UAF mitigation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-series-vmap-race-fix-v3-4-b812eccfa0f9@kernel.org>
References: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
In-Reply-To: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: David Carlier <devnexen@gmail.com>, ljs@kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=6970; i=ljs@kernel.org;
 h=from:subject:message-id; bh=QfkQiauRr1PTaQoDS6zXfYa+8p/BKdWZL6M6VQqRgS0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLCCs6xNmyP28KoEf/gWoHNpG1/fXYf2zhlta4S669uy
 QXX9WxudZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAidnEMv5gadq15wVohonZt
 46eHq3Ii/Q9Jlk7gEDx3kf/ot3Ui4jcYGToXsTs9EnRJnC5rsyE2cO1k6wOFbXMibap49z40L3u
 3lAEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9DCD720007
X-Stat-Signature: 67k7a9w9cfy9a1a4gbs3ztk3a5o399a3
X-HE-Tag: 1784049914-931676
X-HE-Meta: U2FsdGVkX19T+6NTzG32krM6ba1mJycoxR8xUjwAvdAUb0Ujqs4+vIxuj5xs+ClhSg14SOGC8d0MNTaCP2Av7DtBjp1fa9rBxybq8TdQhZpfSb5BpxJo1NwVlQtNtaz+/O6m87T20tH3c/Uzqf+hpZMFZRQ6BctDvgI2g0s7nvKQp+3GHwJn2KP0O3KRwuuGmSPQ02arasZgSLr8Ktvz8YRAuFgf79G4GAnn1dVonP0zXHkgqaf/5kgzU+PoyVbb5U1rPTsq0i0gCWFCkNq1R0t7t1/IkPcAcwK0GkqZuo/O8vjROHOMNDTvo3aXCT8QY0nmShLYfP6ZadR3rAI2dj0XG8r/bcYaV5Rgo+Qh3PfnYdMb12GJHvqHdQw2/JnXzEV/l3fmGmcYHiDzB0N+zc7jOmCKKTu8UVOnYLgNzH6Hrye3YgrhGtDwfTvZUn+bOYsj5MyXM5qkfOme0C11I66BkBCizt0Su/V0Vuh6HmQBf0PxJdGEifXB+K02JYVaqp1ckms6cS+MAc53UUDq1xFFjZXdrwlbYjxXas+W+nbchlMzId1iTvl2X8efzZ3fgpgdkr/RkC8Pj679AYYPJ606l5AssqgBY7sPJiWRxscvZDwMjm5COHTAa9PaTUrpDWDIE5JpkvixWt625vhsst3dXlZrDdiIZ386ioxfUjBCsWrEVKPwaVTRRkiYLs9Xf/375lySEqm08cI8e+HtpjnVurtke2wraKdJpa5BbwmEgGT7auoOXVbrHkjbqJdHvtJokuYqwjeegJAziY1IjD5ReWXA/c+elWjkg4mdMMjyG0PENfCJhFkEQmTaa06hsdOipP3Pb5LgFwXBTgg0kTUboTEbKp/C9y7LJZErk5vOH0MI2U7ljY/ZoqfVWD/nm8hyeZ4BzfLk10ZPQy9SbMa6xiqakn500IGHRG+hYfwficD3U8JR2G0NE4jmbLjrbMBOgny+y6XQONHNdFO
 bPUm8zfy
 0iq9RTSzXZ/EJXWOecyBupPCVuzyd8rMN9qxYx5QRDNOyU5re1O93pXBCN66ILDK5O5ROTxdrYTweg/dcqIHZHYGrnZr4e5U6vqV9HHmoOfrDAPIsOiMS/2/zgyp9OFN8AdrzpQZ64zvQ09kdj+LiWoeZQcanevhhfto9JemoTPRSt1Eb5ExjRrRuXD/mwoV1tZrP2kpHy9fElTf8Pcj0y7jkk9EDg4EuKUUpFPbdaiJEQbNpqiCjWvW5JRVJUEjBM6klgXa96ISl484zfL661bpM0DWcWzYJZ1UAvqnFEqfKrZqPn5CGJbVzNQ==
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

We also simultaneously remove the arm64 if-deffery when acquiring the mmap
read lock upon vmap huge page table promotion as it is no longer required.

Note that this patch relies on the preceding vmalloc patch, and should not
be backported alone.

Fixes: fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump")
Cc: stable@vger.kernel.org
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
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
index a25d8beacc83..bd52fca6e872 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -49,8 +49,6 @@
 #define NO_CONT_MAPPINGS	BIT(1)
 #define NO_EXEC_MAPPINGS	BIT(2)	/* assumes FEAT_HPDS is not used */
 
-DEFINE_STATIC_KEY_FALSE(arm64_ptdump_lock_key);
-
 u64 kimage_voffset __ro_after_init;
 EXPORT_SYMBOL(kimage_voffset);
 
@@ -1864,8 +1862,7 @@ int pmd_clear_huge(pmd_t *pmdp)
 	return 1;
 }
 
-static int __pmd_free_pte_page(pmd_t *pmdp, unsigned long addr,
-			       bool acquire_mmap_lock)
+int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
 {
 	pte_t *table;
 	pmd_t pmd;
@@ -1877,25 +1874,13 @@ static int __pmd_free_pte_page(pmd_t *pmdp, unsigned long addr,
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
@@ -1911,36 +1896,16 @@ int pud_free_pmd_page(pud_t *pudp, unsigned long addr)
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
index 1fa9ac6e43d4..400563ac6d5d 100644
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


