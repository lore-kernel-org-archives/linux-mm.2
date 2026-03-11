Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04FB7104BED5
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EC8E6B0005; Wed, 11 Mar 2026 06:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CD9A6B0089; Wed, 11 Mar 2026 06:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FAB66B008A; Wed, 11 Mar 2026 06:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EFC8E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:36:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A0A05AEF5
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:36:35 +0000 (UTC)
X-FDA: 84533428350.29.DCD6523
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B70E52000B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:36:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ezS6vw3K;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773225393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BS+o9CUivIwQ+3FYUnx1vpQfaswGlIpxsyn0BQxaPnk=;
	b=kPbboLrzrVQnIIKUmjzuO5P0YQgCMWwy1nQENWbYApjX8WBSi81bga6cLjKM/32TcTYDUm
	OSY5/o8lY7OrrZlRypmeYQG4Hf6q2yk+1uQkfiGcs9vDlVmIkXXo/yYsOaq9MLaOZqiP0O
	/6bVlje+NNGM1qiJjWtePcxraVdNOzw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773225393; a=rsa-sha256;
	cv=none;
	b=NtRd/KhECb/09iMe8q6hIKyAj5iGwIlUsO1odpiGSnCPk+3IBfU3X599MDq+zr8LBQXZCy
	Hy9W9QbXgD+74iRXF/fD1vCQTG7+Z1e6W01PovTukJZivheJOTuMNvff7qTylkIeSQYxfh
	gO815lKyF4FhlV0JCOT1EZBAbumalu8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ezS6vw3K;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D8074005B;
	Wed, 11 Mar 2026 10:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABD3C2BC9E;
	Wed, 11 Mar 2026 10:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773225392;
	bh=lNu7q64hprlaCR7g0QrB2ctXWf6ElvwXPCnWy2oZujw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ezS6vw3KQMORKGVvYQxHhbYSAK1mjYyOKSGonzUCFmXD75/wBmO8Ozi+gOAT1bYKg
	 ydEaJWIhquqA7UA3lT7rUuTobTxByzvsWa+19OVguVUKT2QVTnl9h9r1EyVI6aaiKc
	 lIEXgmmvKS35AccbtjIf22URoxSLpdLqYDzkiL3ukCd0ikfF9hbV1g9q7aCDP9evnR
	 bfaFp5PU8zrF4B6A5ULwZE9jqMjYnLkuqRVpqgo9lBpvY4Lw4ra4zSi+eXUWj1yHmW
	 rhlrJTRMUVK2JvvOFbaFrmg4G1M9+7G9kdSHF2eltAFGwBjJ3meFacUKqrl0Em+GQS
	 HY8MYJ/Ic2vwQ==
Date: Wed, 11 Mar 2026 10:36:26 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, 
	shuah@kernel.org
Subject: Re: [PATCH v2 1/2] mm: prevent droppable mappings from being locked
Message-ID: <269b1a31-20d1-4451-b4ba-f55a67f27d96@lucifer.local>
References: <20260310155821.17869-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310155821.17869-1-anthony.yznaga@oracle.com>
X-Stat-Signature: ajdcxs7xzaztqmgrfwyzu3imdychh86n
X-Rspam-User: 
X-Rspamd-Queue-Id: B70E52000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1773225393-541382
X-HE-Meta: U2FsdGVkX1+ZMbbpZeIdy5d1VZEcclCkyoFqe5P+WBp1U8BRhd82xpPoGNG/5AhqOJ9pOSqmc+xjRgahCTfqa3/VfgjYl3FscP0tZhZDBBO/E6o0jkJBmOhUH4bs+O/rZ0tL45Bw9nZom9UU7zIdjQzTjnaUkqdM6PefVfm4d4nnkxbRf80aUZn/c9a/+3HhXZBh4/qXmGa2YNsqXjQw3JREqazORvA90qLwxsH2G+En1PIK/9LNzg2x26/KI21QVza4qoEf7cFvqIX6U6XXkujxmDTlfoj6SUQDGuOZ2w3+XXuxXcXImYJkDfAu2sCH1riDymM24njEKNTV+lRfSyNbIYxhCDQ3/QDWVHsAi5J/BmiHid7/lEZmZjlyws+1MXTVoYMYFevYewxGdDdA6MVzaKArjt7Tk1/f9BmDPBLGi54juX3NJ5RFv6s8aTufxubBpb0AjHl4awv7WAKmiYPxfsnK6h2KQkD3b+l08F18r2eI2PN4GcgyN8c+IhZ8x63AFC5yTUbtIjzpWHwPOUThwiffnrPXBdvEu96+XWYJjvcGkepjKKqpKs2kkKKtP9iSgpjdBkvuJSiYj7gT16oESsDCSD1ay+Udr9ZlmZ9Kq09ks6bXpk4LXeVfGhaDZa/dV1W6uOuK/R9FgDAozWlq1N0siFJk0TLpqJqCwuWM0+nJcWoT/4il0Y9YgBXGpJ553SKisRh3qig+HhCx6PuFoHtCP8uFugK/cx1OnSc/GBdyJSQ0tI0hivlR+/4Gn59GjRh5LjNYZ12LuC0KHMpcXYr6SvJKoz8lKfXDTdsGOnb0hzRRAFu/AnmXly4uPStavPwvGK1eYHKKZSKA+xPJKOgCtvDhL28DHe3mJ292t8yOwGfrBFAszz/tZHROj3A8CpPcwpM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 08:58:20AM -0700, Anthony Yznaga wrote:
> Droppable mappings must not be lockable. There is a check for VMAs with
> VM_DROPPABLE set in mlock_fixup() along with checks for other types of
> unlockable VMAs which ensures this when calling mlock()/mlock2().
>
> For mlockall(MCL_FUTURE), the check for unlockable VMAs is different.
> In apply_mlockall_flags(), if the flags parameter has MCL_FUTURE set, the
> current task's mm's default VMA flag field mm->def_flags has VM_LOCKED
> applied to it. VM_LOCKONFAULT is also applied if MCL_ONFAULT is also set.
> When these flags are set as default in this manner they are cleared in
> __mmap_complete() for new mappings that do not support mlock. A check for
> VM_DROPPABLE in __mmap_complete() is missing resulting in droppable
> mappings created with VM_LOCKED set. To fix this and reduce that chance of
> similar bugs in the future, introduce and use vma_supports_mlock().
>
> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")

We should definitely cc: stable I think.

It might result in some backport pain since it'll probably pre-date the
__mmap_region() stuff :)) sorry.

> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
> v2:
>  - Implement vma_supports_mlock() instead of vma flags mask (DavidH)
>  - Add selftests (Lorenzo)

I know it's a sort of subject thing, but please in future add a cover letter if
#patches > 1 :) thanks!

>
>  include/linux/hugetlb_inline.h    |  2 +-
>  mm/internal.h                     | 10 ++++++++++
>  mm/mlock.c                        | 10 ++++++----
>  mm/vma.c                          |  4 +---
>  tools/testing/vma/include/stubs.h |  5 +++++
>  5 files changed, 23 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
> index 593f5d4e108b..755281fab23d 100644
> --- a/include/linux/hugetlb_inline.h
> +++ b/include/linux/hugetlb_inline.h
> @@ -30,7 +30,7 @@ static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
>
>  #endif
>
> -static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
> +static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
>  {
>  	return is_vm_hugetlb_flags(vma->vm_flags);
>  }

Ideally we'd use the new VMA flags approach, but I'll fix that later myself when
I make those changes.

> diff --git a/mm/internal.h b/mm/internal.h
> index cb0af847d7d9..8c67637abcdd 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1218,6 +1218,16 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
>  	}
>  	return fpin;
>  }
> +
> +static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
> +{
> +	if (vma->vm_flags & (VM_SPECIAL | VM_DROPPABLE))
> +		return false;
> +	if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
> +		return false;
> +	return vma != get_gate_vma(current->mm);

Honestly it's dumb that we don't have vma_is_gate(), I see arm32 have their own
is_gate_vma() macro, but we should really have one to avoid this noise :)

Anyway probably not worth it for this patch esp. if backporting.

Wonder if we should have vma_support_munlock() for secretmem ;) (again one for
another patch I guess).

> +}
> +
>  #else /* !CONFIG_MMU */
>  static inline void unmap_mapping_folio(struct folio *folio) { }
>  static inline void mlock_new_folio(struct folio *folio) { }
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 2f699c3497a5..73551c71cebf 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -472,10 +472,12 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	int ret = 0;
>  	vm_flags_t oldflags = vma->vm_flags;
>
> -	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
> -	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
> -	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
> -		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
> +	if (newflags == oldflags || vma_is_secretmem(vma) ||
> +	    !vma_supports_mlock(vma))
> +		/*
> +		 * Don't set VM_LOCKED or VM_LOCKONFAULT and don't count.
> +		 * For secretmem, don't allow the memory to be unlocked.
> +		 */
>  		goto out;
>
>  	vma = vma_modify_flags(vmi, *prev, vma, start, end, &newflags);
> diff --git a/mm/vma.c b/mm/vma.c
> index be64f781a3aa..18c3c5280748 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2589,9 +2589,7 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
>
>  	vm_stat_account(mm, vma->vm_flags, map->pglen);
>  	if (vm_flags & VM_LOCKED) {
> -		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
> -					is_vm_hugetlb_page(vma) ||
> -					vma == get_gate_vma(mm))
> +		if (!vma_supports_mlock(vma))
>  			vm_flags_clear(vma, VM_LOCKED_MASK);
>  		else
>  			mm->locked_vm += map->pglen;
> diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
> index 947a3a0c2566..416bb93f5005 100644
> --- a/tools/testing/vma/include/stubs.h
> +++ b/tools/testing/vma/include/stubs.h
> @@ -426,3 +426,8 @@ static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
>  }
>
>  static inline void hugetlb_split(struct vm_area_struct *, unsigned long) {}
> +
> +static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
> +{
> +	return false;
> +}

Thanks :) tested locally and working fine.

> --
> 2.47.3
>

Cheers, Lorenzo

