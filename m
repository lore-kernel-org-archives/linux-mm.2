Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FE2E1099B40
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002C46B0128; Fri, 20 Mar 2026 16:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF5CA6B012A; Fri, 20 Mar 2026 16:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4A66B012C; Fri, 20 Mar 2026 16:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C86A46B0128
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:58:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59CF2C14E2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:58:39 +0000 (UTC)
X-FDA: 84567655158.16.5374CFE
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6464080008
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:58:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gdwj60RY;
	spf=pass (imf02.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774040317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjvTIjx7aNv9III4BeSx9B9Cw3n4/JbOni5s6qL4ogk=;
	b=sorI/EiFSypOmA3faI7k3e+UadVbsuKcAuWgRM19IBEyXz8KDsSUoX80rRYN1j8GwEcYbN
	rjdoyAIr/wwjfqOStMUmKuKbq9aYRW7pAxNz7QICOlctbmUOouwujAVa+B2X2p2e1Na4rI
	uogzWxf8EcPRQb3Fuys7LFPZK8jq0Nk=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gdwj60RY;
	spf=pass (imf02.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774040317; a=rsa-sha256;
	cv=pass;
	b=Ge3CsIEBMX9hNJJIvKFe4NYvKAS0QitiEU8UVXXlLJeoyAegYiICqs1apaMuzz4fUl97vs
	ANjVDjSSxTr5fdxOi/DAjjPGkY0Vkb0Dy9HjnSMf1XWiv8PnP7v1vvzt6KYnXGRC3/bj3w
	3gEQhT8ALmXOkfnPwNkrIp2kOdua81M=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1270f10a774so1134c88.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:58:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774040316; cv=none;
        d=google.com; s=arc-20240605;
        b=R94dA0fxUSmwdQZv0QD9bmV22TQX0ZUSXO42H39XnaJJYvz8pqh5667/69RrU66MVc
         gLFYM2EwJiEchR8kHUAvS/F/oOcCd32fSt+wjj7qhE03Q0G/i8frrNjXenl2TOLPX/hM
         xnGWQReXtAynYIb3z6gJiw9FNWYdhv1AMuq4L9azfoBZVv98dy6CQbE6cl/7CItIAGIU
         jPpITtf3Fdgr/rACvccVN78nAJm7MCoCGUuPOa8qQAeU4Lq82PdrUlq3k+SInGNbtDSf
         18KArgO75s4eMxLJV1KcSZ3GJxbowZJ75oy43FVrbeDDMTyEcLaWlGaI6IDZM22PU/90
         G62w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tjvTIjx7aNv9III4BeSx9B9Cw3n4/JbOni5s6qL4ogk=;
        fh=vjmlo65dT3bwujOwu4be5PnOTUPYF/zNrpV078uiamg=;
        b=DetcKTksjNGeKzJ+Fp2E1G5mShPV0z5v8hTfkS1Btk7UgNzBOkEXT/F8PrMz24jq4P
         +fb+Y1mDoP4IfDlAOfjaEC5Rl0euZUqxHOM6OUbDV4t7lTMOOMAj9C9smnxaSv6irv08
         bVBXqa/69kQziVJ87x6I/x4tRxNuUVfUb0eUOC6Kp24OH8RmejnmGsXfEZTiJqifa6V2
         M966ZhoT0vPitEenlwdCAcmBb24JWrpSEZIw2VbS1SNbjFiWtaDV23b9jqjK+NcOtDA3
         5XsJx9b0pKdXR81RgltIdW2YzQjADCrIEa/Dg0NT7L6WoaN+5VSn+KB6xRDS0FbA0Edz
         bIHA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774040316; x=1774645116; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tjvTIjx7aNv9III4BeSx9B9Cw3n4/JbOni5s6qL4ogk=;
        b=Gdwj60RYB05SybVsrhwU7SgiXuutwKBtek9U34oEvruaD20/fU995pRVMtKFHHYHNR
         N+QfsFP5fI4jYYzv+XNvBji9eEupNdbEqjdng7J4wiaLlUPfTUBT3cd9ekNj2t4pbAIb
         X46iG7e+w4iDzvVCynajklYemmXKyKua915WbCWMdTEZvB0hneecoGNC0k4g7gpe6q/P
         Ved9opJ6La1HQoaDpGrIAoPX8+ecCSbAEGx9KHYwpzmK1O+0dA5EuWp6OUm77ftcvTUA
         Tr0XpCRw2azdlQJhfffzpqPhNtGqXAngEyh4ZRAwG9cg2/fndJT/vBMvxIG6rmuDdmGe
         Y6yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774040316; x=1774645116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tjvTIjx7aNv9III4BeSx9B9Cw3n4/JbOni5s6qL4ogk=;
        b=saCYoAzHmTzqOkMai1AHxTWS5J+cKTKuWIQCrJabS8zbLikf3Xx4+2kqshhYMvceJi
         rCAWJIGSVB723TWxPit6nTdas0QV7y0qnbZ/mfw1q+ymbKfySEfCveAG5eRNwwXq36a8
         T61H9nelxbgmlqXbGAyPDRlxrP2In3H2w8WvMgMPFEvfWA+MHHbMNPoFHtD2ov2A+/Yl
         YDfqgqeEQ2904nD8U1d71TTLGgSFfMnNZr0PXypjxvyiVDcOYJbvIrZbvA/yhZK/lxIu
         4E4bvRDsrqOjuwZo9vgrJAyDjp74bkrzPirSOg9c3yqnVf9EbMs97sXTjCmc+1OR7HEC
         w1Pw==
X-Gm-Message-State: AOJu0YxzDM/1V7Lb4jtYvYC3U47NQf01vGwdAd2pfYoJ015KINY4XVa2
	eQpbRqq9VkjWavJbWBfW7SAwyURBdaDivFxecGcP9/tslX5ClowZAlccHCbH5GqglTE7h5POem4
	OqdQfoK2r9NzzNl3H5Fx5z/WZeBQgCbpOC0DlDFKa
X-Gm-Gg: ATEYQzx2l3K+z5GInOICquFIgMBCrBve4fgtR+9bpKnAzv0a6J5Fdqs/r32xKWAOaVv
	x68xLD5Sn51z1gnZYMMndkUM+NcVF2dgL572FQuZOaJU/GfA7w5j5PrmIxaI6g6XSuoX4CLKCKB
	Qq86ZliGhDjqr+MYb1Jez9MuQ+CzrIxT9ENBtNw05zNLtvTTnnvjXMZNi6DMWADNbkQmXphAPD8
	XbTfooPA8Y+KbZFHhbMWJFxpaG0aAxkLxjJz/xZHCNy1DeE33MvtPB6MXQ0SeFC8QPRWRlIln/4
	ggt162Vw
X-Received: by 2002:a05:7022:90c:b0:119:e56b:c1e3 with SMTP id
 a92af1059eb24-12a7b04f470mr49686c88.14.1774040315394; Fri, 20 Mar 2026
 13:58:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com> <20260318-mglru-reclaim-v1-4-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-4-2c46f9eb0508@tencent.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Fri, 20 Mar 2026 13:57:59 -0700
X-Gm-Features: AaiRm51WbvdX7hkUEUjkGVxwL3D59s04Me0piu_TYdD3YeMvHUmNR0aGHH9A5ME
Message-ID: <CAJHvVcgi8m_O03+Grv7jPX8btaVvYuZxh8S6kLjALfREykToDw@mail.gmail.com>
Subject: Re: [PATCH 4/8] mm/mglru: scan and count the exact number of folios
To: kasong@tencent.com
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6464080008
X-Stat-Signature: 5a3otdiq6cwa363x4f9h9pgysig6xx7q
X-Rspam-User: 
X-HE-Tag: 1774040317-21210
X-HE-Meta: U2FsdGVkX1/rnXaML/zTpig8dZdTBxzwPiWipS2H5fcKrCS7KQAQbLnOKSEOj0MQHXrRkgU4Cer8kUhhpQfBHihCk2uMCByaIkTqic4u+56yKo5Cn0MYfMZoo3uOOJTPK6FyhprC/GaN8V87ZekZF7ASnkGjZsDCy3B3o3Gx+FNSDjSdwfgsZLs7MUlJIz59kCTYzIOLHDqtXryOj92+qIV+4epeNLvIu6GTwdkxbHCMKmkGWNk2tL39IkmCxZnvcv/DkdsoYZKiWzVGf7rbrFeJMndhXegEHd5jA5wgnRBLSqbOTF1c6BxezCC7ParwongECHLcZB3L80U/M/tG0AYCY/hkQS9HMdF62AEgtVSchvyx5NGfbHy+kexqKfWcaqArO3qW1V33h1i3vKExfp1+f9ap2CruPAVOyquvTUvT+rpQOLfyPlp108cFFq5Tce6VRQB7G62FfKAPNIykPDhIe56jgLx1Q3lGN4Vf+L6/wOevDtcGyRqHxDqfhFv2yjw9BUIwkJiiFHUZeFPzvAFTmXM7U5qgeJgQMZhjXvMJiBOL9EMCre2LFW9ZHe1yIrvDzH9aXvgrDHsXL5nbiyqSloBP6K1stSHXfTGKJ80QDUzDvWY7MWr+6x36T6JGONN2m/urHWOL73BfumPBCrMOTn1kJowwM/UVqVml8MbaC+5GpTQMi8Mk3HSidneFz7mCadNsyGmoMUTpKbtE3aycjK6JMt28jB3u8P3+RwObpDClDMlBztBoWQZgtyWtL53KNc0b7GkcAJfrSQzmFNHmH6/mUV4NJcXWhLcWyvd+oyZ5GXYInnGFGK9VozbExixJxVZu8HPZurmifmbgDCXVF2L7rgLB897Iguab5stuDlPWLcRmYMOtr91lIDT0eMBhLMV31J1M/Px1HVitRlBUQBquMFnmOJi6gK0rnZ994GQQQ+ARMWbLGbJK8AuhtTD3zzot3uFunc2l1y7
 i278WP36
 vA4EhK73ohOimtDUaM+tUidTRZaVJ0CipZoL+BESECb68d6Uh8F7t7RlEb6FIvBwXmxkEbvvDucCwbExSICMzHDXut4yaoKQDNY5tnMbHhm1oKu6xUqwvc3VB21Xk52DbVBNFVEGNyoT+cPzxPVAqpM3ApDw5U4USOt3nLMS5VeQWRdhljlA2djmqp3yHedcipjGHGkAzXTexXj6lLU0zx88fuaGFp+uJMdN4lfGW7NnLCqjzREdtUQTtL0CG1XBhTMGPgCd2pBNSx7/xR73Y0IphMPKDq1LKU0sG10r6gpEtkuqw/pPing6h/KM46YHTwoE12JnH1a/1LCkA/d/0FE6ivdeLwPWd1s1m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 12:11=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Make the scan helpers return the exact number of folios being scanned
> or isolated. This should make the scan more accurate and easier to
> follow.
>
> Now there is no more need for special handling when there is no
> progress made. The old livelock prevention `(return isolated ||
> !remaining ? scanned : 0)` is replaced by the natural scan budget
> exhaustion in try_to_shrink_lruvec, and sort_folio moves ineligible
> folios to newer generations.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ed5b5f8dd3c7..4f4548ff3a17 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4680,7 +4680,7 @@ static bool isolate_folio(struct lruvec *lruvec, st=
ruct folio *folio, struct sca
>
>  static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>                        struct scan_control *sc, int type, int tier,
> -                      struct list_head *list)
> +                      struct list_head *list, int *isolatedp)
>  {
>         int i;
>         int gen;
> @@ -4750,11 +4750,9 @@ static int scan_folios(unsigned long nr_to_scan, s=
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
> @@ -4819,23 +4817,24 @@ static int isolate_folios(unsigned long nr_to_sca=
n, struct lruvec *lruvec,
>                           int *type_scanned, struct list_head *list)
>  {
>         int i;
> +       int scanned =3D 0;
> +       int isolated =3D 0;
>         int type =3D get_type_to_scan(lruvec, swappiness);
>
>         for_each_evictable_type(i, swappiness) {
> -               int scanned;
>                 int tier =3D get_tier_idx(lruvec, type);
>
>                 *type_scanned =3D type;

I think this is problematic, now `isolate_folios` can scan a nonzero
amount of > 1 type of memory. Then the caller (`evict_folios`) calls
`trace_mm_vmscan_lru_shrink_inactive` with the total scanned amount,
with only the last type we scanned (misattributing part of the scan,
potentially). Not a "functional" issue, but it could mean confusing
data for anyone watching the tracepoint.


>
> -               scanned =3D scan_folios(nr_to_scan, lruvec, sc,
> -                                     type, tier, list);
> -               if (scanned)
> +               scanned +=3D scan_folios(nr_to_scan, lruvec, sc,
> +                                     type, tier, list, &isolated);
> +               if (isolated)
>                         return scanned;
>
>                 type =3D !type;
>         }
>
> -       return 0;
> +       return scanned;
>  }
>
>  static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> @@ -4852,7 +4851,6 @@ static int evict_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>         struct reclaim_stat stat;
>         struct lru_gen_mm_walk *walk;
>         bool skip_retry =3D false;
> -       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>
> @@ -4860,10 +4858,7 @@ static int evict_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>
>         scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness, &t=
ype, &list);
>
> -       scanned +=3D try_to_inc_min_seq(lruvec, swappiness);
> -
> -       if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS =
> lrugen->max_seq)
> -               scanned =3D 0;
> +       try_to_inc_min_seq(lruvec, swappiness);

IIUC, this change is what introduces the issue patch 6 is trying to
resolve. Is it worth squashing patch 6 in to this one, so we don't
have this non-ideal intermediate state?

>
>         lruvec_unlock_irq(lruvec);
>
>
> --
> 2.53.0
>
>

