Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C4CC4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 21:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03F7F6B00AD; Thu, 16 Jul 2026 17:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F329F6B00AE; Thu, 16 Jul 2026 17:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49356B00AF; Thu, 16 Jul 2026 17:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFBD66B00AD
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:31:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C4A5402A9
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:31:50 +0000 (UTC)
X-FDA: 84995937180.27.99B82D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 69CB68000D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:31:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D58q0M8+;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784237508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VUDPRdQphPMrECclGKpOqw0nMGRICTbCUk3WOCCAA1A=;
	b=TyCcgJNzLrF9jcF6vcNLntO3HdjjPFSw4XQBR63McUAGVGLpmvxHOOe39h79Oc/K2oiyux
	mD9lNcL0AR3yYaKn+ClJUvo33lTywuurPOkhI4TthD+ZSNWj2S2PRZMCgR+7SyyyPRYDgF
	cS9DNFVzsmZWh7CANesRhdGlD7yYeWo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784237508;
	b=ST6W7Q1DEr+1iifWFio8fbIG7BXAQwVO+XXvqXvI+kC2wb8SyKiBskrLOPA7kZhsFYNXL6
	rL+RXcIt8eBI2Ah8r0zwZ87p5wyaadszk4pRX5JGVMjGGKDAQq+BppK3Cjb12zhbOZXPLT
	DyZN2tSo9XuSLkU4sTGKiDGv82YTPb0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D58q0M8+;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98E8E43877;
	Thu, 16 Jul 2026 21:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3019C1F00A3A;
	Thu, 16 Jul 2026 21:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784237507;
	bh=VUDPRdQphPMrECclGKpOqw0nMGRICTbCUk3WOCCAA1A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=D58q0M8+Hpf8Dkt3GCqnMEE5JOKkP0nBGdiPf2iJVmdnjHAkCgo1+Z7Fs8Jrlo/9D
	 bdx/vBgJX2NV2AoFWh6icjk/R4EXrTCDNjRp+KhS7BbbUfE7sqnKG4MSYIBwGyBCn8
	 jZV1+Jo43GZdCNQcX8dFJVAp6MHz2agji3U8ZfY9ITXYrfw54Itb9lSU6SwAYZMlbz
	 ujFWDXuMLYH8R4aA4wO5kT6s64CXPZH80un5jn33Z7jslRc8DgZEqHUfCQrm6kXAi6
	 ZcZoh83wZ174UURkU7+xz/uLZ5rC6bVki9PyH+GHwuMYkBe+0mknZeXFh+bHG4FNS1
	 DDtMtBXs/jr1w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 16 Jul 2026 22:31:12 +0100
Subject: [PATCH mm-hotfixes v4 1/4] mm/vmalloc: acquire init_mm lock on
 huge vmap to avoid ptdump UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-series-vmap-race-fix-v4-1-8c108c4317df@kernel.org>
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
 stable@vger.kernel.org, 
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8900; i=ljs@kernel.org;
 h=from:subject:message-id; bh=y0jFTQOJ+Dq2wgdO+3QOYkjdotoBMq7hRls4SEbmZAo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIifdfeP/e/0ik0SPHi9TBVx/edlp7Ghq+TzFZ2VKjzq
 997KvW2o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABORUGb47yguEWjeZ7UmPWPZ
 /uMdtz9P8A05OvNdypf7gv5tj9/K6jP8927O3+tWYr3txq/fB1o+OEyT3v1sZsiM+dm+Zi07VK6
 0MQIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 69CB68000D
X-Stat-Signature: efezbxdrutzexb5y7jhzrw1am34sg3zz
X-HE-Tag: 1784237508-461803
X-HE-Meta: U2FsdGVkX19beztnT/Aq1a4isEN9pMMazJH5s5WQIvD8fH+96iTQar5uH35aid59eMIt1cuc3fQzbQqG1zkGfgINKAB+osluYl2fVRyvTFkrttO4UvHdml9Lgmq9OxeFK/w1o9+2BK8MO+oXrr+4PpSUfIqVZ64Sj6jPfyXKaxNhfRLpnL/foW4dVxFKkZ3+ZqWcvZPRtfkl+vvsnJdFJufF9m2819NfCtysYww4MovOlGi56Gk0vxQ/gl+c2Um1Aviuv9ssl9ifOF6tVnUCSUi/1rVHwbbwcN9k4zP8MZkD22E3Gi9KpuJLSkdCzwdrL24SfGw942XZUiKJdpXviq10Jeiv838mFMoC/OhU4rZKV2IYw1b3U5Icwpa+YL2Wrek+pnHcr9ZrPYO8lCHAteTwRaP203yL/kX2W3Ur6cRWlF9/VKQrv+zDBhzHZaJpvt4bLXqrpAsmtFranB3UjSnaBdgtkRjf3FeEgvTNvn98fwjzNKP4QdMKJlHpe9RkEGaauUXBr3l6j7UFb1qNz9wMx0UhAD+ktqYfaG7JzKTR2DcBTQu3T8cjqDkZjR+OjmfgDYIGVS2NJkC1SNebaSw/40Cg2hb14t+cesuejnEEj/1BrpFYrnRLnu9t+u7HpFfKNkqX8xUwzxDjWGoUT4rS2dae4VvTPByNqQ3BHrlMiYjWlH20S4g1UaLCPvvVpG+2D9CQxiThgvOCIXGWZGdHUj+ZLhMc+vVSOaTYAuPUyt/1VO/mqfwdQDCgNxkIf4BoSoPqnwUtPLeqvCl0vThEnM+1uK0w0AnOTcNHoO47ptjj+aU6hH8VsDt2DL905yCOgL/aC0PO5sT/Q2xS+gsJwxRxJDS/Qapn6spKU8LLV3vgyfmz9lZa74HwT6zuncN1J3nOQ8y/EDZIBQMa5EWwA+tQm/FcrUqBJR+d1IoljydxxkPmCJYMC7cvL/Dq+ud6//8ye5NWTWB+kVD
 R6bUEVM7
 EJk/AvOZvodkUQsIx91yGk+SHnOino0T08etQoF7TZKoJIa2TEGDyRfh8fqMdb7SNpZhVUIwpanWz0yBWPc9GVifCNmuq0H7PbJtaT/Hn3Po8lxmCeVDAfJrdp13KOjKeXB0Trk0pXWmQ+lIJAReT7REsaHYTTs2cdV5gkF1oXjjcvp7yDZLG1n/I1xu0aJnHY6/Ne7QVemaCs9GFayqpdWusAD5pQXkQ+W/JjSCq058fl8O+90U0cy1xnmPTAZkvN04fR7VZrW0wq5LnLHP718PkyU7Y9y78CxTFWKgUdqcVu9Mg1XnEgUQgrKnxqlAeY1CtEoZ4ooCONNYv07ShsQ6pXJS8aZ3JtI1qTWFLmWVCaDpNN3y+Y1xAzTvXQJv6ZqY4bEEILK3poOrpMaetbD8b+SNfQmA3KGDllYXVkrj2rFu1cLCZGsaWrXuSWUc4y9dzPVi1pQR/d55FU/nsRyFTcy9QVhHkUs34kf7kR+DM/ObLzIJkmTHaC6zCgaeT+/6uEbHF/TTkOZI1c6Flwt/CozyqFM2OMH+rnJ4JIfI71wSHxHG3tcQ/WTdwynVh609Km1FF0SiMz/zQX6CNLIIIEA==
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


