Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC4DCCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 05:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9C66B00ED; Fri,  8 May 2026 01:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57AB46B00EF; Fri,  8 May 2026 01:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490986B00F2; Fri,  8 May 2026 01:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 387496B00ED
	for <linux-mm@kvack.org>; Fri,  8 May 2026 01:03:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAD59160715
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:03:06 +0000 (UTC)
X-FDA: 84743058372.01.4EFA1C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E1CC740009
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:03:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZmoHjLb/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778216585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wgW4NtCgA01R+nBQlkqiDk7NeJ1CEOf1gbt/m13bUmc=;
	b=zJN+NfD8aIB5rSTm/5IIYOt1GWhixI5UHR6YYgQQ0hMKthy/ipb0FpwoXDsnTsiCONTrW0
	z29vRG4kJlqkZONU6/gNMTSjRuiYo79J4QWH+n+Hmer6TjSnhaaetZ6WODvqYNlrS6+Hky
	BYQn/ZHTBual+9KFY7ZyKSAA+QU1Hrw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778216585; a=rsa-sha256;
	cv=none;
	b=8NCjNKH3pGLZ78KBpynoSVOFycpC1QpKgJqnmoNcYzP5vupdzrAy1m14cDpRbHKzHXmrXV
	2gD9Pe4uN4itLKmkP01ZK8jvc5Rn2Pi3K9uZyHHRxNGKV8I3Vav0nZ6hS6s0g0kjxY8EEL
	SMlhFTUmaMP6jECPy4NoNo2R/GB13HU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZmoHjLb/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A18D344232
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCC6C2BCF5
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778216583;
	bh=pvhofntp9fIH4mJaNNksnvFNACL/qXOHhn0SN5yzXTg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZmoHjLb/9ZR+EA0YoF4rDDTUbwO+FT2BTWsm106TVcugL2YKM1dkdqGM4+hiKjlCI
	 d/SrpEw6VTDDY4DMSVoobpcQjLJKNxAog4G4CUYxk1+olrppNAnyIzvEaW+Ml1QGd1
	 cf00Njhe+HxvGKDVvhlkMR3yWjY7X1WFhAQBi2Nm/YZRTqTABRzrkgPOAfPqsWmJdU
	 cr5AUlUi5c0k2Wcx+XT8j4dBFjWn9itZMI0inNMc+xOnMN4MrnTmeioL57XmU6EOSC
	 uUg++J4nHFkjZN0m2516dB5/RJcLvCNZ0XZORD2IGtasZNs5C7q/d1cV3ie3YeJDlo
	 nByZa1ZCS06rA==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-65c305f381eso1801022d50.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 22:03:03 -0700 (PDT)
X-Gm-Message-State: AOJu0YwIyM0HZ0EiOOB2YPqbm2h19DWRb09pvCPjRhj2zaAvJMVJDI8w
	wroYOIZCOU+dJLBFoI3mW8uocF6dnqvMBNp774Kt9Up5L8S13vX3ZN+9j2dm2siTeCkkicut6lE
	S7jMHYErdKaiTXnddnPo6D1Sb+mRBmkmhR3EUEPlmHA==
X-Received: by 2002:a05:690e:4410:b0:654:6a61:fb5a with SMTP id
 956f58d0204a3-65c7988c04cmr8359043d50.2.1778216582806; Thu, 07 May 2026
 22:03:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com> <20260421-swap-table-p4-v3-9-2f23759a76bc@tencent.com>
In-Reply-To: <20260421-swap-table-p4-v3-9-2f23759a76bc@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 8 May 2026 07:02:51 +0200
X-Gmail-Original-Message-ID: <CACePvbUL5m-QniPLqRSrwmWDEpvVcM2DjCRggR+cy7PoEZBfYw@mail.gmail.com>
X-Gm-Features: AVHnY4Iw2Yw0C4zZB_QSvaFciSxejqqywdSjTcDEpmlXjSWF5O_Cm-Ti_YjH_wc
Message-ID: <CACePvbUL5m-QniPLqRSrwmWDEpvVcM2DjCRggR+cy7PoEZBfYw@mail.gmail.com>
Subject: Re: [PATCH v3 09/12] mm, swap: consolidate cluster allocation helpers
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E1CC740009
X-Stat-Signature: r3kf14ozc4jizhhmbt7nkokkfwgnrott
X-Rspam-User: 
X-HE-Tag: 1778216584-409673
X-HE-Meta: U2FsdGVkX187LE1gMsIDALi6e8TBcmI79oZj+GR76N2PkAIRA6zXncY8jmuFsFdnWLIOTqYuTj7QM1e0QngWJ+awZL1e15/RNL/anF2EQpZWN5O+1h4ddYt/qsLZUVDe17hwsESypxamPU3vnL8+PI4Pka0RAFgXBJ/5ZYMpx5gOafKov2PgYICyAhVKYlPLYQuwYOci02pJYbouLj4S/37myyHRwcB3HOjxNO29X8Y+Tt1Tn9fhruf5hH8mC5sou3gj37lINqfRzXQZ1tEFa0fnZLAvOqMl5yv+aOZlEkmnry7wPD+3wuDDJ5XhTLamQqQljyEMdOk7xjJ86u3S9TZhBiJ6Bpa837uWXYijHM8vknTgsWxgCLpmLgroyTjhSHhsj0cUqictP6VyQzhx8+1HIm1Q44pKLgKQHoc977h0N/EWcNNkfPkLyI/IBBufzVEoNYs5K6oC8i1DymLol/YUV/c+PoBkbVMZnyYqD9OpFl+0nyNM/4n+E1SRyFrI/dMzi4CZ+2uFNZnW+CXwswkqFZVJavU2GJAaS5Td1QYNBBiPfJdnfgjIwCpWlBQ5Bg7c5Fg4fCgO+9DuJxU5aagSVmZBNA2SEd+7YhZAePMYnyjdfJq4AtuTQ6OY01OGZ1TjYdKKM7BDyutHu2n+VOdN7hnf6ZvpLjclR8++33ruVGwVpoPjgG/InjiiRD826PTetuVJt3DS8Afg2TrY+wuLt41T7YY3en3ysAnp5T9RlCLgjX3aSm+roPoTYso1glK+bVRsldcewVT+uZRILlX+K5GOE5iWhhbYNQ6MnTzE2wqEp+xKNScp8cYi0i0CwCKgz4IyzmjD+t3xwDso/eo22o9t+UsJov5LGajbf2PXjGLxZZAiQCKxOHjKA9XLV13+3wNzVpIRhM6dtO93dRbbnxUDV67ruY/qB0SDG3WJfzhJmJHaf/98RyKqk0303pogZEdjhE0JER5IH8u
 Zy0dso3g
 l7K8BhVVHTZ/kUAV59Nd/TmC86luW5nFMMyfeH3d63tL0QpVFs6N4IPTjsiZVmiyjUebAef89pG16l49u17TLwRzATiKSkR1VCzSrRx8xHnN9AXFv8gcyl+KkgNH8xvxrL/lPFDmMOO3eSLXh8TqDEbzWIKiqT33ET0Oy9yssgmBInOBjnN8Osbw8Aq7lAzClJRFFXzYHhQBP8LRzKqx6jJLZZ9Z4EJ6zVGQht3iVvCD4qqxq9jHzoBs4nBnIZBTnkMAXDZlcjJsaoIfbTUkoxgqnJ5KvKbLqzHsLWejsAu1bWA8rQiNwnCToJblI/u/rdMskuL3K7xT/MY0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 2:16=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Swap cluster table management is spread across several narrow
> helpers. As a result, the allocation and fallback sequences are
> open-coded in multiple places.
>
> A few more per-cluster tables will be added soon, so avoid
> duplicating these sequences per table type. Fold the existing
> pairs into cluster-oriented helpers, and rename for consistency.
>
> No functional change, only a few sanity checks are slightly adjusted.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/swapfile.c | 110 ++++++++++++++++++++++++++--------------------------=
------
>  1 file changed, 49 insertions(+), 61 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 8d3d22c463f3..2d16aa89a4fd 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -411,20 +411,7 @@ static inline unsigned int cluster_offset(struct swa=
p_info_struct *si,
>         return cluster_index(si, ci) * SWAPFILE_CLUSTER;
>  }
>
> -static struct swap_table *swap_table_alloc(gfp_t gfp)
> -{
> -       struct folio *folio;
> -
> -       if (!SWP_TABLE_USE_PAGE)
> -               return kmem_cache_zalloc(swap_table_cachep, gfp);
> -
> -       folio =3D folio_alloc(gfp | __GFP_ZERO, 0);
> -       if (folio)
> -               return folio_address(folio);
> -       return NULL;
> -}
> -
> -static void swap_table_free_folio_rcu_cb(struct rcu_head *head)
> +static void swap_cluster_free_table_folio_rcu_cb(struct rcu_head *head)
>  {
>         struct folio *folio;
>
> @@ -432,15 +419,46 @@ static void swap_table_free_folio_rcu_cb(struct rcu=
_head *head)
>         folio_put(folio);
>  }
>
> -static void swap_table_free(struct swap_table *table)
> +static void swap_cluster_free_table(struct swap_cluster_info *ci)
>  {
> +       struct swap_table *table;
> +
> +       table =3D (struct swap_table *)rcu_dereference_protected(ci->tabl=
e, true);
> +       if (!table)
> +               return;
> +
> +       rcu_assign_pointer(ci->table, NULL);
>         if (!SWP_TABLE_USE_PAGE) {
>                 kmem_cache_free(swap_table_cachep, table);
>                 return;
>         }
>
>         call_rcu(&(folio_page(virt_to_folio(table), 0)->rcu_head),
> -                swap_table_free_folio_rcu_cb);
> +                swap_cluster_free_table_folio_rcu_cb);
> +}
> +
> +static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t =
gfp)
> +{
> +       struct swap_table *table =3D NULL;
> +       struct folio *folio;
> +
> +       /* The cluster must be empty and not on any list during allocatio=
n. */
> +       VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
> +       if (rcu_access_pointer(ci->table))
> +               return 0;
> +
> +       if (SWP_TABLE_USE_PAGE) {
> +               folio =3D folio_alloc(gfp | __GFP_ZERO, 0);
> +               if (folio)
> +                       table =3D folio_address(folio);
> +       } else {
> +               table =3D kmem_cache_zalloc(swap_table_cachep, gfp);
> +       }
> +       if (!table)
> +               return -ENOMEM;
> +
> +       rcu_assign_pointer(ci->table, table);
> +       return 0;
>  }
>
>  /*
> @@ -471,27 +489,15 @@ static void swap_cluster_assert_empty(struct swap_c=
luster_info *ci,
>         WARN_ON_ONCE(nr =3D=3D SWAPFILE_CLUSTER && ci->extend_table);
>  }
>
> -static void swap_cluster_free_table(struct swap_cluster_info *ci)
> -{
> -       struct swap_table *table;
> -
> -       /* Only empty cluster's table is allow to be freed  */
> -       lockdep_assert_held(&ci->lock);
> -       table =3D (void *)rcu_dereference_protected(ci->table, true);
> -       rcu_assign_pointer(ci->table, NULL);
> -
> -       swap_table_free(table);
> -}
> -
>  /*
>   * Allocate swap table for one cluster. Attempt an atomic allocation fir=
st,
>   * then fallback to sleeping allocation.
>   */
>  static struct swap_cluster_info *
> -swap_cluster_alloc_table(struct swap_info_struct *si,
> +swap_cluster_populate(struct swap_info_struct *si,
>                          struct swap_cluster_info *ci)
>  {
> -       struct swap_table *table;
> +       int ret;
>
>         /*
>          * Only cluster isolation from the allocator does table allocatio=
n.
> @@ -502,14 +508,9 @@ swap_cluster_alloc_table(struct swap_info_struct *si=
,
>                 lockdep_assert_held(&si->global_cluster_lock);
>         lockdep_assert_held(&ci->lock);
>
> -       /* The cluster must be free and was just isolated from the free l=
ist. */
> -       VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
> -
> -       table =3D swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_=
NOWARN);
> -       if (table) {
> -               rcu_assign_pointer(ci->table, table);
> +       if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
> +                                         __GFP_NOWARN))
>                 return ci;
> -       }
>
>         /*
>          * Try a sleep allocation. Each isolated free cluster may cause
> @@ -521,7 +522,8 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
>                 spin_unlock(&si->global_cluster_lock);
>         local_unlock(&percpu_swap_cluster.lock);
>
> -       table =3D swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | GFP_KE=
RNEL);
> +       ret =3D swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLO=
C |
> +                                          GFP_KERNEL);
>
>         /*
>          * Back to atomic context. We might have migrated to a new CPU wi=
th a
> @@ -536,20 +538,11 @@ swap_cluster_alloc_table(struct swap_info_struct *s=
i,
>                 spin_lock(&si->global_cluster_lock);
>         spin_lock(&ci->lock);
>
> -       /* Nothing except this helper should touch a dangling empty clust=
er. */
> -       if (WARN_ON_ONCE(cluster_table_is_alloced(ci))) {
> -               if (table)
> -                       swap_table_free(table);
> -               return ci;
> -       }
> -
> -       if (!table) {
> +       if (ret) {
>                 move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FRE=
E);
>                 spin_unlock(&ci->lock);
>                 return NULL;
>         }
> -
> -       rcu_assign_pointer(ci->table, table);
>         return ci;
>  }
>
> @@ -621,12 +614,11 @@ static struct swap_cluster_info *isolate_lock_clust=
er(
>         }
>         spin_unlock(&si->lock);
>
> -       if (found && !cluster_table_is_alloced(found)) {
> -               /* Only an empty free cluster's swap table can be freed. =
*/
> -               VM_WARN_ON_ONCE(flags !=3D CLUSTER_FLAG_FREE);
> +       /* Cluster's table is freed when and only when it's on the free l=
ist. */
> +       if (found && flags =3D=3D CLUSTER_FLAG_FREE) {
>                 VM_WARN_ON_ONCE(list !=3D &si->free_clusters);
> -               VM_WARN_ON_ONCE(!cluster_is_empty(found));
> -               return swap_cluster_alloc_table(si, found);
> +               VM_WARN_ON_ONCE(cluster_table_is_alloced(found));
> +               return swap_cluster_populate(si, found);
>         }
>
>         return found;
> @@ -769,7 +761,6 @@ static int swap_cluster_setup_bad_slot(struct swap_in=
fo_struct *si,
>         unsigned int ci_off =3D offset % SWAPFILE_CLUSTER;
>         unsigned long idx =3D offset / SWAPFILE_CLUSTER;
>         struct swap_cluster_info *ci;
> -       struct swap_table *table;
>         int ret =3D 0;
>
>         /* si->max may got shrunk by swap swap_activate() */
> @@ -790,12 +781,9 @@ static int swap_cluster_setup_bad_slot(struct swap_i=
nfo_struct *si,
>         }
>
>         ci =3D cluster_info + idx;
> -       if (!ci->table) {
> -               table =3D swap_table_alloc(GFP_KERNEL);
> -               if (!table)
> -                       return -ENOMEM;
> -               rcu_assign_pointer(ci->table, table);
> -       }
> +       /* Need to allocate swap table first for initial bad slot marking=
. */
> +       if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
> +               return -ENOMEM;
>         spin_lock(&ci->lock);
>         /* Check for duplicated bad swap slots. */
>         if (__swap_table_xchg(ci, ci_off, SWP_TB_BAD) !=3D SWP_TB_NULL) {
> @@ -2992,7 +2980,7 @@ static void free_swap_cluster_info(struct swap_clus=
ter_info *cluster_info,
>                 ci =3D cluster_info + i;
>                 /* Cluster with bad marks count will have a remaining tab=
le */
>                 spin_lock(&ci->lock);
> -               if (rcu_dereference_protected(ci->table, true)) {
> +               if (cluster_table_is_alloced(ci)) {
>                         swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER=
, true);
>                         swap_cluster_free_table(ci);
>                 }
>
> --
> 2.53.0
>
>

