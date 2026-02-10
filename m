Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4D5DEA3F35
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 09:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11A176B0005; Tue, 10 Feb 2026 04:56:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8776B0088; Tue, 10 Feb 2026 04:56:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F160A6B0089; Tue, 10 Feb 2026 04:56:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E21DC6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:56:18 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85F2413AFF1
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:56:18 +0000 (UTC)
X-FDA: 84428091636.04.343BDAD
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf06.hostedemail.com (Postfix) with ESMTP id AC7E418000D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:56:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Wo9jxiFw;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770717376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g3w4Ro/Mrn1bvyLjMw2VNSGjYzqSkpMN6eH9+J0A5QY=;
	b=pMwdvhD49PhuFkabUNlL0h9aZ1St8qfOcTzqAnNUKZGWoMN4CSYkhREdaUX+RkG374b8Gy
	oSyngQl2sJ0lQNvDmzfpWJWe1LWeD0ym4xULLgJPpITh6cApR9WxEPMha7+oq+m4sHi8QG
	uaJr+RicagcOnJR9r/Cm42YiFoV/2NU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Wo9jxiFw;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770717376; a=rsa-sha256;
	cv=none;
	b=wdbsKnxvYCzthV0oe/bxgzWgFxtGHk72Rdw1kgHTU6u2IAUlCeg0br2OysVoxD6he8eT+w
	eLqKHZhzjHdBYeSHj+oiGPizo743bkHBJLypO6OQaey8Nzf/rn6zJM560ftM5S/BGQ8c6/
	N7ddW+o2Agum29d37PrGO4BX4idwbpk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770717372; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=g3w4Ro/Mrn1bvyLjMw2VNSGjYzqSkpMN6eH9+J0A5QY=;
	b=Wo9jxiFwshE9fRawB9+WWUaBVdE1UcAW+iLmfBBEoYJAZge9xKjLpsUap4sj80lZKbO9QfA6M83Sq5t1Ga4npEeY8dOa1JAmOpbwW5Jm6UjwaFc3yPqMjZQoSZbbQQ9xEbCgMjg7SJL1w3EvE7V4e4W5XVULi5BHzCv94RFn678=
Received: from 30.74.144.109(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WyyoplG_1770717371 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Feb 2026 17:56:11 +0800
Message-ID: <d2bc3d79-5d00-4943-80bd-01b144529177@linux.alibaba.com>
Date: Tue, 10 Feb 2026 17:56:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/11] mm: thp: always enable mTHP support
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1770675272.git.luizcap@redhat.com>
 <29e8dfc2772af4b6e0db24134ca3563ec422b91a.1770675272.git.luizcap@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <29e8dfc2772af4b6e0db24134ca3563ec422b91a.1770675272.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b44h6mfi9frjzkmykwgow848f43w7k9w
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC7E418000D
X-HE-Tag: 1770717375-863157
X-HE-Meta: U2FsdGVkX1+fvbWQ9kmc2WJYgTgNARu3TIlw+zzk/rW8CautTKDsDJ+B/2Pz1vqikXuEmqQUqlBusHoIs1+z6ZeG/bWP4FARohc5Wgj0FmgD3fYursiN2g163KrmTSzc1xdK7LSmdVL4ufIFH8QN+E+ztTYpcx0but9dQQVSM5QQCy1RB75Dl7C4GGC5bJtxehMUI6Iz+IYzszScNq3MTi/t65EVI2mBpM/YYmocsVdMp6QnmZSS4IDBVwzr4hgkEvkuwFI+pKLMuP0ibuCYEJahPMP61TcaH4np5XuPYQ5DYKw50iNLIuWRhfcu/7blg12i+4VZdYvDjFDanRDLfoJ9CVHkTc1V/QRBPLy9/0JmZ9GHT6zgC7m+aJMGqqwCF9Rxtw+YtD9RjjO0fR0gqhmnfBZNlYflA6h904bCw/dilpO6uZVGsvBPUIefvF5DTkQVjuswYkILj4+2pQxMbSERbnCcwcUprHhwGLrONPRJYEesRjF6ouPPHji4sxFk8BJUBaAH8NxcHtb40S6NiuqmMOfB0bPOgUbXT07X1/6jdH3PFvHMOUFrJFgWqU9sRS5gTDq1DWy825+fFtWN+nog2SXfh7R6OWS5Knaw/T49BVWh+pKs3DNeAvd8MVf1DPn+hU0N5xqXMsWkQ/nM+pgvobF8F1GFUsi0yqmSlk+V9SXJ/537aJFcxuUzYLAOO/9fOzIwsk68RMjoXdCR7sL//6NReM17ICpQyW3TSi/3pOZ+eFm1pHVp3xOEawLvMgz4YWQiiDCjUpvlnN6s3Mu6FEgo7KXEoR2/mEYEGL7Ew+8kIbZSofNuvWcl/qPiFDBvY7JKQyY+QOvXqDvXm1GDX5Vj0iQmQ29sO4hgCqnsQfaoh24bpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/10/26 6:14 AM, Luiz Capitulino wrote:
> If PMD-sized pages are not supported on an architecture (ie. the
> arch implements arch_has_pmd_leaves() and it returns false) then the
> current code disables all THP, including mTHP.
> 
> This commit fixes this by allowing mTHP to be always enabled for all
> archs. When PMD-sized pages are not supported, its sysfs entry won't be
> created and their mapping will be disallowed at page-fault time.
> 
> Similarly, this commit implements the following changes for shmem:
> 
>   - In shmem_allowable_huge_orders(): drop the pgtable_has_pmd_leaves()
>     check so that mTHP sizes are considered
>   - In shmem_alloc_and_add_folio(): don't consider PMD and PUD orders
>     when PMD-sized pages are not supported by the CPU
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   mm/huge_memory.c | 11 +++++++----
>   mm/shmem.c       |  4 +++-
>   2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1e5ea2e47f79..882331592928 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -115,6 +115,9 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   	else
>   		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>   
> +	if (!pgtable_has_pmd_leaves())
> +		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> +
>   	orders &= supported_orders;
>   	if (!orders)
>   		return 0;
> @@ -122,7 +125,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   	if (!vma->vm_mm)		/* vdso */
>   		return 0;
>   
> -	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
> +	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>   		return 0;
>   
>   	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
> @@ -806,6 +809,9 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>   	}
>   
>   	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
> +	if (!pgtable_has_pmd_leaves())
> +		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));

I think you should also handle the 'huge_anon_orders_inherit' setting in 
this function if pgtable_has_pmd_leaves() returns false. Shmem as well.

if (!anon_orders_configured)
	huge_anon_orders_inherit = BIT(PMD_ORDER);

> +
>   	order = highest_order(orders);
>   	while (orders) {
>   		thpsize = thpsize_create(order, *hugepage_kobj);
> @@ -905,9 +911,6 @@ static int __init hugepage_init(void)
>   	int err;
>   	struct kobject *hugepage_kobj;
>   
> -	if (!pgtable_has_pmd_leaves())
> -		return -EINVAL;
> -
>   	/*
>   	 * hugepages can't be allocated by the buddy allocator
>   	 */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 1c98e84667a4..cb325d1e2d1e 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1827,7 +1827,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>   	unsigned int global_orders;
>   
> -	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
> +	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>   		return 0;
>   
>   	global_orders = shmem_huge_global_enabled(inode, index, write_end,
> @@ -1935,6 +1935,8 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>   
>   	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>   		orders = 0;
> +	else if (!pgtable_has_pmd_leaves())
> +		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));

Moving this check into shmem_allowable_huge_orders() would be more 
appropriate.

>   
>   	if (orders > 0) {
>   		suitable_orders = shmem_suitable_orders(inode, vmf,


