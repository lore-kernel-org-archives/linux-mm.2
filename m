Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB24BC5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 23:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97C0D6B0327; Fri, 14 Aug 2026 19:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953F46B032B; Fri, 14 Aug 2026 19:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869FB6B032C; Fri, 14 Aug 2026 19:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7896B0327
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:17:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B1ACE1A029F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:09:28 +0000 (UTC)
X-FDA: 85101418416.04.C6FA5B8
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id E306380003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:09:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AY+4cz64;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786748966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNwHOPK19N93EAW+qtCzI4XcCKn5rSewNsMuhgeWytE=;
	b=Wn+jYjQNZ4KcYpQPkqOcuDOMG57OUe860tY7hOU2t9GIXu6x7k069O4BIUuw6pmF7iQIBj
	TCFRmdkCxvg8vvL7o8tzl5HAd7Yym7Z8QH1ZfFpH7ULUvNezSWqN+njkKlLnD7eyi7JI2S
	mUnDuLqumbUvYqUGtSHEVgqys7xFHOI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AY+4cz64;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786748966;
	b=C6Wccau/T7Jo/m880IwT6/jdmP/0VEE/z8nD41qZj/hlW1CI+abhhtDFbN0HiTx7Ua+eYn
	aE+f1CPHZjdnaH7Vag5P4g1+4W6RBkuENw/febHHU9CgkLH8zQ5DgHAGGUuTD6Xxeesw8X
	NwOe21sKsjiWaCwZq8dex0LZFms+foI=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5b0117d49dcso1408173e87.3
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786748965; x=1787353765; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sNwHOPK19N93EAW+qtCzI4XcCKn5rSewNsMuhgeWytE=;
        b=AY+4cz64pybOQB8qoDY94Ae0URUbGjjuaAVbpthKCHgPxX1MExxOUi1/PBi9+4Fe0Q
         KOFNeVCBzPj+xRWbNTaOg3q77Cyz2eXC/vb7QClbJKtiQLWI6Ufcb+SaPZdTEsjLEfih
         RccwnpLPPPbNJHAlgaUy/c7Z31BIuyAdHzi4khXRvrwcJ/krhzM08YGuV+ePHREMQ583
         uSKb0sERMHyjOmMTQPoL4aklsCaNna4kG2MxNzxjsSHPfQyWWncPVwOZV65eoguSvaVE
         53viYusB9rWB3OmJNEQHlihitnZJndsYZ0X2qTTmOe9O4ZYfYFaTQUTps1VWzc8s06eY
         Vjlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786748965; x=1787353765;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sNwHOPK19N93EAW+qtCzI4XcCKn5rSewNsMuhgeWytE=;
        b=B+LNRR2jtsBG+PONhe4zrkpQTv7AbHKk1ZyEh8swKZlxEqbqODRPy1fJnVy9ZGdmL7
         Ti32C20rU0h2qZ8K4EZMgGTa3y20wmR0PYuNjA3Z7RSVx6NEn01sWVNTQt+rP4zwsEcO
         8C9fxmAPltIe3+rhUYFoVbMiMN0lFtgXzawSJTO9LRGad9TGzTu/uGgcC2/uraTzIWrQ
         du4gpw++Kcj1d9awzHHNzA+GzFqQp/2bF/BPqWI1y4PQr42tYg0HNVTt26oc168QjOuj
         tKVDiXnc1d6Fezepy6ddotSDm9wU//doByX5ondwLbTrObvTJn/Ys/MsWOCDZ8aM4neV
         8ORA==
X-Gm-Message-State: AOJu0YwxS+Orhe2+7nsEZcTjVza4sEq9AJ+irWirVOv0aSbkwcwhki4l
	XQ33rxPqgzqJ+YNJ5Z3pSVwbxhtpocwe/72Uix/KM4s9gh1Hx2GbMnuG
X-Gm-Gg: AR+sD11+zHD+ZvAdIW73xLXktTZSTts1cG0oSMZoGb6m0MWmiREkSlMYoGCq5+qS/wi
	aoNMKKaKxgpRlBDR+5xAhWgYKiTKrPmmVpNySrupL6UH2Lg6empQzGlrqZkmds999KFPz6BSLZp
	umA5oxrtn5eCSmgQJLCwzky1DFbUjD43PYfZ/k2qm89guMhS31WQp6EeV43dgAKbsbDOmKFZZLQ
	vGu72xM5jbD3jf0I0d8FXADbPP3cl64PwjKyELW6wZvBIn14F9AZBtXmWjkOFf+jlLeUJuro78/
	WsAQmKTQ2zFA3ZWPepL8vx0LeHSJ7fQeUdRbrZqm2fMANjpIoWTsIlENPcWWUwRjdA9KguMNu/q
	83JVlwbSuqYdIjN4MJWkDYDLVbxEnG7t+IfV53yVy8bmJhpjjEkR9CVGdLqAqk6fJ8JSdN5lhEu
	80xaI9eAOXozmFGhjcQIanQ1GHzBf/1pr657j71o5Y8nEEAKHdWg5IcaKnTOljXWHkRpc69+rKw
	k8=
X-Received: by 2002:a05:6512:32d6:b0:5b1:5ab5:e9f7 with SMTP id 2adb3069b0e04-5b459197257mr1312537e87.39.1786748964849;
        Fri, 14 Aug 2026 16:09:24 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:7b92:9ac1:b9ef:5287])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458c10199sm822986e87.79.2026.08.14.16.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 16:09:24 -0700 (PDT)
Date: Sat, 15 Aug 2026 01:09:23 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, chrisl@kernel.org, nphamcs@gmail.com, 
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com, hannes@cmpxchg.org, 
	yosry@kernel.org, shikemeng@huaweicloud.com, chengming.zhou@linux.dev, 
	baoquan.he@linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC v3 05/15] mm, swap: add xswap cluster grow via VM_SPARSE
 vmalloc
Message-ID: <an-dmyT37Cq-aYUF@soda.int.kasm.eu>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
 <20260813104857.3450386-6-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813104857.3450386-6-hebaoquan@kylinos.cn>
X-Rspamd-Queue-Id: E306380003
X-Stat-Signature: oe7d9hw14nxx3st16mmbrpe5fmnest5k
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786748966-929047
X-HE-Meta: U2FsdGVkX181Clfy/qE7PAcXQzAv2qh91tVyK/4xHQ4yjUAm0N28wdYUX2lS5r6Ly3SVcwCvOvsPzb7cmL2wnyRPXQSAG5pCMPVPe4bbzXNjesXElwLH0cbO2w+CyGbM8GStuQejm5g9/N7DVfvsh3LAE7t7BthaerJQIzOA0j8LelFq3NR3ZrVmtA64HnAut358IW96X2bqBAdQt9XiFDN55pO2hcRU/8QtgfP22KS50GgXmbDTBG6R6Kw3lL3KEg+QFUErM0rJOpMUPW8s6dUqNs/3S49pleMG9IPso3VjMwQF7IDbSKxgpbtyInqIEmBSWPiiOAItjO10KULRr3XYrO6oUP9Fej0CMicjbWMj6LjqNovoIDmBT7W2dS5FHYkdo2SymFA2noGlVfg/luA6Aqgf8b97QvrZj622WS7GIQDW3HjqQXR1XnhO2y6IzNJmTXi7uZiTbX1xo1uw5IPVbdrIGVp3wZn33toCcUMYJwXS3DRdKVIOsyiVj9XGvjL073Q9qv4Q3eCj9pNVeIwXlK/AVdx1/GKZ/9rmOeBiDdg9sgVA27QoLGtwU2sWCBD4uy6fDzVsJ7ywhx/AHoW9A+t1XPcSuhi+7Zxq5iX+JBIqP5lpTYkdNPrhmGa1eaUwtdO1NiskUhwRIltb473djH8ArPyCoQnOdeUkSuKbRThT46EmhvTKkh/di3jy6VM+f+vPC5/+acAclE8MekSQWL3joBw+HlK+d88Cj0VK72JYHGsGqvkwwi1b2pJla+u3V4uVX1myiHlx3RJbmAV9+2NMLj8+uvLiw4E8oeKRX1S0obOCblv2QVkRfyfMX3Vt7IZtk4ZtLy3TAnec1/aXX8nCW9Zd8YfDZZFp7B1urKO/PeXKjiOya143IlLBcML/8td402U8/kSJ8LUKW+idK/UVNBN0vEX+Qwf/rR4PXTH3QbOtlpudl9ckhpRYvHaD+a4DggsQsNey3ku
 6EPzpAzz
 qRO+KWkyPQJ5XD0uN7o0clxmrSQ4EO8ptpMDolzF2U166YhE8tAeqsrno+07sgjrEv7sl8kmbajh9p4USExFkZJ3120I1wIGOC8iYaYcHXBuFXyGKdX5mSw9lGKwJQ/8x/mRx6kf4EhNoesYWVKpTYfZIo6w4CEqO20iaTohaNiDaf8B5aIpffS9ZQnBx43M21tG1OudK2h63UgFv32lP0rqQuUqg1O6F5qdH9XPAB0ZkJN1nBTn01//X1g98hi9RPOM+/8t5P8w9jNtwfvmp2NuZbV+5Z+YxcmjH2G+UcbfebverWbjtcaDxX+Y734new4QyFMPYaBSqSGASGKQju4vQOfeJatfRmccQwArFSj4qBqW+GstVSfUur6p5TMeH+CvvRWnHJ2rCB5YqkTy9hlOiaDhY43ZvK5kwqdy+dNIAP8jLmsB2hQCtAph/bY2UDe6WyGvcZdSlBa0Gocn2OHJom4+CxA6AWSV3kglSAa6syju8zkRrsk3l9WyWeNN3CwrSwOeg3xkUNjy+GLKOOmLYXK+EwF7TQKFXBzG/vN5wI8b1ext595b4SMmwfcQl9b2V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-08-13 18:48:44 +0800, Baoquan He wrote:
> Implement dynamic cluster_info array growth for xswap devices using a
> VM_SPARSE vmalloc area:
> 
> 1. xswap_map_clusters(): Allocate physical pages and map them into
>    the pre-reserved VM_SPARSE KVA region via vm_area_map_pages().
> 
> 2. xswap_unmap_clusters(): Unmap pages from the VM_SPARSE area via
>    vm_area_unmap_pages() (used by the error/teardown paths, shrink
>    comes later).
> 
> 3. setup_swap_clusters_info() xswap path: Use get_vm_area(VM_SPARSE)
>    for the cluster_info array, lazily mapping only the initial chunk.
> 
> 4. free_swap_cluster_info() xswap path: Unmap all clusters and
>    free_vm_area().  Built on the refactoring in the previous patch.
> 
> 5. wait_for_allocation() xswap guard: Skip shrinker-unmapped clusters
>    beyond nr_clusters_mapped.
> 
> The grow path avoids emergency reserves via __GFP_HIGH|__GFP_NOMEMALLOC
> and wraps allocations with memalloc_noreclaim_save().  A per-device
> mutex (xswap_lock) serializes concurrent map/unmap page table
> modifications.
> 
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  include/linux/swap.h |   1 +
>  mm/swapfile.c        | 257 ++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 256 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 7ffc62a3b2d7..c824848c6cfc 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -252,6 +252,7 @@ struct swap_info_struct {
>  	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for xswap dynamic cluster_info */
>  	unsigned long		nr_clusters;	/* total cluster count for xswap */
>  	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
> +	struct mutex		xswap_lock;	/* serialize map/unmap operations */
>  #endif
>  	struct list_head free_clusters; /* free clusters list */
>  	struct list_head full_clusters; /* full clusters list */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4ce30e9ecdf6..178c3b798f8e 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -49,6 +49,25 @@
>  #include "internal.h"
>  #include "swap.h"
>  
> +#ifdef CONFIG_XSWAP
> +/*
> + * xswap: dynamically grow the cluster_info array via a VM_SPARSE area.
> + *
> + * XSWAP_GROW_CLUSTERS is the number of clusters to map in one grow
> + * operation.  It is set to the number of cluster_info structs that
> + * fit in a single page (at least 16), so that the vmalloc page table
> + * overhead is proportional to the number of clusters mapped.
> + */
> +#define XSWAP_GROW_CLUSTERS \
> +	max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info), 16)
> +
> +static int xswap_map_clusters(struct swap_info_struct *si,
> +			      unsigned long start_idx, unsigned long nr);
> +static void xswap_unmap_clusters(struct swap_info_struct *si,
> +				 unsigned long start_idx, unsigned long nr);
> +static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data);
> +#endif
> +
>  static void swap_range_alloc(struct swap_info_struct *si,
>  			     unsigned int nr_entries);
>  static bool folio_swapcache_freeable(struct folio *folio);
> @@ -2708,15 +2727,27 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
>  					unsigned int prev)
>  {
>  	unsigned int i;
> +	unsigned int end = si->max;
>  	unsigned long swp_tb;
>  
> +#ifdef CONFIG_XSWAP
> +	/* xswap may have shrunk and unmapped the cluster_info tail. */
> +	if (si->flags & SWP_XSWAP) {
> +		unsigned long mapped_end;
> +
> +		mapped_end = READ_ONCE(si->nr_clusters_mapped) * SWAPFILE_CLUSTER;
> +		if (mapped_end < end)
> +			end = mapped_end;
> +	}
> +#endif
> +
>  	/*
>  	 * No need for swap_lock here: we're just looking
>  	 * for whether an entry is in use, not modifying it; false
>  	 * hits are okay, and sys_swapoff() has already prevented new
>  	 * allocations from this area (while holding swap_lock).
>  	 */
> -	for (i = prev + 1; i < si->max; i++) {
> +	for (i = prev + 1; i < end; i++) {
>  		swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
>  					i % SWAPFILE_CLUSTER);
>  		if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
> @@ -2725,7 +2756,7 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
>  			cond_resched();
>  	}
>  
> -	if (i == si->max)
> +	if (i == end)
>  		i = 0;
>  
>  	return i;
> @@ -3041,6 +3072,13 @@ static void wait_for_allocation(struct swap_info_struct *si)
>  
>  	BUG_ON(si->flags & SWP_WRITEOK);
>  
> +#ifdef CONFIG_XSWAP
> +	/* Skip shrinker-unmapped cluster tail. */
> +	if (si->flags & SWP_XSWAP)
> +		end = min(end, READ_ONCE(si->nr_clusters_mapped) *
> +			  SWAPFILE_CLUSTER);
> +#endif
> +
>  	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
>  		ci = swap_cluster_lock(si, offset);
>  		swap_cluster_unlock(ci);
> @@ -3057,6 +3095,19 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
>  	if (!cluster_info)
>  		return;
>  
> +#ifdef CONFIG_XSWAP
> +	if (si->flags & SWP_XSWAP) {
> +		/* Unmap all mapped clusters and free the VM_SPARSE area */
> +		if (si->nr_clusters_mapped > 0)
> +			xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
> +		free_vm_area(si->cluster_vm);
> +		si->cluster_vm = NULL;
> +		si->nr_clusters = 0;
> +		si->nr_clusters_mapped = 0;
> +		return;
> +	}
> +#endif
> +
>  	nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
>  	for (i = 0; i < nr_clusters; i++) {
>  		ci = cluster_info + i;
> @@ -3553,6 +3604,150 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
>  	return maxpages;
>  }
>  
> +#ifdef CONFIG_XSWAP
> +static int xswap_map_clusters(struct swap_info_struct *si,
> +			      unsigned long start_idx, unsigned long nr)
> +{
> +	unsigned long start_addr = (unsigned long)si->cluster_info +
> +				   (size_t)start_idx * sizeof(struct swap_cluster_info);
> +	unsigned long end_addr = start_addr + (size_t)nr * sizeof(struct swap_cluster_info);
> +	/* Round to page boundaries for vm_area_map_pages(). */
> +	unsigned long vm_start = PAGE_ALIGN(start_addr);
> +	unsigned long vm_end = PAGE_ALIGN(end_addr);
> +	unsigned int noreclaim_flags;
> +	unsigned long npages;
> +	struct page **pages;
> +	unsigned long i;
> +	int err;
> +
> +	mutex_lock(&si->xswap_lock);
> +
> +	if (vm_start >= vm_end) {
> +		/* All requested clusters fall within already-mapped pages. */
> +		for (i = start_idx; i < start_idx + nr; i++)
> +			spin_lock_init(&si->cluster_info[i].lock);
> +		WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
> +		mutex_unlock(&si->xswap_lock);
> +		return 0;
> +	}
> +
> +	npages = (vm_end - vm_start) >> PAGE_SHIFT;
> +
> +	/* Prevent recursive reclaim during vmap page table allocation. */
> +	noreclaim_flags = memalloc_noreclaim_save();
> +
> +	pages = kmalloc_array(npages, sizeof(*pages),
> +			      __GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL);
> +	if (!pages) {
> +		memalloc_noreclaim_restore(noreclaim_flags);
> +		mutex_unlock(&si->xswap_lock);
> +		return -ENOMEM;
> +	}
> +
> +	for (i = 0; i < npages; i++) {
> +		/* __GFP_ZERO: cluster_info pointer fields must start NULL. */
> +		pages[i] = alloc_page(__GFP_HIGH | __GFP_NOMEMALLOC |
> +				      GFP_KERNEL | __GFP_ZERO);
> +		if (!pages[i])
> +			goto fail;
> +	}
> +
> +	/* Detect racing grower that already mapped these pages. */
> +	if (apply_to_existing_page_range(&init_mm, vm_start,
> +					 vm_end - vm_start,
> +					 xswap_check_mapped, NULL)) {
> +		i = npages;
> +		goto fail_nounmap;
> +	}
> +
> +	err = vm_area_map_pages(si->cluster_vm, vm_start, vm_end, pages);
> +	if (err) {
> +		/* -EBUSY: defensive, the page was already mapped. */
> +		if (err == -EBUSY) {
> +			i = npages;
> +			goto fail_nounmap;
> +		}
> +		i = npages;
> +		goto fail;
> +	}
> +
> +	kfree(pages);
> +	memalloc_noreclaim_restore(noreclaim_flags);
> +
> +	/* Initialize spinlocks for newly mapped clusters */
> +	for (i = start_idx; i < start_idx + nr; i++)
> +		spin_lock_init(&si->cluster_info[i].lock);
> +
> +	/*
> +	 * Pairs with READ_ONCE() in shrink/grow paths.
> +	 */
> +	WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
> +	mutex_unlock(&si->xswap_lock);
> +	return 0;
> +
> +fail_nounmap:
> +	/*
> +	 * The concurrent grower already mapped the range, initialized the
> +	 * cluster spinlocks and advanced nr_clusters_mapped.  It may still
> +	 * be holding those locks while adding clusters to the free list, so
> +	 * do not touch them here; just free our unused pages.
> +	 */
> +	while (i > 0) {
> +		i--;
> +		if (pages[i])
> +			__free_page(pages[i]);
> +	}
> +	kfree(pages);
> +	memalloc_noreclaim_restore(noreclaim_flags);
> +	mutex_unlock(&si->xswap_lock);
> +	return 0;
> +
> +fail:
> +	while (i > 0) {
> +		i--;
> +		if (pages[i])
> +			__free_page(pages[i]);
> +	}
> +	memalloc_noreclaim_restore(noreclaim_flags);
> +	kfree(pages);
> +	mutex_unlock(&si->xswap_lock);
> +	return -ENOMEM;
> +}
> +
> +static void xswap_unmap_clusters(struct swap_info_struct *si,
> +				 unsigned long start_idx, unsigned long nr)
> +{
> +	unsigned long start_addr = (unsigned long)si->cluster_info +
> +				   (size_t)start_idx * sizeof(struct swap_cluster_info);
> +	unsigned long end_addr = start_addr + (size_t)nr * sizeof(struct swap_cluster_info);
> +	/* Round to page boundaries for vm_area_unmap_pages(). */
> +	unsigned long vm_start = PAGE_ALIGN(start_addr);
> +	unsigned long vm_end = PAGE_ALIGN(end_addr);
> +
> +	mutex_lock(&si->xswap_lock);
> +
> +	if (vm_start >= vm_end) {
> +		WRITE_ONCE(si->nr_clusters_mapped, start_idx);
> +		mutex_unlock(&si->xswap_lock);
> +		return;
> +	}
> +
> +	vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
> +	/* vm_area_unmap_pages() clears PTEs but does not free pages. */
> +	/* TODO: free backing pages via page table walk or tracking bitmap */
> +
> +	/* Pairs with READ_ONCE() in shrink/grow paths. */
> +	WRITE_ONCE(si->nr_clusters_mapped, start_idx);
> +	mutex_unlock(&si->xswap_lock);
> +}
> +
> +/* Return 1 at first present PTE to signal range is already mapped. */
> +static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data)
> +{
> +	return 1;
> +}
> +#endif /* CONFIG_XSWAP */
> +
>  static int setup_swap_clusters_info(struct swap_info_struct *si,
>  				    union swap_header *swap_header,
>  				    unsigned long maxpages)
> @@ -3562,6 +3757,64 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
>  	int err = -ENOMEM;
>  	unsigned long i;
>  
> +#ifdef CONFIG_XSWAP
> +	if (si->flags & SWP_XSWAP) {
> +		unsigned long size = PAGE_ALIGN(nr_clusters * sizeof(*cluster_info));
> +		struct vm_struct *vm;
> +
> +		vm = get_vm_area(size, VM_SPARSE);
> +		if (!vm)
> +			goto err;
> +
> +		cluster_info = vm->addr;
> +		si->cluster_vm = vm;
> +		si->nr_clusters = nr_clusters;
> +		si->cluster_info = cluster_info;

Should probably initialise the mutex here instead since
xswap_map_clusters() uses it?

> +
> +		/* Map the initial chunk (at least cluster 0) */
> +		if (xswap_map_clusters(si, 0, min_t(unsigned long,
> +					XSWAP_GROW_CLUSTERS, nr_clusters)))
> +			goto err_free_vm;

> +
> +		/* xswap: only cluster 0 slot 0 is bad */
> +		err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
> +		if (err)
> +			goto err_unmap;
> +
> +		INIT_LIST_HEAD(&si->free_clusters);
> +		INIT_LIST_HEAD(&si->full_clusters);
> +		INIT_LIST_HEAD(&si->discard_clusters);
> +		for (i = 0; i < SWAP_NR_ORDERS; i++) {
> +			INIT_LIST_HEAD(&si->nonfull_clusters[i]);
> +			INIT_LIST_HEAD(&si->frag_clusters[i]);
> +		}
> +
> +		/* Mark mapped clusters: cluster 0 has 1 bad slot, rest free */
> +		for (i = 0; i < si->nr_clusters_mapped; i++) {
> +			struct swap_cluster_info *ci = &cluster_info[i];
> +
> +			if (i == 0) {
> +				ci->flags = CLUSTER_FLAG_NONFULL;
> +				list_add_tail(&ci->list, &si->nonfull_clusters[0]);
> +			} else {
> +				ci->flags = CLUSTER_FLAG_FREE;
> +				list_add_tail(&ci->list, &si->free_clusters);
> +			}
> +		}
> +
> +		mutex_init(&si->xswap_lock);
> +		return 0;
> +
> +err_unmap:
> +		xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
> +err_free_vm:
> +		free_vm_area(si->cluster_vm);
> +		si->cluster_vm = NULL;
> +		si->cluster_info = NULL;
> +		return err;
> +	}
> +#endif /* CONFIG_XSWAP */
> +
>  	cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
>  	if (!cluster_info)
>  		goto err;
> -- 
> 2.54.0
> 

Regards,
Klara Modin

