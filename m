Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D47606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 18:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=d/nc68lp
Received: by kanga.kvack.org (Postfix)
	id 43C116B05B2; Sat, 24 Oct 2026 14:09:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EC106B05B3; Sat, 24 Oct 2026 14:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4C86B05B4; Sat, 24 Oct 2026 14:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFF246B05B2
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 14:09:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81A158034D
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 18:09:08 +0000 (UTC)
X-FDA: 85358306376.13.A8B510B
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7A3DC160006
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 18:09:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="d/nc68lp";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792865346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ERdyhAtVPKJZFC9C4hXaHC+3+7Xam6OVWXt0NVslvcg=;
	b=T6DDAIOELr1nvlhOQ2MiHyQ65iELzeSokT66FC1KDJQxVdcM8tlhZN8FTje0EnJoMgiysg
	N4VzajMVfJpjT2Vo5Z/wqN32y0XhagePhX3Ji+MLjX9apAZDF2E2z1WDeHKDM6FXqTURZD
	FEyD5lsAq5G7fXSTw4nmRZtUmgzLf18=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="d/nc68lp";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792865346;
	b=tQvQKut8SRbSD78yjuUBcDvL74aBBTNy0WawxDIemogNfEjr4iQeSnpHq3xNc5G2pVrFd1
	bFoRxDulfUNWXfDwlT/U+DCAoShg4mQHCt1X7PHftZxgXUFefwRAwvuIGoTJYmN8KUyAjP
	VAD78KJFcm7JRPtf//1rx6U+YhVMiLo=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2e8c710847so224202366b.0
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:09:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792865345; cv=none;
        d=google.com; s=arc-20260327;
        b=Zj9p/thMhuZ5YSL7ad4Vit/EWa19GITiwWT7dPsDjgLsHyJY1VnD80qOk17rR5G4Qb
         bT5F63hxwIIfVs+QzCvdT46glaOhNOnXMdwbPJG32PHQzvBe0Kt9xi7bIV89X5uigLoL
         HJm7pySqkBl5ujavv2Jdidd9vb1PFOeR/VekjpzK03+2bhlFV9d0bUGa4Qv59yF187jD
         IQK1oy1FXW85WL8TRF+88V82vwfFrhe4Dt51GtWghEBpWjnzIwTj5NQYpX/q9Nao6D8S
         P7DhhaAHcWXXG/MJIAtta7Eqa+2dR/KotwUlMN/gnVL5hxapTxhqJJ52jiVbiqtQ+m/q
         Vo2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ERdyhAtVPKJZFC9C4hXaHC+3+7Xam6OVWXt0NVslvcg=;
        fh=CECIkOMNCg5qZB4QZsCuHh7VZgffmDf6T81akS+IdVI=;
        b=OHCEph5+/W7z8ATgYC4u63SBImodzIVhnW9Ft7aTGujBYY6H3npeRIzuDn84u0m16i
         rH7QpG2yEtRGI9fl+cU930R3EUGDxM+oofl1K9z24Uj7clPd8qiO3vB8l7D6dxr6wUS/
         GQouOSkGQeoX8GJw0JftTKzMoyIy9aKkcdT/ZC8yEdN13OpAWr2UXv/IEfhhEpcevjlK
         /+NJx96oCP85i8hNzZWrxBQaIHkYVAN/e0TrwuQlPT5uqRfCJG/ZHAiTQAM2QrLlgnKw
         XV58BByffAYdPwg6gYfpTy9vrx6i3ZZc+eSvSrS2omJ1R1mjKfaNMoplBBrhQ+ZvChkB
         qe2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792865345; x=1793470145; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ERdyhAtVPKJZFC9C4hXaHC+3+7Xam6OVWXt0NVslvcg=;
        b=d/nc68lpG0jmcr5R/fepe/xpWvYwYB3SoqRZT2pkS/F1WLPeHrt3ufSsoqeg5zD7b4
         JNuJV4UGa90IJLIWRZGoOYDPCK2ckrOolZn3nDUmtvs8f6DKU7ifgDaZKIM6Um+6w0Ot
         Ev+gkT1+f2p/bFlR2dgMsQWmrMKabiF01EZ4lMeHvq3HFl9IlD+TUA56EhRUoVIf9Q8V
         WX/0un2Mblxp17ulaX3eeVa1ucY0oRkgvSH1p14e85XoiscIWdj7LzVFkBq10tbwgAF2
         6UtYEG6TcK9aEDMSrup3jU0uZCYFmZTUAknY6cGdtpk1c+YvGWvJn2dHrfVin63JfzZZ
         oLWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792865345; x=1793470145;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ERdyhAtVPKJZFC9C4hXaHC+3+7Xam6OVWXt0NVslvcg=;
        b=EpCGQAHxcQ2u86xd+5tpBOUR5dU9FT6KHRzrJMeNxNCpxNynUqDSmCNWf0ZISvmxza
         5sv37ZMmZWz6QNAJHOyTnDcNh24E6JqFWdhpyfrMs5r18Vl7mWiuxulzYdW0AVJEs70V
         hZhNg02HgMkj0R05RDP9lb5rJHkfELZ26XS60+7FFeKBtdVMBtiUG5Cyx8SUZeCDMstI
         PnfFaK3lLJEogRWqGbQ25RWQP0EToh1PUOoKsBCOTG7Wc7cqqK78mh0p3GKVEe1F2Px+
         cXLtzzBLeFHBk57nfFvIjkjCmpL5FVBOUtziHs3T35FT3wjThf1ylLcuOihZPEO1gVSm
         f3ZQ==
X-Forwarded-Encrypted: i=1; AKwUvBzJcwcRTdtOeFDEUMixkMj97nhrcUjGNKrmNmCxk7w0shlXiPvm8Ar8yMbm7SvdNUDcLBSNZMl6uQ==@kvack.org
X-Gm-Message-State: AFq9FYIcI/Dwdb8/vtvQYOdk4DRcPXW1XtDOuwJufHfnnrychcs9On0H
	ArNwavSubQ9yNsPh1zJTwkHQkkBseIpby4u8O8phwCXtS8tqjfCPFgCycjFAdi+qjP5tbdU5ULi
	S88I3qiYroc9Knj6JfyvHTArB3MZYwMk=
X-Gm-Gg: AYBFou2jRdQiUvlgMtsBndPHmaLmPp3fBQVwbB9RmNQneNAUGrTUk2gQ/QvOB3ypOd0
	b+SwBslN7PoF8IgyIBIeVQ16nbnrWOepIUKJXrSkrTr2Cov74Y1q8E3DkMH6xseQOfQUkVKd4mY
	k0LZE45pxq2MOpf4sS2qvZrGlpyZMV5br2+gyn/sq00AT7Lc39PSzAVroPhY4b55A7gEy/tAhYm
	8lKhTdglCpXyq6lhIg/iJ6IE63ZPQp+eI7hcRGe+X3MOXoFOpi1FEzaJGRHgcOwYwnK7Xqh2w76
	08cE65SxEunz6Qm65LmMVJYPPiS1LTeMbfqJg/QSSEQv1OMJU3cVkeok6xMTf3X5p6xOOP3fkzQ
	Puu8Sk03+/1t+9fSa/E/sPa+iXJw4OVDZhE9P9Sd0OwaEIt1XaWQKh1MwXQPuDrgEehg/yg==
X-Received: by 2002:a17:907:86a5:b0:c41:6149:cb43 with SMTP id
 a640c23a62f3a-c46bde099a6mr296933566b.18.1792865344596; Sat, 24 Oct 2026
 11:09:04 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022220203.91911-1-baohua@kernel.org> <20261022220203.91911-9-baohua@kernel.org>
 <sashiko-outbox-183274@kernel.org>
In-Reply-To: <sashiko-outbox-183274@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 25 Oct 2026 02:08:27 +0800
X-Gm-Features: AclHuK8eWzuWavI0MQObBpMsb7z-DtSxrWiDtHQlSG46lBLdU3C2a79kHtVHB8c
Message-ID: <CAMgjq7DjYS01BQAWnr=EdbhM1gbX+K+pXM6z04UEKg_NLU3CNw@mail.gmail.com>
Subject: Re: [RFC PATCH v5 08/14] mm/mglru: lift youngest gen protection for
 higher priority
To: sashiko-reviews@lists.linux.dev
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	hui.zhu@linux.dev, axelrasmussen@google.com, baolin.wang@linux.alibaba.com, 
	david@kernel.org, hannes@cmpxchg.org, ljs@kernel.org, mhocko@kernel.org, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, weixugc@google.com, 
	yuanchu@google.com, zhuhui@kylinos.cn, baoquan.he@linux.dev, 
	liuxiang.277@bytedance.com, wangzicheng@honor.com, lianux.mm@gmail.com, 
	liam@infradead.org, surenb@google.com, mhocko@suse.com, rppt@kernel.org, 
	zhangbo56@xiaomi.com, lyugaofei@xiaomi.com, ridong.chen@linux.dev, 
	kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7A3DC160006
X-Rspam-User: 
X-Stat-Signature: pgkf1mh77dr143ux5w9sgrf64ak1pnwc
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792865346-918559
X-HE-Meta: U2FsdGVkX1/LHjhoNt/HByXVNpfm7ubwRTycgVsd12w+0zNGUfjgIUHgTWJSGqU9MovxLvSso00GdA5NY8Bl3lMqyTJGmmSBbXjk9ZgRfT47PsqayVHcNJGgcYKIS9sDd9mULLYFrimzuFIcHC7jAat54neadaI3BBo4S7O58HKXgt2reYEsqfFNB/ic4nj+d0K3C7PieH1CgndB9ThPt4Bhpmkdhv1WsS5ZB4MA3qtgzSmt+yBIqba8z5L2VgYl0KJiljeYBuDr01+Ak7Pv7TzrHoW+xMLEJDkU3z1yLPF8ess6eVIwbQq6y0QvoGeqaamyHPpzb5IMYeuXojWzPGSqtDLfyVwOKIdLEf5/dkVV1wvfwcaExYUpm2S3rpCNGisDUrB6/wReQs50BueED2xMQjUFxvsXrLnMs2Qd/+D1C4yK+NFgVYznBi6A6odkOdNUmDlvRrQC0KD/grrgRzxymCyVwvVOzqROA+7wgF4xdiigXKe+AmLDh0RP4tyOFCI+Z7La8sODYu8gjQYbAZBcJ67m9Gm/NxUSs0FJLH9OxdhZn9Ge9AR3UZY7VjhD2+YfnT6yG9FtCKCKRj+rIrYsnXwX32wDC+PcrXwivenyqSzSxhkzwQcKQbLOwpWIGHfGuASZuu201mdYkZ+8b4UopuA7yCB/GsvEMB2A/Jzy8RWFBQh/Uk130cppVir6uGY9Ni3MuUGAYZT5as10CRhtr+2OCakK2dHl7giU2lYSo4iQRkzhTPcIBc+mdW7dR5d/hRNzRe8Lek+LxQE1gZbB1A6h/4ouxWZP86HPK5esqD9TeIkJdhsyyPpoivfylePdL6Da4bknMpUcCgKhLUij1iRYP3aqkTJd158VnosQ78eWpsD52XG9M7OE9dCILZfRN5ozqcevzJ1SCCXrJ3BJo3bLYes9rNqDeEBJr/KK1e9XdKth8coYaYwrSKiNm4/2JXlwdFHTKspikf0
 jd1dYzZy
 B5cpenBH8yROrCMl7aTnQUdLWPN0RS0vqBWndzAYJm1PNRa59rCzq8CnCDUBjbqUZr+WdPVRrAZnQ8LkTFGE4L8Njp6k+QT1zLC/7rQK1LvV0WFQwITE1nAPBortM0+JZAlTRIM4SIH8qlbdC1IyvwhljPjRxOpWJNwPlLxvtkV/pzF92HWbDmEDV4x2iR3g386BbilZxtaAFMKA6AKLR52tJ3LDS1cPHdjO8Yr42frCbbMCo1XmoxL5OlloGRjMsOF0tZbTMgg0J6VlLyPtegt7WQkyraYy/cwdcpCl0RCxXPhu7Ccu3U/qDCMq1yFdyWbg/9eMZcPjkc3M1PQiH2lTLahNysKafg1qs0Qc9C5Izt824TFX7wB9GOQ/uILHHNqVErQZvvIc4MIvRnuESTsRcsN2a6fDY6f5v1M6SGuAGbnFZddvqiFODz48l3o5bYBRM5rvqtkbDBoRDrljBauskEaljK11bTSz+lL81cHS9DpKcAFTz2U1M5a4Oayl40ZPtJQN76k1iwK+TKIEU1BGjIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 24, 2026 at 6:03=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] mm/mglru: scan_folios() scans expired gen < min_seq at DEF_PRI=
ORITY
> --
>
> commit 1329290ce5f86b7de9b77d6b22e4b265f16348ae
> Author: Kairui Song <kasong@tencent.com>
>
> mm/mglru: lift youngest gen protection for higher priority
>
> This commit adjusts scan_folios() in mm/vmscan.c to choose the target
> generation sequence number based on reclaim priority rather than using
> lrugen->min_seq[type] at default priority. It aims to protect younger
> generations at default priority while allowing higher-priority reclaim to
> scan newer generations step by step.
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index fed39b0422e01..d1e14001f9346 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4930,12 +4930,14 @@ static int scan_folios(unsigned long nr_to_scan=
, struct lruvec *lruvec,
> >       VM_WARN_ON_ONCE(!list_empty(list));
> >
> >       /*
> > -      * Respect the gen hotness distribution at low priority to avoid
> > -      * aging and scan cost, but prefer to satisfy the reclaimers requ=
est
> > -      * when under pressure to respect swappiness more and reduce IO c=
ost.
> > +      * Respect hotness at default priority, and only reach into the
> > +      * newest generation when under severe pressure, so hot folios ar=
e
> > +      * not evicted as soon as priority is raised.
> >        */
> >       if (sc->priority =3D=3D DEF_PRIORITY)
> > -             seq =3D lrugen->min_seq[type];
> > +             seq =3D lrugen->max_seq - MIN_NR_GENS;
> > +     else if (sc->priority > DEF_PRIORITY / 2)
> > +             seq =3D lrugen->max_seq - 1;
> >       else
> >               seq =3D lrugen->max_seq;
> >
>
> [Severity: Medium]
> Can this cause scan_folios() in mm/vmscan.c to scan an already-evicted
> generation when a type only has the minimum number of generations left?
>
> In try_to_shrink_lruvec() -> evict_folio_lists() -> evict_folios() ->
> scan_folios() at default priority, when get_nr_gens(lruvec, type) is at t=
he
> minimum (2 generations), lrugen->min_seq[type] is lrugen->max_seq - 1, wh=
ile
> scan_folios() sets seq to lrugen->max_seq - 2 and passes it as max_seq to
> lruvec_populated_min_seq():
>
> mm/vmscan.c:scan_folios() {
>         if (sc->priority =3D=3D DEF_PRIORITY)
>                 seq =3D lrugen->max_seq - MIN_NR_GENS;
>         ...
>         seq =3D lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + =
1, seq);
>         gen =3D lru_gen_from_seq(seq);
> }
>
> In lruvec_populated_min_seq(), because min_seq (lrugen->max_seq - 1) is
> greater than max_seq (lrugen->max_seq - 2), the while loop is skipped and
> max_seq is returned directly:
>
> mm/vmscan.c:lruvec_populated_min_seq() {
>         min_seq =3D READ_ONCE(lrugen->min_seq[type]);
>         while (min_seq <=3D max_seq) {
>                 gen =3D lru_gen_from_seq(min_seq);
>                 for (zone =3D 0; zone < zone_limit; zone++) {
>                         if (!list_empty(&lrugen->folios[gen][type][zone])=
)
>                                 return min_seq;
>                 }
>                 min_seq++;
>         }
>
>         return max_seq;
> }
>
> When scan_folios() previously scanned younger generations (lrugen->max_se=
q - 1
> or lrugen->max_seq) at elevated priority while get_nr_gens(lruvec, type) =
had
> fewer than the maximum number of generations, sort_folio() can move folio=
s
> with a stale folio_lru_gen() value (such as after __lru_gen_reparent_memc=
g()
> or when inc_min_seq() skipped draining old_gen) into that expired
> lrugen->folios[gen][type][zone] list:
>
> mm/vmscan.c:sort_folio() {
>         /* promoted, or moved due to reparenting. */
>         if (gen !=3D min_gen) {
>                 list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
>                 return true;
>         }
> }
>
> A subsequent default-priority call to scan_folios() will then visit that
> expired generation (< lrugen->min_seq[type]) and corrupt active/inactive =
size
> accounting.
>
> In addition, in lru_gen_seq_write() -> run_cmd() -> run_eviction(), debug=
fs
> eviction runs at default priority. If a user requests evicting up to
> lrugen->max_seq - 3 when four generations exist and one type has already
> emptied lrugen->max_seq - 3 while the other type still has min_seq at
> lrugen->max_seq - 3, wouldn't setting seq to lrugen->max_seq - 2 in
> scan_folios() evict folios from generation lrugen->max_seq - 2, exceeding=
 the
> requested seq bound?
>

Looks a false positive, though it is tricky. A folio on a generation
list is only ever promoted, and min_seq[type] is advanced only after
the old generation has been drained by inc_min_seq() or verified empty
by try_to_inc_min_seq(). So when a type is down to MIN_NR_GENS, the
max_seq - MIN_NR_GENS target is empty, not a populated expired
generation. Lazy folio flags and the non evictable skip can create
temporary skew, and reparenting can look odd across generations, but
that skew is transient and cannot survive until a DEF_PRIORITY scan
targets that generation. sort_folio() also refuses to promote from the
last live generation.

For the debugfs case, lruvec_populated_min_seq() starts from
min_seq[type], so the type with min_seq =3D=3D max_seq - 3 scans max_seq -
3 while that generation is populated. The type already at max_seq - 2
was scanned at max_seq - 2 before this patch too. Not enforcing the
requested seq per type is a separate pre-existing debugfs issue, not
caused by this change.

