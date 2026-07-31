Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A08BBC55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 02:14:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290316B0088; Thu, 30 Jul 2026 22:14:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2671D6B008A; Thu, 30 Jul 2026 22:14:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A4746B008C; Thu, 30 Jul 2026 22:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFA0E6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:14:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 39C171C019A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 02:14:13 +0000 (UTC)
X-FDA: 85047451986.28.ED7AD7D
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6F3A040009
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 02:14:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pAN6jO/4";
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785464051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fEupGYGhLWFgoSe/r+XuCrNsAvYCd8RtQFa5T3203Q=;
	b=qEoxODbmp1PFVw2aVNfPZInOD+M9hIjYHiA8PME+3mS9ItfclEgX7ZhUxsv0Gs4LPAgaUa
	oMiyXzznbUEeJK6ZbQn0J02G/j7dRrMiguWmbEg8lhTqxQRjPtwUYAlFonVg3Ja1xxZQZs
	/cW1XWOY+bJCpcPn6EZFCaZq5YOXIUE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785464051;
	b=mZe0xJs1UdIJI+1zHQ9rFZsF08OchNXKTSLayt5JZtMH1lC9luzlGAIkRPe/Ela41xz/v7
	WKAR4w+r8yYOzGyQZt1KGiya+ZXWitgGl1RhmXp2gXMh4W2ciUJMfx5Wd3rc/CK7FAOxJq
	d4dFg/s67HPa4UlnT7N8951Eb66YCeo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pAN6jO/4";
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785464049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1fEupGYGhLWFgoSe/r+XuCrNsAvYCd8RtQFa5T3203Q=;
	b=pAN6jO/4ybpymCX8FToWqPhTuorFnbVQrXI2DTFHP1wDzq7nQdvF1sji83Co4zdLBIG2TI
	lDj7vmuTVVX6ivbn/q7D2iufVlZDKIDeOXg9CC9DMSpNqgAiIUdlo9WGTevIk8wuug0MiY
	2lV3ww5f8Z/73Do3h/oyBDosIgesvbQ=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 03/17] mm/mm_init: skip initializing shared vmemmap
 tail pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <amtgdZ0U_UIbx_hI@kernel.org>
Date: Fri, 31 Jul 2026 10:13:43 +0800
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
Message-Id: <89878C33-9BCD-4FD7-92A0-884CF682CBF3@linux.dev>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
 <20260720093127.540540-4-songmuchun@bytedance.com>
 <5005C7D3-B3ED-4C62-B611-8465D2BC69FD@linux.dev>
 <178540851830.2154539.6359871825839331816.b4-reply@b4>
 <3FCC8989-95DB-450F-95C3-183787DF4D08@linux.dev>
 <amtgdZ0U_UIbx_hI@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6F3A040009
X-Stat-Signature: jo3w7jrznpw3h9xa9x6bhc7a4i1e5dmy
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785464051-768428
X-HE-Meta: U2FsdGVkX1/cxO4GYgNj8W30ph2uD29QJG3YD3MhXFGJZXPnv3UHGyc87gq4+QKF8d9TDL6iS0D5UJ7NPkrldkhxnPak+UgnRRMKrQ4Fzo6Sia0Bixh6ewvlI1hNvq/WXTYaRe+LhumBZx2kvSDu3wbQAmh9hNXIMnnjEiXEcH8C73BqnABKPRTwYnv7O4/kf+ttFSJ3i9LLqtx5+dREUYUnF2rfLHdy/ocfLhfuLsUjcH4CsuObQXhyHNJNzeyDy9Eun0xkENw6hrbmcMDDTqcKxGYsqxZz9Jz0jA3IaxiQl/odtHdL66gnsF77u2lIniZqssmBvfb/YTGPWhB+W+3+aPf3/GbZ9IJODQi36SFCrN9e1j+zSe8z5bhu+jISfQX2/k6gIZvcS1IdYJiSUwIOLnkE59w8tGPdzWNOO1CCTfdvvACR/zcJTYSK5pCfEn8i/zrSB/yIe0G3/FtnBpkjSbYZWQfoso9JFOPf3yBBQklgRBnK7iaz2EhuXVQqBh44ycC9/lj43pGAA380QqOeqrRkDDqFQCcCkrKL8vJMwzIwOj4CVCcbUcAyMYdBBmwsQkVEHP8DXJFMrRt8OPX4gVqFsoaEmamV2QDzrAQT/hWsIMDTGT6RoPeM+6k2Jubq3B5asBvyKUsOlWr74855iPuX5KzH609q7enz4wfhfVmvOpqh+djy9+mI4wp9ReyH9RJOJ6227K53qeHeX9RIUr3JxdDlfLFoOfxg1FqINcGEABhecLaJMaIkXdu+P8aoOz65Yfh3l7iphEwhZo1cxOjRwFcfjoBRQ6lsrdl2VLDD3d09XXbc0496XL+cyPiJ3/uImqNDQF2BOh5pLXf0BeJzHhbypChfUkVD11PWm6NkbaG+qf0kP8toADMtpgHCkXO3yV9WJo/xpzcccBpnA99Rr+YB7yO02ebA5k6NrQRXGHRgZsmaKfUlrQGN9RHOvuePylDLHNASSTn
 VVKtjcpt
 5A46zwCBf0EPNmoGWhggIO+GzDN88mLhORkiGlbnuXbmSkjXeqEUI20Fx0RlWe8AQEAddgmU4PoK7RWRSrTbU6KKtbNBzB290FH3HMa36+EWmR0jz2wCHaA7T4M2qDLY44UvdD8sj/HsEiGqTx+G+lB4sfg6lMyJDQNkcU50ZQbIyEa+IttAt6JHx6BXiYUH5NrpoOcOOIjlN3f3nl3lRglTbA/dc32IlswsAiq1dYfMSo1sUiYDstCYgodOMhPIp9XC61klCXDFA20q5hARDuiWUmdd+VL+lQ3oEwC4aEfv1KvT7ZDGsgUFoBxP8qlMpaTWt4tVKN87HSViJMy6Mqj5SHKN4kwV6FZoLXeCoEVuGI29U2y6FgFkoT6C6FIDG4+lq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 30, 2026, at 22:32, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Thu, Jul 30, 2026 at 09:09:00PM +0800, Muchun Song wrote:
>>> On 2026-07-26 12:30:17+08:00, Muchun Song wrote:
>>>>>=20
>>>>> #else
>>>>> +struct mem_section;
>>>>> +
>>>>> #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
>>>>> #define pfn_in_present_section pfn_valid
>>>>> +static inline struct mem_section *__pfn_to_section(unsigned long =
pfn)
>>>>> +{
>>>>> +   return NULL;
>>>>> +}
>>>>=20
>>>> I'd like to propose an alternative implementation that doesn't =
require
>>>> exposing the mem_section. The idea is to add a new helper function,
>>>> pfn_to_section_order(), so that for non-sparse-memory =
configurations,
>>>> the mem_section concept stays hidden internally. I'd really =
appreciate
>>>> any thoughts or concerns =E2=80=94 if everyone is comfortable with =
it, I can go
>>>> ahead and implement this in the next version.
>>>=20
>>> A helper that keeps mem_section hidden from !SPARSMEM makes perfect
>>> sense to me.
>>>=20
>>> I'd even take it one step further and make it return how many pfns
>>> should be skipped in pfn_vmemmap_optimizable case.
>>=20
>> To make sure we're on the same page, let me walk you through the =
specific
>> changes I have in mind. My initial plan is to introduce =
pfn_to_section_order,
>> and the expected diff changes are as follow to keep mem_sectionhidden =
from
>> !SPARSEMEM.
>>=20
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index dcb757b36902..0b0c2996d080 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -884,7 +884,7 @@ void __meminit memmap_init_range(unsigned long =
size, int nid, unsigned long zone
>>                }
>>=20
>>                if (pfn_vmemmap_optimizable(pfn)) {
>> -                       unsigned int order =3D =
section_order(__pfn_to_section(pfn));
>> +                       unsigned int order =3D =
pfn_to_section_order(pfn);
>>=20
>>                        pfn =3D min(ALIGN(pfn, 1UL << order), =
end_pfn);
>>                        continue;
>> diff --git a/mm/sparse.h b/mm/sparse.h
>> index 030248030dc7..c5fbcdde3cee 100644
>> --- a/mm/sparse.h
>> +++ b/mm/sparse.h
>> @@ -47,6 +47,11 @@ static inline void __section_mark_present(struct =
mem_section *ms,
>>=20
>>        ms->section_mem_map |=3D SECTION_MARKED_PRESENT;
>> }
>> +
>> +static inline unsigned int pfn_to_section_order(unsigned long pfn)
>> +{
>> +       return section_order(__pfn_to_section(pfn));
>> +}
>> #else
>> static inline void sparse_init(void) {}
>> #endif /* CONFIG_SPARSEMEM */
>>=20
>> Since we also use __pfn_to_section in the patch 14 in this series for
>=20
> I still didn't get to patch 14 :)
>=20
>> !SPARSEMEM, we need to make corresponding adjustments=E2=80=94specifica=
lly, by using
>> pfn_to_section_order to determine whether the vmemmap of a given =
section is
>> optimizable. This new helper will be called from several places, so =
I'm afraid
>> its introduction is unavoidable.
>=20
> Do you mean that section_vmemmap_optimizable() will receive pfn as a
> parameter and use pfn_to_section_order() internally?

I was originally planning to go with the this approach, but now I've =
come across
something that feels a bit unusual to me: a function whose name starts =
with section
takes a pfn as its argument instead of a mem_section.

So I started thinking about an alternative. How about we keep =
section_vmemmap_optimizable()
as it is, but introduce a new helper like this:

static inline bool order_vmemmap_optimizable(unsigned int order)
{
	return order >=3D OPTIMIZABLE_FOLIO_MIN_ORDER;
}

The main reason I'm leaning toward this design is that this new helper =
would be
useful in at least three places:

- Inside section_vmemmap_optimizable(), we can use it to decide whether =
a section
  is optimizable:

	static inline bool section_vmemmap_optimizable(const struct =
mem_section *section)
	{
		if (!is_power_of_2(sizeof(struct page)))
			return false;

		return =
order_vmemmap_optimizable(section_order(section));
	}

- In patch 14, we can call =
order_vmemmap_optimizable(pfn_to_section_order(pfn)) to
  make the same kind of check.

- Looking ahead, I'm hoping to unify HugeTLB's optimization checks under =
this
  same helper as part of my broader refactoring plan =E2=80=94 which =
would also allow
  us to remove some HugeTLB-specific code. For example:

	static inline bool hugetlb_vmemmap_optimizable(const struct =
hstate *h)
	{
		return order_vmemmap_optimizable(huge_page_order(h));
	}

I'd really appreciate your thoughts on this =E2=80=94 does this approach =
make sense to you?

Thanks
Muchun

>=20
> If that's the case and pfn_to_section_order() will be used in several
> places I think it's better than to have a dedicated helper just for
> memmap_init_range().
>=20
>> That said, I've also considered an alternative: introducing another =
helper that
>> returns the exact number of PFNs to skip, and using it solely within
>> memmap_init_range(). However, that approach doesn't seem to offer =
much in terms
>> of code simplification. If I'm missing something or if my reasoning =
doesn't align
>> with your expectations, I would really appreciate your guidance. =
Thank you for
>> your patience!
>>=20
>> Thanks,
>> Muchun
>>=20
>>=20
>>=20
>=20
> --=20
> Sincerely yours,
> Mike.



