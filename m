Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A0ACCD6E56
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:09:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37E786B049E; Mon,  1 Jun 2026 23:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32EEF6B04A1; Mon,  1 Jun 2026 23:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2453F6B04A5; Mon,  1 Jun 2026 23:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 16DCF6B049E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:09:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C41D0C2898
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:08:59 +0000 (UTC)
X-FDA: 84833490798.29.C78CB84
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf03.hostedemail.com (Postfix) with ESMTP id 599BF2000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:08:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Te/fsP91";
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780369737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbsuXNQSSzUTtgq4oSp1vzBur9x6afidpwasn1swHTs=;
	b=osC8Wy2TebqJwLE02sMDnZiBFcSIDrzFrw2LMKnq1o5lHQJutKKZOWz8vqMpXB9In2gUGn
	a2WpQSKdUsteTSMmpF2+bk/lbgycwXgb1xmYzpyPD5XsT5gJrOP6Kdvzzt5+uB2Cc2hUtZ
	A5JQteK0xjJ1f9PtuoyFVo5nPwZ8WNc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780369737;
	b=Y/kQF4ZtPoNMSQdmjnCGm13aWW9aLJxN9KM/bNpswUeZRFaBjv/ASuUIrT71I+uwovacbR
	oyWat5W5GqbAuIEJcnenpwAvLvQePXYxmNzXntA1IOH4wDpuhsG30G7cxYbCc0ioG7QMBx
	yO9FSNE9XZYOJcut43Oi7NQNsafl+Ng=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Te/fsP91";
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YbsuXNQSSzUTtgq4oSp1vzBur9x6afidpwasn1swHTs=;
	b=Te/fsP91KX55l1Gbb+C9+u0k3lsQtDmYEzt1UfTZmzElSuKtGIKMJz5MC4kV2vuTKn97krApj
	J66MNqF9SwWz/noaN6xm4l+pGq4tJSV1syNQETRFigZbQF53yFLWCqq6qJOg3GjxofiQLcH7wlJ
	zkKwe43mzvaluygA+VwNMXY=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gTwZf55jlzpStZ;
	Tue,  2 Jun 2026 11:01:14 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id E8F224056F;
	Tue,  2 Jun 2026 11:08:50 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Jun 2026 11:08:50 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Jun 2026 11:08:49 +0800
Subject: Re: [PATCH v8 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
To: "David Hildenbrand (Arm)" <david@kernel.org>, Breno Leitao
	<leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <kernel-team@meta.com>, Lance Yang
	<lance.yang@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
 <20260527-ecc_panic-v8-2-9ea0cfa16bb0@debian.org>
 <19f968f5-1289-f573-4406-e5c91dcd8923@huawei.com>
 <e3d023f1-ab6e-4424-b304-55f1294480c3@kernel.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <33ef8821-c809-b7d1-ea77-6e8a07a6e784@huawei.com>
Date: Tue, 2 Jun 2026 11:08:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <e3d023f1-ab6e-4424-b304-55f1294480c3@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 599BF2000A
X-Rspam-User: 
X-Stat-Signature: idqmh6o148ngmzxhuxn6hf4bsoqbdgk3
X-Rspamd-Server: rspam08
X-HE-Tag: 1780369735-212939
X-HE-Meta: U2FsdGVkX1+8YPvTVvUfrci6sHqPD5hK1SQiXVPgX3AHOEtSZaT/7Bi3fnar+A6TQo/thcR2Hap4ZMEapYR6RhtItD5ymbM7MgPFzUF0ZiAwUUPWdt158Y7L4MimHWUw4NCm7J5L5pnBMcgtrT50h3MQnwKPelxYUYVgRm5J6gyIC9KLbtP2PRNs3ZXHfdEBgbh+vOALRCFD8LF8HULb/IYH82jyuB+ETfogxwddSVp8IOyqB5/xXPOxbFsOP+n3JV1Qe/UARaiQ0nKiMqoPJ0NNx99P0Hjf5YYYCKOvDpcfjvwsuJEDVHIyf1rShnj/b9ecpwx62jAJ8/ai+vKgWPIHA2DzS0gli5+ct5kK0DW1qVMH5PTOTBmK7+U8CiwSxjmbS2k0xoQtGoAkB8adCJmLPGuIFuiKcMHcVqBClO1CJbwnqitBvgVRMXJ7+J3gGdlh8k+21PdOQX7QXmE5ftXpcE2Htj7WMihIZ4Mcoyq8BhqcTRQabi5VDY1BQMwWsD4VVonqhfZFpTTf4Tp/ur0eeKv+f8YjppZ3Q8SqKuTYNvfgyqTO3LXq3W50j+yCIp3xiq0oaCopvtgnbxYkC2My84dh/u/wgZl+OnKStFCfC+RVkJE5EizXl1Ss1Al+4VKAFlM9j6Jl4m/oZmbWpt4aC6def44ic076ze4Kmvr45p02tf2odf4hLrt6QjsMqK4IXkoDZH48D640acLy3ioQmzWEkM/dMllBzc/lyA4nGAaF7B1QSGyIpdSfAPSp77/viXUhWVNU9UJ6C7t/Z85W5GiMx6nNhfcblE5TBnT5h2qOat4cTssynSqMW7RBLQznR5rQdr+V8vk9xwWWCSaQxZgu8KZBgNh6yrhrWz0biqavZ0zsaNBubW326fHycs1rmxdhfzptkHGtWYPGB+BhPa/LaMbiTJ/zt++LWC4TDlznuZt1eoX83jRRnbl1r8/jyYXcB/bZjF8Lvf0
 t9Pxkh8l
 dNL45sAmTZ7yfTDel2y3YFipNymHZ4bzihIVPHUboRZnWeZ4ylQPjU2GsXOIF0twsNjWL8HDp8j4xvNZdHM6Fypwv8PDyUAdDfSXlL08F8scRKmBMo/KbUjrpNHEQj1BW11hFXR7Nln/gPiBQki2iT6YubEtAtiQxSqwpDHPgOf+LJMsEpwqUZs8oN14Ug3ETPFfOH4NngQF0CS40Zo5sfu4z1dOvNfpHscC0KfG3hBjF10Qh2KjfFsd7rllqFPewa2xvmkSjKvZHwEeGK4UKCnu1qM9+ZpDdZ1db55f2U8a0U+1RixA2z4zHswktLGf0TUs9/ob7N3OpA3SxcVYO3GfI5fZjgipH+XA6fHSuzQIKMkE94aJ236hag0sd65jG4WTDvlpRrE/eiKpuspahbChu4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/1 21:22, David Hildenbrand (Arm) wrote:
> On 6/1/26 14:28, Miaohe Lin wrote:
>> On 2026/5/27 22:06, Breno Leitao wrote:
>>> get_any_page() collapses every HWPoisonHandlable() rejection into a
>>> single -EIO via the __get_hwpoison_page() -> -EBUSY -> shake_page()
>>> -> retry path.  That is correct for the transient case (a userspace
>>> folio briefly off LRU during migration or compaction, which a later
>>> shake can drag back), but wrong for stable kernel-owned pages: slab,
>>> page-table, large-kmalloc and PG_reserved pages will never become
>>> HWPoisonHandlable(), so the retry loop is wasted work and the final
>>> -EIO loses the "this is structurally unrecoverable" information.
>>> memory_failure() then maps -EIO into MF_MSG_GET_HWPOISON, which the
>>> panic-on-unrecoverable sysctl deliberately does not act on.
>>>
>>> Introduce HWPoisonKernelOwned(), a small predicate that positively
>>> identifies pages the hwpoison handler cannot recover from:
>>>
>>>   HWPoisonKernelOwned(p, flags) :=
>>>       !(MF_SOFT_OFFLINE && page_has_movable_ops(p)) &&
>>>       (PageReserved(p) || PageSlab(p) ||
>>>        PageTable(p)    || PageLargeKmalloc(p))
>>>
>>> The MF_SOFT_OFFLINE / page_has_movable_ops() opt-out mirrors the
>>> same exception in HWPoisonHandlable(): soft-offline is allowed to
>>> migrate movable_ops pages even though they are not on the LRU, and
>>> we must not pre-empt that with an unrecoverable verdict.
>>>
>>> The list is intentionally not exhaustive.  vmalloc and kernel-stack
>>> pages, for example, do not carry a page_type bit and would need a
>>> different oracle; they keep going through the existing retry path
>>> unchanged.  This is the smallest set we can identify with certainty
>>> by page type.
>>>
>>> Wire the helper into the top of get_any_page() to short-circuit
>>> those pages before the retry loop runs.  On a hit, drop the caller's
>>> MF_COUNT_INCREASED reference (if any) and return -ENOTRECOVERABLE
>>> straight away.  Pages outside the helper's positive list still take
>>> the existing retry path and return -EIO, leaving operator-visible
>>> behaviour for those cases unchanged.
>>>
>>> Extend the unhandlable-page pr_err() to fire for either errno and
>>> update the get_hwpoison_page() kerneldoc to document the new return.
>>>
>>> memory_failure() still folds every negative return into
>>> MF_MSG_GET_HWPOISON via its existing "else if (res < 0)" branch, so
>>> this patch on its own only changes the errno that soft_offline_page()
>>> can propagate to its callers.  A follow-up wires -ENOTRECOVERABLE
>>> through memory_failure() and reports MF_MSG_KERNEL for the
>>> unrecoverable cases, which is what the
>>> panic_on_unrecoverable_memory_failure sysctl observes.
>>
>> Thanks for your patch.
>>
>>>
>>> Suggested-by: David Hildenbrand <david@kernel.org>
>>> Suggested-by: Lance Yang <lance.yang@linux.dev>
>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>> ---
>>>  mm/memory-failure.c | 42 ++++++++++++++++++++++++++++++++++++++++--
>>>  1 file changed, 40 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>> index f4d3e6e20e13..8f63bdfeff8f 100644
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -1325,6 +1325,28 @@ static inline bool HWPoisonHandlable(struct page *page, unsigned long flags)
>>>  	return PageLRU(page) || is_free_buddy_page(page);
>>>  }
>>>  
>>> +/*
>>> + * Positive identification of pages the hwpoison handler cannot recover.
>>> + * These page types are owned by kernel internals (no userspace mapping
>>> + * to unmap, no file mapping to invalidate, no migration target), so the
>>> + * shake_page() / retry loop in get_any_page() can never turn them into
>>> + * something HWPoisonHandlable() will accept.  Short-circuit them to
>>> + * -ENOTRECOVERABLE so callers can panic on operator request instead of
>>> + * spinning through retries that exit as a transient-looking -EIO.
>>> + *
>>> + * The MF_SOFT_OFFLINE / page_has_movable_ops() opt-out mirrors
>>> + * HWPoisonHandlable(): soft-offline is allowed to migrate movable_ops
>>> + * pages even though they are not on the LRU.
>>> + */
>>> +static inline bool HWPoisonKernelOwned(struct page *page, unsigned long flags)
>>> +{
>>> +	if ((flags & MF_SOFT_OFFLINE) && page_has_movable_ops(page))
>>> +		return false;
>>> +
>>> +	return PageReserved(page) || PageSlab(page) ||
>>
>> Once shake_page finds a lightweight range-based way to shrink slab, slab pages could be freed
>> into buddy and above PageSlab test should be removed then. Maybe add a TODO or XXX here?
>>
>>> +	       PageTable(page) || PageLargeKmalloc(page);
>>
>> I'm not sure but is it safe or a common way to test PageReserved, PageSlab,
>> PageTable and PageLargeKmalloc without extra page refcnt?
> 
> Checking typed pages in a racy fashion is fine (PageSlab, PageTable,
> PageLargeKmalloc).

Got it. Thanks.

> Checking PageReserved in a racy fashion is fine as well. TESTPAGEFLAG() will
> allow checking it on compound pages.

It seems PageReserved is not intended to be set on compound pages. I see there are PF_NO_COMPOUND
in its definition: PAGEFLAG(Reserved, reserved, PF_NO_COMPOUND).

> 
> For PageLargeKmalloc, we would want to check the head page, though. The page
> type is only stored for the head page.

Maybe we should check the head page for PageSlab and PageTable too? alloc_slab_page only
set PageSlab on the head page and __pagetable_ctor uses __folio_set_pgtable to set PageTable
on folio.

> 
> So maybe we want to lookup the compound head (if any) and perform the type
> checks against that?

Maybe we should or we might miss some pages that could have been handled. And
if compound head is required, should we hold an extra page refcnt to guard against
possible folio split race?

Thanks.
.



