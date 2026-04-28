Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B3B6FF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 02:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BA906B008A; Mon, 27 Apr 2026 22:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991726B008C; Mon, 27 Apr 2026 22:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CE926B0092; Mon, 27 Apr 2026 22:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9566B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:22:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49BD91C0572
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:22:33 +0000 (UTC)
X-FDA: 84706365786.06.E448295
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5C0D44000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:22:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DG0Bm5RX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777342951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8WtTpk4C3bWW2J9TtLvfZiG0OAM5aNmX37Zh2TBXyQ=;
	b=NwKteLbcrzUJoNHmlP/uO9fVLT5wOyXmJuVut5h2MU0YKcV4JOUQ5actQNJyk36T3lOPbt
	GYQO9s59j5MI3UpJeDzctXcZxH+thUBPmqmbfk0/eQM/dOFphv6rQ1fuEXEAbAEE9LzgPy
	u6zdF5nolbVCAgNyF7YXRaoL90wRyc0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777342951; a=rsa-sha256;
	cv=none;
	b=c5gsSROjjYyOsIgrNSKR67NcCQedTdFH4PpDxASbS6W6+nObhjTJRhHEOFCvvYBrVZQMtt
	TP+dXY4VW24CbnAzg/P7WiMxVxvibg2CksA9aUPG1LxDXSP1MDuIFBmbI0VeXnanl/JW8f
	9S7hVmVFwxbIFiUi1JpH8lRxkKJXmdA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DG0Bm5RX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777342949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P8WtTpk4C3bWW2J9TtLvfZiG0OAM5aNmX37Zh2TBXyQ=;
	b=DG0Bm5RXG0phliP9NHTpaSQiK2iNYYaMZjv8TQBv0NlXK+ehAEvDcUdk7LHI76DtXY4HnQ
	HAYjVIC+RR/KyTT84e0oVBYM3KSE2+z7RJHoNOxVzmN3xgqRSdR2k6yS0V3a3uvmt0KN7O
	qC7UG0CAXh1M6qThDTOdenB3pKZWZwM=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v7 4/6] mm/sparse-vmemmap: Fix DAX vmemmap accounting with
 optimization
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <09298afa-9a36-4f29-a8e1-d4750c338df2@kernel.org>
Date: Tue, 28 Apr 2026 10:21:47 +0800
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
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C2E99AB4-CC47-4D9F-BF56-F971FD5A3C26@linux.dev>
References: <20260426092640.375967-1-songmuchun@bytedance.com>
 <20260426092640.375967-5-songmuchun@bytedance.com>
 <09298afa-9a36-4f29-a8e1-d4750c338df2@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5C0D44000A
X-Stat-Signature: 3994mgyqytk5s9o3egq1xpfau87xderw
X-Rspam-User: 
X-HE-Tag: 1777342951-627138
X-HE-Meta: U2FsdGVkX19UEYqGlblB0SBWhYG/gfP3HgASx1dQzmgW5Lw/jUdkwMCI2QClGzauxfVnQ7FesseFaoUC7LKZHddaqKn8OwqxRf3lPxHMSiNfZEMYGI8VI9iYpCkKWUxQRnPRCF1awhHy+F8G1xPD6l7fZIlPaaMbN5uKYonANCrkaBLDBERHScggDQblM2Y0tCmkm/XjhqSiq+/aeYAO4auRzmCN6DhTmoVVMWNIpuO00JouuK9vyRpoH0OtZFUPoTVws6kyjS6TZJpv38pX19TvYH/RDx6j0b5OLzex5VrIwLMswWFX2ULsQIorkcj/RHdZwv96uRKxdZhpQ6OlN8P0a9pRCGyAOcyTQ0f0qPX0xbMVD10rlspWVXNeLrdc/FrrLZPVSOH/drPD6m+251v/KEImPqgUhzd9Yw0Tz6BdXbYxkGjPtg9SyMHveqHDfy913agfh3nEyNoZv8qJ7T7k8F23nyTYd8EKvWoLdq1Sgjh56H62B4t8ei7/pS5EhAZfXv/cCWA15mYb/QVoB2xZqBDFKKzTcZNajFL5eobJqkjuuJ33z+hT6tHpzXiE+HEaUUdDv/Qy7k8dVdTMAnmKtCGVRtNwIpAOuZVve5E8R3zatLJpvSZwavO3guhyu/DYpULbkyaD9+iEnHAnpCO2moNZBeR4V7OMCIw1bwq5ip7b3H+TEUY0f1+4pCezNCw1Ew/BFwvVoyWMHT2BmVFPB9xkYh61DasURinIpUtO1VjWDQrHLQc2h9ONyykCFBpmhO/bfRBFIlSyz4T4MY9jKlddiVgy+gU9uD8BNx1ZLxSiOHAoLibRvQgXirkzui2n/iTDlJ3BA7QES24S6YeqWtWzPVY5z41Ig+e/IwNtSCnn8tyXa8LlseIPlw04qsQNAqbPcXdZZ4Wh49E6IHms+bNo7C/jGrge2W1Qnp6jd5CUPC2cJnJoMphyw72fdH/o227nTwo1KBSik4S
 Dcq3nVQ3
 JwC/XhOd79sMZkcRgoVwcyYcOFmz91nhh3tSO6/SBmZ58Vp3XPpMGSuVKWJOOTyfNgJ5vdpC0SRigPCg0S2zsFfeQKFhM5IBJFP7X7XTVJl/zy964TiR9VMqwhvsEtwXrkvnSnsDdcSW1ZooQM7n7HpCCaKlHI1n8r4N4Yp02TQr8FLJHpn8rpqfFV6qkDzNFYaOw986yDX9xlYrC1RveDbjRQYNuheGOnP+JoVbkLFdxPZnONedGNzpjNXz6hW4EEgtXbWjf8kJzYCOlUU8wvZpOQ76VnkGY5+pt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 27, 2026, at 18:17, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/26/26 11:26, Muchun Song wrote:
>> When vmemmap optimization is enabled for DAX, the nr_memmap_pages
>> counter in /proc/vmstat is incorrect. The current code always =
accounts
>> for the full, non-optimized vmemmap size, but vmemmap optimization
>> reduces the actual number of vmemmap pages by reusing tail pages. =
This
>> causes the system to overcount vmemmap usage, leading to inaccurate
>> page statistics in /proc/vmstat.
>>=20
>> Fix this by introducing section_nr_vmemmap_pages(), which returns the =
exact
>> vmemmap page count for a given pfn range based on whether =
optimization
>> is in effect.
>>=20
>> Fixes: 15995a352474 ("mm: report per-page metadata information")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> Acked-by: Oscar Salvador <osalvador@suse.de>
>> ---
>> v6 -> v7:
>> - Refine the alignment assertions in section_nr_vmemmap_pages().
>> ---
>> mm/sparse-vmemmap.c | 34 ++++++++++++++++++++++++++++++----
>> 1 file changed, 30 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 3340f6d30b01..01f448607bad 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -652,6 +652,31 @@ void offline_mem_sections(unsigned long =
start_pfn, unsigned long end_pfn)
>> }
>> }
>>=20
>> +static int __meminit section_nr_vmemmap_pages(unsigned long pfn, =
unsigned long nr_pages,
>> + 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>> +{
>> + 	const unsigned int order =3D pgmap ? pgmap->vmemmap_shift : 0;
>> + 	const unsigned long pages_per_compound =3D 1UL << order;
>> +
>> + 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, =
PAGES_PER_SUBSECTION));
>> +
>> + 	if (!vmemmap_can_optimize(altmap, pgmap))
>> + 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), =
PAGE_SIZE);
>> +
>> + 	if (order < PFN_SECTION_SHIFT) {
>> + 		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, =
pages_per_compound));
>> + 		return VMEMMAP_RESERVE_NR * nr_pages / =
pages_per_compound;
>> + 	}
>> +
>> + 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
>> + 	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
>=20
> I would just have done that at the very top, as this check applies to =
all cases.

My initial reasoning was that the current formula holds for compound =
pages smaller
than the section size, and we only need to impose limits when the page =
size exceeds
it. While the current callers of section_nr_vmemmap_pages() don't pass =
sizes larger
than a section, this will change in the future (see [1]).

I might have been overthinking the future-proofing, which led to this =
specific
implementation. However, I=E2=80=99m inclined to keep it as is for now, =
as I'll be updating
that series [1] soon and it will involve further changes to =
section_nr_vmemmap_pages().
That said, I'd love to hear your thoughts before I proceed.

[1] =
https://lore.kernel.org/linux-mm/20260405125240.2558577-43-songmuchun@byte=
dance.com/


>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

>=20
> --=20
> Cheers,
>=20
> David



