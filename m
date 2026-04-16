Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27C3CF433D0
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 02:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45C356B0005; Wed, 15 Apr 2026 22:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40D476B0088; Wed, 15 Apr 2026 22:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3235D6B0089; Wed, 15 Apr 2026 22:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20D226B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 22:06:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C56251A058A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:06:51 +0000 (UTC)
X-FDA: 84662780622.15.7DEB5FE
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf05.hostedemail.com (Postfix) with ESMTP id B005010000A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:06:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J0zA0c7P;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776305210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TaDtlDhvpSN1DHQ/+o47EJco+lcgV052hZ9XtkHXQBM=;
	b=Nx5rF7VquyHud7GxwZ9a/eGZGXyyjA0+iIUlBtK+XY5CPm8FTbM1pzIGP7UDuhSg4bUGC/
	fdVeoyGHkj+73khFi1V7XkHOv9TdjKrz7lYp6zFmUCAGqVdWMkTUlLx2mpUE4DimDs2CgO
	6xvUeJY6NzOlIQniTzUkUWmuHxJKF4w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J0zA0c7P;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776305210; a=rsa-sha256;
	cv=none;
	b=OSe/97d/TYMWJX3/GaxAkUqK9Yah0rx8AYiMQ8fJHCnXsW2J26BF8nkPOT4F7Xu0wFz7kc
	6KVaTKv+QPlM2Wv1dMgrUPeiy7zLEK+vY6VZQQQebYp1gObSLWs8Ld94QnFiwn2DdT8Kni
	dPjS5HVoG5GIxQjNdpL8f1I5759tByo=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776305207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaDtlDhvpSN1DHQ/+o47EJco+lcgV052hZ9XtkHXQBM=;
	b=J0zA0c7PNrU1/2K6DsccDATXvjS/5EjTLM92uaQLPBY5Bs2V4BcyO2VeGwXmN8w1IQpL8E
	uiKGZopweljMF01lnCABOKA5JDUkCf3P60EkZYOn4tKQ6HjXEmbJ+l9Aq0NcG3edWqIxxp
	eVPIu6DatuMk04EV+TM9SasWJSra1zs=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2 6/6] mm/mm_init: Fix pageblock migratetype for
 ZONE_DEVICE compound pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ad_EygHWDi19SS9y@kernel.org>
Date: Thu, 16 Apr 2026 10:06:03 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
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
Message-Id: <86523791-2C69-4A43-BD32-3713840A6640@linux.dev>
References: <20260415111412.1003526-1-songmuchun@bytedance.com>
 <20260415111412.1003526-7-songmuchun@bytedance.com>
 <ad_EygHWDi19SS9y@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B005010000A
X-Stat-Signature: su6jdkzih1mnzd5chmofyn5gfphf3sgq
X-Rspam-User: 
X-HE-Tag: 1776305209-643181
X-HE-Meta: U2FsdGVkX19I+bXUyVf8mwVVfOLnwcsK7IqWFpvkd7+ER1CbcTXq9UOuTdPNph17eMZaTOV/bYDY98rHe8xt8SUA7S47bDZ290C5KcSEEQsJyrYalJvNUg2r2n68Xw8SB7TkPlFj7RM8lzPtlDC6XQgHunz2qdgfA83Ngs/QtH9irWAcTjhCZtQfUYVcN5WN6Z28id3xD4YqLDhuBoutvC4wpx0kuuSS2tR1wKV4kCfy9qJUKnx3wzbwSzPe9JgcGAsH+2A5G9ZjMcofy9YOwWLLzJvIhdVXO08vaCHTcOrXENwDgFh9Wp4eRqB0PD7eMDd0zaCo6C40mZ7XYe08xQJYAb9OsLA4SP0A8iGXqNrcb+tYe1VVfIXjOPgapW5hTg4yObNraOtz7jE2ly6yHGx2xg9qNw/1deL0Krmx3yQzor1yzV13hkcq12UoXp7IRBHaHK32XVxamP9vS+QLF+D+8VeLsBVTKPGNC9QUsfPYzLKtGq9TN4WPJbXABSxdkwmc9MCLVQLEt04gvry6IFPGFcescBmZlgqRooEzyILkiRn6t9gEoR3buuEj/uFE5ecdBLNW0voYCDF4OG6+Fa85E8ADjGmJKF2pnAUOid2VJ56PUkWtj+U7CC3TAhOdRzmNWZ+gTFJdPNw7ghK0K65mBQXNoCAZr0ZWFjoJtPEN2hrtbir59dLPgX1k4lm6yznQ7YBcFR9WbxGeAz42TS3I9UDHuFEbVwLxpkv3GkvP6+mxPLQUnR8aqsp34+TMBht4wReiODrDT6pJ2Smr81/q7YfE9M8ZE6xDelBNPr55O21RpHj45nPwwtR61mVruR6Z416RTPBFTugisyq9ProUFqPBaWR8DSOryPMjiZFpeI6HWARWbuQCWBHbjp4gVh2HElc8IEoQjUtcWVK1NaBm0V/47ZNf46yAyjNUk4wbU5aIZiwjbot6gwyhE/o24GaKDWV2DaJnCjMXhqx
 oU7RYvdT
 ZqiK+3Ycwk0L86kzwTYljpywsKk385FlodFhX9BnYCZSOPtKpD/U+GdQOnJjPL4KIsCZkoewe9W3PUpHWqIzSvgwtw7HdGZRHkhSfStjZXj72tiQSvOqHzCRnrb6wOGCEvjCbYPW+j5/X5nw1AkFrIrDnmXbenpihHfgqjABXTLcM5oqF+epOJH/goXxNrhx+maxDf0Di4BJ9/MgjNJ4xsXsKYWk9sprAFimKO1BFukM9QF6NgGuu39T050jKUvUl8fc0IoJF8TD/i3Cuf2bwp9oWkKjj8UKM4YbpqhIs9pzSTKdkQcPrtImVgkF4Nk9YE2ZXnCNSjGEueJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 16, 2026, at 01:03, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> Hi Muchun,
>=20
> On Wed, Apr 15, 2026 at 07:14:12PM +0800, Muchun Song wrote:
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
>> ---
>> mm/mm_init.c | 42 +++++++++++++++++++++++++++---------------
>> 1 file changed, 27 insertions(+), 15 deletions(-)
>>=20
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index f9f8e1af921c..30528c4206c1 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -674,6 +674,19 @@ static inline void fixup_hashdist(void)
>> static inline void fixup_hashdist(void) {}
>> #endif /* CONFIG_NUMA */
>>=20
>> +static __meminit void pageblock_migratetype_init_range(unsigned long =
pfn,
>> +        unsigned long nr_pages,
>> +        int migratetype)
>> +{
>> + 	unsigned long end =3D pfn + nr_pages;
>> +
>> + 	for (pfn =3D pageblock_align(pfn); pfn < end; pfn +=3D =
pageblock_nr_pages) {
>> + 		init_pageblock_migratetype(pfn_to_page(pfn), =
migratetype, false);
>> + 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
>> + 			cond_resched();
>> + 	}
>> +}
>> +
>> /*
>>  * Initialize a reserved page unconditionally, finding its zone =
first.
>>  */
>> @@ -1011,21 +1024,6 @@ static void __ref =
__init_zone_device_page(struct page *page, unsigned long pfn,
>> page_folio(page)->pgmap =3D pgmap;
>> page->zone_device_data =3D NULL;
>>=20
>> - 	 /*
>> -  	 * Mark the block movable so that blocks are reserved for
>> -  	 * movable at startup. This will force kernel allocations
>> -  	 * to reserve their blocks rather than leaking throughout
>> - 	 * the address space during boot when many long-lived
>> -  	 * kernel allocations are made.
>> - 	 *
>> -  	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
>> -  	 * because this is done early in section_activate()
>> -  	 */
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
>> @@ -1122,6 +1120,8 @@ void __ref memmap_init_zone_device(struct zone =
*zone,
>>=20
>> 	__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>>=20
>> + 	cond_resched();
>> +
>=20
> I don't think we want cond_resched() for every page here too, even =
it's a
> compound page :)

I'll update it to every PAGES_PER_SECTION, does this make sense for you?

Thanks,
Muchun

>=20
> Otherwise
>=20
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>=20
>> if (pfns_per_compound =3D=3D 1)
>> continue;
>>=20
>> @@ -1129,6 +1129,18 @@ void __ref memmap_init_zone_device(struct zone =
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
>> + 	pageblock_migratetype_init_range(start_pfn, nr_pages, =
MIGRATE_MOVABLE);
>> +
>> 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
>> 	nr_pages, jiffies_to_msecs(jiffies - start));
>> }
>> --=20
>> 2.20.1
>>=20
>=20
> --=20
> Sincerely yours,
> Mike.



