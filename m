Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F41C0CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32BAF8E014D; Fri, 19 Sep 2025 06:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DBBB8E0053; Fri, 19 Sep 2025 06:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB198E014D; Fri, 19 Sep 2025 06:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 03FEB8E0053
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:53:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A34DA872B8
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:53:27 +0000 (UTC)
X-FDA: 83905688454.27.8E0D594
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 989FE14000E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:53:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qSYExmxV;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758279206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhpXIa44PXWsjs2uxeORCT8byyhIH3oxkQYJDXpg7eI=;
	b=S28eTAvrAXdAP9xj6+jPSaKvulMGoK3O/5GaXUFz7cKDOTdIUIwHvJP6tLAoncadObdMJw
	+XRd3LwxJ24bjoyipWdqxSiGNVttldukLbuAlM1s3/VNE6XWTqKXnmpQKGVarDhoct5gsQ
	p3kHMvs4d/JP1otPsiknw0HUTTyl6/k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758279206; a=rsa-sha256;
	cv=none;
	b=GmGq8yA+Esc/rNnQkZ1RamXS/ApiZ8cZMQfuhoupmqt/q6xqG+nO1oEN775GH7qqMpu3wV
	AdXiYTezPnYhlCJNTC8AC/vz09vN7YtjvIpkF4FD9JgQC3oJXvHEdEzm4VsfFddBTdKQ0m
	f4mLREjdZHCYejHJ36uERY4ZYZ7O/Sw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qSYExmxV;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <dfb303b9-151b-49ec-b7ef-691c71bd5385@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758279199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WhpXIa44PXWsjs2uxeORCT8byyhIH3oxkQYJDXpg7eI=;
	b=qSYExmxViT2E12srT6OQWReC8YdRSo2KFRn2DWjtAvYvVIyjqxrOdS4zegzCzFd0dCTWYY
	FSyoAUpPigDRkODuI2z4KTcOxmP/rlQ7XAhhG5HTjOvgkcoGgJsuEz6s+ivTGmAzCqQwyu
	ZWH56bQt9BjCCQCmDdrtFjEh9FVQXRM=
Date: Fri, 19 Sep 2025 18:53:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 2/6] mm: remap unused subpages to shared zeropage when
 splitting isolated thp
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
To: David Hildenbrand <david@redhat.com>
Cc: =?UTF-8?B?UXVuLXdlaSBMaW4gKOael+e+pOW0tCk=?= <Qun-wei.Lin@mediatek.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "usamaarif642@gmail.com" <usamaarif642@gmail.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "yuzhao@google.com" <yuzhao@google.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "corbet@lwn.net" <corbet@lwn.net>,
 =?UTF-8?B?QW5kcmV3IFlhbmcgKOaliuaZuuW8tyk=?= <Andrew.Yang@mediatek.com>,
 "npache@redhat.com" <npache@redhat.com>, "rppt@kernel.org"
 <rppt@kernel.org>, "willy@infradead.org" <willy@infradead.org>,
 "kernel-team@meta.com" <kernel-team@meta.com>,
 "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>,
 "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
 "cerasuolodomenico@gmail.com" <cerasuolodomenico@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "ryncsn@gmail.com" <ryncsn@gmail.com>, "surenb@google.com"
 <surenb@google.com>, "riel@surriel.com" <riel@surriel.com>,
 "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 =?UTF-8?B?Q2hpbndlbiBDaGFuZyAo5by16Yym5paHKQ==?=
 <chinwen.chang@mediatek.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 =?UTF-8?B?Q2FzcGVyIExpICjmnY7kuK3mpq4p?= <casper.li@mediatek.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 "baohua@kernel.org" <baohua@kernel.org>,
 "kaleshsingh@google.com" <kaleshsingh@google.com>,
 "zhais@google.com" <zhais@google.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
References: <20240830100438.3623486-1-usamaarif642@gmail.com>
 <20240830100438.3623486-3-usamaarif642@gmail.com>
 <a7944523fcc3634607691c35311a5d59d1a3f8d4.camel@mediatek.com>
 <434c092b-0f19-47bf-a5fa-ea5b4b36c35e@redhat.com>
 <CABzRoyYWQMFTGYgfC7N=cWMnL_+5Y05=jrMhFjBf1aKOGxzq5g@mail.gmail.com>
 <ebedc478-7519-4e30-854e-f6616a7647b0@redhat.com>
 <120445c8-7250-42e0-ad6a-978020c8fad3@linux.dev>
 <9d2c3e3e-439d-4695-b7c9-21fa52f48ced@redhat.com>
 <4cf41cd5-e93a-412b-b209-4180bd2d4015@linux.dev>
Content-Language: en-US
In-Reply-To: <4cf41cd5-e93a-412b-b209-4180bd2d4015@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: q6xwowo9dii7y7ts4xfcatxni8upauzs
X-Rspamd-Queue-Id: 989FE14000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758279205-753491
X-HE-Meta: U2FsdGVkX1+94Y1Oz2ISwikQ42BvBsLvEqXp07ExMhlci+PqxHNdodfWylwUE73MpORzEAqjZuaDzLXVTun2Cn0y6SF+RglKkoua3Psvu5S64SGgtwb6LLNIw+r1xlGs3VJDFE4OcfUQ5qijLptWrOZsGCqSgI9XdRx4zVpIxfDtcHJBgup2ExfbiG4vcozeTs8fEI7zOxhIgBL3vebcOjyZaenQAB3ZJR2MBGEXyG7XerpPnfSkESpdbcj1v94XOPG4uDVtZ/Foh8qmPGCr6D4j1c5sQJiANu5VorsJdk1f6vw0yC/hS/oFbhbMvDC5JvVR17aZATLi+PfS9XLBAbNGwf/G3Ey4xzU64Vm4qEmx+eobMK9HN5T1b8WtBoYYPw2aYpmRoFayee+bAq0+24CRkfp5ZWlVPUicPOiqPbpo8+w7V0KkzmvsdM1kp/L3Tlc71Tbj1Sa0xPdlXOpOI06RIhzdcb83day88MdEjZj4ipkIzltkTbrUE0bTy2fgQmyA4OOsJGEHpslIh5C9hNGmNUqa6qSfwxgFjcJdn3DkFeinZug7aeRPbNm6d3X9R7TuU5TTJvySwkTsYM+xgrsYTmHztx4zreCmCEQ8OJaoo8za0QYkPBGpHcojmbya1SNsdNjm5xhc1YfUm8LsdFHQPFTT6ZDF964Be/4cQCaFMR6fj+WeSFlzxuYs4fRKzyJ8L41KwGPFdexEelolPcefLQApmEcw+KjolFuofgWozzfADu9cVy/hFtvWJ9X8sHYePZ4rhKJJhV4umtDTjdT5DwKs0Zoa/sM/LuuXloOHaB9Ds1tSHWXi/WQT0RqEeva0mXoVNSLmVpBlsOmSwIOhuHUBDP/BdNKEKFKOvq7vSLzyht7LAB8ApcEfmiWez7B1c0bSjpfWFW5fZQqOZfsOX7kt0H5H9/XRpayvoDeHmC+3rgT2wukuSpYwpPgaI7dLvp982KBQaJEsrJD
 lWLx6V/2
 5Kqmbx0Er+25wTpr/08CJOug9I0c/iWwQiMejYJGgzz6kKdlnKwpENnu7Epbseh19jpGSCVHUW2nzZXzON9nLVD3OY+6J8JUc35wRHuNfrTFBqgCxVPt8fnmUSDwjQGJeGvBeR1Te5r+EwjZGxJAMFT67m/uE5j/ABrZn7lai313hMFRm8KHUxFtDapJr9qgLm/aD4ZiAqkvIK2FGU0L8Af/c23Xe1CPw6IF81IWq+tlOAJo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/19 16:14, Lance Yang wrote:
> 
> 
> On 2025/9/19 15:55, David Hildenbrand wrote:
>>>> I think where possible we really only want to identify problematic
>>>> (tagged) pages and skip them. And we should either look into fixing KSM
>>>> as well or finding out why KSM is not affected.
>>>
>>> Yeah. Seems like we could introduce a new helper,
>>> folio_test_mte_tagged(struct
>>> folio *folio). By default, it would return false, and architectures like
>>> arm64
>>> can override it.
>>
>> If we add a new helper it should instead express the semantics that we 
>> cannot deduplicate.
> 
> Agreed.
> 
>>
>> For THP, I recall that only some pages might be tagged. So likely we 
>> want to check per page.
> 
> Yes, a per-page check would be simpler.
> 
>>
>>>
>>> Looking at the code, the PG_mte_tagged flag is not set for regular THP.
>>
>> I think it's supported for THP per page. Only for hugetlb we tag the 
>> whole thing through the head page instead of individual pages.
> 
> Right. That's exactly what I meant.
> 
>>
>>> The MTE
>>> status actually comes from the VM_MTE flag in the VMA that maps it.
>>>
>>
>> During the rmap walk we could check the VMA flag, but there would be 
>> no way to just stop the THP shrinker scanning this page early.
>>
>>> static inline bool folio_test_hugetlb_mte_tagged(struct folio *folio)
>>> {
>>>     bool ret = test_bit(PG_mte_tagged, &folio->flags.f);
>>>
>>>     VM_WARN_ON_ONCE(!folio_test_hugetlb(folio));
>>>
>>>     /*
>>>      * If the folio is tagged, ensure ordering with a likely subsequent
>>>      * read of the tags.
>>>      */
>>>     if (ret)
>>>         smp_rmb();
>>>     return ret;
>>> }
>>>
>>> static inline bool page_mte_tagged(struct page *page)
>>> {
>>>     bool ret = test_bit(PG_mte_tagged, &page->flags.f);
>>>
>>>     VM_WARN_ON_ONCE(folio_test_hugetlb(page_folio(page)));
>>>
>>>     /*
>>>      * If the page is tagged, ensure ordering with a likely subsequent
>>>      * read of the tags.
>>>      */
>>>     if (ret)
>>>         smp_rmb();
>>>     return ret;
>>> }
>>>
>>> contpte_set_ptes()
>>>     __set_ptes()
>>>         __set_ptes_anysz()
>>>             __sync_cache_and_tags()
>>>                 mte_sync_tags()
>>>                     set_page_mte_tagged()
>>>
>>> Then, having the THP shrinker skip any folios that are identified as
>>> MTE-tagged.
>>
>> Likely we should just do something like (maybe we want better naming)
>>
>> #ifndef page_is_mergable
>> #define page_is_mergable(page) (true)
>> #endif
> 
> 
> Maybe something like page_is_optimizable()? Just a thought ;p
> 
>>
>> And for arm64 have it be
>>
>> #define page_is_mergable(page) (!page_mte_tagged(page))
>>
>>
>> And then do
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 1f0813b956436..1cac9093918d6 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4251,7 +4251,8 @@ static bool thp_underused(struct folio *folio)
>>
>>          for (i = 0; i < folio_nr_pages(folio); i++) {
>>                  kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
>> -               if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
>> +               if (page_is_mergable(folio_page(folio, i)) &&
>> +                   !memchr_inv(kaddr, 0, PAGE_SIZE)) {
>>                          num_zero_pages++;
>>                          if (num_zero_pages > khugepaged_max_ptes_none) {
>>                                  kunmap_local(kaddr);
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 946253c398072..476a9a9091bd3 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -306,6 +306,8 @@ static bool try_to_map_unused_to_zeropage(struct 
>> page_vma_mapped_walk *pvmw,
>>
>>          if (PageCompound(page))
>>                  return false;
>> +       if (!page_is_mergable(page))
>> +               return false;
>>          VM_BUG_ON_PAGE(!PageAnon(page), page);
>>          VM_BUG_ON_PAGE(!PageLocked(page), page);
>>          VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
> 
> Looks good to me!
> 
>>
>>
>> For KSM, similarly just bail out early. But still wondering if this is 
>> already checked
>> somehow for KSM.
> 
> +1 I'm looking for a machine to test it on.

Interestingly, it seems KSM is already skipping MTE-tagged pages. My test,
running on a v6.8.0 kernel inside QEMU (with MTE enabled), shows no merging
activity for those pages ...


