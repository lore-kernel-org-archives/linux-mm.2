Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3692C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AB876B008C; Mon, 27 Jul 2026 12:09:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9838F6B0093; Mon, 27 Jul 2026 12:09:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872956B0095; Mon, 27 Jul 2026 12:09:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 572CA6B008C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:09:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1D34400B0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:09:46 +0000 (UTC)
X-FDA: 85035042372.08.E4A23BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id D2E9340012
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:09:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KimNyRM4;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785168585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8hZvw5BCIzYKAyqtxUyPN3SrUFKcu2k1vmkZ0mHjj4=;
	b=Zp+kI2sBiButDGtWEBweMd7INt5QRYKfMXEGegJNUo5HDMmoEEglLA9iUuNd6MnAv1yR03
	NrVrRq7Wxxf5GteC2y/Ymm9r0TH+xjlHso0b/4rt3mwqMR3Njm1l6eDuTMX43zHrR+ZwKa
	PAabfhOzXPTkjRHIlf7jtKjpO7S4HlU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KimNyRM4;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785168585;
	b=eMbUhWWJKayMrtnDfy7X7fe/13oM4NH0En0ASi/MGe6TkyCPIk0gXHJSD0TsvqlYFzc2B+
	NUQWxQ6f3q5GVlaKZC6P4WISHUfJRTStru1tRrmhqB2uh5PdY+PSZzJ+HVUiAvoJEPvNLd
	h0lOCtFHeX11g1lrwVvT0PCA2+NXpz0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FA83405B7
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D401F00A3E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785168584;
	bh=R8hZvw5BCIzYKAyqtxUyPN3SrUFKcu2k1vmkZ0mHjj4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KimNyRM4V01hErM9GKKu8BjFrbkCyerEplyrVhwh71DAvjlsj1exGYFdnO4+aer0s
	 BCpe5emTNdGn0/HPJ02ZxbLRMClZweJIshKBn8r/Cg+vZa/4+RpTbvCahojfvTEqN/
	 Qm9qPr/OQOdFEFONjthDmX/xHcpFlh4z0Sq3+IjoOjpWnqToTRvm9GNngplWdtAO17
	 s1NKLjhLGvomj6QSbMZvVUZenvF0w9LjWvz+2ctRwLVMmwkPbiuS2jfWclszCqKLWM
	 oRmLsfviKzqHhkpG9ezr7C6c0atnfU3YmOKFRzWaNMLwrPo8XXccIb/UUWI/i/rI72
	 VOAs3LOlQyOwA==
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-66893db7bccso3720917d50.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:09:43 -0700 (PDT)
X-Gm-Message-State: AOJu0YwIHvvPe2HSmXuZqGGDh/l3tPeDZ6iaLVUqdDbXeEExFS9n5Llq
	7+4Gvhg3oV4GHE6R4u99k8rgdTm2VRqIk8+PkmpKzsiFiV9/TMK/YIWu+trQMHh8NhorxMFtorL
	t9eTtsIMQHcvAPB9fLr/GAF5plK9rjGKDXVanzh0xag==
X-Received: by 2002:a05:690e:69b:b0:668:99c7:2ba8 with SMTP id
 956f58d0204a3-668c7afeae4mr2150295d50.62.1785168583148; Mon, 27 Jul 2026
 09:09:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev> <20260727140503.1060918-2-baoquan.he@linux.dev>
In-Reply-To: <20260727140503.1060918-2-baoquan.he@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 27 Jul 2026 09:09:30 -0700
X-Gmail-Original-Message-ID: <CACePvbXUPy+scSsGW3Peh3zMJYDyN5NrLOcT8j8vufXqMKxJbA@mail.gmail.com>
X-Gm-Features: AUfX_mzKPpvM8hyWX1BpQ5Qne-tj_INPKAliVfzs7ZD9HUn6eE4NOmSn3IGAkWQ
Message-ID: <CACePvbXUPy+scSsGW3Peh3zMJYDyN5NrLOcT8j8vufXqMKxJbA@mail.gmail.com>
Subject: Re: [RFC PATCH 03/11] mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, nphamcs@gmail.com, 
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, david@kernel.org, 
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: D2E9340012
X-Rspamd-Server: rspam01
X-Stat-Signature: usnzro7xc5h6ut8nrugptr56arj8nu7b
X-HE-Tag: 1785168584-501397
X-HE-Meta: U2FsdGVkX18LSaxKvuaIxmAnERPWPEU2uDZARn6aN8TP3FlvFDI9W/5hzWT4cWwwIP179oRa5R5MlFzH2wPjynvAJNDZZhuQXVJxkVJs579XGl19zcDKrvlW8c44CRDNrADqLo5Yh0uUzAmHY2tryeeeygT1v7EZBh5ok/D4WGEnP9cNDOafONDesQNMfeI9WYWfUdGPG44+EPx58PUtfvIGghiK/3oUFavo0EUJHNhhpx+Xf7oG5fqqTqyAx4y8JVLy+ae52o9WI8tUlAPAXGej1XCqKUlXndvuogWPVM2CK+tMr5zUqhOgFWV40kplZb8U9+A/RTjllgl+rIpJOvO06t0SzD2zVIOMz+weL/yx+VLMCCB/E4SnqsG+kTjSBAmqx9QO7HgJkGRPePcEqwytz0LfPtl6I5rQBK2yE4gI4RW+P68ME8fLdn/1U8w9QaWoEst3LpEucPVhB4NOL4iOC8FFj4wwj+6U/LfOswfwHLmjHXH8PhDKlxNXdDF5SbJvrQ3zd9YY8CQyj9vOrtLx2wTxaYlqjyKQZ0w6k3Dm93hmxoWlZtnwc0f9VzmsEDJ8CKKeacaTcIDOAY/ENIW+ohU1utiJeRZSvaHZDYimGBuF28ZWRdKuf6t+YStoWYugyTlJpFkSwlmXD40TkFnYB84rB870+DNtQ4en1Yq8txSeNHABiW/AQPBNpOS4SHdltBXBkAP4kgG/WChVLdYbMxk8aHdgfowhGJV7iPki7KexezBg8q2cL9m0K7b10fyIgovbdcJy2HPb5oa2fiI3Ed5xEI+HMLCC2ciRKh4CEQjvDbRnzYlBbeLbdRreoQ9V44l8pMaaJ/SdJPrSLnVMKyh0PuZP/hx/DjaG87m3FXDDcmLLvk5Bin/nqLi1DSALm+ppGLRpVdDFYCl2Ji7BriKXzYtj5KJDDqhQ2QgY9cAILjSaj0YAS7lJ2GtobV4vfqvRlYYmD+e+y65
 B9TswiK1
 /2liWKiXS+O3wGxcnDLb3XMHeUlqv4JE8s8To9Byx33SiZTN2u7G0I8uz478ZPWGLYMIJ/GB0LvCF94AujXGg78oxZ1jpMYZMhlKESgVX0pEjI8xUrfCDexhf4ni/NJfjKd8cj66pAxMzBJFF6+tw9VoKwckF45mFiyj6WOmg9iwNhmXeDghiBnse3i1WzlqCILyWq3nFPxsF4danZxsiWt1Hl2Ozx1YQW0XTCfn2TwYijj0V5OenxNrye05k/ADksM66r3bHl3Cs6GxK6JitQtZFhXrNyK6LH9+LZpd0RWY8mmOS2neepM08j3m9zFOlG/cr8H1s4rfVHDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 7:05=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
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
> 4. free_swap_cluster_info(): Refactor to take swap_info_struct*.
>    For xswap, unmap all clusters and free_vm_area().
>
> 5. swapoff: Remove snapshot locals; move p->max/p->cluster_info
>    clearing after free_swap_cluster_info().

I feel that we should provide more generic support for dynamically
growing an array of element size A to size N. Cluster array is just a
user of such an API. There might be more users. This patch hardcodes
the map/umpa of clusters. What about other users of such a dynamic
array?
Another consideration is that the map/unmap logic, while more generic,
adds quite a bit of complexity to an approach intended only for
growth. Any reason we want map/unmap rathern than simple grow from the
current si->max?

I read a bit more about the patch. It seems you need the unmap for the
error cleanup path. In that case I suspect just make cluster a
kmem_cache allocation, cluster array just a pointer. The cluster
pointer array should just grow, not shrink. That might be overall
simpler.
I'm worried someone might abuse the cluster unmap causing unwanted side eff=
ects.

I see the other reason might be you want the cluster code to be
exactly the same when XSWAP is off. For that I think it is acceptiale
to turn cluster into kmem_cache allocated and cluster array as
pointers array as seperate patch as the base even when XSWAP is not
configed.

Chris


> Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> ---
>  mm/swapfile.c | 228 +++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 216 insertions(+), 12 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 143088dae07d..6d9c95ed09bd 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -49,6 +49,24 @@
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
> +       max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info)=
, 16)
> +
> +static int xswap_map_clusters(struct swap_info_struct *si,
> +                             unsigned long start_idx, unsigned long nr);
> +static void xswap_unmap_clusters(struct swap_info_struct *si,
> +                                unsigned long start_idx, unsigned long n=
r);
> +#endif
> +
>  static void swap_range_alloc(struct swap_info_struct *si,
>                              unsigned int nr_entries);
>  static bool folio_swapcache_freeable(struct folio *folio);
> @@ -3041,20 +3059,47 @@ static void wait_for_allocation(struct swap_info_=
struct *si)
>
>         BUG_ON(si->flags & SWP_WRITEOK);
>
> +#ifdef CONFIG_XSWAP
> +       /*
> +        * xswap clusters beyond nr_clusters_mapped have been unmapped
> +        * by the shrinker and their vmalloc pages are no longer
> +        * accessible.  Only iterate over currently mapped clusters.
> +        */
> +       if (si->flags & SWP_XSWAP)
> +               end =3D min(end, READ_ONCE(si->nr_clusters_mapped) *
> +                         SWAPFILE_CLUSTER);
> +#endif
> +
>         for (offset =3D 0; offset < end; offset +=3D SWAPFILE_CLUSTER) {
>                 ci =3D swap_cluster_lock(si, offset);
>                 swap_cluster_unlock(ci);
>         }
>  }
>
> -static void free_swap_cluster_info(struct swap_cluster_info *cluster_inf=
o,
> -                                  unsigned long maxpages)
> +static void free_swap_cluster_info(struct swap_info_struct *si)
>  {
> +       struct swap_cluster_info *cluster_info =3D si->cluster_info;
> +       unsigned long maxpages =3D si->max;
>         struct swap_cluster_info *ci;
> -       int i, nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
> +       int i, nr_clusters;
>
>         if (!cluster_info)
>                 return;
> +
> +#ifdef CONFIG_XSWAP
> +       if (si->flags & SWP_XSWAP) {
> +               /* Unmap all mapped clusters and free the VM_SPARSE area =
*/
> +               if (si->nr_clusters_mapped > 0)
> +                       xswap_unmap_clusters(si, 0, si->nr_clusters_mappe=
d);
> +               free_vm_area(si->cluster_vm);
> +               si->cluster_vm =3D NULL;
> +               si->nr_clusters =3D 0;
> +               si->nr_clusters_mapped =3D 0;
> +               return;
> +       }
> +#endif
> +
> +       nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
>         for (i =3D 0; i < nr_clusters; i++) {
>                 ci =3D cluster_info + i;
>                 /* Cluster with bad marks count will have a remaining tab=
le */
> @@ -3093,11 +3138,9 @@ static void flush_percpu_swap_cluster(struct swap_=
info_struct *si)
>  SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  {
>         struct swap_info_struct *p =3D NULL;
> -       struct swap_cluster_info *cluster_info;
>         struct file *swap_file, *victim;
>         struct address_space *mapping;
>         struct inode *inode;
> -       unsigned int maxpages;
>         int err, found =3D 0;
>
>         if (!capable(CAP_SYS_ADMIN))
> @@ -3189,10 +3232,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spec=
ialfile)
>
>         swap_file =3D p->swap_file;
>         p->swap_file =3D NULL;
> -       maxpages =3D p->max;
> -       cluster_info =3D p->cluster_info;
> -       p->max =3D 0;
> -       p->cluster_info =3D NULL;
>         spin_unlock(&p->lock);
>         spin_unlock(&swap_lock);
>         arch_swap_invalidate_area(p->type);
> @@ -3200,7 +3239,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         mutex_unlock(&swapon_mutex);
>         kfree(p->global_cluster);
>         p->global_cluster =3D NULL;
> -       free_swap_cluster_info(cluster_info, maxpages);
> +       free_swap_cluster_info(p);
> +       p->max =3D 0;
> +       p->cluster_info =3D NULL;
>
>         inode =3D mapping->host;
>
> @@ -3564,6 +3605,112 @@ static unsigned long read_swap_header(struct swap=
_info_struct *si,
>         return maxpages;
>  }
>
> +#ifdef CONFIG_XSWAP
> +static int xswap_map_clusters(struct swap_info_struct *si,
> +                             unsigned long start_idx, unsigned long nr)
> +{
> +       unsigned long start_addr =3D (unsigned long)si->cluster_info +
> +                                  (size_t)start_idx * sizeof(struct swap=
_cluster_info);
> +       unsigned long end_addr =3D start_addr + (size_t)nr * sizeof(struc=
t swap_cluster_info);
> +       /*
> +        * vm_area_map_pages() requires that start and end be page-aligne=
d.
> +        * If start_addr falls within a page that was already mapped by a
> +        * previous batch (grow path), round it up to skip the already-ma=
pped
> +        * partial page.  Always round end_addr up so the vmap page table=
 walk
> +        * terminates correctly (the walk loop exits when addr =3D=3D end=
, and addr
> +        * advances by PAGE_SIZE each iteration).
> +        */
> +       unsigned long vm_start =3D PAGE_ALIGN(start_addr);
> +       unsigned long vm_end =3D PAGE_ALIGN(end_addr);
> +       unsigned long npages;
> +       struct page **pages;
> +       unsigned long i;
> +
> +       if (vm_start >=3D vm_end) {
> +               /* All requested clusters fall within already-mapped page=
s. */
> +               for (i =3D start_idx; i < start_idx + nr; i++)
> +                       spin_lock_init(&si->cluster_info[i].lock);
> +               WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
> +               return 0;
> +       }
> +
> +       npages =3D (vm_end - vm_start) >> PAGE_SHIFT;
> +
> +       pages =3D kmalloc_array(npages, sizeof(*pages), GFP_KERNEL);
> +       if (!pages)
> +               return -ENOMEM;
> +
> +       for (i =3D 0; i < npages; i++) {
> +               /*
> +                * __GFP_ZERO is critical: cluster_info structs contain p=
ointer
> +                * fields (extend_table, zero_bitmap, memcg_table, table)=
 that
> +                * must start as NULL.  Without zeroing, stale data from =
a
> +                * previous user of the page would look like valid pointe=
rs.
> +                */
> +               pages[i] =3D alloc_page(GFP_KERNEL | __GFP_ZERO);
> +               if (!pages[i])
> +                       goto fail;
> +       }
> +
> +       if (vm_area_map_pages(si->cluster_vm, vm_start, vm_end, pages)) {
> +               i =3D npages; /* free all pages on failure */
> +               goto fail;
> +       }
> +
> +       kfree(pages);
> +
> +       /* Initialize spinlocks for newly mapped clusters */
> +       for (i =3D start_idx; i < start_idx + nr; i++)
> +               spin_lock_init(&si->cluster_info[i].lock);
> +
> +       /*
> +        * Pairs with READ_ONCE() in shrink/grow paths.
> +        */
> +       WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
> +       return 0;
> +
> +fail:
> +       while (i > 0) {
> +               i--;
> +               if (pages[i])
> +                       __free_page(pages[i]);
> +       }
> +       kfree(pages);
> +       return -ENOMEM;
> +}
> +
> +static void xswap_unmap_clusters(struct swap_info_struct *si,
> +                                unsigned long start_idx, unsigned long n=
r)
> +{
> +       unsigned long start_addr =3D (unsigned long)si->cluster_info +
> +                                  (size_t)start_idx * sizeof(struct swap=
_cluster_info);
> +       unsigned long end_addr =3D start_addr + (size_t)nr * sizeof(struc=
t swap_cluster_info);
> +       /*
> +        * Round to page boundaries: start up (skip partial page that may
> +        * contain clusters still in use before start_idx), end up so the
> +        * entire range is covered.  vm_area_unmap_pages() operates on
> +        * whole pages.
> +        */
> +       unsigned long vm_start =3D PAGE_ALIGN(start_addr);
> +       unsigned long vm_end =3D PAGE_ALIGN(end_addr);
> +
> +       if (vm_start >=3D vm_end)
> +               goto out;
> +
> +       vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
> +       /*
> +        * vm_area_unmap_pages() only clears PTEs; it does not free the
> +        * physical pages.  Walk the page table to find and free them.
> +        */
> +       /* TODO: free backing pages via page table walk or tracking bitma=
p */
> +       /*
> +        * Pairs with READ_ONCE() in shrink/grow paths.
> +        */
> +       out:
> +       WRITE_ONCE(si->nr_clusters_mapped, start_idx);
> +}
> +#endif /* CONFIG_XSWAP */
> +
>  static int setup_swap_clusters_info(struct swap_info_struct *si,
>                                     union swap_header *swap_header,
>                                     unsigned long maxpages)
> @@ -3573,6 +3720,63 @@ static int setup_swap_clusters_info(struct swap_in=
fo_struct *si,
>         int err =3D -ENOMEM;
>         unsigned long i;
>
> +#ifdef CONFIG_XSWAP
> +       if (si->flags & SWP_XSWAP) {
> +               unsigned long size =3D PAGE_ALIGN(nr_clusters * sizeof(*c=
luster_info));
> +               struct vm_struct *vm;
> +
> +               vm =3D get_vm_area(size, VM_SPARSE);
> +               if (!vm)
> +                       goto err;
> +
> +               cluster_info =3D vm->addr;
> +               si->cluster_vm =3D vm;
> +               si->nr_clusters =3D nr_clusters;
> +               si->cluster_info =3D cluster_info;
> +
> +               /* Map the initial chunk (at least cluster 0) */
> +               if (xswap_map_clusters(si, 0, min_t(unsigned long,
> +                                       XSWAP_GROW_CLUSTERS, nr_clusters)=
))
> +                       goto err_free_vm;
> +
> +               /* xswap: only cluster 0 slot 0 is bad */
> +               err =3D swap_cluster_setup_bad_slot(si, cluster_info, 0, =
false);
> +               if (err)
> +                       goto err_unmap;
> +
> +               INIT_LIST_HEAD(&si->free_clusters);
> +               INIT_LIST_HEAD(&si->full_clusters);
> +               INIT_LIST_HEAD(&si->discard_clusters);
> +               for (i =3D 0; i < SWAP_NR_ORDERS; i++) {
> +                       INIT_LIST_HEAD(&si->nonfull_clusters[i]);
> +                       INIT_LIST_HEAD(&si->frag_clusters[i]);
> +               }
> +
> +               /* Mark mapped clusters: cluster 0 has 1 bad slot, rest f=
ree */
> +               for (i =3D 0; i < si->nr_clusters_mapped; i++) {
> +                       struct swap_cluster_info *ci =3D &cluster_info[i]=
;
> +
> +                       if (i =3D=3D 0) {
> +                               ci->flags =3D CLUSTER_FLAG_NONFULL;
> +                               list_add_tail(&ci->list, &si->nonfull_clu=
sters[0]);
> +                       } else {
> +                               ci->flags =3D CLUSTER_FLAG_FREE;
> +                               list_add_tail(&ci->list, &si->free_cluste=
rs);
> +                       }
> +               }
> +
> +               return 0;
> +
> +err_unmap:
> +               xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
> +err_free_vm:
> +               free_vm_area(si->cluster_vm);
> +               si->cluster_vm =3D NULL;
> +               si->cluster_info =3D NULL;
> +               return err;
> +       }
> +#endif /* CONFIG_XSWAP */
> +
>         cluster_info =3D kvzalloc_objs(*cluster_info, nr_clusters);
>         if (!cluster_info)
>                 goto err;
> @@ -3640,7 +3844,7 @@ static int setup_swap_clusters_info(struct swap_inf=
o_struct *si,
>         si->cluster_info =3D cluster_info;
>         return 0;
>  err:
> -       free_swap_cluster_info(cluster_info, maxpages);
> +       free_swap_cluster_info(si);
>         return err;
>  }
>
> @@ -3852,7 +4056,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>         si->global_cluster =3D NULL;
>         inode =3D NULL;
>         destroy_swap_extents(si, swap_file);
> -       free_swap_cluster_info(si->cluster_info, si->max);
> +       free_swap_cluster_info(si);
>         si->cluster_info =3D NULL;
>         /*
>          * Clear the SWP_USED flag after all resources are freed so
> --
> 2.54.0
>

