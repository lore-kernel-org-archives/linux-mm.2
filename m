Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C1B4CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 09:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BC486B0005; Mon, 25 May 2026 05:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9459F6B0088; Mon, 25 May 2026 05:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80D616B008A; Mon, 25 May 2026 05:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B93B6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:48:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 05B291C157C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:48:16 +0000 (UTC)
X-FDA: 84805466592.17.1375717
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf16.hostedemail.com (Postfix) with ESMTP id E46FF180002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:48:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ULNlomqK;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf16.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779702494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6hlBJJtNF534RxCFHIXSbAD2k3XslcVc3B58swSDEM=;
	b=hhfaRc8iiVNCSNB2jc/uDJZEXCFGf+Jc3xBPUczEyVDwJVFlXtOW2eOK69eKjL9FUVmKUW
	1PPvl4NBd8yXFbj/C8DnJSFS3mrlo03EQG0uixF/II186DoK4bNq/ggnlIdIMti8dHiQBt
	00isYOAe3QAAR4xEeV9vE/eaq+4n30s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ULNlomqK;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf16.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779702494; a=rsa-sha256;
	cv=none;
	b=y+88xKPm90vaG4+rP4HJ9L8jTYW39HsxqzuQSCLI3uKrLWmibVu1OR5Tdapfk4L1H+QrfS
	ktEyzuZbWQ0KUEF6edtvSJnBtcE5bBBFxg40Ebjndog1d9VklKsNa/ig2jUjHMx1bbou7P
	WhTdaPHoPj/mOahf6i52DyomQY3OziA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=R6hlBJJtNF534RxCFHIXSbAD2k3XslcVc3B58swSDEM=;
	b=ULNlomqKN5q4kNrJHlZAG1fyjcwyRasTgaODhW+KfNMx/8bVSGLk6u3ywINmzc
	SQEJjstMiaD11VQDCgiJlL5AWI08AO+S1bUXBXn/V5e+S5ZwMsNpL0wsxircEqUr
	SNg6xUNQBcpEYWu9jmiy/N8VCWIpgqK9RnZ6rJPQfmPEI=
Received: from [10.42.0.218] (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wDnHz6tGhRq4LleDA--.43041S2;
	Mon, 25 May 2026 17:47:27 +0800 (CST)
Message-ID: <1fd099de-97d9-4a54-a97f-062fbae1d88e@163.com>
Date: Mon, 25 May 2026 17:47:25 +0800
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
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <1d8c7c24-b273-4826-9a9e-37fdb0767f2f@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnHz6tGhRq4LleDA--.43041S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZw48JF4kXr18tFWrWFy7Awb_yoWrXF4kpF
	W3G3ZxKrWkGay7ur1Sqw48Zr1Sg3s3JF4rCayfG3W7A3Z8Za9Ykr1rKw15uFW5ArWrG3WI
	9r18Kry7u3WqyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Uu6wZUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC+BBS72oUGrAMQgAA3P
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E46FF180002
X-Stat-Signature: f3mi7dajujwaeaft5wu5cdwqt449bk7c
X-Rspam-User: 
X-HE-Tag: 1779702492-79373
X-HE-Meta: U2FsdGVkX1+YWFULCKDAuz4U8QTiqzxziH4dK0e4c9obhLFK5BoGKzJCATL7EztsX/eUm7v8WDYKAXDlyQ1fGJ/vUUExNCUY6LHnwIuKJkKOk0Q58jucPr5cdXGvquwNA8XWqepUgSJemnmJ0l7BeKNdhcstQGya5DIRrxJyg+/m9GbsLiWJtXbIyEvpjeVrzlNryX/h9uK6qEauGHUBgVycIeweq7M5Pno1XgOrDljnqgLSALmEv0ptzXxI7Zt9UtnNSzrbkey1MrcVaqdHFgnU7INvj8khIwKbRWQCNMthfe5A1pBuPVQkxn/FBQ60FRcyCOSJZQBHQAAzC7XrpXHFCkXoThMKLbZ/crbao+0kqx2hCKJZ8UNCfRureWE7btVweVpFeILPTX23kAxhJDPXSDPzc/J4ZGkXsv5BK6cJp3FvEUtmS0uj7yuCIJqQg+lAc/xq0zfTy7aJxdklq8woWtOtkw6en8X+CtFBF2arERMAQNsCSuiKliDDzuDxpwwnCKJyzUQfll2K6cpm2WweIAt7Bg9cnQE8sVHSt2sqqziKNXOw2K/6Gn9MjLxP0r8q2nPerw6QRBjnGL9zTYG59vAHLo5nAj1sUDZ8j0jaPCGoVEZS3ZPVBkvpEt6kdyoU/J4BdRosaTK1q5Ts9Z1+RM6/3IxMJ3tlpY06rGtmHMe+8mztGaLlKGtt2fFsi7RHj153Mcv2FIoNX2Tses1w/kQYiJMtmSIS+fo8uoK/HxgAPK0BJ6LrCdD5E3AZn4CByMAqEBFPjco0M765wTUYwqZZsS7+1l6w0xel/tUdeVUWzD/ETH99nmQX5xPOwPuF0HlGjb5VjUxD1p/E6dZnOxq6kpigT8CVGCY0ME++Lkof4aLggCtbZ0T7a8DA9rylW4klvWVlZinbjma8HlHlyX7Ueb35LMFOiihU6487Gt6JElVACNk2EjzgNE0GXJ8kX7elsH+Tj1KGcCz
 /o0h7Z1c
 PkGvJF39W2xZKaxPbDikhPmWQoTLrVyZ051qV1hquIiemK+QoeJao5x0kcU6+S+8Xs8fWPfO9bngMIrio1VS2vJdhVDdJdH+sNbZ8OfYD1F8roukkazRKD1tBH10M5QU7tbsGla617fPKn5gJ1Z0qWN9Yn4Jw5YtQ/2BPOtFNuBnDTqEshZAnYv2KEqhQPYORmBvy29WA8tFzdnkBNfoU3n4mJNjKjqWfGHqCVqGPGBPArEuiHnIORivV4/n1bC9c03N8hmpD41NTdZzM2x1STARVDk45We/cz+39W6+GHXaXofaolX96v3E8B4/fuza93ty7VDDpiU7dp7IRyFzwl3dXjU7i3XQfu4eJxQIPIpwd5xdnlepiEJinUOkYKxAszl82HC61iUHI9cAHdvOwOKNk0VfSCuHnUvGZ4bsVWjPzu03RcznBhAvPkm1GQFpIn4SFKyd56SkeLv05p0opVnKbnlAx0eL8V/nChpkLxskl9UxdLMNssePyxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 4:37 PM, Baolin Wang wrote:
> 
> 
> On 5/20/26 6:15 PM, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> Optimize shmem file read by using filemap_get_folios_contig() to
>> batch fetch contiguous folios from the page cache, reducing the
>> overhead of repeated shmem_get_folio() calls.
>>
>> When the folio batch is exhausted, attempt to refill it with
>> filemap_get_folios_contig(). If no folios are found (hole or swapped
>> out pages), fall back to shmem_get_folio() to handle these cases
>> individually.
>>
>> Additionally:
>> - Defer folio_put() until the batch is exhausted or on exit
>> - Add folio_test_uptodate() check before copying to ensure data
>>    validity
>>
>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>> ---
>>   mm/shmem.c | 50 ++++++++++++++++++++++++++++++++++++--------------
>>   1 file changed, 36 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 96ea5a4c0aff..e0eacc23cccd 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -3355,11 +3355,14 @@ static ssize_t shmem_file_read_iter(struct 
>> kiocb *iocb, struct iov_iter *to)
>>       struct file *file = iocb->ki_filp;
>>       struct inode *inode = file_inode(file);
>>       struct address_space *mapping = inode->i_mapping;
>> +    struct folio_batch fbatch;
>>       pgoff_t index;
>>       unsigned long offset;
>>       int error = 0;
>>       ssize_t retval = 0;
>> +    folio_batch_init(&fbatch);
>> +
>>       for (;;) {
>>           struct folio *folio = NULL;
>>           struct page *page = NULL;
>> @@ -3372,18 +3375,38 @@ static ssize_t shmem_file_read_iter(struct 
>> kiocb *iocb, struct iov_iter *to)
>>               break;
>>           index = iocb->ki_pos >> PAGE_SHIFT;
>> -        error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
>> -        if (error) {
>> -            if (error == -EINVAL)
>> -                error = 0;
>> -            break;
>> +fetch:
>> +        folio = folio_batch_next(&fbatch);
>> +        if (!folio) {
>> +            pgoff_t start = index;
>> +            pgoff_t end = (iocb->ki_pos + to->count - 1) >> PAGE_SHIFT;
>> +
>> +            if (folio_batch_count(&fbatch)) {
>> +                for (int i = 0; i < folio_batch_count(&fbatch); i++)
>> +                    folio_put(fbatch.folios[i]);
>> +                folio_batch_reinit(&fbatch);
>> +            }
>> +
>> +            filemap_get_folios_contig(inode->i_mapping, &start, end, 
>> &fbatch);
>> +            if (folio_batch_count(&fbatch))
>> +                goto fetch;
>> +
>> +            error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
>> +            if (unlikely(error)) {
>> +                if (error == -EINVAL)
>> +                    error = 0;
>> +                break;
>> +            }
>> +            if (folio) {
>> +                folio_unlock(folio);
>> +                folio_batch_add(&fbatch, folio);
>> +                fbatch.i++;
>> +            }
>>           }
>> -        if (folio) {
>> -            folio_unlock(folio);
>> +        if (folio) {
>>               page = folio_file_page(folio, index);
>>               if (PageHWPoison(page)) {
>> -                folio_put(folio);
>>                   error = -EIO;
>>                   break;
>>               }
> 
> I haven't tested it yet, but I'm sure this will break the 
> fallback_page_copy mode.
> 
> You're fetching from the batch at folio granularity here, but in 
> fallback_page_copy mode, we still copy the data at page granularity.

Yes, that's a bug, Sashika has already reported it. I’ll fix it in the 
next version.

Sashika also reported another potential issue below, but I think that is 
a misunderstanding, because a folio fetched from the swap cache is 
already marked Uptodate before being added to the page cache. What do 
you think?

~~~
Sashika:

Can this lockless check cause readers to receive spurious zeros instead
of the actual data?

Since filemap_get_folios_contig() fetches locklessly, a folio that is
currently being allocated and initialized, or swapped in by another
thread, might not yet be marked uptodate.

By checking folio_test_uptodate() without holding the folio lock, this falls
through to the zero-fill paths if the folio isn't uptodate yet. The original
code avoided this by using shmem_get_folio() which waits for the folio lock
and I/O completion.
~~~

link: 
https://sashiko.dev/#/patchset/20260520101538.58745-1-chizhiling@163.com

Thanks,



