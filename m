Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFAAFD3E78C
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 03:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E466B0005; Wed, 10 Dec 2025 22:45:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FF2D6B0007; Wed, 10 Dec 2025 22:45:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 014FC6B0008; Wed, 10 Dec 2025 22:45:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3D1C6B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:45:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7EC34160764
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:45:55 +0000 (UTC)
X-FDA: 84205801470.12.CB76D7F
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 901E24000B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:45:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=seJP1B5p;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765424754; a=rsa-sha256;
	cv=none;
	b=tRwnEINuos6nuJhR48Sh0l3H3AoN+7z69MXDPxU/zAEqvVTnFHy9ZwjXYttbvhmdAFV4p7
	fXH3d9HztpL5LLEUh0PI359vLj7fXczVV/qM3LMkE9u8WZXOEB/j3EstqVFnlYacnnV7ad
	0ZlGzWR/nFUItHALY5kNBsYEwQr76iU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=seJP1B5p;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765424754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4yvkDOUriy9pDXe2tWtamvNl+RZD88OoynPeymFSPnY=;
	b=QuJNbHDuAadUIbiiPWQrgORlHUq912cURTwlpvpCHUa9hsBl2pB6iDbqxMgnGxwiZzgQKK
	2FGRzHhS2LW+AFCrakJV1fFdAlga6KT0ufeQri2SR08HnbAeg3oO4YFp92q5KT+kla/K+M
	eFYet+nZZUOBo6YIT1ppJ9itvjjhz4A=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765424751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4yvkDOUriy9pDXe2tWtamvNl+RZD88OoynPeymFSPnY=;
	b=seJP1B5pfkeqKWBRy1j6/f0UPdqHw7PhRHnZjDpQpl9r4V09X+cEpY6/McB9bgdCQJVVbH
	1vnCKLWkuCk8DBlEkOumALtIwzB/i9HKH6HljMBf3ifLAo7c5R7u39QhZWqr17csgQKKoY
	TqvB6SiNcha6FUXyE2J9xCp4nhsYEPg=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <6396CF70-E10F-4939-8E38-C58BE5BF6F91@linux.dev>
Date: Thu, 11 Dec 2025 11:45:13 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Usama Arif <usamaarif642@gmail.com>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BAF36B4D-0047-48C4-9CB8-C8566722A79B@linux.dev>
References: <20251205194351.1646318-1-kas@kernel.org>
 <4F9E5F2F-4B4D-4CE2-929D-1D12B1DB44F8@linux.dev>
 <m63ub6lxljw7m2mmc3ovbsyfurl7hp4cvx27tmwelcxxrra5m3@eva5tqcdjxtn>
 <6396CF70-E10F-4939-8E38-C58BE5BF6F91@linux.dev>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 901E24000B
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 3iyp5diwqrbf7uyrng78rhkoqmzw8zw1
X-HE-Tag: 1765424753-390736
X-HE-Meta: U2FsdGVkX18fekrH+wU2UzGsoThpyr7Mi3RTgIaI8xZHzxoSIXZ8L1Zi7RuZ7oMzGIWdWN9pbZU9Rq6a53jLt7CGN0oFX579yw3nzr9Pq6RugEVM9D15wDblrk9HdXaN49xb643Rf+Riqc/as2WwkyOR+QvyxrFos/KaaubX+E17KNOt00YIfgzM13tkV1bDehc/XMXf4O7Wh3QLc451SICEj3VJ6Hi0PjtvKVBU9brNyGqbbTQbyqWmzeKwzL1vDURIWB7rGzJWcBiKtsd2x/GrDQBRnbAEJ0IlLcn2YlgJqkbGYnrDzGGSxVwvXWRPHH6xolAYD3LQvviMhylDOyAkHngZ3n4gxWXboYbhmaie1uGWitkcKWU8EnSC3ZtM5ph71oRnSXY3ZZAd+W6D6G102vntR8zSppCBDLycW4P5RGW1CpxA1Hk1qlh9qQNG4DAJL76RjoPYLKpq6tYA9YIz8TMSUy9gv56AWbVIoUcdtdW02eaXY89kz0F0MeBv+Ud8xEFmMbYb2Q3tjXagbpDUH3fv35gd+3oGWcnRLWCFKdntJe4PzK2UHgAQVX7U334FGHZMib+JKpQhgKG7DMAd4fdmPTgeJf37p39Fw3xMCF3BETQRMhoSrl17fulpDNp49XPaVRGWjP+8AnxaYx7DkyED2/GFK0fqoV4P7BqeQuNqs1xS0+i3NX0M2LwLbt2O9DRHRuF3fpcF/iLBk4JGyFLJEDMcnWCAyS/4oE22P1pDIpUw64npMw5itiuIOJlF8ZbsmG8+of1QP2rBRsc7Ujyy1Gsne0Bg7VCyPeXP8gzuDxQ9OiIWaoMB8mcYA6Q6SXJ9vQQ3mXD4A4YNolUAqJiaUyev3kRBWRF/uln2udVyaB47lh+yhXFFRl3XrpnZEawUS57x0jD2vKzm4qj7rt3oW8SO+zLsum8NDYP7+usmJ7ORh+JtBVszRj0Fpc5k9R5MPwaKmylVBXe
 +2+46F+E
 61AjxxBuIqziJowWFv7XlxH2MZ4uYMyPi3CPxhyVpwUGzSm4iXvrehBi2/n6NgU7cKWuOsa4SRZsZ0HXtLZa7JwT57/L/qukixM8P06XEFUqp1cilr5TmYmqm90O00Vr/4UE10D3VcUlG17aY96V2uYlftO+hSFUWfxVW7+sa91B1EceveIG3fsabWcQhPEusmdhRPtrqzBLKoefeymYA9guPsepVGtyS1lObbRwHExKpXvG4NwChK6TVrMgJ2OmAoSQV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 10, 2025, at 11:39, Muchun Song <muchun.song@linux.dev> wrote:
>=20
>> On Dec 9, 2025, at 22:44, Kiryl Shutsemau <kas@kernel.org> wrote:
>>=20
>> On Tue, Dec 09, 2025 at 02:22:28PM +0800, Muchun Song wrote:
>>> The prerequisite is that the starting address of vmemmap must be =
aligned to
>>> 16MB boundaries (for 1GB huge pages). Right? We should add some =
checks
>>> somewhere to guarantee this (not compile time but at runtime like =
for KASLR).
>>=20
>> I have hard time finding the right spot to put the check.
>>=20
>> I considered something like the patch below, but it is probably too =
late
>> if we boot preallocating huge pages.
>>=20
>> I will dig more later, but if you have any suggestions, I would
>> appreciate.
>=20
> If you opt to record the mask information, then even when HVO is
> disabled compound_head will still compute the head-page address
> by means of the mask. Consequently this constraint must hold for
> **every** compound page. =20
>=20
> Therefore adding your code in hugetlb_vmemmap.c is not appropriate:
> that file only turns HVO off, yet the calculation remains broken
> for all other large compound pages.
>=20
> =46rom MAX_FOLIO_ORDER we know that folio_alloc_gigantic() can =
allocate
> at most 16 GB of physically contiguous memory. We must therefore
> guarantee that the vmemmap area starts on an address aligned to at
> least 256 MB.
>=20
> When KASLR is disabled the vmemmap base is normally fixed by a
> macro, so the check can be done at compile time; when KASLR is enabled
> we have to ensure that the randomly chosen offset is a multiple
> of 256 MB. These two spots are, in my view, the places that need
> to be changed.
>=20
> Moreover, this approach requires the virtual addresses of struct
> page (possibly spanning sections) to be contiguous, so the method is
> valid **only** under CONFIG_SPARSEMEM_VMEMMAP.

This is no longer an issue, because with nth_page removed (I only
just found out), a folio can no longer span multiple sections even
when !CONFIG_SPARSEMEM_VMEMMAP.

>=20
> Also, when I skimmed through the overall patch yesterday, one detail
> caught my eye: the shared tail page is **not** "per hstate"; it is
> "per hstate, per zone, per node", because the zone and node
> information is encoded in the tail page=E2=80=99s flags field. We =
should make
> sure both page_to_nid() and page_zone() work properly.
>=20
> Muchun,
> Thanks.
>=20
>>=20
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index 04a211a146a0..971558184587 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -886,6 +886,14 @@ static int __init hugetlb_vmemmap_init(void)
>> BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
>>=20
>> 	for_each_hstate(h) {
>> +  		unsigned long size =3D huge_page_size(h) / sizeof(struct =
page);
>> +
>> +  		/* vmemmap is expected to be naturally aligned to page =
size */
>> +  		if (WARN_ON_ONCE(!IS_ALIGNED((unsigned long)vmemmap, =
size))) {
>> +  			vmemmap_optimize_enabled =3D false;
>> +  			continue;
>> +  		}
>> +
>> 		if (hugetlb_vmemmap_optimizable(h)) {
>> 			register_sysctl_init("vm", =
hugetlb_vmemmap_sysctls);
>> 			break;
>> --=20
>> Kiryl Shutsemau / Kirill A. Shutemov



