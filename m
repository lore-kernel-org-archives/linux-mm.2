Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD33FCF64A6
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 02:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24CB56B0032; Wed, 19 Nov 2025 21:56:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 223FC6B0088; Wed, 19 Nov 2025 21:56:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160BA6B0089; Wed, 19 Nov 2025 21:56:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 04A2A6B0032
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:56:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A6BFE89B36
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:56:49 +0000 (UTC)
X-FDA: 84129472938.02.39208F8
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf25.hostedemail.com (Postfix) with ESMTP id DF12FA000E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:56:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gUgFup+9;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763607408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gu2p1stqZhI773t46lmfwAG7f9EMqTo2bXhJc21l38Y=;
	b=j0rIgJehlS4LBjM+6Ye1Nr/YKCggZPB7+jLyzD3D1l24yHqs6B6T7T9sGQEHseM/2Zr9ED
	uSmMRpmRxCYbK7CPOXRWKYUgUr7Rfq9eb9Wn00KrNSSCmjMFLjhODkjixST/gIVyzt0CWL
	5FfFNFEQqH0OYVYhcIHErhMFjtWQp7s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763607408; a=rsa-sha256;
	cv=none;
	b=xnRI/7ZxfpFRqOPmyJW3GDHyGHOTzK33WeX4uaQpWZsg+awxE8KX2ey2FBiGD3TtkMUXEY
	zH5gLqIZBq2ht6WbJjqmM4ESXvxwQdPwf2UnYWNlj68STptmKduktvbnE0BGhX84o0YMcj
	h/pKxSoYjAwed9d5I/fG6dJtUaXpqvc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gUgFup+9;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763607403; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Gu2p1stqZhI773t46lmfwAG7f9EMqTo2bXhJc21l38Y=;
	b=gUgFup+9IpKE67EG+Hfw1ArYkVlxZpVw9bRVxIx6J1u8enQd1p2qBj2ZpughHeM3BqRqo5n1LPEWUOST9zvxLNhbuQEFQIRmvzX1dLMJ0rD8rVaxhiEiFHkjhu1onyP9UZbof8ucO8tf5jGIoewFvuvCGgupm9pijqZypIockKE=
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WsrPqH7_1763607402 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Nov 2025 10:56:42 +0800
Message-ID: <e47c61e4-2c02-4eda-bd8f-900855b03af3@linux.alibaba.com>
Date: Thu, 20 Nov 2025 10:56:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] tmpfs: combine !uptodate and post-eof zeroing
 logic at swapout
To: Brian Foster <bfoster@redhat.com>, linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>
References: <20251112162522.412295-1-bfoster@redhat.com>
 <20251112162522.412295-3-bfoster@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251112162522.412295-3-bfoster@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DF12FA000E
X-Stat-Signature: rakbfsye66ad1ix991oh9isajsyr95ie
X-Rspam-User: 
X-HE-Tag: 1763607406-828069
X-HE-Meta: U2FsdGVkX1/c/VD3wZ0Si9spcq1RObcqtuMgRgcRQQVyOe3XpC1rrlV5nhRRIXuX3CmqPQpDT+MUg2wVOdCxM4LKLf5hIGz6ulV5Lybi7fRzvmaLTwPtqCR17/h/uSvwgJP9aOc4lvjKbhvxw6W8GDfUuH+1cNUFQZsVTOfD9ZYb2JLYc6YHmCDq5mG1uMNfFH/Qi5ritrmMCS92A156eNPfFnG6z8IxJrBy4SiCndAAWMr8QG3Ke8TybFdgnJ2fO399AAj2zPpIuLLs2IRxro6+F0sneVpkgqOealbWAdVvXm3n9YZcGGP7RF4i0M7SkBNeg4uxpnuvrccjGFkz4KzGz28hp2wYPjTPBp3+r3Kk8jYYLXr/a8iL4p4KVi3Zb72sJaZ80XMX3YjPnZ+tkuZhavvOpoVByGZha0GKvJ3XV4XYMxLrxzZ+ciabiJXnlV5HB0BuuDRqh1uCOh9W6bGklCHWoQeQhRTtxDIXR46wP0bG1/nHcNlhUT35fOUZvL+QWVLpAX+dEvXVdcX/f3/loz3oMNh1HGQ3cVBAHwVsVZVgq+ZN9V7w0tZwrQtLftSapl9Et+M3Epdq3gfazL2og5UIvUDR85NRcUxEgp/IyXK2d3knp67hwl+YMrV+3cUwNe/J9XmLysQh0pWWoJqyvOsaudvFL0qYVQyLZwZnnZyy3lV2PVuk4IRp3SsV7E4DQdPITn2oc6NDVl9dDkJJ1YMEmBQVPbkRRwVpqS8xh4Hha29ZqUTlorRB2MYxBX6Mx5mPI0UX44dAJEAwWmDcu8ACup3tgRXwIHgll+qkE994Wv03t3/ibG+S6FyaOY/1RiKFw7PQRe7AIoZJ+YnyOm7PZw/4jkArZOxM11ZGLAM9ynIB2Dmtyhc58rGEiyg4SSPoPxZMEPRa9xDGY+QKkrv0Z6EXyy0HnfASkvaSHTcC+HcP51V2D/h2hO0S88NVkz64dc0bcwL9rug
 SDvZL8gC
 fk7WW5djaVdSKNAaBly7OcKO/q5c6C2+IsfZ57YTQ/8ZE6qFOb+57z0DCbr5J5F24WOqdBK1nFYQq/Y9RcUPFALVF5yRGSNbFZ4Ef0pKc0v268H0RGp0JJeExO1/xdkHKGs5FhnBSYNiX14eH2yWa4TgDpXYkuYHiEPsvI7MV0T53KFah0u754i7LynQFBALnHaPKcy/VCKjFwq2z20biDjzhc7oTI1dmKZcJeyFkCa44nYlL/F3wexwVguR/rcS4y+KdXS50emgTf/I/MNfOS3AeMIb4ahx9G97k42Fo/R6AxEWY716r0gOyc1CVZvb1qvcuH4wPnhOL5Gwc7nqRj67CtVsz+i5bC1nAaSVAK8gt2z3R2AZwD/LXK/bLewhc9ZOq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/13 00:25, Brian Foster wrote:
> shmem_writeout() zeroes folios that are !uptodate (before marking
> them uptodate) or that extend beyond EOF to preserve data integrity
> according to POSIX. This is handled in a couple different blocks.
> Fold the !uptodate zeroing into the post-eof block so we zero from
> one place.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   mm/shmem.c | 40 +++++++++++++++++++---------------------
>   1 file changed, 19 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5fb3c911894f..7925ced8a05d 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1627,25 +1627,20 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>   	 * good idea to continue anyway, once we're pushing into swap.  So
>   	 * reactivate the folio, and let shmem_fallocate() quit when too many.
>   	 */
> -	if (!folio_test_uptodate(folio)) {
> -		if (inode->i_private) {
> -			struct shmem_falloc *shmem_falloc;
> -			spin_lock(&inode->i_lock);
> -			shmem_falloc = inode->i_private;
> -			if (shmem_falloc &&
> -			    !shmem_falloc->waitq &&
> -			    index >= shmem_falloc->start &&
> -			    index < shmem_falloc->next)
> -				shmem_falloc->nr_unswapped += nr_pages;
> -			else
> -				shmem_falloc = NULL;
> -			spin_unlock(&inode->i_lock);
> -			if (shmem_falloc)
> -				goto redirty;
> -		}
> -		folio_zero_range(folio, 0, folio_size(folio));
> -		flush_dcache_folio(folio);
> -		folio_mark_uptodate(folio);
> +	if (!folio_test_uptodate(folio) && inode->i_private) {
> +		struct shmem_falloc *shmem_falloc;
> +		spin_lock(&inode->i_lock);
> +		shmem_falloc = inode->i_private;
> +		if (shmem_falloc &&
> +		    !shmem_falloc->waitq &&
> +		    index >= shmem_falloc->start &&
> +		    index < shmem_falloc->next)
> +			shmem_falloc->nr_unswapped += nr_pages;
> +		else
> +			shmem_falloc = NULL;
> +		spin_unlock(&inode->i_lock);
> +		if (shmem_falloc)
> +			goto redirty;
>   	}
>   
>   	/*
> @@ -1653,11 +1648,14 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>   	 * traditional writeback behavior and facilitates zeroing on file size
>   	 * changes without having to swap back in.
>   	 */
> -	if (folio_next_index(folio) >= end_index) {
> +	if (!folio_test_uptodate(folio) ||
> +	    folio_next_index(folio) >= end_index) {
>   		size_t from = offset_in_folio(folio, i_size);
>   
> -		if (index >= end_index) {
> +		if (!folio_test_uptodate(folio) || index >= end_index) {
>   			folio_zero_segment(folio, 0, folio_size(folio));
> +			flush_dcache_folio(folio);
> +			folio_mark_uptodate(folio);
>   		} else if (from)
>   			folio_zero_segment(folio, from, folio_size(folio));
>   	}

Overall, this looks correct to me. However, I have some concerns about 
this cleanup, as it involves handling different logic for !uptodate 
folios of the fallocate() and EOF zeroing. I'm not sure if combining 
them together makes the code more readable, since, as discussed in patch 
1, there are multiple scenarios to consider for EOF zeroing. Let's see 
how Hugh views this cleanup.

