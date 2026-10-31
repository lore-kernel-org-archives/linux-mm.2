Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49813606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 00:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h17If4ym
Received: by kanga.kvack.org (Postfix)
	id 4E6C66B05B1; Fri, 30 Oct 2026 20:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE236B05B2; Fri, 30 Oct 2026 20:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB5E6B05B3; Fri, 30 Oct 2026 20:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13F586B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:54:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 829411A090D
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:54:37 +0000 (UTC)
X-FDA: 85381100994.24.684A8DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C9BB1A0002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:54:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h17If4ym;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793408075;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UeX+wdDShRmhPelNetjZ+aWPVWfNItPj8vq7heLDX1Q=;
	b=D/lgwFy9iYhKl9Q1IT3Na9tWVeQynuP18P0yZ2KoF9fZoealZi7u30gNeKaYxRxWBFxtek
	P0Q1t5EUu0r28nsX7Oe5ie7OlRjZrxZQvPN+F1TtPxZQoTkl1x9C1TcIHkiRQ8dj9CEDfv
	csPfm2h4wBBfKODJYaquT+ESFxmzDiE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793408075;
	b=agcOC3YSRLffEXkJZwcy0zaPrqc/eFC/iQKVRIMITlv9QiyvHhuF/JdyysnXxlxz6IG8XH
	Jqc0+hsFfaiproJIIL/ylJmeMj+gtDl3Z7UGEvLDkbO6EyyHDxFq5qLcWOloE9EXOGqwLg
	Gry9AZIAr0UigcK385HQwrK3S5dg6fs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h17If4ym;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A4FA843617;
	Sat, 31 Oct 2026 00:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A687B1F000C1;
	Sat, 31 Oct 2026 00:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793408074;
	bh=UeX+wdDShRmhPelNetjZ+aWPVWfNItPj8vq7heLDX1Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h17If4ymRuQeHDvE6GWjSOg6n8BQB36Rr7jWpMqe2IbSBhAFzZapSK/FPlVBkp1jw
	 WBaEkb/oJG89kFx6e34XvY5t149Cw8YqOyeLsq4EhvTkqlPku0Egnhml2lCNAVM8lh
	 mRXtNQYnOafN0TNbAhJtBUQ7axwloxhSFZEHaiHlk55Dz6kv6huTZBPvk785aHP/fE
	 tmpLrgJbF1TCyo6hoAlUtP7P+L95btmcIhJ8rrUgEB+n2ywIVFtVz+YqRddTiqqH5L
	 w/dac6Jnxlh7pqjvyM5kKsoDblbvBDSBp14fmUuMdIh4lGiugSwyCeKGNmkmPwj8dg
	 BFTAY+SHwBZEw==
Message-ID: <sashiko-outbox-191687@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] mm/sparse-vmemmap: drop vmemmap_can_optimize()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "David Hildenbrand" <david@kernel.org>, "Madhavan
 Srinivasan" <maddy@linux.ibm.com>, "Mike Rapoport" <rppt@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "Lance Yang" <lance.yang@linux.dev>, "Michael Ellerman" <mpe@ellerman.id.au>, "Nicholas
 Piggin" <npiggin@gmail.com>, "Christophe Leroy" <chleroy@kernel.org>, "Ritesh
 Harjani" <ritesh.list@gmail.com>, "Shrikanth Hegde" <sshegde@linux.ibm.com>, "Oscar
 Salvador" <osalvador@suse.de>, "Qi Zheng" <qi.zheng@linux.dev>, "Muchun
 Song" <muchun.song@linux.dev>, linux-mm@kvack.org, x86@kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261030140720.1256062-4-songmuchun@bytedance.com>
References: <20261030140720.1256062-1-songmuchun@bytedance.com>
 <20261030140720.1256062-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 00:54:33 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C9BB1A0002
X-Stat-Signature: zyp8x91h48gnonmy79nu8eq5p5qu3ywm
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793408075-817175
X-HE-Meta: U2FsdGVkX18DyhPkIQ1v7+QLHHlsqKgU2lubqYCEkw7BThZ3jEmk0d/MQTXTQJBKEWjcMQQfyeVUmAMjd/Rd7iNpA+ilFaBtxdj7jTM26dr6sFiG8m8U4AbsPtHLfaeuFjr1B+YFWdOAA6CJBOSm6EWhNr6vxJtpz27lcvYroBY+95b5t84c95xZQHnliysVYFRm32EPAHnKHKWwzJzpF7J5dbIofumS9vabu6o2jOQpWMi5ue+t2FFkuNyrqSaRx/F+U60XfTVUbx061CgTs8etDWcz5r9uL7uKwYh3pNV05lX5IaNSCXo1Oee80QawsfbwFBCrAzhw0TkxbepV91tHZysG33K+v/+cEUtRiIRONwFa/r9fjS29jsyf5DJmxqcO7bfORieOXq5pKc3Q8WBy4XqwN8fg0q/7SZfBd+nar4Mx1BREh7KTPaBevtQCjO6CoAxOy6vmHevOuc9fovJgcOtK/sw/gy24yFLumb2grHA7lTw6gjRn4v8aBDooitKJSeMO2cz1h/1OZjm/944MejMZT56d021AsQhC9EUepc3SfapNs8S9KD+5fEaBKZQLJehXxIYn1tXOLzCBtLDQOn91TycBcUFrAeP0LCKOWOAw9kqq+46kv91qNi65j6G7HQV07VyQqjXtPACdFY0uMTbqcOxU1utSD1306BShiDvraF2iqrwCjlSW48eSgzlG5Cg1LOr2ovricbi5G1BQcbGHtxUjZ2pQA7m7EyyxCjUb6VET3i1D8+6VjL8x7bvfdOr3EkBbuHpwGNC2uoMuLLkOwMg6MGWqcU4T28o6+jUFErphME4EbgEkjyh+AO+Mdn3sHCmjvN0veW1aC+n9Z5Y+rSf1inwMXybqcC3s/z8iN2vbyMfZxE26fsw4PWULNP8pOSnHxYCKObP3RX7hWTGVsUQsgA6SM9kKAW+ijGC1VKzZGOId6HTW3VA3HGrI99R3iAK4sjJPfVL
 Oj4QEkQk
 KoEnjEKGX7CjFYAQjmweAn6+dzGOSHEFd2BBt58/I7fz6Cij26gN5/Og6PWDdUcPZKvEDyS0AHCJ5V5fL5Cf+UQm+l+2yQCgQI8nJosJKf9uGlQhpS39N/uyRvnDewO+1LdbiymqUziTdNnY2GcGLhQ3CMI4soa/4gN9tOyQPNKWVyfgpkKj/fTaqoDnt6e8W8KCTTqedMaML9qGYF/6m0FoiDPTRjNjM5UZCTlNBE4dADdCRyJSnzHIU9ntg1ci1f7W8NbjCxNxzU4v8I+Q+NYi9iHG2o2clIl/7Ms+GkrJaU0dd/sIUeP343eX+LIf1Z0NO0heZ2+7aN/GjreuEU39lOgjBvwyYITROfQaVwm+y6bZkXNl2WBPsuBl5Ekn+Y3mEDTIlC5Bg4r1IxmbyL9EdVjGjdFt03V9J8KL+eZjxdJh/JTPfNLvVelMAZOZSro3HxHZRxQtMzgnt3Z8CIQGdugXlWTurVmbh9Hg62/yI9626XpCoFUon9JaZ0URDsZ+dt5WbZM5OcuWEPKHHSbY58qzZ8aiwJAfKEEPJ62Fh0hp2JXwXBSOIjCANSiZtXnborsSpt8TAuaKhewnUhokbu8j0znoUU00FRjrSgHQyg8CBwx4ehIgb49GhV3STMWwps0g/DL4b0RzG++jaMGYwKfwiXUUplRijbTAaBa2c3wQjqYUoVlmJ4i4xDoxx/vefwJCtonX9o0cWT+7rE3xbkg==
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
- [High] mm/sparse-vmemmap: dropping vmemmap_can_optimize() bypasses DAX ar=
ch config
- [Medium] mm/sparse-vmemmap: section_activate() stores non-optimizable com=
pound order
- [Low] mm/sparse-vmemmap: missing header include breaks powerpc init_64.c =
build
--

commit 4171e4b9fc2abb84bf0e245a60563f33f94a263d
Author: Muchun Song <muchun.song@linux.dev>

mm/sparse-vmemmap: drop vmemmap_can_optimize()

This commit removes the DAX-specific vmemmap_can_optimize() helper from
include/linux/mm.h and relies on section_vmemmap_optimizable() to determine
whether a section uses vmemmap optimization.

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e875f73b0c6ff..4fb48fbe712d2 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -38,7 +38,6 @@
>  #include <linux/bitops.h>
>  #include <linux/iommu-debug-pagealloc.h>
>  #include <linux/kcsan-checks.h>
> -#include <linux/vmemmap-optimization.h>

[Severity: Low]
Does removing this include break the 64-bit PowerPC build when
CONFIG_SPARSEMEM_VMEMMAP=3Dy is enabled?

In arch/powerpc/mm/init_64.c, vmemmap_populate() calls
section_set_compound_order():

    section_set_compound_order(__pfn_to_section(page_to_pfn((struct page *)=
start)), 0);

Previously, arch/powerpc/mm/init_64.c got the declaration of
section_set_compound_order() transitively via include/linux/mm.h. Without
including linux/vmemmap-optimization.h in arch/powerpc/mm/init_64.c,
compiling it will fail with an implicit function declaration error.

>  struct mempolicy;
>  struct anon_vma;
> @@ -5395,42 +5394,6 @@ static inline void vmem_altmap_free(struct vmem_al=
tmap *altmap,
>  }
>  #endif
> =20
> -#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
> -static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
> -					  struct dev_pagemap *pgmap)
> -{
> -	unsigned long nr_pages;
> -	unsigned long nr_vmemmap_pages;
> -
> -	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
> -		return false;
> -
> -	if (!pgmap || !is_power_of_2(sizeof(struct page)))
> -		return false;
> -
> -	nr_pages =3D pgmap_vmemmap_nr(pgmap);
> -	nr_vmemmap_pages =3D ((nr_pages * sizeof(struct page)) >> PAGE_SHIFT);
> -	/*
> -	 * For vmemmap optimization with DAX we need minimum 2 vmemmap
> -	 * pages. See layout diagram in Documentation/mm/vmemmap_dedup.rst
> -	 */
> -	return !altmap && (nr_vmemmap_pages > VMEMMAP_OPTIMIZATION_PAGES);
> -}
> -/*
> - * If we don't have an architecture override, use the generic rule
> - */
> -#ifndef vmemmap_can_optimize
> -#define vmemmap_can_optimize __vmemmap_can_optimize
> -#endif
> -
> -#else
> -static inline bool vmemmap_can_optimize(struct vmem_altmap *altmap,
> -					   struct dev_pagemap *pgmap)
> -{
> -	return false;
> -}
> -#endif

[Severity: High]
With vmemmap_can_optimize() removed, nothing in C code checks
CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP anymore. Could this unintendedly
enable DAX vmemmap optimization on architectures that only select
ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP, such as 64-bit LoongArch?

When CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=3Dy and CONFIG_ZONE_DEVICE=3Dy are
both enabled on 64-bit LoongArch, CONFIG_VMEMMAP_OPTIMIZATION is selected.
In section_activate(), order is now set from pgmap->vmemmap_shift, and
section_vmemmap_optimizable() -> vmemmap_optimizable_order() only checks
IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION).

As a result, activating a DAX section with pgmap->vmemmap_shift >=3D
VMEMMAP_OPTIMIZATION_MIN_ORDER on LoongArch will map read-only shared tail
PTEs and grab references to vmemmap_shared_tail_page via vmemmap_alloc_pte(=
).
However, LoongArch's vmemmap_free() in arch/loongarch/mm/init.c is an empty
no-op stub:

    void vmemmap_free(unsigned long start, unsigned long end, struct vmem_a=
ltmap *altmap)
    {
    }

On section_deactivate(), those shared tail page references are leaked and
the read-only PTEs remain mapped, causing subsequent section activations to
either trigger WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)) and fail with
-ENOMEM in vmemmap_pte_populate(), or fault in kernel mode when writing to
struct pages through the stale read-only PTEs.

[ ... ]

> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 3e9d6617c4bb2..43559593107c9 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c

[ ... ]

> @@ -699,10 +707,9 @@ static struct page * __meminit section_activate(int =
nid, unsigned long pfn,
>  	struct mem_section *ms =3D __pfn_to_section(pfn);
>  	struct mem_section_usage *usage =3D NULL;
>  	struct page *memmap;
> -	unsigned int order;
> +	unsigned int order =3D pgmap ? pgmap->vmemmap_shift : 0;
>  	int rc;
> =20
> -	order =3D vmemmap_can_optimize(altmap, pgmap) ? pgmap->vmemmap_shift : =
0;
>  	if (nr_pages < PAGES_PER_SECTION && section_compound_order(ms))
>  		return ERR_PTR(-EOPNOTSUPP);

[Severity: Medium]
What happens in section_activate() when pgmap->vmemmap_shift is non-zero,
but is not actually optimizable (for example, when 0 < pgmap->vmemmap_shift
< VMEMMAP_OPTIMIZATION_MIN_ORDER, or when !is_power_of_2(sizeof(struct page=
)))?

Previously, order was forced to 0 when vmemmap_can_optimize() returned
false. Now, section_activate() passes the raw pgmap->vmemmap_shift to
section_set_compound_order_range(pfn, nr_pages, order).

Because __populate_section_memmap() only resets the order when both altmap
and section_vmemmap_optimizable(ms) are true:

    if (altmap && section_vmemmap_optimizable(ms))
            section_set_compound_order(ms, 0);

ms->compound_page_order remains non-zero for unoptimizable non-zero orders.
Since section_activate() checks section_compound_order(ms) rather than
section_vmemmap_optimizable(ms), wouldn't a subsequent partial-section
activation (nr_pages < PAGES_PER_SECTION) in that section be erroneously
rejected with -EOPNOTSUPP even though vmemmap optimization was never used?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030140720.1256=
062-1-songmuchun@bytedance.com?part=3D3

