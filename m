Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0152BC5AD5A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 02:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0066B007B; Sun,  9 Aug 2026 22:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771176B008A; Sun,  9 Aug 2026 22:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660B06B008C; Sun,  9 Aug 2026 22:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2485E6B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 22:24:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8FEF6120564
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 02:24:21 +0000 (UTC)
X-FDA: 85083765522.29.52181E8
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1D0D618000C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 02:24:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ILCFU8nT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786328659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ABX3O1pHOpPNXhdDN7NESgAwKT5nM7Ptyk6UPNmiDP0=;
	b=pKpRHPIkbp3XjvcBsai+tn01dANNNLxZU4B76pKOrPqPDF4qqbXn845k+ek+zP4TJHsXLa
	dgi8YWYoHue2qdDIvQsaK7TTSU0732quORebNcb8l4owe3WMcPDCfWzHv1q3t4NN6EbAdx
	3Ein8VVWGio7oiwMsRXQ/s2LiJfOIi8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ILCFU8nT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786328659;
	b=chPjEOEr2zx2zGbwqEzipydtpVEoZ7bIHGDe/RbYHTRQlQjpdnxNjD3/BC82JF1zOtH5RJ
	OYd4LuDBBnzpoMYT7No6gi1j1xldLBlGz0WMbU12PAOCllvw3jHBitFgZCTD4mXHT7vfiv
	xhhVItCabqklBdHuTyRDMgxh6p7eJwI=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786328655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ABX3O1pHOpPNXhdDN7NESgAwKT5nM7Ptyk6UPNmiDP0=;
	b=ILCFU8nT+DUlUTjwXVxPFLSNlOurmhZvUKZN4Lw+5JeiqBoOtBpThpuBUPQGnpdx+RaNPc
	VmC62bKa7Fae4RTFvm4gZ1sy2yquG3e/IjSfwV+VJgiV9IIblW2eH27I22cnh8IR/iWjc8
	ZD+gF/vJODJ+Lup7E5aI57V9NoxJiOQ=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v5] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CANruzcSySUn_gLEh9kxwvatSCn4hizcy6v2BkcMe0Jb=HoUOSw@mail.gmail.com>
Date: Mon, 10 Aug 2026 10:23:54 +0800
Cc: osalvador@suse.de,
 akpm@linux-foundation.org,
 usama.arif@linux.dev,
 shakeel.butt@linux.dev,
 wangkefeng.wang@huawei.com,
 anshuman.khandual@arm.com,
 david@kernel.org,
 surenb@google.com,
 fvdl@google.com,
 gthelen@google.com,
 hannes@cmpxchg.org,
 riel@surriel.com,
 sj@kernel.org,
 vbabka@suse.cz,
 mhocko@suse.com,
 bjackman@google.com,
 zi.yan@sent.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <60440F8D-5EE8-4254-9057-5FAD09B5D1FF@linux.dev>
References: <20260809043250.2917406-1-souravpanda@google.com>
 <E2FFA328-21B3-4E3D-8CB9-5638B4CB545B@linux.dev>
 <CANruzcSySUn_gLEh9kxwvatSCn4hizcy6v2BkcMe0Jb=HoUOSw@mail.gmail.com>
To: Sourav Panda <souravpanda@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1D0D618000C
X-Stat-Signature: hwkozjba6zxuje1qqjmdu9pp88tjgiyw
X-Rspam-User: 
X-HE-Tag: 1786328657-823913
X-HE-Meta: U2FsdGVkX18Wt8UduWhF29ki08lreaRd5pCYD+YbfcLN3cGwh8z86SmDKPbCInsjyEwfZ4qitv0o+5LlwfquZ1P+8zIVg/wRjhDG7VqAJS+yEVQfoyH1Mjn2Fcxdzt+Y/0cCbcXKjpBJMCj4QTuTg85aOoS3SR6ZQ9YWBMB9aX8dBgfzT1p9diFfx4IyVc19+XjaO3YevXRt8zogvwrBuFU/xDq8bo/HkTlKJ3+ISxYkLgVvdePHDPHNc1ipYE7WV4kYw0qmJVQZaH/ZhKmR29GGRznU8QfpW5nidUD5bb883uS4adqBNGQ9ditrGPLTjjd6xBSJ4pfgIISx2wQufGCnfIuf5Kbvcb4qqMLtKvpgnkvQEqIQuO4YhPcr4bNWWqFuoV0PRCJLC3LpYHsvXQc1iSAzS+mevQhpJiAVZE4adwH+/YGdmV7s9ozB/V+5G9F2rSoTqmN0zjoU8AFDM2Lc7xAdBftbfQBXxXBnXNirRMRzE4M3pHgyToIPs+/lKYFvT9+p5wS2tAaV7Y7UEQVasm8HF3YlQfQORPlJL3mGFCqeM3KR2x+ESFpCRxmTzpIAkU2pYUdGR5V34IzfKZy8rsHjgi03NqweZi/ztROPhUb2OUzhoE9pAzcCxjzIMorimiCMkj0djDEVYwdjfLU2ZBUqIPKr3+ixl27vnEysoogyc9dJYgnPPEa5vimcnNH5nqhs+j9gFCRD4UphwKjGIbJbgNV0u9KiZMSUy6qzJJEC/bqu4GnK/HtwNMuuIayTIryR9iYrK0NMPxqjrEbjl3xYb1afT41/euQR+/NbO03qvrIP0VkbSnwnUSV5RBVJ9TlQknTE5ZXGAdhmt3du9C5Bzg2nDPlaVH+TsVaJFVhhDTUrtJal7VJblx6lVpDMP/Grsz6HospUCkeFkcuo/WuU9KNoxdo0Oy7qkTdvUebuGbLS5Z5yhAFBisne8idOQD/0QLi+L8GbSTB
 TMP4qgXU
 LhyxgBedm2rShed9Cjaw+ohyH79fgvRQLljDGsqoAAjMjmZ1v0qP4gAGv/6VGYwyIMADFqAh8/0U4xJhW6RDOUpwYGojp1vxa4xWqap02boZpiMloDn4/u0uB7l0RBJim4ZM6vKEedgru13mYPcoNAD0+9/N57HzBL+B8OtdUtF3+vE3/RaL+JKfzfIVy3siqa2ONSWy3KsoAJjYJLdxuCbGqjZCG67yxrJsRSHu+adl0pIx1yMjSW8Xl9xP4XZ/C0w5XCptSrYfFknIDfhlRgkP87FNiAE/2P//CIx8pbUkL3nG2QX66NFHKKbhFbRE1uAPUiIG6B75ijPI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 10, 2026, at 04:11, Sourav Panda <souravpanda@google.com> =
wrote:
>=20
> On Sat, Aug 8, 2026 at 11:58=E2=80=AFPM Muchun Song =
<muchun.song@linux.dev> wrote:
>>=20
>>=20
>>=20
>>> On Aug 9, 2026, at 12:32, Sourav Panda <souravpanda@google.com> =
wrote:
>>>=20
>>> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
>>> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
>>> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
>>> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
>>> alloc_gigantic_frozen_folio().
>>>=20
>>> Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
>>> allocation on hugetlb_cma[nid] without verifying if nid is included =
in
>>> the caller's nodemask. Adding a node_isset(nid, *nodemask) check =
ensures
>>> the initial preferred node allocation honors the memory policy / =
nodemask.
>>>=20
>>> However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask =
in
>>> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
>>> leading to a null pointer dereference kernel panic when nodemask is =
NULL.
>>>=20
>>> Fix this by checking if nodemask is NULL in
>>> hugetlb_cma_alloc_frozen_folio() and defaulting it to
>>> cpuset_current_mems_allowed (safely read using a seqcount retry =
loop).
>>> This ensures that the initial node check and fallback loop safely =
honor
>>> the task's cpuset without violating cpuset constraints or causing =
NULL
>>> pointer dereferences.
>>>=20
>>> =46rom a userspace perspective, this bug allows an unprivileged user =
to
>>> crash the kernel (trigger a panic) by requesting a gigantic hugepage
>>> allocation with MPOL_PREFERRED_MANY on a system where CMA is only
>>> configured on a subset of NUMA nodes.
>>>=20
>>> This can be reproduced by booting a VM with two NUMA nodes, =
restricting
>>> CMA to Node 1 (e.g., hugetlb_cma=3D1:1G default_hugepagesz=3D1G
>>> hugepagesz=3D1G hugepages=3D0), and running a program that allocates =
a
>>> 1GB hugepage area without reserving, restricts allocation to Node 0
>>> using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
>>>=20
>>> void *ptr =3D mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
>>>                  MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
>>>                  MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
>>> unsigned long nodemask =3D 1; /* Node 0 */
>>> mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
>>>       sizeof(nodemask) * 8, 0);
>>> memset(ptr, 0, 1UL << 30); /* Trigger fault */
>>>=20
>>> This results in a NULL pointer dereference:
>>>=20
>>> BUG: kernel NULL pointer dereference, address: 0000000000000000
>>> #PF: supervisor read access in kernel mode
>>> #PF: error_code(0x0000) - not-present page
>>> Oops: Oops: 0000 [#1] SMP NOPTI
>>> RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
>>> Call Trace:
>>>  <TASK>
>>>  only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
>>>  alloc_surplus_hugetlb_folio+0x6d/0x100
>>>  alloc_hugetlb_folio+0x3c5/0x660
>>>  hugetlb_no_page+0x3d9/0x650
>>>=20
>>> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic =
hugepages")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Sourav Panda <souravpanda@google.com>
>>> ---
>>> Changes in v5:
>>> - Replaced defaulting nodemask to &node_states[N_MEMORY] with safely =
reading
>>> cpuset_current_mems_allowed using a seqcount retry loop, ensuring =
fallback
>>> allocations comply with task hardwall cpusets as suggested by Usama =
Arif.
>>> - v4: =
https://lore.kernel.org/linux-mm/20260726072935.3513996-1-souravpanda@goog=
le.com/
>>> - v3: =
https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@googl=
e.com/
>>> - v2: =
https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@goog=
le.com/
>>> - v1: =
https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@googl=
e.com/
>>>=20
>>> mm/hugetlb_cma.c | 15 ++++++++++++++-
>>> 1 file changed, 14 insertions(+), 1 deletion(-)
>>>=20
>>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
>>> index 39344d6c78d8..3ae9347078e9 100644
>>> --- a/mm/hugetlb_cma.c
>>> +++ b/mm/hugetlb_cma.c
>>> @@ -3,6 +3,7 @@
>>> #include <linux/mm.h>
>>> #include <linux/cma.h>
>>> #include <linux/compiler.h>
>>> +#include <linux/cpuset.h>
>>> #include <linux/mm_inline.h>
>>>=20
>>> #include <asm/page.h>
>>> @@ -30,11 +31,23 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int =
order, gfp_t gfp_mask,
>>>      int node;
>>>      struct folio *folio;
>>>      struct page *page =3D NULL;
>>> +     nodemask_t local_node_mask;
>>>=20
>>>      if (!hugetlb_cma_size)
>>>              return NULL;
>>>=20
>>> -     if (hugetlb_cma[nid])
>>> +     if (!nodemask) {
>>> +             unsigned int cpuset_mems_cookie;
>>> +
>>> +             do {
>>> +                     cpuset_mems_cookie =3D =
read_mems_allowed_begin();
>>> +                     local_node_mask =3D =
cpuset_current_mems_allowed;
>>=20
>> I think it only makes sense to move cma_alloc_frozen_compound() =
inside the
>> loop. Otherwise, during subsequent memory allocations, we could still =
face
>> unexpected allocation failures.
>>=20
>> Muchun,
>> Thanks.
>=20
> Hi Muchun!

Hi,

>=20
> What do you think of the following diff? This way
> cma_alloc_frozen_compound is also protected from stale nodemasks.
>=20
>         if (!hugetlb_cma_size)
>             return NULL;
>=20
>    -    if (hugetlb_cma[nid])
>    +retry_cpuset:
>    +    if (!nodemask) {
>    +        cpuset_mems_cookie =3D read_mems_allowed_begin();
>    +        local_node_mask =3D cpuset_current_mems_allowed;
>    +        nmask =3D &local_node_mask;
>    +    } else {
>    +        nmask =3D nodemask;
>    +    }
>    +
>    +    if (hugetlb_cma[nid] && node_isset(nid, *nmask))
>             page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], =
order);
>=20
>         if (!page && !(gfp_mask & __GFP_THISNODE)) {
>    -        for_each_node_mask(node, *nodemask) {
>    +        for_each_node_mask(node, *nmask) {
>                 if (node =3D=3D nid || !hugetlb_cma[node])
>                     continue;
>=20
>    @@ -48,6 +61,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int
> order, gfp_t gfp_mask,
>             }
>         }
>=20
>    +    if (!page && !nodemask &&
> unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
>    +        goto retry_cpuset;
>    +
>         if (!page)
>             return NULL;

The overall looks good to me. But can we change it to this here?

	if (!page) {
		if (!nodemask &&
		    =
unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
			goto retry_cpuset;
		return NULL;
	}

That way, we can remove the 'if (!page)' check here.

Muchun,
Thanks.

>=20
> If this looks good to you, I'll send out v6 with this change.
>=20
> With regards,
> Sourav Panda
>=20
>>=20
>>> +             } while (read_mems_allowed_retry(cpuset_mems_cookie));
>>> +
>>> +             nodemask =3D &local_node_mask;
>>> +     }
>>> +
>>> +     if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
>>>              page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], =
order);
>>>=20
>>>      if (!page && !(gfp_mask & __GFP_THISNODE)) {
>>> --
>>> 2.55.0



