Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE13606A33E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BOH/xn2C
Received: by kanga.kvack.org (Postfix)
	id D5A466B05B5; Thu, 12 Nov 2026 04:25:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0A266B05B6; Thu, 12 Nov 2026 04:25:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2F56B05B7; Thu, 12 Nov 2026 04:25:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87BCD6B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:25:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0EF1E1604A1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:25:08 +0000 (UTC)
X-FDA: 85425933096.03.C535D2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1731720009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:25:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BOH/xn2C";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794475506;
	b=gdLuRBL4nnVjN4fbgG9pTxaICyZ77TffPg4uQv3qbFRB5OsIq6tblLZ7NzAubsHvZox/S5
	9bKjMbsXI5tCITK+tuULnUcaHi4Iakdp35HCPdHv3QZ9TGijar3iTYsPjrXyS0uJJgj1Sd
	OohuZZ7nSI/xYd4IBqReU1Hl3LCOyZQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794475506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5B0RJoEw22n7pSmPjGxvDx2wDYJxUF2iT6J4nNYETk=;
	b=loSo5/R6ikY7SwC34ZA0BtMqTfpLLyLWWjsrGDUM3riOc/gM+d2EIs8mG2JzaML/Gzbw74
	AlohA1zGjmlh4QnMKA5pLFZe0NSa+jWwT5eUIS6rKvDW/VPTRZ5jxlNL6Shh4jaeemJ/kJ
	NTmlslk8mcY0LRFDWNkrVX61W000zHE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BOH/xn2C";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F1B2471DC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415A61F00A06
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794475505;
	bh=J5B0RJoEw22n7pSmPjGxvDx2wDYJxUF2iT6J4nNYETk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BOH/xn2CfkD+tbh//3qR/k0EO+9aEdGd0l1mPWeaJO0YcZU3n5MhNT2Op3oWmZjro
	 gMbNYQo4skRL6IntK6dEyDGPjBzM+PnA6XyMNaq5wmF9i4QOJuSEcl6I6uiG9xSR6T
	 /dQoQaCTGufnE+at8PMX5bHWWcArrVilcR5+ETYzZ2+6L80jImEAm8IeUjLSC5LzXr
	 6N7sDjdRbqvQh3CO7pj/Cwvz6RJ6fey4l/uijA3SIcZemcpckZXAvgM8fZjeB10XMt
	 nxJgVvbI8yqgxJW0IiCdKhSe8VFaPCphfs3JUBtVvAx3sr3MFHq2xEKEovmhGuTIWu
	 dL5VkJugUbbmw==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93f2b8cf037so358165885a.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:25:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEZrDkABASZsGr729UVAY3HEvhl2XgnPOpuJrupqjjpAV9HItsJErqzNmWjWFf2mVq96MEyCqnAqg==@kvack.org
X-Gm-Message-State: APuU4Z+FoLPmta/zw65CVevzj+OTbNitzxDCK2qgZLiYsjd9q8/igex7
	i+9g5hO/HmvqpqF452zk1h6yXFLIPY5ZrJ70HzJjJ5GfFQ1Segfksi/QueRzYqok2JAQRgpajhS
	5Jg07ZrNprcHJTlt9Le0Mepn8jVZmjnU=
X-Received: by 2002:a05:620a:8391:b0:947:7f9b:f839 with SMTP id
 af79cd13be357-947affa76b4mr781387585a.47.1794475504604; Thu, 12 Nov 2026
 01:25:04 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111232603.9934-1-baohua@kernel.org> <20261111232603.9934-13-baohua@kernel.org>
 <sashiko-outbox-210420@kernel.org>
In-Reply-To: <sashiko-outbox-210420@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 12 Nov 2026 17:24:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zFbVuFimS7GHR0djiic71kAHVFPUmwfin97-xMhDB0iw@mail.gmail.com>
X-Gm-Features: AclHuK-hi8tCS7ALgGsjBn_gjNAMG15-FIUkG2aQlj-4JRAEd1r4uCcUq5mKHbQ
Message-ID: <CAGsJ_4zFbVuFimS7GHR0djiic71kAHVFPUmwfin97-xMhDB0iw@mail.gmail.com>
Subject: Re: [PATCH v7 12/16] mm/mglru: Restrict eviction accounting to
 eligible zones
To: sashiko-reviews@lists.linux.dev
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, 
	liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, 
	liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, 
	mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, 
	ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, 
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, 
	zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1731720009
X-Rspamd-Server: rspam12
X-Stat-Signature: hq6gkj9bfc8nrxeqee7dmst9tn93psj3
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794475505-121696
X-HE-Meta: U2FsdGVkX18Yptsk3g09F2R/iCuAlQWk+2EBI3zuj3Hr/GUHVFciVXcxQ/pYvae33QpSc3pXYT050odQP3eQ9C/5xet6LunOc2kx+P2ODGTnERvbiM0Bo/bKqBAbeolA99LbrP7oP5gHNm7BQ4FD5W7TKqZ0sVTOuUeahnvnBs/SGswBD1e6J9F2avcLSezuKvAUn/p0Hlc+mk3Ez0PolS2H+TPp009auGaaYFcfor2I4CQFRVUKp2e5LInLcBB2mnZNBnCHbTEfuVf/ZdqBfxq+gWPE5Sb2RFQFwsedLQAR0M0BU/gHqxRNbCG7KKFmPzXlu+eod3g6lfGRcZTj1QvkoDr2Q8XQ0FHAvOBfX1u/CNJYgoXRb+vFUr+/kPYdE5ZKbD+brdmIjZo56chMP6sN/xluoa8q9C+OXcdmvhQzJ5JggnDjBWfNVI4LhNb532F+j7d8h6XfSutgHh1cmUpqjU0/KiHV+ZOnxbIqRx2EJg+SNVUsTI8YkNejiz8s06MzKoY9vxFkG05nLu9cytkPnl5DyhCTR3QpjEx03UX0nmPjaku9gxwGcY9zkss+mGrHDJWIMsM2LIRD+2SfvJYH6a4S5LAT9d4+SwcR8LEQkhN3zlSuj+R0LAfsspSKct1fS90BYZwqxwQBfYYybxiS0O/fVCxX5ZqzgSo2iBCaCqPlQ7dYKgLl8z58EjG7ywWf4zM5mzVTRBfZ5bQ23ZdDZCKxEMMU1NSGkDhlolBSfosoygrgD6wCxh7QrGhX0v7uaXUmMd5nNRriUMt9lJRzRR5nZThgu6T+7u8tj+V2M7ioo3t5aiv5EGOsw0WJdII4H8a8EnPKi5UAIow+GBVpurZo8e147KxKmVFiALF2n2PyJXLDRbDukjltNdxbkVRdsY7WtjGlnZ54MNJD8fmsS95D5UG6vGtHxw5YWrVXACsv/GZ0HoCQ0Kmk09WuVb2cV5xoF69QOQ1SZD/
 PHSYfID4
 8pT+WZ0bhqTXOKUxvn6SWhAbB4MIiEOqw4kjLQn2F4JVrf197VgC/Qi9vf8+/JPoRMqyBOCwfq6wF0mxq8c1yh8rIvIl6kxUt1yGkthvp/94urh70TdfdfnYV/OrUUPETDN6eR0+PJLM6eqMuRV6LGwL8kIOkK3N5eScpbt2k1aNW2sx8iRLhAyoxgljuvzFcjBPGFWqozGYuswfo7pQsS6BhMPJ5sThfr9bnJklBxZS9ZzSEzcT87qSPBrP2P9eeVYh7GMd0GUhpiB70FoBBdyOdCfMHuWU9BFupYAqqKwdKbq4BWOxCzie5ChAUjuxL084W5fcQ855n4LG3PnRAsbv5THpu+cB5k7nFKLWcoYxngO2yPUMTib3gECEA+fx9lVjUWnqzh9Cw+F3ZcWJCEi6VMxN0IrHlElUK4v/BuT+DsbyTdFRZrVa6V4HwOrgkPBo7/rbJcu4bOIb8ENLez3vKeLX1Ym5rvOfOBQ1gNdYiN19xgjgfwgvuIPwO//WF7Bq8xVQo79j/Xs7fyAb6r0M3bsVAMYZn5iMxd9DEwSx+R23q846wiL2qXbNt1EfCuzFcQGHkIY7PVRuvfEoRkoR30Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 1:01=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/mglru: premature OOM kill in lru_gen_age_node() on
>   zone-constrained reclaim
> --
>
> commit 169c51ce627ac19052dda882e181615f7e7c984d
> Author: Barry Song (Xiaomi) <baohua@kernel.org>
>
> mm/mglru: Restrict eviction accounting to eligible zones
>
> This commit restricts lruvec_evictable_size() and lru_gen_imbalanced() to
> count only zones at or below sc->reclaim_idx by adding a max_zone
> parameter to lruvec_gen_size().
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 41dd77652c82f..8b77e6bc1d519 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4207,8 +4207,8 @@ static void set_initial_priority(struct pglist_da=
ta *pgdat, struct scan_control
> >       sc->priority =3D clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
> >  }
> >
> > -static void lruvec_evictable_size(struct lruvec *lruvec, int swappines=
s,
> > -                               unsigned long nr[])
> > +static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_c=
ontrol *sc,
> > +                               int swappiness, unsigned long nr[])
> >  {
> >       int type;
> >       unsigned long seq;
> > @@ -4221,7 +4221,7 @@ static void lruvec_evictable_size(struct lruvec *=
lruvec, int swappiness,
> >
> >       for_each_evictable_type(type, swappiness) {
> >               for (seq =3D min_seq[type]; seq <=3D max_seq; seq++)
> > -                     nr[type] +=3D lruvec_gen_size(lrugen, type, seq);
> > +                     nr[type] +=3D lruvec_gen_size(lrugen, type, seq, =
sc->reclaim_idx + 1);
> >       }
> >  }
> >
> > @@ -4230,7 +4230,7 @@ static bool lruvec_is_sizable(struct lruvec *lruv=
ec, struct scan_control *sc)
> >       unsigned long total, sizes[ANON_AND_FILE];
> >       int swappiness =3D get_swappiness(lruvec, sc);
> >
> > -     lruvec_evictable_size(lruvec, swappiness, sizes);
> > +     lruvec_evictable_size(lruvec, sc, swappiness, sizes);
> >       total =3D sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
> >
> >       /* whether the size is big enough to be helpful */
>
> [Severity: High]
> Can restricting lruvec_is_sizable() to sc->reclaim_idx trigger a prematur=
e
> global OOM kill in lru_gen_age_node() during zone-constrained reclaim whe=
n
> lru_gen_min_ttl is enabled?
>
> In balance_pgdat(), kswapd sets sc.reclaim_idx =3D highest_zoneidx and ru=
ns
> kswapd_age_node() -> lru_gen_age_node() before kswapd_shrink_node():
>
> mm/vmscan.c:lru_gen_age_node() {
>         ...
>         do {
>                 struct lruvec *lruvec =3D mem_cgroup_lruvec(memcg, pgdat)=
;
>
>                 mem_cgroup_calculate_protection(NULL, memcg);
>
>                 if (!reclaimable)
>                         reclaimable =3D lruvec_is_reclaimable(lruvec, sc,=
 min_ttl);
>         } while ((memcg =3D mem_cgroup_iter(NULL, memcg, NULL)));
>         ...
>         if (!reclaimable && mutex_trylock(&oom_lock)) {
>                 struct oom_control oc =3D {
>                         .gfp_mask =3D sc->gfp_mask,
>                 };
>
>                 out_of_memory(&oc);
>
>                 mutex_unlock(&oom_lock);
>         }
> }
>
> Because user LRU pages are allocated from the highest zones and kept out =
of
> lower zones by lowmem_reserve, a wakeup with a constrained highest_zoneid=
x
> (such as ZONE_DMA or ZONE_DMA32) can find fewer than 1UL << sc->priority
> evictable pages in zones 0..sc->reclaim_idx in every memcg.
> lruvec_is_sizable() and lruvec_is_reclaimable() then return false for all
> memcgs, causing lru_gen_age_node() to invoke out_of_memory() with
> GFP_KERNEL even when higher zones have plenty of reclaimable memory older
> than min_ttl.

I think this is a pre-existing issue. lruvec_is_reclaimable()
uses the current sc->priority to estimate the reclaimable
size, which can significantly underestimate it in min_ttl
cases. Our patch somehow amplifies the problem because it
uses the correct reclaim_idx to calculate the reclaimable
size.

static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct
scan_control *sc,
                                  unsigned long min_ttl)
{
        int gen;
        unsigned long birth;
        int swappiness =3D get_swappiness(lruvec, sc);
        struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
        DEFINE_MIN_SEQ(lruvec);

        if (mem_cgroup_below_min(NULL, memcg))
                return false;

        if (!lruvec_is_sizable(lruvec, sc))
                return false;

        gen =3D lru_gen_from_seq(evictable_min_seq(min_seq, swappiness));
        birth =3D READ_ONCE(lruvec->lrugen.timestamps[gen]);

        return time_is_before_jiffies(birth + min_ttl);
}

I think we have two options: either drop this check and
make sure lruvec_is_reclaimable() focuses solely on
min_ttl:

if (!lruvec_is_sizable(lruvec, sc))
        return false;

Or we can do the following, using the lowest possible
kswapd sc->priority to estimate the reclaimable size:

@@ -4245,7 +4243,7 @@ static bool lruvec_is_reclaimable(struct lruvec
*lruvec, struct scan_control *sc
        if (mem_cgroup_below_min(NULL, memcg))
                return false;

-       if (!lruvec_is_sizable(lruvec, sc))
+       if (sc->priority <=3D 1 && !lruvec_is_sizable(lruvec, sc))
                return false;

        gen =3D lru_gen_from_seq(evictable_min_seq(min_seq, swappiness));


>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.99=
34-1-baohua@kernel.org?part=3D12

