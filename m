Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63386C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 04:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CCD46B008C; Wed, 15 Jul 2026 00:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27C176B0092; Wed, 15 Jul 2026 00:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147676B0093; Wed, 15 Jul 2026 00:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D57D96B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:22:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A88DA05AC
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:22:10 +0000 (UTC)
X-FDA: 84989713620.28.86773A6
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf13.hostedemail.com (Postfix) with ESMTP id 169F820002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:22:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=AwLibNUi;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784089328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+iXPt0ONtXluhXO6lgQ1VsSIPLvlDZ/rbWbf6ggoj+8=;
	b=iaySUWJiCO/XKaGhVhgx/iOyfM2Fcm9ew681AlkY4OBgaDrB/KorcsAQEcXm+UdyUzCW3f
	AiQ1tZa6//nsz6E/UCrw7GFMy83IEVECngGWBwXcxotQ6ZI54RhR0kt1j1npwIN9Q9JqcD
	+4dVerWTf176EoirmOg1mHMKq9gKuFo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=AwLibNUi;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784089328;
	b=EJMsArajeUrHm8mnkwtwYL3zJ+0qAjqz2gDSOdLmNBEupuBFSUkYTuhn2vYc4lYybl1ZOW
	YaTQqCzVhDNhQkd29aA2U+8Ey44zZauUePG+FrxujMWKie8anRLRk9Y15DlhqmpDcjgCJw
	ak/xtvc5KguYM0ANwmNS7bKB5BnLI0Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784089318; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=+iXPt0ONtXluhXO6lgQ1VsSIPLvlDZ/rbWbf6ggoj+8=;
 b=AwLibNUiW9Ur6IgBBhsB14GQTFtXN5bPUSrypIFIaHbOWEKO2LLRNIb9grBTJGjObOaDH7
 VkFZytdK9NYEtxEJ8p2YD34/WvDMMdHWXaPw2E0Jfht+Vx1/hPtR9JLkuY56A4KgdZWGpH
 zkMg4izLCkdELfXwJPMCaEgF+c4C4dAdLAxOnf/dqaULts8lP+XKzwKWJ0j0gRoslRGAxJ
 faxpRjdlHygZ1+Yq/vuedJ/R31ShHkYl4EHx4BOMdk/5lRtBaWIu8FHyzXniQ6D5jEkZ1Q
 dSGIYeFNFjsYbjgyLxfKyMLsheQcilTeS0eNAwPRP+eSjWUerJcAS79rcgzjcA==
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a570ae4+d2f24e+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <03158ab2-94e0-4a48-94d1-df2eedbc5545@linux.dev>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>
Subject: Re: [PATCH v6 4/8] mm: add a template-based fast path for zone-device page init
Date: Wed, 15 Jul 2026 12:21:35 +0800
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
To: "Muchun Song" <muchun.song@linux.dev>
Message-Id: <7bb26368-a305-43a5-ba6a-dc08a62a94bb@bytedance.com>
References: <20260709112520.24857-1-lizhe.67@bytedance.com> <20260709112520.24857-5-lizhe.67@bytedance.com> <03158ab2-94e0-4a48-94d1-df2eedbc5545@linux.dev>
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hwi51aj41keixaart6m7hgixrbepzu18
X-Rspamd-Queue-Id: 169F820002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784089327-609462
X-HE-Meta: U2FsdGVkX1/GMsZh5BXzZRz4/fqEvzFCZGHLV3L41bGOKhW72o94N0bj3615rGuRg0Cena6L/JeqZAQPm79n2RoBFfCsilPf9YZlKeKzYKS67PBZT+4j7DxZqT3VqFyzbM3Wc4AiTi3KYyF/6G67CC24xZ2YQY1VGGfTogRB7M3AuLCqkKoGHxFqIej66lQKkdPfu0QWpI3T8dLPaEP25AlfcNeZ+WvBhEkR3nCbIVxSvRVmHDPdyGGn/WJ+Lu9nu51ADxQAkV9O34dsE5acTWpxNUrsJJJJ/SE3Rn4eluVNTqsib1J65kijhms7sESJggJOTfvg2Ku+SyVPHm3VbJI3ouR6vct5mkrbn7csScu4i1fADGUxVoy0VBRKzbV8lTdMqGawdrHU+ZRM30xjzX63C8+E0vp10Dxxe1dTH8XuKMq3jE1Id4dZvus4dzWVvfIU3qxwsTAeZnEAvR5XhUq2vAi0F/8rLEWgcNF59GUdGp6Pf1UcdOPN0rnRK7kTj+wAegBJNB6U45Sg9Cr8LPPBXJNmyWUHhvC+0fMmvYNhHGzg0kCif1i7R/0k25cPYrYa9bTsgF5ClVq9HG53JfwYdGulcNmHw39tGfIkXm9dFjk+BoK0jrtdXnhX3i1AvhmWnOWr5mgRQ/9j5ofM8aYH/mmSBIM4h8XbrXBdp8sVqsjM3Y/8JVEZFoG4r8RcyOxnhMsCD1lddi39o9rFwQ9h5TG01ts5mpV+dr5Bdhd66fAmWfU+8jlIgNnYw2HDEp4OdxQ2jKfeD0vvakL7BI3ykGqB862SpjQZfxtOFsO54ZH7i2g4oblpZBBe2bVvboS8ew7qHrfCLsM7bTzxFlhIJvdrzYH6CBk469u7DHZqNAZX4JgXSoNZ4leKAdwetLbSopEf6qWDu2UfgrPamr01rkM5c9a+rMryTcrJLsteMOMuuQyEKAyDM4tDiZjRBAg68JXJ02I1ktMX0iN
 hdUMFbe9
 ovMdDuw+u5Iw/O17I2kSbuMrvm1ACNok2E4YUSY1ULxNZZUqo86MXLNkfUIWA3Yf8wFUwLOGZ0h9J8YuV6T44aN0SN+oc10+XFizvip7066aqyQBwkXLizgxD31etl2YhMAXz9XDZDgurhgfnc3f3mxIsi9Isz2xXx41l9hO4azbwHuvSH8QMiVxyv3mVBbRnCTjG/i+CTvXoemWI7pQ6kkitbS1RpJIUcNn3RlYCpibCv3Z0/xhdyvWcH4iRibh139fm+8jp4v+j1CozCPzyHmg12rFYdpQ5rn8ye5hq5Mx7Uyo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 9:28 PM, Muchun Song wrote:
>
>
> On 2026/7/9 19:25, Li Zhe wrote:
>> memmap_init_zone_device() repeats nearly identical head-page
>> initialization for each PFN. Prepare one reusable ZONE_DEVICE head-page
>> template through the existing slow path, refresh the PFN-dependent
>> fields in that template before each copy, and memcpy it into each
>> destination page.
>>
>> The optimized path assigns _refcount through the copied template, so
>> keep it disabled when the page_ref_set tracepoint is enabled.
>>
>> This patch accelerates head-page initialization. The pfns_per_compound
>> =3D=3D 1 case gets the full benefit here, compound tails are handled in =
the
>> next patch.
>>
>> Tested in a VM with a 100 GB fsdax namespace device configured with
>> map=3Ddev on Intel Ice Lake server. This test exercises the nd_pmem rebi=
nd
>> path (pfns_per_compound =3D=3D 1).
>>
>> Test procedure:
>> Rebind the nd_pmem driver 30 times and collect the memmap initialization
>> time from the pr_debug() output of memmap_init_zone_device().
>>
>> Base(v7.2-rc1):
>> =C2=A0=C2=A0 First binding: 1456 ms
>> =C2=A0=C2=A0 Average of subsequent rebinds: 244.28 ms
>>
>> With this patch and its prerequisites applied:
>> =C2=A0=C2=A0 First binding: 1440 ms
>> =C2=A0=C2=A0 Average of subsequent rebinds: 217.19 ms
>>
>> This reduces the average rebind time from 244.28 ms to 217.19 ms, or
>> about 11%.
>
> An 11% reduction is definitely a solid achievement. While the
> absolute gain is in the range of a few dozen milliseconds, I=E2=80=99d
> love to better understand the compounding impact. In which
> specific latency-sensitive scenarios or workloads does saving
> these few dozen milliseconds translate into a major breakthrough
> for the user experience?
>
> Muchun,
> Thanks.

Patch 4 by itself is only an incremental step, not the full result of
the series.

The target scenario here is large fsdax/devdax pmem bind/rebind
latency. This patch removes the repeated head-page initialization
overhead on the pfns_per_compound =3D=3D 1 path, so the gain at this stage
is only a few dozen milliseconds.

The later patches extend the same idea to compound tails and then switch
the template-copy path over to memcpy_nt(), which is where the larger
reduction reported for the full series comes from. Even this
incremental reduction still helps shorten the control-path latency for
large namespace bind/rebind operations.

Thanks,
Zhe

>
>>
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> ---
>> =C2=A0 mm/mm_init.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++=
++++-
>> =C2=A0 1 file changed, 58 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 5fccfbacf855..170021e182e0 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -1065,6 +1065,44 @@ static void __ref=20
>> zone_device_page_init_slow(struct page *page,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_page_count(pa=
ge, 0);
>> =C2=A0 }
>> =C2=A0 +static inline bool zone_device_page_init_optimization_enabled(vo=
id)
>> +{
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * The template fast path copies a preinitializ=
ed struct page=20
>> image.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Skip it when the page_ref_set tracepoint is =
enabled.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 return !page_ref_tracepoint_active(page_ref_set);
>> +}
>> +
>> +/*
>> + * 'template' is a reusable page prototype rather than a strictly=20
>> immutable
>> + * object. Most ZONE_DEVICE fields stay constant across the pages=20
>> covered by
>> + * the current template, but section bits and page->virtual may=20
>> still depend
>> + * on the PFN. Refresh those PFN-dependent fields in the template=20
>> before
>> + * copying it into @page.
>> + */
>> +static inline void zone_device_page_update_template(struct page=20
>> *template,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long pfn)
>> +{
>> +=C2=A0=C2=A0=C2=A0 set_page_section_from_pfn(template, pfn);
>> +#ifdef WANT_PAGE_VIRTUAL
>> +=C2=A0=C2=A0=C2=A0 if (!is_highmem_idx(ZONE_DEVICE))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_page_address(template, _=
_va(pfn << PAGE_SHIFT));
>> +#endif
>> +}
>> +
>> +static void zone_device_page_init_from_template(struct page *page,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long pfn, struct pa=
ge *template)
>> +{
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * 'template' carries the invariant portion of =
a ZONE_DEVICE struct
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * page. Update the PFN-dependent fields in pla=
ce before copying it
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * to the destination page.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 zone_device_page_update_template(template, pfn);
>> +=C2=A0=C2=A0=C2=A0 memcpy(page, template, sizeof(*page));
>> +}
>> +
>> =C2=A0 /*
>> =C2=A0=C2=A0 * With compound page geometry and when struct pages are sto=
red in=20
>> ram most
>> =C2=A0=C2=A0 * tail pages are reused. Consequently, the amount of unique=
 struct=20
>> pages to
>> @@ -1120,6 +1158,7 @@ void __ref memmap_init_zone_device(struct zone=20
>> *zone,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long nr_pages,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct dev_pagemap *pgmap)
>> =C2=A0 {
>> +=C2=A0=C2=A0=C2=A0 bool use_template =3D zone_device_page_init_optimiza=
tion_enabled();
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long pfn, end_pfn =3D start_pfn =
+ nr_pages;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct pglist_data *pgdat =3D zone->zone_=
pgdat;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct vmem_altmap *altmap =3D pgmap_altm=
ap(pgmap);
>> @@ -1127,6 +1166,7 @@ void __ref memmap_init_zone_device(struct zone=20
>> *zone,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long zone_idx =3D zone_idx(zone)=
;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long start =3D jiffies;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int nid =3D pgdat->node_id;
>> +=C2=A0=C2=A0=C2=A0 struct page template;
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (WARN_ON_ONCE(!pgmap || zone_id=
x !=3D ZONE_DEVICE))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>> @@ -1144,7 +1184,24 @@ void __ref memmap_init_zone_device(struct zone=20
>> *zone,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (pfn =3D start_pfn; pfn < end_pfn; pf=
n +=3D pfns_per_compound) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct page *page=
 =3D pfn_to_page(pfn);
>> =C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 zone_device_page_init=
_slow(page, pfn, zone_idx, nid, pgmap);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!use_template) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 zone=
_device_page_init_slow(page, pfn, zone_idx,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 nid, pgmap);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (pfn =3D=3D start_=
pfn) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * Seed the reusable head-page template from the
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * first real struct page, because the existing
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * page-init and pageblock helpers expect a real
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * memmap entry rather than a stack object.
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 zone=
_device_page_init_slow(page, pfn, zone_idx,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 nid, pgmap);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* i=
nit template page */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memc=
py(&template, page, sizeof(*page));
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 zone=
_device_page_init_from_template(page, pfn,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &template);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ALIGNED(pf=
n, PAGES_PER_SECTION))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 cond_resched();
>> --=20
>> 2.20.1
>

