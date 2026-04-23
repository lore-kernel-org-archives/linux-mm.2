Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41072FAD3EC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 02:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0056B008A; Wed, 22 Apr 2026 22:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6912A6B008C; Wed, 22 Apr 2026 22:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6946B0092; Wed, 22 Apr 2026 22:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1636B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:17:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8F2B1B7D2E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:17:58 +0000 (UTC)
X-FDA: 84688210236.21.A3CC885
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6759420003
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:17:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="b/EJECuf";
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776910675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Yl5gpUQ0/kTVgZbIhUE9Yavdt5ZXUQjjozCVUL0yP0=;
	b=TudRPTp10DFZUaTDxAdnnYIAfquuZrSrr+WuvwO0J02en7RoSMTRF8rJSop6me3sTK5yLa
	RIPC3hov1LF/ByOdaQwYNzL3UeRiQnxX3cZx2fnjaE3TpJtPlK29XtSzKSjim2m6lW8Xgz
	HTTPbQrRsLzn5LeZcnLuke1uoBA+rBc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="b/EJECuf";
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776910675; a=rsa-sha256;
	cv=none;
	b=NSrLTjhhSfZl5sVnT5z/oi++VaZ7jvFfTjA3jiEnPGzKucO96HFrxzNaWGEXYeg9DYvWWb
	J+orAwez3upetiPcx5Rp+p7mn/6fsHKXA7Fv5cKUiB3Kf6nuw7DoUwEQZCeXl70LQ1fG+Q
	sucnRZLIXwRLG/gi0DT7uDEErADWJK0=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776910673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Yl5gpUQ0/kTVgZbIhUE9Yavdt5ZXUQjjozCVUL0yP0=;
	b=b/EJECufayhtxajGQW4PznJfjd7sYzCSDHtMjXb2b8xNQSB1pU5qntYRvYaX0WZNC63JrE
	O+KFyPV20HrCEnMWvxGFL+u8VCcDINItPeNU7rqIl7g4xlnosoVzWu7KsxjBRGlYxtxrJk
	l/rl3vDAnT0rDM96adD7Mwz440krZ24=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v4 3/5] mm/sparse-vmemmap: Fix DAX vmemmap accounting with
 optimization
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <168f3ddd-de39-4896-a334-23a6fb8959e8@kernel.org>
Date: Thu, 23 Apr 2026 10:17:08 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
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
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <454BB596-DC35-4773-844C-4B32ABEEF423@linux.dev>
References: <20260422081420.4009847-1-songmuchun@bytedance.com>
 <20260422081420.4009847-4-songmuchun@bytedance.com>
 <168f3ddd-de39-4896-a334-23a6fb8959e8@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: cenodzaqt6rtm3ytwx6e6rauaq1sw4ah
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6759420003
X-HE-Tag: 1776910675-168849
X-HE-Meta: U2FsdGVkX1+HqUuugIH00cR5YN4eaf4aLWm5TrP5YcrA0A6okdAGPXao4vY5EFOLJUMUbsfrMK8z5YM+ixXxBAdRv20Qr3XActpke6iuI8U0cnf//m41sJBzubU3oL7CsU92gXEKQlTXKu8gDGM/M0ztF9QfdsPkipS0nwEaNYYpM0I35Ea2KsZLgd4axnMyZHAmnjcyZthDc+s/QJrc+papmr3o1NAtNq2g6pEClXpwvGTBkvASfdVcjGhzZQbxmEQvEV50h949ei+HkPLexP1sW1c5Rv0uSpzm51iJR0oQ3QgCpW03jVSbUOtzKHV5SfQGooLow2mWUYU5l0sPa/wxGpZTT7hydG0nC+e/hQMboPBGukjPO5EPmttlIO2x22QhaZFA8BrmWpLe9AbxMJax1g/nZM0A4vy2g+9KF9hx72g7e2MzFX2XIegV4HxMyuOvhRoOFmLge7QqPcbLMz9XUMlAN3Beb+6lzPQ7oVV6hkPKgbDtZonaoKO6937dkzEi6UWfqNfZkLTOLDpUg+AezozHmZVBsI9k+sXINUbueK2lThJlDGapa+zQBz9nd/5/S6g0UojYU7NOQeFT+255wwRxPM7CSkrN+4IMSqe9GORFpdB9XY1slASUlB2nlcrXWvttJutS7OLD+CJRWw7/CIKxHIgzHOkJkyAtqt/3D9S58d5VZRjQ0NxiEGPwh4V9pN6BfhPKe0Oy0GFAMRiRqj5b5TqbOC5mlbjJOAQe/iXwhvrKQWJ1p0WnCK0wdG7sUVoUjFVp3xhAKdKxQtQjC6qMM8RbScCXCUZ35slK8uJfToj2rt0MfF8b8EN4cg1ZIto6JO8+0g9m1Wav67HutkHgnyM3ijaSpgRwQy3R8xnSsCSzzmRH7wh/e/M+twY2AcElr5vZYFoDEPP5vXguRg8tXNCnXPr93O8GRa/QCDB4qrQCHHJeAaIj48DUAdZbgVEBWxlI3V37+7b
 I7ocWZPS
 uFVnmyHB+dEX2QOR/aaoTHLYwa0EB/8cJvHSgCLURCM7uOx2uS1AQQxUyXY+6NGoPR6LuBzBKPVPuyADeLyb7KTjLKpzblLAi8uesiHPm324RJgA9fT/uYPHLQKDAOjZe20T2qM8kT6tAP/BsIWYC0G+0ODvR/bD1af+foMDNL415lMxmJWTGD7gzzixCOkiUO2xC69I/MPAU0PgmscoJQlEqZ5Ldhll/rNyYToJAPF+2xyLEzUkCQgLcPQ+kRpWvvITwuX3EvkyHAtLeucVnGQWd1+vccpjuIKHG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 23, 2026, at 02:53, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/22/26 10:14, Muchun Song wrote:
>> When vmemmap optimization is enabled for DAX, the nr_memmap_pages
>> counter in /proc/vmstat is incorrect. The current code always =
accounts
>> for the full, non-optimized vmemmap size, but vmemmap optimization
>> reduces the actual number of vmemmap pages by reusing tail pages. =
This
>> causes the system to overcount vmemmap usage, leading to inaccurate
>> page statistics in /proc/vmstat.
>>=20
>> Fix this by introducing section_vmemmap_pages(), which returns the =
exact
>> vmemmap page count for a given pfn range based on whether =
optimization
>> is in effect.
>>=20
>> Fixes: 15995a352474 ("mm: report per-page metadata information")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> Acked-by: Oscar Salvador <osalvador@suse.de>
>> ---
>> mm/sparse-vmemmap.c | 32 ++++++++++++++++++++++++++++----
>> 1 file changed, 28 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index c208187a4b00..fcc5e0eda9e7 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -652,6 +652,29 @@ void offline_mem_sections(unsigned long =
start_pfn, unsigned long end_pfn)
>> }
>> }
>>=20
>> +static int __meminit section_vmemmap_pages(unsigned long pfn, =
unsigned long nr_pages,
>=20
> I'd have called this "section_nr_vmemmap_pages"

No problem.

>=20
>> +    struct vmem_altmap *altmap,
>> +    struct dev_pagemap *pgmap)
>=20
> Two-tab indent.

OK.

>=20
>> +{
>> + unsigned int order =3D pgmap ? pgmap->vmemmap_shift : 0;
>> + unsigned long pages_per_compound =3D 1L << order;
>=20
> 1UL
>=20
> Both can be const.

Right.

>=20
>> +
>> + VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, min(pages_per_compound,
>> + PAGES_PER_SECTION)));
>=20
> Maybe simply
>=20
> VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
> VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
>=20
> Which is more readable?

That's also quite good.

>=20
>=20
>> + 	VM_WARN_ON_ONCE(pfn_to_section_nr(pfn) !=3D =
pfn_to_section_nr(pfn + nr_pages - 1));
>> +
>> + 	if (!vmemmap_can_optimize(altmap, pgmap))
>> + 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), =
PAGE_SIZE);
>> +
>> + 	if (order < PFN_SECTION_SHIFT)
>> + 		return VMEMMAP_RESERVE_NR * nr_pages / =
pages_per_compound;
>> +
>> + 	if (IS_ALIGNED(pfn, pages_per_compound))
>> + 		return VMEMMAP_RESERVE_NR;
>> +
>=20
> I'll have to trust you on these ones :)

Thanks for your trust.

Thanks,
Muchun.

>=20
>> + return 0;
>> +}
>=20
> --=20
> Cheers,
>=20
> David



