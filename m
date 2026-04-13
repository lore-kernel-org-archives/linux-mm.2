Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44F51EBFD35
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AEA06B0089; Mon, 13 Apr 2026 06:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5872B6B008A; Mon, 13 Apr 2026 06:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C3D46B0092; Mon, 13 Apr 2026 06:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 408456B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:08:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E60BD1A00E0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:08:29 +0000 (UTC)
X-FDA: 84653107938.11.275D2D3
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 88C094000A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:08:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WLiyyOCr;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776074908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sps84VvkM9WL1pZA/XR4z7lJiIfi6BTmHDf8JsPgXUg=;
	b=K8QF7Ze27oUElBm7wD7Hg9c/pj7hXM/nDdrLxTOkspj9Lo58JgwEXJg5izemk/CKLD/auu
	v9Yuxc3bR1uAlU3qvTUgdk9hQgAFm2AQd3U+iphDspOeRalKL8tvtslonCEApP/qxMFNC2
	EzIOD4RJ+gaWZSQPOmqQci5hZNYjIfQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WLiyyOCr;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776074908; a=rsa-sha256;
	cv=none;
	b=aSVoPlDtwWVfQVuRDTg/AVXTI9SxWD1i2MOIFwn4vf6YXYx3NRMiM/8Y8gytZMJU9HSZlf
	dPymaFiHn0ZND2oy04gfkAtH0npluJZ1Bjs2a/qldgKJN4RtbF7zHwhOs11M2ZL0SodgEd
	WckXUJCXjcuI9z/dFAgq9EEzNYXrNh8=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776074903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sps84VvkM9WL1pZA/XR4z7lJiIfi6BTmHDf8JsPgXUg=;
	b=WLiyyOCrQpSqlbf5UlYg0hO4AvDZM7uLPrY9tN+xx3bzTm461ZlsVNwtJ7ZMOa1fUZjx8d
	HK9WKtvgaGuxhxHBe+aUoDbvaQkHBZDJKQK6zfA8TVEk51y6TF+9wIyya+RmrY/kG6bzAz
	qufQTDe3llLJJmWr78ZKyTufEHL3yoY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 06/49] mm/mm_init: fix uninitialized pageblock migratetype
 for ZONE_DEVICE compound pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ady4LBppz-na5lM5@kernel.org>
Date: Mon, 13 Apr 2026 18:07:44 +0800
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
Message-Id: <5910791C-9893-4710-9002-76534DBFBFBD@linux.dev>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-7-songmuchun@bytedance.com>
 <ady4LBppz-na5lM5@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 88C094000A
X-Stat-Signature: o5kuiyyr4m3zkhtu9ieqaxwi13ezeb1p
X-Rspamd-Server: rspam06
X-HE-Tag: 1776074906-153453
X-HE-Meta: U2FsdGVkX18//YZZx1XflCRQeaRM6mombP4i06BxxFCdVFrzEYDd8sEmrW6pNQrOeb/sa6LNMIsBo+lbCANTT7hUirMLhfxm2tI62RPpXcHyvwiW06v9KAx0Ns2V3hYTb74Ri3Xk2mtzFnXayDQMvEkXG1rEkxE+Tdrzw7XYP9FHgT6eAWlHh9JlK02TmM5pjBnff6Y5n1uVW+Vz+m1zDk0aFvQ5PkbaebZbblP3Xq19/0cBA6IUvvU+HIavARIRVZ3Y+5YAIZEzo3090q2NCsZN0Akm5kSJgK3n8gc410jC6ksaaLot0/fL+NribB6GUZ/olnRJzbVGYfLrZApvauBw3mgmVwhIhpg9ZPWP35ZuXohdEGKfV/mBLU9ZJObkqIgsCfZ/F++jbtgr+vZXnYWcuvl/y6uDUybh3+OYcs2ZRORvnhft59lzYCYPG9WZMEfLTP95sEaQWN8b/OVy59Hg23Zh0aHfOuzwEYBcUGlNUiMr9fyTnJeSxQ5gdQd7sWyvTVosKX9YUZTnvoSxK9BgYit001g/dIvCsKRkbu9XQ6bG9yBQufVnn7DPWtsXtMEc+cd836pk+/+y0E/NaNmuSIxB9QWsZBnwsR+NUuobpEnO4QIt0K6yKm0d2fiUzDCBegziVtV4mQF3VTpcHvb009oW7qD/Mf+8Flf9u74jcGRuWG49zHdh15gK3vKhTY9QcyDzvIeECFU9OqaYX/3VukoF0eQqrT9g5Q/JX2eAoVQbKyHHmaLLFPhGsfwsuu6NTylcHNqp6fg1/Qc5XDr6+vkjQNIZdQ/QBgfbylfj7lTaa4zh1sJxS9osnrTqPi7nmIqFuck6YAnkJtF02myf9F0D4WcPf0M0odL8dN85xV43sAbKcWTtYztaA7vHF+eSc9u/FnVQz3uFsLLaPaYypNvfWfcC5Ib311yISzEJFlGUnSpRVxnjNIIpJLG6j2S6Gz8bQaTOKgZ2Pkv
 WXaTzT3I
 GV6QicaOJi/T8yObiicbKlSnlCY0duSe8DJwf4iAJ6bo76Kh+VoFnLzMLzNf1Bi50KpNPUF+luC7zfThoUM1vQGtCkZJbUonEOXa5v2XyzYwPMN+9t5GRDBjAqUBR7+K3WfyaPG9bfo82XknVTM9Eo8ghIwbN8PWOkfnhjHYk9qpGXgNt2s+L3vJMd8Wnw2O7m1UJsX0VHjoXpHAERQjLc6GjFWaveKfnT2MfjNVjzxK5vGdReGvN+TI+C7nU/R2UKaz/Wp1+c/nwMfswvc03fjIBgfmntoQEvk8eexA+rsUJJd7YiyZ/ElUpb71LeJIYmFrZxrJ5NR4hbiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 13, 2026, at 17:32, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Sun, Apr 05, 2026 at 08:51:57PM +0800, Muchun Song wrote:
>> Previously, memmap_init_zone_device() only initialized the =
migratetype
>> of the first pageblock of a compound page. If the compound page size
>> exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
>> subsequent pageblocks in the compound page would remain =
uninitialized.
>>=20
>> This patch moves the migratetype initialization out of
>> __init_zone_device_page() and into a separate function
>> pageblock_migratetype_init_range(). This function iterates over the
>> entire PFN range of the memory, ensuring that all pageblocks are =
correctly
>> initialized.
>>=20
>> Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for =
compound pages")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> mm/mm_init.c | 41 ++++++++++++++++++++++++++---------------
>> 1 file changed, 26 insertions(+), 15 deletions(-)
>>=20
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 9a44e8458fed..4936ca78966c 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -674,6 +674,18 @@ static inline void fixup_hashdist(void)
>> static inline void fixup_hashdist(void) {}
>> #endif /* CONFIG_NUMA */
>>=20
>> +static __meminit void pageblock_migratetype_init_range(unsigned long =
pfn,
>> +        unsigned long nr_pages,
>> +        int migratetype)
>> +{
>> + unsigned long end =3D pfn + nr_pages;
>> +
>> + for (pfn =3D pageblock_align(pfn); pfn < end; pfn +=3D =
pageblock_nr_pages) {
>> + init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
>> + cond_resched();
>=20
> Do we need to call cond_resched() every iteration here?

Of course not.

>=20
>> + }
>> +}
>> +
>> /*
>>  * Initialize a reserved page unconditionally, finding its zone =
first.
>>  */
>> @@ -1011,21 +1023,6 @@ static void __ref =
__init_zone_device_page(struct page *page, unsigned long pfn,
>> page_folio(page)->pgmap =3D pgmap;
>> page->zone_device_data =3D NULL;
>>=20
>> - /*
>> -  * Mark the block movable so that blocks are reserved for
>> -  * movable at startup. This will force kernel allocations
>> -  * to reserve their blocks rather than leaking throughout
>> -  * the address space during boot when many long-lived
>> -  * kernel allocations are made.
>> -  *
>> -  * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
>> -  * because this is done early in section_activate()
>> -  */
>> - if (pageblock_aligned(pfn)) {
>> - init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
>> - cond_resched();
>> - }
>> -
>> /*
>>  * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
>>  * directly to the driver page allocator which will set the page =
count
>> @@ -1122,6 +1119,8 @@ void __ref memmap_init_zone_device(struct zone =
*zone,
>>=20
>> __init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>>=20
>> + cond_resched();
>=20
> Originally we called cond_resched() once per pageblock, now it's =
called
> once per page plus for every pageblock in the tight loop that sets the
> migrate type. Isn't it too much?

There are indeed many more cond_resched() than before, but I don=E2=80=99t=
 have a
concise way to write it, so I took the easy way out.

How about:

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2d680636b67a..d13a2577c4c3 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -683,7 +683,8 @@ static __meminit void =
pageblock_migratetype_init_range(unsigned long pfn,

        for (pfn =3D pageblock_align(pfn); pfn < end; pfn +=3D =
pageblock_nr_pages) {
                init_pageblock_migratetype(pfn_to_page(pfn), =
migratetype, isolate);
-               cond_resched();
+               if ((pfn & (pageblock_nr_pages * 512 - 1)) =3D=3D 0)
+                       cond_resched();
        }
 }

>=20
>> +
>> if (pfns_per_compound =3D=3D 1)
>> continue;
>>=20
>> @@ -1129,6 +1128,18 @@ void __ref memmap_init_zone_device(struct zone =
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
>> + pageblock_migratetype_init_range(start_pfn, nr_pages, =
MIGRATE_MOVABLE);
>> +
>> pr_debug("%s initialised %lu pages in %ums\n", __func__,
>> nr_pages, jiffies_to_msecs(jiffies - start));
>> }
>> --=20
>> 2.20.1
>>=20
>=20
> --=20
> Sincerely yours,
> Mike.



