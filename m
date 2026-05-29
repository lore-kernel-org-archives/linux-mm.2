Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9033CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 07:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235946B0005; Fri, 29 May 2026 03:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E176B0088; Fri, 29 May 2026 03:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123FB6B008A; Fri, 29 May 2026 03:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0090A6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:25:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9703E120328
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:25:08 +0000 (UTC)
X-FDA: 84819621096.21.599FDC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0820C100011
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:25:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dtcc3LgH;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780039507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DvnGy/aNdoF1O4Iz8f505H7qbHc2cS9hrHwlzAYFJpo=;
	b=NbYOUCuw68ywkmzIZSa3HaISxUQ1bNa7wR1zBba3duAbHiq6tfAvArRHCA1nt8GtUtqgb9
	rCXkvfAEpZp8NXXiYwTcVi+yMQ0I9+PKHfdxQaRoPA0Ee/ruNJcvk+DsGErjp8uWluobQe
	ZEGymSFvDf9p2R2yTyMtDjBQY65J1VY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dtcc3LgH;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780039507; a=rsa-sha256;
	cv=none;
	b=kabAob7AXDIRtrXa7jCqy+Q+L4dR0IQybpbgIqFI7kOg74A5im+GxM+SoYihmxgRS6fBoO
	MVxOqbnJ2pLHuu8jC6GhB6dsYvFj9hcyroiPll2zimvzp4EvKY/fOXpgfqgUz3nqaoCInF
	kOk39TglYjNzr2CvFIkgdXpKuyV3Rgc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F5C6605A7;
	Fri, 29 May 2026 07:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788991F00898;
	Fri, 29 May 2026 07:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780039505;
	bh=DvnGy/aNdoF1O4Iz8f505H7qbHc2cS9hrHwlzAYFJpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dtcc3LgHMxD/qPlbvql/b6ShNTNw5wxrlzhV+pAA+DKoz8JwSsviSl2sap7itXy8a
	 RiJc+a/NkOEbKGc/FeXi3ZxGcjRme0f/QlRYgQt5uDSu135tVrwuq0rrr7NMkn0A5p
	 hq5Bb2Jaw6WthWwi461yqEyOsDg2Op/ok22WtEahzW89aSoSHjcjqrGC64D0ZOOhg7
	 XlziVs3ZZuwSYh/rCy119Xtzb/Ruf4rPJ+DhY6hLnOJHQFYApCVWqeIsTAJyfh5jQs
	 wUnCCK5FNnv6jlOLmEGjDPsUOugVmLGjHWDbj4tf0qlNlwiQYvvjOtwLA5qok4ts0x
	 CYGE16Y7eB12w==
Date: Fri, 29 May 2026 08:24:55 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH v5 08/18] mm: add VM_UFFD_RWP VMA flag
Message-ID: <ahk60ViRq4q2g4uz@lucifer>
References: <20260526130509.2748441-1-kirill@shutemov.name>
 <20260526130509.2748441-9-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526130509.2748441-9-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0820C100011
X-Stat-Signature: b3j7scrrheotx8hn9bh4j7dproiqs143
X-HE-Tag: 1780039505-542352
X-HE-Meta: U2FsdGVkX18VApnSHvJpv7NmCRu/JbGikBPSvNMy1pZQ2/0xsES2MAokRqwXSH1RRIUVbYd/qRHBrRGLCRwnbc3421DIzDdqy2QjiEM5NJ7sa7SAE57U00wfgoEc9SOmOCpOsBZg9T+haasO/v2UHp+AjvP9d61AG3ShBAbFKMydQSEktye1ANB+Yxlkzw+IwbThN5yYgXlNES/vczUFEoD8WCXt8Z2Sa8lLCv3oNkomohUZOk9EdHQiy3BX09F0NpusynPCrdtFkXHletUp9vqUxbtUThKWsU1ZMw8pV/0dwPMTNw+ZMxDZ8LZ2xYSE1DgtkbjOVBDyrN+zl+BhEqCDJhX5PpuTwoYZWpp72P6UOZNAF7xqZ4bwmUX0DPZpY/4c4gUpZ5aJ6tWk5JAQuw1tZ029xJbsUXqzwy9yKyQ14/a2AE6XsQL8szvU7fd4VBIkWVjy83UEY7CMeIQeEGw5+xe89x6Sb2QLYcLovEVB07NWEyBdQm9IrX84Mf1C1Imr8Cv9J5u9/gsfJ5CY3/Hh1x0NwKQioqjl0Q8B6F/zxiANfSZtA3UFnlVpYnLYEQU7lD/aDUJmaa5Wm3y9r00qz/njk3zvMRjD+IoH7dGMdY5SvdoZWMJ53HFBU/YbwpzJXhc7bgXmeWP/x6aVj5I4dS9Ztrkzuy09agMAAcqsqnS5+hXIZb5P//d744PGhfe2wvIetdwhqB2cUBvC+lXKnfuGV3wWc+DBYlgMSQz4n2XH5El8UVTchhirlfUhm7+w7n4r4W92H+AbX256POeo8fFGdjeOzDrOdiSY+SE8wL5NQaEPjUclRUUvtNNGxhFRJyUcGq43a60uk/r4DR/jzpz5F2EI4/oG7Ae7zPdwWdx5ZDfiZzrrIbsXMn6dDTgsnwriZNGvLjEBkpNo4UH0+B7CbNXvMhMjNaSdzab/N7S0tvXJSGPaDinxb76FtnwuQeOGrnFEIBM8Hil
 Gjkam9JH
 hhbqhxQaSxHgmyPO9RyQMl8eGNQzUsiUWarBubRUV3VPGn2/eYZPnVe4bVFoL/fBRZCPWMuX9En5hW/udlfGza/PeSRLzAzfsgyhwPdmozQe3ehfhm6F1Mbt/9uCiEAQebU3SUAqMK/phjHCnJbQwWOK6nMyNkrvGuWBqt9Q1YTlHz2wpxyR3SMRmHjZRbp4n6yMJ/deCgK3wh8chas6Xc6n3uCekOdT5nLsB0mopM1gYjDKx333hbfNAzw8E6LgKvTquNheB3FpH1VQBftUYa/fC0pS7B+iiSiGvAosUHFfltNBIgyQaEgIumh6N3uvt2gLY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 02:04:56PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
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

Hm, if you've just used claude to bounce ideas off, I'm really not sure if
it's necessary to disclose, though I respect your thoroughness for doing so
:)

I guess determining the threshold at which it makes sense to do so is still
a WIP for us in the kernel.

> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: SeongJae Park <sj@kernel.org>
> ---
>  Documentation/filesystems/proc.rst |  1 +
>  fs/proc/task_mmu.c                 |  3 +++
>  include/linux/mm.h                 | 28 +++++++++++++++++----------
>  include/linux/userfaultfd_k.h      | 31 +++++++++++++++++++++++++-----
>  include/trace/events/mmflags.h     |  7 +++++++
>  5 files changed, 55 insertions(+), 15 deletions(-)
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
> index 1e5f6ee8a3b6..974c5f4aa533 100644
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
> index 71b11945e4fc..6499cfb61dc4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -362,6 +362,7 @@ enum {
>  #endif
>  	DECLARE_VMA_BIT(UFFD_MINOR, 41),
>  	DECLARE_VMA_BIT(SEALED, 42),
> +	DECLARE_VMA_BIT(UFFD_RWP, 43),

I'm guessing CONFIG_USERFAULTFD_RWP is predicated on CONFIG_64BIT?

It's a silly situation and once my VMA flags stuff is done it'll be
eliminated but for now... :)

>  	/* Flags that reuse flags above. */
>  	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
>  	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
> @@ -505,6 +506,11 @@ enum {
>  #else
>  #define VM_UFFD_MINOR	VM_NONE
>  #endif
> +#ifdef CONFIG_USERFAULTFD_RWP
> +#define VM_UFFD_RWP		INIT_VM_FLAG(UFFD_RWP)
> +#else
> +#define VM_UFFD_RWP		VM_NONE
> +#endif
>  #ifdef CONFIG_64BIT
>  #define VM_ALLOW_ANY_UNCACHED	INIT_VM_FLAG(ALLOW_ANY_UNCACHED)
>  #define VM_SEALED		INIT_VM_FLAG(SEALED)
> @@ -642,22 +648,24 @@ enum {
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
> index f4cf5763f92c..0aef628514df 100644
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
>  #define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT, \
> -				      VMA_UFFD_MINOR_BIT)
> +				      VMA_UFFD_MINOR_BIT, VMA_UFFD_RWP_BIT)
>
>  /*
>   * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
> @@ -178,7 +179,7 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>   */
>  static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
>  {
> -	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
> +	return vma->vm_flags & (VM_UFFD_MINOR | VM_UFFD_WP | VM_UFFD_RWP);

While we're here we might as well switch to using the new API?

Can do:

	return vma_test_any_mask(vma, __VMA_UFFD_FLAGS);

One unfortunate thing is using bit values means we can't do the VM_NONE
trick, but if !CONFIG_USERFAULTFD_RWP then VMA_UFFD_RWP_BIT wouldn't be set
anyway, same for minor so this should be fine?

>  }
>
>  /*
> @@ -208,6 +209,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
>  	return vma->vm_flags & VM_UFFD_MINOR;
>  }
>
> +static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
> +{
> +	return vma->vm_flags & VM_UFFD_RWP;
> +}

Can be:

	return vma_test(vma, VMA_UFFD_RWP_BIT);

> +
> +static inline bool userfaultfd_protected(struct vm_area_struct *vma)
> +{
> +	return userfaultfd_wp(vma) || userfaultfd_rwp(vma);
> +}
> +
>  static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
>  				      pte_t pte)
>  {
> @@ -328,6 +339,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
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
> @@ -421,8 +442,8 @@ static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
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

Cheers, Lorenzo

