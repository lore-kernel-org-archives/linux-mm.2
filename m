Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEA80CA0FF9
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 01:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9CA6B002C; Fri, 29 Aug 2025 21:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9616B002D; Fri, 29 Aug 2025 21:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 072236B002F; Fri, 29 Aug 2025 21:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E05246B002C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 21:54:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 61BBF5C07C
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 01:54:58 +0000 (UTC)
X-FDA: 83831755476.18.AA2C133
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4CCEC1C0002
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 01:54:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fZq4tGmc;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756518896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xwDolcfNFPATwT2jvr+wr+vIc6RvUqDEWxGYkjcpRw=;
	b=PuTVDZwN5OE1KXa/38zGcFJ0cgFgk/dr9sUegTrl3uiTqpgHNsSDt8rIuBu2ETF7wTvPfc
	4FlOalJJM1UjQfwJRUhiDBajHKu28esUllhelqQlxw0zTQ50zeCSevOTbkOuPpzqxiSIUk
	jyaF3ONmTeyPemyhO8klxm4og+O0L+c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fZq4tGmc;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756518896; a=rsa-sha256;
	cv=none;
	b=GABNm3HsChrd1//m/Z9KymVF3r7Pxh2Jc6PAuaBgpyY2xT5srQ+Wv4XhX9aVnRI0ti6MjA
	7Utz8hqmWwl+t2+ra+qBFOWiuhsNmIg+0nYsidGZg5GC+AL71F49s3zobsozbLqJdS/CHJ
	tlvRPjnzbW0vpgyMFHEn1KJk6CHFwac=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756518895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3xwDolcfNFPATwT2jvr+wr+vIc6RvUqDEWxGYkjcpRw=;
	b=fZq4tGmcyNgVZrPl/2J6HkJgMED5S7rxzwiGogy8Uu0BXGgKlnNJSsLUqOi4Bh7zGYgP9U
	+stS7J8hxmIwKdJNoq74EuLk+g2zEjgK02/M2U+HG0iMHSXVXZEfB3K2BHi/kOFSZwD8TY
	gDGSCaGKyIUuLb8t1GiaS/nGlz/tcc8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-NZzPzEW9P7Wsne_yRuDArg-1; Fri,
 29 Aug 2025 21:54:51 -0400
X-MC-Unique: NZzPzEW9P7Wsne_yRuDArg-1
X-Mimecast-MFC-AGG-ID: NZzPzEW9P7Wsne_yRuDArg_1756518889
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58AA61800446;
	Sat, 30 Aug 2025 01:54:48 +0000 (UTC)
Received: from localhost (unknown [10.72.112.154])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09FA919560BC;
	Sat, 30 Aug 2025 01:54:45 +0000 (UTC)
Date: Sat, 30 Aug 2025 09:54:41 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] mm, swap: use the swap table for the swap cache and
 switch API
Message-ID: <aLJZ4Q1ioAiUsWv2@MiWiFi-R3L-srv>
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-7-ryncsn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822192023.13477-7-ryncsn@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4CCEC1C0002
X-Stat-Signature: 8wk3rygcrm6ehmyq3k5tr14dcqq38egp
X-Rspam-User: 
X-HE-Tag: 1756518896-730006
X-HE-Meta: U2FsdGVkX1961bCwbhsvncEcOwxdZXVqtMWQnCxnkK4ki0KB6JeVx9KgOXQejQDnq9+UKZOKZF/YXtIXW2tSCGGl6QboO1fFTOCPViLwKk4P9AuDyu0YCC+Q63IbZGL/P7z63ZipjCWMsA3T7SnKpyfa7kPR9pftIbtLnXql8YDxBsKmoyvkupEIVOyOWwNMIqpiPRFe1K7vS9AjNz4zs/PzmBrjwTsf7e1TbXSzQjJdDcD8J4z2bsEYQ1nNAsVnsDadWGQFr2ZoGu3WBwtDH45A6R/jhhr8nsMLS7NqGC4lfkpCECWqwhswqzVy2dmKQ6HWIZJSds6yZv5bdwtEV45oMy2LFpO5UBrV+JknJa4jrFLBedCgpej4PTz9BmyUV2dgRKgM0iQL700q5guiUwJ/erf6aiy0jO03rrhAChj2e49saf6/seB2Lh4w5RudXvg1AYwtNLAl4kRwzeo4tlHbzVcK+9XE2D9Xtyisj0aZB47Uk/HugPBAFZYnkD3Fo/40CpRO0ZOS9lWZWar17Md+yFneOqlS04WPgoKNJjkXts9Tc5ID/sPXPY25xljzV91UsA67XYoEvkkJJwgyqQ3qBuJy3IYCrPt5IbBnPO6Rdp/3E889A8u3iIx+d+kKPoRZP5DCuVFVLKiKlDgF2pkWOEZdHMVrlIMdfRPjOpYJ6wtOfX996M5LvgaTbsvtPwCciQMbqTDqE1tvU+zDDdECkDk9GxavMmU9YQQ/APNG2lt895Hh6FdcMwsw7uCsvnoNspK0mbr8CgZ7S9a3341Zi7EqgxW0uefj8yyqZwlGN21MZjQvoiwuMKjXeBwQvDQCWJV5nzeWDq5IcXfO7PKheZQW5fXuR+ZfKY3rAfp0iaQKwtiMrYMEeVCC2OgIHqURBJwp9OdXTt6gsbF8ha7rP4IqimPPl2kAFXfF2jcwZzBbRhmQ/hZFVrtNOuwjfOSe9uP2KGvTFwDDYa7
 yr+SDdsC
 Jj5CsL7Mdc8+T9Zy/Or9XGY5hHKig6tY1BXv3+i5YOjhRTGP5nBpXTxryMU7eQY28lygMW9hi9ov5qgoRV169dDmJikINBJHtQ+jCDBtg4CvWBsqi+3HLmFiV8h/mHjnHG+AeFktdNviRdKH/o1T4krVT8QXmUgXDHe17R7Sczh7B5VhbbTMIkqTFo9dZHknmA1/BIpHh5XmPzU5IiNWx31m4yfeEWH4hbt5pAJWqZshFLX4aqmx4HHhClSsT4yzXuz2Cn1b7SoSu7qXMExVEfOnJDPnYByoXbviu2v9AVxI8qZCIWTMKaZH1KFs8kQDmbxJ484WutuQwvpXBJXHXDa4gZWt5/43hbWSXwczG//pjhUpksBhW6i+A5cHGkYMRSwe0mpjuylvhrgtaCqf8+xIl23pZ6DEci54fmv44wxXatGH55zbtciPcUj4EZ4npo5cHVZ/CCT9+fw4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/23/25 at 03:20am, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
......snip...
> diff --git a/mm/swap.h b/mm/swap.h
> index 7b3efaa51624..4af42bc2cd72 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
......snip... 
> +/*
> + * All swap cache helpers below require the caller to ensure the swap entries
> + * are valid and pin the device. This can be guaranteed by:
> + * - get_swap_device: this ensures a single entry is valid and increases the
> + *   swap device's refcount.
> + * - Locking a folio in the swap cache: this ensures the folio won't be freed
> + *   from the swap cache, stabilizes its entries, and the swap device.
> + * - Locking anything referencing the swap entry: e.g. locking the PTL that
> + *   protects swap entries in the page table, so they won't be freed.
> + */
> +extern struct folio *swap_cache_get_folio(swp_entry_t entry);
> +extern void *swap_cache_get_shadow(swp_entry_t entry);
> +extern int swap_cache_add_folio(swp_entry_t entry,
> +				struct folio *folio, void **shadow);
> +extern void swap_cache_del_folio(struct folio *folio);
> +/* Below helpers also require the caller to lock the swap cluster. */
> +extern void __swap_cache_del_folio(swp_entry_t entry,
> +				   struct folio *folio, void *shadow);
> +extern void __swap_cache_replace_folio(struct swap_cluster_info *ci,
> +				      swp_entry_t entry, struct folio *old,
> +				      struct folio *new);
> +extern void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents);
> +
>  void show_swap_cache_info(void);
> -void *get_shadow_from_swap_cache(swp_entry_t entry);
> -int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
> -		      gfp_t gfp, void **shadowp);
> -void __delete_from_swap_cache(struct folio *folio,
> -			      swp_entry_t entry, void *shadow);
> -void delete_from_swap_cache(struct folio *folio);
> -void clear_shadow_from_swap_cache(int type, unsigned long begin,
> -				  unsigned long end);
>  void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
> -struct folio *swap_cache_get_folio(swp_entry_t entry);
>  struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		struct vm_area_struct *vma, unsigned long addr,
>  		struct swap_iocb **plug);

I would put this function renaming change to another standalone patch,
then let this key patch focus on swap table introducing.

> @@ -235,6 +283,33 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
>  
>  #else /* CONFIG_SWAP */
>  struct swap_iocb;
> +
> +static inline struct swap_cluster_info *swap_cluster_lock(
> +	struct swap_info_struct *si, pgoff_t offset, bool irq)
> +{
> +	return NULL;
> +}
> +
> +static inline struct swap_cluster_info *swap_cluster_lock_by_folio(
> +		struct folio *folio)
> +{
> +	return NULL;
> +}
> +
> +static inline struct swap_cluster_info *swap_cluster_lock_by_folio_irq(
> +		struct folio *folio)
> +{
> +	return NULL;
> +}
> +
> +static inline void swap_cluster_unlock(struct swap_cluster_info *ci)
> +{
> +}
> +
> +static inline void swap_cluster_unlock_irq(struct swap_cluster_info *ci)
> +{
> +}
> +
>  static inline struct swap_info_struct *swp_info(swp_entry_t entry)
>  {
>  	return NULL;
> @@ -252,11 +327,6 @@ static inline struct address_space *swap_address_space(swp_entry_t entry)
>  	return NULL;
>  }
>  
> -static inline pgoff_t swap_cache_index(swp_entry_t entry)
> -{
> -	return 0;
> -}
> -
>  static inline bool folio_contains_swap(struct folio *folio, swp_entry_t entry)
>  {
>  	return false;
> @@ -298,28 +368,27 @@ static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
>  	return NULL;
>  }
>  
> -static inline void *get_shadow_from_swap_cache(swp_entry_t entry)
> +static inline void *swap_cache_get_shadow(swp_entry_t end)
>  {
>  	return NULL;
>  }
>  
> -static inline int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
> -					gfp_t gfp_mask, void **shadowp)
> +static inline int swap_cache_add_folio(swp_entry_t end, struct folio *folio, void **shadow)
>  {
> -	return -1;
> +	return -EINVAL;
>  }
>  
> -static inline void __delete_from_swap_cache(struct folio *folio,
> -					swp_entry_t entry, void *shadow)
> +static inline void swap_cache_del_folio(struct folio *folio)
>  {
>  }
>  
> -static inline void delete_from_swap_cache(struct folio *folio)
> +static inline void __swap_cache_del_folio(swp_entry_t entry, struct folio *folio, void *shadow)
>  {
>  }
>  
> -static inline void clear_shadow_from_swap_cache(int type, unsigned long begin,
> -				unsigned long end)
> +static inline void __swap_cache_replace_folio(
> +		struct swap_cluster_info *ci, swp_entry_t entry,
> +		struct folio *old, struct folio *new)
>  {
>  }
>  
> @@ -354,7 +423,7 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
>  static inline pgoff_t folio_index(struct folio *folio)
>  {
>  	if (unlikely(folio_test_swapcache(folio)))
> -		return swap_cache_index(folio->swap);
> +		return swp_offset(folio->swap);
>  	return folio->index;
>  }
>  
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 721ff1a5e73a..c0342024b4a8 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -23,6 +23,7 @@
>  #include <linux/huge_mm.h>
>  #include <linux/shmem_fs.h>
>  #include "internal.h"
> +#include "swap_table.h"
>  #include "swap.h"
>  
>  /*
> @@ -36,8 +37,11 @@ static const struct address_space_operations swap_aops = {
>  #endif
>  };
>  
> -struct address_space *swapper_spaces[MAX_SWAPFILES] __read_mostly;
> -static unsigned int nr_swapper_spaces[MAX_SWAPFILES] __read_mostly;
> +/* Set swap_space is read only as swap cache is handled by swap table */
> +struct address_space swap_space __ro_after_init = {
> +	.a_ops = &swap_aops,
> +};
> +
>  static bool enable_vma_readahead __read_mostly = true;
>  
>  #define SWAP_RA_ORDER_CEILING	5
> @@ -69,7 +73,7 @@ void show_swap_cache_info(void)
>  	printk("Total swap = %lukB\n", K(total_swap_pages));
>  }
>  
> -/*
> +/**
>   * swap_cache_get_folio - Lookup a swap entry in the swap cache.
>   *
>   * A found folio will be returned unlocked and with its refcount increased.
> @@ -79,155 +83,179 @@ void show_swap_cache_info(void)
>   */
>  struct folio *swap_cache_get_folio(swp_entry_t entry)
>  {
> -	struct folio *folio = filemap_get_folio(swap_address_space(entry),
> -						swap_cache_index(entry));
> -	if (!IS_ERR(folio))
> -		return folio;
> +	unsigned long swp_tb;
> +	struct folio *folio;
> +
> +	for (;;) {
> +		swp_tb = __swap_table_get(swp_cluster(entry), swp_cluster_offset(entry));
> +		if (!swp_tb_is_folio(swp_tb))
> +			return NULL;
> +		folio = swp_tb_to_folio(swp_tb);
> +		if (folio_try_get(folio))
> +			return folio;
> +	}
> +
>  	return NULL;
>  }
>  
> -void *get_shadow_from_swap_cache(swp_entry_t entry)
> +/**
> + * swap_cache_get_shadow - Lookup a shadow in the swap cache.
> + *
> + * Context: Caller must ensure @entry is valid and pin the swap device.
> + */
> +void *swap_cache_get_shadow(swp_entry_t entry)
>  {
> -	struct address_space *address_space = swap_address_space(entry);
> -	pgoff_t idx = swap_cache_index(entry);
> -	void *shadow;
> +	unsigned long swp_tb;
> +
> +	swp_tb = __swap_table_get(swp_cluster(entry), swp_cluster_offset(entry));
> +	if (swp_tb_is_shadow(swp_tb))
> +		return swp_tb_to_shadow(swp_tb);
>  
> -	shadow = xa_load(&address_space->i_pages, idx);
> -	if (xa_is_value(shadow))
> -		return shadow;
>  	return NULL;
>  }
>  
> -/*
> - * add_to_swap_cache resembles filemap_add_folio on swapper_space,
> - * but sets SwapCache flag and 'swap' instead of mapping and index.
> +/**
> + * swap_cache_add_folio -  add a folio into the swap cache.
> + *
> + * The folio will be used for swapin or swapout of swap entries
> + * starting with @entry. May fail due to race.
> + *
> + * Context: Caller must ensure @entry is valid and pin the swap device.
>   */
> -int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
> -			gfp_t gfp, void **shadowp)
> +int swap_cache_add_folio(swp_entry_t entry, struct folio *folio, void **shadowp)
>  {
> -	struct address_space *address_space = swap_address_space(entry);
> -	pgoff_t idx = swap_cache_index(entry);
> -	XA_STATE_ORDER(xas, &address_space->i_pages, idx, folio_order(folio));
> -	unsigned long i, nr = folio_nr_pages(folio);
> -	void *old;
> -
> -	xas_set_update(&xas, workingset_update_node);
> -
> -	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> -	VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
> -	VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
> +	unsigned long exist;
> +	void *shadow = NULL;
> +	struct swap_cluster_info *ci;
> +	unsigned int ci_start, ci_off, ci_end;
> +	unsigned long nr_pages = folio_nr_pages(folio);
> +
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
> +
> +	ci = swap_cluster_lock(swp_info(entry), swp_offset(entry));
> +	ci_start = swp_cluster_offset(entry);
> +	ci_end = ci_start + nr_pages;
> +	ci_off = ci_start;
> +	do {
> +		exist = __swap_table_get(ci, ci_off);
> +		if (unlikely(swp_tb_is_folio(exist)))
> +			goto fail;
> +		if (swp_tb_is_shadow(exist))
> +			shadow = swp_tb_to_shadow(exist);
> +	} while (++ci_off < ci_end);
> +
> +	ci_off = ci_start;
> +	do {
> +		__swap_table_set_folio(ci, ci_off, folio);
> +	} while (++ci_off < ci_end);
>  
> -	folio_ref_add(folio, nr);
> +	folio_ref_add(folio, nr_pages);
>  	folio_set_swapcache(folio);
>  	folio->swap = entry;
> +	swap_cluster_unlock(ci);
>  
> -	do {
> -		xas_lock_irq(&xas);
> -		xas_create_range(&xas);
> -		if (xas_error(&xas))
> -			goto unlock;
> -		for (i = 0; i < nr; i++) {
> -			VM_BUG_ON_FOLIO(xas.xa_index != idx + i, folio);
> -			if (shadowp) {
> -				old = xas_load(&xas);
> -				if (xa_is_value(old))
> -					*shadowp = old;
> -			}
> -			xas_store(&xas, folio);
> -			xas_next(&xas);
> -		}
> -		address_space->nrpages += nr;
> -		__node_stat_mod_folio(folio, NR_FILE_PAGES, nr);
> -		__lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr);
> -unlock:
> -		xas_unlock_irq(&xas);
> -	} while (xas_nomem(&xas, gfp));
> -
> -	if (!xas_error(&xas))
> -		return 0;
> +	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
> +	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
>  
> -	folio_clear_swapcache(folio);
> -	folio_ref_sub(folio, nr);
> -	return xas_error(&xas);
> +	if (shadowp)
> +		*shadowp = shadow;
> +	return 0;
> +fail:
> +	swap_cluster_unlock(ci);
> +	return -EEXIST;
>  }
>  
>  /*
> - * This must be called only on folios that have
> - * been verified to be in the swap cache.
> + * Caller must ensure the folio is in the swap cache and locked,
> + * also lock the swap cluster.
>   */
> -void __delete_from_swap_cache(struct folio *folio,
> -			swp_entry_t entry, void *shadow)
> +void __swap_cache_del_folio(swp_entry_t entry, struct folio *folio,
> +			    void *shadow)
>  {
> -	struct address_space *address_space = swap_address_space(entry);
> -	int i;
> -	long nr = folio_nr_pages(folio);
> -	pgoff_t idx = swap_cache_index(entry);
> -	XA_STATE(xas, &address_space->i_pages, idx);
> -
> -	xas_set_update(&xas, workingset_update_node);
> -
> -	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> -	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> -	VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
> -
> -	for (i = 0; i < nr; i++) {
> -		void *entry = xas_store(&xas, shadow);
> -		VM_BUG_ON_PAGE(entry != folio, entry);
> -		xas_next(&xas);
> -	}
> +	unsigned long exist;
> +	struct swap_cluster_info *ci;
> +	unsigned int ci_start, ci_off, ci_end;
> +	unsigned long nr_pages = folio_nr_pages(folio);
> +
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
> +
> +	ci = swp_offset_cluster(swp_info(entry), swp_offset(entry));
> +	ci_start = swp_cluster_offset(entry);
> +	ci_end = ci_start + nr_pages;
> +	ci_off = ci_start;
> +	do {
> +		exist = __swap_table_get(ci, ci_off);
> +		VM_WARN_ON_ONCE(swp_tb_to_folio(exist) != folio);
> +		/* If shadow is NULL, we sets an empty shadow */
> +		__swap_table_set_shadow(ci, ci_off, shadow);
> +	} while (++ci_off < ci_end);
> +
>  	folio->swap.val = 0;
>  	folio_clear_swapcache(folio);
> -	address_space->nrpages -= nr;
> -	__node_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
> -	__lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr);
> +	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
> +	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
>  }
>  
>  /*
> - * This must be called only on folios that have
> - * been verified to be in the swap cache and locked.
> - * It will never put the folio into the free list,
> - * the caller has a reference on the folio.
> + * Replace an old folio in the swap cache with a new one. The caller must
> + * hold the cluster lock and set the new folio's entry and flags.
>   */
> -void delete_from_swap_cache(struct folio *folio)
> +void __swap_cache_replace_folio(struct swap_cluster_info *ci, swp_entry_t entry,
> +				struct folio *old, struct folio *new)
> +{
> +	unsigned int ci_off = swp_cluster_offset(entry);
> +	unsigned long nr_pages = folio_nr_pages(new);
> +	unsigned int ci_end = ci_off + nr_pages;
> +
> +	VM_WARN_ON_ONCE(entry.val != new->swap.val);
> +	VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new));
> +	VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcache(new));
> +	do {
> +		WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)) != old);
> +		__swap_table_set_folio(ci, ci_off, new);
> +	} while (++ci_off < ci_end);
> +
> +	/*
> +	 * If the old folio is partially replaced (e.g., splitting a large
> +	 * folio, the old folio is shrunk in place, and new split sub folios
> +	 * are added to cache), ensure the new folio doesn't overlap it.
> +	 */
> +	if (IS_ENABLED(CONFIG_DEBUG_VM) &&
> +	    folio_order(old) != folio_order(new)) {
> +		ci_off = swp_cluster_offset(old->swap);
> +		ci_end = ci_off + folio_nr_pages(old);
> +		while (ci_off++ < ci_end)
> +			WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)) != old);
> +	}
> +}
> +
> +void swap_cache_del_folio(struct folio *folio)
>  {
> +	struct swap_cluster_info *ci;
>  	swp_entry_t entry = folio->swap;
> -	struct address_space *address_space = swap_address_space(entry);
>  
> -	xa_lock_irq(&address_space->i_pages);
> -	__delete_from_swap_cache(folio, entry, NULL);
> -	xa_unlock_irq(&address_space->i_pages);
> +	ci = swap_cluster_lock(swp_info(entry), swp_offset(entry));
> +	__swap_cache_del_folio(entry, folio, NULL);
> +	swap_cluster_unlock(ci);
>  
>  	put_swap_folio(folio, entry);
>  	folio_ref_sub(folio, folio_nr_pages(folio));
>  }
>  
> -void clear_shadow_from_swap_cache(int type, unsigned long begin,
> -				unsigned long end)
> +void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents)
>  {
> -	unsigned long curr = begin;
> -	void *old;
> -
> -	for (;;) {
> -		swp_entry_t entry = swp_entry(type, curr);
> -		unsigned long index = curr & SWAP_ADDRESS_SPACE_MASK;
> -		struct address_space *address_space = swap_address_space(entry);
> -		XA_STATE(xas, &address_space->i_pages, index);
> -
> -		xas_set_update(&xas, workingset_update_node);
> -
> -		xa_lock_irq(&address_space->i_pages);
> -		xas_for_each(&xas, old, min(index + (end - curr), SWAP_ADDRESS_SPACE_PAGES)) {
> -			if (!xa_is_value(old))
> -				continue;
> -			xas_store(&xas, NULL);
> -		}
> -		xa_unlock_irq(&address_space->i_pages);
> +	struct swap_cluster_info *ci = swp_cluster(entry);
> +	unsigned int ci_off = swp_cluster_offset(entry), ci_end;
>  
> -		/* search the next swapcache until we meet end */
> -		curr = ALIGN((curr + 1), SWAP_ADDRESS_SPACE_PAGES);
> -		if (curr > end)
> -			break;
> -	}
> +	ci_end = ci_off + nr_ents;
> +	do {
> +		WARN_ON_ONCE(swp_tb_is_folio(__swap_table_get(ci, ci_off)));
> +		__swap_table_init_null(ci, ci_off);
> +	} while (++ci_off < ci_end);
>  }
>  
>  /*
> @@ -292,8 +320,7 @@ static inline bool swap_use_vma_readahead(void)
>  /*
>   * Update the readahead statistics of a vma or globally.
>   */
> -void swap_update_readahead(struct folio *folio,
> -			   struct vm_area_struct *vma,
> +void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
>  			   unsigned long addr)
>  {
>  	bool readahead, vma_ra = swap_use_vma_readahead();
> @@ -387,7 +414,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  			goto put_and_return;
>  
>  		/*
> -		 * We might race against __delete_from_swap_cache(), and
> +		 * We might race against __swap_cache_del_folio(), and
>  		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
>  		 * has not yet been cleared.  Or race against another
>  		 * __read_swap_cache_async(), which has set SWAP_HAS_CACHE
> @@ -405,8 +432,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  	if (mem_cgroup_swapin_charge_folio(new_folio, NULL, gfp_mask, entry))
>  		goto fail_unlock;
>  
> -	/* May fail (-ENOMEM) if XArray node allocation failed. */
> -	if (add_to_swap_cache(new_folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
> +	if (swap_cache_add_folio(entry, new_folio, &shadow))
>  		goto fail_unlock;
>  
>  	memcg1_swapin(entry, 1);
> @@ -572,11 +598,11 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
>  		end_offset = si->max - 1;
>  
>  	blk_start_plug(&plug);
> -	for (offset = start_offset; offset <= end_offset ; offset++) {
> +	for (offset = start_offset; offset <= end_offset; offset++) {
>  		/* Ok, do the async read-ahead now */
>  		folio = __read_swap_cache_async(
> -				swp_entry(swp_type(entry), offset),
> -				gfp_mask, mpol, ilx, &page_allocated, false);
> +				swp_entry(swp_type(entry), offset), gfp_mask, mpol, ilx,
> +				&page_allocated, false);
>  		if (!folio)
>  			continue;
>  		if (page_allocated) {
> @@ -600,41 +626,6 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
>  	return folio;
>  }
>  
> -int init_swap_address_space(unsigned int type, unsigned long nr_pages)
> -{
> -	struct address_space *spaces, *space;
> -	unsigned int i, nr;
> -
> -	nr = DIV_ROUND_UP(nr_pages, SWAP_ADDRESS_SPACE_PAGES);
> -	spaces = kvcalloc(nr, sizeof(struct address_space), GFP_KERNEL);
> -	if (!spaces)
> -		return -ENOMEM;
> -	for (i = 0; i < nr; i++) {
> -		space = spaces + i;
> -		xa_init_flags(&space->i_pages, XA_FLAGS_LOCK_IRQ);
> -		atomic_set(&space->i_mmap_writable, 0);
> -		space->a_ops = &swap_aops;
> -		/* swap cache doesn't use writeback related tags */
> -		mapping_set_no_writeback_tags(space);
> -	}
> -	nr_swapper_spaces[type] = nr;
> -	swapper_spaces[type] = spaces;
> -
> -	return 0;
> -}
> -
> -void exit_swap_address_space(unsigned int type)
> -{
> -	int i;
> -	struct address_space *spaces = swapper_spaces[type];
> -
> -	for (i = 0; i < nr_swapper_spaces[type]; i++)
> -		VM_WARN_ON_ONCE(!mapping_empty(&spaces[i]));
> -	kvfree(spaces);
> -	nr_swapper_spaces[type] = 0;
> -	swapper_spaces[type] = NULL;
> -}
> -
>  static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
>  			   unsigned long *end)
>  {
> @@ -807,7 +798,7 @@ static const struct attribute_group swap_attr_group = {
>  	.attrs = swap_attrs,
>  };
>  
> -static int __init swap_init_sysfs(void)
> +static int __init swap_init(void)
>  {
>  	int err;
>  	struct kobject *swap_kobj;
> @@ -822,11 +813,13 @@ static int __init swap_init_sysfs(void)
>  		pr_err("failed to register swap group\n");
>  		goto delete_obj;
>  	}
> +	/* swap_space is set RO after init, so do it here before init ends. */
> +	mapping_set_no_writeback_tags(&swap_space);
>  	return 0;
>  
>  delete_obj:
>  	kobject_put(swap_kobj);
>  	return err;
>  }
> -subsys_initcall(swap_init_sysfs);
> +subsys_initcall(swap_init);
>  #endif
> diff --git a/mm/swap_table.h b/mm/swap_table.h
> new file mode 100644
> index 000000000000..ed9676547071
> --- /dev/null
> +++ b/mm/swap_table.h
> @@ -0,0 +1,106 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _MM_SWAP_TABLE_H
> +#define _MM_SWAP_TABLE_H
> +
> +#include "swap.h"
> +
> +/*
> + * A swap table entry represents the status of a swap slot on a swap
> + * (physical or virtual) device. The swap table in each cluster is a
> + * 1:1 map of the swap slots in this cluster.
> + *
> + * Each swap table entry could be a pointer (folio), a XA_VALUE
> + * (shadow), or NULL.
> + */
> +
> +/*
> + * Helpers for casting one type of info into a swap table entry.
> + */
> +static inline unsigned long null_to_swp_tb(void)
> +{
> +	BUILD_BUG_ON(sizeof(unsigned long) != sizeof(atomic_long_t));
> +	return 0;
> +}
> +
> +static inline unsigned long folio_to_swp_tb(struct folio *folio)
> +{
> +	BUILD_BUG_ON(sizeof(unsigned long) != sizeof(void *));
> +	return (unsigned long)folio;
> +}
> +
> +static inline unsigned long shadow_swp_to_tb(void *shadow)
> +{
> +	BUILD_BUG_ON((BITS_PER_XA_VALUE + 1) !=
> +		     BITS_PER_BYTE * sizeof(unsigned long));
> +	VM_WARN_ON_ONCE(shadow && !xa_is_value(shadow));
> +	return (unsigned long)shadow;
> +}
> +
> +/*
> + * Helpers for swap table entry type checking.
> + */
> +static inline bool swp_tb_is_null(unsigned long swp_tb)
> +{
> +	return !swp_tb;
> +}
> +
> +static inline bool swp_tb_is_folio(unsigned long swp_tb)
> +{
> +	return !xa_is_value((void *)swp_tb) && !swp_tb_is_null(swp_tb);
> +}
> +
> +static inline bool swp_tb_is_shadow(unsigned long swp_tb)
> +{
> +	return xa_is_value((void *)swp_tb);
> +}
> +
> +/*
> + * Helpers for retrieving info from swap table.
> + */
> +static inline struct folio *swp_tb_to_folio(unsigned long swp_tb)
> +{
> +	VM_WARN_ON(!swp_tb_is_folio(swp_tb));
> +	return (void *)swp_tb;
> +}
> +
> +static inline void *swp_tb_to_shadow(unsigned long swp_tb)
> +{
> +	VM_WARN_ON(!swp_tb_is_shadow(swp_tb));
> +	return (void *)swp_tb;
> +}
> +
> +/*
> + * Helpers for accessing or modifying the swap table of a cluster,
> + * the swap cluster must be locked.
> + */
> +static inline void __swap_table_set(struct swap_cluster_info *ci,
> +				    unsigned int off, unsigned long swp_tb)
> +{
> +	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
> +	atomic_long_set(&ci->table[off], swp_tb);
> +}
> +
> +static inline unsigned long __swap_table_get(struct swap_cluster_info *ci,
> +					     unsigned int off)
> +{
> +	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
> +	return atomic_long_read(&ci->table[off]);
> +}
> +
> +static inline void __swap_table_set_folio(struct swap_cluster_info *ci,
> +					  unsigned int off, struct folio *folio)
> +{
> +	__swap_table_set(ci, off, folio_to_swp_tb(folio));
> +}
> +
> +static inline void __swap_table_set_shadow(struct swap_cluster_info *ci,
> +					   unsigned int off, void *shadow)
> +{
> +	__swap_table_set(ci, off, shadow_swp_to_tb(shadow));
> +}
> +
> +static inline void __swap_table_init_null(struct swap_cluster_info *ci, unsigned int off)
> +{
> +	__swap_table_set(ci, off, null_to_swp_tb());
> +}
> +#endif
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 85606fbebf0f..df68b5e242a6 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -46,6 +46,7 @@
>  #include <asm/tlbflush.h>
>  #include <linux/swapops.h>
>  #include <linux/swap_cgroup.h>
> +#include "swap_table.h"
>  #include "internal.h"
>  #include "swap.h"
>  
> @@ -268,7 +269,7 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
>  	if (!need_reclaim)
>  		goto out_unlock;
>  
> -	delete_from_swap_cache(folio);
> +	swap_cache_del_folio(folio);
>  	folio_set_dirty(folio);
>  	ret = nr_pages;
>  out_unlock:
> @@ -422,6 +423,34 @@ static inline unsigned int cluster_offset(struct swap_info_struct *si,
>  	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
>  }
>  
> +static int swap_table_alloc_table(struct swap_cluster_info *ci)
> +{
> +	WARN_ON(ci->table);
> +	ci->table = kzalloc(sizeof(unsigned long) * SWAPFILE_CLUSTER, GFP_KERNEL);
> +	if (!ci->table)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +static void swap_cluster_free_table(struct swap_cluster_info *ci)
> +{
> +	unsigned int ci_off;
> +	unsigned long swp_tb;
> +
> +	if (!ci->table)
> +		return;
> +
> +	for (ci_off = 0; ci_off < SWAPFILE_CLUSTER; ci_off++) {
> +		swp_tb = __swap_table_get(ci, ci_off);
> +		if (!swp_tb_is_null(swp_tb))
> +			pr_err_once("swap: unclean swap space on swapoff: 0x%lx",
> +				    swp_tb);
> +	}
> +
> +	kfree(ci->table);
> +	ci->table = NULL;
> +}
> +
>  static void move_cluster(struct swap_info_struct *si,
>  			 struct swap_cluster_info *ci, struct list_head *list,
>  			 enum swap_cluster_flags new_flags)
> @@ -704,6 +733,25 @@ static bool cluster_scan_range(struct swap_info_struct *si,
>  	return true;
>  }
>  
> +/*
> + * Currently, the swap table is not used for count tracking,
> + * just do a sanity check to ensure nothing went wrong.
> + */
> +static void cluster_table_check(struct swap_cluster_info *ci,
> +				unsigned int start, unsigned int nr)
> +{
> +	unsigned int ci_off = start % SWAPFILE_CLUSTER;
> +	unsigned int ci_end = ci_off + nr;
> +	unsigned long swp_tb;
> +
> +	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
> +		do {
> +			swp_tb = __swap_table_get(ci, ci_off);
> +			VM_WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
> +		} while (++ci_off < ci_end);
> +	}
> +}
> +
>  static bool cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster_info *ci,
>  				unsigned int start, unsigned char usage,
>  				unsigned int order)
> @@ -723,6 +771,7 @@ static bool cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster
>  		ci->order = order;
>  
>  	memset(si->swap_map + start, usage, nr_pages);
> +	cluster_table_check(ci, start, nr_pages);
>  	swap_range_alloc(si, nr_pages);
>  	ci->count += nr_pages;
>  
> @@ -1100,8 +1149,7 @@ static void swap_range_alloc(struct swap_info_struct *si,
>  static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
>  			    unsigned int nr_entries)
>  {
> -	unsigned long begin = offset;
> -	unsigned long end = offset + nr_entries - 1;
> +	unsigned long start = offset, end = offset + nr_entries - 1;

And this kind of clean up or code style adjustment, adding them here will
distract people from focusing on swap table introducing.

>  	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
>  	unsigned int i;
>  
> @@ -1125,7 +1173,7 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
>  			swap_slot_free_notify(si->bdev, offset);
>  		offset++;
>  	}
> -	clear_shadow_from_swap_cache(si->type, begin, end);
> +	__swap_cache_clear_shadow(swp_entry(si->type, start), nr_entries);
>  
>  	/*
>  	 * Make sure that try_to_unuse() observes si->inuse_pages reaching 0
> @@ -1282,15 +1330,7 @@ int folio_alloc_swap(struct folio *folio, gfp_t gfp)
>  	if (!entry.val)
>  		return -ENOMEM;
>  
> -	/*
> -	 * XArray node allocations from PF_MEMALLOC contexts could
> -	 * completely exhaust the page allocator. __GFP_NOMEMALLOC
> -	 * stops emergency reserves from being allocated.
> -	 *
> -	 * TODO: this could cause a theoretical memory reclaim
> -	 * deadlock in the swap out path.
> -	 */
> -	if (add_to_swap_cache(folio, entry, gfp | __GFP_NOMEMALLOC, NULL))
> +	if (swap_cache_add_folio(entry, folio, NULL))
>  		goto out_free;
>  
>  	return 0;
> @@ -1557,6 +1597,7 @@ static void swap_entries_free(struct swap_info_struct *si,
>  
>  	mem_cgroup_uncharge_swap(entry, nr_pages);
>  	swap_range_free(si, offset, nr_pages);
> +	cluster_table_check(ci, offset, nr_pages);
>  
>  	if (!ci->count)
>  		free_cluster(si, ci);
> @@ -1760,7 +1801,7 @@ bool folio_free_swap(struct folio *folio)
>  	if (folio_swapped(folio))
>  		return false;
>  
> -	delete_from_swap_cache(folio);
> +	swap_cache_del_folio(folio);
>  	folio_set_dirty(folio);
>  	return true;
>  }
> @@ -2634,6 +2675,18 @@ static void wait_for_allocation(struct swap_info_struct *si)
>  	}
>  }
>  
> +static void free_cluster_info(struct swap_cluster_info *cluster_info,
> +			      unsigned long maxpages)
> +{
> +	int i, nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
> +
> +	if (!cluster_info)
> +		return;
> +	for (i = 0; i < nr_clusters; i++)
> +		swap_cluster_free_table(&cluster_info[i]);
> +	kvfree(cluster_info);
> +}
> +
>  /*
>   * Called after swap device's reference count is dead, so
>   * neither scan nor allocation will use it.
> @@ -2768,12 +2821,13 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  
>  	swap_file = p->swap_file;
>  	p->swap_file = NULL;
> -	p->max = 0;
>  	swap_map = p->swap_map;
>  	p->swap_map = NULL;
>  	zeromap = p->zeromap;
>  	p->zeromap = NULL;
>  	cluster_info = p->cluster_info;
> +	free_cluster_info(cluster_info, p->max);
> +	p->max = 0;
>  	p->cluster_info = NULL;
>  	spin_unlock(&p->lock);
>  	spin_unlock(&swap_lock);
> @@ -2784,10 +2838,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  	p->global_cluster = NULL;
>  	vfree(swap_map);
>  	kvfree(zeromap);
> -	kvfree(cluster_info);
>  	/* Destroy swap account information */
>  	swap_cgroup_swapoff(p->type);
> -	exit_swap_address_space(p->type);
>  
>  	inode = mapping->host;
>  
> @@ -3171,8 +3223,11 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
>  	if (!cluster_info)
>  		goto err;
>  
> -	for (i = 0; i < nr_clusters; i++)
> +	for (i = 0; i < nr_clusters; i++) {
>  		spin_lock_init(&cluster_info[i].lock);
> +		if (swap_table_alloc_table(&cluster_info[i]))
> +			goto err_free;
> +	}
>  
>  	if (!(si->flags & SWP_SOLIDSTATE)) {
>  		si->global_cluster = kmalloc(sizeof(*si->global_cluster),
> @@ -3233,9 +3288,8 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
>  	}
>  
>  	return cluster_info;
> -
>  err_free:
> -	kvfree(cluster_info);
> +	free_cluster_info(cluster_info, maxpages);
>  err:
>  	return ERR_PTR(err);
>  }
> @@ -3429,13 +3483,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  		}
>  	}
>  
> -	error = init_swap_address_space(si->type, maxpages);
> -	if (error)
> -		goto bad_swap_unlock_inode;
> -
>  	error = zswap_swapon(si->type, maxpages);
>  	if (error)
> -		goto free_swap_address_space;
> +		goto bad_swap_unlock_inode;
>  
>  	/*
>  	 * Flush any pending IO and dirty mappings before we start using this
> @@ -3470,8 +3520,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  	goto out;
>  free_swap_zswap:
>  	zswap_swapoff(si->type);
> -free_swap_address_space:
> -	exit_swap_address_space(si->type);
>  bad_swap_unlock_inode:
>  	inode_unlock(inode);
>  bad_swap:
> @@ -3486,7 +3534,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  	spin_unlock(&swap_lock);
>  	vfree(swap_map);
>  	kvfree(zeromap);
> -	kvfree(cluster_info);
> +	if (cluster_info)
> +		free_cluster_info(cluster_info, maxpages);
>  	if (inced_nr_rotate_swap)
>  		atomic_dec(&nr_rotate_swap);
>  	if (swap_file)
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b0afd7f41a22..1ed3cf9dac4e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -730,13 +730,18 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
>  {
>  	int refcount;
>  	void *shadow = NULL;
> +	struct swap_cluster_info *ci;
>  
>  	BUG_ON(!folio_test_locked(folio));
>  	BUG_ON(mapping != folio_mapping(folio));
>  
> -	if (!folio_test_swapcache(folio))
> +	if (folio_test_swapcache(folio)) {
> +		ci = swap_cluster_lock_by_folio_irq(folio);
> +	} else {
>  		spin_lock(&mapping->host->i_lock);
> -	xa_lock_irq(&mapping->i_pages);
> +		xa_lock_irq(&mapping->i_pages);
> +	}
> +
>  	/*
>  	 * The non racy check for a busy folio.
>  	 *
> @@ -776,9 +781,9 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
>  
>  		if (reclaimed && !mapping_exiting(mapping))
>  			shadow = workingset_eviction(folio, target_memcg);
> -		__delete_from_swap_cache(folio, swap, shadow);
> +		__swap_cache_del_folio(swap, folio, shadow);
>  		memcg1_swapout(folio, swap);
> -		xa_unlock_irq(&mapping->i_pages);
> +		swap_cluster_unlock_irq(ci);
>  		put_swap_folio(folio, swap);
>  	} else {
>  		void (*free_folio)(struct folio *);
> @@ -816,9 +821,12 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
>  	return 1;
>  
>  cannot_free:
> -	xa_unlock_irq(&mapping->i_pages);
> -	if (!folio_test_swapcache(folio))
> +	if (folio_test_swapcache(folio)) {
> +		swap_cluster_unlock_irq(ci);
> +	} else {
> +		xa_unlock_irq(&mapping->i_pages);
>  		spin_unlock(&mapping->host->i_lock);
> +	}
>  	return 0;
>  }
>  
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ee443b317ac7..c869859eec77 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1166,7 +1166,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  
>  out:
>  	if (ret && ret != -EEXIST) {
> -		delete_from_swap_cache(folio);
> +		swap_cache_del_folio(folio);
>  		folio_unlock(folio);
>  	}
>  	folio_put(folio);
> -- 
> 2.51.0
> 


