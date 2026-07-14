Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFFB6C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7B5D6B00B8; Tue, 14 Jul 2026 13:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2D296B00BD; Tue, 14 Jul 2026 13:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4256B00BE; Tue, 14 Jul 2026 13:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A0626B00B8
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:24:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DFB754048F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:24:54 +0000 (UTC)
X-FDA: 84988057308.02.4A9ED5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 10EC510000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:24:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dkCg7y8A;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784049893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TdyW4Y7bH4m/445xWB+ioB8s7SF8KHb3T29qlCFwons=;
	b=Oeq3V7s9xZTpt8gzhmCXygOr+vwnMqMmurtli4BymKlw9DbtTH2epFZFu3x0YV1N298qoC
	bZK5wP91abw0MzILlk0dN9MgnEl2QF025AhrFLHg3VUT/ACf2OPRLYzs/jye68Ebk/4DAb
	dN4lPDxoOj6X2YULsM0TNGAFsE/bFXo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dkCg7y8A;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784049893;
	b=bUPveqbOCIC30piITtgeXgTqYRFLt8VTv7weZfWdmlVajDTKghcsVYg5zXE2kzH1r1zTvT
	/wxsrVNOJZSzcVrB1lAiBd1CWjTkmh/1KdHYFYmXXB4j8uv4K7oBEyfiPGRq1bxX+csAbD
	RPRESYtjxNZ03L+G32I3tPbwa2+Egtg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EDB44399B;
	Tue, 14 Jul 2026 17:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B431F00A3A;
	Tue, 14 Jul 2026 17:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784049892;
	bh=TdyW4Y7bH4m/445xWB+ioB8s7SF8KHb3T29qlCFwons=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dkCg7y8AUG2qBdSFxdwAORuaXUG5SkssaCeVeMM/vBKGJX/yusOnplHactjMTh5Qu
	 GSsN06jQv15Wb1Kubj8kCqFQfy+EwTr0Cz6y9fwA8eN/BGhkKKFGKyx3Go3fNnKPBb
	 LIIgowYASPGyx9wMJMXryQkK6+tLRC4mB9Z/xVu+PxZNpdHcCejy6vWfVa+YLmHZHq
	 qHDq6rfeBwnQ2zqbo31yN9v4quCfd6yhetwEufkZJMQ8X9CZJtqPGoiwgZIhIT2LMu
	 onoCsIH0gp4nToM9Bk2hDfcw5Vr54I5fjeiCOCdzccp0aKy4GYHhNYm4lh0SWP9CYS
	 o+JObs9IyxcYQ==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Tue, 14 Jul 2026 18:24:23 +0100
Subject: [PATCH mm-hotfixes v3 1/4] mm/vmalloc: acquire init_mm lock on
 huge vmap to avoid ptdump UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-series-vmap-race-fix-v3-1-b812eccfa0f9@kernel.org>
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
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8523; i=ljs@kernel.org;
 h=from:subject:message-id; bh=VgBPfIW0qO8qs1oxwHrwgRLvaSj1B2gVcQMgBYESrY4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLCCs7tiha8tWCh8hXmja8VyvTW/hJLtH9gx6y5UzlG5
 /zjU886OkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRuZWMDDu8tHbKcesrz70c
 tvrYQcnMFVnlPdv/mseLVBRf5PjaacDwh2PVpMueovPFp83/Wa9+Ly5GxPK6Unu1SRajg3tN3M6
 JDAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10EC510000B
X-Stat-Signature: d8mong5sp1jjmh9dzrzojtzkachf1b9p
X-HE-Tag: 1784049892-921915
X-HE-Meta: U2FsdGVkX1/cj7jBk0ayWC2Ud9QYrX3YmkBwO7hJCQdFBmQ0D5fpDI0/RUqgbYIu1tKdlbwDJQ9v2TyxuhF9fjdGPOoXLonsMAD5ME4h8aHl0QOe5ncvICGadvBPv2ohxwSNHpBMqTdG0fxBxPsUwZzFNIQ7cnE+ftyOnUV1ZxVII3BsYaa3Xhs9zNruSgcKNkz0hdzQtWppkUm1ZjpzbCP/9/qTYqqnqgYjfCfQqOReBm8lw4V/P4EnOsS7VN2nhPfDCOazDFVXnh/JWEtZ1r9Mi74n+h1dH1fi2el40cD0EV6jtTgJoJTjXzIQknjWC/rqG37wo3vO/2q5e9V126pO8k3nry+EpyIug3YmambPvANQKqSDwUDy+yesiT1o8sdrxl0iYIgVPullmAfzA7aza27HARtj0OnwBNsgqXEl5ToQ88zgVy1aZBoJ0Uwh8XzyZ6mOKdcLDMBXTpD7EB8QtxU5qFKEIX1EEbNyDs6JY8JZ10Urj2TTr4NCNfc97KW9gwxa/NejcJfCzg0HtAzF3SR0m0Z7Fptq7SS8IU+Y1l8YuA/llnTSpU91RacFGSLduz1BinAuZYOcxItlaJaLC0F4yBHQ8b/ilNQZfeWSe+eFHhLWh+PB42jNCES1T5EQppF61oip03RKx0AP2X8VcQ85/znvxn7N1nb1ZSi6Y4MwrJv5Mc2i0xdUnXTOv5rfAG/1HuDw950ve9Dwmc7twmcBUP6hv6XcTlrytGNoA8krLS4MvXq2AvRFxniwE21J+9jTyQN4nK+E0jusYtXvtREsSu1UVTAIMGN//QQN3NDj7mmUO9Qd6I3AUW/ERQp/voYyg8vGgiZStiIjlpPskjo0qClmO2uzOgw3EfYtkp8ImetDiqmqtLDSwQtCtHIwGTSsdsgXediRuqDGW6/yVSSrwjdxCyZ2zvx1hBYhIEteZjcWy+OAX1nQTXGvVmvlcr4ekkn1MoDV1Dn
 koDMgtwz
 tz505VhLshsxLtJesfLyu+i5JgGApNBb5Mo6Q3lYy75JwZxtJ8lBMP9rFx7NVtGLJDRpkxFycLVnfbR5f+YnBX2yHoc0CZJnV4xL+apvFFB00AJJN5UzUVr9i1okzR1ziLHXZzYn6alMI5eN/wn1ZCkqsXmZryWz7uByBIV/Pzp54wfcCBxyFy4BcHUYqaPPVgk1KEXAerM2oazIPpOHBFYi6B/WopJ1uLljimVaeDp6usP30wwZmXHJZvCPVyGlIGvenkQoVET6NQq+9im1HHwCob6+9SI3AW7CGv2UYDhGAknmMnC0s8/3INUyZlFUGjhkB1zF4Tb6IJlQrlpkfjmf1rh9K74wbhEeQT/c6sqKtarfy8VA50mcSXUkTpKEg+VpAJ6LO6tYqily/xUkB+7KWrrhKdQWagx9c/WaDbH1aZkJ8KQkOP3NSceSkTuwZkCE4/uK24L0ajQ1jTdO4d8TbuEo0kdgT2lvfJEcGPl8cqlbBRWB9qfd0NsCuIgBHXtlcn7SrxKSEsrXIWGeGwZIl9F9QPjML3zk3O9KvU4tkKr++3q3/Ic3eYy4sG1Jg1nXJ19uzyrCFatDZiiLO/F/5xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently there is a nasty race between ptdump and vmap when attempting to
map a huge P4D, PMD or PUD entry:

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
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/mmap_lock.h |  1 +
 mm/pagewalk.c             | 22 +++++++++++----------
 mm/vmalloc.c              | 50 ++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 54 insertions(+), 19 deletions(-)

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
index 1afca3568b9b..1fa9ac6e43d4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -43,6 +43,7 @@
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 #include <linux/page_owner.h>
+#include <linux/cleanup.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmalloc.h>
@@ -158,10 +159,25 @@ static int vmap_try_huge_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
 	if (!IS_ALIGNED(phys_addr, PMD_SIZE))
 		return 0;
 
-	if (pmd_present(*pmd) && !pmd_free_pte_page(pmd, addr))
-		return 0;
+	if (!pmd_present(*pmd))
+		return pmd_set_huge(pmd, phys_addr, prot);
 
-	return pmd_set_huge(pmd, phys_addr, prot);
+	/*
+	 * Kernel page table walkers either walk ranges they own exclusively or
+	 * hold the mmap write lock on init_mm (ptdump being the motivating
+	 * case).
+	 *
+	 * Therefore, acquire the mmap read lock to prevent use-after-free when
+	 * freeing page tables.
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
@@ -210,10 +226,18 @@ static int vmap_try_huge_pud(pud_t *pud, unsigned long addr, unsigned long end,
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
@@ -262,10 +286,18 @@ static int vmap_try_huge_p4d(p4d_t *p4d, unsigned long addr, unsigned long end,
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


