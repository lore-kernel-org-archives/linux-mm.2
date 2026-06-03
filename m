Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F373CD6E5D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E70876B0088; Tue,  2 Jun 2026 22:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21226B008A; Tue,  2 Jun 2026 22:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10216B008C; Tue,  2 Jun 2026 22:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC8E06B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:53:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 649901C03E8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:53:50 +0000 (UTC)
X-FDA: 84837081420.19.57F85FE
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2A443A0011
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:53:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NxkwUBap;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780455228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXR0DDEnySpzbdiRagAYl7c+e0VnGF+jVNLwTxCwhtQ=;
	b=t7+28ZeAKqgougsqPkR5CAc4NZCa7K704svMYEVt5Iwd9uqCg0S5SC4EPGHxoC0PTj64gs
	3ATHBdemZeCKtRuUDxFJYm43QIt1OvpqAWmrJOmoI5qplF3ungYIRHbOCHH/P+sfDZ+Lzc
	bc5hsFUAN+w0ht+boixpT+n1vRTeZ8s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NxkwUBap;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780455228;
	b=MhMCIH8fk48D6aha2ZYquXUqYGXLkYqZ1oIlZyBQW3Ugad4JV22WCbVIhsPsSUNxXoFWUN
	mlSpRCs3rUjWNxcOH9JXGp66wmqeo5HvhWQ1QrFzIwT5DV6bEDr0ijQozkGUnAmZd2i+pq
	UyOLBE0qYYAs41WlBqQPGJJ7J2HtdcQ=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780455224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXR0DDEnySpzbdiRagAYl7c+e0VnGF+jVNLwTxCwhtQ=;
	b=NxkwUBapuP1ubsUtM+nqUc6e4oSWGPNe4k31tuYXqiMtmjlN0lcSrZnvD3S1gKNAmwVuGH
	BWAVmV+hhsZHg8TnjTJTi7EcLw5Ltoqml4bZKx0imJFPYB0OSlIrf44wgUtDsgUABdYzSL
	2dSD2TNsXlmQsElmo9BS8yvl/dij+d0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 14/19] mm/hugetlb: Free cross-zone bootmem gigantic
 pages after allocation
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <178041489395.457517.12727427621570734471.b4-review@b4>
Date: Wed, 3 Jun 2026 10:53:04 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1ABCD934-CA2C-4541-9B76-32FAEFD398FF@linux.dev>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
 <20260602101039.1867613-15-songmuchun@bytedance.com>
 <178041489395.457517.12727427621570734471.b4-review@b4>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 6i43stogra9ii1uekmsm4fezyetjm8nn
X-Rspamd-Queue-Id: 2A443A0011
X-HE-Tag: 1780455227-127708
X-HE-Meta: U2FsdGVkX1/Ofwwm4PXOwyEGv9dyIqNXxEqCEmoj/g2DZqHtv+ARAPuRKGHlT46yTh6Ve4s5IclKt+bmXhI7wm+fGoYQZtIg3WyCjE9BcKDXpYSMaO24nMRRMx97SW5n6dc95lxWH0VNcP28o/t5fTwb69BwpbQ8ACccEU70PQzlGvAkVf5jpjokP5iOyqzvSGdN3ewvFsasLcq1gmT+RpDwGDadAICh0xwll8Hl77gXlbp7Dir9eWUeAb3PuZ7tGt1br/7VJWWw/5wzokvL32e4yHMUY1+LXNAHQJRuK5xpyU0FA4KcTbE1uyYI6IYzxEtmSvlfMrV071tbA5kRm6qz5Npw+a7/ItTkjW2DWvryeuKQf8JBeCNlp4iVJl3Od8SlXHriFxmSGSvleoNZdJ/mQND8gcywB0vpbbsHSZvxZKaPdD+6oDVSqBNfNuNYVQIwncb5hRp45xAmhK5ynUhTLWiLMXs2c9UN4O6POWTK8i2k8bkJUVoqwlUAe7BSfGA2FwxKkBh/2Lcr5KsCmQeTWD1tl8wdYGnA5eTLAwFXOAieKaBSOsQPvKi6mRpvcKglAnPpcj1SMvW1nVcOOY0MGGbWMIiRVh5LCgA0w/YLDL8tNDTCtS5RatgShCDoxmEhhYXOHIhTOpEAulnjl3nBVra5R5VTZ76U1zquRI5kqRf+w+A3UbwHisPvz/A3TczNSUHbevrrCHWcOtzp/2j/ujmBVmY6RlJaPtGoVwAP0DM2PEqeaYL3tD3rTLnW7s9qpDY2j05U2j7mn/z2jHZed+BpGfLsOk1WWD90yp/pAlUAoInSbrYz19tHO3dI0euNjPwiJHbbS8S+gY1YHPoAZfqHTDQymKkjWLVLThmfXHUX8dMn0+xJpuCTWsbxQX0DyyibgYzARzqPT+Y77GbByx03EK5paKyCjJLi/ll0rtxob41Oea28oqV61SGJSnNL/AZuU2R813OHmPv
 IuSGk4zo
 DsBd8JhL3VBxK8CDBZTAhj5U2Gpi8AvPuXx+PtmUcVrd2orjZntg8R4L4vjAuuxyXue/jIUgFMsCCAzLLgWqTvGLhMoAeWdSBSAZzZg5MHGEX0NmEMAZkWN1lhPJqfrusiQIhE1ZwUO0oDNv28phMT6SK8n4Y4t1p9+5X7G1zgKTbs/Yv10AiWsFKw+xicBTtovm9UPcOQyHewgHWWX8i+QrGHJUXBout3a0myG5eJ9HB5kxGE2vzqaQnyQ/q3kDPJMYbYVZHez88PevHHtdU1/91wBN2Q908x4KEzvfDCNfbfil6NZATkr1u3j/9bNMcimwpLFEYosaD0zpA6sHyhdfTQ7MrJub29HATiPRUmB6uPNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 2, 2026, at 23:41, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Tue, 02 Jun 2026 18:10:34 +0800, Muchun Song =
<songmuchun@bytedance.com> wrote:
>=20
> Hi Muchun,

Hi Mike,

>=20
>>=20
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 5e557c05d80a..218fb1ca45f4 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -3073,22 +3076,38 @@ static bool __init =
alloc_bootmem_huge_page(struct hstate *h, int nid)
>> [ ... skip 26 lines ... ]
>> + 	* pages belonging to the requested node.
>> + 	*/
>> + 	if (WARN_ON_ONCE(nid_request !=3D NUMA_NO_NODE && nid !=3D =
nid_request))
>> + 		list_add(&m->list, &huge_boot_pages[nid_request]);
>> + 	else
>> + 		list_add(&m->list, &huge_boot_pages[nid]);
>=20
> Can we just memblock_free() the page that intersects zones here?

I had previously considered doing this, but then I realized that if we =
free the
allocated cross-zone memory here, memblock is very likely to select the =
exact
same block for the next allocation. This means we'd just end up with =
this
cross-zone memory again, degrading allocation efficiency. Unless there =
is a way
to mark the block so memblock avoids reallocating it, I ultimately chose =
to
defer the release to prevent this issue from happening.

Thanks.

>=20
> Rather than making alloc_bootmem_huge_page() bool (sorry my bad :)) we
> can make it return -ENOMEM when memblock_alloc() fails, 0 if the page =
is
> not usable and 1 (i.e. number of allocated gigantic pages) if =
everything
> is fine.
>=20
> The callers would need a bit of massage, but it still seems simpler to
> me than adding them to the list and then walking that list.
>=20
> --=20
> Sincerely yours,
> Mike.
>=20


