Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 929D9CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFC788E0010; Tue,  2 Sep 2025 08:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4128E0001; Tue,  2 Sep 2025 08:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D112B8E0010; Tue,  2 Sep 2025 08:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0C388E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:18:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90DC8116F95
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:18:11 +0000 (UTC)
X-FDA: 83844212382.21.0D280F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B36C98000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:18:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dvoF5wYz;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756815489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVE09nG4LqyQ/Albb7V9ObnGMx5f128rOZ7yeletNX4=;
	b=iSkVqgJxf+whIgrUudremAExyZV7QGyf2soFyl+VrbJQ/I9Koak63Xy+H01DitpxED2MHh
	ER0+MtEqMLKGAeFPiTDbit5w4uQbMND5BMM+iK9Zq5Bsxiunz1raOIyu7DyLy1XmryGv8V
	iUCHIobqQ0Pgnpq1u70YiES6KmNOUAE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dvoF5wYz;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756815489; a=rsa-sha256;
	cv=none;
	b=hk6zmAklV98fvp/kUte9YcwYa3ggEByrw6se0O1kaTBAqKIm4XeQ/zYDHeHiZg54VUJYWz
	UTpuLb8d8E4HZOvqoCM62D+K994pyg6k1oh8WP8l9znuOuHn28vKs6u9VQoEWROi4ZiszT
	iobtvukbmDTndiyCaahq0Zup912hTXo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE3C16020C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852C3C4CEFD
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756815488;
	bh=ZTSQwA+EpSV9+ojOsAvLyoFKMHNvauRlTuvilm25yM4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dvoF5wYzcFG9Nrl6nny3ed0swGUNu7wEsqqlI6jaIUZ7UWokOtEe8tpEM+cpYYl93
	 Xemi+o08AjNxxBWzRTXO8FxLzzbJcxrmrBAQ7hzud0ySVzUUTWkQ3FxH51A5hoGq66
	 7RAm5R+RIHBCDYyxiMAvhH8luvUhtQgG80KgBZgQrl9oZrKXyODkFpiXsVHYVWduDy
	 vg3qArNHOBTeQF0i0Dr1UyNuiBv6bLAprg06d5dS97krGEb6+oYVMM5Iv26mzleYNj
	 REs0jtz7dg0TP55oRyGCgkm9/67SYd/Iwi2MJKm6VKEjAR/3yNoBOfUJKyo6rIg1Pb
	 Q3hgOnOUcWYnQ==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-723ad237d1eso3743817b3.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 05:18:08 -0700 (PDT)
X-Gm-Message-State: AOJu0YyCZlwBAWdd6wRzkMfSznDL5XW2p2ksZisD3Fn4TNioFM5aqnZq
	FO8fV59gO/Pw8wLCkbAeTt5wvoFHVLyZpIlqnXdLpTEOJPzHHhGcl3tkkfDjP6YFI6f4SnuOlp4
	k1WAal4J05kh+bFsmzf1U0R0nuC4UQRDi2wvABSyqGw==
X-Google-Smtp-Source: AGHT+IF/fv8Z/lXj5JP5clHJ8aYfTcZOW+8f7Hi0XMCpJtw1fdJZ8y33yDnQyUMOboAz/G8jvSnLVwL7BHJdmVDe/zg=
X-Received: by 2002:a05:690c:6c8f:b0:722:731d:f622 with SMTP id
 00721157ae682-7227636c98cmr110511477b3.17.1756815487736; Tue, 02 Sep 2025
 05:18:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250806161748.76651-1-ryncsn@gmail.com> <20250806161748.76651-3-ryncsn@gmail.com>
In-Reply-To: <20250806161748.76651-3-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 2 Sep 2025 05:17:56 -0700
X-Gmail-Original-Message-ID: <CACePvbWbNeQ1+nk_BHgFyyFM0m1iQvXqa09iPWTRnsUp5Be_Yg@mail.gmail.com>
X-Gm-Features: Ac12FXwYM-QjowMD2uLpV6vp34CLhFUBAr49slLfUGLs_PraM_RMeUsbnnKX7LE
Message-ID: <CACePvbWbNeQ1+nk_BHgFyyFM0m1iQvXqa09iPWTRnsUp5Be_Yg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm, swap: remove fragment clusters counter
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B36C98000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: wbjp67q1e3149zynbfogjy8c77kypyax
X-HE-Tag: 1756815489-83654
X-HE-Meta: U2FsdGVkX1/RZm62RBExZ0Amo62UuFfB7pmuHIiM442V9vZ94RvB4wf3jEHnqJB/YZHOTV9rRTiQZspI84ShfW3DJWIR7tb++viHm7E7OejCthdj82+T5URP9sxYdgLSvVqHYXJqUQ5rKoXfIgPci8PyP/HuoEHKVHbSv9J69xuqgez70hNxshiB4YFmanmTtcrn761XtfDF0a+v9LlpmwiyUVdjZZq3WgyT7MZ8iGnu/clHpjPUm++Mh0QPOaCa8DLlVf+pTmzuqriCZvqNKwRTJq68fEoJ6HdCoNOHgWL/BLVlt9RGj8Kd+bA1NK/d2+bY1m4vJH0FYX/RTGUFG8IGufpZNkNCIqySF9I5gDEn77W9l5gwdYRPwGNbQYuezZlGU+8p0ntIj5WiC06YpRhN/riARMrtoDp2o8YFIdPxzqrURRi3++yjr2BISBr6772qDiDEQPTQfcWIiF0EnlUW5m0tzMX1ySfg5MOj4WWMXiFciX0BdAmywVEw843fnewixW5t/eFOhWiqwX3HCD9XIsX1A8gc42OTUFVClxEYHcuM0j3lB1cSJC3Uzl5s80aFHgp3dWkDg1dn8iUSZygTskp7zqfd2JG97gK7GNrZT6nzhGGDuiSNHfIzMjK26DNIUNCC6NRHZVAfiwEa4In09KoQYCffAywOlEXd7UYQHszJyaYKRrvMhmoPCqn/iwNk6Wbhsn81CwJbH5JNMnWd/AicSlu2NQ2apjL6fRUmbo4Iedj75+awdhnkxNrCOxZQ2VIMxC6qNuNuHPFQyf9nATerVtFRICnbeEKaenl+9ZPK8MlaIEy/R80udamiji1I+jcfzFcgFXVUbZMBmZtJuLNNilFKWIwALO9lWkxqIM7NGrlSB6B3zxzgf7ylYMtkJ0ABPk3a2hKjeG+zum9y/4PvQGKxl5pILxhRtnWeBzP01P9RfUtYIVkd/SsXE0+T6alVB1VTD8geBiE
 I1WjNrb0
 7zM4Wo7eufmTbcedAvWpiQhLyW9eakJuqdVgp/HG275wx4h8vqaKR+rt/GasFnj9TDMt9K2VFWHb73zQ3QWc+VIBAg5VRlnKe480ANI8a6d2Z5AHn1q3PR6o1UJRvoya+cIMcKiXPoYJ2ZVYmA8wyiuKYLM+9RHrXH4VMngcH5h9uH0tyalsLGjTUoBI6o8NyVbgegf76VfXReW0GjwWX/P+d/slxIaO28pCJjX4MSNW38MWwCMMsXAizeaePbm4HR9fn+w10laLZKSO5bjuFHBMT5g3isgvtNDq1XrOesUBNwBy+g2FzreHk1RF5EGnXUDW1W0wCe/wFk52pzfQ/taBXxD/8Au+oDIn5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Wed, Aug 6, 2025 at 9:18=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> It was used for calculating the iteration number when the swap allocator
> wants to scan the whole fragment list. Now the allocator only scans one
> fragment cluster at a time, so no one uses this counter anymore.
>
> Remove it as a cleanup; the performance change is marginal:
>
> Build linux kernel using 10G ZRAM, make -j96, defconfig with 2G cgroup
> memory limit, on top of tmpfs, 64kB mTHP enabled:
>
> Before:  sys time: 6278.45s
> After:   sys time: 6176.34s
>
> Change to 8G ZRAM:
>
> Before:  sys time: 5572.85s
> After:   sys time: 5531.49s
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/swap.h | 1 -
>  mm/swapfile.c        | 7 -------
>  2 files changed, 8 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 2fe6ed2cc3fd..a060d102e0d1 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -310,7 +310,6 @@ struct swap_info_struct {
>                                         /* list of cluster that contains =
at least one free slot */
>         struct list_head frag_clusters[SWAP_NR_ORDERS];
>                                         /* list of cluster that are fragm=
ented or contented */
> -       atomic_long_t frag_cluster_nr[SWAP_NR_ORDERS];
>         unsigned int pages;             /* total of usable pages of swap =
*/
>         atomic_long_t inuse_pages;      /* number of those currently in u=
se */
>         struct swap_sequential_cluster *global_cluster; /* Use one global=
 cluster for rotating device */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 1f1110e37f68..5fdb3cb2b8b7 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -470,11 +470,6 @@ static void move_cluster(struct swap_info_struct *si=
,
>         else
>                 list_move_tail(&ci->list, list);
>         spin_unlock(&si->lock);
> -
> -       if (ci->flags =3D=3D CLUSTER_FLAG_FRAG)
> -               atomic_long_dec(&si->frag_cluster_nr[ci->order]);
> -       else if (new_flags =3D=3D CLUSTER_FLAG_FRAG)
> -               atomic_long_inc(&si->frag_cluster_nr[ci->order]);
>         ci->flags =3D new_flags;
>  }
>
> @@ -965,7 +960,6 @@ static unsigned long cluster_alloc_swap_entry(struct =
swap_info_struct *si, int o
>                  * allocation, but reclaim may drop si->lock and race wit=
h another user.
>                  */
>                 while ((ci =3D isolate_lock_cluster(si, &si->frag_cluster=
s[o]))) {
> -                       atomic_long_dec(&si->frag_cluster_nr[o]);
>                         found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
>                                                         0, usage);
>                         if (found)
> @@ -3217,7 +3211,6 @@ static struct swap_cluster_info *setup_clusters(str=
uct swap_info_struct *si,
>         for (i =3D 0; i < SWAP_NR_ORDERS; i++) {
>                 INIT_LIST_HEAD(&si->nonfull_clusters[i]);
>                 INIT_LIST_HEAD(&si->frag_clusters[i]);
> -               atomic_long_set(&si->frag_cluster_nr[i], 0);
>         }
>
>         /*
> --
> 2.50.1
>

