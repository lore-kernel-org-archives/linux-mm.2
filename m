Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E541CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 03:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02846B0005; Mon, 18 May 2026 23:06:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B2E66B0088; Mon, 18 May 2026 23:06:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9316B008C; Mon, 18 May 2026 23:06:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B1776B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:06:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B208120167
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:06:17 +0000 (UTC)
X-FDA: 84782680794.30.0813DB4
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5F06420007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:06:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cTJSLSdv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779159974; a=rsa-sha256;
	cv=none;
	b=IOByyOGiX7p7zzCpInRTA/xZblm2+EHoqP1UdBChZSRto0ZU55LFv3TDcCM2EmkT3Z1k3W
	9CftsxI4C0ZMbdOrqyo53xT+KkN4SUNZ55R0Mjs9cqH1JhWAmuqYyQv31fpJvMkG+rIWRX
	jsKN9dsq0Bv6dhl95w5jZr7miizA2fI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cTJSLSdv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779159974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ks+qUZy85ASQha921hZs00t//cX4J3vYp69MZtes08=;
	b=hdln4xl+EmCTcJ316WeSp9Zr4TMXUK8UpK7KMBjP9VHZiFuk1zIrEoATbW1LLLF6VfdTT7
	zP+dhifP9z66TayxLn3+l4C+r7gZH+IW1XALQxtwotEAcsfRtN7PJzycQQMrTqm3jIGqI7
	8YZTYq/5AmNAYMxc/44h5MYAGPzd4Cc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779159969; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2ks+qUZy85ASQha921hZs00t//cX4J3vYp69MZtes08=;
	b=cTJSLSdvvk4IkUIrJyOaxsz0E7F9ffuxje+n3qzzdclBUNFAbh6/D0F64xfk9m2TRq2kaBczKnucjA/v/3eJIP2ZeZfiPFPr6jGzdIonokdvoeVrRQUd1XuOPD3M0HPN0GZBmzyM1DtsNsSr3uPHwGkE+oqvx7exSHouYgz+m88=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X3E4Pw5_1779159967;
Received: from 30.74.112.128(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X3E4Pw5_1779159967 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 19 May 2026 11:06:07 +0800
Message-ID: <e63962ad-55a9-4521-9f88-fd6be0c80434@linux.alibaba.com>
Date: Tue, 19 May 2026 11:06:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] mm/shmem: use SGP_GET in read operations
To: Chi Zhiling <chizhiling@163.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
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
 <f5cfe918-8bf1-4494-80ea-32863df1d1df@163.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <f5cfe918-8bf1-4494-80ea-32863df1d1df@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: exnhwoiotrpfxc3b9o9a6irkynwd3d1j
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F06420007
X-Rspamd-Server: rspam07
X-HE-Tag: 1779159972-427395
X-HE-Meta: U2FsdGVkX1+jHNQeJU9syrc4qFafRPZll/FBj0rcgzdjGxb9Iy/Ds1Ozoi/u6I6Td78NrMKhZWI2kQirziCKlHem52WQyu9CE1z5PKLa5GUyJyFeZTcJeuNFVNEsYHiVeaOr/7ionvzeouRQA4X3Cimx0qXfkq/91kBb9rnKeuKDVPMafXQ09QGLrLfV1pPAC37UaxYYGph4DUVeeKXtkWIlSrXeXZrC4o9KtOedYuCDg1pjMoKRqZp1rVRXm5LvGnMKpYKX6ycx1B2lvVKCnqK/6WUhNSc7VnXHKo9UofVmGnQV4rbkt+iz2z9kbFRilYn4JizILoJ6y1bzTkONMYNQ5Efc+dgZjXAbZgT+fr/wZ+J1ZYPQDvVLQkI+fQbkPSzSgylh16tlNbYLucBdTTzXbgiHdtLGzHKKbB6c1HnQADh7QSzGlP/A6SnYjZFYJikNQ9DnqB/GdvhzS66dS0X218PFRNHl8ARDQ6qiql/XUwrLXBiI/IQaQSIb4KeQXMUrYnf0/O8orPDVwtiik6Jv1nmr77ujoyPFJMHaFN893amaq/+XpSkQ/CtiAtpiMchXZE/+3GEP8sAud+f67xuYADFme3HI4TVEPp5OF5qy9jhTXj/pJlhxZ1t5ZfPkG+Ke2dBoVwHFHjEasQzVw8t0HBGdU/PydseJ+pI5rrcbq2YyqAeKYFVl/8bck+QYyOmZ+m+XKvbC6jUDrEX8JLVeSV8fHa/IP3T5eqn8wL7pj2Fh//F/nYZ6kqZJ8P/qz0GRv317ALNQkY+LDfuB8gGXitzGbQ0SL+2pM8wrtAl2uLVNe002mdOMFdv+eytlNKj4dRBusHlWdAA/LtiHqLvsdL6uljvYI3QE/jxIvxYMOLX4620MZ4ArDVMO+ytlW1IG/usoWHqQ/ZykJJV/ZPjz9CeoVKV8IQPI1wRqozJuYC3hPndsFr4Wvou3odHcgWvM6dhYEaZdqL3kAPb
 K0m7EhR1
 lrVgmioT+O/s5rHzFD9B5+I+XuboLxP/w0gymYKhZPOqReiiep9OylFt4lyCDi4yH04Kx9gtr587hgHeBtKAZOo3acq+OmRbmG/Wrd+A5yLyPbH2bAHmbnFTyfFsB4ZFJIIre9bJLZI7PcGSTcjJcoNzzGQOl7co+/NbIdLSRpwcCrpMsVfpBIx3ga7/jLHUutp06Nti6KOz6dljqjw5B5x3jizShqBy9QSYBxbLK7PGRxKtumkg6yNHfjs+3zG9fgH+ZMvZyKrneEw4ZLhb4FCc83ZcgV1UrUHA0B3o1Ltf6qg9Il/gUr3pykRuVCBtniXXrGBAgPsGEfDKWVDzwJUeOsVUk5rePgxf8KxDVGmcmDKdaMnEV/CT82vhbgPHlNNq1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/18/26 3:42 PM, Chi Zhiling wrote:
> On 5/18/26 14:39, Baolin Wang wrote:
>>
>>
>> On 5/15/26 5:47 PM, Chi Zhiling wrote:
>>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>>
>>> Replace SGP_READ with SGP_GET in shmem_file_read_iter(),
>>> shmem_file_splice_read(), and shmem_get_link(). These functions
>>> immediately unlock the folio after getting it, making the lock
>>> acquisition redundant.
>>>
>>> Even though folio_lock can protect folio data consistency or prevent
>>> truncate while holding the lock, these can still happen after unlock.
>>> Since these functions continue reading data after unlocking, the lock
>>> does not provide effective protection. The folio reference count is
>>> what actually prevents reclamation during access, making the lock
>>> unnecessary.
>>>
>>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>>> ---
>>
>> Thanks for your patch. It would be better to squash patch 1 and patch 
>> 2 into a one commit, so that the usage of the newly introduced flag 
>> can be easily seen.
> 
> Hi, Baolin
> 
> Thanks for your review. I will squash patches 1 and 2 in the next 
> version, unless v2 is unnecessary :D
> 
>>
>>>   mm/shmem.c | 12 +++---------
>>>   1 file changed, 3 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index ef19968cc51c..767610f78d0d 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -3370,15 +3370,13 @@ static ssize_t shmem_file_read_iter(struct 
>>> kiocb *iocb, struct iov_iter *to)
>>>               break;
>>>           index = iocb->ki_pos >> PAGE_SHIFT;
>>> -        error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
>>> +        error = shmem_get_folio(inode, index, 0, &folio, SGP_GET);
>>>           if (error) {
>>>               if (error == -EINVAL)
>>>                   error = 0;
>>>               break;
>>>           }
>>>           if (folio) {
>>> -            folio_unlock(folio);
>>> -
>>
>> This is incorrect. Since a shmem folio can still be locked if it is 
>> being swapped in from the swap device.
> 
> I don't know how I missed that, that's truly a serious bug. Thanks for 
> pointing that out.
> 
>>
>> Essentially, you need to show reviewers the benefit of introducing a 
>> new flag. In what scenario would you see overhead from locking the 
>> folio in shmem_get_folio()? And how much performance improvement does 
>> your patch bring? Data is the easiest way to convince people:)
> 
> Honestly, this may not bring significant performance improvements in 
> single thread scenarios.
> 
> I think the main benefit is that during concurrent reads and writes, 
> especially when large folio is enabled, there are more chances that 
> reads and writes occur in the same folio. Removing the folio lock can 
> prevent read operations from being blocked by write operations.
> 
> If necessary, I will include the test data in v2.
> 
> A more important reason is that folio batches are not suitable for 
> storing locked folios, as this could lead to some issues.

If this new flag is necessary, please add these explanations to the 
commit message.

However, if there's no obvious performance improvement, I'd prefer not 
to add an unnecessary flag. Also, looking at the implementation of 
shmem_get_folio_from_batch() in patch 3, couldn't we unlock the folio 
after shmem_get_folio()?

