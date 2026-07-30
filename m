Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC943C55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C537E6B0088; Thu, 30 Jul 2026 08:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C058D6B008A; Thu, 30 Jul 2026 08:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF45A6B008C; Thu, 30 Jul 2026 08:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87BC06B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:22:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2AD681C003C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:22:47 +0000 (UTC)
X-FDA: 85045356774.09.DDA53B5
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4243D140011
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:22:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VyzGF70T;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785414165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2P+KMdUm9r9TSqxSsM4rx3TvXonsXT/xIb6tsSWDzww=;
	b=VcDxuSIGbBI5uzTcuZHriE33EgDXAhKRvzy4Z1NIPVEleVhTD2uK7FFbfbrsW5/zYuLNaS
	bbLMynErypGEbXWj1U5JFniwfr9CWBcHKuUAa4gEXIcTvoQTvijezqdpj0/DCt8c4ALtWn
	j4th6DqqhquXLWA8xVP8g8XX/LW1D30=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785414165;
	b=P8N/LNpQabWPmChCC9MVGtROGn46O60wufYOLry7qsiZJ2wtVPWYjfaZbiAPMgvsDURMMt
	gNrkS/DvwZSivYUyxvJHymuBCE90CZTCtiS5oVgnywaJjOpjTmC1gi4p1EHAZjqzfKzno1
	E76XP2ist8Azc1dZHjOFIx30MAenfU0=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VyzGF70T;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6a07a051a81so1347213a12.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:22:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785414164; cv=none;
        d=google.com; s=arc-20260327;
        b=RhNjU3tBjR9nyNOUzuMZJZpe3+w+gaXt6hGoYCYrHtcDoCrawqBSak50JiE4ZrWdZE
         8aIcmA7NkH1b/cY0uj5uuNX3o6rpq1WaSpNF6z1fSQA59t0snxfDPiIVcDj120rmfBIw
         ybKjYzVlJSjnYTvwKmBcLqk8EaLUpgngqakdodOmJ8pTTf5VOlEPtSJ8QYaUqT6WbTul
         8mwpRZwpqhYlHof+EBV+cTZgMCSngMdaEDAA7JXnR1UBn5dS2An4lkLD50eJjTpHjWG7
         oKaAgL3hN9giHoeRFJmWJ90+XxZGwjfCwExCbu6LZEviQ/udB4HVnYlCsYhRr42q9t29
         wFRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2P+KMdUm9r9TSqxSsM4rx3TvXonsXT/xIb6tsSWDzww=;
        fh=gC8ruEKoWvVVSJ0NbBhXD98978g2dOVux2biI1ZWQH0=;
        b=A4YtTsOla6HjaRmyGtUYX8C6A7cqaYwriDeL23jmyJzHT/NhjM6We/l5oUjLPtZ1+P
         JaVTNN29Amyvqp19YHba+pwt9M/zaBuQJAD+kRrLIuyC1HaBU5sOIUIrSrdQvNzl1crX
         mb3Gr7SM+Mv/o1K9RgHmc5JvKcf8tShSHmcTO/c3WPaXHkBRqhXOUNEmc0I3EvizD+KR
         09l4b/Hsk2tjNOfEh2VT4CBHDWfNaWz6hwQR4rcQ+960tNHGjW96Fi09caj1K/uo/W3V
         g+UX1DnOOzGlfJe/cHVtwwdRqAHF6K3nGg9uDC+PGXXdEr9ptajw/G9xyUFYMoricFA0
         t6xQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785414164; x=1786018964; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2P+KMdUm9r9TSqxSsM4rx3TvXonsXT/xIb6tsSWDzww=;
        b=VyzGF70Tn3UFLJZR0IhsGFm7yq/kLGeFb6CXljOu9cScsfXTxxngp7UzbGr33g81e9
         tqXp61Co2LwcgbvtE2ysBWhqR2ceifuowWhaZXEhOIfGODrYQF1507c8Tx4qCWJT9tbC
         WuzNnuOyO/hMyy2juaqKUswW8HYJqvilBCUTtdRWrcUx/aOd8t9z6GQKp/2fvbWWvSyF
         bLO5A9gPPGwW17kQ+oklT9mZGqio8j/iX2cK9wN/ObulxKZlM3wGiXkPD3Rj3lQjw12A
         upiax6cYInJVpt9zC8pIIlyNOcdgBab0ibXKQGh9j2AoQ3r0YUSW0Hsu5NqIPiBN1HWe
         uNXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785414164; x=1786018964;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2P+KMdUm9r9TSqxSsM4rx3TvXonsXT/xIb6tsSWDzww=;
        b=fJQGgi3Lr3F2sKhYEwqAoTLGfWCxASv8wN33tc0wVXRfGhybnpZYAmiG/urk9y2nST
         +OAe/WbRuK6JMuT+GBoITIvgIcSE1Bqi9Pm4zwrX/n22VTWExP7gVBkvJRAc1K5I+QeR
         i0NnWb070CotNUP8pR1AoxG+9sAIxxEzLizhBbiwcEdumqOSzy0Daa165CJ8ioG4Ycvw
         1JTJgb4WyDPdLkQZ5Ks1KvsBqii8a3YV99rqjbvx48FPpASK+NTYDo20zuuqt0odXPEi
         I4uMxw3C2W1q1/KehImfbNlFiLsUVJcSBK2w5MBBuDHxEClFMP8eEyhJ47e5o6B20M7Q
         13bA==
X-Forwarded-Encrypted: i=1; AHgh+RryA/Bajnw7iDWtqAYhAVbp4/1qVDqgBKt6JLPHe4+0+i+RwJY7ZNV2RHGMZNd3kQmQN943akaPBw==@kvack.org
X-Gm-Message-State: AOJu0YxqBqsBhBuAJ56Wd0al9O1c/ksRO4yZ8ogr41WSKCLDEf2DB/i/
	ROctVX4dWtJoTwEHafaaHS04FLffl3hZ7Qa1ly6cRryS3Huvze9kJNy10FcywMkQ8zl8pq/UlwW
	JjQ2tTGpN54B3wpteV6z5/0cZ4tlHy2E=
X-Gm-Gg: AR+sD1057KVDfnYVd80kgOBbozX9k8h5JzEbqU3RHNecJgTqB5NBWMrP5Wyp5ZmYWyi
	m9kdoXHg6XHAbXU7F6q6cCxJYVd9MqJzQrw27NSaMBd2Q6dmS4pXpnV4rOutmikIOMC/K0WSs/X
	/QKgTWo2ryhGGTWl/HpWxvtPAaiI17Ef0p7iMBiBKvYHgj7ZaJvBVV2uJ+xPu/IZgQeuIvD9jMb
	An2XvKwMkAuUZ4ZrjuXOiuZfEemN2EyxgoykpMVrP+niqoYcVAA4vGUwxrbXK9o0gdwIwePZiPa
	a0U81/Z/K7Ju8Qne4VVf9lcUWIE3VNhADc3TW3R9BbK+ok3n1Dh+rw8dxyukZofLWX+zX3ZYC1Q
	zPQ==
X-Received: by 2002:a17:906:fe47:b0:c12:5a0e:3e0 with SMTP id
 a640c23a62f3a-c1fa5664260mr126758166b.19.1785414163216; Thu, 30 Jul 2026
 05:22:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260726122123.7614-1-baohua@kernel.org> <20260726122123.7614-5-baohua@kernel.org>
In-Reply-To: <20260726122123.7614-5-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 30 Jul 2026 20:22:05 +0800
X-Gm-Features: AUfX_mzjD3DqRwuR3CWgu-4-q1N-eL8RMRPkUVIxJb86QI0d9DnbOs3xbpUICPc
Message-ID: <CAMgjq7B7066bsgGDccH9aP+j0ObDfviZhxVXxE4GZp8-gZxoig@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/5] mm: mglru: run aging when pages are severely
 imbalanced across gens
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	david@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, ljs@kernel.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, linux-kernel@vger.kernel.org, 
	lyugaofei@xiaomi.com, stevensd@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4243D140011
X-Stat-Signature: igmq5nbatbfaqq89mqdnct9n15qi8xip
X-HE-Tag: 1785414165-499140
X-HE-Meta: U2FsdGVkX1/WeZaa6PRzyWiVA9GcV1EtNaaSgZssXOAG8UHbpm0wZtHXGpSdlx8W+VVyEx8289EHvIT5qioh8Q6EvugB7LSNBtChjaQ6KjwOUYhQsLVnmUP/9DnStYsIKS3Lm2Dd42hpjme6XPZWuys85xWyGsncisbKE9TYuJ2qM+4EOjyExWPCMWZyTN1/lujrcDrwdFmqaR8meY4x6t+4S8VZUURpucDEKg1junspYppcQstxEh5VCukphI2o5eLzHH8MuM/t7k1DUwHkSno6tlBWtBnmaIxwSmA3yMiKK9kRkHIDVQKOu5lb3aGGt6ZjDSOFVSWBYjIP4iGgcd4TJyWsWktmg+/Xs5nYeGm0N9Z9KdgV5Edpl3hTVYZyB6LFdXzWm5kR0q0s4x/fVK7tzhovVB/T1hGjyvLVes4Gv/rU6Gu0r9HSmmvQ8DHiOrWP6FpPayLuqeKEM2EeoKsL1Kqe4jq2yz7SKmCB1DUMOE/SZ+BEbvzlzj23HdRTZmThDmjt6y8L9DPQYBmt7IdCp9Q6DY8JaHMGXXP+KPEPk8RCwcc7EbYNd0KpO1hz9VxrF0+qHI2qE/7zRg10E2tfwStALEbGQ81fLCU0PEiNXTETYBHy7/KrPpEmqRu9LiD9Za/5scdWGrz0Wb5/SD1A0HX5zd7WTGF97wvVbkFYn/gFMsRooaq4B4VelwYyMOt0aJ6xwJtTJz4VWB/SjXAeaabzqJKundJS/L6qpq0VcmBSQ7sioVJmgUDacbOs4KRGvK6nJTJr6UPWFkDBbd8oQxDMpoelVS4QTc5SXFFAMFxBhIky9HorOgwxYdDQuKHOKmqdl5UPr/6N9W1vNgYDUnYcQ1qJIRlT9Tb9HpwSnT00U1j/PXhpkD1QcUPi0HqNXS62SIHggbNeBV43WnRNOjEE93Fxcw7WufyWzO6/0kpfes257nQP1ECXpvWpZwh9nbYJSrq2hrT+VJv
 WP7QZQzM
 gWjM9t6X289JcxPdQo43FBxTgfSFu3Qgj1nndKZPtRxaUjhghfECVIw52x+S70sOuR38BEH6aKE9zgumt4EOhS1CsgZEsgosUQyq7znxffgXXyLcwWdG7eFVaMAfwyVY0fb3jd7LwmzjgPrmGHThw+aDtEdvjhpz9TIxIYcOkOtP+FSkf3y4ZAyJp99Ux04ELqC9v0ZhpTcFj7ca0skkLPlYEaPlwLMkdiFyTuQ5KF10Zt1+HdfVr8UXSEtG97eVHw0mEn/U0VMNYAy6w+UkNwCjCDkEA0Eh0Dfq1pC+xKHeltSWZEtwEXhRy8wklMobOsR9zr2RBmezZ13Ywk72iPkYegAu0kJ6zLgaE6D5iIk3b++QHeueGBgroNFb6asC305Apt2RHD3GQyFkuBzi07UOkRREyEBVFn2/GSHZegcJA6C/MssxNnBJlDBeUhJ42Jk0FuM/itD0b/Qqn1/o9JpYVZnLvkr/5CYBa7TyxrTk1T94r0vU/jQxdDSV+SMKU5Hp1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 8:21=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> From: lyugaofei <lyugaofei@xiaomi.com>
>
> This partially restores the reclaim behavior introduced in Yu
> Zhao's initial MGLRU commit, ac35a4902370 ("mm: multi-gen LRU:
> minimal implementation"):
>         /*
>          * It's also ideal to spread pages out evenly, i.e., 1/(MIN_NR_GE=
NS+1)
>          * of the total number of pages for each generation. A reasonable=
 range
>          * for this average portion is [1/MIN_NR_GENS, 1/(MIN_NR_GENS+2)]=
. The
>          * aging cares about the upper bound of hot pages, while the evic=
tion
>          * cares about the lower bound of cold pages.
>          */
>         if (young * MIN_NR_GENS > total)
>                 return true;
>         if (old * (MIN_NR_GENS + 2) < total)
>                 return true;
>
> But with a stricter condition: the younger generations must contain
> at least four times as many folios as the older generations. This
> allows aging to keep folios of the preferred type spread across the
> reclaimable generations.
>
> Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
> Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 37 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d6bd64b4dced..7c13dedb0b1f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4956,9 +4956,40 @@ static int evict_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>         return scanned;
>  }
>
> +static bool lru_gen_imbalanced(struct lruvec *lruvec, int type,
> +               unsigned long max_seq, unsigned long min_seq,
> +               int swappiness)
> +{
> +       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> +       unsigned long young =3D 0, old =3D 0, seq;
> +
> +       /*
> +        * reclaim is forced to a single type in those cases, so there is
> +        * no need to consider the swappiness bias
> +        */
> +       if (swappiness =3D=3D MIN_SWAPPINESS || swappiness > MAX_SWAPPINE=
SS)
> +               return false;
> +
> +       for (seq =3D min_seq; seq <=3D max_seq; seq++) {
> +               int gen =3D lru_gen_from_seq(seq);
> +               unsigned long size =3D 0;
> +               int zone;
> +
> +               for (zone =3D 0; zone < MAX_NR_ZONES; zone++)
> +                       size +=3D max(READ_ONCE(lrugen->nr_pages[gen][typ=
e][zone]), 0L);
> +
> +               if (seq + MIN_NR_GENS > max_seq)
> +                       young +=3D size;
> +               else
> +                       old +=3D size;
> +       }
> +       return young > old * 4;

Hi Barry,

MAX_NR_GEN could be tunable, would it be better to use a macro like
MAX_NR_GEN or MIN_NR_GEN here?

And I know there are experiments to extend MGLRU to run aging
periodically so each gen has a fixed age:

https://lwn.net/Articles/976985/

Not sure if this will conflict if this is a hardcoded aging behavior,
and if we want things like that in the future, these are useful on
servers, I think android might benefit foo.

