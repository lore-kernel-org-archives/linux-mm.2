Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8CC1606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 02:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TnVG+t3V
Received: by kanga.kvack.org (Postfix)
	id 1762F6B05B1; Fri, 30 Oct 2026 22:43:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100686B05B2; Fri, 30 Oct 2026 22:43:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F09DD6B05B3; Fri, 30 Oct 2026 22:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C685B6B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:43:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 55E801208C7
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 02:43:25 +0000 (UTC)
X-FDA: 85381375170.17.8A2F096
Received: from mta0.migadu.com (out-33.mta0.migadu.com [91.218.175.33])
	by imf22.hostedemail.com (Postfix) with ESMTP id 92334C0002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 02:43:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TnVG+t3V;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.33 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793414603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ekXJ0a8Q3aeP50m9J5zFbJe2TWONi3l/1vhiVAvAmk=;
	b=j6gQzoyTZdTjZub4s5jf+HHrmy+ThBH4ilx9CgTSsLK9B84emQQEESuAGfbCqwk+/Tl5fW
	+OBcxnlcBZXT0zxVKZTEKhiGDhi3XjQX1TJhNxGc1cDpfLr8lvHtOeS6o+rZWOm6U7fypZ
	1NAfa+VUC9dTUdjIdy3wyFCrRj0+ylo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TnVG+t3V;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.33 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793414603;
	b=fStHUeyuoTJ+poset3DH2a6Hr6gKSCEpvv+kjJK6aFlfXUETKz0FsyEHAsYpIhNNNIH1nz
	4sgSmQOJu3dmH3A2nxz5pwP0zWjop4U6LHi6KlJau1RMCcFf5FT4NfCRdKZ1sEUA0U6DZk
	p0Y+TyRTP6xrwEycfO5w3+YiLAl2/U0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WsjTDowD69vaAV5c8r7Aevhgcpf9hq/Quk1PYoegTg0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793414600; v=1; x=1794019400;
 b=TnVG+t3VjS9fZ1tMp5GpjwAe+LVdBvZPHiltUW4cB4RrFWTGiqTMOIH/ctF97EJmz87H0ehE
 dsmGxXmOi/bko1nnb0o0vwMJHmmSLTtxBx0A91vbjeXkJ9bnHYsWZxPqfh7CchVuduqe4rFw/hd
 YwQ8Qh3h470eIxU/jjEjL/H4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id dc0478d27c2ffce3;
	Sat, 31 Oct 2026 02:43:19 +0000
X-Mizu-Trace-ID: dc0478d27c2ffce3
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 3/4] mm/sparse-vmemmap: drop vmemmap_can_optimize()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <sashiko-outbox-191687@kernel.org>
Date: Sat, 31 Oct 2026 10:42:56 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lance Yang <lance.yang@linux.dev>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Ritesh Harjani <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org,
 x86@kernel.org,
 linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5841D61D-50CB-4AA9-AC72-BD6AE8033589@linux.dev>
References: <20261030140720.1256062-1-songmuchun@bytedance.com>
 <20261030140720.1256062-4-songmuchun@bytedance.com>
 <sashiko-outbox-191687@kernel.org>
To: sashiko-reviews@lists.linux.dev
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 92334C0002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: bforbqoqzc5ayopdmpy4uotyw45z6atf
X-HE-Tag: 1793414601-313997
X-HE-Meta: U2FsdGVkX1+eTMUQdY82ZdDR0n1UzCJSOKlOzCUXl23DUkoanvmyQXr0K77vc/HmiXHDxkpmmSRtPej6PsdsaWA2HxHUL+r2cExgTGWsUF8UYaJo9F/W7OIA+uxncL03HRS0fov0JeAZQDgDP7mVl5tXBZH2Ery0nqEc49IxKLSez3eyiYj9UhELgPkk6xLSIHMO9NluX1xZDiuDmmcnbyPY2DLVLupkyULb8B7HbTaXdrSXLiMAHDIab3y7hBMs+vCsQLuolSTuBKXW1fOp3wSBOZbze47t3LnsyDICH9/tioAqCVkQREf21j5hu2aoG4hZHq5HzZ2X3zCVzC6jSlTMCPaAqCfiEQWnF1eXG4GDwdyhi/RQaJB+wck/kXNxryWIz82wQkq4DfdfTmm0SNvlb0s6NOaLQLZeNg1NflwoRJgNBVrhhxD9slLs6mJ4V/Fww5nR2PGinYGGUz7nwecUVtj6pKIpuqPfkzBCfSIsmF87msnP4nKw76LNXlp/49zIkHy/fudERqJldRiQxHpfXr2uLX24l6ssGi3/lE8e2pSP1YPs59k41hrR+z5kjlyWy1EbbJLlZ45PB1qrxpnbhGlj2O0f3n/nGbTzu4vh6uhsPGkQiAL4RFec84Q0BPlIjUh2lnXTACueQK+xkfrWr/cT5PN4Wlf5qZBsyqXwe9BZYfBTYqtCegYp9cPwc9yxRwQaUXU+3MRhL3OJeoIBv1x3y8oCcd8XQsp18Z98+5BPPbz6TZrbOqkv7zFmZblYFDbdUUy2GXshWY+ka9eSdZsK6YPquGRo1gokL3trigsNe99CsXmMN/Ouu/mPTQuF/lkjJuaHFKPQI2fRHBc4+ZEUxQA7hk+pBhonKo3TvpM/kmDhxu/yhcejhygoIFC9oc9urWK4ZpaX3yHC1IGXxnZwo1tQXdj+4sHIspkmIdn2RspG8ypYn2qgA1xkNYnwmWm07XrzAU/4Q8o
 C9cMJgxv
 UmOp8Q8Doyzi7AnAMm7D+x3yBW427hwGxdp5wf6yDdv01zW+PIR/u1GCxphV5LrdsYckjnIQmUxHlvHOQBcpEU1mNr+oGCehA1ezEmqfBHNkvIF7tNWNSdH9n09QNtb6Q0+P/cHw2z61VKdFa8qAsFxUNTSRBd9pBy1aWplTT/2XFqLsgN0JG9MsdBTOEo4RQUP6UtQSXD06h0B85p0ITPWaghWP01Tsu+JRDtR8yYwoz2yp3t2j9gRrGAyDHx3DyQqeomCuj3BIyJ6QoRYAD4PR1qJOlDi0p79C2P/aCb38w1dC+7YmPqXp/zGEEQkWjig9PIACZ6rhbOeOCFbaSXb3aEL4iLmEb3DdEUhDZ9KbD2mtsNmqLIzndAvIJy234C/oCxYWmf7tHISK+mqFhcKpyPLCQ36XygM9JrZhgbPkIXy4d5icUbPuFk2R769I83/4ywM0Nxwe4/eMr7B4JWEFzIEvzMzCTuV1Em/kWz0nqBRFjlO4tZQntYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 31, 2026, at 08:54, sashiko-bot@kernel.org wrote:
>=20
> Thank you for your contribution! Sashiko AI review found 3 potential =
issue(s) to consider:
> - [High] mm/sparse-vmemmap: dropping vmemmap_can_optimize() bypasses =
DAX arch config
> - [Medium] mm/sparse-vmemmap: section_activate() stores =
non-optimizable compound order
> - [Low] mm/sparse-vmemmap: missing header include breaks powerpc =
init_64.c build
> --
>=20
> commit 4171e4b9fc2abb84bf0e245a60563f33f94a263d
> Author: Muchun Song <muchun.song@linux.dev>
>=20
> mm/sparse-vmemmap: drop vmemmap_can_optimize()
>=20
> This commit removes the DAX-specific vmemmap_can_optimize() helper =
from
> include/linux/mm.h and relies on section_vmemmap_optimizable() to =
determine
> whether a section uses vmemmap optimization.
>=20
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index e875f73b0c6ff..4fb48fbe712d2 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -38,7 +38,6 @@
>> #include <linux/bitops.h>
>> #include <linux/iommu-debug-pagealloc.h>
>> #include <linux/kcsan-checks.h>
>> -#include <linux/vmemmap-optimization.h>
>=20
> [Severity: Low]
> Does removing this include break the 64-bit PowerPC build when
> CONFIG_SPARSEMEM_VMEMMAP=3Dy is enabled?
>=20
> In arch/powerpc/mm/init_64.c, vmemmap_populate() calls
> section_set_compound_order():
>=20
>    section_set_compound_order(__pfn_to_section(page_to_pfn((struct =
page *)start)), 0);
>=20
> Previously, arch/powerpc/mm/init_64.c got the declaration of
> section_set_compound_order() transitively via include/linux/mm.h. =
Without
> including linux/vmemmap-optimization.h in arch/powerpc/mm/init_64.c,
> compiling it will fail with an implicit function declaration error.

I should include this header in the patch 2 to fix this, because I don't =
like
this implicit way of header file inclusion.

>=20
>> struct mempolicy;
>> struct anon_vma;
>> @@ -5395,42 +5394,6 @@ static inline void vmem_altmap_free(struct =
vmem_altmap *altmap,
>> }
>> #endif
>>=20
>> -#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
>> -static inline bool __vmemmap_can_optimize(struct vmem_altmap =
*altmap,
>> -					  struct dev_pagemap *pgmap)
>> -{
>> -	unsigned long nr_pages;
>> -	unsigned long nr_vmemmap_pages;
>> -
>> -	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
>> -		return false;
>> -
>> -	if (!pgmap || !is_power_of_2(sizeof(struct page)))
>> -		return false;
>> -
>> -	nr_pages =3D pgmap_vmemmap_nr(pgmap);
>> -	nr_vmemmap_pages =3D ((nr_pages * sizeof(struct page)) >> =
PAGE_SHIFT);
>> -	/*
>> -	 * For vmemmap optimization with DAX we need minimum 2 vmemmap
>> -	 * pages. See layout diagram in =
Documentation/mm/vmemmap_dedup.rst
>> -	 */
>> -	return !altmap && (nr_vmemmap_pages > =
VMEMMAP_OPTIMIZATION_PAGES);
>> -}
>> -/*
>> - * If we don't have an architecture override, use the generic rule
>> - */
>> -#ifndef vmemmap_can_optimize
>> -#define vmemmap_can_optimize __vmemmap_can_optimize
>> -#endif
>> -
>> -#else
>> -static inline bool vmemmap_can_optimize(struct vmem_altmap *altmap,
>> -					   struct dev_pagemap *pgmap)
>> -{
>> -	return false;
>> -}
>> -#endif
>=20
> [Severity: High]
> With vmemmap_can_optimize() removed, nothing in C code checks
> CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP anymore. Could this unintendedly
> enable DAX vmemmap optimization on architectures that only select
> ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP, such as 64-bit LoongArch?

You are right. This patch will enable vmemmap-optimization for device =
DAX
on LoongArch.

Because I plan to remove ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP completely =
in
the future, so I'll add a new commit before this one to disable HVO for
device DAX on LoongArch. It'll be easy to do this, just like patch 2 =
does
for PowerPC.

On LoongArch, HugeTLB HVO is supported without gigantic HugeTLB pages. =
So
there is no users of section-based vmemmap optimization. So just =
disabling
vmemmap optimization in architectural vmemmap_populate() is enough.

>=20
> When CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=3Dy and CONFIG_ZONE_DEVICE=3Dy=
 are
> both enabled on 64-bit LoongArch, CONFIG_VMEMMAP_OPTIMIZATION is =
selected.
> In section_activate(), order is now set from pgmap->vmemmap_shift, and
> section_vmemmap_optimizable() -> vmemmap_optimizable_order() only =
checks
> IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION).
>=20
> As a result, activating a DAX section with pgmap->vmemmap_shift >=3D
> VMEMMAP_OPTIMIZATION_MIN_ORDER on LoongArch will map read-only shared =
tail
> PTEs and grab references to vmemmap_shared_tail_page via =
vmemmap_alloc_pte().
> However, LoongArch's vmemmap_free() in arch/loongarch/mm/init.c is an =
empty
> no-op stub:
>=20
>    void vmemmap_free(unsigned long start, unsigned long end, struct =
vmem_altmap *altmap)
>    {
>    }
>=20
> On section_deactivate(), those shared tail page references are leaked =
and
> the read-only PTEs remain mapped, causing subsequent section =
activations to
> either trigger WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)) and fail =
with
> -ENOMEM in vmemmap_pte_populate(), or fault in kernel mode when =
writing to
> struct pages through the stale read-only PTEs.
>=20
> [ ... ]
>=20
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 3e9d6617c4bb2..43559593107c9 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>=20
> [ ... ]
>=20
>> @@ -699,10 +707,9 @@ static struct page * __meminit =
section_activate(int nid, unsigned long pfn,
>> 	struct mem_section *ms =3D __pfn_to_section(pfn);
>> 	struct mem_section_usage *usage =3D NULL;
>> 	struct page *memmap;
>> -	unsigned int order;
>> +	unsigned int order =3D pgmap ? pgmap->vmemmap_shift : 0;
>> 	int rc;
>>=20
>> -	order =3D vmemmap_can_optimize(altmap, pgmap) ? =
pgmap->vmemmap_shift : 0;
>> 	if (nr_pages < PAGES_PER_SECTION && section_compound_order(ms))
>> 		return ERR_PTR(-EOPNOTSUPP);
>=20
> [Severity: Medium]
> What happens in section_activate() when pgmap->vmemmap_shift is =
non-zero,
> but is not actually optimizable (for example, when 0 < =
pgmap->vmemmap_shift
> < VMEMMAP_OPTIMIZATION_MIN_ORDER, or when !is_power_of_2(sizeof(struct =
page)))?

Even though this issue is unreachable, I'm still going to fix it since =
it is easy.
Something like:

diff --git a/include/linux/vmemmap-optimization.h =
b/include/linux/vmemmap-optimization.h
index fa9e9abd6656..104f7275a49f 100644
--- a/include/linux/vmemmap-optimization.h
+++ b/include/linux/vmemmap-optimization.h
@@ -42,7 +42,9 @@ static inline void section_set_compound_order(struct =
mem_section *section,
 {
        VM_WARN_ON(section_compound_order(section) && order &&
                   section_compound_order(section) !=3D order);
-       section->compound_page_order =3D order;
+
+       if (vmemmap_optimizable_order(order))
+               section->compound_page_order =3D order;
 }


Thanks.

>=20
> Previously, order was forced to 0 when vmemmap_can_optimize() returned
> false. Now, section_activate() passes the raw pgmap->vmemmap_shift to
> section_set_compound_order_range(pfn, nr_pages, order).
>=20
> Because __populate_section_memmap() only resets the order when both =
altmap
> and section_vmemmap_optimizable(ms) are true:
>=20
>    if (altmap && section_vmemmap_optimizable(ms))
>            section_set_compound_order(ms, 0);
>=20
> ms->compound_page_order remains non-zero for unoptimizable non-zero =
orders.
> Since section_activate() checks section_compound_order(ms) rather than
> section_vmemmap_optimizable(ms), wouldn't a subsequent partial-section
> activation (nr_pages < PAGES_PER_SECTION) in that section be =
erroneously
> rejected with -EOPNOTSUPP even though vmemmap optimization was never =
used?
>=20
> --=20
> Sashiko AI review =C2=B7 =
https://sashiko.dev/#/patchset/20261030140720.1256062-1-songmuchun@bytedan=
ce.com?part=3D3


