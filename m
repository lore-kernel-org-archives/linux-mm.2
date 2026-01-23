Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46F08D6CFC6
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 05:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A90296B03BC; Fri, 23 Jan 2026 00:00:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63336B03BE; Fri, 23 Jan 2026 00:00:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D3896B03BF; Fri, 23 Jan 2026 00:00:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AFEB6B03BC
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 00:00:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78B1013C1B6
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:33:14 +0000 (UTC)
X-FDA: 84361656708.02.AE40081
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7D77DA0003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:33:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RCqcrNqQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769135593; a=rsa-sha256;
	cv=none;
	b=qo+a1IaL4rlphNlNLAhQyiQ4qtNX4PrsYH8tASGFm2P2QZUcRsG/VZzjRtbUmZ2kr/334w
	KGz1k2GC7D+9PRtq2esOJwzdtA40/KwEeqOdLKdMYxj4zGsFNrduO7z+WviZDkkSDVThS4
	dlmQ5ysYqoy7IzmQjvYAo5PARkr19Vs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RCqcrNqQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769135592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9liem77MY2EVNcCbGxQuntRm1i5SoD+xhrv8gGumRc=;
	b=IrIDntApQOSq24uwm6s56dRf4HRKsnrT3oZfN7tVA6o8nVW8PuAESAa/ruHy0pgAOeb7i5
	aV0Km4M+1I+/xY+VVmS6nWKBMEFStxwoxQ6gddG2XbNpznFX+EV4TUoWjawRjtQEDW0REj
	Bo33+OH3VAFyTx/t5llvd+DgqALHprI=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769135589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C9liem77MY2EVNcCbGxQuntRm1i5SoD+xhrv8gGumRc=;
	b=RCqcrNqQw8gUtzKTyi0COF9Gr/0vM4ntun0ePsp6fMbOS/taKQCpbwdhoKCwV9f5NAyvqc
	+6gaVvviQZaxjaElkaAOBmTbwwhzsE76TUZi3Bz7DbAbITHYQPBFKdfym4jDkAusK8W2EZ
	DO/HOT/jz7LtcBsxh60v4FGjku8egwY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv4 07/14] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <aXJHI8El7QHXQuwT@thinkstation>
Date: Fri, 23 Jan 2026 10:32:28 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BFECEA67-90EC-444A-87A3-A220168B1B67@linux.dev>
References: <aXIaHZ5kNFelmuJi@thinkstation>
 <554FD2AA-16B5-498B-9F79-296798194DF7@linux.dev>
 <aXJHI8El7QHXQuwT@thinkstation>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7D77DA0003
X-Stat-Signature: h6rhuz1315t76exymmz3rmcboswbyy9e
X-HE-Tag: 1769135592-735066
X-HE-Meta: U2FsdGVkX19Qu5kJkj96BjF5QUku4q8Gc0MNssUmA21BSaAD5FdWm0HmIrcLCI6+f1yNnRMV+wGbewCBqfW7CTBF/SK3vV1OVx46xVszyG38XYPZoEIOGRkLevZgZ1ZW/yIV4sAJsTV7CmbEGIu5r+iZfvDl9r65aZZFErNBxwp9JsD7dBNmpvq9zWcjczx5ICeDwrZfLquf6K5g65mHT3uyMCM3dlQ0nnUip359kUpECuBrZNVcFKwubPxaFU90+PfEMCzuxB1N/aVgpv+eJ6B+g9cn+8dNehuLhmuZ5MFNgcsaUcCBzMlSDiu6aUnASufjHSWPko9jw4gOQyMwo+sugLWjw/TAtUC+GxmsWPje4Vq6l1fjJZ+Jm4ZeyHYhKc75rMMCEtKFvrLnY3KiWHd54QY50O60LAz8PSVMwUfg8GhfZXtGj1ItFXVF+B/pOOTh1xyYn6TItJk6Y3VUSv9cTdnEbZs82tOCeVgUVkYHmegDzyVHKcA4ci1tozrsD40U6LTx64lGQRa4GxqaJoLZdcxItPSPh1jH57YyW5gts5CgnXGH+H/Lgx+Pc/H6ePBaAPAawwA5ZJ7WF0ffHtaFdrvxKMU+T8QCZdm+7leDGd8fSFVt12aBxTpACVOqeW4CrH3ZzgdDTy+/yrWYxDshOrcs+YN9sOYlcDaVXsNp2Xqzf2Y2gJht8pkUd1Sa0y2dDbbN9Ca/wc3DzWeuJaBBV8UysXb+bhv1mqRvYcM/bDCSInmQG/yPAVAGPJRKge7q7fBrf5nxwkhiSUJbW4tDCbxymxiFlXtA7KRcOzBqiIf6DRyccdPo0hKCSMSZOWo43D75XzIIpIeH+jncwl6BflGVuMLsGT/w1IyD4bYPpcjjuVxaTPI1S+ZU7hHUcqClLC0XNJtgr4uJJgp4pZHkutD+jf/Q29KXkPT+85Pgych8WOYDO024641mbK74bIiZMRD+sj+nKzNf6mQ
 xV4qhlcZ
 aYXCVxPA5sWFv3kCCQm5usMy9kpqdg49lvbFS0cLrb0NKi0td7jX3p2KaDqYQS0j1b3744Hum7xdwKRww8XDZMleqJAbqvbhvr3/byDd+toYVa0JP0QfAxQjMMmtPx0xaCHjYVPl5E/T0eSmZfm23H2IaCHFKHyzcnQRmB+z3BWonXnH29DS76va6pOiObfON9AVGHZDHgCi3LXZVzZyvxga4Inifu+fIcxuq+5N2IFEet4qeJ3Mw9Zew+q+8Cywz+pDDn2qkaHy1qnIdwJvedJg7+9vQHAJ4BGPubo+DK8wNF+XX8woAK987AA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 23, 2026, at 01:59, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> On Thu, Jan 22, 2026 at 10:02:24PM +0800, Muchun Song wrote:
>>=20
>>=20
>>> On Jan 22, 2026, at 20:43, Kiryl Shutsemau <kas@kernel.org> wrote:
>>>=20
>>> =EF=BB=BFOn Thu, Jan 22, 2026 at 07:42:47PM +0800, Muchun Song =
wrote:
>>>>=20
>>>>=20
>>>>>> On Jan 22, 2026, at 19:33, Muchun Song <muchun.song@linux.dev> =
wrote:
>>>>>=20
>>>>>=20
>>>>>=20
>>>>>> On Jan 22, 2026, at 19:28, Kiryl Shutsemau <kas@kernel.org> =
wrote:
>>>>>>=20
>>>>>> On Thu, Jan 22, 2026 at 11:10:26AM +0800, Muchun Song wrote:
>>>>>>>=20
>>>>>>>=20
>>>>>>>> On Jan 22, 2026, at 00:22, Kiryl Shutsemau <kas@kernel.org> =
wrote:
>>>>>>>>=20
>>>>>>>> If page->compound_info encodes a mask, it is expected that =
memmap to be
>>>>>>>> naturally aligned to the maximum folio size.
>>>>>>>>=20
>>>>>>>> Add a warning if it is not.
>>>>>>>>=20
>>>>>>>> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, =
so the
>>>>>>>> kernel is still likely to be functional if this strict check =
fails.
>>>>>>>>=20
>>>>>>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>>>>>>> ---
>>>>>>>> include/linux/mmzone.h | 1 +
>>>>>>>> mm/sparse.c            | 5 +++++
>>>>>>>> 2 files changed, 6 insertions(+)
>>>>>>>>=20
>>>>>>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>>>>>>> index 390ce11b3765..7e4f69b9d760 100644
>>>>>>>> --- a/include/linux/mmzone.h
>>>>>>>> +++ b/include/linux/mmzone.h
>>>>>>>> @@ -91,6 +91,7 @@
>>>>>>>> #endif
>>>>>>>>=20
>>>>>>>> #define MAX_FOLIO_NR_PAGES (1UL << MAX_FOLIO_ORDER)
>>>>>>>> +#define MAX_FOLIO_SIZE (PAGE_SIZE << MAX_FOLIO_ORDER)
>>>>>>>>=20
>>>>>>>> enum migratetype {
>>>>>>>> MIGRATE_UNMOVABLE,
>>>>>>>> diff --git a/mm/sparse.c b/mm/sparse.c
>>>>>>>> index 17c50a6415c2..5f41a3edcc24 100644
>>>>>>>> --- a/mm/sparse.c
>>>>>>>> +++ b/mm/sparse.c
>>>>>>>> @@ -600,6 +600,11 @@ void __init sparse_init(void)
>>>>>>>> BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
>>>>>>>> memblocks_present();
>>>>>>>>=20
>>>>>>>> +  if (compound_info_has_mask()) {
>>>>>>>> +  WARN_ON(!IS_ALIGNED((unsigned long)pfn_to_page(0),
>>>>>>>> +     MAX_FOLIO_SIZE / sizeof(struct page)));
>>>>>>>=20
>>>>>>> I still have concerns about this. If certain architectures or =
configurations,
>>>>>>> especially when KASLR is enabled, do not meet the requirements =
during the
>>>>>>> boot stage, only specific folios larger than a certain size =
might end up with
>>>>>>> incorrect struct page entries as the system runs. How can we =
detect issues
>>>>>>> arising from either updating the struct page or making incorrect =
logical
>>>>>>> judgments based on information retrieved from the struct page?
>>>>>>>=20
>>>>>>> After all, when we see this warning, we don't know when or if a =
problem will
>>>>>>> occur in the future. It's like a time bomb in the system, isn't =
it? Therefore,
>>>>>>> I would like to add a warning check to the memory allocation =
place, for
>>>>>>> example:
>>>>>>>=20
>>>>>>> WARN_ON(!IS_ALIGNED((unsigned long)&folio->page, folio_size / =
sizeof(struct page)));
>>>>>>=20
>>>>>> I don't think it is needed. Any compound page usage would trigger =
the
>>>>>> problem. It should happen pretty early.
>>>>>=20
>>>>> Why would you think it would be discovered early? If the alignment =
of struct page
>>>>> can only meet the needs of 4M pages (i.e., the largest pages that =
buddy can
>>>>> allocate), how can you be sure that there will be a similar path =
using CMA
>>>>> early on if the system allocates through CMA in the future (after =
all, CMA
>>>>> is used much less than buddy)?
>>>=20
>>> True.
>>>=20
>>>> Suppose we are more aggressive. If the alignment requirement of =
struct page
>>>> cannot meet the needs of 2GB pages (which is an uncommon memory =
allocation
>>>> requirement), then users might not care about such a warning =
message after
>>>> the system boots. And if there is no allocation of pages greater =
than or
>>>> equal to 2GB for a period of time in the future, the system will =
have no
>>>> problems. But once some path allocates pages greater than or equal =
to 2GB,
>>>> the system will go into chaos. And by that time, the system log may =
no
>>>> longer have this warning message. Is that not the case?
>>>=20
>>> It is.
>>>=20
>>> I expect the warning to be reported early if we have configurations =
that
>>> do not satisfy the alignment requirement even in absence of the =
crash.
>>=20
>> If you=E2=80=99re saying the issue was only caught during
>> testing, keep in mind that with KASLR enabled the
>> warning is triggered at run-time; you can=E2=80=99t assume it
>> will never appear in production.
>=20
> Let's look at what architectures actually do with vmemmap.
>=20
> On 64-bit machines, we want vmemmap to be naturally aligned to
> accommodate 16GiB pages.
>=20
> Assuming 64 byte struct page, it requires 256 MiB alignment for 4K
> PAGE_SIZE, 64MiB for 16K PAGE_SIZE and 16MiB for 64K PAGE_SIZE.
>=20
> Only 3 architectures support HVO (select =
ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP):
> loongarch, riscv and x86. We should make the feature conditional to =
HVO
> to limit exposure.
>=20
> I am not sure why arm64 is not in the club.
>=20
> x86 aligns vmemmap to 1G - OK.
>=20
> loongarch aligns vmemmap to PMD_SIZE does not fit us with 4K and 16K
> PAGE_SIZE. It should be easily fixable. No KALSR.
>=20
> riscv aligns vmemmap to section size (128MiB) which is not enough.
> Again, easily fixable.
>=20

OK. After we fix all problems, I think changing WARN_ON to BUG_ON is =
fine.

> --=20
>  Kiryl Shutsemau / Kirill A. Shutemov



