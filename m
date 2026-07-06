Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 721B9C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693196B00C0; Mon,  6 Jul 2026 13:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6445C6B00C1; Mon,  6 Jul 2026 13:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E45A6B00C2; Mon,  6 Jul 2026 13:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23C2D6B00C0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:24:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB6CC401AF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:24:48 +0000 (UTC)
X-FDA: 84959026656.02.002F2F4
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id B2BB31A0009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:24:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=icOhOZC8;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783358686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxP53wL2J2oYif5ANu17eapgCY9wfdHwyPogm4z9pjw=;
	b=0sHB6CuFpxki41vXniIQ3Jj/eYLNkwSmGSTzj4lzDLVUnOIM5ZBp4GT111u5tEfevCavUe
	vdvojgXaYYmdwuZ3PpEmCkJLGQEPlsub1B/8Jg6cAuQUQ35yZm4OnrKY/zg6d2RaEXvMOe
	3YHtUQ621ZsDwHoVF0vXCJ2j5ccToEU=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=icOhOZC8;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783358686;
	b=IcpEX8qPCozU0wS6EJWi4evwaFJMV9kWJdoLao2MltwjS2muhc3ql8REzJoM9tfOKJk9d9
	m+iU01cfhtApW1kmoYpaP6YrWnwBRtqPXz5WzZ6zFs6LsyZ3mbcGBK1bQ3RRpWz6WEsL3d
	/L1k8OeHixzdsOp923lnk2NDfMB3dqM=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c125ba77577so320382166b.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 10:24:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783358685; cv=none;
        d=google.com; s=arc-20260327;
        b=bOwVmEATLitsn0cS3Wp7/GaUerRCzHHFy8wVVxK/93BXFHsFK4KNSIaoNcb9CwYpLc
         7819W7DBi0rtRZGzOCveGNOC5W4MaTD4yjy9/gNLVVXNFZuqMc43djbjr3xqTkqRtZUW
         liP2U/mGj6VVJiATpsYcnmqxoeTja3hklvR9uz97WVksQnLsTAU6dkECujhPe8F8XPID
         CgWWMM6rguc7eUB0vxbeaSymNJHHCYmGaPsnQngWwZBrSdG6slu3suc79PdVGvXDeGNz
         lI4uFHiJy0Ko7axY/Ea9YaQZTLhcZvm64iX9JeMvIWpbYj8sdwWffqMxFY455teZ65qA
         qWUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XxP53wL2J2oYif5ANu17eapgCY9wfdHwyPogm4z9pjw=;
        fh=Of4I1tMkubHNlh5I46OjINaU2ezpw3IFuUXSHb2gdw0=;
        b=KUMBzzj3SRCMkkaHGx1FUe6gc/9r8+ydJh22MGb7Zm+mP9CmnUsVVcG0592swxhBIh
         nAq/3tiq/ZrYli+s+9JyoDazHeXr78DTLVIAVTs5rPOGOHigTxS48BegleYpkPJxIE9a
         voKa0FB3CEkdWIwVOeZ1K+2Gq6Yy6nH9eWaXaomerKhWt4VorRDgXqOs8mTyltlEhgwB
         xhIC5WyKPRXtM+KAsDq8VmGuo7GdcoPJB/uUrNxm6NaotKMaAiHJ3WgcRR2GNqeUwN5X
         0gxHbghoJkV4/wqp7ir7pZntixNdRwQSOOUmn/7Rf0B/fSkkybFDvRHfNSlQwOjYuiTp
         kowg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783358685; x=1783963485; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XxP53wL2J2oYif5ANu17eapgCY9wfdHwyPogm4z9pjw=;
        b=icOhOZC8/ztvjUsemrbJmrYWGJIAdGJEUteIZ/+SisDBYh0198ybMZM3ys+nNtkIGP
         fUmhP8dGl9rV51U6h3ykXAInrsPiZmg5l7btzXkj26Tr3xw8y2WXqAOiBChG1rOD6neX
         gX1rMeifKDwULkL7B/Jc5SZ1TTYoXBpW1k+0X9UWhxenOvMgteW3sLD/fKb3P1svMTmp
         ozS3wZQ4e/zRXNPSD33WkUIS4DiiOHRHTlSK2FVgj8RUuUBMb+JY6PnKEdS6Wqg8x65y
         I5YqO9834l5E/X3On6zBCI/BffvbVD22e2DZ5KCzejHKakHQUghKrilkYbsQGcuaTGle
         i14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783358685; x=1783963485;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XxP53wL2J2oYif5ANu17eapgCY9wfdHwyPogm4z9pjw=;
        b=hz8VIG1ZG9EkQHPgruG2GJMh+w6wrJf3JjJZ9L6e+gkdtR4/HVO/LhH/nLl9rqe+dl
         yiKXq1eSZf4RIYopotyp5R0tRnNPaeq9NPhCRfqiy+DnDplrD27bmMSce8B3qVtLIPKD
         bO/9rYmCOr51yh3VFAG7OUbiqPC2ab0ccpqI2j0FIHLepaKfgKU6WBQfWmQqJEwbzbl2
         AupGz+sHKFkfGHJG6hOOFm+sIQSAH6EmaNyzfhp4FKBAYiOE0/7Qb/nDg6AWYfpjIgEm
         Jt3PyJmUG+K0p35fxuF5jB0bi7HwsG6uMoODRGXGHBCg0KqhWSD2a4rZ6i4PBc9Jjc1P
         HmWw==
X-Forwarded-Encrypted: i=1; AHgh+RreOAE8I+tJLth0CKliJGvTLNw8fEmkOT5javOfGUB4iePXu0wYLB55FcZbDn/RK+LEgzkKfAaWaQ==@kvack.org
X-Gm-Message-State: AOJu0Yz/X+NfIkoDPcn94Rbtyqw+QrP8VEi3++r84YRu5ai1A4YE7/+D
	hvij/bXboydShG0igXtCOc2Xw2wGIvM0q3OwCyRhTVzQtHalY1PWljnEqdV8YU2RZcyGUwsLEca
	Cfij6ecy4JVaB6YCeSI9wQgBTVqq1cLc=
X-Gm-Gg: AfdE7cmirDmAj/TW4CohznQoyaj4uHWm/dxcUeK8NurhGlaVnJ4vmuYgVW2om5KOL83
	RkPHN8yU08zYTQnaU3NNnT1LdXCusqS+zC/A9FMLvQtZ0npUKIvZKTLVl1AJjHBT1QFcgTU8wk7
	AOBVVWBUUaQj/5+LX4p6/PA7QSQdQpvttZNRLljs23Q8kr0kfMnB+ld5mgXbHdW/fXRTkPjC+D5
	dDddHfz5fX4aQEhRraUGC59ATZMC8sgeE58eD5GMcLX1CZDyICyo06Zs2TUqZ3na93gvVpD/HZE
	CToDipDwoYUlSLU3vE57ggVElyCfor8Hi6r+94jF
X-Received: by 2002:a17:907:9511:b0:c11:fb78:4995 with SMTP id
 a640c23a62f3a-c15a692b922mr62990266b.39.1783358684968; Mon, 06 Jul 2026
 10:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com>
 <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-1-a028e8b5fc3d@gmail.com>
In-Reply-To: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-1-a028e8b5fc3d@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 7 Jul 2026 01:24:08 +0800
X-Gm-Features: AVVi8CeLsc9BTwH9hYpNfgnAjsqBY_UguxBev0CFD_zG552dvgLpHsMF9gkFrEo
Message-ID: <CAMgjq7DeWvBszNt0sHcCOft3A48LVJTxLu70F_Ka7=sjii2M8A@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] mm/swap: colocate page-cluster sysctl with swap readahead
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B2BB31A0009
X-Stat-Signature: i8r1x4qe5pdz5kj3xyx48f6fqyn9a6fc
X-Rspam-User: 
X-HE-Tag: 1783358686-443593
X-HE-Meta: U2FsdGVkX1+TuVYZctZNSVqkNZ8TzxBPwoB9Jkjfidk0IgNGlq5/N5XBjEG0x6LKzo+2lLMF127mpV8E9MVGSWwg4vysh9r6PBEPU6bv6x1VOb5334dUa4Ojb6r7H+AMZsTNGXBFu8ZUftxC0gsHM+JW9mSGZgYtjl25YFwhVicCT2Stc2KqO6xrLeqA1NgLt0HuV/Hv+5NFEG7JcspU9uOmrz3IexZosyb6jMSWuCOJimY5VcQuajV6I7hVbIodNb7GwMd/7GF5Cuhg5UD270UZ/2QPiZ4IU6AjB/p9/BCBWCIpGzsOW3pOLxGzHt0HANwzCyN2fBl0RyTlb+tTnq6q/Zf68bODvFA/IZ0WjKErC4qs4B6/wfICVl1B3PgXib1bGqFeDx2+bfI50DH9kgct/hKsVjsc9AYSgSNo3I7l91APLY7i+pM7T/gpjF9kJdj+9tc5A6CGkizjjRiStP37HFABS5IWso4YRvNwDcLNEODYYHtBCkzLP3mLV+SIEBeA1KDYhLkxwjCjnoQq4NNTfPrFbLi7ys2cZUbE/dTMv1VGKEvAC7c31kMWM5xuATlWgaYk9BsF1PY4pckj5n+PaIRJJ3Qu/Am+pSb1w5LguUFZ/2ar1AXnJWoDJfEX860kzc/hxLT8Io4ZyAs+qFeO2+3Uys4gGlWSwFbwMn9xNwq9jymOuquoqt3dPcJ4f+BgY5s3CdTfgvxekif7/J9Oeyi2Ye1HaEaaShDn0UizDDrfPW4coCkte9FhP+1I4Yah6DJbDUsExcllhsAE/zt3qBcRmv1YV8A6jMzTueR36pYfiq27XdSSjr2J6nvM/nqz4M0uaUuPRUDAp32emy9018cf30Q4bXaGGD+943ZoMjuT9k3bhuurWN6ZW4fDiaFzBpMp/9kYfSIW6RbttRbyhhHlLflAuniHGVmcLPHZVV9OGqhxfWEQPAmxEtGVI3jERqhgNNz2Q8oHtHa
 JYMUhx+3
 68eqQOIavol8ri4b+8vVarJd3zs8UnuzC5jJTKcfmynWTKKXHWd68JPSA8zZrg1+CtsO1AGV7MzErzS/UjVo5idyTFx3c+E/z8FKiJAGoRdDsi57AtqXx0bDs9UdDtUoiVDKlHRwOK93H0d7SVRU6hEZEF57NeKE2NuZObSFpVvgPB2kalyCCRl9zR3bbZ7Ve5qki2bdp3jHN47lo8CTn+DUFtIdTDHx0rc+FL8jqjkCivlXaymvOUt4bsbF9ADmPF66+4vB1Oub7M9Nz7CrcHq5vV+H68kgnV6brwOFiRcxq2dczHal+x+1a+9yFZlYtA5Dse1tvKwOdqWn5L3VoNOtYF5xC6Ij+UBH9F5B6yqAzUjI6ma+JclJr0nbNNw6tTZgS8fwP39zWJvev98RniNsUm0ABcLacrAgd80/zRyhpaxELVVJSgCiFuM7lEsU6D+ugbgVUFkeD3qArelElOLZ1RpmFtaLVe7UjnL7Mv2hx7uAZYcC2SAjV9KCCREcdSYiNjURPzjgHji3jQ2Yeo7/A9PYJvWucC2Vx9pFyBKTmyDCeN/3Hle6NXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 5, 2026 at 10:14=E2=80=AFPM Jianyue Wu <wujianyue000@gmail.com>=
 wrote:
>
> page_cluster and the vm.page-cluster sysctl are only used by swap-in
> readahead in swap_state.c. Move them out of swap.c together with
> swap_readahead_setup(), and make page_cluster static to that file.
>
> Rename swap_setup() while moving it as well. The helper is internal to
> MM and now only sets up swap readahead defaults and its sysctl hook, so
> the more specific name matches its reduced scope.
>
> swap_setup() previously lived in mm/swap.c, which is built
> unconditionally, so the vm.page-cluster sysctl was registered also on
> CONFIG_SWAP=3Dn kernels. swap_readahead_setup() is now a no-op stub when
> CONFIG_SWAP is disabled, so vm.page-cluster is no longer registered
> there. The knob only tunes swap-in readahead and had no effect without
> swap.
>
> Suggested-by: Baoquan He <bhe@redhat.com>
> Suggested-by: Barry Song <baohua@kernel.org>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
>  include/linux/swap.h |  1 -
>  mm/swap.c            | 36 ------------------------------------
>  mm/swap.h            |  9 +++++++--
>  mm/swap_state.c      | 37 +++++++++++++++++++++++++++++++++++++
>  mm/vmscan.c          |  2 +-
>  5 files changed, 45 insertions(+), 40 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 3f31b6a56788..45656ca9792d 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -340,7 +340,6 @@ extern void lru_add_drain_cpu_zone(struct zone *zone)=
;
>  extern void lru_add_drain_all(void);
>  void folio_deactivate(struct folio *folio);
>  void folio_mark_lazyfree(struct folio *folio);
> -extern void swap_setup(void);
>
>  /* linux/mm/vmscan.c */
>  extern unsigned long zone_reclaimable_pages(struct zone *zone);
> diff --git a/mm/swap.c b/mm/swap.c
> index 58e4eff698cc..b3ea30edbaad 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -43,10 +43,6 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/pagemap.h>
>
> -/* How many pages do we try to swap or page in/out together? As a power =
of 2 */
> -int page_cluster;
> -static const int page_cluster_max =3D 31;
> -
>  struct cpu_fbatches {
>         /*
>          * The following folio batches are grouped together because they =
are protected
> @@ -1176,35 +1172,3 @@ void lru_reparent_memcg(struct mem_cgroup *memcg, =
struct mem_cgroup *parent, int
>                 lruvec_reparent_lru(child_lruvec, parent_lruvec, lru, nid=
);
>  }
>  #endif
> -
> -static const struct ctl_table swap_sysctl_table[] =3D {
> -       {
> -               .procname       =3D "page-cluster",
> -               .data           =3D &page_cluster,
> -               .maxlen         =3D sizeof(int),
> -               .mode           =3D 0644,
> -               .proc_handler   =3D proc_dointvec_minmax,
> -               .extra1         =3D SYSCTL_ZERO,
> -               .extra2         =3D (void *)&page_cluster_max,
> -       }
> -};
> -
> -/*
> - * Perform any setup for the swap system
> - */
> -void __init swap_setup(void)
> -{
> -       unsigned long megs =3D PAGES_TO_MB(totalram_pages());
> -
> -       /* Use a smaller cluster for small-memory machines */
> -       if (megs < 16)
> -               page_cluster =3D 2;
> -       else
> -               page_cluster =3D 3;
> -       /*
> -        * Right now other parts of the system means that we
> -        * _really_ don't want to cluster much more
> -        */
> -
> -       register_sysctl_init("vm", swap_sysctl_table);
> -}
> diff --git a/mm/swap.h b/mm/swap.h
> index 44ab8e1e595b..624ea8ff3d0d 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -8,8 +8,6 @@ struct mempolicy;
>  struct swap_iocb;
>  struct swap_memcg_table;
>
> -extern int page_cluster;
> -
>  #if defined(MAX_POSSIBLE_PHYSMEM_BITS)
>  #define SWAP_CACHE_PFN_BITS (MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
>  #elif defined(MAX_PHYSMEM_BITS)
> @@ -79,6 +77,8 @@ enum swap_cluster_flags {
>  };
>
>  #ifdef CONFIG_SWAP
> +void swap_readahead_setup(void);
> +
>  #include <linux/swapops.h> /* for swp_offset */
>  #include <linux/blk_types.h> /* for bio_end_io_t */
>
> @@ -336,6 +336,11 @@ static inline unsigned int folio_swap_flags(struct f=
olio *folio)
>
>  #else /* CONFIG_SWAP */
>  struct swap_iocb;
> +
> +static inline void swap_readahead_setup(void)
> +{
> +}
> +
>  static inline struct swap_cluster_info *swap_cluster_lock(
>         struct swap_info_struct *si, pgoff_t offset, bool irq)
>  {
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 6fd6e3415b71..a9f5b944172b 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -22,10 +22,15 @@
>  #include <linux/vmalloc.h>
>  #include <linux/huge_mm.h>
>  #include <linux/shmem_fs.h>
> +#include <linux/sysctl.h>
>  #include "internal.h"
>  #include "swap_table.h"
>  #include "swap.h"
>
> +/* Swap readahead cluster size, as a power of 2 pages. */
> +static int page_cluster;
> +static const int page_cluster_max =3D 31;
> +
>  /*
>   * swapper_space is a fiction, retained to simplify the path through
>   * vmscan's shrink_folio_list.
> @@ -985,6 +990,38 @@ struct folio *swapin_readahead(swp_entry_t entry, gf=
p_t gfp_mask,
>         return folio;
>  }
>
> +static const struct ctl_table swap_readahead_sysctl_table[] =3D {
> +       {
> +               .procname       =3D "page-cluster",
> +               .data           =3D &page_cluster,
> +               .maxlen         =3D sizeof(int),
> +               .mode           =3D 0644,
> +               .proc_handler   =3D proc_dointvec_minmax,
> +               .extra1         =3D SYSCTL_ZERO,
> +               .extra2         =3D (void *)&page_cluster_max,
> +       }
> +};
> +
> +/**
> + * swap_readahead_setup - defaults and sysctl for swap cache readahead c=
lustering
> + */
> +void __init swap_readahead_setup(void)
> +{
> +       unsigned long megs =3D PAGES_TO_MB(totalram_pages());
> +
> +       /* Use a smaller cluster for small-memory machines */
> +       if (megs < 16)
> +               page_cluster =3D 2;
> +       else
> +               page_cluster =3D 3;
> +       /*
> +        * Right now other parts of the system means that we
> +        * _really_ don't want to cluster much more
> +        */
> +
> +       register_sysctl_init("vm", swap_readahead_sysctl_table);
> +}
> +

Thanks, I also think they belong here.

>  #ifdef CONFIG_SYSFS
>  static ssize_t vma_ra_enabled_show(struct kobject *kobj,
>                                      struct kobj_attribute *attr, char *b=
uf)
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f40cfe9d703b..ae710027d546 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7646,7 +7646,7 @@ static int __init kswapd_init(void)
>  {
>         int nid;
>
> -       swap_setup();
> +       swap_readahead_setup();

There is already a subsys_initcall(swap_init); in swap_state.c so
perhaps calling this in that init function is even cleaner. And that
init hook runs earlier than kswapd init so totally fine I think.

Reviewed-by: Kairui Song <kasong@tencent.com>

