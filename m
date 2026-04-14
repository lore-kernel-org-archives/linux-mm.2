Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1550F531E6
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 02:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06076B0088; Mon, 13 Apr 2026 22:29:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB72D6B008A; Mon, 13 Apr 2026 22:29:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCC806B0092; Mon, 13 Apr 2026 22:29:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE38C6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:29:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C9CB1B7575
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 02:29:20 +0000 (UTC)
X-FDA: 84655579680.25.A36DC1E
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4055F40006
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 02:29:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yd2bGA7z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776133758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V5QX9+pQg1ULyMnKqjfgXchOKAT14re8KJFOLZ7j1Uc=;
	b=Oi3H7wvSM4Ea0tklq5K70ecLyTObfYHMHXVAiDrAcC0Q76mYd/Kq7jG1AEcXcHxYZvpo6c
	nHFgIUL7cJkxsZxwwSPunvx4lTr1c1vLOQdha4/A8EBug1m+Xs5lxTh/XGtnNK0mwl1CAX
	DCzPh2gGR//a1VT1lvRS8NS9rwRWNJQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776133758; a=rsa-sha256;
	cv=none;
	b=OIxPD8TLpxdcrFwpzN8cVCSpAP9dy8lUrLqDSmYoBQvrS+wMG7PIFjMLGb1G3SqMiDQc9x
	vpet8ZnDDlZJM1LnpBy+EjADEZjnv+31OqYT3qpsuVeElV7NGM0kXkVH7ULfjRd8l/KJAB
	4S9rg30gxB9dHY4kbRU0uk9/S2bj5MQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yd2bGA7z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776133755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V5QX9+pQg1ULyMnKqjfgXchOKAT14re8KJFOLZ7j1Uc=;
	b=Yd2bGA7z+vMWx2P0hf+Ov1gl4sMFJg6i7OJVdClj6OGD3ec4EqbxCfQ/5VoLn6XgtOKb83
	nP3kyHV5sscI5E+Q1Vp55uKsfQ9jDr0m5aGN3876Obkur4sGjaZwHTpPHVRVlssBSo/Pqd
	gIRpkEbiM6gSw4IOlo+LHzPtvGNrYiE=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 03/49] mm/sparse: fix vmemmap page accounting for HVOed
 DAX
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <d44ff75a-a1bd-4a28-8e8b-0b008d24d41b@kernel.org>
Date: Tue, 14 Apr 2026 10:28:24 +0800
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
Message-Id: <AF32475C-3782-4EAE-BFF8-10078AC08052@linux.dev>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-4-songmuchun@bytedance.com>
 <d44ff75a-a1bd-4a28-8e8b-0b008d24d41b@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4055F40006
X-Stat-Signature: 8sr6nzqsq6jqcp3exzdz69ecoqafhmuo
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776133758-925167
X-HE-Meta: U2FsdGVkX1+QedQgHtrW4PVDgAORo4gGrVV5JiZsDsFmtbtmgwltt9nMog+MmWd+d3J4dIM4hly9szGZAToYWM20aYvWNu+kcK9Pye0t7ZXWYw6Bmjo9vNgC0XykaV0uQ3Q4wgETDXJCpNM3zxMNCYvW1mSCSj+b3evSLir2cTsrX7GUzwge1FL4w7nlfpbfMfrvi8BrnGl9+cvul92xV7Gq3N1LMQNHYkjT6U2zvSmtL4sjTqsolcyMIB/lW2S0yQRK/2lL1VI6pywb5yNIxua47T1//AsKAZOMMBZJuj0avezz3genw78AQrcx1fpCGXXI+wA0BN3uDzmoHMhBYfgLpQsIJCBXYcp2TqSYfQH2px5+8DShmgqPbqw4DNxqp2Mfq7o5HUqFX6nRX5RU+vHPK3SI9/PwbmLbqItwvlAluAEOZ926ZT48GNaIAswhdvt8358yh6kEzbeQXh5SMv3AkTF62IkSI+8vZdDw36JhElBw/XDe8b8u12/QJPVk0bdJ3ScLN7Yc/lJjWHBK06i8jQqrqGrBuRJAIb+xDKMm+DdwjgAgtjdGbXpOejBwy78V42Mk/PpNHVuS0KqiAnoCPYShxc5ewCQStgm2Dixa3n4F4BH1tOOzG1uR5fTFn85pOo/M7L/r6ox0spUtYOzIfq0hrutxCYpuR26w12NUyTuaxh1n7P9PYRxQSR4E9tBcns1hL8IFAk6z4bzaYTIpnNYKK7T0BtLcKDRO/uSMT/ucegK/DQ7kgHy+vBDu4aD9wDn5+MqVNr9iNJXDb6rGz0FFY3OXSKxaKKh8o8trS5SHglYwAL8cD9mMRnFJ0UbLug+SKQ6vcovxsAH/cmR9QEIx4CRR8QpC+lbcfUmjTwPK0Nbsr6pONlBYvAqTSAtR+I+E0sheksnJ4+0l59nwaE6h36/j2DfpuTfnnqnAEb4ExOZtUqYogCBLBBiNFk7y+AnrYd9aWysyz1c
 OwMg2M70
 5SFMT2/TC0S6fjIn0lbY/vfPlFin38b2V9+ZZMM6LDZ1euq1Y8GsAV2uUrCY12jNOMmm0cUtnUKSq6yWsS+xEdAXqTqmI3PMonyVq2kmRm/XUPFJyVWNls2/T1Z2lgnOhBBygAIF5NXNeFSdYEB6Zm+9TOQr5ztPPVV0+aaRjTrXNiXWBO04IStmK/9VydVDvAJEDrkIasOvce9ti2BgZqJZKBmYrqPpOh8+YoipTfuIjBK7jX0pA9ZW3LQ9H8Cl6hx2bZvCF7oJiJTeun11gb36Y8QN+Pw6ojLfF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 14, 2026, at 02:39, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/5/26 14:51, Muchun Song wrote:
>> When HVO is enabled for DAX, the vmemmap page accounting is wrong =
since
>> it only accounts for non-HVO case.
>>=20
>> Fix the accounting by introducing section_vmemmap_pages() that =
returns
>> the exact number of vmemmap pages needed for the given pfn range.
>=20
> I guess only the accounting in /proc/meminfo is messed up, correct?

No. It is in /proc/vmstat

	cat /proc/vmstat | grep memmap

	nr_memmap_pages 0
	nr_memmap_boot_pages 2097163

>=20
>>=20
>> Fixes: 15995a352474 ("mm: report per-page metadata information")
>=20
> Similarly, please send all fixes out separately.

Will do in next version.

>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> mm/sparse-vmemmap.c | 30 ++++++++++++++++++++++++++----
>> 1 file changed, 26 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 7aa9a97498eb..0ef96b1afbcc 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -724,6 +724,27 @@ static int fill_subsection_map(unsigned long =
pfn, unsigned long nr_pages)
>> return rc;
>> }
>>=20
>> +static int __meminit section_vmemmap_pages(unsigned long pfn, =
unsigned long nr_pages,
>> +    	struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>> +{
>> + 	unsigned int order =3D pgmap ? pgmap->vmemmap_shift : 0;
>> + 	unsigned long pages_per_compound =3D 1L << order;
>> +
>> + 	VM_BUG_ON(!IS_ALIGNED(pfn | nr_pages, min(pages_per_compound, =
PAGES_PER_SECTION)));
>> + 	VM_BUG_ON(pfn_to_section_nr(pfn) !=3D pfn_to_section_nr(pfn + =
nr_pages - 1));
>=20
> No new VM_BUG_ON. Ever. :)
>=20
> VM_WARN_ON_ONCE() is your friend.

Got it.

>=20
>> +
>> + 	if (!vmemmap_can_optimize(altmap, pgmap))
>> + 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), =
PAGE_SIZE);
>> +
>> + 	if (order < PFN_SECTION_SHIFT)
>> + 		return VMEMMAP_RESERVE_NR * nr_pages / =
pages_per_compound;
>> +
>> + 	if (IS_ALIGNED(pfn, pages_per_compound))
>> + 		return VMEMMAP_RESERVE_NR;
>> +
>> + 	return 0;
>> +}
>> +
>> /*
>>  * To deactivate a memory region, there are 3 cases to handle:
>>  *
>> @@ -775,11 +796,12 @@ static void section_deactivate(unsigned long =
pfn, unsigned long nr_pages,
>>  * section_activate() and pfn_valid() .
>>  */
>> 	if (!section_is_early) {
>> - 		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * =
sizeof(struct page), PAGE_SIZE)));
>=20
> That's nice to be factored out in any case.
>=20
> --=20
> Cheers,
>=20
> David



