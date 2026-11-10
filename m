Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04FC9606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bhiX/sg9
Received: by kanga.kvack.org (Postfix)
	id EAA636B00EF; Mon,  9 Nov 2026 22:09:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B0D6B05B0; Mon,  9 Nov 2026 22:09:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70C96B05B1; Mon,  9 Nov 2026 22:09:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3DCC6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:09:09 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E28B80742
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:09:09 +0000 (UTC)
X-FDA: 85417728018.23.DC622C3
Received: from mta0.migadu.com (out-92.mta0.migadu.com [91.218.175.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0FFA440007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:09:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bhiX/sg9";
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.92 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794280147;
	b=ikwlGS8bfREGU1DvRb4PXE2JaWYwCgaL7gmTPcfXnR3mCgXp07Oa87RToQrq9krooQNQfb
	Iz8s/8YgJgcHzODMe7eQpEhxHohfLC1s3hZMkXV8pS9o/CD3C6rwgWqPgvpiug0SrRWem8
	C1S37QzJ6gDxgrgYFYhLAdpYVxwTCrI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bhiX/sg9";
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.92 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794280147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/VXI1onF5SeS09KK9lzcvTcmpzrz6Lunid7ms1UK5Nw=;
	b=oYrJlQNaHu1pd4GziIIn/O1p/w9VC9xr65U9r8ZzPPJwiT244yCb8jnrirIPO8FPWU/VcM
	GKJtNQuQ8Uk0U2sTXIAofzvIy0huM/5cJUs7YXjHRTfLedWCJoT9PYeXDi62FRjWar8tor
	Jd3OZxRjH9OR7nGldW8U2TRVcm5MKL8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4vNRBThxCRg1/lwUML9Zpz0Ty+nyn6/jDAJxsej0PWU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794280145; v=1; x=1794884945;
 b=bhiX/sg9FPtDK3iMLNvJz7zXB6dMMvEYHUUslfV4P4zbO3qth0HImCn+hr2JXeA1kktzmScU
 c6Mt17R+gbskOLXahCJnU8H3k1TAuJBBIFTO6wQ179GEaJX+ClrTcJbtAubAANM4sL/JvVAaKUy
 +EqsJeUV15NXEEi+Dhp5UpUU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id dd3535646e2a8843;
	Tue, 10 Nov 2026 03:09:05 +0000
X-Mizu-Trace-ID: dd3535646e2a8843
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 02/11] mm/mm_init: factor out common struct page
 initialization
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <sashiko-outbox-204836@kernel.org>
Date: Tue, 10 Nov 2026 11:08:43 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 James Houghton <jthoughton@google.com>,
 Lance Yang <lance.yang@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <01DEE4E5-49E9-4C33-BBC4-EB04611803B3@linux.dev>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
 <20261109095807.41547-3-songmuchun@bytedance.com>
 <sashiko-outbox-204836@kernel.org>
To: sashiko-reviews@lists.linux.dev
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: 6oqsii1rzud7t9oar7dihqzjhjkeq3da
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0FFA440007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794280146-930190
X-HE-Meta: U2FsdGVkX1+RmckQu/TM5SvMIS2w+KYWpQ6WafmWZHRGRw/ugF5yIKJl5jsg8dyfVbFk4lvj0javm1IIXC2FJGlxrCLDHnPSKAesB2XLljn8hZobsf0ZlWdZq9MoxTFmOm+fs4/+pYUJS750T+bc0WMFnVH8/Oil7vFiIdJH93Ek8V0lOgywjiKBlCXe9ix0xr4fuDNFmhOWwoKOq219bwQpPC+kbagVggErmgRBCJCw3nCcfYU3CNorG/zkdJ8DhexYd+Cz67ZkiPq+nPN1Fd974P5/inmP7+xFL9u+rKnp/kV2Mz5nUZV2uCM7U94i08Ez5sLWd6c3tnjrUfPvbJgvJe+uYjs4dEGIKFC52DE0pW9IDj4iIM1bjXtjdAf0I5zmHyAMOVARIu/9bZZXx6xfi/GMX7kddE3JdUlHSyckHVgPt2Yty6KMgwhIs1H7m/t5t1I5ppvPUYWKTVRSNYt0D5lphEt6TrVQV4rbEkUkv42YtrY6n7yGN3auXlu09QZsAqCVsdM6Lw3KKVk34uhb8eksLw/le4HOVSo54nUKW9g/r3E0RGFy+f9YurISQkLkkHxBLdxdFzfJsdsxvlVq/Ai+MzQsG2FVS2yG7/qZses/S3ohT5uNF+gLkNjMDt9KM0K6Ky2p4km4ZsKPWk8Kmk+PzrQb0dW1TtjGQ9uwhCiXRr6w9gnhFXOXd3acd9OU18EZZuCDUAlnWSwNbkrlFx7+7PbRO1fTPy03utBhfuzqq6r3SYy4FUu+KW4B9QWHsMYG0AV2dg6ajyXq9hPGvodz7uNwIoT3NtGdEjutNCkm7BiYcKBY2F1HhvvCcGWLxuZH8phQ12JBc91iJf6YO5zB1Wl2nnpsQEtThJ0AlWsDmmttb90t6MMzSElrkJ9DLzdfqiR29x6aBYBFTIepxiP1uC9H4xQrWixKgwxRSMMfR1oTemSgGpgIGjuE8FvU/md/QN8jZvUU0Jx
 vEI0XBDp
 D1OsiYjlc2V+YgQkHYrdUWnclosd5Ap2JUxZtOzMZaFFsX1NayRjmuCab7T+3Rqzd+B9gFfjtDXKgDJe9GZZSj754mPMlH7k8hW+6xhvrVMvzVtku9qlJXpBlW68cNFtyosXcHVwTjqD4e1vqckaFehvT5Y2OBUl6G4t8uTr5wD58DbcFQRYAET3swneJxSvcMz7hufXISWCh7u0FRkLTM/NaSU70qcTZHfpIh9uQcDcL/JbOcjMeZwErifxeWX21DRDw7oOXXthCQ8TUn6OpCWWO7kI4IoJMgMjnFrFaqJ0pxY6+xkHgh87fQ3/pEnH0ofadnggDTX6iqY48u2ZTHyL3K5gud7+e982rESwIfHzTdj27gAeuJPVbucaCCSK/BiiZJ/l/9GJv1NN32cqU5zDOzGkGiMDnB731
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 9, 2026, at 18:43, sashiko-bot@kernel.org wrote:
>=20
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/mm_init: __meminit on memmap_init_page_common() crashes at
>  runtime
> --
>=20
> commit bb3e83c26b241fd60613632a0fd50cc529ce8be7
> Author: Muchun Song <muchun.song@linux.dev>
>=20
> mm/mm_init: factor out common struct page initialization
>=20
> This commit factors out PFN-independent struct page initialization =
into
> memmap_init_page_common() and uses it in both __init_single_page() and
> vmemmap_shared_tail_page().
>=20
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 0129152b74d87..9677698f30d3a 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -602,15 +602,28 @@ static inline void =
vmemmap_optimization_verify_zone(struct page *page)
>> 			page_zone_id(page));
>> }
>>=20
>> -void __meminit __init_single_page(struct page *page, unsigned long =
pfn,
>> -				unsigned long zone, int nid)
>> +/* Initialize PFN-independent fields common to pages in the same =
zone. */
>> +void __meminit memmap_init_page_common(struct page *page,
>> +		enum zone_type zone, int nid)
>> {
>> 	mm_zero_struct_page(page);
>> -	set_page_links(page, zone, nid, pfn);
>> -	init_page_count(page);
>> -	atomic_set(&page->_mapcount, -1);
>> +	set_page_zone(page, zone);
>> +	set_page_node(page, nid);
>> 	page_cpupid_reset_last(page);
>> 	page_kasan_tag_reset(page);
>> +	atomic_set(&page->_mapcount, -1);
>> +#ifdef CONFIG_ZONE_DEVICE
>> +	if (zone =3D=3D ZONE_DEVICE)
>> +		__SetPageReserved(page);
>> +#endif
>> +}
>=20
> [ ... ]
>=20
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 9b80dd7326f7e..fd869617423a3 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -212,12 +212,7 @@ struct page __ref =
*vmemmap_shared_tail_page(unsigned int order, struct zone *zon
>>=20
>> 	for (int i =3D 0; i < PAGE_SIZE / sizeof(struct page); i++) {
>> 		page =3D (struct page *)addr + i;
>> -		mm_zero_struct_page(page);
>> -		atomic_set(&page->_mapcount, -1);
>> -		set_page_node(page, zone_to_nid(zone));
>> -		set_page_zone(page, zone_idx(zone));
>> -		if (zone_is_zone_device(zone))
>> -			__SetPageReserved(page);
>> +		memmap_init_page_common(page, zone_idx(zone), =
zone_to_nid(zone));
>> 		prep_compound_tail(page, NULL, order);
>> 	}
>=20
> [Severity: High]
> Can vmemmap_shared_tail_page() call memmap_init_page_common() after
> .init.text has been freed when CONFIG_MEMORY_HOTPLUG is disabled?

Right. I'll remove __meminit from memmap_init_page_common to fix this.

Thanks.

>=20
> When !CONFIG_MEMORY_HOTPLUG, __meminit expands to __init, placing
> memmap_init_page_common() in .init.text, while __ref on
> vmemmap_shared_tail_page() suppresses the modpost section mismatch =
warning.
> With CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=3Dy (which does not depend =
on
> CONFIG_MEMORY_HOTPLUG), allocating HugeTLB pages at runtime reaches
> vmemmap_optimize_pte() -> folio_vmemmap_shared_tail_page() ->
> vmemmap_shared_tail_page() and executes freed .init.text the first =
time a
> zone's shared tail page for that order is allocated after boot.
>=20
> --=20
> Sashiko AI review =C2=B7 =
https://sashiko.dev/#/patchset/20261109095807.41547-1-songmuchun@bytedance=
.com?part=3D2


