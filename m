Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A522C83F27
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 03:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FFEA6B007B; Thu, 24 Jul 2025 23:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D78D6B0088; Thu, 24 Jul 2025 23:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED6F6B0089; Thu, 24 Jul 2025 23:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B6106B007B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:52:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 36D801D9608
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:52:54 +0000 (UTC)
X-FDA: 83701415868.05.1D23370
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf12.hostedemail.com (Postfix) with ESMTP id DD4A740005
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:52:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pPCJSgyz;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753415572; a=rsa-sha256;
	cv=none;
	b=CeNsAmbOK3Lyqvl2KWd+PnuVzgpde8DDze+cAxm9lHlHPFqBP4gHveJsaJ9wwz4YuDbYoi
	nA8ES8wr8ft2MSPJriafkaorJHu4UUVp3WfMQ6v+dE/6MK5d+WWGQsNi7mV3SF5ztiNo7x
	xv3fp05iJVm4O6s1ieuwis8xjI7DXPE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pPCJSgyz;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753415572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfu4uFiMvUI8JUko7ejXG7LLjlYmZWWJPSy5UDDoyF8=;
	b=jxczbfuGYSTuguytLKpJBUs35xAmuhBJ3fGruZpT69B6nmtmw5mcEjgbdCh4d+F7ssGVL2
	RRwNsaKfxoXHRbDWB7HgU5/hxQWI2jULOzecKpET6jxH9qnhgn6d8olXIe56JD+3sAK4Li
	+eo6ld7y/APAKTXWmJaMi4xD5/8mAsU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753415567; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mfu4uFiMvUI8JUko7ejXG7LLjlYmZWWJPSy5UDDoyF8=;
	b=pPCJSgyzbVnJ2gYSXrZ/UfnW3Hksx5vLqZMU1MahEyAJHUOG57ZzWJajagIfP9xpV9tUCQA0bpR9LbEfuFW49CbbISq5e/PX1nqFWDRTLPZMO4Xcd8ls3xPxHhNiV4eUDj3j4Qg0uk7pS7vThYo6Nsz6cHfjjbemU34A7bDJvLw=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WjvFo.E_1753415565 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 25 Jul 2025 11:52:46 +0800
Message-ID: <437bdc7a-d570-4602-9715-c716a660e762@linux.alibaba.com>
Date: Fri, 25 Jul 2025 11:52:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/8] mm/shmem, swap: improve cached mTHP handling and
 fix potential hung
To: Kairui Song <ryncsn@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>,
 Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20250710033706.71042-1-ryncsn@gmail.com>
 <20250710033706.71042-2-ryncsn@gmail.com>
 <CAMgjq7A+DBw=z8RPP-P1hcCH4Mid0txfmKqgqXghoE_v7zGEoA@mail.gmail.com>
 <CAMgjq7DfPXS4PkpGK-zem2L1gZD0dekbAyHa-CPHjf=eonoFXg@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7DfPXS4PkpGK-zem2L1gZD0dekbAyHa-CPHjf=eonoFXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD4A740005
X-Stat-Signature: xctfhy9kupnxmh8wpupgqrehhn3ao531
X-Rspam-User: 
X-HE-Tag: 1753415570-8982
X-HE-Meta: U2FsdGVkX19usRdqppEPO1ZpqtRg+WaoQg/Z3QMJekNhXvv0+k8Goh9bjO0dz+uIpT+2ytXSEBRI+u04hfS3kESH7cG51iMs53OKw06YjbiBlaopOiuLnsT+/pkWU9Dph4AC4CcJiKfz9XoGNbMvvZ+wWchk65ssSjfFxH2xE+5GEg71HQSSgcgI4tQLjXsFZsNWASYQL/Nqp+wOMiHG7q2dgUnc59jsslHJTNvtb3tQRpVEC4CdvhS4AZ3jjI804AS71C3GV9cujOzlq+5DfYT9kxGnFH6zvO4ehxXwo7zwM9FulR4Q7hnFvvusAaog5HdtD9Z50lSRCXOCs3iTxG6Zb/lhT2TCFJU/cwXlErAmaoY41RXFCdhRo3gaxUySc9/xs3xjmvNcvojLmM081dVyjOvP3vW3HlZYYHg9NLOgRtdPwdEk3icT08Wp8ylot8elUqtfoJIstOP6pwhYbRJ/biCFMRqRsAsl27N3zYIc/7xY49owUXVu2x56vLWZhG0O4fD6e+iSJy2+Y112eMrMnZoFg+6tYEd6ATdJPzrPB9aDCrf8gf/sDj5mzuUcDOzlc092/Q+yR+DZ/0CRBYEPjeL5jOd8nwzuUV4VcUs9rU3Xva6fF250LqUcdb8J65QPK4ysi34CEYcyy6FBgt6B0ehtH8MJtocCQOsXLIh8H3aCgsK5oqG723HHKgO5mvR46zPl3tPrUWcQ0cvS0seg/vKq/EJMogQRhb8r/QI//bjwAoxIdMF9DE+9FiKlepJal01NuF0yvjEXTfuOYdlElEaoQ4dWwYrVSOfFPCysGG2cy5N/yRR4E2QNXt+UneWLV7a1n3DuBUDdmBtF4NXJZCfBWaXaz69d1N3HbNXe9dT5PXQ7CW7lCXPM6ZD4InUW743eKrChFR4eR43zvp2sGzFt45VhiLN1U617bn2atE9XeQMrFVoRjG/PluAkGZm6QYL00sk9WFG4W+q
 pp4R4E1e
 bB0XxMUFGZ3XGFFKgmfb78XU89Qvk7zX914PJhqICAfihw3NIDzbBHVBKbS6w0JkoHPpGK/77cwze3OcGUncXsQYmWV/h+vcs9ProMFm2clr3TSxqWLTMPQ4KP4QumHiRj8nrjdSSPeysHC8bV7hajmxjGYvIdFwqwFphw+1HqJFJZsG4ve6KrcUyRtSbc2DDITPhS9yMsAG8iASSoU8g2SjQ3mXYYw1f3wuqoasYHyonbAaj20ux/dyCe237V0/ngICvBd+cVbz6FS8zjhzseCss6vTTGTImXany0D907CiSgDvUucYpFIJgUM/Bm4FZgPoGWKeuy0y9yPTkBQGtrgkUL3cYpczw92EGRrTpWhjSL8ZNswqyGUy2NYDrcVp7sSlkiaTFIQ6rK/ERNgsS1tsT5jIrC7kaz+UD7XlGa1sanXuRUDJN+fLQrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/25 02:16, Kairui Song wrote:
> On Fri, Jul 25, 2025 at 1:02 AM Kairui Song <ryncsn@gmail.com> wrote:
>>
>> On Thu, Jul 10, 2025 at 11:37 AM Kairui Song <ryncsn@gmail.com> wrote:
>>>
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> The current swap-in code assumes that, when a swap entry in shmem mapping
>>> is order 0, its cached folios (if present) must be order 0 too, which
>>> turns out not always correct.
>>>
>>> The problem is shmem_split_large_entry is called before verifying the
>>> folio will eventually be swapped in, one possible race is:
>>>
>>>      CPU1                          CPU2
>>> shmem_swapin_folio
>>> /* swap in of order > 0 swap entry S1 */
>>>    folio = swap_cache_get_folio
>>>    /* folio = NULL */
>>>    order = xa_get_order
>>>    /* order > 0 */
>>>    folio = shmem_swap_alloc_folio
>>>    /* mTHP alloc failure, folio = NULL */
>>>    <... Interrupted ...>
>>>                                   shmem_swapin_folio
>>>                                   /* S1 is swapped in */
>>>                                   shmem_writeout
>>>                                   /* S1 is swapped out, folio cached */
>>>    shmem_split_large_entry(..., S1)
>>>    /* S1 is split, but the folio covering it has order > 0 now */
>>>
>>> Now any following swapin of S1 will hang: `xa_get_order` returns 0, and
>>> folio lookup will return a folio with order > 0.  The
>>> `xa_get_order(&mapping->i_pages, index) != folio_order(folio)` will always
>>> return false causing swap-in to return -EEXIST.
>>>
>>> And this looks fragile.  So fix this up by allowing seeing a larger folio
>>> in swap cache, and check the whole shmem mapping range covered by the
>>> swapin have the right swap value upon inserting the folio.  And drop the
>>> redundant tree walks before the insertion.
>>>
>>> This will actually improve performance, as it avoids two redundant Xarray
>>> tree walks in the hot path, and the only side effect is that in the
>>> failure path, shmem may redundantly reallocate a few folios causing
>>> temporary slight memory pressure.
>>>
>>> And worth noting, it may seems the order and value check before inserting
>>> might help reducing the lock contention, which is not true.  The swap
>>> cache layer ensures raced swapin will either see a swap cache folio or
>>> failed to do a swapin (we have SWAP_HAS_CACHE bit even if swap cache is
>>> bypassed), so holding the folio lock and checking the folio flag is
>>> already good enough for avoiding the lock contention.  The chance that a
>>> folio passes the swap entry value check but the shmem mapping slot has
>>> changed should be very low.
>>>
>>> Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>>   mm/shmem.c | 30 +++++++++++++++++++++---------
>>>   1 file changed, 21 insertions(+), 9 deletions(-)
>>
>> Hi All,
>>
>> Just found some issue here with this patch...
>>
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 334b7b4a61a0..e3c9a1365ff4 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -884,7 +884,9 @@ static int shmem_add_to_page_cache(struct folio *folio,
>>>                                     pgoff_t index, void *expected, gfp_t gfp)
>>>   {
>>>          XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
>>> -       long nr = folio_nr_pages(folio);
>>> +       unsigned long nr = folio_nr_pages(folio);
>>> +       swp_entry_t iter, swap;
>>> +       void *entry;
>>>
>>>          VM_BUG_ON_FOLIO(index != round_down(index, nr), folio);
>>>          VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>>> @@ -896,14 +898,24 @@ static int shmem_add_to_page_cache(struct folio *folio,
>>>
>>>          gfp &= GFP_RECLAIM_MASK;
>>>          folio_throttle_swaprate(folio, gfp);
>>> +       swap = iter = radix_to_swp_entry(expected);
>>>
>>>          do {
>>>                  xas_lock_irq(&xas);
>>
>> I missed a xas_reset here, also better reset iter value too.
>>
>>> -               if (expected != xas_find_conflict(&xas)) {
>>> -                       xas_set_err(&xas, -EEXIST);
>>> -                       goto unlock;
>>> +               xas_for_each_conflict(&xas, entry) {
>>> +                       /*
>>> +                        * The range must either be empty, or filled with
>>> +                        * expected swap entries. Shmem swap entries are never
>>> +                        * partially freed without split of both entry and
>>> +                        * folio, so there shouldn't be any holes.
>>> +                        */
>>> +                       if (!expected || entry != swp_to_radix_entry(iter)) {
>>> +                               xas_set_err(&xas, -EEXIST);
>>> +                               goto unlock;
>>> +                       }
>>> +                       iter.val += 1 << xas_get_order(&xas);
>>>                  }
>>> -               if (expected && xas_find_conflict(&xas)) {
>>> +               if (expected && iter.val - nr != swap.val) {
>>>                          xas_set_err(&xas, -EEXIST);
>>>                          goto unlock;
>>>                  }
>>> @@ -2323,7 +2335,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>>>                          error = -ENOMEM;
>>>                          goto failed;
>>>                  }
>>> -       } else if (order != folio_order(folio)) {
>>> +       } else if (order > folio_order(folio)) {
>>>                  /*
>>>                   * Swap readahead may swap in order 0 folios into swapcache
>>>                   * asynchronously, while the shmem mapping can still stores
>>> @@ -2348,15 +2360,15 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>>>
>>>                          swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
>>>                  }
>>> +       } else if (order < folio_order(folio)) {
>>> +               swap.val = round_down(swap.val, 1 << folio_order(folio));
>>>          }
>>>
>>>   alloced:
>>>          /* We have to do this with folio locked to prevent races */
>>>          folio_lock(folio);
>>>          if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
>>> -           folio->swap.val != swap.val ||
>>> -           !shmem_confirm_swap(mapping, index, swap) ||
>>> -           xa_get_order(&mapping->i_pages, index) != folio_order(folio)) {
>>
>> And this part is incorrect. This `shmem_confirm_swap(mapping, index,
>> swap) ` can't be simply omitted. Some functions below before the
>> shmem_add_to_page_cache shouldn't be called on folios might have
>> already been mapped by others. This shmem_confirm_swap ensures that
>> won't happen.

OK, thanks for the reminding. But could you elaborate a bit? Which 
function should not be called, and what problem might be caused?

>> It may seem like a small change, but it leads to some minor conflicts
>> in one or two following commits, the benchmark result will change too.
>> So I'll have to send a V6 I think.
>>
>> We can remove this `shmem_confirm_swap`, but not in this series I
>> think, maybe after this. Need to re-arrange some functions, with some
>> clean ups for shmem_add_to_page_cache and others.
>>
>>> +           folio->swap.val != swap.val) {
>>>                  error = -EEXIST;
>>>                  goto unlock;
>>>          }
>>> --
>>> 2.50.0
>>>
>>
>> In summary, I'll squash this patch into it and do a rebase of later commits:
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index e3c9a1365ff4..4ca0b665b79e 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -898,9 +898,11 @@ static int shmem_add_to_page_cache(struct folio *folio,
>>
>>          gfp &= GFP_RECLAIM_MASK;
>>          folio_throttle_swaprate(folio, gfp);
>> -       swap = iter = radix_to_swp_entry(expected);
>> +       swap = radix_to_swp_entry(expected);
>>
>>          do {
>> +               iter = swap;
>> +               xas_reset(&xas);
> 
> Correction: this xas_reset is not needed, the iter = swap is needed.

Indeed, my tests do not cover the scenario where xas_nomem() returns true.

>>                  xas_lock_irq(&xas);
>>                  xas_for_each_conflict(&xas, entry) {
>>                          /*
>> @@ -2365,9 +2367,16 @@ static int shmem_swapin_folio(struct inode
>> *inode, pgoff_t index,
>>          }
>>
>>   alloced:
> 
> And it needs `nr_pages = folio_nr_pages(folio); index =
> round_down(index, nr_pages);` here...

IIUC, the index alignment should move into the 'order < 
folio_order(folio)' branch?

>> -       /* We have to do this with folio locked to prevent races */
>> +       /*
>> +        * We have to do this with folio locked to prevent races.
>> +        * The shmem_confirm_swap below only checks if the first swap
>> +        * entry matches the folio, that's enough to ensure the folio
>> +        * is not used outside of shmem, as shmem swap entrie
>> +        * and swap cache folios are never partially freed.
>> +        */
>>          folio_lock(folio);
>>          if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
>> +           !shmem_confirm_swap(mapping, index, swap) ||
>>              folio->swap.val != swap.val) {
>>                  error = -EEXIST;
>>                  goto unlock;
>>
>> And I'll do some clean up afterward to get rid of this
>> shmem_confirm_swap. How do you think?


