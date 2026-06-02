Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80D74CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 05:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86EA46B0432; Tue,  2 Jun 2026 01:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81F896B0434; Tue,  2 Jun 2026 01:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7351F6B0436; Tue,  2 Jun 2026 01:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 603F76B0432
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 01:54:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB8C7A081B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:54:20 +0000 (UTC)
X-FDA: 84833907480.30.B10BD7C
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf15.hostedemail.com (Postfix) with ESMTP id 39C7AA0002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:54:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Jx3CGoHw;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780379659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANoWApNy7HClVP2oRbGsYE3SlFLFzfccZW33ESPs2Qg=;
	b=ablEvL/xWXqFKOqf4+HH8rFvn3OApf0nA2PnfB8pZUw6fQliwcfCjCbXsE6VkB/FRIKxHq
	29d/KK8qa3Z7qUbVTNJAx+DIA1QHwDwoZYOoO63/TvRxFCy+Bp0yw1aAp/wtlNj1g32jYo
	ruSmmdnhEQfzmwmb2iEl+ZrXWsg9YkM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Jx3CGoHw;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780379659;
	b=P8pHGeprANJkJbb+673Zkb41IZb6kYz7FLRUfHsz9WqOWATO+EXBf0pVBqJD/m0PmKQ4dT
	XxZWYw4zYejJOXjpVQBtMlExtQZaz21iraiRdD8W/8faE03hopZ6lJim7+KynUWmmcuLw5
	YcMXorMXrg8IJbdsghvEgXtGZtzccF8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780379651; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ANoWApNy7HClVP2oRbGsYE3SlFLFzfccZW33ESPs2Qg=;
	b=Jx3CGoHwpSMHaahKM6tkVunijmDTSKRQZ/NxzBH7NU+KYFqM6NAkwZl1FAlNfbpQ4tV3F8SL0msSD1VFrBsnqh2eOu5+1skRP4nUEzzYAZ4KY6TBF3rVChym4U72QA1f7Ry/ndyQnP1DQsnGfa9xkC/PuxlVfF5iG+yHB1DDHpA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X43HI8B_1780379649;
Received: from 30.166.17.138(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X43HI8B_1780379649 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Jun 2026 13:54:10 +0800
Message-ID: <6af198e3-89aa-4d31-b596-3a1b623513fa@linux.alibaba.com>
Date: Tue, 2 Jun 2026 13:54:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] mm/shmem: optimize file read with folio batching
To: Chi Zhiling <chizhiling@163.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20260601055704.167436-1-chizhiling@163.com>
 <20260601055704.167436-6-chizhiling@163.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260601055704.167436-6-chizhiling@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 39C7AA0002
X-Stat-Signature: scifb1h7acaib7o6m3gru57bxit4rtue
X-Rspam-User: 
X-HE-Tag: 1780379655-197358
X-HE-Meta: U2FsdGVkX1+KDPFAi3uT6TjbhdT1Qu7yOSWqBAhdyLrIE96cYuD5JJu/e7DdIhmXCJDoWMp55rooYKNigHKuvnSSS7baORU6TeTM7+0f3fDr6XSPJSVMyHhGTa5xpO8xAmUagVIVtjtjznhrq2k9T7KcUmuWOTHcjyOefwod1aOtqwsk28rdOOWmzal2G3If8pGh4+N4CtYf5PqkjZz6RklAawvgrjoPbbzHTZKjDRvN+YXd8WbxwzYWZkfXr7bZKMvfBlo6iN8PSk45/zfWUSmT91N4wpmmKhEEke4F3rT7WExjnd2z1M42mu+uBKdz7veCKoxJsMy+0PPMb3nUwZd54NspqQ/l8BQK8WdNx9J+a2eLTwKxohp5PUC09l+QW6tXuaR2dets/Vva69EaN3Tmt9tkDBMIVPLFSYJ4MT7EhQUF3P/N5Wqkq4chP/vC5gSbfSku/5sBRKHUDUPxwBitFS2R2gr3NwvjBqrOP1oVam7NZimZvquE4ByGoJxn4xcRsQU2ulrq++D/CPq1cgoGQWJ0BQ/QImbvWCOdWoV5xWBR74pF7cbQYBtbwc/MB1VdNZgDH/paF+i5q9PqLRqVDCh0fW3BuVuIq0faeqA3r0qYFXFmhWpVsXjlLGStNvxn6aRSUfQo6gngbRWFzD83uctSHbKdKal7jnL0/ByD5QDNuCZvLmDQ4FcMLnGtIp77uyjJI7c3tFkhMLbq/uWkfcWiy8ThEjNslAa1cjQzUoleFyrG1abnL+NLH5hX9W0wCX2aAQinfRUPMyJzM0rpsgC6s1gtvgZIbL/tzy9iRAidQS6UKdxPmE3qk6yQczkLxirJjgjUwVleQ0l8eAcRNwIkx7LQ0duScWYJEZQUoI9yWoY7q+KhUGxwQOASawoay7TT9wQqfH0V8dIARMl8zJ2G/b2QOAfRzCY88yAVvjUwfK5AxVgEuT1vfor++jxT4nwHVv3cmihvLbU
 2m+HMuU+
 +2Bek/O9Knh/exrO6r+xY+qy6liJkdnw4xnoyHQtRfH+pL7OES1Td3dFPDOA4nQVhzwzH0e9ryGXP3w+yXfwxM1jjBuhPJJCZTztcIzFnusi7sWGhLx3qjXdSXEc4JcLh0q92IZnJ1Mg1w6mobjgdgcaGM7NQ68Lk+LNEDLHvyFgof5F8Oz5uK1lkO4LHF8xQqrbRVnR3Slrx/8EjcTy84f39kF5mnsFWLyWXj9yeLVBSeJwlvhS7lIV6QWvj4/XveI27wdMjp6ZlSAp3tUj48yRc7aKMceBi4bk5IFaGmQCbMEZssG5SGr5Nrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/1/26 1:57 PM, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> Optimize shmem file read by using filemap_get_folios_contig() to batch
> fetch contiguous folios from the page cache, reducing the overhead of
> repeated shmem_get_folio() calls.
> 
> This patch checks the uptodate flag without holding the folio lock, so
> it may observe a non-uptodate state on a locked folio that is still
> being initialized. This is safe because only zero-filled data can be
> copied to the user buffer in that scenario.
> 
> A non-uptodate folio in the swap cache cannot be added to the shmem page
> cache. This creates a semantic conflict, as shmem zeroes the folio out,
> but the swap cache would fill it by reading from the swap backing store.
> 
> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
> ---
>   mm/shmem.c | 57 ++++++++++++++++++++++++++++++++++++++++--------------
>   1 file changed, 42 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index cac355685e49..61937582f08c 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -891,6 +891,14 @@ int shmem_add_to_page_cache(struct folio *folio,
>   	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>   	VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
>   
> +	/*
> +	 * Don't add a non-uptodate folio that is in swap cache to page
> +	 * cache, since shmem will zero it instead of reading from swap
> +	 * backing.
> +	 */
> +	VM_BUG_ON_FOLIO(folio_test_swapcache(folio) &&
> +			!folio_test_uptodate(folio), folio);

It's impossible for a folio to be in both the swap cache and the shmem 
page cache. We can drop this.

>   	folio_ref_add(folio, nr);
>   	folio->mapping = mapping;
>   	folio->index = index;
> @@ -3382,11 +3390,13 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   	struct file *file = iocb->ki_filp;
>   	struct inode *inode = file_inode(file);
>   	struct address_space *mapping = inode->i_mapping;
> -	pgoff_t index;
> +	struct folio_batch fbatch;
>   	unsigned long offset;
>   	int error = 0;
>   	ssize_t retval = 0;
>   
> +	folio_batch_init(&fbatch);
> +
>   	for (;;) {
>   		struct folio *folio = NULL;
>   		unsigned long nr, ret;
> @@ -3395,15 +3405,33 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   
>   		if (unlikely(iocb->ki_pos >= i_size))
>   			break;
> +fetch:
> +		folio = folio_batch_next(&fbatch);
> +		if (!folio) {
> +			pgoff_t start = iocb->ki_pos >> PAGE_SHIFT;
> +			pgoff_t end = (iocb->ki_pos + to->count - 1) >> PAGE_SHIFT;

You should consider the inode size when calculating the 'end'. You can 
reuse the 'end_offset':

end_offset = min_t(loff_t, i_size, iocb->ki_pos + to->count);

then pass 'end_offset - 1' to filemap_get_folios_contig().

> +
> +			if (folio_batch_count(&fbatch)) {
> +				for (int i = 0; i < folio_batch_count(&fbatch); i++)
> +					folio_put(fbatch.folios[i]);
> +				folio_batch_reinit(&fbatch);
> +			}
>   
> -		index = iocb->ki_pos >> PAGE_SHIFT;
> -		error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
> -		if (folio)
> -			folio_unlock(folio);
> -		if (error) {
> -			if (error == -EINVAL)
> -				error = 0;
> -			break;
> +			filemap_get_folios_contig(inode->i_mapping, &start, end, &fbatch);
> +			if (folio_batch_count(&fbatch))
> +				goto fetch;
> +
> +			error = shmem_get_folio(inode, start, 0, &folio, SGP_READ);
> +			if (unlikely(error)) {
> +				if (error == -EINVAL)
> +					error = 0;
> +				break;
> +			}
> +			if (folio) {
> +				folio_unlock(folio);
> +				folio_batch_add(&fbatch, folio);
> +				fbatch.i++;
> +			}
>   		}
>   
>   		/*
> @@ -3411,17 +3439,15 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   		 * are called without i_rwsem protection against truncate
>   		 */
>   		i_size = i_size_read(inode);
> -		if (unlikely(iocb->ki_pos >= i_size)) {
> -			if (folio)
> -				folio_put(folio);
> +		if (unlikely(iocb->ki_pos >= i_size))
>   			break;
> -		}
> +
>   		fsize = folio ? folio_size(folio) : PAGE_SIZE;
>   		offset = iocb->ki_pos & (fsize - 1);
>   		end_offset = min_t(loff_t, i_size, iocb->ki_pos + to->count);
>   		nr = min_t(loff_t, end_offset - iocb->ki_pos, fsize - offset);
>   
> -		if (folio) {
> +		if (folio && folio_test_uptodate(folio)) {
>   			/*
>   			 * If users can be writing to this page using arbitrary
>   			 * virtual addresses, take care about potential aliasing
> @@ -3443,7 +3469,6 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   				ret = copy_folio_to_iter(folio, offset, nr, to);
>   			else
>   				ret = copy_pages_to_iter(folio, offset, nr, to, &error);
> -			folio_put(folio);
>   		} else if (user_backed_iter(to)) {
>   			/*
>   			 * Copy to user tends to be so well optimized, but
> @@ -3474,6 +3499,8 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   		cond_resched();
>   	}
>   
> +	for (int i = 0; i < folio_batch_count(&fbatch); i++)
> +		folio_put(fbatch.folios[i]);
>   	file_accessed(file);
>   	return retval ? retval : error;
>   }


