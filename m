Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 730D1CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEC416B03D7; Mon,  1 Jun 2026 10:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9C846B03D9; Mon,  1 Jun 2026 10:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A650B6B03DA; Mon,  1 Jun 2026 10:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 917C66B03D7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:38:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C1D190FA0
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:38:01 +0000 (UTC)
X-FDA: 84831598362.12.1308CE2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C5EE80014
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:37:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JvcuKBbC;
	spf=pass (imf02.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780324679; a=rsa-sha256;
	cv=none;
	b=UgesoscaHMMeojUMQvynW23yXYb+Hz4Ix6/X6GyS1KCIxOqJYhM+ZQ2PX6qz+tHwAs+2r1
	HJ3HJwoXgm7fD2PcLLIkCc2eyKdhNoDl4IHEa/tlMuZLptJddRAfK1RqOtkUERbdGm0oy5
	oD3KqBBoX8SF3Ea6lFWCohSaTiAlVeI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JvcuKBbC;
	spf=pass (imf02.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780324679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OybkN/MnWZxcEpWXBkhrHVcW6dWBDJmEtjbVKxEqFQQ=;
	b=B3kqTeFavVPpBSx8N9duxddeDpBlZ+RoHoNbq/x/Kaz/Ge5NIU8NDEU0PWsFY47MWeLbwy
	lFHWy3JdLWkEAJiDtTT5p9YHoYdGxH6+Nd+2Ttv1Mcqimlj8S9xIT4XiAPSjP7JbMqzGb5
	a3QBo0NKmggo1pl/jNU+3b9pM0XIjNE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=OybkN/MnWZxcEpWXBkhrHVcW6dWBDJmEtjbVKxEqFQQ=;
	b=JvcuKBbC4jlhe+9trAS6EoJ64nstSy3U2osEEAA5JOVuTAxG76gmVPCqctByBD
	DlGEVKqyDtZAGrfESGCOFBLf7PQnBnJs5dmP/fguZCmGgKKfmUhXMHVXkkIIVWTG
	H4xGS15FINKIk9zF43B6i9CoUZbwt/fCdcjiobFDwzhKg=
Received: from [192.168.5.171] (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD31yIamR1qL2s8Aw--.64956S2;
	Mon, 01 Jun 2026 22:37:15 +0800 (CST)
Message-ID: <f43d968a-8226-462b-98bf-53e69efec0b0@163.com>
Date: Mon, 1 Jun 2026 22:37:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 5/5] mm/shmem: optimize file read with folio batching
To: Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
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
 <6881f92c-972a-4b7a-b3c0-93a91ff38b88@linux.alibaba.com>
 <5f1a3e69-c090-42ac-913e-1e8ce2702e9a@163.com>
 <72817e0c-37d3-4a63-a6d3-1744370c896d@linux.alibaba.com>
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <72817e0c-37d3-4a63-a6d3-1744370c896d@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD31yIamR1qL2s8Aw--.64956S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Gw1DGr13Kr4xur4DKFyDWrg_yoW7Ww45pr
	WrG3ZrKrWUJry7Ar1Iqw10vrn3t34xJF4UXa47G3W7AF1qvFn3Kr1Utw1UuFyUAr1rGr10
	qr18KrW7WF1jyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j1UDJUUUUU=
X-Originating-IP: [58.20.13.92]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9xtO62odmRuxkQAA3c
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5C5EE80014
X-Stat-Signature: y3at43fyzxbgz4qi4mthx46dzfdkqtdj
X-HE-Tag: 1780324677-983978
X-HE-Meta: U2FsdGVkX19glc/xjgXfFyTu/kERdjdqmmmmvrV+yMZGHXdDnK2mlR3ZbdpkhzeLW1Uvbnkz5MafS0/RwZubNPEcg0QcoRq/7TW15W2OtdUPXRM12ptsxGZo6zNMzdaTW4QCcHclMxKjQITie5gBas+qSvJq85KVpluYJmD8Itjyfy1Si+0nt16g1TMC8db9tfSEpwPX5Fjkyu88HQhpgqQiqFHIxMB32I946SGEA5DELIRnD7jfLCmSB20FS9cl1Cb7clIaA6raw64kaDWeCn3lyp8qnP8udXLPaDAR1sGh5n1Dj9RMk4xi0mwAm2mW/JsjuxPpowa44B9r0ISpLzL12vIBUaqqEZxqs3qmaKwKkemwnEv6UHnIOoWoTCOXvxT7fYDzTflVeASIL/6WsW68kLVcpvyQVnSUMjwYoanw8CS5zBW5NI2A3ROqxHhTmP7Ih1VxrPj4hgoX1fWCUufRJNYxC1b8zgDWiLBmPrViHehBbJZjBF6JnJHbdoXywpydcwkX59D3fle7HvkY11hODUBimY+BeD8RszIyXJSJYaYlWFNmTgwJzYOdQ4QEHwSA4knysj4GmcsaSCFDzYLWVVZw3nE4eDiajVFgRYV69rb1SVqv0AJ+e2P/vFZYvovZVYKS21ftQssrXT8DCRC1vmZB4A9wD5o/cEqmRPQ8syIq8HbINv2M4DF18zdL1Mv8D1z36HvA2B0K2EbJctWf24d5DUEqNjJCkSfRby1opXvi/hxaJe4HrAtzdGW9B6AqLmShNhigSHwrDBASVH5Aa3P4cGt67EBWiaOqfHTPAS+bJoTy8kTpcUZKMLZKAJNq/l+ONFXTpKMvLZ3vCDdSLyXnEa9C3vPa9NE+3oYLsybfO1VGxbKOW5fO+Pd2N3L2/FCGVPZK18OkOvk51yRyr548zmXkDR1TCDlC+J94BhNgr1Wzvom68bW5BJp7ycT0b7CMQhyvVdKOcUO
 GvVlsvto
 DTMQSI3EVrtKsXKxgV+r7z9kc2gwr799RejRFuy+p7GuKXWbQ6IVsNA2ULoOETNlwlpa3N9IcO/fxTXwVEcrF0S+dpQDaiPznyaGE/MBIOc0GJPJmUD7vC2Iw8lhesl6sF+bXxX030J17zzfF/JG8bI87R/7xHn1fLyKlImT+WknH2lcabOdYiHCE7WM+CPNfEg5grnS5RsCqGiFXLkW45tDqd4JbqcO9tVoUHxXYYl5KeGBNuPBHKM7xCh1m2RzRacXIs5Cb99apK4l6iiK7yIhaoZCmjWzKpKEcUbQA2NCRas0j0iuHj9f9O7NAOf9W15Z/ye7yISJbnBoZSJqAoseGV3h8lT7psMkDmkkaFKJeTZKS3x96WrzVTcKL8U9AHcAq04Q/fI2IsDfeIj4IBMP25hj0oi5vYQEnMd5FawfnL54E87RtjSxV2D1p4p3fHWjDVjOABlsK69Y77ct8zvKz7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 7:20 PM, Baolin Wang wrote:
> 
> 
> On 5/26/26 3:12 PM, Chi Zhiling wrote:
>> On 5/26/26 11:11 AM, Baolin Wang wrote:
>>>
>>>
>>> On 5/25/26 5:47 PM, Chi Zhiling wrote:
>>>> On 5/25/26 4:37 PM, Baolin Wang wrote:
>>>>>
>>>>>
>>>>> On 5/20/26 6:15 PM, Chi Zhiling wrote:
>>>>>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>>>>>
>>>>>> Optimize shmem file read by using filemap_get_folios_contig() to
>>>>>> batch fetch contiguous folios from the page cache, reducing the
>>>>>> overhead of repeated shmem_get_folio() calls.
>>>>>>
>>>>>> When the folio batch is exhausted, attempt to refill it with
>>>>>> filemap_get_folios_contig(). If no folios are found (hole or swapped
>>>>>> out pages), fall back to shmem_get_folio() to handle these cases
>>>>>> individually.
>>>>>>
>>>>>> Additionally:
>>>>>> - Defer folio_put() until the batch is exhausted or on exit
>>>>>> - Add folio_test_uptodate() check before copying to ensure data
>>>>>>    validity
>>>>>>
>>>>>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>>>>>> ---
>>>>>>   mm/shmem.c | 50 ++++++++++++++++++++++++++++++++++++--------------
>>>>>>   1 file changed, 36 insertions(+), 14 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>>>>> index 96ea5a4c0aff..e0eacc23cccd 100644
>>>>>> --- a/mm/shmem.c
>>>>>> +++ b/mm/shmem.c
>>>>>> @@ -3355,11 +3355,14 @@ static ssize_t shmem_file_read_iter(struct 
>>>>>> kiocb *iocb, struct iov_iter *to)
>>>>>>       struct file *file = iocb->ki_filp;
>>>>>>       struct inode *inode = file_inode(file);
>>>>>>       struct address_space *mapping = inode->i_mapping;
>>>>>> +    struct folio_batch fbatch;
>>>>>>       pgoff_t index;
>>>>>>       unsigned long offset;
>>>>>>       int error = 0;
>>>>>>       ssize_t retval = 0;
>>>>>> +    folio_batch_init(&fbatch);
>>>>>> +
>>>>>>       for (;;) {
>>>>>>           struct folio *folio = NULL;
>>>>>>           struct page *page = NULL;
>>>>>> @@ -3372,18 +3375,38 @@ static ssize_t shmem_file_read_iter(struct 
>>>>>> kiocb *iocb, struct iov_iter *to)
>>>>>>               break;
>>>>>>           index = iocb->ki_pos >> PAGE_SHIFT;
>>>>>> -        error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
>>>>>> -        if (error) {
>>>>>> -            if (error == -EINVAL)
>>>>>> -                error = 0;
>>>>>> -            break;
>>>>>> +fetch:
>>>>>> +        folio = folio_batch_next(&fbatch);
>>>>>> +        if (!folio) {
>>>>>> +            pgoff_t start = index;
>>>>>> +            pgoff_t end = (iocb->ki_pos + to->count - 1) >> 
>>>>>> PAGE_SHIFT;
>>>>>> +
>>>>>> +            if (folio_batch_count(&fbatch)) {
>>>>>> +                for (int i = 0; i < folio_batch_count(&fbatch); i++)
>>>>>> +                    folio_put(fbatch.folios[i]);
>>>>>> +                folio_batch_reinit(&fbatch);
>>>>>> +            }
>>>>>> +
>>>>>> +            filemap_get_folios_contig(inode->i_mapping, &start, 
>>>>>> end, &fbatch);
>>>>>> +            if (folio_batch_count(&fbatch))
>>>>>> +                goto fetch;
>>>>>> +
>>>>>> +            error = shmem_get_folio(inode, index, 0, &folio, 
>>>>>> SGP_READ);
>>>>>> +            if (unlikely(error)) {
>>>>>> +                if (error == -EINVAL)
>>>>>> +                    error = 0;
>>>>>> +                break;
>>>>>> +            }
>>>>>> +            if (folio) {
>>>>>> +                folio_unlock(folio);
>>>>>> +                folio_batch_add(&fbatch, folio);
>>>>>> +                fbatch.i++;
>>>>>> +            }
>>>>>>           }
>>>>>> -        if (folio) {
>>>>>> -            folio_unlock(folio);
>>>>>> +        if (folio) {
>>>>>>               page = folio_file_page(folio, index);
>>>>>>               if (PageHWPoison(page)) {
>>>>>> -                folio_put(folio);
>>>>>>                   error = -EIO;
>>>>>>                   break;
>>>>>>               }
>>>>>
>>>>> I haven't tested it yet, but I'm sure this will break the 
>>>>> fallback_page_copy mode.
>>>>>
>>>>> You're fetching from the batch at folio granularity here, but in 
>>>>> fallback_page_copy mode, we still copy the data at page granularity.
>>>>
>>>> Yes, that's a bug, Sashika has already reported it. I’ll fix it in 
>>>> the next version.
>>>
>>> Good.
>>>
>>>> Sashika also reported another potential issue below, but I think 
>>>> that is a misunderstanding, because a folio fetched from the swap 
>>>> cache is already marked Uptodate before being added to the page 
>>>> cache. What do you think?
>>>
>>> I'm not concerned about swap-in folios, since we already ensure the 
>>> folio is uptodate when swapping out.
>>>
>>> What I'm worried about is that this change moves the 
>>> folio_test_uptodate() check outside of the folio lock, which could 
>>> introduce some race? Of course, with the original logic, the folio 
>>> state could also transition from !uptodate to uptodate after the folio
>>> is unlocked (I need more thought).
>>>
>>> Another race condition that needs to be addressed is, when getting 
>>> the folio locklessly via filemap_get_folios_contig(), there could be 
>>> a concurrent race with swap-out (because you removed the folio- 
>>> >mapping check under folio lock). This could result in reading zero 
>>> data when it shouldn't (the folio actually needs to be swapped in).
>>
>> Sorry, I don't fully understand what you mean. It seems that swap-out 
>> does not clear the uptodate flag, and the folio cannot be freed during 
>> the read operation because its reference count is held. So a swapped- 
>> out folio should not be mistaken for a zero-filled folio. Right?
> 
> Sorry for the late reply. Ah, I missed the held refcnt, and now sounds 
> reasonable.

I've just sent out v2. Feel free to comment. :)

https://lore.kernel.org/linux-fsdevel/20260601055704.167436-1-chizhiling@163.com/


