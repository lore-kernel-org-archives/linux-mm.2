Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 392C2CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 08:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D5F5940009; Fri, 19 Sep 2025 04:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0861B8E0022; Fri, 19 Sep 2025 04:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB75F940009; Fri, 19 Sep 2025 04:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C40EF8E0022
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 04:14:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78A1B59A80
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:14:29 +0000 (UTC)
X-FDA: 83905287858.05.AC37DC2
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 236634000C
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:14:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BmeGBByU;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758269667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dc53JcOzdrcUIu2iVuDKY0KAeJ//x1/I8rOfO8TAJ0E=;
	b=WOzlQ2hOH8IDLHakw5miln6Jc7b95+M6ac7TLiADXqv8UrvFMnuDUimuPboTYCip5dhoNS
	uzV5wX23wc2DkVNpKTptVgicbu5Lxpso/SPX/Utde/toi7xBPH91aZ0WmwOL1HgCD5wiOD
	I2xcJ4nSXBZrYV+OCktnsNqm2cebpNY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758269667; a=rsa-sha256;
	cv=none;
	b=F2/Cm4mvIhPDGH6UCYW9y3zmI3Cu3jMKwdjYAX2IwS0u8AOHHRVlXsYDcyDj0Pn/7j09j2
	oneOEjizyfW8CTuwnyhA4EcHYnNrEXgD3Y3KjgHJgUsD6GNfgUiVLifxWE2eeq1VwpzEOq
	sTl8NLnWUDxx5u5KBRDhR30kwTHu/bE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BmeGBByU;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <4cf41cd5-e93a-412b-b209-4180bd2d4015@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758269664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dc53JcOzdrcUIu2iVuDKY0KAeJ//x1/I8rOfO8TAJ0E=;
	b=BmeGBByUETlTGTM2SzKN9sT+aElM0iDnr9NVCQ0Y4S5LyZS5qVFjUY0/ZQhQcjxmkujkwF
	lcqoAIrEgGu+qx5juQO8M0lGpLChTPtWmm4PXKC8zXPXthowkvLtjPKwUnGPeV4fEL7kE5
	GoVQEabwufMTPdzDfKN5emTG80lC0C8=
Date: Fri, 19 Sep 2025 16:14:11 +0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <9d2c3e3e-439d-4695-b7c9-21fa52f48ced@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 236634000C
X-Stat-Signature: hmq4a1as5sxkkbc4z8g5tooos8k8pqaa
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758269666-759021
X-HE-Meta: U2FsdGVkX18xeom0NaK5gCgzvdFUjGGq3dY2t4tHKXe9VakWnTcov5AZC2UV2miJbrzI66mD47ROCluQHeF8/hH4PMRdM13/gHKd0awjKQcNVbRQIDVe27/8gfUmUQm4n/LSQY4vCxfRt+iomnVaByIpRrr2B12aWAUUgieQh0Mg9YEiiTNMSRJazpwLd8b3lkF/cNrpvH3YadtbDOQ9QSkUGPWU6t7zSWzZFYbSJlYnxFh8gWJI+nM/JcbZdbkFkr+QHfbpLZrs7YqSyacIlR0Cpv3GI5cFnUIz5wsO3c29wpvOTg0f2ZSyf1U8jKGTsmAljOA6yAIxFPSlgdh8vXyKYSOiY9zff917Er7qDXfKe/22gTlM7Ig7QVSAWdj6XjCRvpqQjgvs76woXn9zFcjo++5MR2A7D09tvpdyNFydBeSeBs9YDs/8XNOrGqFRWuv230dHfqB6g/F3rXcrkgz4kmn9OV2bl0RC6V0SleEcTCJ3j7nex1+1BuS9Xnsat69M2HfwwxfLwPQFO6uWsw0Y+Kjsw7e6N2UzCZyTacb6zH5IHc7rZlli7CpdinTyw4xsJS7Rc0rC1QWsFQd7FmaYmL4/szffAnxFX6ph+KSfGHFDrrBXxe1ZFCOkrVpfAuE3R7E2VcxEJ+obXGxmU/fmW7CrA1AMXYMx4wKUw4wkLuCg28+2o2DJ5ZX/MvKgK3IKZqFnCmd/pp4+UO6DEuZoF6i9L1WWN5EYIEkgb4osIicc+HeC6ViBqfXwPGpyPhhHdCSV9hV/+oMWTbqhnja1EvvWmj/sk5ntl8b4B8iGfD77yRXqX/FZImAy0eBfA7nNVpHeRG6F+WlmNsAHNBpAkbBEaKRRndfbT0SML45D24OIZfYTiEtWJuMfls7LKoFpsmNgSfX4SkStk8lbJNtyAG1Cd8sItOhBH9Dfvdnu7WSUCdKBTLim77DESiBSgHYL/sC10PFheqMO1p6
 eaqYpcYo
 4mIyIN4mT5kS+goN3iMcbEU2P2UDEcPGSdDApawpydP5QJvp5+xsvTyflq27b2+PP1nYwZYa4uJDpxLpqFHWDzkaE0YOn1jkgNHUU9W4pQi9QxOpstv15Oz88QHiNeH2szuN9FPKew2Erv53dmH7gXGzCyX0D+XVk8T+k9HwKm8L5ZlIizwNf/w/6s1eQ7gT1Nn6QfDfu576PZkFS0c1z5yvtW6RgIaE8BapP9OS4MK5zBUg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/19 15:55, David Hildenbrand wrote:
>>> I think where possible we really only want to identify problematic
>>> (tagged) pages and skip them. And we should either look into fixing KSM
>>> as well or finding out why KSM is not affected.
>>
>> Yeah. Seems like we could introduce a new helper,
>> folio_test_mte_tagged(struct
>> folio *folio). By default, it would return false, and architectures like
>> arm64
>> can override it.
> 
> If we add a new helper it should instead express the semantics that we 
> cannot deduplicate.

Agreed.

> 
> For THP, I recall that only some pages might be tagged. So likely we 
> want to check per page.

Yes, a per-page check would be simpler.

> 
>>
>> Looking at the code, the PG_mte_tagged flag is not set for regular THP.
> 
> I think it's supported for THP per page. Only for hugetlb we tag the 
> whole thing through the head page instead of individual pages.

Right. That's exactly what I meant.

> 
>> The MTE
>> status actually comes from the VM_MTE flag in the VMA that maps it.
>>
> 
> During the rmap walk we could check the VMA flag, but there would be no 
> way to just stop the THP shrinker scanning this page early.
> 
>> static inline bool folio_test_hugetlb_mte_tagged(struct folio *folio)
>> {
>>     bool ret = test_bit(PG_mte_tagged, &folio->flags.f);
>>
>>     VM_WARN_ON_ONCE(!folio_test_hugetlb(folio));
>>
>>     /*
>>      * If the folio is tagged, ensure ordering with a likely subsequent
>>      * read of the tags.
>>      */
>>     if (ret)
>>         smp_rmb();
>>     return ret;
>> }
>>
>> static inline bool page_mte_tagged(struct page *page)
>> {
>>     bool ret = test_bit(PG_mte_tagged, &page->flags.f);
>>
>>     VM_WARN_ON_ONCE(folio_test_hugetlb(page_folio(page)));
>>
>>     /*
>>      * If the page is tagged, ensure ordering with a likely subsequent
>>      * read of the tags.
>>      */
>>     if (ret)
>>         smp_rmb();
>>     return ret;
>> }
>>
>> contpte_set_ptes()
>>     __set_ptes()
>>         __set_ptes_anysz()
>>             __sync_cache_and_tags()
>>                 mte_sync_tags()
>>                     set_page_mte_tagged()
>>
>> Then, having the THP shrinker skip any folios that are identified as
>> MTE-tagged.
> 
> Likely we should just do something like (maybe we want better naming)
> 
> #ifndef page_is_mergable
> #define page_is_mergable(page) (true)
> #endif


Maybe something like page_is_optimizable()? Just a thought ;p

> 
> And for arm64 have it be
> 
> #define page_is_mergable(page) (!page_mte_tagged(page))
> 
> 
> And then do
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1f0813b956436..1cac9093918d6 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4251,7 +4251,8 @@ static bool thp_underused(struct folio *folio)
> 
>          for (i = 0; i < folio_nr_pages(folio); i++) {
>                  kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
> -               if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
> +               if (page_is_mergable(folio_page(folio, i)) &&
> +                   !memchr_inv(kaddr, 0, PAGE_SIZE)) {
>                          num_zero_pages++;
>                          if (num_zero_pages > khugepaged_max_ptes_none) {
>                                  kunmap_local(kaddr);
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 946253c398072..476a9a9091bd3 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -306,6 +306,8 @@ static bool try_to_map_unused_to_zeropage(struct 
> page_vma_mapped_walk *pvmw,
> 
>          if (PageCompound(page))
>                  return false;
> +       if (!page_is_mergable(page))
> +               return false;
>          VM_BUG_ON_PAGE(!PageAnon(page), page);
>          VM_BUG_ON_PAGE(!PageLocked(page), page);
>          VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);

Looks good to me!

> 
> 
> For KSM, similarly just bail out early. But still wondering if this is 
> already checked
> somehow for KSM.

+1 I'm looking for a machine to test it on.


