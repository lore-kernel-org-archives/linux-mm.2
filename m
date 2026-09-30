Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C77CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486416B0088; Wed, 30 Sep 2026 07:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436FB6B0092; Wed, 30 Sep 2026 07:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326B16B0093; Wed, 30 Sep 2026 07:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F24E06B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:12:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7DF4F160772
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:12:02 +0000 (UTC)
X-FDA: 85270164084.26.F8EF943
Received: from mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 434A7180003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:11:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XNkyp1M5;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790766720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w8TdMHuVObPqzYZTfk2DxdvouGjhEk2R8v52SYa0+5A=;
	b=lu55FpNJ4NwxhiXA4kOOQmwq8Y9ATBDxnnY+uPui2YUPtZCxJeyPu4DOVEemIoflBIR69T
	qCw9WAwBv7kFTF1xflXGlpbFwSEHaP+bkHWTaFztqxsp80TE1/6aY7CD0pokVi28SNVS65
	CQ57STnQ1HMRGgOrraxRL8wSFlg/P1U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XNkyp1M5;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790766720;
	b=nG3ep5PtoFMs8laxW4KjCpaiVcVgxX0dNcMeRIez5bVeeqUiAptBxz3cUckl5ZvLnAM/M6
	rmQsnCpx1pyLRpgJGq4EeLYBwhC1gba0aVFyZzXi2krMRrUkpEBEdKUE9NIqnO8SySk5Hz
	NQy1aTJ0p2I5NH65xX0NaAauVsX/Gao=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sQXlo+ttkX3rsFF/+duoz9qqV2dVYCVBWBpWC91yIf8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790766718; v=1; x=1791371518;
 b=XNkyp1M5k18XTsctUQAfN1VTrqKrnLIO4zb+bTWVxNSiLkr3rEid5M42A57KenHF4HMknEMH
 ToE9G7G7q/4jAV/ihpHF06aKsjh54cHlPkW77c8f4v3rDk1wTK6qDrBFFrvguKYZlRaApeMXn6H
 ttuBmGUyq8gX0tocN9OOavzE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 7bc8601425e44f03;
	Wed, 30 Sep 2026 11:11:58 +0000
X-Mizu-Trace-ID: 7bc8601425e44f03
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v3 2/6] mm/sparse-vmemmap: support device DAX in common
 vmemmap path
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260930085329.17337-1-lance.yang@linux.dev>
Date: Wed, 30 Sep 2026 19:11:45 +0800
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
Message-Id: <62E3517E-517D-4C23-A04A-F5BEB0A84C60@linux.dev>
References: <20260929053231.66085-3-songmuchun@bytedance.com>
 <20260930085329.17337-1-lance.yang@linux.dev>
To: Lance Yang <lance.yang@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Stat-Signature: 67rtgej1hfao6we3n4jfybamhrd73ecw
X-Rspamd-Queue-Id: 434A7180003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790766719-248425
X-HE-Meta: U2FsdGVkX1+FENQEgRGN28PDK87SYnB5REn8FuHB61QxUZCggfIDQVHYc6+CK+P1lUN9ioC43WmFmXpkQ35O0ZlXbnOtPJuF0IpCoSHYydRuZWR/0ZNLMNgk6YKx2+eBms4pEpLEvMONExhy0GCRE5fFtZaZ/0nQKcfbz18/mANxdKmrF0WDjTbgFVm6JGhhqkBQoEQYmjWQd69L4jSwfwRWJ/7307qSt5CAMiEo1uEx0qnoHTYU1Z7kOveqLkMhuiMc+FcVu8ApKeQizcPjB/UejRHKUCx/xDlaXQpM2hj3mgydDvXKBd5L88vBDuQ97rPtOHV25g99JpqesQv3knEntSwmFK7cGErNhgAGh89DieRR98mpKkjhDOsxldIxgmqiNDVOkfd3oWjkNQhQbXSTOXbfu2q4WW8hB3KhCgYhHYZs09A/fda6u5n4n0DlWJRuWzihDuYt4P3O+RfNDY6fQ+tp0MnXqr4jLW6wv3abNsQ7CZo2BgW0FohYwv3CrpSgU11Jd54ngmQQSoCsEr+NkBASKMPHZbJYBicK0P9qvBcGs8zk/fNq4FF7NEVt1FX1wGNhl2CqhnZMebXogaQS9gJfIvGRuZT81R66S/7U1gfAYSgjqCGixA+PzTTTC9oJ0dipVAHVTjz742wdhu9c8Sv6L0PXiWoPNXur1sJ1wlZyfBHcdOHup6a8CBmH6Azv+u1R+CPjDet7Vs6/VV0CMv5MFHAm3PFizMDN8BJVwLvqJpuL8BXnCVtQJan8inPliPaUx31z6eGeFE5HfyxQtiOtc7lOOI2zQqvEHq5i2m01QTBIaZG4SwRT4D88ZGC4bZDHvS2JSyQDgHeyWxpfunYEVrhLH0DijHR1D7HNDLoMI2AaOA6zWXyQaFp8RUJhWJYMcJOYODXwB1qk5H3jUF2Tn6mWYURbGq4hp2CMxxkw82ktSSiGMcFIXQpHn+zK3mSNlQgqMGzrjUi
 Dt11t1E+
 TyGYYu0ehT0RNn/Cr4ygmKzdz+GOph72eQunIq+OmQT2N5sqAoKOWrH6JYMx9Ao1gG8xL4xn4UY/8oHEDOwSQMtONhC5J+43yX0aQOhOZjFLA0cjOBf5il7o+7zT0L0lecSXITuMJj21dLmHtBseb+/+dBWQoCwXqLFmKhg6Pcyhi3lGj66bsQZ9Cux7/cD5iR0X0CB1gxSj5OcGWA6tVHY4HBginOP4ww/7BCIXFx6afbJXQ2/llz0S1L8myJ0y0eGV3t8gW9ANLvXCK39sDmpZAo8lgPqgwWIHwLTdTXjYDBUZeHyE4xbTzfcsxMO7zCfHzN4Z3MW4YzjmdZd86qibXzpTRO7fF+nWdTWs2zxQhvN9cMRyMTSRDdnoeX96eSsizbsPTlMOxfX9HW7u3mS5ZLw==
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


