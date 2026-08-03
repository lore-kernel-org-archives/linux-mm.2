Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC8B4C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B7716B0095; Mon,  3 Aug 2026 09:19:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968626B009D; Mon,  3 Aug 2026 09:19:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A0E6B00A4; Mon,  3 Aug 2026 09:19:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 308496B0095
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:19:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 323A5A200C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:49:41 +0000 (UTC)
X-FDA: 85059637362.01.6820AE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5D99FA0003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:49:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H2yDPgA7;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785754179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/PLpcyYBrSEBbRUVRP44LDnHIuTSuNa8np8+P5gRTLM=;
	b=uRhSXG3Di967XKaK0/stOdcHpxFRPDc4DjVg8jvmqQ7lpRn3JGL3wYC8hq4zXDOIiu54VX
	akz2d7h6IWthMiihQJ0Obz3OgQisJqrngLJckK5qbHSatNMyTCnWGLvT1YjjQl7Hnk3vn3
	1qvphP4AE8m65eiLsb8V3hPbUwEn838=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H2yDPgA7;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785754179;
	b=KW0Y7RApm/s01g5B65fJQkUccv71oCLbWV2vW45Spf49FHgRsse6ly2ctvB+yYAN5WjnFi
	/j3gL0ABvQ6pf1/TEg71zKG4RbEnVW5275CN707uw5Sj6/Rmy+Ncuxsta/qSt23zY9h6TA
	hRgoGxJtrL2Nan/M4x6CFKuY4T7x0ew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7AC343C36;
	Mon,  3 Aug 2026 10:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4E81F000E9;
	Mon,  3 Aug 2026 10:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785754177;
	bh=/PLpcyYBrSEBbRUVRP44LDnHIuTSuNa8np8+P5gRTLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H2yDPgA7UjMHOEAUOMfYH1PaSsyWOmUuHxz7GmBqq9XRdLbcyvY9IF6ZMyPOxXoLN
	 1M4WabL7LPEhJb3TaaWOWcm3wv/Nruzzxk1YrHL5HaSYxGRwWGWPXGkNCmi4Bg26eD
	 Mfyz7R2br2b+tk97dqpIRKaknd0LknMecpItnVO+ANo5pD+TnCtlpjmYtc99qb1kjN
	 6p8vtVw+uQKYlyUcBeWfoxAay4TGA/bmxL/kkzy837CnpaR8cx5J+I9nZYf4Xq8XHJ
	 Usdr1BJqoh1VnF+rjbBMzOJmJJW+Ca20DD6Ufv964P/XY+16OSRpqt3yViD+dzufGn
	 Gcxn5yPYC2XxA==
Date: Mon, 3 Aug 2026 11:49:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/5] mm: Make per-VMA locks available universally
Message-ID: <anBx8wbp4a_cvbQ2@lucifer>
References: <20260802215459.2769283-1-surenb@google.com>
 <20260802215459.2769283-2-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260802215459.2769283-2-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5D99FA0003
X-Stat-Signature: c6nknbdbamskzrf3gik9mk4cxq7he3y7
X-HE-Tag: 1785754179-484220
X-HE-Meta: U2FsdGVkX1+oV0LvcMIe1rTnLJlNShVU7fuVS+SiQgY2Xcn7M6RVDqF3N3eJS/CUtd43FJeyDZtNcIx5k94OadhzP2TaCjva25ok3y4TslJ8x6kEnZ7O1MtlKqvzCOl1dWDCu1IfOcgx2KuuoLm26tijcJraF2oBx3XoZzbzcQR8EMJWJE3EiBWg3tLQk/0OikFHlPq6nKFrUBe0Qlnx30ghkpOLLm3EwvFAeYhYhbjE/tmQQa6V/dSJHV7MK7+w1FyQsPnE58Z3FS6JTHX7r5EAluK3zfVZeWp+LLQa1CQm8sbS2H/LeYFdVXWmA2z0ARtgIHHZb8r/+RZOWxcYs/PY5973PePzRLAhJ8sg6h13Ite6hCSYw8MgPc2uFXBFhbD8hw/J6GNRzp01IVYv/KsDHhs2Glihva0SPWWm9emRSWIKPKwjeXYhyRdQwLnDE0Wm0hlSEsXckLdGfVXvtDc5y8XC0A8oWBkLUkGKc5ow3aI9JwY3l5531rSas0jNF1JBRAfPQQzKOYdf2ltqzeZ+/BukFpXDfLXEXoEPYfcO5B9mfr92AILEoTPfCazsXNFADF1/fCSUNpVzhu7TKiRm31P7spIf3I2GXw2jHw5Es+dqEHCAgxX0Hsf93KKWLFnkwRvm3ZBi75lLakJ/iffACcb2CXj8hCMG/qLeGH9tOoqMp7l4X4jfot7cVKb08SM+Ht2EUWI2FlGp+k6lSjUUwZw+8BPRCFfug5wJg15SHIil3yXQnwe5Q6zacGr8KjZn35I8/EJj1l+QCidpQVnXxZrnm/TeVIAEQI47VuaPqMpGkc0AnPyuNpi8NcKcLF2azBBN+EHjTadBfLUnmNiyUcaKyHl+SOPdODcTHT3ubEJQF9uY3iKJy1Iqiw8vzD5Z0NDH+3pbq2vU1mhUGWXcuMTljKSDSvIU3vu3vUpwF00jDQdCYI8x4eGxz68Pm1dOjGnP1J47sNkRmJx
 GehDBrqr
 CJIDo8GMcpLbV/UrFROefRJfrNEsE61SnaE5jdPsuVB9toUIrLFthxaFIMsOoJ7gThOxxsyCJ+9svN/HerqcWo1TRJtDKs9RJpTv7zcX3kobMAny9P9K5Jqu2/kaIbWjIKmDLdGtIpKPJj6qocxBX4QUpjOlbKpVnHHBYejCFWPE80LS2YUScNMtSxEHuCYbRrsioUIcLNQKdsQnAaOe9i/wYRt/p0bXHDyb7fR9Wj1oPqLIMjrUu7Cy0Z2ccq5SP3mFGlqSmzcPF95fxHud3IGcvbmgtGBibDcdsam/IEhy3Rp0MBDuvf88cEodOIaFDLC71jdYs1aoTuoJ4O1wH6Ykltra+5kiUQwE0GJz51zha4sRL2DM9I8DbCSSJjv+pF6MAPmg7L86nJ5wq0vzq4Sh5PWV8zpme4Wgbau8TTlUqmXD0q7gop+50zBMJyIGad6HsFEqd9yACumL9eoz8d75IpS/fwH7mZxwiM2yM8JwZPguIMJ/hH7LP1RQ9l2Aubin081nsIcfeyDuzIJMPijyBsmYwoUTDbamIOmVk4+xJBCSyhz/fWAzcTdFIWW904RsgspJSsSuYj5DTL1nL8OCfDVHBYn5jBYp9EnC2cQ9m7CJbm8eemC1VowomN2FifQHbNlXs/75oRW70l+7cpL7U7UY0npJH040tBjoNpnQOUAsWC+93goVRpNqLLbBb8EfjbwkjSCkZZe/ToNys1LFDXUCsZddR1SkVoMOSpH8VEJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 02:54:55PM -0700, Suren Baghdasaryan wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> The per-VMA locks have been around for several years. They've had some
> bugs worked out of them and have seen quite wide use. However, they
> are still only available when architectures explicitly enable them.
> Remove the conditional compilation around the per-VMA locks, making
> them available on all architectures and configs.
>
> The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> when the architecture started using per-VMA locks in the fault
> handler. But, contrary to the naming, the Kconfig option does not
> really indicate whether the architecture supports per-VMA locks or
> not. It is more of a marker for whether the architecture is likely to
> benefit from per-VMA locks.
>
> To me, the most important thing side-effect of universal availability
> is letting per-VMA locks be used in SMP=n configs. This lets us use
> per-VMA locking in all x86 code without fallbacks.
>
> Overall, this just generally makes the kernel simpler. Just look at
> the diffstat. It also opens the door to users that want to use the
> per-VMA locks in common code. Doing *that* brings additional
> simplifications.
>
> The downside of this is adding some fields to vm_area_struct and
> mm_struct. There are likely ways to optimize this, especially for
> things like SMP=n configs. For now, do the simplest thing: use the
> same implementation everywhere.
>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Thanks a lot for this! Great change.

I see you also got the VMA userland test changes as well :)

All LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
>  arch/arm/Kconfig                       |  1 -
>  arch/arm64/Kconfig                     |  1 -
>  arch/loongarch/Kconfig                 |  1 -
>  arch/powerpc/platforms/powernv/Kconfig |  1 -
>  arch/powerpc/platforms/pseries/Kconfig |  1 -
>  arch/riscv/Kconfig                     |  1 -
>  arch/s390/Kconfig                      |  1 -
>  arch/x86/Kconfig                       |  2 -
>  fs/proc/internal.h                     |  2 -
>  fs/proc/task_mmu.c                     | 93 --------------------------
>  include/linux/mm.h                     | 12 ----
>  include/linux/mm_types.h               |  8 +--
>  include/linux/mmap_lock.h              | 50 --------------
>  kernel/bpf/stackmap.c                  | 16 +----
>  kernel/bpf/task_iter.c                 |  5 --
>  kernel/fork.c                          |  2 -
>  mm/Kconfig                             | 13 ----
>  mm/Kconfig.debug                       |  1 -
>  mm/debug.c                             |  4 --
>  mm/init-mm.c                           |  2 -
>  mm/memory.c                            |  2 -
>  mm/mmap_lock.c                         | 24 -------
>  mm/pagewalk.c                          |  2 -
>  mm/rmap.c                              |  2 -
>  mm/userfaultfd.c                       | 55 ---------------
>  rust/kernel/mm.rs                      | 22 +++---
>  tools/testing/vma/include/dup.h        |  5 +-
>  tools/testing/vma/vma_internal.h       |  1 -
>  28 files changed, 13 insertions(+), 317 deletions(-)

Look at all that red :) lovely!

>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 9187240a02db..f815209167cd 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -41,7 +41,6 @@ config ARM
>  	select ARCH_SUPPORTS_ATOMIC_RMW
>  	select ARCH_SUPPORTS_CFI
>  	select ARCH_SUPPORTS_HUGETLBFS if ARM_LPAE
> -	select ARCH_SUPPORTS_PER_VMA_LOCK
>  	select ARCH_SUPPORTS_RT
>  	select ARCH_USE_BUILTIN_BSWAP
>  	select ARCH_USE_CMPXCHG_LOCKREF
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 11a9c534b7b4..21eb64b24a2c 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -81,7 +81,6 @@ config ARM64
>  	select ARCH_HAS_PTE_PROTNONE
>  	select ARCH_SUPPORTS_NUMA_BALANCING
>  	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
> -	select ARCH_SUPPORTS_PER_VMA_LOCK
>  	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
>  	select ARCH_SUPPORTS_RT
>  	select ARCH_SUPPORTS_SCHED_SMT
> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> index e20acbe5fe7b..7741e39eca2b 100644
> --- a/arch/loongarch/Kconfig
> +++ b/arch/loongarch/Kconfig
> @@ -69,7 +69,6 @@ config LOONGARCH
>  	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
>  	select ARCH_HAS_PTE_PROTNONE if 64BIT
>  	select ARCH_SUPPORTS_NUMA_BALANCING if NUMA
> -	select ARCH_SUPPORTS_PER_VMA_LOCK
>  	select ARCH_SUPPORTS_RT
>  	select ARCH_SUPPORTS_SCHED_SMT if SMP
>  	select ARCH_SUPPORTS_SCHED_MC  if SMP
> diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/platforms/powernv/Kconfig
> index b5ad7c173ef0..dd8f6060fb7a 100644
> --- a/arch/powerpc/platforms/powernv/Kconfig
> +++ b/arch/powerpc/platforms/powernv/Kconfig
> @@ -17,7 +17,6 @@ config PPC_POWERNV
>  	select PPC_DOORBELL
>  	select MMU_NOTIFIER
>  	select FORCE_SMP
> -	select ARCH_SUPPORTS_PER_VMA_LOCK
>  	select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
>  	default y
>
> diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
> index 74910ce3a541..7d125e288f6e 100644
> --- a/arch/powerpc/platforms/pseries/Kconfig
> +++ b/arch/powerpc/platforms/pseries/Kconfig
> @@ -23,7 +23,6 @@ config PPC_PSERIES
>  	select HOTPLUG_CPU
>  	select FORCE_SMP
>  	select SWIOTLB
> -	select ARCH_SUPPORTS_PER_VMA_LOCK
>  	select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
>  	default y
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 7b9c373d82fa..faa85a031fe5 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -70,7 +70,6 @@ config RISCV
>  	select ARCH_SUPPORTS_LTO_CLANG_THIN
>  	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
>  	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
> -	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
>  	select ARCH_HAS_PTE_PROTNONE if MMU
>  	select ARCH_SUPPORTS_RT
>  	select ARCH_SUPPORTS_SHADOW_CALL_STACK if HAVE_SHADOW_CALL_STACK
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index ab8fccc2cc4e..d1274bca8c39 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -151,7 +151,6 @@ config S390
>  	select ARCH_HAS_PTE_PROTNONE
>  	select ARCH_SUPPORTS_NUMA_BALANCING
>  	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
> -	select ARCH_SUPPORTS_PER_VMA_LOCK
>  	select ARCH_USE_BUILTIN_BSWAP
>  	select ARCH_USE_CMPXCHG_LOCKREF
>  	select ARCH_USE_SYM_ANNOTATIONS
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index fb298e219179..79479d29576f 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -27,7 +27,6 @@ config X86_64
>  	select ARCH_HAS_GIGANTIC_PAGE
>  	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
>  	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
> -	select ARCH_SUPPORTS_PER_VMA_LOCK
>  	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
>  	select HAVE_ARCH_SOFT_DIRTY
>  	select MODULES_USE_ELF_RELA
> @@ -1846,7 +1845,6 @@ config X86_USER_SHADOW_STACK
>  	bool "X86 userspace shadow stack"
>  	depends on AS_WRUSS
>  	depends on X86_64
> -	depends on PER_VMA_LOCK
>  	select ARCH_USES_HIGH_VMA_FLAGS
>  	select ARCH_HAS_USER_SHADOW_STACK
>  	select X86_CET
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index b232e1098117..6713757da099 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -385,10 +385,8 @@ struct mem_size_stats;
>
>  struct proc_maps_locking_ctx {
>  	struct mm_struct *mm;
> -#ifdef CONFIG_PER_VMA_LOCK
>  	bool mmap_locked;
>  	struct vm_area_struct *locked_vma;
> -#endif
>  };
>
>  struct proc_maps_private {
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 817e3e0f9194..096bf0b0b9e0 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -130,8 +130,6 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
>  }
>  #endif
>
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	int ret = mmap_read_lock_killable(lock_ctx->mm);
> @@ -233,46 +231,6 @@ static inline void reacquire_rcu(struct proc_maps_private *priv)
>  	vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
>  }
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -	return mmap_read_lock_killable(lock_ctx->mm);
> -}
> -
> -static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -	mmap_read_unlock(lock_ctx->mm);
> -}
> -
> -static inline bool lock_vma_range(struct seq_file *m,
> -				  struct proc_maps_locking_ctx *lock_ctx)
> -{
> -	return lock_ctx_mm(lock_ctx) == 0;
> -}
> -
> -static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -	unlock_ctx_mm(lock_ctx);
> -}
> -
> -static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
> -					   loff_t last_pos)
> -{
> -	return vma_next(&priv->iter);
> -}
> -
> -static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
> -					 loff_t pos)
> -{
> -	return false;
> -}
> -
> -static inline void drop_rcu(struct proc_maps_private *priv) {}
> -static inline void reacquire_rcu(struct proc_maps_private *priv) {}
> -
> -#endif /* CONFIG_PER_VMA_LOCK */
> -
>  static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
>  {
>  	struct proc_maps_private *priv = m->private;
> @@ -560,8 +518,6 @@ static int pid_maps_open(struct inode *inode, struct file *file)
>  		PROCMAP_QUERY_VMA_FLAGS				\
>  )
>
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	reset_lock_ctx(lock_ctx);
> @@ -612,26 +568,6 @@ static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ct
>  	return vma;
>  }
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -	return mmap_read_lock_killable(lock_ctx->mm);
> -}
> -
> -static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -	mmap_read_unlock(lock_ctx->mm);
> -}
> -
> -static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
> -						     unsigned long addr)
> -{
> -	return find_vma(lock_ctx->mm, addr);
> -}
> -
> -#endif  /* CONFIG_PER_VMA_LOCK */
> -
>  static struct vm_area_struct *query_matching_vma(struct proc_maps_locking_ctx *lock_ctx,
>  						 unsigned long addr, u32 flags)
>  {
> @@ -1314,8 +1250,6 @@ static const struct mm_walk_ops smaps_shmem_walk_ops = {
>  	.walk_lock		= PGWALK_RDLOCK,
>  };
>
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  static const struct mm_walk_ops smaps_walk_vma_lock_ops = {
>  	.pmd_entry		= smaps_pte_range,
>  	.hugetlb_entry		= smaps_hugetlb_range,
> @@ -1345,22 +1279,6 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
>  	return &smaps_shmem_walk_vma_lock_ops;
>  }
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static inline const struct mm_walk_ops *
> -get_smaps_walk_ops(struct proc_maps_private *priv)
> -{
> -	return &smaps_walk_ops;
> -}
> -
> -static inline const struct mm_walk_ops *
> -get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> -{
> -	return &smaps_shmem_walk_ops;
> -}
> -
> -#endif /* CONFIG_PER_VMA_LOCK */
> -
>  /*
>   * Gather mem stats from @vma with the indicated beginning
>   * address @start, and keep them in @mss.
> @@ -3497,7 +3415,6 @@ static const struct mm_walk_ops show_numa_ops = {
>  	.walk_lock = PGWALK_RDLOCK,
>  };
>
> -#ifdef CONFIG_PER_VMA_LOCK
>  static const struct mm_walk_ops show_numa_vma_lock_ops = {
>  	.hugetlb_entry = gather_hugetlb_stats,
>  	.pmd_entry = gather_pte_stats,
> @@ -3512,16 +3429,6 @@ get_show_numa_ops(struct proc_maps_private *priv)
>  	return &show_numa_vma_lock_ops;
>  }
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static inline const struct mm_walk_ops *
> -get_show_numa_ops(struct proc_maps_private *priv)
> -{
> -	return &show_numa_ops;
> -}
> -
> -#endif /* CONFIG_PER_VMA_LOCK */
> -
>  /*
>   * Display pages allocated per node and memory policy via /proc.
>   */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7fabe6c66b4b..d9850f846242 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -931,7 +931,6 @@ static inline void vma_numab_state_free(struct vm_area_struct *vma) {}
>   * These must be here rather than mmap_lock.h as dependent on vm_fault type,
>   * declared in this header.
>   */
> -#ifdef CONFIG_PER_VMA_LOCK
>  static inline void release_fault_lock(struct vm_fault *vmf)
>  {
>  	if (vmf->flags & FAULT_FLAG_VMA_LOCK)
> @@ -947,17 +946,6 @@ static inline void assert_fault_locked(const struct vm_fault *vmf)
>  	else
>  		mmap_assert_locked(vmf->vma->vm_mm);
>  }
> -#else
> -static inline void release_fault_lock(struct vm_fault *vmf)
> -{
> -	mmap_read_unlock(vmf->vma->vm_mm);
> -}
> -
> -static inline void assert_fault_locked(const struct vm_fault *vmf)
> -{
> -	mmap_assert_locked(vmf->vma->vm_mm);
> -}
> -#endif /* CONFIG_PER_VMA_LOCK */
>
>  static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
>  {
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index b5d4cd3b067b..d8e246fd09d3 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -950,7 +950,6 @@ struct vm_area_struct {
>  		vma_flags_t flags;
>  	};
>
> -#ifdef CONFIG_PER_VMA_LOCK
>  	/*
>  	 * Can only be written (using WRITE_ONCE()) while holding both:
>  	 *  - mmap_lock (in write mode)
> @@ -966,7 +965,7 @@ struct vm_area_struct {
>  	 * slowpath.
>  	 */
>  	unsigned int vm_lock_seq;
> -#endif
> +
>  	/*
>  	 * Low 32-bits of virtual page offset.
>  	 * See vma_start_virt_pgoff() comment for details.
> @@ -1003,7 +1002,6 @@ struct vm_area_struct {
>  #ifdef CONFIG_NUMA_BALANCING
>  	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
>  #endif
> -#ifdef CONFIG_PER_VMA_LOCK
>  	/*
>  	 * Used to keep track of firstly, whether the VMA is attached, secondly,
>  	 * if attached, how many read locks are taken, and thirdly, if the
> @@ -1046,7 +1044,6 @@ struct vm_area_struct {
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  	struct lockdep_map vmlock_dep_map;
>  #endif
> -#endif
>  #ifdef CONFIG_64BIT
>  	/*
>  	 * High 32-bits of virtual page offset.
> @@ -1254,7 +1251,6 @@ struct mm_struct {
>  					  * init_mm.mmlist, and are protected
>  					  * by mmlist_lock
>  					  */
> -#ifdef CONFIG_PER_VMA_LOCK
>  		struct rcuwait vma_writer_wait;
>  		/*
>  		 * This field has lock-like semantics, meaning it is sometimes
> @@ -1274,7 +1270,7 @@ struct mm_struct {
>  		 * mmap_lock.
>  		 */
>  		seqcount_t mm_lock_seq;
> -#endif
> +
>  		struct futex_mm_data	futex;
>
>  		unsigned long hiwater_rss; /* High-watermark of RSS usage */
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 87f77e3da77f..eb32b482434e 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -76,8 +76,6 @@ static inline void mmap_assert_write_locked(const struct mm_struct *mm)
>  	rwsem_assert_held_write(&mm->mmap_lock);
>  }
>
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  #ifdef CONFIG_LOCKDEP
>  #define __vma_lockdep_map(vma) (&vma->vmlock_dep_map)
>  #else
> @@ -484,54 +482,6 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
>  				     struct vma_iterator *iter,
>  				     unsigned long address);
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static inline void mm_lock_seqcount_init(struct mm_struct *mm) {}
> -static inline void mm_lock_seqcount_begin(struct mm_struct *mm) {}
> -static inline void mm_lock_seqcount_end(struct mm_struct *mm) {}
> -
> -static inline bool mmap_lock_speculate_try_begin(struct mm_struct *mm, unsigned int *seq)
> -{
> -	return false;
> -}
> -
> -static inline bool mmap_lock_speculate_retry(struct mm_struct *mm, unsigned int seq)
> -{
> -	return true;
> -}
> -static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt) {}
> -static inline void vma_end_read(struct vm_area_struct *vma) {}
> -static inline void vma_start_write(struct vm_area_struct *vma) {}
> -static inline __must_check
> -int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
> -static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> -		{ mmap_assert_write_locked(vma->vm_mm); }
> -static inline bool vma_is_attached(struct vm_area_struct *vma)
> -		{ return true; }
> -static inline void vma_assert_attached(struct vm_area_struct *vma) {}
> -static inline void vma_assert_detached(struct vm_area_struct *vma) {}
> -static inline void vma_mark_attached(struct vm_area_struct *vma) {}
> -static inline void vma_mark_detached(struct vm_area_struct *vma) {}
> -
> -static inline struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
> -		unsigned long address)
> -{
> -	return NULL;
> -}
> -
> -static inline void vma_assert_locked(struct vm_area_struct *vma)
> -{
> -	mmap_assert_locked(vma->vm_mm);
> -}
> -
> -static inline void vma_assert_stabilised(struct vm_area_struct *vma)
> -{
> -	/* If no VMA locks, then either mmap lock suffices to stabilise. */
> -	mmap_assert_locked(vma->vm_mm);
> -}
> -
> -#endif /* CONFIG_PER_VMA_LOCK */
> -
>  static inline void vma_assert_can_modify(struct vm_area_struct *vma)
>  {
>  	if (vma_is_attached(vma))
> diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> index 41fe87d7302f..8848e26ef581 100644
> --- a/kernel/bpf/stackmap.c
> +++ b/kernel/bpf/stackmap.c
> @@ -272,13 +272,8 @@ struct stack_map_vma_lock {
>  /*
>   * Acquire a stable read-side reference on the VMA covering @ip.
>   *
> - * With CONFIG_PER_VMA_LOCK=y this returns a VMA with its per-VMA read
> - * lock held and mmap_lock dropped, so the caller may sleep.
> - *
> - * With CONFIG_PER_VMA_LOCK=n it returns a VMA with mmap_lock still
> - * held; the caller must snapshot any fields it needs and pin vm_file
> - * with get_file() before stack_map_unlock_vma() drops mmap_lock, as
> - * the VMA may be split, merged, or freed after that.
> + * This returns a VMA with its per-VMA read lock held and mmap_lock
> + * dropped, so the caller may sleep.
>   *
>   * Returns NULL on failure, in which case no lock is held.
>   */
> @@ -288,7 +283,6 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock, unsigned long ip)
>  	struct mm_struct *mm = lock->mm;
>  	struct vm_area_struct *vma;
>
> -	/* noop under !CONFIG_PER_VMA_LOCK */
>  	vma = lock_vma_under_rcu(mm, ip);
>  	if (vma) {
>  		lock->vma = vma;
> @@ -308,13 +302,11 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock, unsigned long ip)
>  		return NULL;
>  	}
>
> -#ifdef CONFIG_PER_VMA_LOCK
>  	if (!vma_start_read_locked(vma)) {
>  		mmap_read_unlock(mm);
>  		return NULL;
>  	}
>  	mmap_read_unlock(mm);
> -#endif
>
>  	lock->vma = vma;
>  	return vma;
> @@ -322,11 +314,7 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock, unsigned long ip)
>
>  static void stack_map_unlock_vma(struct stack_map_vma_lock *lock)
>  {
> -#ifdef CONFIG_PER_VMA_LOCK
>  	vma_end_read(lock->vma);
> -#else
> -	mmap_read_unlock(lock->mm);
> -#endif
>  	lock->vma = NULL;
>  }
>
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index e791ae065c39..6cf815bc84be 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -835,11 +835,6 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_iter_task_vma *it,
>  	BUILD_BUG_ON(sizeof(struct bpf_iter_task_vma_kern) != sizeof(struct bpf_iter_task_vma));
>  	BUILD_BUG_ON(__alignof__(struct bpf_iter_task_vma_kern) != __alignof__(struct bpf_iter_task_vma));
>
> -	if (!IS_ENABLED(CONFIG_PER_VMA_LOCK)) {
> -		kit->data = NULL;
> -		return -EOPNOTSUPP;
> -	}
> -
>  	/*
>  	 * Reject irqs-disabled contexts including NMI. Operations used
>  	 * by _next() and _destroy() (vma_end_read, fput, bpf_iter_mmput_async)
> diff --git a/kernel/fork.c b/kernel/fork.c
> index f0e2e131a9a5..ff91f5f66c80 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1077,9 +1077,7 @@ static void mmap_init_lock(struct mm_struct *mm)
>  {
>  	init_rwsem(&mm->mmap_lock);
>  	mm_lock_seqcount_init(mm);
> -#ifdef CONFIG_PER_VMA_LOCK
>  	rcuwait_init(&mm->vma_writer_wait);
> -#endif
>  }
>
>  static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 060190e12bce..77103b46b679 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1425,19 +1425,6 @@ config LRU_GEN_STATS
>  config LRU_GEN_WALKS_MMU
>  	def_bool y
>  	depends on LRU_GEN && ARCH_HAS_HW_PTE_YOUNG
> -# }
> -
> -config ARCH_SUPPORTS_PER_VMA_LOCK
> -       def_bool n
> -
> -config PER_VMA_LOCK
> -	def_bool y
> -	depends on ARCH_SUPPORTS_PER_VMA_LOCK && MMU && SMP
> -	help
> -	  Allow per-vma locking during page fault handling.
> -
> -	  This feature allows locking each virtual memory area separately when
> -	  handling page faults instead of taking mmap_lock.
>
>  config LOCK_MM_AND_FIND_VMA
>  	bool
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index 5737a504efbb..1dd150edfe71 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -310,7 +310,6 @@ config DEBUG_KMEMLEAK_VERBOSE
>
>  config PER_VMA_LOCK_STATS
>  	bool "Statistics for per-vma locks"
> -	depends on PER_VMA_LOCK
>  	help
>  	  Say Y here to enable success, retry and failure counters of page
>  	  faults handled under protection of per-vma locks. When enabled, the
> diff --git a/mm/debug.c b/mm/debug.c
> index 9a0297b3988d..655e6bcc0e8d 100644
> --- a/mm/debug.c
> +++ b/mm/debug.c
> @@ -157,17 +157,13 @@ void dump_vma(const struct vm_area_struct *vma)
>  	pr_emerg("vma %px start %px end %px mm %px\n"
>  		"prot %lx anon_vma %px vm_ops %px\n"
>  		"pgoff %lx file %px private_data %px\n"
> -#ifdef CONFIG_PER_VMA_LOCK
>  		"refcnt %x\n"
> -#endif
>  		"flags: %#lx(%pGv)\n",
>  		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_mm,
>  		(unsigned long)pgprot_val(vma->vm_page_prot),
>  		vma->anon_vma, vma->vm_ops, vma_start_pgoff(vma),
>  		vma->vm_file, vma->vm_private_data,
> -#ifdef CONFIG_PER_VMA_LOCK
>  		refcount_read(&vma->vm_refcnt),
> -#endif
>  		vma->vm_flags, &vma->vm_flags);
>  }
>  EXPORT_SYMBOL(dump_vma);
> diff --git a/mm/init-mm.c b/mm/init-mm.c
> index 3e792aad7626..a1bb2c2d0284 100644
> --- a/mm/init-mm.c
> +++ b/mm/init-mm.c
> @@ -39,10 +39,8 @@ struct mm_struct init_mm = {
>  	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
>  	.arg_lock	=  __SPIN_LOCK_UNLOCKED(init_mm.arg_lock),
>  	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
> -#ifdef CONFIG_PER_VMA_LOCK
>  	.vma_writer_wait = __RCUWAIT_INITIALIZER(init_mm.vma_writer_wait),
>  	.mm_lock_seq	= SEQCNT_ZERO(init_mm.mm_lock_seq),
> -#endif
>  #ifdef CONFIG_SCHED_MM_CID
>  	.mm_cid.lock = __RAW_SPIN_LOCK_UNLOCKED(init_mm.mm_cid.lock),
>  #endif
> diff --git a/mm/memory.c b/mm/memory.c
> index a620d425ec95..f109f6c87b28 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6813,7 +6813,6 @@ static vm_fault_t sanitize_fault_flags(struct vm_area_struct *vma,
>  				 !is_cow_mapping(vma->vm_flags)))
>  			return VM_FAULT_SIGSEGV;
>  	}
> -#ifdef CONFIG_PER_VMA_LOCK
>  	/*
>  	 * Per-VMA locks can't be used with FAULT_FLAG_RETRY_NOWAIT because of
>  	 * the assumption that lock is dropped on VM_FAULT_RETRY.
> @@ -6822,7 +6821,6 @@ static vm_fault_t sanitize_fault_flags(struct vm_area_struct *vma,
>  			(FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)) ==
>  			(FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)))
>  		return VM_FAULT_SIGSEGV;
> -#endif
>
>  	return 0;
>  }
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 898c2ef1e958..e20d01e8d38f 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -43,9 +43,6 @@ void __mmap_lock_do_trace_released(struct mm_struct *mm, bool write)
>  EXPORT_SYMBOL(__mmap_lock_do_trace_released);
>  #endif /* CONFIG_TRACING */
>
> -#ifdef CONFIG_MMU
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  /* State shared across __vma_[start, end]_exclude_readers. */
>  struct vma_exclude_readers_state {
>  	/* Input parameters. */
> @@ -431,7 +428,6 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
>
>  	return vma;
>  }
> -#endif /* CONFIG_PER_VMA_LOCK */
>
>  #ifdef CONFIG_LOCK_MM_AND_FIND_VMA
>  #include <linux/extable.h>
> @@ -548,23 +544,3 @@ struct vm_area_struct *lock_mm_and_find_vma(struct mm_struct *mm,
>  	return NULL;
>  }
>  #endif /* CONFIG_LOCK_MM_AND_FIND_VMA */
> -
> -#else /* CONFIG_MMU */
> -
> -/*
> - * At least xtensa ends up having protection faults even with no
> - * MMU.. No stack expansion, at least.
> - */
> -struct vm_area_struct *lock_mm_and_find_vma(struct mm_struct *mm,
> -			unsigned long addr, struct pt_regs *regs)
> -{
> -	struct vm_area_struct *vma;
> -
> -	mmap_read_lock(mm);
> -	vma = vma_lookup(mm, addr);
> -	if (!vma)
> -		mmap_read_unlock(mm);
> -	return vma;
> -}
> -
> -#endif /* CONFIG_MMU */
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index ed4860c01936..fbcf64c59a97 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -446,7 +446,6 @@ static inline void process_mm_walk_lock(struct mm_struct *mm,
>  static inline void process_vma_walk_lock(struct vm_area_struct *vma,
>  					 enum page_walk_lock walk_lock)
>  {
> -#ifdef CONFIG_PER_VMA_LOCK
>  	switch (walk_lock) {
>  	case PGWALK_WRLOCK:
>  		vma_start_write(vma);
> @@ -461,7 +460,6 @@ static inline void process_vma_walk_lock(struct vm_area_struct *vma,
>  		/* PGWALK_RDLOCK is handled by process_mm_walk_lock */
>  		break;
>  	}
> -#endif
>  }
>
>  /*
> diff --git a/mm/rmap.c b/mm/rmap.c
> index b917431759ee..4e4a4b747977 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -260,11 +260,9 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
>  	/* For the anon_vma to be compatible, it can only be singular. */
>  	VM_WARN_ON_ONCE(operation == VMA_OP_MERGE_UNFAULTED &&
>  			!list_is_singular(&src->anon_vma_chain));
> -#ifdef CONFIG_PER_VMA_LOCK
>  	/* Only merging an unfaulted VMA leaves the destination attached. */
>  	VM_WARN_ON_ONCE(operation != VMA_OP_MERGE_UNFAULTED &&
>  			vma_is_attached(dst));
> -#endif
>  }
>
>  static void maybe_reuse_anon_vma(struct vm_area_struct *dst,
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 258b03182a78..edd90892f8cc 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -122,7 +122,6 @@ struct vm_area_struct *find_vma_and_prepare_anon(struct mm_struct *mm,
>  	return vma;
>  }
>
> -#ifdef CONFIG_PER_VMA_LOCK
>  /*
>   * uffd_lock_vma() - Lookup and lock vma corresponding to @address.
>   * @mm: mm to search vma in.
> @@ -182,34 +181,6 @@ static void uffd_mfill_unlock(struct vm_area_struct *vma)
>  	vma_end_read(vma);
>  }
>
> -#else
> -
> -static struct vm_area_struct *uffd_mfill_lock(struct mm_struct *dst_mm,
> -					      unsigned long dst_start,
> -					      unsigned long len)
> -{
> -	struct vm_area_struct *dst_vma;
> -
> -	mmap_read_lock(dst_mm);
> -	dst_vma = find_vma_and_prepare_anon(dst_mm, dst_start);
> -	if (IS_ERR(dst_vma))
> -		goto out_unlock;
> -
> -	if (validate_dst_vma(dst_vma, dst_start + len))
> -		return dst_vma;
> -
> -	dst_vma = ERR_PTR(-ENOENT);
> -out_unlock:
> -	mmap_read_unlock(dst_mm);
> -	return dst_vma;
> -}
> -
> -static void uffd_mfill_unlock(struct vm_area_struct *vma)
> -{
> -	mmap_read_unlock(vma->vm_mm);
> -}
> -#endif
> -
>  static void mfill_put_vma(struct mfill_state *state)
>  {
>  	if (!state->vma)
> @@ -1852,7 +1823,6 @@ int find_vmas_mm_locked(struct mm_struct *mm,
>  	return 0;
>  }
>
> -#ifdef CONFIG_PER_VMA_LOCK
>  static int uffd_move_lock(struct mm_struct *mm,
>  			  unsigned long dst_start,
>  			  unsigned long src_start,
> @@ -1927,31 +1897,6 @@ static void uffd_move_unlock(struct vm_area_struct *dst_vma,
>  		vma_end_read(dst_vma);
>  }
>
> -#else
> -
> -static int uffd_move_lock(struct mm_struct *mm,
> -			  unsigned long dst_start,
> -			  unsigned long src_start,
> -			  struct vm_area_struct **dst_vmap,
> -			  struct vm_area_struct **src_vmap)
> -{
> -	int err;
> -
> -	mmap_read_lock(mm);
> -	err = find_vmas_mm_locked(mm, dst_start, src_start, dst_vmap, src_vmap);
> -	if (err)
> -		mmap_read_unlock(mm);
> -	return err;
> -}
> -
> -static void uffd_move_unlock(struct vm_area_struct *dst_vma,
> -			     struct vm_area_struct *src_vma)
> -{
> -	mmap_assert_locked(src_vma->vm_mm);
> -	mmap_read_unlock(dst_vma->vm_mm);
> -}
> -#endif
> -
>  /**
>   * move_pages - move arbitrary anonymous pages of an existing vma
>   * @ctx: pointer to the userfaultfd context
> diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
> index 4764d7b68f2a..2633e704c83d 100644
> --- a/rust/kernel/mm.rs
> +++ b/rust/kernel/mm.rs
> @@ -174,26 +174,20 @@ pub unsafe fn from_raw<'a>(ptr: *const bindings::mm_struct) -> &'a MmWithUser {
>      /// When per-vma locks are disabled, this always returns `None`.
>      #[inline]
>      pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> Option<VmaReadGuard<'_>> {
> -        #[cfg(CONFIG_PER_VMA_LOCK)]
>          {
>              // SAFETY: Calling `bindings::lock_vma_under_rcu` is always okay given an mm where
>              // `mm_users` is non-zero.
>              let vma = unsafe { bindings::lock_vma_under_rcu(self.as_raw(), vma_addr) };
> -            if !vma.is_null() {
> -                return Some(VmaReadGuard {
> -                    // SAFETY: If `lock_vma_under_rcu` returns a non-null ptr, then it points at a
> -                    // valid vma. The vma is stable for as long as the vma read lock is held.
> -                    vma: unsafe { VmaRef::from_raw(vma) },
> -                    _nts: NotThreadSafe,
> -                });
> +            if vma.is_null() {
> +                return None;
>              }
> +            Some(VmaReadGuard {
> +                // SAFETY: If `lock_vma_under_rcu` returns a non-null ptr, then it points at a
> +                // valid vma. The vma is stable for as long as the vma read lock is held.
> +                vma: unsafe { VmaRef::from_raw(vma) },
> +                _nts: NotThreadSafe,
> +            })
>          }
> -
> -        // Silence warnings about unused variables.
> -        #[cfg(not(CONFIG_PER_VMA_LOCK))]
> -        let _ = vma_addr;
> -
> -        None
>      }
>
>      /// Lock the mmap read lock.
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> index 800e5fa02d78..362feda28526 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -582,7 +582,6 @@ struct vm_area_struct {
>  		vma_flags_t flags;
>  	};
>
> -#ifdef CONFIG_PER_VMA_LOCK
>  	/*
>  	 * Can only be written (using WRITE_ONCE()) while holding both:
>  	 *  - mmap_lock (in write mode)
> @@ -598,7 +597,7 @@ struct vm_area_struct {
>  	 * slowpath.
>  	 */
>  	unsigned int vm_lock_seq;
> -#endif
> +
>  	unsigned int __vm_virt_pgoff_lo;
>
>  	/*
> @@ -632,10 +631,8 @@ struct vm_area_struct {
>  #ifdef CONFIG_NUMA_BALANCING
>  	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
>  #endif
> -#ifdef CONFIG_PER_VMA_LOCK
>  	/* Unstable RCU readers are allowed to read this. */
>  	refcount_t vm_refcnt;
> -#endif
>  #ifdef CONFIG_64BIT
>  	unsigned int __vm_virt_pgoff_hi;
>  #endif
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> index 8a48b231aa7a..54d5c3360aa2 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -15,7 +15,6 @@
>  #include <stdlib.h>
>
>  #define CONFIG_MMU		1
> -#define CONFIG_PER_VMA_LOCK	1
>
>  #ifdef __CONCAT
>  #undef __CONCAT
> --
> 2.55.0.508.g3f0d502094-goog
>

--
Cheers, Lorenzo

