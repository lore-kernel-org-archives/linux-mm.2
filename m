Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A417C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 13:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518806B008C; Thu,  9 Jul 2026 09:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C8D86B0092; Thu,  9 Jul 2026 09:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BA846B0093; Thu,  9 Jul 2026 09:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9E26B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:25:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D51C8B9CB
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:25:14 +0000 (UTC)
X-FDA: 84969309348.09.F16C6E0
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 214B5C000F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:25:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QSXGGM3n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783603512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sO9G8F5VULeMEdh5I5+DwqvlznbD42nz7nqrLE6HRog=;
	b=I1EsL+1L5YTqe+Z4wdfJ4BhlCVJPmmwZrcHIW93rj42a0fDfDwj6wo9TEl2ijKoSoCC87c
	SaMhAjTawEP/4s8v2gxlYuaL1qd5pBs/V5joBi8tL8GChLoQswgvDtzIsGS3lc+Fr22+L0
	i4WsGw8ECH1x8Og23o5nvWAdSDMBnMI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QSXGGM3n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783603512;
	b=A2far+NfM5qKNsQfnQ2L18xQexJ/p88/iL8PY1w0NQXML8digVna8gFp8fhty4/VjcyEDS
	VoMpb64khc0Zqx6vmaIayfrRvTNN+HpnTYFK9KwwaToCLPEK5fbSZ+j15BPTUP6d58neWo
	BLPiz0Y/uA/aPIMiScli0L0ON4DM6C4=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783603510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sO9G8F5VULeMEdh5I5+DwqvlznbD42nz7nqrLE6HRog=;
	b=QSXGGM3nkI6u+O+hECi0uUyevg1hNCWwlHV/ZG8B8g1RP8JtVFpnPfnZgITfiekwEaBx3k
	eDLeqc/jxdcIiy4W1sQizWiCk7QTeub1WuZAQRrrBWHlLCdsxzIPlWx7Vtjg9woy2gO7Q6
	KrRRL8ORecsEtRjMEEnT8HeDOWUyHf8=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 04/17] mm/mm_init: skip initializing shared vmemmap tail
 pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ak-ctr06UDUlNCJZ@kernel.org>
Date: Thu, 9 Jul 2026 21:23:47 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CFAE1475-6104-483A-86AE-511FB0A1CA2B@linux.dev>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
 <20260702093821.2740183-5-songmuchun@bytedance.com>
 <ak97z4tryYAGJgb_@kernel.org>
 <2306829C-A66D-41F2-B5F7-1C164A7FF757@linux.dev>
 <ak-ctr06UDUlNCJZ@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 214B5C000F
X-Stat-Signature: n7ezm88rurb6nb9sphxsny3wf31q3gdy
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783603511-766500
X-HE-Meta: U2FsdGVkX19A2I4PwgNXk2CUg2YOtLQ7yuvXMArUSzsi17WI2DOrONxZh26De2pEC/fb0LlLkewJQkHssWm9R9t75poEWAFnXuYNJR2HEDtrzeLYHoEqJPADFLaqyGqbVuvRCmrfs19lqPX9kEkntkfimNqNlmMOOqYLAOG7Wc7dpfyEE8Ta9wWUOm16Q3lHCWglVuoNcoTONnvpiqZaFx8nLgM+FCwYc8+2aT/xz2/+m2NKeAGXsx1G3vKufcnEjWENIaKr4hy/WEx72mCNYHSCElX2ZPJiWHxunLVX/ZrZ+yib35sh8Rm9NWMwglL9SUv2qlu9u7X9S2E9/nJW53TAFDh6gXFattZXsO+WPN+FKdNBUyGkAovAY5bldlzXoYysir5PYOKEr66hEtpTs+5pPH+NSf048M1pkHLLZAT6PQoCsF4owjWyRAHLMAsj+NHCKj4SZhCE/D964bkOq/UI1xFKwwkg3CEqXBaPxbe8OB5CWwHYKrgSqTAjCvJN31FAmaUMy3INiDhW3Ok31IoSdieqm3DLerUsZw3BJxLaCm9F41vhr/aKPbF1WqHPltJcXty1PsvKGe1ooRUkKJVzMPuVdweOFJ9uKnsLKR84zUdfBjaCqDv0uZX8eaRGanX2G4PgLM7VKKtuWvjOCQwcdOJYW1wXpjKs4Q+fsUBAJkDMjE1djck1qaDr/6RNiaQOp33KXMoM4SCOnUxVREUP65TJHDjCCLZ5td4tndtVJW2v6rqaImoHF6o1eDr/bhdz5oOHWSiIWJVtfMt/zr3sj7qC10tAAgGd/CAPK/aS4NH+e90TAo7B1VpiTL+h5F8NZ2yvBVhwLBS7sfPqU6q15EOokco1VI2KybdTxE93n/Rh2fp+XKG0YGdPQ2POSPKfUt0JlxeXozXl9lomZbRFkCD9nLsWWPLeSYD4rIcQEiz5MzsRZK9HRMd59WN1dVkVDwavRj8JIvsaUlv
 QVmAc/bM
 eMSUCgfCHkBqTETLNLce338MFJ9prr08YbqjKDluDxMm76r2FerK7QGje9wTELdwNj9gKzWn3yYg0vH1rOwLk3eof7VJKfrArzeEhHopIp1KBSDNSwvUhMxXURhXeHg60AGJ7tXtCF4qr3wQCRk30/Omt2760I1EZmjeLCrYzSgfr6ZNQGdrfzyIh6ytQRzWxix7WqZj9+Fy4i+WUHJLkCWNytsnQ4FF4D+e1a6LQ4xi45MJ3wlxbd0j7RjSIZ1x9K2qp4RW8wcd5IiILwz5qznzqLr45oPmC+bmwtLkqYTPFOWJwKXXRjmwzX+lPyAlrHsd+Lv8isRCBZoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 9, 2026, at 21:05, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Thu, Jul 09, 2026 at 08:31:31PM +0800, Muchun Song wrote:
>>> On Jul 9, 2026, at 18:45, Mike Rapoport <rppt@kernel.org> wrote:
>>> On Thu, Jul 02, 2026 at 05:38:08PM +0800, Muchun Song wrote:
>>>> memmap_init_range() initializes every struct page in the target =
range.
>>>> For compound pages with vmemmap optimization, the tail struct pages =
are
>>>> backed by a shared vmemmap page.
>>>>=20
>>>> Initializing those tail struct pages would overwrite the shared
>>>> vmemmap page contents, so users such as HugeTLB have to open-code
>>>> follow-up handling to restore the metadata afterwards.
>>>>=20
>>>> Use the section's compound page order to detect struct pages that =
fall
>>>> into the shared tail vmemmap range and skip their initialization in
>>>> memmap_init_range().  Still initialize the pageblock migratetypes =
for
>>>> the skipped range so the surrounding setup remains intact.
>>>>=20
>>>> This is a preparatory change for consolidating handling across =
users of
>>>> vmemmap optimization, and it also avoids redundant initialization =
of
>>>> shared tail vmemmap pages during early boot.
>>>>=20
>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>> ---
>>>> include/linux/mmzone.h |  4 ++++
>>>> mm/internal.h          | 16 ++++++++++++++++
>>>> mm/mm_init.c           | 25 +++++++++++++++++++------
>>>> 3 files changed, 39 insertions(+), 6 deletions(-)
>>>>=20
>>>> @@ -673,19 +673,21 @@ static inline void fixup_hashdist(void)
>>>> static inline void fixup_hashdist(void) {}
>>>> #endif /* CONFIG_NUMA */
>>>>=20
>>>> -#if defined(CONFIG_ZONE_DEVICE) || =
defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
>>>> static __meminit void pageblock_migratetype_init_range(unsigned =
long pfn,
>>>> - unsigned long nr_pages, int migratetype, bool atomic)
>>>> + unsigned long nr_pages, int migratetype, bool isolate, bool =
atomic)
>>>=20
>>> What is isolate parameter for?
>>=20
>> I've re-examined the code, and you're right that the isolate =
parameter is technically
>> redundant for our current use case, as memmap_init_zone_range() =
passes false.
>>=20
>> The rationale behind keeping it is future-proofing. The ultimate goal =
of a generic
>> HVO is to support arbitrary huge pages, not just HugeTLB. I decoupled =
this as a
>> parameter to prevent potential regressions down the road; if a =
developer leverages
>> this for other huge page types in the future, they won't =
inadvertently break
>> things by forgetting to update a hardcoded false in =
init_pageblock_migratetype(),
>> especially since memmap_init_range() natively accepts an isolate =
parameter.
>>=20
>> Of course, we could also just delete this parameter for now and add =
it back later if
>> needed. I think both approaches work.
>>=20
>> Which way are you leaning?
>=20
> I'd drop it for now and would revisit when there would be a new HVO =
user.=20
> Even one boolean means it's hard to tell from a call site what is the
> intention of the flag, two make it completely confusing :)

No problem. I'll drop it next version.

Muchun,
Thanks.

>=20
>>>> {
>>>> const unsigned long end =3D pfn + nr_pages;
>>>>=20
>>>> for (pfn =3D pageblock_align(pfn); pfn < end; pfn +=3D =
pageblock_nr_pages) {
>>>> - init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
>>>> + init_pageblock_migratetype(pfn_to_page(pfn), migratetype, =
isolate);
>>>> +#ifdef CONFIG_SPARSEMEM
>>>> if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
>>>> +#else
>>>> + if (!atomic && IS_ALIGNED(pfn, MAX_FOLIO_NR_PAGES))
>>>> +#endif
>>>=20
>>> Let's trigger cond_resched() on some defined number of iterations or =
some
>>> memory size chunk, e.g PAGES_PER_128M or even PAGES_PER_1G.
>>=20
>> Yes, that's for the best. I was really struggling to choose a =
suitable macro
>> for this earlier, but I realized it's a difficult thing to get right. =
I'm leaning
>> toward selecting PAGES_PER_1G instead.
>=20
> Yeah, PAGES_PER_1G makes sense to me too.
>=20
>> Muchun,
>> Thanks.
>>=20
>>>=20
>>>> cond_resched();
>=20
> --=20
> Sincerely yours,
> Mike.


