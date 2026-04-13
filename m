Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C01B1F34C49
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 14:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A975A6B008A; Mon, 13 Apr 2026 10:06:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6EDA6B0092; Mon, 13 Apr 2026 10:06:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB536B0093; Mon, 13 Apr 2026 10:06:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89E106B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:06:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37D9F1601EE
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:06:16 +0000 (UTC)
X-FDA: 84653707152.09.7E21345
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 58FA440016
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:06:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K0xst7Ry;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776089174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUfrQZBP/ZyxZwE2DiN7BB9ru8IXfCgKr+W6yEpjREU=;
	b=V206n/veHKiVaXwBYKHmAzKB8R/H2hC54A7Nh175cXdoxdacHxsitgpsnEKK1QAGLFe09U
	Ym6orhi4Ai/PDv1AChLK7q1q2LgzUNiARTFlUo9B4mwBO9W5je+AjLBoKchxFx+8J0WheH
	tzoU1R5KIzny4u/IBC+bNje/Lm8Pt6M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K0xst7Ry;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776089174; a=rsa-sha256;
	cv=none;
	b=cP+NDB20A3JaV8wVfLkzBminCFeMyk/o7xGLecfN3d1hEKPrqgtckXoFlkBLPY1OoMW4ZH
	W9W174MjgcE8Reb2qItz9TFSr58YaFK5iT5AnyzWz82Ns5uYCjMPJS8VMDfgr0ziRby1Y6
	34mYRo0Nh7ulVyxnzZY5Jup1rPk9lQQ=
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776089168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LUfrQZBP/ZyxZwE2DiN7BB9ru8IXfCgKr+W6yEpjREU=;
	b=K0xst7RydEesK7u/I0oErZaYxbMcx5zzyAsnS8H6GKxD9Ov5nuyoHtuE9XB5fGt4bZHMD0
	p2LcX5tCqoEK0KvpClSKLPtcK+QYnapEe/SKzlBMfyIDgptXBNEvufSuDbVkGcOjB3oEau
	nqdpsWfAeywtCPt8EBRTdgheme5+qTI=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 01/49] mm/sparse: fix vmemmap accounting imbalance on memory hotplug error
Date: Mon, 13 Apr 2026 22:05:34 +0800
Message-Id: <9642F4D9-8F1B-47A4-90BE-C72BB8DE9A11@linux.dev>
References: <adzxNAa7RnUDrykW@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Liam R Howlett <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <adzxNAa7RnUDrykW@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 58FA440016
X-Stat-Signature: ozgit5mdwdfqz7kcekdyi45fq3e3we58
X-Rspamd-Server: rspam06
X-HE-Tag: 1776089174-606296
X-HE-Meta: U2FsdGVkX1+3WsNYrYfAuGK8KbMsuaV5cidcMh6hlq6N8jn63JOD4tjoBjW7i718DdHUkXXhh1kSEZ0LXjDFcob4z7K8nOX0rLe2ZQRNxHVqDUaj1TwYm6zwibmzTHgaMygP0l3arYQ5s1oL0sygZlQKje8uk5hJOvDw1EgCvKaXrCiEUIKqUgFNeKtMEsf9X/xTphcfr8gd/l7wi13cKiZxWKwTZq8oOCsIs92GuMBzaOGksPYfJkLs9mcCVn7Z+Y2Zrjnv4HNm/VOyGUzW8aIXbUIovHSqLFSjQtxv/JUKgsZw5yNKP0y62tLJ1EZFEZCMmObZTaAbJk21zGubB/LtnLdLqGKg8qU5zsL6LFAU9qCS1YiwGVIaV/QEhQSwe2/Ddemt1aFZh6y5GGvv7J1iCFzHXy3p5czZKrHVjPvzSf+84L8OwxDP4OG6zlheqKGSelIHUmp03OYE11iwBDywuxVDLPYZq/FOYjSxzKxFrrefSqibFTp5JMdvZGRmynGgbbKfdA8xujgdYTlxAOwZ0tKCt6uuB5Bd6NFLojBdYc8IHOdYgFDlP1wVcgoFaIEC5lwlqK0OIgejKXntua3xhWYCP5WyA6mjTrUFAMvgiAt3M1lo48S4OpFt1sYrF0IDjRDOsi0QfCyBzNgnHKjNLGlmo+T1fn4F+VpymVKoRtgZJy11b5QchrGKrNGyU1tFYw2jIVRPFwA8ZV5Fe6IbSmiBXnoLTBW6O00IfFMmTqh0hQmmyMRlVLwMjMJ+ZkZtkJdr+jnIhAvzgAQNPzhT1CBGw75YyQf3qvpSx0TtEm2rpyMD3BABxttdzwSBEkYH9wOEM8NsII+HYl2ob1XBsf6G2eo1C2IJKAEE8DRDLSnlUPNh6jAzOMvjc/ngzfiEI3evZmkgP/RJQzVgSqDe2KEux45KSsrDC0gIswHsEQnY8aa4kHNY0VHUYucbygQ7HMymKaoArrko8xx
 I0crPPVc
 HShoYDFg3Yi7SaoMRBshVaxcep/H57AAKJb+GqslKrRXAeyvoLQ1Cw0swx9EgCs25r65h9s78c1NpDSJqztrT91KudddaALHKhEwULbq2k2cvPUcpVmgrW+hXEjGW0XT4/JSKEIBQvj03WcD5WjE+cYqzUcbdPr1yYqr2ecCePfWSOv/lFRR8raxoVprZ1dVET5BvrPaPxSTBuIHZubwwL190vs7PGamJw+4krs9sLAeiEwMjwfIRu5GH83kwC1oFSapd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 13, 2026, at 21:36, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> =EF=BB=BFHi Muchun,

Hi,

>=20
> On Mon, Apr 13, 2026 at 08:47:45PM +0800, Muchun Song wrote:
>>>> On Apr 13, 2026, at 20:05, Mike Rapoport <rppt@kernel.org> wrote:
>>>>>>>>=20
>>>>>>>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>>>>>>>> index 6eadb9d116e4..ee27d0c0efe2 100644
>>>>>>>> --- a/mm/sparse-vmemmap.c
>>>>>>>> +++ b/mm/sparse-vmemmap.c
>>>>>>>> @@ -822,11 +822,11 @@ static struct page * __meminit section_activa=
te(int nid, unsigned long pfn,
>>>>>>>> return pfn_to_page(pfn);
>>>>>>>>=20
>>>>>>>> memmap =3D populate_section_memmap(pfn, nr_pages, nid, altmap, pgma=
p);
>>>>>>>> + memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAG=
E_SIZE));
>>>>>>>=20
>>>>>>> This logically belongs to success path in populate_section_memmap().=
 If we
>>>>>>> update the counter there, we won't need to temporarily increase it a=
t all.
>>>>>>=20
>>>>>> Not strictly related to this patchset, but it seems, we can have a si=
ngle
>>>>>> memmap_boot_pages_add() in memmap_alloc() rather than to update the c=
ounter
>>>>>> in memmap_alloc() callers.
>>>>>=20
>>>>> It will indeed become simpler and is a good cleanup direction, but the=
re
>>>>> is a slight change in semantics: the page tables used for vmemmap page=

>>>>> mapping will also be counted in memmap_boot_pages_add(). This might no=
t
>>>>> be an issue (after all, the size of the page tables is very small comp=
ared
>>>>> to struct pages, right?).
>>>>>=20
>>>>> Additionally, I still lean toward making no changes to this patch, bec=
ause
>>>>> this is a pure bugfix patch =E2=80=94 of course, it is meant to facili=
tate backporting
>>>>> for those who need it. The cleanup would involve many more changes, so=
 I
>>>>> prefer to do that in a separate patch. What do you think?
>>>=20
>>> For this patch and easy backporting I still think that cleaner to have t=
he
>>> counter incremented in populate_section_memmap() rather immediately afte=
r
>>> it.
>>=20
>> Hi Mike,
>>=20
>> Alright, let=E2=80=99s revisit your solution. After we=E2=80=99ve moved t=
he counter into the
>> populate_section_memmap(), we still need to increase the counter temporar=
ily
>> (but in populate_section_memmap()) even if we fail to populate. That=E2=80=
=99s
>> because section_deactivate() reduces the counter without exception, isn=E2=
=80=99t it?
>> Just want to make sure we are on the same page on the meaning of =E2=80=9C=
temporarily
>> increase=E2=80=9D.  Maybe you do not mean =E2=80=9Ctemporarily=E2=80=9D i=
n this case.
>=20
> I suggest to increase the counter only if we succeeded to populate:
>=20
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 6eadb9d116e4..247fd54f1003 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -656,7 +656,13 @@ static struct page * __meminit populate_section_memma=
p(unsigned long pfn,
>        unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>        struct dev_pagemap *pgmap)
> {
> -    return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
> +    struct page *p =3D __populate_section_memmap(pfn, nr_pages, nid, altm=
ap,
> +                           pgmap);
> +
> +    if (p)
> +        memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAG=
E_SIZE));

We don=E2=80=99t increase the counter on failure, then

> +
> +    return p;
> }
>=20
> static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_=
pages,
> @@ -826,7 +832,6 @@ static struct page * __meminit section_activate(int ni=
d, unsigned long pfn,
>        section_deactivate(pfn, nr_pages, altmap);

here section_deactivate() is called, which decrease the counter unconditiona=
lly,
the issue still exists. We didn't fix anything.

Thanks.

>        return ERR_PTR(-ENOMEM);
>    }
> -    memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SI=
ZE));
>=20
>    return memmap;
> }
>=20
>=20
> Then we'll better follow "all or nothing" principle and won't have
> exceptional cases in section_deactivate().
>=20
>> Thanks,
>> Muchun.
>=20
> --
> Sincerely yours,
> Mike.

