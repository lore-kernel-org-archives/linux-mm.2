Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2071CD4F48
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 07:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9ECC6B0005; Mon, 18 May 2026 03:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B505E6B0088; Mon, 18 May 2026 03:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65826B008C; Mon, 18 May 2026 03:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95DE96B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 03:43:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4AEB516145E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:43:57 +0000 (UTC)
X-FDA: 84779751714.19.AB5A1E2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf11.hostedemail.com (Postfix) with ESMTP id BE5EE40005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:43:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=BS9VvLCu;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf11.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779090235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CvxCUqPx5MzhsfmsS+WFjrFDeZc/GotbEpJ6mkFhxeE=;
	b=BVAhxOQS9CvYVgZcnP+CZpfCFib448XTmfKHLIkxWSEtlA4/XZkR6qqt1/eCIEUxl7TFzd
	d+KFX1hCTVbqQ3n5OK838T11IRtcjRRVMU89uOsPlAyCmWUb45VwO3pTWrmTWBvMvIbYUX
	iP39vxVQNpX6y6Nzp3JFL6AeB3dZrow=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779090235; a=rsa-sha256;
	cv=none;
	b=MrbMeHSUVD3iCHNkXivqNo3vIXuqXFfUfmQnqK3bkgP3YHxM6EbL1bzDPbA7TObOFMWuaD
	ir4JQujBYsM9DDgyJqmcPb8De3CEGLZP1iLuUcgfrfFS3mmWGs5pixlXf4SCINc0heqUck
	qyCjk5QbgeiN9JSuwuXHZI8CqWeKQx8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=BS9VvLCu;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf11.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=chizhiling@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=CvxCUqPx5MzhsfmsS+WFjrFDeZc/GotbEpJ6mkFhxeE=;
	b=BS9VvLCuUcnGKQ8t9nen4Bp4R24JlIdnZFeIXsQMAEr496e2PjDKxufIBFvP01
	7aMi4GVVY4r2dYfl28Z2PMPjhDY7rSPaYbnWpWFMF0wD0YrljDFhdjdI141CQ3u5
	PUffXZXKvSpPGQBVgeAqhvWJ3ud+bDyYjsJaPo84Chhcc=
Received: from [10.42.20.201] (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3P2_cwgpqtTEtCA--.6564S2;
	Mon, 18 May 2026 15:42:22 +0800 (CST)
Message-ID: <f5cfe918-8bf1-4494-80ea-32863df1d1df@163.com>
Date: Mon, 18 May 2026 15:42:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] mm/shmem: use SGP_GET in read operations
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20260515094702.1092355-1-chizhiling@163.com>
 <20260515094702.1092355-3-chizhiling@163.com>
 <c0a6e4ea-3ca5-4efc-af5e-b5abc968308b@linux.alibaba.com>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <c0a6e4ea-3ca5-4efc-af5e-b5abc968308b@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3P2_cwgpqtTEtCA--.6564S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZw18tw18ArWDZFyftF1xGrg_yoW5XFyxpr
	W3KasIkr4kJ347Zry2vay8Za4093yxJFW8Ja43t34xZFn8XF1fKrWIg3Wrua45CrZ7A3W0
	q3W093y0v3WYyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UcqXQUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9x4FomoKwt4pWgAA3B
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE5EE40005
X-Stat-Signature: f38r3tqtiyf3hwyj73jj5qssgag6yky3
X-Rspam-User: 
X-HE-Tag: 1779090234-339350
X-HE-Meta: U2FsdGVkX18j9EiShftZcEjVPzaKfYkotUrBz3VuN4nPlq1bEX+EtI0iKlF/3PvYkcIDkKVXbOGeIXCvA4gg3nRlB+u7Q1DJ+QMbwxdG1i42j4w8HPGCT08DR/aLoNcsqagZh5yp9/2W5+WOgjVXiHPYKhTX3aYjBZofY1SBJrRdbFrj0XH51+g5MiFKZOcqVd1y43NdOxwic4B5RzyS7oSr7jIC5cPzJ4cexWYoL+/Ue7mn5jT2RQix0igdWCPL9SNW4fcsHD8SaSZQOM19C0gVNH2tDbyiQpvPYUQJhkhpreqWL4TZKFR+BN1EWZBNHSc/zzo3KK4xUI9Px3AKEd7VbPQH+j3g/YcsPS6KrfZUIhyqQ3JtRDwV1+LCEo5U/j/LcJfgIYl5v4/54tcewDy9kdx9tNAa6kzIrwEiLTvfYnTXcMp4BQs1JXp29WfyB0/VockR5fijZBKD/5T9Cc7jT7+olw/hcfvvAulsuADIx3ZQ9U7XA4s4fju+8O15fSCjLwBzQHTwpaS4Gq5NwG7lsy3q4dZ7baopJnygunfyhQr5NfcbSsPSVTXBFIMb9x2jFv7SHtH7jvD7cPdXyUwTxulH3a42jT/WZLpJlzQNQxfh5MCJyGQkMAvTQp4Vjzx2cv/PBCwhrhmZ7tu9gF59aQu6fxX5+oO19iSKe9CSkB7l/2K+dPIOtUsgcj5Lq+HVSnFKC+6K2gGek22WwAl8pqyzs01E40ByE1nRUASG1555ZDPGHvAMqIPgpkav/hIxRCoCT5YRIY5OEFLiw/Fa3ZP2Z63GwUgleHbFdhvpWb111msYduSvkD3xx5O62p3vnuDQugvyyxWxxJenEvwfg/Fj9HKP/MOE2tdOR6NXBio94MWOWFlR/mRMVrgDn6vLXMAhTzunKQCwD1Rlvw75oR8f4StWI/omPOs1OIL4hncjK+vPpooaX2R/4GWCXTHvzdVhIHPEtU8kH7j
 GLwvnCyE
 f7YSl+YyPKelsAnV32yQHNG5K0H6is0p4Z9ddY7qAsGh1eIK+o/YDOU5G0IRpmRsSfIgETMbw9UuK4MrAQf3L81ffXRosb+34NR39XxrkbwviONQef20y4fml45Coz178V9/CG+M75OVYZJlFsS95YFNBisNMT9gP+xADLhJfqYG2/Iu7YLw0DpjIOa0Ta34o75hnbr6X9EabpwcXUXKm1xE2dtj2lqLajfpcfUQl5E2P/O6WSUV/Q/dXslfyNSqp3Bdcm1OPZyV+MQez8nTnIDPd7ZORBuRB2cojGI/N4bzXEwN6nxewN/DRvlgiTE0YKoOAdXzOmCtcE5jSzp9KeOu8SEVPmZnQTQnl8S6XIsUQucrK3A24KoQRquxQS6JjZT+/ElhoxEuWhZmJZDDC8CBJYU/8vsW9CzNrn19SviKhOqly46kc6kzA3W+jfnw/iIm/aQSz2sQwv0GsjOxuep3gKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/18/26 14:39, Baolin Wang wrote:
> 
> 
> On 5/15/26 5:47 PM, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> Replace SGP_READ with SGP_GET in shmem_file_read_iter(),
>> shmem_file_splice_read(), and shmem_get_link(). These functions
>> immediately unlock the folio after getting it, making the lock
>> acquisition redundant.
>>
>> Even though folio_lock can protect folio data consistency or prevent
>> truncate while holding the lock, these can still happen after unlock.
>> Since these functions continue reading data after unlocking, the lock
>> does not provide effective protection. The folio reference count is
>> what actually prevents reclamation during access, making the lock
>> unnecessary.
>>
>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>> ---
> 
> Thanks for your patch. It would be better to squash patch 1 and patch 2 
> into a one commit, so that the usage of the newly introduced flag can be 
> easily seen.

Hi, Baolin

Thanks for your review. I will squash patches 1 and 2 in the next 
version, unless v2 is unnecessary :D

> 
>>   mm/shmem.c | 12 +++---------
>>   1 file changed, 3 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index ef19968cc51c..767610f78d0d 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -3370,15 +3370,13 @@ static ssize_t shmem_file_read_iter(struct 
>> kiocb *iocb, struct iov_iter *to)
>>               break;
>>           index = iocb->ki_pos >> PAGE_SHIFT;
>> -        error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
>> +        error = shmem_get_folio(inode, index, 0, &folio, SGP_GET);
>>           if (error) {
>>               if (error == -EINVAL)
>>                   error = 0;
>>               break;
>>           }
>>           if (folio) {
>> -            folio_unlock(folio);
>> -
> 
> This is incorrect. Since a shmem folio can still be locked if it is 
> being swapped in from the swap device.

I don't know how I missed that, that's truly a serious bug. Thanks for 
pointing that out.

> 
> Essentially, you need to show reviewers the benefit of introducing a new 
> flag. In what scenario would you see overhead from locking the folio in 
> shmem_get_folio()? And how much performance improvement does your patch 
> bring? Data is the easiest way to convince people:)

Honestly, this may not bring significant performance improvements in 
single thread scenarios.

I think the main benefit is that during concurrent reads and writes, 
especially when large folio is enabled, there are more chances that 
reads and writes occur in the same folio. Removing the folio lock can 
prevent read operations from being blocked by write operations.

If necessary, I will include the test data in v2.

A more important reason is that folio batches are not suitable for 
storing locked folios, as this could lead to some issues.


Thanks,


