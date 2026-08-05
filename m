Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86ECFC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 08:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76F4B6B00B0; Wed,  5 Aug 2026 04:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746D96B00B7; Wed,  5 Aug 2026 04:08:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7C86B00B8; Wed,  5 Aug 2026 04:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3AF436B00B0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:08:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AFF97A02BE
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:08:47 +0000 (UTC)
X-FDA: 85066489494.22.E5A5890
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	by imf29.hostedemail.com (Postfix) with ESMTP id 695DD120002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:08:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HjR4yllr;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785917324;
	b=ntpPsGzoWBzSYae0O8fNeVwg9RD7O5Ozr/s3uzM7hy02Cvz255GImNdwufnA476PSloKzK
	LzkzJgXe0OLsNdgV9TnKuw8ZbhqL48jH+VAR4hovodC/OD4opHKNfrKL4x0BN3TN2k4C3X
	DrfLNn/tMW+6i9FxzDChfnvHTBRNuVA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HjR4yllr;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785917324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNTYfYPWVn5gO8iCYhFkdTqm48nYcVoAs5BXPHIVpNE=;
	b=bu5/wt84z/ZAV/U5Xv4oJHDkM6Xo47yzpapFMH/DrkelzN+SVblhLfZ05GabAHWkAmZ8B2
	sl/kIgI/mDh1pURln3zaD8Aa6J0k/vtclN04daKx4AkxGvLz9q2KdWepzMeSzaniP8jzpe
	slsGdqSGVTEeb1eROrDdsyVFvRmYIwA=
Date: Wed, 5 Aug 2026 16:08:31 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785917319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VNTYfYPWVn5gO8iCYhFkdTqm48nYcVoAs5BXPHIVpNE=;
	b=HjR4yllrAeLtrzLaCEHuwj8pyey5QsbSq+OeatUB6oWNw/Ta0F9V9B4BkD0nkHHaiiaSIC
	cpkSwFbFWYq0N/KhocsSTBH0VDXwa2NF2HZs7/fiTpAst61oLPfhZ6aClnrGJRXPVEAT4q
	DyC/toxXkKZgBtoofiiZnIGB0WoTzbo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>, chrisl@kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com,
	baohua@kernel.org, youngjun.park@lge.com, hannes@cmpxchg.org,
	yosry@kernel.org, david@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 03/11] mm, swap: add xswap cluster grow via VM_SPARSE
 vmalloc
Message-ID: <anLvfyS3S_uc6OYx@MiWiFi-R3L-srv>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev>
 <20260727140503.1060918-2-baoquan.he@linux.dev>
 <CAKEwX=Pe+qMZd2xhnU-PAGQtgXkp56c-JwYCbt2Lux9htgB67Q@mail.gmail.com>
 <amoYawUn3y2eFbPS@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amoYawUn3y2eFbPS@MiWiFi-R3L-srv>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 695DD120002
X-Stat-Signature: u9dxheaeirqh5kb4ijpnnsj8qrx7jwej
X-Rspam-User: 
X-HE-Tag: 1785917324-613811
X-HE-Meta: U2FsdGVkX192y/yW9SdrOnCBjodJIQVLHyGT43t2KXYQENVxRJ8zteXG63tGiDUO8MTmVWjhKygAhXwtdyoPdM41t3QVRFy8c4PJs6myQGeWVjfl8g20pjYEYdn3VTyzOsksw6awJtYyeWR7FewD1KsD+YvYkovShB7fgLFzh/rjW4Mif5Zj3XNqFOuRoIT3pe1IoEJYiwiMnflxqRIfomPjw5yOWX5U7ER1Fk6/ABPPlMWJG1Gx1Ivh4mEgUxsbgdWjzuy4JCFBAOgw9nUUUZOQ61HDmenfK8KxRT/DC2JGpoOfHJ3sEP2fTjwf7Jkkb1s3vXidik/Bs9xvlNrh41JhXNO28qGrm2Wy97SAPWt1E6IiJGGQGd8hYT7mGtYmA4GLpynhoMiqJ9dpjhrwltGJw1/v16dEFAuSbctfVfvUFGWZtMdSQr9aU+wwHda6lznumntDjxK8tLi2ccMYsxlsQmbF4qoQI9DWQdf9QzUxDNj8dRB29mc1sqNtAVS3rqXUuz9ayY4lajiKb+/GCl6BWlVl31Vg1fI9m+/KUR9g/HDQ35Tqtiie+rriL8OKpluXAHd3tay0u0SIlOLtdfUkxE8b9e66Ll4GCqxn5AjuwuwJL342Rxkzb8Ddd5Bx7rppLq4Vgjr2XhrcXe5To6IYlZTrc7AwWzDeAXRnF9unxRNzlnu9feu4+cpQ3KyAfrBSzvaEQbKVFhG+lETwVujspAWN00fLfIf6hcOnZ4wsYiVcd3TO0VckMNB/IUFWDRiDtq4Sd3s9JjGRpn/7hPOQA7yrN3pfTKAzPVNSIwbFlqTgMqtiJyR0GqvhjkvzVdTwFeSITvOca0YYYuhWGAO1zejlcvgMZr2Fb7qyAT3ESyiz902/9eqpzv6O+fnYYkyzGN39KRAEpKXLAuz+SwT6jGT3ThTD2dJv3aWxhDjsqVd62X1MfubUjy6wkmz1inrklE9IBATv4H1Fyfm
 Cr9XhzHX
 P19bDlp4uzUHOSG7+eIilBDp6/q9MECbMNPPgAwjycs27zVzNbqfVCss+qctrsj+bNLDMC4mUf3ApFxQGCALFGV57CxonL/BB7DnSuM9DaLSz196lT9iQOjL3Ps8zdlx7qx2r+QnT9xgKXg2X+Q+zio2uELz8mj/xMmab1WiltTC1TvalPplEf7YcjLKw7gyVxcWJDrr3iujtELsmOBGhCNM/rEzag9IZMty+Xtg9XahhlZsZDhGxf6p3mGMEGVPBJreG1ZJmuAuIx93fU0uzxVKUUOTgDHH9eobBurEgcWz1//FDB/dzkM666VaNSgSoAhZh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/29/26 at 11:12pm, Baoquan He wrote:
> On 07/27/26 at 08:05am, Nhat Pham wrote:
> > On Mon, Jul 27, 2026 at 7:05 AM Baoquan He <baoquan.he@linux.dev> wrote:
...snip...
> > > +#ifdef CONFIG_XSWAP
> > > +static int xswap_map_clusters(struct swap_info_struct *si,
> > > +                             unsigned long start_idx, unsigned long nr)
> > > +{
> > > +       unsigned long start_addr = (unsigned long)si->cluster_info +
> > > +                                  (size_t)start_idx * sizeof(struct swap_cluster_info);
> > > +       unsigned long end_addr = start_addr + (size_t)nr * sizeof(struct swap_cluster_info);
> > > +       /*
> > > +        * vm_area_map_pages() requires that start and end be page-aligned.
> > > +        * If start_addr falls within a page that was already mapped by a
> > > +        * previous batch (grow path), round it up to skip the already-mapped
> > > +        * partial page.  Always round end_addr up so the vmap page table walk
> > > +        * terminates correctly (the walk loop exits when addr == end, and addr
> > > +        * advances by PAGE_SIZE each iteration).
> > > +        */
> > > +       unsigned long vm_start = PAGE_ALIGN(start_addr);
> > > +       unsigned long vm_end = PAGE_ALIGN(end_addr);
> > > +       unsigned long npages;
> > > +       struct page **pages;
> > > +       unsigned long i;
> > > +
> > > +       if (vm_start >= vm_end) {
> > > +               /* All requested clusters fall within already-mapped pages. */
> > > +               for (i = start_idx; i < start_idx + nr; i++)
> > > +                       spin_lock_init(&si->cluster_info[i].lock);
> > > +               WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
> > > +               return 0;
> > > +       }
> > > +
> > > +       npages = (vm_end - vm_start) >> PAGE_SHIFT;
> > > +
> > > +       pages = kmalloc_array(npages, sizeof(*pages), GFP_KERNEL);
> > > +       if (!pages)
> > > +               return -ENOMEM;
> > > +
> > > +       for (i = 0; i < npages; i++) {
> > > +               /*
> > > +                * __GFP_ZERO is critical: cluster_info structs contain pointer
> > > +                * fields (extend_table, zero_bitmap, memcg_table, table) that
> > > +                * must start as NULL.  Without zeroing, stale data from a
> > > +                * previous user of the page would look like valid pointers.
> > > +                */
> > > +               pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
> > > +               if (!pages[i])
> > > +                       goto fail;
> > > +       }
> > > +
> > > +       if (vm_area_map_pages(si->cluster_vm, vm_start, vm_end, pages)) {
> > > +               i = npages; /* free all pages on failure */
> > > +               goto fail;
> > 
> > I was evaluating whether your vmalloc array can be extended to support
> > kernel-driven dynamic growth at least (either as a slot-in replacement
> > for xarray, or as a follow-up optimization if it's too complicated),
> > and I stumble this mapping action.
> > 
> > Seems like it does not take any GFP flag argument, and under the hood
> > it calls GFP_KERNEL. Would this be safe in the swap allocation path
> > (where you slotted it in in patch 4)? Kairui used a more precise set
> > of flags in this path, for e.g for swap table allocation:
> > 
> > ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
> >    GFP_KERNEL);
> > 
> > 
> > I'm guessing this has to do with the fact that we often entered
> > swapping out paths with PF_MEMALLOC... Is there any risk of deadlock
> > etc.?

Hi Chris,

I gave the kmem_cache approach a try, but ended up keeping VM_SPARSE.
The kmem_cache approach has two structural problems:

1. With individually kmem_cache_alloc()'d clusters, ci - si->cluster_info
   no longer works — cluster_info is a pointer array, not a contiguous
   array.  Each struct swap_cluster_info would need a new field to store
   its own index. VM_SPARSE preserves the contiguous array layout, so
   ci - si->cluster_info continues to work for O(1) index lookup everywhere.

2. The struct swap_cluster_info ** pointer array itself costs extra
   memory: 8 bytes per cluster.  That's 8 KB for a 1 GB swap device,
   and 8 MB for a 1 TB device — paid upfront at swapon, regardless of
   how many clusters are actually used.  VM_SPARSE needs no such
   indirection array; the cluster_info is addressed directly through
   the vmalloc area.

By comparison, the introduced change in struct swap_cluster_info isn't
that great.

How the GFP concern is addressed
--------------------------------
Hi Nhat,

You were right about the three layers of hardcoded GFP_KERNEL in v1.
In the current code (the version I'll post as RFC v2), each is fixed:

1. alloc_page() and kmalloc_array() now use:

     __GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL

   This matches the pattern Kairui established in
   swap_cluster_alloc_table().  __GFP_NOMEMALLOC prevents the
   pfmemalloc reserve bypass during reclaim.

2. The internal page-table allocations inside vmap_pages_range()
   use GFP_PGTABLE_KERNEL and are not directly controllable from
   the caller.  To prevent these from recursing into swap reclaim,
   the entire allocation block is wrapped with:

     noreclaim_flags = memalloc_noreclaim_save();
     ... alloc_page / kmalloc_array / vm_area_map_pages ...
     memalloc_noreclaim_restore(noreclaim_flags);

   memalloc_noreclaim_save() ensures __GFP_FS and __GFP_IO are
   cleared for all allocations within the scope, so the page-table
   allocation cannot recurse into filesystem or swap reclaim.

3. The residual risk is that the page-table allocations still lack
   __GFP_NOMEMALLOC, meaning they could theoretically dip into
   emergency reserves under PF_MEMALLOC.  However, each grow
   operation maps at most one PTE page (XSWAP_GROW_CLUSTERS
   clusters per page), so the total order-0 allocation is tiny —
   typically a single page-table page.  This seems acceptable
   compared to the complexity of plumbing a GFP parameter through
   the entire vmap_pages_range() call chain.

A variant vm_area_map_pages_gfp that passes the caller's GFP context
down to the page-table allocations. That cleanly solves the problem
for all VM_SPARSE users, not just xswap.  I'm happy to work on that
if people think it's the right direction, but I'd prefer to keep it
as a separate improvement rather than blocking this series on it.

The shrink path also avoids this problem entirely: it runs in a
workqueue context where PF_MEMALLOC is never set, so GFP_KERNEL
is correct there.

Thanks
Baoquan

> 
> Thanks for catching this.  You're right — there are actually three
> layers of hardcoded GFP_KERNEL in the VM_SPARSE path:
> 
> 1. alloc_page(GFP_KERNEL | __GFP_ZERO) in xswap_map_clusters() for the
> backing pages
> 2. vmap_pages_range() hardcodes GFP_KERNEL (passed only to KMSAN, but
> still semantically wrong)
> 3. The page-table allocations inside vmap_pages_range_noflush_walk()
> (pte_alloc_kernel_track etc.) use GFP_PGTABLE_KERNEL, which is
> GFP_KERNEL | __GFP_ZERO — also lacking __GFP_NOMEMALLOC, and
> completely invisible to the caller
> 
> When PF_MEMALLOC is set (as it is during reclaim), __gfp_pfmemalloc_flags()
> returns ALLOC_NO_WATERMARKS for any allocation without __GFP_NOMEMALLOC,
> meaning those allocations can consume all emergency reserves — including
> the reserves that the reclaim machinery itself needs to make forward
> progress.  That is a real deadlock risk.
> 
> One way is to fix them one by one. Another way is to drop the VM_SPARSE
> approach entirely and implemented Chris's suggestion instead: cluster_info
> is now a struct swap_cluster_info ** pointer array, with each cluster
> individually kmem_cache_zalloc()'d. The grow path (xswap_grow_clusters)
> now uses:
> 
> kmem_cache_zalloc(swap_cluster_cachep,
>         __GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL)
> matching the pattern Kairui established in swap_cluster_alloc_table().
> All allocations are fully GFP-controllable — no hidden vmap page-table
> allocations, no hardcoded GFP_PGTABLE_KERNEL.
> 
> With kmem_cache, shrink is just kmem_cache_free() — each cluster is
> independently allocated and freed. Seems the logic is simpler. If no
> objection, I will give it a shot soon.
> 
> 
> Thanks
> Baoquan

