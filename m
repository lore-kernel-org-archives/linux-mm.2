Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81174C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:53:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870596B00A3; Thu,  9 Jul 2026 10:53:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847DF6B00A6; Thu,  9 Jul 2026 10:53:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785206B00A7; Thu,  9 Jul 2026 10:53:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51BBF6B00A3
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:53:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D620CC0797
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:53:29 +0000 (UTC)
X-FDA: 84969531738.18.D61460F
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id D8F8F140005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:53:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PwCi9JdD;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783608808;
	b=N+mMxJKi2ju4RTIKaoWXbA1kkmY5yi2dksx/NvJwv+Hl34ORR0+U0Wh+j1bdJo7vQDwWo6
	IxenNcutj6Ajar3Voph6Gwrfq1D5s/pCD5hRx93GOL0KkQ2QZmWYDHtT7MV76p+a/4WtyE
	7T9v8FC1Ip9/4TlBQZmt/isawJHFTu4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PwCi9JdD;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783608808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3V4DmKvYu5ICYDlwnJydkBOT1bVUqwjuXDcWIyId3Xw=;
	b=v3t/UNxPFBxmwc9Y60fiKtxkL/Nq7E4PJ2fYxDhBiuw60pE6r9wxxu0DhsZ9w3YqdhhnfD
	1cufPOQsbl/0jDZBR2WgbvQEfqcW0MMDhzZ7vHkPUpM5DoMMDhNandXKgwVvc+06knfO9F
	e2ZASibxdWHvAxLvEbxFT4JJ/GsOyOc=
Date: Thu, 9 Jul 2026 22:52:59 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783608806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3V4DmKvYu5ICYDlwnJydkBOT1bVUqwjuXDcWIyId3Xw=;
	b=PwCi9JdDCO1JE2fhdAuCrQ5Yd8MgYdSnLaM0++DKo40SMUJ8xFDZ4/lW0eEGfUWJwF1Iw1
	7kz1668VQL48qqGxvUEfzphjsVXWdMMhZuKoxxhJ1ZU++MMpb7AzmAcpQODgrrU5XZ41+y
	TPABNWPTj7gTVCglBswlUZDujqaCKjE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org,
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org,
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 09/10] mm/swapfile: implement swap_ghost_extend_max()
 for dynamic growth
Message-ID: <ak-1y8poqzPEhXtQ@MiWiFi-R3L-srv>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
 <20260707082614.95030-10-baoquan.he@linux.dev>
 <CAKEwX=OygNR_5iD+FbWKhMD9Z7fxU3+VOfqn48aRGqZzYF2e_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=OygNR_5iD+FbWKhMD9Z7fxU3+VOfqn48aRGqZzYF2e_g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D8F8F140005
X-Stat-Signature: 5omuypzkoh8n9dqu8uqhkpe5j3jntsc1
X-HE-Tag: 1783608807-853144
X-HE-Meta: U2FsdGVkX18XQj9I/HusvF73wAw0+dJe3zqXrZmyqHCu26gJGO06WYRD1nRdHSNDZnB5xghvCNaVMxq6L8Gogoa/FpzpcCIiFQi/1cvFd1linyF3sn9hgbnBx7dzFac1uU69FzL5I5Vh2T/zCO/b743En/XcNJs0X2qYqFq7VDCsGyS2905iGjntAGliTbRsAvEYDoxjbnoCKf8HDG3uVSh/LKUpVHKw0PzhcCRDhqVOTqvX1ee5FrYklwbd0eXS5KnVhIWArkBe/so4wYwhoPJp1RmJdN2CSKK+kbM8mLks+3yVQDFZMMHI9tZOmXygGMm57XZCyKBo2KugBanOUigKKLXuzthU/8Bp8qDIq5bm02gHEWDNFhAZ7joRxrv48vi/mpWLUMedfiwkaEqw2dF6KZagVaG9ZBikUXSNfdrD0sAl8Tn9y6r9xZHJwWgDyElvd7kQULkUMg1g3U+thaVM/PTpS+fAlW42aDKnO5YYLaTZLprbks4BEkfatuFljGAIid0yqxv4DjN13k9OTI/31fKOw1pjG2pHnj473aYiUPtUOPXaOoOhqvJG1hn1+XrzUp6oim80nlFOWPVEJeFxNVyqgivQ67645FKHILqM0q8bMpwm8gBFUtrWx6hmuK/1aFQVlCeTHhOs5HO40EXzytDK4x2Khj3LhozEBphPQrqsclqyYYBo90t8vxZWmEfF9ddOE7F6+sDxhpEp1UG5g1nOlnzdyq8FTNaCMmTor/KWnZoJ1eYoPcOag7Ckb0Rhh/3yXmQlMvkXDpBYpFWrOdb2YMuMck/NXyY7niyyDfbvcVairjZkfzTRPUdXbkMEXq3P6HRka1SsijiDcAavy1aKWFMAHpfzbFNVwuKz+HhhAvBiCOq3UaL2kYz/9Rp8JlTSwF0jrvxiLh25wJA7fdgbMg6rEjQ6MN7efa+XlC4T+UKq8IwDQoSnj02m+6WWySW4LqwmiKHc5l+
 NEM3O5cN
 ExinfLYzYjujfA6ZLsB+IpKoFfDLk73/3SLyUqKEkUJsTJl/eSs/nXkD0eDyaytJQJ5T+zJ5uLKvRx9mNX2cizdfVU3c93NJsMSRRWTn5IymSeQ8BzxWfi4CF2xo2f54UO1r+b2MG9c7aMOwCstwkbppYbGjqarPcpWapiAzaT2Fsohd4go35W8ZIG9v0qXfVbLi6YUQnGG8pBo4I/kDRdQbCGipX+o575etnoJOMLaGAIh+ZJfAcAX1BuAzCTr/4pYAZ/QZCGybN9Ay1/vNNZtEqc4NC0cZNxsDez/XuVCeew9yoaoqLMm0PLjezEK4HlXle
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/07/26 at 03:36pm, Nhat Pham wrote:
> On Tue, Jul 7, 2026 at 1:27 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > Allocate additional physical pages and map them at the end of the
> > already-reserved sparse vmalloc area via vm_area_map_pages(). The flat
> > cluster_info pointer never moves — new clusters appear contiguously at
> > higher indices. New clusters are fully initialized (spinlocks, list
> > heads, trailing BAD mask) before si->max is published via WRITE_ONCE.
> >
> > Page-pointer tracking in cluster_vm->pages is reallocated to accommodate
> > additional entries. Returns -E2BIG if the requested size exceeds the
> > reserved VA range. Extension is serialized by swapon_mutex.
> >
> > Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> > ---
> >  mm/swapfile.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 110 insertions(+)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index da085a75d7b5..8bf336678887 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -58,6 +58,8 @@ static void move_cluster(struct swap_info_struct *si,
> >                          enum swap_cluster_flags new_flags);
> >  #ifdef CONFIG_ZSWAP
> >  #define GHOST_MAX_CLUSTER_BYTES (64UL * 1024 * 1024)
> > +static int swap_ghost_extend_max(struct swap_info_struct *si,
> > +                                unsigned int new_maxpages);
> >  #endif
> >
> >  /*
> > @@ -4247,6 +4249,114 @@ swp_entry_t ghost_redirect_to_phys(struct swap_info_struct *si, pgoff_t offset)
> >
> >         return (swp_entry_t){};
> >  }
> > +
> > +/*
> > + * swap_ghost_extend_max — Extend an active ghost swap device.
> > + * @si:  ghost device (SWP_GHOST set)
> > + * @new: new max pages (> si->max)
> > + *
> > + * Allocates physical pages and maps them at the end of the reserved
> > + * sparse vmalloc area.  si->cluster_info never moves.  New clusters
> > + * are fully initialized before si->max is published via WRITE_ONCE.
> > + *
> > + * Returns 0, -ENOMEM, -EINVAL, or -E2BIG.  Caller holds swapon_mutex.
> > + */
> > +static int swap_ghost_extend_max(struct swap_info_struct *si,
> > +                                unsigned int new)
> > +{
> > +       unsigned long old_max = si->max, old_nr, new_nr;
> > +       unsigned long old_bytes, new_bytes, nr_new_pg;
> > +       struct page **new_pglist;
> > +       unsigned long i;
> > +
> > +       if (!(si->flags & SWP_GHOST) ||
> > +           !(si->flags & (SWP_USED | SWP_WRITEOK)) ||
> > +           new <= si->max)
> > +               return -EINVAL;
> > +
> > +       old_nr = DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER);
> > +       new_nr = DIV_ROUND_UP(new, SWAPFILE_CLUSTER);
> > +       old_bytes = ALIGN(old_nr * sizeof(struct swap_cluster_info), PAGE_SIZE);
> > +       new_bytes = ALIGN(new_nr * sizeof(struct swap_cluster_info), PAGE_SIZE);
> > +       nr_new_pg = (new_bytes - old_bytes) / PAGE_SIZE;
> > +
> > +       if (old_bytes + nr_new_pg * PAGE_SIZE > si->cluster_vm->size) {
> > +               pr_warn("ghost: extend to %u exceeds reserved VA (%lu bytes)\n",
> > +                       new, si->cluster_vm->size);
> > +               return -E2BIG;
> > +       }
> > +
> > +       new_pglist = kvmalloc_array(si->cluster_vm->nr_pages + nr_new_pg,
> > +                                   sizeof(struct page *), GFP_KERNEL);
> > +       if (!new_pglist)
> > +               return -ENOMEM;
> > +       if (si->cluster_vm->pages) {
> > +               memcpy(new_pglist, si->cluster_vm->pages,
> > +                      si->cluster_vm->nr_pages * sizeof(struct page *));
> > +               kvfree(si->cluster_vm->pages);
> > +       }
> > +       si->cluster_vm->pages = (void *)new_pglist;
> > +
> > +       for (i = 0; i < nr_new_pg; i++) {
> > +               struct page *page = alloc_page(GFP_KERNEL | __GFP_ZERO);
> > +               if (!page) {
> > +                       while (i-- > 0)
> > +                               __free_page(new_pglist[si->cluster_vm->nr_pages + i]);
> > +                       return -ENOMEM;
> > +               }
> > +               new_pglist[si->cluster_vm->nr_pages + i] = page;
> > +       }
> > +
> > +       if (vm_area_map_pages(si->cluster_vm,
> > +                             (unsigned long)si->cluster_vm->addr + old_bytes,
> > +                             (unsigned long)si->cluster_vm->addr + new_bytes,
> > +                             &new_pglist[si->cluster_vm->nr_pages])) {
> > +               for (i = 0; i < nr_new_pg; i++)
> > +                       __free_page(new_pglist[si->cluster_vm->nr_pages + i]);
> > +               return -ENOMEM;
> > +       }
> > +       si->cluster_vm->nr_pages += nr_new_pg;
> > +
> > +       for (i = old_nr; i < new_nr; i++) {
> > +               struct swap_cluster_info *ci = &si->cluster_info[i];
> > +               spin_lock_init(&ci->lock);
> > +               INIT_LIST_HEAD(&ci->list);
> > +       }
> > +
> > +       if (new % SWAPFILE_CLUSTER) {
> > +               unsigned long base = (new - 1) / SWAPFILE_CLUSTER *
> > +                                   SWAPFILE_CLUSTER;
> > +               unsigned long idx = base / SWAPFILE_CLUSTER;
> > +               struct swap_cluster_info *ci = &si->cluster_info[idx];
> > +
> > +               if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL)) {
> > +                       for (i = 0; i < nr_new_pg; i++)
> > +                               __free_page(new_pglist[si->cluster_vm->nr_pages + i]);
> > +                       return -ENOMEM;
> > +               }
> > +               spin_lock(&ci->lock);
> > +               for (i = new % SWAPFILE_CLUSTER; i < SWAPFILE_CLUSTER; i++)
> > +                       __swap_table_set(ci, i, SWP_TB_BAD);
> > +               spin_unlock(&ci->lock);
> > +       }
> > +
> > +       WRITE_ONCE(si->max, new);
> > +
> > +       for (i = old_nr; i < new_nr; i++) {
> > +               struct swap_cluster_info *ci = &si->cluster_info[i];
> > +               ci->flags = CLUSTER_FLAG_FREE;
> > +               spin_lock(&si->lock);
> > +               list_add_tail(&ci->list, &si->free_clusters);
> > +               spin_unlock(&si->lock);
> > +       }
> > +
> > +       si->pages += new - old_max;
> > +       atomic_long_add(new - old_max, &nr_swap_pages);
> > +       spin_lock(&swap_lock);
> > +       total_swap_pages += new - old_max;
> > +       spin_unlock(&swap_lock);
> > +       return 0;
> > +}
> >  #endif /* CONFIG_ZSWAP */
> 
> Does this only grow? Say I have a huge but temporary spike in swap
> usage, which triggers the extension of the the ghost swapfile address
> space. Do these metadata space live forever?

Yes, it is grow-only for now.  The metadata overhead of an extended
ghost device is very small: cluster_info[] costs ~32 MB per TB of
capacity.  For a 64 GB machine, 1 TB of ghost swap space costs about
0.05% of RAM in metadata.  This is not a resource that needs urgent
reclamation after a spike subsides.

If it does need to be reclaimed — for instance, after a one-time spike
pushed capacity far beyond normal needs — ghost swap supports swapoff.
The admin can swapoff the ghost device and swapon a new one at a
smaller size.  No swap type in the kernel today supports online
shrinking (not block devices, not swapfiles, not zram), so this is the
standard mechanism.

Shrinking would require migrating active swap entries out of the
evacuated range — swap entry migration infrastructure that does not
exist in the kernel today.  Implementing it solely to reclaim a few MB
of metadata after a capacity spike does not seem like a good
cost/benefit trade-off.  If there is a concrete use case that requires
online shrinking, we can discuss adding it as follow-up work.

Thanks
Baoquan

> 
> If that's the case, might as well just swapon...?

