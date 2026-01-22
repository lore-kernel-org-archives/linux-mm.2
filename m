Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 156A0D3EE66
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 14:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 212CE6B01FB; Thu, 22 Jan 2026 09:03:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EA796B01FE; Thu, 22 Jan 2026 09:03:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1214F6B01FF; Thu, 22 Jan 2026 09:03:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F24456B01FB
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:03:16 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1CD98B6F2
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:03:16 +0000 (UTC)
X-FDA: 84359766792.10.D9B777B
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf26.hostedemail.com (Postfix) with ESMTP id 88E32140009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:03:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mH868Ya+;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769090595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ag4pvlq0Xt7bkCn3IMv0eQk3VBjXmIBsOS9DJbsrrSM=;
	b=veddgCRSgNgEmb/09C1t77RDIKMXRG8GAxSiQFVSWeamEewY29XLFS6K/tEJFCmmol6vc0
	Iafoq0P/9jAZaQy5AIzCWkjIbsKXgH0hBVSz+1t9l2RzQkh3fY9I6akA8kKpwnzWi/Ryaa
	pG8gmUWUQX7LKofk5xYy7JEWMMVeui8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mH868Ya+;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769090595; a=rsa-sha256;
	cv=none;
	b=sdzYM29N/pO6Okzao5ZuJtwEa4z0F8w+HtIPMs4p1ALI2BvXtT02QyeuSYDbSf55uQzWCO
	hkd7heIGYDDurIHozcCQSzxSfhc/IMHcMefVVVrRv1HhYaB19ljqUS/GHwhbdiTEGwBWK3
	tCiqAPlrCoz7mHMZyCNYwm7py0xujEU=
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769090592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ag4pvlq0Xt7bkCn3IMv0eQk3VBjXmIBsOS9DJbsrrSM=;
	b=mH868Ya+RRo/6e2/zo1l+T5Mc7oqXypqdF2i+4A0qDTVtEoGBoMiEizqwIhwipHS9mLGBL
	SMcC08B0UYqDuGuKkgasiPm+PUmgui+ZfuWdruFQK4mVUfpC9jgKE8NsbWgHZ2gcirlmeb
	cfA8IscdZhJOBr2jsRvWWyx5SCStBrM=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCHv4 07/14] mm/sparse: Check memmap alignment for compound_info_has_mask()
Date: Thu, 22 Jan 2026 22:02:24 +0800
Message-Id: <554FD2AA-16B5-498B-9F79-296798194DF7@linux.dev>
References: <aXIaHZ5kNFelmuJi@thinkstation>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
In-Reply-To: <aXIaHZ5kNFelmuJi@thinkstation>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3ybgg4h6f8ad3btf8g8pzz3eh8yhhfr7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 88E32140009
X-HE-Tag: 1769090594-802683
X-HE-Meta: U2FsdGVkX1/orkdI/PDtDO0BPM/Jqbx9AAZJ/GbpbzSgtDTSY/UkgA3mHdHix9vK7JLuxzbnc6J2j+QwzjOGRRr4vtjW2jXPzLGZTNmaiPaKUmntHAeT3+jCD/gwJKpodfzUC7BouEWQVkwSekb7UgUJtLjlD6+4aAyQ6brOhl2bmRkFPpfUNsgkIHXN1Le8QghM4Dbz0Akyeq8BQ8tJ8I5je0fJsE2hp/TMeG9hrvTYul732D5YLHDQ//NgTJtDoSQ5cTExx98FyZHHuCK2wz0tbuQX5pEgagFyWGC4ga6XPhsPzV/5yQig6IHjL430vQIIQxp1Yg96sCabt21oqgMRTSNxdI9zzrQF96KMMk0pCWTlq9tnrOidkk+maF4LLOnRE74saCvGes5uwx7hX8HLmDUrk8DxUng6qhPOdENzK6bY2HZWQp1gYji/7r2o1ji9eYHn8056FdnTzwsFUD3J6lu4XyBWmQCvpw7dDrL5q/Nq4RbPaWg/KZ+p6rt4ez8Ce3z7WMnhxt4m4vaYDE800AHOIyeg5Nh3bskGceds3sc96R/ncCk/y4qPJsHsE2ozoATXcotNtBrGumccaMmaAu4iKJJ1JWks8en4gGUru0MF6Aqk99sGE43zuQsNO8HA6ax60Eu4qkx+lJrp9H2NyOsoLq4T4N0ojzshh1DybOvEPp8qRwZH9BhQiGuRbEWvOYhTAW2B2aePe2wKd66KvuaSmnwkcj5MJJek0ihiot9vAiWb1a7zTdY2cLDeQWL/hl/HDeALpZMFr8CrE+62ypTZUtTiJ58yDpABskpB/ioOglu1qVGBn0A5wxqANKdTr+gSgppTZuhr4GXKr/lJeqiKUuPsximaEXX1r24iNwWSs3m6JPkFqsBf54SR+JRoVOMIx0sVCYkP0of+F+2iQh5AwLstpnbQ/OMZJLi4qqsd91Vrk+WO5TzpGsfWwfNJTeVvr/hg0JROWag
 TRN2+zaD
 5l9tj9j/NBDlxdLioUcz1dcNQAamIytlbXpHLuNEiC274jHTctGZhjCZTqrxA5VW572UB8wIWr9jx7Ey+BD9lHC5SfG2gFYG7kCkmQF/PritjGlwCIteLXYiswQB+NBvy9Ww+fDje64D1F+GSksdw6f+bGSiO0Oz93jXa18pru2DdYoB9dpIwAuIuLrDbgz/a9/pzeDdSE4HDktDCfa/D+K1ygsxoeHZVFL+In9ZsHCW6gvZjBjj21LO79eNtTbloMcuWLr7PRui7V66N7bmObJnJq3LsraAJ8r+S7YIH/6oEp3SsaKNh/0jIeQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 22, 2026, at 20:43, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> =EF=BB=BFOn Thu, Jan 22, 2026 at 07:42:47PM +0800, Muchun Song wrote:
>>=20
>>=20
>>>> On Jan 22, 2026, at 19:33, Muchun Song <muchun.song@linux.dev> wrote:
>>>=20
>>>=20
>>>=20
>>>> On Jan 22, 2026, at 19:28, Kiryl Shutsemau <kas@kernel.org> wrote:
>>>>=20
>>>> On Thu, Jan 22, 2026 at 11:10:26AM +0800, Muchun Song wrote:
>>>>>=20
>>>>>=20
>>>>>> On Jan 22, 2026, at 00:22, Kiryl Shutsemau <kas@kernel.org> wrote:
>>>>>>=20
>>>>>> If page->compound_info encodes a mask, it is expected that memmap to b=
e
>>>>>> naturally aligned to the maximum folio size.
>>>>>>=20
>>>>>> Add a warning if it is not.
>>>>>>=20
>>>>>> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so th=
e
>>>>>> kernel is still likely to be functional if this strict check fails.
>>>>>>=20
>>>>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>>>>> ---
>>>>>> include/linux/mmzone.h | 1 +
>>>>>> mm/sparse.c            | 5 +++++
>>>>>> 2 files changed, 6 insertions(+)
>>>>>>=20
>>>>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>>>>> index 390ce11b3765..7e4f69b9d760 100644
>>>>>> --- a/include/linux/mmzone.h
>>>>>> +++ b/include/linux/mmzone.h
>>>>>> @@ -91,6 +91,7 @@
>>>>>> #endif
>>>>>>=20
>>>>>> #define MAX_FOLIO_NR_PAGES (1UL << MAX_FOLIO_ORDER)
>>>>>> +#define MAX_FOLIO_SIZE (PAGE_SIZE << MAX_FOLIO_ORDER)
>>>>>>=20
>>>>>> enum migratetype {
>>>>>> MIGRATE_UNMOVABLE,
>>>>>> diff --git a/mm/sparse.c b/mm/sparse.c
>>>>>> index 17c50a6415c2..5f41a3edcc24 100644
>>>>>> --- a/mm/sparse.c
>>>>>> +++ b/mm/sparse.c
>>>>>> @@ -600,6 +600,11 @@ void __init sparse_init(void)
>>>>>> BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
>>>>>> memblocks_present();
>>>>>>=20
>>>>>> +  if (compound_info_has_mask()) {
>>>>>> +  WARN_ON(!IS_ALIGNED((unsigned long)pfn_to_page(0),
>>>>>> +     MAX_FOLIO_SIZE / sizeof(struct page)));
>>>>>=20
>>>>> I still have concerns about this. If certain architectures or configur=
ations,
>>>>> especially when KASLR is enabled, do not meet the requirements during t=
he
>>>>> boot stage, only specific folios larger than a certain size might end u=
p with
>>>>> incorrect struct page entries as the system runs. How can we detect is=
sues
>>>>> arising from either updating the struct page or making incorrect logic=
al
>>>>> judgments based on information retrieved from the struct page?
>>>>>=20
>>>>> After all, when we see this warning, we don't know when or if a proble=
m will
>>>>> occur in the future. It's like a time bomb in the system, isn't it? Th=
erefore,
>>>>> I would like to add a warning check to the memory allocation place, fo=
r
>>>>> example:
>>>>>=20
>>>>> WARN_ON(!IS_ALIGNED((unsigned long)&folio->page, folio_size / sizeof(s=
truct page)));
>>>>=20
>>>> I don't think it is needed. Any compound page usage would trigger the
>>>> problem. It should happen pretty early.
>>>=20
>>> Why would you think it would be discovered early? If the alignment of st=
ruct page
>>> can only meet the needs of 4M pages (i.e., the largest pages that buddy c=
an
>>> allocate), how can you be sure that there will be a similar path using C=
MA
>>> early on if the system allocates through CMA in the future (after all, C=
MA
>>> is used much less than buddy)?
>=20
> True.
>=20
>> Suppose we are more aggressive. If the alignment requirement of struct pa=
ge
>> cannot meet the needs of 2GB pages (which is an uncommon memory allocatio=
n
>> requirement), then users might not care about such a warning message afte=
r
>> the system boots. And if there is no allocation of pages greater than or
>> equal to 2GB for a period of time in the future, the system will have no
>> problems. But once some path allocates pages greater than or equal to 2GB=
,
>> the system will go into chaos. And by that time, the system log may no
>> longer have this warning message. Is that not the case?
>=20
> It is.
>=20
> I expect the warning to be reported early if we have configurations that
> do not satisfy the alignment requirement even in absence of the crash.

If you=E2=80=99re saying the issue was only caught during
testing, keep in mind that with KASLR enabled the
warning is triggered at run-time; you can=E2=80=99t assume it
will never appear in production.

So I don't think the administrator will notice a
warning in practice.=20

>=20
> Adding a check to the allocation path if way too high price for a
> theoretical problem.

Not theoretical. It=E2=80=99s a problem indeed. We should
 make the system works properly in production. And
 I don=E2=80=99t think it=E2=80=99s too high price, as I said only adding
 the check to CMA not buddy allocator, CMA
 allocation is not supposed to be in a hot path=20
(Please carefully read the reply plan I gave at the
 very beginning.
).=20

>=20
> --
>  Kiryl Shutsemau / Kirill A. Shutemov

