Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF7DCFB44C4
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27AEF6B008A; Fri, 24 Apr 2026 03:51:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252AD6B008C; Fri, 24 Apr 2026 03:51:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 142036B0092; Fri, 24 Apr 2026 03:51:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 020326B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:51:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B60991B8BE9
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:51:30 +0000 (UTC)
X-FDA: 84692679540.12.386512E
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf20.hostedemail.com (Postfix) with ESMTP id 97A3B1C000D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:51:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f5sWadWI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777017089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ORSaWnko0V3NhVqidFGTv7S6AWqSkqSLorMuOfpODA=;
	b=qQqSYHG4pPWs8Rbk+dxTkC200JLrYO6dM/i7CDjWpKfXm4mDSA9n5+cr4e1RNutqNiJpBP
	0VgICHoqui5it4YGQVE0boeDMc5xvghinwbYE8pSCqrFAw4/HTAGPcs6C3s0kHnJ1JD4xZ
	S+psa7l2m0XOjFhMKmmzkcKoTngc0qc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f5sWadWI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777017089; a=rsa-sha256;
	cv=none;
	b=yiW3qcznwjydIurT3xb054cOniT2BJOpCmFnuAdl1P5GQbuHfcK6ZJuijEMGCRdFIZWkge
	6ojM+FQAxxXMwhQ7tkYbMxsLw77/+kT1j4eiT2A2R2Ze9udeQIrCDBNg1YDUHQ782YeaCy
	EEskixnwKtI+eVbBCh3IOeMg9uBXg6w=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777017086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ORSaWnko0V3NhVqidFGTv7S6AWqSkqSLorMuOfpODA=;
	b=f5sWadWIcXFWMoPuLXqfAVQq8XtQDNfCfsvXrl+tyhRViG3SQIamnGMCotuewbABJ9cFH4
	PYhz/HibwXyamvirz+mWtj2C3RPJ/RNlVHmjxhhppl13+g7APOW6R5fSkAUQgJxqYQ7tdZ
	DvCm6GbEn5PGd64kYmFnP3vBYTawe0o=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v6 4/7] mm/sparse-vmemmap: Fix DAX vmemmap accounting with
 optimization
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <0fe62163-cdfd-47e4-bc88-df7a69dc5a6d@kernel.org>
Date: Fri, 24 Apr 2026 15:48:44 +0800
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
Message-Id: <5A4644D9-B64E-4AD9-9D9A-B3DAB84CB827@linux.dev>
References: <20260424025547.3806072-1-songmuchun@bytedance.com>
 <20260424025547.3806072-5-songmuchun@bytedance.com>
 <0fe62163-cdfd-47e4-bc88-df7a69dc5a6d@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 97A3B1C000D
X-Stat-Signature: hdntryyt3gu8d7kqag3ojrr5pyt8koz4
X-Rspam-User: 
X-HE-Tag: 1777017088-179106
X-HE-Meta: U2FsdGVkX19fNPXFV1SYKSoPVl5HKP43A+0ESqwFbozwRtxP29N5daysOmhdGZ+T54RS/4V864m2ArNTY8p0bs0Zajt45+9hvSPw0KLttgzVRMNVyVm0NwYZFw7tunpc3H9CEn/pp516GjpTHE1yT4ER3f8siG0eAPEMQXkMVeTbPyJBta7By7HUzj+K5ZDqv+2SUZ4j0WX7LHIjxZ1B4FYQos+XuZCJ9caLaF4NfPLfXj5kiVI5EZi6n74+FBNU6lYb+D7p8qf7TWuaBc2v99+Xr8axqcRwKqf9EHmZScV3uKFcfWmUXagTB43iORvT+9a/x7NPQ8xHKh91yQ3WoKJVCKt4OzWu9XBUr6ryIk9X2PLu4ZBJ/Z/xrVTGKttsEYbW7IVv54cZqSyxJzCk1U9cn2qsfG/OCKhS2sgacSkEYNSdBIif1Uz+idPeL1D9XDwZw/hAOH4tDW9UiFbINrPmiB3gvy+Ydk2Ooit1tuqn5JtRZHFZIiYWROfGEi0sqKB5m5xKKsI04tV2g8h/0mhKhmbpGK+QDVkywKhIGYF2gAYxPGWCzxafJlV+Ny+xDYktU2U3jSIUUskixeKFvf/ttk+0CEq1xUQntVjyi4SOQL5IApql7UOlNsBLV7Kr/ufL9CeyzyziLlwddNxloQqbpFn+xvaN4AfgSN02fdbLHGQv6KrjDyl1fVUp+xzRO6i2KC8CIXUvyks+Rt7m/zDg+yzSlJrEBxRiA/hQZsOQxtMDX7qI4RLomACBJqjNzhu+uNdiW4ogzYGAAwkUarCZZMUcMyaz9F13YNXADpehZj6GRHgxCNW32RA51S2g3uBM96NGJNXYHdChdat8rL+lP/ETs9sXdv4V/IhrUvru1WBQLyvQ5cHootjeBFAywsnI5WqnvL3RUpoH+bv7bqf79G7IV1zKPOHrt258Kl0KNUn1/WLSF5QwD2X+tOyifjXVY+3uuLFyt0uEY7G
 v3N+mBhI
 xQeL4fnvcafrH6lXX82w16F0H0WqW8PPQkmLW+r1s4YPubj4QXlBL8f/sSer1UFW/yC3H0XGh0TKUU6ofkA5IPU2rlFqfJFO+ZQGWZ+f7YBlnXh88exclOXT6bzAe4jM+gutzPqXfH33iFNGHA8ARmBtAP9JXNUPHxJtgEHo0xSFpV5YxQznOfZO2DAu+foRu/V4qTlnGORUU3gXv3v1e13SGUsaCt6Z3X5KCP9X/0+yExqqZ9DtPn9BVnsmS/tNm8kSfCp7t8L2o8uzQlLQQwL9rIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 24, 2026, at 15:33, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/24/26 04:55, Muchun Song wrote:
>> When vmemmap optimization is enabled for DAX, the nr_memmap_pages
>> counter in /proc/vmstat is incorrect. The current code always =
accounts
>> for the full, non-optimized vmemmap size, but vmemmap optimization
>> reduces the actual number of vmemmap pages by reusing tail pages. =
This
>> causes the system to overcount vmemmap usage, leading to inaccurate
>> page statistics in /proc/vmstat.
>>=20
>> Fix this by introducing section_vmemmap_pages(), which returns the =
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
>> mm/sparse-vmemmap.c | 31 +++++++++++++++++++++++++++----
>> 1 file changed, 27 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 3340f6d30b01..2e642c5ff3f2 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -652,6 +652,28 @@ void offline_mem_sections(unsigned long =
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
>> + 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages,
>> +     				    min(pages_per_compound, =
PAGES_PER_SECTION)));
>=20
> FWIW, I though the right thing to do here would be:
>=20
> VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound);
> VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION);
>=20
> I don't really see how PAGES_PER_SECTION make sense given that
> PAGES_PER_SUBSECTION are the smallest granularity we allow =
adding/removing.
>=20
> Also, the "min()" implies that there is a connection between both =
properties,
> but there isn't to that degree.
>=20
> If order =3D=3D 0, then you'd only ever check alignment for ... 1, not
> PAGES_PER_SUBSECTION, which already looks weird.
>=20
> So you really want to check "max(pages_per_compound, =
PAGES_PER_SUBSECTION)", but
> just having two statements is clearer.
>=20
> Or am I getting something very wrong here? :)
>=20

You are absolutely right. I misread it earlier. I mistakenly read
PAGES_PER_SUBSECTION as PAGES_PER_SECTION, which is why I still used
PAGES_PER_SECTION in v5. That was my mistake and obviously not what
you originally meant.

I completely agree with your suggestion to use two statements here,
as it makes the alignment requirements much clearer. I'll fix this in
the next version. Thanks for pointing this out!

Muchun,
Thanks.

>=20
> --=20
> Cheers,
>=20
> David



