Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 642C5C9832F
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 20:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6B256B0088; Sat, 26 Sep 2026 16:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1B646B008A; Sat, 26 Sep 2026 16:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09B36B008C; Sat, 26 Sep 2026 16:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FEC86B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 16:30:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6B66140944
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 20:30:04 +0000 (UTC)
X-FDA: 85257055128.21.538AE41
Received: from mail-ed2-f33.google.com (mail-ed2-f33.google.com [74.125.228.97])
	by imf13.hostedemail.com (Postfix) with ESMTP id EFB6B20006
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 20:30:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JoriumWu;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.97 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790454602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJ/PmwAD1gXfRgUIPquc0VEGnUEhKbmHbwXAzi7i4tY=;
	b=qJELv7pUq//RmzUyXv8lMHjuiSlbmRBsNmdKGfR9hR4ddD+J6/rBAu7CfIZYhGuk0QxZck
	H3aKPzwpnHMYyNgn7xBugCqI+2d0iZsZx2WfqB9sgfRiECYkn9pLm8S8ZqXqkRWjgj/3ys
	ovXhcM1QEKHIRLk7O9UTO3+h8m87d9k=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790454603;
	b=LoigcINVemj6sx1AyNWLw5qokUPEQOO5F/3kBYT1N3rUwrCb5KhpFjbKeI5gZHkVN5schu
	1E4DNluDNm8SpKxZdTo49VvYlmzObkvVQ3qBP7aKuh0VEQJ029tQKzqWzHmxeYXrFiV+BM
	pDfHYd5IWuubGIKkt1OnM2uRuBcGj9k=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JoriumWu;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.97 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed2-f33.google.com with SMTP id 4fb4d7f45d1cf-6abc27842b6so630355a12.3
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 13:30:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790454601; cv=none;
        d=google.com; s=arc-20260327;
        b=qCDLXys46IFhFVqlYgftIcZanEB6/AuYeMkV1wgO0RZqhwYvENxX98FwTfMGMP53ah
         X0cq1qiJSxr7B8V7ka2Yacli2G5P8U+/mX537FyYCd0v1MEaT1q5K6nFSYL56KBfFAO5
         mEybIAXm1TR4XRCODich9UCu7gG0aAPOLYJdVjuUfUr6l75S2YHlr6P4+Zj0zeKlx4o8
         ZVkXbbmDIqlID8CoRNx0re8kHgqXikbGagr1NgYx/pmh5susda9PjejPyERrVTkecNtK
         HRZJusIBM4vtcLo8QFHtC5ljxztN1PQi4tMu3IZYQ5Zgvc9pLWs5DCzKEJIWNoWcBdfy
         r86Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LJ/PmwAD1gXfRgUIPquc0VEGnUEhKbmHbwXAzi7i4tY=;
        fh=WYCLBsKwCUKdmKBUCH/s4Z8b0yc352ip9Cs5xSDuGxI=;
        b=DI/jqRfl0aqa1Wiw7IeppHbRRhxsygdbw9c9u3DNr+eMePFnOvVJED9f1oBwZxneEv
         iFdr+YM3YzOU6JQ/4qfsZ0axDkaJpEWDoEgm2nSNC6vTOvLpKgB/eAmpR+JYcpMnQBi5
         CcrpemFTq2vRyCbInZMbyZs0BqqfiiYef1ZTX/FvtsebnSshgwVOgLfjSrFCr+/Xjo0v
         vT0OEsn3kyt+4+UMJGoCmiL3/ucQ1IAMSIzBjP2D/V0H7IL/+llrae9IpLzoFb9Vj6Ph
         Npe3GrLitgdnna3TuxtaKW3d2N3uOm5fjlj+2xExYziPb4bVnuqLydZtXNUZ47RdjS8h
         Xu0Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790454601; x=1791059401; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LJ/PmwAD1gXfRgUIPquc0VEGnUEhKbmHbwXAzi7i4tY=;
        b=JoriumWuXW0zuyAViP/LT4KD1GSwgQvxK0Vtdv1roIZ/3SxpWoCgHtePuEXP98RmDB
         CX79AbubcjagaupmSmWQ/1LbGfotq8e0UObbibxfsZzQik5Wg3FdtAOqBiuIqb4cLPBq
         sZVAg5gvVf9KjxQCzwMvQZ4Y8jlFMBN9HhUt4VDFcs2j7OD0Y9BDbooE4qFUzs1embP3
         cDtQqRyvxRF5evoXWav0rssii2Bx8BSzlHu5fJIPRkYSpuBPJwExW9oLoVWqfu/B351x
         o/XT6PEZ2gpsuj9h2tY/xRtH8iPn6Rf93r1XL04rm93h1x090HOpkdE9LP7g5Dw1SJC7
         x6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790454601; x=1791059401;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LJ/PmwAD1gXfRgUIPquc0VEGnUEhKbmHbwXAzi7i4tY=;
        b=bBB2tTsvUo3M0W4VbwooSBgyPtGHaMPeny4RmACkthr62ZGOgpHvLUu3P6UggacASh
         8qdxqsD3lnWJ+H54iW1upnwC1RjgD0sXDqJE036X07NhEIQYnGwzGGAQk6Kwoq2bK96b
         OwR5gWtMDF9DzwBTRcWmnvwQF5qMvZGDZ5MmzAeSPWTg1czAwQQAuym+Xw1bLIhROVES
         Xk6fxubU82MlDKBV5aS/YkoTTKKjVOAX/s6PT422H3cTQapaik0XaNx5r7StjYFBbIb3
         5o/ZMMqENhUfRr/c24Huo5bblJIMS2cPsIBhjbVlstBhYJBqak6nuuEjAauwN1mQltam
         GVSg==
X-Forwarded-Encrypted: i=1; AKwUvBy6LJlc8fPMp6F/Ng7zsnCtdY0zy8YotPe/pPhLENDioNF+7oZdx72cvGh949bdJXPzjOXyQVctHg==@kvack.org
X-Gm-Message-State: AFuF++lrQ70/wTUDzUni9WvVLmE0yldeaonqRqZzSMoMjivSxYFfqEZv
	QbumJ4utbu3bC7XxEhsXtlZpWcFT7ZTr9psT/5Sy0akHlxwVhO+N7h8c3/myXAavoekansUwZRB
	KzJCLG2pjdGw5Xyk4o7TXiT58W2gvOns=
X-Gm-Gg: AYBFou2S4eIVpIPhk50sVqaddEtnyxhmM87uGDYTzd8lTd0h81+LcVscy5Lioz5Zq0f
	igBy+AfKAP+i/L4uJqzLXReLYiFVtnSy7/OPYXkcK3hcOGkVubFJqkSG2HwCuWOdNGr0ZMdUFPy
	gEwbVjKY1Y1Bp25IZrWmelwPEztiimrrdkH0pYDLyDbRevZcqT0wm2U3QnE3N9ug7WkgTpvucug
	fdSWD70aiOIrmG2mAS4s8qZz7LNOyYzL+yOkQCe/BIdWcJTHnpFsE5gtre1xLRxjlhj7DLl3InF
	E2zOIB+u5LLmIFlqcItFr1Rp71J8nlHQLRNmFMDkW2lbHszFe/f7N89gkWm+25ZX1xXknfxX4mN
	cF+FwCa/MjaTD
X-Received: by 2002:a17:907:d789:b0:c29:609a:be6 with SMTP id
 a640c23a62f3a-c2ac2525b6emr763887166b.40.1790454601226; Sat, 26 Sep 2026
 13:30:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com> <20260910080722.3961351-2-qinyuntan@linux.alibaba.com>
In-Reply-To: <20260910080722.3961351-2-qinyuntan@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 27 Sep 2026 04:29:24 +0800
X-Gm-Features: AclHuK_HLsSdldIrlBbtvCnGgQdp91BDp7hfEaJjYM4zx10m9_fHT-4QsHIpQGQ
Message-ID: <CAMgjq7DkLi7aPLRyGv__f6NLPkRHY=0Fw0kLEdevnoTFpqsbzw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm: memcontrol: drop kmemcg_id and use
 mem_cgroup_id() for list_lru indexing
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Usama Arif <usama.arif@linux.dev>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EFB6B20006
X-Stat-Signature: bxnm3x7dshccdxdirknpp1aqmi7xhrsk
X-Rspam-User: 
X-HE-Tag: 1790454602-177743
X-HE-Meta: U2FsdGVkX1884S2klWszxWB2Wss8AyJgfAeh8gf7zcqgMt5yG/Ebw6pMpclmQ7Fqjh8NViVGweC/PFdeK3nhfyiIClZhCSsfSWtgvmJLy762HUzGfT/CRcWhmEaTQtPOnjApMd848us1iGtEJY20Eq5hUYnnpItgRjnnsWn1IMlzSXXafCrflBN2Ki0RLJfajuD1hA48cyUWDP09Ml35BDgUkFaUVgPV8TfY8JvZB1FWTHPB6QIijueBz8DYwI6NiSGPC9NxCJn8HSbr7vfwyuG7EIA1SrWHdEYWu+XMAxTu968YQkmYxEznVOeH37+iyCMebu4ZQV0011FruzCpKv/WEVq3iGQkPTHdsM0TysJxZSxkDDDRkpuZYnlxbz0Oc6ITX86e2oTz2qFNExXLRx+KMuMVZNH8lp19o+B0f3ezbW728FjG70YYBll+fs3KxoaCka/p6srOu323fLaQVy2jMJRb13NzkEJwdDzyXjNHuzfN8xv+OWxdMp0PugoplzKAAwl1SaU+5BIwGVJDbTbFGIP9uPgodgvclYSsAwjFc63ihhiLxNO8KVyKrgovg1GIMAEunBikOKFUKRMlTEPVQKPtM5wJ8dpzU+2WfCgbsh+rXwkbJgN+RRza03zxjQ+0x5QuHnojGogSrKKZVDMo6zdy1UPI4MYnl8mXyi6NzE15Dimm/JhWPT4FcVynbuSAW1pUXJ1ILtb5AGtfQy6INTOxEVKuqhlPCjgmLYgqSBCFsrtXtuUaL3h6HUahWI+VdRe5seWjjKDTH5PQwmvoGaRC/l/1KbSxPV/gBtutapkmMTHnPSnntvBXRhcBCfUFDoq84ABVpUKdLGfFAcmiVK4me3IC0RnogCLQZuWh1LWZntwyE/741jjfg8iGICut1k2bd6tl7kKaM6Bo0QvLgrrD+5OaaaFVlhrc3gJMY7KJXEFZi7H/wDyzt4804j/YkGjyqCoMh/+H0Un
 LbZ8tFjq
 NnJBRHQx4KS7+Z8igXYiP3nLJ68jfPnsomfzcD11nwUYpuRHw/Sil/YMRULn/0kCMG4486INBSA9mXAYK8qf3uAo/Wxex6MSZ3F4oJuRa8Sg9Go8TY7fy0y61yoXFstQUPWPUUvulC4MqXwueXodmvMlfoTDwuw47T4GWWlX7xMsLI+U0XZDoGo9MNFIOFQfOHSTZPcj5cFDNwb/ZJ+/k0IEml4/c48l1fUf1S/V5VUkNlS9s6JCVcL2wJIAIHA8M64l815v2o/DHXgLylZL0Z2TmeZEg7d2sx9Covi4VcfiIA3bYi95/kwsW6cTMeCnEMcm9FoXWM3kb0P+INoAsA+nlhsBM2IjmDyRK+HjCEKbQybqBpSoZsuV3iNiRS8HezAQm4JVdr0rBk9x3POY8c50T2BFHWsZn6lQqCSalto+0HvcU5U8mvR7L5x/OiglcUGEq5JFhD2MzoWiNy3I74TNX9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 4:18=E2=80=AFPM Qinyun Tan <qinyuntan@linux.alibaba=
.com> wrote:
>
> kmemcg_id is a copy of the private memcg ID and serves no purpose
> other than indexing the per-memcg list_lru xarray.  It is assigned
> when kmem accounting goes online, which never happens with
> cgroup.memory=3Dnokmem, and the memcgs then all resolve to the
> per-node lists.  The next patch needs the index to work under nokmem
> as well.
>
> Index the lists with mem_cgroup_id().  The cgroup ID is unique per
> memcg and is only recycled once the cgroup is destroyed, long after
> offlining has erased the xarray entries, so a recycled ID cannot
> resurrect a stale entry.  The lookup now takes memcg pointers and
> routes root and NULL to the per-node lists itself.
>
> Also drop the nokmem early return from the offline path, so that the
> reparenting covers lrus that stay memcg aware without kmem
> accounting.  memcg_online_kmem() and memcg_offline_kmem() are each
> down to a single statement now; inline them into the css online and
> offline hooks, dropping the root check, as css_offline() is never
> called for the root and a memcg that failed css_online() cannot have
> list_lru entries.
>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> ---
>  include/linux/memcontrol.h | 15 -------------
>  mm/list_lru.c              | 27 ++++++++++++------------
>  mm/memcontrol.c            | 43 +++++++-------------------------------
>  3 files changed, 22 insertions(+), 63 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index fdf4812e1d818..821dc0e32603a 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -254,7 +254,6 @@ struct mem_cgroup {
>  #if BITS_PER_LONG < 64
>         seqlock_t               socket_pressure_seqlock;
>  #endif
> -       int kmemcg_id;
>
>  #ifdef CONFIG_CGROUP_WRITEBACK
>         struct list_head cgwb_list;
> @@ -1774,15 +1773,6 @@ static inline void memcg_kmem_uncharge_page(struct=
 page *page, int order)
>                 __memcg_kmem_uncharge_page(page, order);
>  }
>
> -/*
> - * A helper for accessing memcg's kmem_id, used for getting
> - * corresponding LRU lists.
> - */
> -static inline int memcg_kmem_id(struct mem_cgroup *memcg)
> -{
> -       return memcg ? memcg->kmemcg_id : -1;
> -}
> -
>  struct mem_cgroup *mem_cgroup_from_virt(void *p);
>
>  static inline void count_objcg_events(struct obj_cgroup *objcg,
> @@ -1850,11 +1840,6 @@ static inline bool memcg_kmem_online(void)
>         return false;
>  }
>
> -static inline int memcg_kmem_id(struct mem_cgroup *memcg)
> -{
> -       return -1;
> -}
> -
>  static inline struct mem_cgroup *mem_cgroup_from_virt(void *p)
>  {
>         return NULL;
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index a4522ca93ebcb..9241d17de4388 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -72,10 +72,11 @@ static int lru_shrinker_id(struct list_lru *lru)
>  }
>
>  static inline struct list_lru_one *
> -list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
> +list_lru_from_memcg(struct list_lru *lru, int nid, struct mem_cgroup *me=
mcg)
>  {
> -       if (list_lru_memcg_aware(lru) && idx >=3D 0) {
> -               struct list_lru_memcg *mlru =3D xa_load(&lru->xa, idx);
> +       if (list_lru_memcg_aware(lru) && memcg && !mem_cgroup_is_root(mem=
cg)) {
> +               struct list_lru_memcg *mlru =3D
> +                       xa_load(&lru->xa, mem_cgroup_id(memcg));
>
>                 return mlru ? &mlru->node[nid] : NULL;
>         }
> @@ -91,7 +92,7 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid,
>
>         rcu_read_lock();
>  again:
> -       l =3D list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(*memcg));
> +       l =3D list_lru_from_memcg(lru, nid, *memcg);
>         if (likely(l)) {
>                 lock_list_lru(l, irq, irq_flags);
>                 if (likely(READ_ONCE(l->nr_items) !=3D LONG_MIN)) {
> @@ -132,7 +133,7 @@ static inline bool list_lru_memcg_aware(struct list_l=
ru *lru)
>  }
>
>  static inline struct list_lru_one *
> -list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
> +list_lru_from_memcg(struct list_lru *lru, int nid, struct mem_cgroup *me=
mcg)
>  {
>         return &lru->node[nid].lru;
>  }
> @@ -313,7 +314,7 @@ unsigned long list_lru_count_one(struct list_lru *lru=
,
>         long count;
>
>         rcu_read_lock();
> -       l =3D list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
> +       l =3D list_lru_from_memcg(lru, nid, memcg);
>         count =3D l ? READ_ONCE(l->nr_items) : 0;
>         rcu_read_unlock();
>
> @@ -502,11 +503,10 @@ static void memcg_reparent_list_lru_one(struct list=
_lru *lru, int nid,
>                                         struct list_lru_one *src,
>                                         struct mem_cgroup *dst_memcg)
>  {
> -       int dst_idx =3D dst_memcg->kmemcg_id;
>         struct list_lru_one *dst;
>
>         spin_lock_irq(&src->lock);
> -       dst =3D list_lru_from_memcg_idx(lru, nid, dst_idx);
> +       dst =3D list_lru_from_memcg(lru, nid, dst_memcg);
>         spin_lock_nested(&dst->lock, SINGLE_DEPTH_NESTING);
>
>         list_splice_init(&src->list, &dst->list);
> @@ -536,7 +536,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memc=
g, struct mem_cgroup *paren
>                  * allocating a new mlru since CSS_DYING is already set f=
or this
>                  * memcg a rcu grace period ago.
>                  */
> -               mlru =3D xa_load(&lru->xa, memcg->kmemcg_id);
> +               mlru =3D xa_load(&lru->xa, mem_cgroup_id(memcg));
>                 if (!mlru)
>                         continue;
>
> @@ -551,7 +551,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memc=
g, struct mem_cgroup *paren
>                 for_each_node(i)
>                         memcg_reparent_list_lru_one(lru, i, &mlru->node[i=
], parent);
>
> -               xa_erase_irq(&lru->xa, memcg->kmemcg_id);
> +               xa_erase_irq(&lru->xa, mem_cgroup_id(memcg));
>
>                 /*
>                  * Here all list_lrus corresponding to the cgroup are gua=
ranteed
> @@ -566,9 +566,10 @@ void memcg_reparent_list_lrus(struct mem_cgroup *mem=
cg, struct mem_cgroup *paren
>  static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
>                                             struct list_lru *lru)
>  {
> -       int idx =3D memcg->kmemcg_id;
> +       if (!memcg || mem_cgroup_is_root(memcg))
> +               return true;
>
> -       return idx < 0 || xa_load(&lru->xa, idx);
> +       return xa_load(&lru->xa, mem_cgroup_id(memcg));
>  }
>
>  static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
> @@ -602,7 +603,7 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *=
memcg,
>                         if (!mlru)
>                                 return -ENOMEM;
>                 }
> -               xas_set(&xas, pos->kmemcg_id);
> +               xas_set(&xas, mem_cgroup_id(pos));
>                 do {
>                         xas_lock_irqsave(&xas, flags);
>                         if (!xas_load(&xas) && !css_is_dying(&pos->css)) =
{
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7ce50bccf1264..aa010608fbff8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3771,33 +3771,6 @@ void folio_split_memcg_refs(struct folio *folio, u=
nsigned old_order,
>         obj_cgroup_get_many(folio_objcg(folio), new_refs);
>  }
>
> -static void memcg_online_kmem(struct mem_cgroup *memcg)
> -{
> -       if (mem_cgroup_kmem_disabled())
> -               return;
> -
> -       if (unlikely(mem_cgroup_is_root(memcg)))
> -               return;
> -
> -       static_branch_enable(&memcg_kmem_online_key);
> -
> -       memcg->kmemcg_id =3D memcg->id.id;
> -}
> -
> -static void memcg_offline_kmem(struct mem_cgroup *memcg)
> -{
> -       struct mem_cgroup *parent;
> -
> -       if (mem_cgroup_kmem_disabled())
> -               return;
> -
> -       if (unlikely(mem_cgroup_is_root(memcg)))
> -               return;
> -
> -       parent =3D parent_mem_cgroup(memcg);
> -       memcg_reparent_list_lrus(memcg, parent);
> -}
> -
>  #ifdef CONFIG_CGROUP_WRITEBACK
>
>  #include <trace/events/writeback.h>
> @@ -4225,7 +4198,6 @@ static struct mem_cgroup *mem_cgroup_alloc(struct m=
em_cgroup *parent)
>         seqlock_init(&memcg->socket_pressure_seqlock);
>  #endif
>         memcg1_memcg_init(memcg);
> -       memcg->kmemcg_id =3D -1;
>  #ifdef CONFIG_CGROUP_WRITEBACK
>         INIT_LIST_HEAD(&memcg->cgwb_list);
>         for (i =3D 0; i < MEMCG_CGWB_FRN_CNT; i++)
> @@ -4299,7 +4271,8 @@ static int mem_cgroup_css_online(struct cgroup_subs=
ys_state *css)
>         struct obj_cgroup *objcg;
>         int nid;
>
> -       memcg_online_kmem(memcg);
> +       if (!mem_cgroup_kmem_disabled() && likely(!mem_cgroup_is_root(mem=
cg)))
> +               static_branch_enable(&memcg_kmem_online_key);
>
>         /*
>          * A memcg must be visible for expand_shrinker_info()
> @@ -4307,7 +4280,7 @@ static int mem_cgroup_css_online(struct cgroup_subs=
ys_state *css)
>          * here, when mem_cgroup_iter() can't skip it.
>          */
>         if (alloc_shrinker_info(memcg))
> -               goto offline_kmem;
> +               goto reparent_lrus;
>
>         for_each_node(nid) {
>                 objcg =3D obj_cgroup_alloc();
> @@ -4364,8 +4337,8 @@ static int mem_cgroup_css_online(struct cgroup_subs=
ys_state *css)
>                 }
>         }
>         free_shrinker_info(memcg);
> -offline_kmem:
> -       memcg_offline_kmem(memcg);
> +reparent_lrus:
> +       memcg_reparent_list_lrus(memcg, parent_mem_cgroup(memcg));
>         mem_cgroup_private_id_remove(memcg);
>         return -ENOMEM;
>  }
> @@ -4381,11 +4354,11 @@ static void mem_cgroup_css_offline(struct cgroup_=
subsys_state *css)
>
>         zswap_memcg_offline_cleanup(memcg);
>
> -       memcg_offline_kmem(memcg);
> +       memcg_reparent_list_lrus(memcg, parent_mem_cgroup(memcg));
>         /*
>          * The reparenting of objcg must be after the reparenting of
> -        * the list_lru in memcg_offline_kmem(), which ensures that
> -        * they will not mistakenly get the parent list_lru.
> +        * the list_lru above, which ensures that they will not
> +        * mistakenly get the parent list_lru.
>          */
>         memcg_reparent_objcgs(memcg);
>         reparent_shrinker_deferred(memcg);
> --
> 2.43.7
>

Hi Qinyun

With this commit, my arm64 VM hangs at every boot with a
100%-reproducible infinite loop in xas_find(), driven by
the dcache shrinker during the first remount of the root filesystem.
Reverting this fixes the issue:

   CPU: 2 UID: 0 PID: 579 Comm: mount Not tainted
7.3.0-rc4.orig-00725-g09d9672a5d4f #33 PREEMPT(full)
   pc : xas_find+0x184/0x1c8
   lr : xas_find+0x6c/0x1c8
   Call trace:
    xas_find+0x184/0x1c8
    xa_find_after+0x88/0x120
    list_lru_walk_node+0xc0/0x2a0
    shrink_dcache_sb+0x80/0x130
    reconfigure_super+0xc0/0x1f8
    vfs_fsconfig_locked+0xa8/0x120
    __arm64_sys_fsconfig+0x280/0x33c

Just for reference, this also fixed it:

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 7dbb6125cb1d..42c48c3b9235 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -427,13 +427,13 @@ unsigned long list_lru_walk_node(struct list_lru
*lru, int nid,
  unsigned long index;

  xa_for_each(&lru->xa, index, mlru) {
- rcu_read_lock();
- memcg =3D mem_cgroup_from_private_id(index);
- if (!memcg || !mem_cgroup_tryget(memcg)) {
- rcu_read_unlock();
+ memcg =3D mem_cgroup_get_from_id(index);
+ if (!memcg)
  continue;
- }
- rcu_read_unlock();
  isolated +=3D __list_lru_walk_one(lru, nid, memcg,
  isolate, cb_arg,
  nr_to_walk, false);

=3D=3D=3D

And BTW cgroup ID lookups seem much heavier, not sure about the
performance impact.

