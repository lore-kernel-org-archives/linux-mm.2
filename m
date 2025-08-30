Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C06A7CA0FF9
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 03:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13766B0022; Fri, 29 Aug 2025 23:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBD576B0023; Fri, 29 Aug 2025 23:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DABDD6B0025; Fri, 29 Aug 2025 23:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C46996B0022
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:34:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9ABE119F5D
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:34:38 +0000 (UTC)
X-FDA: 83832006636.19.2FFFD28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A1E42100007
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:34:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fRIughrd;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756524876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dB7pHEjlJmHAPoy34rBcEnzVjtsjw5PxG0oS03OHIYE=;
	b=U17J1G+6Akl8DS+vuSO7NPUsnreiHgz40xm9rAtcxrK4o4AGTlw1CnKU46QHjr6CL8F5sy
	GAjpZSRnYEUhKP9qwAZ4kdwrRC7eaujauKpkKUL7V5pXbKeafxD0rNeJY1058EQ+CGJ2Sb
	KDBo1U2dIoJ70oui/lcCgH527aexbsE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756524876; a=rsa-sha256;
	cv=none;
	b=N6XADnHSNATfRD1mzuWnpO0ad6wcegIOUB+nX+x4AFcx2+Aw692ILbsrNDICxM8+zHDtUE
	buPJAsac20gntdcSlvNIGVmQOJviQANODREP7tRpiltj5OMY47PdMJLMgFcYymkOI9UwNV
	KrXfw1TLjI92med1uAcUI4KNW8ePgXw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fRIughrd;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 15D5144535
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACB7C4CEF4
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756524875;
	bh=5wnb05pWs9+1Qw1E4DRRBG7BAaK/b/R6AUA8lOPef44=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fRIughrdrI6N7sVuvr0u7DPw5VSaSP1ncd1V727TCG2XxSulQbxaZVcsGrfJUJ+Mh
	 prIL63W9uY/Cd7F2KYJA/SpYTpo6UD/UsQDYWwwxu6Ri7a5O9rskYsdfbrGXblP7PC
	 6F2oWWDjT2B8NC1V94JIsPxKsGxgFrdr1ZKEWUnZpKUYlBc4JrBtVdwkrHMULuzFD7
	 bAdFLO43/WFbJnZoWyQh3QfQgyMRfOMvE4kHCmmx6J9ciljzN7+05CZlPP2dQKAUqZ
	 TyZ6v5fG/JminfWzYBugpaor+bU839l9EzqLcCRN4KQXkTOuM++Uf3YrXnyanuyj7l
	 qZEsHtUToemdw==
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e96eb999262so1955284276.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 20:34:34 -0700 (PDT)
X-Gm-Message-State: AOJu0YydC6etaMmi0V2UXQ3/Sq2fM08cMmiLmwZpjX34K5p/abQStYbn
	tSm7wsU8mgupHOkENFE3/4PRjQjzwI16UGhjlswb5BVBvA8cLXZXkYS0MxIpRpeydOgVKkhL8Jf
	t3w/p2FVW401xYTR8vO/hExv13Nm49+JCcIUVPZ4ivQ==
X-Google-Smtp-Source: AGHT+IFVpmB7YPi+xVquPStiAkIsGyQT84oH475n71Jl7Zy+0l5/K9UoBdkCM2ohjmwANvV2agqbl0K5S2cgrZQrsR8=
X-Received: by 2002:a05:690c:34ca:b0:71f:f942:8474 with SMTP id
 00721157ae682-7227657547fmr9529767b3.49.1756524873438; Fri, 29 Aug 2025
 20:34:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-7-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-7-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 29 Aug 2025 20:34:22 -0700
X-Gmail-Original-Message-ID: <CACePvbVVz5G9mC=Od3Uhw9Dkkgz-_jMg9R5EzNxUwx0adKKPQw@mail.gmail.com>
X-Gm-Features: Ac12FXwTjbpC_98WLH-yAwClK7NGVMK2oVCP4OvD9MQ51dx0qqScOCtUpmD0nfQ
Message-ID: <CACePvbVVz5G9mC=Od3Uhw9Dkkgz-_jMg9R5EzNxUwx0adKKPQw@mail.gmail.com>
Subject: Re: [PATCH 6/9] mm, swap: use the swap table for the swap cache and
 switch API
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A1E42100007
X-Stat-Signature: f4g4r7xbx1rjthgtc7ej9zprw8k4k8k3
X-HE-Tag: 1756524876-616444
X-HE-Meta: U2FsdGVkX1/v2XBg/VZDAqaIlfp1lQHbm/NzCNJMeHfMiNbQyhEUYf/r66EBCC1p92ds7LL0P8VQsjjnr3hHljVQif2raV6rzlJW/m8XPlAhyTUu2t+Ctz2TmPe5sTuNGTBOgJTP4NGsLXV3eYN16GFYPMDSP5qbK50g4LBwMjn3mAMC8wVQmvNd62QQHVP2JZ+9El9lxHXgxXBj/+bTI8RVV5SsM28vWDl80PBzhAzJfPj7rNZAsLeHssrzgw8R3dV1gvjQPc9NGVZ+lq+bkfXZR24Galy7BTpA0xE/MKbRMNmDLfrDlj6jell9JYwILjqZKPErDIp8wl95iTeq+EP0jhwUafvknjjP8PZytAzYVVCOv998TV38a57qJbeRL7+3+4s9kThA+Pl0NQxo3YhQBfTX7+hFTH4+RF8Mb8tWYk6kgzhNM9jbrkw057+Sx9NfYLwdqzSIPoQbIUt5BXepKExWlnb5bS1RJMN6eqarhy7e9CwM23ttKCpfhlYChIMbqBd1A0+1CaXnieqNMM+RlHdyr0XkA9dhrqmiO0I7XWOncGANqYw8GYRxLp3QK3lJxDaf6XaQDei1JWDgyq1J8jt51L6Yk5JZcgEkVuZgf2nUqx0sHJnI1As44N06edRh+6LxKfx1/K507qMb1sHURjDYsf7Dct+jFKAr1TBb87bjBBbttqEciA/aDyF0y0SmPRzE/rXVzlGK9HrlkJ+WOaiSZZhlOB4hNBJgr4DfnDNG0bM+dF+F02TIIRs3nWinItwvXkynzBN7GOXuOkycGxRaXkUlg1pMKQBXBOVtydA3TEK5LZixj4VrwANK93FfOWaGz84x/0I/SiI+hvEtRG0oWMiJgnJcT63lzybqXZhe9FgmIKzPbnGQZQj7M7OJqbOejXRgU6El0IeJydIyo2MOu1r9a/WpmGYdI82iUPYGE/peweqNqh26N7DeO7+ow0ujf7xfAekt1FI
 lESd32ke
 KtNVE8nPzHOm90wHo9Evi8nboWy+HqHjkuahERUHL7ZJjfq6mqekLMaoOaJLozUezaQhDFWfu8EVvvgpU+DtCVMIXzameL8KyBMsyXxI9/aAVItboHGdqawzHQu5NrD5f4pSGyox6Eo4kyL6RR7LjW68wsXS6/fYlRhx9IkQXT6+IWWWBeZ9bAH40tbjE53kbo8mAC+3fhKtI+fufyTm/IRoYVOuGRS2s3H6o7W/aeoG2dwdyOT78vnGN98P+qy2KYtzhOzfH41x7NACz0ZoqIFNlAohZmVmvWfRd7OLuJKACNktPe/lwknd8nVfCkkSzfP8rZ35cyCLRvd9CYmuR8umJke04gSr3/Xhi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Introduce basic swap table infrastructures, which are now just a
> fixed-sized flat array inside each swap cluster, with access wrappers.
>
> Each cluster contains a swap table of 512 entries. Each table entry is
> an opaque atomic long. It could be in 3 types: a shadow type (XA_VALUE),
> a folio type (pointer), or NULL.
>
> In this first step, it only supports storing a folio or shadow, and it
> is a drop-in replacement for the current swap cache. Convert all swap
> cache users to use the new sets of APIs. Chris Li has been suggesting
> using a new infrastructure for swap cache for better performance, and
> that idea combined well with the swap table as the new backing
> structure. Now the lock contention range is reduced to 2M clusters,
> which is much smaller than the 64M address_space. And we can also drop
> the multiple address_space design.
>
> All the internal works are done with swap_cache_get_* helpers. Swap
> cache lookup is still lock-less like before, and the helper's contexts
> are same with original swap cache helpers. They still require a pin
> on the swap device to prevent the backing data from being freed.
>
> Swap cache updates are now protected by the swap cluster lock
> instead of the Xarray lock. This is mostly handled internally, but new
> __swap_cache_* helpers require the caller to lock the cluster. So, a
> few new cluster access and locking helpers are also introduced.
>
> A fully cluster-based unified swap table can be implemented on top
> of this to take care of all count tracking and synchronization work,
> with dynamic allocation. It should reduce the memory usage while
> making the performance even better.
>
> Co-developed-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  MAINTAINERS          |   1 +
>  include/linux/swap.h |   2 -
>  mm/filemap.c         |   2 +-
>  mm/huge_memory.c     |  16 +--
>  mm/memory-failure.c  |   2 +-
>  mm/memory.c          |   2 +-
>  mm/migrate.c         |  28 ++--
>  mm/shmem.c           |  26 ++--
>  mm/swap.h            | 151 +++++++++++++++------
>  mm/swap_state.c      | 315 +++++++++++++++++++++----------------------
>  mm/swap_table.h      | 106 +++++++++++++++
>  mm/swapfile.c        | 105 +++++++++++----
>  mm/vmscan.c          |  20 ++-
>  mm/zswap.c           |   2 +-
>  14 files changed, 500 insertions(+), 278 deletions(-)
>  create mode 100644 mm/swap_table.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b6f7c6939ff8..b78adfb3c7f0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16214,6 +16214,7 @@ F:      include/linux/swapops.h
>  F:     mm/page_io.c
>  F:     mm/swap.c
>  F:     mm/swap.h
> +F:     mm/swap_table.h
>  F:     mm/swap_state.c
>  F:     mm/swapfile.c
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index cb59c13fef42..7455df9bf340 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -470,8 +470,6 @@ extern int __swap_count(swp_entry_t entry);
>  extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t =
entry);
>  extern int swp_swapcount(swp_entry_t entry);
>  struct backing_dev_info;
> -extern int init_swap_address_space(unsigned int type, unsigned long nr_p=
ages);
> -extern void exit_swap_address_space(unsigned int type);
>  extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
>  sector_t swap_folio_sector(struct folio *folio);
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index e4a5a46db89b..1fd0565b56e4 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4504,7 +4504,7 @@ static void filemap_cachestat(struct address_space =
*mapping,
>                                  * invalidation, so there might not be
>                                  * a shadow in the swapcache (yet).
>                                  */
> -                               shadow =3D get_shadow_from_swap_cache(swp=
);
> +                               shadow =3D swap_cache_get_shadow(swp);
>                                 if (!shadow)
>                                         goto resched;
>                         }
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2a47cd3bb649..209580d395a1 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3721,7 +3721,7 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>         /* Prevent deferred_split_scan() touching ->_refcount */
>         spin_lock(&ds_queue->split_queue_lock);
>         if (folio_ref_freeze(folio, 1 + extra_pins)) {
> -               struct address_space *swap_cache =3D NULL;
> +               struct swap_cluster_info *swp_ci =3D NULL;

Not real review feedback. Just pure nitpick:
swp_ci reads strange to me. How about "cluster" or just "ci"?

>                 struct lruvec *lruvec;
>                 int expected_refs;
>
> @@ -3765,8 +3765,7 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>                                 goto fail;
>                         }
>
> -                       swap_cache =3D swap_address_space(folio->swap);
> -                       xa_lock(&swap_cache->i_pages);
> +                       swp_ci =3D swap_cluster_lock_by_folio(folio);
>                 }
>
>                 /* lock lru list/PageCompound, ref frozen by page_ref_fre=
eze */
> @@ -3798,10 +3797,9 @@ static int __folio_split(struct folio *folio, unsi=
gned int new_order,
>                          * Anonymous folio with swap cache.
>                          * NOTE: shmem in swap cache is not supported yet=
.
>                          */
> -                       if (swap_cache) {
> -                               __xa_store(&swap_cache->i_pages,
> -                                          swap_cache_index(new_folio->sw=
ap),
> -                                          new_folio, 0);
> +                       if (swp_ci) {
> +                               __swap_cache_replace_folio(swp_ci, new_fo=
lio->swap,
> +                                                          folio, new_fol=
io);
>                                 continue;
>                         }
>
> @@ -3836,8 +3834,8 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>
>                 unlock_page_lruvec(lruvec);
>
> -               if (swap_cache)
> -                       xa_unlock(&swap_cache->i_pages);
> +               if (swp_ci)
> +                       swap_cluster_unlock(swp_ci);
>         } else {
>                 spin_unlock(&ds_queue->split_queue_lock);
>                 ret =3D -EAGAIN;
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index c15ffee7d32b..bb92d0c72aec 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1199,7 +1199,7 @@ static int me_swapcache_clean(struct page_state *ps=
, struct page *p)
>         struct folio *folio =3D page_folio(p);
>         int ret;
>
> -       delete_from_swap_cache(folio);
> +       swap_cache_del_folio(folio);
>
>         ret =3D delete_from_lru_cache(folio) ? MF_FAILED : MF_RECOVERED;
>         folio_unlock(folio);
> diff --git a/mm/memory.c b/mm/memory.c
> index 9ca8e1873c6e..f81bf06e6ff5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4696,7 +4696,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>
>                                 memcg1_swapin(entry, nr_pages);
>
> -                               shadow =3D get_shadow_from_swap_cache(ent=
ry);
> +                               shadow =3D swap_cache_get_shadow(entry);
>                                 if (shadow)
>                                         workingset_refault(folio, shadow)=
;
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 8e435a078fc3..74db32caba2d 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -563,10 +563,10 @@ static int __folio_migrate_mapping(struct address_s=
pace *mapping,
>                 struct folio *newfolio, struct folio *folio, int expected=
_count)
>  {
>         XA_STATE(xas, &mapping->i_pages, folio_index(folio));
> +       struct swap_cluster_info *swp_ci =3D NULL;
>         struct zone *oldzone, *newzone;
>         int dirty;
>         long nr =3D folio_nr_pages(folio);
> -       long entries, i;
>
>         if (!mapping) {
>                 /* Take off deferred split queue while frozen and memcg s=
et */
> @@ -592,9 +592,16 @@ static int __folio_migrate_mapping(struct address_sp=
ace *mapping,
>         oldzone =3D folio_zone(folio);
>         newzone =3D folio_zone(newfolio);
>
> -       xas_lock_irq(&xas);
> +       if (folio_test_swapcache(folio))
> +               swp_ci =3D swap_cluster_lock_by_folio_irq(folio);
> +       else
> +               xas_lock_irq(&xas);
> +
>         if (!folio_ref_freeze(folio, expected_count)) {
> -               xas_unlock_irq(&xas);
> +               if (swp_ci)
> +                       swap_cluster_unlock(swp_ci);
> +               else
> +                       xas_unlock_irq(&xas);
>                 return -EAGAIN;
>         }
>
> @@ -615,9 +622,6 @@ static int __folio_migrate_mapping(struct address_spa=
ce *mapping,
>         if (folio_test_swapcache(folio)) {
>                 folio_set_swapcache(newfolio);
>                 newfolio->private =3D folio_get_private(folio);
> -               entries =3D nr;
> -       } else {
> -               entries =3D 1;
>         }
>
>         /* Move dirty while folio refs frozen and newfolio not yet expose=
d */
> @@ -627,11 +631,10 @@ static int __folio_migrate_mapping(struct address_s=
pace *mapping,
>                 folio_set_dirty(newfolio);
>         }
>
> -       /* Swap cache still stores N entries instead of a high-order entr=
y */
> -       for (i =3D 0; i < entries; i++) {
> +       if (folio_test_swapcache(folio))
> +               __swap_cache_replace_folio(swp_ci, folio->swap, folio, ne=
wfolio);
> +       else
>                 xas_store(&xas, newfolio);
> -               xas_next(&xas);
> -       }
>
>         /*
>          * Drop cache reference from old folio by unfreezing
> @@ -640,8 +643,11 @@ static int __folio_migrate_mapping(struct address_sp=
ace *mapping,
>          */
>         folio_ref_unfreeze(folio, expected_count - nr);
>
> -       xas_unlock(&xas);
>         /* Leave irq disabled to prevent preemption while updating stats =
*/
> +       if (swp_ci)
> +               swap_cluster_unlock(swp_ci);
> +       else
> +               xas_unlock(&xas);
>
>         /*
>          * If moved to a different zone then also account
> diff --git a/mm/shmem.c b/mm/shmem.c
> index e03793cc5169..f088115cf209 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1698,13 +1698,13 @@ int shmem_writeout(struct folio *folio, struct sw=
ap_iocb **plug,
>                 }
>
>                 /*
> -                * The delete_from_swap_cache() below could be left for
> +                * The swap_cache_del_folio() below could be left for
>                  * shrink_folio_list()'s folio_free_swap() to dispose of;
>                  * but I'm a little nervous about letting this folio out =
of
>                  * shmem_writeout() in a hybrid half-tmpfs-half-swap stat=
e
>                  * e.g. folio_mapping(folio) might give an unexpected ans=
wer.
>                  */
> -               delete_from_swap_cache(folio);
> +               swap_cache_del_folio(folio);
>                 goto redirty;
>         }
>         if (nr_pages > 1)
> @@ -2082,7 +2082,7 @@ static struct folio *shmem_swap_alloc_folio(struct =
inode *inode,
>         new->swap =3D entry;
>
>         memcg1_swapin(entry, nr_pages);
> -       shadow =3D get_shadow_from_swap_cache(entry);
> +       shadow =3D swap_cache_get_shadow(entry);
>         if (shadow)
>                 workingset_refault(new, shadow);
>         folio_add_lru(new);
> @@ -2120,13 +2120,11 @@ static int shmem_replace_folio(struct folio **fol=
iop, gfp_t gfp,
>                                 struct shmem_inode_info *info, pgoff_t in=
dex,
>                                 struct vm_area_struct *vma)
>  {
> +       struct swap_cluster_info *ci;
>         struct folio *new, *old =3D *foliop;
>         swp_entry_t entry =3D old->swap;
> -       struct address_space *swap_mapping =3D swap_address_space(entry);
> -       pgoff_t swap_index =3D swap_cache_index(entry);
> -       XA_STATE(xas, &swap_mapping->i_pages, swap_index);
>         int nr_pages =3D folio_nr_pages(old);
> -       int error =3D 0, i;
> +       int error =3D 0;
>
>         /*
>          * We have arrived here because our zones are constrained, so don=
't
> @@ -2155,13 +2153,9 @@ static int shmem_replace_folio(struct folio **foli=
op, gfp_t gfp,
>         new->swap =3D entry;
>         folio_set_swapcache(new);
>
> -       /* Swap cache still stores N entries instead of a high-order entr=
y */
> -       xa_lock_irq(&swap_mapping->i_pages);
> -       for (i =3D 0; i < nr_pages; i++) {
> -               WARN_ON_ONCE(xas_store(&xas, new));
> -               xas_next(&xas);
> -       }
> -       xa_unlock_irq(&swap_mapping->i_pages);
> +       ci =3D swap_cluster_lock_by_folio_irq(old);
> +       __swap_cache_replace_folio(ci, entry, old, new);
> +       swap_cluster_unlock(ci);
>
>         folio_add_lru(new);
>         *foliop =3D new;
> @@ -2198,7 +2192,7 @@ static void shmem_set_folio_swapin_error(struct ino=
de *inode, pgoff_t index,
>         nr_pages =3D folio_nr_pages(folio);
>         folio_wait_writeback(folio);
>         if (!skip_swapcache)
> -               delete_from_swap_cache(folio);
> +               swap_cache_del_folio(folio);
>         /*
>          * Don't treat swapin error folio as alloced. Otherwise inode->i_=
blocks
>          * won't be 0 when inode is released and thus trigger WARN_ON(i_b=
locks)
> @@ -2438,7 +2432,7 @@ static int shmem_swapin_folio(struct inode *inode, =
pgoff_t index,
>                 folio->swap.val =3D 0;
>                 swapcache_clear(si, swap, nr_pages);
>         } else {
> -               delete_from_swap_cache(folio);
> +               swap_cache_del_folio(folio);
>         }
>         folio_mark_dirty(folio);
>         swap_free_nr(swap, nr_pages);
> diff --git a/mm/swap.h b/mm/swap.h
> index 7b3efaa51624..4af42bc2cd72 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -2,6 +2,7 @@
>  #ifndef _MM_SWAP_H
>  #define _MM_SWAP_H
>
> +#include <linux/atomic.h> /* for atomic_long_t */
>  struct mempolicy;
>  struct swap_iocb;
>
> @@ -35,6 +36,7 @@ struct swap_cluster_info {
>         u16 count;
>         u8 flags;
>         u8 order;
> +       atomic_long_t *table;   /* Swap table entries, see mm/swap_table.=
h */
>         struct list_head list;
>  };
>
> @@ -80,22 +82,62 @@ static inline struct swap_cluster_info *swp_offset_cl=
uster(
>         return &si->cluster_info[offset / SWAPFILE_CLUSTER];
>  }
>
> -static inline struct swap_cluster_info *swap_cluster_lock(
> -               struct swap_info_struct *si,
> -               unsigned long offset)
> +static inline struct swap_cluster_info *swp_cluster(swp_entry_t entry)
> +{
> +       return swp_offset_cluster(swp_info(entry), swp_offset(entry));
> +}
> +
> +static inline unsigned int swp_cluster_offset(swp_entry_t entry)
> +{
> +       return swp_offset(entry) % SWAPFILE_CLUSTER;
> +}
> +
> +/*
> + * Lock the swap cluster of the given offset. The caller must ensure the=
 swap
> + * offset is valid and that the following accesses won't go beyond the l=
ocked
> + * cluster. swap_cluster_lock_by_folio is preferred when possible
> + */
> +static __always_inline struct swap_cluster_info *__swap_cluster_lock(
> +               struct swap_info_struct *si, unsigned long offset, bool i=
rq)
>  {
>         struct swap_cluster_info *ci =3D swp_offset_cluster(si, offset);
>
>         VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swa=
poff */
> -       spin_lock(&ci->lock);
> +       if (irq)
> +               spin_lock_irq(&ci->lock);
> +       else
> +               spin_lock(&ci->lock);
>         return ci;
>  }
> +#define swap_cluster_lock(si, off) __swap_cluster_lock(si, off, false)
> +
> +/*
> + * Lock the swap cluster that holds a folio's swap entries. Caller needs=
 to lock
> + * the folio and ensure it's in the swap cache, and only touch the folio=
's swap
> + * entries. A folio's entries are always in one cluster, and a locked fo=
lio lock
> + * ensures it won't be freed from the swap cache, hence stabilizing the =
device.
> + */
> +static inline struct swap_cluster_info *__swap_cluster_lock_by_folio(
> +               struct folio *folio, bool irq)
> +{
> +       VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +       VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
> +       return __swap_cluster_lock(swp_info(folio->swap),
> +                                  swp_offset(folio->swap), irq);
> +}
> +#define swap_cluster_lock_by_folio(folio) __swap_cluster_lock_by_folio(f=
olio, false)
> +#define swap_cluster_lock_by_folio_irq(folio) __swap_cluster_lock_by_fol=
io(folio, true)
>
>  static inline void swap_cluster_unlock(struct swap_cluster_info *ci)
>  {
>         spin_unlock(&ci->lock);
>  }
>
> +static inline void swap_cluster_unlock_irq(struct swap_cluster_info *ci)
> +{
> +       spin_unlock_irq(&ci->lock);
> +}
> +
>  /* linux/mm/page_io.c */
>  int sio_pool_init(void);
>  struct swap_iocb;
> @@ -115,10 +157,11 @@ void __swap_writepage(struct folio *folio, struct s=
wap_iocb **swap_plug);
>  #define SWAP_ADDRESS_SPACE_SHIFT       14
>  #define SWAP_ADDRESS_SPACE_PAGES       (1 << SWAP_ADDRESS_SPACE_SHIFT)
>  #define SWAP_ADDRESS_SPACE_MASK                (SWAP_ADDRESS_SPACE_PAGES=
 - 1)
> -extern struct address_space *swapper_spaces[];
> -#define swap_address_space(entry)                          \
> -       (&swapper_spaces[swp_type(entry)][swp_offset(entry) \
> -               >> SWAP_ADDRESS_SPACE_SHIFT])
> +extern struct address_space swap_space __ro_after_init;
> +static inline struct address_space *swap_address_space(swp_entry_t entry=
)
> +{
> +       return &swap_space;
> +}
>
>  /*
>   * Return the swap device position of the swap entry.
> @@ -128,15 +171,6 @@ static inline loff_t swap_dev_pos(swp_entry_t entry)
>         return ((loff_t)swp_offset(entry)) << PAGE_SHIFT;
>  }
>
> -/*
> - * Return the swap cache index of the swap entry.
> - */
> -static inline pgoff_t swap_cache_index(swp_entry_t entry)
> -{
> -       BUILD_BUG_ON((SWP_OFFSET_MASK | SWAP_ADDRESS_SPACE_MASK) !=3D SWP=
_OFFSET_MASK);
> -       return swp_offset(entry) & SWAP_ADDRESS_SPACE_MASK;
> -}
> -
>  /**
>   * folio_contains_swap - Does this folio contain this swap entry?
>   * @folio: The folio.
> @@ -160,17 +194,31 @@ static inline bool folio_contains_swap(struct folio=
 *folio, swp_entry_t entry)
>         return offset - swp_offset(folio->swap) < folio_nr_pages(folio);
>  }
>
> +/*
> + * All swap cache helpers below require the caller to ensure the swap en=
tries
> + * are valid and pin the device. This can be guaranteed by:
> + * - get_swap_device: this ensures a single entry is valid and increases=
 the
> + *   swap device's refcount.
> + * - Locking a folio in the swap cache: this ensures the folio won't be =
freed
> + *   from the swap cache, stabilizes its entries, and the swap device.
> + * - Locking anything referencing the swap entry: e.g. locking the PTL t=
hat
> + *   protects swap entries in the page table, so they won't be freed.
> + */
> +extern struct folio *swap_cache_get_folio(swp_entry_t entry);
> +extern void *swap_cache_get_shadow(swp_entry_t entry);
> +extern int swap_cache_add_folio(swp_entry_t entry,
> +                               struct folio *folio, void **shadow);
> +extern void swap_cache_del_folio(struct folio *folio);
> +/* Below helpers also require the caller to lock the swap cluster. */
> +extern void __swap_cache_del_folio(swp_entry_t entry,
> +                                  struct folio *folio, void *shadow);
> +extern void __swap_cache_replace_folio(struct swap_cluster_info *ci,
> +                                     swp_entry_t entry, struct folio *ol=
d,
> +                                     struct folio *new);
> +extern void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents);
> +
>  void show_swap_cache_info(void);
> -void *get_shadow_from_swap_cache(swp_entry_t entry);
> -int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
> -                     gfp_t gfp, void **shadowp);
> -void __delete_from_swap_cache(struct folio *folio,
> -                             swp_entry_t entry, void *shadow);
> -void delete_from_swap_cache(struct folio *folio);
> -void clear_shadow_from_swap_cache(int type, unsigned long begin,
> -                                 unsigned long end);
>  void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int=
 nr);
> -struct folio *swap_cache_get_folio(swp_entry_t entry);
>  struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>                 struct vm_area_struct *vma, unsigned long addr,
>                 struct swap_iocb **plug);
> @@ -235,6 +283,33 @@ static inline int non_swapcache_batch(swp_entry_t en=
try, int max_nr)
>
>  #else /* CONFIG_SWAP */
>  struct swap_iocb;
> +
> +static inline struct swap_cluster_info *swap_cluster_lock(
> +       struct swap_info_struct *si, pgoff_t offset, bool irq)
> +{
> +       return NULL;
> +}
> +
> +static inline struct swap_cluster_info *swap_cluster_lock_by_folio(
> +               struct folio *folio)
> +{
> +       return NULL;
> +}
> +
> +static inline struct swap_cluster_info *swap_cluster_lock_by_folio_irq(
> +               struct folio *folio)
> +{
> +       return NULL;
> +}
> +
> +static inline void swap_cluster_unlock(struct swap_cluster_info *ci)
> +{
> +}
> +
> +static inline void swap_cluster_unlock_irq(struct swap_cluster_info *ci)
> +{
> +}
> +
>  static inline struct swap_info_struct *swp_info(swp_entry_t entry)
>  {
>         return NULL;
> @@ -252,11 +327,6 @@ static inline struct address_space *swap_address_spa=
ce(swp_entry_t entry)
>         return NULL;
>  }
>
> -static inline pgoff_t swap_cache_index(swp_entry_t entry)
> -{
> -       return 0;
> -}
> -
>  static inline bool folio_contains_swap(struct folio *folio, swp_entry_t =
entry)
>  {
>         return false;
> @@ -298,28 +368,27 @@ static inline struct folio *swap_cache_get_folio(sw=
p_entry_t entry)
>         return NULL;
>  }
>
> -static inline void *get_shadow_from_swap_cache(swp_entry_t entry)
> +static inline void *swap_cache_get_shadow(swp_entry_t end)
>  {
>         return NULL;
>  }
>
> -static inline int add_to_swap_cache(struct folio *folio, swp_entry_t ent=
ry,
> -                                       gfp_t gfp_mask, void **shadowp)
> +static inline int swap_cache_add_folio(swp_entry_t end, struct folio *fo=
lio, void **shadow)
>  {
> -       return -1;
> +       return -EINVAL;
>  }
>
> -static inline void __delete_from_swap_cache(struct folio *folio,
> -                                       swp_entry_t entry, void *shadow)
> +static inline void swap_cache_del_folio(struct folio *folio)
>  {
>  }
>
> -static inline void delete_from_swap_cache(struct folio *folio)
> +static inline void __swap_cache_del_folio(swp_entry_t entry, struct foli=
o *folio, void *shadow)
>  {
>  }
>
> -static inline void clear_shadow_from_swap_cache(int type, unsigned long =
begin,
> -                               unsigned long end)
> +static inline void __swap_cache_replace_folio(
> +               struct swap_cluster_info *ci, swp_entry_t entry,
> +               struct folio *old, struct folio *new)
>  {
>  }
>
> @@ -354,7 +423,7 @@ static inline int non_swapcache_batch(swp_entry_t ent=
ry, int max_nr)
>  static inline pgoff_t folio_index(struct folio *folio)
>  {
>         if (unlikely(folio_test_swapcache(folio)))
> -               return swap_cache_index(folio->swap);
> +               return swp_offset(folio->swap);
>         return folio->index;
>  }
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 721ff1a5e73a..c0342024b4a8 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -23,6 +23,7 @@
>  #include <linux/huge_mm.h>
>  #include <linux/shmem_fs.h>
>  #include "internal.h"
> +#include "swap_table.h"
>  #include "swap.h"
>
>  /*
> @@ -36,8 +37,11 @@ static const struct address_space_operations swap_aops=
 =3D {
>  #endif
>  };
>
> -struct address_space *swapper_spaces[MAX_SWAPFILES] __read_mostly;
> -static unsigned int nr_swapper_spaces[MAX_SWAPFILES] __read_mostly;
> +/* Set swap_space is read only as swap cache is handled by swap table */
> +struct address_space swap_space __ro_after_init =3D {
> +       .a_ops =3D &swap_aops,
> +};
> +
>  static bool enable_vma_readahead __read_mostly =3D true;
>
>  #define SWAP_RA_ORDER_CEILING  5
> @@ -69,7 +73,7 @@ void show_swap_cache_info(void)
>         printk("Total swap =3D %lukB\n", K(total_swap_pages));
>  }
>
> -/*
> +/**
>   * swap_cache_get_folio - Lookup a swap entry in the swap cache.
>   *
>   * A found folio will be returned unlocked and with its refcount increas=
ed.
> @@ -79,155 +83,179 @@ void show_swap_cache_info(void)
>   */
>  struct folio *swap_cache_get_folio(swp_entry_t entry)
>  {
> -       struct folio *folio =3D filemap_get_folio(swap_address_space(entr=
y),
> -                                               swap_cache_index(entry));
> -       if (!IS_ERR(folio))
> -               return folio;
> +       unsigned long swp_tb;
> +       struct folio *folio;
> +
> +       for (;;) {
> +               swp_tb =3D __swap_table_get(swp_cluster(entry), swp_clust=
er_offset(entry));
> +               if (!swp_tb_is_folio(swp_tb))
> +                       return NULL;
> +               folio =3D swp_tb_to_folio(swp_tb);
> +               if (folio_try_get(folio))
> +                       return folio;
> +       }
> +
>         return NULL;
>  }
>
> -void *get_shadow_from_swap_cache(swp_entry_t entry)
> +/**
> + * swap_cache_get_shadow - Lookup a shadow in the swap cache.
> + *
> + * Context: Caller must ensure @entry is valid and pin the swap device.
> + */
> +void *swap_cache_get_shadow(swp_entry_t entry)
>  {
> -       struct address_space *address_space =3D swap_address_space(entry)=
;
> -       pgoff_t idx =3D swap_cache_index(entry);
> -       void *shadow;
> +       unsigned long swp_tb;
> +
> +       swp_tb =3D __swap_table_get(swp_cluster(entry), swp_cluster_offse=
t(entry));
> +       if (swp_tb_is_shadow(swp_tb))
> +               return swp_tb_to_shadow(swp_tb);
>
> -       shadow =3D xa_load(&address_space->i_pages, idx);
> -       if (xa_is_value(shadow))
> -               return shadow;
>         return NULL;
>  }
>
> -/*
> - * add_to_swap_cache resembles filemap_add_folio on swapper_space,
> - * but sets SwapCache flag and 'swap' instead of mapping and index.
> +/**
> + * swap_cache_add_folio -  add a folio into the swap cache.
> + *
> + * The folio will be used for swapin or swapout of swap entries
> + * starting with @entry. May fail due to race.
> + *
> + * Context: Caller must ensure @entry is valid and pin the swap device.
>   */
> -int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
> -                       gfp_t gfp, void **shadowp)
> +int swap_cache_add_folio(swp_entry_t entry, struct folio *folio, void **=
shadowp)
>  {
> -       struct address_space *address_space =3D swap_address_space(entry)=
;
> -       pgoff_t idx =3D swap_cache_index(entry);
> -       XA_STATE_ORDER(xas, &address_space->i_pages, idx, folio_order(fol=
io));
> -       unsigned long i, nr =3D folio_nr_pages(folio);
> -       void *old;
> -
> -       xas_set_update(&xas, workingset_update_node);
> -
> -       VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> -       VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
> -       VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
> +       unsigned long exist;
> +       void *shadow =3D NULL;
> +       struct swap_cluster_info *ci;
> +       unsigned int ci_start, ci_off, ci_end;
> +       unsigned long nr_pages =3D folio_nr_pages(folio);
> +
> +       VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +       VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
> +       VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
> +
> +       ci =3D swap_cluster_lock(swp_info(entry), swp_offset(entry));
> +       ci_start =3D swp_cluster_offset(entry);
> +       ci_end =3D ci_start + nr_pages;
> +       ci_off =3D ci_start;
> +       do {
> +               exist =3D __swap_table_get(ci, ci_off);
> +               if (unlikely(swp_tb_is_folio(exist)))
> +                       goto fail;
> +               if (swp_tb_is_shadow(exist))
> +                       shadow =3D swp_tb_to_shadow(exist);
> +       } while (++ci_off < ci_end);
> +
> +       ci_off =3D ci_start;
> +       do {
> +               __swap_table_set_folio(ci, ci_off, folio);
> +       } while (++ci_off < ci_end);
>
> -       folio_ref_add(folio, nr);
> +       folio_ref_add(folio, nr_pages);
>         folio_set_swapcache(folio);
>         folio->swap =3D entry;
> +       swap_cluster_unlock(ci);
>
> -       do {
> -               xas_lock_irq(&xas);
> -               xas_create_range(&xas);
> -               if (xas_error(&xas))
> -                       goto unlock;
> -               for (i =3D 0; i < nr; i++) {
> -                       VM_BUG_ON_FOLIO(xas.xa_index !=3D idx + i, folio)=
;
> -                       if (shadowp) {
> -                               old =3D xas_load(&xas);
> -                               if (xa_is_value(old))
> -                                       *shadowp =3D old;
> -                       }
> -                       xas_store(&xas, folio);
> -                       xas_next(&xas);
> -               }
> -               address_space->nrpages +=3D nr;
> -               __node_stat_mod_folio(folio, NR_FILE_PAGES, nr);
> -               __lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr);
> -unlock:
> -               xas_unlock_irq(&xas);
> -       } while (xas_nomem(&xas, gfp));
> -
> -       if (!xas_error(&xas))
> -               return 0;
> +       node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
> +       lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
>
> -       folio_clear_swapcache(folio);
> -       folio_ref_sub(folio, nr);
> -       return xas_error(&xas);
> +       if (shadowp)
> +               *shadowp =3D shadow;
> +       return 0;
> +fail:
> +       swap_cluster_unlock(ci);
> +       return -EEXIST;
>  }
>
>  /*
> - * This must be called only on folios that have
> - * been verified to be in the swap cache.
> + * Caller must ensure the folio is in the swap cache and locked,
> + * also lock the swap cluster.
>   */
> -void __delete_from_swap_cache(struct folio *folio,
> -                       swp_entry_t entry, void *shadow)
> +void __swap_cache_del_folio(swp_entry_t entry, struct folio *folio,
> +                           void *shadow)
>  {
> -       struct address_space *address_space =3D swap_address_space(entry)=
;
> -       int i;
> -       long nr =3D folio_nr_pages(folio);
> -       pgoff_t idx =3D swap_cache_index(entry);
> -       XA_STATE(xas, &address_space->i_pages, idx);
> -
> -       xas_set_update(&xas, workingset_update_node);
> -
> -       VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> -       VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> -       VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
> -
> -       for (i =3D 0; i < nr; i++) {
> -               void *entry =3D xas_store(&xas, shadow);
> -               VM_BUG_ON_PAGE(entry !=3D folio, entry);
> -               xas_next(&xas);
> -       }
> +       unsigned long exist;
> +       struct swap_cluster_info *ci;
> +       unsigned int ci_start, ci_off, ci_end;
> +       unsigned long nr_pages =3D folio_nr_pages(folio);
> +
> +       VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +       VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
> +       VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
> +
> +       ci =3D swp_offset_cluster(swp_info(entry), swp_offset(entry));
> +       ci_start =3D swp_cluster_offset(entry);
> +       ci_end =3D ci_start + nr_pages;
> +       ci_off =3D ci_start;
> +       do {
> +               exist =3D __swap_table_get(ci, ci_off);
> +               VM_WARN_ON_ONCE(swp_tb_to_folio(exist) !=3D folio);
> +               /* If shadow is NULL, we sets an empty shadow */
> +               __swap_table_set_shadow(ci, ci_off, shadow);
> +       } while (++ci_off < ci_end);
> +
>         folio->swap.val =3D 0;
>         folio_clear_swapcache(folio);
> -       address_space->nrpages -=3D nr;
> -       __node_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
> -       __lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr);
> +       node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
> +       lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
>  }
>
>  /*
> - * This must be called only on folios that have
> - * been verified to be in the swap cache and locked.
> - * It will never put the folio into the free list,
> - * the caller has a reference on the folio.
> + * Replace an old folio in the swap cache with a new one. The caller mus=
t
> + * hold the cluster lock and set the new folio's entry and flags.
>   */
> -void delete_from_swap_cache(struct folio *folio)
> +void __swap_cache_replace_folio(struct swap_cluster_info *ci, swp_entry_=
t entry,
> +                               struct folio *old, struct folio *new)
> +{
> +       unsigned int ci_off =3D swp_cluster_offset(entry);
> +       unsigned long nr_pages =3D folio_nr_pages(new);
> +       unsigned int ci_end =3D ci_off + nr_pages;
> +
> +       VM_WARN_ON_ONCE(entry.val !=3D new->swap.val);
> +       VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new=
));
> +       VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcac=
he(new));
> +       do {
> +               WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)=
) !=3D old);
> +               __swap_table_set_folio(ci, ci_off, new);

I recall in my original experiment swap cache replacement patch I used
atomic compare exchange somewhere. It has been a while. Is there a
reason to not use atomic cmpexchg() or that is in the later part of
the series?


> +       } while (++ci_off < ci_end);
> +
> +       /*
> +        * If the old folio is partially replaced (e.g., splitting a larg=
e
> +        * folio, the old folio is shrunk in place, and new split sub fol=
ios
> +        * are added to cache), ensure the new folio doesn't overlap it.
> +        */
> +       if (IS_ENABLED(CONFIG_DEBUG_VM) &&
> +           folio_order(old) !=3D folio_order(new)) {
> +               ci_off =3D swp_cluster_offset(old->swap);
> +               ci_end =3D ci_off + folio_nr_pages(old);
> +               while (ci_off++ < ci_end)
> +                       WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci,=
 ci_off)) !=3D old);

Will this cause the swap cache to replace less than full folio range
of the swap entry in range?
The swap cache set folio should atomically set the full range of swap
entries. If there is some one race to set some partial range. I
suspect it should fail and undo the particle set. I recall there are
some bugs on xarray accidentally fixed by one of your patches related
to that kind of atomic behavior.

I want to make sure a similar bug does not happen here.

It is worthwhile to double check if the atomic folio set behavior.

Looks good to me otherwise. Just waiting for confirmation of the swap
cache atomic set behavior.

Chris

> +       }
> +}
> +
> +void swap_cache_del_folio(struct folio *folio)
>  {
> +       struct swap_cluster_info *ci;
>         swp_entry_t entry =3D folio->swap;
> -       struct address_space *address_space =3D swap_address_space(entry)=
;
>
> -       xa_lock_irq(&address_space->i_pages);
> -       __delete_from_swap_cache(folio, entry, NULL);
> -       xa_unlock_irq(&address_space->i_pages);
> +       ci =3D swap_cluster_lock(swp_info(entry), swp_offset(entry));
> +       __swap_cache_del_folio(entry, folio, NULL);
> +       swap_cluster_unlock(ci);
>
>         put_swap_folio(folio, entry);
>         folio_ref_sub(folio, folio_nr_pages(folio));
>  }
>
> -void clear_shadow_from_swap_cache(int type, unsigned long begin,
> -                               unsigned long end)
> +void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents)
>  {
> -       unsigned long curr =3D begin;
> -       void *old;
> -
> -       for (;;) {
> -               swp_entry_t entry =3D swp_entry(type, curr);
> -               unsigned long index =3D curr & SWAP_ADDRESS_SPACE_MASK;
> -               struct address_space *address_space =3D swap_address_spac=
e(entry);
> -               XA_STATE(xas, &address_space->i_pages, index);
> -
> -               xas_set_update(&xas, workingset_update_node);
> -
> -               xa_lock_irq(&address_space->i_pages);
> -               xas_for_each(&xas, old, min(index + (end - curr), SWAP_AD=
DRESS_SPACE_PAGES)) {
> -                       if (!xa_is_value(old))
> -                               continue;
> -                       xas_store(&xas, NULL);
> -               }
> -               xa_unlock_irq(&address_space->i_pages);
> +       struct swap_cluster_info *ci =3D swp_cluster(entry);
> +       unsigned int ci_off =3D swp_cluster_offset(entry), ci_end;
>
> -               /* search the next swapcache until we meet end */
> -               curr =3D ALIGN((curr + 1), SWAP_ADDRESS_SPACE_PAGES);
> -               if (curr > end)
> -                       break;
> -       }
> +       ci_end =3D ci_off + nr_ents;
> +       do {
> +               WARN_ON_ONCE(swp_tb_is_folio(__swap_table_get(ci, ci_off)=
));
> +               __swap_table_init_null(ci, ci_off);
> +       } while (++ci_off < ci_end);
>  }
>
>  /*
> @@ -292,8 +320,7 @@ static inline bool swap_use_vma_readahead(void)
>  /*
>   * Update the readahead statistics of a vma or globally.
>   */
> -void swap_update_readahead(struct folio *folio,
> -                          struct vm_area_struct *vma,
> +void swap_update_readahead(struct folio *folio, struct vm_area_struct *v=
ma,
>                            unsigned long addr)
>  {
>         bool readahead, vma_ra =3D swap_use_vma_readahead();
> @@ -387,7 +414,7 @@ struct folio *__read_swap_cache_async(swp_entry_t ent=
ry, gfp_t gfp_mask,
>                         goto put_and_return;
>
>                 /*
> -                * We might race against __delete_from_swap_cache(), and
> +                * We might race against __swap_cache_del_folio(), and
>                  * stumble across a swap_map entry whose SWAP_HAS_CACHE
>                  * has not yet been cleared.  Or race against another
>                  * __read_swap_cache_async(), which has set SWAP_HAS_CACH=
E
> @@ -405,8 +432,7 @@ struct folio *__read_swap_cache_async(swp_entry_t ent=
ry, gfp_t gfp_mask,
>         if (mem_cgroup_swapin_charge_folio(new_folio, NULL, gfp_mask, ent=
ry))
>                 goto fail_unlock;
>
> -       /* May fail (-ENOMEM) if XArray node allocation failed. */
> -       if (add_to_swap_cache(new_folio, entry, gfp_mask & GFP_RECLAIM_MA=
SK, &shadow))
> +       if (swap_cache_add_folio(entry, new_folio, &shadow))

It feels so good we will not get ENOMEM here. The swap table page is
already allocated when allocating the entry from swap allocator.

>                 goto fail_unlock;
>
>         memcg1_swapin(entry, 1);
> @@ -572,11 +598,11 @@ struct folio *swap_cluster_readahead(swp_entry_t en=
try, gfp_t gfp_mask,
>                 end_offset =3D si->max - 1;
>
>         blk_start_plug(&plug);
> -       for (offset =3D start_offset; offset <=3D end_offset ; offset++) =
{
> +       for (offset =3D start_offset; offset <=3D end_offset; offset++) {
>                 /* Ok, do the async read-ahead now */
>                 folio =3D __read_swap_cache_async(
> -                               swp_entry(swp_type(entry), offset),
> -                               gfp_mask, mpol, ilx, &page_allocated, fal=
se);
> +                               swp_entry(swp_type(entry), offset), gfp_m=
ask, mpol, ilx,
> +                               &page_allocated, false);
>                 if (!folio)
>                         continue;
>                 if (page_allocated) {
> @@ -600,41 +626,6 @@ struct folio *swap_cluster_readahead(swp_entry_t ent=
ry, gfp_t gfp_mask,
>         return folio;
>  }
>
> -int init_swap_address_space(unsigned int type, unsigned long nr_pages)
> -{
> -       struct address_space *spaces, *space;
> -       unsigned int i, nr;
> -
> -       nr =3D DIV_ROUND_UP(nr_pages, SWAP_ADDRESS_SPACE_PAGES);
> -       spaces =3D kvcalloc(nr, sizeof(struct address_space), GFP_KERNEL)=
;
> -       if (!spaces)
> -               return -ENOMEM;
> -       for (i =3D 0; i < nr; i++) {
> -               space =3D spaces + i;
> -               xa_init_flags(&space->i_pages, XA_FLAGS_LOCK_IRQ);
> -               atomic_set(&space->i_mmap_writable, 0);
> -               space->a_ops =3D &swap_aops;
> -               /* swap cache doesn't use writeback related tags */
> -               mapping_set_no_writeback_tags(space);
> -       }
> -       nr_swapper_spaces[type] =3D nr;
> -       swapper_spaces[type] =3D spaces;
> -
> -       return 0;
> -}
> -
> -void exit_swap_address_space(unsigned int type)
> -{
> -       int i;
> -       struct address_space *spaces =3D swapper_spaces[type];
> -
> -       for (i =3D 0; i < nr_swapper_spaces[type]; i++)
> -               VM_WARN_ON_ONCE(!mapping_empty(&spaces[i]));
> -       kvfree(spaces);
> -       nr_swapper_spaces[type] =3D 0;
> -       swapper_spaces[type] =3D NULL;
> -}
> -
>  static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
>                            unsigned long *end)
>  {
> @@ -807,7 +798,7 @@ static const struct attribute_group swap_attr_group =
=3D {
>         .attrs =3D swap_attrs,
>  };
>
> -static int __init swap_init_sysfs(void)
> +static int __init swap_init(void)
>  {
>         int err;
>         struct kobject *swap_kobj;
> @@ -822,11 +813,13 @@ static int __init swap_init_sysfs(void)
>                 pr_err("failed to register swap group\n");
>                 goto delete_obj;
>         }
> +       /* swap_space is set RO after init, so do it here before init end=
s. */
> +       mapping_set_no_writeback_tags(&swap_space);
>         return 0;
>
>  delete_obj:
>         kobject_put(swap_kobj);
>         return err;
>  }
> -subsys_initcall(swap_init_sysfs);
> +subsys_initcall(swap_init);
>  #endif
> diff --git a/mm/swap_table.h b/mm/swap_table.h
> new file mode 100644
> index 000000000000..ed9676547071
> --- /dev/null
> +++ b/mm/swap_table.h
> @@ -0,0 +1,106 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _MM_SWAP_TABLE_H
> +#define _MM_SWAP_TABLE_H
> +
> +#include "swap.h"
> +
> +/*
> + * A swap table entry represents the status of a swap slot on a swap
> + * (physical or virtual) device. The swap table in each cluster is a
> + * 1:1 map of the swap slots in this cluster.
> + *
> + * Each swap table entry could be a pointer (folio), a XA_VALUE
> + * (shadow), or NULL.
> + */
> +
> +/*
> + * Helpers for casting one type of info into a swap table entry.
> + */
> +static inline unsigned long null_to_swp_tb(void)
> +{
> +       BUILD_BUG_ON(sizeof(unsigned long) !=3D sizeof(atomic_long_t));
> +       return 0;
> +}
> +
> +static inline unsigned long folio_to_swp_tb(struct folio *folio)
> +{
> +       BUILD_BUG_ON(sizeof(unsigned long) !=3D sizeof(void *));
> +       return (unsigned long)folio;
> +}
> +
> +static inline unsigned long shadow_swp_to_tb(void *shadow)
> +{
> +       BUILD_BUG_ON((BITS_PER_XA_VALUE + 1) !=3D
> +                    BITS_PER_BYTE * sizeof(unsigned long));
> +       VM_WARN_ON_ONCE(shadow && !xa_is_value(shadow));
> +       return (unsigned long)shadow;
> +}
> +
> +/*
> + * Helpers for swap table entry type checking.
> + */
> +static inline bool swp_tb_is_null(unsigned long swp_tb)
> +{
> +       return !swp_tb;
> +}
> +
> +static inline bool swp_tb_is_folio(unsigned long swp_tb)
> +{
> +       return !xa_is_value((void *)swp_tb) && !swp_tb_is_null(swp_tb);
> +}
> +
> +static inline bool swp_tb_is_shadow(unsigned long swp_tb)
> +{
> +       return xa_is_value((void *)swp_tb);
> +}
> +
> +/*
> + * Helpers for retrieving info from swap table.
> + */
> +static inline struct folio *swp_tb_to_folio(unsigned long swp_tb)
> +{
> +       VM_WARN_ON(!swp_tb_is_folio(swp_tb));
> +       return (void *)swp_tb;
> +}
> +
> +static inline void *swp_tb_to_shadow(unsigned long swp_tb)
> +{
> +       VM_WARN_ON(!swp_tb_is_shadow(swp_tb));
> +       return (void *)swp_tb;
> +}
> +
> +/*
> + * Helpers for accessing or modifying the swap table of a cluster,
> + * the swap cluster must be locked.
> + */
> +static inline void __swap_table_set(struct swap_cluster_info *ci,
> +                                   unsigned int off, unsigned long swp_t=
b)
> +{
> +       VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> +       atomic_long_set(&ci->table[off], swp_tb);
> +}
> +
> +static inline unsigned long __swap_table_get(struct swap_cluster_info *c=
i,
> +                                            unsigned int off)
> +{
> +       VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> +       return atomic_long_read(&ci->table[off]);
> +}
> +
> +static inline void __swap_table_set_folio(struct swap_cluster_info *ci,
> +                                         unsigned int off, struct folio =
*folio)
> +{
> +       __swap_table_set(ci, off, folio_to_swp_tb(folio));
> +}
> +
> +static inline void __swap_table_set_shadow(struct swap_cluster_info *ci,
> +                                          unsigned int off, void *shadow=
)
> +{
> +       __swap_table_set(ci, off, shadow_swp_to_tb(shadow));
> +}
> +
> +static inline void __swap_table_init_null(struct swap_cluster_info *ci, =
unsigned int off)
> +{
> +       __swap_table_set(ci, off, null_to_swp_tb());
> +}
> +#endif
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 85606fbebf0f..df68b5e242a6 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -46,6 +46,7 @@
>  #include <asm/tlbflush.h>
>  #include <linux/swapops.h>
>  #include <linux/swap_cgroup.h>
> +#include "swap_table.h"
>  #include "internal.h"
>  #include "swap.h"
>
> @@ -268,7 +269,7 @@ static int __try_to_reclaim_swap(struct swap_info_str=
uct *si,
>         if (!need_reclaim)
>                 goto out_unlock;
>
> -       delete_from_swap_cache(folio);
> +       swap_cache_del_folio(folio);
>         folio_set_dirty(folio);
>         ret =3D nr_pages;
>  out_unlock:
> @@ -422,6 +423,34 @@ static inline unsigned int cluster_offset(struct swa=
p_info_struct *si,
>         return cluster_index(si, ci) * SWAPFILE_CLUSTER;
>  }
>
> +static int swap_table_alloc_table(struct swap_cluster_info *ci)
> +{
> +       WARN_ON(ci->table);
> +       ci->table =3D kzalloc(sizeof(unsigned long) * SWAPFILE_CLUSTER, G=
FP_KERNEL);
> +       if (!ci->table)
> +               return -ENOMEM;
> +       return 0;
> +}
> +
> +static void swap_cluster_free_table(struct swap_cluster_info *ci)
> +{
> +       unsigned int ci_off;
> +       unsigned long swp_tb;
> +
> +       if (!ci->table)
> +               return;
> +
> +       for (ci_off =3D 0; ci_off < SWAPFILE_CLUSTER; ci_off++) {
> +               swp_tb =3D __swap_table_get(ci, ci_off);
> +               if (!swp_tb_is_null(swp_tb))
> +                       pr_err_once("swap: unclean swap space on swapoff:=
 0x%lx",
> +                                   swp_tb);
> +       }
> +
> +       kfree(ci->table);
> +       ci->table =3D NULL;
> +}
> +
>  static void move_cluster(struct swap_info_struct *si,
>                          struct swap_cluster_info *ci, struct list_head *=
list,
>                          enum swap_cluster_flags new_flags)
> @@ -704,6 +733,25 @@ static bool cluster_scan_range(struct swap_info_stru=
ct *si,
>         return true;
>  }
>
> +/*
> + * Currently, the swap table is not used for count tracking,
> + * just do a sanity check to ensure nothing went wrong.
> + */
> +static void cluster_table_check(struct swap_cluster_info *ci,
> +                               unsigned int start, unsigned int nr)
> +{
> +       unsigned int ci_off =3D start % SWAPFILE_CLUSTER;
> +       unsigned int ci_end =3D ci_off + nr;
> +       unsigned long swp_tb;
> +
> +       if (IS_ENABLED(CONFIG_DEBUG_VM)) {
> +               do {
> +                       swp_tb =3D __swap_table_get(ci, ci_off);
> +                       VM_WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
> +               } while (++ci_off < ci_end);
> +       }
> +}
> +
>  static bool cluster_alloc_range(struct swap_info_struct *si, struct swap=
_cluster_info *ci,
>                                 unsigned int start, unsigned char usage,
>                                 unsigned int order)
> @@ -723,6 +771,7 @@ static bool cluster_alloc_range(struct swap_info_stru=
ct *si, struct swap_cluster
>                 ci->order =3D order;
>
>         memset(si->swap_map + start, usage, nr_pages);
> +       cluster_table_check(ci, start, nr_pages);
>         swap_range_alloc(si, nr_pages);
>         ci->count +=3D nr_pages;
>
> @@ -1100,8 +1149,7 @@ static void swap_range_alloc(struct swap_info_struc=
t *si,
>  static void swap_range_free(struct swap_info_struct *si, unsigned long o=
ffset,
>                             unsigned int nr_entries)
>  {
> -       unsigned long begin =3D offset;
> -       unsigned long end =3D offset + nr_entries - 1;
> +       unsigned long start =3D offset, end =3D offset + nr_entries - 1;
>         void (*swap_slot_free_notify)(struct block_device *, unsigned lon=
g);
>         unsigned int i;
>
> @@ -1125,7 +1173,7 @@ static void swap_range_free(struct swap_info_struct=
 *si, unsigned long offset,
>                         swap_slot_free_notify(si->bdev, offset);
>                 offset++;
>         }
> -       clear_shadow_from_swap_cache(si->type, begin, end);
> +       __swap_cache_clear_shadow(swp_entry(si->type, start), nr_entries)=
;
>
>         /*
>          * Make sure that try_to_unuse() observes si->inuse_pages reachin=
g 0
> @@ -1282,15 +1330,7 @@ int folio_alloc_swap(struct folio *folio, gfp_t gf=
p)
>         if (!entry.val)
>                 return -ENOMEM;
>
> -       /*
> -        * XArray node allocations from PF_MEMALLOC contexts could
> -        * completely exhaust the page allocator. __GFP_NOMEMALLOC
> -        * stops emergency reserves from being allocated.
> -        *
> -        * TODO: this could cause a theoretical memory reclaim
> -        * deadlock in the swap out path.
> -        */
> -       if (add_to_swap_cache(folio, entry, gfp | __GFP_NOMEMALLOC, NULL)=
)
> +       if (swap_cache_add_folio(entry, folio, NULL))
>                 goto out_free;
>
>         return 0;
> @@ -1557,6 +1597,7 @@ static void swap_entries_free(struct swap_info_stru=
ct *si,
>
>         mem_cgroup_uncharge_swap(entry, nr_pages);
>         swap_range_free(si, offset, nr_pages);
> +       cluster_table_check(ci, offset, nr_pages);
>
>         if (!ci->count)
>                 free_cluster(si, ci);
> @@ -1760,7 +1801,7 @@ bool folio_free_swap(struct folio *folio)
>         if (folio_swapped(folio))
>                 return false;
>
> -       delete_from_swap_cache(folio);
> +       swap_cache_del_folio(folio);
>         folio_set_dirty(folio);
>         return true;
>  }
> @@ -2634,6 +2675,18 @@ static void wait_for_allocation(struct swap_info_s=
truct *si)
>         }
>  }
>
> +static void free_cluster_info(struct swap_cluster_info *cluster_info,
> +                             unsigned long maxpages)
> +{
> +       int i, nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
> +
> +       if (!cluster_info)
> +               return;
> +       for (i =3D 0; i < nr_clusters; i++)
> +               swap_cluster_free_table(&cluster_info[i]);
> +       kvfree(cluster_info);
> +}
> +
>  /*
>   * Called after swap device's reference count is dead, so
>   * neither scan nor allocation will use it.
> @@ -2768,12 +2821,13 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spe=
cialfile)
>
>         swap_file =3D p->swap_file;
>         p->swap_file =3D NULL;
> -       p->max =3D 0;
>         swap_map =3D p->swap_map;
>         p->swap_map =3D NULL;
>         zeromap =3D p->zeromap;
>         p->zeromap =3D NULL;
>         cluster_info =3D p->cluster_info;
> +       free_cluster_info(cluster_info, p->max);
> +       p->max =3D 0;
>         p->cluster_info =3D NULL;
>         spin_unlock(&p->lock);
>         spin_unlock(&swap_lock);
> @@ -2784,10 +2838,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spec=
ialfile)
>         p->global_cluster =3D NULL;
>         vfree(swap_map);
>         kvfree(zeromap);
> -       kvfree(cluster_info);
>         /* Destroy swap account information */
>         swap_cgroup_swapoff(p->type);
> -       exit_swap_address_space(p->type);
>
>         inode =3D mapping->host;
>
> @@ -3171,8 +3223,11 @@ static struct swap_cluster_info *setup_clusters(st=
ruct swap_info_struct *si,
>         if (!cluster_info)
>                 goto err;
>
> -       for (i =3D 0; i < nr_clusters; i++)
> +       for (i =3D 0; i < nr_clusters; i++) {
>                 spin_lock_init(&cluster_info[i].lock);
> +               if (swap_table_alloc_table(&cluster_info[i]))
> +                       goto err_free;
> +       }
>
>         if (!(si->flags & SWP_SOLIDSTATE)) {
>                 si->global_cluster =3D kmalloc(sizeof(*si->global_cluster=
),
> @@ -3233,9 +3288,8 @@ static struct swap_cluster_info *setup_clusters(str=
uct swap_info_struct *si,
>         }
>
>         return cluster_info;
> -
>  err_free:
> -       kvfree(cluster_info);
> +       free_cluster_info(cluster_info, maxpages);
>  err:
>         return ERR_PTR(err);
>  }
> @@ -3429,13 +3483,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, speci=
alfile, int, swap_flags)
>                 }
>         }
>
> -       error =3D init_swap_address_space(si->type, maxpages);
> -       if (error)
> -               goto bad_swap_unlock_inode;
> -
>         error =3D zswap_swapon(si->type, maxpages);
>         if (error)
> -               goto free_swap_address_space;
> +               goto bad_swap_unlock_inode;
>
>         /*
>          * Flush any pending IO and dirty mappings before we start using =
this
> @@ -3470,8 +3520,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>         goto out;
>  free_swap_zswap:
>         zswap_swapoff(si->type);
> -free_swap_address_space:
> -       exit_swap_address_space(si->type);
>  bad_swap_unlock_inode:
>         inode_unlock(inode);
>  bad_swap:
> @@ -3486,7 +3534,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>         spin_unlock(&swap_lock);
>         vfree(swap_map);
>         kvfree(zeromap);
> -       kvfree(cluster_info);
> +       if (cluster_info)
> +               free_cluster_info(cluster_info, maxpages);
>         if (inced_nr_rotate_swap)
>                 atomic_dec(&nr_rotate_swap);
>         if (swap_file)
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b0afd7f41a22..1ed3cf9dac4e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -730,13 +730,18 @@ static int __remove_mapping(struct address_space *m=
apping, struct folio *folio,
>  {
>         int refcount;
>         void *shadow =3D NULL;
> +       struct swap_cluster_info *ci;
>
>         BUG_ON(!folio_test_locked(folio));
>         BUG_ON(mapping !=3D folio_mapping(folio));
>
> -       if (!folio_test_swapcache(folio))
> +       if (folio_test_swapcache(folio)) {
> +               ci =3D swap_cluster_lock_by_folio_irq(folio);

One line does not require "{"

> +       } else {
>                 spin_lock(&mapping->host->i_lock);
> -       xa_lock_irq(&mapping->i_pages);
> +               xa_lock_irq(&mapping->i_pages);
> +       }
> +
>         /*
>          * The non racy check for a busy folio.
>          *
> @@ -776,9 +781,9 @@ static int __remove_mapping(struct address_space *map=
ping, struct folio *folio,
>
>                 if (reclaimed && !mapping_exiting(mapping))
>                         shadow =3D workingset_eviction(folio, target_memc=
g);
> -               __delete_from_swap_cache(folio, swap, shadow);
> +               __swap_cache_del_folio(swap, folio, shadow);
>                 memcg1_swapout(folio, swap);
> -               xa_unlock_irq(&mapping->i_pages);
> +               swap_cluster_unlock_irq(ci);
>                 put_swap_folio(folio, swap);
>         } else {
>                 void (*free_folio)(struct folio *);
> @@ -816,9 +821,12 @@ static int __remove_mapping(struct address_space *ma=
pping, struct folio *folio,
>         return 1;
>
>  cannot_free:
> -       xa_unlock_irq(&mapping->i_pages);
> -       if (!folio_test_swapcache(folio))
> +       if (folio_test_swapcache(folio)) {
> +               swap_cluster_unlock_irq(ci);
> +       } else {
> +               xa_unlock_irq(&mapping->i_pages);
>                 spin_unlock(&mapping->host->i_lock);
> +       }
>         return 0;
>  }
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ee443b317ac7..c869859eec77 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1166,7 +1166,7 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
>
>  out:
>         if (ret && ret !=3D -EEXIST) {
> -               delete_from_swap_cache(folio);
> +               swap_cache_del_folio(folio);
>                 folio_unlock(folio);
>         }
>         folio_put(folio);
> --
> 2.51.0
>

