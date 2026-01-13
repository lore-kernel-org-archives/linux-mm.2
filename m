Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D186BD29DE0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 07:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E7956B0005; Tue, 13 Jan 2026 02:16:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395D46B0089; Tue, 13 Jan 2026 02:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 293986B008A; Tue, 13 Jan 2026 02:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 156F26B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:16:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A136488BA6
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:16:24 +0000 (UTC)
X-FDA: 84326082288.27.7EE4005
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf22.hostedemail.com (Postfix) with ESMTP id D07C5C0009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:16:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Zx0AQn1M;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768288583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZNhFnQEZUXJnPJHL10ktoc1HOWLSt8s0MJQfSG/HMI=;
	b=I4ijgsH5ieiRrCXdBLyXGzCd54n+Vj4QCIw/Ky6/rQl1AktVLOOrI7Gb0vS+uAHUThlO1B
	kspe8U9/1JVHox8/STjbaq49VIN/hr8AIWozweqw3GxkN3+WLwuC+Mk1d77B/xvLdjd18x
	0ilvW3yC8Za7YMPYVBvYFimSeAMdb7I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Zx0AQn1M;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768288583; a=rsa-sha256;
	cv=none;
	b=A4C0fQW7W2afm29HGjaSiuJ1kc/DObWFV7ijWTOp3cZkvQ2sRVVVh96IWKN0Qm77B8a/1v
	mVRO4+4qqSvfdofVA3NmiGwvXMRqu5fGIPwu5V4vxQdquGBbee1C7tjxi0Tw0s6cHLkzc/
	mbqLkMfuFZ7lTZkK8w60qa7QwUM6dq8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768288579; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IZNhFnQEZUXJnPJHL10ktoc1HOWLSt8s0MJQfSG/HMI=;
	b=Zx0AQn1M7H9hU4BKW9+YYFnlbZ5dg96Y6mMniAGGZoCdbzXrfCJh7ezIr2mgRFZT/K99k6A4SyQOoB/YFMBz1AyM+VZtSqUu3I0bzbY6W55sNoVjjK1+ms9gYaXA9qwM9qlAgwuw6ya445Ai+8eIfJhbgTCrpYI8j2HXwTH903Y=
Received: from 30.74.144.126(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WwzyEDF_1768288577 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 13 Jan 2026 15:16:17 +0800
Message-ID: <d95f9ea4-aa47-4d85-9b76-11afd0fb3ee7@linux.alibaba.com>
Date: Tue, 13 Jan 2026 15:16:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem, swap: fix race of truncate and swap entry split
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260112-shmem-swap-fix-v1-1-0f347f4f6952@tencent.com>
 <d20f536c-edc1-42a0-9978-13918d39ecba@linux.alibaba.com>
 <CAMgjq7ASxBdAakd_3J3O-nPysArLruGO-j4rCHg6OFvvNq7f0g@mail.gmail.com>
 <1dffe6b1-7a89-4468-8101-35922231f3a6@linux.alibaba.com>
 <CAMgjq7Biq9nB_waZeWW+iJUa9Pj+paSSrke-tmnB=-3uY8k2VA@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7Biq9nB_waZeWW+iJUa9Pj+paSSrke-tmnB=-3uY8k2VA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D07C5C0009
X-Stat-Signature: fmc76xgpudhhkdohfmypwrzzr1a9zch9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768288581-44060
X-HE-Meta: U2FsdGVkX19JkHNBDhtrKlO+xU4kUAmLY/7mzUQ5hSRywF6gvnGCVfN43RZqHPGogRKUcO+G5Cik8RnOlv/DuOtBDGlJdueh8BCk24j2eT7DStKodo5dipmfPCDNaJ1r3QpM+C23b0gK9c2JwjgKjLY8g8UxCSjXxmvSLrt7QWBXg6XOzWs3pcc9GcVwcdV3xdqWjDIhYXGTTABZFBHmtlY+1BM2HCJpGUHPmKjd32Z+aIRrR32TtBtQGhhPEAGH1qc+wE7Di7LO87h9b+qsYArAccW/6jG64ahAp6Ssu7r/B1Z6eVqw6MujWTn/kBL28P5jBMlwFIxvowt0542e+rR120EcYXT8EYCCEebg/0ca5St2I8ZiH7k932URgQFqxsVeQxwkkjK7whc03lGjcccr3CzhbDo4RIc/RVL+cBtwYAg8MNAo1Bm29lA4GJ6+vUysQL5iSmjxAwMGk49hNII0J791a255bscnqkV8z9F/SnobinodbJ75ByBoXbpMFvSPUDb0tfxrGquhBvkBZS1S5DxyJAAvGdkM6lHLVsU0S/X3TTEZGaGc6bejThjXVDzZN+5MA8npOsQU15iCbyCXm2CCxNUB+PyvPN0EG1XfZZsP1Fzoh8cSzWokl+d7HnLjt6w2E7/4WG5uPnEQdF3xIbIv5wCpZMinJhUx2zwtLSr1vNyG+fGpvzzYS757bNhu/BYUmTJPqKnqMYPHAI+Nl22vo7zo9VGUeg7hlB0qevvd0NAhWZTO4NUSlpyFmkUDgQ92rM+oHTfQ/T2qooArgjFJrwcxfuT6Zck0HK48rrSH4L3hfHrB+gTV9BiMRNqSPaiVmIEPch0ginTxscELRpbm8tw7O5DyzLnRk1+ySJY7fWNGkjFsArV5kk+1axqPHVCEaDzc9Vwql34qIbPn33qNChiS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

Sorry for late reply.

On 1/12/26 5:55 PM, Kairui Song wrote:
> On Mon, Jan 12, 2026 at 4:22 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>> On 1/12/26 1:56 PM, Kairui Song wrote:
>>> On Mon, Jan 12, 2026 at 12:00 PM Baolin Wang
>>> <baolin.wang@linux.alibaba.com> wrote:
>>>> On 1/12/26 1:53 AM, Kairui Song wrote:
>>>>> From: Kairui Song <kasong@tencent.com>
>>>>>
>>>>> The helper for shmem swap freeing is not handling the order of swap
>>>>> entries correctly. It uses xa_cmpxchg_irq to erase the swap entry,
>>>>> but it gets the entry order before that using xa_get_order
>>>>> without lock protection. As a result the order could be a stalled value
>>>>> if the entry is split after the xa_get_order and before the
>>>>> xa_cmpxchg_irq. In fact that are more way for other races to occur
>>>>> during the time window.
>>>>>
>>>>> To fix that, open code the Xarray cmpxchg and put the order retrivial and
>>>>> value checking in the same critical section. Also ensure the order won't
>>>>> exceed the truncate border.
>>>>>
>>>>> I observed random swapoff hangs and swap entry leaks when stress
>>>>> testing ZSWAP with shmem. After applying this patch, the problem is resolved.
>>>>>
>>>>> Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>>>> ---
>>>>>     mm/shmem.c | 35 +++++++++++++++++++++++------------
>>>>>     1 file changed, 23 insertions(+), 12 deletions(-)
>>>>>
>>>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>>>> index 0b4c8c70d017..e160da0cd30f 100644
>>>>> --- a/mm/shmem.c
>>>>> +++ b/mm/shmem.c
>>>>> @@ -961,18 +961,28 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
>>>>>      * the number of pages being freed. 0 means entry not found in XArray (0 pages
>>>>>      * being freed).
>>>>>      */
>>>>> -static long shmem_free_swap(struct address_space *mapping,
>>>>> -                         pgoff_t index, void *radswap)
>>>>> +static long shmem_free_swap(struct address_space *mapping, pgoff_t index,
>>>>> +                         unsigned int max_nr, void *radswap)
>>>>>     {
>>>>> -     int order = xa_get_order(&mapping->i_pages, index);
>>>>> -     void *old;
>>>>> +     XA_STATE(xas, &mapping->i_pages, index);
>>>>> +     unsigned int nr_pages = 0;
>>>>> +     void *entry;
>>>>>
>>>>> -     old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
>>>>> -     if (old != radswap)
>>>>> -             return 0;
>>>>> -     swap_put_entries_direct(radix_to_swp_entry(radswap), 1 << order);
>>>>> +     xas_lock_irq(&xas);
>>>>> +     entry = xas_load(&xas);
>>>>> +     if (entry == radswap) {
>>>>> +             nr_pages = 1 << xas_get_order(&xas);
>>>>> +             if (index == round_down(xas.xa_index, nr_pages) && nr_pages < max_nr)
>>>>> +                     xas_store(&xas, NULL);
>>>>> +             else
>>>>> +                     nr_pages = 0;
>>>>> +     }
>>>>> +     xas_unlock_irq(&xas);
>>>>> +
>>>>> +     if (nr_pages)
>>>>> +             swap_put_entries_direct(radix_to_swp_entry(radswap), nr_pages);
>>>>>
>>>>> -     return 1 << order;
>>>>> +     return nr_pages;
>>>>>     }
>>>>
>>>> Thanks for the analysis, and it makes sense to me. Would the following
>>>> implementation be simpler and also address your issue (we will not
>>>> release the lock in __xa_cmpxchg() since gfp = 0)?
>>>
>>> Hi Baolin,
>>>
>>>>
>>>> static long shmem_free_swap(struct address_space *mapping,
>>>>                                pgoff_t index, void *radswap)
>>>> {
>>>>            XA_STATE(xas, &mapping->i_pages, index);
>>>>            int order;
>>>>            void *old;
>>>>
>>>>            xas_lock_irq(&xas);
>>>>            order = xas_get_order(&xas);
>>>
>>> Thanks for the suggestion. I did consider implementing it this way,
>>> but I was worried that the order could grow upwards. For example
>>> shmem_undo_range is trying to free 0-95 and there is an entry at 64
>>> with order 5 (64 - 95). Before shmem_free_swap is called, the entry
>>> was swapped in, then the folio was freed, then an order 6 folio was
>>> allocated there and swapped out again using the same entry.
>>>
>>> Then here it will free the whole order 6 entry (64 - 127), while
>>> shmem_undo_range is only supposed to erase (0-96).
>>
>> Good point. However, this cannot happen during swapoff, because the
>> 'end' is set to -1 in shmem_evict_inode().
> 
> That's not only for swapff, shmem_truncate_range / falloc can also use it right?

Yes, so I just mentioned your swapoff case.

>> Actually, the real question is how to handle the case where a large swap
>> entry happens to cross the 'end' when calling shmem_truncate_range(). If
>> the shmem mapping stores a folio, we would split that large folio by
>> truncate_inode_partial_folio(). If the shmem mapping stores a large swap
>> entry, then as you noted, the truncation range can indeed exceed the 'end'.
>>
>> But with your change, that large swap entry would not be truncated, and
>> I’m not sure whether that might cause other issues. Perhaps the best
>> approach is to first split the large swap entry and only truncate the
>> swap entries within the 'end' boundary like the
>> truncate_inode_partial_folio() does.
> 
> Right... I was thinking that the shmem_undo_range iterates the undo
> range twice IIUC, in the second try it will retry if shmem_free_swap
> returns 0:
> 
> swaps_freed = shmem_free_swap(mapping, indices[i], end - indices[i], folio);
> if (!swaps_freed) {
>      /* Swap was replaced by page: retry */
>      index = indices[i];
>      break;
> }
> 
> So I thought shmem_free_swap returning 0 is good enough. Which is not,
> it may cause the second loop to retry forever.

After further investigation, I think your original fix seems to be the 
right direction, as the second loop’s find_lock_entries() will filter 
out large swap entries crossing the 'end' boundary. Sorry for noise.

See the code in find_lock_entries() (Thanks to Hugh:))

	} else {
		nr = 1 << xas_get_order(&xas);
		base = xas.xa_index & ~(nr - 1);
		/* Omit order>0 value which begins before the start */
		if (base < *start)
			continue;
		/* Omit order>0 value which extends beyond the end */
		if (base + nr - 1 > end)
			break;
	}

Then the shmem_get_partial_folio() will swap-in the large swap entry and 
split the large folio which crosses the 'end' boundary.

So we don't need to split the large swap entry.

As for your original code, can you pass the 'end' to the 
shmem_free_swap() just like the find_lock_entries() does? Something like 
below (untested):

static long shmem_free_swap(struct address_space *mapping,
                             pgoff_t index, pgoff_t end, void *radswap)
{
         XA_STATE(xas, &mapping->i_pages, index);
         unsigned int nr_pages = 0;
         void *entry;

         xas_lock_irq(&xas);
         entry = xas_load(&xas);
         if (entry == radswap) {
                 nr_pages = 1 << xas_get_order(&xas);
                 base = xas.xa_index & ~(nr_pages - 1);
                 if (base < index || base + nr_pages - 1 > end)
                         nr_pages = 0;
                 else
                         xas_store(&xas, NULL);
         }
         xas_unlock_irq(&xas);

         if (nr_pages)
                 swap_put_entries_direct(radix_to_swp_entry(radswap), 
nr_pages);

         return nr_pages;
}

