Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D685FD2ECFC
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 01:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4790C6B033F; Mon, 19 Jan 2026 20:16:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 450546B0342; Mon, 19 Jan 2026 20:16:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353056B0343; Mon, 19 Jan 2026 20:16:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21BE06B033F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 20:16:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5AF01AE04F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:16:39 +0000 (UTC)
X-FDA: 84350577318.08.1F349B1
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf25.hostedemail.com (Postfix) with ESMTP id 82077A0003
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:16:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=M5XjkrFG;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768871798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOHQsrEmVvikkCnWyd025/g3MvKnBrG2ukxJxETFEIM=;
	b=V++tAFZI36qsV1BJU5GY+89Om5+wyHYaI2/KjOv0MOL1ne5T2i8IfXqIS4LHewEi31IcX5
	V4HYIvAyNao3JdJcxiNBWl80LN7PWa2QCGXNoSYtmKi8kEj2exjffIS/kSmOI0CGqRHHO+
	NDa+Xe+XOJDN7gTfD5pe95DtPHGYgRQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=M5XjkrFG;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768871798; a=rsa-sha256;
	cv=none;
	b=KpXkuJeCDwxYiZQUflXnKcpNblGhv1zzRDbu+pM725IHvFKSsMiEPgajpB0p/QtrU5ELcf
	tsqBVnGnfIAodISqSbSkEBkaEHStPlByBCRWPTvvkZgn9WI6eOucxCkH1FGHyGZt9nfGC4
	w0NAZnp3zdFQ0/aDmPM+egm5QghOZgk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768871793; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tOHQsrEmVvikkCnWyd025/g3MvKnBrG2ukxJxETFEIM=;
	b=M5XjkrFGLqe5eP1AjA7hoLYNldGMkxs1stIo1LI7J/T5xaecJUbFdy1aqotOF/2IsQLewSfv2tV4U1FSmDW6BGDKkN2M6Aerm3n9cIhcVbwP0a7GYMqVpKuTCbDE2AkxOYqDLOhywvCEd+sPCBQojmbHnfLoYiAldqU2IEHyyak=
Received: from 30.74.144.120(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WxSDocC_1768871791 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 20 Jan 2026 09:16:32 +0800
Message-ID: <9961743c-6d5f-4a62-9220-50869ac9a2d5@linux.alibaba.com>
Date: Tue, 20 Jan 2026 09:16:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/shmem, swap: fix race of truncate and swap entry
 split
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
 stable@vger.kernel.org
References: <20260120-shmem-swap-fix-v3-1-3d33ebfbc057@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260120-shmem-swap-fix-v3-1-3d33ebfbc057@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 82077A0003
X-Stat-Signature: rc4k9ozpoqcmgt94thqqbeipf9s11qw7
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768871796-177051
X-HE-Meta: U2FsdGVkX19XnxKA4cEw2NDfok8+/HJNDqQ9ROT+iEDNtgKXOzHmH47TmjsscXVlKV3jvXWv5p5mkrKt0n+s1SNKCTN3FZQ6RmgcSPF7uA+Jtfq3rrZmuwk6U7e3/lcNx8EQAyI9RKNvineVhnlibb/f9WSv3xkyASwO83tYaZtl/YpKp/6gox92c3Q1N6ASoK07VwTAy5eql2Rm2Z+056QODS1o91suhCRUkzaCtkmNSRDKi6B2uFO+BaREiZVciyabQjNMYkEYUxElvT5T6FAK+5ziU8/7AuYTi/oJeHthC87y5z0okagefupauMKfmuw1Qhwk/qAkHPjRXI9nB2klRClzNhIEl2Ea8KhCslM/GHpwwpkBpUCnGgwKPdOntvjdbsqaUDu7iIeojjQ1IGkXM+ofloWSdQ/YvGqv2tpl1fYY7JO+nvOo86NKI91r1T5QeD7Z7mjCsWCv3FW9RKkmuYhfnxx89T+CdNzJYSrfzuttAG6jkFhsIyspr7NT1WL5tbqE5ijDXkVOaEXRTd+9AYBtw3CmwroKN+OspCJDfwYAUkfrndwTiU4dbBWwlnKK9VTOm8ohN3lDSZ4OULm73PucBshohvDWLkJol3Y6ONuQe19d/+NsD13vDscN3gWOhEvD4B1ujU5+ZIqEo/X8w2Zpq2pwUFwvpGA+0XeQk+D1TXAcJlwOAwt5LQW0g16yaLuE9YPdp2D5EoDR15EMnOltSqeLEIBSp8kRDyS9zvX4tlUHKkyfQ0bzLHk8I9sBl70cz8wtFSHWNQ/yc/t430alYzcpxFF1LDCGt/c0SVBGnSWwTsBv64po0yNaAL8z1x++Vg+V7mbYfDpGEz7i7UZsOqFVl+F2RMdcsypds468VWhXEd+v/qYkGxKpPKYmbVa2aK6/D6j8hhxOxmsB6gR1kHKeAOmk1qwldq5eXqoXcYZahYmbCIzeV7EZUcIhZVFGTLkZk5dMit+
 Quabnbak
 6SIiZoqhGgfuG4qvsItP/VyOwyrcYuQq5Xf+oYd21lek+5RqndoUuJF0vjzzei0AGafXYEL481QaZsf/yinbKbmz89GDxtcvAXH24slfQZSI6QzRFbG8wa4tEuEOvNn4lTScU2wm5k+GjRpLkygZie4AMd3IfLyn2I82HkupW0SwcFK5zHhwRU8CKcQubdf3I+qFxvgHytmtrErswmvPvhhp78ve0kasS2inlToRH0VMO8Hw33ppBE97czel2+cNISnYFXUlBpY9GoTadS4228C6iDU9ak7BiCj3Ns6js7070qa6KxXC2CPd7OyX5wZmmTmGctdYa04xMEaY9fHJ+upjQsyxw/eAMjRuq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/20/26 12:11 AM, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The helper for shmem swap freeing is not handling the order of swap
> entries correctly. It uses xa_cmpxchg_irq to erase the swap entry, but
> it gets the entry order before that using xa_get_order without lock
> protection, and it may get an outdated order value if the entry is split
> or changed in other ways after the xa_get_order and before the
> xa_cmpxchg_irq.
> 
> And besides, the order could grow and be larger than expected, and cause
> truncation to erase data beyond the end border. For example, if the
> target entry and following entries are swapped in or freed, then a large
> folio was added in place and swapped out, using the same entry, the
> xa_cmpxchg_irq will still succeed, it's very unlikely to happen though.
> 
> To fix that, open code the Xarray cmpxchg and put the order retrieval
> and value checking in the same critical section. Also, ensure the order
> won't exceed the end border, skip it if the entry goes across the
> border.
> 
> Skipping large swap entries crosses the end border is safe here.
> Shmem truncate iterates the range twice, in the first iteration,
> find_lock_entries already filtered such entries, and shmem will
> swapin the entries that cross the end border and partially truncate the
> folio (split the folio or at least zero part of it). So in the second
> loop here, if we see a swap entry that crosses the end order, it must
> at least have its content erased already.
> 
> I observed random swapoff hangs and kernel panics when stress testing
> ZSWAP with shmem. After applying this patch, all problems are gone.
> 
> Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kairui Song <kasong@tencent.com>

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

> ---
> Changes in v3:
> - Rebased on top of mainline.
> - Fix nr_pages calculation [ Baolin Wang ]
> - Link to v2: https://lore.kernel.org/r/20260119-shmem-swap-fix-v2-1-034c946fd393@tencent.com
> 
> Changes in v2:
> - Fix a potential retry loop issue and improvement to code style thanks
>    to Baoling Wang. I didn't split the change into two patches because a
>    separate patch doesn't stand well as a fix.
> - Link to v1: https://lore.kernel.org/r/20260112-shmem-swap-fix-v1-1-0f347f4f6952@tencent.com
> ---
>   mm/shmem.c | 45 ++++++++++++++++++++++++++++++++++-----------
>   1 file changed, 34 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ec6c01378e9d..6c3485d24d66 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -962,17 +962,29 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
>    * being freed).
>    */
>   static long shmem_free_swap(struct address_space *mapping,
> -			    pgoff_t index, void *radswap)
> +			    pgoff_t index, pgoff_t end, void *radswap)
>   {
> -	int order = xa_get_order(&mapping->i_pages, index);
> -	void *old;
> +	XA_STATE(xas, &mapping->i_pages, index);
> +	unsigned int nr_pages = 0;
> +	pgoff_t base;
> +	void *entry;
>   
> -	old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
> -	if (old != radswap)
> -		return 0;
> -	free_swap_and_cache_nr(radix_to_swp_entry(radswap), 1 << order);
> +	xas_lock_irq(&xas);
> +	entry = xas_load(&xas);
> +	if (entry == radswap) {
> +		nr_pages = 1 << xas_get_order(&xas);
> +		base = round_down(xas.xa_index, nr_pages);
> +		if (base < index || base + nr_pages - 1 > end)
> +			nr_pages = 0;
> +		else
> +			xas_store(&xas, NULL);
> +	}
> +	xas_unlock_irq(&xas);
> +
> +	if (nr_pages)
> +		free_swap_and_cache_nr(radix_to_swp_entry(radswap), nr_pages);
>   
> -	return 1 << order;
> +	return nr_pages;
>   }
>   
>   /*
> @@ -1124,8 +1136,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>   			if (xa_is_value(folio)) {
>   				if (unfalloc)
>   					continue;
> -				nr_swaps_freed += shmem_free_swap(mapping,
> -							indices[i], folio);
> +				nr_swaps_freed += shmem_free_swap(mapping, indices[i],
> +								  end - 1, folio);
>   				continue;
>   			}
>   
> @@ -1191,12 +1203,23 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>   			folio = fbatch.folios[i];
>   
>   			if (xa_is_value(folio)) {
> +				int order;
>   				long swaps_freed;
>   
>   				if (unfalloc)
>   					continue;
> -				swaps_freed = shmem_free_swap(mapping, indices[i], folio);
> +				swaps_freed = shmem_free_swap(mapping, indices[i],
> +							      end - 1, folio);
>   				if (!swaps_freed) {
> +					/*
> +					 * If found a large swap entry cross the end border,
> +					 * skip it as the truncate_inode_partial_folio above
> +					 * should have at least zerod its content once.
> +					 */
> +					order = shmem_confirm_swap(mapping, indices[i],
> +								   radix_to_swp_entry(folio));
> +					if (order > 0 && indices[i] + (1 << order) > end)
> +						continue;
>   					/* Swap was replaced by page: retry */
>   					index = indices[i];
>   					break;
> 
> ---
> base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
> change-id: 20260111-shmem-swap-fix-8d0e20a14b5d
> 
> Best regards,


