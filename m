Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32706CA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 15:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 523736B0006; Sat,  6 Sep 2025 11:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FB978E0005; Sat,  6 Sep 2025 11:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4384F8E0001; Sat,  6 Sep 2025 11:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30FB46B0006
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 11:48:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8770BA38D
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 15:48:47 +0000 (UTC)
X-FDA: 83859258294.11.AA0ACBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 689D540003
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 15:48:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SApPLkyX;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757173725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJLo/F+siNjCL0Srvn/uYHdxvlq9n7bcXJy3yyjbuyE=;
	b=7kPlCKTe1gvE/hMh1L+k7pp51LOM2kd5AZyUisbr7wa/s4RSN59lFb11Wojh4EoOIcfp26
	3lRBE6bWAoZXEGYQ8HQEzjgflCSvneCq+hXXVoqnCKnScL1UlCzDn9HZUTfv87J21lke/j
	NfIPZrtcmaMZngfK3wKDS/XN+zB7oE4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SApPLkyX;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757173725; a=rsa-sha256;
	cv=none;
	b=XDxQpfHcioIs3D31Ng0nEvJ0ozIJ6b44jWNU2oVu9A+K1fH8RSDagKJKSbDnmwbdGqvp6g
	vRKhYOCSf43Q2PzSmLMHNryP+i879QbIWyLsKBcdQlcsU8bbidYj89prZpiAGDgiB5Bycr
	kQMWnT5bDhlJeYlMrLV9JZbuoFLh6oE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4890B44A05
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 15:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B784C4CEF9
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 15:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757173724;
	bh=iuLWCsIBZxDQ2MBJdwm2NrZSglPZeOKYdQ7nbEyaEmk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SApPLkyXCiYvF2/mq1ZP+u1HZoU5C54x+LWAvy2q+nGJykcSP7NG3LcaA2ZyxuD/a
	 vubz1HmWisy8GuQtm5mkBV1+qQZYtld9YZxiAdNMqtJzHg7olGziSzPQeNC5FX8rja
	 FuRauYCCbQPtnA71iyUZ+uJz1xQK95bcWrFbWKP+VoSDnjl/vQlT9JWDL5oyEpT4jQ
	 aGWzWymlaioi2m3V0rl0v4abwhrzUYt11adTgCWCP6siOhN5+hXMPSQ1FWlUvQHGCw
	 Qgdb42liiPGuIpoqXlRFa9PKSYGlkMtgNhZeHhIRmqhXTDy53jFLEBUOgJ9LIM54KN
	 Qq56MWUeWQX1w==
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45dd9d72f61so52045e9.0
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 08:48:44 -0700 (PDT)
X-Gm-Message-State: AOJu0YxV4TH1bGwNnGbB0Oj5RnDKwUAJkFPrgf/fyo37Yf+Xa4g/xfeb
	abCn8O+DU5M7yp6Fbi/gZ34uozUcRcFil7QsXT+vL8PK1fVONp+yl3l19yh664U3livBJ5OhQFG
	b6hC3YYwtM0/VPpPcwXS9LPl9+otzqyCCV+oC0QAD
X-Google-Smtp-Source: AGHT+IGfOHFfYjrv75nj+zPedFLz/C32IBV6OSZzlh+tt/0dkhgj6uNTqGVaCcOwBOvAkMKoeKUzATipNNt+w8JR9MA=
X-Received: by 2002:a05:600c:35d3:b0:45c:b4fb:f0b3 with SMTP id
 5b1f17b1804b1-45dde171ab0mr864355e9.3.1757173722805; Sat, 06 Sep 2025
 08:48:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-16-ryncsn@gmail.com>
In-Reply-To: <20250905191357.78298-16-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 6 Sep 2025 08:48:31 -0700
X-Gmail-Original-Message-ID: <CAF8kJuOd5WHC5oHtyy3SOGNSVqwMp4YudYJi8vgdUAoskpbp9Q@mail.gmail.com>
X-Gm-Features: AS18NWBEcSo_7Xs5GSFLBOKA84DhgQEWJ_kmytYfUvUse6z9v7Oo0kH7y1QVMl4
Message-ID: <CAF8kJuOd5WHC5oHtyy3SOGNSVqwMp4YudYJi8vgdUAoskpbp9Q@mail.gmail.com>
Subject: Re: [PATCH v2 15/15] mm, swap: use a single page for swap table when
 the size fits
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 689D540003
X-Stat-Signature: 8rudeebknpx8hgh6fk8kne8ncw7ojyqb
X-Rspam-User: 
X-HE-Tag: 1757173725-158895
X-HE-Meta: U2FsdGVkX1+Gxkosc5hg59uvJf0Sz6LtEMCbZrqklRAuxCROjIEmkBeiDaMXM7O37B2HKBGYutJ8SSnNRfEbLFnK4br0TOoWpEa+FWJGJQYcQUvLdSa8vI6dtnF/+IlKTTZ79hWVolF8lL+OfBIhQA/WCkum0NpirQf6soO/UwKrsEkJ7oFhUdBf8h7X/a0EUulqicZNgDLXFWZ8EUz/+M+3NInynIwecRDxZU1FVPjjgqXichpoUqzzwwRW01P3JnvvWNk09yvBNTdx/XYSGMwkdT3myEEIrQSY2TfwY0HX/8udVuzwYectWdRi91JJQPof1rDE3zSAkb6L5sYwFEBjjD9NIvVrzXx/xsJYSCfCs33uuRzOZli8hmyvn0LApqm1dtDFiLmYGNcqlV2Sp7COnlMqjY8rntXIKF9S2EO+DXmiQ5NzowybxGDDLXAS/AKrIotu6lO++ig2QsVVX4hbghxdt4Fmjjb62hfatGyWEyMmrRnuAmlpN0mg4FcsSiq5OvnXTvLtJ5zcCJtnQYN4B9zLUSFBnJQ+H5W9K++riCMNEXs3HRKZj9vGp0oe2qcTIUtNlb+oJYJcnoG+VsJ5ymDXOPm41AC6HNUYiNGxySbBjdEA8y2n7iMGNp5SBJ5yBn09tLT/SqNFaEsiAFRQgZWqUwtlCpGSo29uTIdGzLcDiYKIpeNUMhqr/M0UzdivvD/WcTmruyHbvQlSRFy3nXdx3SXxopjBjFBZAJpLBJMvJxqsiGJHGhYyz+IUkF+KbKwyXVjCAvr4/585jXnNXRu5GJWohfNG52oBmE7jnsC7l3UgoH6qoHPal0LPBAKpYcgCxc3pjE4ZGS4/x+wn+AfrWFId9SUkba5Kg4otrsub9249x8H2pvm/Hrl4q6pgfa19g507iSLXdUfWTx2mVPBYRM/+xYAy2M+W/2U1F0WY4oX8YUQPnBgtAAjQ9vM3I6O15D3HyMYnpAR
 UMV9wkmM
 Zw7cTQX213nbz0hqE4Z+M/wK17XP8pBVKG+8hU8KZR/AutG113eah2YWxAeX5NHd4S17UnSURg2XtjSjWOTlNv1BigSUsYCCdCH/cBkEDVPTjarYJzY5KM5OzWRSoQe9gwzXUCwDGe22bnrTVBbGJA/VS9gSKB8Kp4907LK6m6rO8pjeZvbxP/K5jqUqN2ZEeDTVzTPvARibr5ISTHqS0laD9/iiG8sGBC0zLili0P9h/D/wxAlaBTXq7XD2chI89Isj+80N+sIB05jRxbThhKJF1IWRnWR/7bRV5FQUVePo+hTBCdEwX7jfJyx4QfzBKLR9hKOPovFbWqTCskekTHYRsSjhPdIvD7+J3pUkGlaQxNXmVNgMw1fPidYKwxhPO1iVZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I did not notice new changes, anyway.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Fri, Sep 5, 2025 at 12:15=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> We have a cluster size of 512 slots. Each slot consumes 8 bytes in swap
> table so the swap table size of each cluster is exactly one page (4K).
>
> If that condition is true, allocate one page direct and disable the slab
> cache to reduce the memory usage of swap table and avoid fragmentation.
>
> Co-developed-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> ---
>  mm/swap_table.h |  2 ++
>  mm/swapfile.c   | 50 ++++++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 43 insertions(+), 9 deletions(-)
>
> diff --git a/mm/swap_table.h b/mm/swap_table.h
> index 52254e455304..ea244a57a5b7 100644
> --- a/mm/swap_table.h
> +++ b/mm/swap_table.h
> @@ -11,6 +11,8 @@ struct swap_table {
>         atomic_long_t entries[SWAPFILE_CLUSTER];
>  };
>
> +#define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) =3D=3D PAGE_SIZE)
> +
>  /*
>   * A swap table entry represents the status of a swap slot on a swap
>   * (physical or virtual) device. The swap table in each cluster is a
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 49f93069faef..ab6e877b0644 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -430,6 +430,38 @@ static inline unsigned int cluster_offset(struct swa=
p_info_struct *si,
>         return cluster_index(si, ci) * SWAPFILE_CLUSTER;
>  }
>
> +static struct swap_table *swap_table_alloc(gfp_t gfp)
> +{
> +       struct folio *folio;
> +
> +       if (!SWP_TABLE_USE_PAGE)
> +               return kmem_cache_zalloc(swap_table_cachep, gfp);
> +
> +       folio =3D folio_alloc(gfp | __GFP_ZERO, 0);
> +       if (folio)
> +               return folio_address(folio);
> +       return NULL;
> +}
> +
> +static void swap_table_free_folio_rcu_cb(struct rcu_head *head)
> +{
> +       struct folio *folio;
> +
> +       folio =3D page_folio(container_of(head, struct page, rcu_head));
> +       folio_put(folio);
> +}
> +
> +static void swap_table_free(struct swap_table *table)
> +{
> +       if (!SWP_TABLE_USE_PAGE) {
> +               kmem_cache_free(swap_table_cachep, table);
> +               return;
> +       }
> +
> +       call_rcu(&(folio_page(virt_to_folio(table), 0)->rcu_head),
> +                swap_table_free_folio_rcu_cb);
> +}
> +
>  static void swap_cluster_free_table(struct swap_cluster_info *ci)
>  {
>         unsigned int ci_off;
> @@ -443,7 +475,7 @@ static void swap_cluster_free_table(struct swap_clust=
er_info *ci)
>         table =3D (void *)rcu_dereference_protected(ci->table, true);
>         rcu_assign_pointer(ci->table, NULL);
>
> -       kmem_cache_free(swap_table_cachep, table);
> +       swap_table_free(table);
>  }
>
>  /*
> @@ -467,8 +499,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
>         lockdep_assert_held(&ci->lock);
>         lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
>
> -       table =3D kmem_cache_zalloc(swap_table_cachep,
> -                                 __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_N=
OWARN);
> +       table =3D swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_=
NOWARN);
>         if (table) {
>                 rcu_assign_pointer(ci->table, table);
>                 return ci;
> @@ -483,7 +514,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
>         if (!(si->flags & SWP_SOLIDSTATE))
>                 spin_unlock(&si->global_cluster_lock);
>         local_unlock(&percpu_swap_cluster.lock);
> -       table =3D kmem_cache_zalloc(swap_table_cachep, __GFP_HIGH | GFP_K=
ERNEL);
> +       table =3D swap_table_alloc(__GFP_HIGH | GFP_KERNEL);
>
>         local_lock(&percpu_swap_cluster.lock);
>         if (!(si->flags & SWP_SOLIDSTATE))
> @@ -520,7 +551,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
>
>  free_table:
>         if (table)
> -               kmem_cache_free(swap_table_cachep, table);
> +               swap_table_free(table);
>         return ci;
>  }
>
> @@ -738,7 +769,7 @@ static int inc_cluster_info_page(struct swap_info_str=
uct *si,
>
>         ci =3D cluster_info + idx;
>         if (!ci->table) {
> -               table =3D kmem_cache_zalloc(swap_table_cachep, GFP_KERNEL=
);
> +               table =3D swap_table_alloc(GFP_KERNEL);
>                 if (!table)
>                         return -ENOMEM;
>                 rcu_assign_pointer(ci->table, table);
> @@ -4075,9 +4106,10 @@ static int __init swapfile_init(void)
>          * only, and all swap cache readers (swap_cache_*) verifies
>          * the content before use. So it's safe to use RCU slab here.
>          */
> -       swap_table_cachep =3D kmem_cache_create("swap_table",
> -                           sizeof(struct swap_table),
> -                           0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);
> +       if (!SWP_TABLE_USE_PAGE)
> +               swap_table_cachep =3D kmem_cache_create("swap_table",
> +                                   sizeof(struct swap_table),
> +                                   0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU,=
 NULL);
>
>  #ifdef CONFIG_MIGRATION
>         if (swapfile_maximum_size >=3D (1UL << SWP_MIG_TOTAL_BITS))
> --
> 2.51.0
>
>

