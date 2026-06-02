Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F00BC5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 06:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8896B00A0; Tue,  2 Jun 2026 02:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88ED6B00A3; Tue,  2 Jun 2026 02:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9E386B00A4; Tue,  2 Jun 2026 02:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8F1E6B00A0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:18:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4230491F35
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:18:17 +0000 (UTC)
X-FDA: 84833967834.01.AD9C973
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0DBF1180005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:18:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=nUL0AUC2;
	spf=pass (imf24.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780381095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6w4mGCqzHENp4jk9gAMrbzBGsGOC3Xwp2PsWkL6dAbU=;
	b=X3R/xj9FoTw03WfH6/Gyqf5zTljlNu3yHkBLEedToZlT70Xm64dSqkC8EGlCq715/Eg3y2
	ohmp4/1oFIFi0pusn00sC8gIt8T27C/5SlivhGEUc52vow62ohsHpK7FWeUd4iDLnXIRYd
	5OQh6fGbP9IyQmcPWX5Xv7CSVV1uLb8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780381095;
	b=nkJkPADXiid+6CmKN/iyk0atOEZNZRNGVvvE/yUb88DL/JW5TJ7s4+GwHZfh0hiNpLfZVT
	m+cWznkEiM2elO4lR9uyL8epmQVqiwQ7s6CzMNDASYlMelaRhtrImWIofRfW2/9PitZcID
	VyVMFyFZeKsTa9U3yD9DNe78dVUeulc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=nUL0AUC2;
	spf=pass (imf24.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=6w4mGCqzHENp4jk9gAMrbzBGsGOC3Xwp2PsWkL6dAbU=;
	b=nUL0AUC2+jQxRt/bvguX2SP9uUUfQzw6gpNHzKGGXGbVfkM/f+M4OUSAy6RBIG
	9ncdXe7dHndpRiLUHY7PPRmK5dzfO6U3UUgApeJTOvumOU4+TmFXLI+NFDgXMmUA
	NgP+u0w46AKgIDsZhbFX1ef7uWkMcTLJlOAC4IG/YgNss=
Received: from [10.42.20.201] (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3nwKBdR5qZ6nqAw--.5050S2;
	Tue, 02 Jun 2026 14:17:37 +0800 (CST)
Message-ID: <59de56ad-585e-43da-a6c9-7107c6433bdd@163.com>
Date: Tue, 2 Jun 2026 14:17:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] mm/shmem: remove page-copy fallback in shmem read
 path
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20260601055704.167436-1-chizhiling@163.com>
 <20260601055704.167436-5-chizhiling@163.com>
 <06a4c4a0-fc3c-488e-9015-04f0532650f2@linux.alibaba.com>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <06a4c4a0-fc3c-488e-9015-04f0532650f2@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3nwKBdR5qZ6nqAw--.5050S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAr1xtw4kCw1xuw47ur4Durg_yoWrZr1Upr
	WfKanIyF48Jay7Cr13XF4DZryrt3s3JFW8JayfG3WfJ3ZFyF95KFWUt3409FW3A347A3WI
	gw4qkr9rua1Ut3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U5kuxUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC+AGfPWoedYHd1AAA3S
X-Rspamd-Queue-Id: 0DBF1180005
X-Rspam-User: 
X-Stat-Signature: i4i1p8rdo1gy9efm1xt554kjtic7mjk4
X-Rspamd-Server: rspam08
X-HE-Tag: 1780381093-961544
X-HE-Meta: U2FsdGVkX18Tc+etEE30+0Mhtecxrxymj7+44fBonoxqyJkIBVZ6RZQe8I7aiZNrWwK7xPI0wbgknLi20JXA3vEa7irzVfr/ELXzKq5pttiV/Wmob6WqcTAQk2ip3twJqvaXoSoGMx2nMQo5n4tkzLmF0rK70+2yD2ejqN7AYHj4q+kDpwL7vUz10B6b1yh3reQZf0PgvO4+IhQVWyfb6VtNFAZbXci4c4n0gtZB8AL4rmX48JQyigcal4G/1rFkym6jetv/2IFL7Wx41dc/STiIQxuVgG2x2abb94ONOUr3HOJR1k4ohWCueVS6nS95ow1Y+ofTFkkxxP5X9vaMTv1/WUWHrwbePchqXkOnOsX9w3nd1ZBVP6u1A4cenC2pIw79CyAlmWfOp0HxCOUeKGe2NzSdseYJBlV1cYyjECXyyy9LEbxFy+iD3f5KQpOpW9OGWStgElWnCTAox3Gj2h+8T5wj1eG2RJLBaEEuFqdpVhE8R/TDOQeBUewtlC5qpQu3PNEU9Dg1rk1VCQrPAhlLgTzZu/8jK+27ZyEO3IUHzEa1p5xlbSOs4ribXuN1sn564bc5snorx4G4O7D6bljN7Ipv4hcME5ASYLrFl9rZ5DCS4LJFLzUZJIiIC/1I2bC8mGeGrpSu65leS/0FAtLBevT9nrHO0Y4c3uLBwHQHtRRs9rkFi6QhGkAKnvEdG+6YmcTxtOGrzfPdt26bhFmnGyQyO3WADoMKMdN4Q9fyJ6dbQCrVdzIaXpv7zdvfNCbLjyhqA1w/WlSal2S1vvD56DxVTzgGQL3o8iFCLRqSYEzXJ2RaK2jAGbWyF4mHUtJ3L+unn2BlK452PCg1znZWFLs6mI5WJVDwrDHHY1goS7Y9s8Nyria4rSRTe0rclYkA+sibzhYqf8vCnG3hleGMiCfwGUU47JJEuTfsz3BCF2v/YDeN5vmkDm12PgQtD27FLRRkCeMeo8mWUpY
 5IlIiY3Q
 r8d8w3mdN7codpdLBFB2alXO/Cky1cp2d4p3qkZHzb6ZQTjPberEnrbQlEIOsJl3iJLe5ECbgIOXzV4B9AfA6pY4O/R4qE3mt3ApwwdDeeF+AIiwjS4zNraGpaF8SFLsaER6qck9n5s0XpGQtj3A/Vo/Vi6z9XdaYY3h94Nz0cI3CwvM5JhZgZoW8j8X78Ti8s3JaCOfEl0FJcCtcUuD8vR0xak1j4eEy6A9LPt1quKRsV4NjUCK90iSKD7MshoCzctUbQdsL1xNTheh5l7Pn7npE1BkgjV5VEs47d3pcqJ1ph7q7o3Pmg96ztFYO+TfiYHoZkkwiv817jF24h1uKaBa79pgMNBXQOxAF0otmph3QFwieTZXSiD/nWmXe54yj+s65D5sWwK7uh+sW3wpDncVqJipvO0pgticJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 13:39, Baolin Wang wrote:
> 
> 
> On 6/1/26 1:57 PM, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> This is perp patch for folio batch support which removing the fallback
>> to page-copy mode from shmem reads.
>>
>> The existing hwpoison fallback would require fetching the same folio
>> multiple times to read its each pages, which complicates the
>> batching model. Instead, move hwpoison handling into
>> copy_each_pages_to_iter(), allowing the error path to be centralized.
>>
>> This simplifies the shmem fast read path and avoids special-case
>> handling that conflicts with folio batching support.
>>
>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>> ---
>>   mm/shmem.c | 63 +++++++++++++++++++++++++++++-------------------------
>>   1 file changed, 34 insertions(+), 29 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index b08118fbd275..cac355685e49 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -3353,6 +3353,30 @@ static size_t copy_zero_to_iter(size_t bytes, 
>> struct iov_iter *i)
>>       return written;
>>   }
>> +static size_t copy_pages_to_iter(struct folio *folio, size_t offset,
>> +        size_t bytes, struct iov_iter *i, int *error)
>> +{
>> +    struct page *page;
>> +    unsigned long off, nr, ret, written = 0;
>> +
>> +    do {
>> +        page = folio_page(folio, offset >> PAGE_SHIFT);
>> +        if (PageHWPoison(page)) {
>> +            *error = -EIO;
>> +            break;
>> +        }
>> +
>> +        off = offset_in_page(offset);
>> +        nr = min(PAGE_SIZE - off, bytes - written);
>> +
>> +        ret = copy_page_to_iter(page, off, nr, i);
>> +        offset += ret;
>> +        written += ret;
>> +    } while (written < bytes && ret == nr);
>> +
>> +    return written;
>> +}
>> +
>>   static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct 
>> iov_iter *to)
>>   {
>>       struct file *file = iocb->ki_filp;
>> @@ -3365,10 +3389,8 @@ static ssize_t shmem_file_read_iter(struct 
>> kiocb *iocb, struct iov_iter *to)
>>       for (;;) {
>>           struct folio *folio = NULL;
>> -        struct page *page = NULL;
>>           unsigned long nr, ret;
>>           loff_t end_offset, i_size = i_size_read(inode);
>> -        bool fallback_page_copy = false;
>>           size_t fsize;
>>           if (unlikely(iocb->ki_pos >= i_size))
>> @@ -3376,25 +3398,13 @@ static ssize_t shmem_file_read_iter(struct 
>> kiocb *iocb, struct iov_iter *to)
>>           index = iocb->ki_pos >> PAGE_SHIFT;
>>           error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
>> +        if (folio)
>> +            folio_unlock(folio);
>>           if (error) {
>>               if (error == -EINVAL)
>>                   error = 0;
>>               break;
>>           }
>> -        if (folio) {
>> -            folio_unlock(folio);
>> -
>> -            page = folio_file_page(folio, index);
>> -            if (PageHWPoison(page)) {
>> -                folio_put(folio);
>> -                error = -EIO;
>> -                break;
>> -            }
>> -
>> -            if (folio_test_large(folio) &&
>> -                folio_test_has_hwpoisoned(folio))
>> -                fallback_page_copy = true;
>> -        }
>>           /*
>>            * We must evaluate after, since reads (unlike writes)
>> @@ -3406,12 +3416,9 @@ static ssize_t shmem_file_read_iter(struct 
>> kiocb *iocb, struct iov_iter *to)
>>                   folio_put(folio);
>>               break;
>>           }
>> -        end_offset = min_t(loff_t, i_size, iocb->ki_pos + to->count);
>> -        if (folio && likely(!fallback_page_copy))
>> -            fsize = folio_size(folio);
>> -        else
>> -            fsize = PAGE_SIZE;
>> +        fsize = folio ? folio_size(folio) : PAGE_SIZE;
>>           offset = iocb->ki_pos & (fsize - 1);
>> +        end_offset = min_t(loff_t, i_size, iocb->ki_pos + to->count);
> 
> Do not add this unnecessary change.

Okay,

> 
>>           nr = min_t(loff_t, end_offset - iocb->ki_pos, fsize - offset);
>>           if (folio) {
>> @@ -3420,12 +3427,8 @@ static ssize_t shmem_file_read_iter(struct 
>> kiocb *iocb, struct iov_iter *to)
>>                * virtual addresses, take care about potential aliasing
>>                * before reading the page on the kernel side.
>>                */
>> -            if (mapping_writably_mapped(mapping)) {
>> -                if (likely(!fallback_page_copy))
>> -                    flush_dcache_folio(folio);
>> -                else
>> -                    flush_dcache_page(page);
>> -            }
>> +            if (mapping_writably_mapped(mapping))
>> +                flush_dcache_folio(folio);
> 
> I'm not sure this is safe for all architectures (it's safe for arm64 
> since no actual data cache flush happens here), but for architectures 
> that do perform an actual data cache flush, if the page has already been 
> hwpoisoned, flushing the cache could trigger a RAS error?
> 
> I think you should move this into copy_pages_to_iter() for hwpoisoned 
> folios.

Okay, will fix it, thanks!


