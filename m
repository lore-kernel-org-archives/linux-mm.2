Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F23BCFAD3F0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 03:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A20E6B0005; Wed, 22 Apr 2026 23:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B6D6B008A; Wed, 22 Apr 2026 23:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35706B008C; Wed, 22 Apr 2026 23:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDD046B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 23:12:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BDC81403A9
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:12:34 +0000 (UTC)
X-FDA: 84688347828.30.8450069
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5A43818000A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:12:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IGlW4RZv;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776913952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5eNb16Y0uJwWAOzByzOeSIHg4jxQlqJ20m2cdPXXu30=;
	b=WfFkgOmxNLfxiMo5MQL39NOf2GepCgqbFtx9Xezd2gMDcLT4nkXjCSVBOdXFLRM8bUkskh
	+632JK5cQSk9bgLmBjtO5buA7LUIUiXzgwEhsXGPq0hp9/VSz85UYswfjhQMVUPiRq6/hu
	WZiMS7ZnScyPRLjqtIkXLlTqadM978U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IGlW4RZv;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776913952; a=rsa-sha256;
	cv=none;
	b=rs8228mP+EyuiicxSTFvbdlrN5XW9jpPlt4Zbo2vRSnh9Dvo0DKtffXzngk3sFh1p9sv/L
	Tm2hX6V88iuXQWu+3ChXCV7zB+BdSu6rvlj1nxsLfJfp44y3jm5tufL9WTPC0q4MoEixUm
	A2zLS7+x4so+KyurZTGSyZMSeyhohd0=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776913950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5eNb16Y0uJwWAOzByzOeSIHg4jxQlqJ20m2cdPXXu30=;
	b=IGlW4RZvYQzuXJekYe+qqsVATrFv+wW/Be6t5xeDINprC4gd1efrJj+Jp/3gE2ZIq1vsx+
	q/Ji/1RGScCJ7TCRYZ2s6olOYYncU7CobGwX4NiqxURTVbQ+XbUSwA/vg2CbByEb+soAMU
	FW4cfpQnhrDZMM02+y1y9fl2dh6Wb+g=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v4 4/5] mm/mm_init: Fix pageblock migratetype for
 ZONE_DEVICE compound pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <95d59eee-a4fe-4d11-b335-07f3b3ef2e66@kernel.org>
Date: Thu, 23 Apr 2026 11:11:39 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FE96D828-7C9F-452B-8EEE-97CA77EF8E25@linux.dev>
References: <20260422081420.4009847-1-songmuchun@bytedance.com>
 <20260422081420.4009847-5-songmuchun@bytedance.com>
 <95d59eee-a4fe-4d11-b335-07f3b3ef2e66@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5A43818000A
X-Stat-Signature: d5xxdofequ7j4iycooxtp6ouc3mkx66a
X-Rspam-User: 
X-HE-Tag: 1776913952-293675
X-HE-Meta: U2FsdGVkX186fJVa2/otVnX+f7WRyoLspbzwFhiiIhi+3lRvzVAeo4/q6t9TJYFiIGKnzO6Kafpok+AeGRuxW/FOM8hH422pBeWrLYmbKaQZm7AhuPXvxzreAz/VX+C2HU9RQg+wMkzbWy7nddfqbK1UPJZdSSbPPQPQ0lOqqEKzdDF7YYs7Ru/v9DpPMdyB0PYeszfZeycx4C3Y/I5GJRo03vBzyOwE8qLwiA4LvfFxzvFBZaBLApv8TGdGqdql3Z/j5XD4mbCkq1VQJrhdlWUeqQVHKSDAVpo3/22dEO0D2MVN+wCF5M6Kr0oYWwiCPmLaNdaEI/WWTRkgkuNeWOGFf+zceBGhwIRr6On1xI3Um81u7iduM1oebp/OsQ+jEfXcNrY4Tk/2zapIbs7Fe5SQRgYT+dV00Fj3QTV+AY2km1TsdSuug9hRbYk4KXpT2JwsHbeDSi101hGdCqPyJL/rLjWizZVgNdHG/kRuooNa7uQ4rQc9qZ0F8JroLNvTf08Xmc1GQx83oiUz+UV3WIYl+7SuIr6HrPbZDUCnMt1STYn4FB0VKDLPFWYwebBoVvVMbIxkgmXeAPR3bxr5rP2FR9a5CcBva7QrCEziGKig00GQXS6BTCOE7l+EOKSl31zgodY27dsOOWxs7hxKv1BZM+V6u1Ba8cEttOeJ+p8BudOvculvb3BrdyZBweh2HF1T81Xs2ioK5yqm22xGxVUABkbfPgRckMOkS/bPSJ/Z6ws2MAJK0+VqmWB4JtAq4u3qZcb14EE3xkfwEkJLFwwiyuuFzaLUQudN7KdrI3BJJ+TNSsuWm3BB8b1TK9x5yzSs6nTTYKE+yOKfOAcfMsp8hq67bFV82T06dx+skEcae69EdWNHynynHpAcCH+a6qfsFB0kXQWJOnd7wPx7tGdSW+oZp0BKS656E7paBdteGtGkBmsCDEkhFjnncPMRKdTXUoyDH7wtNOrUSqU
 DfeDP2H9
 XZXwPr2XCKFPH6MRs7x6nGop1sOknlVziUGQtqz/v9XuD5+QOCQ73sRLk2b7wOWmxDGf/EfzXC3FP/5HODPUCUuqCCLUjF8OgWVa+l4n9eaqCEfF4CAXnKU02Z9iDeCqCRXa4LM3gpUcHprDIfp3w0M7JAAuDkrCPAZUZp4g6ZMpdaapiiGWbMXt7/+Fjup5HvNVRbkuRUIYlPOP7XInENGv4udaaWOdEZr350M6fdAULl0izo9BXH5iECnCOzCWiD7QWRcAJQAoeSOTqBSLLFt/32ahAQheynF7XaYDYXRKcwHs/e4gsikxFL2xecwpIiXtKoh4XKBf7S7rrunjK4cx2sGfJsDIir1rF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 23, 2026, at 03:03, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/22/26 10:14, Muchun Song wrote:
>> The memmap_init_zone_device() function only initializes the =
migratetype
>> of the first pageblock of a compound page. If the compound page size
>> exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
>> subsequent pageblocks in the compound page remain uninitialized.
>>=20
>> Move the migratetype initialization out of __init_zone_device_page()
>> and into a separate pageblock_migratetype_init_range() function. This
>> iterates over the entire PFN range of the memory, ensuring that all
>> pageblocks are correctly initialized.
>>=20
>> Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for =
compound pages")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>> ---
>> mm/mm_init.c | 45 ++++++++++++++++++++++++++++++---------------
>> 1 file changed, 30 insertions(+), 15 deletions(-)
>>=20
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index f9f8e1af921c..9d0fe79a94de 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -674,6 +674,21 @@ static inline void fixup_hashdist(void)
>> static inline void fixup_hashdist(void) {}
>> #endif /* CONFIG_NUMA */
>>=20
>> +#ifdef CONFIG_ZONE_DEVICE
>> +static __meminit void pageblock_migratetype_init_range(unsigned long =
pfn,
>> +        						unsigned long =
nr_pages,
>> +        						int migratetype)
>=20
> Two-tab indent says hi :)

No problem.

>=20
>> +{
>> + 	unsigned long end =3D pfn + nr_pages;
>=20
> Can be const.

Ah, yes.

>=20
>> +
>> + 	for (pfn =3D pageblock_align(pfn); pfn < end; pfn +=3D =
pageblock_nr_pages) {
>> + 		init_pageblock_migratetype(pfn_to_page(pfn), =
migratetype, false);
>> + 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
>> + 			cond_resched();
>> + 	}
>> +}
>> +#endif
>> +
>> /*
>>  * Initialize a reserved page unconditionally, finding its zone =
first.
>>  */
>> @@ -1011,21 +1026,6 @@ static void __ref =
__init_zone_device_page(struct page *page, unsigned long pfn,
>> 	page_folio(page)->pgmap =3D pgmap;
>> 	page->zone_device_data =3D NULL;
>>=20
>> - 	/*
>> - 	 * Mark the block movable so that blocks are reserved for
>> - 	 * movable at startup. This will force kernel allocations
>> - 	 * to reserve their blocks rather than leaking throughout
>> - 	 * the address space during boot when many long-lived
>> - 	 * kernel allocations are made.
>> - 	 *
>> - 	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
>> - 	 * because this is done early in section_activate()
>> - 	 */
>> - 	if (pageblock_aligned(pfn)) {
>> - 		init_pageblock_migratetype(page, MIGRATE_MOVABLE, =
false);
>> - 		cond_resched();
>> - 	}
>> -
>> /*
>>  * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
>>  * directly to the driver page allocator which will set the page =
count
>> @@ -1122,6 +1122,9 @@ void __ref memmap_init_zone_device(struct zone =
*zone,
>>=20
>> 	__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>>=20
>> + 	if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
>> + 		cond_resched();
>> +
>> 	if (pfns_per_compound =3D=3D 1)
>> 		continue;
>>=20
>> @@ -1129,6 +1132,18 @@ void __ref memmap_init_zone_device(struct zone =
*zone,
>>      compound_nr_pages(altmap, pgmap));
>> }
>>=20
>> + /*
>> +  * Mark the block movable so that blocks are reserved for
>> +  * movable at startup. This will force kernel allocations
>> +  * to reserve their blocks rather than leaking throughout
>> +  * the address space during boot when many long-lived
>> +  * kernel allocations are made.
>> +  *
>> +  * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
>> +  * because this is done early in section_activate()
>> +  */
>=20
> I am deeply confused about the "memmap" comment here.
>=20
> There is no MEMINIT_HOTPLUG special-casing. Nobody "clears memmap".

Absolutely right. This comment was originally copied from the regular
memory initialization path long ago (commit 966cf44f637e), and it has
become completely outdated and misleading over the years after several
MM hotplug refactorings.

>=20
>=20
> That comment was introduced in
>=20
> commit 966cf44f637e6aeea7e3d01ba004bf8b5beac78f
> Author: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Date:   Fri Oct 26 15:07:52 2018 -0700
>=20
>    mm: defer ZONE_DEVICE page initialization to the point where we =
init pgmap
>=20
> Where we added memmap_init_zone_device().
>=20
>=20
>=20
> Is that commit still valid, and this it actually belong here, above =
the
> migratetype setting?

To be honest, I just blindly moved this comment along with the =
migratetype
initialization code out of __init_zone_device_page() without deeply =
analyzing
its historical context and current validity.

After looking into it, I think this comment is an obsolete relic from =
commit
966cf44f637e and no longer makes sense here.

I will completely remove this confusing comment in v5. Thanks for =
catching this!

Thanks,
Muchun

>=20
>=20
>> + 	pageblock_migratetype_init_range(start_pfn, nr_pages, =
MIGRATE_MOVABLE);
>> +
>> 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
>> 		nr_pages, jiffies_to_msecs(jiffies - start));
>> }
>=20
>=20
> --=20
> Cheers,
>=20
> David



