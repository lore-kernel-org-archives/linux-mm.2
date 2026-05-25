Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24A80CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 07:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13C66B0093; Mon, 25 May 2026 03:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC4056B0095; Mon, 25 May 2026 03:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2A96B0096; Mon, 25 May 2026 03:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C34386B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:10:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53D12140197
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:10:36 +0000 (UTC)
X-FDA: 84805069272.28.1CC90E9
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9DE2818000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:10:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mjFDPoQS;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779693034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0TGY7Tvs4qtdmNexGx+wDHmFYHVm6o5kSYPELpBcuk=;
	b=Lx/eEs3YNOHXwV4Me/v2VEszRJBAkn9XMFifrQnVrmX6sgfdUGJlsHj+Q6++S20eiab6vO
	ZiQuUMWT71gmWFTUKWmv2F84KGArY8zXU5wjQ/Rfcf1VBRUBZzEhj2tqYRUD1HUE8p3L8n
	/ao73LI/u0Dku9Msz3yUNfIFW2xTaIo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mjFDPoQS;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779693034; a=rsa-sha256;
	cv=none;
	b=PlOj3LzqSK8RcqDMpCWVDii7O2ep152sVD+J5eLf3gW0MJGpimdfI6oq7+ZvkHF0xU/LtS
	aBYo9BCeaybPb5lhOcvrtue/kij4zJKV3VsRwh0bET7AD+btYYTIjTVoyOUlbZaCJZ5uSS
	UJ1hHjliFCvUuoKMzVMO0Q9OP8GXHiE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779693029; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=q0TGY7Tvs4qtdmNexGx+wDHmFYHVm6o5kSYPELpBcuk=;
	b=mjFDPoQSSzWNDTYa7QcQA8yGYIKJ8TzwWSwnUtOKhEG2hU2Dr6cT0lNIECrjfD7pONZoPHmQemFlCv150PQeD7ZUaNmk8RQTNs/FJrpwPVQJ/riRxlGGbY0xS35h0Y1+j0PbVU40WuVvbqo15OcpXVVZglOtzCKGQNT+XOw7Ins=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X3VfnFW_1779693026;
Received: from 30.74.144.135(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X3VfnFW_1779693026 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 25 May 2026 15:10:27 +0800
Message-ID: <772f7bcb-eb78-4439-b94b-1a096a01dc51@linux.alibaba.com>
Date: Mon, 25 May 2026 15:10:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/5] mm/shmem: make SGP_NOALLOC succeed on hole like
 SGP_READ
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
 <20260520101538.58745-4-chizhiling@163.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260520101538.58745-4-chizhiling@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qs7qor3jmx7qp5rncj9puibmoqi6r1j4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9DE2818000A
X-HE-Tag: 1779693032-44278
X-HE-Meta: U2FsdGVkX1++0qE7Tb+LkOQ2cCcteoA5pYMraUQs0t/NsLjI/gK7+c+M7kD/EHxhU4UMUgR0bBTpylyC5HOlbJj686JseM6Lc9K/IalAzB4ypo2TsrX62dnx3qO3iz9+4rvBMs9fMLqdGS0MGW/qdA5y5VHAz/b9rDXYv+ydKQAx8/HzK6DKXXxRxcivKsDH1fkovdM7FCq7b/ERuv3vkPaxv5R/11QEV8DxquZhsD1ICJOLTHdIZDH2ztaGXsj97x6+l/1icXKXC4gmGUsn1PK6cw5liKi2oX1ZasPyE340NK7yW4yGBkZRDSfpAYYdx2xhWrMkOFR3rJz1Y78l0rb9+P5vq1LpolXW2Z6oznJvXV1K77sIZ5GBJGcz1l2dd0FoqXFZNgab1kwIiZGVEc5vFNGnwZ6sWvQXuwWOZ/5V/vLQq4h7C9iQ9U8gYjZnz+BwfeAW1BM2nscMxTN0Yl+D37CfbWSiEbuY4TRM3huSfpsQh/1lZgTZPhacBqg31H4nZv2WzlXd5UE1/EaaO0cnTZGW8NwMyQca4qVm2MN75Ab2XdiyPUOMolJ1tDV7YzCQEa1FTghTTBOZkdvk4a2TwmCS42zTUSMo08G1opkO/c2hMw7q7zjYANsDUIE5oBuBIPa0uR7jq0nBOMLhgtFLStcxlC6z818ItId3cDlJlsx5U9deILeFqjxBHgE1sWPKhvPNMoSRbcOAie8hK3s2ZKwl2Kgzt9UWMPcCpYMQqeJlb6o2uwgzyDXQ4B0c3bTxNw4s+AyrjP+Tcs8ehKFhi7RMm8TJsg0SgVZ49qJbpMCAVZVByd6QFaKwn4as+AsIpE1ov5VnzWvVZmABiL1ctwdGqz4V0UaIS9N12a2WCKXAWRIixH74DIExdnH8TmIJw5ISq0fvCScvyjjmSccGO4UX1t1iYieP1iU9wF6FL5Wggr8Ff3xHv7wfT8XAvt3Olv9Px8wRtUMOMGL
 jiUg/L6x
 Xv6IrKHLbHfoohXqYsZMESWvhnkb1peex/tJzEk8a2H+rLPzPd+G5hGZU/pSLz7avTZNl+4kt6yb8XWTOIz+FGxwTOcayueoqaA0vfAX1CCn7L4b5Uo3g1aY0z5HbvLZh/oqRN/2YqEVs5BZdpAFx8s+UCdCTAYDgXBEf4qtKDwZ0mr28hwnhLUrJRoi0VlxNnsCRkS1RIS7NwSrv7Rg7yW2D/Bur78KDUC5/hoR/9WDhy6fvDcNH1TZpSoVrSgUrrhzI4EZx8aZ03kEEihyuYCGuMt0qVuB2cke0lp6Z09V1FjR3wK+2bvZ/cANQ3o0GyahmnBqbZkYGrd9yCisaMgM8bs7UEA0DV1JOZnXtQGNWXPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/20/26 6:15 PM, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> Change SGP_NOALLOC to return 0 with NULL folio on hole, matching
> SGP_READ behavior. This simplifies the sgp_type handling by unifying
> hole semantics across these types.
> 
> Previously, SGP_NOALLOC returned -ENOENT on hole, while SGP_READ
> returned 0. This inconsistency required special handling in callers
> like khugepaged and userfaultfd.

This patch doesn't seem to be a performance optimization, and I'm not 
convinced.

> After this change:
> - khugepaged: behavior unchanged (checks both error and NULL folio)

But this adds an extra check to khugepaged, and I'm not sure it's worth it.

> - userfaultfd: behavior unchanged (both -ENOENT and NULL are converted
>    to -EFAULT before returning to userspace)

No, this will break userfaultfd, cause userfaultfd currently returns an 
error code directly in this case (please update to the latest 
codebase.). See:

static struct folio *shmem_get_folio_noalloc(struct inode *inode, 
pgoff_t pgoff)
{
	struct folio *folio;
	int err;

	err = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
	if (err)
		return ERR_PTR(err);

	return folio;
}

> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
> ---
>   include/linux/shmem_fs.h | 2 +-
>   mm/khugepaged.c          | 2 +-
>   mm/shmem.c               | 9 +++------
>   3 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index 93a0ba872ebe..d461713c095b 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -165,7 +165,7 @@ extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
>   /* Flag allocation requirements to shmem_get_folio */
>   enum sgp_type {
>   	SGP_READ,	/* don't exceed i_size, don't allocate page */
> -	SGP_NOALLOC,	/* similar, but fail on hole or use fallocated page */
> +	SGP_NOALLOC,	/* like SGP_READ, but accept fallocated page */
>   	SGP_CACHE,	/* don't exceed i_size, may allocate page */
>   	SGP_WRITE,	/* may exceed i_size, may allocate !Uptodate page */
>   	SGP_FALLOC,	/* like SGP_WRITE, but make existing page Uptodate */
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b8452dbdb043..3309d1c094df 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1950,7 +1950,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   				xas_unlock_irq(&xas);
>   				/* swap in or instantiate fallocated page */
>   				if (shmem_get_folio(mapping->host, index, 0,
> -						&folio, SGP_NOALLOC)) {
> +						&folio, SGP_NOALLOC) || !folio) {
>   					result = SCAN_FAIL;
>   					goto xa_unlocked;
>   				}
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b5dc21b323c..458853c506ea 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2524,14 +2524,11 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>   	}
>   
>   	/*
> -	 * SGP_READ: succeed on hole, with NULL folio, letting caller zero.
> -	 * SGP_NOALLOC: fail on hole, with NULL folio, letting caller fail.
> +	 * SGP_READ/SGP_NOALLOC: succeed on hole, with NULL folio.
>   	 */
>   	*foliop = NULL;
> -	if (sgp == SGP_READ)
> +	if (sgp <= SGP_NOALLOC)
>   		return 0;
> -	if (sgp == SGP_NOALLOC)
> -		return -ENOENT;
>   
>   	/*
>   	 * Fast cache lookup and swap lookup did not find it: allocate.
> @@ -2657,7 +2654,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>    *
>    * When no folio is found, the behavior depends on @sgp:
>    *  - for SGP_READ, *@foliop is %NULL and 0 is returned
> - *  - for SGP_NOALLOC, *@foliop is %NULL and -ENOENT is returned
> + *  - for SGP_NOALLOC, *@foliop is %NULL and 0 is returned
>    *  - for all other flags a new folio is allocated, inserted into the
>    *    page cache and returned locked in @foliop.
>    *


