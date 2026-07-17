Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31A38C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F1B6B00DB; Fri, 17 Jul 2026 13:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35286B00DC; Fri, 17 Jul 2026 13:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72536B00DD; Fri, 17 Jul 2026 13:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC65B6B00DB
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:31:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 491DC1601EF
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:31:26 +0000 (UTC)
X-FDA: 84998960172.13.D37A4B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 610F44000D
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:31:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wxu9zgqI;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784309484;
	b=JSs7jXl3iGzZavjWvAUyQZEah7qNVc2G3yfJkfYoTfUaw/I2PV/c0W+WIhLHHK6uNictMO
	yDrOCJgZokS32plOkMujdf8gRfpfHsHVuYCTC3Hwgruqdp6AoKnYhzgbwvwk6/eYfXLb9x
	jfiChg4DGJu78LVLD2lDR0AYYKlPozk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wxu9zgqI;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tB+p5fpJihvWmKYtOqn6XBXbSKHjdM1g/8Wc7lnKAc=;
	b=3awYGTxD5iWipjQgheA3zxckMK/B0tSE3avteRYFHYV0eD4wamcrsOLuBu2/OO0vh3B0y3
	EKXdT903PFNpq44d75674wwJwftDZjocK67GmldIj3GAH9V9rvqWT1Zpti9Y+zv6k/DGZp
	Pq1kloHVQ7m1BwFuG3XEAXqvoqtlj2U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0238B60A75;
	Fri, 17 Jul 2026 17:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A7C1F00A3D;
	Fri, 17 Jul 2026 17:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309483;
	bh=6tB+p5fpJihvWmKYtOqn6XBXbSKHjdM1g/8Wc7lnKAc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Wxu9zgqIph5rtq6bTKYeHsaiTgxmWpTOwq98kp7/FgXG55S4zw0mETpYJT0yfbyPq
	 v4V5g+nDLg/ghKYBi5mk8rvjZlAhytiKJcx45c4Brl9l2yYq3Oq6NsJfFC417wfHzQ
	 nEBMYY/F2Hn0ehBJGokTLjGbrdWaaUUhz4wU8dEmGho81WigKlnV7ujaEaUP1nKnn2
	 9KjKwty8unA4lldmoJS4SwYuTYkCO8/kkwO6cuknvoWVtcbs1W8JJfUWjmO6QUDDLH
	 dBZTx4vjOUiYj9omJD2y5FfAmxxaZXP1/vo2uMdE8m4CbzOsEyj2QKTHzh5//tJKCN
	 LXQOR0tArV9qA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 18:30:11 +0100
Subject: [PATCH mm-hotfixes v5 5/5] arm64: remove redundant concurrent
 ptdump UAF mitigation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-series-vmap-race-fix-v5-5-606a0ac6d3e5@kernel.org>
References: <20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org>
In-Reply-To: <20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org>
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
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKi0rbPmiD/OZTXw4v7yvRv651ei/3cuKD+SZn7s71WQ
 nr3o9af7ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEHn1lZJhx43Hz5ID+kmJe
 3r7zmyZwv3D7KhTYJX5kG2fK/jdH7mgw/GTkPXPjdkyIsd0f84dBtVY3N+yRF7h5eeHxcueUi5Y
 sW1gA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 610F44000D
X-Stat-Signature: ko5s5ugjff89fo7s9ik7ogt9yw3zasjy
X-HE-Tag: 1784309484-607411
X-HE-Meta: U2FsdGVkX1/Oto6sDpEsp+wmmiEQ90reeSYyGmd3Ohwncs2aEhZHrF2TdQ/lI/y9onE328n2Z3ZBX1bY8a8l9AC7UtwDaiyIlefnNQ63jYdvyAhJ4KDXQV3kWhvBHE4DNQMDGLO+m19FuL1X1DLZVE29oThtGMmNDIcS9JcVCgU7U+7fCMs3aH3q+2M0fk9iajxrYuofG/cHYdaH7KT/botwV+bW9SU99tRpMNyoZen5hhdBVNbfk/bDxJDU4YCuSmbRzzMF23HtBtCVJCeVOMap3GjKOwCHNddidfz9PAoDi49d4jTNZk48Sy1vNk9/qEjckuTwYF7btPnxDk/7iNkVybpSCwYsoBsmFM9wwfmY+B0VA85OZ01cvcsQTl+PWEDjZJLDOXK3Z6W1pjQAfpayy4fqnHTDES1VGQ8F/r2n4N+vR77kBWsGC72jWtJm4AyG5YL5BOz9YfZIHLzYFImm+Fhp2ZS43q4fQJ9NMok5yU/SHt78ZHl/QuStC6wcTFKt5p2kji8PbTT3sL+UjmKeuZWd4qUs8tb1I7bMiScOS5df4nGxXFdvI5VA2kQu++ADF32g2IkAzKL7J8scaKfTnXI4apjhb8aXUUP4A9HYm4e0YWy3AF1UetavrhzLsGsHF13FYMjrc98H5O6QE24mv32cTgyCCJQAG8+ukhv+X+Vv/IixRW30aLQiK6orL7PPXmHBCs3pmiekyAM4RA7exgd6apV9tA+Z6X7tMOclubsol2MJV1LVDWOs6Lvp5YXuJskhxlaKGMSGBm5R+HizUPa5AQClt8eChCRc0SP/MT9KEn/EkDwwh9cE981J0UEP+3KRod35gwX1aWe1C+t9X9CSt9XFBOpwOjZXlbYPfSfoOgi2+VrtpvhM3/ZWOecKKJUd74gxHoyiXMTVEIFmtNYuYJYQvGFg5AWZI/o+Whqc7QgegvSKfMuLFlRy6CkLkwEbj7V4V8vsa1z
 PKdSftdV
 CrJj50xGByLlKMUOyZ/Q1Q5Y2AbmZXgrI1x9DYh6k65yVQvS76/9RyOF/wx55eusxrjlkKw+MAOaH9NSpHe3b1kEeg6sU7UKDHiVJUZxtBSGHELVpRHTIzlvNllNSHmGR319OStHc0z+/zIlCXN3hosDhSm63XWizw9DoujIpxpGyvICbea1A8UzoRfURQdRenLevptZT5id6/RQpOEworYyNL+VadkkVvCEdZBqUjinbd7Eeg72YNZX4XGFGqVt0zDWp/jUMoz3HzeS4Euk4IkEi7iFiifUrQjacFp8l7VabQw20jw6frRR99w==
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


