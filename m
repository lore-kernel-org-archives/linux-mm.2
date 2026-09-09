Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB973C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD36B6B00A3; Wed,  9 Sep 2026 09:08:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA9306B00A4; Wed,  9 Sep 2026 09:08:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBF2A6B00A5; Wed,  9 Sep 2026 09:08:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC3496B00A3
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:08:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C1681601EC
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:08:37 +0000 (UTC)
X-FDA: 85194253074.13.0F944FB
Received: from mta0.migadu.com (out-234.mta0.migadu.com [91.218.175.234])
	by imf03.hostedemail.com (Postfix) with ESMTP id C49212000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:08:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E2QXc9Kd;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.234 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788959315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2y/dIV5tPGOfJuIl5SfYxpTegneI+xoglz4aoff884=;
	b=mkio484wnxdk6hirOf7Dg+j9N3LsOxPh6TOTnuO9SfKCEcoUYvgv4UKbcTdIfmnzpGDodj
	X/e9n2AiHcnK3l539OV2kBBgVGKbHXgiFtFHKUfDKJZwNXF9szJMqSO2ckQ1QB6zG62bR7
	0tN/P8Ri5cVXlDe+g2u1yjgj9t6WBFk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788959315;
	b=tJDetu1O3KW0ww3/BWsav2inDipe/nQ3sX+EPVEDhtGrEqGAa3ALdb8si//F7M8OsWtdiW
	wPudVUGUWSmJSDLCxHAIYg5UJ3o8JnJtVByNGG/AgdhLJNpyaiJ4ChOHh6LoDJjbE3P6ID
	khaMNXgMNpyXkV9nlGKtTfy5zPnMOuA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E2QXc9Kd;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.234 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bbsRBPS39F1qCvHS8TXrx+bY+bmKnc5cP2dNW7zwNzE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788959313; v=1; x=1789564113;
 b=E2QXc9Kdfido1pjPy4dtaU+WZvszdY1lADRjeK+e67nSqWVjMWnFs2z8Tv0OUeYpzgok+C7W
 F3lRO991HIKiWDR4SAwT83eMpa+7n44z44IS2GtKilUGlBxZaamTKytWn3DJTPRyGNmY4gSfN2r
 RDiobjQ9O4twlBVLeTZSxPSM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 04d50cffb0466e00;
	Wed, 09 Sep 2026 13:08:33 +0000
X-Mizu-Trace-ID: 04d50cffb0466e00
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v5 10/17] mm/hugetlb: switch HugeTLB to section-based
 vmemmap optimization
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <67dc7ac8-b39d-4354-8cbf-f2a1c3a369ee@kernel.org>
Date: Wed, 9 Sep 2026 21:08:16 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <82CAF33D-2482-4E8B-826D-8AF5E6FF8866@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-11-songmuchun@bytedance.com>
 <67dc7ac8-b39d-4354-8cbf-f2a1c3a369ee@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Stat-Signature: 59skkzsqwd9u1eo7n84xnfkotxzu5ewr
X-Rspam-User: 
X-Rspamd-Queue-Id: C49212000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1788959314-971009
X-HE-Meta: U2FsdGVkX19UqoJvyV+DenflEuKQ1UrzGWlWFVYQLEQ8XQWvE4lvYhCqLKvfOdp+rEW8hK9MfnEBx62xYUKNJLowg8BR12ilW7synb6Gf7e9MB1vZLjPh0QFOdSpfmqXq97bdw3IJPkz+15KOVpR5MysSEWOWUu9zawOG4T0xh1xU7BwLFAsWAed10q7tzf4Bnr1rcx0CPoijwrGEJyG65tkLMRAqxDrchDochfwhGASfLBsMtlOr1uvX2nlC+clWycVxtIWbQwdFMxnzfT4FJ2dtd/DpnozNFuqnbn+mVcZ9SAA3U4t1MZxIArIV3euag79NPd6kH2dHYx8xovtDRQv6/H49xEReGQim0TMjATszfr5ZfSWGKpYumQyjgxo0bMjopks/urrglofzeGDDP+D/5HGbGGk6L06vf8vwtO3SVZXmSCO14mhFS78yzNeAfeQAcC9UzvjEiRxyh1fqKw3vZ2rnt8Rp49TgcRl0VZs9sjzIA6IEMD7WVvWCzakz5y3AYr/RIMxqe0qERyR/RpJxO2eX/weaMWGaaz89hKQ+J068BgSf65E/qpGtX4KJcuWBYqz0k7OSdjZjocVo2GaVKA8Gl6bNw3sh77uZKsUYWP7EGCQSaxYSRzeMtC0JbaNoyXGuBeZKKxfCMVSPKuZeZvsQ8ofIeOyE+zRup4aoAmePMjrmdIG+hHcGy+eQ4vUFJaMEil2oA4DuRPCAT+Sc0qrXVWLOuAn8sgptGb+xl7CjKbY34tFyVBiXN1NnmhjKMlVAzxuBUuJVcjwB7XLj9aEyDvZhJXChAN8rIopxk6S9/AJsgzC5E/h2gb8rq+MTD55/yU23YoqYL0f0m4FPORAESQH4cCVbEL/vQw5LZeDvSx47z8Px6o8smcueKJBqkyWtR+Guq4y1CgLkMEigrm8IQOKzNQfmiXlnBsWf6Hs8f7DiM+ohYzqcIZp6ci0mloNectxidTP4Az
 l7RGe6IL
 3nxJO/CZZ2U5IAaspx1DvuxNTvftmW3sVYvUXIgh64nrtjVPa1toMpJG0cxDb6HpbAFB60rs+tkBnvzRBa5d9U8NGPk068Boz4ps+MynMFK5BwS3o/W4U2ynyGIT6YX2wIaEYUOG5JEvg5p1VO7N6GB/3j+FBhmRqOVZ2LDGYxG/GgBhEvA1nsDq0bweWuq89E5HmxLGFAHvJMsoNseaWrst04+yRrG6jvq16vXginMhaVvT/pBpn3B0dCSv/PSwJrA1DmiXaRlzC4t1WS3GtyKaoRRYYp6Y4TIc46wpdaB5kcUBiShJNqCQGX17vVhxqj1/7urHwwWLEi8/3UxEuPLtwDmefXALW/EzlNi16CRRAZxzfm/5G38TEjoLjQJE8CN2j9pvb8LvjfDU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 9, 2026, at 17:58, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 8/25/26 10:46, Muchun Song wrote:
>> HugeTLB bootmem vmemmap optimization still carries its own early =
setup
>> path, including pre-populating optimized mappings before the generic
>> sparse-vmemmap code runs.
>>=20
>> Now that the section-based vmemmap optimization can derive HugeTLB
>> vmemmap deduplication from section metadata, HugeTLB only needs to =
mark
>> the bootmem huge page range with the appropriate order. The generic
>> sparse-vmemmap population path can then allocate and map the shared =
tail
>> vmemmap pages without any HugeTLB-specific early population code.
>>=20
>> Do that by setting the section order when a bootmem huge page is
>> allocated and dropping the dedicated pre-HVO helpers and related
>> special-casing.
>>=20
>> This removes duplicate early setup logic and switches HugeTLB to the
>> section-based vmemmap optimization path.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> ---
>> v3:
>> - Use the order-based helper for the bootmem vmemmap-optimized check
>>=20
>> v2:
>> - Collect Acked-by from Mike Rapoport
>> ---
>> include/linux/hugetlb.h |  1 -
>> include/linux/mm.h      |  3 --
>> mm/hugetlb.c            | 30 ++------------
>> mm/hugetlb_vmemmap.c    | 90 =
+++--------------------------------------
>> mm/hugetlb_vmemmap.h    | 14 +++----
>> mm/sparse-vmemmap.c     | 31 --------------
>> mm/sparse.h             | 27 +++++++++++++
>> 7 files changed, 42 insertions(+), 154 deletions(-)
>=20
> Nice cleanup.
>=20
>>=20
>> diff --git a/mm/sparse.h b/mm/sparse.h
>> index e4617f9c8876..049272aba84e 100644
>> --- a/mm/sparse.h
>> +++ b/mm/sparse.h
>> @@ -16,6 +16,24 @@ static inline unsigned int section_order(const =
struct mem_section *section)
>> return section->order;
>> }
>>=20
>> +static inline void section_set_order(struct mem_section *section, =
unsigned int order)
>> +{
>> + 	VM_WARN_ON(section_order(section) && order && =
section_order(section) !=3D order);
>> + 	section->order =3D order;
>=20
> As raised previously "section order" is entirely unclear. If this is a =
compound
> page order we should spell that out.

But I also have another question. Should I also rename the helper name,
like section_set_compound_order? or it is enough to just renaming
the field name?

Thanks.

>=20
>=20
> --=20
> Cheers,
>=20
> David



