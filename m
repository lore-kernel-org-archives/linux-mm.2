Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C27606A323
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 05:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W3B9Y8OY
Received: by kanga.kvack.org (Postfix)
	id A1B6D6B0128; Tue, 20 Oct 2026 01:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3B26B0408; Tue, 20 Oct 2026 01:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92FB96B040A; Tue, 20 Oct 2026 01:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 682616B0128
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:45:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C84BE408BB
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:45:11 +0000 (UTC)
X-FDA: 85341916422.07.3FC6A7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 38C768000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:45:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W3B9Y8OY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792475110;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ljNN4Eabv0VZKAivtD9fEiK49Q3BHX3CJd7m36FxJ8=;
	b=cxH30lzxPujOOINAauXqqW861hqeXOEKXFt5cwju0OFlphVTg6wY/XObkAFDN7AbsjvMli
	0kb5kA8GxctqcUI2s9WGpHFamB415WHiIdospPsauI+zqdg32YBfaPH0YFx3aWF10RAU0j
	6lDJUq+bBI1LiXDQ6fqrdI03FhwKhTQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W3B9Y8OY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792475110;
	b=UYGBMEcwktXNLug3MnAvxsLGeAL3fzlf7rcelR8SV1hwYN+W4endrbHjzSQFRs3rgIiM5z
	JJV26Ij0wnKpzyOOliMAZ9Fucmei65FVE/HFsgohVn/4DS3QTZXWRs3RZsjKerrMvTtNpJ
	cf+i20cFEXPleLiNsDw2wIchltCEdvs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B34C5600AA;
	Tue, 20 Oct 2026 05:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704F31F000C4;
	Tue, 20 Oct 2026 05:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792475109;
	bh=5ljNN4Eabv0VZKAivtD9fEiK49Q3BHX3CJd7m36FxJ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W3B9Y8OY8Xp51pJWVAc/0fCmzahSB5Y0GBI9G+IEeIxS5BMw+LQIt5TntXGyjuXbu
	 wSxDSWZu6SP/kNay6ghFG3NR793hd+ckd6uVcVm3KhhWWlHhgakKWrHgHa6uMcVj5J
	 hVdXrNuGNXAO6Fuq3SkzOeNZgbHIQH8wYMyeejg6wcTNKh7mTj/RlWvkSFL7poqfj7
	 y6U8miDK2Qadx1ROV1KFikDPFNr/fXmmd84DKMdaJtiyxz4NTIAp/nV24P13OPPj/8
	 2HXkJhLdg3/Axe2FwwVGfGlXThlXfyZLBh91eoRH62ENXjZbaYIwpRiC392OxyK9nV
	 ewYVibQ4z4Oxw==
Message-ID: <sashiko-outbox-178439@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/5] mm/vmalloc: undo partial mappings inside the
 mapping functions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hao Ge" <hao.ge@linux.dev>, "Suren Baghdasaryan" <surenb@google.com>, "Uladzislau
 Rezki" <urezki@gmail.com>, "Madhavan Srinivasan" <maddy@linux.ibm.com>, "Michael
 Ellerman" <mpe@ellerman.id.au>, "Nicholas Piggin" <npiggin@gmail.com>,
 =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAoQ1MgR1JPVVAp?= <chleroy@kernel.org>,
 =?utf-8?b?Uml0ZXNoIEhhcmphbmkgKElCTSk=?= <ritesh.list@gmail.com>, "Shrikanth
 Hegde" <sshegde@linux.ibm.com>, "Alexander Potapenko" <glider@google.com>, "Marco
 Elver" <elver@google.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Dennis Zhou" <dennis@kernel.org>, "Tejun
 Heo" <tj@kernel.org>, "Christoph Lameter" <cl@gentwo.org>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org
In-Reply-To: <20261019054531.87652-4-hao.ge@linux.dev>
References: <20261019054531.87652-1-hao.ge@linux.dev>
 <20261019054531.87652-4-hao.ge@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 05:45:07 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 38C768000B
X-Stat-Signature: ykm7y7cghtwtyjmqsmaguy83irze6dkq
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792475110-746523
X-HE-Meta: U2FsdGVkX1+s2h0euIallskQCEWEkL7UuW7syAqV+KKqapa6wopnvTFdj9TmwjlX/UAYYMAtdXgtSggWNuI9AOum2xEfo7hm728EXsHSs7azxTHq8u3Bl7467NrHY0rhxXCvLTOrf4gQuTBTga8HC1oYf2P/rT1p7ZZd1dYA0adUt22KKgBL8eCeWaIu2WOw/6bd+lWsuFgGrkbARppxFTrL4dAbbGJvUYoIderumF0Qi1wtmcNbwIk5GACDsjlu7unBSUNHUOJrWO46jOp6emMV7c+BNSW1R36ZLxHh7MAmcKvZYts+2XthD3srb+updg3iAdOw3x0aMP4Q4zxbY9leoiVergsaLo7jlTfGlhjbDWxQZeSINC6NhTGCjX9+2FG90Fsv0V1YCm+bkzhp7qAZGH+gNk5ED99n9ZyCoUM30Eoy9rZgGC4ltBThETH3k8b2ajsXAQM2e5bnic4vClJQU3YxHoXhfDVnljcNdVK/clyXFbJvnA/Ohxc0mBSCJ/WHjBWJsxGXTfihkFDKsPnJG51xo4A6LiHpZKzvUP1uqwboiZ5zKrK6enJhje6hBPL/VxUkEK6wXos0VEpgzcNj6Bhybdy8/FESTruwSUtcIjgJEGvFbjIisIrwHtWZkvh8czVd/VE2MfbyF7uEj9YZ0B7zwCQ2EMdd6VDc/6FTIi1K5yRt3R5T3oOPFbXT4tU+wae7KJcrPzIKHaPwZDIWAPDQ7uawNweMa29EaC+aGwT7KWD9nzwrNJ9z/WLvP7cVA4Tt63F0SR/344WjU/ecXCyQF+7K1vzhaHb6EVRf+DNKrWEUMYq9dBTBtHWvrtWBnUV0676qkAco1N51dr2btKvqiQnutlKXF5ohkIbW+VExaFgvg1+5HgjN18EA9cwlpPsmfFCb2AYsOiItpjRupm51GkTMVorptt17jm0G0hEdm7Loc8RoWZad1rhb+17iHEpIvJnT3qSfi1S
 EvmIbuln
 Eg8iR/ZX1CZuFLGxmNgWDePO15A/Iij2vgJiXPLuxNSpgUn7lNt2iqEC6ylCX/Z5vaiaxf9mnCSCxCeYpeCAgScAJJExAxTvSoQhYT8zAYFiHuQVmbPmRDncrTGsbTHXDK5pXo0IH91U9TQjFjja1zvGU/Qgsp7jXo5cETpovf62gu8mpXEja8NffYAilIWEcNOeyq34PSLFoG+fWVjbdJMrztAFgX/fJhAMa2bjMfMQZzSzAWDcrA63zynmAQG+t3Yw9DMhVKFuRFZA3/8J4Vag67LlL7ENEyDFSQkfZhamF9848kTFTN/TDM7lFhoELnYArfsAZo7fGlpybMswFGGh0mSOeFjcgiyKO/0HVXkGKvaAxJZzFUEUj5B8JcGduMO/jn7QkVpFMap/RKDzpk+3Dx2PHYBfCADLOk4m/u0pcxXoWZ04nbPXuWfbnXburoDyRIyicJfI2UjhFBz6utKbs2TdAJHMgDQFhYoDB3T+7AJ+pM8cEhaEmapesuLGWiUDVI2h1WFT+nuBO9WKHrWxlgw8jQwaRiO41p5gI6P5nA2d3MWjAynJ5ZRKhLrna4rix9R3V/2UMKqxWWfOpPSc2nnPasopNm6tMYn09Gd3xd1W5Zp5pYP5gPf6IZUX8fVwbnmWRVo9ujhJ+KKSOpLlPhC3TLHg9Cs2t9CnXAqPwi90=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] mm/vmalloc: infinite loop in vunmap_pte_range() on unaligned error=
 rollback
- [High] mm/vmalloc: __vmap_pages_range_noflush() calls cond_resched() in a=
tomic context
- [Medium] mm/vmalloc: vmap_page_range() calls flush_cache_vmap() before er=
ror rollback
--

commit 043026437ba63b051df5d14470fe69ce8fa8825c
Author: Hao Ge <hao.ge@linux.dev>

mm/vmalloc: undo partial mappings inside the mapping functions

This commit adds rollback logic using __vunmap_range_noflush() and
kmsan_vunmap_range_noflush() into vmap_page_range(),
__vmap_pages_range_noflush(), and vmap_pages_range_noflush() when page
table installation or KMSAN metadata setup fails. It also adds range and
page_shift validation in __vmap_pages_range_noflush().

> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 44e0eb32708f1..75aa5acf55660 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -363,6 +363,9 @@ int vmap_page_range(unsigned long addr, unsigned long=
 end,
>  	if (!err)
>  		err =3D kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>  					       ioremap_max_page_shift);
> +	if (err)
> +		__vunmap_range_noflush(addr, end);
> +
>  	return err;
>  }

[Severity: High]
What happens here when vmap_range_noflush() returns -EINVAL for a range
where end - addr is not PAGE_SIZE-aligned?

In vmap_pte_range(), commit a739e6b557af09 added a check to bail out on
unaligned ranges specifically to avoid an infinite loop:

mm/vmalloc.c:vmap_pte_range() {
	...
	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
		return -EINVAL;
}

This can be reached on 64KB page kernels via pci_remap_iospace() ->
vmap_page_range() with 16KB/32KB/48KB PCI I/O ranges (for example via
loongson_pci_probe() or acpi_pci_root_remap_iospace()).

When vmap_pte_range() returns -EINVAL, vmap_page_range() now calls
__vunmap_range_noflush(addr, end) with the unaligned range. Whenever a PMD
in [addr, end) is already populated with a PTE table (such as the
PCI_IOBASE PMD populated during early boot by reserve_pio_range(), or an
earlier PMD mapped in the same call), __vunmap_range_noflush() descends
into vunmap_pte_range(), which has no alignment check:

mm/vmalloc.c:vunmap_pte_range() {
	...
	do {
		...
			ptent =3D ptep_get_and_clear(&init_mm, addr, pte);
		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
	} while (pte +=3D (size >> PAGE_SHIFT), addr +=3D size, addr !=3D end);
}

Because end - addr is not a multiple of PAGE_SIZE, won't addr step past end
and loop infinitely, clearing unrelated kernel PTEs and corrupting memory
past the PTE table?

[Severity: Medium]
Also in vmap_page_range(), flush_cache_vmap(addr, end) is called
unconditionally before checking err and before rolling back with
__vunmap_range_noflush(addr, end):

mm/vmalloc.c:vmap_page_range() {
	err =3D vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
				 ioremap_max_page_shift);
	flush_cache_vmap(addr, end);
	if (!err)
		err =3D kmsan_ioremap_page_range(addr, end, phys_addr, prot,
					       ioremap_max_page_shift);
	if (err)
		__vunmap_range_noflush(addr, end);

	return err;
}

On UML, flush_cache_vmap is defined as flush_tlb_kernel_range:

arch/um/include/asm/cacheflush.h:
#define flush_cache_vmap flush_tlb_kernel_range

When vmap_range_noflush() fails partway through or
kmsan_ioremap_page_range() fails, flush_cache_vmap() runs while the
partially installed PTEs are still pte_present(), causing
update_pte_range() in arch/um/kernel/tlb.c to map them into the host OS via
ops->mmap() and clear _PAGE_NEEDSYNC:

arch/um/kernel/tlb.c:update_pte_range() {
	...
		if (pte_present(*pte)) {
			...
			ret =3D ops->mmap(ops->mm_idp, addr, PAGE_SIZE,
					prot, fd, offset);
		} else
			ret =3D ops->unmap(ops->mm_idp, addr, PAGE_SIZE);

		*pte =3D pte_mkuptodate(*pte);
}

When __vunmap_range_noflush(addr, end) then clears the software PTEs
without a subsequent TLB flush or unmap notification, won't those host OS
mmap mappings be left behind? Should flush_cache_vmap(addr, end) only be
called after both vmap_range_noflush() and kmsan_ioremap_page_range()
succeed?

> @@ -683,27 +686,35 @@ int __vmap_pages_range_noflush(unsigned long addr, =
unsigned long end,
>  		pgprot_t prot, struct page **pages, unsigned int page_shift)
>  {
>  	unsigned int i, nr =3D (end - addr) >> PAGE_SHIFT;
> +	unsigned long start =3D addr;
> +	int err =3D 0;
> +
> +	if (WARN_ON_ONCE(addr >=3D end))
> +		return -EINVAL;
> =20
>  	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>  		return -EINVAL;
> =20
>  	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> -			page_shift =3D=3D PAGE_SHIFT)
> -		return vmap_small_pages_range_noflush(addr, end, prot, pages);
> -
> -	for (i =3D 0; i < nr; i +=3D 1U << (page_shift - PAGE_SHIFT)) {
> -		int err;
> -
> -		err =3D vmap_range_noflush(addr, addr + (1UL << page_shift),
> +			page_shift =3D=3D PAGE_SHIFT) {
> +		err =3D vmap_small_pages_range_noflush(addr, end, prot, pages);
> +	} else {
> +		for (i =3D 0; i < nr; i +=3D 1U << (page_shift - PAGE_SHIFT)) {
> +			err =3D vmap_range_noflush(addr, addr + (1UL << page_shift),
>  					page_to_phys(pages[i]), prot,
>  					page_shift);
> -		if (err)
> -			return err;
> +			if (err)
> +				break;
> =20
> -		addr +=3D 1UL << page_shift;
> +			addr +=3D 1UL << page_shift;
> +		}
>  	}
> =20
> -	return 0;
> +	/* Undo the PTEs installed before the failure. */
> +	if (err)
> +		__vunmap_range_noflush(start, end);
> +
> +	return err;
>  }

[Severity: High]
Similarly here, __vmap_pages_range_noflush() checks addr >=3D end, but does
not check PAGE_ALIGNED(addr) or PAGE_ALIGNED(end).

If a caller passes a sub-page or unaligned range (for example, 0 < end -
addr < PAGE_SIZE), nr =3D (end - addr) >> PAGE_SHIFT evaluates to 0, so the
huge-page path still maps nothing and returns 0, while the small-page path
loops infinitely in vmap_pages_pte_range(). And if the huge-page path fails
on an unaligned range, __vunmap_range_noflush(start, end) will hit the same
infinite loop in vunmap_pte_range().

Should both vmap_page_range() and __vmap_pages_range_noflush() validate
PAGE_ALIGNED(addr) && PAGE_ALIGNED(end) upfront before attempting to map or
unmap?

> =20
>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> @@ -715,7 +726,16 @@ int vmap_pages_range_noflush(unsigned long addr, uns=
igned long end,
> =20
>  	if (ret)
>  		return ret;
> -	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
> +
> +	ret =3D __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
> +	/*
> +	 * The page tables undo themselves on failure. Tear down the
> +	 * metadata that was fully set up before the mapping failed.
> +	 */
> +	if (ret)
> +		kmsan_vunmap_range_noflush(addr, end);
> +
> +	return ret;
>  }

[Severity: High]
Can calling __vunmap_range_noflush() and kmsan_vunmap_range_noflush() here
trigger a sleeping-in-atomic-context bug when __vmalloc() or kvmalloc() is
called with GFP_ATOMIC or GFP_NOWAIT?

__vmalloc_area_node() supports non-blocking allocations by wrapping
__vmap_pages_range() in memalloc_apply_gfp_scope(gfp_mask):

mm/vmalloc.c:__vmalloc_area_node() {
	...
	flags =3D memalloc_apply_gfp_scope(gfp_mask);
	do {
		ret =3D __vmap_pages_range(addr, addr + size, prot, area->pages,
				page_shift, nested_gfp);
	} while ((gfp_mask & __GFP_NOFAIL) && (ret < 0));
	memalloc_restore_gfp_scope(flags);
}

When a GFP_ATOMIC or GFP_NOWAIT allocation runs in atomic context (such as
under a spinlock, preempt_disable(), or rcu_read_lock()) and page table
allocation fails in vmap_small_pages_range_noflush() after at least one PMD
in [start, end) is populated (or after kmsan_vmap_pages_range_noflush()
populated the KMSAN shadow/origin ranges), __vmap_pages_range_noflush() and
kmsan_vunmap_range_noflush() synchronously call __vunmap_range_noflush().

__vunmap_range_noflush() walks the populated PMDs via vunmap_pmd_range(),
which unconditionally calls cond_resched():

mm/vmalloc.c:vunmap_pmd_range() {
	...
	do {
		next =3D pmd_addr_end(addr, end);
		if (pmd_none_or_clear_bad(pmd))
			continue;
		vunmap_pte_range(pmd, addr, next, mask);

		cond_resched();
	} while (pmd++, addr =3D next, addr !=3D end);
}

Commit 9c47753167a6 ("mm/vmalloc: defer freeing partly initialized
vm_struct") deferred error-path cleanup in __vmalloc_area_node() to a
workqueue specifically because unmapping on failure can sleep. Doesn't
calling __vunmap_range_noflush() synchronously inside
__vmap_pages_range_noflush() and vmap_pages_range_noflush() reintroduce
cond_resched() in atomic context?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019054531.8765=
2-1-hao.ge@linux.dev?part=3D3

