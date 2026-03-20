Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C24E01099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4E086B011F; Fri, 20 Mar 2026 16:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D258B6B0123; Fri, 20 Mar 2026 16:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B2D6B0128; Fri, 20 Mar 2026 16:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B32096B011F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:10:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 62618136F48
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:10:14 +0000 (UTC)
X-FDA: 84567533148.11.78728B1
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6DC1BC000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:10:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kU5YRMOi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774037412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aaxnU5gAYhvzJ+CuVhDpXbVGsndsgjJVUO1JI4WYgo8=;
	b=EBFPokH6U/hwd+KDVbZy4sLnWA4BipwUKbb/+M+85nwIt8MKAzBjP29NRrINbhxCnEZKfc
	37cViTx5dtlDFtNErwydXRGqI/FP3LJv7P3gaRt8xrFxK01/lO40MY2bUbmac+0bT6G5Ao
	S3LWblay8ZjkbNgIH3T9UTdHRM5asjs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774037412; a=rsa-sha256;
	cv=pass;
	b=F27qZbbyHW3ltFR3paPGornV+I4EY14ROLI56g2PMZdh0i/0pHc0xC1wax4piXY2JoFZv6
	Rsrkho+a7JbBiGkct4rdk0lHa4gMI8CtTXg/Zq8DqwmJ/Wzy7+nW+im9XudqpmRzXfooBQ
	wneZ0NvGn0j0DuSBqkQ1oNUYVejx29Q=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kU5YRMOi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-128ce536fe0so1770c88.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:10:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774037411; cv=none;
        d=google.com; s=arc-20240605;
        b=FZCe4zeijB1wL/Ds8ZlayE254CgOl0jpAWN+3Nk7gpFhRijDxrn7RYca6zx+KXuyVK
         peSyXUmYnkqyeNiOJz6wJT5elfXN/PVjIO7lsJYK/GMri9nlWOn6DXU7CxrkLAFlj2Ge
         0PRWE+MNkol0DtN/Q+ml3bYi65v5+9SqUwrQ39u2aARRN2Ewh/BOVUl5fL3p3SdlgqwE
         fa8kwpJUtks21iFZsHIWHuZGY8+y82srEsMoUYTgXiK4c/S+0/ykkZoEt8CRsvCxSW0K
         2nE4FslzWuLWxuGSfgcZoipqtGiNLdhBMRTb4r9IPHk7fAQTKn6kd67LErvGNZgSRLZ/
         J60w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aaxnU5gAYhvzJ+CuVhDpXbVGsndsgjJVUO1JI4WYgo8=;
        fh=vjmlo65dT3bwujOwu4be5PnOTUPYF/zNrpV078uiamg=;
        b=fnefjTz8x7VIEb9vmahxW9yCIC7qWxhIqkFWJzFcBvtqVO3xn+TGtAbF2Ay1shRlC1
         fOYQGRGavpxQpmOTJPSA+SgpyFP4ZdqJ/vVIJFIj9ugww6JrK5hxjXHfFTHGh4UzAUyV
         WL//OGr9YFQV/K1rgj1CoaeMPQW09ogRlDKXUeN1HBn9KCM5MrIvmXxqipjRfO7GaNvk
         /nCXabvj0IOZtr1CPkuRRSyyI8kvoUlF08IAKq+S24yXrNrVaHcLnG/uYVzK+W+Ca4Cb
         XLRgeIgB0jD126wXiXpVR3RewrpU7rVMVgASJu64M8XgYiS9UtonfBJaPbWUqaOvvMLM
         w+HQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774037411; x=1774642211; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aaxnU5gAYhvzJ+CuVhDpXbVGsndsgjJVUO1JI4WYgo8=;
        b=kU5YRMOiZykA9Mu0uVDycucGG70lJTU+TpMxwehwqx44m34iP09lAKGtzw7/cU5B4Q
         TxnW8eYSvDAUZxAJv+G2Cgw0ncZcJnB1cXgYvZ0iZgy6JY1NQBaKd7HmZoiBuyG6aqNc
         VVupSwBEm/k+IBpbHU/JdoqnvhzEoZbBYeohkM4lgprAI5T/emGWXhtO2V5uujkskzcw
         E1t0rFs5EVENgUAAiO0BEG8qM0oTLKFLV7lUFwZUw/2p+hCMsCzFFdoyc45CCX8sbhZw
         O+xU+1+CoXO5QG/tNpr0VgEIYh3zT3md1LUmIHvSzGcXuEWWfd8H6UoGs4kzCiuCr3Md
         I79w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774037411; x=1774642211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aaxnU5gAYhvzJ+CuVhDpXbVGsndsgjJVUO1JI4WYgo8=;
        b=aoiM9F1x7PJ0ENb1dTmfEmqSd2JF4nw+uKkMBTZBUNaMW3Tht36e9+SvrZgahsIyEc
         3LDahbDKIGec8yPrGqmmfQy+NtsvPHLwCUi+1tLQS/qEqQ8U2pcvQ0KfXnSZFkQLux7a
         yfB3GSi2VV82jjM/A56xxekQVynCSVZVVyvyJfdCj9BDjcHDMHrstr/FNAVaTXohKMJX
         Bn1sebJfI/7S5IVnyfAhZkPY8k0rRrG7IE+IcbFEen3kYNzKi7ZeYgN9wgLUnKVAWeXS
         +fOiEq8omRzRbymE3i/eueT8W4lF+juHL69iDyT4DYAPD1GLIOPAJZo0gQUehuwWfdMZ
         EYWg==
X-Gm-Message-State: AOJu0YxbIp5fmIjhcqj78dB0rfxO+kxRHk2yiFbkUs1pFLJf30heiNUl
	EZKdANDyk75sGPWj/fCVMgMFcCl1K0peGy8li8ug/5Dt5Jm9+1BOHXmoe4tk+yWQtacNzA0Yap6
	aFfbQWv7F+LIEu9LD7wWybXdWf2+RDPZthgP2uGy4
X-Gm-Gg: ATEYQzxxyeMmhZCPgV1jtYoykY8uRK7keWq8Ke5r02yqrR/W2kBhRKhV5I0nRl6MsUH
	7XNC9UFeXFwypWJvj2xu0laOZG5d1IgqKZayjN9G52QgL/+V8wl1yGCuoVaUvrABES86yZUikOa
	x32XzZD2jv75wResyvXiIprAfvEQAhgjjc3eoQ58k4MQQcONt+GxW0iCgjIo7A0/UdBUZYQZGXG
	I7xgl5mxux04dVRZqHxoA2HYgbn9xXRzt5zrA1T9b+ClVofSpVqRfXhP4oc2xsi9jO4as2VQhz+
	sMi2A9KQ
X-Received: by 2002:a05:7022:90c:b0:119:e56b:c1e3 with SMTP id
 a92af1059eb24-12a7b04f470mr43352c88.14.1774037410501; Fri, 20 Mar 2026
 13:10:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com> <20260318-mglru-reclaim-v1-3-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-3-2c46f9eb0508@tencent.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Fri, 20 Mar 2026 13:09:34 -0700
X-Gm-Features: AaiRm533BgpgnRyfENiMQePkwVxo18zGPp3_m1L9A9FHHhVCr99gl6yczqLjU-I
Message-ID: <CAJHvVchcp4roMKuhjkCv4_bE4ivbo3zTzehkfE=3JqjybYM+TQ@mail.gmail.com>
Subject: Re: [PATCH 3/8] mm/mglru: restructure the reclaim loop
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6DC1BC000E
X-Stat-Signature: juxxuxak9mkm9x9wtci9wi1oeij4iu1g
X-Rspam-User: 
X-HE-Tag: 1774037412-104619
X-HE-Meta: U2FsdGVkX1+wyTPjrQF5tNDAeHaF4Tc4TlC1LA1jjvMdTEPSaoLUQRXIMezPmbRdZ+QtJ/dav9VoFnTNfmMb3A2S4Jp6IWSB+26RFM1ZiRH1N7QnL8b0C2hlr5/xR1YkVDPuY1Rf4sfuX0rYoacnYPR1sEQttptPTro7vmlgaJVqQ16UmVYTI93iFi2UchisDCWXjNov2NQtUZHw9yy04G7Sw4V7BlVYNKicV0Ap55f9LaVV3BCk5qfBXy0Yyuu/XNpd+iXLInrULztc2fSe+FM4UWfaTVV0X2xb2Y1YfBboFvBg2dQFt40MsexqIrpq8gN8knP78+cMQNG3QtDa8G/xGjGpeINiocTRPOWQC/xUbREwfg+xdMOhMrU8PGOzKei0Otfug2vnC1GaHzXu0UHQGIIYUkQ3mrtPQTQ/ur8gdeHXY4+FcSqljWbOyj90rGaYNS8XILvIUvawsEg9LEgPF/vRsCWjBesUCxxc3ljC/YxrzkPr344uIOyH93aEsyM0mi/uTMdm2ire4vWxA1O+lifSm9fj+E3AXlv0dv7Fv4oi2mxzvJ6Ct+GIQzNSuKg3N7cREnIRZxrrvd29zNdodOv6nrTmVDAbaH7XgK6BYEEUvhzRHF2YZg3sMI2O0k78qtKWDkYD7jEkoIsF/MvP4CJVJG7raURgLK0ZKna6zOYr43eaqaS0aUNfNKFX9zGS2mB/d82FeV4QLWxOATdoKF8iw58SQfTVD5qYkN6zrutOVrvgY0fliMj0XBJzdRzHMTuY9EB/XryHyPTnQttArpa+UbfD0pag4/qQ74KePcxTJrqSh/p5ukREopyGSMLUx/run9e9/EA5/IgNXux5GXCVxPbXm8QBHjAdcO91aQp0JKZGQOR8s/ekm9LeSl93VaQ/woNIMjXD2kGCh/703tCKQtJw8Tcp++XGHBCLgTRmEqgLNikjLgTSWQDNZH1KcUm1fMg4qJxsmrL
 AZgzBaPr
 mFHGFGIQstQqnegc3o6vQMIew7yJ9bLblfuY5JRCqhrbCAgH+IJhKjHoPlzWFEWTFgy86KSJjhbKg1xlDmPBwrk6tFZFVn2Qtqm+4ktM/b7TuPTGJIs9JPTP4IRV9tRzlG7/GqzPrYo8Si0rIrLHEZhbkQIkM/SK8HKxju1N0o/ZsjktpZpXN32ZYpnmK5ln+4Q9QSpAYz6ESJlRjye4y5ce2saCTp3dFRGI4D0oEhdAK9lB1XXZDqOGCTtbewATmkDTKLtEYbeY/fBrMO7o2FuKOBqcmVcuprXwATHXyzzUnwcEmdgaQR+7rk+RMIG6SF6/p0snRmlVWt/2b7gpfrGB4LExxhqTCy4+Kg6Z6kxEsjVsXV6TW29DOCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This looks like a reasonable refactor to me. To me the new code is
more straightforward to reason about, and I don't see anything this
breaks (either by inspection of with basic functional testing).

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>

On Tue, Mar 17, 2026 at 12:11=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The current loop will calculate the scan number on each iteration. The
> number of folios to scan is based on the LRU length, with some unclear
> behaviors, eg, it only shifts the scan number by reclaim priority at the
> default priority, and it couples the number calculation with aging and
> rotation.
>
> Adjust, simplify it, and decouple aging and rotation. Just calculate the
> scan number for once at the beginning of the reclaim, always respect the
> reclaim priority, and make the aging and rotation more explicit.
>
> This slightly changes how offline memcg aging works: previously, offline
> memcg wouldn't be aged unless it didn't have any evictable folios. Now,
> we might age it if it has only 3 generations and the reclaim priority is
> less than DEF_PRIORITY, which should be fine. On one hand, offline memcg
> might still hold long-term folios, and in fact, a long-existing offline
> memcg must be pinned by some long-term folios like shmem. These folios
> might be used by other memcg, so aging them as ordinary memcg doesn't
> seem wrong. And besides, aging enables further reclaim of an offlined
> memcg, which will certainly happen if we keep shrinking it. And offline
> memcg might soon be no longer an issue once reparenting is all ready.
>
> Overall, the memcg LRU rotation, as described in mmzone.h,
> remains the same.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 74 ++++++++++++++++++++++++++++++-------------------------=
------
>  1 file changed, 36 insertions(+), 38 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d48074f9bd87..ed5b5f8dd3c7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4926,49 +4926,35 @@ static int evict_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
>  }
>
>  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_se=
q,
> -                            int swappiness, unsigned long *nr_to_scan)
> +                            struct scan_control *sc, int swappiness)
>  {
>         DEFINE_MIN_SEQ(lruvec);
>
> -       *nr_to_scan =3D 0;
>         /* have to run aging, since eviction is not possible anymore */
>         if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_se=
q)
>                 return true;
>
> -       *nr_to_scan =3D lruvec_evictable_size(lruvec, swappiness);
> +       /* try to get away with not aging at the default priority */
> +       if (sc->priority =3D=3D DEF_PRIORITY)
> +               return false;
> +
>         /* better to run aging even though eviction is still possible */
>         return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=
=3D max_seq;
>  }
>
> -/*
> - * For future optimizations:
> - * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for mem=
cg
> - *    reclaim.
> - */
> -static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *s=
c, int swappiness)
> +static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *s=
c,
> +                          struct mem_cgroup *memcg, int swappiness)
>  {
> -       bool need_aging;
>         unsigned long nr_to_scan;
> -       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> -       DEFINE_MAX_SEQ(lruvec);
> -
> -       if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
> -               return -1;
> -
> -       need_aging =3D should_run_aging(lruvec, max_seq, swappiness, &nr_=
to_scan);
>
> +       nr_to_scan =3D lruvec_evictable_size(lruvec, swappiness);
>         /* try to scrape all its memory if this memcg was deleted */
> -       if (nr_to_scan && !mem_cgroup_online(memcg))
> +       if (!mem_cgroup_online(memcg))
>                 return nr_to_scan;
>
>         nr_to_scan =3D apply_proportional_protection(memcg, sc, nr_to_sca=
n);
> -
> -       /* try to get away with not aging at the default priority */
> -       if (!need_aging || sc->priority =3D=3D DEF_PRIORITY)
> -               return nr_to_scan >> sc->priority;
> -
> -       /* stop scanning this lruvec as it's low on cold folios */
> -       return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -=
1 : 0;
> +       /* always respect scan priority */
> +       return nr_to_scan >> sc->priority;
>  }
>
>  static bool should_abort_scan(struct lruvec *lruvec, struct scan_control=
 *sc)
> @@ -4998,31 +4984,43 @@ static bool should_abort_scan(struct lruvec *lruv=
ec, struct scan_control *sc)
>         return true;
>  }
>
> +/*
> + * For future optimizations:
> + * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for mem=
cg
> + *    reclaim.
> + */
>  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_cont=
rol *sc)
>  {
> +       bool need_rotate =3D false;
>         long nr_batch, nr_to_scan;
> -       unsigned long scanned =3D 0;
>         int swappiness =3D get_swappiness(lruvec, sc);
> +       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>
> -       while (true) {
> +       nr_to_scan =3D get_nr_to_scan(lruvec, sc, memcg, swappiness);
> +       while (nr_to_scan > 0) {
>                 int delta;
> +               DEFINE_MAX_SEQ(lruvec);
>
> -               nr_to_scan =3D get_nr_to_scan(lruvec, sc, swappiness);
> -               if (nr_to_scan <=3D 0)
> +               if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
> +                       need_rotate =3D true;
>                         break;
> +               }
> +
> +               if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
> +                       if (try_to_inc_max_seq(lruvec, max_seq, swappines=
s, false))
> +                               need_rotate =3D true;
> +                       break;
> +               }
>
>                 nr_batch =3D min(nr_to_scan, MAX_LRU_BATCH);
>                 delta =3D evict_folios(nr_batch, lruvec, sc, swappiness);
>                 if (!delta)
>                         break;
>
> -               scanned +=3D delta;
> -               if (scanned >=3D nr_to_scan)
> -                       break;
> -
>                 if (should_abort_scan(lruvec, sc))
>                         break;
>
> +               nr_to_scan -=3D delta;
>                 cond_resched();
>         }
>
> @@ -5034,12 +5032,12 @@ static bool try_to_shrink_lruvec(struct lruvec *l=
ruvec, struct scan_control *sc)
>                 wakeup_flusher_threads(WB_REASON_VMSCAN);
>
>         /* whether this lruvec should be rotated */

It's a nitpick, but with the variable rename, this comment isn't doing
is much good now. :)

> -       return nr_to_scan < 0;
> +       return need_rotate;
>  }
>
>  static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>  {
> -       bool success;
> +       bool need_rotate;
>         unsigned long scanned =3D sc->nr_scanned;
>         unsigned long reclaimed =3D sc->nr_reclaimed;
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> @@ -5057,7 +5055,7 @@ static int shrink_one(struct lruvec *lruvec, struct=
 scan_control *sc)
>                 memcg_memory_event(memcg, MEMCG_LOW);
>         }
>
> -       success =3D try_to_shrink_lruvec(lruvec, sc);
> +       need_rotate =3D try_to_shrink_lruvec(lruvec, sc);
>
>         shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
>
> @@ -5067,10 +5065,10 @@ static int shrink_one(struct lruvec *lruvec, stru=
ct scan_control *sc)
>
>         flush_reclaim_state(sc);
>
> -       if (success && mem_cgroup_online(memcg))
> +       if (need_rotate && mem_cgroup_online(memcg))
>                 return MEMCG_LRU_YOUNG;
>
> -       if (!success && lruvec_is_sizable(lruvec, sc))
> +       if (!need_rotate && lruvec_is_sizable(lruvec, sc))
>                 return 0;
>
>         /* one retry if offlined or too small */
>
> --
> 2.53.0
>
>

