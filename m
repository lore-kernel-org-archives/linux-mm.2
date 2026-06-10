Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A378BCD98CC
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 23:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFEBD6B0088; Wed, 10 Jun 2026 19:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6516B008C; Wed, 10 Jun 2026 19:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D769F6B0092; Wed, 10 Jun 2026 19:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B87366B0088
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:04:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F55DC18C4
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:04:16 +0000 (UTC)
X-FDA: 84865533312.29.BA60077
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf27.hostedemail.com (Postfix) with ESMTP id 111F64000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:04:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z25CXkF6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781132654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=gBwMtz9+DLq+AWFH1yc42fUL5F6dpw2lBB3kcC3OAl4=;
	b=8CTId0HXJTGF7POvGBO9BDZ6kr1krCkJxefHU7ohhUcumdk2yNHZIl84H9SaBBp7qX9mdD
	RGVe1E/lwAmIpstTPbVJLIyVX48yMBO/QPgyKF+xLQgUQlbOJZONoVMzXsC0n2GjnfNqYG
	89oXLvGt0a+6DG7FWuYVk/Ms1/n2wBI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z25CXkF6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781132654;
	b=d8y0dnEiZGovVcXcgNEJjuhZQshgWKwXqx04tzNOz/fGsP/H0Kg2Bcho36gZK53zCC+9rr
	MQYe7J+ZqpLOlSFeeFf8vvty9Rkm7q9JkpVwnGFKq9GX9/FrRQ1EjDaHn7LOFdfwOYpFVo
	NPb1KmYmenanOjJ3ATcbf+Dq79477qc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781132655; x=1812668655;
  h=subject:to:cc:from:date:references:in-reply-to:
   message-id;
  bh=NrfDJeLaDVFV6BTEzVF69wHPyf8HjvMHexSeh6P9njQ=;
  b=Z25CXkF60ZPgenJ81WXg8UckUfY2lIT2LR373Vm22rJNirNepqJTGEkd
   8QnaZvVWEkjhu/g/GXIx50ZFp+uznzqQpGAvlyR1GVn9pIEiWQr825AYR
   mMETWSec1LWEhpNogxxoxUg1gYDBv8Ct+c20+mg+GyKKs4l4MgqzkSI9P
   meOMDr/MrOuToW/pOMb2UxF54m7FiHP2ePeBM5X5IM83FLDLJODHlAABe
   qnVsj99vmp+7WiVSqn3RdAFPqlNDGwSNRnUO8r7LOfLsEYNJHufpOgeR6
   9NnaFWs/75NYVIw0aYT5v95Yi6TVvnVVJwyxh3J6S0JSk0+9tiGgy+TVS
   g==;
X-CSE-ConnectionGUID: 1TEBHJLnTtOyIqCTP7w+Fg==
X-CSE-MsgGUID: p/xEwpXhQKGVmjeKwxka1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="104603428"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="104603428"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 16:04:13 -0700
X-CSE-ConnectionGUID: BqDqHtuHSkWlVKhHjm+imQ==
X-CSE-MsgGUID: 41bLmpFNQduzLJoIdZqFgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="251409768"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa005.fm.intel.com with ESMTP; 10 Jun 2026 16:04:11 -0700
Subject: [PATCH v2 1/5] mm: Make per-VMA locks available universally
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, Arve Hjønnevåg <arve@android.com>, Carlos Llamas <cmllamas@google.com>, Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Todd Kjos <tkjos@android.com>, Vlastimil Babka <vbabka@kernel.org>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 10 Jun 2026 16:04:11 -0700
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
In-Reply-To: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
Message-Id: <20260610230411.617DD5E7@davehans-spike.ostc.intel.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 111F64000C
X-Stat-Signature: 16e1du7tm51gudfdp9etnf1yenxhh6yp
X-Rspam-User: 
X-HE-Tag: 1781132653-221144
X-HE-Meta: U2FsdGVkX18ZHKIa1jciPRR7I0QXkf+TggYNy7hhYQ8XTFVg71V7eIheBf+5Ycs38okZAf3X3L3r65motucsOjM4wSCfmLQJTw0I4Yn/uQBJEWXylrP1vWWMzN6eqMivZOZkNtONF0MwfxP3XQl44p2Wob4Km7jsd5s5H1ZU8zmaxYzZWHpiNrZyBe+cGxK01TKDUpiRpshWF8HFKvoB2CwzaW/su1bi+7C8kW/wlGMy1dwCjLhOp2wb5Kiz3vSzkksbxrxEP2jnfs+aajINGTYlu/LS7JBYowwpXKTKqgtOlQzMU2dqcSbCpftRijT6iL/KlnrZbCvgsz+Aiy9xSlVpVrlADIlz9k4cMWlJLzvfxv454EM9pxz7h01iKNXs9LoYrOjbLg+SVXqsab3MLgg/t8Y/Dr3hkoUEWMbiDFQ6pCc1TPbyugrumr6D+Txi22J/UP4owEwGuyNWbHJGoewcbIXHvPCQIKjcgc+G2tZe5qOckZD+spa+Qs/mEpHrXDoGLRol7xFUgs3D40qEHomzBLXpFZuEZuyEgUmjF+q2e6YRE0wGBr+BCFb/XAPjer8xmI9ZTWmJC9Yp/nZeZd1b8N8C1xxYw/KZ7EDrYleRhdjbwxmCz0O9SDcVj7wZb10rqel2zZF/86Wl9shLznlPB0CKsev55TWaZZaUt+TxHwZNxQ0y4GdMBuVUAJwnb8qqoAHL+RH0Ha/x1t7J68ocJ01gp9hBv04TuZegbkYwR6Kw5fbB5Vt1Hvq6dKXowdmTUX6uYNaQj5sZwcErdSQF3ckwrlVpgyGk7E1gRDsmGumNsoZrhEfaS83hQQ9J5ysC6Yk8vwTKxI2wu3FxrKZizOsogB4HPd+Dc+NWiMTxijWh8+cTGAnmK1qAId2wFhpilkkSryMm/MwWhtUT9LqV7V4BbusJLnKEsI+wbROYyLuB8nVMs/7gRhFqZpqMwGQvOTbanNhytvKD5oN
 hVY6jwZj
 ecYLeF51cJhwDePJnE/TqckEhIX/EPSc9IEvVu+lI34/JUQmgoSu7R7aR27CDhkNSvGyrZVHEth1eu2siZCjx2oVtY+fnalEj8HhP2RdDO+KKZyDrLoSNMykHtEmzbaruxCg2dCcSa+nbuSwirGPI5SuGASyc0Hi6WP3CWueC6o+B/vl+cFPXxeCqGgg2nOWvFrTsXpXHlayVEHL/ZmALC5C099VFfkqUsnUtrdxz38PnjRyFWUJl/p8CwrZTS49VJRy/B/7tcSqzXOW0+5bgY0ICCgSzuk/rds6ejL6cibBFkXiHDjyXO/qGNsPi9982pVSuxA/fWyIRraJUE+uGonBd6nxUNqgvfDAZGmWFeJEF2z1SK++r4kb7EyajxTSqUHbqs70wY+iETYWv3hsnvXx4XXATNUnQeoAQcu79JTJ69kk6PTsddA8WrTkg5CIWKXzL7lbNHI0rH3R2gZmMWmfJ+Pg/Ht0i2qMc/7U4VEMvKh1+4PubBcYYXSOSQedyS8NN/hEOgp0HQ3rLtJ8uEmaxlftBlPq2lNcNnQV7Bu9w/roUO73gedRZTWkn2o/QjGTrWxt9gBazb56C+wKng7VGhDRQGAeqdlGdLMe88JFzOV38tioXH++Rtd7HcWDssbP9MpUEVmQII/f64aJR4EJNjoScUrl87lyP0jKwF4sYTjTWlxORBt+4Gg==
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
per-VMA locks in common code. Doing *that* brings additional
simplifications.

The downside of this is adding some fields to vm_area_struct and
mm_struct. There are likely ways to optimize this, especially for
things like SMP=n configs. For now, do the simplest thing: use the
same implementation everywhere.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org

--

Changes from v1:
 * Remove a bunch of left over CONFIG_PER_VMA_LOCKs
 * Trim some speculation out of the changelog
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
 b/fs/proc/task_mmu.c                     |   51 ----------------------------
 b/include/linux/mm.h                     |   12 ------
 b/include/linux/mm_types.h               |    7 ---
 b/include/linux/mmap_lock.h              |   48 ---------------------------
 b/kernel/bpf/task_iter.c                 |    5 --
 b/kernel/fork.c                          |    2 -
 b/mm/Kconfig                             |   13 -------
 b/mm/Kconfig.debug                       |    1 
 b/mm/debug.c                             |    4 --
 b/mm/init-mm.c                           |    2 -
 b/mm/memory.c                            |    2 -
 b/mm/mmap_lock.c                         |   24 -------------
 b/mm/pagewalk.c                          |    2 -
 b/mm/rmap.c                              |    2 -
 b/mm/userfaultfd.c                       |   55 -------------------------------
 b/rust/kernel/mm.rs                      |    7 ---
 b/tools/testing/vma/include/dup.h        |    4 --
 b/tools/testing/vma/vma_internal.h       |    1 
 27 files changed, 1 insertion(+), 252 deletions(-)

diff -puN arch/arm64/Kconfig~unconditional-vma-locks arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~unconditional-vma-locks	2026-06-10 15:57:53.491348630 -0700
+++ b/arch/arm64/Kconfig	2026-06-10 15:57:54.069369179 -0700
@@ -80,7 +80,6 @@ config ARM64
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SCHED_SMT
diff -puN arch/arm/Kconfig~unconditional-vma-locks arch/arm/Kconfig
--- a/arch/arm/Kconfig~unconditional-vma-locks	2026-06-10 15:57:53.499348914 -0700
+++ b/arch/arm/Kconfig	2026-06-10 15:57:54.070369215 -0700
@@ -41,7 +41,6 @@ config ARM
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_CFI
 	select ARCH_SUPPORTS_HUGETLBFS if ARM_LPAE
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_RT
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
diff -puN arch/loongarch/Kconfig~unconditional-vma-locks arch/loongarch/Kconfig
--- a/arch/loongarch/Kconfig~unconditional-vma-locks	2026-06-10 15:57:53.542350439 -0700
+++ b/arch/loongarch/Kconfig	2026-06-10 15:57:54.070369215 -0700
@@ -68,7 +68,6 @@ config LOONGARCH
 	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	select ARCH_SUPPORTS_NUMA_BALANCING if NUMA
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SCHED_SMT if SMP
 	select ARCH_SUPPORTS_SCHED_MC  if SMP
diff -puN arch/powerpc/platforms/powernv/Kconfig~unconditional-vma-locks arch/powerpc/platforms/powernv/Kconfig
--- a/arch/powerpc/platforms/powernv/Kconfig~unconditional-vma-locks	2026-06-10 15:57:53.544350510 -0700
+++ b/arch/powerpc/platforms/powernv/Kconfig	2026-06-10 15:57:54.070369215 -0700
@@ -17,7 +17,6 @@ config PPC_POWERNV
 	select PPC_DOORBELL
 	select MMU_NOTIFIER
 	select FORCE_SMP
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
 	default y
 
diff -puN arch/powerpc/platforms/pseries/Kconfig~unconditional-vma-locks arch/powerpc/platforms/pseries/Kconfig
--- a/arch/powerpc/platforms/pseries/Kconfig~unconditional-vma-locks	2026-06-10 15:57:53.552350794 -0700
+++ b/arch/powerpc/platforms/pseries/Kconfig	2026-06-10 15:57:54.070369215 -0700
@@ -23,7 +23,6 @@ config PPC_PSERIES
 	select HOTPLUG_CPU
 	select FORCE_SMP
 	select SWIOTLB
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
 	default y
 
diff -puN arch/riscv/Kconfig~unconditional-vma-locks arch/riscv/Kconfig
--- a/arch/riscv/Kconfig~unconditional-vma-locks	2026-06-10 15:57:53.559351043 -0700
+++ b/arch/riscv/Kconfig	2026-06-10 15:57:54.070369215 -0700
@@ -70,7 +70,6 @@ config RISCV
 	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
-	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if HAVE_SHADOW_CALL_STACK
 	select ARCH_SUPPORTS_SCHED_MC if SMP
diff -puN arch/s390/Kconfig~unconditional-vma-locks arch/s390/Kconfig
--- a/arch/s390/Kconfig~unconditional-vma-locks	2026-06-10 15:57:53.571351470 -0700
+++ b/arch/s390/Kconfig	2026-06-10 15:57:54.071369250 -0700
@@ -153,7 +153,6 @@ config S390
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
-	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_USE_SYM_ANNOTATIONS
diff -puN arch/x86/Kconfig~unconditional-vma-locks arch/x86/Kconfig
--- a/arch/x86/Kconfig~unconditional-vma-locks	2026-06-10 15:57:53.577351684 -0700
+++ b/arch/x86/Kconfig	2026-06-10 15:57:54.071369250 -0700
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
--- a/fs/proc/internal.h~unconditional-vma-locks	2026-06-10 15:57:53.579351755 -0700
+++ b/fs/proc/internal.h	2026-06-10 15:57:54.071369250 -0700
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
--- a/fs/proc/task_mmu.c~unconditional-vma-locks	2026-06-10 15:57:53.594352288 -0700
+++ b/fs/proc/task_mmu.c	2026-06-10 15:57:54.072369286 -0700
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
--- a/include/linux/mmap_lock.h~unconditional-vma-locks	2026-06-10 15:57:53.599352466 -0700
+++ b/include/linux/mmap_lock.h	2026-06-10 15:57:54.072369286 -0700
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
--- a/include/linux/mm.h~unconditional-vma-locks	2026-06-10 15:57:53.745357660 -0700
+++ b/include/linux/mm.h	2026-06-10 15:57:54.073369321 -0700
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
--- a/include/linux/mm_types.h~unconditional-vma-locks	2026-06-10 15:57:53.763358300 -0700
+++ b/include/linux/mm_types.h	2026-06-10 15:57:54.074369357 -0700
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
diff -puN kernel/bpf/task_iter.c~unconditional-vma-locks kernel/bpf/task_iter.c
--- a/kernel/bpf/task_iter.c~unconditional-vma-locks	2026-06-10 15:57:53.773358655 -0700
+++ b/kernel/bpf/task_iter.c	2026-06-10 15:57:54.074369357 -0700
@@ -835,11 +835,6 @@ __bpf_kfunc int bpf_iter_task_vma_new(st
 	BUILD_BUG_ON(sizeof(struct bpf_iter_task_vma_kern) != sizeof(struct bpf_iter_task_vma));
 	BUILD_BUG_ON(__alignof__(struct bpf_iter_task_vma_kern) != __alignof__(struct bpf_iter_task_vma));
 
-	if (!IS_ENABLED(CONFIG_PER_VMA_LOCK)) {
-		kit->data = NULL;
-		return -EOPNOTSUPP;
-	}
-
 	/*
 	 * Reject irqs-disabled contexts including NMI. Operations used
 	 * by _next() and _destroy() (vma_end_read, fput, bpf_iter_mmput_async)
diff -puN kernel/fork.c~unconditional-vma-locks kernel/fork.c
--- a/kernel/fork.c~unconditional-vma-locks	2026-06-10 15:57:53.783359011 -0700
+++ b/kernel/fork.c	2026-06-10 15:57:54.074369357 -0700
@@ -1067,9 +1067,7 @@ static void mmap_init_lock(struct mm_str
 {
 	init_rwsem(&mm->mmap_lock);
 	mm_lock_seqcount_init(mm);
-#ifdef CONFIG_PER_VMA_LOCK
 	rcuwait_init(&mm->vma_writer_wait);
-#endif
 }
 
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
diff -puN mm/debug.c~unconditional-vma-locks mm/debug.c
--- a/mm/debug.c~unconditional-vma-locks	2026-06-10 15:57:53.785359082 -0700
+++ b/mm/debug.c	2026-06-10 15:57:54.075369392 -0700
@@ -157,17 +157,13 @@ void dump_vma(const struct vm_area_struc
 	pr_emerg("vma %px start %px end %px mm %px\n"
 		"prot %lx anon_vma %px vm_ops %px\n"
 		"pgoff %lx file %px private_data %px\n"
-#ifdef CONFIG_PER_VMA_LOCK
 		"refcnt %x\n"
-#endif
 		"flags: %#lx(%pGv)\n",
 		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_mm,
 		(unsigned long)pgprot_val(vma->vm_page_prot),
 		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
 		vma->vm_file, vma->vm_private_data,
-#ifdef CONFIG_PER_VMA_LOCK
 		refcount_read(&vma->vm_refcnt),
-#endif
 		vma->vm_flags, &vma->vm_flags);
 }
 EXPORT_SYMBOL(dump_vma);
diff -puN mm/init-mm.c~unconditional-vma-locks mm/init-mm.c
--- a/mm/init-mm.c~unconditional-vma-locks	2026-06-10 15:57:53.808359899 -0700
+++ b/mm/init-mm.c	2026-06-10 15:57:54.075369392 -0700
@@ -39,10 +39,8 @@ struct mm_struct init_mm = {
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.arg_lock	=  __SPIN_LOCK_UNLOCKED(init_mm.arg_lock),
 	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
-#ifdef CONFIG_PER_VMA_LOCK
 	.vma_writer_wait = __RCUWAIT_INITIALIZER(init_mm.vma_writer_wait),
 	.mm_lock_seq	= SEQCNT_ZERO(init_mm.mm_lock_seq),
-#endif
 	.user_ns	= &init_user_ns,
 #ifdef CONFIG_SCHED_MM_CID
 	.mm_cid.lock = __RAW_SPIN_LOCK_UNLOCKED(init_mm.mm_cid.lock),
diff -puN mm/Kconfig~unconditional-vma-locks mm/Kconfig
--- a/mm/Kconfig~unconditional-vma-locks	2026-06-10 15:57:53.816360183 -0700
+++ b/mm/Kconfig	2026-06-10 15:57:54.075369392 -0700
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
diff -puN mm/Kconfig.debug~unconditional-vma-locks mm/Kconfig.debug
--- a/mm/Kconfig.debug~unconditional-vma-locks	2026-06-10 15:57:53.820360326 -0700
+++ b/mm/Kconfig.debug	2026-06-10 15:57:54.075369392 -0700
@@ -310,7 +310,6 @@ config DEBUG_KMEMLEAK_VERBOSE
 
 config PER_VMA_LOCK_STATS
 	bool "Statistics for per-vma locks"
-	depends on PER_VMA_LOCK
 	help
 	  Say Y here to enable success, retry and failure counters of page
 	  faults handled under protection of per-vma locks. When enabled, the
diff -puN mm/memory.c~unconditional-vma-locks mm/memory.c
--- a/mm/memory.c~unconditional-vma-locks	2026-06-10 15:57:53.830360681 -0700
+++ b/mm/memory.c	2026-06-10 15:57:54.076369428 -0700
@@ -6659,7 +6659,6 @@ static vm_fault_t sanitize_fault_flags(s
 				 !is_cow_mapping(vma->vm_flags)))
 			return VM_FAULT_SIGSEGV;
 	}
-#ifdef CONFIG_PER_VMA_LOCK
 	/*
 	 * Per-VMA locks can't be used with FAULT_FLAG_RETRY_NOWAIT because of
 	 * the assumption that lock is dropped on VM_FAULT_RETRY.
@@ -6668,7 +6667,6 @@ static vm_fault_t sanitize_fault_flags(s
 			(FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)) ==
 			(FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)))
 		return VM_FAULT_SIGSEGV;
-#endif
 
 	return 0;
 }
diff -puN mm/mmap_lock.c~unconditional-vma-locks mm/mmap_lock.c
--- a/mm/mmap_lock.c~unconditional-vma-locks	2026-06-10 15:57:53.834360824 -0700
+++ b/mm/mmap_lock.c	2026-06-10 15:57:54.077369463 -0700
@@ -43,9 +43,6 @@ void __mmap_lock_do_trace_released(struc
 EXPORT_SYMBOL(__mmap_lock_do_trace_released);
 #endif /* CONFIG_TRACING */
 
-#ifdef CONFIG_MMU
-#ifdef CONFIG_PER_VMA_LOCK
-
 /* State shared across __vma_[start, end]_exclude_readers. */
 struct vma_exclude_readers_state {
 	/* Input parameters. */
@@ -431,7 +428,6 @@ fallback:
 
 	return vma;
 }
-#endif /* CONFIG_PER_VMA_LOCK */
 
 #ifdef CONFIG_LOCK_MM_AND_FIND_VMA
 #include <linux/extable.h>
@@ -548,23 +544,3 @@ fail:
 	return NULL;
 }
 #endif /* CONFIG_LOCK_MM_AND_FIND_VMA */
-
-#else /* CONFIG_MMU */
-
-/*
- * At least xtensa ends up having protection faults even with no
- * MMU.. No stack expansion, at least.
- */
-struct vm_area_struct *lock_mm_and_find_vma(struct mm_struct *mm,
-			unsigned long addr, struct pt_regs *regs)
-{
-	struct vm_area_struct *vma;
-
-	mmap_read_lock(mm);
-	vma = vma_lookup(mm, addr);
-	if (!vma)
-		mmap_read_unlock(mm);
-	return vma;
-}
-
-#endif /* CONFIG_MMU */
diff -puN mm/pagewalk.c~unconditional-vma-locks mm/pagewalk.c
--- a/mm/pagewalk.c~unconditional-vma-locks	2026-06-10 15:57:53.851361429 -0700
+++ b/mm/pagewalk.c	2026-06-10 15:57:54.077369463 -0700
@@ -446,7 +446,6 @@ static inline void process_mm_walk_lock(
 static inline void process_vma_walk_lock(struct vm_area_struct *vma,
 					 enum page_walk_lock walk_lock)
 {
-#ifdef CONFIG_PER_VMA_LOCK
 	switch (walk_lock) {
 	case PGWALK_WRLOCK:
 		vma_start_write(vma);
@@ -461,7 +460,6 @@ static inline void process_vma_walk_lock
 		/* PGWALK_RDLOCK is handled by process_mm_walk_lock */
 		break;
 	}
-#endif
 }
 
 /*
diff -puN mm/rmap.c~unconditional-vma-locks mm/rmap.c
--- a/mm/rmap.c~unconditional-vma-locks	2026-06-10 15:57:54.018367366 -0700
+++ b/mm/rmap.c	2026-06-10 15:57:54.077369463 -0700
@@ -260,11 +260,9 @@ static void check_anon_vma_clone(struct
 	/* For the anon_vma to be compatible, it can only be singular. */
 	VM_WARN_ON_ONCE(operation == VMA_OP_MERGE_UNFAULTED &&
 			!list_is_singular(&src->anon_vma_chain));
-#ifdef CONFIG_PER_VMA_LOCK
 	/* Only merging an unfaulted VMA leaves the destination attached. */
 	VM_WARN_ON_ONCE(operation != VMA_OP_MERGE_UNFAULTED &&
 			vma_is_attached(dst));
-#endif
 }
 
 static void maybe_reuse_anon_vma(struct vm_area_struct *dst,
diff -puN mm/userfaultfd.c~unconditional-vma-locks mm/userfaultfd.c
--- a/mm/userfaultfd.c~unconditional-vma-locks	2026-06-10 15:57:54.049368468 -0700
+++ b/mm/userfaultfd.c	2026-06-10 15:57:54.078369499 -0700
@@ -104,7 +104,6 @@ struct vm_area_struct *find_vma_and_prep
 	return vma;
 }
 
-#ifdef CONFIG_PER_VMA_LOCK
 /*
  * uffd_lock_vma() - Lookup and lock vma corresponding to @address.
  * @mm: mm to search vma in.
@@ -164,34 +163,6 @@ static void uffd_mfill_unlock(struct vm_
 	vma_end_read(vma);
 }
 
-#else
-
-static struct vm_area_struct *uffd_mfill_lock(struct mm_struct *dst_mm,
-					      unsigned long dst_start,
-					      unsigned long len)
-{
-	struct vm_area_struct *dst_vma;
-
-	mmap_read_lock(dst_mm);
-	dst_vma = find_vma_and_prepare_anon(dst_mm, dst_start);
-	if (IS_ERR(dst_vma))
-		goto out_unlock;
-
-	if (validate_dst_vma(dst_vma, dst_start + len))
-		return dst_vma;
-
-	dst_vma = ERR_PTR(-ENOENT);
-out_unlock:
-	mmap_read_unlock(dst_mm);
-	return dst_vma;
-}
-
-static void uffd_mfill_unlock(struct vm_area_struct *vma)
-{
-	mmap_read_unlock(vma->vm_mm);
-}
-#endif
-
 static void mfill_put_vma(struct mfill_state *state)
 {
 	if (!state->vma)
@@ -1672,7 +1643,6 @@ out_success:
 	return 0;
 }
 
-#ifdef CONFIG_PER_VMA_LOCK
 static int uffd_move_lock(struct mm_struct *mm,
 			  unsigned long dst_start,
 			  unsigned long src_start,
@@ -1747,31 +1717,6 @@ static void uffd_move_unlock(struct vm_a
 		vma_end_read(dst_vma);
 }
 
-#else
-
-static int uffd_move_lock(struct mm_struct *mm,
-			  unsigned long dst_start,
-			  unsigned long src_start,
-			  struct vm_area_struct **dst_vmap,
-			  struct vm_area_struct **src_vmap)
-{
-	int err;
-
-	mmap_read_lock(mm);
-	err = find_vmas_mm_locked(mm, dst_start, src_start, dst_vmap, src_vmap);
-	if (err)
-		mmap_read_unlock(mm);
-	return err;
-}
-
-static void uffd_move_unlock(struct vm_area_struct *dst_vma,
-			     struct vm_area_struct *src_vma)
-{
-	mmap_assert_locked(src_vma->vm_mm);
-	mmap_read_unlock(dst_vma->vm_mm);
-}
-#endif
-
 /**
  * move_pages - move arbitrary anonymous pages of an existing vma
  * @ctx: pointer to the userfaultfd context
diff -puN rust/kernel/mm.rs~unconditional-vma-locks rust/kernel/mm.rs
--- a/rust/kernel/mm.rs~unconditional-vma-locks	2026-06-10 15:57:54.051368539 -0700
+++ b/rust/kernel/mm.rs	2026-06-10 15:57:54.078369499 -0700
@@ -174,7 +174,6 @@ impl MmWithUser {
     /// When per-vma locks are disabled, this always returns `None`.
     #[inline]
     pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> Option<VmaReadGuard<'_>> {
-        #[cfg(CONFIG_PER_VMA_LOCK)]
         {
             // SAFETY: Calling `bindings::lock_vma_under_rcu` is always okay given an mm where
             // `mm_users` is non-zero.
@@ -188,12 +187,6 @@ impl MmWithUser {
                 });
             }
         }
-
-        // Silence warnings about unused variables.
-        #[cfg(not(CONFIG_PER_VMA_LOCK))]
-        let _ = vma_addr;
-
-        None
     }
 
     /// Lock the mmap read lock.
diff -puN tools/testing/vma/include/dup.h~unconditional-vma-locks tools/testing/vma/include/dup.h
--- a/tools/testing/vma/include/dup.h~unconditional-vma-locks	2026-06-10 15:57:54.064369001 -0700
+++ b/tools/testing/vma/include/dup.h	2026-06-10 15:57:54.078369499 -0700
@@ -569,7 +569,6 @@ struct vm_area_struct {
 		vma_flags_t flags;
 	};
 
-#ifdef CONFIG_PER_VMA_LOCK
 	/*
 	 * Can only be written (using WRITE_ONCE()) while holding both:
 	 *  - mmap_lock (in write mode)
@@ -585,7 +584,6 @@ struct vm_area_struct {
 	 * slowpath.
 	 */
 	unsigned int vm_lock_seq;
-#endif
 
 	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
@@ -618,10 +616,8 @@ struct vm_area_struct {
 #ifdef CONFIG_NUMA_BALANCING
 	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
 #endif
-#ifdef CONFIG_PER_VMA_LOCK
 	/* Unstable RCU readers are allowed to read this. */
 	refcount_t vm_refcnt;
-#endif
 	/*
 	 * For areas with an address space and backing store,
 	 * linkage into the address_space->i_mmap interval tree.
diff -puN tools/testing/vma/vma_internal.h~unconditional-vma-locks tools/testing/vma/vma_internal.h
--- a/tools/testing/vma/vma_internal.h~unconditional-vma-locks	2026-06-10 15:57:54.066369072 -0700
+++ b/tools/testing/vma/vma_internal.h	2026-06-10 15:57:54.078369499 -0700
@@ -15,7 +15,6 @@
 #include <stdlib.h>
 
 #define CONFIG_MMU
-#define CONFIG_PER_VMA_LOCK
 
 #ifdef __CONCAT
 #undef __CONCAT
_

