Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35AF1606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 10:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RVjLTTkH
Received: by kanga.kvack.org (Postfix)
	id 5580A6B05B8; Wed,  4 Nov 2026 05:19:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2976B05B9; Wed,  4 Nov 2026 05:19:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7856B05BA; Wed,  4 Nov 2026 05:19:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AB506B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:19:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 79E1D1A065C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:19:07 +0000 (UTC)
X-FDA: 85397038734.23.F3C50C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C4DB71A0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:19:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RVjLTTkH;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793787545;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FI6NNzNyzqnYwtEHEWst8a+x+M7cP7h9Q4B/iWUar3Q=;
	b=UPm4hbFWeZJAR4vv9WD5xheebVWKi7ZrKtBOqsvxEU/Y1R4cOTYTmzZyhgnw6fBRutRCdB
	+/8/Mj2Jg5Ley8UOJkvYAZSWdB7HrI0IG3BLHAo97MeYquhdXqtQwMtsgWUkO1geehGJHp
	qaWbR8C/Q9Gi4ByWcgGYIj+BqC9CPsY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793787545;
	b=JMNmpH2QkvGUAVetjcmpw4lxb06RHXx9U23cfpMXq2nXNmXS5+ANRMV6bD5mZSgObbswOZ
	EOWUDlq23i8iHaL0ip8jG2X3F05QfDrGLCssQ52SoptHsZXmQmxE/Mk+slHLe/if1p4dAd
	/bVOxqkZqAVzqFBNWo8MLakIq6whkMg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RVjLTTkH;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5206860DAC;
	Wed,  4 Nov 2026 10:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BD21F000C1;
	Wed,  4 Nov 2026 10:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793787545;
	bh=FI6NNzNyzqnYwtEHEWst8a+x+M7cP7h9Q4B/iWUar3Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RVjLTTkHu1zwJUMiqXLMojPM7ZA2QkqjZEeq//rOqrPuc9Uyzqlz7lXY/sVfFXYQe
	 ZkIKR9PA4k/LybfbO5QYfto1/zmUr/dEeqiFih00lyJZiODJ8K+4apVAPauuLfy3hc
	 YDaTKnfvW8pXxlF3rtlyln3Gy2HUuVPNPe7xQ7DwwS5PP/eL6Cdl5hNrtbxgucZn8d
	 3vxPPXGUFFkEOZ+4ZCGi/4BCAsWMsYdIXM6mk2RcnDpmVhsCaGT4fx3MOdmHZJJrYM
	 reoKFIGQQbcSKovhGP3mvC6wh2ltwgFQ7nKVGUvMveHHRZeLI6nA2i461CTiQulF19
	 2TDdbyv+k3H/A==
Message-ID: <sashiko-outbox-197082@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 10/10] mm/vmalloc: align vm_area so vmap() can batch
 mappings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wen Jiang" <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com, will@kernel.org
Cc: "Xueyuan Chen" <xueyuan.chen21@gmail.com>, ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org, chleroy@kernel.org, david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
In-Reply-To: <20261103101658.766905-11-jiangwenxiaomi@gmail.com>
References: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
 <20261103101658.766905-11-jiangwenxiaomi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 10:19:03 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: 86886y8n1m99zit5z78wnnerqdwwgj6r
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C4DB71A0002
X-Rspam-User: 
X-HE-Tag: 1793787545-412131
X-HE-Meta: U2FsdGVkX1+maedb3N4RgQN3sj8qinBXpzhOrq8NB+0UAbydP17UoYAACwC3Fjq+LTz/1/CqGRDkuEnqwFEYWzHK5LHg28z9hgkss0G6TLjt3ff/PYdOXr6vKBcoDr/CT5IWM4OO4/9U73hhgyHifoZPg+9q9rZRSXoIJ8SezAfPM2EXiU/mEeb2bgfoT8E2afCbBgzfRLlORdq0NORAz/rAhjIHHy6roP+0nuWRZMhADEnIMRsuaEjzazuHU4nr50UBykE/1dHLPuUrq3rc3m9Xsfe5Q6E27DFyGgBPI2ZkJwE/Egslo6WXXZ3/BDef+yP+bmAbVi9CxBP2gDl19ZG03IRPyYp/Fk0mA6oYPsPOTV5tnZ0gPvjqFt2bPwFSHtLY0nyUyTyJWLrBRMnlWOSL2PXsrsq23dLfyjWf2YValTkz3pQQ0buVIC7vxSxj3L6ouO3a8/H8LkNuRk3s9uCsghye6QSpfz19RQVcracxj69RjHFh7RmglP8FUozv/CC8bMlWMoA7NQe8mBt2BnL4TD7n5UYCB0oVKtQmkjxaL2IM0TnATcyWatJ9nxm99qGmCyX1WA1MblTFAbjyIxt6UQA6RtzfspGDPf+RiPTU4pcKOfdYd2tevjVFwx0sfTigeWaK+jX0hh3CFJ4wUzbTXMRqVKcZzwngU5zZrHDZ433XRvSV//xB4S2ai+98ZRbgx9H27/y9ARa+NtZv6cZ0y0Aj0gEb1nEN+f7WxPf9sUM7ZDiU+aRj8ornHRgHk7vYLx7L3RQs1QAMqI8x8axkR93k4W8zGZW494WAuBNoWD7QQrc/gp7KPh3XLsMIooqtN5FvyyvcTkeRH78NSrdEbpHVO8mA+OtJaSpuoTTXIqxWTYtxbUlSBeQo1szMAGTzP76aO50vgUr7JRZX0aEyOj7c0E+7Eu1rk08IZatBUZqDNre+/f3uHQmHeXL7k+nbEyxE8fCoETixTlZ
 KM4B9TRz
 s1L55Xzs4MtXJC3dqt0eU0sGUVyPaz6MZRncNnISCJAj5tFeQo2kU6dP1Nh/2VE67OEOHmAtNJKspcjfXnWfm4Bg9vmf0WWA4SoH9ED8ZZ1cPFwWblhhNnUAMA8YOryFr37fT9H+uYhZKVy0NoEkeFy/toiOMafi+tIqgNZ871IOwtcUz6aiSILnrtXMZ/gHZ/0dtEVrbHoqdlI5Ev0+DsCxv0hOHG3U346H0DTEPugSrUwWOQFw41za8K204yznq+sUGN2+UXOmK0GSrggHrQeqsV0XFdDE25Zy42QRH1xVTm+1FVH9iLxdCq6wjHADi41D/cQ1AL2yK87ybeJsSjqijUrEphHEPYcE9jeOQsGG9me2qEcFxa9DHCOtOEtJQVrc6gJaorByhSjpm+t7aljRXoL9U2KmWvdZpd7j4GL3PxKjVMNTjIz0DexslHftchcR9S4EyDINnmMLM5NwZ23IyBfwf19BpUY2WojpiTW7dqHjUA3r356hGUgFAWHXbauc30bPsGPvA1wLtQCihLxGORVVHHSTUkma2rNWMGVY/hNYVDwGbnluyFr/pdLJ49gR2InQzGmrXXKg1RZ7pkqRevFd9CdWLnfe7JlSANB2zrppp6nfLfQNkBPmpShrhMQfshbPtSZZmyUrD72T83tNag5uyxE5y/2R7UqxqelZXX3tJEsFCVaSb11Tbnh4o2OV+N292xkIVP8P9NYgV84OlAvGhFA1MGv8e41dUicGUkOM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] mm/vmalloc: out-of-bounds physical mapping in vmap() across PM=
D boundary
--

commit bba985c9d433d420f66d2ffcfeb47090bbcf7552
Author: Barry Song (Xiaomi) <baohua@kernel.org>

mm/vmalloc: align vm_area so vmap() can batch mappings

This commit aligns the virtual address area allocated for vmap() to PMD_SIZE
or the architecture-supported PTE batch shift so that contiguous pages can =
be
mapped in batches.

> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 42b3addd20f98..e15bcef804fc3 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c

[ ... ]

> @@ -3692,6 +3700,30 @@ static int vmap_pages_range_batched(unsigned long =
addr, unsigned long end,
>  	return err;
>  }
> =20
> +static struct vm_struct *vmap_get_aligned_vm_area(unsigned long size,
> +		unsigned long flags, pgprot_t prot, const void *caller)
> +{
> +	struct vm_struct *vm_area;
> +	unsigned int shift;
> +
> +	if (arch_vmap_pmd_supported(prot) && size >=3D PMD_SIZE) {
> +		vm_area =3D __get_vm_area_node_aligned_caller(size, PMD_SIZE,
> +				flags, caller);
> +		if (vm_area)
> +			return vm_area;
> +	}
> +
> +	shift =3D arch_vmap_pte_supported_shift(size);
> +	if (shift > PAGE_SHIFT) {
> +		vm_area =3D __get_vm_area_node_aligned_caller(size, 1UL << shift,
> +				flags, caller);
> +		if (vm_area)
> +			return vm_area;
> +	}

[Severity: Critical]
Can this cause vmap() to map out-of-bounds physical pages across a PMD
boundary on arm64 when pages[] contains multiple physically discontiguous
chunks that share a mapping shift larger than CONT_PTE_SHIFT?

In vmap_get_aligned_vm_area(), when size < PMD_SIZE (for example, a 1MB vmap
composed of two 512KB order-7 chunks on 4K-page arm64, or an 8MB vmap compo=
sed
of two 4MB order-8 chunks on 16K-page arm64 where PMD_SIZE is 32MB), or when
the PMD_SIZE-aligned allocation falls back, the virtual range is only align=
ed
to 1UL << arch_vmap_pte_supported_shift(size), which is CONT_PTE_SIZE on
arm64. The same alignment also occurs for batch_start if a PMD-aligned vmap
starts with a CONT_PTE_SIZE chunk followed by larger chunks.

In vmap_pages_range_batched(), get_vmap_mapping_order() can return an order
where shift > CONT_PTE_SHIFT, and consecutive discontiguous chunks with the
same shift are coalesced into a single walk:

mm/vmalloc.c:vmap_pages_range_batched() {
	for (unsigned int i =3D 0; i < nr_pages; ) {
		unsigned int shift =3D PAGE_SHIFT +
			get_vmap_mapping_order(pages + i, prot, nr_pages - i);

		if (!i)
			prev_shift =3D shift;

		if (shift !=3D prev_shift) {
			err =3D vmap_pages_range_noflush_walk(batch_start, batch_end,
					prot, pages + batch_idx, prev_shift);
			...
		}
		...
		batch_end +=3D 1UL << shift;
		i +=3D 1U << (shift - PAGE_SHIFT);
	}
}

When [batch_start, batch_end) crosses a PMD boundary at an offset M into the
first chunk (where 0 < M < (1UL << prev_shift) and M is a multiple of
CONT_PTE_SIZE), vmap_pages_pmd_range() splits the walk at pmd_addr_end(addr,
end). The first PMD maps the initial M bytes of chunk 0 and advances *nr to
M >> PAGE_SHIFT.

At the start of the next PMD (addr =3D PMD_BOUNDARY), *nr points M bytes in=
to
chunk 0 (physical address PA_0 + M), leaving only (1UL << prev_shift) - M
contiguous bytes in chunk 0 before pages[] switches to the discontiguous
physical address of chunk 1. However, vmap_pages_pte_range() still passes t=
he
full shift =3D prev_shift to vmap_set_ptes():

mm/vmalloc.c:vmap_pages_pte_range() {
	do {
		struct page *page =3D pages[*nr];
		...
		pfn =3D page_to_pfn(page);
		size =3D vmap_set_ptes(pte, addr, end, pfn, prot, shift);
		nr_pages =3D PFN_DOWN(size);
	} while (pte +=3D nr_pages, *nr +=3D nr_pages, addr +=3D size, addr !=3D e=
nd);
}

Because addr (at PMD_BOUNDARY) and PFN_PHYS(pfn) (at PA_0 + M) are both
aligned to CONT_PTE_SIZE, and end - addr covers the coalesced second chunk,
arch_vmap_pte_range_map_size() returns the full 1UL << prev_shift:

arch/arm64/include/asm/vmalloc.h:arch_vmap_pte_range_map_size() {
	if (!IS_ALIGNED(addr, CONT_PTE_SIZE))
		return PAGE_SIZE;

	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
		return PAGE_SIZE;

	size =3D min(end - addr, 1UL << max_page_shift);
	size =3D round_down(size, CONT_PTE_SIZE);
	return size;
}

Doesn't vmap_pte_set_huge() then map 1UL << prev_shift contiguous physical
bytes starting at PA_0 + M, overrunning the end of chunk 0 by M bytes into
unowned physical memory while advancing *nr past the first M bytes of chunk=
 1?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103101658.7669=
05-1-jiangwenxiaomi@gmail.com?part=3D10

