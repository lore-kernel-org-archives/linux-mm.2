Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26DC2F531E7
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 02:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6716B0088; Mon, 13 Apr 2026 22:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83FB36B008A; Mon, 13 Apr 2026 22:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707A46B0092; Mon, 13 Apr 2026 22:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB336B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:34:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D00E413A94F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 02:34:13 +0000 (UTC)
X-FDA: 84655591986.05.C596774
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7F4E4120007
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 02:34:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YMSIsHOb;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776134052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vw6s/HiBgFDsTXtMvscroT4fKbZCyCeW0iTze1OcKV8=;
	b=Lglm8U7CSwbJAACCKm/8V72PZd8FW6qKqSWPTxPh5wC/tcnCPKgxm+mZHK3OocK/7jn3V0
	Nuq8Jq1+KbLubEh9NBilgmfLAAvmAfI7Z4vVT5hgpemg1CiuC5Qc6y9K39Ew0RltHdO0Gc
	rF8rKE7Emy1hg/9im/e50vI1wodo3tA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YMSIsHOb;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776134052; a=rsa-sha256;
	cv=none;
	b=vjAlpN6PSgplOlWFq8Bd7+P+UzKHXlWILYP+KfdngeQVq/0lQ3VX6d2WgRVJuD1Bo3YEu/
	5FA7BWaM/43hqEbFtl7iu9CunSW6jW3CisMVuTI1aZx0SqlOME9v8ePcTn0mHT6NfUdhjf
	pFPqTKOHxZBZO8sRVIPRJ+WMEWOMUH4=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776134048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vw6s/HiBgFDsTXtMvscroT4fKbZCyCeW0iTze1OcKV8=;
	b=YMSIsHObqjSgUKpGmW7VPicOKfXENbGzne3HXT8+8KeT1nH3cFGRtcU90fcbhRJ37dfUUd
	DCkmYS6TlpRbNe3kRUHce9SLxBoEsRBGNMEcjUgoWQfhm//49hI7CoBuBLi+jMnwFj92jV
	cGZXASiaDO0RoydpvGcPc8QexRtGP3Y=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 03/49] mm/sparse: fix vmemmap page accounting for HVOed
 DAX
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <2b51659e-5527-4e15-a0a8-41f30f589d07@kernel.org>
Date: Tue, 14 Apr 2026 10:33:18 +0800
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
Message-Id: <65E94431-F4A3-4C8B-B7B9-2ED3EF431DA7@linux.dev>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-4-songmuchun@bytedance.com>
 <2b51659e-5527-4e15-a0a8-41f30f589d07@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7F4E4120007
X-Stat-Signature: g7sh9w7kqypagujoj6wdr6zihhbttcgp
X-Rspam-User: 
X-HE-Tag: 1776134050-645644
X-HE-Meta: U2FsdGVkX1/Iyfer1njJszBXkNfqqAUDUcmGW+CTO0gSvfJf1us4sLkXA9whWj9rhSqvtqlE5e8axbdGb1Kld1ddqXvdIoXq4MPWAbYRKpvdL9o7bUcCTlOoeQjw+4lG8gV538YOlGWDw0QWGPWSwg4wfQirU4t2M5VDQTClOMCraPYoGiZjvD8gu34yos2WV25t8oGhw/XU6Kb5yvZFeVAH9p19wXxqFcKjg6s8nlRMNshgbRAORNKagXQmqxlm5F1swBNBWe/z7BK6j8XFLmjZYrUmAFV05eV/jYvosk97dvDjVus/oMGyiJipNC2sq5nKbkXzamgKGN1noGZixfF5F/q69FH121hAulnqSgQBdKp99T7pv1Oz4mZxoA0hdy8N0r3dHafsjeCpwpsiMKKYcMjXhs0/I/8XEa41O+cECeSbo6jfjR9cy3Q22s7wI6ocJ98Nehu1/lvVGVB/VRGUHlQ7U50YpYlKAf2aAih4/rFuqGLh3cBKJRA/ZIyzwnCa7Q7JGWMjPKwZ4ZqECvGXKRL6pOQ1FWIrbwcYRatWQ4av2HjEOkxkhRi4eY9Qjz2urp7edI9wTKd3W8rvNXQyMxVevF1XIvpXOOSsHe1D33NDPt5dFjQKGZkkO0p1Kb7TeL86sLEKjA6M1RoScykT+Vg+nMXb/W8YBOA3Gz3rGWVZV6sEKg/w372blXYLq0AHo76DIPCAPZfmpFOiYF0aBbEkPa9IMbIayUy/cblvH+6uJmjRhv9jSPOpfjazkS/pt0XJnM+WRDrJ2NlRsOHDwoVRCdvtZb+ld6Fc1EGjCw4E/TAdntI5S4mdge7cg1/Gmd82IAGNMkQhPz0EDH8F+XxEQmZzkwT284PfcbIhVngpo3WV/0SK5AH7gNXxuxE+/z1FJ22axBryPy9XBK1ix+64/74/Pesmye8D7EvXBr+G2ZuWlDmMkVpzymDUJvfXyOsdPfBGpbK+GNc
 IVpxSnRI
 7Mpt1KX14bB+f7rTGNlZFxG68fOWtwqD3Spvnu7IzRPGYR1IKUB6OnhTJNIe0B7Z4A0KRuOyJ72DFsiLaNtR01mb94mg3AVkbP3+YrBkMJnomh9hPXwbO25aN0LfsmeICsQFkkcnOcRrQYsO1mqgP7FwjeQ4uyuBMmpK4oNYL+ujNQ9IqhYutjfNYMWvoQTk7B1kCg+9VUijxKQV5tSSedQC9/+6NbWZW6UpZVERiST9d/M4UsSFTRvJFo4pngRDm3wDB/KYlMl2h7XACKqRnE4KK6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 14, 2026, at 02:41, David Hildenbrand (Arm) <david@kernel.org> =
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
>>=20
>> Fixes: 15995a352474 ("mm: report per-page metadata information")
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
>=20
> This makes me wonder whether that is really the right place to update
> the counter. Can't we update the counter where we actually =
allocate/free
> the pages, so we don't have to re-calculate that?

The vmemmap pages are allocated via vmemmap_populate(). Different
architectures may implement their own versions of vmemmap_populate()
(though this is relatively rare), leading to the accounting being
scattered across various locations. As for vmemmap_free(), there is
no generic implementation; since each architecture implements its
own version, the accounting would be dispersed across different
architectures, making the implementation appear quite complex.

Thanks,
Muhcun

>=20
> --=20
> Cheers,
>=20
> David



