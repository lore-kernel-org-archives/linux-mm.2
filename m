Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB42CC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:36:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42236B0103; Wed, 29 Jul 2026 10:36:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3A66B0105; Wed, 29 Jul 2026 10:36:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1D46B0106; Wed, 29 Jul 2026 10:36:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 653FF6B0103
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:36:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE83C1206CB
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:36:50 +0000 (UTC)
X-FDA: 85042065780.17.4492AEE
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 73B04100010
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:36:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="MIC2U8/1";
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785335808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0I9nKHn/A1RS7al455BEcnRTRDEmeHd2vd9dCfmqmo=;
	b=A7QLbIkxEEquyCUKNC05wBw5i9m8TTB5SRCX+GGYcGG3SPEh9998r1lLbHdv4BA4zRkKp7
	4dc+VAE5DKl1oqz8+PMQcshR2rwJA+OvTr342+MbubJQsOOrJAhY1kdZiwwdWQ2x9A2Gq+
	m9mKEuZID+R6rDEOiPaJaPrWhqNmEjM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="MIC2U8/1";
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785335808;
	b=Ojs6njh9dDlMPeWVsV9zLktD0jXVRfJ1vFG/ALioILSXfqO29cZq4FYgIehPUesjXbHE4n
	mkDMV7f1U+YnJq15twBhTNNWEWiTUfdSQO4L9wffDQLC/Kf1gTrw/ezCSa1kmks3gEVvZD
	i2Hp+yL3N01WAxUjhQPgkyZ1UIiYeWk=
Date: Wed, 29 Jul 2026 22:36:36 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785335806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+0I9nKHn/A1RS7al455BEcnRTRDEmeHd2vd9dCfmqmo=;
	b=MIC2U8/1U81Avzlk+3iMgMysCfemlqBPq9g7Oq1bfSU9WLW4NBWShg7/C62hwEdvF7uXzo
	Uz2e8qRYy/E/EEGwwkxg9fo3JPs1ILtOhIDAHj6uby6/U1o343MFSvQa8OHvjuakb3zAaR
	wfPb2jt+4rpjLdHcBzxqA7XjINWJfQg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, nphamcs@gmail.com,
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com,
	hannes@cmpxchg.org, yosry@kernel.org, david@kernel.org,
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 03/11] mm, swap: add xswap cluster grow via VM_SPARSE
 vmalloc
Message-ID: <amoP9JM9VT8Fib7G@MiWiFi-R3L-srv>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev>
 <20260727140503.1060918-2-baoquan.he@linux.dev>
 <CACePvbXUPy+scSsGW3Peh3zMJYDyN5NrLOcT8j8vufXqMKxJbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbXUPy+scSsGW3Peh3zMJYDyN5NrLOcT8j8vufXqMKxJbA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 73B04100010
X-Rspamd-Server: rspam01
X-Stat-Signature: 9cztzhj7oex4o93ghdhm1kcw6es8hiew
X-HE-Tag: 1785335808-727034
X-HE-Meta: U2FsdGVkX1+WwPuNN3IH9l3/nyxf53ZH0Gc3uNCixWcNO0mFWFvTYn0b2bRfO1j4U6i0tqRe36HTEgAGcI+M8cQIXct4+cPtfr3XBwsc+HD/l+PCuj9RopGKCWW5ngsgPm5drHJYE5goFkXjLu5p7XhxOlfSHugDPkX8h2qYSYluqwltK5f1YsJfq/ISYs8OWgzlQXrYyzD6jXvR0pOuIMO+mQ1LYivd7FZ3DjJTA4Gv+l+sMlLxQAfHd2KS8xXXDIQGB1r8zO7y42LjONZ/hWEAZUeJ+XeVVQ7IrTRdjHRn22iXlDDVYUBQIzeYnN2qNHUHhOhkHSNCQwN5r+bEEUScUZwvXtnfNcCRNt94OUGkuIAXyGLD7L0fDZfH04TApmOaie+vmJuqN6CFHEEKHZT/Ct05pDRDU10NYYfEvj2/whMvdJJ41TYxSREguS0sXjMBh/xmf2c7NhtZTM2LvD5mS4YWX0QJp33SrgMkfFvbh3+/LM2aaIH0b9FoRgl3/nyI7pJVYi9SFBMEBfK758hzAhoOXJilwdXkCvNEmlu60sKIzTX4m3zawA68SH1IxFlGIEQaubCl/hHd6pmcTzn9HvyBXZf403sVM8C+552YAmAV2fXLmV/jkQwF/ktaCv9h2+Rx6ezr37L7QafSEd+rc6P6+16ycrk7NVDiZVLCZyM5NHT6C1C34Cx/GMy4OGlKl7sNydesZ7e0waFOP9hrHWs3VBd86zYtrWAm/MBCi7AXIj7ydAXIcVQlXWhzoCwOOe6Z9774o0OMi8g5pkVQh6ksjqTPpnOmlBKfOPec4Hr5B690KI57WwhG60YDEIrsh5l/TWid1PdeUZoLU0Mu07k8n2ydVvaLm3rq3MYh7BTNfhJf3gFJ3dYLUEtbL5lmQne8MNj0adG2aCHdVQiy54eUqYN7f2ramag+GuB5Ph+x0b5nF/sT1lDGnif8Si66/EyXPVLrrSSSqsx
 G0lDAh9g
 6BijlFVXfDFI4X0vfmfHgxwXfKwghmSAclBFHC61JECmrKEAGbNQ5ZDuh8e1JJuNPk2ZtvK4k5VNMx2r/9DRqmO8b35fPP8DoRzq4KbHksz5v3HL0qn7NYWfnPCKUfNHRfHyZkABLhKH7AjukkiJSg3SbvCQid86udH3x0hLlsXx34h4nE8kBFNExNKWiINnVTiaDk99J9le2QMlgr49/Q06EHaDeGIzMfx2BaGRpFuvWF8Yh4wPfkoger2SvdXyillTJdNxavB7mAvuap4g/6KlK2G+i6/r3dETLWNdYLqiB1YmMraaWk/iKzimpJmhp50Mm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/27/26 at 09:09am, Chris Li wrote:
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
> 
> I feel that we should provide more generic support for dynamically
> growing an array of element size A to size N. Cluster array is just a
> user of such an API. There might be more users. This patch hardcodes
> the map/umpa of clusters. What about other users of such a dynamic
> array?
> Another consideration is that the map/unmap logic, while more generic,
> adds quite a bit of complexity to an approach intended only for
> growth. Any reason we want map/unmap rathern than simple grow from the
> current si->max?

That's because vmalloc virtual area need be allocated in advance. 

> 
> I read a bit more about the patch. It seems you need the unmap for the
> error cleanup path. In that case I suspect just make cluster a
> kmem_cache allocation, cluster array just a pointer. The cluster
> pointer array should just grow, not shrink. That might be overall
> simpler.
> I'm worried someone might abuse the cluster unmap causing unwanted side effects.
> 
> I see the other reason might be you want the cluster code to be
> exactly the same when XSWAP is off. For that I think it is acceptiale
> to turn cluster into kmem_cache allocated and cluster array as
> pointers array as seperate patch as the base even when XSWAP is not
> configed.

I think about your suggestion carefully. Instead of VM_SPARSE,
cluster_info is now struct swap_cluster_info ** — a pointer array
that only grows, never shrinks. Individual clusters are kmem_cache_zalloc()'d
on demand and kmem_cache_free()'d during shrink.  This completely
eliminates the VM_SPARSE vmap/unmap complexity and, more importantly,
gives us full control over GFP flags (__GFP_NOMEMALLOC) to avoid
dipping into emergency reserves from reclaim context. The data structure
would look like below:

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 80c83dd8804f..dbb94686ca7c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -247,7 +247,7 @@ struct swap_info_struct {
        struct plist_node list;         /* entry in swap_active_head */
        signed char     type;           /* strange name for an index */
        unsigned int    max;            /* size of this swap device */
-       struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
+       struct swap_cluster_info **cluster_info; /* cluster pointer array */
        struct list_head free_clusters; /* free clusters list */
        struct list_head full_clusters; /* full clusters list */
        struct list_head nonfull_clusters[SWAP_NR_ORDERS];
@@ -277,6 +277,11 @@ struct swap_info_struct {
        struct list_head discard_clusters; /* discard clusters list */
        struct plist_node avail_list;   /* entry in swap_avail_head */
        const struct swap_ops *ops;
+#ifdef CONFIG_XSWAP
+       unsigned long nr_clusters;      /* total cluster count for xswap */
+       unsigned long nr_clusters_mapped; /* currently mapped cluster count */
+#endif
 };


diff --git a/mm/swap.h b/mm/swap.h
index abd26588abd2..f32dea150f76 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -62,6 +62,7 @@ struct swap_cluster_info {
        unsigned long *zero_bitmap;
 #endif
        struct list_head list;
+       unsigned int idx;               /* index in si->cluster_info pointer array */
 };

@@ -402,7 +411,7 @@ static inline bool cluster_is_usable(struct swap_cluster_info *ci, int order)
 static inline unsigned int cluster_index(struct swap_info_struct *si,
                                         struct swap_cluster_info *ci)
 {
-       return ci - si->cluster_info;
+       return ci->idx;
 }

The pattern itself is very simple — allocate pointer array via kvmalloc_array,
allocate elements via kmem_cache_zalloc, free elements via kmem_cache_free,
never shrink the pointer array — so extraction should be straightforward. Seems
this is doable and code change will be simpler than VM_SPARSE way. If
this is agreed on, I can try to make a v2 in that way.

Thanks
Baoquan

> 
> 
> > Signed-off-by: Baoquan He <baoquan.he@linux.dev>
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
> > +       }
> > +
> > +       kfree(pages);
> > +
> > +       /* Initialize spinlocks for newly mapped clusters */
> > +       for (i = start_idx; i < start_idx + nr; i++)
> > +               spin_lock_init(&si->cluster_info[i].lock);
> > +
> > +       /*
> > +        * Pairs with READ_ONCE() in shrink/grow paths.
> > +        */
> > +       WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
> > +       return 0;
> > +
> > +fail:
> > +       while (i > 0) {
> > +               i--;
> > +               if (pages[i])
> > +                       __free_page(pages[i]);
> > +       }
> > +       kfree(pages);
> > +       return -ENOMEM;
> > +}
> > +
> > +static void xswap_unmap_clusters(struct swap_info_struct *si,
> > +                                unsigned long start_idx, unsigned long nr)
> > +{
> > +       unsigned long start_addr = (unsigned long)si->cluster_info +
> > +                                  (size_t)start_idx * sizeof(struct swap_cluster_info);
> > +       unsigned long end_addr = start_addr + (size_t)nr * sizeof(struct swap_cluster_info);
> > +       /*
> > +        * Round to page boundaries: start up (skip partial page that may
> > +        * contain clusters still in use before start_idx), end up so the
> > +        * entire range is covered.  vm_area_unmap_pages() operates on
> > +        * whole pages.
> > +        */
> > +       unsigned long vm_start = PAGE_ALIGN(start_addr);
> > +       unsigned long vm_end = PAGE_ALIGN(end_addr);
> > +
> > +       if (vm_start >= vm_end)
> > +               goto out;
> > +
> > +       vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
> > +       /*
> > +        * vm_area_unmap_pages() only clears PTEs; it does not free the
> > +        * physical pages.  Walk the page table to find and free them.
> > +        */
> > +       /* TODO: free backing pages via page table walk or tracking bitmap */
> > +       /*
> > +        * Pairs with READ_ONCE() in shrink/grow paths.
> > +        */
> > +       out:
> > +       WRITE_ONCE(si->nr_clusters_mapped, start_idx);
> > +}
> > +#endif /* CONFIG_XSWAP */
> > +
> >  static int setup_swap_clusters_info(struct swap_info_struct *si,
> >                                     union swap_header *swap_header,
> >                                     unsigned long maxpages)
> > @@ -3573,6 +3720,63 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
> >         int err = -ENOMEM;
> >         unsigned long i;
> >
> > +#ifdef CONFIG_XSWAP
> > +       if (si->flags & SWP_XSWAP) {
> > +               unsigned long size = PAGE_ALIGN(nr_clusters * sizeof(*cluster_info));
> > +               struct vm_struct *vm;
> > +
> > +               vm = get_vm_area(size, VM_SPARSE);
> > +               if (!vm)
> > +                       goto err;
> > +
> > +               cluster_info = vm->addr;
> > +               si->cluster_vm = vm;
> > +               si->nr_clusters = nr_clusters;
> > +               si->cluster_info = cluster_info;
> > +
> > +               /* Map the initial chunk (at least cluster 0) */
> > +               if (xswap_map_clusters(si, 0, min_t(unsigned long,
> > +                                       XSWAP_GROW_CLUSTERS, nr_clusters)))
> > +                       goto err_free_vm;
> > +
> > +               /* xswap: only cluster 0 slot 0 is bad */
> > +               err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
> > +               if (err)
> > +                       goto err_unmap;
> > +
> > +               INIT_LIST_HEAD(&si->free_clusters);
> > +               INIT_LIST_HEAD(&si->full_clusters);
> > +               INIT_LIST_HEAD(&si->discard_clusters);
> > +               for (i = 0; i < SWAP_NR_ORDERS; i++) {
> > +                       INIT_LIST_HEAD(&si->nonfull_clusters[i]);
> > +                       INIT_LIST_HEAD(&si->frag_clusters[i]);
> > +               }
> > +
> > +               /* Mark mapped clusters: cluster 0 has 1 bad slot, rest free */
> > +               for (i = 0; i < si->nr_clusters_mapped; i++) {
> > +                       struct swap_cluster_info *ci = &cluster_info[i];
> > +
> > +                       if (i == 0) {
> > +                               ci->flags = CLUSTER_FLAG_NONFULL;
> > +                               list_add_tail(&ci->list, &si->nonfull_clusters[0]);
> > +                       } else {
> > +                               ci->flags = CLUSTER_FLAG_FREE;
> > +                               list_add_tail(&ci->list, &si->free_clusters);
> > +                       }
> > +               }
> > +
> > +               return 0;
> > +
> > +err_unmap:
> > +               xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
> > +err_free_vm:
> > +               free_vm_area(si->cluster_vm);
> > +               si->cluster_vm = NULL;
> > +               si->cluster_info = NULL;
> > +               return err;
> > +       }
> > +#endif /* CONFIG_XSWAP */
> > +
> >         cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
> >         if (!cluster_info)
> >                 goto err;
> > @@ -3640,7 +3844,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
> >         si->cluster_info = cluster_info;
> >         return 0;
> >  err:
> > -       free_swap_cluster_info(cluster_info, maxpages);
> > +       free_swap_cluster_info(si);
> >         return err;
> >  }
> >
> > @@ -3852,7 +4056,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
> >         si->global_cluster = NULL;
> >         inode = NULL;
> >         destroy_swap_extents(si, swap_file);
> > -       free_swap_cluster_info(si->cluster_info, si->max);
> > +       free_swap_cluster_info(si);
> >         si->cluster_info = NULL;
> >         /*
> >          * Clear the SWP_USED flag after all resources are freed so
> > --
> > 2.54.0
> >

