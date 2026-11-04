Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF65606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hnnV/ht7
Received: by kanga.kvack.org (Postfix)
	id 7231E6B00EF; Wed,  4 Nov 2026 06:15:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4706B05CD; Wed,  4 Nov 2026 06:15:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C59C6B05CE; Wed,  4 Nov 2026 06:15:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 333496B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:15:23 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A52F4A8346
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:15:22 +0000 (UTC)
X-FDA: 85397180484.05.AEEBA1F
Received: from mta0.migadu.com (out-253.mta0.migadu.com [91.218.175.253])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0D242C0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:15:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="hnnV/ht7";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.253 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpEDw5hjXj7841PRbs5dGID3L5ntxvD9VVbE0nNrrAA=;
	b=EOhL/7HGGbVEswQbLIetQPFVSz4XaUweak+gReLxe3EPgjSZ+nHAv3SPU6GR0dbB55H9kv
	GvnvoUgQiUX6YedI4CwdEtz4sjnsu3TlYBCQAPIndxfGpw1UvC6a3JkxAJlb07sOu7GaJ8
	JcwxtQlj7NfMeUyNnGoPZY5/rRhK5Vg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="hnnV/ht7";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.253 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790920;
	b=sfU3XVZXh/EEsQvWt9eOFxvvMcyOygq389kQvSS4iBeLmcjbXYLmt0YnCB/zGn1NY4yc0e
	Ctjkj1SIW3KpYzI7FVjIGbNxJxpZLssNfmtY/W0teQIxlC8Pq7IJpttqAVVteTqDm/QGag
	ce+XA6cuag5SetPqUH+wncBosaoq1hg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sk+qxKHeyasIiOhy5LS3K94shR3FnmgUqi2mNGl6j6U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793790915; v=1; x=1794395715;
 b=hnnV/ht7MPpfuPiYc5OnoYdShepbOj+OHpIWxHZNm38ZqyIjR7Y7uoRJDw2p0V1pyrYPis2U
 sij1bZavn34aUgginERHwZr3snM7PgIfBThHazlAQ22Koa9sO3YOUcSfCWmL9FiRGHQUG0HWPQn
 DOpWSjYWQQaS+MQXaPyFoHjg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 170b41dc14da184d;
	Wed, 04 Nov 2026 11:15:13 +0000
X-Mizu-Trace-ID: 170b41dc14da184d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 04/12] mm: hugetlb_vmemmap: generalize vmemmap page
 allocation
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ausBsbaw9DNVh4KA@localhost.localdomain>
Date: Wed, 4 Nov 2026 19:14:48 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <650347FF-8445-45FD-B1F8-085ED6F997B3@linux.dev>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-5-songmuchun@bytedance.com>
 <ausBsbaw9DNVh4KA@localhost.localdomain>
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0D242C0006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: a1dusuf15unwt16hbxppcmw8iq1moyfp
X-HE-Tag: 1793790919-981121
X-HE-Meta: U2FsdGVkX19vbSvYioWju/HRRFx0T2k3OfGiQT9RGgu7ND7vm5VCV4cb9wsx9auoVllxHecPUXCLosG7BICz0jUMKb/WrLdhDjYkFWpBvi8afRTxCflF7PlPuLoB4mBXk/5qkaQZOmxox7RvL4A/ZtxQebLdoQsSda1IZtSLuKh+VZkHqgbLNLC9jPoVWPnwpXh0OhLydY9qcXLz33AKxmbNe2A0853CtOYUq846JfiuAPIQb5Fmo7weVWxfXluvUdyOyhHi8nCWaRe/6UTl3Fsj35W4DNTauc/GJqCpGnLY5VpGUMgoYonFgMxuRKKBKmnX3sLUEriNWF3gJcWrvjqBWvWCtAn8cYLdqSH045ABZhcwFbBBmvHBMwbRd/4ikMLfbxOUGkNBt4Ei3SKOUl1IoOUZDRbbXJyVwDwXIiywo/s6VPJjmRgvyFLAebuoCup6FyDY8+SU3vcMxx/FTVT2CqScxmM7PZvznNDGKDzDx43rP6tpqnjzCsTZxPFYcccgbR8j2VzSXROrKv+Zp8Asp/HgwJMMtdkmgpdkx5xs16+HRMd/pY1AXP7LL7L2aQ38XrsjlOcRtuPiLW/Aon3tZPEcA0sPwdUrfOR4ve+iTKpsk9BthKh+5XGKbvU5utQz8m7dy/VChPrL1p1kPr9jxy0tzAexmy0950gqyCuuO3uanSmNL6/O9jZK4tSS/7GlxIRHw4we8Ur0C9ZZ8rqdIi7LtIjRCazpX1VCU1h1TfcKK+YZZeh0ITA0gy9oyYvSkBsxQ74jHMlN39AlOPrgISM8C/LKG75sQu7vnM/8+4PmnTrTQtWXnEf6/SHohVqt8I4B2OkOxvYk3mPzoJ+7KB9FhhE1W0kAf3WOLQy/AkBwzVH0K1UjvP4ubJtntRpA3Q77i7XVHEX/Ohy6284zCUwa4MF0Z/xOjQNsI0Jw+LeCgZu4pw7ARBB5P2ej/qpAJQXP2n9wJZlM95g
 gYXJSiqp
 N51vLRf1SkHvt3fAgq3fwmQd6tm3g3Zy5xY1HPG0w6Qe2Yr6MWcsyJ1Fx3Z9Czg34WA3cHgwonW8aXGtevojbyj4u0/Ye1QZEJ1RA1Zfm2VVNJZgoIUpsrPT9GLbvKdd1b8W+L/rMrnB1LKHNKxfTdhaWmqzWl+d/4p4Lx+li/oRtvpcIOLlzsVO4pEXG+ELJ2YyTzbYDPVwxBBqY77FSrr0qlX40R9dl/QG1LjT0KNs9fA7SCxcIZwV2A2GETp5aRZq/2UP7kamxzokutXqZwO85aFM8pgW3hGCRkWwIOVVYaP1KVGGeVg64GSOjpHjNOKVJDi+Wa0B2IAGj+rE03LhDzR+NIPJBu1TFmpyZUb3FEUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 4, 2026, at 17:58, Oscar Salvador (SUSE) <osalvador@kernel.org> =
wrote:
>=20
> On Wed, Nov 04, 2026 at 10:35:02AM +0800, Muchun Song wrote:
>> Vmemmap page allocation is currently tied to restoring a virtual =
range
>> and assumes an empty destination list.  These constraints prevent it =
from
>> being reused when pages are requested independently of a vmemmap =
range or
>> appended to an existing list.
>>=20
>> Generalize the allocator and give it an all-or-nothing list contract =
so
>> the restore and optimization paths can share the same allocation =
policy.
>> This also allows HVO head-page allocation to fail gracefully under =
memory
>> pressure without triggering the OOM killer.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
>=20
> Reviewed-by: Oscar Salvador <osalvador@suse.de>

Thanks for your review.

>=20
> A small nit below:
>=20
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index 0e5b2b182d1b..d3058e106795 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
> ...
>> +static int alloc_vmemmap_page_list(struct list_head *head,
>> +		unsigned int nr_pages, int nid)
>> {
>> -	gfp_t gfp_mask =3D GFP_KERNEL | __GFP_RETRY_MAYFAIL;
>> -	unsigned long nr_pages =3D (end - start) >> PAGE_SHIFT;
>> -	int nid =3D page_to_nid((struct page *)start);
>> +	LIST_HEAD(new_pages);
>> 	struct page *page, *next;
>> -	int i;
>>=20
>> -	for (i =3D 0; i < nr_pages; i++) {
>> -		page =3D alloc_pages_node(nid, gfp_mask, 0);
>> +	for (unsigned int i =3D 0; i < nr_pages; i++) {
>> +		page =3D alloc_pages_node(nid, GFP_KERNEL | =
__GFP_RETRY_MAYFAIL, 0);
>> 		if (!page)
>> -			goto out;
>> -		list_add(&page->lru, list);
>> +		goto free_pages;
>> +		list_add(&page->lru, &new_pages);
>> }
>> +	list_splice(&new_pages, head);
>> 	memmap_pages_add(nr_pages);
>>=20
>> 	return 0;
>> -out:
>> -	list_for_each_entry_safe(page, next, list, lru)
>> +free_pages:
>> +	list_for_each_entry_safe(page, next, &new_pages, lru)
>> 		__free_page(page);
>> 	return -ENOMEM;
>> }
> ...
>> @@ -527,15 +526,13 @@ static int =
__hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>>  */
>> folio_set_hugetlb_vmemmap_optimized(folio);
>>=20
>> -	vmemmap_head =3D alloc_pages_node(nid, GFP_KERNEL, 0);
>> -	if (!vmemmap_head) {
>> +	if (alloc_vmemmap_page_list(vmemmap_pages, =
VMEMMAP_OPTIMIZATION_PAGES, nid)) {
>> 		ret =3D -ENOMEM;
>> 		goto out;
>=20
> alloc_vmemmap_page_list() already gives you the error code (ENOMEM), =
so
> it would look more natural to me to use that already and not =
"overwrite"
> it.
> e.g:=20
>=20
> ret =3D alloc_vmemmap_page_list
> if (ret)
>     goto out;

Agreed, thanks =E2=80=94 I'll just propagate the return value next =
version.

Muchun

>=20
> but as I said, just a nit :-)
>=20
>=20
> --=20
> Oscar Salvador
> SUSE Labs



