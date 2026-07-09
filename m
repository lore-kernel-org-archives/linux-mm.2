Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E48D6C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 12:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D772B6B0088; Thu,  9 Jul 2026 08:32:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D00E46B008A; Thu,  9 Jul 2026 08:32:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC8BE6B008C; Thu,  9 Jul 2026 08:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD1D6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:32:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26814887E5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:32:47 +0000 (UTC)
X-FDA: 84969177174.27.29A481E
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id A55AFC0006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:32:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EFRIuEf+;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783600365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qIaNLNm9VuAS2foEnqbP367IvDgYygGITQCqidSdvLo=;
	b=wiuyJNkCTpwC2DFxEG7b4f/75uyYvSZOtRDvu5qsQpiVQ4jhCq1mX2cQ89abEkbBbRMgu/
	c8BP+3mIjfDN8IX33vgrwwhwJugopIraqubm82yTmdhat2nf949DebeC6de2CLuW1fkD50
	S5+oJuKdWy4aoIVP2iS/kzWUW8HRYW8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783600365;
	b=mitT2pbweybls9bymA3589P7kup7d9fw0bTldhCDamXXz4A7OELlJ+lSi0LcPgxFrPletl
	NESf+qbjUopWnInIR3azxpCBpfUumAoTo5yhW1mSZnjUNbSrZQRSBZUQ7Do1Lfy8JiuCCH
	lxSrdq2EGP96QDEpueJ9Yvzz0Zv0CYg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EFRIuEf+;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783600358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qIaNLNm9VuAS2foEnqbP367IvDgYygGITQCqidSdvLo=;
	b=EFRIuEf+dcSQJ16OaGTavldWW10IO15UpndLxGXEf55y6xSwQf3h5ScjCFQAiMcMJ/zxXP
	j/UwrAWlunDwmtH3iVWqRH+SlJQQf9/sBfR+M/RStV6QEKsdPYQSuRJQMwzB6T6bBahgEn
	nxYl+L1yi7h50uuFySIcGu/xZom9VNE=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 04/17] mm/mm_init: skip initializing shared vmemmap tail
 pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ak97z4tryYAGJgb_@kernel.org>
Date: Thu, 9 Jul 2026 20:31:31 +0800
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
Message-Id: <2306829C-A66D-41F2-B5F7-1C164A7FF757@linux.dev>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
 <20260702093821.2740183-5-songmuchun@bytedance.com>
 <ak97z4tryYAGJgb_@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A55AFC0006
X-Stat-Signature: mqoz8w8x1uskgddrcp44gqmbzxofmphm
X-HE-Tag: 1783600363-752087
X-HE-Meta: U2FsdGVkX1/4JgYaU1PyZbqiIhvGMt8BATDPNZQZ2uyqm3btQo6lWTUig5UcLewa+l/88Pitzlcq+nQ8rWdXoaPE/wibn3GbQp0w3hBWYDw5BYW1c+LkeVzApAgzj+w5B69vu43mc39QZTqUvgnT6jSm4OQMoVgOgUGGQt/3sLsw6+iu91bfYdBMBc3+NDcUxwaigdJXyrdoV1AFeqsjUOyeYFdKf9JkVICBsig3wUD/u0g6Nd0jjdhp0reO3F+sbX5UW7ssck+IOPkXSjkomRNzra/MxIAriKnUV9XqIeisEVD48oMR6FHMgicTcaHXLSc7ytZH07f/SfZ9BSniT2bSj7FHfd0TR4T5ELgfWaHY0nb9tpgouYca+zLG58BcsEnATqagG+BqQYo81VG1pdggkbv8eRsSwyfCqYXPTGM2ZtupFVpNxwD3Xx0/ZkcJsqVVrq4ZhkUK9LOxuW9uShcF+2jGXNS+0fiaw3YcZc+B9cMVz0er9a62yfa0sTjovtdWdWA91Mo5ThlQ8u80StipPB1K8hDLs1uCAvzPY7/TYdsbKBEkPyU+FR6Vhq7oz4MjTTNiKkfPWj5pE2KIwFHeVmPTav3YtMAFKpPcIiIolpGZQv+2J5sWw6aiSXBgHlqQCTd923y6GGDrxsRfqdk0rMmgM3Fc7XvEaErv5tTuq0aL5bT5Zd+fJyyuJIYYzvWVbV8poLLCpwViOS+MaVbnQWXYrmCGl2Zy9a9g8KQi0ICC1q6gDD18+Wba/tW8do+JUuAcRcTIBG8LQqLuDBzw+AeRyh4xG3HIn2rxflEDjiX+sUGj2GXu6K6SaiO8poCjG/sJR8+0ghnKxvf2238Zme1AKeEGUaao4ZMS5U3+SovmyvbzhYaZdJy3LQv5j42ZS9WnU/fi88OvU9LGpPxug361yQbGHln4lqdhmK0Oi60Ekj6G0B14Pj7Wo9xLk4QGYmuLEFXMBfkF2kq
 TyWAZ//0
 qmMU6BjVUd4sK2LuPRf6w8WOVev05XZtsNV0Y3vO9z1li5IRNTjVEc7QckXLixh6LrCuNXITd4I5k9GjOgg7yGe9NRDUqqE/Biw4NCQqpguRxJVLMrrlgcNHPleid1tl6eUX4vPIbKiNWaO9oGZHyduhknYRVeGnGScIwjIJBSUTxGCi9uNx7FITXuDiPJ/s1+gd+YgwJ1eFtwuhPnnHO1Nl51g5sogm0uTru+lgnL4FHvriKqQ+hMGgWXK6YFJO8THY5zGFRLelrHpIVKhvDMo+e+I0Cgm6iA/Cjl4IAATzco/cDyxGDhOxyG5/rVoNGQy1dNXg8RzFgQpk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 9, 2026, at 18:45, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> Hi Muchun,

Hi,

>=20
> Below are some preliminary comments, I'm planning to spend more time =
on
> review next week.

Thanks for the early feedback! Looking forward to more review next week.

>=20
> On Thu, Jul 02, 2026 at 05:38:08PM +0800, Muchun Song wrote:
>> memmap_init_range() initializes every struct page in the target =
range.
>> For compound pages with vmemmap optimization, the tail struct pages =
are
>> backed by a shared vmemmap page.
>>=20
>> Initializing those tail struct pages would overwrite the shared
>> vmemmap page contents, so users such as HugeTLB have to open-code
>> follow-up handling to restore the metadata afterwards.
>>=20
>> Use the section's compound page order to detect struct pages that =
fall
>> into the shared tail vmemmap range and skip their initialization in
>> memmap_init_range().  Still initialize the pageblock migratetypes for
>> the skipped range so the surrounding setup remains intact.
>>=20
>> This is a preparatory change for consolidating handling across users =
of
>> vmemmap optimization, and it also avoids redundant initialization of
>> shared tail vmemmap pages during early boot.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> include/linux/mmzone.h |  4 ++++
>> mm/internal.h          | 16 ++++++++++++++++
>> mm/mm_init.c           | 25 +++++++++++++++++++------
>> 3 files changed, 39 insertions(+), 6 deletions(-)
>>=20
>> @@ -673,19 +673,21 @@ static inline void fixup_hashdist(void)
>> static inline void fixup_hashdist(void) {}
>> #endif /* CONFIG_NUMA */
>>=20
>> -#if defined(CONFIG_ZONE_DEVICE) || =
defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
>> static __meminit void pageblock_migratetype_init_range(unsigned long =
pfn,
>> - unsigned long nr_pages, int migratetype, bool atomic)
>> + unsigned long nr_pages, int migratetype, bool isolate, bool atomic)
>=20
> What is isolate parameter for?

I've re-examined the code, and you're right that the isolate parameter =
is technically
redundant for our current use case, as memmap_init_zone_range() passes =
false.

The rationale behind keeping it is future-proofing. The ultimate goal of =
a generic
HVO is to support arbitrary huge pages, not just HugeTLB. I decoupled =
this as a
parameter to prevent potential regressions down the road; if a developer =
leverages
this for other huge page types in the future, they won't inadvertently =
break
things by forgetting to update a hardcoded false in =
init_pageblock_migratetype(),
especially since memmap_init_range() natively accepts an isolate =
parameter.

Of course, we could also just delete this parameter for now and add it =
back later if
needed. I think both approaches work.

Which way are you leaning?

>=20
>> {
>> 	const unsigned long end =3D pfn + nr_pages;
>>=20
>> 	for (pfn =3D pageblock_align(pfn); pfn < end; pfn +=3D =
pageblock_nr_pages) {
>> - 		init_pageblock_migratetype(pfn_to_page(pfn), =
migratetype, false);
>> + 		init_pageblock_migratetype(pfn_to_page(pfn), =
migratetype, isolate);
>> +#ifdef CONFIG_SPARSEMEM
>> 		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
>> +#else
>> + 		if (!atomic && IS_ALIGNED(pfn, MAX_FOLIO_NR_PAGES))
>> +#endif
>=20
> Let's trigger cond_resched() on some defined number of iterations or =
some
> memory size chunk, e.g PAGES_PER_128M or even PAGES_PER_1G.

Yes, that's for the best. I was really struggling to choose a suitable =
macro
for this earlier, but I realized it's a difficult thing to get right. =
I'm leaning
toward selecting PAGES_PER_1G instead.

Muchun,
Thanks.

>=20
>> 			cond_resched();
>> 	}
>> }
>=20
> --=20
> Sincerely yours,
> Mike.



