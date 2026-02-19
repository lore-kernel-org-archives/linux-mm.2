Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA828E9A04C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 06:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDBF26B0088; Thu, 19 Feb 2026 01:46:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8A316B0089; Thu, 19 Feb 2026 01:46:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95E76B008A; Thu, 19 Feb 2026 01:46:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 928566B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 01:46:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB7068B9A5
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:46:05 +0000 (UTC)
X-FDA: 84460271490.18.C5404D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id BC60140002
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:46:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V996QwKw;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771483563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3amATLPJIdOTkhT0E8FmfEhq4Pc4avBt1L1DIZdyeWc=;
	b=KEde4XpeY1LGiy0GrHbQYMfqGa2yY6uPqv2O+7rT84Etkt59IbPbqXoLeWXysL8P4HmTbt
	2NFzT80tLlGWPQOFtnkTflrHUB1guDTiXqrLxyS+LZx5ic8Nvjt5fqAeATvdabHeBcY7XL
	nWhfUWD2nMzso2/JfhOgCex9HZtl190=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V996QwKw;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771483563; a=rsa-sha256;
	cv=none;
	b=KvKfljxkkFqZ7kJo52vwPuO9Bl0WvnHIWS/Qne+38Zly3JXYqZAQO2o/TDwYrLksNhl/tZ
	N1Rz+uo8WDv3G4/UJls1Sw/TftQiSUiQWQVIoYmWlJUhImPX0gflOpdxY5iqX8WbCeMTLu
	9YxPPl1FgJbmRGvngkgCwXDxfvDQT18=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FCFD4428D
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D05DC4AF09
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771483562;
	bh=exIFoUQ7OlM/XQWxN/LJt7p9eZkh9S8E8n3kDGdCPhk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=V996QwKwvgULtkC2UEPdJ+d5fbkPvgRmmARJ6z/kriwjbcyn1va1LdFBs4N9Y44cq
	 gcwEkVG5XbCnv06VrtGVErnEab3S8bkqbrPwexH1j99co/Wt1G6HWkzjq9aIj26a5Y
	 b7/IuYlenbAioKxk+j7DafCu5SxsxoIlJ8fbOZ7THk51u8T5ZCh78KbxAbu0QiXxdy
	 cu64HEnGe0qUgrNArop51G2JulnZBwSaGyR2OnN3lh1jFeY+6BqPxr93kl5jkymMEb
	 VfJ0jlX5dfXHUg+HXa9EDNMAHGdyCsoAsCZ5Db0CaalKzZUkMnKEzvYrPuOIgNcyHD
	 M0HmD+CEVFM0w==
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-64aea64bf15so548546d50.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 22:46:02 -0800 (PST)
X-Gm-Message-State: AOJu0YzgHNVEnNEaIQjtq+O3lGYXHHjBHMBHLkJ16LOX20/Dj4A5tXsq
	K5IDMjMoXlODJz8b4EiEoAX3m8RE4lY0FhBXDlqEHTlD7t2XEy4TeSpJtpk+kI8iyWlI+PnxRia
	+w2HZkom2OpFHeSECwRtIqiv5tKpn/3DCnlWb7l1b8A==
X-Received: by 2002:a05:690e:140f:b0:645:5d39:2549 with SMTP id
 956f58d0204a3-64c55587d97mr2839068d50.21.1771483561406; Wed, 18 Feb 2026
 22:46:01 -0800 (PST)
MIME-Version: 1.0
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com> <20260218-swap-table-p3-v3-2-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-2-f4e34be021a7@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 18 Feb 2026 22:45:50 -0800
X-Gmail-Original-Message-ID: <CACePvbXnEU+VsE_wWMfaPsQCAmbZiFJjddsHdhLDnbGL_1P8WA@mail.gmail.com>
X-Gm-Features: AZwV_Qi0brKcxdkGgvqo79TUDmPiyuvEqCu2daUYDg-eAK2ytxQ13PDGtRCXWYg
Message-ID: <CACePvbXnEU+VsE_wWMfaPsQCAmbZiFJjddsHdhLDnbGL_1P8WA@mail.gmail.com>
Subject: Re: [PATCH v3 02/12] mm, swap: clean up swapon process and locking
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BC60140002
X-Stat-Signature: i6zsikt7wxp4oeu7rqr8tkpr8qpahnmo
X-HE-Tag: 1771483563-200323
X-HE-Meta: U2FsdGVkX18Mz0skrhnVbC31SzFRqZK2tvjCaco7o8/IOFLmhttbiKi3wJg7LKsWR3h7IZ2j0Rdu79N/dlSyDx408TF8pI9zQvQgi2uOgwjYcs5EzluK6jKaOrcYBHWBQPKZjY46fTIYMVQ4gSPrUwGPFHU2/LkQpOqnqJeQhzSRv5cYGUhJIca3+opR+OykEV6lsqc7mUwcb5fRlRK3u31beGCXLIfE1vE7dh2RWPonmHL1Vv/QYVEWkBKP64TQgE3EhYnPjAvyu5+YjIO68rQlaOjo96K5CaT9O25qyQfUUO/nrXoYY+o+LBl+PpRABIl5MOUgx8uX6q3YshKDG8PAM84Orh+5dvSUFhG0IqhyUs7ZvAJwQZ2BBllJXejE1ot2xgFEB2E50arMqAz8bSZvJBhPL3/FCIYfllLqMLpUjoNKXyd7EgdJDMMlG4+B9jEyewby7Rbp2A3nH1XhiGw78IKyZLGSnbJmMKORAvRkASNwpkfQpWc2B7DS2DY9ImP/gg1XWluGoy3+o4+uWIpnbM5kZi1DYiM3GnYsS1PO/NefRfqnMGx8JLPY9uPslb2bcmIdIhtnGNfaIiro4MDZCfY+1OZ66F9rbrL/eewMgbzmH7rMFgpyfHd1jFDS8p5z7WMuhS7pgzoJ08tm5JAjkjPiX7p36os3AuOGm5+RFK2+X6pjygEeAS5TOR7xz5tKYI+wFS9ncl6kAtaPV+oD7c9DYFPB+lcFGAWD7ofPhINrwZ7Bd25XMHdHHuBtEOg4Dcivek2B2Y/9aqoX5/SIeyM1pEt36EfcHdwwdYMPJ6Q0eZsP7BDThR92iAbTdj5hBhqQGQcAAcReGOrCnDSmb8NUHpWS/KNeuIjDB9wBgOGAQ5CwjtSN2N5EU3cE3Ttqal6QC5rvcVzNZBK+hMLphR+Dq3DIIAtmn0JsNLhxwC3y49Dx/EDPp69TlY5gEJfq+xcYbtLg8EdzgsA
 tkeYuohm
 zeSc1o4Uc4RuVVA8MGctvR1XInKQvJXDeGGM+EHGBA44qSWWaPlQy7UwgzaDAF2oT2j7o5xsMQ4gcZzQyz2IEWHAwgHHq1FzHS9P4ZP1oU5/f5/vMJsNw1jjMZGDGW3y2OFJBm+dP38i4KPgZsoH76jve4k1sUXIt3My0ut2FRNrzubOf682p5LaOLRKiyH1MsFFIhsHuK2umwKRYovJ0OpauKX508JudZMJ1TFNi5MdZtQDHdDmVMcfMf+7NvMEjfg7/35sQc/AXx/xNahzK5esjuvVIoz0EunJ99nUBHR9WyCZ7m3AGrDjPgmUnqs7UYbvf753hKpB6wWE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

On Tue, Feb 17, 2026 at 12:06=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Slightly clean up the swapon process. Add comments about what swap_lock
> protects, introduce and rename helpers that wrap swap_map and
> cluster_info setup, and do it outside of the swap_lock lock.
>
> This lock protection is not needed for swap_map and cluster_info setup
> because all swap users must either hold the percpu ref or hold a stable
> allocated swap entry (e.g., locking a folio in the swap cache) before
> accessing. So before the swap device is exposed by enable_swap_info,
> nothing would use the swap device's map or cluster.
>
> So we are safe to allocate and set up swap data freely first, then
> expose the swap device and set the SWP_WRITEOK flag.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swapfile.c | 87 ++++++++++++++++++++++++++++++++---------------------=
------
>  1 file changed, 48 insertions(+), 39 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 25dfe992538d..8fc35b316ade 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -65,6 +65,13 @@ static void move_cluster(struct swap_info_struct *si,
>                          struct swap_cluster_info *ci, struct list_head *=
list,
>                          enum swap_cluster_flags new_flags);
>
> +/*
> + * Protects the swap_info array, and the SWP_USED flag. swap_info contai=
ns
> + * lazily allocated & freed swap device info struts, and SWP_USED indica=
tes

Is "struts" a typo for "struct"?

Chris

> + * which device is used, ~SWP_USED devices and can be reused.
> + *
> + * Also protects swap_active_head total_swap_pages, and the SWP_WRITEOK =
flag.
> + */
>  static DEFINE_SPINLOCK(swap_lock);
>  static unsigned int nr_swapfiles;
>  atomic_long_t nr_swap_pages;
> @@ -2657,8 +2664,6 @@ static int setup_swap_extents(struct swap_info_stru=
ct *sis,
>  }
>
>  static void setup_swap_info(struct swap_info_struct *si, int prio,
> -                           unsigned char *swap_map,
> -                           struct swap_cluster_info *cluster_info,
>                             unsigned long *zeromap)
>  {
>         si->prio =3D prio;
> @@ -2668,8 +2673,6 @@ static void setup_swap_info(struct swap_info_struct=
 *si, int prio,
>          */
>         si->list.prio =3D -si->prio;
>         si->avail_list.prio =3D -si->prio;
> -       si->swap_map =3D swap_map;
> -       si->cluster_info =3D cluster_info;
>         si->zeromap =3D zeromap;
>  }
>
> @@ -2687,13 +2690,11 @@ static void _enable_swap_info(struct swap_info_st=
ruct *si)
>  }
>
>  static void enable_swap_info(struct swap_info_struct *si, int prio,
> -                               unsigned char *swap_map,
> -                               struct swap_cluster_info *cluster_info,
> -                               unsigned long *zeromap)
> +                            unsigned long *zeromap)
>  {
>         spin_lock(&swap_lock);
>         spin_lock(&si->lock);
> -       setup_swap_info(si, prio, swap_map, cluster_info, zeromap);
> +       setup_swap_info(si, prio, zeromap);
>         spin_unlock(&si->lock);
>         spin_unlock(&swap_lock);
>         /*
> @@ -2711,7 +2712,7 @@ static void reinsert_swap_info(struct swap_info_str=
uct *si)
>  {
>         spin_lock(&swap_lock);
>         spin_lock(&si->lock);
> -       setup_swap_info(si, si->prio, si->swap_map, si->cluster_info, si-=
>zeromap);
> +       setup_swap_info(si, si->prio, si->zeromap);
>         _enable_swap_info(si);
>         spin_unlock(&si->lock);
>         spin_unlock(&swap_lock);
> @@ -2735,8 +2736,8 @@ static void wait_for_allocation(struct swap_info_st=
ruct *si)
>         }
>  }
>
> -static void free_cluster_info(struct swap_cluster_info *cluster_info,
> -                             unsigned long maxpages)
> +static void free_swap_cluster_info(struct swap_cluster_info *cluster_inf=
o,
> +                                  unsigned long maxpages)
>  {
>         struct swap_cluster_info *ci;
>         int i, nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
> @@ -2894,7 +2895,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         p->global_cluster =3D NULL;
>         vfree(swap_map);
>         kvfree(zeromap);
> -       free_cluster_info(cluster_info, maxpages);
> +       free_swap_cluster_info(cluster_info, maxpages);
>         /* Destroy swap account information */
>         swap_cgroup_swapoff(p->type);
>
> @@ -3243,10 +3244,15 @@ static unsigned long read_swap_header(struct swap=
_info_struct *si,
>
>  static int setup_swap_map(struct swap_info_struct *si,
>                           union swap_header *swap_header,
> -                         unsigned char *swap_map,
>                           unsigned long maxpages)
>  {
>         unsigned long i;
> +       unsigned char *swap_map;
> +
> +       swap_map =3D vzalloc(maxpages);
> +       si->swap_map =3D swap_map;
> +       if (!swap_map)
> +               return -ENOMEM;
>
>         swap_map[0] =3D SWAP_MAP_BAD; /* omit header page */
>         for (i =3D 0; i < swap_header->info.nr_badpages; i++) {
> @@ -3267,9 +3273,9 @@ static int setup_swap_map(struct swap_info_struct *=
si,
>         return 0;
>  }
>
> -static struct swap_cluster_info *setup_clusters(struct swap_info_struct =
*si,
> -                                               union swap_header *swap_h=
eader,
> -                                               unsigned long maxpages)
> +static int setup_swap_clusters_info(struct swap_info_struct *si,
> +                                   union swap_header *swap_header,
> +                                   unsigned long maxpages)
>  {
>         unsigned long nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLU=
STER);
>         struct swap_cluster_info *cluster_info;
> @@ -3339,10 +3345,11 @@ static struct swap_cluster_info *setup_clusters(s=
truct swap_info_struct *si,
>                 }
>         }
>
> -       return cluster_info;
> +       si->cluster_info =3D cluster_info;
> +       return 0;
>  err:
> -       free_cluster_info(cluster_info, maxpages);
> -       return ERR_PTR(err);
> +       free_swap_cluster_info(cluster_info, maxpages);
> +       return err;
>  }
>
>  SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flag=
s)
> @@ -3358,9 +3365,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>         int nr_extents;
>         sector_t span;
>         unsigned long maxpages;
> -       unsigned char *swap_map =3D NULL;
>         unsigned long *zeromap =3D NULL;
> -       struct swap_cluster_info *cluster_info =3D NULL;
>         struct folio *folio =3D NULL;
>         struct inode *inode =3D NULL;
>         bool inced_nr_rotate_swap =3D false;
> @@ -3371,6 +3376,11 @@ SYSCALL_DEFINE2(swapon, const char __user *, speci=
alfile, int, swap_flags)
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
>
> +       /*
> +        * Allocate or reuse existing !SWP_USED swap_info. The returned
> +        * si will stay in a dying status, so nothing will access its con=
tent
> +        * until enable_swap_info resurrects its percpu ref and expose it=
.
> +        */
>         si =3D alloc_swap_info();
>         if (IS_ERR(si))
>                 return PTR_ERR(si);
> @@ -3453,18 +3463,17 @@ SYSCALL_DEFINE2(swapon, const char __user *, spec=
ialfile, int, swap_flags)
>
>         maxpages =3D si->max;
>
> -       /* OK, set up the swap map and apply the bad block list */
> -       swap_map =3D vzalloc(maxpages);
> -       if (!swap_map) {
> -               error =3D -ENOMEM;
> +       /* Setup the swap map and apply bad block */
> +       error =3D setup_swap_map(si, swap_header, maxpages);
> +       if (error)
>                 goto bad_swap_unlock_inode;
> -       }
>
> -       error =3D swap_cgroup_swapon(si->type, maxpages);
> +       /* Set up the swap cluster info */
> +       error =3D setup_swap_clusters_info(si, swap_header, maxpages);
>         if (error)
>                 goto bad_swap_unlock_inode;
>
> -       error =3D setup_swap_map(si, swap_header, swap_map, maxpages);
> +       error =3D swap_cgroup_swapon(si->type, maxpages);
>         if (error)
>                 goto bad_swap_unlock_inode;
>
> @@ -3492,13 +3501,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, speci=
alfile, int, swap_flags)
>                 inced_nr_rotate_swap =3D true;
>         }
>
> -       cluster_info =3D setup_clusters(si, swap_header, maxpages);
> -       if (IS_ERR(cluster_info)) {
> -               error =3D PTR_ERR(cluster_info);
> -               cluster_info =3D NULL;
> -               goto bad_swap_unlock_inode;
> -       }
> -
>         if ((swap_flags & SWAP_FLAG_DISCARD) &&
>             si->bdev && bdev_max_discard_sectors(si->bdev)) {
>                 /*
> @@ -3551,7 +3553,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>                 prio =3D swap_flags & SWAP_FLAG_PRIO_MASK;
>
>         si->swap_file =3D swap_file;
> -       enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
> +
> +       /* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap de=
vice */
> +       enable_swap_info(si, prio, zeromap);
>
>         pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%l=
luk %s%s%s%s\n",
>                 K(si->pages), name->name, si->prio, nr_extents,
> @@ -3577,13 +3581,18 @@ SYSCALL_DEFINE2(swapon, const char __user *, spec=
ialfile, int, swap_flags)
>         inode =3D NULL;
>         destroy_swap_extents(si, swap_file);
>         swap_cgroup_swapoff(si->type);
> +       vfree(si->swap_map);
> +       si->swap_map =3D NULL;
> +       free_swap_cluster_info(si->cluster_info, si->max);
> +       si->cluster_info =3D NULL;
> +       /*
> +        * Clear the SWP_USED flag after all resources are freed so
> +        * alloc_swap_info can reuse this si safely.
> +        */
>         spin_lock(&swap_lock);
>         si->flags =3D 0;
>         spin_unlock(&swap_lock);
> -       vfree(swap_map);
>         kvfree(zeromap);
> -       if (cluster_info)
> -               free_cluster_info(cluster_info, maxpages);
>         if (inced_nr_rotate_swap)
>                 atomic_dec(&nr_rotate_swap);
>         if (swap_file)
>
> --
> 2.52.0
>
>

