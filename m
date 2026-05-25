Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F23F8CD5BCF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275D96B008C; Mon, 25 May 2026 04:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FFFD6B0093; Mon, 25 May 2026 04:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6B16B0095; Mon, 25 May 2026 04:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E8E316B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:37:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D235DC05E0
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:37:40 +0000 (UTC)
X-FDA: 84805288680.02.A6EE65E
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id F0337C0002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:37:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QFV+reBt;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779698259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fM5SE1333rF5XvXXkmPILOtV+9GPvTKGJed+D55Hqho=;
	b=E7MEV+1Qr+us7PW26IsG1CQTkYo3iE3sSYjP/q4UQyDWdvy0sCOBENNPlA1KdSlWZuNXf9
	cJ/OFJkGLuACtICZrjtOz78uuR+ERacZOpXyfrDUJeMW6jIBSdEjTP0YCzj7F6/4QYOQWI
	mIUK9PIbTt9RQUvt15Ho9q0rZt9eg+k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QFV+reBt;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779698259; a=rsa-sha256;
	cv=none;
	b=ArRey6axzICQl4NbvEbDzOynBh8TwrmGe0Smxc4PhpLQhorOOAQIKpKh1B1abbC9LCRCBq
	zhp6V9ey2Ftb9a+DZ01gCgTGg1GMyepg2viufR3S6kr+YDHwoSLhS/jqYt8+1RQEsRf5bD
	36t/sdx7y3XfB4BODAjtVV93EFpN8Ig=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779698255; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fM5SE1333rF5XvXXkmPILOtV+9GPvTKGJed+D55Hqho=;
	b=QFV+reBtAs02OImrfPF2iqvsZRC2xefqHCcos5+2cZq/iOEBZfwsTZgCyTqJ9iCuqeVakZlneADBe2d8fb5Ax1PpvzoLLu8kjKOPFi1OBpclVU6H8+CzHLmHbKk2Wr7GuxXaqocZdTJuLKA9gUP5tnTtL6RYx2RXvQFdYZRRiNM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X3WrLhT_1779698252;
Received: from 30.74.144.135(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X3WrLhT_1779698252 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 25 May 2026 16:37:33 +0800
Message-ID: <1d8c7c24-b273-4826-9a9e-37fdb0767f2f@linux.alibaba.com>
Date: Mon, 25 May 2026 16:37:32 +0800
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260520101538.58745-6-chizhiling@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cbm6cbadpf9xijh51m9ee18txbf9fa89
X-Rspamd-Queue-Id: F0337C0002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779698257-709906
X-HE-Meta: U2FsdGVkX188U0qsyizC4uImeHp8/qzwQzAGf6a15mNkr+SumsJzSpY1adaVPwHWf6Cv1DQRNjpk8ZGBVyDMcm2kbFdenxKqnLIOZucp0vkYEZDsnckxPFmesdryZlBi28iqMm3W8QqiYSqlJd0o5WGsUHFuGWxGGMzCzI2v7vcGY7rAnkdaFj/SSgZUOwK+i/lq5GGzF1kFNM0edgZL9tVJ4KvzxzYg22oQwUKxF+pPLWy5M2cZV8VXE1DpJmX0pnLJw68Tj9Gnt2j8uJ6gfrJvf9O2tbc5GJZ1DF1avqAOWWKzJL4ULQwCXF3mSSvmp5ZHerDAEt3t4zdES1Jewu0BM/4MeXtDoAVhhEOifn9m84V0ZMI1DMXcXurMdLUx6/KmsG8J4iT7/amJmPNMJzHr6iwwUx1zGG5n26f4iZ/C7noDhvBPV0/hG04KIYhjGP/nH8maVl6OxfPxGEVcfVnEV1SRCGVrJZsHtyV7SA3gD5heMPB+QUN3Q4mzdg5YzMYPCo4bYr41esY5NvggCv/0VG32cnyK4wpNVD9mmvJoLITZPoLhwdBanwb9rjmePlS6f5A9MrFCgeIokV2jBJYo/lwHs+/uXCxh2B1i0UFxbtrQiwScMM7jCHHu1CAE9yUtVCkKFZD5eFQUxccyRRRZoOajgSfGq/ZCkOtTtD5tYNAYU7CElOvjdWy1PRrJ3a7F+xSk3WqdBac8dk60JkQ3hLI5kxPSfSRhfhbYdIqNghNLCVK5gUKaxAPb724I1Uxbdeb0VgUP+ktI2vMciZ3qpJkOFQoWv9AqskW2b+uLdCf94ZH1ecxL/Fjtzx8epZshD+Tm39yju0RLZmoARQnZlRubbpyWLJp57VaYnRPVzu/9W1QpwLZ74dlWc3km+lmOKfjeDyZj6yZ01AUsipor4TlIy5qihroY9qLFwGn4u3BVMC1PA/Gf41P5GJoENS4/GPKs/ex92Cy83Xh
 vXYEeUlw
 Qs8qgmS/pVfPaNedwmmx5NbKPkMnKXR/07ItNpKFOeydphfaQCkRi+3qbfRQt5rMknW1NVyszHRDuz8nPoRP7jkjsxELFi4w/+lC9q7nyHjjuG8rTtNZIqSg+IFkVcJWFo2B+LPlxKf702esrHEzc6zMVIGBpUCE/v8sBoi0Y68G5q397WmvTJymDxIcQaWbEDYUsIjEkLeujS8/gMwE1vdN6ny9FeHqbML03VyZn7qNEONkyoULs984HmOg/+WmPGz8dR3cpG7Ea22Cc0E6gk/4bXJTXbMm76/Aq7nBmOIVi0Bz7c7aI+Iv4gd4fUOnUy2a3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/20/26 6:15 PM, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> Optimize shmem file read by using filemap_get_folios_contig() to
> batch fetch contiguous folios from the page cache, reducing the
> overhead of repeated shmem_get_folio() calls.
> 
> When the folio batch is exhausted, attempt to refill it with
> filemap_get_folios_contig(). If no folios are found (hole or swapped
> out pages), fall back to shmem_get_folio() to handle these cases
> individually.
> 
> Additionally:
> - Defer folio_put() until the batch is exhausted or on exit
> - Add folio_test_uptodate() check before copying to ensure data
>    validity
> 
> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
> ---
>   mm/shmem.c | 50 ++++++++++++++++++++++++++++++++++++--------------
>   1 file changed, 36 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 96ea5a4c0aff..e0eacc23cccd 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3355,11 +3355,14 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   	struct file *file = iocb->ki_filp;
>   	struct inode *inode = file_inode(file);
>   	struct address_space *mapping = inode->i_mapping;
> +	struct folio_batch fbatch;
>   	pgoff_t index;
>   	unsigned long offset;
>   	int error = 0;
>   	ssize_t retval = 0;
>   
> +	folio_batch_init(&fbatch);
> +
>   	for (;;) {
>   		struct folio *folio = NULL;
>   		struct page *page = NULL;
> @@ -3372,18 +3375,38 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   			break;
>   
>   		index = iocb->ki_pos >> PAGE_SHIFT;
> -		error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
> -		if (error) {
> -			if (error == -EINVAL)
> -				error = 0;
> -			break;
> +fetch:
> +		folio = folio_batch_next(&fbatch);
> +		if (!folio) {
> +			pgoff_t start = index;
> +			pgoff_t end = (iocb->ki_pos + to->count - 1) >> PAGE_SHIFT;
> +
> +			if (folio_batch_count(&fbatch)) {
> +				for (int i = 0; i < folio_batch_count(&fbatch); i++)
> +					folio_put(fbatch.folios[i]);
> +				folio_batch_reinit(&fbatch);
> +			}
> +
> +			filemap_get_folios_contig(inode->i_mapping, &start, end, &fbatch);
> +			if (folio_batch_count(&fbatch))
> +				goto fetch;
> +
> +			error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
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
> -		if (folio) {
> -			folio_unlock(folio);
>   
> +		if (folio) {
>   			page = folio_file_page(folio, index);
>   			if (PageHWPoison(page)) {
> -				folio_put(folio);
>   				error = -EIO;
>   				break;
>   			}

I haven't tested it yet, but I'm sure this will break the 
fallback_page_copy mode.

You're fetching from the batch at folio granularity here, but in 
fallback_page_copy mode, we still copy the data at page granularity.

