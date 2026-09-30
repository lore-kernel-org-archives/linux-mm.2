Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA956CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 10:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2A7F6B0088; Wed, 30 Sep 2026 06:10:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C027B6B008C; Wed, 30 Sep 2026 06:10:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B19D46B0095; Wed, 30 Sep 2026 06:10:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86DEA6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:10:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 07B8F40730
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:10:11 +0000 (UTC)
X-FDA: 85270008222.13.90655F8
Received: from mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6284BA000E
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:10:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A+9Lx1hl;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790763009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w8TdMHuVObPqzYZTfk2DxdvouGjhEk2R8v52SYa0+5A=;
	b=M/i18dX/1n8ydrRFjRajRdc3XSv3UuI5999RDarNPqXmuWje4O0ByPo3ZwpVHztTuTFpWV
	i5KWNmQfh+M9tBePTpyJ8yoJ/fv0BU/1etA7Bi3j70/0aNlypQ+GnAhDt4ytjydBxLLU81
	rVMBzdot/R2YaMXZBMWU76x7jGskTO0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A+9Lx1hl;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790763009;
	b=WVfMYzUsKhdxs813vaR6HAbk7QqcDFR3zVvHb2OOSzkhOgQW6gScMecEPdkmQpf3rmt8RJ
	OdkpTvQyG+t1yuCUF4nFPXim8GFEKCCYk1pc1Rqnb68cdHOc0VoqglI2B1jpOirH7YgMS8
	e3I1S9NtfCIFrnGkuwYVH7ArAiBDA3o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2chB+6TPhVuRnOZXELhxZytj9BOYBqeVPMdvplCJobM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790763003; v=1; x=1791367803;
 b=A+9Lx1hllhbzQT0VcT76xVSjE63/J/iCHuwgomiIP1JGBQNX+bpmZLL2rdN+38KNTMew03mM
 l8n0gaq+4699FSU5oBbhM3iQEkFbfdOye5D9JJ3wb0pPTLKQEvySj56HTgFuuX85wysCVmBbazy
 t+6HjsWq0gX/oLU7H1YGW9dQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id e1901c4a5a410c4d;
	Wed, 30 Sep 2026 10:10:01 +0000
X-Mizu-Trace-ID: e1901c4a5a410c4d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v3 2/6] mm/sparse-vmemmap: support device DAX in common
 vmemmap path
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260930085329.17337-1-lance.yang@linux.dev>
Date: Wed, 30 Sep 2026 18:09:41 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 maddy@linux.ibm.com,
 rppt@kernel.org,
 akpm@linux-foundation.org,
 david@kernel.org,
 mpe@ellerman.id.au,
 npiggin@gmail.com,
 chleroy@kernel.org,
 ritesh.list@gmail.com,
 sshegde@linux.ibm.com,
 ljs@kernel.org,
 liam@infradead.org,
 vbabka@kernel.org,
 surenb@google.com,
 mhocko@suse.com,
 qi.zheng@linux.dev,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BAD58999-1EDD-4A37-ABA0-DB1BD8AB3453@linux.dev>
References: <20260929053231.66085-3-songmuchun@bytedance.com>
 <20260930085329.17337-1-lance.yang@linux.dev>
To: Lance Yang <lance.yang@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6284BA000E
X-Stat-Signature: fg4gcibyx659qypsg3pzcfwds1jya9qh
X-HE-Tag: 1790763007-5787
X-HE-Meta: U2FsdGVkX18ZiWe3Vwc7vJkByTzf9kcgiORF2VrrEzjGSn+YPgfVN0Xj5qZcnZjCfMCglWmOTiG8YzZp+Kj35KyBv3V6+HGXfD2RRs3+N5y0HQoxnwBJcqGo+zQTzCkMAT4BPUabDx2cMaTJfL/r9CgqptWg21IUymlQXztGmoyBfJXxihqLXvHf2xdQiNhRirN9Nnch69wvEhZMpL9mNUfi/HPa4NSbLunzdCXimNn8JOPJnPizdzie+pylYanG3toSYK53zQpXyubaVJMcFrJV0gvfZ+VABX6SC5gwMihj1nTmsXcV6I0svnSKgsHaRnxGvBKQh19juGy079A3SN4+iv0opobEs6TjBcEEsUzuuP2NDqPvUWy/6eE3/h4a18U8ZxXRBof57OTR8HfV7/RplZdt1tI8OcjIyZNDAIKiFujDpvxA7gT/1YeVeoHSuHEDIURhoe/uBSWorsc7a31bQcHzOWazhF7M8SrURfabt4NI6BDaq1+NZeO1mDkiQKv1Pke0IfkSZVav5v4qNCNQnHCzURi0c50aBKqYZ3WQGRM9+sts09oGtIwuo7xiGrc5sB6VPq3E4Zel714NPQ+FI6DQJIevfYnLW2dJ5wCEGwdn1pGFm4g5/Bh0DCpre/4MhGwtTw+Nlx++MQY5RQ2ULCL2yTI9oE/68MHYr7zrPBqQz8dqzZk9tgCqcWXINbmcBwSMCDei1QUOkTEaVFwYKhgr+v2FFXbCxsHY3RfwHh29QNFlueeztMbkWkRVRQdEeDGx1B7Lvv6qoEhJ3XqkalNsv6ckZbH/Vy+X7kv7vU2PdM05i5v1UGkpit3I9dU35JehOi5fQl/umUZMsE7xCFLkpIOU4fEcz0RkaJ8TJREdZy1LAI6f6+dlrjZ6hlIGPdgK0CXEB9akV4tvmRTQBK4xApqXeD9tuucngjRocarrr7EdJADauLJAjV+C88XoawdQCat+RPNCdLf
 wLJjWbzk
 wOdwCMoeA1+oOFuYIM3HYkgfAJ47t7N1zjXxGzU9refUtsaLwWD7IbRXxelLbmx937ycM2jMr2OLTpKzAJhES12ad4Eah3IxMmPA4+XWgtegrZHBnVzn6PepbdHjEukB4OaKGPzIdNxxLj9NNQRccTeynML7M408pFqWZtcZYxeM/Ukj+8DQsnsJCZZBqICRJcwJFOyniwe2Td0mY/MkOfgkPVWyaCCzEE0Qw08vtbzwbYfoi68Cc2iX9TWkFJhgpMiItP81i+KAMG2SfU1efgkFj5SbhZl6QU0lgrp/3WuiJsRhZ3G1otJeeM1IjjH3wIJm15C1BwPR0T97YMpJ1NglKkUUm6D7V+X9Sjz6pli5eD+dFnnUj1yQBtQp5bOqxtlvP7LKwSbUDilKw9eihwPSSPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 30, 2026, at 16:53, Lance Yang <lance.yang@linux.dev> wrote:
>=20
>=20
> On Tue, Sep 29, 2026 at 01:32:27PM +0800, Muchun Song wrote:
>> The common vmemmap population path cannot yet handle optimized Device =
DAX
>> mappings on its own. It uses pfn_to_zone() to find the shared tail =
page,
>> but Device DAX populates its vmemmap at runtime before the =
ZONE_DEVICE span
>> is initialized.
>>=20
>> Teach the common path to use device_zone() for runtime optimized =
vmemmap
>> population while retaining pfn_to_zone() for early boot. This allows =
the
>> same path to support both early boot mappings and Device DAX.
>>=20
>> The backing PFN supplied by the Device DAX-specific population path =
is no
>> longer used, allowing the redundant lookup and population code to be
>> removed later.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Qi Zheng <qi.zheng@linux.dev>
>> ---
>> v3:
>> - Collect Acked-by from Qi Zheng
>>=20
>> v2:
>> - Expand comments around slab initialization to explain zone lookup =
and
>> page refcounting (suggested by Qi Zheng)
>> ---
>> mm/sparse-vmemmap.c | 64 =
+++++++++++++++++++++++++--------------------
>> 1 file changed, 35 insertions(+), 29 deletions(-)
>>=20
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 8219abc6c3e5..ee4c113ca938 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -237,18 +237,43 @@ static __meminit void =
*vmemmap_alloc_pte(unsigned long pfn, int node,
>> struct page *page;
>> const unsigned int order =3D pfn_to_section_compound_order(pfn);
>>=20
>> - /*
>> -  * Device DAX still relies on vmemmap_populate_compound_pages() for
>> -  * head/first-tail allocation and tail-page reuse.
>> -  */
>> if (!vmemmap_optimizable_pfn(pfn))
>> return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
>>=20
>> - zone =3D pfn_to_zone(pfn, node);
>> + /*
>> +  * Before slab is available, vmemmap optimization is used for early
>> +  * system RAM, whose zone can be determined from the PFN.
>> +  *
>> +  * Once slab is available, only ZONE_DEVICE memory reaches this
>> +  * optimized population path. Its zone span has not been =
initialized
>> +  * while its vmemmap is being populated, so pfn_to_zone() cannot be
>> +  * used. Obtain ZONE_DEVICE directly from the node instead.
>> +  */
>> + zone =3D slab_is_available() ? device_zone(node) : pfn_to_zone(pfn, =
node);
>> page =3D vmemmap_shared_tail_page(order, zone);
>> if (!page)
>> return NULL;
>>=20
>> + /*
>> +  * During early vmemmap population, the shared tail vmemmap backing
>> +  * page is allocated from memblock before its struct page can =
safely
>> +  * participate in page refcounting. Therefore, no reference can be
>> +  * held for each shared PTE mapping, and the mappings must be =
unshared
>> +  * before the vmemmap is depopulated.
>> +  *
>> +  * Once slab is available, the shared backing page is allocated =
from
>> +  * the buddy allocator and can be refcounted. Hold one reference =
for
>> +  * each shared PTE mapping. The architecture vmemmap teardown drops
>> +  * the reference through __free_pages() when removing the mapping,
>> +  * preventing the backing page from being freed while it is shared.
>> +  *
>> +  * The backing page may be shared by enough PTE mappings to exhaust
>> +  * the positive range of its reference count. Stop populating the
>> +  * vmemmap if another reference cannot be acquired.
>> +  */
>> + if (slab_is_available() && !try_get_page(page))
>> + return NULL;
>=20
> BTW, shouldn't __add_pages() undo the earlier sections on a population
> failure? Say the first section is added successfully, but populating =
the
> next one fails, e.g. due to an allocation failure:
>=20
> void *memremap_pages(struct dev_pagemap *pgmap, int nid)
> {
> 	...
> 	const int nr_range =3D pgmap->nr_range;
> 	int error, i;
> 	...
> 	pgmap->nr_range =3D 0;
> 	error =3D 0;
> 	for (i =3D 0; i < nr_range; i++) {
> 		error =3D pagemap_range(pgmap, &params, i, nid);
> 		if (error)
> 			break;
> 		pgmap->nr_range++;
> 	}
>=20
> 	if (i < nr_range) {
> 		memunmap_pages(pgmap);
> 		pgmap->nr_range =3D nr_range;
> 		return ERR_PTR(error);
> 	}
> ...
> }
>=20
> We still need to undo the sections already added in the failed range,
> though ... memunmap_pages() won't touch those, since it only removes
> completed ranges.
>=20
> If the range starts at a section boundary, we'd hit -EEXIST in
> fill_subsection_map() on retry while those subsection bits are still =
set.
>=20
> The old DAX path had this issue too. Could we roll back [start_pfn, =
pfn)
> in __add_pages() as a separate fix? Something like this:
>=20
> ---8<---
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 796af1028ee2..16a0a2c885bc 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -380,6 +380,7 @@ EXPORT_SYMBOL_GPL(pfn_to_online_page);
> int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
> struct mhp_params *params)
> {
> + 	const unsigned long start_pfn =3D pfn;
> 	const unsigned long end_pfn =3D pfn + nr_pages;
> 	unsigned long cur_nr_pages;
> 	int err;
> @@ -417,6 +418,10 @@ int __add_pages(int nid, unsigned long pfn, =
unsigned long nr_pages,
> 			break;
> 		cond_resched();
> }
> +
> + 	/* Roll back the sections added before the failure. */
> + 	if (err && pfn !=3D start_pfn)
> + 		__remove_pages(start_pfn, pfn - start_pfn, altmap, =
params->pgmap);
> 	vmemmap_populate_print_last();
> 	return err;
> }
> --
>=20
> Hope I haven't missed anything :)

Good catch. This is indeed a pre-existing issue, and the old DAX path =
was
affected as well.

Your proposed fix looks correct to me. I would slightly prefer keeping =
the
rollback close to the failure:

            err =3D sparse_add_section(nid, pfn, cur_nr_pages, altmap,
                                     params->pgmap);
            if (err) {
                    __remove_pages(start_pfn, pfn - start_pfn, altmap,
                                   params->pgmap);
                    break;
            }

If the first section fails, this simply calls __remove_pages() with an
empty range, which is a harmless no-op.

Would you mind sending this as a separate bug fix? I will ACK it.

Thanks,
Muchun


