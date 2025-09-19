Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5537CCAC5A8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 12:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3338E000B; Fri, 19 Sep 2025 08:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63028E0001; Fri, 19 Sep 2025 08:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92AD08E000B; Fri, 19 Sep 2025 08:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1C88E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:44:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50822160677
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:44:32 +0000 (UTC)
X-FDA: 83905968384.03.B6E479B
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf30.hostedemail.com (Postfix) with ESMTP id D64548000E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:44:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="idiqMF/F";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758285870; a=rsa-sha256;
	cv=none;
	b=WM+xFksENv82k9uxovOwtZ4+S85M5BGceaamwAAtpQU6PQHNuW/rCT/PzExdaOht6JVcnA
	72oHcon8MIxTJSbNZh4oKTxhhokYEvJaYx84VfEJM578exxrg8bSB2/uj2Qmzxi6vwZfEI
	wMw7/TCIxtyH53tQDZ8EWKJGpaS3Rro=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="idiqMF/F";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758285870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1FLwkYOUVkwrrVHc9TlgJl3FE5qVq/cdte4SWXZgzE=;
	b=1HY4ZhmMCDozFRM74rLjNrqzu+sQ7sDwdZ/Nt6rrbqPisL/EUapfdDPkP3pLWtlG/U3uxy
	3Ipkbjv6HX3CNuIIKcP9biBjBMiEUmhlidPM2lpT/wpwsTbW2XTlOhfMv79YxAovwpzS6i
	CLaocmQz3+eR4h2E6OZ6V/w4SqPBkxA=
Message-ID: <4a67a5d5-6043-4ba4-b1ca-2b0a800aafb9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758285864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K1FLwkYOUVkwrrVHc9TlgJl3FE5qVq/cdte4SWXZgzE=;
	b=idiqMF/F2cFWSTzPsNc74ZZn7KDQsa3YohzP4Jr+GT0ZYco72PslC9P64P6ffs4UyHiL5R
	cPdWj06/LPQlVQ58Bra+5toAm06sdHVL169F5MrpE1e1ELcoUy0DJelJsqoT/eE5OLhmX2
	Cr554tR1sW2TjiYYyApiVxIMGu06lps=
Date: Fri, 19 Sep 2025 20:44:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 2/6] mm: remap unused subpages to shared zeropage when
 splitting isolated thp
Content-Language: en-US
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
 <dfb303b9-151b-49ec-b7ef-691c71bd5385@linux.dev>
 <9395a9ca-d865-42d7-9ea1-8e693e4e38e0@linux.dev>
In-Reply-To: <9395a9ca-d865-42d7-9ea1-8e693e4e38e0@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D64548000E
X-Stat-Signature: sprsxmn5c19ou7yuuuwpr44j95wtr9fb
X-Rspam-User: 
X-HE-Tag: 1758285868-958206
X-HE-Meta: U2FsdGVkX18221PlHt6XP9TUKPwVxFCT0mALyRcVoXPMuvTvAb8wzQCfeykTE1qmX73/y1Hgeuo6vq+etyaz9rNlP9fbd4qtiV9K81p7Q1HMxEl7q1SQBvVvu9r0T1lhVx8fkCyWjhYVZbF1gzMYMNmJxOc7F5b0QJzpXNvIGdJgttZKiuO2m3HdvzdyYGueVH/4VwJimfqEvG2s/aw8l1pJXS640cMbdOXW8ulQ3aYFWNiwbNBrBPKzlMrlvYSWfYjYfgY0RKdUzWPh4QhZyBABE41zv5UoW2lKZlN/hZaq/HAbfC50jby09ADTfHctFxXPEwYYgO4aK0CJGNtFCraTkRCTor/TXpJdyxHc7ZCoaEVc+tAXe003hIyGrE+PSyr03MPvxeZ+Y6k/OwIc+xS5lEoFFBpB90YY6pxloANyvaVInh6lie/sBvR+MFnurOoh/k7g5/QQ+PwVVZqfR1+hYuTZaK4vwE7f9qeAkH35b6pUJ1aZnz2h3cvxg3+9zLpWqgGeR0/jURIh0q9gzk2eiPGG6pRGX0LUVSIaDTGezyuAfJ310LsmaicvHCYtpLiFaImEtdUBkeXiBCqF+ZhkT4UDsQIjWODAU24LllikUHv0UJqffOeD7QpmMkgjH+SuPft2k5RXRhMcF0V7TQHViBmh2+LbuzRqHBOxSLCVAjig5eWcA12Mnp+tUmv+QjMfiJEbb/UKhSgTEuSrWS0RSgnUg74TcVqYDP6I5C4toJWXbAJ81tlULhZsK409laCM8ulXpl/+mzgeKb7N4hDPPviKdy2yPHfAbdYKvOMq8hi+J8BWAirsqzfq6NzIf+Vb978VRgBWCTKKOc2qpAOKykccYPwSUQmIUMjxkE6Ib2tzdX81HVZrL6hDCh3NHLya1Ib7b9yteZkxyqRyrzkHjTV7JJe+xpbA1Dgh9b65HAT9xbfxx6xOpwenz0hXazHIHm1fAVcJK6QxEia
 3az0KLA8
 OR1kfP3BIlmLjbwZy9/92i6SwAJVEDvFP5IBIZ0p95e18vrALoh8Yy5Zq8XEE0tridZT7QEkcsvql1gMx/qj00Pt0CA3IKjo5T4e2kFbsJT6fNoAaoukMTPgXIV8vfI6AWiw01jfEAxWEZZnQVMY0NwI7T/UfM8m6nKgVxHwo5WT8WtLP4VJapk+QrsEM2LJc4QkZpY2gcAQQdydV7VEFnQQ4TNhHo2bDZJb/ENwisdgf5To=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/19 20:19, Lance Yang wrote:
> Hey David,
> 
> I believe I've found the exact reason why KSM skips MTE-tagged pages ;p
> 
>>
>>
>> On 2025/9/19 16:14, Lance Yang wrote:
>>>
>>>
>>> On 2025/9/19 15:55, David Hildenbrand wrote:
>>>>>> I think where possible we really only want to identify problematic
>>>>>> (tagged) pages and skip them. And we should either look into 
>>>>>> fixing KSM
>>>>>> as well or finding out why KSM is not affected.
>>>>>
>>>>> Yeah. Seems like we could introduce a new helper,
>>>>> folio_test_mte_tagged(struct
>>>>> folio *folio). By default, it would return false, and architectures 
>>>>> like
>>>>> arm64
>>>>> can override it.
>>>>
>>>> If we add a new helper it should instead express the semantics that 
>>>> we cannot deduplicate.
>>>
>>> Agreed.
>>>
>>>>
>>>> For THP, I recall that only some pages might be tagged. So likely we 
>>>> want to check per page.
>>>
>>> Yes, a per-page check would be simpler.
>>>
>>>>
>>>>>
>>>>> Looking at the code, the PG_mte_tagged flag is not set for regular 
>>>>> THP.
>>>>
>>>> I think it's supported for THP per page. Only for hugetlb we tag the 
>>>> whole thing through the head page instead of individual pages.
>>>
>>> Right. That's exactly what I meant.
>>>
>>>>
>>>>> The MTE
>>>>> status actually comes from the VM_MTE flag in the VMA that maps it.
>>>>>
>>>>
>>>> During the rmap walk we could check the VMA flag, but there would be 
>>>> no way to just stop the THP shrinker scanning this page early.
>>>>
>>>>> static inline bool folio_test_hugetlb_mte_tagged(struct folio *folio)
>>>>> {
>>>>>     bool ret = test_bit(PG_mte_tagged, &folio->flags.f);
>>>>>
>>>>>     VM_WARN_ON_ONCE(!folio_test_hugetlb(folio));
>>>>>
>>>>>     /*
>>>>>      * If the folio is tagged, ensure ordering with a likely 
>>>>> subsequent
>>>>>      * read of the tags.
>>>>>      */
>>>>>     if (ret)
>>>>>         smp_rmb();
>>>>>     return ret;
>>>>> }
>>>>>
>>>>> static inline bool page_mte_tagged(struct page *page)
>>>>> {
>>>>>     bool ret = test_bit(PG_mte_tagged, &page->flags.f);
>>>>>
>>>>>     VM_WARN_ON_ONCE(folio_test_hugetlb(page_folio(page)));
>>>>>
>>>>>     /*
>>>>>      * If the page is tagged, ensure ordering with a likely subsequent
>>>>>      * read of the tags.
>>>>>      */
>>>>>     if (ret)
>>>>>         smp_rmb();
>>>>>     return ret;
>>>>> }
>>>>>
>>>>> contpte_set_ptes()
>>>>>     __set_ptes()
>>>>>         __set_ptes_anysz()
>>>>>             __sync_cache_and_tags()
>>>>>                 mte_sync_tags()
>>>>>                     set_page_mte_tagged()
>>>>>
>>>>> Then, having the THP shrinker skip any folios that are identified as
>>>>> MTE-tagged.
>>>>
>>>> Likely we should just do something like (maybe we want better naming)
>>>>
>>>> #ifndef page_is_mergable
>>>> #define page_is_mergable(page) (true)
>>>> #endif
>>>
>>>
>>> Maybe something like page_is_optimizable()? Just a thought ;p
>>>
>>>>
>>>> And for arm64 have it be
>>>>
>>>> #define page_is_mergable(page) (!page_mte_tagged(page))
>>>>
>>>>
>>>> And then do
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 1f0813b956436..1cac9093918d6 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -4251,7 +4251,8 @@ static bool thp_underused(struct folio *folio)
>>>>
>>>>          for (i = 0; i < folio_nr_pages(folio); i++) {
>>>>                  kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
>>>> -               if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
>>>> +               if (page_is_mergable(folio_page(folio, i)) &&
>>>> +                   !memchr_inv(kaddr, 0, PAGE_SIZE)) {
>>>>                          num_zero_pages++;
>>>>                          if (num_zero_pages > 
>>>> khugepaged_max_ptes_none) {
>>>>                                  kunmap_local(kaddr);
>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>> index 946253c398072..476a9a9091bd3 100644
>>>> --- a/mm/migrate.c
>>>> +++ b/mm/migrate.c
>>>> @@ -306,6 +306,8 @@ static bool try_to_map_unused_to_zeropage(struct 
>>>> page_vma_mapped_walk *pvmw,
>>>>
>>>>          if (PageCompound(page))
>>>>                  return false;
>>>> +       if (!page_is_mergable(page))
>>>> +               return false;
>>>>          VM_BUG_ON_PAGE(!PageAnon(page), page);
>>>>          VM_BUG_ON_PAGE(!PageLocked(page), page);
>>>>          VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
>>>
>>> Looks good to me!
>>>
>>>>
>>>>
>>>> For KSM, similarly just bail out early. But still wondering if this 
>>>> is already checked
>>>> somehow for KSM.
>>>
>>> +1 I'm looking for a machine to test it on.
>>
>> Interestingly, it seems KSM is already skipping MTE-tagged pages. My 
>> test,
>> running on a v6.8.0 kernel inside QEMU (with MTE enabled), shows no 
>> merging
>> activity for those pages ...
> 
> KSM's call to pages_identical() ultimately leads to memcmp_pages(). The
> arm64 implementation of memcmp_pages() in arch/arm64/kernel/mte.c contains
> a specific check that prevents merging in this case.
> 
> try_to_merge_one_page()
>      -> pages_identical()
>          -> !memcmp_pages() Fails!
>          -> replace_page()

Forgot to add:

memcmp_pages() is also called in other KSM paths, such as
stable_tree_search(), stable_tree_insert(), and
unstable_tree_search_insert(), effectively blocking MTE-tagged
pages from entering either of KSM's trees.

> 
> 
> int memcmp_pages(struct page *page1, struct page *page2)
> {
>      char *addr1, *addr2;
>      int ret;
> 
>      addr1 = page_address(page1);
>      addr2 = page_address(page2);
>      ret = memcmp(addr1, addr2, PAGE_SIZE);
> 
>      if (!system_supports_mte() || ret)
>          return ret;
> 
>      /*
>       * If the page content is identical but at least one of the pages is
>       * tagged, return non-zero to avoid KSM merging. If only one of the
>       * pages is tagged, __set_ptes() may zero or change the tags of the
>       * other page via mte_sync_tags().
>       */
>      if (page_mte_tagged(page1) || page_mte_tagged(page2))
>          return addr1 != addr2;
> 
>      return ret;
> }
> 
> IIUC, if either page is MTE-tagged, memcmp_pages() intentionally returns
> a non-zero value, which in turn causes pages_identical() to return false.
> 
> Cheers,
> Lance


