Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA143FC72A9
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 16:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EDC06B00B1; Sun, 22 Mar 2026 12:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F1D6B00B3; Sun, 22 Mar 2026 12:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 755BA6B00B4; Sun, 22 Mar 2026 12:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CFC86B00B1
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:20:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 039E75B205
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:20:46 +0000 (UTC)
X-FDA: 84574212534.14.B41838F
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0C97740009
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:20:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QFdDn49r;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774196445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsEVnAR2rid+kZCPg5L9YJqeGiJ0WqsCqIwul1NAGcY=;
	b=wKvdwd6WKN9uqZwP0S1mJTR7RLPFvR751hpLG/ooYi8rVE2YUgecWVLeFuLcBMt6K0Beum
	H2n6G2ObSYbvGhbCzlXtWeBkD8gz1oaP7FxFBl5ljih5aTz+94vx+sB+2qZ0lRJcgHHE1k
	HGRsaGqb2ZeTkhl2bdT7SSwCWzlvoZA=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QFdDn49r;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774196445; a=rsa-sha256;
	cv=pass;
	b=7jdlkenNiHQ4/nGAaQoQP/EqPln6dN16shgEaQh6YkXZEYJzrlMnyPUeW9aeXo1KriliD6
	Jws07th/XWyBM5QIFgJvXzBdPhiySL484zuTmPU+WQpWgRpD/jl+rEBLqYDWiZ8Ecj/DS+
	X7IgxSSbx1pnfwGl9AskucMo5Vu57EA=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6674cba2c50so6387338a12.0
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 09:20:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774196443; cv=none;
        d=google.com; s=arc-20240605;
        b=WcikT/S6qG+d/+cQ4X9c41l4HHqJp8MoqrfMzFDqUX4ZtGzjF1SCL/eqripmVuY0K3
         liZ//VS1YAJ+eO40BqIDLJWjb/iXF15WRhWC02qPGWiSx7bxPSqC5t3qZ0/FSshxZaOV
         bdlwe1WEgLR1p0fzvGE7c7XVMTyQdElo4B+7x+oqfhZBTFVMwpYSzZi/EE01LfqMzRe/
         NhGLXCJRMWe7s4kek4fDBiEKkiwkHCr/3I1uPWlIPemgd4EkDmEmaSrBn+m3nDXTvTzP
         IAV1IL06Hk+Oo8hNW44OV25copZ0RgV0egPRR3UkYD6FA3nx8T8yMt7wbAvA2oo/IYve
         +yHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JsEVnAR2rid+kZCPg5L9YJqeGiJ0WqsCqIwul1NAGcY=;
        fh=PDkWHDPYrUH4Rv3G6SlipcAJYCmVeJ5HojcdeLfJRmE=;
        b=fmhjcarcXaow5KwDWr7VuAsDKTgzTjqARJ1RziOzmJtKvpxp7BvJyX4Vt+sOFlEZNf
         aDDUroEC/kpM/q+z/AA+N5sy5iH3AflT+ATgkp9eQskAI4z8Iwa3KdYk6bHoJFCr8NYp
         aMfc4/6dxZCHxJ1G1AVoqZIR8kSBdyVM0b9nzYo+2FLLF1QIpyt6U+08lpTDrJIttHrZ
         /DW3MqKIBTAy7BJItzMBPEIKp8t2qD7wrcqVUBnoBrRPBIJYfy158zJKBABELEBRGFsF
         s5RGpC3VS55AAbk3B8Pp1gEJZFM4bmOasKDxd4vOdba9kWGcsjY2tSLL0h2+ASDCJYQo
         8hsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774196443; x=1774801243; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JsEVnAR2rid+kZCPg5L9YJqeGiJ0WqsCqIwul1NAGcY=;
        b=QFdDn49rgjh5iuomz1oLqsV8dSj0OXf3JlBsIldwZxxXD+A3gr+mLseYdZCwMDDH1X
         ZtrR7szQSOsbpGwNyxBDk6aKwugH6RY9UpzxKJeTOog8yMC3jUZwdwKsgolephrIOuv4
         thmttG2lUOwr5g+Wn3Pr4BImkaHMkzjdZGGJ3/UzyvEGP+THMLPvraHhXquo57AnmXJX
         G35NrjbzsnwL9BHsDrBd9SpX82cv0F4ksCuzXf7W9Y6cJdA/IbPOARVrw4j6XQTKc85F
         7IbzyoDZfBYx1Ql5GvTJWKKnIbajpCjK59VLQQXxwfi8sEaePOKWZPusyN+1hMDLQCu6
         VCUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774196443; x=1774801243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JsEVnAR2rid+kZCPg5L9YJqeGiJ0WqsCqIwul1NAGcY=;
        b=Pf/nwjMffJFeDyNcV3jqMq6VutlHvOufJELSySWTYlq0wKuMya08vMiR9F8Z2SKXBZ
         111NgKc9nB9zC/ZDzIkygTAZJRSVFMyGcR3JYAXFyFloNA0SFMbOrgkcA6PX69rNtfLk
         UJBdwUeM+17efRlBSHgYVQg/mqaCeksaBkyWiV9Bi4WRsftyxUo38+M1aItHLz6PeubH
         jOnk9vqTYYpzVroRIPxyxDjxKhg3btXPbIYGtlBhNT/loonxUWk4I3m9V0wBIZ8DM+mc
         D5BkDVcVw7uS0hFiFE6OLBxPSaCQ19NZgFGyKPhtLjsnc6lguixJQvDa9K1dRz8X8ZfX
         P0vg==
X-Gm-Message-State: AOJu0Yw9Oa7+jqJIFWD1PB4RaxhCHcZPnur3XKe8buX+y3FKrnVl2w2m
	0Iu2hdxwVYml1mXZmMbofeerojCObCrZMshNCBnTv9HZTjkc5nw1kN32NVHgis9Nssz/xuLx9O0
	0RI6uewwThmnIKGxDZOa42J66/gG3Y9Q=
X-Gm-Gg: ATEYQzwHu6EqAEd1kn4D2PPBEmQ+6msrl5hMVqQM63ap5zAFsCLJ0fTzPtkWCfsPElc
	KCijnO7XHW1YrTsr/7ONJbdn7LDgQoR1BqAfXrbWU3r+QOMBFCuYpYsyFjUlfF8C+DJR9mxOOq+
	yOBQVX4HITtR8UzCtRZFDAQZVZoVq5YpgRCl4FxTMEkuxkppsFYCyNO+DcTuYXKQvy9yVVrpvZw
	nZ9L0hOGDqxMr33OUWi6PaWQbYKWVpi7hFhZnkdQm65lE0g7i8avQsHE35W3ckhzO3QRnX/FWbD
	1A4eCIvB+v79wSpEMpsgWWQ0A2WlTY6R40lSNmCF
X-Received: by 2002:a17:907:7212:b0:b93:f24a:127 with SMTP id
 a640c23a62f3a-b980faab80fmr777557766b.24.1774196443245; Sun, 22 Mar 2026
 09:20:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-4-2c46f9eb0508@tencent.com> <CAJHvVcgi8m_O03+Grv7jPX8btaVvYuZxh8S6kLjALfREykToDw@mail.gmail.com>
In-Reply-To: <CAJHvVcgi8m_O03+Grv7jPX8btaVvYuZxh8S6kLjALfREykToDw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 23 Mar 2026 00:20:06 +0800
X-Gm-Features: AQROBzCY1d8LzbtA6PDy_QoFVLbyiDaxylUKUJZdCupD0T7-Ko53DGcklOhde4o
Message-ID: <CAMgjq7CjwdaQk66=61sNLR_21eaPZrFiai2foaTQNbZ3uxQmRw@mail.gmail.com>
Subject: Re: [PATCH 4/8] mm/mglru: scan and count the exact number of folios
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C97740009
X-Rspamd-Server: rspam08
X-Stat-Signature: xjqtm5fa4ujuy4mpd1owmmum3aczpbdq
X-HE-Tag: 1774196444-389679
X-HE-Meta: U2FsdGVkX1+wPGesSxJMEN6JyU1zig03l0qc2zrfejzf8wynMkksHPuCwuuUXPKwRH18Q1F/77gIomZdFsHGjeYB2lISuaRlC3dJasP1jDWVVjol5+fG4nBzFKQm/NPGDp40iFrGTNNF035e2j6tBAumfkvXCTxWSE4QXhG0ql+Ag7+trrd0u8XKhd3LmxMA632jkW+/V2ZuOs1RXULfx6T7LDDLEz00YjBqNjXBA+3T2+5aXnoBAIWlzLMV7UFhwC7imjtl+9EnJKAEdhZUpsH9zoIu4UfHE/enHslr2g4JCNsXdfnKltnU03QiyuQUW1IeF5wj2LFrPhu5YL7/T86Fvvw7vAN8hdZpZMlpiGm//de4/N4LCgdt1CJNlSTVZCkVvEig00l5Sq65MfzCeX4hHDNPjet7VD2kuMTnR+SV4fXDoE3njp35LGmQbLxxqC1DuvN+ucW5URMejS++GKeXSpDSwWl7Bh/XxFh5aNkG/NwxXNtbtVmmq7Z1tVkEoF531Z5vy4WJYnS06PJ2l5jZ0Xe1WlBQSodpfgVvTlSl81Brp+QbFiMtYNaRCAfHQGtjz5fx5sIa4L9oVmDya8+9HBslwPeM85H0oicQY5ZAYoDgrFGjfbzbzLgD4jSFE+1188mDjLCDDYphyWoL4BPVmz4Xlk1eEQmPD4w3wK8B+z2shTUCFrYgzHSQBk4eQqG3bsRDME79XDfufvVrFYP3WCtF/VbVG+Hq93L3H/gnWP2Ty5ddqAqLY1cT2fOM20ykb1NoZnrS0ECDtYnX1BPKvDtStDo2R0cUhsgKfUrDXJ8FlMAlfZtskp/20v9b2N0MDwEvu2QzT/A08SIsqsgl7ICSSJoID5zD9d+dbSUDvHKEXgxD/oB1uoCs3O/i3LTY53BZN6bOGz6N45Qh3eCVTDyDveK+cev1TvcqEFTL7HfPX3MMrIeWpF2EdufcNr9RjKjvxI6qyH5yPFr
 8+Rtm53K
 XnhE+lqSOzEk9aPJgrFOXxccBXARLq6DlEKJZpJhGWwoClJ2axKr/sXSqKyxL9zSrLlvfZeC+6QecW/XK5QQeZHBcTvtnUCEcfydpjD5kcDjpePLg4ciXV71lsn+bcNn+dkfs5awaf20caV1mmyq/xQ7PLFZ60gAwmeEC19M9eJDeFqQ/oOs30lhNZ6hlk3gaw7QKppBH++LhBL/Z4WMx/m6E4gmhQfh5ggCHmY2qpZ0GSkQO9GdHNdzOZZN34lVJD6XEFqWYl9kkPMhg2C7LOGsxYYSLL3lAotEpZFjaovpiM0RWkxvbYAW0S8szzlkGAEPDm5oT5WZ4OWtfYBIw+D47RHRKCmw5RludmrSfQW5/YVWOuNmq8eFQC+py3h5ZTnVGeuMNCVjAIVTkCrgX9zIwOWYkWzIx/pV6mLsmgxWsUsduOna13Ckei4aN4MjltddEjH6n+zhMfb2HjA0UFDBDinhBgyHBvzsm48pR8KWbZEoq12E1KeZvuQFdmSLdtrM+sMNc6hxmOvaIZBiyPFCTXIm6MUTGWtN+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 4:59=E2=80=AFAM Axel Rasmussen <axelrasmussen@googl=
e.com> wrote:
>
> On Tue, Mar 17, 2026 at 12:11=E2=80=AFPM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Make the scan helpers return the exact number of folios being scanned
> > or isolated. This should make the scan more accurate and easier to
> > follow.
> >
> > Now there is no more need for special handling when there is no
> > progress made. The old livelock prevention `(return isolated ||
> > !remaining ? scanned : 0)` is replaced by the natural scan budget
> > exhaustion in try_to_shrink_lruvec, and sort_folio moves ineligible
> > folios to newer generations.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/vmscan.c | 27 +++++++++++----------------
> >  1 file changed, 11 insertions(+), 16 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index ed5b5f8dd3c7..4f4548ff3a17 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4680,7 +4680,7 @@ static bool isolate_folio(struct lruvec *lruvec, =
struct folio *folio, struct sca
> >
> >  static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec=
,
> >                        struct scan_control *sc, int type, int tier,
> > -                      struct list_head *list)
> > +                      struct list_head *list, int *isolatedp)
> >  {
> >         int i;
> >         int gen;
> > @@ -4750,11 +4750,9 @@ static int scan_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
> >                                 type ? LRU_INACTIVE_FILE : LRU_INACTIVE=
_ANON);
> >         if (type =3D=3D LRU_GEN_FILE)
> >                 sc->nr.file_taken +=3D isolated;
> > -       /*
> > -        * There might not be eligible folios due to reclaim_idx. Check=
 the
> > -        * remaining to prevent livelock if it's not making progress.
> > -        */
> > -       return isolated || !remaining ? scanned : 0;
> > +
> > +       *isolatedp =3D isolated;
> > +       return scanned;
> >  }
> >
> >  static int get_tier_idx(struct lruvec *lruvec, int type)
> > @@ -4819,23 +4817,24 @@ static int isolate_folios(unsigned long nr_to_s=
can, struct lruvec *lruvec,
> >                           int *type_scanned, struct list_head *list)
> >  {
> >         int i;
> > +       int scanned =3D 0;
> > +       int isolated =3D 0;
> >         int type =3D get_type_to_scan(lruvec, swappiness);
> >
> >         for_each_evictable_type(i, swappiness) {
> > -               int scanned;
> >                 int tier =3D get_tier_idx(lruvec, type);
> >
> >                 *type_scanned =3D type;
>
> I think this is problematic, now `isolate_folios` can scan a nonzero
> amount of > 1 type of memory. Then the caller (`evict_folios`) calls
> `trace_mm_vmscan_lru_shrink_inactive` with the total scanned amount,
> with only the last type we scanned (misattributing part of the scan,
> potentially). Not a "functional" issue, but it could mean confusing
> data for anyone watching the tracepoint.

Thanks! Nice catch, I'll introduce another variable for the tracepoint
then it should be fine.

>
>
> >
> > -               scanned =3D scan_folios(nr_to_scan, lruvec, sc,
> > -                                     type, tier, list);
> > -               if (scanned)
> > +               scanned +=3D scan_folios(nr_to_scan, lruvec, sc,
> > +                                     type, tier, list, &isolated);
> > +               if (isolated)
> >                         return scanned;
> >
> >                 type =3D !type;
> >         }
> >
> > -       return 0;
> > +       return scanned;
> >  }
> >
> >  static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruve=
c,
> > @@ -4852,7 +4851,6 @@ static int evict_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
> >         struct reclaim_stat stat;
> >         struct lru_gen_mm_walk *walk;
> >         bool skip_retry =3D false;
> > -       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> >         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> >
> > @@ -4860,10 +4858,7 @@ static int evict_folios(unsigned long nr_to_scan=
, struct lruvec *lruvec,
> >
> >         scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness, =
&type, &list);
> >
> > -       scanned +=3D try_to_inc_min_seq(lruvec, swappiness);
> > -
> > -       if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GEN=
S > lrugen->max_seq)
> > -               scanned =3D 0;
> > +       try_to_inc_min_seq(lruvec, swappiness);
>
> IIUC, this change is what introduces the issue patch 6 is trying to
> resolve. Is it worth squashing patch 6 in to this one, so we don't
> have this non-ideal intermediate state?

Well it's not, patch 6 is fixing an existing problem, see the cover
letter about the OOM issue.

This part of changing is just cleanup the loop code. It looks really
strange to me that increasing min_seq is considered as scanning one
folio. Aborting the scan if there is only 2 gen kind of make sense but
this doesn't seems the right place. These strange parts to avoid
livelock can be dropped since we have an exact count of folios being
scanned now. I'll add more words in the commit message.

