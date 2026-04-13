Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BEB9EBFD2C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 09:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAD906B0089; Mon, 13 Apr 2026 05:50:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5E7B6B008A; Mon, 13 Apr 2026 05:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74916B0092; Mon, 13 Apr 2026 05:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A90D6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:50:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45091E028F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:50:18 +0000 (UTC)
X-FDA: 84653062116.19.F842F49
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4ED40140002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:50:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gpzednZO;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776073816; a=rsa-sha256;
	cv=none;
	b=LpJf8aercITkr8eSHPmQi42GU+ANNdzR0PXvLpTKOpL7m0qExV+dRzCFNYXR9NCyrObuXJ
	GsRZMxBA5fdnqwGBIq7GBCDQk6z6rC9AOOSkC+xfu6tiI7htPvvIv8TksoVmogvMhrWI2w
	y95XVMzrKCcJNRlgSyltNk2gSSuIUO0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776073816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QPYOp4SQxJnwqDa7dtThbAGyQONRoG1+/Tuu6VpyDD4=;
	b=q97WLqc1mzMMagTZyjYQdmI9GT/0E2XoQkzK8gtjn5A1uHlq1XTD5wpekI5XHwZuVpVa8W
	9HE89IgQSK8JwJC4nLvpzidl6f8QhWj9Zf8K8PpuFSCZMGz9qeUmlUW+l3sc/N2c8J2axq
	OCF3B65U5zZipXuUaT/Sil5Wu63gT4Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gpzednZO;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776073813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QPYOp4SQxJnwqDa7dtThbAGyQONRoG1+/Tuu6VpyDD4=;
	b=gpzednZOE7T4VRbmaNwl/0LR5EKOY7DV6qB8eeeTSzNFlQ8kEWHKOXH1Ftf8s64zXzdrEW
	GG1v4unDi5PvSisJIE+sPNXmm7uXoyv7CY5HGJ5qRQYR0917YaeGHqzhFRFwHqRWrNXpWL
	J7ZXICa5XaP1N13mEBFAZZS+be30RtE=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 01/49] mm/sparse: fix vmemmap accounting imbalance on
 memory hotplug error
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ady40BWw5WgQHf3z@kernel.org>
Date: Mon, 13 Apr 2026 17:49:17 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
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
Message-Id: <35454ADD-C983-4577-997E-884266C56FB6@linux.dev>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-2-songmuchun@bytedance.com>
 <ady1LQMN1xhPGcuT@kernel.org> <ady40BWw5WgQHf3z@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4ED40140002
X-Stat-Signature: mo9qhpnddqszqdcc3urizj8exgispkay
X-HE-Tag: 1776073816-345925
X-HE-Meta: U2FsdGVkX189ZnF/E3qCQmgIIifpM8DBkrQINGkA9erQoovawfQw7kiY43ZPqHDhyyt+R8Aacn7eQ5xlMhBy4LDMbpMDO4I5Flude9VGSlZab6K521ZPgMPOb1PL/MSdXgZ6R+sCkoSCwuLJdUGm6GMgQqpBjWdXt1JqAM7dEj50W01htfdmptSBMsd81o16STmT33TFQvTPrI3V3Ag234io1EapLdo0CAO3XmXm2sA/plffZyz3rTzMFpWuTzKiGu7zAFvgLMT5Oj2hoqZR2xQcR5Uynm0xaK/m72cbi5hKtose+I7XFjO5EYlY4uBvO/MzTSHnc40YYkPcy57iUGeviKzI5DSaXLcPTCb7rGLaALt1zCIwMLEbaYe4IVqz4cdRruFw6tBegAAcYtTKKO/1KGVDM4EyOtq1egyMn6//9qf19+aPx/kViR3er0hG5zbrTHLf3v2dYdXZAZvnirspvb+V5sWzsuClNC4k6R1OTXspEnMMOqQTvCVRzrO+4+VJ5ibz3blophnH/EeMVixmoKxwvrr04CCWMcHDjpdjZWIdN/sfj3q7pKwK3sghC800P9l+hxiv0GYDlYtBdMFWxRNFL16yVF+sFqRvhnJtwtxAIX7wuoc31cGrHXWfxMlwMC/NcYK3AhGHLTtxTNsPyRNe6FeLC4Fkm94eplPnkTLO1Pxjbz1Q52+6Afc39thY9sYb0hDqjCrBHrhHUKP5eeYY7NFYVLjdszBMPLpJ9W2QrvXWldNcA1TuN4e4eRb0Z1QaxdqegLtKolaGogtSpT2ZGletCo7YmmRUPjb9Ow19af+tIOFV/B18bn3MQLpkbDiXhWt0mIi0cvnC5Vbj/oL0nHUfWi2k54Wsim1k810oh236+nFRk1HVrNvNTOuK9IouBBIzGmT1H2Ll6N/lPMns4aFt0EfKH0aMIH6AQc9BCkH3pcYOy2aUHYiA8ktaM27rxJP37/JGIpu
 vBlZgGsc
 3LiizdyLMDG4ZbwNcJkErlLBNMILs3VzaC1Ju2aPfdI+zKIQtHMbqu7pULIOhh8W7Y2UtNiFu4Mx6kJ8vEKd0X9cdLJedDW66DFhjpG5CJXEc1ReFOo6VdSkTEogJV1eClKtYBZH0aH3rzzxrYjhDNZL0PfGeXFIUEDGuN5x383prn5iqzuDbZd60r76n/1snSwZTDEbdeEvnot0tuwYk0XHnCtzHwtpljAwO7X0mKMWXnRBcSLR/425czy6vcVXE6LFe5hNX/yUWR3LG2a6VFTieEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 13, 2026, at 17:35, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Mon, Apr 13, 2026 at 12:19:50PM +0300, Mike Rapoport wrote:
>> On Sun, Apr 05, 2026 at 08:51:52PM +0800, Muchun Song wrote:
>>> In section_activate(), if populate_section_memmap() fails, the error
>>> handling path calls section_deactivate() to roll back the state. =
This
>>> approach introduces an accounting imbalance.
>>>=20
>>> Since the commit c3576889d87b ("mm: fix accounting of memmap =
pages"),
>>> memmap pages are accounted for only after populate_section_memmap()
>>> succeeds. However, section_deactivate() unconditionally decrements =
the
>>> vmemmap account. Consequently, a failure in =
populate_section_memmap()
>>> leads to a negative offset (underflow) in the system's vmemmap =
tracking.
>>>=20
>>> We can fix this by ensuring that the vmemmap accounting is =
incremented
>>> immediately before checking for the success of =
populate_section_memmap().
>>> If populate_section_memmap() fails, the subsequent call to
>>> section_deactivate() will decrement the accounting, perfectly =
offsetting
>>> the increment and maintaining balance.
>>>=20
>>> Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> ---
>>> mm/sparse-vmemmap.c | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>=20
>>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>>> index 6eadb9d116e4..ee27d0c0efe2 100644
>>> --- a/mm/sparse-vmemmap.c
>>> +++ b/mm/sparse-vmemmap.c
>>> @@ -822,11 +822,11 @@ static struct page * __meminit =
section_activate(int nid, unsigned long pfn,
>>> return pfn_to_page(pfn);
>>>=20
>>> memmap =3D populate_section_memmap(pfn, nr_pages, nid, altmap, =
pgmap);
>>> + memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), =
PAGE_SIZE));
>>=20
>> This logically belongs to success path in populate_section_memmap(). =
If we
>> update the counter there, we won't need to temporarily increase it at =
all.
>=20
> Not strictly related to this patchset, but it seems, we can have a =
single
> memmap_boot_pages_add() in memmap_alloc() rather than to update the =
counter
> in memmap_alloc() callers.

It will indeed become simpler and is a good cleanup direction, but there
is a slight change in semantics: the page tables used for vmemmap page
mapping will also be counted in memmap_boot_pages_add(). This might not
be an issue (after all, the size of the page tables is very small =
compared
to struct pages, right?).

Additionally, I still lean toward making no changes to this patch, =
because
this is a pure bugfix patch =E2=80=94 of course, it is meant to =
facilitate backporting
for those who need it. The cleanup would involve many more changes, so I
prefer to do that in a separate patch. What do you think?

Thanks,
Muchun.

>=20
>>> if (!memmap) {
>>> section_deactivate(pfn, nr_pages, altmap);
>>> return ERR_PTR(-ENOMEM);
>>> }
>>> - memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), =
PAGE_SIZE));
>>>=20
>>> return memmap;
>>> }
>>> --=20
>>> 2.20.1
>>>=20
>>=20
>> --=20
>> Sincerely yours,
>> Mike.
>=20
> --=20
> Sincerely yours,
> Mike.



