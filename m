Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD61F606A337
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 13:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZYye6LEP
Received: by kanga.kvack.org (Postfix)
	id C83956B05B0; Thu, 12 Nov 2026 08:02:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5B8C6B05B3; Thu, 12 Nov 2026 08:02:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70A26B05C6; Thu, 12 Nov 2026 08:02:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7476B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:02:21 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2A6D01A05F6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:02:21 +0000 (UTC)
X-FDA: 85426480482.16.CFE2ABD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 47DBB80008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:02:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZYye6LEP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794488539;
	b=wevBt1ZgrxrZHn0JQoPqc+XzPKTyeGRT+WTYpKEOd0G2u5oMzdEaaXCZcOf16iTgjwdymz
	fqbWH5cPk8pnOTYEj9n2YssnjxvSxtS7vW9CgrcHMwjlwBXuHWHEYSjx+qA9I8z/2jO06u
	TFIrYtxF8sCjpSks8JxL/LXnEcwXurw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794488539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJ2PySTdMP5k2BjkIu5goRjZubEIQvsj1+Fqpgep/Gc=;
	b=dEnnvWiHRCR+4inD4B3aRcJTQ97LQ7DXX4auTERHlCuqe6rf3Q0NO7vHxf9EUUDdq4IPNL
	hqXStqqQbZ2aPGrLhKdq04KqmTFNQ8HGSpgzu6G3SyskghyNjUKR2lMgQk2cakZXBdQu3u
	kRXPShSoc+v+4HInMpFPLR8g9dgapmc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZYye6LEP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F7DE473CD;
	Thu, 12 Nov 2026 13:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E70E1F00A08;
	Thu, 12 Nov 2026 13:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794488538;
	bh=RJ2PySTdMP5k2BjkIu5goRjZubEIQvsj1+Fqpgep/Gc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZYye6LEPfA/hnqdM0bt26qltKvUOPso/adO51BU6OdxmublLSBrFT+5XvG6U0YdFe
	 uq/JfdaQEF/PlQ7LO5rOm/oi5mIbt32QjrqBpidCkjkvYzVJ7VvZUXyUpv7Ft0fxbO
	 ny8GKJ8KBcSuZTHUdAUsOm8wyelyJDp6UU76t4+y2+gklMPSadIR+i6Plt4K8FydO3
	 BB9PX+bWUr3dopxGc6n4bOqz5rG7ZHNGyp1ydmzi3aIFu2nOyF9LFcJZS3r+oEL7ig
	 CNLWFU1q2cH9kozO0ORb7bSCTVosIlFYIcjJH92CsOONOZ8p9NLAXWv7Y7MIYitJHy
	 YFJ70bEhL6GJw==
Message-ID: <a242ede8-71c2-4f75-b5e5-dcfa98ab25d3@kernel.org>
Date: Thu, 12 Nov 2026 14:02:11 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: add vmf_insert_pfn_order() and vmf_pfn_order_ok()
 helpers
To: Eliav Farber <farbere@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261111113045.35368-1-farbere@amazon.com>
 <20261111113045.35368-3-farbere@amazon.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261111113045.35368-3-farbere@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 47DBB80008
X-Rspamd-Server: rspam12
X-Stat-Signature: u9anhu7htpu4gqdeeygckbsi8ukig7nn
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794488539-823919
X-HE-Meta: U2FsdGVkX18FsuDHAh5d44U6AJ9A1kB9Zo4ZetZAPK3b5KSgQlNJ+PFbuZ+U31pnOcZZXTVK9nZH4O3TTigClbeazogOftb/mgmrVnHsicUefy/cGSS399JmlCd6XBHahqaXgnYKSnWrCg+OCyo+8//AJT/EEJ+G97g8cBKo6ep7mzqIi2jS4ZFerrzH06FCLLJffUNenlO/PKJ/cy/G/CV2D+fQ4femAcR7wVnlAf6EzTpJpT889TwS8Sn5p5UMspCD+M6TLuBoVhUiLVo03POz2FoM9dM1GonXYB6KYJY778KqJDSuNJct5uYVAD/pJIOWiUDO8mxFBe+6nJIHyZE80SgF90pFvAuzNMQyMOxMTauXTCtoK673ygAsmw6DvsFCsnv4/BTYGrTF+4/507/P3B2J16DTMyRK6GxfgOaJk5m3agm5R2/f3cGq7Kl7SQZzeP4Ez0tvkroB2gc305tvbQk5T0v2Ei17yIeeIwmQCK9ixwfs9MJhomBTBK2HKcoF1+liYcuAOf1fVxK8VbmW6gav6OZsa0LuarL5Dyj2CGjgj6j0QiJk8WDMv7oEo3w5vTRxdJi5fIwls7WuH+OwLkrDFtBvZRRPpUYPgXxv75R9Eap4j5kAgdrLcWFPawsTPt+9w9cXna3NDWzhWinIklT4Z2I9N9+8Cn9VeZIL533jTQ8Ixj7pCCrwWpdcC0ovbIXCMwWJgazPR/owo/OsdAbM240ccQilcUHgpstwO3X1deKJPMwTe1j1fVvkZn0vduum5CRMxGR7MrxwA+8g+JcQr8iekXjbxp5cJ55LFbU2x5GVomQeGU2PikWBi4V5cuS51xSgLOUMWkB3KVN9cR3tHbC8Bx7QADAXL99v1adMs1ORytgSJsjIgdBDAEKcED2z3qCqAnOfYviCtCeCl3fiFGiVhb+R0xFsY1z1IzIsXRDO0G2nGBpgO+QOGJbXrGZ05t/Xq+qaE0y
 iFsaKTjG
 Ksy4UnUhPNrs2NiTgTVHUJvifovCQsZxGymh85LsjoVOuBx5Uo25lZnre1zx/pBjS84a38ojhOQkuSOD8RLKaRnrSO1tbtkQa7fnnO6eprv9zaIwdByaAJp2LplteHCLyQx3v+WIOZ3Suq/4hdC5rI/eYwFXpRJug0n0K7gWYbZT1pygGh8i+gNSmH28cCYHyCLR8EbPSaEkl8wmgw1C0xvP35t8f4cN1ZECohhMAZO3oQLvu+4LdM3F+N3DlANUyptxwP0v5t+aZ1nopM4Ve7roYB7YXvN+KBI/fuVWSeL7I8COOWx5W0ZB8R2R8LrrZPDDjb1irhe2/Ds7oNukVKLCf+lfYdJ14ei5Enkt4+IBKKipThw+3Ncqfvq5K4sS/4KDFaATHaIJqFsaSh6TNqaQD+KHGEPkkCVpRCv7nKeTXOCjJvftnAI1uTdMNXfUgMFPZnADOFZeTHKNvt1sZWHYvEIP2lVyJF3dEQqPHgMu+I3M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 12:30, Eliav Farber wrote:
> ->fault/->huge_fault handlers of VM_PFNMAP mappings that want huge PFN
> mappings open-code the same steps: check that the order-aligned fault
> window lies within the VMA and that the pfn is aligned to the order,
> then call vmf_insert_pfn(), vmf_insert_pfn_pmd() or vmf_insert_pfn_pud()
> depending on the order, guarded by
> CONFIG_ARCH_SUPPORTS_{PMD,PUD}_PFNMAP, and fall back to a smaller order
> otherwise. vfio-pci has its own is_aligned_for_order() and
> vfio_pci_vmf_insert_pfn() for this.
> 
> Add vmf_pfn_order_ok() for the window and alignment check, and
> vmf_insert_pfn_order() for the order dispatch. The latter also checks
> pfn_modify_allowed() for huge orders: the order-0 vmf_insert_pfn() does
> this, but vmf_insert_pfn_pmd() and vmf_insert_pfn_pud() do not. The two
> are separate so that a driver can apply its own policy (access checks,
> device locking) between them.
> 
> vmf_insert_pfn_order() passes the fault's write flag to
> vmf_insert_pfn_pmd() and vmf_insert_pfn_pud(), as the DAX and DRM
> ->huge_fault handlers do. With write=false, insert_pmd() leaves a
> read-only entry in place and returns VM_FAULT_NOPAGE, so a store to a
> mapping that mm write-protected for tracking (soft-dirty, uffd-wp)
> faults forever; wp_huge_pmd() splits the entry only when the handler
> returns VM_FAULT_FALLBACK. Passing it marks the entry young, dirty and,
> where the VMA allows, writable, as wp_page_reuse() does at PTE level.
> The order-0 path needs nothing: wp_pfn_shared() resolves that fault.
> 
> The helper also declines the huge zero folio's pfn, which
> vmf_insert_pfn_pmd() refuses with SIGBUS, so that the fault is retried
> at PTE order where it maps.
> 
> They will be used by the /dev/mem and UIO huge_fault handlers added
> later in this series.
> 
> Signed-off-by: Eliav Farber <farbere@amazon.com>
> ---
>  include/linux/mm.h | 28 ++++++++++++++++++++++++++
>  mm/memory.c        | 49 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 77 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c11bdee1596a..57437b317709 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5010,6 +5010,34 @@ vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn);
>  vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
>  		unsigned long addr, unsigned long pfn);
> +vm_fault_t vmf_insert_pfn_order(struct vm_fault *vmf, unsigned long pfn,
> +				unsigned int order);
> +
> +/**
> + * vmf_pfn_order_ok - check that a pfn can be mapped at a given fault order
> + * @vmf: The fault being handled.
> + * @pfn: The pfn to map at the start of the order-aligned fault window.
> + * @order: The fault order (0 for a single page).
> + *
> + * For a huge (order > 0) fault, the order-aligned window around @vmf->address
> + * must lie within the VMA and @pfn must be aligned to @order. @pfn is only
> + * looked at once the window is known to lie within the VMA, so a caller may
> + * compute it before calling, even when the window starts below vm_start.
> + *
> + * Return: true if vmf_insert_pfn_order() may map @pfn at @order, false if the
> + * fault should fall back to a smaller order.
> + */
> +static inline bool vmf_pfn_order_ok(const struct vm_fault *vmf,
> +				    unsigned long pfn, unsigned int order)
> +{
> +	const struct vm_area_struct *vma = vmf->vma;
> +	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) - 1);
> +
> +	return !order || (addr >= vma->vm_start &&
> +			  addr + (PAGE_SIZE << order) <= vma->vm_end &&
> +			  IS_ALIGNED(pfn, 1UL << order));

To make this somewhat consumable for a human,

if (!order)
	return true;
return start >= vma->vm_start && end <= vma->vm_end;

And maybe rejecting IS_ALIGNED(pfn, 1UL << order) with WARN_ONCE() as this
sounds like the user is doing something stupid?

But looking again, this all looks like sanity checks where the user is just
doing something stupid?

Why is that required at all? I'd get rid of this entirely.


> +}
> +
>  int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
>  
>  static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
> diff --git a/mm/memory.c b/mm/memory.c
> index ab29ec719ae1..0c583442e049 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3002,6 +3002,55 @@ vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  }
>  EXPORT_SYMBOL(vmf_insert_pfn);
>  
> +/**
> + * vmf_insert_pfn_order - insert a pfn mapping of a given fault order
> + * @vmf: The fault being handled.
> + * @pfn: The pfn to map at the start of the order-aligned fault window.
> + * @order: The fault order (0 for a single page).
> + *
> + * Helper for ->fault and ->huge_fault handlers of VM_PFNMAP mappings: maps @pfn
> + * with a PTE for order 0, or with a PMD/PUD for PMD_ORDER/PUD_ORDER where the
> + * architecture supports huge PFN mappings. The caller must have checked the
> + * window and the pfn alignment with vmf_pfn_order_ok().
> + *
> + * vma cannot be a COW mapping.
> + *
> + * Return: vm_fault_t value; %VM_FAULT_FALLBACK if @order cannot be mapped, so
> + * that the fault is retried at a smaller order.
> + */
> +vm_fault_t vmf_insert_pfn_order(struct vm_fault *vmf, unsigned long pfn,
> +				unsigned int order)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	bool write = vmf->flags & FAULT_FLAG_WRITE;
> +
> +	if (!order)
> +		return vmf_insert_pfn(vma, vmf->address, pfn);
> +
> +	/*
> +	 * vmf_insert_pfn_pmd() refuses the huge zero folio's pfn with SIGBUS,
> +	 * while a PTE mapping of it is fine, so fall back to a smaller order.
> +	 */
> +	if (is_huge_zero_pfn(pfn))
> +		return VM_FAULT_FALLBACK;
> +
> +	/*
> +	 * vmf_insert_pfn_pmd()/_pud() don't call pfn_modify_allowed(), unlike
> +	 * the order-0 path, so check it explicitly for the L1TF mitigation.
> +	 */
> +	if (!pfn_modify_allowed(pfn, vma->vm_page_prot))
> +		return VM_FAULT_FALLBACK;
> +
> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order == PMD_ORDER)
> +		return vmf_insert_pfn_pmd(vmf, pfn, write);
> +
> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order == PUD_ORDER)
> +		return vmf_insert_pfn_pud(vmf, pfn, write);
> +
> +	return VM_FAULT_FALLBACK;
> +}
> +EXPORT_SYMBOL_GPL(vmf_insert_pfn_order);
> +
>  static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
>  			bool mkwrite)
>  {


Why do we even care about the order? Why isn't it sufficient that we get called
with "insert this pfn range" and we see how to best map it (pfn/pmd/pud)?

Why does the caller even have to care about *how* something is mapped?

-- 
Cheers,

David

