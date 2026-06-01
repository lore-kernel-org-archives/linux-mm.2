Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CEB7CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 20:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CBC96B04BB; Mon,  1 Jun 2026 16:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2C56B04BD; Mon,  1 Jun 2026 16:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DFE06B04BE; Mon,  1 Jun 2026 16:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6EC6B04BB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:15:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 163491614F4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:15:37 +0000 (UTC)
X-FDA: 84832449114.16.340FE1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 781B21C0002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:15:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JuZ8bT9d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780344935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=syeJCfN05uDjUd4svPq4RNjDQXcDyKa61aaj7lQd5U4=;
	b=hx1SeDf8npyktdyWmJOPIZOCKRdQhOZyaN35qlrBBcCO08grbRaSaMTzURBRfJwNDwHaOI
	k3bFkTrdY9aWM5sqHYmxTztnyjrQoPv5//9DU0kTUFZQkQnK+oxCvdP3yr7T/df8lVlXYf
	fb7AEPkXk25BtNby+qcH05OBqeTXCDc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JuZ8bT9d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780344935;
	b=5htq9j0fpuB1u13+NW1hMYLV9JcqU+k0NI2OyPKm10jpsMyZQehLo5Bs+8iTZJuy/BTotc
	1607Jpc4xwkkaChlObajNQ6xJm7WkqEA21rUOFwCuQeRgj9wnMJNhdy38ibXYEMFZSpKLi
	sYNi1KFbpXLy10wMApTd5rh3EghjBRg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B55E643588;
	Mon,  1 Jun 2026 20:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A761F0089A;
	Mon,  1 Jun 2026 20:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780344934;
	bh=syeJCfN05uDjUd4svPq4RNjDQXcDyKa61aaj7lQd5U4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=JuZ8bT9dSGV4klPf9XsbtbDDHSt7f4OvQDGLa29dKTvxYBAVCMhiPPsZ8B0deX9nE
	 slfEcP1rtXhoFaa6OcBHWn+Y4+FyCVuhgYcgYn5EWc2aFOOTL1LRqvtTJEe6+/3O44
	 2JJmRLVlOthnh0F8g0Gc1mgHJjuVQunCxqYaKbmde+DdLEffE96ADOa2SA54rNjGjv
	 4nXV6yxRWCTFs8LfQGE9sWIcKtyGzzRvvlzXd8FTHPcFGL732wtYT4rFxzHvlgsyje
	 L7Vd8y+HRceRgaTuZIRRQt5Gknk+HehCaEofmiJ/ckJj553zEBe+lqbMLnn69hFImc
	 I/e/577Zby1Qg==
Content-Type: multipart/mixed; boundary="===============8340823664292074246=="
MIME-Version: 1.0
Message-Id: <f45f02410d23c99d14f3577da9b27a327816b5a0904bdeefc8e229eac760d1cf@mail.kernel.org>
In-Reply-To: <20260601183728.1800490-1-tj@kernel.org>
References: <20260601183728.1800490-1-tj@kernel.org>
Subject: Re: [PATCH bpf-next] bpf: Replace scratch PTE atomically when allocating arena pages
From: bot+bpf-ci@kernel.org
To: tj@kernel.org,void@manifault.com,arighi@nvidia.com,changwoo@igalia.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@linux.dev,memxor@gmail.com
Cc: peterz@infradead.org,catalin.marinas@arm.com,will@kernel.org,tglx@kernel.org,mingo@redhat.com,bp@alien8.de,dave.hansen@linux.intel.com,akpm@linux-foundation.org,david@kernel.org,rppt@kernel.org,emil@etsalapatis.com,sched-ext@lists.linux.dev,bpf@vger.kernel.org,x86@kernel.org,linux-arm-kernel@lists.infradead.org,linux-mm@kvack.org,linux-kernel@vger.kernel.org,tj@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon,  1 Jun 2026 20:15:34 +0000 (UTC)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 781B21C0002
X-Stat-Signature: x6dzb9phrtg4qaa1s8q4jzxjourhmka7
X-Rspam-User: 
X-HE-Tag: 1780344935-901070
X-HE-Meta: U2FsdGVkX19c28kxBunN5rR9Av1rb4O9jK+fIo/T6RrjKnaZPGuMr3Bxei4a6CDOZlSGGvtauNHxtEmZ/jEmOnxUthTAQJJF1FicKp/jb+BAVEJcOc9QfO52JxxsaGznDb36BZYl3UBYiZ+WzWF3KGArkf2v/X4ktkf6u8fJkPgy3/HDP3AGE473o53OSnW81wGSI6Ewv4TaWHnjsBUGRTR4AWh0R84V5q3QFa29owfUla4j+lqKx5k/Lkp+fu7L4TmiST13ml0N2IgM//wzUZfTYh6uMWaW3WLFELBa86dpqaZ5il8viFSp0HyLm4tE8j4LDWuTjoHcStmBfOi8X66Ti1aygJ+acy6TScwKKrXz+WhSVpHvOmcS6X0eCz94k57G4VMbkXqcNWvR6eXyjiD0sdHOdCI2vJ/VbXEQ3t4B8M9SJrkazsR5g4lmwynerJNUJS1GG8jDHpB8t8IlVU+bYfDYFgUaLJeQbMjFd7hSXvz2tZcTtfIN+8AJqunvu0e+zZpxngsKSlOJIXa0epGu0YsG1HaIj0QBzdmhKoGB7OcA8H6QxKfvzi0bhJTQJeWzdV3kcRuyRlgwinSd0KkXaDgdBDR19DzV1O/FtuDkSyGukL7zU1928DrSoEDjmfG7GJnSSahjjTwy2ZovawgZ5vSwLz89p5po7Zq1unA2ObxZsZBph6epBe8KyLdesR+5f3AJEJXqMlsoyqt1Lj7EkFRmIywz6ThizfPvQsj5kfl1ItZkJaWwohbttRrr/gK9+UZFXXOmh8bnK+EnyrZDENAZ6Pkc5G3jIAEj6FwD/fDT9D90wql7T8fO43UGNRj6mwKOAmVuwVRAUndGebOioSf88eS/x/TA1M6MqHuYYRj7XHjCz+Z2g2i33M1REYexbbxqUQ4g1u24jGPG44szN/81jpxnjL2mwKEZD6S6cDUE5zFgBXhF1s2YK3+XwbZIhNLDJtATZxJ1ISA
 glK0uf6e
 DWjOStswNr9DHEp3O2f17GEHVZR+lnGW/aJtRp1GDOUy1J4Nhc8xbv5kUD+moEDWIx9vBPaQPobJKreq903JAt/PguGy7MDTVtnhGtzyigz1cL+ybMeZb1OXpelYRaLz6BmWDOi65X4+pI3a0mVVZpWzBdqsX7IovlN4IRCKuew7O1UjuNoer5GACXKhcpjNvLbBaZsVqcbBHJ8m5dYOQ0ohakyWDuIOO1Q9g+xOz9LShd+Vf/Ew1hzfEIxl4P1mHMf07u5v6NMgvTJPi42DJdefeUZ2FKGTvW5zyk4EJkaMYgUl0qwdTLmotdva8TrJ0v/1ZScVF1L9XW2xrS+xF0CNkUY0K4TDyJ+pQkJao+mCKzQYUBneaPj4qvKYOIWAQUOAXo5TNByCuflqaM5U7UV3aywCCnED6qN/b5CDkubbNjtw+SDcRKdrhsMFWKx68lYOq/c0QvJBoTVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8340823664292074246==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index b5739bb99fc1..4c6c4081ef71 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1061,6 +1061,24 @@ static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
>  }
>  #endif
>
> +#ifndef flush_tlb_before_set
> +/**
> + * flush_tlb_before_set - invalidate a kernel PTE's TLB before re-setting it
> + * @addr: kernel virtual address whose PTE was just cleared
> + *
> + * Some architectures (e.g. arm64) do not allow a live page-table entry to be
> + * repointed at a different page in one step. The old entry must first be made
> + * invalid and its translation flushed from every TLB, and only then may the new
> + * entry be written.
> + *
> + * This is only for the lockless atomic kernel-PTE installers (ptep_try_set()).
> + * It must be callable with interrupts disabled.
> + */
> +static inline void flush_tlb_before_set(unsigned long addr)
> +{
> +}
> +#endif

A subsystem pattern flags the empty generic stub as potentially
concerning, so I wanted to ask about the TLB behaviour on arches that
define ptep_try_set() but use this no-op flush_tlb_before_set().

> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 1727503b25d8..b6ac5a91a296 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c

[ ... ]

> @@ -154,19 +155,44 @@ static int apply_range_set_cb(pte_t *pte, unsigned long addr, void *data)
>  {
>  	struct apply_range_data *d = data;
>  	struct page *page;
> +	pte_t pteval;
>
>  	if (!data)
>  		return 0;
> -	/* sanity check */
> -	if (unlikely(!pte_none(ptep_get(pte))))
> -		return -EBUSY;
>
>  	page = d->pages[d->i];
>  	/* paranoia, similar to vmap_pages_pte_range() */
>  	if (WARN_ON_ONCE(!pfn_valid(page_to_pfn(page))))
>  		return -EINVAL;
>
> -	set_pte_at(&init_mm, addr, pte, mk_pte(page, PAGE_KERNEL));
> +	pteval = mk_pte(page, PAGE_KERNEL);
> +#ifdef ptep_try_set
> +	/*
> +	 * Kernel-fault recovery may have installed the scratch page here, and
> +	 * some architectures (arm64) prohibit valid->valid PTE transitions.
> +	 * Install atomically into a none slot. If scratch is present, clear it
> +	 * and flush_tlb_before_set() (break-before-make) before retrying.
> +	 */
> +	while (!ptep_try_set(pte, pteval)) {
> +		pte_t old = ptep_get(pte);
> +
> +		if (pte_none(old))
> +			continue;
> +		if (WARN_ON_ONCE(pte_page(old) != d->scratch_page))
> +			return -EBUSY;
> +		ptep_get_and_clear(&init_mm, addr, pte);
> +		flush_tlb_before_set(addr);

On x86, ptep_try_set() is defined, so this branch is taken, and
bpf_arena_handle_page_fault() is wired into the x86 fault path, so the
scratch page can really be installed here.

x86 does not override flush_tlb_before_set(), so it resolves to the empty
generic stub above. The scratch slot is then changed scratch_page ->
none -> real_page with no TLB invalidation:

	ptep_get_and_clear(&init_mm, addr, pte);
	flush_tlb_before_set(addr);   /* no-op on x86 */
	... ptep_try_set(pte, pteval);

I could not find a flush of the kernel range on the allocation path.
arena_alloc_pages() only calls flush_vmap_cache() (flush_cache_vmap(),
a no-op on x86) and never flush_tlb_kernel_range(), whereas
arena_free_pages() does call flush_tlb_kernel_range() before the range is
reused.

The CPU that took the original kernel fault restarts the faulting
instruction and accesses kaddr through the scratch page, populating its
TLB with kaddr -> scratch_page. After the real page is installed without
a flush, can that stale kaddr -> scratch_page translation persist, so
that later kernel-side accesses at kaddr reach the shared per-arena
scratch page instead of the freshly allocated page?

The arm64 path looks fine here, since flush_tlb_before_set() expands to
flush_tlb_kernel_range() and performs the break-before-make invalidate.

The commit message says:

> The new flush_tlb_before_set() is a no-op except on arches like arm64
> that need the break-before-make TLB invalidate.

so x86 is intended to need no flush after this scratch -> real transition.
Is there an x86-specific reason the stale scratch translation cannot be
observed, or should the allocation path flush the TLB for the affected
range on these arches too?

> +	}
> +#else
> +	/*
> +	 * Without ptep_try_set() there is no atomic installer, but such arches
> +	 * also do not wire up bpf_arena_handle_page_fault(), so no scratch page
> +	 * is ever installed and the slot is always none here.
> +	 */
> +	if (unlikely(!pte_none(ptep_get(pte))))
> +		return -EBUSY;
> +	set_pte_at(&init_mm, addr, pte, pteval);
> +#endif
>  	d->i++;
>  	return 0;
>  }


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26775626381
--===============8340823664292074246==--

