Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF137C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 15:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5AE76B0122; Wed, 29 Jul 2026 11:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C696B0123; Wed, 29 Jul 2026 11:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA346B0180; Wed, 29 Jul 2026 11:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AE9C6B0122
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:12:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE5401C08D4
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:12:56 +0000 (UTC)
X-FDA: 85042156752.20.51A1BC4
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5FA3B160009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:12:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lZHUDOqc;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WGWZOVo9FQi4yCCJXT5thQck79C8dzo74UOUAl3PZa4=;
	b=xtZI6vEYbUyIersoizhmVz13NT98movU4aOkf8K3f0DqJBss9+i9I4l9RsEckqVMcK81sJ
	hC6NFQVyzML3fvLokF4X3Yt7lMMOcVSF3TCUK5OhKxM7b/DeuxFlm9p5UViQ0B81CGbRJK
	O8ieGdl01kR+JcPDBIjnT4GivIgBiQM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337975;
	b=SKQ+ZYb8tjjcWS+qg9WKeDMkuIvDETU2YbwXHBoCWl+Y/+3AuDsXribnzzX1YQUlbIrV2n
	R/Seww9YROJrwqvIcV3LaH7+MqSxT57ntoTr40FWFtwy3ZVAx0VfWjCnqP7JTKM8zkIbKG
	KigbX02MebDGzVw6595o3TeNyVYRMKg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lZHUDOqc;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 29 Jul 2026 23:12:43 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785337971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WGWZOVo9FQi4yCCJXT5thQck79C8dzo74UOUAl3PZa4=;
	b=lZHUDOqc9Js4vijztT02oY7lA4Da4gXntN16HH1UGEdUkL+YUTr0NztxsFcLQLrC2TsrwX
	EpC14ybVknneWacuyDF6bcdYECe1NjtdLZFKnivZTMKPUtDD9gY2C+1zrFuk4SjeWjmh4E
	eAqF8LGfbeOHh/VKOjcSXneWngpcg0U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com,
	hannes@cmpxchg.org, yosry@kernel.org, david@kernel.org,
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 03/11] mm, swap: add xswap cluster grow via VM_SPARSE
 vmalloc
Message-ID: <amoYawUn3y2eFbPS@MiWiFi-R3L-srv>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev>
 <20260727140503.1060918-2-baoquan.he@linux.dev>
 <CAKEwX=Pe+qMZd2xhnU-PAGQtgXkp56c-JwYCbt2Lux9htgB67Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=Pe+qMZd2xhnU-PAGQtgXkp56c-JwYCbt2Lux9htgB67Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: p8kzfxjux6bxej4gdfbngtodz6zt9ps6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5FA3B160009
X-HE-Tag: 1785337973-616787
X-HE-Meta: U2FsdGVkX19S5vp7L9Q3C01hEwB1Jsivtd6ClZ5rRXKQQgd4lWUu/OBF2qVV8bacYxXmqkCJD8L9ovSWV3SVK5lpVBFSXJqeXMMsJaZM30lQS1fomPrgnT+EeB/7ZcI1AQkxMDwUg7gejDWi659KntjYv/L4GeUnOhsU7Da78oDY32qnfsfoOvsB+ECVFdmX5V1lzMygRriU2acrddrQBlLn15pkF9CPh63Gt8WAX16pLjbDMKZ+hnYmmVLhW6pztzeht500B3AJTDvXc9vaUTrxV8i0ru231Lz4B0xDlBoJxwZn8pfAhMRgEXZXYKVdqpyDAh/Nz5oamQL3f2pAkEGEZ5p9uqWfWQGd8XouZDq/NmcI6hQ1XdGQp10PaUcFlO8SdQDBqMZv+8GlXhfL6JQ/sLKltjTE+vjVPjW3clM8H3hqLAXfOV8AZOtP2p9b+QHliuyIAVLSOW0jFHThy1Dmr9JMJ1I4NpjOrhL9U+wrMMDav6Jv1HPrgUg+qlc2fo3LFanuD2pA7Gbp2xkUODThyXzvoMY5+JOn0KJOAhXxSKfa7ikTydjS2xjD4A9HlWZeq9bBNXjDnQ5iUpDjQ/6eMuW8anNHydb5cuTaE97hsDKsjXd6O4mKlQGkGZmBLCnQ1W/r63AqbRRJFpSqzKCyCUre+lbMnkALoRQgTGePchN8NhzoKn/3TlBfii/KAdH4NHrdU4H5tbQFuI/r1rOV3IblwI+RtiAzjTTuBKoms2SW+whw12LGgV38+tTuQh5v5mlhE4FtZT9WkxSsjgw4onGO/z/lpDiXnYdAKR+WgLxtUR+j9wyMr2Q0/MYWQlO7dvK0aPVbQSvn2eTmkclOYkEHwFlWj693XktywgJo0Xco0Lq6aYcoD3DO+mEgmFGMpPjwy7PqEIW426k26RiGZdVX1RgH0R13KcrtIvMm5ICD3nu+cz6Zq4C+pHL9c/hZSRKhJXP61NpMXse
 7FcBv4l8
 NB9dgrG2IYsaIr/zvdHbW7Ej676YmufU35QU9GfiPDGd+DvUdnO8EEcU3UPzxfo00er80yU/c9yJJkC2hJbmFM9sJWVLNRvrGS3OfOjWnwDiLItNCoLFwD6VtUoYToU1XE0/6HmKOjgKqqiL2deuLTMj58cifZiBkZ7ODOel3qdQz3zHwNlgm7txJ1UH8nSYgVj2gSmh0rqtATXe+ye1N1sOmqN/bhcPIz7gtU6ypiN42x+RBCcrZIdQbBtDx6ZAqf5nuKuALQmNOJ2M7ZlYXjE7ces73IRzy59cXKdq40BCySLc/+s+ctdYPZGKsQGf9++aB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/27/26 at 08:05am, Nhat Pham wrote:
> On Mon, Jul 27, 2026 at 7:05 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > Implement dynamic cluster_info array growth for xswap devices using a
> > VM_SPARSE vmalloc area:
> >
> > 1. xswap_map_clusters(): Allocate physical pages and map them into
> >    the pre-reserved VM_SPARSE KVA region via vm_area_map_pages().
> >
> > 2. xswap_unmap_clusters(): Unmap pages from the VM_SPARSE area via
> >    vm_area_unmap_pages() (used by the error/teardown paths, shrink
> >    comes later).
> >
> > 3. setup_swap_clusters_info() xswap path: Use get_vm_area(VM_SPARSE)
> >    for the cluster_info array, lazily mapping only the initial chunk.
> >
> > 4. free_swap_cluster_info(): Refactor to take swap_info_struct*.
> >    For xswap, unmap all clusters and free_vm_area().
> >
> > 5. swapoff: Remove snapshot locals; move p->max/p->cluster_info
> >    clearing after free_swap_cluster_info().
> >
> > Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> 
> I'll give my 2 cents on the direction we're pursuing later. I've done
> a lot of thinking over the past weeks, and I have some new concerns
> now regarding how we plan to land this joint venture :)
> 
> That said, this is a new piece of extension, done per my request
> (kernel-driven dynamic swap address space growth - thanks for taking
> my concerns seriously), and I've also evaluated this vmalloc-based
> data structure in the past week, so I'll put in my inquiries/concerns.
> 
> > ---
> >  mm/swapfile.c | 228 +++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 216 insertions(+), 12 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 143088dae07d..6d9c95ed09bd 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -49,6 +49,24 @@
> >  #include "internal.h"
> >  #include "swap.h"
> >
> > +#ifdef CONFIG_XSWAP
> > +/*
> > + * xswap: dynamically grow the cluster_info array via a VM_SPARSE area.
> > + *
> > + * XSWAP_GROW_CLUSTERS is the number of clusters to map in one grow
> > + * operation.  It is set to the number of cluster_info structs that
> > + * fit in a single page (at least 16), so that the vmalloc page table
> > + * overhead is proportional to the number of clusters mapped.
> > + */
> > +#define XSWAP_GROW_CLUSTERS \
> > +       max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info), 16)
> > +
> > +static int xswap_map_clusters(struct swap_info_struct *si,
> > +                             unsigned long start_idx, unsigned long nr);
> > +static void xswap_unmap_clusters(struct swap_info_struct *si,
> > +                                unsigned long start_idx, unsigned long nr);
> > +#endif
> > +
> >  static void swap_range_alloc(struct swap_info_struct *si,
> >                              unsigned int nr_entries);
> >  static bool folio_swapcache_freeable(struct folio *folio);
> > @@ -3041,20 +3059,47 @@ static void wait_for_allocation(struct swap_info_struct *si)
> >
> >         BUG_ON(si->flags & SWP_WRITEOK);
> >
> > +#ifdef CONFIG_XSWAP
> > +       /*
> > +        * xswap clusters beyond nr_clusters_mapped have been unmapped
> > +        * by the shrinker and their vmalloc pages are no longer
> > +        * accessible.  Only iterate over currently mapped clusters.
> > +        */
> > +       if (si->flags & SWP_XSWAP)
> > +               end = min(end, READ_ONCE(si->nr_clusters_mapped) *
> > +                         SWAPFILE_CLUSTER);
> > +#endif
> > +
> >         for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
> >                 ci = swap_cluster_lock(si, offset);
> >                 swap_cluster_unlock(ci);
> >         }
> >  }
> >
> > -static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
> > -                                  unsigned long maxpages)
> > +static void free_swap_cluster_info(struct swap_info_struct *si)
> >  {
> > +       struct swap_cluster_info *cluster_info = si->cluster_info;
> > +       unsigned long maxpages = si->max;
> >         struct swap_cluster_info *ci;
> > -       int i, nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
> > +       int i, nr_clusters;
> >
> >         if (!cluster_info)
> >                 return;
> > +
> > +#ifdef CONFIG_XSWAP
> > +       if (si->flags & SWP_XSWAP) {
> > +               /* Unmap all mapped clusters and free the VM_SPARSE area */
> > +               if (si->nr_clusters_mapped > 0)
> > +                       xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
> > +               free_vm_area(si->cluster_vm);
> > +               si->cluster_vm = NULL;
> > +               si->nr_clusters = 0;
> > +               si->nr_clusters_mapped = 0;
> > +               return;
> > +       }
> > +#endif
> > +
> > +       nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
> >         for (i = 0; i < nr_clusters; i++) {
> >                 ci = cluster_info + i;
> >                 /* Cluster with bad marks count will have a remaining table */
> > @@ -3093,11 +3138,9 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
> >  SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> >  {
> >         struct swap_info_struct *p = NULL;
> > -       struct swap_cluster_info *cluster_info;
> >         struct file *swap_file, *victim;
> >         struct address_space *mapping;
> >         struct inode *inode;
> > -       unsigned int maxpages;
> >         int err, found = 0;
> >
> >         if (!capable(CAP_SYS_ADMIN))
> > @@ -3189,10 +3232,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> >
> >         swap_file = p->swap_file;
> >         p->swap_file = NULL;
> > -       maxpages = p->max;
> > -       cluster_info = p->cluster_info;
> > -       p->max = 0;
> > -       p->cluster_info = NULL;
> >         spin_unlock(&p->lock);
> >         spin_unlock(&swap_lock);
> >         arch_swap_invalidate_area(p->type);
> > @@ -3200,7 +3239,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> >         mutex_unlock(&swapon_mutex);
> >         kfree(p->global_cluster);
> >         p->global_cluster = NULL;
> > -       free_swap_cluster_info(cluster_info, maxpages);
> > +       free_swap_cluster_info(p);
> > +       p->max = 0;
> > +       p->cluster_info = NULL;
> >
> >         inode = mapping->host;
> >
> > @@ -3564,6 +3605,112 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
> >         return maxpages;
> >  }
> >
> > +#ifdef CONFIG_XSWAP
> > +static int xswap_map_clusters(struct swap_info_struct *si,
> > +                             unsigned long start_idx, unsigned long nr)
> > +{
> > +       unsigned long start_addr = (unsigned long)si->cluster_info +
> > +                                  (size_t)start_idx * sizeof(struct swap_cluster_info);
> > +       unsigned long end_addr = start_addr + (size_t)nr * sizeof(struct swap_cluster_info);
> > +       /*
> > +        * vm_area_map_pages() requires that start and end be page-aligned.
> > +        * If start_addr falls within a page that was already mapped by a
> > +        * previous batch (grow path), round it up to skip the already-mapped
> > +        * partial page.  Always round end_addr up so the vmap page table walk
> > +        * terminates correctly (the walk loop exits when addr == end, and addr
> > +        * advances by PAGE_SIZE each iteration).
> > +        */
> > +       unsigned long vm_start = PAGE_ALIGN(start_addr);
> > +       unsigned long vm_end = PAGE_ALIGN(end_addr);
> > +       unsigned long npages;
> > +       struct page **pages;
> > +       unsigned long i;
> > +
> > +       if (vm_start >= vm_end) {
> > +               /* All requested clusters fall within already-mapped pages. */
> > +               for (i = start_idx; i < start_idx + nr; i++)
> > +                       spin_lock_init(&si->cluster_info[i].lock);
> > +               WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
> > +               return 0;
> > +       }
> > +
> > +       npages = (vm_end - vm_start) >> PAGE_SHIFT;
> > +
> > +       pages = kmalloc_array(npages, sizeof(*pages), GFP_KERNEL);
> > +       if (!pages)
> > +               return -ENOMEM;
> > +
> > +       for (i = 0; i < npages; i++) {
> > +               /*
> > +                * __GFP_ZERO is critical: cluster_info structs contain pointer
> > +                * fields (extend_table, zero_bitmap, memcg_table, table) that
> > +                * must start as NULL.  Without zeroing, stale data from a
> > +                * previous user of the page would look like valid pointers.
> > +                */
> > +               pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
> > +               if (!pages[i])
> > +                       goto fail;
> > +       }
> > +
> > +       if (vm_area_map_pages(si->cluster_vm, vm_start, vm_end, pages)) {
> > +               i = npages; /* free all pages on failure */
> > +               goto fail;
> 
> I was evaluating whether your vmalloc array can be extended to support
> kernel-driven dynamic growth at least (either as a slot-in replacement
> for xarray, or as a follow-up optimization if it's too complicated),
> and I stumble this mapping action.
> 
> Seems like it does not take any GFP flag argument, and under the hood
> it calls GFP_KERNEL. Would this be safe in the swap allocation path
> (where you slotted it in in patch 4)? Kairui used a more precise set
> of flags in this path, for e.g for swap table allocation:
> 
> ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
>    GFP_KERNEL);
> 
> 
> I'm guessing this has to do with the fact that we often entered
> swapping out paths with PF_MEMALLOC... Is there any risk of deadlock
> etc.?

Thanks for catching this.  You're right — there are actually three
layers of hardcoded GFP_KERNEL in the VM_SPARSE path:

1. alloc_page(GFP_KERNEL | __GFP_ZERO) in xswap_map_clusters() for the
backing pages
2. vmap_pages_range() hardcodes GFP_KERNEL (passed only to KMSAN, but
still semantically wrong)
3. The page-table allocations inside vmap_pages_range_noflush_walk()
(pte_alloc_kernel_track etc.) use GFP_PGTABLE_KERNEL, which is
GFP_KERNEL | __GFP_ZERO — also lacking __GFP_NOMEMALLOC, and
completely invisible to the caller

When PF_MEMALLOC is set (as it is during reclaim), __gfp_pfmemalloc_flags()
returns ALLOC_NO_WATERMARKS for any allocation without __GFP_NOMEMALLOC,
meaning those allocations can consume all emergency reserves — including
the reserves that the reclaim machinery itself needs to make forward
progress.  That is a real deadlock risk.

One way is to fix them one by one. Another way is to drop the VM_SPARSE
approach entirely and implemented Chris's suggestion instead: cluster_info
is now a struct swap_cluster_info ** pointer array, with each cluster
individually kmem_cache_zalloc()'d. The grow path (xswap_grow_clusters)
now uses:

kmem_cache_zalloc(swap_cluster_cachep,
        __GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL)
matching the pattern Kairui established in swap_cluster_alloc_table().
All allocations are fully GFP-controllable — no hidden vmap page-table
allocations, no hardcoded GFP_PGTABLE_KERNEL.

With kmem_cache, shrink is just kmem_cache_free() — each cluster is
independently allocated and freed. Seems the logic is simpler. If no
objection, I will give it a shot soon.


Thanks
Baoquan

