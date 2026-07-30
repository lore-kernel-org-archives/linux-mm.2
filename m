Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6732EC55167
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C5566B0096; Thu, 30 Jul 2026 09:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 775C36B0098; Thu, 30 Jul 2026 09:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B2E66B0099; Thu, 30 Jul 2026 09:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 431536B0096
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:09:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC558A014B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:09:40 +0000 (UTC)
X-FDA: 85045474920.22.EBEC6BF
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3EBDC120005
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:09:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lc6BcPe5;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785416979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n80UyXrjaxZDblcYgL2RK7KkUgNXXLilUukX1cXCVmg=;
	b=3Udmeoy5wyYJMw/rP2mtihX70cWoUDw66jIcM164nTodOPQO6rWxy65iUkqZ9Nq9VHI5Vh
	mlG6NBBKqKX3MDmOtQh6XZQs9yW4OD2+klalvenu5Pci1tjoMGH5kzcnnbMxrQ4nAJr1v6
	E1pbHovwduTMb4nHgV1L+9IKS9J0PwQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785416979;
	b=js/TahUsMx+ost27elRGefj2xVQSKPNTA/V2YT6bOpfsq6gjwVStpMVobAomG+A2yS1Jqc
	52LgNjOCUeeSnFaGAtnUBBFHrDd16WvBVBFNRLaoZZ1cwEQShGsAsxbWKc/YGCIGhbn52f
	54aHfIxX0pRUaLKQL7hERVMJON1byxk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lc6BcPe5;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785416972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n80UyXrjaxZDblcYgL2RK7KkUgNXXLilUukX1cXCVmg=;
	b=lc6BcPe55LdO7JYMgKr2B/atyloWVgQfyyC1LGUztckrBLxzZMRUuP3OaQFVnkhxZhAzr4
	P/J16ys7HJiigGJj474/AIhFIIhHBfIg8Bi4ZMKkhzagA89U5sz6zWi+zcTsZzZiGMx2/g
	LJACO2VRe0wZah1AkMXOEceKKNriTRE=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 03/17] mm/mm_init: skip initializing shared vmemmap
 tail pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <178540851830.2154539.6359871825839331816.b4-reply@b4>
Date: Thu, 30 Jul 2026 21:09:00 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3FCC8989-95DB-450F-95C3-183787DF4D08@linux.dev>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
 <20260720093127.540540-4-songmuchun@bytedance.com>
 <5005C7D3-B3ED-4C62-B611-8465D2BC69FD@linux.dev>
 <178540851830.2154539.6359871825839331816.b4-reply@b4>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3EBDC120005
X-Stat-Signature: 3984s6zu3y6346rx1j8gkcs9mjepoanw
X-Rspam-User: 
X-HE-Tag: 1785416977-628079
X-HE-Meta: U2FsdGVkX18KM4UbyglJlV+ze+ufAwy6cPSbL2lcfVud35ZRht5ZL/SSuKRVhNn5Qc7uNUzzKujqiaUv7Y8pzBjTeRUIPqHPorckzHrccQw4joXJDW0AMxOt3Nxi1mbMBfTdyxhzbzsKUyYhkmdnlbjxxrz/X/2aUqOYFzQy2FPl2BGX5O9E+NCR+mb+vGXjFPlGAKZsvxmRPclRqBKtrARZ7e1pxhKEm8LIjHIcy6akZAKnItTWLZKxSSVgJ2kjWDNIZ+3fWcZ7plxNxaIRRFnF5ka4B4Wu1Cbe3JDpzRZuwKiDHaOLvjqWyQjGeKQ58c6Bcbw6H9EMB23hV/etGUCHZtrVh6v8mW0qHR60m6qKLv1pkCoH3aRwPd+3HhU2+Gl+reyn+GxOfmT1DE1T5nJoplA4smjUmWMPcfpXznC1KY9i8oFM3aB2K2GapI/8vUYC4Jyiv8Ke3SeHh3W2J6vA2B7WhWg22tWN3IYyBg90ssKlWqod6ZI3QWtMxqGDLOwHYu5Q+6o0tH2fw8phsBMY57v5CQrq+FQpH8ueMbmmN22qD4jZRE/Sg4BF9rxqIhZN9WNPI6CtuPO7ZkqSwPdMLiKfh07d2r9KchdtIucfibpGw9cEy9KG+Z9yVLQDGrMkoURthjfsrtWfhQN+GsLpeAB7DfUzR4I21yHwb6jfhSBmDZWvlkVN1argvYsokMBpkUyvu9FXzOOpBrjKOAi+iJ2Mo2V6te2Av5MqPUKMFzpcDDWCrUKM2nHrMOEhdIFz7ArqXOLGuFbdPvuq+7BX/Adwudk+B9AiZW0C1F45/+BHpgbsaoipb5AaxnopvRiA49QRjYXouOTcVN1j/enIjm1U0zQeHoe6glzDL1ZnQ1akJTc2tRqvPLbCr9P6sF93C9PQtd/HHgul8Rbw5qUBqnYkUJsqPOxdeapnCm/CAljM5bujXo33mc9VNfzjrkPHF4FeLzbuJrvknIM
 w6lEGBKh
 BL1dir+53QlOw3f5E+5p4S3uDQCThBxcf0pKMc4m2js4u7UIySgOKFZ8eRQpodNGh+8QFCTwdF9IjIJqJm7kcAIxoHz8bt5i+xwfEAWN4KHgGdrkN6F0xfMDPsXkGvSYTYlJwXHPtmUlTuIoRoMpIkweJVN2pup3XG5JAqNudSOmffAfUMJZYeaatONtRdrlobX2vojeWOzPo4FVsYVnFeTd1FSkgiyrhNtRzp1Iw6361rr4wP4e9harFf9h9UQSTcTkrPF0u05biI530YkrT6o3YrlakiVG27JOKnj7RHv2UaroeqB9zxd5dJccNMaYcPGIOwdmtdgUko+jwVq/HT/rCQJIEkd4EwSU/OlaupZUMJHu6F98mnJ39r+R/uORaglIlDs+7DeQy4J9sbxJmV0Tpgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 30, 2026, at 18:48, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> Hi Muchun,

Hi,

>=20
> On 2026-07-26 12:30:17+08:00, Muchun Song wrote:
>>> On Jul 20, 2026, at 17:31, Muchun Song <songmuchun@bytedance.com> =
wrote:
>>>=20
>>> memmap_init_range() initializes every struct page in the target =
range.
>>> For compound pages with vmemmap optimization, the tail struct pages =
are
>>> backed by a shared vmemmap page.
>>>=20
>>> Initializing those tail struct pages would overwrite the shared
>>> vmemmap page contents, requiring users such as HugeTLB to restore =
the
>>> metadata afterwards.
>>>=20
>>> Track the compound order for HVO-backed sections and use that =
metadata
>>> to detect struct pages that fall into the shared tail vmemmap range.
>>> Skip those shared tail pages in memmap_init_range(), then initialize
>>> pageblock migratetypes for the processed range with a helper after =
the
>>> per-page initialization loop.
>>>=20
>>> The !SPARSEMEM __pfn_to_section() stub is needed only for the build:
>>> memmap_init_range() references __pfn_to_section() after checking
>>> pfn_vmemmap_optimizable(), and !SPARSEMEM builds still have to =
compile
>>> that code even though pfn_vmemmap_optimizable() folds to false.
>>>=20
>>> This is a preparatory change for consolidating handling across users =
of
>>> vmemmap optimization, and it also avoids redundant initialization of
>>> shared tail vmemmap pages during early boot.
>>>=20
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> ---
>>> v2:
>>> - Fold section order tracking into the first user instead of keeping =
a
>>> standalone API-only patch (suggested by Mike Rapoport)
>>> - Rename page_vmemmap_optimizable() to pfn_vmemmap_optimizable() and
>>> pass a PFN directly (suggested by Mike Rapoport)
>>> - Initialize pageblock migratetypes from a helper after the per-page
>>> loop (suggested by Mike Rapoport)
>>> - Use a 1G PFN chunk for cond_resched() in the pageblock helper
>>> (suggested by Mike Rapoport)
>>> - Guard section_order() with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP so
>>> it returns 0 when HVO is disabled and lets the compiler optimize the
>>> code as much as possible (suggested by Mike Rapoport)
>>> - Explain why the !SPARSEMEM __pfn_to_section() stub belongs here
>>> (suggested by Mike Rapoport)
>>> ---
>>> include/linux/mmzone.h | 14 ++++++++++++++
>>> mm/mm_init.c           | 33 +++++++++++++++++----------------
>>> mm/sparse.h            | 23 +++++++++++++++++++++++
>>> 3 files changed, 54 insertions(+), 16 deletions(-)
>>>=20
>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>> index 82b0155d886f..2a32101d55e6 100644
>>> --- a/include/linux/mmzone.h
>>> +++ b/include/linux/mmzone.h
>>> @@ -2011,6 +2011,14 @@ struct mem_section {
>>> unsigned long section_mem_map;
>>>=20
>>> struct mem_section_usage *usage;
>>> +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>>> +  	/*
>>> + 	 * Normally, sections hold regular (order-0) pages. However, for
>>> + 	 * sections with HVO enabled, this tracks the compound page =
order
>>> + 	 * to enable deduplication of redundant vmemmap pages.
>>> + 	 */
>>> +  	unsigned int order;
>>> +#endif
>>> #ifdef CONFIG_PAGE_EXTENSION
>>> /*
>>>  * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
>>> @@ -2365,8 +2373,14 @@ static inline unsigned long =
next_present_section_nr(unsigned long section_nr)
>>> #endif
>>>=20
>>> #else
>>> +struct mem_section;
>>> +
>>> #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
>>> #define pfn_in_present_section pfn_valid
>>> +static inline struct mem_section *__pfn_to_section(unsigned long =
pfn)
>>> +{
>>> +  	return NULL;
>>> +}
>>=20
>> I'd like to propose an alternative implementation that doesn't =
require
>> exposing the mem_section. The idea is to add a new helper function,
>> pfn_to_section_order(), so that for non-sparse-memory configurations,
>> the mem_section concept stays hidden internally. I'd really =
appreciate
>> any thoughts or concerns =E2=80=94 if everyone is comfortable with =
it, I can go
>> ahead and implement this in the next version.
>=20
> A helper that keeps mem_section hidden from !SPARSMEM makes perfect
> sense to me.
>=20
> I'd even take it one step further and make it return how many pfns
> should be skipped in pfn_vmemmap_optimizable case.

To make sure we're on the same page, let me walk you through the =
specific
changes I have in mind. My initial plan is to introduce =
pfn_to_section_order,
and the expected diff changes are as follow to keep mem_sectionhidden =
from
!SPARSEMEM.

diff --git a/mm/mm_init.c b/mm/mm_init.c
index dcb757b36902..0b0c2996d080 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -884,7 +884,7 @@ void __meminit memmap_init_range(unsigned long size, =
int nid, unsigned long zone
                }

                if (pfn_vmemmap_optimizable(pfn)) {
-                       unsigned int order =3D =
section_order(__pfn_to_section(pfn));
+                       unsigned int order =3D =
pfn_to_section_order(pfn);

                        pfn =3D min(ALIGN(pfn, 1UL << order), end_pfn);
                        continue;
diff --git a/mm/sparse.h b/mm/sparse.h
index 030248030dc7..c5fbcdde3cee 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -47,6 +47,11 @@ static inline void __section_mark_present(struct =
mem_section *ms,

        ms->section_mem_map |=3D SECTION_MARKED_PRESENT;
 }
+
+static inline unsigned int pfn_to_section_order(unsigned long pfn)
+{
+       return section_order(__pfn_to_section(pfn));
+}
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */

Since we also use __pfn_to_section in the patch 14 in this series for
!SPARSEMEM, we need to make corresponding adjustments=E2=80=94specifically=
, by using
pfn_to_section_order to determine whether the vmemmap of a given section =
is
optimizable. This new helper will be called from several places, so I'm =
afraid
its introduction is unavoidable.

That said, I've also considered an alternative: introducing another =
helper that
returns the exact number of PFNs to skip, and using it solely within
memmap_init_range(). However, that approach doesn't seem to offer much =
in terms
of code simplification. If I'm missing something or if my reasoning =
doesn't align
with your expectations, I would really appreciate your guidance. Thank =
you for
your patience!

Thanks,
Muchun




