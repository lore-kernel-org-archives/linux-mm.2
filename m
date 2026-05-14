Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7792DCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B008B6B0096; Thu, 14 May 2026 04:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB10D6B0098; Thu, 14 May 2026 04:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A03E6B0099; Thu, 14 May 2026 04:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8574F6B0096
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:17:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 35B8616099E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:17:06 +0000 (UTC)
X-FDA: 84765320052.24.AA041E6
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6642840005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:17:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v0lPPCkg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778746624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zLrAoOEPFxwptypqmQTS2ICcy/5N9VlSvuD2zj/07tA=;
	b=LiF9yaEg5DlMTa0FQ2Sh/Io1vyM3ZZmBhl9ls2njJW0LMQF06y+5l1m6BkpzsIlvySVZjW
	CwTC2b+YsB2m4IDD9TDZ0Wv2dSGBzbzUsRqU2ErfOvBHtsXOc8Nu3GYdNZEPT9WP8cM1cG
	os+YfqeCKvGQ42zT/LI3pAepkH4fIDo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778746624; a=rsa-sha256;
	cv=none;
	b=sc6VA3mmvFAQLWgvJHuox3xi7ePqCuU1l5CL0zKg1B4QeIi4eZg9DrXmuln5eiHG40Qr6W
	4f21t/XHIduKI4xgGBp8ZB2tEsJg9nTSloRfbbRO+Ezc4oZjtz3GZSLAXpjOBB6TwtuNwf
	PZQ8oUKIObOgLmfgcAnuLWHPDcTs4QU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v0lPPCkg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778746622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zLrAoOEPFxwptypqmQTS2ICcy/5N9VlSvuD2zj/07tA=;
	b=v0lPPCkgev1849GW+OiWliI9YXN1+EVzWIId60Z+uglBAigKo0XkAOcmg4+zbfwEM9ovUe
	n1ZirusYynvEENdn/xkIkli/HW42I5RUhrEPLZLmywQg6fAgjw1rhGfykOgf1TM6A6ToKH
	i0ViW3SEoN+yW3QoELP2RdXU0u9VCtU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2 04/69] mm/hugetlb: Initialize gigantic bootmem hugepage
 struct pages earlier
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <agWCVeywSo5lk1Vs@localhost.localdomain>
Date: Thu, 14 May 2026 16:16:05 +0800
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
Message-Id: <19B1C90F-B268-4FA8-BF9E-4B7B6188B908@linux.dev>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-5-songmuchun@bytedance.com>
 <agWCVeywSo5lk1Vs@localhost.localdomain>
To: Oscar Salvador <osalvador@suse.de>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 6642840005
X-Rspamd-Server: rspam04
X-Stat-Signature: qg4gsqehdj5d1b5e8a5zm3ohgjrsdtf1
X-HE-Tag: 1778746624-615866
X-HE-Meta: U2FsdGVkX1+3UJ8c7WCVqqPiMmusqKfWiRrhORxdrBw9wmwn16L78WFLKcGDIuxUGjFrbmwnxLJI1WbpdpADuckn9qzyeVqsI9RSULiXM238/RgsFz8gXCctdUjX3jqlzIR3CG/xFv3tF3TVrw1AEdtD1QjoC9PythcqK5+gi6IB7lWJ5bh23WNVIUzYM31+UnMRPtCJMiz6YadgXpU4k4C+hQEB3CXCQq1SJ1aoqma25d9ga4j+Vk5N8rYOliA0MRB929NNFE+dMqmutaemA71wLD8bCTVj+CPYr3h43yMb3GCEKjzh73ei29hHeGuA2znyQqNjkXk1vsCoy5gg+po7Tci+qWD8LHFRBTJcs24VnJhrXMco6uKekQy71IyX4R3mW51hO23bC6f5tOpXviYhm0aQ1V3OhTYToQgBoO/dOxrECE+vhknl76KbxCcHbdLWJn6Kh80uFoFGDBvtzpE0SJfx4Bqd6taBZK7+3HmmxezUezOOZ9bPIop6oXexufC0lq0tfV3SRcWgkbmHz0ftbj1/p3dWRShvsINxClp/AexoGKo4YCxtbA+0NzpagcbddGNcQ3OATVIra5AwZY/w1uQSCklaTs7Kt1+9ibthzmiQ4Q9No5uYSZ0YNY9ZCy6bOqs1jzZlTsSG3k3VhOLv+mNv+WYYzc/C6V3nT1kkDfsIDpWFr25dMibiiL3SkQhaj3QzckCrEJIe6HGHlHv1jZ3hzyvTJkvVOYWOGOyHzTNCyU7gvvh9SVxj3oKJnT1lDOqptzxbwUlTTzQBZZQtUo2j7DtaEUNwJLOzQ6tvkfWzjsL32b6NT3L5dmAE5wKTkb8L7GdXPdkJxKUIZ5gg0OiAGxWOpBMm6Tr9XBqtpo5QW2BGjBzd9PR+Pqjp37E+2c/N1/FdVJlDSN5hizI20N5v+A//ZAXtDcdpzMdtiq87Y16CDkw6rmgV9WVeR4afjgA3ARi4+Z8pEHF
 dsF/8LBV
 nonUoAvaEilyJlThAUsRXnRtJbf/2a90w8glUrWFoGhNza0VGhJL82MxSJhxHbqUDGXWXbHXufoyA1Q7wQt0K9X0W1EE500JSwSNsnIczT1OqVodGc6gW7+CEtK+x3uxlSfPBhem/2NEJjqln5R6sawOgwMkELghixM0XPD9UpzRJi5Q57xT3JMitq7bT2Z/JQX8cUpn11x1DzZEzJowkSb9eA70WeFHWaIJ5CzPjwZ+oEoEBkPJ8qq1D9y8/6wyZpo4D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 14, 2026, at 16:05, Oscar Salvador <osalvador@suse.de> wrote:
>=20
> On Wed, May 13, 2026 at 09:04:32PM +0800, Muchun Song wrote:
>> Gigantic bootmem HugeTLB pages are currently initialized from =
hugetlb_init(),
>> but page_alloc_init_late() runs earlier and walks pageblocks to =
determine
>> zone contiguity.
>>=20
>> If a bootmem HugeTLB region is marked noinit, set_zone_contiguous() =
can
>> observe still-uninitialized struct pages through =
__pageblock_pfn_to_page().
>> This may not trigger an immediate failure, but it can make
>> set_zone_contiguous() compute the wrong zone contiguity state. If =
extra
>> poisoned-page checks are added in this path, such as =
PF_POISONED_CHECK()
>> in page_zone_id(), it can also trigger an early boot panic.
>>=20
>> Initialize gigantic bootmem HugeTLB struct pages from =
page_alloc_init_late(),
>> before zone contiguity is evaluated, so later page allocator setup =
only
>> sees valid struct page state. This also makes the initialization =
order
>> more natural, as struct pages should be initialized before later code
>> inspects them.
>>=20
>> Fixes: fde1c4ecf916 ("mm: hugetlb: skip initialization of gigantic =
tail struct pages if freed by HVO")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>=20
> Acked-by: Oscar Salvador <osalvador@suse.de>
>=20

Thanks.

> but
>=20
>> ---
>> include/linux/hugetlb.h | 5 +++++
>> mm/hugetlb.c            | 3 +--
>> mm/mm_init.c            | 1 +
>> 3 files changed, 7 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 93418625d3c5..52a2c30f866c 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -173,6 +173,7 @@ extern int movable_gigantic_pages __read_mostly;
>> extern int sysctl_hugetlb_shm_group __read_mostly;
>> extern struct list_head huge_boot_pages[MAX_NUMNODES];
>>=20
>> +void hugetlb_struct_page_init(void);
>=20
> we lost the hint that this only takes care of bootmem pages.

Right.

> So I think hugetlb_bootmem_struct_page_init or something like that =
would make
> it more clear?

Yes. Make sense.

Thanks,
Muchun

>=20
>=20
> --=20
> Oscar Salvador
> SUSE Labs



