Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0747DFC72AF
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 08:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED96F6B0095; Sun, 22 Mar 2026 04:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A206B00A2; Sun, 22 Mar 2026 04:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78EE6B00A5; Sun, 22 Mar 2026 04:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C70156B0095
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 04:14:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18DFE14080B
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 08:14:46 +0000 (UTC)
X-FDA: 84572987772.05.EAA22F3
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2961A4000B
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 08:14:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mv54FG0a;
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774167284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jIppzh5IstjkHxWGHQotgkN4+HX02RcgUFDs/AAYNs=;
	b=ED7TzZLi5i7faCQJklJhcbAJ2Cy0a+7RPt+J2PEnuKUattzsbMjGEBhSguP985e6pkwpIf
	kjf6L5HIg5Tn8uGUc/fsvgeel++bdlkYNBD2ghwHPpV8DVngKpkcwtJdJSQKhCJWuElvB8
	3XBQIZ9oOljiBgcTj02/GPInSrTaMN0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mv54FG0a;
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774167284; a=rsa-sha256;
	cv=pass;
	b=GhalydX942ctuHG+tDVPnXayQyHLVaPY73zgZQdxb7gvUf8LhZgzS1wOttC/qXZVfWtErL
	Qo3qGGH4cS1HA1sXC2RP+idGd0aY0y7bb3JvVrYY8AgPwGKDfKG3xJvBw9P48JKni14vjy
	1cCMKKEWyvJv6htUZQu6Wx2oGRhrg+Q=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-89c6f61020cso36364356d6.0
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 01:14:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774167283; cv=none;
        d=google.com; s=arc-20240605;
        b=glIjD2XeFCTXaS/gs4Ik01jQV4WTw7CDafjSboRIAs4YcrJ3YrdMhw2wmXVaq/tkrP
         JSl9Z11va8kIRpo3OXc+UYbMYTPVRYe8QZ0wu7tHcBSzFKcJGn3bF+eVDAIQ8GOL8ZvA
         P3fdV0CtfgXRo5BE97c00DSGMqYLalvAmhmz7HHrI83SJVYSuJobAEtAfNQAzbjtM6L6
         Fc9jbtOJxxVzjpvUXa5xgvczmr2M1tJzxxzQ7tOYO8LWo9gMSBlqWFE8rmc7521RTzij
         5Z2Hxrty1UqPqmX9QBOU0m0wzY5GW/jk/YKjO71pIJZIQk4WpH6mpXapTWW2yGIu48cZ
         pvHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3jIppzh5IstjkHxWGHQotgkN4+HX02RcgUFDs/AAYNs=;
        fh=/JkQnwljR5A49aQg7Gv9c52PqVY75h6ML62R/ZWNr+I=;
        b=V5fRxBeYphq8Fhw1vF//CRdykaqrVmlg/p+3CXJWPxWOhbhJv4bd7r5P3GIUpu10GT
         eNMXw8uOx9jaHjf4nfMtmOjRSu8eHZfZt6mks+f1BmM+cbENwYpzrXG/gbkNK2nikXuU
         ZVzGdPlXTxuNXkOywJrPZnIYp/yuYFpZFWnc+GNOobdpWh+QaxW0W7TQ/JV/J7euTkVd
         SaT0l/Cw7rOHWWTlOtYeu2DwZiUPYDJcVaPDkHhcgCBuMtNyt4iKEAxLK5zZF6NhcLxc
         qzaxqfptCWCn2KdEsL/SmWUpsfXR2z7yxo5GB/w1hUr5Jep2xeLTBl2vS0R2oe6pBQq0
         HjmA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774167283; x=1774772083; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3jIppzh5IstjkHxWGHQotgkN4+HX02RcgUFDs/AAYNs=;
        b=Mv54FG0akIpa6YnNU7Y/IONFQ1iMn1RnF2tR0eMeAcKHYQCNUSVap3e8ftHKB1yUzo
         ZqHW7q0lNe1yfKE+W/LHQhqM01VXrk3+JtyCozr/Eli6ttTsKQ+uQ0pzyoQ58u1NlLl2
         Xn1EuVRICwOP8z7kEczv2ogorKKHmv/iYzyr/VDRqYeOi7cCbXq0aT5xvWGrtWGJ/78z
         dhKRm1CimJTAUgqBEkSOMN6zOeY+7tWiBPKxyo7MsMsWfhLJNJWFTpogOSj9t9x7U0ft
         laxROhCjlUICsHHbepH6cft3juKdNtL8ZIyG4p3GFGHuMb05az4fiDk0V3ZLtVftXgyj
         aq/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774167283; x=1774772083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3jIppzh5IstjkHxWGHQotgkN4+HX02RcgUFDs/AAYNs=;
        b=liNx+01+OFgHCgxlCHuIzrkywpp/+89zYeYNB82nAW8pI1ktl31N09u9vAO+P3SD/j
         Fz2nNY6cFupn/aOY/HgQQDmu+u72rUcfA8mspR5N9aH3KtbHxvYdi2KSX7C8+fyxCWlm
         Zk6VbPIFeYIb8MkIWVJN722O6ud4BipiGBheNf+tCnYZJc5DYADDjfg/wtW2omqRYjXp
         /fZsaJKc5N8gpyYuMXZcCaaKJRnaRhRJS/BhGO7Ln678r2P2/G3mU7MB7Zztm+KIYlR/
         /hTJ0kLu5hl/nuj18KG5V0dG3YZvZUG177JFxtt2Atp7gnkHkNyGo6JWv9t8/0x/3API
         XKlg==
X-Gm-Message-State: AOJu0Yxz2dFB8NbMPU2tJVBwehk2lFsU5KxLAyvPRpTF12JQ0gBt8tKr
	Ow5sLkT67tzGDZTyoRKEmT3Mw1Eo6H81r7h5/97eSVDiylX89cnXJx6ioDFHvzAOjs9s4Y/ddsw
	ImliViX/7GvC0g+l9SjiNs8Wd/folc1U=
X-Gm-Gg: ATEYQzwUExtz0ezb8Np2iOKoH/OXrC0sueE3Z4t35YtWlo5ZbLDLBIpfoJMgchhOZKT
	TEe+Kftw/I8tIz5NqSR0fdKD7RGZRfeDmI5U2FBjxvRmIChLMo3zqoJEGjXzralCazg7xdMoSrx
	2E1DBUo3/Zs6t5KMow/WpJxrLMxsycCWCHB3d5Ar6XlSMxZuU4RCa3klFv7pXosfF//mEOH4TSo
	P3XaFnrqfJ0jX3M6q3GmUdWBoRHJsvUHOh8Ibtji/UfBJKj+YV6Cg3haHw8hIe4ENZb+gOAmIZO
	k8+u4htWNQ==
X-Received: by 2002:a05:6214:cab:b0:89a:45c:bb65 with SMTP id
 6a1803df08f44-89c773e1b57mr201848356d6.12.1774167282916; Sun, 22 Mar 2026
 01:14:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com> <20260318-mglru-reclaim-v1-2-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-2-2c46f9eb0508@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 22 Mar 2026 16:14:31 +0800
X-Gm-Features: AaiRm52W3h9K_9g28RU7SAF8ADcJ3bkD8nwkibABaOCeRZy8igLmoNrn0VgCPyY
Message-ID: <CAGsJ_4wExxpA53XVb1qZ=dr4kh2Xow-wq1UFYxnCwUwF+S5xkQ@mail.gmail.com>
Subject: Re: [PATCH 2/8] mm/mglru: relocate the LRU scan batch limit to callers
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
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2961A4000B
X-Rspamd-Server: rspam08
X-Stat-Signature: nuhruur7d3ioe7gom5ip864sk3z1xdd3
X-HE-Tag: 1774167283-232618
X-HE-Meta: U2FsdGVkX1+PhWnoj0pv76p2510MA+YA7T9wJSScKeVA3t/iqNLazKJFEbQQnTgQg3nK8vNuO3GwshUi7+zSKPRbBJIjMOAl4pnwlkOag/0MaPa6HQ4Y7xZ5mEFtx4hjy77j/ykdx6OFusgAWSepBm+KFbGaWYCh9D+PyDjbm7s5Hsfc0OCHAGOlHqjEaqgNuEnna4B+0aUf7XkzCPFl7qszG1hMT0cQ3FfIm93cGDRMVtdDafYUm8P2O/6PHxdPSYO5fyVwanJfdzgnV23SsCzm+SAcG6irKCIoqmGXaUcy26/EXDURbceV62+3oEaPbyCv42r3cEY8VafjxlbdtKej06avzTXZInKKJ0BAxTgX1c5eEKXoxmofjxnDkos90x7A0gpjuhHKCqDepnWA7gKWHIN+3wetPZ9ZY+tYNJZubCnHoy+f+F8kXVh77Fq/Exqc2JoYN7gsIWyDogV3z/cuoEv8CleL4rrTRj+voTjN67p18rhJFNTcbS4A2tZv4CpX3VDfx44by28UH1mw0SW3efyY7vSMuNk9ZYPYEVp6bDQZnh7/FxXGAVdpv1z/LSeIUFDLO7HG5/xFfI39Sc2NHqtFPy8x5ZIUJAFJBgR/QeB/GTiVhNTr+lMcE9JD5AB1/0IU3Dj6lO0fLRWjyMSANvh+E/KiPYGFRhKyG3oaVVzlAUmSoSsg/3ukuCypDk337T8NGaBk+dF04UoXMfTtyCAQcqt+8bCFPK8zIRzSqBEtvRENV3MfoDFQKFIbJUGG1nj5LS43CBMsemvDYoSmfzA/dKgHrArkcO+4D0pkf6YEq4x6wx1zspEyzijDXr3stxBNkMsHUGMmODelG4g9TiZWLk5Yl2nBpDezidY2fOZC9z5Hs+tN5qvqq57X8/5WY5PC7fsI+Tq/EIIfdXwIWh0f01aOw5jzX6kO4dDbBC1X0N09SF5If8rHnqLFjzTIWL4IhHg5SWMSJuC
 UXk6864f
 Tmwtz2jQoTs+U8I/o4ZxnHyhJ7gBO2szgdZp9ehoeDATJ73gKekYXq7USCna1Qn4/FJoURJnyFolY/MdBjjeLQ2QgdxoeFlvcGUHmRaZw+mcuF3wE7wTFiL/LHO5rV6QkTs+ZgK7YfJcyCGqXn5KvESiaLbwUuhEyw8nJ1IaMPshIApj2agn6VmGhze7+7tVbLC4p4OJf+RZc433LBoAj5+KOTnHKYZVrX0yrFRhW/aDKqXo6Ms8RuZYunxTYXO68CPwb2RjjvZUiChY7bcyTCH9cvf94WoDGB5kzSx96fSL74Nb29h8hlx2zaDn45HreWCKgiihioQzpDpoA/S3QffkVICidIH0xUbMRs2FKGRKAgsFdkQqKSLrjA7sutPkcC82DOs/nOx5pS87s+hzAmqbQsc9xc5L8oDQE70Dg+3kYrwAXIGL5GHiOrxtMMfZy7ZvOVkTbN9nDbO8xs6ibWjbO86lRDOuG1k9s6E0SuBdA3Y68kn0PKQGrsoxM5qZMt8BVikxuu+Xfuso=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 3:11=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Same as active / inactive LRU, MGLRU isolates and scans folios in
> batches.  The batch split is done hidden deep in the helper, which
> makes the code harder to follow.  The helper's arguments are also
> confusing since callers usually request more folios than the batch
> size, so the helper almost never processes the full requested amount.
>
> Move the batch splitting into the top loop to make it cleaner, there
> should be no behavior change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d7fc7f1fe06d..d48074f9bd87 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4689,10 +4689,10 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>         int scanned =3D 0;
>         int isolated =3D 0;
>         int skipped =3D 0;
> -       int scan_batch =3D min(nr_to_scan, MAX_LRU_BATCH);
> -       int remaining =3D scan_batch;
> +       unsigned long remaining =3D nr_to_scan;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>
> +       VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>         VM_WARN_ON_ONCE(!list_empty(list));
>
>         if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS)
> @@ -4745,7 +4745,7 @@ static int scan_folios(unsigned long nr_to_scan, st=
ruct lruvec *lruvec,
>         mod_lruvec_state(lruvec, item, isolated);
>         mod_lruvec_state(lruvec, PGREFILL, sorted);
>         mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
> -       trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batc=
h,
> +       trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_sca=
n,
>                                 scanned, skipped, isolated,
>                                 type ? LRU_INACTIVE_FILE : LRU_INACTIVE_A=
NON);
>         if (type =3D=3D LRU_GEN_FILE)
> @@ -4827,7 +4827,8 @@ static int isolate_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
>
>                 *type_scanned =3D type;
>
> -               scanned =3D scan_folios(nr_to_scan, lruvec, sc, type, tie=
r, list);
> +               scanned =3D scan_folios(nr_to_scan, lruvec, sc,
> +                                     type, tier, list);

Do we need to change this?

>                 if (scanned)
>                         return scanned;
>
> @@ -4999,7 +5000,7 @@ static bool should_abort_scan(struct lruvec *lruvec=
, struct scan_control *sc)
>
>  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_cont=
rol *sc)
>  {
> -       long nr_to_scan;
> +       long nr_batch, nr_to_scan;
>         unsigned long scanned =3D 0;
>         int swappiness =3D get_swappiness(lruvec, sc);
>
> @@ -5010,7 +5011,8 @@ static bool try_to_shrink_lruvec(struct lruvec *lru=
vec, struct scan_control *sc)
>                 if (nr_to_scan <=3D 0)
>                         break;
>
> -               delta =3D evict_folios(nr_to_scan, lruvec, sc, swappiness=
);
> +               nr_batch =3D min(nr_to_scan, MAX_LRU_BATCH);

I wonder if we should modify get_nr_to_scan() to return
a maximum of MAX_LRU_BATCH=EF=BC=9F

> +               delta =3D evict_folios(nr_batch, lruvec, sc, swappiness);
>                 if (!delta)
>                         break;
>
> @@ -5615,6 +5617,7 @@ static int run_aging(struct lruvec *lruvec, unsigne=
d long seq,
>  static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct=
 scan_control *sc,
>                         int swappiness, unsigned long nr_to_reclaim)
>  {
> +       int nr_batch;
>         DEFINE_MAX_SEQ(lruvec);
>
>         if (seq + MIN_NR_GENS > max_seq)
> @@ -5631,8 +5634,8 @@ static int run_eviction(struct lruvec *lruvec, unsi=
gned long seq, struct scan_co
>                 if (sc->nr_reclaimed >=3D nr_to_reclaim)
>                         return 0;
>
> -               if (!evict_folios(nr_to_reclaim - sc->nr_reclaimed, lruve=
c, sc,
> -                                 swappiness))
> +               nr_batch =3D min(nr_to_reclaim - sc->nr_reclaimed, MAX_LR=
U_BATCH);

Looks good to me.

> +               if (!evict_folios(nr_batch, lruvec, sc, swappiness))
>                         return 0;
>
>                 cond_resched();
>
> --
> 2.53.0

Thanks
Barry

