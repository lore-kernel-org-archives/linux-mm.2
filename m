Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E17A6F9937D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264306B008A; Thu, 23 Apr 2026 08:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23AE56B008C; Thu, 23 Apr 2026 08:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178576B0092; Thu, 23 Apr 2026 08:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 058CD6B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:05:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA29A160154
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:05:17 +0000 (UTC)
X-FDA: 84689690274.06.8F66D3D
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf06.hostedemail.com (Postfix) with ESMTP id 234F518000B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:05:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=loE9WOAK;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776945916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r2ijiexG6FD3eVhJKFQEv8cSP6rYZ0EZ6ENNdT32YGY=;
	b=d97HcXtZTk4kXAdKKyMqKhc4VFC0GjxG861SLSgrw83SMeeIzPSHpVJ9TJ3yUTY79rsHno
	8DxUfxzvdZVKu1i7hYodKW2J8hOVT8WlkxyvcaZ8YHws6LLUTJUgqly/DJJsbw4cfejfXH
	JCIRHKQe68Sh95vtOG0pDvNM5gT44iU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=loE9WOAK;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776945916; a=rsa-sha256;
	cv=none;
	b=P4sw9lash1GP9yS7JnWBPlyBvU3BRBeoaWxj0IflWvb8sSFBf/tZw3Qd1HezVoy1ByMZAC
	8R/amwz7XfAewatdQvSnh8qouogQ/ZrWAqAaVUc+d1zA0WI3dzvXK+Nlk8hXwVRjTxnvZg
	HijbfofeDj9ToJKyDzoAqYYaagkdeZY=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776945907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r2ijiexG6FD3eVhJKFQEv8cSP6rYZ0EZ6ENNdT32YGY=;
	b=loE9WOAKvvpSicNxVCnhTWQ4U0StHn5NBmnVSl5HthVRJaAX8DQNdOjl3sOEec+wJmyBYR
	1I3Zw2WfbSOPvDxPo108yOvJgV+wKg5hjlhLbbMfR3YdbIw5ptwEft6Vu75oO/LqQ7QLk6
	GK737O+gWWCesjjYSz+fM9tScT+YnzI=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v5 v5 4/6] mm/sparse-vmemmap: Fix DAX vmemmap accounting
 with optimization
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <1cbae635-a115-4270-bae2-64145d16f936@kernel.org>
Date: Thu, 23 Apr 2026 20:04:21 +0800
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
Message-Id: <1ADE7CE5-F02D-42B2-B7AC-FE0D6E86042D@linux.dev>
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
 <20260423071911.1962859-5-songmuchun@bytedance.com>
 <1cbae635-a115-4270-bae2-64145d16f936@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ihkyrojrw73rh7okuih66xant3up6cci
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 234F518000B
X-HE-Tag: 1776945913-772381
X-HE-Meta: U2FsdGVkX1+zWNZmekIGyuxi9kGkAm5SwSbWGxBvff1qlq7LYBoAQ3rPrQEUfFHWdy7+mNyq7I1sW988QfamAntqPEGBekUbNoQjLCKWSaHweqoQDMU4mYxlrW49bElMhqPGGhgqy1uu3BJO4k62wVt+broA4tANJhQXZCZbEW/Jc3xJHvodGY6X2CMo/QUY8cWAaM0qwQSXCKg7LW+o/ouGYKdY0kQPzO0W6TJvDcgTx5VZEDZIivA/vtrBEj+4YyGcw++6AgojkGX9FWRUy9MXXZpzq0JCHFPvgYOEOGdYP1UOypy6vZsOjaSIKSidDQCh5hz+o4teU0F3vGIAY1bfvCRMYvoVfTs4fR1l2KSMKAQtSJg/raGHQzPQ8X8z4GYCfNuocNi3MUiH6GcfkoWSmexOpDH1I3FIjIw85QZvfd3KrVJ3KZcd+7OWDodTCAQojTMr7mKTIRWBae2oGPnxo2L/OStNY5PqzkJkh59OPmkvuHtW4yN8kIJAfuJphxiyQ/VL5bWmZ8qRTKmfDgD/VmKxulAZeeGk9UW4NfphI0sOKtCyDIU9jzFmzvclMYKUvvLl0kuVoIl7adY2TZ+640grAjcTN4Gb77ydoIdKv3yuppL0PaAZ0Bu8t5G3bWCN/VGFT1cSYnW/glciVUzshgFn2Qn7B20D7d4YZIkjIhmVrWzuSDDUX8U13NZ9bfOhFDEFf6217CFhHCCEVMyhtEFU34OOuIgTzQ7crHTbo28uoXnY3zEf++r+7GdAq3KYnEtGzMwdj57ImT31c4rGi8MpCKKHTmeayTy4GlDAdcp9vVwEaY3sHm6Fao5PmdKhFfxt1gpxc9yfaYEMLvJF5XJTELSLCF5wt8/BlZMpBjN3VsOKD2zGy5tr0ihO954h7/gfcwK0CfrRP75mV7GvVKINXiRf8jxoCdEP9PsnWli7LN90qW03jI6Ig9CUMja1syhCye7KHTygXhi
 EofvfoAA
 fiyyE8AE7iZ4V1UYgsa6+SQs6+0Qra56VGqQvTIVokB/tm4kSqsZgvy5NVxMoNx/X/noRQcom/1RV3UalVV6zWRAYGuC2zdkP29q5AnbhX/UJqG2u/1h4XN4dFOkUmZkSAuz15+IHtmlWWxdCpFJE9ZU+zgaDxq0pKNrczXZ5pzRxkn2ynFi8vMMkBAGvorgpNRjTej4oiJBn8UhlKerECyVn58MwyuatqcQEimf9T0vDnics/NNdLRDkPSkrppXQZiwJPjyXOSSxdNejABLM8h9764Ey0sF8xti6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 23, 2026, at 18:40, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/23/26 09:19, Muchun Song wrote:
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
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> Acked-by: Oscar Salvador <osalvador@suse.de>
>> ---
>> mm/sparse-vmemmap.c | 31 +++++++++++++++++++++++++++----
>> 1 file changed, 27 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 3340f6d30b01..979d71158c9b 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -652,6 +652,28 @@ void offline_mem_sections(unsigned long =
start_pfn, unsigned long end_pfn)
>> }
>> }
>>=20
>> +static int __meminit section_nr_vmemmap_pages(unsigned long pfn, =
unsigned long nr_pages,
>> +	struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>> +{
>> + 	const unsigned int order =3D pgmap ? pgmap->vmemmap_shift : 0;
>> + 	const unsigned long pages_per_compound =3D 1UL << order;
>> +
>> + 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, =
pages_per_compound));
>> + 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
>=20
> Thinking about the PAGES_PER_SECTION, can't we get called for =
sub-sections?

Oh, I see. My apologies=E2=80=94I just remembered why I took the minimum =
of
pages_per_compound and PAGES_PER_SECTION in the previous version v4:
it was specifically to support subsections.

In the last version, when I was addressing your suggestions/questions,
I forgot about this underlying logic and simplified it to two lines.
Of course, that=E2=80=99s on me, not you.

Ah, looks like I need to update the patch to fix this.

Muchun,
Thanks.

>=20
> --=20
> Cheers,
>=20
> David



