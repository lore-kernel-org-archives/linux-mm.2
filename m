Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F8C3D6406A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 01:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CDF56B0005; Tue, 16 Dec 2025 20:34:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77BD56B0089; Tue, 16 Dec 2025 20:34:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650DE6B008A; Tue, 16 Dec 2025 20:34:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 519B96B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:34:05 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2EB6140855
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 01:34:04 +0000 (UTC)
X-FDA: 84227242008.06.5764D50
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf08.hostedemail.com (Postfix) with ESMTP id D9C0016000A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 01:34:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MymxaKhX;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765935243; a=rsa-sha256;
	cv=none;
	b=YqQx7XoXhfalM9vTuNtYswYWzgw+aZQQ7119wWixSzJnTxoGZVDnr2fuyn3q5OPA5T1sy3
	6USBfI7dkkE6aWAR60G2fRtLjRsINpzYLxXDVkaZ3etGt9TXk1aKNJ+U8sSmvozOWBTzv8
	Y1wZX5U0LZNqpn/khhsyzSYGscv4zCo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MymxaKhX;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765935243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LOBi0mCLSN1pX4/fJ7qcbzGYmH1wlSSOqnzZMNKNsIA=;
	b=LvNk8FZSoBBDC6qq/GqW9G/O++9T7dzQFObi1zDHd1VXBok84+OFkq2YNALCWMakBNB2rM
	UPJ7QDfk25HxgP9ET2C6312F1/5Kk4rB2AOjq7A9WjvA/5FgcduwfaPC3hp3Ax4FVdDSJv
	c5gtqr5vRLttd1vomdfQXtOcqojnTjY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765935238; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LOBi0mCLSN1pX4/fJ7qcbzGYmH1wlSSOqnzZMNKNsIA=;
	b=MymxaKhXa+HFQi0CPc2tUktfIJpbR1Wu0TshbMSBysMgG3qFaLtnQgFsxVLeTETwWqKA7clzfYWcK+0YzaBSflfKuf9IUxIhg+VsiUJj7S5YrLeF1JqPPCqgyawF6sTSIuUuX69CvwwX+0ehN0P6++vs0Pwty5DNWE0pVwAiSew=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wv1EBZW_1765935235 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 17 Dec 2025 09:33:56 +0800
Message-ID: <45d61f3c-b721-4e42-8aa6-5f252193d2b7@linux.alibaba.com>
Date: Wed, 17 Dec 2025 09:33:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 mm-new 07/16] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
 ziy@nvidia.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251201174627.23295-1-npache@redhat.com>
 <20251201174627.23295-8-npache@redhat.com>
 <95b1403f-3ddb-43ff-b481-2ecc6ab8352f@linux.alibaba.com>
 <CAA1CXcCtp2OwTmm-1EYUpOhsey1sv7CRFu8454m16C=k9iaN6g@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAA1CXcCtp2OwTmm-1EYUpOhsey1sv7CRFu8454m16C=k9iaN6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D9C0016000A
X-Stat-Signature: 6mupx44gz7gsybtj4aw7kgw9epdr333c
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765935241-591879
X-HE-Meta: U2FsdGVkX18jVVVgfOrWJXP6hvGNpBJH36q82V9uv3e6CELRG94wMmOH8JBFkOiIeB4LdHSjDdTBDr5Yt93spRxiJPfKOjNbvkD9OpTJceuwwyg8HdUg8idMh50DPXMFKqURxVOLM7gIMmKWuvAcPnv195eo/lMtZvM3anNQ1yeGY/4R1nDjupLEOsDvBRfaUxQOL0ekrp5yp1MxZ+u6jFQ0aRGXybwPnGLXS+tslwSR5LaANeCEG7Hk8rbjGvr22NImOgeXvFeWgEUedQZtmLZbXTMN4u393I1M+1nXRIXs51I4ko05S1zAwm2XWGziEGOM4696gtGEC9KCuoNfN6jMN0/qXYY04Ma5c1VyU2jkFKJNjZ91ExcvuXB5BrygvXA+61QJF2uRBwVVANAtxGTl6c3BppbBO/5csPiapN+DNA95mwxvvZthKvdcI1XdVrpileLSA99Y6KXByNa1HhwI/BnW7jibLvQzOVe7uDS6rUja4qLBqyzMFdIqoVbUL7fXDsy5Ybor5I0ZYkzHaXsGhzHGAZiHMaBN7xXmBjElRF0IJGLN+34OxRAX8iToq6TngTVydMFC1jTFH3ysyIaCufcRkVh10uLd2UgQlMau/1txF6t5YUHBgbn3gXE2KTbyqZPjvqdh2NWCXezmOxQO54MpAZlroKdFOzD8EKDG7a8N/6PFnfycYftr5S6yLG6E1VhgfIhsM+srT+9HaAqhQ82D63baD6c5bu7fkwrvzzT8KmxK/o+3DMLylNG6H7jTpcDsCSRf5rqb7+qq4zKxeBRvzzp1WiWIcdCwvLo9tzBZglsRr8IEmZZadKw8oWVaplaktxTHg6hDURj1eRpU2zFsfMWgVWuGmSNRKQKT6ocOciqWRvFU9A7Kxc/ZmDiBEe5J+G0xj4VexAGLIbGGN9Obly+XI1iurOHblt9phrDk63h1zxIeKnbCpnzWAaQZez6Zfkw5QdusCLx
 RIeJIhq4
 76SA3qm+59AHCGJZKhHvnwCeaDoyVFKNdVGVKteNS/jYJFRdWxBFS2YAHGiwa5Xz4R3QDaVqUZ0qUj3x/y/LvDrJ48PiG2327FE52AysseffKgx+wDOC94Tv4moNJRDNQy22jdWYrNxu9QW5l8JgogXx3Hyzbx7EdahJ9JUGf7euV5PvUCaTHxxSGwd3nFChYGIEil62slTt2VMdDoow0g+kh4oueeYj4cOu/zcTle8TdecTOBIMmefei021HBHHo8gcyd98dpp56iR90DuPfRLdr7Q+HTf7/4xRnAR/oIqrvwjvFE7YQK+LnNUCJubI3KMfA+PAsj6rsOKzgeG4nDXEUfjodPq7ChAqzHo2UkqqDNmnMiT5xJ5q5WGO4HsbUlrRaQFEwIqU+Z+GyrwE3iFzZbmi+SmuDUpHVrZH8dwcQchWzvtcrr6XHNba87BOraNBuy2E5+YurdpKFk82j2sAMkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/17 07:26, Nico Pache wrote:
> On Tue, Dec 16, 2025 at 1:12 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> Hi Nico,
> 
> Hi Baolin! Thanks for testing :)
> 
> Did you happen to test with the changes I asked Andrew to append to
> this commit?
> 
> Either way, I think your fixup makes more sense than mine.

Ah, I did not notice your fixup commit earlier, which seems to address 
this problem. And as I said, we don't need to call release_pte_pages() 
in this case.

>> On 2025/12/2 01:46, Nico Pache wrote:
>>> The current mechanism for determining mTHP collapse scales the
>>> khugepaged_max_ptes_none value based on the target order. This
>>> introduces an undesirable feedback loop, or "creep", when max_ptes_none
>>> is set to a value greater than HPAGE_PMD_NR / 2.
>>>
>>> With this configuration, a successful collapse to order N will populate
>>> enough pages to satisfy the collapse condition on order N+1 on the next
>>> scan. This leads to unnecessary work and memory churn.
>>>
>>> To fix this issue introduce a helper function that will limit mTHP
>>> collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
>>> This effectively supports two modes:
>>>
>>> - max_ptes_none=0: never introduce new none-pages for mTHP collapse.
>>> - max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
>>>     available mTHP order.
>>>
>>> This removes the possiblilty of "creep", while not modifying any uAPI
>>> expectations. A warning will be emitted if any non-supported
>>> max_ptes_none value is configured with mTHP enabled.
>>>
>>> The limits can be ignored by passing full_scan=true, this is useful for
>>> madvise_collapse (which ignores limits), or in the case of
>>> collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
>>> collapse is available.
>>>
>>> Signed-off-by: Nico Pache <npache@redhat.com>
>>> ---
>>>    mm/khugepaged.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>>>    1 file changed, 42 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 8dab49c53128..f425238d5d4f 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -463,6 +463,44 @@ void __khugepaged_enter(struct mm_struct *mm)
>>>                wake_up_interruptible(&khugepaged_wait);
>>>    }
>>>
>>> +/**
>>> + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
>>> + * @order: The folio order being collapsed to
>>> + * @full_scan: Whether this is a full scan (ignore limits)
>>> + *
>>> + * For madvise-triggered collapses (full_scan=true), all limits are bypassed
>>> + * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
>>> + *
>>> + * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
>>> + * khugepaged_max_ptes_none value.
>>> + *
>>> + * For mTHP collapses, we currently only support khugepaged_max_pte_none values
>>> + * of 0 or (HPAGE_PMD_NR - 1). Any other value will emit a warning and no mTHP
>>> + * collapse will be attempted
>>> + *
>>> + * Return: Maximum number of empty PTEs allowed for the collapse operation
>>> + */
>>> +static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
>>> +{
>>> +     /* ignore max_ptes_none limits */
>>> +     if (full_scan)
>>> +             return HPAGE_PMD_NR - 1;
>>> +
>>> +     if (!is_mthp_order(order))
>>> +             return khugepaged_max_ptes_none;
>>> +
>>> +     /* Zero/non-present collapse disabled. */
>>> +     if (!khugepaged_max_ptes_none)
>>> +             return 0;
>>> +
>>> +     if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
>>> +             return (1 << order) - 1;
>>> +
>>> +     pr_warn_once("mTHP collapse only supports max_ptes_none values of 0 or %d\n",
>>> +                   HPAGE_PMD_NR - 1);
>>> +     return -EINVAL;
>>> +}
>>> +
>>>    void khugepaged_enter_vma(struct vm_area_struct *vma,
>>>                          vm_flags_t vm_flags)
>>>    {
>>> @@ -550,7 +588,10 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>        pte_t *_pte;
>>>        int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
>>>        const unsigned long nr_pages = 1UL << order;
>>> -     int max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
>>> +     int max_ptes_none = collapse_max_ptes_none(order, !cc->is_khugepaged);
>>> +
>>> +     if (max_ptes_none == -EINVAL)
>>> +             goto out;
>>
>> After testing your patchset, I hit the following crash. The reason is
>> that when 'max_ptes_none' is -EINVAL here, it shouldn't goto out to call
>> release_pte_pages(), because the '_pte' hasn't been initialized at this
>> point, and there's no need to release folios either.
>>
>> After applying the fix below, the crash issue is resolved. I'm not sure
>> whether Andrew will help fix this or if you will send a new version to
>> address this issue.
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 8cffaf59ced8..2e8171a6d7df 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -646,7 +646,7 @@ static int __collapse_huge_page_isolate(struct
>> vm_area_struct *vma,
>>           int max_ptes_none = collapse_max_ptes_none(order,
>> !cc->is_khugepaged);
>>
>>           if (max_ptes_none == -EINVAL)
>> -               goto out;
>> +               return result;
>>
>>           for (_pte = pte; _pte < pte + nr_pages;
>>                _pte++, addr += PAGE_SIZE) {
>>
>> "
>> [  565.319345] Unable to handle kernel paging request at virtual address
>> fffffffffffffffa
>> .......
>> [  565.319409] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000001f8549a000
>> [  565.319416] [fffffffffffffffa] pgd=0000001f85f2a403,
>> p4d=0000001f85f2a403, pud=0000001f85f2b403, pmd=0000000000000000
>> [  565.319427] Internal error: Oops: 0000000096000006 [#1]  SMP
>> .......
>> [  565.326733] pc : release_pte_pages+0x68/0x178
>> [  565.326960] lr : __collapse_huge_page_isolate+0xc0/0x748
>> [  565.327232] sp : ffff800083593910
>> .......
>> [  565.331476] Call trace:
>> [  565.331664]  release_pte_pages+0x68/0x178 (P)
>> [  565.331940]  __collapse_huge_page_isolate+0xc0/0x748
>> [  565.332249]  collapse_huge_page+0x4cc/0xa70
>> [  565.332510]  mthp_collapse+0x254/0x2a8
>> [  565.332754]  collapse_scan_pmd+0x5a0/0x6d8
>> [  565.333010]  collapse_single_pmd+0x214/0x288
>> [  565.333275]  collapse_scan_mm_slot.constprop.0+0x2ac/0x460
>> [  565.333617]  khugepaged+0x204/0x2c8
>> [  565.333992]  kthread+0xf8/0x110
>> [  565.334368]  ret_from_fork+0x10/0x20
>> "
>>
>>>
>>>        for (_pte = pte; _pte < pte + nr_pages;
>>>             _pte++, addr += PAGE_SIZE) {
>>


