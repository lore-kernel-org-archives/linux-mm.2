Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C04A4606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=ODz/vS4N
Received: by kanga.kvack.org (Postfix)
	id D48046B05B4; Wed, 11 Nov 2026 02:57:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F6F6B05C4; Wed, 11 Nov 2026 02:57:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C370E6B05C6; Wed, 11 Nov 2026 02:57:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4AFF6B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:57:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 282AE140206
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:57:39 +0000 (UTC)
X-FDA: 85422083838.26.9C1A02D
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf03.hostedemail.com (Postfix) with ESMTP id 669BA20002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:57:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="ODz/vS4N";
	spf=pass (imf03.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794383857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+DF6qqz40dY4g5mMl/PNQxSuH0QCVVV01BSTCTsMLkA=;
	b=zA5FYq8kye03FIrCU0KjFnZQ08XLrckBv/OeiepAdMuvv5QnU7pJvnvXaql0hVTeaTlMxP
	tF4Ugq5XAJW+Oc89gd+z67O3Ugmf4XVx5lT4Ynb4jWqgl+jhTBJuOvBVVwYAbEwqQUNeSH
	PM2f3mjZhh4YMic09KzV5Kzvup3R6vc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794383857;
	b=xBz/RHGB0P/1Jq0HbytFNJkS1r7Ue4A8LREt4RLeCFV6pRjhhi8wZzOkF7Sh+mxUZn8NSY
	+cKweuSQzewEhwNMyGAZxr4/gF+nrR5s49pXtFvSeJ8Ife8aiCpnps1YT3HFQk8sVtRos3
	ryyqt5wLVbYXN5eaqMkQ7cdOMYR1wAw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="ODz/vS4N";
	spf=pass (imf03.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794383849; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=+DF6qqz40dY4g5mMl/PNQxSuH0QCVVV01BSTCTsMLkA=;
 b=ODz/vS4NeCoyHegC3BbwNywwWr/7af9IzpXvyTH7cNrhS11z+SRMKra76TbLilg+xbKw7q
 CAvGYfWnILx8GX3e6O7kTDdH/WvBeOMyY1U4PnPJcDRtRN4/1ME88qYQE5SOUcDN04MkJk
 UOOh3rhzA2aP+wXIa/beo9WP/QgQk98xYTDzUUrDBhbENBM5vaTbXlO0VCngiAG+Tau0fn
 egkdfGTJFDfJ1/nZESHkWPPGD34wdMmuEUBmnTz7H/VLqoRnkfiK5R1MILZeNEqikA64OL
 9Xp+g4oAQdfGwjD3VSoW14Mce0FU60SecdBvB/8P/veIuTWYo8V4KNd7xJZdvQ==
Cc: <linux-mm@kvack.org>, <sashiko-reviews@lists.linux.dev>, 
	<akpm@linux-foundation.org>, <apopple@nvidia.com>, <balbirs@nvidia.com>, 
	<david@kernel.org>, <osalvador@suse.de>, <rppt@kernel.org>
Message-Id: <7f39bb9b-3e1a-4560-94e3-69ee624b7973@bytedance.com>
Content-Transfer-Encoding: quoted-printable
References: <20261110114859.76343-1-lizhe.67@bytedance.com> <20261110114859.76343-3-lizhe.67@bytedance.com> <sashiko-outbox-207133@kernel.org> <0bb7599b-b20f-4bba-a7b8-fca2a093fcf9@bytedance.com> <000a2613-6643-4ac1-8378-a3e7df0b211a@linux.dev>
To: "Muchun Song" <muchun.song@linux.dev>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 11 Nov 2026 15:57:11 +0800
X-Lms-Return-Path: <lba+26af41fe7+cc51a0+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH v2 2/2] mm/hugetlb: optimize bootmem hugepage tail vmemmap init
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <000a2613-6643-4ac1-8378-a3e7df0b211a@linux.dev>
User-Agent: Mozilla Thunderbird
X-Rspamd-Server: rspam06
X-Stat-Signature: 4pxd36uhrpgsk87h3ddg1zoykkd71gds
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 669BA20002
X-Rspam-User: 
X-HE-Tag: 1794383856-267651
X-HE-Meta: U2FsdGVkX1+AS7tZ0262i5BR4ZHkniVZgQdVHdCqBKSuVD96Rc3GUjScILoegA5p1zMnnT1xyvCdDN4dcfxXXORvTDjyOdzf5N2oO/xGvWglPvxd1QxYr2TsJDiprzJlunvAJXCew1f0MmbiD9wH6+qWeacIFm/kuW+o+I33FAhfkMjvTuZTAm/KdTnh3l15sEPE6gt7ubfNVWpoS8TzqahyReocaKGagHPTSmam9PvpfSxlCgknBXX8ddhI8/JIcqbfuhtkDr/0Z/JPF9xLRt8bV3vOQA5/h7uli33IHRJ2pHaE+wvmgRDcYOa8VU4aymLLPBc3+EvYYltpy/Hmk2P2SrOj91FKujvMppXLefD5dPwnCPe0hQAjdv4bQJFqGqFZxEqzDrRElXo0ovMPb8j8hvCWl5piwvJ6uoZOpXTx8GOQP6auSWva8z5VhQDCwW1CaJvnvDWOYMmgMdc6kuxrups0rZVmkDUpA0vvFmUo5EzZnBq/KX5QAoVewTvqB6W5fN2rSGvAh0T5tGplstmJ4J5VjWUchRCaZc8Zr0HdDSRmQ7U70mJKpc05UwIJYdsqHvqbO4hpCYXhdaQblWEOkuphFp2htJvCd0i8kJGDqFiSNSxAi8WTuv+zjEGpqNe5kXMfaxG/BJzrDETdBRXyJv5ThkKoysvHtEziQEKLD/EHnMlCW+sp4POQINeDEOAn4bFQKXfO52+1ODwAgE7Aq1R2FmHzxIBryY7EVoikPe5wiD91OnQJJyKen4mVz6cmZ//+4oRx832wOJ6rquefQtkEhHjVuAU/RhOaXoC54Idwtu9uOlI55ii8UnvZaJTPDXVFZKv7OhorsT+o8VMNkc8gKFDX1I+YgtdlduLj85KqcF+GxSe7XTkaI/+kTlYuO0QDcK4lkt3qtabUJpEUpqKj5CJz9o9eZNtTTV+tdUiQzZQnJE/r8huxYDP3LGdYqd9ufv7m/nOUusc
 /HCTkWXc
 W/tENv/H9Pt2iumsOZO15IDbs+GdrcbfWaynu37GrAtyc4XD0FegVB9wAAW+MTCiqhSQktIS+DINlOXrfrUO0LbFiP4mDvh1naJciy+pLkcNrrdi9mSJkDdlGwbhoXlr5Y/rTDHI8IT0XLtCCqnf1XeZK4VwzUIJ+tdfxnWsNTmZqA7ahIhtP/I7yMsUeEtrTIsVs1UG8mt+HVlx8egZ/na/KKAHKV0I8WMIT0kXGFgKbKIsKnJhEvTNLXV7AeAcpR+fyD2egrTauTfFWcQg5kwNAx9W7EhRLd/pJP7ME//pcDN/4XpQXmfuQZ01ATjhVyYQm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 1:28 PM, Muchun Song wrote:
>
>
> On 2026/11/11 11:14, Li Zhe wrote:
>> On 11/10/26 9:35 PM, sashiko-bot@kernel.org wrote:
>>> Thank you for your contribution! Sashiko AI review found 1 potential
>>> issue to consider:
>>> - [High] mm/hugetlb: out-of-bounds write in
>>> =C2=A0=C2=A0=C2=A0 hugetlb_folio_init_tail_vmemmap()
>>> --=20
>>>
>>> commit 5be89b38412d58045fd600596787f54c7559d32c
>>> Author: Li Zhe <lizhe.67@bytedance.com>
>>>
>>> mm/hugetlb: optimize bootmem hugepage tail vmemmap init
>>>
>>> This commit optimizes bootmem hugepage tail struct page=20
>>> initialization by
>>> seeding a template from the first tail page and initializing the=20
>>> remaining
>>> tail pages via memmap_init_page_from_template().
>>>
>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>> index cb2de24affdc4..6ae5d2679e3aa 100644
>>>> --- a/mm/hugetlb.c
>>>> +++ b/mm/hugetlb.c
>>>> @@ -3239,6 +3239,7 @@ static void __init=20
>>>> hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enum zone_type zone =3D folio_zon=
enum(folio);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int nid =3D folio_nid(folio);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct page *page =3D folio_page(=
folio, start_page_number);
>>>> +=C2=A0=C2=A0=C2=A0 struct page template;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long head_pfn =3D folio_=
pfn(folio);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long pfn, end_pfn =3D he=
ad_pfn + end_page_number;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int order =3D huge_page_=
order(h);
>>>> @@ -3247,11 +3248,20 @@ static void __init=20
>>>> hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * As we marked all tail pag=
es with=20
>>>> memblock_reserved_mark_noinit(),
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * we must initialize them o=
urselves here.
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>> -=C2=A0=C2=A0=C2=A0 for (pfn =3D head_pfn + start_page_number; pfn < e=
nd_pfn;=20
>>>> page++, pfn++) {
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __init_single_page(page, p=
fn, zone, nid);
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 prep_compound_tail(page, &=
folio->page, order);
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_page_count(page, 0);
>>>> -=C2=A0=C2=A0=C2=A0 }
>>>> +=C2=A0=C2=A0=C2=A0 pfn =3D head_pfn + start_page_number;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 /*
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Seed a template from the first real tail p=
age and refresh only
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * PFN-dependent fields before copying it.
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>> +=C2=A0=C2=A0=C2=A0 __init_single_page(page, pfn, zone, nid);
>>>> +=C2=A0=C2=A0=C2=A0 prep_compound_tail(page, &folio->page, order);
>>>> +=C2=A0=C2=A0=C2=A0 set_page_count(page, 0);
>>>> +=C2=A0=C2=A0=C2=A0 memcpy(&template, page, sizeof(template));
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 for (pfn++; pfn < end_pfn; pfn++)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memmap_init_page_from_temp=
late(pfn_to_page(pfn), pfn, zone,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 &template);
>>> [Severity: High]
>>> Can peeling the first iteration out of the loop overwrite the struct=20
>>> page
>>> past the end of folio when start_page_number >=3D end_page_number?
>>>
>>> Previously, the loop was a no-op when pfn >=3D end_pfn.=C2=A0 Now, when=
 HVO=20
>>> does
>>> not optimize a gigantic folio, prep_and_add_bootmem_folios() calls
>>> hugetlb_folio_init_tail_vmemmap(folio, h,
>>> VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES, pages_per_huge_page(h)) after
>>> gather_bootmem_prealloc_node() has already initialized the first
>>> VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES pages.
>>>
>>> On configurations where a gigantic page has pages_per_huge_page(h) <=3D
>>> VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES (for example, powerpc
>>> mpc885_ads_defconfig with 16 KiB pages, MAX_PAGE_ORDER =3D=3D 8, and 8 =
MiB
>>> gigantic hugepages of order 9, where both values are 512), this
>>> unconditionally initializes folio_page(folio, start_page_number) and=20
>>> marks
>>> the adjacent physical page's struct page as a compound tail of folio,
>>> corrupting mem_map.
>>
>> Thanks for the report. This looks valid.
>>
>> I will restore the empty-range check before seeding the template in v3.
>
> Go ahead. I will end up removing this empty-range check here [1].
>
> [1]=20
> https://lore.kernel.org/all/20261109095807.41547-8-songmuchun@bytedance.c=
om/


Thanks. I will keep the check in v3 for this series.

Thanks,
Zhe

>
>>
>> Thanks,
>> Zhe
>

