Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07C80C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116956B00D3; Fri, 17 Jul 2026 13:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE646B00D4; Fri, 17 Jul 2026 13:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004DB6B00D5; Fri, 17 Jul 2026 13:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C99736B00D3
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:30:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A3A0C013B
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:30:58 +0000 (UTC)
X-FDA: 84998958996.06.AC2A878
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 86C3D180015
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:30:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WASkYcCH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784309456;
	b=SfcVWGv/gktn/LpsxrSb6ZW8hyKEOWh+d/IM4OvdAwdowUVEIaKlZTQ9+HtpnW2balZPia
	/ol0SiRoCtSq+DivMHmfBVIcav7hahHWc1o7hZ3vP8THnq01dF89GpHPuyUTIKfqaqkybW
	PtrzfH8BL0wdfBr/qG2PD0xeVp4k7vk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WASkYcCH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VUDPRdQphPMrECclGKpOqw0nMGRICTbCUk3WOCCAA1A=;
	b=AqKXj4j3wWn/+YFOYS8WDxwEJETBIW7WDTziWp2wWl/lubjLPws7jZL91whcd/jjrHNi5M
	MtJfLwC9PQHj3rtB65p86R3gxGmQlSRccZMjHu1Xiy9s96SttNQH7y2mowwQ1JYwFloTGY
	YYg8ZFH8I7dvcSVZ3runFCZaGy2uly4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4D8D424C9;
	Fri, 17 Jul 2026 17:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3D11F00A3A;
	Fri, 17 Jul 2026 17:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309455;
	bh=VUDPRdQphPMrECclGKpOqw0nMGRICTbCUk3WOCCAA1A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WASkYcCHBUDKKnfXbCGeSPf5kDOuVpR194ki/SN/lZBzNwpojwTWPoripPyE9IPsJ
	 vOrVxnqDgxjwc6ws0TCpUqLwQ/he31BZlqLBBRUOfP0SdKrV/Iv6iEhbNC9i3oS3g8
	 C58UuxqQ8feH9Zm1RI0pm8dE3csGJ1T12b6aedALWnsNujf8UUGXRKTotHPUXLZ3Tt
	 d3HtgklZbEN3/x8UI1VnT3eeikE2xFMpWheBa03vTFyzaCws0xf9j64ahg99kuJ+jH
	 dEQtGV2bTJmTV22NROODyaTv9Wd+UfiK3W1Ta373JBqv8/ydetOjC7yr19o8/7FgVh
	 PcIOIQ3vmPxLA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 18:30:07 +0100
Subject: [PATCH mm-hotfixes v5 1/5] mm/vmalloc: acquire init_mm lock on
 huge vmap to avoid ptdump UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-series-vmap-race-fix-v5-1-606a0ac6d3e5@kernel.org>
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
 stable@vger.kernel.org, 
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8900; i=ljs@kernel.org;
 h=from:subject:message-id; bh=y0jFTQOJ+Dq2wgdO+3QOYkjdotoBMq7hRls4SEbmZAo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKi0rZpNpubpcYWZK9ZZCXWeYRjyTnzwJRjiv3/f31Wv
 /X2plVyRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACbSs4Dhr6TFMv7zJffK2ITj
 9vJeYVcwufHql8Cbu33yMyovtfxQVmJkaHgwQTdbzOdzW8jtuo6tP4SfhuswGUbckcy6uKK7vuc
 ODwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 86C3D180015
X-Rspam-User: 
X-Stat-Signature: qn48o98nnz17auyaseb3nbopgrh4kgqu
X-Rspamd-Server: rspam03
X-HE-Tag: 1784309456-131446
X-HE-Meta: U2FsdGVkX1/+HaPoTcX/I1Uj1iT4l/M/2YqP8iRPWoHpyNMjeAs3FkS/OJpc9WMieSYIWBM+djuI97XkoXehtbAm3iEw6IyqfppsJFUnDXgGAAQUVyj/c+pqD1zUXfves837PRWRtn4R7n/SauRDi6SZPt4KKAb1SGDM706yNE1xWidBPleNQuUMKpvOgPJA04lA/q/5Ax2wqBUp8o6gBST0cGEUUDSmnbxkBc8uMrFUa8xXw6QvILRbbYVip1PZUaaSspWO3SWwIhTy/S98XMyEH2Z0JpapOK86zs4/ilH+L0k7ggroCTGu2UEfEHZqTHSzSYSiSEujhxCczCEr28Dlqg7Ll0uHCfEeekhlgIhSnAU6m6AUhHPXrnzGAsz8pFiOb+YLjw3np0lt976f4tCx/VzFSq08tMKRtonTGA6t9kE2O4OXQR3TmL9ln5IKTGY/c5d+OsTePvURmXZ15MB8zYYSEpRlXCKtqc7HSBfpMnj5BPO51BxD+P8/01ygaAHWW5MPZkuBN+eGOzpk5Smjy998Q1uoPtDbg8+uTolPOqOOVDRV7NNqkpma1qSnVTfXQo51jZjiOZw+arsqQWyoq85VyNPe9zwdXb3jBtEfOl+NDTZcIEF+HhhCX2zVaT8+zLiI533YCW1lNShbuV4ObX/UhQ1Mvjhk2yZJ+szS6+LglbUq9GoQlb4ElxUIciLhpuKbbvkVISBcRTh0JuXI593HixyRPpFl3RJJcL7lCDWZqWzF3V2rWzipT37zkW/iJ3vwxElyArTzX1IahR7D3j4KVgSvyzQP0axvpxcXpCsaFJeUQYAuLwYugATSxQmZvPg1IJDuKwO+xeYYduvUrpMJJZzgL+ivXwkY2iCIMoDerGjhqF7AtUIiiRBIDlN80FIfBqfrZbffi0cJk07T1JwCyYQaw8Jd3feE0qvIjkKlPvamzZUZ56q3EA0WQCDIkCwlGnGgscuO2dv
 upT/Wd26
 2oH8m7D0Iz7v4YRm4VqmEP8ZXnYChGPuvdnaomx6e9TCHhEeR6xWJuszE0qKoDnZFI16xDXPV3f+hX8oXNQ6SWjizIggj+NdNqsXlJYSp2hJ0p/Sjd0Sr0mH2sbsCO/vqtAZ/hCr51D+HXS+FFNEO+lKNkwn6+NfIh5VUtJpnJOFpuHuM8eoGrPBXbmQYsyJo+BFP63KmHc4t/veTRq8Iyb4pd11itwnXsyonbpKBYls9Nd57w/RFSzpH3LH9km4GIOsTCzgiGalXYxK220crqma4vUHGAUNzRf1/sOMhgcnDeHsgONR9WPs+6CBstLD2aCGmp5C7QqIb7B8GpZ/9f+2WhlrvLtVmyuEk9oe931l9JAOQinX8sdFKjKSkpTr6K27XaoHJEgwUNPR2GXEEWBBkJ/QHe/isCLQbOi6FhvOvRxlydPnoMNwnMipMAu8qwUR983/QkbRzb/kevB3PT8NnOofe8/CbHfrmpXXeQf81fxz9dd4nqGZ1pWIKCGBm9oDEBS26f8R5WsAzwNzP94ZbiAFYg+e9c0zp8aQJAHNgGU3gVMUpIjHJ9JVQR4Y03uTdKwuibgkYbNQFju4Z/jhoXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently there is a nasty race between ptdump and vmap when attempting to
map a huge P4D, PUD or PMD entry:

* ptdump walks kernel page table ranges it doesn't own.

* When vmap maps ranges it tries to promotes existing ones to huge page
  tables in vmap_try_huge_[p4d,pud,pmd]() at P4D, PUD and PMD level,
  freeing the lower page table in [p4d,pud,pmd]_free_[pud,pmd,pte]_page()
  when it succeeds.

Both of these things can happen at the same time and as a result ptdump can
access a freed page table, resulting in a use-after-free and memory
corruption.

This is possible because while ptdump_walk_pgd() holds both the mem hotplug
lock and the mmap write lock before invoking walk_page_range_debug(), vmap
takes no relevant locks at all.

Fix this by holding the mmap read lock in vmap_try_huge_*() when freeing
page tables.

The read lock is sufficient: ptdump is the only walker that must be
excluded and it holds the mmap write lock.  Other holders of the read lock
may run concurrently, but each exclusively owns the range it operates on
and cannot reach the page tables freed here.

We also hold the lock while assigning the huge page table entry, which
means page table walkers observe only the huge or non-huge page table
entry.

We use a trylock to prevent ptdump from blocking vmap making forward
progress. This is fine because it's an optimisation in any case, and thus
the vmap can safely proceed regardless.

All other kernel page table walkers that touch vmalloc ranges either
exclusively own the memory walked or acquire the mmap lock, so this
correctly excludes those walkers.

One wrinkle here is commit fa93b45fd397 ("arm64: Enable vmalloc-huge with
ptdump"), which addresses the issue for arm64 only by explicitly acquiring
the mmap read lock on kernel page table freeing should a concurrent ptdump
be in progress.

This is problematic as vmap may acquire the mmap read lock prior to ptdump
attempting to acquire an mmap write lock, leading to a deadlock when the
mmap read lock is slept upon on page table freeing due to rwsem
anti-starvation.

We work around this by predicating the mmap lock being taken on
!CONFIG_ARM64 for the time being.

With this patch applied, a follow up will partially revert commit
fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump") and at that stage
remove the arm64 ifdeffery.

We also update walk_page_range_debug() to assert the mmap write lock
unconditionally and update the comment here to reflect this change.

The issue has existed as long as ptdump was available and vmap freed page
tables when promoting to a huge leaf entry, that is, since commit
b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table") for
huge ioremap, and commit 121e6f3258fe ("mm/vmalloc: hugepage vmalloc
mappings") for huge vmalloc.

Since the former is the earlier of the two we choose that for our Fixes
tag.

We also define a guard class for mmap_read_trylock() so we can use
cleanup.h to make the scope handling cleaner in the implementation.

This patch is based on work by David Carlier (linked), with gratitude!

Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
Cc: stable@vger.kernel.org
Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
Link: https://lore.kernel.org/linux-mm/20260706203128.162335-1-devnexen@gmail.com/
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mmap_lock.h |  1 +
 mm/pagewalk.c             | 22 +++++++++++----------
 mm/vmalloc.c              | 49 ++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 53 insertions(+), 19 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 04b8f61ece5d..6b5c2390cc30 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -621,6 +621,7 @@ static inline void mmap_read_unlock(struct mm_struct *mm)
 
 DEFINE_GUARD(mmap_read_lock, struct mm_struct *,
 	     mmap_read_lock(_T), mmap_read_unlock(_T))
+DEFINE_GUARD_COND(mmap_read_lock, _try, mmap_read_trylock(_T))
 
 static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
 {
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 3ae2586ff45b..bbcfd68d0907 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -678,6 +678,8 @@ int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end
  * will also not lock the PTEs for the pte_entry() callback.
  *
  * This is for debugging purposes ONLY.
+ *
+ * The mmap write lock must be held.
  */
 int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 			  unsigned long end, const struct mm_walk_ops *ops,
@@ -691,6 +693,16 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 		.no_vma		= true
 	};
 
+	/*
+	 * When walking userland page tables, an mmap write lock must be held to
+	 * account for munmap() downgrading to an mmap read lock when tearing
+	 * down page tables.
+	 *
+	 * When walking kernel page tables, an mmap write lock must also be held
+	 * to account for page table freeing on vmap huge page mapping.
+	 */
+	mmap_assert_write_locked(mm);
+
 	/* For convenience, we allow traversal of kernel mappings. */
 	if (mm == &init_mm)
 		return walk_kernel_page_table_range(start, end, ops,
@@ -700,16 +712,6 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 	if (!check_ops_safe(ops))
 		return -EINVAL;
 
-	/*
-	 * The mmap lock protects the page walker from changes to the page
-	 * tables during the walk.  However a read lock is insufficient to
-	 * protect those areas which don't have a VMA as munmap() detaches
-	 * the VMAs before downgrading to a read lock and actually tearing
-	 * down PTEs/page tables. In which case, the mmap write lock should
-	 * be held.
-	 */
-	mmap_assert_write_locked(mm);
-
 	return walk_pgd_range(start, end, &walk);
 }
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1afca3568b9b..d5c4d2bb770b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -43,6 +43,7 @@
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 #include <linux/page_owner.h>
+#include <linux/cleanup.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmalloc.h>
@@ -158,10 +159,24 @@ static int vmap_try_huge_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
 	if (!IS_ALIGNED(phys_addr, PMD_SIZE))
 		return 0;
 
-	if (pmd_present(*pmd) && !pmd_free_pte_page(pmd, addr))
-		return 0;
+	if (!pmd_present(*pmd))
+		return pmd_set_huge(pmd, phys_addr, prot);
 
-	return pmd_set_huge(pmd, phys_addr, prot);
+	/*
+	 * Acquire the mmap read lock to exclude ptdump, which walks
+	 * kernel page tables it does not own under the mmap write lock.
+	 *
+	 * Concurrent read lock holders are safe: each exclusively owns
+	 * the range it operates on and cannot reach this page table.
+	 */
+#ifndef CONFIG_ARM64
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
+#endif
+	{
+		if (!pmd_free_pte_page(pmd, addr))
+			return 0;
+		return pmd_set_huge(pmd, phys_addr, prot);
+	}
 }
 
 static int vmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
@@ -210,10 +225,18 @@ static int vmap_try_huge_pud(pud_t *pud, unsigned long addr, unsigned long end,
 	if (!IS_ALIGNED(phys_addr, PUD_SIZE))
 		return 0;
 
-	if (pud_present(*pud) && !pud_free_pmd_page(pud, addr))
-		return 0;
+	if (!pud_present(*pud))
+		return pud_set_huge(pud, phys_addr, prot);
 
-	return pud_set_huge(pud, phys_addr, prot);
+	/* See comment in vmap_try_huge_pmd(). */
+#ifndef CONFIG_ARM64
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
+#endif
+	{
+		if (!pud_free_pmd_page(pud, addr))
+			return 0;
+		return pud_set_huge(pud, phys_addr, prot);
+	}
 }
 
 static int vmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
@@ -262,10 +285,18 @@ static int vmap_try_huge_p4d(p4d_t *p4d, unsigned long addr, unsigned long end,
 	if (!IS_ALIGNED(phys_addr, P4D_SIZE))
 		return 0;
 
-	if (p4d_present(*p4d) && !p4d_free_pud_page(p4d, addr))
-		return 0;
+	if (!p4d_present(*p4d))
+		return p4d_set_huge(p4d, phys_addr, prot);
 
-	return p4d_set_huge(p4d, phys_addr, prot);
+	/* See comment in vmap_try_huge_pmd(). */
+#ifndef CONFIG_ARM64
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
+#endif
+	{
+		if (!p4d_free_pud_page(p4d, addr))
+			return 0;
+		return p4d_set_huge(p4d, phys_addr, prot);
+	}
 }
 
 static int vmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,

-- 
2.55.0


