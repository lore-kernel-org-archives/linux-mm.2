Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE06FCCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63D876B0088; Wed, 29 Apr 2026 14:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615336B008A; Wed, 29 Apr 2026 14:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52AC46B008C; Wed, 29 Apr 2026 14:20:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3451E6B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:20:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E760A1B894D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:19:59 +0000 (UTC)
X-FDA: 84712407318.22.8D308FB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf20.hostedemail.com (Postfix) with ESMTP id B815F1C0010
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:19:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hSBCFGOL;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777486798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=SR03HGSss6vHoqowDiaIS4XYKnKkBStazKwzHh53u8U=;
	b=pYK1FWpt9qSHmjux8FK7p+ltziZI8tAg/GbH4JzibV0SZmMMfxqtYnhNr4PuwTZYiLS44q
	/0wXWryVYdi4Xq8oA5V9pFxtczwrLrpQ7pbWhzmSHjAoI13K/qQlreRkSI5cnezskLfPnl
	JYI0BfE9AFmRRteZdltarJXGr/TqcwI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hSBCFGOL;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777486798; a=rsa-sha256;
	cv=none;
	b=Wpm9kU9nwkWbSc9PSJWGQty9BU0Gz/CC3/KEhgpJLCJ+wV1hlWk4f3R+uoepUCVYgcFT0t
	7FoPed2wdge0TTwbEwSckGwd3d02lbHF348tDPFzUWPrGXJYcdzghT1BJVsdLSUcwK77iu
	DHO6WPnX+PoC842s7JiSnS2DUiRYYCA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777486798; x=1809022798;
  h=subject:to:cc:from:date:references:in-reply-to:
   message-id;
  bh=un+pifbBsTc6JbIPkyaX7lb0emhMOKFM+/ruKLV0yA0=;
  b=hSBCFGOLZyB3jNcN1CU1kHfsLxdeNrjImEOJiudtFVULdUI9PKORMfYS
   a7XhBKkC7jV8DOSiBAKiVDltnKVu8FQJy2NRun5s7sIqaI6Wegx63M456
   GKBLXPL+hV92e/oQiHXckq571c9euTbVHXyivT5aF0KT4jAUvMG6a3l70
   0NpinSsmLoPBmXDdfYhR0wM6tMvlFXdVTk3EgDwpnuhZwa9c1j8RP+JEL
   HD39EEnIvXnnWNMGXrMRL1DE8uYqeurkuHqpsb2jNEIpPzkvSWUkp+Yum
   8UshSlpI/THjULCbEDQL8vP/LorIuN43QTCRNy4lWDKUt1Zh3LplebvZw
   w==;
X-CSE-ConnectionGUID: XtBCV/3fQrumyn3WHUVKAA==
X-CSE-MsgGUID: crMF+qC2QEi1ul0aiH070Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="95990092"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="95990092"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:19:56 -0700
X-CSE-ConnectionGUID: gunGUiJ1R4KizrtWzx51iw==
X-CSE-MsgGUID: Q27R8zmkQUWzuTFiT12jKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="239336386"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa005.fm.intel.com with ESMTP; 29 Apr 2026 11:19:56 -0700
Subject: [PATCH 1/6] mm: Make per-VMA locks available universally
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 29 Apr 2026 11:19:55 -0700
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
In-Reply-To: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
Message-Id: <20260429181955.0C443845@davehans-spike.ostc.intel.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B815F1C0010
X-Rspamd-Server: rspam06
X-Stat-Signature: 77qpfjufj4w98etosp9pykppyxuknecd
X-HE-Tag: 1777486797-153367
X-HE-Meta: U2FsdGVkX195azTDLsJkH2wnaIi0QcEZQjvXLp1HeXQJz2crHVW6E2njfz5jSSB5RWyk+LUOGMtNR1SZaIsXhnSQzYN8iF/pRf2V4AxFrqJ0sD452+JeG0Y6AfJY6w0SN05YDrcWrw9vxuxuaGIoY/mDQsRwHRCttJAv1nMOUpxY+bhiTwcvE/kFl6DhaYM67sZtomFMBDg5OnsCxtnGJLjrR7ROV/pnR7/km9Q6UBrAR06PTebxMWHlUP/PDx83xtcXsfHFo4yaFhVYq/HIRHvhgK/9CADUkGh8MGWohA7hffjexT8pV1uGReT/tHh6xfEimNGZ9H09B3iRY4oQeKLRDcpgH0Llz8ChsSWsiq2BpcUtRQsQcG9AvqxdZ3P4KMF1Emc3BMAgDYtlYIVHf/FLkkFLuTecAUjUlbMi9eQxMmPHSIHmPR7VE5tdgZHtJSZhbYiu0JwU04HTybWUbl3zoHmV2InjvmOZmf4ZyOsPdfHEnoXvqNLDR7x2OnCcuR1wGuh+LsaX8RJnHuySbCy0FFvcvvLTFi2f2MWrjPAmuOm/u1q4rCTAp9c+w0dfliJhJjl9UXEWEjOaNme/xL9RP1ls2aGWW++ggyVKQ9Mv2V3NlcvLG37pqPa33xDy+IF6ampGFq/jXZEt8SO7sP0oH1jgkp58Nmt3ostodIN7wtUuRTDp+a9B2UqNutwBxEYbgs97AVb5FC+Z6IcmaACG/UjrDxzAmPLZqoH/z4KQlU5MLUEBQHKLyVCw0t0U3Qat8DaWQ25kDs32mDiCnKyl0K5JrVKjz7deI15RL2LAM+iAJ/vobeR2ttVV+NS0eq6iCPVn0xfdzdbtwDi4FQF0HvljqsBD7CZf8VJw+Xn8JX6Y+1D0DeiY05RlbmCl3cU0tPJMALDP5xSvd/Q+SXf48u2yz4laP0RgR8lQMI8CER+DQS9hLNaVclihcZBs4Za+NpTU1kAiZ5ep8B2
 aG+hSkBi
 5pwiR396CcPPzyEJAtM79Gc7VruZjeT3pPbb8AgaW0Iw6W8vV2pvgc0i0G4otYJjUVtXUQf5eDT+TrndQIwkFNbEsdbf8KK/wOWYVVKT6v5M0vTz3RnYRYAETQ+UTTa5hZY7FxvMhAUfZVGDEn4Owziw0f12sB11MtX/J2LvaT4YKQwU/1db/Y/+lQnsuirwKQusgnlchRJyCzicbYc+xh/AO9HCMW+5v9x1kLrP+mK/kxp2FafIkotDHTs7yqQLwUKwgAxJee0WIleOBzizkx3iSOGMHoCkK/9xoagvDOVqTeiD7ESzLSAZ/HXG7vHCrTwst+jhUDbPcUnnyQReSYavF6GS6bqzh0tKxfhVFLB6Q331xJ9Mjk/KwG3dWoFSGs94Ve72+UvTq1+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


From: Dave Hansen <dave.hansen@linux.intel.com>

The per-VMA locks have been around for several years. They've had some
bugs worked out of them and have seen quite wide use. However, they
are still only available when architectures explicitly enable them.
Remove the conditional compilation around the per-VMA locks, making
them available on all architectures and configs.

The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
when the architecture started using per-VMA locks in the fault
handler. But, contrary to the naming, the Kconfig option does not
really indicate whether the architecture supports per-VMA locks or
not. It is more of a marker for whether the architecture is likely to
benefit from per-VMA locks.

To me, the most important thing side-effect of universal availability
is letting per-VMA locks be used in SMP=n configs. This lets us use
per-VMA locking in all x86 code without fallbacks.

Overall, this just generally makes the kernel simpler. Just look at
the diffstat. It also opens the door to users that want to use the
per-VMA locks in common code. Doing *that* can bring additional
simplifications.

The downside of this is adding some fields to vm_area_struct and
mm_struct. I suspect there are some very simple ways to implement the
per-VMA locks that don't require any additional fields, especially if
such an approach was limited to SMP=n configs*. For now, do the
simplest thing: use the same implementation everywhere.

 * For example, since SMP=n configs don't care much about scalability or
   false sharing, there could be a single, global VMA seqcount that is
   bumped when any VMA is modified instead of having space in each VMA
   for a seqcount.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
---

 b/arch/arm/Kconfig                       |    1 
 b/arch/arm64/Kconfig                     |    1 
 b/arch/loongarch/Kconfig                 |    1 
 b/arch/powerpc/platforms/powernv/Kconfig |    1 
 b/arch/powerpc/platforms/pseries/Kconfig |    1 
 b/arch/riscv/Kconfig                     |    1 
 b/arch/s390/Kconfig                      |    1 
 b/arch/x86/Kconfig                       |    2 -
 b/fs/proc/internal.h                     |    2 -
 b/fs/proc/task_mmu.c                     |   51 -------------------------------
 b/include/linux/mm.h                     |   12 -------
 b/include/linux/mm_types.h               |    7 ----
 b/include/linux/mmap_lock.h              |   48 -----------------------------
 b/kernel/fork.c                          |    2 -
 b/mm/Kconfig                             |   13 -------
 b/mm/mmap_lock.c                         |    2 -
 16 files changed, 1 insertion(+), 145 deletions(-)

diff -puN arch/arm64/Kconfig~unconditional-vma-locks arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~unconditional-vma-locks	2026-04-29 11:18:47.795519653 -0700
+++ b/arch/arm64/Kconfig	2026-04-29 11:18:49.088569421 -0700
@@ -80,7 +80,6 @@ config ARM64
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SCHED_SMT
diff -puN arch/arm/Kconfig~unconditional-vma-locks arch/arm/Kconfig
--- a/arch/arm/Kconfig~unconditional-vma-locks	2026-04-29 11:18:47.915524272 -0700
+++ b/arch/arm/Kconfig	2026-04-29 11:18:49.088569421 -0700
@@ -41,7 +41,6 @@ config ARM
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_CFI
 	select ARCH_SUPPORTS_HUGETLBFS if ARM_LPAE
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_RT
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
diff -puN arch/loongarch/Kconfig~unconditional-vma-locks arch/loongarch/Kconfig
--- a/arch/loongarch/Kconfig~unconditional-vma-locks	2026-04-29 11:18:47.956525850 -0700
+++ b/arch/loongarch/Kconfig	2026-04-29 11:18:49.088569421 -0700
@@ -68,7 +68,6 @@ config LOONGARCH
 	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	select ARCH_SUPPORTS_NUMA_BALANCING if NUMA
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SCHED_SMT if SMP
 	select ARCH_SUPPORTS_SCHED_MC  if SMP
diff -puN arch/powerpc/platforms/powernv/Kconfig~unconditional-vma-locks arch/powerpc/platforms/powernv/Kconfig
--- a/arch/powerpc/platforms/powernv/Kconfig~unconditional-vma-locks	2026-04-29 11:18:47.969526350 -0700
+++ b/arch/powerpc/platforms/powernv/Kconfig	2026-04-29 11:18:49.089569460 -0700
@@ -17,7 +17,6 @@ config PPC_POWERNV
 	select PPC_DOORBELL
 	select MMU_NOTIFIER
 	select FORCE_SMP
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
 	default y
 
diff -puN arch/powerpc/platforms/pseries/Kconfig~unconditional-vma-locks arch/powerpc/platforms/pseries/Kconfig
--- a/arch/powerpc/platforms/pseries/Kconfig~unconditional-vma-locks	2026-04-29 11:18:47.972526466 -0700
+++ b/arch/powerpc/platforms/pseries/Kconfig	2026-04-29 11:18:49.089569460 -0700
@@ -23,7 +23,6 @@ config PPC_PSERIES
 	select HOTPLUG_CPU
 	select FORCE_SMP
 	select SWIOTLB
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
 	default y
 
diff -puN arch/riscv/Kconfig~unconditional-vma-locks arch/riscv/Kconfig
--- a/arch/riscv/Kconfig~unconditional-vma-locks	2026-04-29 11:18:48.060529854 -0700
+++ b/arch/riscv/Kconfig	2026-04-29 11:18:49.089569460 -0700
@@ -70,7 +70,6 @@ config RISCV
 	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
-	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if HAVE_SHADOW_CALL_STACK
 	select ARCH_SUPPORTS_SCHED_MC if SMP
diff -puN arch/s390/Kconfig~unconditional-vma-locks arch/s390/Kconfig
--- a/arch/s390/Kconfig~unconditional-vma-locks	2026-04-29 11:18:48.125532357 -0700
+++ b/arch/s390/Kconfig	2026-04-29 11:18:49.089569460 -0700
@@ -153,7 +153,6 @@ config S390
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_USE_SYM_ANNOTATIONS
diff -puN arch/x86/Kconfig~unconditional-vma-locks arch/x86/Kconfig
--- a/arch/x86/Kconfig~unconditional-vma-locks	2026-04-29 11:18:48.128532472 -0700
+++ b/arch/x86/Kconfig	2026-04-29 11:18:49.090569499 -0700
@@ -27,7 +27,6 @@ config X86_64
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_SOFT_DIRTY
 	select MODULES_USE_ELF_RELA
@@ -1885,7 +1884,6 @@ config X86_USER_SHADOW_STACK
 	bool "X86 userspace shadow stack"
 	depends on AS_WRUSS
 	depends on X86_64
-	depends on PER_VMA_LOCK
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_USER_SHADOW_STACK
 	select X86_CET
diff -puN fs/proc/internal.h~unconditional-vma-locks fs/proc/internal.h
--- a/fs/proc/internal.h~unconditional-vma-locks	2026-04-29 11:18:48.305539283 -0700
+++ b/fs/proc/internal.h	2026-04-29 11:18:49.090569499 -0700
@@ -382,10 +382,8 @@ struct mem_size_stats;
 
 struct proc_maps_locking_ctx {
 	struct mm_struct *mm;
-#ifdef CONFIG_PER_VMA_LOCK
 	bool mmap_locked;
 	struct vm_area_struct *locked_vma;
-#endif
 };
 
 struct proc_maps_private {
diff -puN fs/proc/task_mmu.c~unconditional-vma-locks fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~unconditional-vma-locks	2026-04-29 11:18:48.346540861 -0700
+++ b/fs/proc/task_mmu.c	2026-04-29 11:18:49.090569499 -0700
@@ -130,8 +130,6 @@ static void release_task_mempolicy(struc
 }
 #endif
 
-#ifdef CONFIG_PER_VMA_LOCK
-
 static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
 {
 	lock_ctx->locked_vma = NULL;
@@ -213,33 +211,6 @@ static inline bool fallback_to_mmap_lock
 	return true;
 }
 
-#else /* CONFIG_PER_VMA_LOCK */
-
-static inline bool lock_vma_range(struct seq_file *m,
-				  struct proc_maps_locking_ctx *lock_ctx)
-{
-	return mmap_read_lock_killable(lock_ctx->mm) == 0;
-}
-
-static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
-{
-	mmap_read_unlock(lock_ctx->mm);
-}
-
-static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
-					   loff_t last_pos)
-{
-	return vma_next(&priv->iter);
-}
-
-static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
-					 loff_t pos)
-{
-	return false;
-}
-
-#endif /* CONFIG_PER_VMA_LOCK */
-
 static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
@@ -527,8 +498,6 @@ static int pid_maps_open(struct inode *i
 		PROCMAP_QUERY_VMA_FLAGS				\
 )
 
-#ifdef CONFIG_PER_VMA_LOCK
-
 static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
 {
 	reset_lock_ctx(lock_ctx);
@@ -581,26 +550,6 @@ static struct vm_area_struct *query_vma_
 	return vma;
 }
 
-#else /* CONFIG_PER_VMA_LOCK */
-
-static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
-{
-	return mmap_read_lock_killable(lock_ctx->mm);
-}
-
-static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
-{
-	mmap_read_unlock(lock_ctx->mm);
-}
-
-static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
-						     unsigned long addr)
-{
-	return find_vma(lock_ctx->mm, addr);
-}
-
-#endif  /* CONFIG_PER_VMA_LOCK */
-
 static struct vm_area_struct *query_matching_vma(struct proc_maps_locking_ctx *lock_ctx,
 						 unsigned long addr, u32 flags)
 {
diff -puN include/linux/mmap_lock.h~unconditional-vma-locks include/linux/mmap_lock.h
--- a/include/linux/mmap_lock.h~unconditional-vma-locks	2026-04-29 11:18:48.700554487 -0700
+++ b/include/linux/mmap_lock.h	2026-04-29 11:18:49.091569537 -0700
@@ -76,8 +76,6 @@ static inline void mmap_assert_write_loc
 	rwsem_assert_held_write(&mm->mmap_lock);
 }
 
-#ifdef CONFIG_PER_VMA_LOCK
-
 #ifdef CONFIG_LOCKDEP
 #define __vma_lockdep_map(vma) (&vma->vmlock_dep_map)
 #else
@@ -484,52 +482,6 @@ struct vm_area_struct *lock_next_vma(str
 				     struct vma_iterator *iter,
 				     unsigned long address);
 
-#else /* CONFIG_PER_VMA_LOCK */
-
-static inline void mm_lock_seqcount_init(struct mm_struct *mm) {}
-static inline void mm_lock_seqcount_begin(struct mm_struct *mm) {}
-static inline void mm_lock_seqcount_end(struct mm_struct *mm) {}
-
-static inline bool mmap_lock_speculate_try_begin(struct mm_struct *mm, unsigned int *seq)
-{
-	return false;
-}
-
-static inline bool mmap_lock_speculate_retry(struct mm_struct *mm, unsigned int seq)
-{
-	return true;
-}
-static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt) {}
-static inline void vma_end_read(struct vm_area_struct *vma) {}
-static inline void vma_start_write(struct vm_area_struct *vma) {}
-static inline __must_check
-int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
-static inline void vma_assert_write_locked(struct vm_area_struct *vma)
-		{ mmap_assert_write_locked(vma->vm_mm); }
-static inline void vma_assert_attached(struct vm_area_struct *vma) {}
-static inline void vma_assert_detached(struct vm_area_struct *vma) {}
-static inline void vma_mark_attached(struct vm_area_struct *vma) {}
-static inline void vma_mark_detached(struct vm_area_struct *vma) {}
-
-static inline struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
-		unsigned long address)
-{
-	return NULL;
-}
-
-static inline void vma_assert_locked(struct vm_area_struct *vma)
-{
-	mmap_assert_locked(vma->vm_mm);
-}
-
-static inline void vma_assert_stabilised(struct vm_area_struct *vma)
-{
-	/* If no VMA locks, then either mmap lock suffices to stabilise. */
-	mmap_assert_locked(vma->vm_mm);
-}
-
-#endif /* CONFIG_PER_VMA_LOCK */
-
 static inline void mmap_write_lock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_start_locking(mm, true);
diff -puN include/linux/mm.h~unconditional-vma-locks include/linux/mm.h
--- a/include/linux/mm.h~unconditional-vma-locks	2026-04-29 11:18:48.714555026 -0700
+++ b/include/linux/mm.h	2026-04-29 11:18:49.091569537 -0700
@@ -890,7 +890,6 @@ static inline void vma_numab_state_free(
  * These must be here rather than mmap_lock.h as dependent on vm_fault type,
  * declared in this header.
  */
-#ifdef CONFIG_PER_VMA_LOCK
 static inline void release_fault_lock(struct vm_fault *vmf)
 {
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK)
@@ -906,17 +905,6 @@ static inline void assert_fault_locked(c
 	else
 		mmap_assert_locked(vmf->vma->vm_mm);
 }
-#else
-static inline void release_fault_lock(struct vm_fault *vmf)
-{
-	mmap_read_unlock(vmf->vma->vm_mm);
-}
-
-static inline void assert_fault_locked(const struct vm_fault *vmf)
-{
-	mmap_assert_locked(vmf->vma->vm_mm);
-}
-#endif /* CONFIG_PER_VMA_LOCK */
 
 static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
 {
diff -puN include/linux/mm_types.h~unconditional-vma-locks include/linux/mm_types.h
--- a/include/linux/mm_types.h~unconditional-vma-locks	2026-04-29 11:18:48.761556836 -0700
+++ b/include/linux/mm_types.h	2026-04-29 11:18:49.092569576 -0700
@@ -959,7 +959,6 @@ struct vm_area_struct {
 		vma_flags_t flags;
 	};
 
-#ifdef CONFIG_PER_VMA_LOCK
 	/*
 	 * Can only be written (using WRITE_ONCE()) while holding both:
 	 *  - mmap_lock (in write mode)
@@ -975,7 +974,7 @@ struct vm_area_struct {
 	 * slowpath.
 	 */
 	unsigned int vm_lock_seq;
-#endif
+
 	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
 	 * list, after a COW of one of the file pages.	A MAP_SHARED vma
@@ -1007,7 +1006,6 @@ struct vm_area_struct {
 #ifdef CONFIG_NUMA_BALANCING
 	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
 #endif
-#ifdef CONFIG_PER_VMA_LOCK
 	/*
 	 * Used to keep track of firstly, whether the VMA is attached, secondly,
 	 * if attached, how many read locks are taken, and thirdly, if the
@@ -1050,7 +1048,6 @@ struct vm_area_struct {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map vmlock_dep_map;
 #endif
-#endif
 	/*
 	 * For areas with an address space and backing store,
 	 * linkage into the address_space->i_mmap interval tree.
@@ -1249,7 +1246,6 @@ struct mm_struct {
 					  * init_mm.mmlist, and are protected
 					  * by mmlist_lock
 					  */
-#ifdef CONFIG_PER_VMA_LOCK
 		struct rcuwait vma_writer_wait;
 		/*
 		 * This field has lock-like semantics, meaning it is sometimes
@@ -1269,7 +1265,6 @@ struct mm_struct {
 		 * mmap_lock.
 		 */
 		seqcount_t mm_lock_seq;
-#endif
 #ifdef CONFIG_FUTEX_PRIVATE_HASH
 		struct mutex			futex_hash_lock;
 		struct futex_private_hash	__rcu *futex_phash;
diff -puN kernel/fork.c~unconditional-vma-locks kernel/fork.c
--- a/kernel/fork.c~unconditional-vma-locks	2026-04-29 11:18:48.774557336 -0700
+++ b/kernel/fork.c	2026-04-29 11:18:49.092569576 -0700
@@ -1067,9 +1067,7 @@ static void mmap_init_lock(struct mm_str
 {
 	init_rwsem(&mm->mmap_lock);
 	mm_lock_seqcount_init(mm);
-#ifdef CONFIG_PER_VMA_LOCK
 	rcuwait_init(&mm->vma_writer_wait);
-#endif
 }
 
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
diff -puN mm/Kconfig~unconditional-vma-locks mm/Kconfig
--- a/mm/Kconfig~unconditional-vma-locks	2026-04-29 11:18:48.838559801 -0700
+++ b/mm/Kconfig	2026-04-29 11:18:49.093569614 -0700
@@ -1394,19 +1394,6 @@ config LRU_GEN_STATS
 config LRU_GEN_WALKS_MMU
 	def_bool y
 	depends on LRU_GEN && ARCH_HAS_HW_PTE_YOUNG
-# }
-
-config ARCH_SUPPORTS_PER_VMA_LOCK
-       def_bool n
-
-config PER_VMA_LOCK
-	def_bool y
-	depends on ARCH_SUPPORTS_PER_VMA_LOCK && MMU && SMP
-	help
-	  Allow per-vma locking during page fault handling.
-
-	  This feature allows locking each virtual memory area separately when
-	  handling page faults instead of taking mmap_lock.
 
 config LOCK_MM_AND_FIND_VMA
 	bool
diff -puN mm/mmap_lock.c~unconditional-vma-locks mm/mmap_lock.c
--- a/mm/mmap_lock.c~unconditional-vma-locks	2026-04-29 11:18:49.084569267 -0700
+++ b/mm/mmap_lock.c	2026-04-29 11:18:49.093569614 -0700
@@ -44,7 +44,6 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_relea
 #endif /* CONFIG_TRACING */
 
 #ifdef CONFIG_MMU
-#ifdef CONFIG_PER_VMA_LOCK
 
 /* State shared across __vma_[start, end]_exclude_readers. */
 struct vma_exclude_readers_state {
@@ -431,7 +430,6 @@ fallback:
 
 	return vma;
 }
-#endif /* CONFIG_PER_VMA_LOCK */
 
 #ifdef CONFIG_LOCK_MM_AND_FIND_VMA
 #include <linux/extable.h>
_

