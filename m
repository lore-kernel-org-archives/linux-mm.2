Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA9E1EDA69A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 04:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7A2C6B0088; Wed,  4 Mar 2026 23:45:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A289E6B0089; Wed,  4 Mar 2026 23:45:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DF616B008A; Wed,  4 Mar 2026 23:45:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5FE6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 23:45:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B03DBB4FF
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:45:58 +0000 (UTC)
X-FDA: 84510771996.20.43349FE
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1AC57160003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:45:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=noa0goaa;
	spf=pass (imf08.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772685956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqjw/P8xBjvFVPu7VOJlzQ42BZVaj8vKem4uQsK6qDs=;
	b=gD2AC3GuNiq1s5DpUqqFKVgPKNYLneNYCS50mnFyDEtGBCXELEUJg1A6LAOppFdoS+tBue
	qV3nz1cso2UJKzC4gGy+5RRZEu9B0jcK4Iwn52I89aJODMbTN9Xgh9PHdKFeMvnmWYheQ0
	QOnm1nnAN83RwdBHMeO/0azIsSoy03E=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=noa0goaa;
	spf=pass (imf08.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772685956; a=rsa-sha256;
	cv=pass;
	b=vRlYcnvI3GDfKbG1h3829w7oYp6gKqWU48akWKsXmu+j1hCu5+bJVWNnz1uq0FUVoMSa73
	1FpT8HrLnHhmqxrreE7gScZGZ+amukzfYTrivs5O+dYWnUIl9Dy/vV1yuJibsEs7KsHOnk
	Lq/tQsI7Rxq8SSqTl33Zeer3l0Gax7w=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-899ee87355dso57614726d6.1
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 20:45:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772685955; cv=none;
        d=google.com; s=arc-20240605;
        b=dG63nbevyZ8nD0uDzvw9HN1NTIrOlrPbWc0nfGx3HnnkncMRaMdk56zloXoMw5eP9J
         oezLkpdHrneTA/DSBxGCdIVZJGoNflEbyXqoTB5bq1LlirhM6sUgCJ9fyhX88bwZeK8c
         cKniEsByQKIHRF3oaM3igrUmSedSv08/bm4DHWA/0Q7YyiIn9y7xjw9Mm6BgayjEQ4BD
         RKKfrBniQ2hE+AOhdB8ILY1QrErBRoFAvdgTg6QKq8UeTY8QZxTct3kS+55mGmIdLG0v
         9miY1ZCku+CraBPSXPhTCseiaTusKu8KB6XZkddqOG8fONxMIMgROReK5/jlZQEqeK7D
         d3oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vqjw/P8xBjvFVPu7VOJlzQ42BZVaj8vKem4uQsK6qDs=;
        fh=o6ZI2nLWFkn/qpEbT9iGg3UoxcxQc1O4VQRquPtlLgI=;
        b=kkJNnYLHzzM/Tht9GClp5tW9cP6jD+4GXHFvPF37mz7LJgacssrNypOhxoYh/5lzjX
         3y7JkimXwPzYQh5Al3HNNYaaqQTY1yRmTvsfw4YW94KVo4vGN5gT41XrBKUA4MWkD27d
         wQZQ74e8H/8BjkWQwkUOtaYMeFdkTJo2k3OrDMZA6rx3eNXDDdZppGKJvmxV37MTLT3G
         /yFuL5C7md2/+8Oi6QXx3VIwqTYLSy58mOWwxAwdkxureMkwlluQXmaqzNQVjkHsdOdn
         hzMnidriQY5LnfpM84TEoQx769t/uKqs4YEOUgBXdg0LWTNOZwfWTR2sZtmbsgzG2xD6
         lX7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772685955; x=1773290755; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vqjw/P8xBjvFVPu7VOJlzQ42BZVaj8vKem4uQsK6qDs=;
        b=noa0goaaFeFN8i79vT0HCy0UQbhimTneU8eP3TkcaWCETr1JBrDxTI0H/pBTBAf5hK
         pntNWH6bKA6AiO928MwhqBTlR1op0GTTfyRU2oZwWnjPj7HpQh485WhcB0YZwvJrdENO
         YgO1swu6/SSoKLbZYzH0HcHWbM1SgAd+N3uLrPFMlRaR7y0kG+erF+YUxQBUwoI+vTjr
         XX5d4DR1hF1NBernv6D5e4MFJtlTcCzqGy/0wzve/B6WF6EUalZgqCiGOd2qqGeyuCg3
         Dqea+1fEYzapgzPk+333A8bmoAmSNq5X15XYNZv3ql2G/4rwc/teUd7cWMOFuRFxoeoF
         pCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772685955; x=1773290755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vqjw/P8xBjvFVPu7VOJlzQ42BZVaj8vKem4uQsK6qDs=;
        b=ur2zTQMvSJuSeiWDmcvM9600GCZ11D2S9/l4/l783Oe/a076rr6B2WYYZ3Dh8F0+xZ
         U8XTNzLBSPCq6vHuVfzi8cPaWyyXRcfS7fJWS9hXS47eyGGDU5eOpBGlohoTANGVO9j0
         tK0ypRITdEe3EtwVMAA2MA1UjypNaJMNSjxtFGM+yv0qo4pUP9uq6kqFyWXAUmKp6Uc2
         SLa5WOAUq4LuBhVDFFRWtOr1NswT6LiMuYp7ZkIhtcGfw9cibOMCoSiExtwzXpGszZwi
         fY9HAh3gAg/0DnB4tWQtKvarBCiMf5hSarSgWjEl18B9bfLV5fTY9+bjA8BnnmTyMeFv
         qQog==
X-Forwarded-Encrypted: i=1; AJvYcCXbyXkDvpsdIPeRu6jZLY7ZkcC1KiYz7PULVQFMvN3NXW5rmxmOGMHTrSh+u54z43uexckFGP18wg==@kvack.org
X-Gm-Message-State: AOJu0YwotLyCCrbQwHjqcmnsAcoUZdphaHpwYSSH2G9pQvMU77ofUxgv
	us2qFaP0YI72wT4FJqBpKYmjU0Wy2CNbmcG3uNDqC3TvKQf/vthuISiVYBut3Ta1RFRQXyfRxLk
	t73oZ62S8GdlYazyd9b6rNZDFyJs+T70=
X-Gm-Gg: ATEYQzwNffYauxSpr+Wo8J5AdEubZFx2jR7mF79sOVKsUfYNo9Zvv4dJo6NIFgHGQJw
	gitK+glok4J2o1QxTvX1qNSUdRO9B5WML2wWhtSferA/65654Y6bLLWnlDXWJ2bHQYD/1xtBN6c
	ILQsqMAwvDqTZ4NEFtwaObBtIcI8HMruLR98kKxsSx9ihAvkhmcNc4I8eqsRyuav84Kxaocg4jv
	v8A5tn1rAf7hD0jXP54OaCtVkz3Seo3claXyAL9qGLu+pRhbZjCCXf0NDZBsk7UJfSfn3IOHUEm
	LLTwfRQUC3+Gaixu
X-Received: by 2002:ad4:5ecd:0:b0:89a:3bb:3c45 with SMTP id
 6a1803df08f44-89a19aee48fmr72084406d6.33.1772685954912; Wed, 04 Mar 2026
 20:45:54 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
 <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
 <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com>
 <CALOAHbCma=SW4nu_GPv_pbuuXv1V5JPB-9cA3z1TeemWqU68tg@mail.gmail.com>
 <CAGsJ_4yAkaqqzSu7SS=_fgZ_AQCqtbv8LmuPGCb7SiFpGk4csg@mail.gmail.com>
 <CAMgjq7AkvgzW96-JQzEg5c4oW0cMsjPHcCnukCUZXgSvXL4-DQ@mail.gmail.com>
 <CALOAHbB3rQ2b7ABqFegt2afYRL7KjpWREucrhOYfTT=onV1+Gw@mail.gmail.com>
 <CAJj2-QEO=9Nt+HP6m=xtFD8qcXCdGCRmESmcs0haeiMdqqTA1Q@mail.gmail.com>
 <CAGsJ_4ynhyROTMsy1m3AZNsAzFsjZY3EYpSOSTLR0dQSxO+akw@mail.gmail.com>
 <CAJHvVci8nc-yTHkAbSEQQtqkRvgATJWcSTwBCY49A5W4AQcd7Q@mail.gmail.com>
 <CALOAHbC0XbvG4OCy94j+ZUyTZt65QB0Y=p1UwKvGcsgcWKy7mg@mail.gmail.com> <71281163-F081-456F-AFB0-37DC0470850A@icloud.com>
In-Reply-To: <71281163-F081-456F-AFB0-37DC0470850A@icloud.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 5 Mar 2026 12:45:43 +0800
X-Gm-Features: AaiRm50jhwY8uCVcJhYNlLo-8R6Rm9EzauWp50Up2YRcFMIRedxN4_4Q_8ecdQM
Message-ID: <CAGsJ_4zsM--Wzn6-EgRo23uCaii0bszFfRcuYrrKf=-cHgKmGA@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Bingfang Guo <bfguo@icloud.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Kairui Song <ryncsn@gmail.com>, 
	BINGFANG GUO <bingfangguo@tencent.com>, lenohou@gmail.com, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, weixugc@google.com, 
	wjl.linux@gmail.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: byamt6bjspocppxoz15srzha4yd1wxeu
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AC57160003
X-HE-Tag: 1772685955-510827
X-HE-Meta: U2FsdGVkX18JvcV0IreP/ik+cnoSEQAPqrTgOJsl2c/i/gM64MMCVlKRZad+9BREVg7zoaQ3TzBXyClq+ECCHJFradNIdGUuzic4N/lzBG9kj5s0AcBNQ5rCNZBaijAWfE5nwO7Zmi+Bts8weMlKjMFNzPt+ltEEeTidjZhcMz3s1oomiK0fEoWAFyuIw0Evp2HuGBSVCp5+aSjyrXk2pYHMWeVE0623bYDfc94+sCfKOYsK8ZNTW781IHnqITcXYtvEQKA7E5Xp7H4VUJxP/aaMMQHJWNaPKuSpQiJjjePhYPRsbLzeYUOJ2YfbU1h7FIazC7rUNPwOqI45utYMfB5dhC51+6Vs3YKwTeT2S6yh6zPljvQwytB3BLQeuQsRQF8jz90sMyyhu/jrIFDx54e6mN+H0d8QGXhazWRm024DHnq4rgw3p6tAnHXjEvVPYcplEKDVHgU+9wvJ8jptpXwMnAB0W6iHtZ4Cpvnnwn0V32itK/XHxLpIT7WbElcEWURV7OuY4o84fsXwDzOg0cERum3j5T9ZUY+cjL2usfu2tdswOM/v0xT7MctVlJ1BFxgK6nfRhYyO7rq/OleAaoiGrJlU8VJS5E2c4gwMWM1KiVkGAEArsea/kZAa3C+gfhN1Bpyq8qqclkbhlq4wRI+FlJTfZfeluqyTHJCa85S4sbsHaco473/9atzH8V5+YomnYJOAgSC2u42RX1/Yib7eebGtgIxDFjPMdI7Ai1CotfxpBjc9ZIOaKidpv4vvS0bWTJicZunlBFE2SXTTolzqSptp7B72uTPwsRQPF4VZp+XYBI1I353f1hMYjunL+SIXcz6GAz1jhSyD3vJ4wXQ3pdN0TjVvNa9iMVV3gXTh3CF1nrXGRHNLXn4FOn/geDI0Vqwo8tnuX3da/8DVGXX1XSp24YRMfvpNVe/PNE1Hq9IH/OfKzPLTAdhFTI00CWulVL7Isvg6x+Ot0nw
 zFKETtVG
 2EkVZHmXGWT4UT6y6ntw35nrisuZGjp9gbjDz73yaKrWXKXws+oIX8hH0xsSt7c+jxfIdrWyCy4MWPa2CFLaHYcfkd69Ma5TOS7M8VPE00EuvV1T7d5b/3vBzcOHk2DO/5tKkUGSI5lZeoqhJB9G0rsF7ahzCLFaFSBIaCgBTOP9KmZzwJh/Kx3EmLuVpideVZ36AKtbJ+BmNiLD9lZfhtWlQfn+tJUVCEomBOecxSo/lEpy1FySMK/hgNfDHLeAdw43mNnYQMETzj/uGqty593sHJHtsIToAC9Pdg3qSyLobgpHsu5MA9C9x1fUsPOZp326m0cZe4hY4QYb4V/T9ARs4uXuk1ZCbFRzvvOryaNc1+9RUJhPinS4eZmpjs+A5QTPT5hPPDRKcX0n6TSqzTC+OpClAk3Cr9LZRSwOm3fx7etc4bqBmLgRgg/TjkkyfRrs+zRj6eLKa1Z6tREJOBHCk0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]
>
> --
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 614ccf39fe3f..d7ff7a6ed088 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2652,6 +2652,43 @@ static bool can_age_anon_pages(struct lruvec *lruv=
ec,
>
>  #ifdef CONFIG_LRU_GEN
>
> +DEFINE_STATIC_KEY_FALSE(lru_gen_draining);
> +
> +static inline bool lru_gen_is_draining(void)
> +{
> +       return static_branch_unlikely(&lru_gen_draining);
> +}
> +
> +/*
> + * Lazily wait for the draining thread to finish if it's running.
> + *
> + * Return: whether we'd like to reclaim from multi-gen LRU.
> + */
> +static inline bool lru_gen_draining_wait(struct lruvec *lruvec, struct s=
can_control *sc)
> +{
> +       bool global_enabled =3D lru_gen_enabled();
> +
> +       /* Try reclaiming from the current LRU first */
> +       if (sc->priority > DEF_PRIORITY / 2)
> +               return READ_ONCE(lruvec->lrugen.enabled);
> +
> +       /* Oops, try from the other side... */
> +       if (sc->priority > 1)
> +               return global_enabled;
> +
> +       /*
> +        * If we see lrugen.enabled is consistent here, when we get the l=
ru
> +        * spinlock, the migrating thread will have filled the lruvec wit=
h some
> +        * pages, so we can continue without waiting.
> +        */
> +       while (global_enabled ^ READ_ONCE(lruvec->lrugen.enabled)) {
> +               /* Not switching this one yet. Wait for a while. */
> +               schedule_timeout_uninterruptible(1);
> +       }
> +
> +       return global_enabled;
> +}

Hi Bingfang,

Thanks very much for sharing. In my humble opinion, the code feels a
bit hacky. If we need to do something to reduce the probability of OOM
without fully fixing the issue, Leon=E2=80=99s approach=E2=80=94trying to r=
eclaim from
both MGLRU and the active/inactive LRU during the transition=E2=80=94seems
less hacky, assuming they show the same likelihood of triggering OOM,
while still leaving some race conditions there.

> +
>  #ifdef CONFIG_LRU_GEN_ENABLED
>  DEFINE_STATIC_KEY_ARRAY_TRUE(lru_gen_caps, NR_LRU_GEN_CAPS);
>  #define get_cap(cap)   static_branch_likely(&lru_gen_caps[cap])
> @@ -5171,6 +5208,8 @@ static void lru_gen_change_state(bool enabled)
>         if (enabled =3D=3D lru_gen_enabled())
>                 goto unlock;
>
> +       static_branch_enable_cpuslocked(&lru_gen_draining);
> +
>         if (enabled)
>                 static_branch_enable_cpuslocked(&lru_gen_caps[LRU_GEN_COR=
E]);
>         else
> @@ -5201,6 +5240,9 @@ static void lru_gen_change_state(bool enabled)
>
>                 cond_resched();
>         } while ((memcg =3D mem_cgroup_iter(NULL, memcg, NULL)));
> +
> +       static_branch_disable_cpuslocked(&lru_gen_draining);
> +
>  unlock:
>         mutex_unlock(&state_mutex);
>         put_online_mems();
> @@ -5752,6 +5794,16 @@ late_initcall(init_lru_gen);
>
>  #else /* !CONFIG_LRU_GEN */
>
> +static inline bool lru_gen_is_draining(void)
> +{
> +       return false;
> +}
> +
> +static inline bool shrink_lruvec_draining(struct lruvec *lruvec, struct =
scan_control *sc)
> +{
> +       return false;
> +}
> +
>  static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_cont=
rol *sc)
>  {
>         BUILD_BUG();
> @@ -5780,7 +5832,10 @@ static void shrink_lruvec(struct lruvec *lruvec, s=
truct scan_control *sc)
>         bool proportional_reclaim;
>         struct blk_plug plug;
>
> -       if (lru_gen_enabled() && !root_reclaim(sc)) {
> +       if (lru_gen_is_draining() && lru_gen_draining_wait(lruvec, sc)) {
> +               lru_gen_shrink_lruvec(lruvec, sc);
> +               return;
> +       } else if (lru_gen_enabled() && !root_reclaim(sc)) {
>                 lru_gen_shrink_lruvec(lruvec, sc);
>                 return;
>         }

Thanks
Barry

