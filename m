Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0480FCD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 16:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF2556B0092; Tue, 23 Jun 2026 12:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCA246B0093; Tue, 23 Jun 2026 12:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE15B6B0095; Tue, 23 Jun 2026 12:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99B7C6B0092
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:46:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17BB4140265
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:46:00 +0000 (UTC)
X-FDA: 84911754480.05.A467CD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 833BBC0003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:45:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WNoNdlTf;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782233158;
	b=FJ4KwqQWXRt3EhONEL+yRXuko8YkcEY26tefuQIfgTsspgI9KsSpMZsO8F9zREpgxHdUy5
	mO3zmCABHk07vHDLhQ/VK/eo3IivQgk8o9mxrE+1ePZLGd5BSQMAhcU/aAF1oclM6h9osk
	JJQo1LRJeP9DlXu7UQ1ub/PbT3a4tyc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782233158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zvnJVHOKhUJTuaDT+cJ6ybd01RvOsf9xGCdjcPmiwiw=;
	b=DwE1ebFMQKB3ZcUFGX9/I/wM0FzcKFWGfh2Jx0+HYOWYkND0rNzDWzUr4PR5+tsVN/FF4T
	Qut0Yfdt1BE+zXXZ8tQrbWI0/4TGUjlTUMbHWCDRgrXLkwnjvWtxjI2RskE135YokY4X+S
	7k+m0nGZZ7LEPX64lA8IijS6JkUWAlQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WNoNdlTf;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9827601F5;
	Tue, 23 Jun 2026 16:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9781F000E9;
	Tue, 23 Jun 2026 16:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782233157;
	bh=zvnJVHOKhUJTuaDT+cJ6ybd01RvOsf9xGCdjcPmiwiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WNoNdlTf5dtoVDrLtPpaABEWdsNJzXTRo4n42kxANANgtU3aTQQgD59XzJIMaD6NE
	 FMReDXe3YQIdJpTDoIcIapQA6oASlDdnjZ7FaF4nJrISrV8jtwbdoCQWekxPrUbL6B
	 UuqcdbC9i4S+nCAsvKfBuu/IlzE1cnTDEkAKPTctj8notPVtMIIdA9S6k1Ir5JrZEw
	 QVDQ4w3vrwaPbW+6DSbWDqwKQfxS1uL0ua8u0cMQ8ikARTdccgvTkZBwi/p8j+3FuK
	 4LuVes7IHfWWphMl0/EQPlXiTQt3C4n/TSzvtT47KHvQcFW+tCkGmMsP+xmsXmXhjF
	 JjyhRhzIiDfqw==
Date: Tue, 23 Jun 2026 17:45:49 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	liam@infradead.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com, david@kernel.org
Subject: Re: [PATCH 1/2] mm/swap: rename subpage->page in
 folio_dup_swap/folio_put_swap
Message-ID: <ajq4Jwng1yuK5oJ2@lucifer>
References: <20260623125723.2503832-1-dev.jain@arm.com>
 <20260623125723.2503832-2-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623125723.2503832-2-dev.jain@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 833BBC0003
X-Stat-Signature: q6mtpm9io4u6ahihw1q5yr43epyh55hd
X-HE-Tag: 1782233158-926725
X-HE-Meta: U2FsdGVkX19zFHMd+8UbxJpLuLJ/mGBVsqsE7Kk2CUrI4DMweJ65VuOuqIAvanXMmRf+z9GszpYbJLsgkNRcqgiy7igG4Xymlg1Ety+yJYtvhUuJ32g9CH89BiGlUbrduvWQSFhjo6ZJhtEmp0sLoVf6L67EFCn1c93XNLJcnzqYgpu3EvNJwgFING7hYcCrNQFLKA0/YvieYcgei0sfLY1d3KP2MAnov4GuFCIln/vavv4FgHd1K/2Y5Pa2FOufbaYM7ySgBg5zFZRJc9qICtUL+fIAxM0D7oGfLlQktwyrdnF+evkaY/kM/hKRGvaCeKWLLovihEegKh9fvMpUVfJmX/KxaZJrSIiXqGu0GaLuzwQZjY/ngG6R8EMWYP/ABpWdPnUKVt7SBfFcZCYGFuDc6UFui8uI9DoIpJi7jLMi/6/0L0EY5OhZBYVVGDMsJPSkpTcBYI7LDG4du+yGeCfD6h8ajLF3EPo9uZuL37TeLJFzr2Y9WFQFkMsJbZ34J+k8qvL5ua30rulxJNdegD7ynIjk5uHcfH1gqOlmOONYiyYIytx9Y9gtV3hfnvuY9xPLr2K6XcGHgdTTjkUSvxeTgvbsSbYfUsXw+1Zez32/oa+C2FYSikHylEgEEyNj0xmBSzwU45Uy5QhCFPpTCaGhje+NVRQs/NLCzQMPjm2xmRxR472LjeT+4exnZjJJJ8GMiVbA0GTbKxwRzKOx1uQ3qYNHgD1Bgarv1MAdHrBsDpNEz1okKq+yVh3w8wijS05oqtcG4v+/KI5Nmc8hFmSm8sOgCf15I6k9vAeRD3uBRUS44lxrFysbhZ8KI7Xx5Kh9PyvZJ4TXGr/AEFUgtv+9Z3vgyCmzFcyKKXurj5jDss1pKjFU8Xj38DBfprEBg9cSL4O6+b6KFNM3UFqdFakNPk6/b0/aK8gnXvBnYmVBzgAS/QOTSXziBY5yjnuqQqu7/PAn9DU4ntNBWUj
 9gQtVEJ4
 SiD40IBsSSzaIaoip1wAuShpYKWoaGzgc/FzmB/l7A7b5KqiycqoH9qKp2ouThxIDJINUgh2z5BEpjBlsSVsuJBBLcNCX4zxzvb1PuTcjQcvCcCNRwojG2aPvGDjOQ1jdDJvXt1fykhrO/SrGXfMD6ifYoRzEkxw5cYcjeWPx++E/HmmiGwOOTJ3ddfihMUHApRLhi1CjE8KYXRmvXPLLsHIAlMJAOPYxVMgIcw+9vw0Ig1HqImAdw8FARVV/mOoEMJD6GsKh+Ys7P375pMPhS6v77JXXxDZrwxxJiqEmSSfwwvezR13DDytpsps7URT9OeBe/+rygUG+TIyuAx5IyE12PHh6suTkEfd2hXjhabcnYVtX+kX4YM+H62kVCY5soD+l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 12:57:21PM +0000, Dev Jain wrote:
> Folios have pages, not subpages. Rename 'subpage' parameters to 'page'.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

This subpatch of your series LGTM! ;) so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Thanks, Lorenzo

> ---
>  mm/swap.h     |  4 ++--
>  mm/swapfile.c | 16 ++++++++--------
>  2 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index 77d2d14eda421..44ab8e1e595b0 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -230,8 +230,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
>   * folio_put_swap(): does the opposite thing of folio_dup_swap().
>   */
>  int folio_alloc_swap(struct folio *folio);
> -int folio_dup_swap(struct folio *folio, struct page *subpage);
> -void folio_put_swap(struct folio *folio, struct page *subpage);
> +int folio_dup_swap(struct folio *folio, struct page *page);
> +void folio_put_swap(struct folio *folio, struct page *page);
>
>  /* For internal use */
>  extern void __swap_cluster_free_entries(struct swap_info_struct *si,
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 78b49b0658add..a602e5820513a 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1781,7 +1781,7 @@ int folio_alloc_swap(struct folio *folio)
>  /**
>   * folio_dup_swap() - Increase swap count of swap entries of a folio.
>   * @folio: folio with swap entries bounded.
> - * @subpage: if not NULL, only increase the swap count of this subpage.
> + * @page: if not NULL, only increase the swap count of this page.
>   *
>   * Typically called when the folio is unmapped and have its swap entry to
>   * take its place: Swap entries allocated to a folio has count == 0 and pinned
> @@ -1795,7 +1795,7 @@ int folio_alloc_swap(struct folio *folio)
>   * swap_put_entries_direct on its swap entry before this helper returns, or
>   * the swap count may underflow.
>   */
> -int folio_dup_swap(struct folio *folio, struct page *subpage)
> +int folio_dup_swap(struct folio *folio, struct page *page)
>  {
>  	swp_entry_t entry = folio->swap;
>  	unsigned long nr_pages = folio_nr_pages(folio);
> @@ -1803,8 +1803,8 @@ int folio_dup_swap(struct folio *folio, struct page *subpage)
>  	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>  	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
>
> -	if (subpage) {
> -		entry.val += folio_page_idx(folio, subpage);
> +	if (page) {
> +		entry.val += folio_page_idx(folio, page);
>  		nr_pages = 1;
>  	}
>
> @@ -1815,13 +1815,13 @@ int folio_dup_swap(struct folio *folio, struct page *subpage)
>  /**
>   * folio_put_swap() - Decrease swap count of swap entries of a folio.
>   * @folio: folio with swap entries bounded, must be in swap cache and locked.
> - * @subpage: if not NULL, only decrease the swap count of this subpage.
> + * @page: if not NULL, only decrease the swap count of this page.
>   *
>   * This won't free the swap slots even if swap count drops to zero, they are
>   * still pinned by the swap cache. User may call folio_free_swap to free them.
>   * Context: Caller must ensure the folio is locked and in the swap cache.
>   */
> -void folio_put_swap(struct folio *folio, struct page *subpage)
> +void folio_put_swap(struct folio *folio, struct page *page)
>  {
>  	swp_entry_t entry = folio->swap;
>  	unsigned long nr_pages = folio_nr_pages(folio);
> @@ -1830,8 +1830,8 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
>  	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>  	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
>
> -	if (subpage) {
> -		entry.val += folio_page_idx(folio, subpage);
> +	if (page) {
> +		entry.val += folio_page_idx(folio, page);
>  		nr_pages = 1;
>  	}
>
> --
> 2.43.0
>

