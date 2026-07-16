Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6298C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 21:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C0B6B00B3; Thu, 16 Jul 2026 17:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A031D6B00B5; Thu, 16 Jul 2026 17:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919AE6B00B6; Thu, 16 Jul 2026 17:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 654726B00B3
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:32:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF57B1602EF
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:32:09 +0000 (UTC)
X-FDA: 84995937978.13.EFBFC06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 291F94000A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:32:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NmwgOa92;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784237528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tB+p5fpJihvWmKYtOqn6XBXbSKHjdM1g/8Wc7lnKAc=;
	b=on5d/xIkY0fpKU1MbP1VrdMMtCW5B/a1cieDILHklW4UGo2hUSg6yUlnrvtoDacWM9WetP
	9cGO/HYa3dXdBXtIFnevCE4r7GposFOXbHBina1/zbzpaytGGBO3QrfhOWslwTFNrDvxdF
	XKq7NUUKxtyemQ7/pGdghr2RdWaR8D0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NmwgOa92;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784237528;
	b=LiLhUA1NvT+TACfGFaW+p24wTQltekiyjLE9PzBdxNfmOWdrZuWdJrFuFMIpkJhtBJaYuu
	PgKHjv4TQYc5uHh3w3bGtDQniyvGEHfES9xMF5gg0lPP/qM7YEBQjVFRKhQxugNtX94OAj
	ZdwN+3mDsS+akblJVl9PRuxMUZUUx7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D1614324D;
	Thu, 16 Jul 2026 21:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEF91F000E9;
	Thu, 16 Jul 2026 21:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784237527;
	bh=6tB+p5fpJihvWmKYtOqn6XBXbSKHjdM1g/8Wc7lnKAc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NmwgOa92PeD48+bLHUAnvL16XjRKn0h3kz3vESeNv5Xhqnj3ggmzIWBXdFEPyMcTX
	 fJhBMOQOJQ+2iCO5mPto30hTGE6qL8Oe7ldjnmQ9Re0i2HQiGK2V9lXBhR1CfCV3XB
	 5q6AyYOfIWL1Rr+Cqd18GE735zTE8lg4QQxygLEX8KLtETwV6squjFXrHuiRYNMgeu
	 cTNJq84ysVaj6Ztf3t+vk3f1YCJkYod87ejGP8R56cJT4K19UAtzIYDZFCRZR65HI9
	 IQHJF9wIu3f6XvEO+sRaVkGaiehTmKdKS1mEnLxprdPDXi0g1kLIHifWgM14ekZJBC
	 Dt1c6JEj6f3CQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 16 Jul 2026 22:31:15 +0100
Subject: [PATCH mm-hotfixes v4 4/4] arm64: remove redundant concurrent
 ptdump UAF mitigation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-series-vmap-race-fix-v4-4-8c108c4317df@kernel.org>
References: <20260716-series-vmap-race-fix-v4-0-8c108c4317df@kernel.org>
In-Reply-To: <20260716-series-vmap-race-fix-v4-0-8c108c4317df@kernel.org>
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
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7063; i=ljs@kernel.org;
 h=from:subject:message-id; bh=kE9XtB6iyw7BSFNAuuPgI01clqwgzMyGQ2yqQHsLjJM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIifdfqWl5lylpfsPmAvrPrt6Vyx7bu6VxW84JjddT7M
 4Xb/+671FHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJvLNjZHi6UU7r53+HlR+L
 P+QsMfBrOaYzf+0HlpYiUeYfKoXi+c8Y/kfnLNGy2d6aEJ72yVTwOdPS/lK523P+Poy9fOGY1Td
 vERYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 291F94000A
X-Stat-Signature: jeju754iukp164qhnxzedmwh1cdanihk
X-Rspam-User: 
X-HE-Tag: 1784237527-106937
X-HE-Meta: U2FsdGVkX18LbZxYuztWDT+XkTYTQQbTUK0taaqMn5x5wG+dMHzJUNqzK1s46LDdgXCSjZVTjCLRPhS2q3Ob7wWGWbCIiRfUEhLGQzAUfOS3HHoa2wXVFCBLkWqzklUCDqKPQpCy+4W1juFXHfdVUQcN6Cac2S5sHJV8cPBWobXxmXq3+i2/Mg8UT2rZDp34BDi/MrS2u71IaRdLbO3ux+P+cPQP6i0zBqDisD+TamT5jULeG1tvTIBjQsHu9M7eD6qp29kE1ZJCm9Zu3D5UVC9oRGocMLAhes65dk7ut7iuUVt6f09/pjDvysRDFi9XooE1bAvPmADcDI/4a9G5KIXy042LXD5jnABYt5kieZVoQgVKuopadUT9teYyOasiodurzeamVmLKG+VohnWdxHrRaplEsoq7cv3+QV43Wux7z7w26kQZivBIZSegLwL8HM/uBgZzZ4BntpV0L8N1TbRP7DUQwkfeJkrzi4BAupc9VTwMfArvtZM81AhgrLpNZV3kPulCLgRVqhkOnohgS6C9m+w5TodH04bu5sbQaBw51uyhBkxSAu1VaySu/KxNoBKDJmdMZnLveywH0bM0XU0Nm8qlCNNoWJP718CGGBAkITn0WZ/QcbQ6A7EppzspJrkm/f7HsetevwFXEYof7MCbPtHCCA7yodoyzcQLeC5Mu1cv0waHf8ptpSyN1cxjgUrkUls9TEpNlLLazxgtt1DlMj3NgSrDNLufwNABK6uU44wi2FwxMPqkynr3JOUGbC5ELMHSFbCZr0a6zCV9EE9TBFb/dozYk0G8rEZSeC650C60xLkTgJbWGl1Srr9HlyeqZ/vLOd2zWke1r9ED9H6cAv/aE/ePSXyD0uj37k1NgXoFSpUz4QIdbeVtFmPe685AeISw0tK+Dvy6+xmI+K6MqfW4FFu0RNhemUKOkxG6sTIVW+69Ulw56Z5AtQflrakxiB9lBPGxYZF3Jnu
 Ua0QaUI/
 GLnOpIp7cBo//ZI2nGEM9hlmGWKPD3fcrrymh+U0e1Bg1Ihr1ofOhmk36RL+35DPcfirnxPlksIr0Ke551vysgixsVZXOnSlvenWo/W30vfw3cWJ3Rx/+ca9Nl1sWGKeiCvRnJ2KUAE9fL9tlxY36JfGKyO7P3cLNrFBehELoOsizmEDDxDj223o3/II2CGRvYy6hb/78c5EA1sTcGvH/8TJYLV88oG++p8LQ5Fp0zvxxbsqewFUIxtjtEQ/2CdM6YS3RfgpnB0Mgn/ez0/jBITbM0Sf9hWsuA/8w+u+gGOvk8UIdnQUXxTP+VA==
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


