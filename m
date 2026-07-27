Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02BC4C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09406B007B; Mon, 27 Jul 2026 11:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE0E96B00C2; Mon, 27 Jul 2026 11:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7B16B00D7; Mon, 27 Jul 2026 11:05:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FC1E6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:05:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF74740788
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:05:40 +0000 (UTC)
X-FDA: 85034880840.28.6080BDC
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1258740007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:05:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LbU3FrU3;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785164739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K4Qz9i47mt1/XqvHs5lPOX9/Y1Q97QNY8XuhmKXC13k=;
	b=WRxoHKDeIbcRErZ5p7Z7Z2N/Lo5Kon92RedOBiVrXaUU9bwuJ4PvovFxv5wNyUGyJlk/fH
	WMPpCa+6pMPEJEuFhDap35I9gkzMSbUa+1BFVzOCwnwPyme4n11JHibj8Z+I14hlaZr7jA
	C4zzgefXuaY4frDHhV3/gawkgpeN1K0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785164739;
	b=BGPwArUpnTRn0ptFizkuiN7SAnvRFUouVHuS9mOZAODOaq7bnqgXeeV+rzn3FAh8jE/dIW
	m9ubvOoAQUwMos9V+GpFeXEnV8/Uyzbx4hKSa4tFE4uTk+NJrCV8h4HVb5EpQr6EpnouVV
	9Qqmtn6YoqMbHJ7LIq3M8eReNvzJgJY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LbU3FrU3;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso19349705e9.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:05:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785164737; cv=none;
        d=google.com; s=arc-20260327;
        b=nRxAOGnelbeLOdo1IOLktHqpPLrEQfcAty+RXXADJ5/P5z8nvBNZKbOLkwY9VfTnT4
         6T3mV/81mW03cESVarmCYlD7MvKOPxgDsmkwHg7TppHpnCH1wFSapb4vawu2YdQIRbB6
         8krhL/kD+ma8MAUmTLuELw1XqW1BQnugfwRO51B8pJMc9XrV9mSrPlcEHY1sNbBEVtjG
         eXj35IFbpTrvgejr9dHYexFO9lhnffF8SWf4uOZ6wrCzXYyGWbanL1Hwj9nImlfUbO21
         mrpZg+c2VeqRiRhwf79Tt9rDaKqFG5u3YXi1JLa6L+LT4vm5/fENnnEoXW3GuL33Qw81
         fxOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K4Qz9i47mt1/XqvHs5lPOX9/Y1Q97QNY8XuhmKXC13k=;
        fh=8XrvDq9ieM5Z8DKkNaqXCuIJMDO3DtmjupLh6pGzwJY=;
        b=shBwww5NGL3Wo1EAAdxk8mjcng+TpL3OcjD4X9cqVLkwyNb3kYswaDZOCeO6Hk68Jh
         RORi9VbS4/lhjgwrhGMZb7mQuivqZLGAKsqEKH5tb2dItaCGWrUDzsWrMkvrXyDmQE/4
         KhSGikN5bYGYXd2hEDIZbJDcXQHGHoOe4OQlSZWb3yafCLXE9YL+KZbZwr5SCDCWH2ST
         3uDFXQY4IP49WCjbYufG9JSGETltRKZA8/qJVv5DtuR3kyM/CUmGWjxL6zLJZWC2p3U9
         R+3Urqdx1hQAZfrHDHFaDBQaBTrR5n1ST9JD3ZYax6sS/VM4qwX8eRbXXm4zac9PaAsQ
         wkEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785164737; x=1785769537; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K4Qz9i47mt1/XqvHs5lPOX9/Y1Q97QNY8XuhmKXC13k=;
        b=LbU3FrU3/HlG0KXrednRP3GMZIpeWp7TumaozRgmc+Tkik1ddWagLiQUrIdNfD5S7+
         ERfUJFXdsnvnnOArYkTBNXoYh5vHrTQrK3t53438NnKExeG7V9y9vSMk44wFOQ3Yz7bE
         svvY68uTaxGpUDh/0mG1+LNd2MEQkNiPK4tahXf6He16pH6UbJ/gWv/3lrYkC5M6sJiM
         LWp8h2PqBsewO6BHVlKtqIoHTsPqMlpWX5sMubAX8H6+SzgtyE0rI/tM3E86EQ3GD+qs
         FL8tuoy7kEvf8WFlo+sNLgDIqcnQC9F3N5qnHjVmm688eTNloEBw+UQ9GGyB/HNu5L/L
         xtEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785164737; x=1785769537;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K4Qz9i47mt1/XqvHs5lPOX9/Y1Q97QNY8XuhmKXC13k=;
        b=mJwQnd0nP9Crmn9D7tCxhF4Lor1jd+9kFxMnKK34EsQoM8ACbyKOJ8LyWvJtDZqx3Y
         2iDcJ1luZlZ66DlFscusftBOvfmfDMRH9UrjzaSfTyXeUvlFtK5R9o+/aLOHo5qIct3l
         GrfQ/i1VYLGCym6ybeARQ4hY8HxgBeanf+zy/HcNuy/IoFQ6XERm+ffZfvdg33w+IWf/
         0uL/18oKzgDv/vCfoF0USHRz+Qm9AanAXEjIsdovDQ0iQBg/55D+KSlItSG6ka1+a/fF
         l+SfvTvdg9AUkiE7FgKTIhmBrvyYBnQhLNzx8vgalzOkMhxuNSjS9fUhH/+j3cLO6wDl
         UUCA==
X-Gm-Message-State: AOJu0YyLhQ616oi8eoWzmupGuf3jvvfMHu8kejW/mdi8+dTzaiOJUMJt
	7ddHfN/mQSF5rjBa1nX9zJVmgQU/N0aHhFHH9s5/Pqa+CkPlIOmNE+nAMWMs0RgZEmIJEQ/dut4
	JjtWiXk6hEkLhCrolFVnm1xY054JvLdQ=
X-Gm-Gg: AR+sD11oUzYQLGhBxfxfdxrRqFqlS2jJJjOdYRzSVJmtZ0gjF8gvFhyw77oPQdQAli8
	hfyEHDl/tXiJGdIOW5Sj7VzOxCvOV4Wz4YlWhDdQjpzBH6wATUfqJ3zIfDWz/TO/dHM+vwb55/b
	AdN5YC35idGYXZWNfD1OrNvwdi7TilshyKAfJuk54czBQb80u1qxX6SYH5h21k/LB2+ZJTfifwI
	pwFg0dd7tYwxNXOiKabgvUD0is14x5nwhB/+ey0A2ClX8h51HO/IjnrH9OOOCL+aNrRsMJNNbKF
	Zd67HAQDODOgPikDzWNGvARBFiN0
X-Received: by 2002:a05:600c:8214:b0:495:5e07:649b with SMTP id
 5b1f17b1804b1-496b570dbbemr109486935e9.24.1785164737315; Mon, 27 Jul 2026
 08:05:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev> <20260727140503.1060918-2-baoquan.he@linux.dev>
In-Reply-To: <20260727140503.1060918-2-baoquan.he@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 27 Jul 2026 08:05:26 -0700
X-Gm-Features: AUfX_mw-3BKLmoaL54r6stwQT7Z1I6t_-F1r-Hk3xRG25TkghUx3z51cv0eDikw
Message-ID: <CAKEwX=Pe+qMZd2xhnU-PAGQtgXkp56c-JwYCbt2Lux9htgB67Q@mail.gmail.com>
Subject: Re: [RFC PATCH 03/11] mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, david@kernel.org, 
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1258740007
X-Stat-Signature: rnc56sm914ksystyoi7nr9bganmoekn8
X-Rspam-User: 
X-HE-Tag: 1785164738-943169
X-HE-Meta: U2FsdGVkX1+Q442QpE9ugKXPyP6XSRMAhUr+QUrg/TA765o2lOGN6nPf/elRbGYymaaGW09uJEQuNy8QnwRAu9Fi4ml1YVRpM64C9jWeKgiScAebXFb9lt9qugR8IgHJWe/+EA06fwxuSUm/UcIkPvIURaIQOaM/4LGj4XpPEGU3b9dWNyimMiSpi44r2S/dSskiMGw4QHAQBKs4IOKzgV30K5F/wiivdWE8lfsRxTE/xBT+G+GycU5p0GYjkATrLsdJnp8164RLllD5+Un9m0qNEOMSJdDOEuWK0WYlsHll26Sf0pWu956S/Nz1EkKAvj31Xi5pMvUTZZZ8dU0umhPWR7cOsrkVLm8uJcGh277uS0kszNcYMdx0/RGmO0KF8h4Vc2+OhgEgsLw+B3tqTEcGuoQA8iwAOIZbZC1mSuJbmSgGvLII/P8Y/LH6qs1PecbxClcra0kn6IkieJBB9y+EU8OFZPcZgc8jX8r5t6Beskf6s3YXVF8H1732ZHIgk9aGUm6mNkkkDKxYmxB37FdXQCIMyY67rpvwSQPSP58n9H+V1LrP3eURFhz3xAZsL/zjBGZMexcc+X3D/AxHrufA3/31pP8/ejUcs96Hb2yReT14BAL6cfwuk2r+JL/dE2IY4dEhgA6dDkq493eME7oStX28d2nrHLAKge0PdLzKzdy0fpO0q6leYn5ZulowFn2tqkDhasqfh8TG3031+AtlXTx7LrPD37IAs6ig24tMl9+7SQUULMs4oWoax1OP2DH2GtjGJMQ9/m3Pdlsg+lhVownJWwJKQTrzWGe2gNSrJwcBnvz7h3om6yjAjzd74yhXa6eUNzniZMeXvIeibZVGBUzz7Yxyrt+TKLwRI1ab92SQY06IJUBxa/HAlOL0jzrJ7Ym0wxUxY610RVwPw1F5fpAdiKARm9yS+qq52p21PZQXK1BZq7eEIEFV7S/LittsyuCSjaKcXDheawS
 EM0lLq1T
 3ViHEzh4UbkIegqLtEKej9zYEgBsInzs5xCuwiwBGSZXL/l95i/V/cQUti9rG1iDQQFsxMvFBcQIwNwDas3AD8/ArIXg3vc1wYKh9VK24ME9nOYYaJXofBojEDP9Qvup4N9GI+i9DtqUGKW8MaEL6xj1rmp4U68pXvjHJb9fhOwN8Xzpw/FVMHkAmfPzZycGD9nJVmZUpMhMIShRgqfdbEOTZ1fkhCaTzCWIgzc8I4atfLJ3HUQswEwVH/BCnQhzysoH0spU2CzlBnG6X4sk/AQbnU/8hNvepj7brm8MLXXUaY2oTNEDQRElvWxIilBzVHv3uObA6GRsultyNE8xjwiVRfrm77rc87BZ3BV2AZ7WXnvYDZxhQbhwdAN1uOR9KT6C/iShNTooWiyDVorRbzEyL64D9wIIGekskssd0j7qnTF6IDWqA/ok+li3FwMYnZOCm
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
>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>

I'll give my 2 cents on the direction we're pursuing later. I've done
a lot of thinking over the past weeks, and I have some new concerns
now regarding how we plan to land this joint venture :)

That said, this is a new piece of extension, done per my request
(kernel-driven dynamic swap address space growth - thanks for taking
my concerns seriously), and I've also evaluated this vmalloc-based
data structure in the past week, so I'll put in my inquiries/concerns.

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

I was evaluating whether your vmalloc array can be extended to support
kernel-driven dynamic growth at least (either as a slot-in replacement
for xarray, or as a follow-up optimization if it's too complicated),
and I stumble this mapping action.

Seems like it does not take any GFP flag argument, and under the hood
it calls GFP_KERNEL. Would this be safe in the swap allocation path
(where you slotted it in in patch 4)? Kairui used a more precise set
of flags in this path, for e.g for swap table allocation:

ret =3D swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
   GFP_KERNEL);


I'm guessing this has to do with the fact that we often entered
swapping out paths with PF_MEMALLOC... Is there any risk of deadlock
etc.?

Kairui, any thoughts?

