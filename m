Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AFB4C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302A46B0095; Mon, 24 Aug 2026 11:11:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B38B6B0096; Mon, 24 Aug 2026 11:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17AE16B0099; Mon, 24 Aug 2026 11:11:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E11116B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:11:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8AC881A014F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:11:02 +0000 (UTC)
X-FDA: 85136500764.12.D34EB2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0027C80002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:11:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIeM4nw9;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787584261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wx9f9XPX6UaTsyTsSp+lWebUiETju9PeSHKWEVZrKvQ=;
	b=qf8m3MMi0SBtI71FAw9S9XQAtpQItdRSBGrHf9/cAaTOR7K8V8uu7pCfSqmMF6TvzafmeK
	6zi5NKXk6vckoX2u2PMNWdYnHRb+c60iEYzPzNGyk9doa7Ho8vMfqpmJx901ceGVyDmovg
	xU/xxbGUdT7+pkgjp38lkbfoX/u327Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787584261;
	b=0RTStxMVegjLbfF7Bo3Z5cMP/bpmpG8fRvKaIj4JZg5C7TLc6rzavKCokjb5JuTyaB1eHq
	wE6j1HI7BblkobGNc3HFSijh6wnNKs9e9wiKSiQuFlH/A5D7vlTx7NN/NVnnHSubMZ+SNx
	b7cO8RVv5Gibyp/kN2JwSapAcyHZVSI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIeM4nw9;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5FD7A600CB;
	Mon, 24 Aug 2026 15:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2423E1F000E9;
	Mon, 24 Aug 2026 15:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787584260;
	bh=Wx9f9XPX6UaTsyTsSp+lWebUiETju9PeSHKWEVZrKvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aIeM4nw9zSLp14C7Qg/aoWJ+Gibkr1HmmR0ckBQ4y26T1NYNtGBzmDSU3/xnRFaoV
	 TuzTZNLgmDM9Q08D5Yzggqivp3V83HsLluIKSwBD+aVrE53Ku2YeWV1SMVRw1b+oVv
	 WlqOq3JhDUknsD4U/dUlvXguIpg2M9YY9kuprCHgTPYml9GsRiKR1abr4/MGUglhw8
	 P0swNBzh5TBanefQbSD7CTT9M15MwtjMlbZh8xrpLK5szSEfkcbGMw9vqK000/4003
	 /mbEjamc8pSlzLFaYVI9BuaqwBPBc18xTuyi5oze1LI6PTCMFPD1qLTgli+1JpTkhb
	 q10MUO6pdJrJQ==
Date: Mon, 24 Aug 2026 16:10:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] userfaultfd: use userfaultfd_*() helpers instead of
 open coded flag tests
Message-ID: <aoxdWWMEeQbcG5Pq@gremlin>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-3-3086981b33cf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-3-3086981b33cf@kernel.org>
X-Rspam-User: 
X-Stat-Signature: pnrwz9uoj63kmdpi4nrye3qckfb1iezo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0027C80002
X-HE-Tag: 1787584260-487072
X-HE-Meta: U2FsdGVkX186/GR4Hsze8k2FzYWq9URR3oqaBXaFIWE2lzcVJyuedfBtlnoJxdVVC1xikC2p7TUDR+eMgumgUvLUzrZcahhH5xP47Cq6tPSBt+blWXiCz2DHMewQ+0SM4fVysmJ8byumf1NdW3LUskWr/vIdmpYLI6uTUJPMOE9X8+9xpkZ/omhVDgjE/25RycRAltjLUuvFU2J8ZTcQccXZKsVCoIkfW+9yuDv1WmwU7TrTv16LV2ZXhzfkr4v5AJi5Vsr19c04LrC5xCvj7bpd/HLuH6INqAHgksHhdPg5qL/KwTMMA9WJnJTUDG94HB8XTJiibmR0Cl4/9/932jJLztferweTLXJe4KEQdCn+g3nwZfy+tT55sKyrs48tPkPGnfK965DBOidk4ZWzHnfsgu7X0sCz7Ad8iL3dYqY9JOtBCi6tykyby/tdHfYKr4G/clSmUaByTkFF1CjWLkicj0Lho8SMxER8wh1xw3Lco3q3fwZZeBk05H3PCXVe1K9a/Kft6P6LyB7jhn5ceTPKRvz1uTS0qOlEgWYjHxOKn9FJjxFlqfujfYPTmGh3PEqXpQQ4VoAxS14gTnueOqrBqltCv1QeuHuSsaYMPYuuELLERyM2YUQAseHh9eHHpv1kAWM3bvf43DJ1pLk/pEfO74nfUuU1WtMigRN8kF192mIslpNMPyZ0GirXEveG2CFTpnGD3Gb1crFOAs2fiES6AMhzn10AXw9j/kB5j09Bz0sEXUSzWQN9RXznpsCfUPddtlfPx+N6PUPoPJncq9o9kL7FXUhtR+rw3T8DlpAd8ODQZEHI6IAwvdSF3Kau4kW/Fve9506XBHgu13Y3Q13hl5vESVmJxu5CaednGVaSy2ycQ9wt+de75pNf1NHrP6Dqhi3vPuTwBpaU32ED2k7Wb5dMKsFtARccJcriCQv1Sy8cK94XyJ63qOGUhOe5m9WnamhArhGmFZb91d7
 zNUwO9T0
 4zyoecDObHXoHbExaxvi2kkTG39zY+gdWs1sOTMvoU20pFqwmI+fTzrzg0LYVYZFeOG9k/fa8wL7EE0RSduY0CWQzO5tTx+eRo/kdoCD79bTqap+6jDJy0UDWyKjg3h5KXmykeDs8TbVzrQBz2Z/1ViUimqN91HCDrGvPFUsP95xwXzadk7jysm7IkhTGlJEoXYqfHMWXlaFLv/exVre9n546v0HMukzgLyvw1ymNTtsBymZYA6rXCoiTJRS38NUQ9RoK9gsrF/VgO/7PoygKGy/eMBFOh+8T5mIdgtJK4brtHe7xOwm00vZTGqW5imWQOIdX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 23, 2026 at 03:17:40PM +0300, Mike Rapoport (Microsoft) wrote:
> Move userfaultfd_{missing,wp,minor,rwp}() and userfaultfd_protected()
> ahead of uffd_disable_huge_pmd_share() and uffd_disable_fault_around()
> and make the latter two use the helpers rather than open coded VMA flag
> masks.
>
> Convert open coded VMA flag test in mfill_get_vma() to userfaultfd_wp()
> as well.

It'd be better to do the moves and the reworks separately. We don't have a limit
on patch count :)

>
> With every user of the per-VMA uffd modes going through the helpers,
> their underlying representation can be changed in the next step.
>
> No functional change.

There is a functional change, or at least seems to be, see below.

>
> Assisted-by: copilot:claude-opus-5
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  include/linux/userfaultfd_k.h | 70 +++++++++++++++++++++----------------------
>  mm/userfaultfd.c              |  2 +-
>  2 files changed, 35 insertions(+), 37 deletions(-)
>
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index 3396d270b159..d8262e3dc134 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -168,42 +168,6 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>  	return vma->vm_userfaultfd_ctx.ctx == vm_ctx.ctx;
>  }
>
> -/*
> - * Never enable huge pmd sharing on some uffd registered vmas:
> - *
> - * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
> - *   tracking information is per pgtable entry.
> - *
> - * - VM_UFFD_MINOR VMAs, because otherwise we would never get minor faults for
> - *   VMAs which share huge pmds. (If you have two mappings to the same
> - *   underlying pages, and fault in the non-UFFD-registered one with a write,
> - *   with huge pmd sharing this would *also* setup the second UFFD-registered
> - *   mapping, and we'd not get minor faults.)
> - */
> -static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
> -{
> -	return vma_test_any_mask(vma,
> -		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
> -					VMA_UFFD_MINOR));
> -}
> -
> -/*
> - * Don't do fault around for WP, RWP or MINOR registered uffd range.  For
> - * MINOR registered range, fault around will be a total disaster and ptes can
> - * be installed without notifications; for WP it should mostly be fine as long
> - * as the fault around checks for pte_none() before the installation, however
> - * to be super safe we just forbid it; for RWP, pre-faulted neighbours would
> - * be indistinguishable from accessed pages in PAGEMAP_SCAN (PAGE_IS_ACCESSED)
> - * and pollute the tracked working set, so each page must be populated by its
> - * own fault.
> - */
> -static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
> -{
> -	return vma_test_any_mask(vma,
> -		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
> -					VMA_UFFD_MINOR));
> -}
> -
>  static inline bool userfaultfd_missing(const struct vm_area_struct *vma)
>  {
>  	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
> @@ -235,6 +199,40 @@ static inline bool userfaultfd_protected(const struct vm_area_struct *vma)
>  	return userfaultfd_wp(vma) || userfaultfd_rwp(vma);
>  }
>
> +/*
> + * Never enable huge pmd sharing on some uffd registered vmas:
> + *
> + * - uffd-WP and uffd-RWP VMAs, because the write protect / access tracking
> + *   information is per pgtable entry.
> + *
> + * - uffd-MINOR VMAs, because otherwise we would never get minor faults for
> + *   VMAs which share huge pmds. (If you have two mappings to the same
> + *   underlying pages, and fault in the non-UFFD-registered one with a write,
> + *   with huge pmd sharing this would *also* setup the second UFFD-registered
> + *   mapping, and we'd not get minor faults.)
> + */
> +static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
> +{
> +	return userfaultfd_minor(vma) || userfaultfd_wp(vma) ||
> +	       userfaultfd_rwp(vma);
> +}
> +
> +/*
> + * Don't do fault around for WP, RWP or MINOR registered uffd range.  For
> + * MINOR registered range, fault around will be a total disaster and ptes can
> + * be installed without notifications; for WP it should mostly be fine as long
> + * as the fault around checks for pte_none() before the installation, however
> + * to be super safe we just forbid it; for RWP, pre-faulted neighbours would
> + * be indistinguishable from accessed pages in PAGEMAP_SCAN (PAGE_IS_ACCESSED)
> + * and pollute the tracked working set, so each page must be populated by its
> + * own fault.
> + */
> +static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
> +{
> +	return userfaultfd_minor(vma) || userfaultfd_wp(vma) ||
> +	       userfaultfd_rwp(vma);

This is changing the logic.

Before we were testing only the flags, now we have:

static inline bool userfaultfd_rwp(const struct vm_area_struct *vma)
{
	/*
	 * Callers gate PAGE_NONE usage on this; PAGE_NONE is a BUILD_BUG()
	 * without CONFIG_ARCH_HAS_PTE_PROTNONE, so fold to false.
	 */
	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
		return false;
	return vma_test_single_mask(vma, VMA_UFFD_RWP);
}

I.e. adding in a CONFIG_ARCH_HAS_PTE_PROTNONE check.

BTW side-note these:

static inline bool userfaultfd_missing(const struct vm_area_struct *vma)
{
	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
}

static inline bool userfaultfd_wp(const struct vm_area_struct *vma)
{
	return vma_test_any_mask(vma, VMA_UFFD_WP);
}

static inline bool userfaultfd_minor(const struct vm_area_struct *vma)
{
	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
}

Should all use vma_test_single_mask() really :)


> +}
> +
>  static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
>  				      pte_t pte)
>  {
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 74f04c323c50..32003aa04943 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -261,7 +261,7 @@ static int mfill_get_vma(struct mfill_state *state)
>  	 * validate 'mode' now that we know the dst_vma: don't allow
>  	 * a wrprotect copy if the userfaultfd didn't register as WP.
>  	 */
> -	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
> +	if ((flags & MFILL_ATOMIC_WP) && !userfaultfd_wp(dst_vma))
>  		goto out_unlock;
>
>  	if (is_vm_hugetlb_page(dst_vma))
>
> --
> 2.53.0
>

--
Cheers, Lorenzo

