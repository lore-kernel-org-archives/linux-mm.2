Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66210C5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7936A6B0161; Tue, 18 Aug 2026 05:07:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76DA16B0163; Tue, 18 Aug 2026 05:07:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681BF6B0166; Tue, 18 Aug 2026 05:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 364856B0161
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:07:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCE9116093C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:07:05 +0000 (UTC)
X-FDA: 85113810810.09.737C075
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf07.hostedemail.com (Postfix) with ESMTP id C85E240004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:07:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Pwradp7i;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787044023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OUmQzs8imz/cxJgfjhdMM5XOnPvU68WAXE5zrkkXS0Q=;
	b=L9fF8ot90YBqMq00Ih1G2h0fmfRgF7ccbdCkDe+5AY8jOSWjpdhN+JkVsBXYLzDEflWf+v
	nUkdsN5Yd+WSOABXxFptflV26H2PiZLQ0UDqk8vuPlC24n8dfQ2diUrR7Y7hxD5iYkiaYa
	VE0wSI62TCtnpQccU2gaWlo3UW7lKX4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Pwradp7i;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787044023;
	b=TV3x1TO7ChuElz3p8+kRm4iO3xgEGuPaCiJTK4mfS4pNQGVUl9lwJnBOJeAVTLXqAIGACx
	+opb2jhTypbpXwhSfbJxHYtqY0U24Bd8LTYO7IRCaBjLy7Mzfz1oMGY/sqggxE3s5ZlWV6
	hPRwqGuvpCKsfEI7qahYcZb02auDH8U=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OUmQzs8imz/cxJgfjhdMM5XOnPvU68WAXE5zrkkXS0Q=;
	b=Pwradp7iCtV9l0a3R0vCZDtP6ReAzqUBTqUY3M03OC6hUoXQa6x17MXUppagkfe0ZEhOUbI/p
	nQDm96w2WikjWdQvEhgoBpu62fkrJBRpbmaEKOCFf2+r4RZ++1/CF1b7ZB0PHbfP/i5cWYM60uc
	8VRtaosH3NkI3Sr6rXVO9Hc=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hPNqV0dlJz1T4Mc;
	Tue, 18 Aug 2026 16:56:54 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 016A14058C;
	Tue, 18 Aug 2026 17:06:53 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Aug 2026 17:06:52 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Aug 2026 17:06:51 +0800
Subject: Re: [PATCH v6 4/5] mm/memory-failure: skip take_page_off_buddy after
 dissolving HWPoison HugeTLB page
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <osalvador@kernel.org>, <willy@infradead.org>, <osalvador@suse.de>,
	<jackmanb@google.com>, <hannes@cmpxchg.org>, <nao.horiguchi@gmail.com>,
	<david@kernel.org>, <william.roche@oracle.com>, <tony.luck@intel.com>,
	<wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
	<akpm@linux-foundation.org>, <muchun.song@linux.dev>, <liam@infradead.org>,
	<rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <shuah@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <boudewijn@delta-utec.com>, <ljs@kernel.org>,
	<ziy@nvidia.com>, <vbabka@kernel.org>
References: <20260705180714.3708947-1-jiaqiyan@google.com>
 <20260705180714.3708947-5-jiaqiyan@google.com>
 <c5d4a1e4-cc3f-5cee-2ec3-53d5eb01bbb2@huawei.com>
 <CACw3F52RfFR4gZ9+kAmi6fkq39t6Sk1oUW0jqiXOFAAgn0iOyQ@mail.gmail.com>
 <d908b3d6-e3db-6eaf-100f-ffc1dd765c55@huawei.com>
 <CACw3F537_QTg8eax-aB2jDv+tEqgg8GqsP=T9wEfpH+zNttanw@mail.gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <b7319726-4621-1896-07d0-f83a7fc37258@huawei.com>
Date: Tue, 18 Aug 2026 17:06:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CACw3F537_QTg8eax-aB2jDv+tEqgg8GqsP=T9wEfpH+zNttanw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Queue-Id: C85E240004
X-Rspamd-Server: rspam07
X-Stat-Signature: fa6zoghzaooop9weohxeh991uuzs7jkj
X-HE-Tag: 1787044022-34426
X-HE-Meta: U2FsdGVkX19cVzS2LVAdFSwA9xTM6zRE9AKls0e8AWG9clQvfZrSjIgE9NyHXzkz8NSXtb8VvlrDyYZ2SgmwHKUWTMRUSRc9zhhN1oekgfieZdb3udAm8vckxVL5JEekR2aXWXii/aXlN3ufolDsPr0G0RfXOWjf+qiQH720gxGKMBhTyxhPm6rG8wTAO+6ZBzTWQwE2tQYo/wiui8d4H3/JWMLPVh6Zpo+kd/CF0G23Jx8lVugEk8jt0EvllImZMgjl3pgH6QeS05MGncohqlWTfBvLExIq3HyO7wy7In2Xw9qFRRLvpSup3j6ICOahj8clD4rQWNS9Hve0iYo9Bu7pW8FzqFxik8T28BSBI/XD3lWnIJN/Ezr3238esLAIu443F+aWsTG3/WVvrPrKlxPXOw1gWeAU6/RuOA2JdctodG5T2LUueH7W657TDhaFWwupP3H8ciLTGYHIKk8dO+/2t/1RXaWBFQlcZDNMB5QUcdJ5M2yiSpMzRSxkRw7BIqdSQtKRyMBNzDc0vq4cS1pw/C2jpoII8+PGowV4s1U13Fw0P/vDh5Q/QyeEjSR9NV8HNHXAe19w+kbO68fBZpPhg9XLoy30KrIOmspTWASbPgBGAZW8jvU/xUrmAHkkEjRQhDuXMdJsS2JrHJD3fOgIg1uEUgMojfcl86fad8rVrxjC0tKb3g2leSXeywKr9wXQZvVSFWrw0EMMQ+BqQmU+wX53mNoxNn6ruqUVMEELID4Ew1dv/WoWW36PrXh9p6Q4K+fchQLl1YcMRUZ5No5/uU2gLlKC+zkUPxatpINl9nFE8WWCr28EIG/L03BLJrxkVBN6qi14Vb+6cwvA8nfdMtqpqSpEJgXJPGcwvXSvyo8OMcsYEJ/oviLEHAJ4NedxJvPc7dGYW+wX8IvMDCNQD9QqMG8ZhX/3Z6NwksU4zIz1W79lF9DDKumy8rgq+MiKvVyOXzY2PTF8xkH
 QCw7n5nC
 PQCIXVEjImheimwDyUCh4hOk823iUHVwn+G9J06nvjKtnI4yP9Cl5OwK6pb+DjjQXgElCBd6lUzKox0agaBLicEcwi2c4ZoAukiHdBRgXDAoRZC2MSuVL9YztvFvJNcuA0nquDRqEgoiF5YLvdmzQXfaprRslunO6PpF73EdkNnGPgJgrf3wEiOMckF5hZ1fI/5l/j+ZSkG8mp9ofPoWqR1CcRAZvn2/NdETqwldB612KX3+vbcufEOKqlC8bdX2ndfyLlpAedmSbN1JgiuAjfsg0XbEFTBHJkhSzXPsp/kilGFPPjUPeYtRvhymYCd1tN74scnRi8IFuzfmBl16yLCIx4ykXqOj2dfEx93adpaSRunnoYA6Wsm35RSUi6GAO12acQTee54W1BFRNpXK60gEj4ZU4T/hGe2M5Vf/w4BeDr0YCesv6gdU8TRCrCVvpUkHlTj8WIsHqxJCwo+lNpHdd8BK1QS/stpLH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/18 11:30, Jiaqi Yan wrote:
> On Mon, Aug 17, 2026 at 12:23 AM Miaohe Lin <linmiaohe@huawei.com> wrote:
>>
>> On 2026/8/17 8:29, Jiaqi Yan wrote:
>>> On Fri, Jul 17, 2026 at 12:37 AM Miaohe Lin <linmiaohe@huawei.com> wrote:
>>>>
>>>> On 2026/7/6 2:07, Jiaqi Yan wrote:
>>>>> Now that HWPoison subpage(s) within HugeTLB page will be rejected by
>>>>> buddy allocator during dissolve_free_hugetlb_folio(), there is no
>>>>> need to drain_all_pages() and take_page_off_buddy() anymore. In fact,
>>>>> calling take_page_off_buddy() after dissolve_free_hugetlb_folio()
>>>>> succeeded returns false, making caller think __page_handle_poison()
>>>>> failed.
>>>>>
>>>>> Add __hugepage_handle_poison() and replace __page_handle_poison() at
>>>>> HugeTLB specific call sites. The being handled HugeTLB page either
>>>>> is free at the moment of try_memory_failure_hugetlb(), or becomes
>>>>> free at the moment of me_huge_page().
>>>>>
>>>>> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>>>>> ---
>>>>>  mm/memory-failure.c | 36 ++++++++++++++++++++++++++++++------
>>>>>  1 file changed, 30 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>>>> index 3d15b4c1b694..a37b67550718 100644
>>>>> --- a/mm/memory-failure.c
>>>>> +++ b/mm/memory-failure.c
>>>>> @@ -174,6 +174,30 @@ static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
>>>>>  static DEFINE_MUTEX(pfn_space_lock);
>>>>>
>>>>>  /*
>>>>> + * Only for a HugeTLB page being handled by memory_failure(). The key
>>>>> + * difference to soft_offline() is that, no HWPoison subpage will make
>>>>> + * into buddy allocator after a successful dissolve_free_hugetlb_folio(),
>>>>> + * so take_page_off_buddy() is unnecessary.
>>>>> + */
>>>>> +static int __hugepage_handle_poison(struct page *page)
>>>>> +{
>>>>> +     struct folio *folio = page_folio(page);
>>>>> +
>>>>> +     /*
>>>>> +      * Can't use dissolve_free_hugetlb_folio() without a reliable
>>>>> +      * raw_hwp_list telling which subpage is HWPoison. So do not free
>>>>> +      * them to the buddy allocator. dequeue_hugetlb_folio_node_exact()
>>>>> +      * will ensure to never re-allocate this hugepage.
>>>>> +      */
>>>>> +     if (folio_test_hugetlb_raw_hwp_unreliable(folio))
>>>>> +             /* raw_hwp_list becomes unreliable when kmalloc() fails. */
>>>>> +             return -ENOMEM;
>>>>
>>>> There are some branches in __update_and_free_hugetlb_folio that will leave hugetlb
>>>> folio untouched:
>>>>
>>>> static void __update_and_free_hugetlb_folio(struct hstate *h,
>>>>                                                 struct folio *folio)
>>>> {
>>>>         bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
>>>>
>>>>         if (hstate_is_gigantic_no_runtime(h))
>>>>                 return;<-- 1
>>>
>>> Thanks for catching this, Miaohe.
>>>
>>> I think the most challenging part is that
>>> update_and_free_hugetlb_folio() must support deferring freeing (via
>>> schedule_work()), so adding a return value isn't that straightforward
>>> without some refactoring...
>>>
>>> If making __hugepage_handle_poison() check
>>> hstate_is_gigantic_no_runtime() == 0 (or
>>> gigantic_page_runtime_supported() == 1) isn't an absurd idea, we can
>>
>> I'm afraid this might not be a good idea. Maybe we could re-check page state after
> 
> Any specific reason? It seems to me that code that included
> "hugetlb.h" can access gigantic_page_runtime_supported().

I am concerned that with the changes of the implementation of
dissolve_free_hugetlb_folio(), gigantic_page_runtime_supported()
might not be the sole reason causing dissolve_free_hugetlb_folio()
to fail. This would require __hugepage_handle_poison() to be modified
accordingly but we might miss that in the future... But still no strong
opinion here. :)

Thanks.
.

> 
> I feel checking gigantic_page_runtime_supported() upfront is cleaner
> than checking page state after dissolve:
> 
> if (!gigantic_page_runtime_supported())
>     return -EOPNOTSUPP;
> 
> vs
> 
> /* Direct state check after dissolve */
> rc = dissolve_free_hugetlb_folio(folio);
> if (!rc && folio_test_hugetlb(folio)) {
>     /* Dissolve failed silently due to unsupported gigantic runtime freeing */
>     rc = -EOPNOTSUPP;
> }
> 
> 
>> calling dissolve_free_hugetlb_folio?
>>
>>> just do that and avoid adding return value to
>>> __update_and_free_hugetlb_folio().
>>>
>>>>
>>>>         /*
>>>>          * If we don't know which subpages are hwpoisoned, we can't free
>>>>          * the hugepage, so it's leaked intentionally.
>>>>          */
>>>>         if (folio_test_hugetlb_raw_hwp_unreliable(folio))
>>>>                 return;<-- 2
>>>
>>> __hugepage_handle_poison() already checked this, and with mf_mutex no
>>> one can set raw_hwp_unreliable.
>>
>> Agreed.
>>
>>>
>>>>
>>>>         /*
>>>>          * If folio is not vmemmap optimized (!clear_flag), then the folio
>>>>          * is no longer identified as a hugetlb page.  hugetlb_vmemmap_restore_folio
>>>>          * can only be passed hugetlb pages and will BUG otherwise.
>>>>          */
>>>>         if (clear_flag && hugetlb_vmemmap_restore_folio(h, folio)) {
>>>>                 spin_lock_irq(&hugetlb_lock);
>>>>                 /*
>>>>                  * If we cannot allocate vmemmap pages, just refuse to free the
>>>>                  * page and put the page back on the hugetlb free list and treat
>>>>                  * as a surplus page.
>>>>                  */
>>>>                 add_hugetlb_folio(h, folio, true);
>>>>                 spin_unlock_irq(&hugetlb_lock);
>>>>                 return;<-- 3
>>>
>>> __hugepage_handle_poison() should not get into this if-block because
>>> dissolve_free_hugetlb_folio() must have
>>> hugetlb_vmemmap_restore_folio()-ed successfully, so clear_flag must be
>>> false here. Otherwise dissolve_free_hugetlb_folio() already returns
>>> early without update_and_free_hugetlb_folio().
>>
>> Agreed.
>>
>> Thanks.
>> .
> .
> 


