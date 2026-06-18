Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1698ACD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043A76B009D; Thu, 18 Jun 2026 11:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A936B00A0; Thu, 18 Jun 2026 11:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72AA6B00A2; Thu, 18 Jun 2026 11:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B03726B009D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:02:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38917A0178
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:02:53 +0000 (UTC)
X-FDA: 84893350626.01.3436C68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 43E4080003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:02:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nn0Fg7wy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781794971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XrWWHE7HCzMTLFEr+DmM/BCd/rCfiNn7ZrXRNKxD8sw=;
	b=3afauVxL46GGY1JsVDK5DUBsONhgbi8Xr8F9enYyNbCAvuzdgXlDTutR8d8LVCTq3R9mcN
	if5X733SJ5nvgA/rcrtesERTBmn+9clGFekVgYOItHfWm7UtWJJwBv4e6h+RU6aAGG1Whh
	5RNRj3NZOflGEcW7JUAYk+J8Q5mluLI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nn0Fg7wy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781794971;
	b=tsCXVyl2XJ9IJpxDUenDCToIph0MeyI79FPATNFBpgWUnwAcMYUA3pgW3nqtVdS5ZWm8AY
	jHCH9/KMSFeaiAbTtJhYjF4rBo1nEikx7aDEKsk9jzTJwhTVer9Ykm2gqkfAJOxeVS8f6h
	Kb0HYnEE6ZTsqsx59snf/KVYXWaOMS4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A1BB436DA;
	Thu, 18 Jun 2026 15:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883531F000E9;
	Thu, 18 Jun 2026 15:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781794970;
	bh=XrWWHE7HCzMTLFEr+DmM/BCd/rCfiNn7ZrXRNKxD8sw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Nn0Fg7wyY8Krc8YoBes8VyMbxEFBqOdnC1VrWWY8lLhEawopqw5ctiek/wuyVPLhn
	 YhqoOOiKZUd6ae/gf0tuxAQI1h2ix3dbf/n6rSJZ2b3tc6ZDhprW1FAB4furHa8I+h
	 nGJemLPnGD9FEFBsWuYUbToTJCeVHfqw1KXSibKp5L9fbZnpr+ezFjpWz65tuB1Wt1
	 5pEct+bqx3jrlKhJHBbMw6R/lrYFjjCuFlupWUvuNd1sCkdfTbNVoOCSSHOJm5Tcas
	 O5zilfFZYo8GtSuBbmoviOqXyJB43GM3cjvkQ3MvZK7U+jsBZddpI+Rb4p46wmwDmw
	 nlzYddLR5ckhQ==
Message-ID: <5942d4d2-5719-4196-af49-b35cf5f7b88d@kernel.org>
Date: Thu, 18 Jun 2026 17:02:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
Content-Language: en-US
To: Miaohe Lin <linmiaohe@huawei.com>, Jiaqi Yan <jiaqiyan@google.com>
Cc: osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com,
 hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org,
 william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev,
 liam@infradead.org, rientjes@google.com, duenwen@google.com,
 jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com,
 mhocko@suse.com, boudewijn@delta-utec.com, ljs@kernel.org,
 osalvador@kernel.org, willy@infradead.org, Zi Yan <ziy@nvidia.com>,
 harry.yoo@oracle.com
References: <20260531055829.3636554-1-jiaqiyan@google.com>
 <20260531055829.3636554-2-jiaqiyan@google.com>
 <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com>
 <45290F97-B8BD-4A9B-934E-0A122A5F3A80@nvidia.com>
 <CACw3F51hi1SAs264i0FKMbieOQhCpRQQ9s7gS_cHDYgHsqu0WQ@mail.gmail.com>
 <ce2f2cea-1451-09a4-4562-62808b1c2d93@huawei.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <ce2f2cea-1451-09a4-4562-62808b1c2d93@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 43E4080003
X-Stat-Signature: mgo4hqbarqmpy6d7pg8ie94nws6qe5ip
X-Rspam-User: 
X-HE-Tag: 1781794971-895376
X-HE-Meta: U2FsdGVkX1/nV17tqh2XiAIHPjyz5/5/zTzaLJOYK0NdKp7Hy7Ss7uqVDHv02yRzHwzuAO43H8j2rNImmRm4ESxJmPXqGFmomVn75xXWcUHbeUkuipS+7gWO8BK/YnGVnqjgF/uikBcKdN1IiuLIMFBxpeg3mtGCIGHPAQ2YVXoe1OYkZ+ieHAbAHlibJxlfEjKohRQOgj9oqf9TrXjepmWgKduS6CEaEjDRQBmBBWnB0HoeJUKpL/fLIc+zl3iXRmVmw9u9b1BTNExmV8CGLCqpOUbS/onCWtYnijDKXh9tO1ilSHcjXR1HQnf1fFo9BpiAqzuaMyor3xNpgDNOK3H5Zm+xLgxhBSn5huvlKVENPmPeLc+NoZ+oAq3CdtO6NGMrA891bWvC01Z6RZoVW++RmMd5146EnGvV7VzE9RKBsCaPB0aeklQs162rpo0MWkgIwvI1KcF90GgO9okADpX03a5GPgaKpCVn/CPl9/3Nd6nnTQfjatYVyV8ePYI90y4WXJCYjee+9n52LPr9ONfO59tk6I/weAUAjaZxgNiK1yMU0eBsrp07tBYW254/ZkA3y6SnnP6RpwvjhW2VsINafYjoYRsr+GqoP56RGHv8WhhssjGkXq94g02H7DgOSlxnn9y5pERxiWZb5ENC+KBDk2NvdbRd1snYnKqbmgJJpIjYFycv1QozXTykLYF07cKvUap5t0my7WDg+i/T34btgWPE+rKh/DB6Kn4TYdNpqN/8hdLC0iKQRij7j9DPe82OF4VnQ7Msn9Erp6nWN4g4eL28CjYLq8YpH4SpqYyxRJYF69knBdz9IkH02MbaGXYPbavPYR8PFcRdoWpULM+3VXfEfk1XS8cNxYH7+kQS3OqKMIVFG/uJN2YcmSB2kHS0CZthwsrR0pkuUTfLyTbMfRerzlip0VskdrurRosiVTkyOpLKrt/DCr2Hq0SHN/jBur6FX/3jYfydpEj
 IQGDjnru
 2fIMcywizyS/4Nsfd6k+zGWHW/233tjXy5QXwcW+KNBgGkCzVvBKrj/aUFVNi/BKJUWYfMuLt7XJXw4Jod0BqbgMidh2IAb+U7LlyT2UAV0pggSBT/LnZAYSwmHjj843+z5XG3xOQlT1ZItFyeZzDcP7BJTMPj4vTQnd+yo3ExJDBzyUV4gE/OD5DgcchRB/NZIWr4Fb5gb916Gz28N8pYkVSUmxKtMW3/2hOoGefhNQEm3GZRUtZTciIx9tZ/irP/65hEwe9v/mKR9Vjrrl2zlLybKLfbPTZv5F77T5mN+GRoyQgijvOHLrmdnSc8TttMhVDFMdyl8PlnRqtAgv26QQIi55m3mCk6XheHimSioYfVjixD8W7YdIqgJiT8tosCLxjLVOvOg7dIo0DtJHRC/nx+dknSETp/MQlkenSyDx5FQRkJnsa5uKOR+HPRtVj00wLgddG1PVOmWQ6TjGU0ZKGlJk74+F1DFbP7M8Hs7QWuuimxJj8WS2NyeIqD22PxVqZKIJR2N2sk+P0GelNPqPNiLfi+4QZBhAjcUpt9UzDYvJI/W4raZnHdColT2/NOsWigHOktPs6mKJHVfaUEJo6vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/16/26 08:53, Miaohe Lin wrote:
> On 2026/6/16 11:23, Jiaqi Yan wrote:
>> On Fri, Jun 12, 2026 at 11:34 AM Zi Yan <ziy@nvidia.com> wrote:
>>>
>>> On 8 Jun 2026, at 23:44, Miaohe Lin wrote:
>>>
>>>> On 2026/5/31 13:58, Jiaqi Yan wrote:
>>>>> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
>>>>> becomes non-HugeTLB, and it is released to buddy allocator
>>>>> as a high-order folio, e.g. a folio that contains 262144 pages
>>>>> if the folio was a 1G HugeTLB hugepage.
>>>>>
>>>>> This is problematic if the HugeTLB hugepage contained HWPoison
>>>>> subpages. In that case, since buddy allocator does not check
>>>>> HWPoison for non-zero-order folio, the raw HWPoison page can
>>>>> be given out with its buddy page and be re-used by either
>>>>> kernel or userspace.
>>>>>
>>>>> Memory failure recovery (MFR) in kernel does attempt to take
>>>>> raw HWPoison page off buddy allocator after
>>>>> dissolve_free_hugetlb_folio(). However, there is always a time
>>>>> window between dissolve_free_hugetlb_folio() frees a HWPoison
>>>>> high-order folio to buddy allocator and MFR takes HWPoison
>>>>> raw page off buddy allocator.
>>>>>
>>>>> Another similar situation is when a transparent huge page (THP)
>>>>> runs into memory failure but splitting failed. Such THP will
>>>>> eventually be released to buddy allocator when owning userspace
>>>>> processes are gone, but with certain subpages having HWPoison.
>>>>>
>>>>> One obvious way to avoid both problems is to add page sanity
>>>>> checks in page allocate or free path. However, it is against
>>>>> the past efforts to reduce sanity check overhead [1,2,3].
>>>>>
>>>>> Introduce free_has_hwpoisoned() to only free the healthy pages
>>>>> and to exclude the HWPoison ones in the high-order folio.
>>>>> The idea is to iterate through the sub-pages of the folio to
>>>>> identify contiguous ranges of healthy pages.
>>>>>
>>>>> free_has_hwpoisoned() is added in free_pages_prepare() as
>>>>> a shortcut and is only invoked if PG_has_hwpoisoned indicates
>>>>> HWPoison page exists and after checks and preparations in
>>>>> free_pages_prepare() all succeeded. free_has_hwpoisoned() then
>>>>> can re-use free_prepared_contig_range() [4] to decompose healthy
>>>>> ranges into the largest possible chunks of different orders.
>>>>> Every chunk meets the requirements to be freed via free_one_page().
>>>>>
>>>>> free_has_hwpoisoned() has linear time complexity wrt the number
>>>>> of pages in the folio. While the power-of-two decomposition
>>>>> ensures that the number of calls to the buddy allocator is
>>>>> logarithmic for each contiguous healthy range, the mandatory
>>>>> linear scan of pages to identify PageHWPoison() defines the
>>>>> overall time complexity. For a 1G hugepage having 8 HWPoison
>>>>> pages, free_has_hwpoisoned() takes around 1ms on average on
>>>>> a system having 56 Intel Skylake physical cores. This is
>>>>> 15x to the case of freeing no HWPoison page. The cost is far
>>>>> from triggering soft lockup, and fair for handling exceptional
>>>>> hardware memory errors.
>>>>>
>>>>> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
>>>>> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
>>>>> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
>>>>> [4] https://lore.kernel.org/all/20260401101634.2868165-2-usama.anjum@arm.com
>>>>>
>>>>> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>>>>
>>>> Thanks for your update. This patch looks good to me while some comments below.
>>>>
>>>>> ---
>>>>>  mm/page_alloc.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>  1 file changed, 85 insertions(+)
>>>>>
>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>> index e47679e7a9db..03df929abca6 100644
>>>>> --- a/mm/page_alloc.c
>>>>> +++ b/mm/page_alloc.c
>>>>> @@ -208,6 +208,7 @@ gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
>>>>>  unsigned int pageblock_order __read_mostly;
>>>>>  #endif
>>>>>
>>>>> +static void free_has_hwpoisoned(struct page *page, unsigned int order);
>>>>>  static void __free_pages_ok(struct page *page, unsigned int order,
>>>>>                          fpi_t fpi_flags);
>>>>>  static void reserve_highatomic_pageblock(struct page *page, int order,
>>>>> @@ -1309,6 +1310,14 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
>>>>>
>>>>>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
>>>>>
>>>>> +/*
>>>>> + * Returns
>>>>> + * - true: checks and preparations all good, caller can proceed freeing.
>>>>> + * - false: do not proceed freeing for one of the following reasons:
>>>>> + *   1. Some check failed so it is not safe to proceed freeing.
>>>>> + *   2. A compound page has some HWPoison pages. The healthy pages
>>>>> + *      are already safely freed, and the HWPoison ones isolated.
>>>>> + */
>>>>>  static __always_inline bool __free_pages_prepare(struct page *page,
>>>>>              unsigned int order, fpi_t fpi_flags)
>>>>>  {
>>>>> @@ -1317,6 +1326,15 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>>>>>      bool init = want_init_on_free();
>>>>>      bool compound = PageCompound(page);
>>>>>      struct folio *folio = page_folio(page);
>>>>> +    /*
>>>>> +     * When dealing with compound page, PG_has_hwpoisoned is cleared
>>>>> +     * with PAGE_FLAGS_SECOND. So the check must be done first.
>>>>> +     *
>>>>> +     * Note we can't exclude PG_has_hwpoisoned from PAGE_FLAGS_SECOND.
>>>>> +     * Because PG_has_hwpoisoned == PG_active, free_page_is_bad() will
>>>>> +     * confuse and complaint that the first tail page is still active.
>>>>> +     */
>>>>> +    bool should_fhh = compound && folio_test_has_hwpoisoned(folio);
>>>>>
>>>>>      if (fpi_flags & FPI_PREPARED)
>>>>>              return true;
>>>>> @@ -1443,6 +1461,16 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>>>>>
>>>>>      debug_pagealloc_unmap_pages(page, 1 << order);
>>>>>
>>>>> +    /*
>>>>> +     * After breaking down compound page and dealing with page metadata
>>>>> +     * (e.g. page owner and page alloc tags), take a shortcut if this
>>>>> +     * was a compound page containing certain HWPoison subpages.
>>>>> +     */
>>>>> +    if (should_fhh) {
>>>>> +            free_has_hwpoisoned(page, order);
>>>>> +            return false;
>>>>> +    }
>>>>
>>>> When the code reaches here, the hwpoisoned pages have passed through kernel_poison_pages,
>>>> kasan_poison_pages, kernel_init_pages, arch_free_page... These functions might write to
>>>> the hwpoisoned pages. Is it safe to do so?
>>>
>>> At least, kernel_poison_pages() writes to the page. It probably should be
>>> moved up, somewhere like above kernel_poison_pages().
>> 
>> Writing to HWPoison pages (location having memory error) is usually
>> safe, as in it doesn't cause a machine check exception. Memory
> 
> In x86, set_mce_nospec is called for hwpoisoned pages. So writing to
> HWPoison pages would cause unexpected page fault in kernel?
> 
> Thanks.

Seems we'll have to extract everything between kernel_poison_pages() and
debug_pagealloc_unmap_pages() to a function, don't call it when should_fhh
is true and instead call it in free_has_hwpoisoned() on pages that are not
HWPoison? I think it's acceptable to do it there one page at a time in order
not to complicate things as most of that stuff is debug-only and we're
handling a rare event.

