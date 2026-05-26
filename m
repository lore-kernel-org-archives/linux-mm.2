Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80746CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE446B0005; Mon, 25 May 2026 23:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95A06B0093; Mon, 25 May 2026 23:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD20E6B0095; Mon, 25 May 2026 23:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE1F6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:11:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 452D5A010A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:11:49 +0000 (UTC)
X-FDA: 84808096338.13.255C6AB
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id EA2B31A0002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:11:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vW5feQWS;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779765107; a=rsa-sha256;
	cv=none;
	b=4wCg/+lK2s58jfHg6f0HflI88+fSppjzyl+a4Dqkf24j2jUykp3oMlvWFgMbP43Yt2Kn8i
	+Sgjhx3bgio6ixWf2osvv5d8GkNl0QyipeHT4bZ9t1zm/qvk0F2g5FxPCTMeqdr3EbVVAd
	UF7kBPkPk/Axd4kKGhjBgrDL7W9nmok=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vW5feQWS;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779765107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7v33FftUcaSJVVadLdgHYBmh6TcIYmBJ6C9+IhpAVE=;
	b=ij6onO7eHVJT6E6GlpkQXOecOXlzB1TLdHxU7M7YFI+5tgz1wP7o8YzuWwPLC7CMz0s+zJ
	U9TTnz3rbyeG/eFd5LHvbhC7J7M0/q52BvXF5iDZ7vGFNAUZPJYFRgSQvmnS7/tVppjUIq
	kb4W0mvo3BQfaMNVgiTiT41dX8hHqBI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779765102; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=W7v33FftUcaSJVVadLdgHYBmh6TcIYmBJ6C9+IhpAVE=;
	b=vW5feQWSt5yxOfhU04FB1GfmyEYxXsa17xGRUPIcaK2oc7s1T+99QQaezcvIB2+qStmR7NepLA/guD4nEYUgmbZZmohG0dz/2HVLStL1id8jrwGaqMnP5ErlubQV4nl3z0Vehi2oXF7AlTAxtecEGEbcgUlYA4NEuc7Chamiq3A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X3eu4Cu_1779765099;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X3eu4Cu_1779765099 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 26 May 2026 11:11:40 +0800
Message-ID: <6881f92c-972a-4b7a-b3c0-93a91ff38b88@linux.alibaba.com>
Date: Tue, 26 May 2026 11:11:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 5/5] mm/shmem: optimize file read with folio batching
To: Chi Zhiling <chizhiling@163.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Chi Zhiling <chizhiling@kylinos.cn>
References: <20260520101538.58745-1-chizhiling@163.com>
 <20260520101538.58745-6-chizhiling@163.com>
 <1d8c7c24-b273-4826-9a9e-37fdb0767f2f@linux.alibaba.com>
 <1fd099de-97d9-4a54-a97f-062fbae1d88e@163.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <1fd099de-97d9-4a54-a97f-062fbae1d88e@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EA2B31A0002
X-Rspamd-Server: rspam03
X-Stat-Signature: 9fu57o6y4uw6i3bkfy6ooa6ct4urprzw
X-HE-Tag: 1779765105-464101
X-HE-Meta: U2FsdGVkX19E29tHmV8164qXXXSeFX8RIj+4nZWfF1/RVhxbd9AnCvXZuvGizruEGfrsWxrYuIit813rNQK2qMYLa6Qozlkz2rSI2GXFGPa7ESoAu1E2x8tb7v+DNzz61eHfo0qyG+Oi85KGRFLmQ+jkJbY1tUxnzagZY86LT5UOrJRvyuRHy5groalbkOy0zEQi5sUKXdt9oDE6wqJ5r5dm5mGF9fGC/x++HLXhzbTBUF8gNEoRO3m4OO8maOvYoY73pMjABTysWVCSf0bgbi1XDZyI+S8UMFn9SXkguGEqyRCRWq6gJX25EsCMR81dPY1JQ6oVAACwkBYnnIryfEgueHev6VXI1moWXw23OzMrG6Sb7NL8MadOrvUPuzO3sntfYKxgLvh3lpc93QB5t/ZGs4sDTyE7eaFA3tbvXLLfpE7zUz8agltlWvQxRw+iS6n3ASLSq3SayFUy1bHUvb6J+u64YIVkr656sqNK3+mc6DLOTD6d8n7kmJbZhROlkwXbUdBC0Mnao5668xyNejIIGj03Ou0KP7/30pzbltgtigx8AfxUbDMHO1JPDaMNMulxQdOcMBhUEKkOeW2IXRQf4Eo8UinSQ7d1LYug4+wIheCxQo46Buor+jw01elLegSZ5SCVKGSWA8McZmGEY60p0L6FUxWDQu0Qiul2PQhS/kz8E0X7Y5KDjIsSJFKGX0RpDUsNpHwL5wLV7YDO4BpWYkGuuB4iupokyizJAPjnxn+nOSYE7hOsPmUtEzhjP9ywBUruAn0Ex+Nd2yfrznGMr9+m+U8u+X7EwlWErdMy0tETlu2TEUg2BOjV2ErSBmW06HUGQwqrMnwOHW19HcRFAAJRxzPQSk9M7FYzSoGj174d8jWWSEiNsacHLupZv95oD46dw2xRllXrgngTRGU6BqC6wSAVLShjrnRtHGfHiS6RhLo5xH6hE3L0Z7BPjhKnhW7q6Y2pFq8ee1N
 +CNFD+D2
 ebgJKzujC0y2jx/5rIB3+y5yi2bWKjQpwjeSDpFVVP7/dU3eD65vgQutfWF6bZ75dLHLQ5RDD5ZYRF+rSx9gAw5JpgxB7OWiRIBGD2pZAfEYw2HMaIF7nHK/G7jPRpqnVxsd3wcKYE3vkk2+ZIu7sIiT5zpfrDpvylY+IHKvvPfk4gw6qVnpLLooSfZ4hwMiOgA/t+Mqf+Ua857QShI90eul9h+2L7f2e3Z37nKdp2Jmx8mtH5Hi2t5yJ4nUlgO5PK1UqBxxmKcAf9XpOmIsczgqqmW0jMgq3s8vzvpEsXz7BJPzNgZfLgrvdAbQM4bs9wv7PsOWvl/eGUQR3rYVwTihinA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/25/26 5:47 PM, Chi Zhiling wrote:
> On 5/25/26 4:37 PM, Baolin Wang wrote:
>>
>>
>> On 5/20/26 6:15 PM, Chi Zhiling wrote:
>>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>>
>>> Optimize shmem file read by using filemap_get_folios_contig() to
>>> batch fetch contiguous folios from the page cache, reducing the
>>> overhead of repeated shmem_get_folio() calls.
>>>
>>> When the folio batch is exhausted, attempt to refill it with
>>> filemap_get_folios_contig(). If no folios are found (hole or swapped
>>> out pages), fall back to shmem_get_folio() to handle these cases
>>> individually.
>>>
>>> Additionally:
>>> - Defer folio_put() until the batch is exhausted or on exit
>>> - Add folio_test_uptodate() check before copying to ensure data
>>>    validity
>>>
>>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>>> ---
>>>   mm/shmem.c | 50 ++++++++++++++++++++++++++++++++++++--------------
>>>   1 file changed, 36 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 96ea5a4c0aff..e0eacc23cccd 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -3355,11 +3355,14 @@ static ssize_t shmem_file_read_iter(struct 
>>> kiocb *iocb, struct iov_iter *to)
>>>       struct file *file = iocb->ki_filp;
>>>       struct inode *inode = file_inode(file);
>>>       struct address_space *mapping = inode->i_mapping;
>>> +    struct folio_batch fbatch;
>>>       pgoff_t index;
>>>       unsigned long offset;
>>>       int error = 0;
>>>       ssize_t retval = 0;
>>> +    folio_batch_init(&fbatch);
>>> +
>>>       for (;;) {
>>>           struct folio *folio = NULL;
>>>           struct page *page = NULL;
>>> @@ -3372,18 +3375,38 @@ static ssize_t shmem_file_read_iter(struct 
>>> kiocb *iocb, struct iov_iter *to)
>>>               break;
>>>           index = iocb->ki_pos >> PAGE_SHIFT;
>>> -        error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
>>> -        if (error) {
>>> -            if (error == -EINVAL)
>>> -                error = 0;
>>> -            break;
>>> +fetch:
>>> +        folio = folio_batch_next(&fbatch);
>>> +        if (!folio) {
>>> +            pgoff_t start = index;
>>> +            pgoff_t end = (iocb->ki_pos + to->count - 1) >> PAGE_SHIFT;
>>> +
>>> +            if (folio_batch_count(&fbatch)) {
>>> +                for (int i = 0; i < folio_batch_count(&fbatch); i++)
>>> +                    folio_put(fbatch.folios[i]);
>>> +                folio_batch_reinit(&fbatch);
>>> +            }
>>> +
>>> +            filemap_get_folios_contig(inode->i_mapping, &start, end, 
>>> &fbatch);
>>> +            if (folio_batch_count(&fbatch))
>>> +                goto fetch;
>>> +
>>> +            error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
>>> +            if (unlikely(error)) {
>>> +                if (error == -EINVAL)
>>> +                    error = 0;
>>> +                break;
>>> +            }
>>> +            if (folio) {
>>> +                folio_unlock(folio);
>>> +                folio_batch_add(&fbatch, folio);
>>> +                fbatch.i++;
>>> +            }
>>>           }
>>> -        if (folio) {
>>> -            folio_unlock(folio);
>>> +        if (folio) {
>>>               page = folio_file_page(folio, index);
>>>               if (PageHWPoison(page)) {
>>> -                folio_put(folio);
>>>                   error = -EIO;
>>>                   break;
>>>               }
>>
>> I haven't tested it yet, but I'm sure this will break the 
>> fallback_page_copy mode.
>>
>> You're fetching from the batch at folio granularity here, but in 
>> fallback_page_copy mode, we still copy the data at page granularity.
> 
> Yes, that's a bug, Sashika has already reported it. I’ll fix it in the 
> next version.

Good.

> Sashika also reported another potential issue below, but I think that is 
> a misunderstanding, because a folio fetched from the swap cache is 
> already marked Uptodate before being added to the page cache. What do 
> you think?

I'm not concerned about swap-in folios, since we already ensure the 
folio is uptodate when swapping out.

What I'm worried about is that this change moves the 
folio_test_uptodate() check outside of the folio lock, which could 
introduce some race? Of course, with the original logic, the folio state 
could also transition from !uptodate to uptodate after the folio
is unlocked (I need more thought).

Another race condition that needs to be addressed is, when getting the 
folio locklessly via filemap_get_folios_contig(), there could be a 
concurrent race with swap-out (because you removed the folio->mapping 
check under folio lock). This could result in reading zero data when it 
shouldn't (the folio actually needs to be swapped in).

