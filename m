Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CFDB606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VZsqWkki
Received: by kanga.kvack.org (Postfix)
	id 6C1DA6B05BE; Mon,  9 Nov 2026 22:55:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672126B05BF; Mon,  9 Nov 2026 22:55:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5170F6B05C0; Mon,  9 Nov 2026 22:55:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26C3F6B05BE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:55:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 785D41203E5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:55:40 +0000 (UTC)
X-FDA: 85417845240.04.1D0981D
Received: from mta1.migadu.com (out-6.mta1.migadu.com [95.215.58.6])
	by imf13.hostedemail.com (Postfix) with ESMTP id 41A3020004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:55:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VZsqWkki;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.6 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794282938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DzWy6/WNRqeEWa/9epvO5IlQ0oGV8ntkJrwHkR0I+2M=;
	b=vubDlhPPFXcNpgNpyEqnnZwHivbWXBhV41mHewDDoF72LEVwxSMp/7+dM2lKKFPTIk3UMK
	gLovhAtebCcAHmXi8kDXJO9+TACGHYcxYLV+ZeV4pXeWHkfvmpZY19KG8/H87VGGCJpqO2
	tJnMxR/ZVivCC7gAOK2FaYs0LtmCLS0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794282938;
	b=FkfM++03iq1Tkod3Wr5wvCYvYHTXLGNw3e+8nLq3K1wXy8JzCjB1zUoK8P59OxpXNDzweP
	GMbflRkIX5k2Yz5Op1P3TaAKU7jqmH/1OeKAXnjLwkxnLviMy6Rv/ZOvKB3E/uyuZnnmIt
	Tyma0oYyU1RG+v4L37cIXeGeigpnM/E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VZsqWkki;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.6 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1DHEogHVtoCxTluCnUyg4zaFiqVYIq8x+VghISvowBE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794282936; v=1; x=1794887736;
 b=VZsqWkkioxxyYiwUPbs6n8T9AQpdhjVa9A65a9tduQA4r56pxIqQ2hnGkgtf6dcJUAbIblXi
 aWwjXc8TNKcSu9q4bZdnckjlu/CnrK4UAlhxqMVzE3Rt5DjYwp2841O3vsrP6j2l+orH0vJq2u7
 zspH+lhahswDK7pxYlCiYPqA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id a0e095d83234cbec;
	Tue, 10 Nov 2026 03:55:28 +0000
X-Mizu-Trace-ID: a0e095d83234cbec
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 11/11] mm/mm_init: move pageblock migratetype init to
 memmap helpers
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <sashiko-outbox-204845@kernel.org>
Date: Tue, 10 Nov 2026 11:55:13 +0800
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
Message-Id: <B97DC5CB-5A3A-497C-B051-213A1A14411C@linux.dev>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
 <20261109095807.41547-12-songmuchun@bytedance.com>
 <sashiko-outbox-204845@kernel.org>
To: sashiko-reviews@lists.linux.dev
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: wuq6qnayma1cjgdue64b951f8xnk7a68
X-Rspamd-Queue-Id: 41A3020004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794282938-294078
X-HE-Meta: U2FsdGVkX19DVGEi+QpkRMpBu8fOUt2kF4lu6p21z0L5iwrb+g1TEYPvsLUK5Ef9i3/0565nZO1GBcJEqvtI5CH8CFy2ePC3wgm3MW6NwxR/JCY11e6hjBAXwvbT9poTparxeBAOXMhaC95OQSRkji5wSV7dzJ3O5/GQUTO+rjcAa/wqRyjWo82+aQLIgASNla74NiAFeMonisq3Lr3jhee534C4VbB1RJDPieKo+Vx32gjjReVkpKWJy6kLV+mceH+IeSwMDe2W1xo8tZlUR6nF5jClSNiZoj+VqQUJaKAE6LJMuPrviMHRaxWl/kXfpuPDS9lzzlg9DDFtSWgThZE9NjfIFTXTLDkLfaKggYqHKGroa1/qstzeiMYLXc4OLJGCtylAFH07jpsSSOG1HBfY6jrHvSjqmWDy1LcAHCp4Lq82GpzZhjhPeq6gK2Vqw/on/2c2Tx1GS3SY9gsLa59+zNDBaEJhagULaCpXkcwKRgQ44r1mRkQN7hkxrcOevh0SKaO6PD+Z2xFPAojGeef5gG8xIIloiH0CaEBDr5FL2UJ5XmLCOdWQESaKWZ2My8CBr1CHDIz2cZzSrveq3Rk1/7N8HybXXNL8YbRlG9RuXZkbu802zbyhEi5fHnwmQby7eqfMtm5A9DcUODbS6YKcJY0Szov5Ag3o9hy68hi4iB2+3y6JHRCvqIZIT5Nc41qBQkooJ9NKKycZxb/J3NekejT3MaLNHwoGxXJjLpwUKpDhk1u+CXcCXcq2JrK4VpT5JI2hPkmWXNzk3wtKVjDlicSrvFsSSr+LmjkjA2Y7cMxTrSsfkIQVbpvqbUenIrev+NS5jX3f8wlCquu+1MJk6haRh0ajRwTLR+Sv8lfOTEEs8VRw4z78q88fcCdug1dJTTC7bfM6TDt5nqF7EzO9tIjvVjUSCv5UWgsCIfxyjibQlFe+dg85G0AThZw5t27Pzw547pmbuCA8Vmb
 ppckbS4o
 zxEzK5QuqQxXNzIJhOrlEbxC6yEPdJJhOmPRYLrrFR0VsYDfgs3QjYsLMerQVdzhV5gsxkDkQWFJOvhsiJESoRVdqJ8XdPaIq9lnuJ+E2u8St3QTPSw0DJX2pxZqYSZ+l13FQgj/bjfMIVFAJcA8atWgR58XbIx/0b283VCf35lJsJJP5/hr2PeuMOqcuwZkUU4E5f/O+NDgH93ShWtFQ/JDTUf+kgOC6UNDYiv657NEDLnuEqoQAocyqGZRgiYu2vkNeq796IyjSxak9Ztml32uF7VV2k0aeRsi/qtJj84SgwrYmjFtSgkQP8+ZSfvu8OSBOljTh2gjpAiurZ+aoxnrBAe4qWNtR+NpxyUx8lNNr9exxIOC/gtdU4NQ2zsDJuCmcf5oRLiM+wxlomk5lKLOL6c2sazZcHfMP
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
> - [Low] mm/mm_init: commit message cites nonexistent
>  memmap_init_page_frozen()
> It also noticed 1 related pre-existing issue this patch does not
> introduce:
> - [Critical] mm: uninitialized migratetype in
>  pageblock_migratetype_init_range() [1]
> --
>=20
> commit e81bf248ba8e6f6857b5a558e23fdf0fa0e68ad6
> Author: Muchun Song <muchun.song@linux.dev>
>=20
> mm/mm_init: move pageblock migratetype init to memmap helpers
>=20
> This commit moves MIGRATE_MOVABLE pageblock initialization into
> memmap_init_compound_page_frozen() and =
memmap_init_zone_device_basepages(),
> and removes hugetlb_bootmem_init_migratetype().
>=20
>> Move the MIGRATE_MOVABLE pageblock initialization into the frozen =
memmap
>> initialization helpers instead. This makes memmap_init_page_frozen()
>> initialize the pageblock for single pages and
>> memmap_init_compound_page_frozen() initialize the whole range for =
compound
>> pages, so the ZONE_DEVICE and hugetlb bootmem paths can share the =
same
>> initialization.
>=20
> [Severity: Low]
> This isn't a bug, but the commit message mentions a nonexistent
> memmap_init_page_frozen() helper.  The patch updates
> memmap_init_zone_device_basepages() to initialize the pageblock range =
for
> ZONE_DEVICE base pages instead.

My bad. It should be memmap_init_zone_device_basepages().

>=20
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 61a720bb44dce..e05db8abde2fd 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -751,6 +751,9 @@ void __meminit =
memmap_init_compound_page_frozen(struct page *head,
>> 	for (unsigned long i =3D 1; i < nr_pages; i++)
>> 		memmap_init_page_from_template(head + i, pfn + i, zone, =
&template);
>> 	prep_compound_head(head, order);
>> +
>> +	pageblock_migratetype_init_range(pfn, 1UL << order, =
MIGRATE_MOVABLE,
>> +					 /* isolate */ false, /* atomic =
*/ false);
>> }
>>=20
>> struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
>> @@ -1110,6 +1113,9 @@ static void =
memmap_init_zone_device_basepages(unsigned long start, unsigned long
>> 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
>> 			cond_resched();
>> 	}
>> +
>> +	pageblock_migratetype_init_range(start, end - start, =
MIGRATE_MOVABLE,
>> +					 /* isolate */ false, /* atomic =
*/ false);
>> }
>=20
> [Severity: Critical]
> This problem wasn't introduced by this patch, but can
> pageblock_migratetype_init_range() leave the first partial pageblock's
> migratetype uninitialized [1] when the starting PFN is not aligned to
> a pageblock boundary?

The condition is reachable, but it does not appear to cause a functional
problem. The partial pageblock retains its existing migratetype, or
MIGRATE_UNMOVABLE from the zero-initialized bitmap; it does not contain
uninitialized data. ZONE_DEVICE pages do not enter the buddy allocator =
or normal
isolation path, so this does not affect allocation, migration, or =
removal.

Moreover, the pageblock also covers PFNs outside the pgmap range, so =
overwriting
its migratetype could affect adjacent memory. So I'll not fix it.

Thanks.

>=20
> mm/mm_init.c:pageblock_migratetype_init_range() {
>    ...
> 	for (pfn =3D pageblock_align(pfn); pfn < end; pfn +=3D =
pageblock_nr_pages) {
> 		enum migratetype mt =3D kho_bootmem_migratetype(pfn, =
migratetype);
>=20
> 		init_pageblock_migratetype(pfn_to_page(pfn), mt, =
isolate);
>    ...
> }
>=20
> pageblock_align(pfn) rounds the starting PFN upward to the next =
pageblock
> boundary.  When a caller such as ZONE_DEVICE initialization or memory
> hotplug passes a range starting in the middle of a pageblock, the loop
> skips that initial partial pageblock, leaving its pageblock flags
> uninitialized.
>=20
> [1] =
https://sashiko.dev/#/bug/linux-492df7cc-d097-43e5-9701-9954aee1d064
>=20
> --=20
> Sashiko AI review =C2=B7 =
https://sashiko.dev/#/patchset/20261109095807.41547-1-songmuchun@bytedance=
.com?part=3D11


