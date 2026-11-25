Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCFD3606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jlIaZOTi
Received: by kanga.kvack.org (Postfix)
	id C62AA6B0A0D; Wed, 25 Nov 2026 08:16:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39C66B0A0F; Wed, 25 Nov 2026 08:16:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4EB56B0A10; Wed, 25 Nov 2026 08:16:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6CD6B0A0D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:16:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 177F21C49FB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:16:27 +0000 (UTC)
X-FDA: 85473690414.24.71A0736
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1DA261C0002
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:16:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jlIaZOTi;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795612585;
	b=jC/Rgn9fCOwFuEhBpOPlo8gwcrBGJWGO55NOLUY3rdKSjTqIRc4YSTkyvkBiYXhUeQZ05b
	ll6sQN/w8R25kouHpNKlHjm3B3Z66DTetCbtuJ5N6PvWLyofxiVJY5toPXKPqxn/rY8Olz
	l+GdGohgrXO9Ez7POCeNYMotARDzmcw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795612585;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wfHfoffwgQ42eBrOdbPVaIwEE0p9xDrDHUkm0VvxXM=;
	b=w7h00yyKATAFm88GQrTV9RbCJzGv3yCRA/8OasjmcUWsIYjcHehq0dDcK+5BpX/9WGo9mM
	TRF50hF84NcBnZpwgnXNWERbmWOBi/geFOIQJgXnzd4bpPGRnZuJLaRFSbNdAqspkdr09U
	CgBsGtCVK/S+qjlJ/R1dyouAvNOGPQ4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jlIaZOTi;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8867043F83;
	Wed, 25 Nov 2026 13:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D871F000CF;
	Wed, 25 Nov 2026 13:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795612583;
	bh=0wfHfoffwgQ42eBrOdbPVaIwEE0p9xDrDHUkm0VvxXM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jlIaZOTi8mcDtMdh7+2kln3FbgU+/RW081qKz2cdmejrrCuUN3TBoE/zl4k6/8Cxa
	 UHJXDOdMczydxP+f3TDR1/rmZC+b5m/+x4dlqfbB6U7Et6aN7xv8A5h8E1uBv+aLa/
	 9u5fkoOcHC2Xzi/EcDev4rNtcuYgwF4LVKkaZNN8yjSRbRT+qdz0xO++ZQG5BZ1933
	 kz8dCKvWJbVe0dgpBmF0X4nfuMrTWvq4637wGbCIO6/yiuFCCtjtOZdBCYKCEXHrFn
	 /M3QnHXyLy64tLGGxX1LJjc7NmdR676tJmcBlWbjbc8aCWR3WjDWBT3bM/ZX9TmneS
	 FBuEqqW/e8TiA==
Message-ID: <sashiko-outbox-233479@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/5] mm/char-mem: implement huge_fault support for
 /dev/mem
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eliav Farber" <farbere@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Zi
 Yan" <ziy@nvidia.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jann
 Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, linux-mm@kvack.org
In-Reply-To: <20261124131510.38745-5-farbere@amazon.com>
References: <20261124131510.38745-1-farbere@amazon.com>
 <20261124131510.38745-5-farbere@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:16:22 +0000
X-Stat-Signature: ii9aetm9ttx8u5xa4r3e94xrde3m3kzz
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1DA261C0002
X-HE-Tag: 1795612584-92897
X-HE-Meta: U2FsdGVkX1+dYihl0I4ERhzkji4WgBDYAc2uUZt8gmAN4wofxd1k8exkA7PLvu2o1YKSRiv8BvlIz5jG8n9xrlshHZQ2npM9/CddeOZdBKzvOp8+K9+0HXE9z/QJ6HLBQtueRQIq8ib8isXffWb0tQLb6Jfsq3My0XX5425fxfYTFFN4LVisOjbwiPbVd6luYRcZbC9SHNeIeTqHiXgEub3pkm+Xz9JrhXnUSRSaKP+AvywgxdH25fXfrCn01uRlQ7d6gIXEbQeaT0ZLp7GhQ49nuhodFh+BUrv8mBlQYibArKDl2JnqyfJNo/9C2W9rYChg6BQUjjRGT+ScolfjyXyapOw6hk28+JZi0iV7rO/WtsE4Lewi9aS2np8e/RWSAbyQZoXWiHliHuObVfZSelsvpTh36uLObB2pMT8PJXquW4aFM4Chql8Yg4w/sPI/TF1ZU/dS+m1XD5usphKxZQRIjA3vUY3w5t/fTRPXxBhTmpFxrrDAnLtkThmRvCWWYrn6oTU7iyuDRYMjgZRk557nP8gMWOQL5VHUb8DjF1X8+GmQGSoOEaDmRc/cuAxHj/6BvI204n4mVLxnUgxE11gM1qJpb8b4HiHKQlPcOQBv8YKDPlIfcdFGhLnJecTBeUS+zIoZfp+uVqj2OawpCNMZPExOO8q/f5SJY4pOmU4y/UerHnv+z8FVX5nV9IyHxWWK93CQJuslGhsfuvB7mFfSfBAmq2Oec914c2LLfjVaMtgk8Joj36FHqdLw4UpadjX6EoVpwcL6K+5c6VbIMpU68j3D9dP0cr1CmjEFJtopYE3LsD4u7sMJKZ9mSzSw69jeE+PIDhhQ9JJ8nHba+MEump44+0gqfkvQuF4tgO7hxNzV0QYiYnJ49EN2VEStvAZxjXp2o593a3IN9FR//7UNSKj0WIF7Bf7UWkwoS6H0YSheEzDnx9amBzQOqez01Ooni38fVHe/Kpn++Dv
 pS6XTAv7
 45DTNiwIHv7Twm9AyADTA7P336C2IRlmJoxjKLIReOOkAr5Qehbu7tJgPY49W9ckQoKkWi1l15C7k2SLKwQMx0GxbPp0jbR8V3P/hZTuUEP0P/kp3V1fJZNPipV4tzsNM8p0INlvXRudVqdtKXTo6NgBtsYux4fXd/6T/J9GL+KOnVzIDuVSz0IhihhjKjrDf5A1Wvz1aeQShNnLz8TMWSWWoxXeorcC6x2tXsNqqL1x4XnlwXNqdNs3leXwAwa5vH/UbuObuYVk75TNUjyxqtCEjVH7TdEOdTdAg6yQCzDqvprQ4wpF78skD4TSWGZ10ch+uuofGtck0p6nHg0ZBzc+DA+0weOb9j1dYait5//b1+L5KGJdJEUH7RsojITisVArK63xxTrYCRDu68JbUfB9wC5MM2xbm1D2PUuxY03azzFOMQxoeW+vVOt8DnXfC55mQnd1GB+Qf4NRtr1wGnCQxZERzbzVPOYOGicao/GZ09As0Pow33+PcO/qdjRZBJCTneLkh4cW/o17KqGxQtQ2fMqE3Uln7w66O0egybjGVDH0YQ+CjWaeD4dkpg5dfMDJRf4anCbxho9fdeb7t+CGDyafCajDSSp4euIGqtdZlJhzmXlYPoFwojvFhf4rd9PRNWoprnqCRMyxNL2qhLXSee/1SrxWurva/tyd7vZKGSruVJuq2+cuINRl22HKwp5XhtZqmVmHBo2jTSWoObF2or25dljqlQhPVSdXTSWoA1UC++BXIRSKnhRv25AwWdbawsdNdcDMjmk1olcETWp2m/GyQbwcauFNppT/4bBEqJ/BFn6bZkR8VZ+h4rPUqBGPes/cL9HDAUmtag2LKYpqRuNZTL/FcvriiDDSrpZaSb+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] mm/char-mem: unchecked runtime PUD support in
  mmap_mem_huge_fault()
- [Medium] mm/char-mem: missing thp_get_unmapped_area in mem_fops
  defeats huge_fault
--

commit 67f1816619b76ea83350a58c506176be1eb3bbc4
Author: Eliav Farber <farbere@amazon.com>

mm/char-mem: implement huge_fault support for /dev/mem

This commit changes non-COW /dev/mem mappings (when CONFIG_IO_STRICT_DEVMEM
is disabled) from eager 4KiB remap_pfn_range() population at mmap() time to
fault-driven population with ->fault and ->huge_fault handlers using
vmf_insert_pfn_order().

> diff --git a/mm/char-mem.c b/mm/char-mem.c
> index c5761ddedbd7d..283531645f185 100644
> --- a/mm/char-mem.c
> +++ b/mm/char-mem.c
> @@ -318,9 +318,68 @@ static inline int private_mapping_ok(struct vm_area_=
desc *desc)
>  }
>  #endif
> =20
> +#ifdef CONFIG_MMU
> +/* Populate /dev/mem on fault, huge where the arch and alignment allow */
> +static vm_fault_t mmap_mem_huge_fault(struct vm_fault *vmf, unsigned int=
 order)
> +{
> +	unsigned long addr =3D vmf->address & ~((PAGE_SIZE << order) - 1);
> +	struct vm_area_struct *vma =3D vmf->vma;
> +	unsigned long pfn;
> +
> +	/* An order-aligned addr below the VMA would wrap the subtraction */
> +	if (addr < vma->vm_start)
> +		return VM_FAULT_FALLBACK;
> +
> +	pfn =3D vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
> +
> +	return vmf_insert_pfn_order(vmf, pfn, order);
> +}

[Severity: Medium]
Can a PUD_ORDER fault reach vmf_insert_pfn_pud() here on a system that
lacks runtime PUD hugepage support?

For VM_PFNMAP mappings, __thp_vma_allowable_orders() enables both PMD_ORDER
and PUD_ORDER, and thp_disabled_by_hw() only checks PMD support via
has_transparent_hugepage().  vmf_insert_pfn_order() checks compile-time
IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) without verifying runtime PUD
support (such as has_transparent_pud_hugepage() or
arch_vmap_pud_supported()).

On PowerPC Book3S 64 with 64KiB pages running on the Hash MMU
(!radix_enabled()), CONFIG_ARCH_SUPPORTS_PUD_PFNMAP is enabled while PUD
hugepages are unsupported, so vmf_insert_pfn_pud() -> insert_pud() ->
pfn_pud() -> __pud_mkhuge() hits an unconditional BUG().  On x86_64 CPUs or
VMs without X86_FEATURE_GBPAGES, pud_mkhuge() sets _PAGE_PSE on the PUD
entry, causing a reserved-bit page fault and an oops in pgtable_bad().

[ ... ]

> @@ -355,11 +414,25 @@ static int mmap_mem_prepare(struct vm_area_desc *de=
sc)
>  					       size,
>  					       desc->page_prot);
> =20
> +	desc->action.error_override =3D -EAGAIN;
> +
> +	/*
> +	 * COW can't be populated on fault: vmf_insert_pfn*() BUG_ON() it. And
> +	 * with IO_STRICT_DEVMEM a fault can install an entry after
> +	 * revoke_iomem() has zapped it, so keep the revoke final.
> +	 */
> +	if (IS_ENABLED(CONFIG_IO_STRICT_DEVMEM) ||
> +	    vma_desc_is_cow_mapping(desc)) {
> +		/* Remap-pfn-range will mark the range with the I/O flag. */
> +		desc->vm_ops =3D &mmap_mem_eager_vm_ops;
> +		mmap_action_remap_full(desc, desc->pgoff);
> +		return 0;
> +	}
> +
>  	desc->vm_ops =3D &mmap_mem_ops;
> =20
> -	/* Remap-pfn-range will mark the range with the I/O flag. */
> -	mmap_action_remap_full(desc, desc->pgoff);
> -	desc->action.error_override =3D -EAGAIN;
> +	/* Tracking reserves the memory type, for PAT conflict detection */
> +	mmap_action_track_pfn(desc, desc->pgoff);
> =20
>  	return 0;
>  }

[Severity: Medium]
Should mem_fops also set .get_unmapped_area =3D thp_get_unmapped_area under
CONFIG_MMU so unhinted mmap() calls receive a PMD-aligned virtual address?

In __get_unmapped_area(), the automatic thp_get_unmapped_area_vmaflags()
fallback only runs when !file.  Because mem_fops leaves .get_unmapped_area
as NULL on CONFIG_MMU, an unhinted mmap(NULL, len, ...) of /dev/mem gets a
4KiB-aligned virtual address from mm_get_unmapped_area_vmaflags().
Whenever vma->vm_start and vma->vm_pgoff << PAGE_SHIFT are not congruent
modulo PMD_SIZE, mmap_mem_huge_fault() computes an unaligned PFN at every
PMD and PUD boundary, which vmf_insert_pfn_pmd() and vmf_insert_pfn_pud()
reject with VM_FAULT_FALLBACK, falling back from the previous batched
remap_pfn_range() to individual 4KiB page faults across the mapping.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124131510.3874=
5-1-farbere@amazon.com?part=3D4

