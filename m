Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E89B460A2603
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DOIUurRY
Received: by kanga.kvack.org (Postfix)
	id BCC2C6B00EF; Thu, 12 Nov 2026 00:12:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B55C26B05B0; Thu, 12 Nov 2026 00:12:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1E3F6B05B1; Thu, 12 Nov 2026 00:12:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68E496B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:12:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46080A04D2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:12:11 +0000 (UTC)
X-FDA: 85425295662.01.383117B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 713F6C0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:12:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DOIUurRY;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794460329;
	b=IMHIQKMBrNrNw0BfmtQOimm8t2ldflk4fHhEqQm9i1QMR797c5LzkAG0cHFqqv0ViXLa3A
	RUEAoG9YkNdwpdF8kQpX+dhr+rnABv/NPrvG8HguMB4sWv0fO8uTN1Xml3gBtRooRyQftw
	NpaJNTygc+hypN1PMztOtlhbIJ9Sbvo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DOIUurRY;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794460329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udLw4xWZiN/RL0nJMpzRBuktpxg/7u9GaKiX9eOBGPg=;
	b=j+0hN63ZzvBHWTZUQKXT+IF/5kU7YUr2TC90enf0NVdXyMF2M7910CDoqe1u03OqNl5fk6
	pFWM04ZQR8r9QW8sV1SXrq0sAyeX0+3pY1k3rVgj7SHixK+ZGCD5zEWDoGc/N66X3k2C14
	bD/f4xlOLenm7QPthlrKrYtFF5y5r+M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D05636375E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAC91F00A10
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794460328;
	bh=udLw4xWZiN/RL0nJMpzRBuktpxg/7u9GaKiX9eOBGPg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DOIUurRYrYdoGHsUDKaM8EY4mr+oKpr9uiPgYohVoHZI6VeHzgRc9pyeG/xuAzbRF
	 2960g0JJaAWCSxahGkOlTs48VKfnXKUe2qkzGQZed/Fr7uvH8LRlzarpIJgBVSeujV
	 Rk4755u4D6hl1FXY8gde8HVmSFIzasjoSH1eGmfcVb0NbsAJ/R8ZNF0nkAJLOqZt/K
	 LYNbAkD2R75smDDkAu+4VKUBgADS0tDWEmFZCa9uE8ptuxTo6UtSC7kdYJMW/XRYUm
	 Osqrpvrmb9bcmXCex4F/D/O7AqZxVul9E2bQkv8YlEYi4yN7/jlVXt5CWsarOK2Q5J
	 arGqK1S++Tp3A==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-943e8d35f74so338240585a.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:12:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEaZ6b2oL0lM01jgzIO64kj0wSHIEGAqwMBePF3GxnWRm3msLAtgUPlt4P5+DHvgjHPhXqyZLrrLw==@kvack.org
X-Gm-Message-State: APuU4Z+Byd9l5I1XPGYFLZqm3lfMYsfrhuKuCMSNDN7AXNkUSX1VsPYJ
	HULfjdLtCQLqTQ64Beu3FSElEXdau3jEEUyxG5f98WdvbXq9QXDhEF3lxcWoqn/6wny6ZoR2J/o
	OBGpky2mTeFFpTHdiauWYaUCjKXLrMtA=
X-Received: by 2002:a05:620a:6ccd:b0:93f:6e05:22eb with SMTP id
 af79cd13be357-947b004790fmr805777285a.48.1794460327831; Wed, 11 Nov 2026
 21:12:07 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111232603.9934-1-baohua@kernel.org> <20261111232603.9934-3-baohua@kernel.org>
 <sashiko-outbox-210410@kernel.org>
In-Reply-To: <sashiko-outbox-210410@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 12 Nov 2026 13:11:56 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z8Xh-AeJScRY35yxu4Q2VA9RWc65hLOcR=qPf0Kg5T5w@mail.gmail.com>
X-Gm-Features: AclHuK-adsV3p3T53pKhzF58lye_dnBVy2PQxeZn1uz83gTILSeoRI6H6dSrch4
Message-ID: <CAGsJ_4z8Xh-AeJScRY35yxu4Q2VA9RWc65hLOcR=qPf0Kg5T5w@mail.gmail.com>
Subject: Re: [PATCH v7 02/16] mm/mglru: extract lruvec_populated_min_seq() helper
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
X-Stat-Signature: gztnt9sdqburu9t54obmif8u7o353z66
X-Rspamd-Queue-Id: 713F6C0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794460329-52134
X-HE-Meta: U2FsdGVkX19CbTcx1ZW7ysCD61vWOU19RWpfhyQ48xBgk2naYovw1xZJIxEVclTy7EuoJiVXH4xGdxkT3fB6trbzBATwlIyrYJqwvcu+Pj0mKJH0t0yN164e27lNyEB/WeV7tIU38nDm/wJRJXEMO/JmlJn5VIiVzJL6vSKE+fj5rKxLRqefx3qRTrgNZjdXOi5OvpEJx6vx2bU9g+8glMssWSAMcTgoX19w+qm/kBxz5UmBKmaIsUGso3OBBLTZB4vLFOjAmVWNPlpxNCUjK5tlau3JfvCc66HPm/h6f2hbwthwYSxvUUbQcyqBOYtE8Lv2gcLDmEe1gqTL3jRKDvCDt6VJcQ7gyfxbMZAfBnjlt5gCKZFHi0XlEUmhP1u5VsHaIeyF2DYgwDb8QfgYQ4T9lSLu2ZMHQrthDQaDEc38k1PaoMuZeDA65sSCFZUo2Cg5AXqkNmxv7Q4zPw7OqK+kxQAy0v0z41UCXyZVR1qMwgXs64gBdbKSpcyCod1lPRyaeFuss9pxH2mvEzFcVxHNu9TEsn1Rc1B6GRqU2//Uefi7hxXuOcZmyPvD1upZvsCXbeCIE/SXmxdHVsN6uBRbxyzdNnQoc8uP1UWHdX+7ICS6ydiaI2iw6qH4JK5iMJCMnFHoiUpzuW//21EG6OxlpliPXLjdiGnLCE+QOVQ3vNaSerkVbzgWbGb0u+Fmj9vYC2BR/dToHnNQJCRDSgq5tOpGQ8bNyB1k2KELmqqGDxOOoMLz4MvjcXFTFVQkaTeq2Z28+kLDhRhpKqTmu/B3eZSwpyvRLtYuS/RHXGeATzyCGuJXxio1//SC95PDVzBH/TdCWGo5DXu3Rba31+AwSTQ8R3hxzRCMvbPedgkAZjtA8r2rTzmzUSlPbW2p/3zlhYZsqhB3bSXxgb+c8uHVesYSsDqrABt9vIRFEWNTjEg3P5TxGJPw5RHeCe+A2JTC4NN1FH5LI+5hlTz
 hey9xnwK
 k2savPTuoaoiNCROvd/UvMJFi6UeCSH6SRkHhLDtzzIbEXlzaV0LQTbFuhV+0fLplaK/aJD53xroOGxCW3fpIKTZWj81Osld95bg8tPb+HAt88udIzyz9DILt9/NiOMChZuwPPWgPsGd57yACjmeKha6+yLFpWN5kmjD2wZpj0Yqrd6bhs5tEnRyFPHpG0I3yeCob26OgrvKJhEMCP4mCkafVQ25i0vA0iLbzeJGOTOzxi6BLyA4a+sU0gZh5mJfBcwiMfD7nwQUxdLwWH485TguLj69DDgHKRKbq9rJPR7nghhRUqql0U0UZ71RWRJ6kVT5JQBrSbP8Jzo7re8c6PemVg2ttf+YHtlXIuHI0Xt78mlxYyanOY2CRf3rCgUn4XoxOgut4+ihDPZXsAytDo+1qBCQdcS3B9gYzzSX3EqPpnAAESutG9b9mtRJi3NZqU7bNnWTqEvOuYdl9cBwgc11dtbJtYAbKOo1A+3x0Tpe0D/jAvnqhGxotSfac5NoCrt6o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 1:00=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] mm/mglru: shadowed local variable seq in try_to_inc_min_seq()
> --
>
> commit 7a4927e9f0aa8623b1c83f69afd1fb935c342dd5
> Author: Kairui Song <kasong@tencent.com>
>
> mm/mglru: extract lruvec_populated_min_seq() helper
>
> This commit extracts the search for the oldest populated generation of a
> type from try_to_inc_min_seq() into a new lruvec_populated_min_seq()
> helper.
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index ed224cb80a75a..f98cd483f014a 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
>
> [ ... ]
>
> >  static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
> >  {
> > -     int gen, type, zone;
> > +     int type;
> >       bool seq_inc_flag =3D false;
> >       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >       DEFINE_MIN_SEQ(lruvec);
> > +     unsigned long seq;
> >
> >       VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
> >
> > -     /* find the oldest populated generation */
> > +     /* Requires at least MIN_NR_GENS gens for basic functionality */
> > +     seq =3D lrugen->max_seq - MIN_NR_GENS;
> >       for_each_evictable_type(type, swappiness) {
> > -             while (min_seq[type] + MIN_NR_GENS <=3D lrugen->max_seq) =
{
> > -                     gen =3D lru_gen_from_seq(min_seq[type]);
> > -
> > -                     for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> > -                             if (!list_empty(&lrugen->folios[gen][type=
][zone]))
> > -                                     goto next;
> > -                     }
> > -
> > -                     min_seq[type]++;
> > +             min_seq[type] =3D lruvec_populated_min_seq(lruvec, type, =
seq + 1);
> > +             if (min_seq[type] > lrugen->min_seq[type])
> >                       seq_inc_flag =3D true;
> > -             }
> > -next:
> > -             ;
> >       }
>
> [Severity: Low]
> This isn't a bug, but adding seq at function scope causes the existing
> inner declaration in try_to_inc_min_seq() to shadow it and recompute the
> same value:
>
> mm/vmscan.c:try_to_inc_min_seq() {
>         ...
>         if (swappiness && swappiness <=3D MAX_SWAPPINESS) {
>                 unsigned long seq =3D lrugen->max_seq - MIN_NR_GENS;
>         ...
> }
>
> Dropping the inner declaration would avoid the -Wshadow warning under W=
=3D2
> and reuse the value already computed.

This makes sense to me, we can do:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9f759d213614..a640590f6be3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4033,8 +4033,6 @@ static void try_to_inc_min_seq(struct lruvec
*lruvec, int swappiness)

        /* see the comment on lru_gen_folio */
        if (swappiness && swappiness <=3D MAX_SWAPPINESS) {
-               unsigned long seq =3D lrugen->max_seq - MIN_NR_GENS;
-
                if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] < =
seq)
                        min_seq[LRU_GEN_ANON] =3D seq;
                else if (min_seq[LRU_GEN_FILE] > seq &&
min_seq[LRU_GEN_ANON] < seq)


>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.99=
34-1-baohua@kernel.org?part=3D2

