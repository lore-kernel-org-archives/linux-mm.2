Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62390CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 13:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A949D8E0012; Fri, 19 Sep 2025 09:24:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6CD38E0001; Fri, 19 Sep 2025 09:24:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95B498E0012; Fri, 19 Sep 2025 09:24:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83A528E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:24:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38E76C02C2
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:24:50 +0000 (UTC)
X-FDA: 83906069940.25.300CF46
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id EC1AC40014
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:24:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BIfFOlXN;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758288288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gOx1K9W6IpgjKGBYblzlfTeW/YPQKf2lOT+ygyeGOuE=;
	b=mYvhBFvdPujl5uUoeBnH+tTRR4/L/3xPTX+o2prksP5hugeGmiaCcjsOE/IHl09QNg3idi
	MrU5e7QhuBXTvtoQn/4Y/kUY2t5QwHAOixzQctN3CQKxSTQsFS0dpIWkP2m19tYiPXBYnQ
	nm6wWQcxV1Ri4YkhOdlm2TnP1f+RkhI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BIfFOlXN;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758288288; a=rsa-sha256;
	cv=none;
	b=wlF0xlUlHuajjWzINZX5ye4EnbGM5ebr2CevxU4AIKrEdueI9X9Xc5IMNl/L/0agw6RjX1
	56YjtswRFR7vrYRyseWTDFa1wRztk5QoiqwJq7eJdPeuOoZ+mW8wipLsHPAuLKHilkFAVz
	TYLyHQKgnJQ0kwCBGU7kQLv1HN9bHyw=
Message-ID: <fd469dd5-8d4e-4169-ac7a-daeff9d2777f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758288285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gOx1K9W6IpgjKGBYblzlfTeW/YPQKf2lOT+ygyeGOuE=;
	b=BIfFOlXNLJKckdL/MG6thldIkbNraS46l3B1wrxX9pO5lr+lgmxeDsVMV/r4oPU6orzUyg
	lVuVfQEJWkvw4DKh9yV56MjDDMCZHW0rEumT7WxTmpJMH5LWtTXmZRhxunwFPexvXv6VJe
	hHKmrZJrdJbqW4qpWt+KyUmYUiWZzao=
Date: Fri, 19 Sep 2025 21:24:35 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 2/6] mm: remap unused subpages to shared zeropage when
 splitting isolated thp
Content-Language: en-US
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
 <dfb303b9-151b-49ec-b7ef-691c71bd5385@linux.dev>
 <9395a9ca-d865-42d7-9ea1-8e693e4e38e0@linux.dev>
 <ca2106a3-4bb2-4457-81af-301fd99fbef4@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <ca2106a3-4bb2-4457-81af-301fd99fbef4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EC1AC40014
X-Stat-Signature: sbwo5ogusxcz1gmn5z854orzhs5gnu4o
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758288287-349526
X-HE-Meta: U2FsdGVkX1/7g1HiqBY5USGaNebvR317Y79iKmk9GlLsiX3Odp/eWWb+LwWZFxF/rS7Dhn9LaHSZugCDP6dyLl398lMuDFMeoJGBhkhFdB9cSL/5ViTEqniizzKNt/EpUBa6IGLyZoaHPloYcV2rCTyWA883NuscRDlrjSSupfFJvdmxR7td4rkmIsH/OUul6YRfKld3IB/pujWVsH+mdyC9h7vyYIIo3f8ir8jUWkDuGPM2vtHq2jK/M262aIcvC/DxfA44oNI0zapwI+B4mKJpXYi15/2yyzFyxSWbCNJA1oPfgx5nkxpLWr/hMZ/HcAfoUGPlLbPeEnpq35A0CjdTWDN1mj1QBMroX7q0Hfvho6PVIciBi0dkajZKuAVgGYny+SYrdYzaLiL8GkZObNYIAaPeFY88R5NcIxkJVYKbyIB66MY4pLvAFCc/a1AtJkMZPt6Ir3F2whIaxl6133diLe9tFiFjewAxgPFdaVQFGe7TnP7/0+zBvlPtVs1joh3yaK9wJuYbTx7ltEL+hO8hphn2iq+kwYBXAi3FzrU13VGlXPNK6VmYqFlRhen/cPg/V7sVMweSAvP/YjqGUqqEstEhHhkp3TYUt2WaJK9nUC63dwF2jJ+gdiaIjer8vC8e1OUMNvxey9D0IiNNRowLO5uS6YCstOP1OXtL8d4G0calazs863X5zR9gJt1r4hD6v8peB3Zwbtgctdrfwt9/UyCB66vHMiEKPjRPpM/JPrx4P+qcj8P6JsNPGZBOVp5pIACoafsvVRMww2JIUCrnOWvER3qYMARCG+1Jjkso3xBqyCREOphR/GOzleYbOTJuiPTW/8LEAgcUF2gqDJXdUm71azh21axtm9WP5YfGm2sLxsOFL/XcA3N4fLIjv4TbTSFBWXg3A1TIgnoP51mLbfVok3xaZ6XzUMLppIbYw/A4d0wUv5lnmI/Dd2f5lQZkeAAvYolkuidey8X
 Eitj7mDk
 mkclWOm4WUJ3YVLKTjVdyx5/DOd26vXl9MA6G//bNI819D28jLKD88mLwnK+IPJ+Nmvi3ZwCKRP98Dp/Iw/k3jr8M5O7zm6kTn1eEK+kmYSfC4/6R0zjIFE+SERkXf8Lj49jK6xpEoHw1kOlD4tJYhBWfY8LdYZgL9iNJpv26E3WwsIZYilBALjXOZzJljxZ7RsEIGTn1Dkwc2Dss5VPIqCYJquhRNiy6pfpoCPjWFaNv5IE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/19 21:09, David Hildenbrand wrote:
> On 19.09.25 14:19, Lance Yang wrote:
>> Hey David,
>>
>> I believe I've found the exact reason why KSM skips MTE-tagged pages ;p
>>
>>>
>>>
>>> On 2025/9/19 16:14, Lance Yang wrote:
>>>>
>>>>
>>>> On 2025/9/19 15:55, David Hildenbrand wrote:
>>>>>>> I think where possible we really only want to identify problematic
>>>>>>> (tagged) pages and skip them. And we should either look into fixing
>>>>>>> KSM
>>>>>>> as well or finding out why KSM is not affected.
>>>>>>
>>>>>> Yeah. Seems like we could introduce a new helper,
>>>>>> folio_test_mte_tagged(struct
>>>>>> folio *folio). By default, it would return false, and architectures
>>>>>> like
>>>>>> arm64
>>>>>> can override it.
>>>>>
>>>>> If we add a new helper it should instead express the semantics that
>>>>> we cannot deduplicate.
>>>>
>>>> Agreed.
>>>>
>>>>>
>>>>> For THP, I recall that only some pages might be tagged. So likely we
>>>>> want to check per page.
>>>>
>>>> Yes, a per-page check would be simpler.
>>>>
>>>>>
>>>>>>
>>>>>> Looking at the code, the PG_mte_tagged flag is not set for regular 
>>>>>> THP.
>>>>>
>>>>> I think it's supported for THP per page. Only for hugetlb we tag the
>>>>> whole thing through the head page instead of individual pages.
>>>>
>>>> Right. That's exactly what I meant.
>>>>
>>>>>
>>>>>> The MTE
>>>>>> status actually comes from the VM_MTE flag in the VMA that maps it.
>>>>>>
>>>>>
>>>>> During the rmap walk we could check the VMA flag, but there would be
>>>>> no way to just stop the THP shrinker scanning this page early.
>>>>>
>>>>>> static inline bool folio_test_hugetlb_mte_tagged(struct folio *folio)
>>>>>> {
>>>>>>      bool ret = test_bit(PG_mte_tagged, &folio->flags.f);
>>>>>>
>>>>>>      VM_WARN_ON_ONCE(!folio_test_hugetlb(folio));
>>>>>>
>>>>>>      /*
>>>>>>       * If the folio is tagged, ensure ordering with a likely 
>>>>>> subsequent
>>>>>>       * read of the tags.
>>>>>>       */
>>>>>>      if (ret)
>>>>>>          smp_rmb();
>>>>>>      return ret;
>>>>>> }
>>>>>>
>>>>>> static inline bool page_mte_tagged(struct page *page)
>>>>>> {
>>>>>>      bool ret = test_bit(PG_mte_tagged, &page->flags.f);
>>>>>>
>>>>>>      VM_WARN_ON_ONCE(folio_test_hugetlb(page_folio(page)));
>>>>>>
>>>>>>      /*
>>>>>>       * If the page is tagged, ensure ordering with a likely 
>>>>>> subsequent
>>>>>>       * read of the tags.
>>>>>>       */
>>>>>>      if (ret)
>>>>>>          smp_rmb();
>>>>>>      return ret;
>>>>>> }
>>>>>>
>>>>>> contpte_set_ptes()
>>>>>>      __set_ptes()
>>>>>>          __set_ptes_anysz()
>>>>>>              __sync_cache_and_tags()
>>>>>>                  mte_sync_tags()
>>>>>>                      set_page_mte_tagged()
>>>>>>
>>>>>> Then, having the THP shrinker skip any folios that are identified as
>>>>>> MTE-tagged.
>>>>>
>>>>> Likely we should just do something like (maybe we want better naming)
>>>>>
>>>>> #ifndef page_is_mergable
>>>>> #define page_is_mergable(page) (true)
>>>>> #endif
>>>>
>>>>
>>>> Maybe something like page_is_optimizable()? Just a thought ;p
>>>>
>>>>>
>>>>> And for arm64 have it be
>>>>>
>>>>> #define page_is_mergable(page) (!page_mte_tagged(page))
>>>>>
>>>>>
>>>>> And then do
>>>>>
>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>> index 1f0813b956436..1cac9093918d6 100644
>>>>> --- a/mm/huge_memory.c
>>>>> +++ b/mm/huge_memory.c
>>>>> @@ -4251,7 +4251,8 @@ static bool thp_underused(struct folio *folio)
>>>>>
>>>>>           for (i = 0; i < folio_nr_pages(folio); i++) {
>>>>>                   kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
>>>>> -               if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
>>>>> +               if (page_is_mergable(folio_page(folio, i)) &&
>>>>> +                   !memchr_inv(kaddr, 0, PAGE_SIZE)) {
>>>>>                           num_zero_pages++;
>>>>>                           if (num_zero_pages >
>>>>> khugepaged_max_ptes_none) {
>>>>>                                   kunmap_local(kaddr);
>>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>>> index 946253c398072..476a9a9091bd3 100644
>>>>> --- a/mm/migrate.c
>>>>> +++ b/mm/migrate.c
>>>>> @@ -306,6 +306,8 @@ static bool try_to_map_unused_to_zeropage(struct
>>>>> page_vma_mapped_walk *pvmw,
>>>>>
>>>>>           if (PageCompound(page))
>>>>>                   return false;
>>>>> +       if (!page_is_mergable(page))
>>>>> +               return false;
>>>>>           VM_BUG_ON_PAGE(!PageAnon(page), page);
>>>>>           VM_BUG_ON_PAGE(!PageLocked(page), page);
>>>>>           VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
>>>>
>>>> Looks good to me!
>>>>
>>>>>
>>>>>
>>>>> For KSM, similarly just bail out early. But still wondering if this
>>>>> is already checked
>>>>> somehow for KSM.
>>>>
>>>> +1 I'm looking for a machine to test it on.
>>>
>>> Interestingly, it seems KSM is already skipping MTE-tagged pages. My 
>>> test,
>>> running on a v6.8.0 kernel inside QEMU (with MTE enabled), shows no 
>>> merging
>>> activity for those pages ...
>>
>> KSM's call to pages_identical() ultimately leads to memcmp_pages(). The
>> arm64 implementation of memcmp_pages() in arch/arm64/kernel/mte.c 
>> contains
>> a specific check that prevents merging in this case.
>>
>> try_to_merge_one_page()
>>     -> pages_identical()
>>         -> !memcmp_pages() Fails!
>>         -> replace_page()
>>
>>
>> int memcmp_pages(struct page *page1, struct page *page2)
>> {
>>     char *addr1, *addr2;
>>     int ret;
>>
>>     addr1 = page_address(page1);
>>     addr2 = page_address(page2);
>>     ret = memcmp(addr1, addr2, PAGE_SIZE);
>>
>>     if (!system_supports_mte() || ret)
>>         return ret;
>>
>>     /*
>>      * If the page content is identical but at least one of the pages is
>>      * tagged, return non-zero to avoid KSM merging. If only one of the
>>      * pages is tagged, __set_ptes() may zero or change the tags of the
>>      * other page via mte_sync_tags().
>>      */
>>     if (page_mte_tagged(page1) || page_mte_tagged(page2))
>>         return addr1 != addr2;
>>
>>     return ret;
>> }
>>
>> IIUC, if either page is MTE-tagged, memcmp_pages() intentionally returns
>> a non-zero value, which in turn causes pages_identical() to return false.
> 
> Cool, so we should likely just use that then in the shrinker code. Can 
> you send a fix?

Certainly! I'll get on that ;p

Cheers,
Lance


