Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A85AFCC9DB
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0146B008A; Tue, 10 Mar 2026 04:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930D66B008C; Tue, 10 Mar 2026 04:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808B26B0092; Tue, 10 Mar 2026 04:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5CD6B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:50:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EC0213B185
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:50:01 +0000 (UTC)
X-FDA: 84529531002.19.1831C8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 52484A0011
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:49:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l4zbQ13W;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773132599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w3ELxCrySJbGeecgFV9kiBo6p0YaNpsGYLFMYHtFvdc=;
	b=hk3VesFgq/p/PWPU2py/k+Cg7CeV+ChRP6YhQKbou+pidDmB0ntrl+Rp75bosGM/vnMud6
	YxEDEwYa857PUxkZtbh65QRdFwg9Y05K2GJWb5Q6WaB8Drihro+xU+rj/z1W5XrVwbvrU4
	5WnQ/4Hk62Tw7DNvrjzm9LzDbWvcUt4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l4zbQ13W;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773132599; a=rsa-sha256;
	cv=none;
	b=GQCjptB/2rKdBJ0erLpxNP6gF2+BmQMsxU7fhev5sjqdRsFasYejyUGorE0bHwcvzWCYja
	Q3RJ0xQxFgC8arp9r6y3zmZt5y986kKGvonSL8aQLbSFde8srzKkvQaZk2yYN0M8NdzSgt
	UsXduYFMZ5SVVr2600tzNjbTm5lGFmU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 37B7843D80;
	Tue, 10 Mar 2026 08:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B55C19423;
	Tue, 10 Mar 2026 08:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773132598;
	bh=sc04YWcoFw3HCxCEjTYuLR1BU0ZmF/L7aZlD5dlhEUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l4zbQ13W/8pQO5Mo9qkD4ppFO06c2xPPgGbxXRgf1cpOJbAKtY2/dRzQfFxR0OW5b
	 7hm4DMEzLOLoCpah28N6G/VH1HlmiOjYiHqM5hmeyu9EFB6Kci7m5CMYJ9ntNiwixY
	 7noHA/Wx5Tu99S7QSfRMeEOYulxPS9lRDdci6sUVkMUaE7/mv4cS/HIqIWuWHUk5m6
	 o4bCjVZ+uEpzzi+Nb6ACQma26dxCpVUAijbSHuLAvP4YEBvIMQ8FHL6827rV6PNJmT
	 s66zW0o3wFHiut1KVTosmCcmd8VMXxArz+YACM8fwj9aGZZiOQgL4M8upGn2C6Iybu
	 ARgkWeQI6aoDA==
Date: Tue, 10 Mar 2026 08:49:47 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, david@kernel.org, hughd@google.com, chrisl@kernel.org, 
	kasong@tencent.com, weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com, 
	harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de, 
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org, 
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH 6/9] mm/swapfile: Make folio_dup_swap batchable
Message-ID: <18928285-20c6-4cd9-842f-c0aef91421a2@lucifer.local>
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-7-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310073013.4069309-7-dev.jain@arm.com>
X-Rspamd-Queue-Id: 52484A0011
X-Rspamd-Server: rspam07
X-Stat-Signature: w66t8j1wms94up4188i1kh8o6y9c8wam
X-Rspam-User: 
X-HE-Tag: 1773132599-943392
X-HE-Meta: U2FsdGVkX1+eEc+s89f/xsZLY/1oXeJ9sLJtTqsn4g0sm2IPoEXUyI8j1uDpcZiNMatJzKbVTJxRzXRWMkwiZLeu0Sd1kfWIRAT9dzA1y20et7DB+fPeS26Z3EKFIbaayhjigAVC0Q85w3NDEBk02UQ1DQKYALECRRwz5iF/slVoBdxcYZCeoYIyT1/jSNhTobHCoW1tvhcoIQCPZGxwSuqmjdXRS+xMlU4QNkCBeNar9MB+tCHtRMKrRIpcTUaCPtLv0wZy1j1k7eHKE7y+h6HPQbs1tGIcFDgMnayFr+qbiQH9aXBg2IkEo+4IbZEopENZDYv1LpQTeW3u2aydIofs1K8M/bX/l1wtojoE7BkLHWwa1xgEaoGyJRinj4fFs+hTxXA3M0BZ/gKb8pzTQ8Z7AXWJSeHWi2KF8DRIjGFERinZxoaB1ywfm8GqKF2j3xI7nwP6UV/JSalAg1lSEuEL387WREJQZcF28X4RrbDdzDtV6/MmJqAcsWqrfG/aosp9NkJJW91SzjhudXwUktyZ0TP1j9r5MC7oo3wjd5QaTo4iRRqgx8yN0R4oTPTZZ6MKJXna9hpUUfXJLQ+MWRR3BImxwGbD3iSuM6A7mFdZyXTldvlrZlE+v+qxxJ+i3b4XtSOPGiD2XL3mwpsfXjqImhBYldjUbB9lcvQUmCG6a/+NEylkdwSUGYwKlNeGF+2GAmZSHoqCAV9AHp4hL3LRx1Byqy3vETaoLNb0lW8DdGJpwGfdPJgPWTRWScPft9pHQkHoDkj/gELASa9BfUOJzstQiHMsq5kzMmqLxitSfzwxbyiZVI8YNH913Cf8ZPRr+wylyFmSwn/SG27Vkz3uL61bd3ZMKmpvFedIKFLKlIMHqWRgmt0BBguNENtGTYfmDDULvgDVAChWh3AjZTdKi9Ac3Zwi2lw4kzKcW5pD5z7h6gyvPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 01:00:10PM +0530, Dev Jain wrote:
> Teach folio_dup_swap to handle a batch of consecutive pages. Note that
> folio_dup_swap already can handle a subset of this: nr_pages == 1 and
> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
>
> Currently we have a not-so-nice logic of passing in subpage == NULL if
> we mean to exercise the logic on the entire folio, and subpage != NULL if
> we want to exercise the logic on only that subpage. Remove this
> indirection, and explicitly pass subpage != NULL, and the number of
> pages required.

You've made the interface more confusing? Now we can update multiple subpages
but specify only one? :)

Let's try to actually refactor this into something sane... see below.

>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c     |  2 +-
>  mm/shmem.c    |  2 +-
>  mm/swap.h     |  5 +++--
>  mm/swapfile.c | 12 +++++-------
>  4 files changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index dd638429c963e..f6d5b187cf09b 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2282,7 +2282,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  				goto discard;
>  			}
>
> -			if (folio_dup_swap(folio, subpage) < 0) {
> +			if (folio_dup_swap(folio, subpage, 1) < 0) {
>  				set_pte_at(mm, address, pvmw.pte, pteval);
>  				goto walk_abort;
>  			}
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5e7dcf5bc5d3c..86ee34c9b40b3 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1695,7 +1695,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>  			spin_unlock(&shmem_swaplist_lock);
>  		}
>
> -		folio_dup_swap(folio, NULL);
> +		folio_dup_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));
>  		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
>
>  		BUG_ON(folio_mapped(folio));
> diff --git a/mm/swap.h b/mm/swap.h
> index a77016f2423b9..d9cb58ebbddd1 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -206,7 +206,7 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
>   * folio_put_swap(): does the opposite thing of folio_dup_swap().
>   */
>  int folio_alloc_swap(struct folio *folio);
> -int folio_dup_swap(struct folio *folio, struct page *subpage);
> +int folio_dup_swap(struct folio *folio, struct page *subpage, unsigned int nr_pages);
>  void folio_put_swap(struct folio *folio, struct page *subpage);
>
>  /* For internal use */
> @@ -390,7 +390,8 @@ static inline int folio_alloc_swap(struct folio *folio)
>  	return -EINVAL;
>  }
>
> -static inline int folio_dup_swap(struct folio *folio, struct page *page)
> +static inline int folio_dup_swap(struct folio *folio, struct page *page,
> +				 unsigned int nr_pages)
>  {
>  	return -EINVAL;
>  }
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 915bc93964dbd..eaf61ae6c3817 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1738,7 +1738,8 @@ int folio_alloc_swap(struct folio *folio)
>  /**
>   * folio_dup_swap() - Increase swap count of swap entries of a folio.
>   * @folio: folio with swap entries bounded.
> - * @subpage: if not NULL, only increase the swap count of this subpage.
> + * @subpage: Increase the swap count of this subpage till nr number of
> + * pages forward.

(Obviously also Kairui's point about missing entry in kdoc)

This is REALLY confusing sorry. And this interface is just a horror show.

Before we had subpage == only increase the swap count of the subpage.

Now subpage = the first subpage at which we do that? Please, no.

You just need to rework this interface in general, this is a hack.

Something like:

int __folio_dup_swap(struct folio *folio, unsigned int subpage_start_index,
		     unsigned int nr_subpages)
{
	...
}

...

int folio_dup_swap_subpage(struct folio *folio, struct page *subpage)
{
	return __folio_dup_swap(folio, folio_page_idx(folio, subpage), 1);
}

int folio_dup_swap(struct folio *folio)
{
	return __folio_dup_swap(folio, 0, folio_nr_pages(folio));
}

Or something like that.

We're definitely _not_ keeping the subpage parameter like that and hacking on
batching, PLEASE.

>   *
>   * Typically called when the folio is unmapped and have its swap entry to
>   * take its place: Swap entries allocated to a folio has count == 0 and pinned
> @@ -1752,18 +1753,15 @@ int folio_alloc_swap(struct folio *folio)
>   * swap_put_entries_direct on its swap entry before this helper returns, or
>   * the swap count may underflow.
>   */
> -int folio_dup_swap(struct folio *folio, struct page *subpage)
> +int folio_dup_swap(struct folio *folio, struct page *subpage,
> +		   unsigned int nr_pages)
>  {
>  	swp_entry_t entry = folio->swap;
> -	unsigned long nr_pages = folio_nr_pages(folio);
>
>  	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>  	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
>
> -	if (subpage) {
> -		entry.val += folio_page_idx(folio, subpage);
> -		nr_pages = 1;
> -	}
> +	entry.val += folio_page_idx(folio, subpage);
>
>  	return swap_dup_entries_cluster(swap_entry_to_info(entry),
>  					swp_offset(entry), nr_pages);
> --
> 2.34.1
>

Thanks, Lorenzo

