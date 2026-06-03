Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2D05CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 151366B008A; Wed,  3 Jun 2026 08:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129006B008C; Wed,  3 Jun 2026 08:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03EB56B0096; Wed,  3 Jun 2026 08:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4A0A6B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:52:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98D1E14031E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:52:40 +0000 (UTC)
X-FDA: 84838590480.27.AB1DF80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id DB69940008
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:52:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UxE84y/S";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780491159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0LBDQdj4F5kgJaAQzgzgFyrow/wV0tNWGh6dD2EJJzE=;
	b=keDDDlp6dWC03x435NreffbNdM2QnAR+B7StOC1GrW8Hrz/PEVWRZhL41T6Cr877Q/4dBe
	gnmy1h7Fjd8+vzNXmad8oTMJzIHZvxPf7HrIC0LKAmxHDSR23PP7Opx6LNphBjYHYFoiAB
	OqV77KjJYf+C1U+2IvubldXOidePUtI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UxE84y/S";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780491159;
	b=uJZc8cz5b/XOu/gwIio9Ynk0cpQX6AfkwCo3b+eiiPCfRO3A0tbnZl0KsQcVh8v+DrA8cV
	TdLEpJ2Mchx1fkECkearMUPm+wVOU04fx1udpAIl7GpdGXrTVCvluFni/rh9uVpEtfq9Cv
	hqJeWVuadUmaB3lDneBZp8+YVShW3xA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 12AFB440D5;
	Wed,  3 Jun 2026 12:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C301F00893;
	Wed,  3 Jun 2026 12:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780491158;
	bh=0LBDQdj4F5kgJaAQzgzgFyrow/wV0tNWGh6dD2EJJzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UxE84y/SQr+Ii1ViKjtRb3BuCRGqaGkaWPvqmeNItatBpBRy2egqMlF8q0R+Afnlm
	 aIJvGnoVppn2Ztfjum15r/IfatCP60OgPE1RQLGSg1/vE6vPWM7JFMcpAJwBSh1h4a
	 OTP4FoJtBEJPKx/moY4kwKnpx1fwVGop1QtB46OfoajTIV944jKax0L5UvIZ4ppd3y
	 YkyuK86FXEGHzW0YCwaJb9aE6YXGGMmB1+the+/g+XMBUDgCUoaLdfuFrKaxG8ojV/
	 rQuwKnVYebmd0NG2W/6GhjynF0XnjXzgs4xeNvr8h/R8pSjrahk+X5odQmHzKeM0dh
	 FFSjGT3X1Tjow==
Date: Wed, 3 Jun 2026 13:52:29 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v6 05/15] mm: add VM_UFFD_RWP VMA flag
Message-ID: <aiAiTuzRrIvc93m8@lucifer>
References: <20260529172716.357179-1-kas@kernel.org>
 <20260529172716.357179-6-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529172716.357179-6-kas@kernel.org>
X-Rspamd-Queue-Id: DB69940008
X-Rspam-User: 
X-Stat-Signature: dzynb9cu5pn9tze1p9fu7hxttapd5oho
X-Rspamd-Server: rspam09
X-HE-Tag: 1780491158-6012
X-HE-Meta: U2FsdGVkX18Kl2y96BHMyjec0CgYnnSVTrUFdpsyTIrPz/Bem8Kwx+sDr2a8Lp4iJjsNhjpNyVdurYydqI7HseYbQ8YXvC3JDs2YCnoGa3tQX4+WI8btDgN2mMJ3qP3aqAU9Z2e4N7iTr7j1zBGa1+VPTTEOHNqECdffmTKAeeaUg9lUnP1/CoUY0JBwoVAnsiFCVqZAfxByB2HRsUAIp+b62ZGV/bwEiOS14eXXwCskBvLrZF2zlbQo8upuw99RWnvCEpMd+u/BT9Ue9ovTc5dfkrmrcGtFEZ9hrIeayhmEzNsWpw/1OIel38pTSKQE3iX1oq+ArfvV3CmdpgNZue85LK5UFPuGqcokwFtMBxCqmE70uL0NOysZF9/lQQIZ4l5Jx8TlFYAOvh3/6dM6L6wvVQcdEeYt3VD83RLcS4HWf/wugzORx5zJyoy5QQJ9Z9AJK8lXxr3kufeYyEcbLciUtmc85x9nT8mF6hYK7WmScKxyV2EFvHtwzEkp+SyJEzwNDLYDya0d3WlBXax5VJVJyhAYZXely5VYKYRlfzmZPmVfNdJr/k5wi3/adN7DAFyisH6rpHPLKbhHbt71W/dFpErhF4O/zgsVmnPP92u0qJW38YyLtcRnfR6ZVedyE9GC83RmFrbSTCBCCFsNai5Sv+VLofrcTkW0Hd0iNbuLlKFwveBdFHyJbptyI1bo0NrVVy6Ct2b1JPsTOqq6B9JmyagtqhIGajzXM1WI0BvmzRDCi9s63jxcaV70ZFR0g38ueYWtxiQjo3hVsrKxLJoC8Hv1ANK3dG7dzjA8vcMLw7KCYz4wrpY50yBiY1Aw5uOIl7xXT7LuEYIPmlln/aNYr6af1B0UZnz3bh2T1h0oD0xOnbtRuIOd4XS/bOPuNBT2sAlzwm4jFv5iN3PN6Q2NUajJ7f8xzIMOqbewQHVH1XTYT2UgKyTpGlKJJBo9BDS++YZTQPhdEMCPGxg
 9JJ1UNdh
 23X0ZXt5TEUiccPnSjG7xw+u+rqBqzDhO1SiDyi9lMAjZPuk5+QPN8Up4WpVXc/NYOSiFXLyUjvhLUmXlYYUcjv4nQWUH6LzrT6dPlU8xIuVIRadEZlN8wAF3QDFVWzA6Vit2vSAHjZDMpd1Rpep+swdYZiebGzRImZ51YHQYvqE4jjlxuZIAfI9gCTNuNAzHoRf61gd6k34A/uvQEd6KukHcsEWh1PwpP+KDXaYjB08StchNoJ5ybDp4Iw5fEndEbvX7cdS6lKgerJ5owMcuFZRe6/GQs3pgAmqukOOyw0xgdyydeiAUnm9SXtnRk/FKyxkd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 06:26:34PM +0100, Kiryl Shutsemau (Meta) wrote:
> Preparatory patch for userfaultfd read-write protection (RWP). RWP
> extends userfaultfd protection from plain write-protection (WP) to
> full read-write protection: accesses to an RWP-protected range --
> reads as well as writes -- trap through userfaultfd.
>
> Reserve VM_UFFD_RWP, add the userfaultfd_rwp() and
> userfaultfd_protected() helpers, and wire up the smaps "ur" entry and
> the trace-flag table the rest of the series will use. The flag is
> gated on CONFIG_USERFAULTFD_RWP, which is introduced together with the
> UAPI in a later patch; until then VM_UFFD_RWP aliases VM_NONE and
> every downstream check folds to dead code.
>
> Nothing sets or queries the flag yet.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: SeongJae Park <sj@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  Documentation/filesystems/proc.rst |  1 +
>  fs/proc/task_mmu.c                 |  3 +++
>  include/linux/mm.h                 | 41 ++++++++++++++++++++----------
>  include/linux/userfaultfd_k.h      | 32 +++++++++++++++++++----
>  include/trace/events/mmflags.h     |  7 +++++
>  5 files changed, 65 insertions(+), 19 deletions(-)
>
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index db6167befb7b..db28207c5290 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -607,6 +607,7 @@ encoded manner. The codes are the following:
>      um    userfaultfd missing tracking
>      uw    userfaultfd wr-protect tracking
>      ui    userfaultfd minor fault
> +    ur    userfaultfd read-write-protect tracking
>      ss    shadow/guarded control stack page
>      sl    sealed
>      lf    lock on fault pages
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 939657aa334a..ca0f69b347e8 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1237,6 +1237,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>  #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
>  		[ilog2(VM_UFFD_MINOR)]	= "ui",
>  #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
> +#ifdef CONFIG_USERFAULTFD_RWP
> +		[ilog2(VM_UFFD_RWP)]	= "ur",
> +#endif
>  #ifdef CONFIG_ARCH_HAS_USER_SHADOW_STACK
>  		[ilog2(VM_SHADOW_STACK)] = "ss",
>  #endif
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..5ac31fbadeef 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -353,6 +353,7 @@ enum {
>  #endif
>  	DECLARE_VMA_BIT(UFFD_MINOR, 41),
>  	DECLARE_VMA_BIT(SEALED, 42),
> +	DECLARE_VMA_BIT(UFFD_RWP, 43),
>  	/* Flags that reuse flags above. */
>  	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
>  	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
> @@ -496,12 +497,17 @@ enum {
>  #else
>  #define VM_UFFD_MINOR	VM_NONE
>  #endif
> +#ifdef CONFIG_USERFAULTFD_RWP
> +#define VM_UFFD_RWP		INIT_VM_FLAG(UFFD_RWP)
> +#else
> +#define VM_UFFD_RWP		VM_NONE
> +#endif
>
>  /*
> - * vma_flags_t masks for the userfaultfd VMA flags. VMA_UFFD_MINOR is gated on
> - * the same config as VM_UFFD_MINOR -- which implies 64BIT, where the bit fits
> - * -- so an out-of-range bit is never fed to mk_vma_flags() on a build whose
> - * bitmap cannot hold it.
> + * vma_flags_t masks for the userfaultfd VMA flags. The two high-bit modes are
> + * gated on the same configs as their VM_* flags above -- both of which imply
> + * 64BIT -- so an out-of-range bit is never fed to mk_vma_flags() on a build
> + * whose bitmap cannot hold it.
>   */
>  #define VMA_UFFD_MISSING	mk_vma_flags(VMA_UFFD_MISSING_BIT)
>  #define VMA_UFFD_WP		mk_vma_flags(VMA_UFFD_WP_BIT)
> @@ -510,6 +516,11 @@ enum {
>  #else
>  #define VMA_UFFD_MINOR		EMPTY_VMA_FLAGS
>  #endif
> +#ifdef CONFIG_USERFAULTFD_RWP
> +#define VMA_UFFD_RWP		mk_vma_flags(VMA_UFFD_RWP_BIT)
> +#else
> +#define VMA_UFFD_RWP		EMPTY_VMA_FLAGS
> +#endif
>
>  #ifdef CONFIG_64BIT
>  #define VM_ALLOW_ANY_UNCACHED	INIT_VM_FLAG(ALLOW_ANY_UNCACHED)
> @@ -648,22 +659,24 @@ enum {
>   * reconsistuted upon page fault, so necessitate page table copying upon fork.
>   *
>   * Note that these flags should be compared with the DESTINATION VMA not the
> - * source, as VM_UFFD_WP may not be propagated to destination, while all other
> - * flags will be.
> + * source: VM_UFFD_WP and VM_UFFD_RWP may be cleared on the destination
> + * (dup_userfaultfd() -> userfaultfd_reset_ctx() when the parent context did
> + * not negotiate UFFD_FEATURE_EVENT_FORK), while all other flags propagate.
>   *
>   * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
>   *                           reasonably reconstructed on page fault.
>   *
>   *              VM_UFFD_WP - Encodes metadata about an installed uffd
> - *                           write protect handler, which cannot be
> - *                           reconstructed on page fault.
> + *              VM_UFFD_RWP  write- or read-write-protect handler, which
> + *                           cannot be reconstructed on page fault.
>   *
> - *                           We always copy pgtables when dst_vma has uffd-wp
> - *                           enabled even if it's file-backed
> - *                           (e.g. shmem). Because when uffd-wp is enabled,
> - *                           pgtable contains uffd-wp protection information,
> - *                           that's something we can't retrieve from page cache,
> - *                           and skip copying will lose those info.
> + *                           We always copy pgtables when dst_vma has the
> + *                           uffd PTE bit in use even if it's file-backed
> + *                           (e.g. shmem). Because when the uffd bit is
> + *                           in use, the pgtable contains the protection
> + *                           information, that's something we can't
> + *                           retrieve from page cache, and skip copying
> + *                           will lose those info.
>   *
>   *          VM_MAYBE_GUARD - Could contain page guard region markers which
>   *                           by design are a property of the page tables
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index c4f2cc6dfcf0..f3b2db27989b 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -21,10 +21,11 @@
>  #include <linux/hugetlb_inline.h>
>
>  /* The set of all possible UFFD-related VM flags. */
> -#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
> +#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
> +			 VM_UFFD_WP | VM_UFFD_RWP)
>
>  #define __VMA_UFFD_FLAGS mk_vma_flags_from_masks(VMA_UFFD_MISSING, VMA_UFFD_WP, \
> -						 VMA_UFFD_MINOR)
> +						 VMA_UFFD_MINOR, VMA_UFFD_RWP)
>
>  /*
>   * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
> @@ -179,7 +180,8 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>  static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
>  {
>  	return vma_test_any_mask(vma,
> -		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR));
> +		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR,
> +					VMA_UFFD_RWP));

Wonder if a vma_test_any_masks() is worth adding now :) [will do separately though]

>  }
>
>  /*
> @@ -210,6 +212,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
>  	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
>  }
>
> +static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
> +{
> +	return vma_test_any_mask(vma, VMA_UFFD_RWP);

NIT: You could use vma_flags_test_single_mask() just to make it clear it's a single
flag. It's not a big deal though really.

> +}
> +
> +static inline bool userfaultfd_protected(struct vm_area_struct *vma)
> +{
> +	return userfaultfd_wp(vma) || userfaultfd_rwp(vma);
> +}
> +
>  static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
>  				      pte_t pte)
>  {
> @@ -330,6 +342,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
>  	return false;
>  }
>
> +static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
> +{
> +	return false;
> +}
> +
> +static inline bool userfaultfd_protected(struct vm_area_struct *vma)
> +{
> +	return false;
> +}
> +
>  static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
>  				      pte_t pte)
>  {
> @@ -423,8 +445,8 @@ static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
>  }
>
>  /*
> - * Returns true if this is a swap pte and was uffd-wp wr-protected in either
> - * forms (pte marker or a normal swap pte), false otherwise.
> + * Returns true if this swap pte carries uffd-tracked state in either
> + * form (pte marker or a normal swap pte), false otherwise.
>   */
>  static inline bool pte_swp_uffd_any(pte_t pte)
>  {
> diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
> index a6e5a44c9b42..bfface3d0203 100644
> --- a/include/trace/events/mmflags.h
> +++ b/include/trace/events/mmflags.h
> @@ -194,6 +194,12 @@ IF_HAVE_PG_ARCH_3(arch_3)
>  # define IF_HAVE_UFFD_MINOR(flag, name)
>  #endif
>
> +#ifdef CONFIG_USERFAULTFD_RWP
> +# define IF_HAVE_UFFD_RWP(flag, name) {flag, name},
> +#else
> +# define IF_HAVE_UFFD_RWP(flag, name)
> +#endif
> +
>  #if defined(CONFIG_64BIT) || defined(CONFIG_PPC32)
>  # define IF_HAVE_VM_DROPPABLE(flag, name) {flag, name},
>  #else
> @@ -215,6 +221,7 @@ IF_HAVE_UFFD_MINOR(VM_UFFD_MINOR,	"uffd_minor"	)		\
>  	{VM_PFNMAP,			"pfnmap"	},		\
>  	{VM_MAYBE_GUARD,		"maybe_guard"	},		\
>  	{VM_UFFD_WP,			"uffd_wp"	},		\
> +IF_HAVE_UFFD_RWP(VM_UFFD_RWP,		"uffd_rwp"	)		\
>  	{VM_LOCKED,			"locked"	},		\
>  	{VM_IO,				"io"		},		\
>  	{VM_SEQ_READ,			"seqread"	},		\
> --
> 2.54.0
>

