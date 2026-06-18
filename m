Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A79DCCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 14:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64A56B009E; Thu, 18 Jun 2026 10:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16666B009F; Thu, 18 Jun 2026 10:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903E36B00A0; Thu, 18 Jun 2026 10:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8256B009E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:52:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D655B40163
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:52:52 +0000 (UTC)
X-FDA: 84893325384.19.3766247
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 184A0A0005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:52:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iTGaeHn3;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781794371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQl5cL23P0GYGD2wyyo9fPAsutjl9AWeF0qR8niOf3M=;
	b=piQmhrGm2gvQtXfOa+LmIwPJ/AvDTvBzS4awuv1bob9E/IdUWKq8pgYC1bZOji1738O5um
	WskTYLA0GerD18qs9QIZiODXyP8k6EL0+m44p+DkbHRT0sTXwsh6NnfWFuQYXIpFcSAfKm
	NCexUTdoEWhEepWTuO4oFuTL9TP1Knw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iTGaeHn3;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781794371;
	b=dya5JWxFcnKRz+KpAlmL4OBg8FR+SUxTcVgjut5SfIJEbHOqQXwM7TpJoI02QqlIGU/8bc
	6vtKCKaZ7ni27oE5gsTRNClUa2RDPivqM+UbEjKsEqbstT3hhj165UL8vT0vvhy8HVn5Zy
	5UqtDvCDXCSpucyY/FNSC+IQsAPh9hQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E551343F92;
	Thu, 18 Jun 2026 14:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C14E1F000E9;
	Thu, 18 Jun 2026 14:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781794369;
	bh=tQl5cL23P0GYGD2wyyo9fPAsutjl9AWeF0qR8niOf3M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iTGaeHn3lzVFVErV88A+1G8OCecl/z0kDZPH/Ur2KCuwa/EgLjgsnW/4dOEgoYy5z
	 +fG4vsKpYkuhwuYtYT+yE3K8Y1AKp1r7+swOQVi6X6CJNFsCG77MDmUfUJdrFG6sWU
	 vUXaCZOMpBSuITF9iFQ5rWDLt6jO7yUgrdMwj8QU+Q6jhwq5ExryH96cCrMgNeKymE
	 76w/wiLlhERPt/CMONGBBj/Bt3EIXG0KLVooliUq5TDHUOmycuiV6viLc9gEpogBvo
	 CDTUUE13pcfm3jQhDcswB7BZKDp4BWasac49N8HHK1JJhjkyZM6zpD4rGpNDBQfRIC
	 WiSh1e1mfRlfw==
Message-ID: <db7d1c9d-3d73-4502-960c-9c2023b90471@kernel.org>
Date: Thu, 18 Jun 2026 16:52:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Jiaqi Yan <jiaqiyan@google.com>,
 Miaohe Lin <linmiaohe@huawei.com>, harry.yoo@oracle.com
Cc: osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com,
 hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org,
 william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev,
 liam@infradead.org, rientjes@google.com, duenwen@google.com,
 jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com,
 mhocko@suse.com, boudewijn@delta-utec.com, ljs@kernel.org,
 osalvador@kernel.org, willy@infradead.org
References: <20260531055829.3636554-1-jiaqiyan@google.com>
 <20260531055829.3636554-2-jiaqiyan@google.com>
 <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com>
 <45290F97-B8BD-4A9B-934E-0A122A5F3A80@nvidia.com>
 <CACw3F51hi1SAs264i0FKMbieOQhCpRQQ9s7gS_cHDYgHsqu0WQ@mail.gmail.com>
 <DJAY8RKHUO52.28U7OSO06U91J@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <DJAY8RKHUO52.28U7OSO06U91J@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 184A0A0005
X-Stat-Signature: uppur3j1garrqxp9n1xmqkuzd763wyxf
X-HE-Tag: 1781794370-225059
X-HE-Meta: U2FsdGVkX1/WGYfu0PqwKCmqG5sTiZtIiDS8puSMXjVwYcNXkt6ih+XFDejt/342vQjREtG4WYjY2j8nzJxB1eDu0rsFtCzaAFgCQd2I49LQsuZYroPSXdtaXscj4KQi0Og47fiaBMarYh8hYDPMt5bvrVkUcD126PU4g+9iHR2CommsuJJAfASFv14pGfBSz9INiEYgHyDzGdSy4/PTHxMUquSHZi4h7N6BR+5KTRLypYAaQpHOfz8CxARyGKKDgl8EYZojtOaKEhU9942t2gTwqBU5jm6K0A4CLckR1dFUw0lV1iFCwo8RSqAvdDUlEGkoGSTZdzZbVCfVLD5tZq+xR1h9Gc+YVPGCTEsNZNHoownjUi6kuNtpX53bCb1yxJDDf1LGsMsZ6ZTX91AxK3SCCxoexpghGI958YlVLuFpyUYqpyvev8TF4Y5KnchNI88PaJLeFLHWJKOnp7/bOgCGaF8AnzoULN8F3q0/loeYOGn1IsJIkF8cBiQzLBdwH0hoInQRFpUrPJHptf0tEM6jIiJqySmk6hg8Mx+1SjFXSH3D7buhRjBICgWOdLtnF/kqZGvdrbmu+/Pr9DuqvM3d5kdsBou3XvdOnPtIs0OUeBnglLOsw5E/MbZl/rk7mTzUAB1JGgt4IuoeebXpMeQ3tFFLcUYF0/YLJ07yqFskYdT8LNAY6oo2M/XBpVEmZSa/aertZdsUmjf/TC2eEYfTWB0mYjl6uHmUJsFeH3y+K/PdTUx+NoVGlqxB+aW2QFlla4zvtEPvJ4zC8EGpcEH9kWYh/z+xLY8XZtKqUKvtr+2FlcF3eYThasQ4C7rjGlx5sqv2fv7YXBqpzFlKPO98L735nEs8THQWPSJQqwuvJkNZZa7gPiSCbz6uRYqeMgvLX6L0A08cuoZv0vr+Ov8RZS4iJdEqpBSC72FeYHfdcJn/jxtpJjigV7QWgYuG6R0chapkbbHx4U9X8jx
 F0X6D/6E
 KoJwJ9MKb77CgMq2Cq0HwjJTYXN9miPuQK3kcxc4oka+vgFeLzzrbpF5tWuN3ID/DeKSEPd+oHapJGnBMgvS87V7qsd0qWOgcpFgGFHsYZzxyHap1Daa1r+l7S04hS8ukAifuKvoz6XyAnLjitNgkdWf1I7S2LmdTptRJsfghi/O1vCHIQzfD18w+HYz/e8BZqxg5YVY5v8U0bOK9UnF80erKImgrPWznonIu6CkznYLhPH+WWqdaAGE+CjfgKTq5osVd/b5O+0RzHCO4DV9s2JVtIc8hJlGBEZ0jOzYNrFdkRs/JebFZ16dAfuqAFCL9QZU8VUNRc+xYievnm7PmekNEiPMUPSuazl43gPJHBjnCPeqvdauMD5nbizV36ka3ke2j6zj+5beTZCgfcKKAY0cNYQC81b+6n3+5uAriN9wUwVyOTw8K5yGPyR14XuryaZ165XxboCwSwheoKZqq0Q/7+KH1tdskbdGCT0BxIMPN5BqsCQL4iPEWG2rjLpYCLjRZPxu2SGbN67MDQigafe0ILsXTmhwqMVIW5AHGTlq92TKLwIFfsZGgscPho6PsPYYzDkyOef4mgG1gu6E2yPf7Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 03:56, Zi Yan wrote:
> On Mon Jun 15, 2026 at 11:23 PM EDT, Jiaqi Yan wrote:
>> On Fri, Jun 12, 2026 at 11:34 AM Zi Yan <ziy@nvidia.com> wrote:
>>>
>>> On 8 Jun 2026, at 23:44, Miaohe Lin wrote:
>>>
>>> > On 2026/5/31 13:58, Jiaqi Yan wrote:
>>> >> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
>>> >> becomes non-HugeTLB, and it is released to buddy allocator
>>> >> as a high-order folio, e.g. a folio that contains 262144 pages
>>> >> if the folio was a 1G HugeTLB hugepage.
>>> >>
>>> >> This is problematic if the HugeTLB hugepage contained HWPoison
>>> >> subpages. In that case, since buddy allocator does not check
>>> >> HWPoison for non-zero-order folio, the raw HWPoison page can
>>> >> be given out with its buddy page and be re-used by either
>>> >> kernel or userspace.
>>> >>
>>> >> Memory failure recovery (MFR) in kernel does attempt to take
>>> >> raw HWPoison page off buddy allocator after
>>> >> dissolve_free_hugetlb_folio(). However, there is always a time
>>> >> window between dissolve_free_hugetlb_folio() frees a HWPoison
>>> >> high-order folio to buddy allocator and MFR takes HWPoison
>>> >> raw page off buddy allocator.
>>> >>
>>> >> Another similar situation is when a transparent huge page (THP)
>>> >> runs into memory failure but splitting failed. Such THP will
>>> >> eventually be released to buddy allocator when owning userspace
>>> >> processes are gone, but with certain subpages having HWPoison.
>>> >>
>>> >> One obvious way to avoid both problems is to add page sanity
>>> >> checks in page allocate or free path. However, it is against
>>> >> the past efforts to reduce sanity check overhead [1,2,3].
>>> >>
>>> >> Introduce free_has_hwpoisoned() to only free the healthy pages
>>> >> and to exclude the HWPoison ones in the high-order folio.
>>> >> The idea is to iterate through the sub-pages of the folio to
>>> >> identify contiguous ranges of healthy pages.
>>> >>
>>> >> free_has_hwpoisoned() is added in free_pages_prepare() as
>>> >> a shortcut and is only invoked if PG_has_hwpoisoned indicates
>>> >> HWPoison page exists and after checks and preparations in
>>> >> free_pages_prepare() all succeeded. free_has_hwpoisoned() then
>>> >> can re-use free_prepared_contig_range() [4] to decompose healthy
>>> >> ranges into the largest possible chunks of different orders.
>>> >> Every chunk meets the requirements to be freed via free_one_page().
>>> >>
>>> >> free_has_hwpoisoned() has linear time complexity wrt the number
>>> >> of pages in the folio. While the power-of-two decomposition
>>> >> ensures that the number of calls to the buddy allocator is
>>> >> logarithmic for each contiguous healthy range, the mandatory
>>> >> linear scan of pages to identify PageHWPoison() defines the
>>> >> overall time complexity. For a 1G hugepage having 8 HWPoison
>>> >> pages, free_has_hwpoisoned() takes around 1ms on average on
>>> >> a system having 56 Intel Skylake physical cores. This is
>>> >> 15x to the case of freeing no HWPoison page. The cost is far
>>> >> from triggering soft lockup, and fair for handling exceptional
>>> >> hardware memory errors.
>>> >>
>>> >> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
>>> >> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
>>> >> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
>>> >> [4] https://lore.kernel.org/all/20260401101634.2868165-2-usama.anjum@arm.com
>>> >>
>>> >> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>>> >
>>> > Thanks for your update. This patch looks good to me while some comments below.
>>> >
>>> >> ---
>>> >>  mm/page_alloc.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++
>>> >>  1 file changed, 85 insertions(+)
>>> >>
>>> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> >> index e47679e7a9db..03df929abca6 100644
>>> >> --- a/mm/page_alloc.c
>>> >> +++ b/mm/page_alloc.c
>>> >> @@ -208,6 +208,7 @@ gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
>>> >>  unsigned int pageblock_order __read_mostly;
>>> >>  #endif
>>> >>
>>> >> +static void free_has_hwpoisoned(struct page *page, unsigned int order);
>>> >>  static void __free_pages_ok(struct page *page, unsigned int order,
>>> >>                          fpi_t fpi_flags);
>>> >>  static void reserve_highatomic_pageblock(struct page *page, int order,
>>> >> @@ -1309,6 +1310,14 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
>>> >>
>>> >>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
>>> >>
>>> >> +/*
>>> >> + * Returns
>>> >> + * - true: checks and preparations all good, caller can proceed freeing.
>>> >> + * - false: do not proceed freeing for one of the following reasons:
>>> >> + *   1. Some check failed so it is not safe to proceed freeing.
>>> >> + *   2. A compound page has some HWPoison pages. The healthy pages
>>> >> + *      are already safely freed, and the HWPoison ones isolated.
>>> >> + */
>>> >>  static __always_inline bool __free_pages_prepare(struct page *page,
>>> >>              unsigned int order, fpi_t fpi_flags)
>>> >>  {
>>> >> @@ -1317,6 +1326,15 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>>> >>      bool init = want_init_on_free();
>>> >>      bool compound = PageCompound(page);
>>> >>      struct folio *folio = page_folio(page);
>>> >> +    /*
>>> >> +     * When dealing with compound page, PG_has_hwpoisoned is cleared
>>> >> +     * with PAGE_FLAGS_SECOND. So the check must be done first.
>>> >> +     *
>>> >> +     * Note we can't exclude PG_has_hwpoisoned from PAGE_FLAGS_SECOND.
>>> >> +     * Because PG_has_hwpoisoned == PG_active, free_page_is_bad() will
>>> >> +     * confuse and complaint that the first tail page is still active.
>>> >> +     */
>>> >> +    bool should_fhh = compound && folio_test_has_hwpoisoned(folio);
>>> >>
>>> >>      if (fpi_flags & FPI_PREPARED)
>>> >>              return true;
>>> >> @@ -1443,6 +1461,16 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>>> >>
>>> >>      debug_pagealloc_unmap_pages(page, 1 << order);
>>> >>
>>> >> +    /*
>>> >> +     * After breaking down compound page and dealing with page metadata
>>> >> +     * (e.g. page owner and page alloc tags), take a shortcut if this
>>> >> +     * was a compound page containing certain HWPoison subpages.
>>> >> +     */
>>> >> +    if (should_fhh) {
>>> >> +            free_has_hwpoisoned(page, order);
>>> >> +            return false;
>>> >> +    }
>>> >
>>> > When the code reaches here, the hwpoisoned pages have passed through kernel_poison_pages,
>>> > kasan_poison_pages, kernel_init_pages, arch_free_page... These functions might write to
>>> > the hwpoisoned pages. Is it safe to do so?
>>>
>>> At least, kernel_poison_pages() writes to the page. It probably should be
>>> moved up, somewhere like above kernel_poison_pages().
>>
>> Writing to HWPoison pages (location having memory error) is usually
>> safe, as in it doesn't cause a machine check exception. Memory
>> controller usually just fails the write op and waits for the next read
>> to raise the MCE / exception for prevent silent data corruption.
>>
>>>
>>> I do not like the shortcut method, since the pages are freed in
>>> __free_pages_prepare(). This causes confusion. One alternative I can think
>>
>> What exactly is the confusion? or why does freeing has to be done by
>> __free_pages_prepare()'s caller?
>>
>> Harry suggested the shortcut method [1]. Although freeing inline might
>> surprise the caller, it simplifies things for all callers.
>>
>> [1] https://lore.kernel.org/linux-mm/aVy7L-3pc4JUYBEn@hyeyoo
> 
> The function name is __free_pages_prepare(), but the code ends up with
> freeing the pages if the folio has HWPoison.

It might free some, or leak some (already before this patch). Seems to me
really the only important part for the caller is if it can proceed freeing
or not.

>>
>>> of is to make __free_pages_prepare() returns a enum
>>> { FREE_PAGE_PREPARE_SUCCESS, FREE_PAGE_PREPARE_FAIL, FREE_PAGE_PREPARE_HAS_HWPOISON}
>>> and handle the return value in the caller.

Until the callers need to distinguish that, it sounds like an unnecessary
complication to me.

>> Are you worried that a caller of __free_pages_prepare() may see false
>> returned in the has_hwpoison case, but mistakenly propagate some kind
>> of error, or doing something under the assumption that folio not
>> freed? In this case the three enums can be useful. But I checked
>> current callers of __free_pages_prepare() and they don't have the
>> above problem.
> 
> Right. Looking at compaction_free() code, if dst gets has_hwpoison (not
> possible now, but if in the future migration code decides to mark folios
> when copy fails with EHWPOISON), the next list_add() is going to cause

I think we should fix compaction_free() (as a separate patch preceding this
one) to not proceed if prepare returns false. It could in theory already
happen before this patch due to a random memory corruption of struct page
causing some of the existing checks to fail.

> trouble. Or you can rename the function to
> __free_pages_prepare_and_free_has_hwpoison()? At least, caller knows the
> potential side effect.

Uh that's long. All callers are from PAGE ALLOCATOR mm-subsystem, it's not a
driver API so we'll know what we're doing (famous last words :)

