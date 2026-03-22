Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69B49FC72CB
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 16:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEEE46B00AF; Sun, 22 Mar 2026 12:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6D46B00B1; Sun, 22 Mar 2026 12:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDC5C6B00B2; Sun, 22 Mar 2026 12:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADDFD6B00AF
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:12:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E2A4BB77D
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:12:29 +0000 (UTC)
X-FDA: 84574191618.24.91EA8BA
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3654D140002
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:12:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W4KHVIwy;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774195947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XurT+VE/H+4pusdVhugAfKNwp7ah8VEXsxBJLHbX2c8=;
	b=mAYuAhstI5uycH+FWRBk4+fSh/bCEMInSak2oRBXYWhESrKm4i64wirSLnvgE5nczQz+Lz
	d9/zkLF4FR0DoNTicrVyEKKiGUyNpsozZyKlMENkApI1IodFB5KHZURUVuj86fr2mVlz7c
	SitXkPP2MFBcvlR4i6mivvC2eX8l22c=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W4KHVIwy;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774195947; a=rsa-sha256;
	cv=pass;
	b=OLsqdlD04Byy3l/gXzXSMiPUVwA2QjPp7+ZIvsEt++yulFU33COcwLg2XBFi5SzlqnfGYW
	bZqlAvEB8G/ZDuu0/Fpd9Ki8g35nO8DUF4rsqIs6xHTZIRfyer25fsymssyzLT2oxhYuKG
	ihHnrmAcSOIX6lsjN+C0DaSOUSlxJGQ=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-668abc98923so3518883a12.3
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 09:12:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774195946; cv=none;
        d=google.com; s=arc-20240605;
        b=e483AR33sQhkCLgUHkDHvfv3M57F92Qk0bsQ7vIXQKTEZh8aFnjN8ii0qllZwcctre
         gGh3+ywOWjywBt+AwgrLAOd7+ZaA8k/B9BwQPuIV/PkOvK9xBES5IiAFOt6NySLIYrHO
         xjC1LQd40joIlBlE4u7ao10NcOYHGqLXA/3QD1eYPYv8qRLxen2S5wg2RF4p7Dt2UIxP
         TA1wv9IVcApdRpYq1hxpW4cTy1McLNgwpuJbyfsq9Z4n7jOErYfr51qVB7te2PTHXUih
         jNerdBGWmd3E9irOlpO7yDEAxi9j5hnwB3KKpijouvPIWvYOClH0PgVfJJ6fW8797ko+
         hxww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XurT+VE/H+4pusdVhugAfKNwp7ah8VEXsxBJLHbX2c8=;
        fh=PDkWHDPYrUH4Rv3G6SlipcAJYCmVeJ5HojcdeLfJRmE=;
        b=OgdS5nViLvKcwzEgXoNDQZbiTIKZdFATh52oOz/5eyHZSke+WL6NATlLM84IvcNF1W
         wpYnJsvfiPe9kWZ7oc2/FNgkbrOKJh1smF4q0PbqsLFgwoFAOF5vThaVxAtySzK3myGy
         xDUP7mZfyLNBTPd63f9hjLGlueW1TvpIxELfyqVPvvmWcvSf0nSaJ6O8qVv/QnbWC0HS
         lSu8x3LsaCsfNZM5ZLZbKW6WLZcu3RQHLGUA/Z+RcKx1G8o91F7t3Pl+b8iPUuhY3mpn
         itMjjf3ULs7i6qCnyX7VvW0dwWafv0d0Xb86sQ3CZmgK3wi1aAewfQopjDYkVI+JSvXd
         f8iQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774195946; x=1774800746; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XurT+VE/H+4pusdVhugAfKNwp7ah8VEXsxBJLHbX2c8=;
        b=W4KHVIwy8CgZQfXhrZ+WK+r8J/Wh5q7GR09uWTVnACdgLYlS4Nzs9kVdTkJbMKwVD6
         UDckQgfvrPbLadVRbOSSkwIplpiqzVaiY5/b5Is2cCVnB2d21etW3DRGfaZR0sWv7ufg
         uFjXmJHe11gkbuFnfdKu1naFfiDBiJjbWQFngw77nh3O8iIxk2UuR5ZVf7mteDn/eqt1
         TBGx16UbOqgAekW9ob19g1dv5bDMQxxpzoohB1Sv0aUsHqhbfJzKf/Ly3fx8lFlz1Ovz
         P/dE+5dhhfBEHZWB3TpB5OrFMXoXVJAGi6P7mlWgExDK5KpgP6qMHeksFzpPuXhkXXRP
         MyQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774195946; x=1774800746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XurT+VE/H+4pusdVhugAfKNwp7ah8VEXsxBJLHbX2c8=;
        b=mnggXq2xjbuYXQQo/YVsSavtkG+CTregz1H1/hVvNsKSsgyciXIjmOmg3jUyF7Yx7U
         wq7e+KGQQS6IsG7XifRdehVSbEeH5uO/Ahs7CfsIC1vdR/eX71ZlLNxCFH941GHCqAb0
         HIjUyHYKJTLNpz1tV81SbHIwCUiTrf0VxL191lehtZ7bM5cuNUyjGeAa9IilALI+0GbQ
         otwtWyTXKQE0R9qch4reME4fWJeLgTYLvagfYOsIbSBoDqNkneRrXH5W2FSd9GveKa0K
         Ubu65ynscDO77W+cELRObToAUnzBbU3Cx9ywzBOFRCFPEvi5FN1ZwcfUBN1pIQB9f/jX
         N6/Q==
X-Gm-Message-State: AOJu0Yys2DCc1gYdSxa1ZNES4NZfHFfe2IbbwAIwL+EyhRDQuE3UiQnb
	JgfCbITU+MveqB9qgJOWGNjy0Xpy5FV5vSBI4Xu+VxQPYharv2/hvZMrxDUa3FjAXmcTId56Tor
	M7t9UaIR5hhiwY2feWPLQS+6uAf8QFMM=
X-Gm-Gg: ATEYQzxb+uNTF84dK42OlUf8YTOgpSZjfF2Gczd4Y2l2RnZWKaTRlKg4SvlyD9NA8jw
	Kzf3gQZyI7JSMV1hmm90hQwinWVjUiVJzR6uQciBHtmepexdMovLfCuiyO8A9OKLqAD6pdkGMNR
	xY8QoIZtjyQdG0gLK1FzVgVS2F3tvbAMktQCd2UT/4Xn1IAD49I1PZUGSoEyLv+Os/MxJb6Ltu5
	XvDglkc5Yrhe/gF2+L0I2UEIfDJS5cJ98+aW/eV2ak5jyzkAIrF90bxCub+Rc5g3uslvtazao++
	8GeETvwJw4324juz6qwe0D2iRSlHv/flrXXv4uXl
X-Received: by 2002:a05:6402:a0d3:b0:667:f3dd:6062 with SMTP id
 4fb4d7f45d1cf-668c972a6f9mr5775715a12.17.1774195945441; Sun, 22 Mar 2026
 09:12:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-3-2c46f9eb0508@tencent.com> <CAJHvVchcp4roMKuhjkCv4_bE4ivbo3zTzehkfE=3JqjybYM+TQ@mail.gmail.com>
In-Reply-To: <CAJHvVchcp4roMKuhjkCv4_bE4ivbo3zTzehkfE=3JqjybYM+TQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 23 Mar 2026 00:11:49 +0800
X-Gm-Features: AQROBzDopoGrS6QJ0-m-pt0G0aYzn_KW_a80ET4j-S5SVm7Uzj4bGAE3xLsX_aY
Message-ID: <CAMgjq7CEHr0w2JmqZBjBUmpNyQ2oNkKHLf4hJQbuMzL4+A_uig@mail.gmail.com>
Subject: Re: [PATCH 3/8] mm/mglru: restructure the reclaim loop
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dyfhgotfc3f7gm3dzepbyrbb8w15bfr1
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 3654D140002
X-HE-Tag: 1774195946-368222
X-HE-Meta: U2FsdGVkX18DoMI1uSBVfgPoFLUV670UacGE5Ma8ueCRfDOYKtaR0DpmfUVC16c0xpj6s/cC5ZNYimDG+eVwrDehMN3yHt9dsezukS8wI7Dk5XSJvXUqKmhX+TejP6UbLUIofmc3LknI2dq5uYxzplJlgSe4uRiVOK5tHkoRKdoSai01JMxC9gQ1HH1mbtcsSadKv5os8Oc3iPN3j5/U/NEx+1bLa980lNZ2QNa5bAchsujRqfltXZIX3WlWPsiWUNfHvJ1DCTo5SGrqxotqtdpaaD4VZswerxR3Dp5wIYFT6sVqObEP/a7IhWDg6rWdcZAuNIytcSEzXhxmanIjO4k6lv62lzhb/wkEnKuiEfh9kHDA8OdCK0+A1H7aDedO40Eb30EBJENC+L0bv6ogy3QJTc8iIzJG0J0k2OS6NVk7v4V0TeWg5858xn5iTBlYTEgnaNmgihG72VnAlKoZ+BXcWyrkRsg+jPqYBccWlkHCsvAfp1kgf+qz42B66HDcLNHHY/qmMzsssc7moCV9o9zNAUZLpqDXDxRqu7X9qGuKklCVNOlrW0fI61Ecc28wEaqQgG1GCPljrPaaK2+Kz2X88YJhavWpmnu9OafbS94FYoMgsMiAxgpFFiB5RrvXjTKgLsoBwDLsRiELiSLwSUmcSuVENFHDjHWHfOXwmbDudktyGOO1jr0Ad4k23jG13sHrmA4vQvgubZXKHMCKPcp4mNXTVNK3J1DWUbUcMB5D18E0nOQl1pp8IpIMNz691lmuDOzgkh/BJ7q8DGK+LI2biuReh0WtrQPjbk+V92bBAkc0I66EeJ7MWA287lUVGFPYTeqTSlFuzMyl6XQF+e5vyhTqCREnS22QOLxv1dTkmJR2OTmms8MtsOWXOvewYvE374NBZw86VsICU91e/Tep9WFpVddFdky4XYDPUW1UwIs7YCNNlFY0JhyBlXWqHRFiPcQeSp3xR5eH+oq
 AoAkM9HI
 lnlllsbr+z0BVISR5FmWKzMo/55APtMLjvCp6gd/r7XhszFVMcBgNRhYAkHDGjIFpj4601X4QEHo1u36oglrmbmPzbbGAzibAGbV+hix9+q7KflM/PC5tupOfiAs3IkLdHRlaHCr7/1F88OQu5YfSZofdDH++5/XhLTw9fh21RqT+YWUfMJ10NXxGpNGE9hxauTWStfdXI+L7Us1lW0dKqXg/rXscr4Xa8bFE0nlt5rVu5QvZHcTUc92ogEvxBlsCj1AZ3Jpuxu+a1yOmDtKB+6KQOohk31mZuana0sKOx14fCvnZmRcoL3Lu5wHdHnG0c3/RIyinwYF2ijayPXdIrfHE+BCfOxJI41K2kBzVw0Pxw5Lm6N8WT7FnN9U+dgzALWMJe96M2bxGELXZK1gfMBFr0yvaQ1vzUMuj/0q38WX/quFWQINY1Tl0HrayxI8ejFtKMwTBuUkhQjayhcUwHumxFoISmNN6Qnqs3bKfinck1Og6y22u8La9poadiPXbcHx3/JT4Y1r0aMHV3JvBiko5UzTtg86g/ics
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 4:10=E2=80=AFAM Axel Rasmussen <axelrasmussen@googl=
e.com> wrote:
>
> This looks like a reasonable refactor to me. To me the new code is
> more straightforward to reason about, and I don't see anything this
> breaks (either by inspection of with basic functional testing).
>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
>
> On Tue, Mar 17, 2026 at 12:11=E2=80=AFPM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > The current loop will calculate the scan number on each iteration. The
> > number of folios to scan is based on the LRU length, with some unclear
> > behaviors, eg, it only shifts the scan number by reclaim priority at th=
e
> > default priority, and it couples the number calculation with aging and
> > rotation.
> >
> > Adjust, simplify it, and decouple aging and rotation. Just calculate th=
e
> > scan number for once at the beginning of the reclaim, always respect th=
e
> > reclaim priority, and make the aging and rotation more explicit.
> >
> > This slightly changes how offline memcg aging works: previously, offlin=
e
> > memcg wouldn't be aged unless it didn't have any evictable folios. Now,
> > we might age it if it has only 3 generations and the reclaim priority i=
s
> > less than DEF_PRIORITY, which should be fine. On one hand, offline memc=
g
> > might still hold long-term folios, and in fact, a long-existing offline
> > memcg must be pinned by some long-term folios like shmem. These folios
> > might be used by other memcg, so aging them as ordinary memcg doesn't
> > seem wrong. And besides, aging enables further reclaim of an offlined
> > memcg, which will certainly happen if we keep shrinking it. And offline
> > memcg might soon be no longer an issue once reparenting is all ready.
> >
> > Overall, the memcg LRU rotation, as described in mmzone.h,
> > remains the same.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/vmscan.c | 74 ++++++++++++++++++++++++++++++-----------------------=
--------
> >  1 file changed, 36 insertions(+), 38 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index d48074f9bd87..ed5b5f8dd3c7 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4926,49 +4926,35 @@ static int evict_folios(unsigned long nr_to_sca=
n, struct lruvec *lruvec,
> >  }
> >
> >  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_=
seq,
> > -                            int swappiness, unsigned long *nr_to_scan)
> > +                            struct scan_control *sc, int swappiness)
> >  {
> >         DEFINE_MIN_SEQ(lruvec);
> >
> > -       *nr_to_scan =3D 0;
> >         /* have to run aging, since eviction is not possible anymore */
> >         if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_=
seq)
> >                 return true;
> >
> > -       *nr_to_scan =3D lruvec_evictable_size(lruvec, swappiness);
> > +       /* try to get away with not aging at the default priority */
> > +       if (sc->priority =3D=3D DEF_PRIORITY)
> > +               return false;
> > +
> >         /* better to run aging even though eviction is still possible *=
/
> >         return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=
=3D max_seq;
> >  }
> >
> > -/*
> > - * For future optimizations:
> > - * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for m=
emcg
> > - *    reclaim.
> > - */
> > -static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control =
*sc, int swappiness)
> > +static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control =
*sc,
> > +                          struct mem_cgroup *memcg, int swappiness)
> >  {
> > -       bool need_aging;
> >         unsigned long nr_to_scan;
> > -       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> > -       DEFINE_MAX_SEQ(lruvec);
> > -
> > -       if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
> > -               return -1;
> > -
> > -       need_aging =3D should_run_aging(lruvec, max_seq, swappiness, &n=
r_to_scan);
> >
> > +       nr_to_scan =3D lruvec_evictable_size(lruvec, swappiness);
> >         /* try to scrape all its memory if this memcg was deleted */
> > -       if (nr_to_scan && !mem_cgroup_online(memcg))
> > +       if (!mem_cgroup_online(memcg))
> >                 return nr_to_scan;
> >
> >         nr_to_scan =3D apply_proportional_protection(memcg, sc, nr_to_s=
can);
> > -
> > -       /* try to get away with not aging at the default priority */
> > -       if (!need_aging || sc->priority =3D=3D DEF_PRIORITY)
> > -               return nr_to_scan >> sc->priority;
> > -
> > -       /* stop scanning this lruvec as it's low on cold folios */
> > -       return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ?=
 -1 : 0;
> > +       /* always respect scan priority */
> > +       return nr_to_scan >> sc->priority;
> >  }
> >
> >  static bool should_abort_scan(struct lruvec *lruvec, struct scan_contr=
ol *sc)
> > @@ -4998,31 +4984,43 @@ static bool should_abort_scan(struct lruvec *lr=
uvec, struct scan_control *sc)
> >         return true;
> >  }
> >
> > +/*
> > + * For future optimizations:
> > + * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for m=
emcg
> > + *    reclaim.
> > + */
> >  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_co=
ntrol *sc)
> >  {
> > +       bool need_rotate =3D false;
> >         long nr_batch, nr_to_scan;
> > -       unsigned long scanned =3D 0;
> >         int swappiness =3D get_swappiness(lruvec, sc);
> > +       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> >
> > -       while (true) {
> > +       nr_to_scan =3D get_nr_to_scan(lruvec, sc, memcg, swappiness);
> > +       while (nr_to_scan > 0) {
> >                 int delta;
> > +               DEFINE_MAX_SEQ(lruvec);
> >
> > -               nr_to_scan =3D get_nr_to_scan(lruvec, sc, swappiness);
> > -               if (nr_to_scan <=3D 0)
> > +               if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))=
 {
> > +                       need_rotate =3D true;
> >                         break;
> > +               }
> > +
> > +               if (should_run_aging(lruvec, max_seq, sc, swappiness)) =
{
> > +                       if (try_to_inc_max_seq(lruvec, max_seq, swappin=
ess, false))
> > +                               need_rotate =3D true;
> > +                       break;
> > +               }
> >
> >                 nr_batch =3D min(nr_to_scan, MAX_LRU_BATCH);
> >                 delta =3D evict_folios(nr_batch, lruvec, sc, swappiness=
);
> >                 if (!delta)
> >                         break;
> >
> > -               scanned +=3D delta;
> > -               if (scanned >=3D nr_to_scan)
> > -                       break;
> > -
> >                 if (should_abort_scan(lruvec, sc))
> >                         break;
> >
> > +               nr_to_scan -=3D delta;
> >                 cond_resched();
> >         }
> >
> > @@ -5034,12 +5032,12 @@ static bool try_to_shrink_lruvec(struct lruvec =
*lruvec, struct scan_control *sc)
> >                 wakeup_flusher_threads(WB_REASON_VMSCAN);
> >
> >         /* whether this lruvec should be rotated */
>
> It's a nitpick, but with the variable rename, this comment isn't doing
> is much good now. :)

Thanks for suggesting, this can be simplified.

