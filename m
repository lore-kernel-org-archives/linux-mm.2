Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5A97C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 10:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972ED6B07BC; Sat, 15 Aug 2026 06:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923FF6B07BD; Sat, 15 Aug 2026 06:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8128F6B07BE; Sat, 15 Aug 2026 06:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD4D6B07BC
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:36:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0B07C0335
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:36:56 +0000 (UTC)
X-FDA: 85103150832.14.14D5A5E
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id 06E8640005
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:36:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dczcg45g;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786790215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vnZiTFKSAoocFhTo8McUVPhAmeid+C6lDN1zJfSeDFc=;
	b=k2MM8y3r+jtT2KCXluHfuyUIRS+Mh9CUL/0ZuuOC5q639ukGujGiSCj9lfeKdwWI9yBQg3
	wRKhAaVVr78EpplMu1chfz4kzHJRi9+wNP7KGy2vxYn4w/CtbVrPK4iJgllk42kna9Gs94
	ObJ2BfDBRDsWRyU0iv7p8bFpjubSTR8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dczcg45g;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786790215;
	b=gLdx5b1+sq9nCEu6VcrpErieX5QB+Y7vqj+iuqkSKUzG9EiwAkp8AkQeuKvW19jO3iptDM
	QA22ynGpRiO0wXnLNzHNUVCZnSK3efkMIgIe1N6cijh0gIOzEuT2B69dTTwcDeqze/qdRf
	49e78WDGsu4eu0K9UdlN+/XUhNOeMJw=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-69fc9f25118so1805569a12.2
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 03:36:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786790213; cv=none;
        d=google.com; s=arc-20260327;
        b=jEzz8XVWLIp/iyGt3+UT5uKhh8TMqAEmc/wDmh52a7FADihylL/wOlqBfJWrEf6Lhi
         Y7TTltSj5j0oC7qVO9lzCR5+Or5HHAPiJnfeTUcthNtTBSVXUXDmcJY5g6Ff3u8OZC/Y
         uRzmg2baO+1rkakMM8qw5pLBwFSfsDdaEBfe4mX+VLoNTV1Uk0pOsQZ6Xvxc/WZ2q7jV
         M/dzeXYMd4YQle0JIAHyaxPJP3mjOexm5FfudUQFStuO/oKIyZRHz53HWqQOLfUij/dU
         5a+td3Elbp49UFRFSeIi4DXTDQpxJFGSGcpJgy7kP/F98166ZVZASJyJaH/dQS2FkeZ6
         +DUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vnZiTFKSAoocFhTo8McUVPhAmeid+C6lDN1zJfSeDFc=;
        fh=iR4cXIiEYCdF3LD5LDxAS+1EYwBkFML5wOTgOEO0CUw=;
        b=r/Se/PISSG3Ay+32jxoc9Ol8y1pxYB8aVjWO7Gj5W2QRmKyfuSpxOMix5gF90QJcw9
         NMLYVVm8wry7TtooYfGFDovbe7fHajonAAnZV/Ev/8Pgv1PwafJrXoDky55qjIVG6nNA
         TQWxnJ71mgpYBjEwj4fc8vqpks/fBPENWycdQcm4cC1LAG47cIx/+PXccVQyEV/w0rMG
         2QxFxXmOb0ci4JGxO36ejoruztLnZ757gbpolXfR1qRaVRgxXmsmPQUmInZ+kTtxpcYG
         SD7mghg0rRxiwHGiUNbNCnZ9lDgBLW9LZ9wYgbu2gkTvr+twHwtTj0IcAZGA5CGYSifK
         rbYA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786790213; x=1787395013; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vnZiTFKSAoocFhTo8McUVPhAmeid+C6lDN1zJfSeDFc=;
        b=dczcg45gx76vpaR2XXFDTr4e0PZJZk3hGyynzYPn3Nd92DjOUoiGhin25T5/N/FATw
         Sgo7xpN0ajzMR+Ob/CBL2NWDrIVS6F41pwuclicVyhJthNSNMcvhhszyvOdUQJ7B6hu5
         GZUqCiLi9C0WflKnbcAZKgQM2TBhrc6p9nDPlKNTkcDDWKY00CdME+/jr1/1XiMB/uLJ
         6/U9UijEdezAN7Qu40wNqmckIIJViy5eGtBUU/HdhaILt6UHeGPhasypT6FrTi8Wttdu
         gWseNNkl9q3a3xUbG24FKCJbbnUAqa1m8YAdHqrYgd5nTZEhT35DxD5cgd6HjPL1Pl0w
         oKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786790213; x=1787395013;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vnZiTFKSAoocFhTo8McUVPhAmeid+C6lDN1zJfSeDFc=;
        b=ME57sXSUouv/IxwpyijvS5snu/V6uKjszH1ktD/iKf7EX+tedfeVAtHcezF6fbWTpY
         eVOJTWqbnbuDbCJF0ZnPcPUP6msVgx91MEPzGblvtSW+L+kVM9cY5PosiORjoc4QB4jO
         Z76bKlCNUkk76rnZZGrjnp0td73fAHV4d5Lmw4UIWAFSka9554v7I0/1mRYKjaGNqwVp
         nH735hv2vEzgfmZ7qTsYPRm1mUeX1euph/dL4/qCnEf52k3dIA5EOxBkrna4CLPfYiJO
         nZGzuZK8XxVTY0dtqubDQo4z3TzB6UJAWlWg9aqBSXXG8YVS4RAei58rMLbowSmICQn/
         VoNA==
X-Gm-Message-State: AOJu0YxNH3zO3qTAwMrmKoyRJOXA9Dl7BITDQXrCrha64BllvGqcbFkR
	xV/q3jeXYBjc0xjv7OEoyf1tIabo6k1zMCZSWxKKm4E+Z2BGT7t/NsfdwYl7meMe+ec8SFob0+W
	8d3EafGV9XK13SQnhgdUdWFS3c+5QK20=
X-Gm-Gg: AR+sD122qpu5My8qHVsYpGGOh4H9apK4XKXzQdKgqsHjVpGgWzRCqiPVGqJloXGq5Np
	HjcKHKj0U/S7WANco0MFizQY/znEHU/jm6anJBPgNRt6ThuPnHu7zbNezI7F/dHy+rJZfh44jlq
	V52X/LspyfuQH3aLfq72i+IUS7ZxG7JKt/7FOTMeNQIgRnqOi/k60XsT7vlBZ/5pmqVVk7At5dm
	C+VFn7OmxSCgchYJiHNgd6p9u8NQWWbKH9jZ0ax8c/Wo6FNEkkpKYFd8+t6BIX+vdv2FB/CEXh7
	vm6dQmVBQa++1np/w5T9DsDegl5fXhx/ifHoU4XNafNdjbz/w7npl663ppIR9qypPlIr1+obG08
	g/w==
X-Received: by 2002:a17:906:ee8d:b0:c21:792:8257 with SMTP id
 a640c23a62f3a-c212a1d6bd0mr501209266b.15.1786790213101; Sat, 15 Aug 2026
 03:36:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-6-4d8dad39dad6@tencent.com> <CAGsJ_4yBJVpHO09HNP7cRyt4NH0AX77Sz0W4ppdQcc9fY1bAZw@mail.gmail.com>
In-Reply-To: <CAGsJ_4yBJVpHO09HNP7cRyt4NH0AX77Sz0W4ppdQcc9fY1bAZw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 15 Aug 2026 18:36:16 +0800
X-Gm-Features: AcwNN1XEDc-Qh3T6u4zhkGsXahR_kqoZIfVrMMEdKsYYSFr5PwD4n2Kn-yhytdE
Message-ID: <CAMgjq7Bg9wHC0MS8DGNzU7WFxHd2Lz5OrerUh=TLYYbiUppiQA@mail.gmail.com>
Subject: Re: [PATCH RFC 06/15] mm/mglru: use explicit tier range in read_ctrl_pos()
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 06E8640005
X-Stat-Signature: z3jhf6ofw4prxewz3fbx3yk9fh4654gu
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786790214-516529
X-HE-Meta: U2FsdGVkX1/oVP63dQFp7tWpHDEXBo0iQZRed9wDYrxiCCTqietejffN0yZA5BteW45MOsHLAotsF+EgNl4bFL7i17HyHFtmyz1HR6QskM8giGG+4Slzu8lhifgMsX91it2TODpWmkat0PQ25lhRcxZ8DS7EH3+J/mml6jlXjn5tX7ymMMpPrCpPC68lUI6TVU+6uXGsvhq62k6ZTXn2AMoaqgOKMrzxuuzRPtPZgyfp/1R+zG2EWIbNMC7c16isrT+kk8aOeMzvhwYSaGiQrybLx3KtpHs2kYesQlOcGycF/izsfT3IazDe6xYDIQGbOnaMbiNxB0eJI14ZoRO++CTc7x28kfY3wvi6x0s1seMf9mtIXfhjejTY/Pv1Xl++7DL0lRxZ17eBwh+pnxoP0uLBcPh+kv+j+4FH1iww+2Y1+ZpA6w0QvY/LsA76s5Vv215cJu+Imp/7scdbrBYvU+v1O9pNbccMWfxyRnU4PO3QAlgW8Z0XawRazXEnofFsZOyl+6M2/MNuM3hlc/XNVApzr1QLeYp2w56rdsgQ+7T8kAC4Mx5C9nghdTTKTTdBWh/kpApnJcJOy4H/rH0Gf9429tdSl+SuLrJ32SEcmn/61y14D6OeZte3zN9YqnZ2Y2uxU/X3Se/rQppkX4LX54NlKlXao63f02SBy3dJ+QUv4pBenlDVzpRJHJ4E+3Dx8PlubhnI/fHzV9jjkNZmWaHeqn2pwtUoc+olCgFXk25D0c1ZyioK/qWnQUMAiC2IlGIU40sxHz4tIuKmnPlWB4uEOIajqV0wlYs+KB+Qxl8qNJckiUlObpkOaoytnjYTra76FvfF8dyz3SuPbSHGl0SczAOZWDgEfZUnMwbFumm21Zu+Rr9t5KVESt6GqdeOk6mI7thRB3iCuEyw2/mtWsplHTFB4B+laN5KuKO3YB6HfzWauh4KYXm8dZYepU/UVPp0N9pKERfvaOUe/mY
 t3wOTIzf
 dpHNm/OqmJ86jOR2qnVOIARKbi5jX3oseDY8MWLs+G+zjDGbYamdacm41f7TYCB442vfIe6i1EXmifkGsRAjIKy8FHRtW10Wne4hhG2x5GbkqvRRDPkZbPCfK2UUYksYauZ88MvxRP3v7GFTve/SHIMbOrxvi+HDlpyMepXwYB5Ghw/oJ6CeXvNR/w5glas/MjEm077NEeo5AeZADrR3H93fFH2eEyc4aTvfYtMNjFJKOWDfn+1ImtQBxKQZH6VRfPza2r3W19jaaiqLiimttvBONm1Noqwmc+7nyNflneg6JVPd6vecibKfFe4wgh0ntFlXAiAbo8Yqu3WKBQ+Gw1bPKv7MuQ8mFUX0OJ9br6VXX2lZKM13sycA4FdmNd9Mig7lMztB5jKOTzGRDz1RD40vT37msgdUBn2z5p82duznxxnphXotrD1Ey5q7ubQfegFocHTQmfmGJCXA26Q0mH2FyHdV5aV34Y7LGXCdMgL6mV8pRWFf6vOlJQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 1:25=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Tue, Aug 4, 2026 at 3:47=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > read_ctrl_pos() encodes the tier range in a single "tier" parameter
> > via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
> > as the end.  This is hard to follow or maintain or extend. Tier
> > values 0..3 select a single tier, while tier =3D=3D MAX_NR_TIERS select=
s
> > the full range.
> >
> > Replace it with explicit (tier_min, tier_max) parameters using a
> > half-open [tier_min, tier_max) interval, which is the conventional C
> > idiom.  The call sites become self-documenting:
> >
> >   - get_tier_idx:   (0, 1) for tier 0, (tier, tier+1) for each tier
> >   - get_type_to_scan: (0, MAX_NR_TIERS) for the full range
>
> I agree, this is a nice cleanup. The existing code is really hard to
> read. The magic is in i =3D tier % MAX_NR_TIERS, but I've been bitten
> by this magic a couple of times.
>
> But could we make the range inclusive? Right now, it still feels a bit
> difficult to follow.
>
> Since tier_min and tier_max are tier indices rather than a typical
> array range, would an inclusive [tier_min, tier_max] range be easier
> to read here? In particular, tier, tier + 1 at the call sites still
> requires the reader to know that tier_max is exclusive.
>
> >
> > No functional change.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/vmscan.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index c2ea92c2b69e..a359d5a1ff41 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3192,8 +3192,8 @@ struct ctrl_pos {
> >         int gain;
> >  };
> >
> > -static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, i=
nt gain,
> > -                         struct ctrl_pos *pos)
> > +static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_mi=
n,
> > +                         int tier_max, int gain, struct ctrl_pos *pos)
> >  {
> >         int i;
> >         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > @@ -3202,7 +3202,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, =
int type, int tier, int gain,
> >         pos->gain =3D gain;
> >         pos->refaulted =3D pos->total =3D 0;
> >
> > -       for (i =3D tier % MAX_NR_TIERS; i <=3D min(tier, MAX_NR_TIERS -=
 1); i++) {
> > +       for (i =3D tier_min; i < tier_max; i++) {
> >                 pos->refaulted +=3D lrugen->avg_refaulted[type][i] +
> >                                   atomic_long_read(&lrugen->refaulted[h=
ist][type][i]);
> >                 pos->total +=3D lrugen->avg_total[type][i] +
> > @@ -4805,9 +4805,9 @@ static int get_tier_idx(struct lruvec *lruvec, in=
t type)
> >          * This value is chosen because any other tier would have at le=
ast twice
> >          * as many refaults as the first tier.
> >          */
> > -       read_ctrl_pos(lruvec, type, 0, 2, &sp);
> > +       read_ctrl_pos(lruvec, type, 0, 1, 2, &sp);
>
> It's still a bit of a headache when three integers are put together.
> Could we somehow make the 0 more self-explanatory, such as using
> TIER_MIN or a named constant?
>
> >         for (tier =3D 1; tier < MAX_NR_TIERS; tier++) {
> > -               read_ctrl_pos(lruvec, type, tier, 3, &pv);
> > +               read_ctrl_pos(lruvec, type, tier, tier + 1, 3, &pv);
> >                 if (!positive_ctrl_err(&sp, &pv))
> >                         break;
> >         }
> > @@ -4828,8 +4828,8 @@ static int get_type_to_scan(struct lruvec *lruvec=
, int swappiness)
> >          * Compare the sum of all tiers of anon with that of file to de=
termine
> >          * which type to scan.
> >          */
> > -       read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &=
sp);
> > -       read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINES=
S - swappiness, &pv);
> > +       read_ctrl_pos(lruvec, LRU_GEN_ANON, 0, MAX_NR_TIERS, swappiness=
, &sp);
> > +       read_ctrl_pos(lruvec, LRU_GEN_FILE, 0, MAX_NR_TIERS, MAX_SWAPPI=
NESS - swappiness, &pv);
> >
>
> Maybe we could introduce macros such as TIER_MIN and TIER_MAX to
> make the intent clearer?
>
> #define TIER_MIN 0
> #define TIER_MAX (MAX_NR_TIERS - 1)
>
> Best Regards
> Barry

Sounds good to me. Thanks for the review!

