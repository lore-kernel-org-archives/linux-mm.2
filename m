Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C827CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAD636B008C; Thu, 14 May 2026 04:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A84EE6B0092; Thu, 14 May 2026 04:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C27E6B0093; Thu, 14 May 2026 04:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3916B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:14:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3308F14056A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:14:12 +0000 (UTC)
X-FDA: 84765312744.27.1B80769
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2831E18000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:14:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j3fsDcx7;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778746450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=co+PDVFtUfeY9Azvp0wD3jOOEodjcJ+478dVQU/LkoI=;
	b=qraMwOmc8mkt2yv1k5C7N3jFGLRd1wZqXe8lRB79MyyzN36DIrpI387cM/ABo3NRy7ZNCW
	AZrxoyr/LUSYFRqbu2LerdI1C8C7iNCUCo5YmXhHmnMAnAEvM0kY6+NDdWK8DCSlFXGepb
	JptozDTfPD4Sb7rS8h6XyM7mr0Od3ZQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j3fsDcx7;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778746450; a=rsa-sha256;
	cv=none;
	b=HMlsxZ6+KViK25chmvO09Oh+yG8bt1xfsS2p/FQUAKqVt85oFggP9k11ZABPs2Piv1G4Ns
	szo1SXV8MeOOg07M6jGZvLXPudsclRWuD40SHBvY1ZbdAsBpXiLWCsP5aN8n3FYVu6k/1e
	Wxns5Q4tNTxjTWsG28n1vJpoexgHXAE=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778746447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=co+PDVFtUfeY9Azvp0wD3jOOEodjcJ+478dVQU/LkoI=;
	b=j3fsDcx7/FSW0gAiMjYPF67lTpafzHKsRZrrN1bIwXHyEJPS1uPVvvuH28QY+dfTux6xmh
	7sKJS7p3MQRsLJDf21qNOWrDPiNOnr+7z97BLGVlh257j83+tRLHMFug09EbLrs8pF/H1R
	2Fx+bM7aYiicP20yCmvvUR9rRb8d1pg=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2 01/69] mm/hugetlb: Fix boot panic with CONFIG_DEBUG_VM
 and HVO bootmem pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <agV-8Ng-E0tZ9G5k@localhost.localdomain>
Date: Thu, 14 May 2026 16:13:15 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
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
 Ackerley Tng <ackerleytng@google.com>,
 Frank van der Linden <fvdl@google.com>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D282FD33-5A85-40F0-9B4A-3B4414DE5486@linux.dev>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-2-songmuchun@bytedance.com>
 <agV-8Ng-E0tZ9G5k@localhost.localdomain>
To: Oscar Salvador <osalvador@suse.de>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 98hrtir3ppdzowhaqop3obct5zdtzdwp
X-Rspamd-Queue-Id: 2831E18000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778746449-638809
X-HE-Meta: U2FsdGVkX19nbyfdrVPeKemD7mdHwUGqc2tHh1qUHzl/p9dQ+d2xWAIu3QQG1wRFwYyD0EaOAqz9xRJMFRGytbeUU7XGqrVVEfKEm0+7ncXBCmRhAe9du4LR7slMRZ6ctz4pGCdAh1eMyZFIza/doltehjXmHzAmmt/pN7RqTz6iQFw2n552g5cwrZR/0bnm7NT+eVxmZo5xeXRwGGKTMmVTgvfFKqoCAW7m5ePavf73ThXPS/ADnW4l32pV/+dvpmMtg61oQgl6gAHoCzBmy4E6yyfI8fqBVHQ8PbByK9Iyq17JS57FjooeRD3oJsO0M0uAlws4H5hAuHtkPkDhIk6L4NWLVV5M4PJNHYqDH2fcO3wv4h3OoJEmbZFPax7CKY5ko66dW+QG2Gg/vzS0bhN/D0egTAvrqgBD6Ad1iHw/Sbf3nuHl+tUExnqyN8asdt8ZD5N/HB+WyI0d8ygHY+UKOIvjZw+R8ymtclxiiJpoHRLwC9XbuQJm7GwYr22Vi8P/iXvvXnfFgZux4CUS1AVd8y/XMcvwyIvEDnuCWwTEaZM+1EVpXsvKrMVSyhf9+kQTy6b62fkibCcT+TfQ8/a08xaNmpwF37jWm7rUNHM9VTEFDTCD/LMn7aufOxs9MaqITCpVl5XSut1OVJD93W6xf/VtK2mLb0U9VmAXW9pybNTuzdNWJeOjr1ieqOysgKNALCS1PLf7iglC5yYAPtwVWuqfWgCJc5seQRe/FIVGpKPFhQ0TZ0W6mAqsxNYcCEWNYm97qgYj5SXaKulCJ9luJtdYrZDuQTm7xSHzNj/UYpccrXS7EfPDO/0kAA3mr0ShuAd9klNnmCWrYJZrLmRDNelQkF8nrpVRGecPZJpdfLKQ43NmjE7+/Wj+J8TFeaMtCqO56mCh3kOGeannWKTEUVvVUFUdXAViMy9kf75MwSYbmsTTYpNltrufxvcxVTvkyPtuRW3uzUYYejD
 WLzSRBTy
 As2v3HLHX2TBcZXnXZjtxlyANNLGhPYYwxUyYhzlFag43ByGuqdDBEtN3cjbKYo9h5KbZiUjjhMW0P4gwX7ptB7WN8U7lOWLltwtW8U6LkZ7WnyO1x4iYpvR/5rIe/QWuHKNTBR7TpXQP37pNUYPmVP0Pl3/hzLit8Kt9lt714ZaQseXLh8mx74ZhPNF2u1I4h0NX6GU6Y53uNoQ3mqLABr5+dFw9VJAPSv3fZ+VkSa1PooSTpCZou6wKcjQiDEp2cdeApImtm/HYb1Lf4kg8anpEzGgJSjrOw70RRd/YSCpYCd+VP7qVuyLCezeU2Y8BnY9mHfyMYMR8o7ruv7Kxa3TqCy+ylmOYGnKi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 14, 2026, at 15:51, Oscar Salvador <osalvador@suse.de> wrote:
>=20
> On Wed, May 13, 2026 at 09:04:29PM +0800, Muchun Song wrote:
>> Commit 622026e87c40 ("mm/hugetlb: remove fake head pages") switched
>> HVO to reuse per-zone shared tail pages from zone->vmemmap_tails[].
>>=20
>> Those shared tail pages were initialized in hugetlb_vmemmap_init(), =
but
>> bootmem HugeTLB folios are prepared earlier from =
gather_bootmem_prealloc().
>> With hugetlb_free_vmemmap=3Don, prep_and_add_bootmem_folios() can =
access
>> pageblock flags on bootmem HugeTLB pages whose mirrored tail struct =
pages
>> already point to the shared tail page. On CONFIG_DEBUG_VM kernels,
>> get_pfnblock_bitmap_bitidx() then dereferences the =
still-uninitialized
>> shared tail page and can panic during boot.
>>=20
>> Initialize zone->vmemmap_tails[] from gather_bootmem_prealloc(), =
before
>> bootmem HugeTLB folios are processed, and drop the later =
initialization
>> from hugetlb_vmemmap_init().
>>=20
>> This bug only affects CONFIG_DEBUG_VM kernels, where the relevant
>> assertion is evaluated.
>>=20
>> Fixes: 622026e87c40 ("mm/hugetlb: remove fake head pages")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>=20
> For the correctness of the change
>=20
> Acked-by: Oscar Salvador <osalvador@suse.de>

Thanks.

>=20
> but I have a couple of comments:
>=20
>> ---
>> mm/hugetlb.c         | 19 +++++++++++++++++++
>> mm/hugetlb_vmemmap.c | 17 -----------------
>> 2 files changed, 19 insertions(+), 17 deletions(-)
>>=20
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 31b34ca0f402..d22683ab30a1 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -3382,6 +3382,25 @@ static void __init =
gather_bootmem_prealloc(void)
>> .max_threads =3D num_node_state(N_MEMORY),
>> .numa_aware =3D true,
>> };
>> +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>> + 	struct zone *zone;
>> +
>> + 	for_each_zone(zone) {
>> + 		for (int i =3D 0; i < NR_VMEMMAP_TAILS; i++) {
>> + 			struct page *tail, *p;
>> + 			unsigned int order;
>> +
>> + 			tail =3D zone->vmemmap_tails[i];
>> + 			if (!tail)
>> + 				continue;
>> +
>> + 			order =3D i + VMEMMAP_TAIL_MIN_ORDER;
>> + 			p =3D page_to_virt(tail);
>> + 			for (int j =3D 0; j < PAGE_SIZE / sizeof(struct =
page); j++)
>> + 				init_compound_tail(p + j, NULL, order, =
zone);
>> + 		}
>> + 	}
>=20
> This deserves a comment why do we need to initialize those pages here, =
no need for
> a fat one but a hint, because everybody else looking at this will =
wonder why do not
> have it in hugetlb_vmemmap_init(), as the name suggests.

Make sense.

>=20
>=20
>> +#endif
>>=20
>> 	padata_do_multithreaded(&job);
>> }
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index 4a077d231d3a..62e61af18c9a 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -870,27 +870,10 @@ static const struct ctl_table =
hugetlb_vmemmap_sysctls[] =3D {
>> static int __init hugetlb_vmemmap_init(void)
>=20
> At this point, hugetlb_vmemmap_init only initialites the sysctls for
> each hstate, should the name reflect that better?

A good point. I can add a new cleanup patch.

>=20
> Also, vmemmap_get_tail() still thinks that tail pages are initialized
> here from this comment:

Good catch. I'll fix it.

>=20
> "/*
>   * Only allocate the page, but do not initialize it.
>   *
>   * Any initialization done here will be overwritten by memmap_init().
>   *
>   * hugetlb_vmemmap_init() will take care of initialization after
>   * memmap_init().
>   */"
>=20
> so we might want to adjust that as well, and I am not sure if we have
> more comments in the tree referencing hugetlb_vmemmap_init() as the =
init
> point for those pages that need correction.

Only this one.

>=20
>=20
> Having said that, and this is just a question, we cannot really make
> gather_bootmem_prealloc() also do the initialization of the sysfs =
right?
> I see that hugetlb sysfs gets initialized from hugetlb_init() a few
> calls after, so.. meh.

hugetlb_vmemmap_init() is introduced by me. I want to hide some symbols
from mm/hugetlb_vmemmap.c at that time. So I used late_initcall() for =
that.

>=20
> Anyway, maybe just convert hugetlb_vmemmap_init to =
hugetlb_vmemmap_sysfs_create
> (pick a better name), so it does not look like having two entry points
> for vmemmap init stuff.

This bug fix is a temporary change, the whole zone initialization will
removed later in patch 30. Then, there will be only one place for =
vmemmap init :)

I=E2=80=99m curious about your thoughts on the practice of minimizing =
external
symbols. Personally, I=E2=80=99d prefer to move these initializations =
into
their respective files:

    - hugetlb_sysfs_init();
    - hugetlb_cgroup_file_init();
    - hugetlb_sysctl_init();

Of course, that=E2=80=99s just my personal preference.

Muchun,
Thanks.


>=20
> --=20
> Oscar Salvador
> SUSE Labs



