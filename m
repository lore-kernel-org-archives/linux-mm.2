Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E3B606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 07:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NCC0tsF4
Received: by kanga.kvack.org (Postfix)
	id 235916B05B2; Thu,  5 Nov 2026 02:16:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20DF76B05B7; Thu,  5 Nov 2026 02:16:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14A7A6B05B8; Thu,  5 Nov 2026 02:16:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB7F26B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:16:57 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C65B51205F7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:16:56 +0000 (UTC)
X-FDA: 85400208432.26.CBC360B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2654840002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:16:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NCC0tsF4;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793863015;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELp7uyQISlekK6wZ3Z38qoZleKazeMHWG5TRxk9j71o=;
	b=EJ6fBs8w2IYO0+6tBQzTHBKWu28cZzKfuH+L0GSf3kgC304H5MIvs1j1DpYhZN5bJLhE8a
	wRFaLlyEJ15q6vgSz4qTCbjhYUp4MRnrsOxKWfbPokQrHlEXrYeXRYN2n4D21DC052yY6w
	36fB08KqJfDyQKcsfOc8DjAiuFa03jA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793863015;
	b=z7AJI0tperi6+02vR9/qKJ5em6ugp3WSN5VYN4oYQagNXqkqcHpfqjg5pv4Lb5w/8yYK0r
	bOzcTLfvklX6J6bgh0AjQRiEKVhKTOdiumyS/kTPdj1C5RqhULi66EN1Q79euMkZYMOPsb
	2JzWS6t6hl3h5+04KKmtGV5NVRp04ao=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NCC0tsF4;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10A3B419DE;
	Thu,  5 Nov 2026 07:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E302F1F0093A;
	Thu,  5 Nov 2026 07:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793863013;
	bh=ELp7uyQISlekK6wZ3Z38qoZleKazeMHWG5TRxk9j71o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NCC0tsF4SVs47Ss5VcYXH81cXcbLlx4df6zcxBhEvYz2W1VC2ob7bJv7l2UO7QBAE
	 9vvRBGpj+B6dXffMXrJl/2KBLyJ7JX3qdlDBrV8tpDuIW4g2FZsxALi5P7ZVPdNuu2
	 NGVgzgJuvMproYsmSWrdLc/RokTw1uqPMSmgt/LsqX65NJXO8BPr1qBnQOb1deylDk
	 FlXgGJZR6dIrxB/O7YiXT6gDV8nuuOaMBPtYNN47VYbdZn/6jBPB2oz9H7VXYd6G+4
	 7bQ9GXhjMZZfv2Q16Fihbdc/HC1gjJXSk0EJb/lgIWIf/noMQmSNlZRZv5FC0Tjga0
	 /KXgS99S0AOtg==
Message-ID: <sashiko-outbox-198655@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/5] mm/sparse-vmemmap: drop @pgmap from vmemmap
 population APIs
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
In-Reply-To: <20261105061217.13302-6-songmuchun@bytedance.com>
References: <20261105061217.13302-1-songmuchun@bytedance.com>
 <20261105061217.13302-6-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 07:16:52 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: 4k4a93eo9b66397maozp46f1wwcs5xr6
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2654840002
X-Rspam-User: 
X-HE-Tag: 1793863014-589823
X-HE-Meta: U2FsdGVkX1/8yQQpjH8QVKYUkXgBrGDQNqrHfuJKpZkVlLjoASCdSau4l11dYfq9LfsdA3TPia/Ls2uxNYmpbEuwcD5BTliVxMEvqs4NJ7EjscJWhoiXwbbTsSvxJr+9aup6jyxp4TC+pvzgBbZbT6Qp1SYKzcZY1Vc5jNfX6sHVqQ5qKwrskjzp+o6IsLETK6T7dtr99j/0FV7FeafRBgz5Iw3+OXNBGpp5Bnh5/lZmYL8RW782CiPX0SFwh8UUPWP4pH0ykjei3IdRWF0pQoUO4F2dr2FifmnkijWPu3dUGv0WSbXYzWu89hl+tECgnKO0xpTX3hk8Bh2rn+QYRAhN+nZNhjuc9aDMsmbtftPMGQqYqd9WFgqDcdHHgt+bLlQRM4z6cYaBbjmNp0QIu3Dz1dfsTej8IWGafQwRYMBJF+lZ+rEmVQopKC2O9HNGd4OJ6D7RY4pk4tDyUHN3cjMaU2DKQtSp2/spFYj/ing9kxM5p7oSAIK2MEmZxlfge2vP2mvSY6otY5FPN76ouytODJKKsw3M1+pZIq2FF3ectJXkBMcM7EM6gT66IRd/2j2tBII/YAgfcNUpDU0k+O+2EzBBnwos0iC9QEyeEWgA3sDCORrNNQaeofhNcWNs/Qa7kQa8asEzT1oq+fKx/H1W7wfZVPQbI6Y6S7yXov+GyXtuDmll9MS49ax+JblPt7rzuvXBxu5ssOASmAPsSMR5eUFcaVDiVL2OFtT6Cmim47dEPaASbWaqL74nvim1xuze44j4s329p5hIIYuoXvStukETYJSVHvbt0kT0U8ONMv8bP+Mrc7SToL9QoEa8hX2Wg3l70lDHc383W8BLXcbjfUT4sLlm4TZ26NbjGkgUMzCllI4vy4StLhtoX7Znl1wfW3FAP2zZgmstvDRzKCC6wLjYEOwVlOcHFD2D0HhVB+KDS/ZIXcl7rDaX1OWUBqD2huMUzFzlBldxTY1
 wICO/C1l
 9g7EybQQxucFBt7oP5Mxi/Ml5BLNcjy+6ThFCYb6/uVHiN6k/HNpNQXIvCOo7FbABpo04gS4vxJskcF5lWQoUqsEk6i4sSgKoVWMopDqacOwwJJl+iBxDIHvjQZVmQ+RuXOkApuQL4FIBmGCgQAsZauH5i6p1J6WnkxG7s9QIyvV0P8OCIT0/vVQFM8eeuVyB7+RpmIyuXeh17YUKphP/oiemzfd6rYw2epQmuNk7qqkscoOsxXTzLbVWSrkwi1S308wI1lWxZ07MrwMtgJbjQmMGEYGWglS9edx4283nCX4tX9IbUwr+nFq1DVgnJQWFtbfXmJMR8DbHJkiwG2SlV7lpxpWbDdy1ac4G8Z8/QVUceXDzq4nXfvwTBSE+1TqsAbrNpBljlgfghAY4sMY6m/PBPLGhsKY5w5JA43aMlZk1sDL8zjB5Gg8fGkwwzyv418qS0q6PClg0vBJaDWRW8Yv4a/LifIJ1RPnjdngBRLcfDO2eRaQUuvu9jTRowx8L4c3U7jwmv6TDUg9po4CtYuV11NomsLMvZw0UM3YWY5beGpXqs8oT7kKZyMNMgBe2y4V8J5l35SPbi28sDSoOQCwtoSxwPo3PQFglZXYRuCOebgHYXGwq77/S6Bk17Y8B1r/Bg+jqNGNz+GvFoRQrE58GRp5jn7cloStB
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
- [Low] mm: undeclared vmemmap in section_vmemmap_optimization_disable()
--

commit b9ce7eece3f26dd29a5fe079915770aa843f9257
Author: Muchun Song <muchun.song@linux.dev>

mm/sparse-vmemmap: drop @pgmap from vmemmap population APIs

This commit removes the @pgmap parameter from the vmemmap population
helpers and related memory hotplug interfaces, relying instead on
mem_section state and internal architecture-specific checks.

> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 71a927d67a9f9..5777f2e296845 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -462,8 +462,7 @@ int __meminit vmemmap_populate_hugepages(unsigned lon=
g start, unsigned long end,
>  }
> =20
>  struct page * __meminit __populate_section_memmap(unsigned long pfn,
> -		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
> -		struct dev_pagemap *pgmap)
> +		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
>  {
>  	unsigned long start =3D (unsigned long) pfn_to_page(pfn);
>  	unsigned long end =3D start + nr_pages * sizeof(struct page);

[Severity: Low]
Does section_vmemmap_optimization_disable() (called right below here in
__populate_section_memmap()) cause a build failure on 64-bit LoongArch
when CONFIG_VMEMMAP_OPTIMIZATION is enabled?

In include/linux/vmemmap-optimization.h,
section_vmemmap_optimization_disable() is a static inline function that
calls page_to_pfn():

include/linux/vmemmap-optimization.h:
static inline void section_vmemmap_optimization_disable(unsigned long start,
		unsigned long end)
{
	unsigned long pfn =3D page_to_pfn((struct page *)start);

Under CONFIG_SPARSEMEM_VMEMMAP, page_to_pfn() expands via
include/asm-generic/memory_model.h to ((unsigned long)((page) - vmemmap)).
However, include/linux/vmemmap-optimization.h does not include
linux/pgtable.h or asm/pgtable.h where vmemmap is defined.

On 64-bit LoongArch, arch/loongarch/include/asm/pgtable.h includes
linux/vmemmap-optimization.h before defining the vmemmap macro:

arch/loongarch/include/asm/pgtable.h:
#include <linux/mm_types.h>
#include <linux/mmzone.h>
#include <linux/vmemmap-optimization.h>
...
#define VMEMMAP_ALIGN	max(PMD_SIZE, MAX_FOLIO_VMEMMAP_ALIGN)
#define vmemmap		((struct page *)(ALIGN(VMALLOC_END, VMEMMAP_ALIGN)))

Because section_vmemmap_optimization_disable() is a static inline
function, the preprocessor expands page_to_pfn() inside
linux/vmemmap-optimization.h before vmemmap is defined, leaving vmemmap as
an undeclared identifier when compiling any translation unit that includes
asm/pgtable.h with CONFIG_VMEMMAP_OPTIMIZATION=3Dy.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105061217.1330=
2-1-songmuchun@bytedance.com?part=3D5

