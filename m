Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF939F327CD
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 09:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421A76B0089; Tue, 21 Apr 2026 05:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F97C6B0092; Tue, 21 Apr 2026 05:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335E66B0093; Tue, 21 Apr 2026 05:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 247656B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:32:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B60CA5CE2E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:32:20 +0000 (UTC)
X-FDA: 84682047240.25.6FDD17D
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id CA3E48000B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:32:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bF6yocuu;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776763939; a=rsa-sha256;
	cv=none;
	b=o3EiP/SKrIgMMHFbdv/3dscIC+gnk9vnWvsBeQEbUj+UmkZTRV8iIgjUbvJK3IkDMK6TEN
	Jip7OMbbz+4csD7uj3mi86jTwvRixqvmbhClaTI1VbCaG0a4bAv6fW0isLvKtvVNUOydto
	LWEdpykBMC9yr1srKVXTuZlMyg6xt/c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bF6yocuu;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776763939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H7VXEbbN0/EFAsyspDHjyOjj9f+YNV767eZ9TvCWrBw=;
	b=1ItEAm9Vv19Mv0NmQ7FyPDm6n8yE5lecElGL0GYdL1qAZgLXPPjPr02L8e2mP/QiehE8xx
	UtmeLB3RF1xgxinYvW/Z4xRq/HMK19YB1vqddhOfzxFAbfEL9nktm8AbRwZBI4Bp1Und7E
	dP0uvfTOw7wLhhy1+6QH8RlzgavTISQ=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776763936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H7VXEbbN0/EFAsyspDHjyOjj9f+YNV767eZ9TvCWrBw=;
	b=bF6yocuuZ5+0H8Fj7WvzL919cWKgFPNL8PdSdWurzXEOJq1H1pY/1J/qvHbN+HJ1tcyOns
	0TRyXPw7yhE8WRPiIeS845fY2+SuhVVLrT/9htCQjcZl2S2MUjm4PP27xLcp0mCQOqZcFn
	wLmMzaDq8QJtPO4YC1f8nb4g+n+Pv4E=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v3 4/4] mm/mm_init: Fix pageblock migratetype for
 ZONE_DEVICE compound pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260421022044.1217503-5-songmuchun@bytedance.com>
Date: Tue, 21 Apr 2026 17:31:36 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
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
Message-Id: <67CABBD2-FA75-40D0-909D-9B6A523CCC8C@linux.dev>
References: <20260421022044.1217503-1-songmuchun@bytedance.com>
 <20260421022044.1217503-5-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CA3E48000B
X-Stat-Signature: b6fksg363nskftbaipxszsxb6hxrhssw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776763938-375317
X-HE-Meta: U2FsdGVkX19DTCbLtV20xR8bxXc19GBwv7SRkDwcYmVRw1rRVI5Ug1uugg11kl9F8DI9m+s6Btia83TbuJvQPM5ee6YFItqAL5g3Zw2z9SbyQrXVMs7nUPUCH6lF2GC5SncyBBKOVNWa4zeeNtY68oO5T201LUcAeUezSW359z66DtamvoZCazUVi4PPWs99VXzNBn+K8C+4y0kVaZA79NNvb5cu036jClckqpsa0JejAnNtGF15HHbaxMN78G4h2Rrma9omemhgScb4mME2xXWFap95jqadkMfBDwWzKKy8dDYxz8dNn2Zd41h8EeHOAwK3ncOzk223FkmWNy01pT7upNOvdR3F1KCbZgSSKt4jbyF737s/6CiRnC2oOIS02bnOv1PKjslvSUJXcANan3jkUnP6ZLfCWUwc5lPoqT7EVyqpW1sAt6CQghJewhM18ZKY2FwuePkj6qVAFsaFwxChBihC0SDEM2kZFt2Ghn7WZrE6xFKFJ5YsWBU8KBXWmNq8NXY1sNtH/bNgYPHYLRES4aOFlr1snX6iHzFCbLbMziAm0H3EBVAxsW6bkV+iV401xyWw/2cxmdiNufuk0qny2e1mBzBd58AttSWC39nXu2C+rJSl77dCOQfPWWjaxEo2vceOIDrxUAnMQlE5SAygf2WG6MW3tDOdnq7TUOSM3NTSpuulw7+R/xrvld5/2UgKA31+gynrRZIwpjnN1MOcsmZhGIuPITq1YUjw4gLp0hu7P4qDS9emm5SIKA0ecGTmWXRjTvENN7GxKvjO0lwYY+zzRrfmNMUUR4TQrQh474+jlCCssvJIf1CSfWKzbh8w8Ygbb6ozy6irFlY9wq4L+JTkTQd9fHwujaQMFcwhgXroS68KFoqM8J8tjyqRiSBbg5WruL2PHqLhk9oWavNlPjAPZFe0UGejR3czDurji5jpw7wIS1DyxaNYWVdYzU3c8y1+XFIgoMvsx4O
 hOVryWPB
 1/XT3P2hqV5gbULuDkyu2Kly6Imun94raOi7zHZ6uHGqlpe0BoKlNkVRNBeKdhGxRzbynigyxGEhDDac8tgVOWMQcUdM0d73lqcAaIIN3Y3VL9dIgLUdXQXWigL3bkhD8ojvW115gxTi/pEAqizQ16HhR7bL7Dmh3yBoKb3CyUmZjd64dVWNvAXyHAPvO/KmUhqYW8y+y05QNV4LSHi2pcM/hHlOnfHJpWpCV9mWEyKOQWgKiUZBwkrZyxLm4lo1CBzqy7CpBpFYJtJI7oL7bMPr3x3BY0BTduu1WQ0TWdmx7VtZw9NXJIpZmKD7+8w4NEUwsc/hU5u8zxQY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 21, 2026, at 10:20, Muchun Song <songmuchun@bytedance.com> =
wrote:
>=20
> The memmap_init_zone_device() function only initializes the =
migratetype
> of the first pageblock of a compound page. If the compound page size
> exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
> subsequent pageblocks in the compound page remain uninitialized.
>=20
> Move the migratetype initialization out of __init_zone_device_page()
> and into a separate pageblock_migratetype_init_range() function. This
> iterates over the entire PFN range of the memory, ensuring that all
> pageblocks are correctly initialized.
>=20
> Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for =
compound pages")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> mm/mm_init.c | 43 ++++++++++++++++++++++++++++---------------
> 1 file changed, 28 insertions(+), 15 deletions(-)
>=20
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index f9f8e1af921c..e2d8eae23aa3 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -674,6 +674,19 @@ static inline void fixup_hashdist(void)
> static inline void fixup_hashdist(void) {}
> #endif /* CONFIG_NUMA */
>=20
> +static __meminit void pageblock_migratetype_init_range(unsigned long =
pfn,
> +       unsigned long nr_pages,
> +       int migratetype)
> +{
> + 	unsigned long end =3D pfn + nr_pages;
> +
> + 	for (pfn =3D pageblock_align(pfn); pfn < end; pfn +=3D =
pageblock_nr_pages) {
> + 		init_pageblock_migratetype(pfn_to_page(pfn), =
migratetype, false);
> + 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
> + 			cond_resched();
> + 	}
> +}

I found a positive comment from AI review:

This trigger a -Wunused-function warning when CONFIG_ZONE_DEVICE is
disabled.

I'll fix it in the next version.

Thanks.


