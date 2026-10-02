Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FEB2CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 08:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432E06B0088; Fri,  2 Oct 2026 04:39:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3B16B008A; Fri,  2 Oct 2026 04:39:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5C76B008C; Fri,  2 Oct 2026 04:39:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0104F6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 04:39:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5EC6AA75A1
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:39:06 +0000 (UTC)
X-FDA: 85277036292.17.35F1344
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B61C5140002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:39:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TsRl5Del;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790930344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KRxNLIPM60ZIDq6ro/IGuIKeWFbCWOgKc8p6gwqctKE=;
	b=tG42JAFlw1sZcSx4BPssMSSXW9z+pETZacrHTOUluhODkiqIWNErq8+tNhtH90bTQcms5M
	m5TxCTkhJWp+W6unNny/eqA34xXRkr6j2z8pXSSG4O9CuBFQ7mLlT9kIzU0zaE8MoeAKhn
	T9yWOn6xex3i/gZ2buaK6Rur++15ezQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TsRl5Del;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790930344;
	b=AFViMyb1kmWRD2PIKzYS2gwis8esHWiLfE6gTW4vHh865U1f/H2KjNU8+8oYqhbWv89bb+
	KGeZDIpr/etIphDtJCKPfMesyAgiaJG1gbVpEypihxFsLGsJelHPY1T75/vERqmSafEQS/
	OFKrBNt+uxvMM4mB63bXaOrMqgrAZ9I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0297A4168E;
	Fri,  2 Oct 2026 08:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16D51F000FF;
	Fri,  2 Oct 2026 08:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790930343;
	bh=KRxNLIPM60ZIDq6ro/IGuIKeWFbCWOgKc8p6gwqctKE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TsRl5DelJUV+pcGbdEBRo0WIrx4BFJXhiL6Y9UoAgr/0P6nELkytR9bJei1zt4iLf
	 CXCDESIpPn5izZW570HY5tEhSz+1cii9gLr4lXLY8y2u9Q1i+CzXfAKZQIU1ASuoPC
	 7284EhuN/8XsjOGM5OBZ3WvPUloBxtLEuPtKzpBheseGyx3VxDvGqmNVSnlkiZZfM2
	 NPAK48W5Q7z1fmKR0+xb3dUJuCZhAMT3aHyU+cFyNxN4iSdI/a0jQq/Z6soGxPB/Ii
	 pS0ornjfDTv0xzZPyortR/WSq4RkNkx8v/jMgS4jqB9m5+OJ3IUkrhkz9fUiamHni2
	 yroBAi8ajvsGw==
Date: Fri, 2 Oct 2026 09:38:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, 
	akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, peterx@redhat.com, dave.hansen@linux.intel.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm: don't ioremap COWed anon pages in
 generic_access_phys()
Message-ID: <ar9omYD3HcTDBpGA@gremlin>
References: <699ae98c.050a0220.340abe.0d31.GAE@google.com>
 <20261001152524.171115-1-ngocthang2710.1999@gmail.com>
 <32fe40e2-854a-47ec-9d95-93e23f9a7af4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32fe40e2-854a-47ec-9d95-93e23f9a7af4@kernel.org>
X-Rspamd-Queue-Id: B61C5140002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 7wprzg73ykjqa5yt8qaqam76gndant71
X-HE-Tag: 1790930344-277576
X-HE-Meta: U2FsdGVkX18+EvutT3PV3/S6S74ndZznppz/1qcBhAGusXxh96ZiJLsEalcoeYsuzapKGcRoOaZSbeQs7oBruxEfRlMit22+jodQX1x/Ljq2+sL7BnvGydZQgrro3hn4A6N5PT/BloUymzLJujBjibiso0Lcolp0PXX/N1L+d5kSy3itWGsdbsRoS/imbfDmkx7Ho39pU00w3h+mdzG02FwWUxwOnABlR/XhDhvVtu6zVMqL0RhTQplwbu+6bIuXw+q5+Aj1Qbvt9J7gXXKwNyI+eizTUlB5/h4M3gTjlWkQdYJGCk1o4Uvbh2/tejVXV9cUneIPm/KIpml8OsPz0wBDNuGMUir2Sudm8MCI8+G/Yfv33PWTlnfCOQJzpgc5iMsHq2Qj06aEpZt7hDJ8+MqnPPaSTvg3uuKkq6HxQ7I3SQXYG48CsNCgLAWkegbYA2yOFZXxjNsYawx59+BVqwexDtGHMaCySO2aU8eClp6Kmdm7Z2qWyBSLKODgpwMzSjvXupmIsGjlp1pySr+U5pQosBZnQ89sAmcHE2/LMFkksm+jCqIYwVhgWkwkXWXNPOj0MRofjon1Ks4NholiSP9unnXRrD0QU36Srla2iCiJ7cCkv2gfOdQ0fiuDpWF62oN1YdGIFU9fBpeOuDhMsSYCfvOsAVscwjAxz3tQnTfD63D/us4qXwF7nExgmuuW7HANoZJ6MEkKPAvHI7fgXjiS9gwPVn6N0Y9xt4vW2yCiRRuv2pcKC6Y5BOfXQYtUFtbXXYZXX0iX0hWM9e2EPmFqo8tPcY3uW+dsvCdkpLPeg7b8tAz5dn+NHb4aFERRL02Rs4wgykr691Tm6rNWj3uFI7HUKRMiHx3TDXQsGTDaVtWSydS2W/Mu9Z+SPJdEMyJkujYPEyXyqtKv2HF+Rjxd+jIBIt+svO+qjNe3OHlCg8lSRbtcS2KLg4t4p4DSw5e1LqDtHzUx/K9lqba
 0oSjO5L3
 rb8A8yDJ6JSX2uzRqUTo0u9Z4MzbEHHB55HATVHwo+s2MEwElp2siQSLpNB060X3CTxXQrNlutE/8Xi/5HLPjK1CKJ82huAJUSWehRFMVjGlpxuv2XRvVyMLJpxjjtyS6Va8/kCEtMfaXZjxqIvyKAKhrJN43F9xS7RLQ0jcYD5YavMb1BzBjcYUGVHkcGRL9JKA4WAuUCn5ckq1o2gyAiR/Zxwf39mJaD15ykOhtrQ2CYcZ2oTFk68pF7OEAStPe7dHFqRiu9aGnkGALc6haTfAhOWKvKZ+usHdMOa/vYY73UgRATrqZjBWnPWDGuP0WKivk8bxlutpUvDoP7KDOMpID6H3DKdnDMG5Af4EBKFUIPUovz0XEJ4lrKsMr+qE+SQMk9kjwJd2uO24uFkJLMH+3PTsuc0U4NFj7f9Ba6xQB2gXR/pZhUs8h1XPVSRxo3mMrzMXlyo0DemWsggqWPHDoiM5aeZBqWLBu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 10:22:29PM +0200, David Hildenbrand (Arm) wrote:
> On 10/1/26 17:25, Nguyen Ngoc Thang wrote:
> > A MAP_PRIVATE mapping of iomem (e.g. a PCI sysfs resourceN file) is a
> > COW pfnmap: a write fault replaces the pfn with an anonymous page, which
> > remap_pfn_range() allows by keeping vm_pgoff equal to the base pfn.
> >
> > generic_access_phys() does not tell those COWed pages apart from the
> > original pfns and ioremaps whatever the PTE points to. Reading such an
> > address via /proc/pid/mem or ptrace then ioremaps RAM:
> >
> >   ioremap on RAM at 0x0000000045623000 - 0x0000000045623fff
> >   WARNING: arch/x86/mm/ioremap.c:216 at __ioremap_caller.isra.0+0x4c2/0x5f0
> >   Call Trace:
> >    generic_access_phys+0x130/0x4d0 mm/memory.c:7178
> >    kernfs_vma_access+0x1ce/0x280 fs/kernfs/file.c:437
> >    __access_remote_vm+0x58f/0x890 mm/memory.c:7256
> >    mem_rw+0x2a1/0x670 fs/proc/base.c:912
> >
>

Sorry to say this looks schlopped.

This guy has sent 10 series across 6 subsystems over ~21 hrs:

https://lore.kernel.org/all/?q=f%3Angocthang2710.1999%40gmail.com

Nguyen - please do not flood the kernel with patches, and please use the
Assisted-by tag for generated content.

The original code you submitted is really not great even if the issue may
be valid.

So I'd say somebody from the core team should take over this if we want to
come up with a patch.

> Ack, apart from that, nothing bad should happen.
>
> > Reject COWed pages using the same linearity rule vm_normal_page() uses.
>
> Hm I don't enjoy that.
>
> What about letting follow_pfnmap_start() just perform a vm_normal_page()
> etc and indicate that information to the caller in the
> follow_pfnmap_args() ?
>
> We kind-of have that information in the form of follow_pfnmap_args.special
> ... but it's not available on all architectures. And it shouldn't exist.
>
> I was thinking a while ago about disallowing follow_pfnmap_start() entirely
> on anon folios, but the VM_IO thingy made me assume that there are some
> odd users (kvm/vfio) that actually need CoWed folios.

Ugh.

>
> Anyhow, this is what I think we should do for now:
>
>
> From 0b75f30b137612f18cdee28c8c0dfa96870868c2 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Thu, 1 Oct 2026 22:19:57 +0200
> Subject: [PATCH] tmp
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

This looks reasonable but I hate that we have 'special' CoW overrides like
this :)

> ---
>  include/linux/mm.h |  4 +++-
>  mm/memory.c        | 48 ++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 45 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c49ef99b4413..b90e547797a9 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3193,6 +3193,8 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
>  				  unsigned long addr, pmd_t pmd);
>  struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>  				pmd_t pmd);
> +struct folio *vm_normal_folio_pud(struct vm_area_struct *vma,
> +		unsigned long addr, pud_t pud);

Hmm, if not defined before why would this need a new PUD handler? Do we
even have PUD-leaf PFN mappings?

>  struct page *vm_normal_page_pud(struct vm_area_struct *vma, unsigned long addr,
>  		pud_t pud);
>
> @@ -3245,7 +3247,7 @@ struct follow_pfnmap_args {
>  	unsigned long addr_mask;
>  	pgprot_t pgprot;
>  	bool writable;
> -	bool special;
> +	bool cow;
>  };
>  int follow_pfnmap_start(struct follow_pfnmap_args *args);
>  void follow_pfnmap_end(struct follow_pfnmap_args *args);
> diff --git a/mm/memory.c b/mm/memory.c
> index 926276d41920..764b79204ab7 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -843,7 +843,7 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>   * @addr: The address where the @pmd is mapped.
>   * @pmd: The PMD.
>   *
> - * Get the "struct folio" associated with a PTE. See __vm_normal_page()
> + * Get the "struct folio" associated with a PMD. See __vm_normal_page()
>   * for details on "normal" and "special" mappings.
>   *
>   * Return: Returns the "struct folio" if this is a "normal" mapping. Returns
> @@ -879,6 +879,28 @@ struct page *vm_normal_page_pud(struct vm_area_struct *vma,
>  	return __vm_normal_page(vma, addr, pud_pfn(pud), pud_special(pud),
>  				&entry, sizeof(entry), PGTABLE_LEVEL_PUD);
>  }
> +
> +/**
> + * vm_normal_folio_pud() - Get the "struct folio" associated with a PUD
> + * @vma: The VMA mapping the @pud.
> + * @addr: The address where the @pud is mapped.
> + * @pud: The PUD.
> + *
> + * Get the "struct folio" associated with a PUD. See __vm_normal_page()
> + * for details on "normal" and "special" mappings.
> + *
> + * Return: Returns the "struct folio" if this is a "normal" mapping. Returns
> + *	   NULL if this is a "special" mapping.
> + */
> +struct folio *vm_normal_folio_pud(struct vm_area_struct *vma,
> +				  unsigned long addr, pud_t pud)
> +{
> +	struct page *page = vm_normal_page_pud(vma, addr, pud);
> +
> +	if (page)
> +		return page_folio(page);
> +	return NULL;
> +}
>  #endif
>
>  /**
> @@ -6947,7 +6969,7 @@ static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
>  				     spinlock_t *lock, pte_t *ptep,
>  				     pgprot_t pgprot, unsigned long pfn_base,
>  				     unsigned long addr_mask, bool writable,
> -				     bool special)
> +				     struct folio *folio)
>  {
>  	args->lock = lock;
>  	args->ptep = ptep;
> @@ -6955,7 +6977,7 @@ static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
>  	args->addr_mask = addr_mask;
>  	args->pgprot = pgprot;
>  	args->writable = writable;
> -	args->special = special;
> +	args->cow = folio && folio_test_anon(folio);

I actually wonder if this should be changed to folio_has_anon_rmap() at
some point :)

Since a folio being 'anon' is vague, because we stupidly made 'anon' vague
in general.

Anyway I was going to ask does this suffice for CoW but having an anon rmap
implies CoW so it does.

>  }
>
>  static inline void pfnmap_lockdep_assert(struct vm_area_struct *vma)
> @@ -7008,6 +7030,7 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
>  	struct vm_area_struct *vma = args->vma;
>  	unsigned long address = args->address;
>  	struct mm_struct *mm = vma->vm_mm;
> +	struct folio *folio = NULL;
>  	spinlock_t *lock;
>  	pgd_t *pgdp;
>  	p4d_t *p4dp, p4d;
> @@ -7047,9 +7070,12 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
>  			spin_unlock(lock);
>  			goto retry;
>  		}
> +
> +		if (vma_is_cow_mapping(vma))
> +			folio = vm_normal_folio_pud(vma, address, pud);
>  		pfnmap_args_setup(args, lock, NULL, pud_pgprot(pud),
>  				  pud_pfn(pud), PUD_MASK, pud_write(pud),
> -				  pud_special(pud));
> +				  folio);
>  		return 0;
>  	}
>
> @@ -7068,9 +7094,12 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
>  			spin_unlock(lock);
>  			goto retry;
>  		}
> +
> +		if (vma_is_cow_mapping(vma))
> +			folio = vm_normal_folio_pmd(vma, address, pmd);
>  		pfnmap_args_setup(args, lock, NULL, pmd_pgprot(pmd),
>  				  pmd_pfn(pmd), PMD_MASK, pmd_write(pmd),
> -				  pmd_special(pmd));
> +				  folio);
>  		return 0;
>  	}
>
> @@ -7080,9 +7109,12 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
>  	pte = ptep_get(ptep);
>  	if (!pte_present(pte))
>  		goto unlock;
> +
> +	if (vma_is_cow_mapping(vma))
> +		folio = vm_normal_folio(vma, address, pte);
>  	pfnmap_args_setup(args, lock, ptep, pte_pgprot(pte),
>  			  pte_pfn(pte), PAGE_MASK, pte_write(pte),
> -			  pte_special(pte));
> +			  folio);

This all seems reasonable, I guess, insofar as the horrible 'special' CoW
handling is reasonable, but this function is gross to have this degree of
duplication across page table levels.

But I guess one for the future.

>  	return 0;
>  unlock:
>  	pte_unmap_unlock(ptep, lock);
> @@ -7145,6 +7177,10 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
>  	writable = args.writable;
>  	follow_pfnmap_end(&args);
>
> +	/* Reject CoW'ed anonymous folios. */
> +	if (args.cow)
> +		return -EINVAL;
> +
>  	if ((write & FOLL_WRITE) && !writable)
>  		return -EINVAL;
>
> --
> 2.43.0
>
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

