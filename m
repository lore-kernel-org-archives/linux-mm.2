Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA843C9830E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 01:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31DBB6B0088; Sun, 27 Sep 2026 21:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3E36B008A; Sun, 27 Sep 2026 21:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E39A6B008C; Sun, 27 Sep 2026 21:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF5FA6B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 21:32:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA392120B1A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:32:56 +0000 (UTC)
X-FDA: 85261447152.18.A52FBB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 04870120005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:32:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hu2Z0aUM;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790559175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4TzlysRbSLxMJJGtFXRGA5uc2Vf08632rG8/TIVLUY=;
	b=oYKSjYR42ZSgAFjjTpc3XFXjb+B8dqnB8mbvLTFw5JUkhhF/HnfdHs/APKuTkss/rK/+Wd
	JJm9lpsXRiUVexKkjn/x9DeDelgQerT+yrJPaI/pf/NMGo33Lb2arbL8CqtT5ChQReG3UE
	wrYXi8uczh6C8ilHhItkEzYtirznfq8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790559175;
	b=nPh9ANvj0BGNUnoGu1CDWfdqKlKox8GXV2M7bHsLKKDg6B16lyOr/Ybw8nUJgdAQAfCC31
	/EU9mIVLzyjj6AL+uH9xsrdaDQuwFm2KMCIKxS5J3vouwJB0+9oocQyiFJTluffGwQ+Gwq
	UEnSUWRBhBcaIJ628OfDmIa1LHNk71o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hu2Z0aUM;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C9216022A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB731F0089E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790559174;
	bh=M4TzlysRbSLxMJJGtFXRGA5uc2Vf08632rG8/TIVLUY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Hu2Z0aUMfHnIzXKnp/RCiDH3mg3VSpcf01KYR4IHijbmUE1s2mBYdXpxCu/lzYXmv
	 NgbucFlbHUAUQgzp+1B8pOtXWce1n1ktod/DxHJ2AaEE6UYahQpLF/XUh2amph/Fvf
	 kPG1WlxMc4nMzjXYUE4TMYy7CzDret+IG32HHEcXUpskmI2TMaMnOwIWnQzTNMkm45
	 kRsvOdmOOs2w39XFh3jTIKXN5G0uhu1WdsvJNG7q7bLRGii/cOTc+xIhdx/MBycoWZ
	 fy5jRJFObJijWy0+034/lZZub31hjQPPqm1hGWNgTwTNxXORBV2zB4DoRIXObVThH9
	 PhgH1RnAe8naQ==
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6aaf10bf094so2911205a12.2
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:32:54 -0700 (PDT)
X-Gm-Message-State: AFq9FYIcGfslglIvDtDssy9Z7n07jPfiNl8MFldNeQ7CRhEmMU8eaMRj
	zP0/1MJb1QufvET/8wrCNUeIgP+Sf+ihO0nww793beP+srZLPlEEBlMflwh2RVX9Ryll2lXdcTa
	Br7jRq7OWJt7p8xnruOztT76JQ1JZAM4olVZhD9l0ig==
X-Received: by 2002:a05:6402:43c9:b0:6ab:eb3e:ef5a with SMTP id
 4fb4d7f45d1cf-6abeb3ef73dmr2709178a12.37.1790559172871; Sun, 27 Sep 2026
 18:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <20260916101929.149106-5-hebaoquan@kylinos.cn>
In-Reply-To: <20260916101929.149106-5-hebaoquan@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 15:32:39 -1000
X-Gmail-Original-Message-ID: <CACePvbV8VL7aGsEvsnWW+WTBz_pTp0R01hn_2NRRNKyghyq=0g@mail.gmail.com>
X-Gm-Features: AclHuK-sf7nD_Jq5U5qabydRkLVe6bvgK1iqYsc_ZtW76E9WQG271nbPrgL9FLI
Message-ID: <CACePvbV8VL7aGsEvsnWW+WTBz_pTp0R01hn_2NRRNKyghyq=0g@mail.gmail.com>
Subject: Re: [PATCH v3 04/14] mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 04870120005
X-Stat-Signature: zuf476zn6o5p3qzxswwi167cg47c55ax
X-HE-Tag: 1790559174-754851
X-HE-Meta: U2FsdGVkX1+HEubpsnWhWBDQoDyIeGlvvXBTQebo85dmAjmtF0rsttpZkCw8M4B+jZwYqy8bir/pv062H5O2L8zvUhKjRa4SSDod/2myM+UfdY9UBNNgaG1zJg7uIW0Q4a02abHxfA2VSDEAkxzCVsuoKmXL0h/jV7WhFkWnrYRUXI/xZY+9mFE7Cl8aOJNVkAjLnk4KXtkZKtqLSQT29Lsfip8d5rbxyuY1UZsmbp5RMUCUDy19shuzhfYkvUpKjSNz9Wt1L4LfgLqBuujxl6rzFf2b0geRGld6I6STk6o9a7VTAF+f13XxjP5Lj2BjVEfOjoyeUEADf3nx2BK/m++7UzMQyp7speNllMAy0grnn3M1dmCVGPoFxlb3c4u2lNFbLK2mj6VLEz/4RngGKPAina31ERpkGnKnxi5x2mzRHWoGh+l3VckJjnZRSOj93vrT9WZw3CX1WQZntvTVb7NQFZuoIt9MnfEO3g2JDSt9y/tvEPV/+JQjqkcRxCRXIfkhKvyxaRoA6/fS889EnL15K5SvPUS94nbB/vSV2sHHBUwQWSK563FhF7hYdIZR40x1WEvi9MMpPF969m6joq5qGEzg+HmjjfdFWqAw8kv6qloc6pcI9Z1/rs9eoEbQ6/GAamcFxOyBmyYnGNHKQJxEZ+VLfbKlxI3/CpRGxsDBC/RegODCjmW9ioNkXBdfYrR4iwC2PEORmnf1qk/GaKivi20bqdioFU/noGMN+XbY62yWamImjcsYq+vyH0MnQ2tQBxsgRhbbrKpiDd099kF3mic8JmJ+i43Vs5o75D9ygE+vSCmTWbd9J1Y9Q5e9MuJzsmwwkV4yaJ2IllZZ4EZD0a9618jsJj/NofWSFf1693FHPhKfdq4661HyqODrnqEE7OufmV7xTnCSWEYDU1I2dnk0ufahIFYomb1orml+4DwqAYn2J9ztsYtsRWr2FWbgwsndKuqJCsp52t/
 s0Y2Q4xv
 crOYatj3fBNVKtvG1CABISvEy+cQErT1W9IoqJMqEDtV2QhyIwY/LPWUz/PwBoeyJthW2Zt1YoI2GO7ygbeFqtPeYnpuhlTCxK7ijkPaAJ66tsH6/ezkC8gXHgThgneBVoy1LlUxox/YmxbSLfEpvOKQp6mfq0EpqIhmz9AIDKAo6lFtNizzM4tzxFlglbTAmb8A1pafZ3XabGilClzAMX2XM7ziK0U4gtvCj4lEhnzBlqGeS0bAh9ziClAKYDslMClmAQm2JNXYLEuW7An/hqJ9/sCWMUb7I/5aEKQ2y17yYH/ZpM/ZtigsfPM4ordwlTwBgCCkfct/svyS5Pv/8SupIGM8TbAWJ4Tb8TNF105Za1eowO2JcytNTx1IrNdQGTF5tfoiERS/PSVPNoddsNN9aFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:20=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> =
wrote:
>
> Back the cluster_info array with a sparse vmalloc area that is populated
> lazily in chunks: pages are allocated and mapped as swap usage grows, and
> unmapped again on error/teardown. Only an initial chunk is mapped at
> device setup, and all accesses are bounded to the mapped range.
>
> A per-device mutex serializes the map/unmap operations, and the grow path
> rejects stale ranges and cleans up partial mappings on failure.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  include/linux/swap.h |   1 +
>  mm/swapfile.c        | 321 +++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 313 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index b7882aac1eab..8c62a53667bb 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -246,6 +246,7 @@ struct swap_info_struct {
>         struct vm_struct        *cluster_vm;    /* VM_SPARSE area for clu=
ster_info */
>         unsigned long           nr_clusters_max;/* total clusters in the =
xswap address space */
>         unsigned long           nr_clusters_mapped; /* currently mapped c=
luster count */
> +       struct mutex            xswap_lock;     /* serialize map/unmap op=
erations */
>  #endif
>         struct list_head free_clusters; /* free clusters list */
>         struct list_head full_clusters; /* full clusters list */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4b260f9760ac..dac5e0db0e94 100644
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
> +       max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info)=
, 16)
> +
> +static int xswap_map_clusters(struct swap_info_struct *si,
> +                             unsigned long start_idx, unsigned long nr);
> +static void xswap_unmap_clusters(struct swap_info_struct *si,
> +                                unsigned long start_idx, unsigned long n=
r);
> +static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
> +#endif
> +
>  static void swap_range_alloc(struct swap_info_struct *si,
>                              unsigned int nr_entries);
>  static bool folio_swapcache_freeable(struct folio *folio);
> @@ -2797,10 +2816,24 @@ static unsigned int find_next_to_unuse(struct swa=
p_info_struct *si,
>                                         unsigned int prev)
>  {
>         struct swap_cluster_info *ci;
> -       unsigned long i, end;
> +       unsigned long i, cluster_end, end;
>         unsigned int ci_off;
>         unsigned long swp_tb;
>
> +       end =3D si->max;
> +#ifdef CONFIG_XSWAP
> +       /* xswap may have shrunk and unmapped the cluster_info tail. */
> +       if (si->flags & SWP_XSWAP) {
> +               unsigned long mapped_end;
> +
> +               /* Pairs with the smp_store_release() in xswap_map_cluste=
rs(). */
> +               mapped_end =3D smp_load_acquire(&si->nr_clusters_mapped) =
*
> +                            SWAPFILE_CLUSTER;
> +               if (mapped_end < end)
> +                       end =3D mapped_end;
> +       }
> +#endif
I want to explore is it cleaner to moving this xswap specific thing
into swap_ops.
Then swap core just callt swap_ops if the device has this ops implemented.
That way, most of the xswap specific code can live in the xswap.c
rather than the swapfile.c

> +
>         /*
>          * No need for swap_lock here: we're just looking
>          * for whether an entry is in use, not modifying it; false
> @@ -2808,11 +2841,11 @@ static unsigned int find_next_to_unuse(struct swa=
p_info_struct *si,
>          * allocations from this area (while holding swap_lock).
>          */
>         i =3D prev + 1;
> -       while (i < si->max) {
> +       while (i < end) {
>                 ci =3D __swap_offset_to_cluster(si, i);
> -               end =3D min_t(unsigned long,
> -                           ALIGN_DOWN(i, SWAPFILE_CLUSTER) + SWAPFILE_CL=
USTER,
> -                           si->max);
> +               cluster_end =3D min_t(unsigned long,
> +                                   ALIGN_DOWN(i, SWAPFILE_CLUSTER) + SWA=
PFILE_CLUSTER,
> +                                   end);
>
>                 /*
>                  * An empty cluster has no slot in use, so skip it whole.
> @@ -2822,13 +2855,13 @@ static unsigned int find_next_to_unuse(struct swa=
p_info_struct *si,
>                  * enough, unlike in every other cluster_is_empty() calle=
r.
>                  */
>                 if (!READ_ONCE(ci->count)) {
> -                       i =3D end;
> +                       i =3D cluster_end;
>                         cond_resched();
>                         continue;
>                 }
>
>                 ci_off =3D i % SWAPFILE_CLUSTER;
> -               for (; i < end; ci_off++, i++) {
> +               for (; i < cluster_end; ci_off++, i++) {
>                         swp_tb =3D swap_table_get(ci, ci_off);
>                         if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp=
_tb))
>                                 return i;
> @@ -2838,7 +2871,6 @@ static unsigned int find_next_to_unuse(struct swap_=
info_struct *si,
>
>         return 0;
>  }
> -
>  static int try_to_unuse(unsigned int type)
>  {
>         struct mm_struct *prev_mm;
> @@ -3136,6 +3168,17 @@ static void wait_for_allocation(struct swap_info_s=
truct *si)
>
>         BUG_ON(si->flags & SWP_WRITEOK);
>
> +#ifdef CONFIG_XSWAP
> +       if (si->flags & SWP_XSWAP) {

Maybe this is another swap_ops oppertunity?

> +               /*
> +                * Skip the shrinker-unmapped tail; pairs with the
> +                * smp_store_release() in xswap_map_clusters().
> +                */
> +               end =3D min(end, smp_load_acquire(&si->nr_clusters_mapped=
) *
> +                         SWAPFILE_CLUSTER);
> +       }
> +#endif
> +
>         for (offset =3D 0; offset < end; offset +=3D SWAPFILE_CLUSTER) {
>                 ci =3D swap_cluster_lock(si, offset);
>                 swap_cluster_unlock(ci);
> @@ -3147,11 +3190,41 @@ static void free_swap_cluster_info(struct swap_in=
fo_struct *si)
>         struct swap_cluster_info *cluster_info =3D si->cluster_info;
>         unsigned long maxpages =3D si->max;
>         struct swap_cluster_info *ci;
> -       int i, nr_clusters;
> +       unsigned long i, nr_clusters;
>
>         if (!cluster_info)
>                 return;
>
> +#ifdef CONFIG_XSWAP
> +       if (si->flags & SWP_XSWAP) {

Another swap_ops for unmapping clusters?

> +               unsigned long nr_mapped;
> +
> +               /*
> +                * Cluster 0 keeps the bad header slot, so it never empti=
es
> +                * and __free_cluster() never frees its table.
> +                */
> +               /* Pairs with the smp_store_release() in xswap_map_cluste=
rs(). */
> +               nr_mapped =3D smp_load_acquire(&si->nr_clusters_mapped);
> +               for (i =3D 0; i < nr_mapped; i++) {
> +                       ci =3D &cluster_info[i];
> +                       spin_lock(&ci->lock);
> +                       if (cluster_table_is_alloced(ci)) {
> +                               swap_cluster_assert_empty(ci, 0, SWAPFILE=
_CLUSTER, true);
> +                               swap_cluster_free_table(ci);
> +                       }
> +                       spin_unlock(&ci->lock);
> +               }
> +               /* Unmap all mapped clusters and free the VM_SPARSE area =
*/
> +               if (si->nr_clusters_mapped > 0)
> +                       xswap_unmap_clusters(si, 0, si->nr_clusters_mappe=
d);
> +               free_vm_area(si->cluster_vm);
> +               si->cluster_vm =3D NULL;
> +               si->cluster_info =3D NULL;
> +               si->nr_clusters_mapped =3D 0;
> +               return;
> +       }
> +#endif
> +
>         nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
>         for (i =3D 0; i < nr_clusters; i++) {
>                 ci =3D cluster_info + i;
> @@ -3649,6 +3722,173 @@ static unsigned long read_swap_header(struct swap=
_info_struct *si,
>         return maxpages;
>  }
>
> +#ifdef CONFIG_XSWAP
> +static int xswap_map_clusters(struct swap_info_struct *si,
> +                             unsigned long start_idx, unsigned long nr)

Yet another swap_ops for mapping clusters. Just an idea for thought.

> +{
> +       unsigned long start_addr =3D (unsigned long)si->cluster_info +
> +                                  (size_t)start_idx * sizeof(struct swap=
_cluster_info);
> +       unsigned long end_addr =3D start_addr + (size_t)nr * sizeof(struc=
t swap_cluster_info);
> +       unsigned long vm_start =3D PAGE_ALIGN(start_addr);
> +       unsigned long vm_end =3D PAGE_ALIGN(end_addr);
> +       unsigned int noreclaim_flags;
> +       unsigned long mapped_end;
> +       unsigned long npages;
> +       struct page **pages;
> +       unsigned long i;
> +       int err;
> +
> +       mutex_lock(&si->xswap_lock);
> +
> +       /* Refuse a stale range: the boundary moved since the caller read=
 it. */
> +       if (start_idx !=3D READ_ONCE(si->nr_clusters_mapped)) {
> +               mutex_unlock(&si->xswap_lock);
> +               return -EAGAIN;
> +       }
> +       if (start_idx + nr > si->nr_clusters_max) {
> +               mutex_unlock(&si->xswap_lock);
> +               return -EAGAIN;
> +       }
> +
> +       /*
> +        * Page-granular mapping can cover clusters past the previous chu=
nk.
> +        * Find the already-mapped prefix and map only the rest.
> +        */
> +       mapped_end =3D vm_start;
> +       if (vm_start < vm_end)
> +               apply_to_existing_page_range(&init_mm, vm_start,
> +                                            vm_end - vm_start,
> +                                            xswap_mapped_end, &mapped_en=
d);
> +       if (vm_start >=3D vm_end || mapped_end =3D=3D vm_end)
> +               goto mapped;
> +       vm_start =3D mapped_end;
> +
> +       npages =3D (vm_end - vm_start) >> PAGE_SHIFT;
> +
> +       /* Prevent recursive reclaim during vmap page table allocation. *=
/
> +       noreclaim_flags =3D memalloc_noreclaim_save();
> +
> +       pages =3D kmalloc_array(npages, sizeof(*pages),
> +                             __GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL)=
;
> +       if (!pages) {
> +               memalloc_noreclaim_restore(noreclaim_flags);
> +               mutex_unlock(&si->xswap_lock);
> +               return -ENOMEM;
> +       }
> +
> +       for (i =3D 0; i < npages; i++) {
> +               /* __GFP_ZERO: cluster_info pointer fields must start NUL=
L. */
> +               pages[i] =3D alloc_page(__GFP_HIGH | __GFP_NOMEMALLOC |
> +                                     GFP_KERNEL | __GFP_ZERO);
> +               if (!pages[i])
> +                       goto fail;
> +       }
> +
> +       err =3D vm_area_map_pages(si->cluster_vm, vm_start, vm_end, pages=
);
> +       if (err) {
> +               /*
> +                * -EBUSY means the range is already mapped; xswap_lock s=
hould
> +                * prevent it.  Fail instead of recording a mapping whose
> +                * cluster locks were not initialized.
> +                */
> +               if (err =3D=3D -EBUSY) {
> +                       WARN_ON_ONCE(1);
> +                       i =3D npages;
> +                       goto fail_nounmap;
> +               }
> +               i =3D npages;
> +               goto fail;
> +       }
> +
> +       for (i =3D start_idx; i < start_idx + nr; i++)
> +               spin_lock_init(&si->cluster_info[i].lock);
> +
> +       kfree(pages);
> +       memalloc_noreclaim_restore(noreclaim_flags);
> +
> +       /*
> +        * Publish the new mappings and cluster lock initialization befor=
e
> +        * the count; walkers without xswap_lock use smp_load_acquire().
> +        */
> +       smp_store_release(&si->nr_clusters_mapped, start_idx + nr);
> +       mutex_unlock(&si->xswap_lock);
> +       return 0;
> +
> +mapped:
> +       for (i =3D start_idx; i < start_idx + nr; i++)
> +               spin_lock_init(&si->cluster_info[i].lock);
> +
> +       /* Publish the advanced count. */
> +       smp_store_release(&si->nr_clusters_mapped, start_idx + nr);
> +       mutex_unlock(&si->xswap_lock);
> +       return 0;
> +
> +fail_nounmap:
> +       /*
> +        * The mapping was not recorded: free our pages and fail so the
> +        * caller does not touch cluster_info for the range.
> +        */
> +       while (i > 0) {
> +               i--;
> +               if (pages[i])
> +                       __free_page(pages[i]);
> +       }
> +       kfree(pages);
> +       memalloc_noreclaim_restore(noreclaim_flags);
> +       mutex_unlock(&si->xswap_lock);
> +       return -EBUSY;
> +
> +fail:
> +       /* Clear PTEs vm_area_map_pages() may have left before freeing pa=
ges. */
> +       vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
> +       while (i > 0) {
> +               i--;
> +               if (pages[i])
> +                       __free_page(pages[i]);
> +       }
> +       memalloc_noreclaim_restore(noreclaim_flags);
> +       kfree(pages);
> +       mutex_unlock(&si->xswap_lock);
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
> +       unsigned long vm_start =3D PAGE_ALIGN(start_addr);
> +       unsigned long vm_end =3D PAGE_ALIGN(end_addr);
> +
> +       mutex_lock(&si->xswap_lock);
> +
> +       if (vm_start >=3D vm_end) {
> +               WRITE_ONCE(si->nr_clusters_mapped, start_idx);
> +               mutex_unlock(&si->xswap_lock);
> +               return;
> +       }
> +
> +       vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
> +       /* vm_area_unmap_pages() clears PTEs but does not free pages. */
> +       /* TODO: free backing pages via page table walk or tracking bitma=
p */
> +
> +       WRITE_ONCE(si->nr_clusters_mapped, start_idx);
> +       mutex_unlock(&si->xswap_lock);
> +}
> +
> +/* Track the end of the run of pages that is already mapped. */
> +static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data)
> +{
> +       unsigned long *mapped_end =3D data;
> +
> +       if (!pte_present(ptep_get(pte)))
> +               return 0;
> +       *mapped_end =3D addr + PAGE_SIZE;
> +       return 0;
> +}
> +#endif /* CONFIG_XSWAP */
> +
>  static int setup_swap_clusters_info(struct swap_info_struct *si,
>                                     union swap_header *swap_header,
>                                     unsigned long maxpages)
> @@ -3658,6 +3898,69 @@ static int setup_swap_clusters_info(struct swap_in=
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
> +               si->nr_clusters_max =3D nr_clusters;
> +               si->cluster_info =3D cluster_info;
> +
> +               /* Must be initialized before xswap_map_clusters() locks =
it. */
> +               mutex_init(&si->xswap_lock);
> +
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

It seems there is code duplication with the normal cluster info setup.
Please try to deduplicate them. Isolate the common setup. e.g. Cluster
list init should definitely be one of them. Then we have a function to
initialize one cluster and xswap can reuse those functions. Again
xswap can have some swap_ops for setup device info as well.

Chris

