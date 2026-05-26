Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C70FCD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 07:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7085C6B008A; Tue, 26 May 2026 03:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DEFC6B008C; Tue, 26 May 2026 03:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4EF6B0095; Tue, 26 May 2026 03:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6746B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:13:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8A80A02F3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:13:23 +0000 (UTC)
X-FDA: 84808705086.07.556D256
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf06.hostedemail.com (Postfix) with ESMTP id 296C018000A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:13:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=OTW337En;
	spf=pass (imf06.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779779602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OsrxvTynmtU2f3TXx1zK/ZSLAbOC+Ly6ZdLq2+fEK+8=;
	b=p45zoNajee5i8kaFA5cVDVmP3ld/nem/m0tv8CxQrMP0zrEvbgDSScuX1MW9WQQSdCEeME
	M7OLcEmFvduNNf6bW8GtLCtvKylI7cYVLd7YyvpVNBN3NG3OasYDV3ZkTZvK9y3hhJotbK
	sU+DSMxWNaoEthXvY0PZOCJSad2/g/Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=OTW337En;
	spf=pass (imf06.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779779602; a=rsa-sha256;
	cv=none;
	b=n0ZR7YGgdH4XNp7Vz3Sf0JjpaKYwSOPKwXy+ah/wmFgrI7JlQLh+yvfx6Sj2qFao/0Gb/C
	x6XNagq5ar5rLRkP+oc8MY49GP26ImoTaP8F0HDOEFW6oYj1tlJ/HOx7U8NmbBsV7o4m9z
	Hu/EhPSsh4GqAlup/GGPTSCOn6dEYtw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=OsrxvTynmtU2f3TXx1zK/ZSLAbOC+Ly6ZdLq2+fEK+8=;
	b=OTW337EnCAtXlkpIeJ8xfNJpeemySjNDOND9jWwTXcCBuxr/g6Ff/rV/9k3z0K
	njjzwpOpMtUizhmxpY8P5DWkWz4SwEuk7+9yMl4xwLwjWNFFuWmeV3z+jURVk2GG
	oHTrYJd4XhKvqqBF5leXC+w/cf1coNNS575j8idzMZmyg=
Received: from [10.42.0.216] (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDnP2LNRxVql9VVDw--.30187S2;
	Tue, 26 May 2026 15:12:15 +0800 (CST)
Message-ID: <5f1a3e69-c090-42ac-913e-1e8ce2702e9a@163.com>
Date: Tue, 26 May 2026 15:12:13 +0800
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
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <6881f92c-972a-4b7a-b3c0-93a91ff38b88@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnP2LNRxVql9VVDw--.30187S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXr47Kry7Gr13GrWkJw4fZrb_yoWrtFWUpr
	WrG3ZxKrWkWrW7Ar1Sqw1FvFn3t34xtF4rXa4fG3W7AFn0vFn3Kr15tw15uFWrAr4rGr10
	qr10krW7WF1jyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRU5rcUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9w-kgmoVR88KPwAA3c
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 296C018000A
X-Stat-Signature: jsc8cfak14fktjmfjq68sb1ieu13u7u4
X-HE-Tag: 1779779600-445315
X-HE-Meta: U2FsdGVkX1/LKGK7VQimi6RfKDTbKn4UHFeNC+IoRvjU+6tN2IWwLoaAZFAknkYNVdP2k0XyJYXQCoMfI4z3kgy1fMy2VmDyLZfhYACxV1A0XKvs7TuG70XhEND7+wOO4XX62Jq5AmtkPhqU1FiAxdCG3+0jTVBrHC2VXcsq8NribgxV5aff9MpcVXON3bsnYXNPr5bHsuqq0Y7bUkGBVWeY5orrZPjmZ/KFFWjAnnOcpuTaX03LiwpZ+EKZFsR8w6+nMHhJ5F06F/vea3nSXP8MiJut144Sz3/8T7cwjpHitLtrCCWQDFWbOOA3CDyC1cuLHbIncJDsMYvQ0IoLMG0A+d62LMVClZIlShHv004EKEcBEnWl+wPiv2L6z3Mgb867Wy4MPz/D2ThcpZXV1kKILBOKQsjQc+iZ6XdQ0N1k0q+l913i2J4OIFxyzHhfQtWvmsQ5O4ZUZ8vM0z2SYmHq1Jz4horT8N/mtETaGKNYwRQQzhSjFnSEoh5X7/zIuFdPtUA2j5069PH+ihKrbN8KjKfNF2DY3W7O2MyqzXRj+kTWfJFtX+bjf9GnrCf/40nhRxyGrJXAqXzpN4PJwqyPLXEb6LnLtCMFV7aJEaIVWWE6R/1AYsbCQ+tbl9ElyJ+9zvSl40cR4/aK08o4Ayt/Q51frrOS6ddcFg5dz8gRMFwXoKvo1esi8L++lBRNXQnmjG2fcKtBsUVZJ5Bf+AylcdfPgndbYv+NKHcGXKjc2Eo7Bjh663Ejy1+GvsSZIsWiOfMxMIaAB/zH2ubVexomI2u0Z+6F7VFeE9IoowoV2Yfu2UxqosHOlrx1Cx4JAwYKKtUa5hcD4D0HcnwBvjqHB4SvtHbHnggxTrQpn1OyQIHAXmCeUB6FSs7hlCg2/RMkXIvpsjS+KTkfbKGwslmJ1OlzVPcP9bBIez09/VejnlA14IHNpEMwOGBRKjyAUIDWmWXHajkw7Sd1dk8
 UW8r6WxI
 nhxuXMKGRja+y2E1MqILGwFGOzF/gpCnInjHBHp7QwvNLC2ckLGcc0r/4ZRyrfl3L98oEc2JOD1Lw/aLKTwvlfWNrDQ2+Ala6VJDDWUVwH0fP/+m4hpsY4sk/y9masWf3zn+cPRG2KxxQdX4KJziKEtzS94vFr9g8KV6GPsLbzJx3tsdhiacTyah6UiPwwLivkPMREutD5eBh6wzMavVUYJPJWDfEswknOlRhdmskDtU7CWo0yT+gZlHBNdh5S8FyqN+LfRdaQY4qWQn6gs0Wj8RbVM/2xwQeDiYpJD+4Ds3mVkRdHANJfP7H+Z25TfUWOgBFccw2aQVnnCmkM8F6Vg4gw9Ap7Piu9pzZ0E8kApnfbUiFhhQJXJpu5UlT+ht8lDFhj6/D3as9aiTZiwQhfSX4vO79VMR30asS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 11:11 AM, Baolin Wang wrote:
> 
> 
> On 5/25/26 5:47 PM, Chi Zhiling wrote:
>> On 5/25/26 4:37 PM, Baolin Wang wrote:
>>>
>>>
>>> On 5/20/26 6:15 PM, Chi Zhiling wrote:
>>>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>>>
>>>> Optimize shmem file read by using filemap_get_folios_contig() to
>>>> batch fetch contiguous folios from the page cache, reducing the
>>>> overhead of repeated shmem_get_folio() calls.
>>>>
>>>> When the folio batch is exhausted, attempt to refill it with
>>>> filemap_get_folios_contig(). If no folios are found (hole or swapped
>>>> out pages), fall back to shmem_get_folio() to handle these cases
>>>> individually.
>>>>
>>>> Additionally:
>>>> - Defer folio_put() until the batch is exhausted or on exit
>>>> - Add folio_test_uptodate() check before copying to ensure data
>>>>    validity
>>>>
>>>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>>>> ---
>>>>   mm/shmem.c | 50 ++++++++++++++++++++++++++++++++++++--------------
>>>>   1 file changed, 36 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>>> index 96ea5a4c0aff..e0eacc23cccd 100644
>>>> --- a/mm/shmem.c
>>>> +++ b/mm/shmem.c
>>>> @@ -3355,11 +3355,14 @@ static ssize_t shmem_file_read_iter(struct 
>>>> kiocb *iocb, struct iov_iter *to)
>>>>       struct file *file = iocb->ki_filp;
>>>>       struct inode *inode = file_inode(file);
>>>>       struct address_space *mapping = inode->i_mapping;
>>>> +    struct folio_batch fbatch;
>>>>       pgoff_t index;
>>>>       unsigned long offset;
>>>>       int error = 0;
>>>>       ssize_t retval = 0;
>>>> +    folio_batch_init(&fbatch);
>>>> +
>>>>       for (;;) {
>>>>           struct folio *folio = NULL;
>>>>           struct page *page = NULL;
>>>> @@ -3372,18 +3375,38 @@ static ssize_t shmem_file_read_iter(struct 
>>>> kiocb *iocb, struct iov_iter *to)
>>>>               break;
>>>>           index = iocb->ki_pos >> PAGE_SHIFT;
>>>> -        error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
>>>> -        if (error) {
>>>> -            if (error == -EINVAL)
>>>> -                error = 0;
>>>> -            break;
>>>> +fetch:
>>>> +        folio = folio_batch_next(&fbatch);
>>>> +        if (!folio) {
>>>> +            pgoff_t start = index;
>>>> +            pgoff_t end = (iocb->ki_pos + to->count - 1) >> 
>>>> PAGE_SHIFT;
>>>> +
>>>> +            if (folio_batch_count(&fbatch)) {
>>>> +                for (int i = 0; i < folio_batch_count(&fbatch); i++)
>>>> +                    folio_put(fbatch.folios[i]);
>>>> +                folio_batch_reinit(&fbatch);
>>>> +            }
>>>> +
>>>> +            filemap_get_folios_contig(inode->i_mapping, &start, 
>>>> end, &fbatch);
>>>> +            if (folio_batch_count(&fbatch))
>>>> +                goto fetch;
>>>> +
>>>> +            error = shmem_get_folio(inode, index, 0, &folio, 
>>>> SGP_READ);
>>>> +            if (unlikely(error)) {
>>>> +                if (error == -EINVAL)
>>>> +                    error = 0;
>>>> +                break;
>>>> +            }
>>>> +            if (folio) {
>>>> +                folio_unlock(folio);
>>>> +                folio_batch_add(&fbatch, folio);
>>>> +                fbatch.i++;
>>>> +            }
>>>>           }
>>>> -        if (folio) {
>>>> -            folio_unlock(folio);
>>>> +        if (folio) {
>>>>               page = folio_file_page(folio, index);
>>>>               if (PageHWPoison(page)) {
>>>> -                folio_put(folio);
>>>>                   error = -EIO;
>>>>                   break;
>>>>               }
>>>
>>> I haven't tested it yet, but I'm sure this will break the 
>>> fallback_page_copy mode.
>>>
>>> You're fetching from the batch at folio granularity here, but in 
>>> fallback_page_copy mode, we still copy the data at page granularity.
>>
>> Yes, that's a bug, Sashika has already reported it. I’ll fix it in the 
>> next version.
> 
> Good.
> 
>> Sashika also reported another potential issue below, but I think that 
>> is a misunderstanding, because a folio fetched from the swap cache is 
>> already marked Uptodate before being added to the page cache. What do 
>> you think?
> 
> I'm not concerned about swap-in folios, since we already ensure the 
> folio is uptodate when swapping out.
> 
> What I'm worried about is that this change moves the 
> folio_test_uptodate() check outside of the folio lock, which could 
> introduce some race? Of course, with the original logic, the folio state 
> could also transition from !uptodate to uptodate after the folio
> is unlocked (I need more thought).
> 
> Another race condition that needs to be addressed is, when getting the 
> folio locklessly via filemap_get_folios_contig(), there could be a 
> concurrent race with swap-out (because you removed the folio->mapping 
> check under folio lock). This could result in reading zero data when it 
> shouldn't (the folio actually needs to be swapped in).

Sorry, I don't fully understand what you mean. It seems that swap-out 
does not clear the uptodate flag, and the folio cannot be freed during 
the read operation because its reference count is held. So a swapped-out 
folio should not be mistaken for a zero-filled folio. Right?



