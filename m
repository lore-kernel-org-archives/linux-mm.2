Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55BB5CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 06:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798856B03F0; Tue,  2 Jun 2026 02:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721AC6B03F1; Tue,  2 Jun 2026 02:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9AA6B03F2; Tue,  2 Jun 2026 02:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 490E06B03F0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:59:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF961A07F7
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:59:39 +0000 (UTC)
X-FDA: 84834072078.18.C66B9B7
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf02.hostedemail.com (Postfix) with ESMTP id 87ACB80004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:59:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=nczK3mTa;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf02.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780383577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0u09G9M4d/dWKQPXhmcyWzvXnBXZljiiy494JC/FcQ=;
	b=DpYyOG+Ch95ymBP1jLiZxLkoRfK4twBeBpeeXkW0/h351yf5kSkF4Po0c8EcGO3S+dAZrv
	IYC8oN76yd/pgvFv6FNmzaL2xn//7DMFun3JzvVtaqI4JMCyt0Ezai7RPGC/lXKTuNfiAf
	mksZnOoElXaWIGLK1QB5owWztmY2Bzs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=nczK3mTa;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf02.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780383577;
	b=nZK6yUQDzSf9jPg38dL0Ls70q2eTCchZAT21vOnnAviuSev4VNRZH0Byg1oAe995FIhT4p
	0TAR2JSzwc85QYpbrX30+fSG+NcDOIKkMZ+aZ1ZH3Fp1iqinwVPaBgWJbXseUP3x2ShvsX
	SKzQb/mOEC1lukRd66a6enVxoDAsQcw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=h0u09G9M4d/dWKQPXhmcyWzvXnBXZljiiy494JC/FcQ=;
	b=nczK3mTa7ql9aFEaXej07Y0POKIGZCW19mqmaNQngoUQZ4aHOI/QwTTjy9LSa7
	p4s1YdH5crmEFeOd1wyB3pZwN2hc0O/YKQw3fKltJEgCt7a8N+P//WVCDwEBvJBd
	Teq/xkUIoUPbv9nPb7Wui4eUBpr9G9iEjyigLyy3bEZ3U=
Received: from [10.42.20.201] (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wBHTRcnfx5qW37VAw--.8462S2;
	Tue, 02 Jun 2026 14:58:48 +0800 (CST)
Message-ID: <2261be54-da57-4395-a001-327e53c3c849@163.com>
Date: Tue, 2 Jun 2026 14:58:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] mm/shmem: optimize file read with folio batching
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20260601055704.167436-1-chizhiling@163.com>
 <20260601055704.167436-6-chizhiling@163.com>
 <6af198e3-89aa-4d31-b596-3a1b623513fa@linux.alibaba.com>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <6af198e3-89aa-4d31-b596-3a1b623513fa@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHTRcnfx5qW37VAw--.8462S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Xry8Cw47Wr1fArWUuF4DArb_yoW7Cr1kpF
	W3K3ZIkrZ7Jay7ur1fXF1kZ3WrK395tFW5Jay3G3W3A3Z8Ja95KF47Kw1Y9FW5ArZrC3WI
	qw109ryDu3WjqrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UeCJQUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9wkMqWoefynQAwAA3q
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ze6biid3dk9561ite7n1mwfjwibry1oi
X-Rspamd-Queue-Id: 87ACB80004
X-HE-Tag: 1780383573-753162
X-HE-Meta: U2FsdGVkX18/z+oyp0cdzjB/laJi3ZebWOslg9siZx4xnlBHU97pR9zYG2EmkPQlrH1WMWwvHgnoc03e7dnh4jofHD9OJAzfenKfsJgFva9Uvep6hQnIMzpu0bh1ZIv7uyZf/No2Ci0UhnVVrS4xwL1G0lNOy0GwAucj2nqzDgM8sp6i3iIXPMHM8a5+8CZUF2vSqOg+dxsEWDw+rnSlWmyFF5Q+Fdo1mjVct7VAcqi1f9cyrdImC2SUXvxS9THXdA4qguRMIgeVaiLXvFXVBb6qiz+ijyE6x/WwsMkG5lVIsx5Iw5AiYirMW1PfwxjafMrpsqNvW+rWdWjmUzDjqpmtaIP7IBC0ZIelp22K4w3R54mnogc644xi15yc5uXfeER4KmFnwcejDUeqR3bjDvCtNU4dAamp58VzAqdAVGr4ETmwQN2COyTOVqJvadSdMNWd72mmDeyXgi2nlq+3CW2GPQtR31qHnifdySh5V6gdu1BoITz60Il/0cxNiYI6xz0Uv+ZFHNlK+dPinUh8C5mXpaxPJhhhq/cAppk5DMtjpUxMV/fMy95Iqu8JbpE9wBvQD8ep94kWaT9gU+klUme88iwtergRz1UZkv/5KdvjynCfppw/vLMjrou433C/gcMMQA3wUQi/eNrPUsVLuvu2bg1Y/MfhJZTwuNP6V2280p8i3QgLLc1tDj1ayDNEjPb6cD8YRMooJqcyoEo61rXPYVjUOovC8oYhyAL+Gu6+FHxs8lhOg4BqeVURjPaCmR9Bo+YWiHsDqkzSXyRHBVDx5vnpCtvHkz5vdVglIcm+KUNoetwjgix7nQmnjVtRvDSPzyNIxKIplfxx4Tyy3PKKAowsMVGZQV9O8oTlKl3+rQYetPQuam3PaiROzMb/+nxnmua5SnQHanHxFfwiSnSRY46J5wGipzZUsKLb0OZHxi3JsZMZTjjhwZMGoP0bjj4wNKo3zZRAkrEuEdS
 SmToEr3q
 QSxP5E7VmpF99ZX7pB7tpB5jdbJoP438bJXAVYTxe7kQ1vJBWkwuAE5TArFEC33to5Rlo1UrE2DaVuMxntzF7HvgPvtVI+r6FARkeLe1jAShqrGxsvbQ9qw3fE3uTFibx03wTF5/tKoMHScYkNv792OZYryjUG8RgbbeY2z/t40qoVqr/yGiemDjj28gugoB7BUi8S4h/ul/sSUcjbZ6s/3CwOwW5gMkGxkC35xIg9XE2W9l/ldzVOIXgufMq4N7069NJhtWLzSIE9ufW4WE7zo0uCcVj4GoLR0RGNxwDG00o6n/LqqHA/iDSHIYxoFduow57liFOjV94QkwkuWMSqIg8EHLYVNuysH7QoRMLnjd9CtBfWwJ4QOIR7YZ9qf5JPkkMHQ+r7XbWFU+3i8oAs7R7W64xWBI+V+8b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 13:54, Baolin Wang wrote:
> On 6/1/26 1:57 PM, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> Optimize shmem file read by using filemap_get_folios_contig() to batch
>> fetch contiguous folios from the page cache, reducing the overhead of
>> repeated shmem_get_folio() calls.
>>
>> This patch checks the uptodate flag without holding the folio lock, so
>> it may observe a non-uptodate state on a locked folio that is still
>> being initialized. This is safe because only zero-filled data can be
>> copied to the user buffer in that scenario.
>>
>> A non-uptodate folio in the swap cache cannot be added to the shmem page
>> cache. This creates a semantic conflict, as shmem zeroes the folio out,
>> but the swap cache would fill it by reading from the swap backing store.
>>
>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>> ---
>>   mm/shmem.c | 57 ++++++++++++++++++++++++++++++++++++++++--------------
>>   1 file changed, 42 insertions(+), 15 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index cac355685e49..61937582f08c 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -891,6 +891,14 @@ int shmem_add_to_page_cache(struct folio *folio,
>>       VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>>       VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
>> +    /*
>> +     * Don't add a non-uptodate folio that is in swap cache to page
>> +     * cache, since shmem will zero it instead of reading from swap
>> +     * backing.
>> +     */
>> +    VM_BUG_ON_FOLIO(folio_test_swapcache(folio) &&
>> +            !folio_test_uptodate(folio), folio);
> 
> It's impossible for a folio to be in both the swap cache and the shmem 
> page cache. We can drop this.

Okay, I just want to set a reminder for others.

> 
>>       folio_ref_add(folio, nr);
>>       folio->mapping = mapping;
>>       folio->index = index;
>> @@ -3382,11 +3390,13 @@ static ssize_t shmem_file_read_iter(struct 
>> kiocb *iocb, struct iov_iter *to)
>>       struct file *file = iocb->ki_filp;
>>       struct inode *inode = file_inode(file);
>>       struct address_space *mapping = inode->i_mapping;
>> -    pgoff_t index;
>> +    struct folio_batch fbatch;
>>       unsigned long offset;
>>       int error = 0;
>>       ssize_t retval = 0;
>> +    folio_batch_init(&fbatch);
>> +
>>       for (;;) {
>>           struct folio *folio = NULL;
>>           unsigned long nr, ret;
>> @@ -3395,15 +3405,33 @@ static ssize_t shmem_file_read_iter(struct 
>> kiocb *iocb, struct iov_iter *to)
>>           if (unlikely(iocb->ki_pos >= i_size))
>>               break;
>> +fetch:
>> +        folio = folio_batch_next(&fbatch);
>> +        if (!folio) {
>> +            pgoff_t start = iocb->ki_pos >> PAGE_SHIFT;
>> +            pgoff_t end = (iocb->ki_pos + to->count - 1) >> PAGE_SHIFT;
> 
> You should consider the inode size when calculating the 'end'. You can 
> reuse the 'end_offset':
> 
> end_offset = min_t(loff_t, i_size, iocb->ki_pos + to->count);
> 
> then pass 'end_offset - 1' to filemap_get_folios_contig().

Okay, I will.

And I'm considering whether to reintroduce shmem_get_read_batch as a 
replacement for filemap_get_folios_contig.

The main reason is to be able to quickly skip over holes, so that we 
don't fall back when encountering holes during reads, thereby addressing 
the performance regression when reading holes.

> 
>> +
>> +            if (folio_batch_count(&fbatch)) {
>> +                for (int i = 0; i < folio_batch_count(&fbatch); i++)
>> +                    folio_put(fbatch.folios[i]);
>> +                folio_batch_reinit(&fbatch);
>> +            }
>> -        index = iocb->ki_pos >> PAGE_SHIFT;
>> -        error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
>> -        if (folio)
>> -            folio_unlock(folio);
>> -        if (error) {
>> -            if (error == -EINVAL)
>> -                error = 0;
>> -            break;
>> +            filemap_get_folios_contig(inode->i_mapping, &start, end, 
>> &fbatch);
>> +            if (folio_batch_count(&fbatch))
>> +                goto fetch;
>> +
>> +            error = shmem_get_folio(inode, start, 0, &folio, SGP_READ);
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
>>           /*
>> @@ -3411,17 +3439,15 @@ static ssize_t shmem_file_read_iter(struct 
>> kiocb *iocb, struct iov_iter *to)
>>            * are called without i_rwsem protection against truncate
>>            */
>>           i_size = i_size_read(inode);
>> -        if (unlikely(iocb->ki_pos >= i_size)) {
>> -            if (folio)
>> -                folio_put(folio);
>> +        if (unlikely(iocb->ki_pos >= i_size))
>>               break;
>> -        }
>> +
>>           fsize = folio ? folio_size(folio) : PAGE_SIZE;
>>           offset = iocb->ki_pos & (fsize - 1);
>>           end_offset = min_t(loff_t, i_size, iocb->ki_pos + to->count);
>>           nr = min_t(loff_t, end_offset - iocb->ki_pos, fsize - offset);
>> -        if (folio) {
>> +        if (folio && folio_test_uptodate(folio)) {
>>               /*
>>                * If users can be writing to this page using arbitrary
>>                * virtual addresses, take care about potential aliasing
>> @@ -3443,7 +3469,6 @@ static ssize_t shmem_file_read_iter(struct kiocb 
>> *iocb, struct iov_iter *to)
>>                   ret = copy_folio_to_iter(folio, offset, nr, to);
>>               else
>>                   ret = copy_pages_to_iter(folio, offset, nr, to, 
>> &error);
>> -            folio_put(folio);
>>           } else if (user_backed_iter(to)) {
>>               /*
>>                * Copy to user tends to be so well optimized, but
>> @@ -3474,6 +3499,8 @@ static ssize_t shmem_file_read_iter(struct kiocb 
>> *iocb, struct iov_iter *to)
>>           cond_resched();
>>       }
>> +    for (int i = 0; i < folio_batch_count(&fbatch); i++)
>> +        folio_put(fbatch.folios[i]);
>>       file_accessed(file);
>>       return retval ? retval : error;
>>   }


