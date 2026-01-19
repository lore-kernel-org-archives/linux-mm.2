Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD50C9830C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 03:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A62D6B00E8; Sun, 18 Jan 2026 22:04:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D416B00E9; Sun, 18 Jan 2026 22:04:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4A46B00EA; Sun, 18 Jan 2026 22:04:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B37F6B00E8
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 22:04:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9DEF1A064E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:04:12 +0000 (UTC)
X-FDA: 84347219544.06.0A34BFC
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf20.hostedemail.com (Postfix) with ESMTP id 767AD1C000A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:04:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="mixYw56/";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768791850; a=rsa-sha256;
	cv=none;
	b=zGlsZSc6XzPZPpaHhqdDlta2WkdkkoPypXTVR/YgdJFL6RlBZBshElEgdO2ffe/rmfxHtG
	m1xZcSYFU0R8IHrBw3jk6/jgPJr0wuUQ7EFO96VoiRiXGRkfr8lNzRNPY7uhKwyGJ2M8tF
	eSBeVaqy4RHnQGaSqzNTaCgU/jmfxJU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="mixYw56/";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768791850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0eI/5dwYg2GHXyg1BMxV5hVYdSwwVqxTeMdN4bZK0Q=;
	b=F6L8a5nGjqjWETqBKuJBzpQudx22yn8Jy+te6x+Jlzlf7lU8uQ4mInmF/UKm+zQKOSooeJ
	0AwYTfzyXIyxWmkc2YHSIDYbzJee4pDadC8g4P7DyARlMTMzKC7U93w52T6Cc/YES2wwCV
	1dafqBk6ruoP7lxwF5ivxI6vK015a8c=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768791845; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=n0eI/5dwYg2GHXyg1BMxV5hVYdSwwVqxTeMdN4bZK0Q=;
	b=mixYw56/gzFDarIdQCcAG0I6g5H7tgKfKTTIsXhiDNIXYP9yZlgF3JmlQzKtNES1eMHXk49jRysKaNk6asPa26qzuJc2C8Ab+ztaL/RFVf7tpFnscwlyH0yhItNQZPv8dLfMoX0sCQZ5WzJaMeoijf/cSMb9SEkjeYY7gIjlrCI=
Received: from 30.74.144.151(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WxHY2Rb_1768791843 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 19 Jan 2026 11:04:03 +0800
Message-ID: <74fd3fd1-97d0-46a3-b76e-435808efff02@linux.alibaba.com>
Date: Mon, 19 Jan 2026 11:04:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/shmem, swap: fix race of truncate and swap entry
 split
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
 stable@vger.kernel.org
References: <20260119-shmem-swap-fix-v2-1-034c946fd393@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260119-shmem-swap-fix-v2-1-034c946fd393@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 767AD1C000A
X-Rspamd-Server: rspam06
X-Stat-Signature: imukoqibq6rqtk6digooh7tx51jm1gmr
X-Rspam-User: 
X-HE-Tag: 1768791849-641458
X-HE-Meta: U2FsdGVkX19yybKHWEsKdNesplanOU7utu9tMmYUyM4YTB3OotVZbkLa2+TdnwY6+SR3CHcn6urEAiiLQmxvfq+HXp+8FYh7T3tebrg+sF3Xkrx26axS0KMmYPiUUk+7a9Yit+4hXn1WFDC93290IfsrhkudTCFCiejC7EPL4ig4DoWEbURqV/vz2bBtvDCZVol4Y8/6bKLoNZcnvZ3giLdWmEUylDRbIDOkBYnN1M4d8Mqp0AIdz4Ra8TLo/6dznv/5dkyqWOX57wSSYZW3BKbYXCFDtsfmHuuXO9sO+7Mq5SqB7AZfBZoA2EKYPdabFQxVQPdfsg13UEdExQxcw41AjdUEfI+6Zpo03reFQwnl7IavW31xtLL/lN7mqlPHDJDGcGIMgL7sCNDhvtO0DXylv0eoZYCK/ehvgqXhgRvNQxTL5ZXo3Ut0+e9y8MA4DhS4y4olZUiwwQ5gC4b8bIoBe76v8F5IHgSafV4fw9nvfukRm3JzI5TIZGAsp7f7v7Zm1ut4VBePlFsrYWF1uTI/H+4JDWhZAM60dUrpDdTiNBCl/xEBPGEfYbGpoqEtKS2tOmpD8ulO1G1WsarnOyKd96n7v1np8l/nTzusRBR2TqscMywxczx2w/ADa7AfRLcPg4vdEO4KfK+nzE5jqD1RZ79e2siEmVTZH8+UJqli5Q0008owg2FzmVobWhcRB5GTTCgDKSLFPayIroA/4+Va+9kqZALtf/I3JfvECnpVpNbNB5awM3BJpytssJIKb3mG82G8M3CrqybdxEF3ZFLQJUyxyRGeB+vzeP8UY63X97N7UtAJw5EWOIibHOa3cP9QZDXuDgD1Ngfc05qKKvhs5YUPU57BJCnXKizRB1Xvyf3EeaBcwPgM+Coo4Hbx0YJH0MhYlDWiGtzPwgyKoY5OC1amK6ZMvq7WTUj8uQblrpM7Dw2ndcglHrUgkjIBla1NpjdIrgNl0W4N1HX
 L+6YgZEZ
 OAadNgVgVUQ5taZYzsqnF8ToJmgfIhZ3uRmNbIVekY46Vbus3/DydEFxcKB6Hix/WGquoyoiOuIbCW5lV2V47jngi95Jy+hi4uvgHmjgtLd3ApApUkXkgre9vNdrlEdub+G1mmy89NuxvQramx5BuhqTQt1IxJ1TYGWgSdIJm+mHTQQph+4zWMXARRjpo/kMZzI0NojE70pVGp6zxy9PsHA7NyAAc3MzjYlKZWQddymJs9m9kMJqvS2IKK4Z+eDkedZ0fFoaFfGqlvw1MF6dDl107JkerpD4/5375nxsxgiVsYTQ6bDjmYGQrkQ3PtjZWzbevZUnHY1kWcq81TkMlbhz9Ai6Ny6L0Tztoz5BJkUggCWQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/19/26 12:55 AM, Kairui Song wrote:
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
> ---
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
> index 0b4c8c70d017..fadd5dd33d8b 100644
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
> -	swap_put_entries_direct(radix_to_swp_entry(radswap), 1 << order);
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
> +		swap_put_entries_direct(radix_to_swp_entry(radswap), nr_pages);
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
> +					if (order > 0 && indices[i] + order > end)
> +						continue;

The latter check shoud be 'indices[i] + 1 << order > end', right?

