Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A787C531F8
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 15:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 987316B00B0; Thu, 23 Jul 2026 11:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937656B00B2; Thu, 23 Jul 2026 11:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FFC46B00B3; Thu, 23 Jul 2026 11:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52D9E6B00B0
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:17:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C58C440513
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:17:41 +0000 (UTC)
X-FDA: 85020395922.10.8A8AD81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E9651A000C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:17:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KRq8PkcA;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784819860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tB+p5fpJihvWmKYtOqn6XBXbSKHjdM1g/8Wc7lnKAc=;
	b=y+o1Rq2PKEc/0clF+sRSvwZI8p/8oktH9NHW9yW9s5KoYmXKCt9h6xQDcFD3DYB2xd3G4D
	8MNrafchRFtyVPM6pbYYEvQmKjFl9Ra7LpBKMiKysu3SEIqIcUSy8rka1ugxrrqBRnNHrF
	JwpZv0b+rpTl9eL+6AeDWje5kdGRRn8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784819860;
	b=67dTi6GdKbPlE4N7q1JlrLUjIrREpVoCy0BX8i2VH7E8zu1cPEqTrfPWKf84/immpP33Xn
	lmV653U1faGPL1RgvqEjGSCu4wJbesPi8hcFBPQuHbl+tFw9yS3cGVxs9kFqXrsyYviC2T
	Ho7CZZCJcmw49vKbSgRK2bL+dCJh/Sk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KRq8PkcA;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B004439BF;
	Thu, 23 Jul 2026 15:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF771F00A3D;
	Thu, 23 Jul 2026 15:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784819859;
	bh=6tB+p5fpJihvWmKYtOqn6XBXbSKHjdM1g/8Wc7lnKAc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KRq8PkcAI15VvLDhvamyrojQCEWXOJom5dmcVSRO3GGI0ZVtmBWxnlnE4AfAvyW5R
	 xSyNV65KtAqJ+AvR5Wuxbd8pExLFLRPPQeUuAcx6AV3s33G+KLwTWzaSddN0y/DdoF
	 MWRWqVKt3EnHVokgFuwjSt8Aw/UEvPGcBZm2/gKqTMgr6P949HYeNEnGcMXF2TpnUh
	 dY0jpQKJ62SmMj9IWNm7sEVu9ncYGmQm4sUlXSCzAkl+ZvG4gEsu7AZ96Rvg42W4Y3
	 NG691MHau9f3QMzSeaejz1V6rUC3jsXt1wPdRFfZqeZp/CaXPrITTT7J6iFG2I+0qG
	 KMvqqHSJXD1wg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 23 Jul 2026 16:16:35 +0100
Subject: [PATCH mm-hotfixes v6 5/5] arm64: remove redundant concurrent
 ptdump UAF mitigation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-series-vmap-race-fix-v6-5-8cc77dcc0018@kernel.org>
References: <20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org>
In-Reply-To: <20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org>
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
 linux-arm-kernel@lists.infradead.org, "Denis V. Lunev" <den@virtuozzo.com>, 
 "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7063; i=ljs@kernel.org;
 h=from:subject:message-id; bh=kE9XtB6iyw7BSFNAuuPgI01clqwgzMyGQ2yqQHsLjJM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKSDGJX1utw8GwSKzbiF8gXVHh1sqQieU/oivnb0i5vD
 2qse5zeUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIkcYGH4n6NXKbo/bEO/hMzX
 CQcZJhQf9Fpxozz4pO7M2XPF9wnliTP8ldJbzXqqN+T1UY/L+/2PmS3rVPbftWy1jrJfkvNqgak
 /WAE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E9651A000C
X-Stat-Signature: gcqhfm8r6t9skb1oy3ohmbrorsgct1qh
X-Rspam-User: 
X-HE-Tag: 1784819859-995034
X-HE-Meta: U2FsdGVkX19gy59VH5qmQgEFP22ITDrdiQ7nYT8C71jLva+3dRgAdEYk2rfVh2jKbd8mhmP16wjv4BNYYuQId4Kuy+LEo4u3HCxRmxaPQVtkmCHztf//yHI5+d9UP6sW3jCtjO58BZlXSF5uCCka9BV9n4R8RTzetFO4oTl8fQLHCNsOvrZix3DLQfy9LTKoLWT22Lx2OURSAVV00uQckJSnIJkYfMw55NlKAsHKkKhm/W6kqh/v2/mETEk3cr0vmUpkEZIAc70U3+LGenHsUIoaE2O/isqjrAXUWuM/JibAHHtP7s7kKv1xAQqVc68B+S89LBkjkRKh5rDFnOLIj7BE6VlYgjsyoHW8RkZ/sCZ4ESqYkzKYL432asUj2mpytnP2qz/NL1UhX0D55TZbVZXDYpr3vqnxfRr1pGEbEcOTfJ3nzi8qkFETK5simbHJd9T2zBgzItIOvKSltJWB7i6uc8k1YikdJv+BC8xLhGKgnN0z78kh0ftwsQ8k79EbarieTprmqt13XzCBOb51RUcgb1hY5llBG9OhcNd55jjZVLxwfxKUFkL0MwkFZqIjO2GW4A/sQclbSU03bk58U45BNUCtMTsiTl2tguh56qYr/w+Q4R8XDgeqUbQ/J22etGSjsdcP30q07z2VtGAnTLpKFMfBSwroqppGv7nKbJDsTdfnCBx9FslryiOlA+ao+4AneQGNyNNUaNA39A5pAadewSQ9yVmAyvI1s25zSTXmLKTBfMjeICl5sWZxZRL0GIT4Y2pzg4PeUmQBY+1m1UiMLZpsZt9xWeXeF975P5UR35EGA9UQqlC4CiarEr2hCexOIZ8gTVbcIPQdfZ6i4By2xXpN/fy1yoUOHc8SWVJZSlKyD8WZxWZTXYfZsrAZm1mTovixqq/1oscc5Oen5ZRNgyea90xSuf1PeLPWx5OQE52giDHtsN/CdfwQEPMjD7DeuH24DnkS01gFvbQ
 kxZYaGEK
 kDMyQu200hYaR/CWrwKxpLeX6WJpFzyfe5aGL62BM3qBaNHNoAisN8v2RUza6hOvCJRj8rE++lFRwmDwlM1YL1OnR4DG8vqd0Oax6q7oVqVbywzQoOqAELZkzVOMGMs4rUdG+OKuyeLFP00y34bruuZeGHD1eyF39ayDMKuJmggTYCEUnUbCzAbF4GSnmq5REepbP2l3FiZPBwJNuT3PtmTIej9qLIm8KMIb7FiI2rPBSR4J8wB+BTYqvMUrKWXNcZ164vBa5MKN5cA4FtyTHb+44qZlUnTmdl4Ng8ugrWCdZ56GmUVgrSSCOtQ==
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
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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
index d5c4d2bb770b..f4fa227a8d7f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -169,10 +169,7 @@ static int vmap_try_huge_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
 	 * Concurrent read lock holders are safe: each exclusively owns
 	 * the range it operates on and cannot reach this page table.
 	 */
-#ifndef CONFIG_ARM64
-	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
-#endif
-	{
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm) {
 		if (!pmd_free_pte_page(pmd, addr))
 			return 0;
 		return pmd_set_huge(pmd, phys_addr, prot);
@@ -229,10 +226,7 @@ static int vmap_try_huge_pud(pud_t *pud, unsigned long addr, unsigned long end,
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
@@ -289,10 +283,7 @@ static int vmap_try_huge_p4d(p4d_t *p4d, unsigned long addr, unsigned long end,
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


