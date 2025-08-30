Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 555ABCA0FF9
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 04:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 800906B002C; Sat, 30 Aug 2025 00:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1206B002F; Sat, 30 Aug 2025 00:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE046B0031; Sat, 30 Aug 2025 00:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D51F6B002C
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 00:23:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03964140A2E
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:23:37 +0000 (UTC)
X-FDA: 83832130116.26.3BEE89F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2B08E8000B
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:23:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PAuPgW6D;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756527816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfIAEbnEfPA8NLHbFihkx4jLwJRo+ySAEqJMEysZ3nE=;
	b=ORKUJxp6F79a7TrfLbw47Ut9buAaFJ950mXsruIeSxsWk9/sTolpCO4eZJWSSxb7GtT6pC
	Q+mLHVKtxRJuponEMjWVZLsfEhQ/ayDx26B1C+nxmDZ0XYhUKNJDTL6LJs7lwW/ZppbF+/
	Q2brsX06pD0pVUn5Byd8VtXMhCWH6/E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PAuPgW6D;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756527816; a=rsa-sha256;
	cv=none;
	b=NIbGdY2RTIklqDUWV6QCD5qZlZ/Nk0ZwL9ZEFrtr/5PrwdvR5nIZN+dLId+hAtQ2Qb9cRW
	emn3oazhtLAJ+Ue16eDnZwh08bMy3bL/Gw8Yhi2Z9ZYfMhwC7GJNFYByEf9YkNebF182dX
	hxzZjcZdaKeLzo16G5yF/mpRJFVu1IA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1852B44517
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FC5C4CEF8
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756527814;
	bh=D9KYpDUP5BVnW8FywXZwKnRRF1ITjfxzDIQ9H8sxo4Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PAuPgW6DTcFnirnw9UcqldJvkgib7KlFB/JhUA3yke1jVHWwKEou+iqZedEtWCd9f
	 tkGu1jrZxyuHCq56vlsy2IwPWxY8PL5832VV3EaVn8azpr2q5SI1jbKS1yWC+zZWQQ
	 allQPhuRUoHiDg1wV5RcCmDknW8AJHFEkq7ZQqOTMVVSDXfIXsMoaNLHLMeioUlxbI
	 HJ7lyW8uQ79M0MEosGWBzqqsE7wLSE++eqa4tcYess/I/lvAtHhWcLfD30c/MeMuCW
	 ZpQeUmMGZXz24pA4Gc3rxzpSiCYP4s6xaZSJuNW0NhHU3PkxOyPRcyHx1JV1tct38z
	 78x0KotLZGQsA==
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e970a7f0e54so2343301276.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 21:23:34 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz94V2u2qYIzb5y9W51MMoS8vi2+OCo5RsrL4K9IN90HJNqWyzc
	zL8AxHb9PRj3XhdyB2/bCO3g++Q8JlHfEiccv26cpYTLbkgmsNNGRwmNkZ3Iucu7UZpbFyvaaif
	dXo6G5V9w+9JAgJa61/jxe+20mlacvGOmRb+OD1RHWg==
X-Google-Smtp-Source: AGHT+IHUYw5iTZZitWn5/kKGBPhEdinJ2+s/C+umqFngBTgvc3KVlGfasTHujxDCl4c1wk8GQEV+wkrPMOG9LwOTEh4=
X-Received: by 2002:a05:690c:a053:b0:722:7941:4f63 with SMTP id
 00721157ae682-722794152b5mr2931557b3.38.1756527814094; Fri, 29 Aug 2025
 21:23:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-10-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-10-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 29 Aug 2025 21:23:23 -0700
X-Gmail-Original-Message-ID: <CACePvbWSsy4BzJuWOHr5k_g9D3jqjevdWtwPoTg88H0O+noE0A@mail.gmail.com>
X-Gm-Features: Ac12FXz6jrOEFnuqwA82LzX_2OD8nZLAfwzRWUeO3BPVny99yHfT1S7Pw2lZEkg
Message-ID: <CACePvbWSsy4BzJuWOHr5k_g9D3jqjevdWtwPoTg88H0O+noE0A@mail.gmail.com>
Subject: Re: [PATCH 9/9] mm, swap: use a single page for swap table when the
 size fits
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2B08E8000B
X-Stat-Signature: kjr5bsxhzyhexzfhy4t8cit7e47eeggh
X-Rspam-User: 
X-HE-Tag: 1756527815-306485
X-HE-Meta: U2FsdGVkX19fl2mvz0j9YfpxJU3DHOkGj8n5k5FQK4o9+Th4fxD3u8SOPmYS981PFhqumgeXbGZwAQkhJ+PGzXCZVP5hR0vKL5FEd8yCrcx18lPAGfFYM+xCBquvO6SYy2AIrarHEhgbfb17V2p9MaLon2sMxCqacDg2ZgqwR4MO75Nf2bV8MphZz9o6JGdnVLJygBWO31GLztDYtmSQFMrGutcX09Ze+URhPqno5B1JddK21Fu4wz0kRKhFiB9mGU78OeNeuzsoBQ8muK1vI3DSlWEDNBE/CLVO5gVig6GdeB2ePrG3Kb4+1DesCMK+hi4FaK8Nf1VfbKVqQyXQ4I7IXwbs9BkjW+uMunUNc2kubZka34+t0KUOaLSiKppvidbLeKomcgLd1EvUTgnqGcUeEK0XBlaENnFgycc/mq1qK9i5Hox86v/l3rxzxNdIMLm5HTUsk32NQglJsGzuYLGi+cA9r30jkMeVjVlVWRGiwG4farU33HwDAMNqJT2KMMPNgFrqgWRSk//3g4eboQImKvPaDhCoJw19b5XHJH6c9Ki5uYZ4wBT4dRKMMcKyYnoyQb5VRkm+2wZ5SCcOBL6X1K5oWpT+ODLZkPu2v4hqboHdUzP5q046QCbn65qnJTwqbwrtrl7RsW/Inw3N5C1ylH9i46xuI6ognm98VGCZ1FAnQ98DX7eSZTKJVJeN7FhTzz5Slz7pXh7hQ5uIfj6orqTDgncKBgs4HrdeQohsdyZiO4C//8awrOgwcEn0K2rJ62bYOokahCuMrqI9TpZtVd4rnS4kjo+Eo2ELzXPb0iIuq7KfrzQT2Y4dpQOPdQFujsfgPpZr8SNnwWtvaNuGlHNbRuWVKQX1hgVAEaS1OUHQd33eb0s39n5CzrhwnjmNkVQxkFb1fI3Tr9lqQmXKYSra19EZK+sJyv4OnfwscuUjlf2CtJIa0K2F7zkS0aPOz2CcGHCwH6W3Q7c
 25w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
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
> ---
>  mm/swap_table.h |  2 ++
>  mm/swapfile.c   | 50 ++++++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 43 insertions(+), 9 deletions(-)
>
> diff --git a/mm/swap_table.h b/mm/swap_table.h
> index 4e97513b11ef..984474e37dd7 100644
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
> index 00651e947eb2..7539ee26d59a 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -432,6 +432,38 @@ static inline unsigned int cluster_offset(struct swa=
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
> @@ -445,7 +477,7 @@ static void swap_cluster_free_table(struct swap_clust=
er_info *ci)
>         table =3D (void *)rcu_dereference_protected(ci->table, true);
>         rcu_assign_pointer(ci->table, NULL);
>
> -       kmem_cache_free(swap_table_cachep, table);
> +       swap_table_free(table);
>  }
>
>  /*
> @@ -469,8 +501,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
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
> @@ -485,7 +516,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
>         if (!(si->flags & SWP_SOLIDSTATE))
>                 spin_unlock(&si->global_cluster_lock);
>         local_unlock(&percpu_swap_cluster.lock);
> -       table =3D kmem_cache_zalloc(swap_table_cachep, __GFP_HIGH | GFP_K=
ERNEL);
> +       table =3D swap_table_alloc(__GFP_HIGH | GFP_KERNEL);
>
>         local_lock(&percpu_swap_cluster.lock);
>         if (!(si->flags & SWP_SOLIDSTATE))
> @@ -522,7 +553,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
>
>  free_table:
>         if (table)
> -               kmem_cache_free(swap_table_cachep, table);
> +               swap_table_free(table);
>         return ci;
>  }
>
> @@ -740,7 +771,7 @@ static int inc_cluster_info_page(struct swap_info_str=
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
> @@ -4076,9 +4107,10 @@ static int __init swapfile_init(void)
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

