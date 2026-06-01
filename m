Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1577CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1CA26B0332; Mon,  1 Jun 2026 07:20:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF46B6B0333; Mon,  1 Jun 2026 07:20:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D31806B0334; Mon,  1 Jun 2026 07:20:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4EF06B0332
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:20:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7779F1C0710
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:20:14 +0000 (UTC)
X-FDA: 84831099948.30.388E898
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf15.hostedemail.com (Postfix) with ESMTP id 26E55A0013
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:20:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LVbC7ehc;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780312812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IRfMuzG3yKuY5rg+diXsrslBNyfmmtnGq7jInIoNeyM=;
	b=1MH+7tqD3umM2QixOxU59XH06aob4NJXjfDf2CljO66lK/h3cj7iIj0NtKRZGRqfKL9y0R
	k199KSeVwpunK0Eo3beYOrNCWHP/dk1ZBUJWN/L+QMJ16wUYuIj2qCpLGtbSP7EiW6axfw
	lfLtBy0+ver/WTqcUSC2Y0ArvLhzAN4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LVbC7ehc;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780312812; a=rsa-sha256;
	cv=none;
	b=IF/3zE/v8RU6ewyBU49CR8WeOlAOwGWSz+HE9M7n2AJkPkLw6fHiv7mLaN7NvQZso29jTt
	4jCTokDfITXAhQNM86DX9ER6QG6KoEt2eYV5gblfQ3gnhCAPI2aJQMX3N3nd0caJ+PDY8f
	s5MAC9llXi6klorXILNq1seHerEXUZg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780312808; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IRfMuzG3yKuY5rg+diXsrslBNyfmmtnGq7jInIoNeyM=;
	b=LVbC7ehcJXQ6ysDHd3coxDI6Zuf/YpKmoevswZXiQV3OPfelaDsCFSPaszbz8HWVGLAxwhw6vOlDjpnbAkycQNifLs0I6uoK+9tgysNF7zYa19omplB/Z0zy99wG220ip4fFlkLMu0IXfFZvTO9dWt7Fcko2uS2FWyf1Z9omXag=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X4-llN8_1780312805;
Received: from 30.166.19.62(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4-llN8_1780312805 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 01 Jun 2026 19:20:05 +0800
Message-ID: <72817e0c-37d3-4a63-a6d3-1744370c896d@linux.alibaba.com>
Date: Mon, 1 Jun 2026 19:20:04 +0800
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
 <6881f92c-972a-4b7a-b3c0-93a91ff38b88@linux.alibaba.com>
 <5f1a3e69-c090-42ac-913e-1e8ce2702e9a@163.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <5f1a3e69-c090-42ac-913e-1e8ce2702e9a@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 26E55A0013
X-Stat-Signature: q6wmwtribsax5iqcdktwz8zqhtbbkjtu
X-HE-Tag: 1780312810-306853
X-HE-Meta: U2FsdGVkX1/olpi3Z8ayVZ3wqbP7lUedLEL2cT9Iu410uE23nWIdQLUCyIgjNcbSY6V/ULw/N6pH+tpgg1yG3mBWkHzQh2tyVOMq2wuEBRaJ4i8AW1zlccDbXoMFj8j7nHpFpjcIPK5rQd5L75csTK3cKul1sS0F8O+RddZr0w9bQW3Aq5riP/pT7091HgSj5LuuMO3FkTfot0K7Id5rdTSLijb8mHJx0HOUxlRNLLcHPFN15g5H3dQypdnMM3x+POB6VBvayszu0WTCAD0d3qwz0cWx6qSZeQ/0uB1sep5IYfEkZL2UhQLkpPKtTt06XJVkp0cNVKGBefzLueVmOnxtm1QFa0BmlTSfEyaVRa3imXco8Z9rl9pnq5xIv4Wi6VYIYaYlWNdO8GE00H3TZV22aqZSa0vTFhSiN1ZeDmOpztTyy/BMO1xkixJKhPulr54PV5zI0r7IGrmxSd8zW5O8Egr4DyU1lLs0U3jhmuUF9Tz3uDSl7tM71+GkFihhhPMeZqLvJmtsmBTdJfOgJQb6Hi7tqOaixLuueoFpaBp70roIJUT7zpd6+nFLG6XfzyQfhS5GUzWn2i13xfwLHRYuCM4RYVAOPRo3O3lrx5xMcOLi8XBZtvhIKvSydpXpAFXu8sm4u5dG1jQDAnJtfBBaHc31JxSd9/qqLhbyneKc3KGtRqwZjuhXjFzJpf09CZELCubz2ZxntksYU2ed9vSZ5QdhCDKxQXB51ZD0IoUh86/rmjxS+R0dpltWTri4FY0djcgj5ZOsmFKcXYM/2/C7cUDIABC/9iiNFWcdk2/CuSsgF5q7pbLUAqfyYTmCZw2ALivA3pIdB1GR++cvy375H3eBOm3tbudUW4v8S3itlF+1h2nac8uTqryBy//2OlOCGmA0pR1+BX/gls8ox43C3Qv8s13BVfpSco14wXLQZ21J/pr2xSAKD8ogna9pCisQJpuSNsu94Jqk6az
 5hns+U0P
 fIN9NoTvtuTtF7kFUgg/zY3ZTjRWAiKsiXAASzhlQVlQo9h3EdyHfdspZrs4McZYM1AlZMWOiQssGxtY+QewN/tUno3cuWJkYP5a5YGEw7NGrLY6onUuODfnXOp3K+CcjH4V+3qBp9yPcfSwzTuMivdPp6GweupTSVKP723xiYHg0wise18SHSkV4T9od6DCqwMwHZmjXn375j7Yqesn3soo4L4wIgifIkJfnW5q0Ovo3ajvr9yUMRR2oeoqRffD0I7MfMO5f5U/jBKJ0PpjvCztHFeqY5kt87j+sza6PWk2VcT2N/ld3Z8Gx7reFBXyV3fjnnB4pgmGHx2adxf2ALoTV8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/26/26 3:12 PM, Chi Zhiling wrote:
> On 5/26/26 11:11 AM, Baolin Wang wrote:
>>
>>
>> On 5/25/26 5:47 PM, Chi Zhiling wrote:
>>> On 5/25/26 4:37 PM, Baolin Wang wrote:
>>>>
>>>>
>>>> On 5/20/26 6:15 PM, Chi Zhiling wrote:
>>>>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>>>>
>>>>> Optimize shmem file read by using filemap_get_folios_contig() to
>>>>> batch fetch contiguous folios from the page cache, reducing the
>>>>> overhead of repeated shmem_get_folio() calls.
>>>>>
>>>>> When the folio batch is exhausted, attempt to refill it with
>>>>> filemap_get_folios_contig(). If no folios are found (hole or swapped
>>>>> out pages), fall back to shmem_get_folio() to handle these cases
>>>>> individually.
>>>>>
>>>>> Additionally:
>>>>> - Defer folio_put() until the batch is exhausted or on exit
>>>>> - Add folio_test_uptodate() check before copying to ensure data
>>>>>    validity
>>>>>
>>>>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>>>>> ---
>>>>>   mm/shmem.c | 50 ++++++++++++++++++++++++++++++++++++--------------
>>>>>   1 file changed, 36 insertions(+), 14 deletions(-)
>>>>>
>>>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>>>> index 96ea5a4c0aff..e0eacc23cccd 100644
>>>>> --- a/mm/shmem.c
>>>>> +++ b/mm/shmem.c
>>>>> @@ -3355,11 +3355,14 @@ static ssize_t shmem_file_read_iter(struct 
>>>>> kiocb *iocb, struct iov_iter *to)
>>>>>       struct file *file = iocb->ki_filp;
>>>>>       struct inode *inode = file_inode(file);
>>>>>       struct address_space *mapping = inode->i_mapping;
>>>>> +    struct folio_batch fbatch;
>>>>>       pgoff_t index;
>>>>>       unsigned long offset;
>>>>>       int error = 0;
>>>>>       ssize_t retval = 0;
>>>>> +    folio_batch_init(&fbatch);
>>>>> +
>>>>>       for (;;) {
>>>>>           struct folio *folio = NULL;
>>>>>           struct page *page = NULL;
>>>>> @@ -3372,18 +3375,38 @@ static ssize_t shmem_file_read_iter(struct 
>>>>> kiocb *iocb, struct iov_iter *to)
>>>>>               break;
>>>>>           index = iocb->ki_pos >> PAGE_SHIFT;
>>>>> -        error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
>>>>> -        if (error) {
>>>>> -            if (error == -EINVAL)
>>>>> -                error = 0;
>>>>> -            break;
>>>>> +fetch:
>>>>> +        folio = folio_batch_next(&fbatch);
>>>>> +        if (!folio) {
>>>>> +            pgoff_t start = index;
>>>>> +            pgoff_t end = (iocb->ki_pos + to->count - 1) >> 
>>>>> PAGE_SHIFT;
>>>>> +
>>>>> +            if (folio_batch_count(&fbatch)) {
>>>>> +                for (int i = 0; i < folio_batch_count(&fbatch); i++)
>>>>> +                    folio_put(fbatch.folios[i]);
>>>>> +                folio_batch_reinit(&fbatch);
>>>>> +            }
>>>>> +
>>>>> +            filemap_get_folios_contig(inode->i_mapping, &start, 
>>>>> end, &fbatch);
>>>>> +            if (folio_batch_count(&fbatch))
>>>>> +                goto fetch;
>>>>> +
>>>>> +            error = shmem_get_folio(inode, index, 0, &folio, 
>>>>> SGP_READ);
>>>>> +            if (unlikely(error)) {
>>>>> +                if (error == -EINVAL)
>>>>> +                    error = 0;
>>>>> +                break;
>>>>> +            }
>>>>> +            if (folio) {
>>>>> +                folio_unlock(folio);
>>>>> +                folio_batch_add(&fbatch, folio);
>>>>> +                fbatch.i++;
>>>>> +            }
>>>>>           }
>>>>> -        if (folio) {
>>>>> -            folio_unlock(folio);
>>>>> +        if (folio) {
>>>>>               page = folio_file_page(folio, index);
>>>>>               if (PageHWPoison(page)) {
>>>>> -                folio_put(folio);
>>>>>                   error = -EIO;
>>>>>                   break;
>>>>>               }
>>>>
>>>> I haven't tested it yet, but I'm sure this will break the 
>>>> fallback_page_copy mode.
>>>>
>>>> You're fetching from the batch at folio granularity here, but in 
>>>> fallback_page_copy mode, we still copy the data at page granularity.
>>>
>>> Yes, that's a bug, Sashika has already reported it. I’ll fix it in 
>>> the next version.
>>
>> Good.
>>
>>> Sashika also reported another potential issue below, but I think that 
>>> is a misunderstanding, because a folio fetched from the swap cache is 
>>> already marked Uptodate before being added to the page cache. What do 
>>> you think?
>>
>> I'm not concerned about swap-in folios, since we already ensure the 
>> folio is uptodate when swapping out.
>>
>> What I'm worried about is that this change moves the 
>> folio_test_uptodate() check outside of the folio lock, which could 
>> introduce some race? Of course, with the original logic, the folio 
>> state could also transition from !uptodate to uptodate after the folio
>> is unlocked (I need more thought).
>>
>> Another race condition that needs to be addressed is, when getting the 
>> folio locklessly via filemap_get_folios_contig(), there could be a 
>> concurrent race with swap-out (because you removed the folio->mapping 
>> check under folio lock). This could result in reading zero data when 
>> it shouldn't (the folio actually needs to be swapped in).
> 
> Sorry, I don't fully understand what you mean. It seems that swap-out 
> does not clear the uptodate flag, and the folio cannot be freed during 
> the read operation because its reference count is held. So a swapped-out 
> folio should not be mistaken for a zero-filled folio. Right?

Sorry for the late reply. Ah, I missed the held refcnt, and now sounds 
reasonable.

