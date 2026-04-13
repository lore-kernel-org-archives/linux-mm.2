Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D770F34C58
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 14:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C54BE6B008A; Mon, 13 Apr 2026 10:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05506B0092; Mon, 13 Apr 2026 10:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF38C6B0093; Mon, 13 Apr 2026 10:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1506B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:16:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A948E2663
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:16:57 +0000 (UTC)
X-FDA: 84653734074.11.14253DC
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id BF98010000F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:16:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tat+hmEl;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776089814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Kzkhn3LFWO3+QSE/fQj/hH3qJPFehnDOa4OjhTu82w=;
	b=16GTj6u+QaSJ67tMPNAtyxRjgwJc1C0E/jR3Aqnp5hhU6/FKwCYQy8VY2kQMPsvJpwJwLY
	ERC+qBym8zqYY69uiUfyO2Hib/EAl0rpF37wUKxU4btC8O3opR5DMM3qaVoFim3OjB4yFf
	VstSoPcB6SxBMKfatffRG775w/2NzGs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tat+hmEl;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776089814; a=rsa-sha256;
	cv=none;
	b=xGNJRE4wNVVdFq/dPtriUPMOqQccFj+KYrKnEbMV7JQH6nJtIMKRxTgLmEp6sVQaB7WSK5
	s4CuZsfErJGmcewxGKFdx5cd3EM+PUpx4A0ApXcb1jpXwzgZh4fs6kZRwFXrNELENKr5Zy
	WkKYDJLH1NNBuPAfzIwJ7G4Uf9IOpOE=
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776089811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Kzkhn3LFWO3+QSE/fQj/hH3qJPFehnDOa4OjhTu82w=;
	b=Tat+hmEl4LkYQIHCK1EKoRWrUNb7DtBDa9KMzVcByj1HdimbvKHuSURjjlcj/voNVEuEJu
	17NRVMv2anbHCIs+VBh9J0mCkoI+wiTqWkYKSat0cu6ljmDFzRXwLJdVwBPFJUkJ1yTj83
	hm/N7D4bqI1p4sipyGvCWKX/p/tPtMI=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 01/49] mm/sparse: fix vmemmap accounting imbalance on memory hotplug error
Date: Mon, 13 Apr 2026 22:16:20 +0800
Message-Id: <48CF5603-D8E1-4C86-8554-E8BA03D195FB@linux.dev>
References: <9642F4D9-8F1B-47A4-90BE-C72BB8DE9A11@linux.dev>
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
In-Reply-To: <9642F4D9-8F1B-47A4-90BE-C72BB8DE9A11@linux.dev>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: y8gieghh84cnaxxaw9fjdawj8y9hgomx
X-Rspamd-Queue-Id: BF98010000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1776089813-201857
X-HE-Meta: U2FsdGVkX1/UG0s2jbHpnl9RNwm7S9ddB2gA8vWRnSgGbpCmrgwt+r7O1KplmDXTks+d0rG464vFnquY+xnO35QN/KF8jC2aFLuW2YI/UC1uKu7iVHa4tb3VUhA8g8xVxXn1cL/w0YHPl9D4jSa+MWrFRarKHDYQJ6XooiX4oNk99/BqI2MQBmMdNFBCxlTHAiw0E9lUivXbMqWa1oTayiLzk3kz7wnHRlECqBNlMtZfjAcrO8aTYS+byAXsh5BeQUC9TQ8Cy3mLJsky80ofM99RuoZE28Ezwz8UYzElwhw0579D2Bh80genEuXhf65l3lzJSAddSKb0otMq9C+QkCpRjzuzqQ6rMJ1cgBZxJF8kM//JE3qcjVAQ3VFwoAnZ6n3s/5EJubqHoIbMwDvXs3g0Hqu6GkijJUBSwrQOG23uRyS6nyeLd4HrGa06VwnNDxsTO/+zzVD7kz2IbJxzjcBt+/MlJviTH3ZNFx0MWNTISMXviikEetigym2R+1HiE+WzYWzGNBrNuy8yi1Y+RcOx6VkSgu6IzC2udTDTROBHHQgt5NBvUZYsGcMIKhMf9BmGVBEaDm1ftDUQBARdRVnzkesn1Klh+iKg90T/Ee5BQEysAnjjXA8A9J0XNGdh+swWjWfv243K9EjjJWFNcueKkSpS/mEMgmCvbij+r7KHRsvwpFxHBm1N60O3tR4/jAiKF2jNWSZu6r4FDj3Uh1UzcbyV8PvHTyuWGIH7ZLXpgoCHSzcaOl5CIvF0NcJR43RSGzdATAANEYoPg/V85Kh35JjXlQWimnzm49FzbAm6iGKRTMgpWdAZUeX4SOrHy+dOtxlwBv2aNhKX7+jgSDqH1RNgt4ZnXlRnuKlGYOq7whfVs/bHaQMUdus5Bb8l82kyiC1Bkb0n8Z7c7MADnwzOStTYthjZv/Xvgy8iNhHfGVOghNhq0YSfIGqqQwj5guSVBpy5YxSSVn7cJ7r
 gWddijaw
 Cu7yq8R5KhEAFD6f8bqjU/UWTXH2gbbspzrFuLMAKQmCzZmfQZSxF9ZP2hVzYRr7FVsokeVpFyUchOEkDh7N0mQ4Z0VREA4D4ZTYTttytCkK1qKlgFa1rkOhfFVU5B1YAryzF4Q+klPQPsYpZIy0cLkInrNbreps58Gt/c0/sdp8q9ORc86YG+7V0LWZBAAZtFo4QorrmJfTPzj9YnTePYDX4NkUjKiVzA2tR5fZ053zdxGbjenHU0y2hVOceAbAZwaL/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 13, 2026, at 22:05, Muchun Song <muchun.song@linux.dev> wrote:
>=20
> =EF=BB=BF
>=20
>> On Apr 13, 2026, at 21:36, Mike Rapoport <rppt@kernel.org> wrote:
>>=20
>> =EF=BB=BFHi Muchun,
>=20
> Hi,
>=20
>>=20
>> On Mon, Apr 13, 2026 at 08:47:45PM +0800, Muchun Song wrote:
>>>>>> On Apr 13, 2026, at 20:05, Mike Rapoport <rppt@kernel.org> wrote:
>>>>>>>>>>=20
>>>>>>>>>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>>>>>>>>>> index 6eadb9d116e4..ee27d0c0efe2 100644
>>>>>>>>>> --- a/mm/sparse-vmemmap.c
>>>>>>>>>> +++ b/mm/sparse-vmemmap.c
>>>>>>>>>> @@ -822,11 +822,11 @@ static struct page * __meminit section_acti=
vate(int nid, unsigned long pfn,
>>>>>>>>>> return pfn_to_page(pfn);
>>>>>>>>>>=20
>>>>>>>>>> memmap =3D populate_section_memmap(pfn, nr_pages, nid, altmap, pg=
map);
>>>>>>>>>> + memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), P=
AGE_SIZE));
>>>>>>>>>=20
>>>>>>>>> This logically belongs to success path in populate_section_memmap(=
). If we
>>>>>>>>> update the counter there, we won't need to temporarily increase it=
 at all.
>>>>>>>>=20
>>>>>>>> Not strictly related to this patchset, but it seems, we can have a s=
ingle
>>>>>>>> memmap_boot_pages_add() in memmap_alloc() rather than to update the=
 counter
>>>>>>>> in memmap_alloc() callers.
>>>>>>>=20
>>>>>>> It will indeed become simpler and is a good cleanup direction, but t=
here
>>>>>>> is a slight change in semantics: the page tables used for vmemmap pa=
ge
>>>>>>> mapping will also be counted in memmap_boot_pages_add(). This might n=
ot
>>>>>>> be an issue (after all, the size of the page tables is very small co=
mpared
>>>>>>> to struct pages, right?).
>>>>>>>=20
>>>>>>> Additionally, I still lean toward making no changes to this patch, b=
ecause
>>>>>>> this is a pure bugfix patch =E2=80=94 of course, it is meant to faci=
litate backporting
>>>>>>> for those who need it. The cleanup would involve many more changes, s=
o I
>>>>>>> prefer to do that in a separate patch. What do you think?
>>>>>=20
>>>>> For this patch and easy backporting I still think that cleaner to have=
 the
>>>>> counter incremented in populate_section_memmap() rather immediately af=
ter
>>>>> it.
>>>=20
>>> Hi Mike,
>>>=20
>>> Alright, let=E2=80=99s revisit your solution. After we=E2=80=99ve moved t=
he counter into the
>>> populate_section_memmap(), we still need to increase the counter tempora=
rily
>>> (but in populate_section_memmap()) even if we fail to populate. That=E2=80=
=99s
>>> because section_deactivate() reduces the counter without exception, isn=E2=
=80=99t it?
>>> Just want to make sure we are on the same page on the meaning of =E2=80=9C=
temporarily
>>> increase=E2=80=9D.  Maybe you do not mean =E2=80=9Ctemporarily=E2=80=9D i=
n this case.
>>=20
>> I suggest to increase the counter only if we succeeded to populate:
>>=20
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 6eadb9d116e4..247fd54f1003 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -656,7 +656,13 @@ static struct page * __meminit populate_section_memm=
ap(unsigned long pfn,
>>       unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>>       struct dev_pagemap *pgmap)
>> {
>> -    return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);=

>> +    struct page *p =3D __populate_section_memmap(pfn, nr_pages, nid, alt=
map,
>> +                           pgmap);
>> +
>> +    if (p)
>> +        memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PA=
GE_SIZE));
>=20
> We don=E2=80=99t increase the counter on failure, then
>=20
>> +
>> +    return p;
>> }
>>=20
>> static void depopulate_section_memmap(unsigned long pfn, unsigned long nr=
_pages,
>> @@ -826,7 +832,6 @@ static struct page * __meminit section_activate(int n=
id, unsigned long pfn,
>>       section_deactivate(pfn, nr_pages, altmap);
>=20
> here section_deactivate() is called, which decrease the counter unconditio=
nally,
> the issue still exists. We didn't fix anything.
>=20
> Thanks.
>=20
>>       return ERR_PTR(-ENOMEM);
>>   }
>> -    memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_S=
IZE));
>>=20
>>   return memmap;
>> }
>>=20
>>=20
>> Then we'll better follow "all or nothing" principle and won't have
>> exceptional cases in section_deactivate().

To follow  "all or nothing" principle here, I think we should not call
section_deactivate() to do the cleanup in section_activate().

After all, if section_activate() didn't succeed, how can we use
section_deactivate() to release the resources? What do you think?

Thanks.

>>=20
>>> Thanks,
>>> Muchun.
>>=20
>> --
>> Sincerely yours,
>> Mike.

