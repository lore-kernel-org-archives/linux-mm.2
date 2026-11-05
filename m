Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F286D606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 07:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nZ0sycGB
Received: by kanga.kvack.org (Postfix)
	id 198A96B05B0; Thu,  5 Nov 2026 02:16:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A4E6B05B1; Thu,  5 Nov 2026 02:16:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05FB26B05B2; Thu,  5 Nov 2026 02:16:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D119E6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:16:53 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B46E61A0983
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:16:52 +0000 (UTC)
X-FDA: 85400208264.21.5EDCB00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1532A40009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:16:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nZ0sycGB;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793863011;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oejeWNhQX2tZnGny/UGddApTW2mUljlFgEnUYOZYHz8=;
	b=INPlvz8HcaN4ApLrqxO4eoP2PFF2wRvFRVgzPeXDQH8CUebwXRBxxfFUNtrd1UeCG02jqu
	0s3qXRbMx37wmSPSZiRQVO6SuI+X/vbANAYc5W1ZzKbtdkkTAGABlgAvi2qK2hSN0hE4U7
	VShOWqv/lT++VL2Ci8PPZLD0CeTJLDA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793863011;
	b=H6Zg/gKg2FMiX7PMptae1h5OzbXjGlSfk31ChH15EgcBg389KndIyVUjo3IvrY71Z/+1lB
	7rxK+DDRKYYl8c+gAZ1xZ/kEC1JEUG1oBO/OfoM/6YWUw+V+Hrie/FlUTd6jKQnAExf6Uu
	EGW7YPUTGd/52LgxpJBJPyN38d9Yv5k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nZ0sycGB;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5197B60213;
	Thu,  5 Nov 2026 07:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7871F00919;
	Thu,  5 Nov 2026 07:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793863010;
	bh=oejeWNhQX2tZnGny/UGddApTW2mUljlFgEnUYOZYHz8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nZ0sycGBAxvzOQlpEE7wGvPoWFX47ogBO3TANDIIIASrSXAWHfkI03irpSQJBlT9M
	 SRXGKWD3UGa8Qx82oEwpRONezuJHT0Jr+TchBCAVYZWQk7aRlUkWyQ17uq9prjVoHs
	 hJIXwzhVlYTpJjbzA/cOl62UUhhgYPRgYKF3clJzAhV35amMKiSrE8i0zxE+cSq74F
	 s4+agZEUsAPtrBTUeomgbDUYtFM4P1zMbL1H03fScBw5DIUkyS3qmO4AkMuedkxyC6
	 9afUAsOdzMuDSVQa0bonkIsJCPD7hxJo6SX38zin9378io5fUiOI2pm1rWzsuOfKxS
	 PnuUPH6GN5I/Q==
Message-ID: <sashiko-outbox-198652@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/5] powerpc/mm: drop powerpc vmemmap_can_optimize()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "David Hildenbrand" <david@kernel.org>, "Madhavan
 Srinivasan" <maddy@linux.ibm.com>, "Mike Rapoport" <rppt@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "Lance Yang" <lance.yang@linux.dev>, "Michael Ellerman" <mpe@ellerman.id.au>, "Nicholas
 Piggin" <npiggin@gmail.com>, "Christophe Leroy" <chleroy@kernel.org>, "Ritesh
 Harjani" <ritesh.list@gmail.com>, "Shrikanth Hegde" <sshegde@linux.ibm.com>, "Oscar
 Salvador" <osalvador@suse.de>, "Qi Zheng" <qi.zheng@linux.dev>, "Muchun
 Song" <muchun.song@linux.dev>, "Huacai Chen" <chenhuacai@kernel.org>, "WANG
 Xuerui" <kernel@xen0n.name>, linux-mm@kvack.org, x86@kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261105061217.13302-3-songmuchun@bytedance.com>
References: <20261105061217.13302-1-songmuchun@bytedance.com>
 <20261105061217.13302-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 07:16:48 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1532A40009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: xkemyyt6fgucjq8rfbmtaq56mcd3dq61
X-Rspam-User: 
X-HE-Tag: 1793863010-494548
X-HE-Meta: U2FsdGVkX1/79exC79gnUT64GfOUWQvBo103Tp/1LFFF2LYlSx7sP3k3qpFY6zaOTZ1TU5b8s753sUiT325Zn5TJxr2C98V75nDMuiKggAytVsrLhegpQ1z5BkkatSVsOHxXbLOL/9Eo5FVTCJPX7eFvEPRbz2FyYICwoRls6NF18oHuwuJogR7EOAn7eiiArWj8HKEb0tkvkc+ttzGlzI67KMDU17eQCNV1xpavFjry7wxn4TkxM6dnNCdlRyysSKZ2DWsiCePKVcHkuUQvFp/XP7DBXeyBCdfJHvxWGpcZ69guz/p8JnVVaZZwyomGF5Yr4v62wId1KmDVtK4bi+LXpt0iyqE664VXIcVIIsg6u4ectw9GKZh+m1VegBEk6hI+r0Haxv/tQfeV7EmIVBgNmAThtDMVAfO0b8bkI8R/hqI//lgG42lnBxP+H7X4dsNj2VD7AP0yHNQZYTi2sQqiPU0+jJye1udfWe12962JtfdKK0YyBaIHW7nnX5RzP7PgoOfT7cSfQbQAl5Rr//9xCFY6dtSE/YjGSXI/EUDWGwkumXtk+45TxuPNiF0ZNZd+WORYz8Q/85Wc7E4vwP37uY/Yf1GA6QP6Wewlys1rDEFJtKDmRJRk+3mFuVy2TL2BHGLrkOsB+wuvrRiPphd0fCzcx5s7f9fRZsLpIoOlPajkvNFf2rnQnBnvJ54Ds7A7j5DftEaJ7JPPTfnRnphbzLq1FGHJO+sP7KqvBb+sjPRisWsJoMFboi3H1NMPHzach8766gwJjSjdNykK7HyNmPaqyahjxF2LXS5PH8UFj5e8RekRN+bAoyF7N36edxrf21ZjQ+Tm4c4t6JDNkPH9u40Ejs0C+71Uvghy0mEsgC8To5ENjdDcAt5LDO9yD81A0hyC/U0jZi1YGKU3OIClGpWjAD7M+jU/PhERxq5ICxWwEsLsHTKft3RkKH+JVKJmjwpqkH/pKEfbi5L
 Ajucil+Q
 kVhiFNVlgP4fmxnzODO4tcNC6I+XegV8wz+xQnCx7Obuc/r0wGJkjWMjG7Lea6YcVlJZVuJ0OntublEi2TTc6Q6sHfXL4r/ekmtweuIUYeej4ekgKrNgHR24351aufwJ7cci1RhRXIu86NA31Lp0G0FYhGDJSvyK27pLkCpE8nEylKk4mFDmK4lX4MKU34MHPbsmZg2RVe8162sV+3Gmh2W2ah9QkJhQ8kW0mo1A1tvhxNOQsqE3QaWDYH4OnS5ZBzjYIEz+ynfBjEM5PbfCE0bOdm7s+dXJ2ua5bEggiX5MGG9ZucLcv5omTYWkZ7CGtKBW20sIYV1526fjtM7v6YHoP1Xjjowpqg6ed5eJ5nXRe2TuEqxVc65H/oyKc2kKESfls4uaQNgbgiewOnDWXc68tGQlQGuFXwk2Gu6dLj8t4w8wnRUmAGp6ZB3fsMod7VVqxH2MRy35mN33+7XSEbxnsDe7QsM7YPy1J3Z9e9C9+w2MviIbAwhIRGG6Ii0b08OUPZiGul5EGgBwHQRa82h0EYWlvAeha33I2506NTvTmRiCj/qLnRsITagucUdhIgXdJ7uRuM7PV14XeZqosr8BoEAIyR/hMI0eVIwkay7f6Q2F3H0J7b9aZ6ifANPwIA+kbBZWRz1iSyb1zHJgXUD9Gt3X3hI1rI1BURN8sMWfzw5NaO3wUy8EDOG1H4YBiqVkE281hPfMQeLF8MgbjLXJhHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] mm: undeclared vmemmap in section_vmemmap_optimization_disable()
- [Low] mm: define vmemmap_optimizable_order() before section_vmemmap_optim=
izable()
--

commit e51c76b2ae2d335e25edd03780c815eb467b564b
Author: Muchun Song <muchun.song@linux.dev>

powerpc/mm: drop powerpc vmemmap_can_optimize()

This commit adds section_vmemmap_optimization_disable() to disable vmemmap
optimization in architecture fallback paths such as PowerPC Hash MMU, and
removes the PowerPC-specific vmemmap_can_optimize() override.

[ ... ]

> diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap=
-optimization.h
> index 858311a71b0cc..5c09da4df4d83 100644
> --- a/include/linux/vmemmap-optimization.h
> +++ b/include/linux/vmemmap-optimization.h
> @@ -57,6 +57,27 @@ static inline void section_set_compound_order_range(un=
signed long pfn,
>  		section_set_compound_order(__nr_to_section(section_nr + i), order);
>  }
> =20
> +static inline bool section_vmemmap_optimizable(const struct mem_section =
*section)
> +{
> +	return vmemmap_optimizable_order(section_compound_order(section));
> +}

[Severity: Low]
Will moving section_vmemmap_optimizable() here break the build at this
commit when CONFIG_VMEMMAP_OPTIMIZATION is enabled?

At this point in include/linux/vmemmap-optimization.h,
vmemmap_optimizable_order() has not been declared yet and is only defined at
the end of the header after the #endif for CONFIG_VMEMMAP_OPTIMIZATION:

include/linux/vmemmap-optimization.h:
    static inline bool vmemmap_optimizable_order(unsigned int order)
    {
        if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
            return false;
        ...
    }

Compiling translation units that include linux/vmemmap-optimization.h with
CONFIG_VMEMMAP_OPTIMIZATION=3Dy fails with an implicit declaration of
vmemmap_optimizable_order() followed by a static declaration following a
non-static declaration.

A later commit in the series ("mm/sparse-vmemmap: drop
vmemmap_can_optimize()") moves vmemmap_optimizable_order() above the
#ifdef CONFIG_VMEMMAP_OPTIMIZATION block. Could that move of
vmemmap_optimizable_order() be done in this patch instead to keep the series
bisectable?

> +
> +static inline void section_vmemmap_optimization_disable(unsigned long st=
art,
> +		unsigned long end)
> +{
> +	unsigned long pfn =3D page_to_pfn((struct page *)start);

[Severity: Low]
Could calling page_to_pfn() inside section_vmemmap_optimization_disable()
cause a build failure on architectures such as LoongArch that include
linux/vmemmap-optimization.h before defining vmemmap?

When CONFIG_VMEMMAP_OPTIMIZATION (and therefore CONFIG_SPARSEMEM_VMEMMAP) is
enabled, page_to_pfn() in include/asm-generic/memory_model.h expands to
reference vmemmap:

    #define __pfn_to_page(pfn)	(vmemmap + (pfn))
    #define __page_to_pfn(page)	(unsigned long)((page) - vmemmap)

However, include/linux/vmemmap-optimization.h does not include a header that
defines vmemmap, and arch/loongarch/include/asm/pgtable.h includes
linux/vmemmap-optimization.h to obtain MAX_FOLIO_VMEMMAP_ALIGN before it
defines the vmemmap macro:

arch/loongarch/include/asm/pgtable.h:
    #include <linux/mm_types.h>
    #include <linux/mmzone.h>
    #include <linux/vmemmap-optimization.h>
    #include <asm/fixmap.h>
    #include <asm/sparsemem.h>
    ...
    #define VMEMMAP_ALIGN	max(PMD_SIZE, MAX_FOLIO_VMEMMAP_ALIGN)
    #define vmemmap		((struct page *)(ALIGN(VMALLOC_END, VMEMMAP_ALIGN)))

Because section_vmemmap_optimization_disable() is a static inline function
parsed before the vmemmap macro is defined, doesn't vmemmap remain an
undeclared identifier in page_to_pfn() when compiling on LoongArch with
CONFIG_VMEMMAP_OPTIMIZATION enabled?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105061217.1330=
2-1-songmuchun@bytedance.com?part=3D2

