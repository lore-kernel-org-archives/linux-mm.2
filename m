Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25EAFC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 10:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36546B0093; Sun, 12 Jul 2026 06:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D984B6B0095; Sun, 12 Jul 2026 06:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8A016B0096; Sun, 12 Jul 2026 06:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 943586B0093
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 06:44:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D8E4A0887
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 10:44:47 +0000 (UTC)
X-FDA: 84979791414.23.30B6865
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3DC4940004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 10:44:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iHt7yzwn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783853085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w3ZKkJYADp4LuVEyETZdU5oY7rqadayz5ZMLHtiQ+kM=;
	b=6fodqb7GLdBcrchuYTJ1zswMlbtF9pgBY3wE0pbw3bI+VzDPs+nZNbuOWME9nkZK1JdFvb
	TwyGnVMgogRx4TmfQ1izlvC4dSElVmmq9N/99XGxkhtOml+AcAzykkY/Qq/Nvrapf40o/t
	uDhvPrHbzdYIMK1lqdRgPHzf3/xG2Xo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iHt7yzwn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783853085;
	b=rX7rOPJzhVQST7xAoNvnr3cJcjojsfOSZGblOOXGsG9mMiWfDq2hyV/0yJ8bOKTWlW04q8
	qgz6Epp+FjXZV47BeBsUpxlbxOOczWSLRwV3yO1uX5OlUeBsV2xyjIOQYblGR2hxzFA8tC
	NEPgr3DWdTRbf5IvdHP6Gi0/CNuTUKc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 34672400F8;
	Sun, 12 Jul 2026 10:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFD01F000E9;
	Sun, 12 Jul 2026 10:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783853084;
	bh=w3ZKkJYADp4LuVEyETZdU5oY7rqadayz5ZMLHtiQ+kM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iHt7yzwnmfb4E3hm94gtbrfP2oY+H4ve2xcX15Qwg0r3kIIRRm2AAgNDRanH8HfvD
	 26LM0AKvLNIADfJIhHJYnjRdlNVzlv9vU+n5KFEmF+8db0OeFBrQ8SI1UqCZ26Bc/G
	 XCuMTsxDNYwvgr2xLDmJ+qmB65/ikkfLrm0dEVXkI9JmknMlj8uTTyFwqQvNKvpLYf
	 GWAXTOTMmKtij3/MXOOVD7YvSo5napCfywpQJKM1tLFtB3KJa3AqW3yWmNWrR77QpK
	 EcbvsF57UO4MkhdFoM9mcEs26GBO2VaJU2TGvZqlac36qmn9wTALSEMe2qFueZoq4C
	 daqu/1hpUoi4A==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Sun, 12 Jul 2026 11:42:27 +0100
Subject: [PATCH mm-hotfixes v2 4/4] arm64: remove redundant concurrent
 ptdump UAF mitigation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260712-series-vmap-race-fix-v2-4-ad134cc3a12a@kernel.org>
References: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
In-Reply-To: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6878; i=ljs@kernel.org;
 h=from:subject:message-id; bh=GlL9IPStDd4Tw6wUpim2GluEjrJu4zbK1OV4gJFr1DI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKC8z9wlYVZawkyFRf3PNSLnPecf9ndfVvfBzLrfdpxn
 mXnlM+FHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZgIvwjDPwWjpackbZ8enXrQ
 v2wLk7GH5K2GqaaVUhESjbwePkXqeowMnR/z/wWbvLWWunvmtf3We9Li3zSPcERfCZv9+E9EfN9
 8LgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3DC4940004
X-Stat-Signature: ixgpni85ca7x66okfkpeh6osmd37drhd
X-HE-Tag: 1783853085-702995
X-HE-Meta: U2FsdGVkX1/PkDg0fA0TUFlFoQYax3ircwbRCEQ+TTTbgYI1BXU440BvAAzc5RC+ieH7qLlBRAVE55bM5tlqPTXeVFc0Mw0iUhi+wnBr1D7S9E50nsvRKI+QH6i8u+tzP+KkVTmZUvY/FH6+vaLPDarxhrzrsD8OgdCbJ/g0B0puszWkfMJ7XcSqUM9y65A33k8OII6Ntn4cI+eGCv1I6ov77HzsqpdddtvrwzvYycN59bcTih+zxnytv4II4g6UBz9TJaxDEdcJOzjRUc9swQ6EeoQiLu53DXYn7PDvY0A+W1n+ekhcJAOpVgjiZ2kCOh5IdasNk5sSEav9L3be7yvlDZDeuSZG9uiFvJbpkpTxcTxAucff67pJ79VWbYBlB1wLVrQUxjoCTz9jtqC8ca0ER3IRXojeqChEXlh69S7UTLfoGIS/n1H1Y5DNNs/zKM5KYNiLsYqzYlD7smdCRgVadtrT6pf/68YlYjkR7J+RbEOtAcHlsrGJIOGzGJNQ/Q/O8kOyyFg4xxlW2ttNbyLE44ITJIOg2DieBVl13ehZYGBMMAtXQytdiDR+Z8LqSJDcFdXlkHwa9v635xUGUWaQGsvXcnaif8yNeiggINUj4qxUPUHe1hLKTFvFZgFl74p1voUfF5E3skV13yE04ABSt0WS/oXRt3OH2fyWfysyrCrZ+J1sBPmVSPukANR4aY5wjETtvF7SsiXqTZu5nBYjS5H0L9LXEKduwFgFhElaKk3j9r3xPkoxKbudT25U1sySfvDuJKpTzf9l6riO1cHsfVN1DnUXZCWnygYQ8E714eM61qBPyD5AiapcIan4CXpRmsshpXyayuQ7jvNnPhKn5IHHNYdWjEbw1dxxLsY8zI9QTiO4nhxInL4J9Bt3HidwqaNaHhzdiP3ciP0OERsuxOz/Brb62hzL11fbsY8GfWOTiX5eKv1yye6iyKqD1xmX9jvjnEI2G/esC0b
 dYxCGTI6
 8wqiJrMsOJWDcHDffFl+rXSneaLSzv+b/hRzSrO0GJo/YGEPJKs/DOHGb+ans2hPb8cCDjS6+wureac2BeSFr5nl8OJuIjL6ZQqkmV1NYzrFnJV7/MkLJLgjDCjzicXvuaShpMSIlbVSxnBdvEFBjikC+MJr2HVzQXFj1K7JzdiHSbyuZvAn0sGY+Pc07K7sOiSovilWYjpvRqLpqiLzxIQBy+txI+iKHZyFdhEP2uMe8BnwVJbtSMPxfQ6hn/K/W3cEuP8VKcWVyMCwW+2noNA0RQBPhxFV+ysqGEz4MwSOZ9soz4lMKwL3qag==
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


