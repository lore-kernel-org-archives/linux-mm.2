Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87805C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 04:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724BC6B0093; Wed, 15 Jul 2026 00:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FCF86B0095; Wed, 15 Jul 2026 00:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6123C6B0096; Wed, 15 Jul 2026 00:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31BA66B0093
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:13:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 96D0A1205BE
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:13:28 +0000 (UTC)
X-FDA: 84989691696.22.290C1F0
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0735920006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:13:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=VjO3PUvT;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784088807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iYeoB2Oy/GZpBzjfZl/wRaVKRhISTMx1gSLVXS3r6YQ=;
	b=GFMeMAe4tRYcY6qrQekyFPbSNm8EBjjhz2frfckJ2xBPxSUSuKpCeQfkWV+4B0IEIb0XBD
	TnxAkNvjkcVwC9pkt+rRl7yNTR06afYvMVAb75CvaLj//vd3YE4tfzfE7VIapEItl8XU1O
	G+07T2G6pUPTzLCc9LgQrayKl09vOKU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=VjO3PUvT;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784088807;
	b=zikaSPvbGvyFaFVwD7vlYTYeU+s4K9IE1R+8E4+EgewjzhypAxk5Pxl9dJ1PCewhR8svpc
	tkAP2HzI52ZoRE0I1vPlklUJ54358NAps12aQcRfFZuZna3ouowg4cJPslMcnhUPd/qcaU
	GfukJleNU33OQ3k/w3fmgMo9+fRV/+c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784088800; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=iYeoB2Oy/GZpBzjfZl/wRaVKRhISTMx1gSLVXS3r6YQ=;
 b=VjO3PUvTDUj3RjNqk8bDBkutYkm4ldUGqiss4dQJVY9POQZM40HbYe9+YncVtM8itsjyjY
 Pf5EthMWJRltFiODPOFTPpNyne/X22AJ4cpV9dPjxMrxIU1K8e0HS3Tgtqqj6kFOYGTFg7
 7S0Hmpa1Q5Zuadsl7/4XgkNYKPjcqakEfTfRj/vOPRBjMIa6WrdODeQmr6HyacSdwAyUnT
 E+suoiQpgO/qwQxEffUb6YAy/d6vlp0ixyQv5KWpB/lWnhgpSVFOrAddrxoQyiK/ray4Ad
 x8JT/bvDJdevYO4+7bTTTNVgp7KbN5Jxt5/3x5MNxkMgI+9Eweo9HDrT6AGjPg==
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a5708de+22d1e4+kvack.org+lizhe.67@bytedance.com>
Date: Wed, 15 Jul 2026 12:12:57 +0800
Message-Id: <0f83a711-5493-45f1-871b-1fade5fa2916@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>
Subject: Re: [PATCH v6 2/8] mm: factor zone-device page init helpers out of __init_zone_device_page
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
In-Reply-To: <993afd58-e503-46aa-acaf-19243b0d147c@linux.dev>
References: <20260709112520.24857-1-lizhe.67@bytedance.com> <20260709112520.24857-3-lizhe.67@bytedance.com> <993afd58-e503-46aa-acaf-19243b0d147c@linux.dev>
To: "Muchun Song" <muchun.song@linux.dev>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Stat-Signature: kr47qz5hrjqdgspify6cb8jwjqq6gmus
X-Rspamd-Queue-Id: 0735920006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784088805-21665
X-HE-Meta: U2FsdGVkX1+ypbWcDLIP/gF0nYCEMv2wxqROpxj8GJAYKKCpKNuIZxiCakze+XM5Ezo3Ld4AggwASaiuLkmEs/TFUlQWC2hQMXAKcPoPMiZVritFeXqsB41WVAgJYnootJjuNBoQwPUnCRvqbMgq1YJfpVuqxYi1Cc8vKoWfdjnJKj4Hh/1eoiAJHQxMtiSPhQr+8oBjBADoW+4x5iQrfOGbMr6zCC2lp5TcnWevQ+mR6Q7FWyrhXFzUS8eD6mItLHq2Ktjnl15vxSyGWSGhpd0DCEBbCLYNw6i5qRf7BBgSiftTiA3UeFKguarmSXUAiayEJCMZiYbYkV3RR9A1421rNXM7DDQ1jCdb6fmymdU7tjiN/4mKuOEerpAa/9mLrhK7hWZ853mZVRlQHvmTDiWeNScxQzoHPYr3p6UZxZrXF4ApSgy9u4f0oBunTfwZeeJKsIrppq5J3sfj1nHgBU/qwzcnQPFYbPhaE0FZLgCfhq63TN0gc6+OaP1rCbjSnYpVIh7jy6Le3Z93d1yKxzprM0/yvZMlVN9vqgtxAURa5/w22yK2Nfqcg41+JCOG8vulC8YyYvMjg/3USgyWskluDbkwroZiEHiy3bEtxinZ0cjal4l1mfDXgL8Pyeb9mmguqcB2WGxPQt93fdeCmA57B9+YEe+k3fowq8szCPeoyIOAyY7LfCHhUAsU101LQTClbDCeAYEdyqJ5NGHT1Qg3XNj9hgrdgzJRgxL1AeaFJB5EQ10yUdTp6RSx7hnOC9tSGlrsv+bHpJBDsLSMZopNwJxlkp1UQ8Pw/K+8TsCPuOWhSiAIfvHQwWNDBsgDKyzk2gNX84JgXX4TsR7eSJ/wQbN7OZNyPu7Ec/LqquWP+aa5pCUC/XSyohDxXUI0zdY1khiVLYP4PzPBhewM1QadtjDeXX6DK4wrRwvt+XiQG6LuLvDcvCffPBaddEXs1CRlomouhrBBaYYxlnB
 Kh3eVH8a
 4IPorFpaecX4vPfvaNdSi6xNntm6ybHND7vU+kbXnyK6cyzML1Cp2qL9RQFsWVfxNUiFNK7w+tao5VdTrRNNvQUh6Sh8Fhg698xnCbRVljHbGzpE2g5xsr1ZydoC9FLIWyncOgtJ4qHXD7TOmESzu2JiIDgYO0Llc/vTCF0Hi0TcoUnc/QdBGCxJ8fUZr2GpKqACfa1mu/WmkITZOPFl8Iw/KyT1J/TtAjzNEdTdGvlliy+UkjGT8A2iEgGBl691+OCIgmYq2scKVKa+p80Fy8A5X1Ph1tDkDzhGXtU6+KTbOyqXQx/vK0RA4aiqLqmxU96fTsK94B5ApTIi6JjjbGLarbBqkmweyO6o8u6DYaSRu10ftnVSblAILmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 10:44 AM, Muchun Song wrote:
>
>
> On 2026/7/9 19:25, Li Zhe wrote:
>> memmap_init_zone_device() currently mixes refcount policy and core
>> ZONE_DEVICE page setup in a single helper.
>>
>> Factor the refcount-reset predicate into pagemap_resets_refcount(), move
>> the common page initialization into __zone_device_page_init(), and wrap
>> the existing slow path in zone_device_page_init_slow().
>
> Hi,
>
> Sorry if this has been discussed before, but I'm still curious=E2=80=94wh=
at
> is the significance of the 'slow' suffix here? I don't think I quite
> understand why this is called the 'slow path' here. Is there also a
> 'fast path' for initializing struct page?
>
> Thanks.=20

The "slow" suffix here is relative to the template-copy fast path added
later in patch 4.

Patch 2 factors the existing per-page initialization path into a helper
so that the later patches can reuse it as the fallback path when
template copying is not used. In that sense, this helper is the slow
path, while the fast path is introduced later in the series.

Thanks,
Zhe

>>
>> This keeps the slow-path behaviour unchanged and gives later patches
>> reusable helper boundaries.
>>
>> No functional change intended.
>>
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> ---
>> =C2=A0 mm/mm_init.c | 56 ++++++++++++++++++++++++++++++++++-------------=
-----
>> =C2=A0 1 file changed, 37 insertions(+), 19 deletions(-)
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 95808ab5cfdb..5fccfbacf855 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -1005,11 +1005,37 @@ static void __init memmap_init(void)
>> =C2=A0 }
>> =C2=A0 =C2=A0 #ifdef CONFIG_ZONE_DEVICE
>> -static void __ref __init_zone_device_page(struct page *page,=20
>> unsigned long pfn,
>> +/*
>> + * Return true when the free path for this pagemap type restores the=20
>> page
>> + * refcount to 1, so memmap_init_zone_device() can keep the count=20
>> set by
>> + * __init_single_page(). Otherwise initialize the refcount to 0 and=20
>> leave
>> + * it to the allocator or pgmap callbacks to raise it when the page is
>> + * handed out again.
>> + */
>> +static inline bool pagemap_resets_refcount(const struct dev_pagemap=20
>> *pgmap)
>> +{
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * MEMORY_DEVICE_GENERIC pages regain a refcoun=
t of 1 in the free
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * path. The remaining ZONE_DEVICE types start =
from 0 here and=20
>> raise
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * the count again when the allocator or driver=
 hands the page out.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 switch (pgmap->type) {
>> +=C2=A0=C2=A0=C2=A0 case MEMORY_DEVICE_FS_DAX:
>> +=C2=A0=C2=A0=C2=A0 case MEMORY_DEVICE_PRIVATE:
>> +=C2=A0=C2=A0=C2=A0 case MEMORY_DEVICE_COHERENT:
>> +=C2=A0=C2=A0=C2=A0 case MEMORY_DEVICE_PCI_P2PDMA:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return false;
>> +=C2=A0=C2=A0=C2=A0 case MEMORY_DEVICE_GENERIC:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return true;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 return true;
>> +}
>> +
>> +static void __ref __zone_device_page_init(struct page *page,=20
>> unsigned long pfn,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned=
 long zone_idx, int nid,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct d=
ev_pagemap *pgmap)
>> =C2=A0 {
>> -
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __init_single_page(page, pfn, zone_idx, n=
id);
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> @@ -1028,23 +1054,15 @@ static void __ref=20
>> __init_zone_device_page(struct page *page, unsigned long pfn,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page_folio(page)->pgmap =3D pgmap;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page->zone_device_data =3D NULL;
>> +}
>>
>> -=C2=A0=C2=A0=C2=A0 /*
>> -=C2=A0=C2=A0=C2=A0=C2=A0 * MEMORY_DEVICE_GENERIC pages regain a refcoun=
t of 1 in the free
>> -=C2=A0=C2=A0=C2=A0=C2=A0 * path. The remaining ZONE_DEVICE types start =
from 0 here and=20
>> raise
>> -=C2=A0=C2=A0=C2=A0=C2=A0 * the count again when the allocator or driver=
 hands the page out.
>> -=C2=A0=C2=A0=C2=A0=C2=A0 */
>> -=C2=A0=C2=A0=C2=A0 switch (pgmap->type) {
>> -=C2=A0=C2=A0=C2=A0 case MEMORY_DEVICE_FS_DAX:
>> -=C2=A0=C2=A0=C2=A0 case MEMORY_DEVICE_PRIVATE:
>> -=C2=A0=C2=A0=C2=A0 case MEMORY_DEVICE_COHERENT:
>> -=C2=A0=C2=A0=C2=A0 case MEMORY_DEVICE_PCI_P2PDMA:
>> +static void __ref zone_device_page_init_slow(struct page *page,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long pfn, unsigned =
long zone_idx, int nid,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct dev_pagemap *pgmap)
>> +{
>> +=C2=A0=C2=A0=C2=A0 __zone_device_page_init(page, pfn, zone_idx, nid, pg=
map);
>> +=C2=A0=C2=A0=C2=A0 if (!pagemap_resets_refcount(pgmap))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_page_count(pa=
ge, 0);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>> -
>> -=C2=A0=C2=A0=C2=A0 case MEMORY_DEVICE_GENERIC:
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>> -=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 }
>>
>> =C2=A0 /*
>> @@ -1090,7 +1108,7 @@ static void __ref memmap_init_compound(struct=20
>> page *head,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (pfn =3D head_pfn + 1; pfn < end_pfn;=
 pfn++) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct page *page=
 =3D pfn_to_page(pfn);
>>
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __init_zone_device_page(page=
, pfn, zone_idx, nid, pgmap);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 zone_device_page_init_slow(p=
age, pfn, zone_idx, nid, pgmap);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 prep_compound_tai=
l(page, head, order);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_page_count(pa=
ge, 0);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> @@ -1126,7 +1144,7 @@ void __ref memmap_init_zone_device(struct zone=20
>> *zone,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (pfn =3D start_pfn; pfn < end_pfn; pf=
n +=3D pfns_per_compound) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct page *page=
 =3D pfn_to_page(pfn);
>>
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __init_zone_device_page(page=
, pfn, zone_idx, nid, pgmap);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 zone_device_page_init_slow(p=
age, pfn, zone_idx, nid, pgmap);
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ALIGNED(pf=
n, PAGES_PER_SECTION))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 cond_resched();
>> --=20
>> 2.20.1
>

