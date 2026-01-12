Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1AFDD2504D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 08:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413CF6B0088; Mon, 12 Jan 2026 03:22:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C27E6B0089; Mon, 12 Jan 2026 03:22:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3986B008A; Mon, 12 Jan 2026 03:22:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 174326B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 03:22:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C97461B88B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:22:34 +0000 (UTC)
X-FDA: 84322620228.17.839C4B3
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf19.hostedemail.com (Postfix) with ESMTP id CCD531A0006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:22:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MsQqVW+L;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768206153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ad7R/+eI3g9Xu6IbHx4VEjDEO9JdlcbHLzN6J0fDGaI=;
	b=Dp1Rh7q29aBL2DgNkRY48awWFyJ/YNBvor4EoU8k47H9Hl1owyWZuqM2KKnIvWqAtIaFOO
	r3ntlppm1zxLFdPGE1v0lI6jXoD7MU4WwBg9f855LaKrwswiUXflUvcBJYUWejl6/DNn3B
	YwL/RL+WoqMu1BJnyKttwaqh55MYLAY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MsQqVW+L;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768206153; a=rsa-sha256;
	cv=none;
	b=GpFiA0UK/jAMOPgJdHKBvxRox96te7BAi2V2AO0WFiGwMuXkX9PGQSHrVAeWlvPw10nPfg
	3tRGYz9t2rbFMVIexJBpat+8D+aRJ29s+AqA0Z01M0sn90vKBxNBKC+pN0P23WcX/2LrID
	Pv+pdJd/r4+cNRwch6V8wbGknqZ9MKE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768206148; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ad7R/+eI3g9Xu6IbHx4VEjDEO9JdlcbHLzN6J0fDGaI=;
	b=MsQqVW+LxIe5wkdCWgVsbKdUr6YJpuyQxEpxbTsbKZBUUgOccjusfMUiip5MYREdAKana9EQevKXxcFfgspH6TIDMJ7AqvaMAaIBWvFa9miL1BRtnu6Fp7K7ev0VrQ0D/zY3I6q+oPeRBPNNBmdkwFvbPt5MundXZKELv89eOBc=
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wwr3iRU_1768206145 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Jan 2026 16:22:26 +0800
Message-ID: <1dffe6b1-7a89-4468-8101-35922231f3a6@linux.alibaba.com>
Date: Mon, 12 Jan 2026 16:22:24 +0800
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7ASxBdAakd_3J3O-nPysArLruGO-j4rCHg6OFvvNq7f0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: krbk8ruk1rww1xnqn5idfourme588c6f
X-Rspamd-Queue-Id: CCD531A0006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768206151-826423
X-HE-Meta: U2FsdGVkX1+g6IvEC2Dgp7pLVpWpA5YLIAUtzksVJX3t15VORPOluGOo4PBOYh3JRtzeOYeFkfgRWk+UCsNpc7+RZgt1HKxenxHDXl5uPCpawI2b60G4kuy7AijynumBxXuVVICuswLO+AdmXhSqeUQU9WPnlyyXEb3WRFQ3i/IaUiTkooFRTjfp1MK4iJM9hgP59vGilw90qhoJvgHU3/9ngXtw6aCojXwRFQslphx0vUpkWAstCP8nzUhQkErmowBac98xXSnrm1S58kx1XoMDMhOdfeG8KujHaNZVJgYZHKVbkmlsPrLb7V9ZcHGKOlyIg5m0lqhTefAeJJy7P2AhiB5HSt/p1UVIgOs8aklXk37jhOnC1JfGxWgrN+LvhK8SlvHopAQx8kvIq8ucxWuNDfYoUkw96VgOp7bzHPl0mapyGL5dUb2DgUvX9xH7MkqqcHw2v3h16rdl6uMSmet3mdLrorL9rvSypBaPG+4W7wocsMMMqVhwOnZos3XLvT8CbZ57mzN3cWsTPZzzlc+/dxRb6dm9obZDXckxJcIrNFvY3AK6FQmHEnl8hzqRu0uqa6HLQV+LDVyMvawf2jFR9wG97d0GeorTZ8sqxY4P7RpdfZwIcdRTNhZdJKM1hlsbBu1ADdQ1KWgzYywt3wez1ztJvB+IZKix3lWpvugqL6k2N0PQlfbevhAIfd6EEDevolQMySmiX9tywpJQmuOUMRT3YaGgHdIZimEpapejPVtXooxOJoysd1enQCY3ILq/Cq9VJN6MpuGiBMu+Vq1GLhUi154ssqafluc/cphfeNVu9Y9MMyD+LN8SF1Fo1igFCcjYPuucnV0vYP5ICNyVEB/tjbZ88l/RL73TQCtqg8BXZg08qvrSPmyVnIA5DR3W6YpFy+uSbcDF6m//shhZ9EIYXTuAA32SUjMhBoltWBTg9pGKLuU8R3uF6/3Wi5vNON21IvxPgGuwZbX
 veYB8/Le
 5sVBOWyODmXpV3yJRhoOXBNRSXd9ZAHikqgoSFd0CH2C2PBhSxWAEuG+gPStCoNYYnOOeIjqlHMxg5z6DAwEyXIVYZeLDRASgxnyxM+SzeGVKaO7aErqPdXt4yt4fxBfamcunzhdKl23quBMpK1w+nXsi1pVvk4z9wtcNB1fig5i3aFIVGmObnEKVhzNbrRyY/ut6XFsW24OgX93wT9VmThAV2FCOcNcuIb0Rr7MRKhZVM4T+FIDO6PtaRcio2EN9e9BGVr3/6myFXEpe08qo6JjlmchESOG6oIxFdR6h1gMvg9R2lgaWkQRfl1xDpjgsyR+7HrBSN8Hb700W0+vyegsSDpFbhSoz3vGl3bOmIlfWkqSpNU9h7T6uoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/12/26 1:56 PM, Kairui Song wrote:
> On Mon, Jan 12, 2026 at 12:00 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>> On 1/12/26 1:53 AM, Kairui Song wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> The helper for shmem swap freeing is not handling the order of swap
>>> entries correctly. It uses xa_cmpxchg_irq to erase the swap entry,
>>> but it gets the entry order before that using xa_get_order
>>> without lock protection. As a result the order could be a stalled value
>>> if the entry is split after the xa_get_order and before the
>>> xa_cmpxchg_irq. In fact that are more way for other races to occur
>>> during the time window.
>>>
>>> To fix that, open code the Xarray cmpxchg and put the order retrivial and
>>> value checking in the same critical section. Also ensure the order won't
>>> exceed the truncate border.
>>>
>>> I observed random swapoff hangs and swap entry leaks when stress
>>> testing ZSWAP with shmem. After applying this patch, the problem is resolved.
>>>
>>> Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>>    mm/shmem.c | 35 +++++++++++++++++++++++------------
>>>    1 file changed, 23 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 0b4c8c70d017..e160da0cd30f 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -961,18 +961,28 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
>>>     * the number of pages being freed. 0 means entry not found in XArray (0 pages
>>>     * being freed).
>>>     */
>>> -static long shmem_free_swap(struct address_space *mapping,
>>> -                         pgoff_t index, void *radswap)
>>> +static long shmem_free_swap(struct address_space *mapping, pgoff_t index,
>>> +                         unsigned int max_nr, void *radswap)
>>>    {
>>> -     int order = xa_get_order(&mapping->i_pages, index);
>>> -     void *old;
>>> +     XA_STATE(xas, &mapping->i_pages, index);
>>> +     unsigned int nr_pages = 0;
>>> +     void *entry;
>>>
>>> -     old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
>>> -     if (old != radswap)
>>> -             return 0;
>>> -     swap_put_entries_direct(radix_to_swp_entry(radswap), 1 << order);
>>> +     xas_lock_irq(&xas);
>>> +     entry = xas_load(&xas);
>>> +     if (entry == radswap) {
>>> +             nr_pages = 1 << xas_get_order(&xas);
>>> +             if (index == round_down(xas.xa_index, nr_pages) && nr_pages < max_nr)
>>> +                     xas_store(&xas, NULL);
>>> +             else
>>> +                     nr_pages = 0;
>>> +     }
>>> +     xas_unlock_irq(&xas);
>>> +
>>> +     if (nr_pages)
>>> +             swap_put_entries_direct(radix_to_swp_entry(radswap), nr_pages);
>>>
>>> -     return 1 << order;
>>> +     return nr_pages;
>>>    }
>>
>> Thanks for the analysis, and it makes sense to me. Would the following
>> implementation be simpler and also address your issue (we will not
>> release the lock in __xa_cmpxchg() since gfp = 0)?
> 
> Hi Baolin,
> 
>>
>> static long shmem_free_swap(struct address_space *mapping,
>>                               pgoff_t index, void *radswap)
>> {
>>           XA_STATE(xas, &mapping->i_pages, index);
>>           int order;
>>           void *old;
>>
>>           xas_lock_irq(&xas);
>>           order = xas_get_order(&xas);
> 
> Thanks for the suggestion. I did consider implementing it this way,
> but I was worried that the order could grow upwards. For example
> shmem_undo_range is trying to free 0-95 and there is an entry at 64
> with order 5 (64 - 95). Before shmem_free_swap is called, the entry
> was swapped in, then the folio was freed, then an order 6 folio was
> allocated there and swapped out again using the same entry.
> 
> Then here it will free the whole order 6 entry (64 - 127), while
> shmem_undo_range is only supposed to erase (0-96).

Good point. However, this cannot happen during swapoff, because the 
'end' is set to -1 in shmem_evict_inode().

Actually, the real question is how to handle the case where a large swap 
entry happens to cross the 'end' when calling shmem_truncate_range(). If 
the shmem mapping stores a folio, we would split that large folio by 
truncate_inode_partial_folio(). If the shmem mapping stores a large swap 
entry, then as you noted, the truncation range can indeed exceed the 'end'.

But with your change, that large swap entry would not be truncated, and 
I’m not sure whether that might cause other issues. Perhaps the best 
approach is to first split the large swap entry and only truncate the 
swap entries within the 'end' boundary like the 
truncate_inode_partial_folio() does.

Alternatively, this patch could only focus on the race on the order, 
which seems uncontested. As for handling large swap entries that go 
beyond the 'end', should we address that in a follow-up, for example by 
splitting? What do you think?

> That's why I added a max_nr argument to the helper. The GFP == 0 below
> looks not very clean either, that's trivial though.
> 
>>           old = __xa_cmpxchg(xas.xa, index, radswap, NULL, 0);
> 
> Am I overthinking it?


