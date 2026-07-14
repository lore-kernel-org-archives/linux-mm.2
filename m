Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 682D0C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 11:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60CFC6B0092; Tue, 14 Jul 2026 07:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3926B0093; Tue, 14 Jul 2026 07:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520B06B0095; Tue, 14 Jul 2026 07:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 261A86B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:23:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 90BC48028E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:23:34 +0000 (UTC)
X-FDA: 84987146748.05.7F0C384
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf08.hostedemail.com (Postfix) with ESMTP id D1A58160002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:23:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BTzB0iPZ;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784028213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ic+aWwaSz46V+LedNdfmAheNIC6sClM8F1svsoDeJLQ=;
	b=ZfxmCxG3unQmf2lmGgMogJd4USMEeKKT0fulRB87WXli4qs/YFtAuE+NJ0KAtks78XVi8K
	nkHyr3SWPCqmpgbtZZqYzp4RGOcwq8T0nM81uP0nIlw52mpjZF+bsitIb7P0PZTLCv1mYf
	Snl+7q5xG0rKJKZNQ0I0i8NctJzIbZs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BTzB0iPZ;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784028213;
	b=Swd3qJLR28UluBol9lZjGp5BXH5GNoP0DNJWK5+6EeOnf2iCRWfx/GGNsQdc9H1gxOe6Ki
	CVeyYrN72ZUeLe5DfPRhipzi8I90+ndkg7DUPMlTWeLExuSh2hll160mDnGNQOnzyDqd1R
	VjjZwGTdcBG2yKYGbg49TGaS6SRKFbg=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784028208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ic+aWwaSz46V+LedNdfmAheNIC6sClM8F1svsoDeJLQ=;
	b=BTzB0iPZJxSwIjoJI+hAEyWR8xxBjAJMON/tbmuUmybdBNBD14IL/+qBx7/G0FNdwotYAv
	Wo94bFny/4PokGhwWVU60T4ZI3e2OECohbrdVrdrGGBB3EzFNWGgmcFBNCJpfNkFR8G+0o
	x+PZZkCIokQdJYLmn0RvwX9FB35yNMI=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v6 8/8] mm: use memcpy_nt() in zone-device template copies
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <04f5b50a-a526-4644-b9f0-c54a0d6db702@linux.dev>
Date: Tue, 14 Jul 2026 19:22:39 +0800
Cc: linux-arch@vger.kernel.org,
 linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 x86@kernel.org,
 akpm@linux-foundation.org,
 apopple@nvidia.com,
 arnd@arndb.de,
 balbirs@nvidia.com,
 bp@alien8.de,
 dave.hansen@linux.intel.com,
 david@kernel.org,
 kees@kernel.org,
 mingo@redhat.com,
 rppt@kernel.org,
 tglx@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <67BC9BE5-A201-4DED-B847-8C74BF30B16D@linux.dev>
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
 <20260709112520.24857-9-lizhe.67@bytedance.com>
 <04f5b50a-a526-4644-b9f0-c54a0d6db702@linux.dev>
To: Li Zhe <lizhe.67@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nr69z8b9cnj4ocur56shf69n7xepkmt5
X-Rspamd-Queue-Id: D1A58160002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784028209-828570
X-HE-Meta: U2FsdGVkX19KtxgaUNSjvMkYskGxAQ2xsYjqx7qled1v8A/8xtyWCJ31PKZ7HZpNZD2jgV7CWxBETL7ca4JPZpQv+SJS9nLZimzxjAicHXtMgAgG7mkdr+bW5bnvIhC1m7ijty5jJi/OuDhcwP9KLjGACRwelA2ichbaGr9imjUTT8R17UFdUB1PHxH7mu7MyA8oI9V0jnGXxsu6Gu9JV4jXbWzG0lvkPVxHj+4oLxiCCdad9HtTFqL0qQMm+fKsKK1Nnf7vuuoeWZC2Hgf63ACWACEa+fLgKo6BOk9lqYus2tK/Os4Wv5fhMWcrSYmipqO24vzVbQrtlnEeK7w9QcGpHSHF82r/AAXxThmqs3Z2hkWfL5pIklFgzDb6oAFQjgYECTXOGiDXgKEOg0HY5WZw8j5qikBPp7OY53ni5XoOvFIWLMx1ouuTfBnWvKqZpTEvCiZ3l/X2L5nddKOM53HlCHRJ1iikuTLQqNgp5TYvxgLK7CKMSBf2kTZusJuv1A9nMrRw99m+e3b7FNjkU5OvuILUCJargKB0aI6pgJg7VJhjMmikA6CeNpfP8yn7PehaHdV1mPDYekHHMJAXI607+B4Wh9orY6/NvhwSs3tXDOEfncAKCNwx1f7TBxQE4eQ5slb65p1sbaCqXFEeGEWCBmOuVepaks+XCjcR5Y8Lr5fhIGDNQd6zkU3m5UfzF7wnfTFffSuOo2QPi6WdXxY0cwBdNdu/6rJtJlDwGPjjPU6YWXaweeehWiKtp+NWa69MA5NjXMuEFjrK9qLDqR/E/xmAvsFCPi48AR3vjJ6oIijVFHxIsh0VpYfquHfdPgFS7jWlYsw7wsc28DXiYe0O3bEmbvpG81vuGLLMw6LNiqeIOdEw+ztBnG6wFd3u/dJ/GTHjvpbEPZ6xnY2Ps4he8B3dFpK+IH7AfXzxvfQpfiee0XRMEDgT5iJqYuhslXn0lwjOMtmezbaC11m
 U2LN9Nuy
 UKAtmr97HtrxnpLuweLmVFIX1G0uRGkmcv/4WogEXrrXy9/32rXxGUf79w/1uk0F0OZbdS8JaUxNP2HqCUJttqY7lSTgh63FQj6IjwgcunhQK645VaJDRyHQDBJyF8ZbEAxjHMrz9xfK1y0+xxcM7W7GM6sWz0Ci1GPtwyGm7sM4IGL2YiRm6vLv80N1XT2TgqjzKFfOIz8SKajg6uS5Ryu8GG8ST48Gpezg0jBzDZzlH/0vc4BfLUl579d7w3LIJELgS14m8hqtDfIkQmatvmrWqlNU9vVfII90hPy5FxiBgMmVbrw8qT0GRkfGtewwFJmO1164R4rR8G+1EvaXyqnjHyPFlQCpYRrh/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 14, 2026, at 17:45, Muchun Song <muchun.song@linux.dev> wrote:
>=20
>=20
>=20
> On 2026/7/9 19:25, Li Zhe wrote:
>> The template fast path currently uses memcpy() for the actual struct
>> page copy. Switch zone_device_page_init_from_template() to =
memcpy_nt()
>> and add memcpy_nt_drain() before memmap_init_compound(), before
>> prep_compound_head() updates overlapping tail metadata, and before
>> returning from memmap_init_zone_device().
>>=20
>> ZONE_DEVICE memmap initialization is largely write-once: each struct
>> page is populated once, and most destination cachelines are not =
expected
>> to be reused immediately afterwards. On x86, a regular cached =
memcpy()
>> can therefore incur write-allocate traffic by pulling destination
>> cachelines into the cache before writeback, and can populate the =
cache
>> with data that has little near-term reuse. Using memcpy_nt() lets =
this
>> path request non-temporal stores for that copy pattern, which can =
reduce
>> cache pollution and avoid part of the associated write-allocate
>> overhead, while architectures without a specialized backend still =
fall
>> back to memcpy().
>>=20
>> When memcpy_nt() maps to non-temporal stores, order those stores =
before
>> memmap_init_compound(), before prep_compound_head() updates =
overlapping
>> compound metadata, and before returning from =
memmap_init_zone_device().
>>=20
>> Keep sanitized builds on the slow path so KASAN/KMSAN retain their
>> instrumented stores.
>>=20
>> Tested in a VM with a 100 GB fsdax namespace device configured with
>> map=3Ddev and a 100 GB devdax namespace (align=3D2097152) on Intel =
Ice Lake
>> server.
>>=20
>> Test procedure:
>> Rebind the nd_pmem and dax_pmem driver 30 times and collect the =
memmap
>> initialization time from the pr_debug() output of
>> memmap_init_zone_device().
>>=20
>> Base(v7.2-rc1):
>>   First binding for nd_pmem driver: 1456 ms
>>   Average of subsequent rebinds: 244.28 ms
>>=20
>>   First binding for dax_pmem driver: 1462 ms
>>   Average of subsequent rebinds: 273.31 ms
>>=20
>> With this series:
>>   First binding for nd_pmem driver: 1272 ms
>>   Average of subsequent rebinds: 96.79 ms
>>=20
>>   First binding for dax_pmem driver: 1354 ms
>>   Average of subsequent rebinds: 119.04 ms
>>=20
>> This reduces the average rebind time by about 60.4% for nd_pmem and
>> 56.4% for dax_pmem.
>>=20
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> ---
>>  mm/mm_init.c | 39 +++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 37 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index fb855bb0437a..addb4969587e 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -1067,11 +1067,21 @@ static void __ref =
zone_device_page_init_slow(struct page *page,
>>=20
>>  static inline bool zone_device_page_init_optimization_enabled(void)
>>  {
>> + /*
>> + * Keep sanitized builds on the slow path so their stores stay
>> + * instrumented.
>> + */
>> + if (IS_ENABLED(CONFIG_KASAN) || IS_ENABLED(CONFIG_KMSAN))
>> + return false;
>=20
> It is not a major concern if struct page initialization lacks KASAN or
> KMSAN instrumentation. To keep things simple, let's just entirely =
remove
> zone_device_page_init_optimization_enabled() to simplify the code.

BTW, If you really want to properly support KASAN, you should integrate
the check directly into memcpy_flushcache() via kasan_check_write(), =
rather
than treating it as a special case here.

>=20
> Thanks.
>=20
>> +
>>   /*
>>   * The template fast path copies a preinitialized struct page image.
>>   * Skip it when the page_ref_set tracepoint is enabled.
>>   */
>> - return !page_ref_tracepoint_active(page_ref_set);
>> + if (page_ref_tracepoint_active(page_ref_set))
>> + return false;
>> +
>> + return true;
>>  }
>>=20
>>  static inline void zone_device_tail_page_init(struct page *page,
>> @@ -1110,7 +1120,7 @@ static void =
zone_device_page_init_from_template(struct page *page,
>>   * to the destination page.
>>   */
>>   zone_device_page_update_template(template, pfn);
>> - memcpy(page, template, sizeof(*page));
>> + memcpy_nt(page, template, sizeof(*page));
>>  }
>>=20
>>  /*
>> @@ -1179,6 +1189,15 @@ static void __ref memmap_init_compound(struct =
page *head,
>>      &template);
>>   }
>>   }
>> +
>> + /*
>> + * When the template path is enabled, order the preceding tail-page =
copies
>> + * before prep_compound_head() updates the overlapping compound =
metadata
>> + * in the first tail-page descriptors. If memcpy_nt() fell back to
>> + * regular cached stores, memcpy_nt_drain() may be a no-op.
>> + */
>> + if (use_template)
>> + memcpy_nt_drain();
>>   prep_compound_head(head, order);
>>  }
>>=20
>> @@ -1238,10 +1257,26 @@ void __ref memmap_init_zone_device(struct =
zone *zone,
>>   if (pfns_per_compound =3D=3D 1)
>>   continue;
>>=20
>> + /*
>> + * When the template path is enabled, order the preceding head-page =
copy
>> + * before memmap_init_compound(), which immediately updates =
compound-head
>> + * metadata. If memcpy_nt() fell back to regular cached stores,
>> + * memcpy_nt_drain() may be a no-op.
>> + */
>> + if (use_template)
>> + memcpy_nt_drain();
>> +
>>   memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
>>       compound_nr_pages(pfn, altmap, pgmap),
>>       use_template);
>>   }
>> + /*
>> + * Ensure any prior template copies are ordered before returning.
>> + * On architectures where memcpy_nt() used regular cached stores,
>> + * memcpy_nt_drain() may be a no-op.
>> + */
>> + if (use_template)
>> + memcpy_nt_drain();
>>=20
>>   pageblock_migratetype_init_range(start_pfn, nr_pages, =
MIGRATE_MOVABLE);
>>=20
>> --
>> 2.20.1
>>=20
>=20


