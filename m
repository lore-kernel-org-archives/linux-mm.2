Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE4D5C44501
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 10:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 385D66B0088; Sun, 12 Jul 2026 06:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 337766B008A; Sun, 12 Jul 2026 06:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D0C6B008C; Sun, 12 Jul 2026 06:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0B836B0088
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 06:44:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A32C92722
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 10:44:25 +0000 (UTC)
X-FDA: 84979790490.26.E13A242
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 93074C0009
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 10:44:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kNSp2fhA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783853063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zpPQrWrhaa9UNndbmcx8A6wGwMbr3pW1qCJ/JB1tuhc=;
	b=u8e3Z6WrSsi8fKkVzjwsq3AtoYzfJnPSE/zeq1X7gNLCBaZyy/L1QPQypyCZ6tF0O6VgPA
	VEl3M6yzq20L+P77dXnMhZMHn7xQ5UbbCQUoYYtvt4746+sCbcCQrlJnHlAZMbrBydmk07
	dpFkbSQTMrzILQpFpXbavsQyGQZFKJI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kNSp2fhA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783853063;
	b=qTbnpVu0MvxYcsaTU+hsVtnwemO2b58jXlln0FcALUxRU2XVnCkdw9WDaOQ6VjKewTvzGQ
	HPuHpzQHdfccxemPVL8l5XFHDsEkLrhDNEfPakAN3kF+AfdbT9ntI5QT+EnaUWX8akfjV9
	2qsc0YbYyjO3eDJbXs4uUc2hE5ltH74=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 17F2F6132C;
	Sun, 12 Jul 2026 10:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026F51F00A3A;
	Sun, 12 Jul 2026 10:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783853062;
	bh=zpPQrWrhaa9UNndbmcx8A6wGwMbr3pW1qCJ/JB1tuhc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kNSp2fhA4GIlbE62mL2Z8FrYKasEjgKZsF3b0rA+28FKqQZrTdfSftLk9RuV+5XrT
	 MunEzauTlLTS+W4xYOlz/qVyH893DoSKzVQb9EuFKWLMtMm3KASZE452GOzwQMeM8o
	 g90c6npA6AIsJG0iErJZgrDBcc6sA92xyw2KrTo5140Ag9MYNfGansJWdTi9UrBDer
	 058eIKu71qMblp/6gcmQXbRLNcI1ouLLReKusTGAY2McMW94EALI4yFtQxj9bAWHkW
	 +BIaHyzuOBeGRDOK7OwfLRmjlnUNtO0baD8QdrGREqBPBk97zlYt6Ya8od9NcmnMjF
	 HTIzsWRwP8fUw==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Sun, 12 Jul 2026 11:42:24 +0100
Subject: [PATCH mm-hotfixes v2 1/4] mm/vmalloc: acquire init_mm lock on
 huge vmap to avoid ptdump UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260712-series-vmap-race-fix-v2-1-ad134cc3a12a@kernel.org>
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
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=10169; i=ljs@kernel.org;
 h=from:subject:message-id; bh=xQodVoiXdDrJKxRsliP+fCQ/22OZXiwGI+7CmkHVdwg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKC8z9IdUf8z3HhZwvamlaVZzaFs66mrXCKzT3Vo62/z
 /vLcBV3lLIwiHExyIopsjz/Ir4/SCRsXucFfzeYOaxMIEMYuDgFYCIFFxgZrhoueHDxzxvO8u1B
 T20YZ3YV6Zv8ttu360Pdm+qbXowbRBj+mRvPe/lkrbD48je5pwUSmf9/u/fPX9bXdoqkDAvnerY
 YBgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 93074C0009
X-Stat-Signature: 7rhw7i1b6jf8wadh6fem1ioetr3htq43
X-HE-Tag: 1783853063-782394
X-HE-Meta: U2FsdGVkX18xFBON4dA5tvqJnO0Ras2rMhP3PbcwPvUwxCECmBk0u5ToLynvG1JjyCF3uOFkhmhYW0br/pQYOXf9xLrPU5M68+N3R94+wCRWAVa/5wtgo+Icf/XLl1hfSA1UzESqLV7OklyEsZ3IbrFlc+B5DZo73wAJ9xSGgeYpcHmWTZZDmXVmvwMa7uCxEHEVrKU9adOzHAoPbf35pWwTDgLeWJg72Um7rMQFmBi0f0xqui42NB3D29lAxasc8ZzjcuIo7pPNmwOehl/Com7QMmL72HcZqq2xiF06E0RwWluqAy7wa7WO0YKI/WO3sL0I8Hku26eXc/NXXMJibOy6Gm0qqlb++0Ci58s9GHiEzMBvo0hUp3kjbN7yCfG9Z1Thvo6KIkaLZfjb7CXGJaDXikC2sTOZab94VN39DovIMucix+zSOROQ8Kcg3Lj85D/yuu5nAgTQcnrOGwL1Ru7R0mGdgfA8r/iBES2tukzfSKkv0Wh1hSMOx8v0R57f2unBsj3PzC6UY0IRaFSY0/8wF3Qc8YAfqVoqF1dzGH89TQ+Zut4BHsvjJ84+fJa0lFvCxn0NpJmJnnylpdXgWkl95dBZygq/mhgsi9kQwOMUZTqzFiMs+aKq9fpdM48DyuP6PIf1S4giwmodSkFZSj20JfgpVKZ9dYJXpRriPaefwPKQo9Z5T+yWV66Hfi/5wbI6WV12Lt3xpGuzSY6eZoPKd7qHT6ftHYlggy1L3c6ZihXBRoAAp0J+8gvMy5RyvX4MqYs2xUkmly6pBwGGtygS7k2ydJMJqJHnKoKgbczdKKG4SL722psvvd6X9LRtd+AaHCvXN5arXgQcMILCdpClYcApkKwLW9EFvRK7b9bxPaneG2dOYHv2g+X7glKLAvb7NV776uaL3AxFoiVGRjX4ObemHBtuZNlDBhOs58GyfngPYbokxFgaAMLqt2Bj24SEUyF62YDNDY99f3o
 MxwemoFM
 6oczP0gEk4hl3xD62X6Q9uf7QqYni7hsM0LnKWeLouQj8WtkPqnZWxrzxehcXgjfH/QFpqBIU+C008Twzr8/GfvhoWBf8pznF962T1bga/Inmz2Q/AQKBuIQzcBVmXB7SoLz3QurntdOemWdKPHjh1AVQfT049ZkzudSVkn4ur6aCaWcXVBEN5p2FkdDfaNty5VhymmnW4mT+3sgSv0BvEXW8WUB50WV+MFeIOG8Nz7q+vBIOwtCim0t8c5ZFAO4nAvzXRn1OLNTwH0KpHibjq6SbK3h41Qz8o8N2VU0pXKtLIajpQIjJJ+PbBK+Ju+4ezoWoIFKI/tFhmIRuBw/4xM64UUQCl0pPlvTjgbeVAwGxWAZtrx5eHpJ+rRtm1w3yCPKVDzYGM/VA7wrxTnTISLx51Vuh8sKvHiMgjSEUeqeqZwtPyQjIzss37i/FOfajhlsWEjYujF+n9Zpb435EWQs4PzrgKccBX0QariMQpAU+9SWVeQdNTInu+naRFcVTg8tvaf+VL2vxAF8YsWo/Ev/Y8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently there is a nasty race between ptdump and vmap when attempting to
map a huge P4D, PMD or PUD entry.

ptdump is invoked by arch code to walk kernel or EFI page tables, either to
output it for debugging purposes, or to assert that there are no
W+X (i.e. executable writable pages) exposed in these ranges.

The feature is enabled generally via CONFIG_PTDUMP (whose implementation is
in mm/ptdump.c), and expose a debugfs interface for it if
CONFIG_PTDUMP_DEBUGFS is defined.

If CONFIG_PTDUMP is enabled, then /sys/kernel/debug/check_wx_pages is
enabled which checks kernel ranges to perform the W+X check. If
CONFIG_DEBUG_WX is enabled, this is done on boot.

(Note that arm32 implements its own page table walker and uses
CONFIG_ARM_DEBUG_WX and CONFIG_ARM_PTDUMP_DEBUGFS for this.)

The EFI implementations vary by architecture, but are not relevant to the
bug, as the issue is when kernel page ranges are walked.

ptdump_walk_pgd() holds both the mem hotplug lock and the mmap write lock
before invoking walk_page_range_debug(), however this runs into an issue
with vmalloc ranges.

When vmap maps a P4D, PUD or a PMD sized range and encounters an existing
P4d/PUD/PMD entry pointing to a PUD/PMD/PTE page table, it invokes
vmap_try_huge_[p4d,pud,pmd]() to try to convert it to a huge page table
mapping if possible.

However, when it does this, it holds no meaningful locks against other
kernel page table walkers, invoking [p4d,pud,pmd]_free_[pud,pmd,pte]_page()
which calls pagetable_free() and pagetable_free_kernel() in
turn (pte_fragment_free() for powerpc).

This means that a use-after-free becomes possible if the ptdump page table
walker happens to be walking a PUD, PMD or PTE page table after it has been
freed.

Since commit 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page
tables"), if CONFIG_ASYNC_KERNEL_PGTABLE_FREE is set,
pagetable_free_kernel() will batch the page table freeing operation,
otherwise it frees the page table directly.

While the KASAN report that syzbot highlighted indicated that the issue
arose in a workqueue introduced by this change, this is coincidental and
the commit did not alter the race which has existed for quite some time.

This patch resolves the issue by simply having
vmap_try_huge_[p4d,pud,pmd]() hold the mmap read lock on init_mm while
invoking [p4d,pud,pmd]_free_[pud,pmd,pte]_page() and
[p4d,pud,pmd]_set_huge().

This way, page table walkers either observe a newly promoted huge
P4D/PUD/PMD leaf entry or the prior PUD/PMD/PTE entry and never get passed
a dangling pointer, whether the page is freed asynchronously or not.

All other kernel page table walkers that touch vmalloc ranges either
exclusively own the memory walked or acquire the mmap lock, so this
correctly excludes those walkers.

We acquire the mmap read lock as a trylock, as this is an optimisation that
is permitted not to succeed, a race is very unlikely, and doing so
eliminates latency sleeping on the lock would have otherwise caused.

We also define a guard class for mmap_read_trylock() so we can use
cleanup.h to make the scope handling cleaner in the implementation.

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

This patch is based on work by David Carlier (linked), with gratitude!

Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
Cc: stable@vger.kernel.org
Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
Link: https://lore.kernel.org/linux-mm/20260706203128.162335-1-devnexen@gmail.com/
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
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


