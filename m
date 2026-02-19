Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03041E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 07:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60B066B0088; Thu, 19 Feb 2026 02:01:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DFC26B0089; Thu, 19 Feb 2026 02:01:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5061E6B008A; Thu, 19 Feb 2026 02:01:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3CFC66B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:01:16 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09C6714045E
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:01:16 +0000 (UTC)
X-FDA: 84460309752.03.287D960
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E560B1A0002
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:01:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pIscfHUi;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771484474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dQm06OrjRil0mytb+X0ql3n/VTAy4k9IVRr4C85NVo=;
	b=PKnx5w/s3XsHtwA/4eExlGxm9I3h/oO3JSyCXNkY9+1eNybEdzL/KhpQh3rgZnK2a9emde
	fBgw/bDx6ENIBrbtGG+hI4Yl/sH+e0yiwfALL2FlG9RMthTtNDqe5Dj/Pbr7TnLmZYgdtO
	xldn4KVww/bKfgz+X1GYjymQDoY9R6M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pIscfHUi;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771484474; a=rsa-sha256;
	cv=none;
	b=URQL4ZtOsEXCAzV3Egwo6E1Xm/TJBJYYC1NCnfKMGlrqVW1k7fgGUNv/OL2czacCDytpzI
	tBB8yQdEuX8WThwWOFjc8iyK/IJwPDKhQVeLhbmuIXx/FSqTO3tq55IaPnCvavFVqxVG3D
	iRCF04eNAeRtrjKs3bXOJgBsTFrZo2I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BF1E43ECF
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083F5C19423
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771484473;
	bh=axWfvdNtUUIefpNfL/TztuOJLEY47y3bwWxx1ovpkI0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pIscfHUi9TUscEbo2CuSCh4k53Fi6zkvEqmsZmsoxL930xSLWsMD5SfOdc/2auW1p
	 K/j+jJVpU2jaaKROZIYt6KnjH79Sl5QIwXjXQigvFsJo9PCsF5pqRHsIZyhEkgb3Be
	 OJ+PngRym+Yko4nmNjg+XbC+T2CteuhXUxFj3P3dfYMOL5j+sqwQfAGedmgWENTZTQ
	 ARkSQZKcACZgimOMHa/3u8wuoJZMaK2FvF5cU6gQW8r7Av2aKwO9b8xtC9dzJz+ThN
	 JGnzpnyDG7pTTdBzFz6mlLzoCDDVNV0e76bN+R1Vp2WNzOJkY5Nhp3kCC0t+Guj4U4
	 ku0Iss8m+yllw==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-79430ef54c3so5172177b3.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:01:12 -0800 (PST)
X-Gm-Message-State: AOJu0YyLmQeAnSIYyBLpVrAjT+vqPSKNhxl/7EyclDFrGz4u9r4FuxJW
	6BBcGlqLRD0x6m6efs59ne+4bdzBc6oIiZGLocd/c61/THSPEzCKC90OIl1G2LKrQV3r0k1x8yq
	nda7QzF3qtpBXfvKkSyfSXaEuO65CQbCqPWWcTOM87g==
X-Received: by 2002:a53:ac83:0:b0:64c:2114:1766 with SMTP id
 956f58d0204a3-64c21b27746mr12878734d50.45.1771484472261; Wed, 18 Feb 2026
 23:01:12 -0800 (PST)
MIME-Version: 1.0
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com> <20260218-swap-table-p3-v3-7-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-7-f4e34be021a7@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 18 Feb 2026 23:01:01 -0800
X-Gmail-Original-Message-ID: <CACePvbV1bmL_5=ogmDCSRSr6AS97taNpKQ1n6+wNhx3hVNYxPA@mail.gmail.com>
X-Gm-Features: AZwV_QiP4cdR3MeQN-i3G5QqxAEXvxAFJjSu3bRFkr54LCR84Dk2bpsAjpSwjwA
Message-ID: <CACePvbV1bmL_5=ogmDCSRSr6AS97taNpKQ1n6+wNhx3hVNYxPA@mail.gmail.com>
Subject: Re: [PATCH v3 07/12] mm, swap: mark bad slots in swap table directly
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gutyctdhdmbjuhohhidnos49j4d6wbmc
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: E560B1A0002
X-HE-Tag: 1771484473-227185
X-HE-Meta: U2FsdGVkX19B+qZQ3Q9Narvm8RuVbVNNGliDTCUbgBWI8R2xoVWlQAw2B3DQbbYeOmYfJ31AtoKK2Ixgm0OJHhl+kU3dU1NUwqVylWJF+X40yL+1IE+BqKBxDhwB1fvBxvHFHECimRU83G09fc2xoFtpv0p3/B6bxgPLvykasfJ6Lk4c6VifNlUoCsSmldrEeUmcnkb4cdmzT2OGnIzdpr8NlYmPHrOV80bDqDADVxClhaFa3mQfssFWwmnt++ikJyRhaJATTRiu2TKb7dDXYUDSVxnCe3VfDPWKUEyoiSNNJwekeyQB0uG59vdkq7Lp7JzAud/ButTneL/5KzxabldNN4mU0uOgNJBqMzYp8Ea2cZ5lSaHJnuWdeU/P6akGgOYOCWw7VS9nmOFBt7AtfuMkNaj47QHAsz0naPX6ZoJGEW3b51DeFksUaIW+pNicJQ+RJmDDqONVhqShdPgGHSUmOcXsYSNMuPJ01huDgmCIh2SsE2YYliZZa3SWz5pYUvV0ebdfORSnT/XtT5HXFJrJm91UtUHGg5pobQzUKLpiSJtxwKW2KmB3+qujcLsLfO/0wo0rUPiaBbvpurojvDInvLt6Xaipu1C+eFwPYBAMYLXE6A70Rc976k/2mFytr1syddEeD5RlywdGV4SC5GerrJT6kqiG9piW5F+9dPou8OomBWehdoVyCOVNBxF08u31Snep7KPyYmgGApK0nls9xVWLp+DampUbIDE1LApSyQ5/1PsBFCykYtZkrbu4eLkNRCb+/qhN0mKG7jZ0BY5xPJDwlAnMJbZsG1pUiFN+miz0Xsw0oIOCMjqBiAAgZ8IhEDuHBCxO1b2wCUUlJLvTAodTzzKEFJsy4DO6ezmGaKLe33F91dHsxKXdQyFVM5OlJlC3Snuu2h83NT4RNU3k8e+6jC/xm+2RLqggAtHfARHOqARLvRmFjWXcsNsddK90LmamJggokaP/4Zt
 he9GE8PZ
 U9cR3AJuBC03ztv4nKaPGZO1kI46qzhMXEzoe9rjfOsCrJdOAaeg7nV5DxFt5teJDl5blK7Bu1yfDmXK7fw11i7u9oegfe+efgmLUDyo9CpuUgR1462hMhBQO4f9owxu58ETDg7WPiEpZZtBWgHbzN27aRlzP6L9IUDlahy2UJXnRKIZuLKw05aSBdOVkaYXAxEDiHCNoKjH6yzuU2DaiHVJyuSOal5JCfIxDBH6/HrZ9dflHJgagrcbfmBWv/ehYJqATxMq0IsIT6bagbAXcWMJlxkaF9m2lzcEQt8lZQDMOuNziAvns4XhYvAkISLpmLMMXMbVIRYS//XE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 12:06=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> In preparing the deprecating swap_map, mark bad slots in the swap table
> too when setting SWAP_MAP_BAD in swap_map. Also, refine the swap table
> sanity check on freeing to adapt to the bad slots change. For swapoff,
> the bad slots count must match the cluster usage count, as nothing
> should touch them, and they contribute to the cluster usage count on
> swapon. For ordinary swap table freeing, the swap table of clusters with
> bad slots should never be freed since the cluster usage count never
> reaches zero.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/swapfile.c | 56 +++++++++++++++++++++++++++++++++++++++++------------=
---
>  1 file changed, 41 insertions(+), 15 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 91c1fa804185..18bacf16cd26 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -454,16 +454,37 @@ static void swap_table_free(struct swap_table *tabl=
e)
>                  swap_table_free_folio_rcu_cb);
>  }
>
> +/*
> + * Sanity check to ensure nothing leaked, and the specified range is emp=
ty.
> + * One special case is that bad slots can't be freed, so check the numbe=
r of
> + * bad slots for swapoff, and non-swapoff path must never free bad slots=
.
> + */
> +static void swap_cluster_assert_empty(struct swap_cluster_info *ci, bool=
 swapoff)
> +{
> +       unsigned int ci_off =3D 0, ci_end =3D SWAPFILE_CLUSTER;
> +       unsigned long swp_tb;
> +       int bad_slots =3D 0;
> +
> +       if (!IS_ENABLED(CONFIG_DEBUG_VM) && !swapoff)
> +               return;
> +
> +       do {
> +               swp_tb =3D __swap_table_get(ci, ci_off);
> +               if (swp_tb_is_bad(swp_tb))
> +                       bad_slots++;
> +               else
> +                       WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
> +       } while (++ci_off < ci_end);
> +
> +       WARN_ON_ONCE(bad_slots !=3D (swapoff ? ci->count : 0));
> +}
> +
>  static void swap_cluster_free_table(struct swap_cluster_info *ci)
>  {
> -       unsigned int ci_off;
>         struct swap_table *table;
>
>         /* Only empty cluster's table is allow to be freed  */
>         lockdep_assert_held(&ci->lock);
> -       VM_WARN_ON_ONCE(!cluster_is_empty(ci));
> -       for (ci_off =3D 0; ci_off < SWAPFILE_CLUSTER; ci_off++)
> -               VM_WARN_ON_ONCE(!swp_tb_is_null(__swap_table_get(ci, ci_o=
ff)));
>         table =3D (void *)rcu_dereference_protected(ci->table, true);
>         rcu_assign_pointer(ci->table, NULL);
>
> @@ -567,6 +588,7 @@ static void swap_cluster_schedule_discard(struct swap=
_info_struct *si,
>
>  static void __free_cluster(struct swap_info_struct *si, struct swap_clus=
ter_info *ci)
>  {
> +       swap_cluster_assert_empty(ci, false);
>         swap_cluster_free_table(ci);
>         move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
>         ci->order =3D 0;
> @@ -747,9 +769,11 @@ static int swap_cluster_setup_bad_slot(struct swap_i=
nfo_struct *si,
>                                        struct swap_cluster_info *cluster_=
info,
>                                        unsigned int offset, bool mask)
>  {
> +       unsigned int ci_off =3D offset % SWAPFILE_CLUSTER;
>         unsigned long idx =3D offset / SWAPFILE_CLUSTER;
> -       struct swap_table *table;
>         struct swap_cluster_info *ci;
> +       struct swap_table *table;
> +       int ret =3D 0;
>
>         /* si->max may got shrunk by swap swap_activate() */
>         if (offset >=3D si->max && !mask) {
> @@ -767,13 +791,7 @@ static int swap_cluster_setup_bad_slot(struct swap_i=
nfo_struct *si,
>                 pr_warn("Empty swap-file\n");
>                 return -EINVAL;
>         }
> -       /* Check for duplicated bad swap slots. */
> -       if (si->swap_map[offset]) {
> -               pr_warn("Duplicated bad slot offset %d\n", offset);
> -               return -EINVAL;
> -       }
>
> -       si->swap_map[offset] =3D SWAP_MAP_BAD;
>         ci =3D cluster_info + idx;
>         if (!ci->table) {
>                 table =3D swap_table_alloc(GFP_KERNEL);
> @@ -781,13 +799,21 @@ static int swap_cluster_setup_bad_slot(struct swap_=
info_struct *si,
>                         return -ENOMEM;
>                 rcu_assign_pointer(ci->table, table);
>         }
> -
> -       ci->count++;
> +       spin_lock(&ci->lock);
> +       /* Check for duplicated bad swap slots. */
> +       if (__swap_table_xchg(ci, ci_off, SWP_TB_BAD) !=3D SWP_TB_NULL) {
> +               pr_warn("Duplicated bad slot offset %d\n", offset);
> +               ret =3D -EINVAL;
> +       } else {
> +               si->swap_map[offset] =3D SWAP_MAP_BAD;
> +               ci->count++;
> +       }
> +       spin_unlock(&ci->lock);
>
>         WARN_ON(ci->count > SWAPFILE_CLUSTER);
>         WARN_ON(ci->flags);
>
> -       return 0;
> +       return ret;
>  }
>
>  /*
> @@ -2754,7 +2780,7 @@ static void free_swap_cluster_info(struct swap_clus=
ter_info *cluster_info,
>                 /* Cluster with bad marks count will have a remaining tab=
le */
>                 spin_lock(&ci->lock);
>                 if (rcu_dereference_protected(ci->table, true)) {
> -                       ci->count =3D 0;
> +                       swap_cluster_assert_empty(ci, true);
>                         swap_cluster_free_table(ci);
>                 }
>                 spin_unlock(&ci->lock);
>
> --
> 2.52.0
>
>

