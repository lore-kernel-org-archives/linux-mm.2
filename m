Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA8C9F8808B
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 07:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E61C6B0089; Thu, 16 Apr 2026 03:01:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BDF56B008A; Thu, 16 Apr 2026 03:01:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D3126B008C; Thu, 16 Apr 2026 03:01:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE526B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:01:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC11C16062A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:01:44 +0000 (UTC)
X-FDA: 84663523728.07.78157BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BC1FA40008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:01:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AaaIMRNg;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776322903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVqU6YK6/SvqF8+LADnJYWkNivQ9TRoFbUusrITLtJY=;
	b=KHcY0kF+LS5SiK2+zb50i+gkMkDAG0UqEscU2b9KeFPPD8e0aLoN9+othPEv07H0gIchev
	BDIEoK/TYd2fFmNC1bAQbr1lt+HuiInkDCArHxGes0Waavvl0JTo/BrPrraxnlOkkkq0d6
	/Ql8SX/poFcom7FVkVyVnnWwicaUL/k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AaaIMRNg;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776322903; a=rsa-sha256;
	cv=none;
	b=ksgXDb0xTibBtXfwYkbEfBfuHzwg/ds2HuWLiDd8/8MRKqljqMoW4LSQwlIylqOU4cf5pd
	9FxCY+Qi+x+oY7KVSnfqOnulmnjdbAP+Lui5qk0J1ft/iQ4/2s/uhLXpHiCvchPHgHylom
	U/Q+CutZfPbFitRekvsWlLA7p/qU988=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8ED4744465
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28289C2BCF5
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776322901;
	bh=9+RKQPJabR6qnebRk19AB48dKeXoK7iWRhmeNz3xeic=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AaaIMRNgFS23xcQ9LwwhgekyUfI1Fp+sre6hG3Ru9NRMztFk31RdCso/tKvqxxl5C
	 Qo+YhgbLzOdC+YAjBvp0DkmTKLKZWWKmxRnw84C1yymVkO7NgxOvfFloOYWT3FqLA/
	 nKvi5gWVIaCR0nEhFtAiJBVXHkxuFK9tY/Jsv1rSF5uPSZXq6wDGOmTmjDBA3iLhG8
	 8NVVm1gTZ4Z2dzKOvGzhoBX67EYUXqfugCDGOZZT2gP6qP+/x0KQ0AztdGrRBTU6MP
	 IxeEbcXROpS0/yf5vuYvWNXy9MWnTWxo3/0qtJJHfjUQEvVCLh24x0gYcJPmAsfxNZ
	 UhCkyPbawOHAg==
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-56f3e6bbecdso2309622e0c.2
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:01:41 -0700 (PDT)
X-Gm-Message-State: AOJu0YwTOfln+KS33FmrLwnhHGPwttdL7IzHp8vLq6ac1mPTPjWMzi9f
	cQsBBka5hf+BcqQUFYwb1jqhgWdWNtKe8NB6Alk+QxBAv8tL8xtvqqMZwdDale/l/Shmbn1cTkT
	E0rtoiouzqqcCJTLBZE5WVaCbnt3Q45U=
X-Received: by 2002:a05:6122:80a8:b0:56d:b639:5c0d with SMTP id
 71dfb90a1353d-56f3bd019aemr11978264e0c.13.1776322898994; Thu, 16 Apr 2026
 00:01:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com> <20260413-mglru-reclaim-v5-5-8eaeacbddc44@tencent.com>
In-Reply-To: <20260413-mglru-reclaim-v5-5-8eaeacbddc44@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 16 Apr 2026 15:01:27 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yH6v58oD8K56hMPp5bTYGC1Bfo3XSAViW9gWeSwLXgDw@mail.gmail.com>
X-Gm-Features: AQROBzB-6EBIWS71H_5Uddxj9C3mF8mGUG3_Ds62a2U1zMaS_mFqgMlBaFw4sAk
Message-ID: <CAGsJ_4yH6v58oD8K56hMPp5bTYGC1Bfo3XSAViW9gWeSwLXgDw@mail.gmail.com>
Subject: Re: [PATCH v5 05/14] mm/mglru: scan and count the exact number of folios
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hcbrzynieoyhkkbthuzrc9xmoq4nwe1q
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BC1FA40008
X-HE-Tag: 1776322902-423574
X-HE-Meta: U2FsdGVkX19UClSSQyGMxLEMY/XgFjzZ9qQue4h1mVS4HWVTkc8N2OunVG3LmRBqF5i6IwedhOPJQq2x2P/g5Qeq4aA5kg41OSjgHfEkxSDX7/ZAU7DC2AsoZSugynr96wn0Khs5tAI2w3GWM/MiWfKBDV3m/SPaf9oG9xB45I1y01gtnqo8RESX5vZ5j9u/ia+K4D46EhdBpn6MD4veOJQ2NdW6o/8d6oejcvtDkNDAxwJkicV0xxtwsE7npXHSqxFfvDJyrlFWE0+knsMH03c0p+Dt/Y83Gf5EuUbMe063+WnYEFngdxAWLUG4aN+QdWQnNboanK8vu2apu0L/XAbpm3xDio4KBmEu503t6BIHnPZezS6xycv6fBCoYwLARaPvKXXB+OyUl5OESawiSEvgUvhbiU9O3g1TcXp5uePHjOeGdyiZ0LumD1B/+zp1GRMbwSUVQygvHBLW5SC6+X9xBMXNp7fCzGfWJVhWb+S+y746xc4bFGxX5tQDVzSqjJDjTysSq2byruodNIyH/n6KqNqGJih5RLP0H5VG3OOZ2+8N5m8kLylNpduoFA1RAv+u/IAd5F3RPcGaim1mjxAFEVMdBmv0V6erImO0e7YpfEn50zNt9J+LM9LVq4Z11Vmf99KRaVxK3XiOtQ35snJGzhgHtbohgINDvuxvilRo22g29qciSPqkphB49YMJ0DDBDN7JIIGxwPJEA5Fnwx4q6oH84jsNU/jxby3O+tCo0g8liFPiN334h+bJJmwt91D7VQw4WpKYvp/tI5fGyeykuBIlLis1U7DZrBmg+SNhwmJOG+NzG27wqWFgWa6DVgUUkiTR7viHNySiIM8WAZYvbiphMyoofSE6pepNsaL+D3bpBpUCivTFYCu8m5P8qW5CJmdd88tpmni5+MsdrC0bczfWpaL0FLaqbvIH5wudwm/pEmOoa4k+dItTJ6FTKnIvkn1wd1Ne9+JWnaj
 bA5VWd2K
 l7Iwh5pPjTuWvgovttjF4nfJD1T9zhuaZf67POLNcWK0k0MOcb+IVEQ9Gh+oe+mnJ7pD1dB5njOGSOhp6RaN8Y8SUwM/F4sV1InWXJJFVV2jW1wqYoEImqMXxV8XC+qwxNYCpSBtqR6vjTQR6upENpNsEhks7+xVe8qUIVPljbAlOYZN+q+ySFeV4b+V2DqaHvO9q6rGYCNagOVtCrxt1vXH9ODC9eaYJkuGyMdAhedBF3qaHpixC7AswVxYQMhnHUt6lgyzESx38PrKV7jPvL9VZH9VMcohm3S+ZZwMz9L9j7UYQMC1Le/o31dfTDdasFtipfOVn7HCVow6H/3gO/OOGS3TYW6Sl2/8+XvlGuk044EcZWhCKs/gTSWLXQSqDlQyR/2dXRUdw1XBPSphE5tYDGqJNMUSrDNNaB8QwZbtPXaF67RLowi5VLe0/Z7ydMxO/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 12:48=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Make the scan helpers return the exact number of folios being scanned
> or isolated. Since the reclaim loop now has a natural scan budget that
> controls the scan progress, returning the scan number and consume the
> budget should make the scan more accurate and easier to follow.
>
> The number of scanned folios for each iteration is always positive and
> larger than 0, unless the reclaim must stop for a forced aging, so
> there is no more need for any special handling when there is no
> progress made:
>
> - `return isolated || !remaining ? scanned : 0` in scan_folios: both
>   the function and the call now just return the exact scan count,
>   combined with the scan budget introduced in the previous commit to
>   avoid livelock or under scan.
>
> - `scanned +=3D try_to_inc_min_seq` in evict_folios: adding a bool as a
>   scan count was kind of confusing and no longer needed to, as scan
>   number should never be zero as long as there are still evictable
>   gens. We may encounter a empty old gen that return 0 scan count,
>   to avoid that, do a try_to_inc_min_seq before isolation which
>   have slight to none overhead in most cases.
>
> - `evictable_min_seq + MIN_NR_GENS > max_seq` guard in evict_folios:
>   the per-type get_nr_gens =3D=3D MIN_NR_GENS check in scan_folios
>   naturally returns 0 when only two gens remain and breaks the loop.
>
> Also change try_to_inc_min_seq to return void, as its return value is
> no longer used by any caller. Move the call before isolate_folios so
> that any empty gens created by external folio freeing are flushed, and
> add another call after isolate_folios to also flush empty gens that
> isolation itself may create.
>
> The scan still stops if there are only two gens left as the scan number
> will be zero, this behavior is same as before. This force gen protection
> may get removed or softened later to improve the reclaim a bit more.
>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 60 ++++++++++++++++++++++++++++++-------------------------=
-----
>  1 file changed, 30 insertions(+), 30 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d4aaaa62056d..e3b68b008376 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3878,10 +3878,9 @@ static bool inc_min_seq(struct lruvec *lruvec, int=
 type, int swappiness)
>         return true;
>  }
>
> -static bool try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
> +static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
>  {
>         int gen, type, zone;
> -       bool success =3D false;
>         bool seq_inc_flag =3D false;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>         DEFINE_MIN_SEQ(lruvec);
> @@ -3907,11 +3906,10 @@ static bool try_to_inc_min_seq(struct lruvec *lru=
vec, int swappiness)
>
>         /*
>          * If min_seq[type] of both anonymous and file is not increased,
> -        * we can directly return false to avoid unnecessary checking
> -        * overhead later.
> +        * return here to avoid unnecessary checking overhead later.
>          */
>         if (!seq_inc_flag)
> -               return success;
> +               return;
>
>         /* see the comment on lru_gen_folio */
>         if (swappiness && swappiness <=3D MAX_SWAPPINESS) {
> @@ -3929,10 +3927,7 @@ static bool try_to_inc_min_seq(struct lruvec *lruv=
ec, int swappiness)
>
>                 reset_ctrl_pos(lruvec, type, true);
>                 WRITE_ONCE(lrugen->min_seq[type], min_seq[type]);
> -               success =3D true;
>         }
> -
> -       return success;
>  }

I like that you removed those "success" checks;
they have caused me to fail many times.

>
>  static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int sw=
appiness)
> @@ -4686,7 +4681,7 @@ static bool isolate_folio(struct lruvec *lruvec, st=
ruct folio *folio, struct sca
>
>  static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>                        struct scan_control *sc, int type, int tier,
> -                      struct list_head *list)
> +                      struct list_head *list, int *isolatedp)
>  {
>         int i;
>         int gen;
> @@ -4756,11 +4751,9 @@ static int scan_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>                                 type ? LRU_INACTIVE_FILE : LRU_INACTIVE_A=
NON);
>         if (type =3D=3D LRU_GEN_FILE)
>                 sc->nr.file_taken +=3D isolated;
> -       /*
> -        * There might not be eligible folios due to reclaim_idx. Check t=
he
> -        * remaining to prevent livelock if it's not making progress.
> -        */
> -       return isolated || !remaining ? scanned : 0;
> +
> +       *isolatedp =3D isolated;
> +       return scanned;
>  }
>
>  static int get_tier_idx(struct lruvec *lruvec, int type)
> @@ -4804,33 +4797,36 @@ static int get_type_to_scan(struct lruvec *lruvec=
, int swappiness)
>
>  static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruve=
c,
>                           struct scan_control *sc, int swappiness,
> -                         int *type_scanned, struct list_head *list)
> +                         struct list_head *list, int *isolated,
> +                         int *isolate_type, int *isolate_scanned)
>  {
>         int i;
> +       int scanned =3D 0;

I would prefer to rename this to total_scanned.

>         int type =3D get_type_to_scan(lruvec, swappiness);
>
>         for_each_evictable_type(i, swappiness) {
> -               int scanned;
> +               int type_scan;

And then we keep this as "scanned".

>                 int tier =3D get_tier_idx(lruvec, type);
>
> -               *type_scanned =3D type;
> +               type_scan =3D scan_folios(nr_to_scan, lruvec, sc,
> +                                       type, tier, list, isolated);
>
> -               scanned =3D scan_folios(nr_to_scan, lruvec, sc, type, tie=
r, list);
> -               if (scanned)
> -                       return scanned;
> +               scanned +=3D type_scan;
> +               if (*isolated) {
> +                       *isolate_type =3D type;
> +                       *isolate_scanned =3D type_scan;
> +                       break;
> +               }
>
>                 type =3D !type;
>         }
>
> -       return 0;
> +       return scanned;

Then
return total_scanned;

>  }
>
>  static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>                         struct scan_control *sc, int swappiness)
>  {
> -       int type;
> -       int scanned;
> -       int reclaimed;
>         LIST_HEAD(list);
>         LIST_HEAD(clean);
>         struct folio *folio;
> @@ -4838,19 +4834,23 @@ static int evict_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
>         enum node_stat_item item;
>         struct reclaim_stat stat;
>         struct lru_gen_mm_walk *walk;
> +       int scanned, reclaimed;
> +       int isolated =3D 0, type, type_scanned;
>         bool skip_retry =3D false;
> -       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>
>         lruvec_lock_irq(lruvec);
>
> -       scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness, &t=
ype, &list);
> +       /* In case folio deletion left empty old gens, flush them */
> +       try_to_inc_min_seq(lruvec, swappiness);
>
> -       scanned +=3D try_to_inc_min_seq(lruvec, swappiness);
> +       scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness,
> +                                &list, &isolated, &type, &type_scanned);
>
> -       if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS =
> lrugen->max_seq)
> -               scanned =3D 0;
> +       /* Isolation might create empty gen, flush them */
> +       if (scanned)

scanned is not equal to isolated, right?
Somehow, I feel the comment does not match the if (scanned).
I assume sort_folio() could also create empty gen?

> +               try_to_inc_min_seq(lruvec, swappiness);

Thanks
Barry

