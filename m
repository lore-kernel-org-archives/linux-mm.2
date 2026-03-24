Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17690F532EC
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5DE6B0092; Tue, 24 Mar 2026 04:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BD256B0095; Tue, 24 Mar 2026 04:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3296B0096; Tue, 24 Mar 2026 04:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0C36B0092
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:06:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1CE213CC3A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:06:21 +0000 (UTC)
X-FDA: 84580224162.05.2EFFCD7
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id C99BB80003
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:06:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cnsGYbNU;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cnsGYbNU;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774339579; a=rsa-sha256;
	cv=pass;
	b=jHS0mo17kL85F1Vf0ABXfpBCxv58zHe+9ftQox35/DKUIE6+MSPVMBwbI+a2yUKWIpMxJ7
	4Gs551Y6ePmhsuZxRnXq0l5gkEBITmySxdBjLkrkT9toAEyoE17SbzrAju3ypFpiipLyby
	X7FXv6ROKHaAWngTTF3M8mmDyFizrqI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774339579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGHYqtwWpNoCe45E2GKfU+FkoX+p9Z6lhHttAf4NvOY=;
	b=ToSMXMOoGlfbiCW0ML4SjFqcRPKUXuSmNCKZi2/gGF5wmo917rw3zZHAyerFeZ92OCS1oI
	cj2IKOhh+kFCwKJxV3kvc0be0APyisojpNCmijqg8sdNPfRbeUFA+gODFxWotfBdyu1JU8
	/9PjqB+RU8kgK+uJqWiKRHUicQitxmM=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b941762394aso646079266b.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:06:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774339578; cv=none;
        d=google.com; s=arc-20240605;
        b=CdMziJWphPyVUN7ZpaElLI2DGd1UD2Co+3n9pNsqqVp7HF90D7dgIzSkVCFM20UszP
         FkRK5BubiI89VdEf6PWwJEp/KmpkdsyDyR6CTs6OtocZVTfcZ+5jaWOG2AaV80COluh8
         /vYjT/+jQm3ao0h8komsova1tT5bOQKRSJsenj1vKk3lEPTHIK0UGLKudpmKU38OT87c
         dHc71YHxZiawWZdXHFSB5c9ZPnWsl5X/o7TOJFkMwVRshLN/YayVgErt6//pC98zJMZJ
         qgyCLXRTrTgnZfNdjXV2ITrYp+imw52V13Z03yBp4GiJPsAflbHPttPfDg7t8I5GXaic
         LR/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AGHYqtwWpNoCe45E2GKfU+FkoX+p9Z6lhHttAf4NvOY=;
        fh=jALXmptdVv4jJHtv8u1HVP5abfxtP19pwxAFqOD1aBM=;
        b=kttiRJI0JzrsnPDQL9rI6foRVwnCZuw80uK54uqdYGd/EYnXaiTAfeEgpJlDgvapnf
         sUkiJzIWoOyJAzgjXgdo7Vs/v7+ziUY0cimSTHmZojKBGvQaTWdX740PpRvXwjABkt5s
         ntwoyMrqefsry8Nml4TGO5iWUBwqbqrkokPzKfnELZtubL1dmEX/R7neKwAPDJrQHrFJ
         MHI0JLS1VrK0UZ0jrioq43rBnurFB0lOhwGZ0t/2Ko5D3TVbWBWZ1+QnlPEKcA3ew/NK
         ZaBcO0Sy4e1UsiKzG39J8DRcwvCnxuRunvfQrPOslydNWTYcRlj+m213cSqGIJ39dDgk
         ruxQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774339578; x=1774944378; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AGHYqtwWpNoCe45E2GKfU+FkoX+p9Z6lhHttAf4NvOY=;
        b=cnsGYbNU5RMUhrpsEdFjcJ/4k12PVvvn1UbBG6IaNd0+XyJ6Rk48gjTBdxgflHfutV
         davxNm0BUK+N4P7nVR+hOZCLJGl7u6WllTcPkrfyas1xPvAhgLPkMiDwi/3LOcXoKRUW
         sTq1NioRExMrqiCTNbllhOSleWd621QzrSa7f8b2xy6vrXmW2XJKFKryMpLlXYVS5qfy
         zL7+niDWqk5QgNYJQMJ0g1Akrt2Opcj8YpQjVPP01dqaahGWgzuA6cvJyfOgWvVHS3Kc
         CCbfjjowdU4b+5TgKIUM7Xvdijou8sSwDxk6RcRfaU8Dtit0FAYr535DbDW8eY2TxP6w
         nISg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774339578; x=1774944378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AGHYqtwWpNoCe45E2GKfU+FkoX+p9Z6lhHttAf4NvOY=;
        b=VnIi28OKVm3o+/F4qQFdJ+jbvG0liYkRdpqztHYEM8CH6kOgU970rLYJrJxSwSAv+w
         tdUgGKt6kaWUY/V71Yw9smSOPqVdWVPC4NReXzXi10Q9KFgWFmOqUoId6f8RvB5CT44M
         KhuUznNwMz5zq6g2ExTmKo75YeI/t1IkLXnXM+GFzb07QjLPbTcN2AUPmz+DBWgbmE+d
         yEIGFnK8P3d8GnlyWe0TaMw7qpfT/S4tX+oi91H7vDMAHOGh/U/sZVfYNT/A/2AvpKwa
         hGsp8VfrNe0uiZYBPJVH/O78V9+BPL+w7jbacWLHCUob0wUlZYdzALuY4wUDTM9Rq6Bu
         zPQg==
X-Forwarded-Encrypted: i=1; AJvYcCVHjm49W4OJkgdEFU9jvaEZuUws4QtLq6aLIKd7mXN+Bo5IWwUVTtrFhFoLhyovPkMtEpSz4xChCQ==@kvack.org
X-Gm-Message-State: AOJu0YwXydVmO4dgU6hSs7yt1Fp15lvMHUnParT6SJkbJuqZk2JmmhEv
	CGL38ZiOmzzVkVe9L8SM4Go/TK9BSxD7J+mvrdQXJDNab02Le19uosPOni87flyVST3BJQSzj87
	MNM6A/KlCYbkPJESOekgrOohBsRwaEkk=
X-Gm-Gg: ATEYQzwrld4LDe6CrDYnIgqCtwwXGxzJbcYsvXEyx095A/PmQdt0QIEYpVz7M+o2J7K
	eodWSaTGJmv8EflGoPB0LWZ8jyAYLSTkeORJSiYkr6/zlyYipExQ2DgAFg6P/+Mw3AnyBMda6Tu
	OBfwCDzvBLzuzbb0m4sG/Db37g4OTEi4giwtFOZ2XN+yLczZb4KADGIorYdxFPPLXDgj9w+S7et
	WmREbm34Ry2vXQi1BXhqEAluSigo+XqbA6nvkbkEvEzEnmGOF7Kv3IuaKs9KAYT5e3W4vgn2qDx
	hgIeFznoKhhHgC6jwjAkf8xDgtLXW5nYZ4oOCJB1
X-Received: by 2002:a17:906:27d7:b0:b97:7b94:a47d with SMTP id
 a640c23a62f3a-b982f39968bmr827848066b.50.1774339577687; Tue, 24 Mar 2026
 01:06:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-4-2c46f9eb0508@tencent.com> <CAJHvVcgi8m_O03+Grv7jPX8btaVvYuZxh8S6kLjALfREykToDw@mail.gmail.com>
 <CAMgjq7CjwdaQk66=61sNLR_21eaPZrFiai2foaTQNbZ3uxQmRw@mail.gmail.com> <0427249d-c6c7-477a-aeff-e007198fcf45@huaweicloud.com>
In-Reply-To: <0427249d-c6c7-477a-aeff-e007198fcf45@huaweicloud.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 24 Mar 2026 16:05:41 +0800
X-Gm-Features: AQROBzAf5m8U4Bq5ZXZYskw541sdgh9Tc33l-kZNnHKHariQPHGx9z0hGIT_iio
Message-ID: <CAMgjq7CGhMsf4qWrW5O-s2AP7BwpbpPahEFkd-u3Q9jGFGCeZQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] mm/mglru: scan and count the exact number of folios
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C99BB80003
X-Stat-Signature: fyfsqhuq189ujdexkbppc8eayk8kp4eq
X-Rspam-User: 
X-HE-Tag: 1774339579-666070
X-HE-Meta: U2FsdGVkX195AnZryQ5CyLmCfSDfTMQfg7QqSDdNYLaDWEk82rSJLuRR9bk37U0T/Yb2bNKY+mwzKxQtXB0ZqMi4iVpcLlul0Im2ozF7xenXiZZ6gMR4VJX4tNcwv2QmZ9jDVj6FAyI4Tv2EO21fv8F+4sIVijw33Cq14XKh94I7nPBFeqsQH4vE8no4FtGdVjLWzui1vJQypDd1KFjRDW5faGXKwf9sn1SFe1IlAv4usLENvtNSHbW57SdMQTcBuFQMymsn12IEvZOny8LLjFGzs7VTO1+tSwwnge7hRD/kKS5SJNYkRLjOhDulI4mTkbk5yBDLkEtI4QzXYdXBXQONBkq4lgWl66TxldpA2Q4pJu0+d+S+ZKhbl5+EbZxQqydBXtBSzQHdrH8tUz/2Z+icfIlbL66LhfhdM5+sh6et97vF52r8KGBW5IPE77JZN9s/Jv+hYAYnM9qtUx6qKSL+KyV4i8QXGbruX/ljeDlwDSnCID5+ur4rYA7wCZYET+okrNh89J1gbdgnZL7793TKGNQJZ/AqMhQpS9S0fZy/4ClINKYKZ9HzGeDmlVnsLyTJsyKvrFC4pFgbwcGIfy79+UBgVdkrJi90QLgq8gH4Q/QQ71acDgQx26Ze6BKeQnuGZGYy1PuH2EmuvMOujV1CrueW4i0uvEMVWXvvLiP1KlcD63TxxA0ozyL2Zf5rIPsg++NrSnZv8uVqFNtrpaOzU+k6Xs2aLJk09OiG2TsuGDjX8x9iiVuAJK+2yujNYEap6ZfqIDCNJ720pgUL/1ewgYpP8HWsLqGwtwQ9+M+hJpdDhjhFl8VyhcgjYP9WM48EdG3IfnRWwsQqPEOt6HEnByoRh8f1pSeFdfw9Kkpif4cwoT2dNX4SmNLybIkwQpHoYEuz16r5f3u2nu4/lQ0aN1iUv6jU69r6kRXL+92QtNqa6BTJKKMBfO766hh0gGb0vOwnyr851FLaymo
 WhUrNJHL
 S1/Npi0rAT2vgDi1J1bBHzRQmVrI4sAONSgDuiDG4yocKli6KIfEhbH9rzg2Bg1xrmDwqGWOXiunkB/MylMrNvAJjWNVLptgSB6LBCUHjcSRGz6eRF/8cY9NhkQFQtQaIPRUPXMEH4XT6xi43pvvqG9WH/xmQNNiMdfoDq2Tb3IXkrYsO8WAyU/2h2XYDzOjzqBwm1HtpU+bEmg8Waom7hLHMSWFqz9gYtCGB9gdoHYguVMp1VdK+5ysbWy6CQuD+6J4M5U3qet0f3g2Ao1ezFv2eduV2gpb5ZpqOrGr8v2bqhHC4un8nUlfjg9c1wFinerZ/7qoHgQuVlhDWXazFKUkqrqvWP4yu5N9AcHplAUdfM2w2oga7UFN2iaXODm+fO+h+hHQZI6wrH7tJN6ix8FcSqrtY4tVWMEfWOQSAGFcHkz6jEMYlT2SNObrDKAOpzb+18gshG8AAEyl6FhrCTrLC5qpjv9YnIHlThOmBv6aXxLt+rIHZPDFfEft33vY9zlaM+ZLTwoeB217XlSRbz1pFu92aQ/mGt2LttvEuPxLw2XxipoOSVE37Hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 3:22=E2=80=AFPM Chen Ridong <chenridong@huaweicloud=
.com> wrote:
> On 2026/3/23 0:20, Kairui Song wrote:
> > On Sat, Mar 21, 2026 at 4:59=E2=80=AFAM Axel Rasmussen <axelrasmussen@g=
oogle.com> wrote:
> >>
> >> On Tue, Mar 17, 2026 at 12:11=E2=80=AFPM Kairui Song via B4 Relay
> >> <devnull+kasong.tencent.com@kernel.org> wrote:
> >>>
> >>> From: Kairui Song <kasong@tencent.com>
> >>>
> >>> Make the scan helpers return the exact number of folios being scanned
> >>> or isolated. This should make the scan more accurate and easier to
> >>> follow.
> >>>
> >>> Now there is no more need for special handling when there is no
> >>> progress made. The old livelock prevention `(return isolated ||
> >>> !remaining ? scanned : 0)` is replaced by the natural scan budget
> >>> exhaustion in try_to_shrink_lruvec, and sort_folio moves ineligible
> >>> folios to newer generations.
> >>>
> >>> Signed-off-by: Kairui Song <kasong@tencent.com>

...

> >>>  static int evict_folios(unsigned long nr_to_scan, struct lruvec *lru=
vec,
> >>> @@ -4852,7 +4851,6 @@ static int evict_folios(unsigned long nr_to_sca=
n, struct lruvec *lruvec,
> >>>         struct reclaim_stat stat;
> >>>         struct lru_gen_mm_walk *walk;
> >>>         bool skip_retry =3D false;
> >>> -       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >>>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> >>>         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> >>>
> >>> @@ -4860,10 +4858,7 @@ static int evict_folios(unsigned long nr_to_sc=
an, struct lruvec *lruvec,
> >>>
> >>>         scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness=
, &type, &list);
> >>>
> >>> -       scanned +=3D try_to_inc_min_seq(lruvec, swappiness);
> >>> -
> >>> -       if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_G=
ENS > lrugen->max_seq)
> >>> -               scanned =3D 0;
> >>> +       try_to_inc_min_seq(lruvec, swappiness);
> >>
> >> IIUC, this change is what introduces the issue patch 6 is trying to
> >> resolve. Is it worth squashing patch 6 in to this one, so we don't
> >> have this non-ideal intermediate state?
> >
> > Well it's not, patch 6 is fixing an existing problem, see the cover
> > letter about the OOM issue.
> >
> > This part of changing is just cleanup the loop code. It looks really
> > strange to me that increasing min_seq is considered as scanning one
> > folio. Aborting the scan if there is only 2 gen kind of make sense but
> > this doesn't seems the right place. These strange parts to avoid
> > livelock can be dropped since we have an exact count of folios being
> > scanned now. I'll add more words in the commit message.
>
> This change confused me too.
>
> IIUC, this change looks conceptually tied to patch 3. The following chang=
e means
> that evict_folios should not be invoked if aging is needed. So the judge =
can be
> dropped there, right?
>
>
> ```
>  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_cont=
rol *sc)
>  {
> ...
> +               if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
> +                       if (try_to_inc_max_seq(lruvec, max_seq, swappines=
s, false))
> +                               need_rotate =3D true;
> +                       break;
> +               }
> ```
>

Hi Ridong,

Ahh yes, as you pointed out, the explicit should_run_aging kind of
guards the evict_folio. That's not everything, besides, previously
isolate_folios may return 0 if there is no folio isolated. But now it
always return the number of folios being scanned, unless there are
only two genes left and hit the force protection, which also makes the
judge here can be dropped.

But not invoking evict_folios if aging is needed is an existing
behavior, that commit (patch 3) didn't change it, just made it cleaner
so we can see it well.

Now the folio scan number combines well with the scan budget
introduced in the previous commit.

And I just noticed it might be even better to move try_to_inc_min_seq
before isolate_folios, to avoid an empty gen blocking isolate_folios.
Usually this won't be an issue since calling try_to_inc_min_seq after
isolate_folios also ensures reclaim won't generate any problematic
empty gen, but removing folio by things like freeing could introduce
one or two empty gens.

The forced gen protection may cause other problems but that's
irrelevant to this commit, should be improved later.

