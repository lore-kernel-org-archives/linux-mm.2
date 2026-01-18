Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D5D3C98315
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 19:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848666B00C3; Sun, 18 Jan 2026 14:33:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6186B00C5; Sun, 18 Jan 2026 14:33:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CAB76B00C6; Sun, 18 Jan 2026 14:33:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5AFC16B00C3
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:33:19 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E59F11405DC
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:33:18 +0000 (UTC)
X-FDA: 84346083276.01.6F0288C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 38DFA180006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:33:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ROsNx4kS;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768764797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JR5N+cqvevEQDVp7kDqn/R2ezVBSTAtlwxF/8RcN06c=;
	b=LrDmXK73eTKJoLeDi7v6mNbU8gytJxTNh2+2pIOm8J2+eIuDIDOGi3K10CBfMHPTSYuI8l
	9LHzO4LxEQ91NN3GNS0HU19kJDaAqWBA3L91ZRi3IMxq0gtIImJdH9+WBji5ye7R6GB8Ms
	WYfbCsBNswItsOWScZErLetDhx5Jmv0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ROsNx4kS;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768764797; a=rsa-sha256;
	cv=none;
	b=Zr6/f+nfPq8LMXCgyPHuzxEC0CO/Z+RQ42Yg2iBSIOrl05yZDkE5fVGzfdj3k5E5QR5R61
	jhU/yGsixNR75aSxu7uXd+NDviMqoduG1A9tYMzkQXfs/JFlKNPL83CRRX55Q1OhkiIqJr
	YSr2IF2E6k1RGA2U1otKjxg8xhV4scM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7817A60010;
	Sun, 18 Jan 2026 19:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EE8C116D0;
	Sun, 18 Jan 2026 19:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768764796;
	bh=Z+Jk8atOFmoKOV1bvDP8AmN9aAvWYcDPiNtVQJD27Ww=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ROsNx4kSsxCqNztbQEdn66FEa0kaCUSn1IxPqSel8tUGvT8Z+lxvVkNBXaoz8bQta
	 jINJX8BF2Aenca5/8AusZ4SI2CHxG2oKXtsXvrKElCd2ufNCIpy8zwAfpcN4ADMCP4
	 8t3x0GoBbUeix3TT0Jk8pHeBSPf7LBpRg7JAGW1I=
Date: Sun, 18 Jan 2026 11:33:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/shmem, swap: fix race of truncate and swap entry
 split
Message-Id: <20260118113315.b102a7728769f05c5aeec57c@linux-foundation.org>
In-Reply-To: <20260119-shmem-swap-fix-v2-1-034c946fd393@tencent.com>
References: <20260119-shmem-swap-fix-v2-1-034c946fd393@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 38DFA180006
X-Stat-Signature: os9jxkoo6xwdtb8gtidyjer6bus9grh9
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768764797-505162
X-HE-Meta: U2FsdGVkX19/sfWffU1IuMzwWZy/g3jCcRzcaZF9MOkivaIPiDkmaQxoQVJpkLcFTCaZVQCRG+XgYSXCHazWmlloejkKssrIC2RXDxwLaq6Y3yH1vipmqxGpKnzp8SbsXwUNYKxydqmRijhhL8EcU/RLwGvY+7gPIlH9fO3RnCAqmsdXjQyKLvmWNuAseXFUl1oZnYDdeondzmtssm3w+qOVUaZVcO038eYzJzywKlwMJURd0GjGkcK7FkZ5oLlFyezTi55H0n0AtqK7m1LV7RuBMUOcX51Qcwn48IJBOfSwSesHQY5bp1T68wq2QmW95e+h7HJPbdO1eAKjVGIg7gu9Lh1RylyBVelpxZ5OxgGjbGf9x56buvvYTeb9KS0h3adDZvrB599HEHky1sJRJBQJFwORbyBgi3g8+vM8fAUBLVLOY/RtgBKjohobSNSZ4prexc1JQxAgkHaUAKNwChH91EneAixGTAi5oEERsolpSzKutKEJkErlkfs5RnXIiEfKxQgONGEz3PXsdXp7NfTpMxiYy2sQ+7BGkNq4tdJhUPpX+bLN2GO4KBeESft9qXHrEpCtd6ASzf82eAPXM/TcOES+Pyvn5fC9tjsPhZJ0XiuNQGy2yqRbHx1BJykuStNiceeYreVmt8vKy1SsnQm9ZSctTR5vjVEvClt2kJG0FGjL89DDY2xLGJqt4kDSar1gc1y0mRscBmHEXwChj9mW0YO45R+yw8d7PfT800uHvPhTyQ2hbUjFLL6Nmoo7YDyGOa0mgonKQK2m/nW4CGZO+MzKxsy+8xfERpg0SE2rLhFZs93MMl5N6Y9jYuKe93Pb1i6dRxubUsVfKW3buzkhomifEBO/iN990s1JKgl0nHJ1VQus+9ryuDWUibeU5ZMldatSj7iFUtI16dWNGGieHxNZMsYfw2RZmI7eEIlO3Mo12+o4xbRYJ1R5u0AD8jdwf9CemoJ0VVwsfk7
 3sUn6gDE
 QLsq/dCjLILiDO6nyzYwf3+rNyyX/1GPRTvErp1pipjekqZVDWQgyQOt/ui1owB3aITjt0/J73r0YNdiyhyTv2WOEbTed82Aqwyl00HimhnDckhVpC+I08+xRrvU1k96m++Kruo/aK86B/NvEc0cIclHL4LQcGf5EQcoRJRJxIM0Jd/SjMRfmQFZvt+GTNmXh0GzaWNpVhuNVOLScUwSROquJGU9geAgL1Yru+ai8ZJ5jCRG6bAyuBBUGM1WEfo8hLLVYE42uXc9dVIWwmgfZW6W5XeeEOSuv9De/lxaFWxhTRjMhAn0buWPlKBm+WeJ/65KET7V5AH1Ho/dgH8pcWP/APP+BYXtYDbBsF0dgq49bqUjvSwBv9r+eGF6gSMifKtStl5wftRbwtQ9S442wwjJJ1rsDEdN2ypRU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 19 Jan 2026 00:55:59 +0800 Kairui Song <ryncsn@gmail.com> wrote:

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

September 2024.

Seems about right.  A researcher recently found that kernel bugs take two years
to fix.  https://pebblebed.com/blog/kernel-bugs?ref=itsfoss.com

>
> ...
>
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -962,17 +962,29 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
>   * being freed).
>   */
>  static long shmem_free_swap(struct address_space *mapping,
> -			    pgoff_t index, void *radswap)
> +			    pgoff_t index, pgoff_t end, void *radswap)
>  {
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
>  }
>  

What tree was this prepared against?

Both Linus mainline and mm.git have

: static long shmem_free_swap(struct address_space *mapping,
: 			    pgoff_t index, void *radswap)
: {
: 	int order = xa_get_order(&mapping->i_pages, index);
: 	void *old;
: 
: 	old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
: 	if (old != radswap)
: 		return 0;
: 	free_swap_and_cache_nr(radix_to_swp_entry(radswap), 1 << order);
: 
: 	return 1 << order;
: }

but that free_swap_and_cache_nr() call is absent from your tree.



