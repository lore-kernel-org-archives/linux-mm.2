Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B6CEF34C49
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 13:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0FEA6B0092; Mon, 13 Apr 2026 09:57:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73216B0093; Mon, 13 Apr 2026 09:57:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3B126B0095; Mon, 13 Apr 2026 09:57:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B28B6B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:57:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 146D386BDA
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:57:32 +0000 (UTC)
X-FDA: 84653685144.19.16A3F2D
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id E41D14000B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:57:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DmYoUD9o;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776088650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WB6X/KB4lcgoxaXTVldx7yfC+K++jG31ztfaBdye/0o=;
	b=8gdZgZLetHpenhcrP4ZKxaSDjJsTb+FfIKCGdiq31Mr7NzTAtXnjXniBt8SghAWnhXjPfj
	huJ14NU1QwPwgK1brpN82A8zJeSlcCmUJJe5ug7IsZvbU35rKouUvNAr72ui5Ukpu/HVVA
	Bh9imIK8/C2Wqt7+kJfZe7pAlhWLuCk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DmYoUD9o;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776088650; a=rsa-sha256;
	cv=none;
	b=UC3P74ey9EYNZJkZCsLN+GMp/9k+hslVTp7JVDAS6pSG+VaWBaXWY58OPcuHnhv0EhrFyi
	rOylMgiBS9YfrsjDrsamnisW/1/gGlYuFDmVXHau8/lJ9Te1mdGut2b4jFY/hheqHMgqzC
	PyRiKDSyAXACRm6hI3jWSYnLNJPumVU=
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776088647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WB6X/KB4lcgoxaXTVldx7yfC+K++jG31ztfaBdye/0o=;
	b=DmYoUD9oKqdfKivm9z9TwfbKLHD13LH/gu6nFBQGBPzDBoPrHIIJnqbsGdaBjyp/HzmHN5
	mVQMvqextCEEWtEWK81D/y4Sja1/VSwcgDqDjhNY8hYIm10O6g8QQmcjc0z05CcPpQLLRS
	8dTHIkivv52rRR/NBQD14jzk00a+lW0=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 06/49] mm/mm_init: fix uninitialized pageblock migratetype for ZONE_DEVICE compound pages
Date: Mon, 13 Apr 2026 21:57:00 +0800
Message-Id: <ADC5EFE8-454D-4B9D-8BB0-39FF671290F0@linux.dev>
References: <adzvdRPrK55TutT6@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Liam R Howlett <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <adzvdRPrK55TutT6@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: uyqqj1qf9sin4gmdqmg4x5ep6rp3nmdb
X-Rspamd-Queue-Id: E41D14000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1776088649-851875
X-HE-Meta: U2FsdGVkX184T+9GhREQkc19zNxIGCArd+iV/5Pg27wYArHmAq2TRPWX0FtbyPRiS1C+Ni4ZNHCxP1gpMN9oLkl9ppyU2lFhoOdVjrI4rwG/mVQrHQ2aoUuim/JLFnM+p/dVxgUdmJ8orSzkRJpXi8FgSLhZVFjypAE8ZDvx2cHrnR6b4b9oTE7z5cNaLWZpD6EX+9PBwKKPLO+y8P7uYaPDxbRp0L+Pantp0etHPUK0u6DD2qKaxvIqJD/8+iCYayNgn5Z8+gm/Oe4Fb7A/zXzaYQFb7RkPfsXyPC3QPTCMj6UorHYtgXPfDL3sEf0pVen7gYt3feO0wEnJkBpLVglhfBo4cJ47d1Ob4cb8ddoruo2oxD2X3Qo8M3kypqt07eA4/DojJCVY60d3hPWKBiqVpWEGFZcpoIjTIDhE+ycs9YtTJW+3yMy965C8r2Fe8w/qUYbqWhXpzxtj1vD+jw3JUwY+i7ogX+1jvcAfzbL1RmpqrVdJAmWpt54/mHmO7TYuF+FY2dwuyaft5Wiy5aIkkksOOsSZ07ceyTyQSqTjh6v9eghHzXbQQC+GJE5Yh5rUQqjUL+VL1IIObAlw5RKLmphiuYu4efYVus0sFOg+wmxhpauo/pWeCd01ykI6mB/yphe8/tXjzW10MRd9NJpnX4kg6iNh67RaRKR4sfZnL9dayRahnzD5b3GUMmeCukK1ppH8taAAED1fFQEUHPl+f7OR/dtb9EZQZd7OpTlaGqM8ZEffeX8MuHlJni4YTq7TvGwg+1nXZPiCkNXxk7af272ghj3fQDjxf7QF+xwcWG+8rD1fNfLIbtjW5zrUtdEkWCofq0gJx8H6YjRB84LJsRV4pH2VNxrUXGcA5fYnY1uywvHx8vCkMcvqWcKn9DVqxRoEiUfjKIdMvEWjOwIU2dpDHKKLnnKBNMsAOwlVUCL2CH4uSFa8WMi7xywLqzxae1GTH9FrMsuXWid
 YSlSbYnp
 E5JzgbfnH4sRnb1nXq+RvfL7VgnkJmCdTsS6kmIElvdNEFwSf4Um4LSDdD45Tzm1X9OmPCfM6p3o9/HSmHy/61duBMTomUbCOVwKdFanB7uDUVgiyx17OKptsoh0trGCd1evznDHfuOAx33khAE8rxqwyrMIudnH4Vme+alr5Q8cRWfY/+2FGTmoJ/MTIX83o6FD96FV1B0vL2ZxHlriTgOn6RkHimKX/ZgOoBE26n4XN7uP8bnDTQVsnS65Js0jkgAQ15YnlgjPgHDPyN2AZWRQowwDQOoKBOGZ2od4Evub2opIQpDiuc+k+2lWGY2UGjVKBpozzX3dp1jE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 13, 2026, at 21:28, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> =EF=BB=BFOn Mon, Apr 13, 2026 at 06:07:44PM +0800, Muchun Song wrote:
>>=20
>>=20
>>>> On Apr 13, 2026, at 17:32, Mike Rapoport <rppt@kernel.org> wrote:
>>>=20
>>> On Sun, Apr 05, 2026 at 08:51:57PM +0800, Muchun Song wrote:
>>>> Previously, memmap_init_zone_device() only initialized the migratetype
>>>> of the first pageblock of a compound page. If the compound page size
>>>> exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
>>>> subsequent pageblocks in the compound page would remain uninitialized.
>>>>=20
>>>> This patch moves the migratetype initialization out of
>>>> __init_zone_device_page() and into a separate function
>>>> pageblock_migratetype_init_range(). This function iterates over the
>>>> entire PFN range of the memory, ensuring that all pageblocks are correc=
tly
>>>> initialized.
>>>>=20
>>>> Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound=
 pages")
>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>> ---
>>>> mm/mm_init.c | 41 ++++++++++++++++++++++++++---------------
>>>> 1 file changed, 26 insertions(+), 15 deletions(-)
>>>>=20
>>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>>> index 9a44e8458fed..4936ca78966c 100644
>>>> --- a/mm/mm_init.c
>>>> +++ b/mm/mm_init.c
>>>> @@ -674,6 +674,18 @@ static inline void fixup_hashdist(void)
>>>> static inline void fixup_hashdist(void) {}
>>>> #endif /* CONFIG_NUMA */
>>>>=20
>>>> +static __meminit void pageblock_migratetype_init_range(unsigned long p=
fn,
>>>> +        unsigned long nr_pages,
>>>> +        int migratetype)
>>>> +{
>>>> + unsigned long end =3D pfn + nr_pages;
>>>> +
>>>> + for (pfn =3D pageblock_align(pfn); pfn < end; pfn +=3D pageblock_nr_p=
ages) {
>>>> + init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
>>>> + cond_resched();
>>>=20
>>> Do we need to call cond_resched() every iteration here?
>>=20
>> Of course not.
>>=20
>>>=20
>>>> + }
>>>> +}
>>>> +
>>>> /*
>>>> * Initialize a reserved page unconditionally, finding its zone first.
>>>> */
>>>> @@ -1011,21 +1023,6 @@ static void __ref __init_zone_device_page(struct=
 page *page, unsigned long pfn,
>>>> page_folio(page)->pgmap =3D pgmap;
>>>> page->zone_device_data =3D NULL;
>>>>=20
>>>> - /*
>>>> -  * Mark the block movable so that blocks are reserved for
>>>> -  * movable at startup. This will force kernel allocations
>>>> -  * to reserve their blocks rather than leaking throughout
>>>> -  * the address space during boot when many long-lived
>>>> -  * kernel allocations are made.
>>>> -  *
>>>> -  * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
>>>> -  * because this is done early in section_activate()
>>>> -  */
>>>> - if (pageblock_aligned(pfn)) {
>>>> - init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
>>>> - cond_resched();
>>>> - }
>>>> -
>>>> /*
>>>> * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
>>>> * directly to the driver page allocator which will set the page count
>>>> @@ -1122,6 +1119,8 @@ void __ref memmap_init_zone_device(struct zone *z=
one,
>>>>=20
>>>> __init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>>>>=20
>>>> + cond_resched();
>>>=20
>>> Originally we called cond_resched() once per pageblock, now it's called
>>> once per page plus for every pageblock in the tight loop that sets the
>>> migrate type. Isn't it too much?
>>=20
>> There are indeed many more cond_resched() than before, but I don=E2=80=99=
t have a
>> concise way to write it, so I took the easy way out.
>>=20
>> How about:
>>=20
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 2d680636b67a..d13a2577c4c3 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -683,7 +683,8 @@ static __meminit void pageblock_migratetype_init_rang=
e(unsigned long pfn,
>>=20
>>        for (pfn =3D pageblock_align(pfn); pfn < end; pfn +=3D pageblock_n=
r_pages) {
>>                init_pageblock_migratetype(pfn_to_page(pfn), migratetype, i=
solate);
>> -               cond_resched();
>> +               if ((pfn & (pageblock_nr_pages * 512 - 1)) =3D=3D 0)
>> +                       cond_resched();
>=20
> TBH, I don't know if 512 is the right number :)

I picked this number out of thin air. I=E2=80=99m not sure as well.

>=20
> pageblock boundary was a convenient point to have cond_resched() along wit=
h
> setting the migrate type.
>=20
> Here we might be able to squeeze more iterations between subsequent
> cond_resched() calls.

Choosing an appropriate number is indeed difficult. We need to consider
both unnecessary cond_resched() calls and scheduling latency, and the
specific value also depends on the current CPU performance. At the very leas=
t,
I find it hard to choose a correct value. Since we all agree it should be la=
rger
than 512, why not just pick 1024? I can't think of a good evaluation criteri=
on
or selection method either.

Thanks.

>=20
> --
> Sincerely yours,
> Mike.

