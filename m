Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287E4606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 01:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nfCoFaDq
Received: by kanga.kvack.org (Postfix)
	id 093DC6B0625; Thu, 12 Nov 2026 20:31:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B2E6B0638; Thu, 12 Nov 2026 20:31:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE99A6B0639; Thu, 12 Nov 2026 20:31:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C711F6B0625
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:31:22 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D2A74123A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:31:22 +0000 (UTC)
X-FDA: 85428368004.03.8A726C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9B4D01A0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:31:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nfCoFaDq;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794533480;
	b=4lHrl2PaFLudff8lRCfBfagGAIiXUzpdTu6Xa6COxDgzO1PsLzBIDja8MlEFCUPEde71E2
	CQ9BHOkgYW//PDPnaGxkHnuKs4jUbEy8wiW2Ql3ctd5uyKTmxRbtLcjutJ0fjdxMq906J3
	d3EyiRQs0nI/2gyB8HdUikcLLAYhU6Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nfCoFaDq;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794533480;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gONCpmkwYb/dCk10Tjbo6P4VmwfKuzVMyh98RYolt8I=;
	b=4AI4hIjtiTKinLsDPnEAkhn+4fK0n03Dw9g14n+Q8ASViCbqZmxV8A/Hk4sqoGfremJZRx
	J7YCryJxJeWvWOmC1B+J7A6Z4U5TYJ2qdgOOaTzGpmWhSYlszXV522frlVpSaZxCYiSuw0
	i1RojkgsblKwoQnjJRlx1fOBpNDx9lM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DBC6624CE;
	Fri, 13 Nov 2026 01:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C601F000C4;
	Fri, 13 Nov 2026 01:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794533479;
	bh=gONCpmkwYb/dCk10Tjbo6P4VmwfKuzVMyh98RYolt8I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nfCoFaDq7YzNuRYzv7NyC6dL/AJRefQb3UoQ6c0fH+OSI3CcKPNDUYct4iJCJmHDX
	 G4qksDt3gWYtSI9mohuP4UGXhIM7Mvgqc2DeZnvjcLgWX1kJOpHVxorN9yaDaEP7fq
	 URmZSixjlMK3b3z7iD7T2sDt6tIeWg/wUNX2WACSpREhHk0Ro11JhIis1Vxdp1EISw
	 yFirOhAkQcHcmekxJBYT6ZHzODOTiiulmvwY3d3Wy4lQSz8PMsWyD4jGzlPUNlA3sm
	 nyLHKYSa2tnejvozBb+spQgGLxoTFWxKpETQCUEzQN9Ky1qK9PpAM2cMMtGt7H/WVv
	 noX5y0MMKgb0g==
Message-ID: <sashiko-outbox-212060@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/4] mm/char-mem: implement huge_fault support for
 /dev/mem
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eliav Farber" <farbere@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "David Hildenbrand" <david@kernel.org>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jann
 Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>, linux-mm@kvack.org
In-Reply-To: <20261112125638.12209-4-farbere@amazon.com>
References: <20261112125638.12209-1-farbere@amazon.com>
 <20261112125638.12209-4-farbere@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 01:31:18 +0000
X-Stat-Signature: wfkyxxtuu9tg58b45wuo9zshkijw8yza
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9B4D01A0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794533480-251437
X-HE-Meta: U2FsdGVkX18eKVUF1XgvnH4pcFkE42znqnELD28mj3cNxJ29UzyEVw0sPEXvbmik5aNb1SYpOnVbGLFGeaD8hn780EJlYibDiiKte1a19zlikd0HcOxEHTaaaUNJEB03AdMGRCaFuGyDoIRpM6ukKv2LD5WCJaOpWVF0Ogb7IMlFkAE60FowDYBC0ChZyAeF4J3669zE10bL7FZ0sMMbPTrBuNm70NREz8/JfzLTD1keToBeIZEVlrcCcH3MwktspOADJaqrA85tOGjrPHPsBOo7hfEK/Cer7IYJPdW7m0xLgAsFcLeilZTmu3PF+Fl7k5XxO6QX5uRXoIKVe3Lg1XOHJjfoAW5SeQ444M28ttAzPp8dVKE/bsCuMLUFzngzN3GLZQx8Eaar/DGkY6rj8ktM+XDKXMhvpJ9sEsKzo0wG4DAPvCPEo5fC8z2zSteY2lpjJWwB/IFZnNAfP76AplYpYk/usLnPFmHOCXNDh2IfeyhwVLChlK9p8KVf2/5qGXmwtTSN2OZvWzhew1sEno7cb3OIuCgHknsXyP3rUWHXEbgrSl/rqdHR8jxUL96Pcf0wJRCninZCyjgYZ6qCT5e0rQTJ2Y+ajIN6Dr+vbAKZEx8noAHQBKcW62aYSmC5A8u8z9t5/7qybIX4SUcvggMHbhuJYhpQi4iVHd1GI/2GZREIPJz99PcJtjZhKcmnhTcSa1zck3i463r3CDCj5PjYsRoZ8UTMlrOzKUALGxLt6XnvenQRziovdE+dNUwLF0Vnly8RZ53JpodchGscYtQ18lAh/DC07H+2p3gdBYmQxKHriv3xItw9md7OhLL0Q7pRVtNNFHDx3sM2uF+GXqDyJsyG3l5HRNg5MwWzasvKLzrWQxuLFlWG5aAPPpSW1WUxahweMh6Ug3C4Et3sA8PoYQtPHRG5Wm1D/UDHelfpODnVu/PBfcoNwztU36mYD+3HSh95cr7Gtlx4v5t
 EefCPWZT
 +rDZYdmjFY7ZTE7jfbElPhhbDgI3d1KZLBBYVvf/WOeguYEBvK6514HQuVNP2fjh7Al2ipxWc4U5LIG5XyPc1CgGZJYFV9i/sFw85LKSDHB9GzdwOTx1ii9osf8jisbVhgpmkweCVdlB0DW0q4doDTf8BOxyUgGC7QCkbmDxN6foBpP4uIsc7aY1CIFHkUbAFsMPruFTFAix3UFPQXIE/sH4CbGdFiiGlmj3ftF9tYeIh5oY2t4Y/wCxAJy13uG7q0nvb9dGezBMqEPoEsQwlWrIU8kDo1/j5jrpLreVCOKO1luvoHnYoyLwhyaaf/2Bp6rXzTDXvdbhmft9oDeuMTdR6PE3rX6or/kMEPCNp63iHNsPhpH4zJ+uPssgN8BgmG6chkoH/MJ/qwMoRz9Bmn683NeQ/5e/d+PXTN7qCs+tFzBxZCpSMrDRvtvoHk623YWpeIDkBKsYd2zf11Pfhpkz3Or6YHvByYyMpUJLwwIrbsxnj74gyvQP3PSEFrbZUy+6m/3gsMFj44CRh856fUS2NEV8fAkkXrujbS7W0cMJJFSzEgjeW6AtDXQfa3rrrt3rn5RpUIJRvdsMgcRkvOVDlDPky6MDpeLoX1GzYOB4v8hMvrcWJEnJGPLSDOMmIl3UK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/char-mem: unchecked runtime PUD support in
  mmap_mem_huge_fault()
--

commit 231caef4edac4da87c99aec56a1e3e64b13e76e2
Author: Eliav Farber <farbere@amazon.com>

mm/char-mem: implement huge_fault support for /dev/mem

This commit populates non-COW /dev/mem mappings on fault via ->fault and
->huge_fault handlers using vmf_insert_pfn_order() rather than mapping the
entire range eagerly with 4K PTEs at mmap() time.

> diff --git a/mm/char-mem.c b/mm/char-mem.c
> index c5761ddedbd7d..99f02d6a8b07d 100644
> --- a/mm/char-mem.c
> +++ b/mm/char-mem.c
> @@ -318,9 +318,95 @@ static inline int private_mapping_ok(struct vm_area_=
desc *desc)
>  }
>  #endif
> =20
> +#ifdef CONFIG_MMU
> +/*
> + * Populate /dev/mem mappings on fault, using a PMD or PUD mapping where=
 the
> + * architecture, the fault address and the pfn allow it.
> + */
> +static vm_fault_t mmap_mem_huge_fault(struct vm_fault *vmf, unsigned int=
 order)
> +{
> +	unsigned long addr =3D vmf->address & ~((PAGE_SIZE << order) - 1);
> +	struct vm_area_struct *vma =3D vmf->vma;
> +	unsigned long pfn;
> +
> +	/*
> +	 * vm_pgoff is the base pfn of the mapping. vmf_pfn_order_ok() ignores
> +	 * pfn if the window starts below vm_start.
> +	 */
> +	pfn =3D vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
> +	if (!vmf_pfn_order_ok(vmf, pfn, order))
> +		return VM_FAULT_FALLBACK;
> +
> +	/*
> +	 * Access was checked at mmap() time, but with CONFIG_IO_STRICT_DEVMEM
> +	 * revoke_iomem() zaps the mapping once a driver claims part of the
> +	 * range. Re-check here so a revoked page is not faulted back in. Like
> +	 * the mmap()-time check, it is not serialised against revoke_iomem(),
> +	 * so a fault that passed it can still install a page revoked right
> +	 * after.
> +	 */
> +	if (!range_is_allowed(pfn, PAGE_SIZE << order))
> +		return order ? VM_FAULT_FALLBACK : VM_FAULT_SIGBUS;
> +
> +	return vmf_insert_pfn_order(vmf, pfn, order);
> +}

[Severity: Medium]
Can mmap_mem_huge_fault() attempt to install a PUD mapping when the
hardware or MMU mode does not support PUD hugepages at runtime?

For VM_PFNMAP mappings, __thp_vma_allowable_orders() allows PUD_ORDER
whenever PMD THP is enabled, and vmf_insert_pfn_order() only checks the
compile-time CONFIG_ARCH_SUPPORTS_PUD_PFNMAP before calling
vmf_insert_pfn_pud():

mm/memory.c:vmf_insert_pfn_order() {
    ...
	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order =3D=3D PUD_ORDER)
		return vmf_insert_pfn_pud(vmf, pfn, write);
    ...
}

Previously /dev/mem only created 4K PTE mappings via remap_pfn_range(),
making this a regression when faulting on a PUD-aligned /dev/mem range.
On PowerPC Book3S 64 running with the Hash MMU (!radix_enabled()),
vmf_insert_pfn_pud() -> insert_pud() -> pfn_pud() -> __pud_mkhuge() hits
an unconditional BUG() under the PUD lock.  On x86_64 systems without
X86_FEATURE_GBPAGES, pud_mkhuge() sets _PAGE_PSE in the PUD entry,
causing a reserved-bit page fault and a kernel oops in pgtable_bad() on
the retried access.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112125638.1220=
9-1-farbere@amazon.com?part=3D3

