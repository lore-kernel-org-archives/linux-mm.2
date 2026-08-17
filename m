Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3BA2C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EBE96B007B; Mon, 17 Aug 2026 03:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89DF76B00A3; Mon, 17 Aug 2026 03:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78ECC6B04A6; Mon, 17 Aug 2026 03:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC246B007B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:23:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69F2314070A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:23:56 +0000 (UTC)
X-FDA: 85109922072.01.0858053
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf12.hostedemail.com (Postfix) with ESMTP id F3CA84000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:23:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wy+zW023;
	spf=pass (imf12.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786951434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xWH1usVd09PJQj81vk8s/B/+j0Sidd2Zk//Vvn6sQZ4=;
	b=ZYd3MzhNDlwO09ocpSAvjJbUy0EQ+yFqs+llr4QEk0qkig/A00TtriAFCa0N8PlG96KAOy
	or+FAcKq2rnyLKRCPpkgtOi1FcG/1ssLLbQmXHxglC53YCv/WNCJVEvk2q0U72ULVHa/az
	8Fu+t8EfKVYoikUIJP0dw28rLzAPI38=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wy+zW023;
	spf=pass (imf12.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786951434;
	b=LyJcXu/1pT9S23ms5s13OvvK2UCXth14Xc4Y0ci92NYBN8BijTVpwN8B53DXwNWba/YV5F
	2U73H9LeyiIXFZ9D69V+AVdm4ROxz33YxmySKDrBYxAQZV3QqdxtBQCzEM3bfnee+kBS4L
	nBMx8Br5R8Hh0eI3ZFuH9U1e0GgsTfA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xWH1usVd09PJQj81vk8s/B/+j0Sidd2Zk//Vvn6sQZ4=;
	b=wy+zW023oSvdOVx4ltYTaTj8lkFakmRbbBhviqWbUpQAMo98lxlh4E1MpCufTIRhmIRvZj/d4
	OjShh521fG1l5gF7ZO8bMEkRsH1Vobk/5/cBHepCZNiqkxE08p2/gANFTF5LKgBWbknAgyK9yQI
	UYmU/7rC4SU8U9uazlVYwU0=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hNkZB5hLGz1K98V;
	Mon, 17 Aug 2026 15:13:06 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E217740578;
	Mon, 17 Aug 2026 15:23:46 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 17 Aug 2026 15:23:46 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 17 Aug 2026 15:23:45 +0800
Subject: Re: [PATCH v6 4/5] mm/memory-failure: skip take_page_off_buddy after
 dissolving HWPoison HugeTLB page
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <osalvador@kernel.org>, <harry.yoo@oracle.com>, <willy@infradead.org>,
	<osalvador@suse.de>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
	<nao.horiguchi@gmail.com>, <david@kernel.org>, <william.roche@oracle.com>,
	<tony.luck@intel.com>, <wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
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
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d908b3d6-e3db-6eaf-100f-ffc1dd765c55@huawei.com>
Date: Mon, 17 Aug 2026 15:23:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CACw3F52RfFR4gZ9+kAmi6fkq39t6Sk1oUW0jqiXOFAAgn0iOyQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F3CA84000A
X-Stat-Signature: yuqb4wxxiprpcp9q1oaah8g79utbw8tu
X-Rspam-User: 
X-HE-Tag: 1786951432-253277
X-HE-Meta: U2FsdGVkX1+XLXxnIRVfo9CkI5fJq0Eh5F2xF4YPX0tErFzlkuks+z3G+NUsrG6OXFUEN81KwZuO2A/j8ALAxLpeBCjvKKb08iadEd0QZkSbEgguEKoH00H0VjqqGGkcEPvHuaUuDKb0sEtCoyycVDx8hJI+053x36dIyuA2QreRXrYsNbvkQxyOwoQUeMbLesmAPgSKRQCpcKOZOr5nVKN2Y3gp64S9jxwXGeh5ua67AuRec1xsNzWIqroaAa34ieIxJhNOC6CCnY4En0bv5BOcZG+wf7edqsqLqgX4LNrJL8vdsG0g612FGPLsNfxymi0cSeeOUVJkVD/oVhkJj+mojU2x8JWLymlOOSggumfvlPukeBDU5EQqSZKmh2vSD3YWuKgf9vgGwBWubjVwNNrzpnmRKmn7IntTxhtASU/Seo5x6cLV1CuyaKYvuTEuNVIjveXtUOSPH4NWv7XxdpnO3Rdb3O5ejxTuFtJijwCLt7lnHk9rQ0Qs5e1pd70xtofijLR9pN0rJ8uBbwtZWcGsIewLwICXJTgVZrjXtlal4SHhgXaQnpJC9ojhx4/eL7zgL+YM6Z6bOBknq84PEn/a0YAXfRrdx2Og6aTp/kD1aBNC+UYuVOAh9LU11jhFv4jmYBgazit3ldoHfxGx9pptkd69pPWhs1nMUhAOlXoHiYNMpSbay82ZE1wPgsI+CBsSdwI11ZfeQrWlAWvNFV/PNOfVi5kLq9PNRUHL52I/GQSyikWrxaYO/HZ0kISTt0pRtgEQ8OPw1GUZkiBzfoTMDi6dpToZlPh4NS/MraSeI11uQ7udVF0aHgGG5+Ifo2hvwJXUna+fPEXESgaQQV7zBnQAht12FPO8NTnE8FROtGfFIRZK7sYFnpeYG1W57nV2YAo+MrKw+JLM+34Ql8sRH5HGXf6NLepRswdf4e9YByn/kayg2qeGWm76K46QzCF4rZKWeOt7OPdPwlG
 d97tFV/7
 ZFsiG1TDsJrMWTO3GD2XMH6s/HkDuwl1egIlgykaC46Kliev/UIL6BxDiHdwNAfjroWPLc6ITF6gD1wOF7I0ME0MjPLABsgQqpeXWW7bywZK/t3DfjbHnT3hVkApB5OOwKFA8b8br6lq7ZGMXeMcJtYDel/QNb9UsqZb9n7Uq0+H+RVCyyicGnWmabCH28xTBj2xq6hW1JbKbKV4qOEZ0lSdPezuvW0u1Jsh+nI25E5bSQQG3oEHqNxBz2QERt5/SJ4RKJT8QWz072wdmlruEWfpSh0+iprqlH6eEDTLvvBTRxer9kULzJ1XeUEF0LHPea+4Qjke0jex4asqxg/Zw91neRJvfult7oqIb9cwtD82AMiqGI2sMB0X9vfUeBF6QQUAnPynYKv8y3zG75bNhe/k0aFGVMKYPaNxG7XwstpVj9O+P9zBlgo7GX9YTv3LgiBlI25DZ79enfXICBkoWU8hQnE5WMfyMOTV8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/17 8:29, Jiaqi Yan wrote:
> On Fri, Jul 17, 2026 at 12:37 AM Miaohe Lin <linmiaohe@huawei.com> wrote:
>>
>> On 2026/7/6 2:07, Jiaqi Yan wrote:
>>> Now that HWPoison subpage(s) within HugeTLB page will be rejected by
>>> buddy allocator during dissolve_free_hugetlb_folio(), there is no
>>> need to drain_all_pages() and take_page_off_buddy() anymore. In fact,
>>> calling take_page_off_buddy() after dissolve_free_hugetlb_folio()
>>> succeeded returns false, making caller think __page_handle_poison()
>>> failed.
>>>
>>> Add __hugepage_handle_poison() and replace __page_handle_poison() at
>>> HugeTLB specific call sites. The being handled HugeTLB page either
>>> is free at the moment of try_memory_failure_hugetlb(), or becomes
>>> free at the moment of me_huge_page().
>>>
>>> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>>> ---
>>>  mm/memory-failure.c | 36 ++++++++++++++++++++++++++++++------
>>>  1 file changed, 30 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>> index 3d15b4c1b694..a37b67550718 100644
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -174,6 +174,30 @@ static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
>>>  static DEFINE_MUTEX(pfn_space_lock);
>>>
>>>  /*
>>> + * Only for a HugeTLB page being handled by memory_failure(). The key
>>> + * difference to soft_offline() is that, no HWPoison subpage will make
>>> + * into buddy allocator after a successful dissolve_free_hugetlb_folio(),
>>> + * so take_page_off_buddy() is unnecessary.
>>> + */
>>> +static int __hugepage_handle_poison(struct page *page)
>>> +{
>>> +     struct folio *folio = page_folio(page);
>>> +
>>> +     /*
>>> +      * Can't use dissolve_free_hugetlb_folio() without a reliable
>>> +      * raw_hwp_list telling which subpage is HWPoison. So do not free
>>> +      * them to the buddy allocator. dequeue_hugetlb_folio_node_exact()
>>> +      * will ensure to never re-allocate this hugepage.
>>> +      */
>>> +     if (folio_test_hugetlb_raw_hwp_unreliable(folio))
>>> +             /* raw_hwp_list becomes unreliable when kmalloc() fails. */
>>> +             return -ENOMEM;
>>
>> There are some branches in __update_and_free_hugetlb_folio that will leave hugetlb
>> folio untouched:
>>
>> static void __update_and_free_hugetlb_folio(struct hstate *h,
>>                                                 struct folio *folio)
>> {
>>         bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
>>
>>         if (hstate_is_gigantic_no_runtime(h))
>>                 return;<-- 1
> 
> Thanks for catching this, Miaohe.
> 
> I think the most challenging part is that
> update_and_free_hugetlb_folio() must support deferring freeing (via
> schedule_work()), so adding a return value isn't that straightforward
> without some refactoring...
> 
> If making __hugepage_handle_poison() check
> hstate_is_gigantic_no_runtime() == 0 (or
> gigantic_page_runtime_supported() == 1) isn't an absurd idea, we can

I'm afraid this might not be a good idea. Maybe we could re-check page state after
calling dissolve_free_hugetlb_folio?

> just do that and avoid adding return value to
> __update_and_free_hugetlb_folio().
> 
>>
>>         /*
>>          * If we don't know which subpages are hwpoisoned, we can't free
>>          * the hugepage, so it's leaked intentionally.
>>          */
>>         if (folio_test_hugetlb_raw_hwp_unreliable(folio))
>>                 return;<-- 2
> 
> __hugepage_handle_poison() already checked this, and with mf_mutex no
> one can set raw_hwp_unreliable.

Agreed.

> 
>>
>>         /*
>>          * If folio is not vmemmap optimized (!clear_flag), then the folio
>>          * is no longer identified as a hugetlb page.  hugetlb_vmemmap_restore_folio
>>          * can only be passed hugetlb pages and will BUG otherwise.
>>          */
>>         if (clear_flag && hugetlb_vmemmap_restore_folio(h, folio)) {
>>                 spin_lock_irq(&hugetlb_lock);
>>                 /*
>>                  * If we cannot allocate vmemmap pages, just refuse to free the
>>                  * page and put the page back on the hugetlb free list and treat
>>                  * as a surplus page.
>>                  */
>>                 add_hugetlb_folio(h, folio, true);
>>                 spin_unlock_irq(&hugetlb_lock);
>>                 return;<-- 3
> 
> __hugepage_handle_poison() should not get into this if-block because
> dissolve_free_hugetlb_folio() must have
> hugetlb_vmemmap_restore_folio()-ed successfully, so clear_flag must be
> false here. Otherwise dissolve_free_hugetlb_folio() already returns
> early without update_and_free_hugetlb_folio().

Agreed.

Thanks.
.

