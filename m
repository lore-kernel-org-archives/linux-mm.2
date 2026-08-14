Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41069C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 10:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122CA6B0308; Fri, 14 Aug 2026 06:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3D56B0309; Fri, 14 Aug 2026 06:48:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2BA16B030A; Fri, 14 Aug 2026 06:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D22776B0308
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:48:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73EF914041E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:48:32 +0000 (UTC)
X-FDA: 85099551264.22.43C0C68
Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3E100160003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:48:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a2xK+vrl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.68 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786704510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoVCbZGbuMiZ+tCeIPIM66YHmSmt2qbD4ur8OmOKPcw=;
	b=hzD54qdmioOXb/Jkjb2xtSXbl1gpgeJOD0SV9GO1KbHyjZuExoYRHwNqIkg+bCKHB2/JKe
	9tqfx4MWevKdJ2TXrmqgz/NN2TYy5tMCsDZ+7NX7KAijfVo7Rkzwy/ubG9Falfiy9tJ7pL
	VFXH0ouT1iOb44vZHowP2V1hF8IQrOo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a2xK+vrl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.68 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786704510;
	b=zmk5Iob+7D5wOuzzxj85IUXYG7opAFnX3oNSL3ojHOFT7eOzfPNd/Fe4vHkqYE6ypMyC3p
	KePa93fxotDARP+35qxGpWvmO+PlizGTtb7mCUnToIcE4nlGCTFxBN/9tUInF0qfOo+UI5
	H8RCeEHLvF+CTQj2BYPTyMZBVGUxQS0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1HqmXyGIYCOs3rLYM6mQfaT9V9V/gD99mJ6fGYBQcYY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786704508; v=1; x=1787309308;
 b=a2xK+vrliUD3IQLW6W0fAhb/OGvaRiQe4OHYb6qyig0CniH6D9ltEZ4JH1/BkutctC8zSzje
 Ig4CvKuoGPvB/nLTqxwmyioC/imY5QZlc4haDOtrMGYfwzpPwXfOoBXnRKxNvOQ+Grohyfz23LW
 MrzBYOvMkkY6//nYzIaikEts=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id a74bc2444d3c3b30;
	Fri, 14 Aug 2026 10:48:28 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Aug 2026 11:48:26 +0100
Message-Id: <DKOLVZ1JCVHL.1Q3926NV045GD@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <x86@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Andy Lutomirski"
 <luto@kernel.org>, "David Kaplan" <david.kaplan@amd.com>, "Thomas Gleixner"
 <tglx@kernel.org>, "Patrick Bellasi" <derkling@google.com>, "Reiji
 Watanabe" <reijiw@google.com>, "Sean Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 13/26] mm: introduce freetype_t
From: "Brendan Jackman" <brendan.jackman@linux.dev>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-13-6f5729aa9832@google.com>
 <anJvFVPmdpURs2B9@google.com>
In-Reply-To: <anJvFVPmdpURs2B9@google.com>
X-Rspam-User: 
X-Stat-Signature: 6cr1bnuqnkfpc38pmpsj35tdhytgs8ha
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3E100160003
X-HE-Tag: 1786704510-710306
X-HE-Meta: U2FsdGVkX188Bet5jlQF6Cgv6ZoGt8ETzD3TOnfaa4gDsmok4a5f3gxzLgofoe32KqcVAxSwPFL09XSVe8bu6gbuuqSnwP1KKCv4mxXdrKkSyz7fksRPf96+khMAp0kD683Xs6GgmpEEM2DwZa29lSjGrJNl+akoZvmxiAFoMeEGUn3M9LZVbvUQb+rhl7MZhgTAIdG22UVKkkhyNdH8hRc1LT+8LJAcay1PY9DQl3crkft9NV1kflZ3PJnvoOaTwb8beEjKI5rc/zRrDP+Ol7ItawucXWF16p1Da5gcXMyVd24RvKm7FRulyyP408+0DAXtZtvmDq5LknAPWiJVwVXrTBVgLwwqDIf0YEz3Czb52lt6qED/FX8elzhE9UnNOTEPD0yeS5G7f3XSX/VbUsbi+7gv2FtZWo9+46z45vtHLdxeDO3MzOvCNFUmtMWXsR0r3uPnwTjyEMbuU93hvPBrHUBGGe8Qq5kdFKCHbvufNT8WCPHvx8zc9gC6ywNmfkc5g7qr13fodFf28AS8H7+qrvF8IQH0pjHtpTuH38RqLxowakJFqld4fNUdom08CAFGbCubDZ6uEz8c2Rqk1hC9/Z16Q+6NuTde+32Jk+SW/2FykqTqzWw4zjiaRyeyDIxULerLWMEzOc882ds2bguasEbM1fTBLxdGmgdQJRFPLNyYzXhf8nq/sIwnzJIg2RcVdBAFzWy2YW5plOiS0UppTKfJhbExyGn9f9MVAVgNzQB+j9w2lUrwQE07ICb+mTEg9PX5HtGkLg+S7i32wGTMXRBTTYL7u5imwJjIKPHYg3fkornbTZHWFfw8Cx/k8Q969Wj2xWpudfeqJjSNigfBRhqbYbVoO7g2Dkf7MAYki5SFHxOfJJ/PhSfJtl7DYuH5jrMHlO+iHF3I6ZRI9mcWpgZJ6KAz5xMJd/iNNyiocGUVA2RxixBqPSHxRGZWg2tO6OqQD3gahY3TRW9
 LAmtPRkE
 BAj9Zu9bf73No9TXnyzQz+Ue5LVx9rGPtEiUpHqzrT7NDTuXDzK4MIReUtfxXutJ+CbhNFwOed/Qwu48ehayfDARKJTkXXjuDCyenyBZCTnrZ11cQrUoONRySQs0x4kwr/vAjsbx9HADI7u8ePOZa9RUu26zvTOsi5uM19AcR6Aje8Uo98JZKwcVf+zZalJKYZHCiS3WNLWRBsfRz1Yo0dMH/WLpSjnyEA8PQUcdfKVZu6rliH051+U4FKfzx3RngK+3DkdhKSPR2LAUdDvMG1bsvuWwEhSzeD6AOVZ0ZmUX4I/aMCLavsFE/3gCZU1x9Vh//+FCSmzVunpGuJlzSugAzXKP4pDTxxB63POEJGWqVW6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 5, 2026 at 12:02 AM BST, Yosry Ahmed wrote:
>> @@ -3190,9 +3272,9 @@ EXPORT_SYMBOL_GPL(split_page);
>>  int __isolate_free_page(struct page *page, unsigned int order)
>>  {
>>  	struct zone *zone =3D page_zone(page);
>> -	int mt =3D get_pageblock_migratetype(page);
>> +	freetype_t ft =3D get_pageblock_freetype(page);
>> =20
>> -	if (!is_migrate_isolate(mt)) {
>> +	if (!is_migrate_isolate(free_to_migratetype(ft))) {
>>  		unsigned long watermark;
>>  		/*
>>  		 * Obey watermarks as if the page was being allocated. We can
>> @@ -3205,7 +3287,7 @@ int __isolate_free_page(struct page *page, unsigne=
d int order)
>>  			return 0;
>>  	}
>> =20
>> -	del_page_from_free_list(page, zone, order, mt);
>> +	del_page_from_free_list(page, zone, order, ft);
>> =20
>>  	/*
>>  	 * Set the pageblock if the isolated page is at least half of a
>> @@ -3214,14 +3296,16 @@ int __isolate_free_page(struct page *page, unsig=
ned int order)
>>  	if (order >=3D pageblock_order - 1) {
>>  		struct page *endpage =3D page + (1 << order) - 1;
>>  		for (; page < endpage; page +=3D pageblock_nr_pages) {
>> -			int mt =3D get_pageblock_migratetype(page);
>> +			freetype_t old_ft =3D get_pageblock_freetype(page);
>> +			freetype_t new_ft =3D freetype_with_migrate(old_ft,
>> +				MIGRATE_MOVABLE);
>> +
>>  			/*
>>  			 * Only change normal pageblocks (i.e., they can merge
>>  			 * with others)
>>  			 */
>> -			if (migratetype_is_mergeable(mt))
>> -				move_freepages_block(zone, page, mt,
>> -						     MIGRATE_MOVABLE);
>> +			if (migratetype_is_mergeable(free_to_migratetype(ft)))
>> +				move_freepages_block(zone, page, old_ft, new_ft);
>
> While poking at the code with AI, it pointed out that new_ft here may be
> an invalid freetype (e.g. unmapped movable). I don't think anything in
> move_freepages_block() or its callees checks against this. There may not
> be an actual code path that would lead to this,=20

Yeah I think the bug is impossible in practice because of the
freetype-flags(a) =3D=3D freetype_flags(b) in can_merge_freetypes()...

> but it's very subtle.

... but yeah. Also there will be other bugs in this form (failure to
handle a no-freelist freetype), I have had several of them already while
developing these patches. I have specifically asked AI to look for them
and it didn't find this one. (Well, it's actually also quite likely
it did but I didn't read it properly or something).

> We can add a check to can_merge_freetypes() (introduced in later
> patches) to check for invalid types.
>
> But I think we may actually want a check in prep_move_freepages_block(),
> which is called by move_freepages_block() and others before moving a
> pageblock. WDYT?

Yeah I think that's the answer, we just have to put those checks in the
right places.=20

FWIW my original nerd instinct here was to create some freelist
abstraction that makes the problem go away by making "no freelist of
that type" look just like an empty freelist. But aside from being more
galaxy-brained code to review, that doesn't work here at all:
move_to_free_list() targeting a nonexistent freetype is inherently a
bug.

