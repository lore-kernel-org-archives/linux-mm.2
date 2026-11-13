Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F95606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 05:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vah1V1BJ
Received: by kanga.kvack.org (Postfix)
	id CDAE76B05B5; Fri, 13 Nov 2026 00:47:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64246B0613; Fri, 13 Nov 2026 00:47:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B546B0618; Fri, 13 Nov 2026 00:47:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74CFC6B05B5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:47:37 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF194140285
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:47:36 +0000 (UTC)
X-FDA: 85429013712.09.FA6B732
Received: from mta1.migadu.com (out-106.mta1.migadu.com [95.215.58.106])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9E1DA40004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:47:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vah1V1BJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794548855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tH9MRkHQTZbs1LzKP4zwJuzcXsw9kcfIaj2yccY1Tzc=;
	b=dFxaGnh35M5j7w23C1wa+gRrnDVmFyefYdyc4iHyNaqBzaSoFz1ulhlvtOAJLJZwxsPmQZ
	AaCmq2IxnqBi6r1jfRPdTMXZkDZTPkpYLsTiJ+Eu+eXGYF3C0EpNiDF9jqBpN9yFK+u76J
	0prEHS4lB2Kf1NfNKkj1kPowU5h+Xok=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794548855;
	b=YEymuO7LfTTflbODqLtltRMzshSj3+GEWpJTRW7q3JWGrYJ0K+77naqLlR4vO9uzcL519k
	HLMqWVoh47bgjz8LfrrKkV/BcYLT0XVuMJ6x4oSMWK6Eqvr7AMEQWg8ekRDkgbsJjS3yk7
	amfpXjD1DsbX8CJZEFNfOb074aOWgdg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vah1V1BJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=k23lgE2Jzwowgo6m52d31kwDYMIKzjyRuwBX8TKnliw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794548852; v=1; x=1795153652;
 b=vah1V1BJzyDQPBXiFoiTCNiHazPgAheKdRO33bHipe52/y+yAl43SB0Ku0GgJ1V00l0jR64R
 gNZEwA/rC3wGHfKH5EC1jOD3dd6dcxe+kruvkxcP9wAPduHUaHJzKIMkrOL062xAgoCL2lhYlpj
 r8OK8eWv7WROLSvGnQ/SL8H8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6a17f1505f6787fd;
	Fri, 13 Nov 2026 05:47:32 +0000
X-Mizu-Trace-ID: 6a17f1505f6787fd
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 12/14] mm/cma: centralize CMA pageblock initialization
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <sashiko-outbox-212157@kernel.org>
Date: Fri, 13 Nov 2026 13:47:13 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Li Zhe <lizhe.67@bytedance.com>,
 Andrew Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 James Houghton <jthoughton@google.com>,
 Lance Yang <lance.yang@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EDBD7566-17EA-4B8D-8510-E670614DDA01@linux.dev>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
 <20261113033442.62970-13-songmuchun@bytedance.com>
 <sashiko-outbox-212157@kernel.org>
To: sashiko-reviews@lists.linux.dev
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: 7ak734tb7fuyqaw3zoaepcuq1n9g13g3
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E1DA40004
X-HE-Tag: 1794548854-308511
X-HE-Meta: U2FsdGVkX1+iZI32BJZG03p5nkT3L3ZHKNhtVs71oyH1OMbnaA5uN//ixD8ACeCtZ1Aoi3TK3XN/aTHPnEhe4JPTszXyGQYLSnXLfeot8xB6C+uXa0ZhJA+6skZ+8LGUR3mzSYQyT18tpHrbSKX5G7Huq3p1vRmRNB+HUQINE9UIxiMwFh23YxMojA1047iUNDs8vl7QErodAnuQrfNWqFUH6paCpqOw6vOHqvYEZ7pCDhmgaPFHdvSQPOXJf2A2W4TXYDwF3lWGcETZD4xQka67HUYtLLlZV/0/HTa/vz2uy2WolSUzfX26REdVgC0WVpRl3snyBs6ieBy/B1JG/5MtMJhO5CQzm0fC8gtMiMnblwqOCe9G1xYnsqVUEBT2vNh7bNIsjr/GWggIU6ERkcoli9pisTJBWJ60qStz5dTRyLN/Li3L2qbCsQFC6exTTMYrOmkRRIkLwp3F5QaGeYpgtDjYsxwr9pzUI5DH2uG6FbteTmnGXPnJWHV9nkE4KZU0yc45EvQDUy76fDDCqrhRJp48xWr8DdGKHLwFcy/S7G5cffQPx3eKAjEqwaXwiZm0rhhXR2DPfEH31tOqDZVyRGGBh9KsMopXaFUZ4pEAqweSZzRhlHZT/PP0hlyKSz2Pz6gZq0334+gqVJWwW3NzlZqsnEXvQFuICo58Pjh4VwHBi7P6U7lPX8lAeJyAo0XG7CaOmOxeiUmFZBSMoT0Ym/kD6GzxBOt5WeOLuMetrkdDo9DuBAhLvntwv314y7AwCWsX6A8vyCozcGDKoUCtLthSVK8ouIXRfg7CjjRrmcRprHCS4J6OTXNbC0ZToJV3ZTc0HGTxTA5jo0n7fGofLRlFNSFGYPTWWNFweQ/aLbgJRC83dHT9DkFFRi/Kcasb8iW0drRLyD2NiEr1XFk06+AL1lNLntDsGOo+TlqcRZgAfucPEDEn/Kf1FeigfHzxfK8yt+Dcen1HSWK
 nONrI5Dj
 palwhCWCkDEoH9YF9oWerp4PenRhQ9LtXcfj94EXGSvtbpzxvoNR+OHgGzeDmVxfnc8+P0k4gxMnywZa+igzaDD8fMmHAGGq5kUI0R/sleOBbp9NWX03emVzV7LQg305HlnoAC4Ua5iGQvehbpWUVKofvCoVoJwtf3zjKYZS3Q6UmGlLW6XQFjpCsslqHdE4nxKq0uxUa2cS9WkWGe6EQ7h7FM1Z6Vu+VbBPrskAU4hkvUu9W5dWu9RRzZQO7uhcLhBKcEw9zAbZy57sxaoB8fX7x9QqEPu+sUhKF0UaZa5ZzLw1nGRo7EXlAd32s+/fja4rrz9vYUmoLn3i9QrjtX/vAhIge+ZLhxNAJ+oTMNlpHasMEtLECA55wJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 13, 2026, at 12:07, sashiko-bot@kernel.org wrote:
>=20
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/cma: skipped and per-PFN managed page accounting in
>  cma_activate_area()
> --
>=20
> commit cd588f911bb59c4583e63d2e776ba252d0663161
> Author: Muchun Song <muchun.song@linux.dev>
>=20
> mm/cma: centralize CMA pageblock initialization
>=20
> This commit moves the initialization of early-reserved CMA pageblocks =
from
> hugetlb into cma_activate_area() and restores managed-page accounting =
for
> those pages if CMA activation fails.
>=20
>> diff --git a/mm/cma.c b/mm/cma.c
>> index 9ec1d1fd5dff5..46e72734ba729 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>=20
> [ ... ]
>=20
>> @@ -191,12 +195,13 @@ static void __init cma_activate_area(struct cma =
*cma)
>> 	/* Expose all pages to the buddy, they are useless for CMA. */
>> 	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
>> 		for (r =3D 0; r < cma->nranges; r++) {
>> -			unsigned long start_pfn;
>> -
>> 			cmr =3D &cma->ranges[r];
>> -			start_pfn =3D r <=3D allocrange ? early_pfn[r] : =
cmr->early_pfn;
>> +			end_pfn =3D r <=3D allocrange ? early_pfn[r] : =
cmr->early_pfn;
>> +			for (pfn =3D cmr->base_pfn; pfn < end_pfn; =
pfn++)
>> +				=
adjust_managed_page_count(pfn_to_page(pfn), 1);
>> +
>> 			end_pfn =3D cmr->base_pfn + cmr->count;
>> -			for (pfn =3D start_pfn; pfn < end_pfn; pfn++)
>> +			for (; pfn < end_pfn; pfn++)
>> 				free_reserved_page(pfn_to_page(pfn));
>> 		}
>> 	}
>=20
> [Severity: Medium]
> Does gating the adjust_managed_page_count() loop on
> !CMA_RESERVE_PAGES_ON_ERROR leave early-reserved gigantic hugetlb =
pages
> unaccounted in zone->managed_pages and totalram_pages if CMA =
activation
> fails?

Right. I think the following diff will fix it.

diff --git a/mm/cma.c b/mm/cma.c
index 7ca0e100504d..e8845747f7cf 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -200,18 +200,23 @@ static void __init cma_activate_area(struct cma =
*cma)
        for (r =3D 0; r < allocrange; r++)
                bitmap_free(cma->ranges[r].bitmap);

-       /* Expose all pages to the buddy, they are useless for CMA. */
-       if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
-               for (r =3D 0; r < cma->nranges; r++) {
-                       cmr =3D &cma->ranges[r];
-                       end_pfn =3D r <=3D allocrange ? early_pfn[r] : =
cmr->early_pfn;
-                       for (pfn =3D cmr->base_pfn; pfn < end_pfn; =
pfn++)
-                               =
adjust_managed_page_count(pfn_to_page(pfn), 1);
-
-                       end_pfn =3D cmr->base_pfn + cmr->count;
-                       for (; pfn < end_pfn; pfn++)
-                               free_reserved_page(pfn_to_page(pfn));
-               }
+       for (r =3D 0; r < cma->nranges; r++) {
+               cmr =3D &cma->ranges[r];
+               end_pfn =3D r <=3D allocrange ? early_pfn[r] : =
cmr->early_pfn;
+               /* Restore managed page accounting for early-reserved =
pages. */
+               for (pfn =3D cmr->base_pfn; pfn < end_pfn; pfn++)
+                       adjust_managed_page_count(pfn_to_page(pfn), 1);
+
+               if (test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags))
+                       continue;
+
+               /* Expose the remaining pages to the buddy. */
+               end_pfn =3D cmr->base_pfn + cmr->count;
+               for (; pfn < end_pfn; pfn++)
+                       free_reserved_page(pfn_to_page(pfn));
        }
        totalcma_pages -=3D cma->count;
        cma->available_count =3D cma->count =3D 0;

>=20
> When crashkernel=3D...,cma is used alongside hugetlb_cma,
> hugetlb_cma_add_crashkernel_ranges() sets CMA_RESERVE_PAGES_ON_ERROR =
on
> the hugetlb_cma area before hugetlb_bootmem_alloc() reserves gigantic
> pages from it via cma_reserve_early().  gather_bootmem_prealloc_node()
> always skips adjust_managed_page_count() for hugetlb_early_cma(h) =
folios,
> and those folios remain active in the hugetlb pool even if
> cma_activate_area() fails, so their managed page count needs to be
> restored regardless of CMA_RESERVE_PAGES_ON_ERROR.
>=20
> Also, calling adjust_managed_page_count(pfn_to_page(pfn), 1) once per =
base
> PFN invokes setup_per_zone_lowmem_reserve() for every 4 KiB page =
(262,144
> times per 1 GiB page) instead of stepping by pageblock_nr_pages or
> adjusting by end_pfn - cmr->base_pfn.

Batching is not generally safe here. Activation can fail before zone =
validation,
or because the CMA range crosses zones, while =
adjust_managed_page_count(page, count)
charges the full count to page_zone(page). Since this is an exceptional =
early-boot
failure path, I prefer to retain the per-PFN accounting.

Thanks.

>=20
> --=20
> Sashiko AI review =C2=B7 =
https://sashiko.dev/#/patchset/20261113033442.62970-1-songmuchun@bytedance=
.com?part=3D12


