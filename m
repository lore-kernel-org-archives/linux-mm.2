Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15970C55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2169E6B0088; Thu, 30 Jul 2026 09:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE8A6B008A; Thu, 30 Jul 2026 09:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104136B0093; Thu, 30 Jul 2026 09:04:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDECE6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:04:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 805F7120157
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:04:31 +0000 (UTC)
X-FDA: 85045461942.26.BDCDF68
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9FAEAA000D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:04:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NJgyOlF2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785416669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DgTI17Npaj7RxXtKiWxg+nzYCLrtjUc+y7I6yBRco+E=;
	b=3OFQ5Mv7CJhvib7NoJNP63oisTFQt6cdUKpV68Y0jTwZXI9IdtlWdm05sn7RaWnuGWEdMP
	Y4eI9eg1oLb3epkpl7wdkpNEqvpPVa7FIsWAf2HG1Owh2o4/o5cLs88UOh+5C+fq5zqezs
	q29BAE5ILMMYOLqZqyOt3Dt7dtDoVf0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NJgyOlF2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785416669;
	b=m4+myGkEuzXYXl4F3fXtJ8ox0hKepSwEYSaBjDNdqUEx1kX0AxM3hHzk0tIptCJKLW2keZ
	C+CmJns9l+q1RkSZYPsli+HyUlJauPSUOAQqHCSHhkPzJvw6FGr3ENNWccZ7mBGM6Tjnec
	YF9Bt+1kWYGz5nyfM6wLS173Tb6tAUA=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1677c91969so246100666b.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785416668; x=1786021468; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DgTI17Npaj7RxXtKiWxg+nzYCLrtjUc+y7I6yBRco+E=;
        b=NJgyOlF2Aa+sgoWOWtVPReBIbjKwJmfsD10k3vgiW4Lr2XAFn4BvUepel9wsvq4SDU
         AbBM474+vE2w8qpaeiDNKOG0e0atUOFbF/8EeES/aHeSKDuXQso3mD+ecXoF89QRR6cq
         FgponXcNfgNFGJ6uCjxVBJ3gSnSpNd3Qpd75G6fc+BnRcpzJEKpaHm5lAAQYr49XeVrh
         1Z43MbT7TSkbFehKsTRTPTVK8g9l6MO5SYtKqRZDSJIQNYo+W5iiLaNbWJeZRuhEiOW2
         tvnuzPNWIg8Q/NxP6j2Kpkvas3DA6Kuwr0ocS5Zkpyf3Z/zrc5MpoHjDMQ3moE3pKRPv
         d4yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785416668; x=1786021468;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DgTI17Npaj7RxXtKiWxg+nzYCLrtjUc+y7I6yBRco+E=;
        b=Kw2ro5DZ3rJvsEfKUQ3/r885nVyOCV/LIg6KiZLsDymaCwi0671MMfd66fwxBzLApY
         oeN/tOtIq47rBUrCh3jbtnaK+UwSepInSLJM4+DpC3+ClzXw8SpNWU11U6fEkwUoqZ6R
         m/GwtJPXGUA8Y/Oa7348DwI5tm/t+JY85e4Z8MsUKUK8Bmd6vWLyj6DdO3YkgzPiukgq
         xtlc8C6t9oUQFWOpL/KOqFYlUpoYdqFuIdXeduFzvnqR/rpODeMFH+UHaWalsdCWVBh8
         VD9jPMQ6dvYbDJzqJgbBS2NATbA5PzpQ5zVvSFHAB7k0ZIF1P1+uG++zKGm4tRwmH9H5
         S+Dg==
X-Gm-Message-State: AOJu0YzzzEpA2V9O9D1HB0/auUO5jYaoA6ZTnkF89C7U0Mb2taM1mjqz
	a1SuvnwL3gnJvfcxmw6Mlw6vSg6P6MKLctxW7Sx3loWvrddtsCUQMZ0T
X-Gm-Gg: AR+sD13psh0iBMhcol712yuE90P1Rcr+HdlMCPCIfkS4MqHoTLQH9qF1Pt3BjM29z7+
	oi/6W1b2ia6+64JJBoA8czutrQoUMaDrFCE2x3/5tctNqlfU4Qh/Sh2iBKPclLo3eXYQYt+EvIV
	b5YSZbw4rtTkHNJtxuU7PyAO/xWBmbs1wDAdzV2jQ2sjeqDdd9pN4gZ3Q05DzL5y+v5m5Kwj4DA
	jgWSY6wyHp3Zwd1XtYo6sX8f5umrKaj30C+beQHEbZ6gTOQRHkjTSYTfmtE2xuXvOZd1l2pzxYu
	hQbdSr+qRo4G+jdOeOmf8l8G8OsQLQF5ef0Q2Z2mkLoqerrS2HRzpSPh1q8J7nrSNz7byoyaUCn
	oCYS6wsYfOL0sWwHMt9DhpAJhS7mx7lTqgLHK84eUuo9ohE91OBn21eLXtpzRA85+sgsGXyNnu4
	0SAShwTddShgZimRgu8exvY+s4tg==
X-Received: by 2002:a17:907:6d1a:b0:c16:581a:2a51 with SMTP id a640c23a62f3a-c1fa53ac343mr131168166b.12.1785416667822;
        Thu, 30 Jul 2026 06:04:27 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fa85dac0csm64655066b.28.2026.07.30.06.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 06:04:26 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 30 Jul 2026 15:04:24 +0200
To: Artem Lytkin <iprintercanon@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, urezki@gmail.com,
	shivamkalra98@zohomail.in, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: make vm_struct.nr_pages an unsigned long
Message-ID: <amtL2Md-vl_gt-pV@milan>
References: <20260729175708.7074-1-iprintercanon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729175708.7074-1-iprintercanon@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9FAEAA000D
X-Rspam-User: 
X-Stat-Signature: 6ri1tgxtrjd7f1tsc6aembozzho63and
X-HE-Tag: 1785416669-754880
X-HE-Meta: U2FsdGVkX1+lSeGV0a9jOP9jMDL3C22XYPp4UaUarOLsSU9k6FVrQhIyu3EdxvhQf1uAr6p87TQh1/odqC0Evd0d6wTfKa7Smg/39XTv9DjcgfLKPNR350mAJYmfOX3cm5OMfzymiaw6h4C8De++xf+DFOe2LM8dfv1cUmewP61y9Zr9ugCqMdhY2lhqST0tKXercvCu9O9Ft/KfHgWscfxknS1HySZ93jVddvhFq8z4mS4HS06jvkeOGbt+6MX/mrnTU4Ua+ji9hB+zd0kSUm/16q6lhw6ggwNGp4Dwk7gUb9Z/NthwvYLg3zG64//TRhs2yXkEIPm63PA9wj1sq6ZqDY4TiNHqnPcJUl/L+9LQ096wAdAzlxWhQFHWO8ONIdz09e2iB9SkxqSMk78VE4I2jfzxhkmY2CmkM3FOMwsxkB9rqQH7NhHQ2baJy8dZhmljUYWUdLmOliNXJRUo8ybOj/S0AAuMnPfXDiZoFbcrlkIN55qjefyKA7J50D7P2yJ6NafbgPvG3ngBw07X3xx3FskzaJA6P81OUH39Lp5PcHitF46nfdYT5AuHsiyaotMMJIHd65L5g9+gIloD6/YHpTashu40L9FdigMROxQAvgGBBwRDSMSU2cTaM/3tTd2aEY4B8lRqY8txaVxk2CcM1kO1eV83Q0sam4MvVIUwcKpJVRKdREFHEm0WXnb9mKh6JO7d2DM8kTaHFn8JCjRHzyVHcKKhQeZJmSmPaXFbGwl/9pdP7m5E7yrSsG1sRIIsK0EEVu//PQAhy2dy6yZem6HzMuqjvJkJ3WMXatoBcuR17jtFp7Dn7fvOeJtpxBAHJUmNrK8mmUw8wxQkDIC5vYpaC6lsMUA3i/ylEVwCLRUaJ8ANZYPYmTgNLXzp2Upt0A9pD1poNqEHaf2Dmk5MNoRiJ+vbHBIEmlJT2Pq92oRpa+GVKHfEZ9WqK+AEHP0n0Ezucp9uZPS9dLW
 ZBY9JizJ
 DD0J3phpUafreGA6HYz9vB7LQ5NcOf2/jQzDK2sm6GhV/wtTlF9a/vDDW9RN5LAZfgjnHtnPUF5ye0enbc/ChnuC2TKOI9plTJN7gDQRDOEXLliWPPPuUivhIASbd4Y7JQgpivPsI6m54KDO0UHyADUMPe0JG+onBa36UgAiJoxdkfdLAhuINsrf8MiknDBhSagas+fkYMqDH6TAMXDrZMv/s/I4IKf8Pa008EsVdbGaviE7p78IXg0CEQrnVKzdupJxT9vaIfE2Li3Rnk/VyiWmY0OlN2udrnzOabzR/YuVQzQlnv0+FnUqb6Gsp1DW+IeminavylDX+c5QBKJ1OUco8tUi85UpmGaEY5ax7463TKU67U3rajUQ4U0oa4xjYkCXXpqOZmVuVXr2D7LAMiS/dUSX+QPtMNkfRgiUC6RE+wTFqvCzRIYrHCXO6XzgesZIFnBcdjz2m0Tl2kkqWseZiZsEZKQkGhSDxLTbmamoZmgnXPatmHrCQ3xnzgJ41x7PbA2MVQ7aWNnR5t1enB5opLqXQB0iJrGX+a5x+eSevKIPPl+xLUp2hMD3PMrMxKP5j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 08:57:08PM +0300, Artem Lytkin wrote:
> A vmalloc area can hold more than 2^32 pages, but the page counts
> tracking it are 32 bit. That has produced the same truncation bug twice
> already, once in vread_iter() and once in the vrealloc() grow-in-place
> check, and it keeps the casts that hide it scattered around the file.
> 
> Widen the field and everything that feeds or consumes it, so the byte
> counts derived from it are computed in 64 bit arithmetic without a cast
> at each site:
> 
>   - vm_area_alloc_pages() takes and returns a page count, and the result
>     is stored into nr_pages, so its parameter, return type and the
>     nr_allocated and nr_remaining accumulators widen too. The 100 page
>     cap on a bulk request stays narrow, only its literal becomes 100UL.
> 
>   - nr_small_pages in __vmalloc_area_node() is derived from a 64 bit
>     size and compared against nr_pages, so it widens as well. Before
>     this the store truncated for a size of 16 TiB or more, which sized
>     area->pages from the wrapped count while __vmap_pages_range() still
>     walked the full size. The cast on array_size next to it was already
>     redundant and goes away with it.
> 
>   - new_nr_pages and old_nr_pages in vrealloc_node_align_noprof() widen,
>     which drops the four casts on them, and the casts added by the two
>     preceding patches in vrealloc_node_align_noprof() and vread_iter()
>     are no longer needed either.
> 
>   - vm_area_free_pages() takes a page index range.
> 
> Three loop counters that index area->pages were plain int and would have
> overflowed at 2^31 pages: in set_area_direct_map(), in vm_reset_perms()
> and in the bulk allocation loop, where the index is seeded from
> nr_allocated. They become unsigned long.
> 
> Printing needed fixing in two places. vmalloc_dump_obj() used %u, and
> vmalloc_info_show() printed the unsigned field with %d, which would have
> shown a negative page count for an area of 8 TiB or more.
> show_numa_info() used a single unsigned int as both the page index and
> the node id, so the page loop gets its own unsigned long counter.
> 
> The page table walkers are not covered here. vmap_pages_pte_range() and
> the levels above it carry the page cursor as int *nr, so a mapping is
> still capped independently of the counters this patch widens. Widening
> that cursor touches the whole walker and is separate work.
> 
> Nothing outside mm/vmalloc.c needs a change to build or to behave as
> before. Those users either index the pages array or multiply the count
> by PAGE_SIZE, which is unsigned long already. kexec_handover stores the
> count into a 32 bit field of its own ABI, which caps that interface
> exactly where it did before.
> 
> On x86-64 this leaves sizeof(struct vm_struct) at 72 bytes when
> CONFIG_HAVE_ARCH_HUGE_VMALLOC=n, since the existing padding before
> phys_addr absorbs the change, and takes it to 80 when the config is
> enabled. Both sizes come from the same kmalloc-96 bucket that
> __get_vm_area_node() allocates from, so the footprint per area does not
> change either way.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Artem Lytkin <iprintercanon@gmail.com>
> ---
>  include/linux/vmalloc.h |  2 +-
>  mm/vmalloc.c            | 62 ++++++++++++++++++++---------------------
>  2 files changed, 31 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index d87dc7f77f4e8..a39c20c77efcd 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -62,7 +62,7 @@ struct vm_struct {
>  #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
>  	unsigned int		page_order;
>  #endif
> -	unsigned int		nr_pages;
> +	unsigned long		nr_pages;
>  	phys_addr_t		phys_addr;
>  	const void		*caller;
>  	unsigned long		requested_size;
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index baf7e396e3fc7..efd5e42c64e2e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3338,7 +3338,7 @@ struct vm_struct *remove_vm_area(const void *addr)
>  static inline void set_area_direct_map(const struct vm_struct *area,
>  				       int (*set_direct_map)(struct page *page))
>  {
> -	int i;
> +	unsigned long i;
>  
>  	/* HUGE_VMALLOC passes small pages to set_direct_map */
>  	for (i = 0; i < area->nr_pages; i++)
> @@ -3354,7 +3354,7 @@ static void vm_reset_perms(struct vm_struct *area)
>  	unsigned long start = ULONG_MAX, end = 0;
>  	unsigned int page_order = vm_area_page_order(area);
>  	int flush_dmap = 0;
> -	int i;
> +	unsigned long i;
>  
>  	/*
>  	 * Find the start and end range of the direct mappings to make sure that
> @@ -3427,10 +3427,10 @@ void vfree_atomic(const void *addr)
>   * Caller is responsible for unmapping (vunmap_range) and KASAN
>   * poisoning before calling this.
>   */
> -static void vm_area_free_pages(struct vm_struct *vm, unsigned int start_idx,
> -			       unsigned int end_idx)
> +static void vm_area_free_pages(struct vm_struct *vm, unsigned long start_idx,
> +			       unsigned long end_idx)
>  {
> -	unsigned int i;
> +	unsigned long i;
>  
>  	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
>  		for (i = start_idx; i < end_idx; i++)
> @@ -3642,12 +3642,12 @@ static inline gfp_t vmalloc_gfp_adjust(gfp_t flags, const bool large)
>  	return flags;
>  }
>  
> -static inline unsigned int
> +static inline unsigned long
>  vm_area_alloc_pages(gfp_t gfp, int nid,
> -		unsigned int order, unsigned int nr_pages, struct page **pages)
> +		unsigned int order, unsigned long nr_pages, struct page **pages)
>  {
> -	unsigned int nr_allocated = 0;
> -	unsigned int nr_remaining = nr_pages;
> +	unsigned long nr_allocated = 0;
> +	unsigned long nr_remaining = nr_pages;
>  	unsigned int max_attempt_order = MAX_PAGE_ORDER;
>  	struct page *page;
>  	int i;
> @@ -3695,7 +3695,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	if (!order) {
>  		while (nr_allocated < nr_pages) {
>  			unsigned int nr, nr_pages_request;
> -			int i;
> +			unsigned long i;
>  
>  			/*
>  			 * A maximum allowed request is hard-coded and is 100
> @@ -3703,7 +3703,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  			 * long preemption off scenario in the bulk-allocator
>  			 * so the range is [1:100].
>  			 */
> -			nr_pages_request = min(100U, nr_pages - nr_allocated);
> +			nr_pages_request = min(100UL, nr_pages - nr_allocated);
>  
>  			/* memory allocation should consider mempolicy, we can't
>  			 * wrongly use nearest node when nid == NUMA_NO_NODE,
> @@ -3849,12 +3849,12 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	unsigned long addr = (unsigned long)area->addr;
>  	unsigned long size = get_vm_area_size(area);
>  	unsigned long array_size;
> -	unsigned int nr_small_pages = size >> PAGE_SHIFT;
> +	unsigned long nr_small_pages = size >> PAGE_SHIFT;
>  	unsigned int page_order;
>  	unsigned int flags;
>  	int ret;
>  
> -	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
> +	array_size = nr_small_pages * sizeof(struct page *);
>  
>  	/* __GFP_NOFAIL and "noblock" flags are mutually exclusive. */
>  	if (!gfpflags_allow_blocking(gfp_mask))
> @@ -4352,7 +4352,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  	}
>  
>  	if (size <= old_size) {
> -		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
> +		unsigned long new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
>  
>  		/* Zero out "freed" memory, potentially for future realloc. */
>  		if (want_init_on_free() || want_init_on_alloc(flags))
> @@ -4381,7 +4381,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  		    !(vm->flags & (VM_FLUSH_RESET_PERMS | VM_USERMAP)) &&
>  		    gfp_has_io_fs(flags)) {
>  			unsigned long addr = (unsigned long)kasan_reset_tag(p);
> -			unsigned int old_nr_pages = vm->nr_pages;
> +			unsigned long old_nr_pages = vm->nr_pages;
>  
>  			/*
>  			 * Use the node lock to synchronize with concurrent
> @@ -4394,16 +4394,13 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  			spin_unlock(&vn->busy.lock);
>  
>  			/* Notify kmemleak of the reduced allocation size before unmapping. */
> -			kmemleak_free_part(
> -				(void *)addr + ((unsigned long)new_nr_pages
> -						<< PAGE_SHIFT),
> -				(unsigned long)(old_nr_pages - new_nr_pages)
> -					<< PAGE_SHIFT);
> +			kmemleak_free_part((void *)addr +
> +					   (new_nr_pages << PAGE_SHIFT),
> +					   (old_nr_pages - new_nr_pages)
> +						<< PAGE_SHIFT);
>  
> -			vunmap_range(addr + ((unsigned long)new_nr_pages
> -					     << PAGE_SHIFT),
> -				     addr + ((unsigned long)old_nr_pages
> -					     << PAGE_SHIFT));
> +			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
> +				     addr + (old_nr_pages << PAGE_SHIFT));
>  
>  			vm_area_free_pages(vm, new_nr_pages, old_nr_pages);
>  		}
> @@ -4415,7 +4412,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  	/*
>  	 * We already have the bytes available in the allocation; use them.
>  	 */
> -	if (size <= (unsigned long)vm->nr_pages << PAGE_SHIFT) {
> +	if (size <= vm->nr_pages << PAGE_SHIFT) {
>  		/*
>  		 * No need to zero memory here, as unused memory will have
>  		 * already been zeroed at initial allocation time or during
> @@ -4722,7 +4719,7 @@ long vread_iter(struct iov_iter *iter, const char *addr, size_t count)
>  			 * mapping types (vmap, ioremap) don't set nr_pages.
>  			 */
>  			size = (vm->flags & VM_ALLOC && vm->nr_pages) ?
> -				       ((unsigned long)vm->nr_pages << PAGE_SHIFT) :
> +				       (vm->nr_pages << PAGE_SHIFT) :
>  				       get_vm_area_size(vm);
>  		else
>  			size = va_size(va);
> @@ -5228,7 +5225,7 @@ bool vmalloc_dump_obj(void *object)
>  	struct vmap_area *va;
>  	struct vmap_node *vn;
>  	unsigned long addr;
> -	unsigned int nr_pages;
> +	unsigned long nr_pages;
>  
>  	addr = PAGE_ALIGN((unsigned long) object);
>  	vn = addr_to_node(addr);
> @@ -5248,7 +5245,7 @@ bool vmalloc_dump_obj(void *object)
>  	nr_pages = vm->nr_pages;
>  	spin_unlock(&vn->busy.lock);
>  
> -	pr_cont(" %u-page vmalloc region starting at %#lx allocated at %pS\n",
> +	pr_cont(" %lu-page vmalloc region starting at %#lx allocated at %pS\n",
>  		nr_pages, addr, caller);
>  
>  	return true;
> @@ -5266,16 +5263,17 @@ bool vmalloc_dump_obj(void *object)
>  static void show_numa_info(struct seq_file *m, struct vm_struct *v,
>  				 unsigned int *counters)
>  {
> -	unsigned int nr;
>  	unsigned int step = 1U << vm_area_page_order(v);
> +	unsigned long i;
> +	unsigned int nr;
>  
>  	if (!counters)
>  		return;
>  
>  	memset(counters, 0, nr_node_ids * sizeof(unsigned int));
>  
> -	for (nr = 0; nr < v->nr_pages; nr += step)
> -		counters[page_to_nid(v->pages[nr])] += step;
> +	for (i = 0; i < v->nr_pages; i += step)
> +		counters[page_to_nid(v->pages[i])] += step;
>  	for_each_node_state(nr, N_HIGH_MEMORY)
>  		if (counters[nr])
>  			seq_printf(m, " N%u=%u", nr, counters[nr]);
> @@ -5333,7 +5331,7 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
>  				seq_printf(m, " %pS", v->caller);
>  
>  			if (v->nr_pages)
> -				seq_printf(m, " pages=%d", v->nr_pages);
> +				seq_printf(m, " pages=%lu", v->nr_pages);
>  
>  			if (v->phys_addr)
>  				seq_printf(m, " phys=%pa", &v->phys_addr);
> 
> base-commit: 248951ddc14de84de3910f9b13f51491a8cd91df
> prerequisite-patch-id: bc462c518eb9ddcaccad5e1f5fed7cc24512b117
> prerequisite-patch-id: 891688c2e93c570d1c9c7802b46aaba974002684
> -- 
> 2.43.0
> 
Makes sense to me. The commit message could be shorter describing
just an issue. I was lost when i read it first time.

Also:

<snip>
Artem Lytkin (3):
  mm/vmalloc: fix 32-bit truncation of the area size in vread_iter()
  mm/vmalloc: fix 32-bit truncation in the vrealloc() grow-in-place check
  mm/vmalloc: make vm_struct.nr_pages an unsigned long
<snip>

first two fix overlaps. The latest also do it by converting nr_pages
to unsigned long and removes (unsigned long) casting introduced by 1 and 2.

Maybe just use one commit which is last in this series?

Anyway for this

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

