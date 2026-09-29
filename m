Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52F8CC9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 13:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466466B0088; Tue, 29 Sep 2026 09:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4069C6B008A; Tue, 29 Sep 2026 09:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8EE36B0092; Tue, 29 Sep 2026 09:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0BE6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:43:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 051661C2B63
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:43:12 +0000 (UTC)
X-FDA: 85266916266.26.CFD25F1
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf18.hostedemail.com (Postfix) with ESMTP id 154C31C0008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:43:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oFpGHkFm;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790689391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7jnymnyh4wNs1wifMEqk5jjYIJtuGqcqWV2+z65JOE=;
	b=pLMvIlLoeW0RxDSPXgQrMHo2U6fTltQhNr6WOBjg15z4+3PN6HmxpWxoEkHHEBYqgVK7nA
	hrsXjMAvEUGk8bTQFF9CZBYE4ifNrXvP5ojw2gpsgWmc/JAaQaGuEViryTmv7Oa7cxYV3G
	7xS8gLkNR9NjPB8I9MhVTi0hJ3YwSgU=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oFpGHkFm;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790689391;
	b=jttnhxJFcUY68JQjk7ZpWNAHZa7BqMBl/+nRe5/aVdQkbywuH9Y2lHb5S+lt07uYw7FDDY
	Fcq3Re2pg3UhQTPlqZOaONmrm33i0mEOv6Jt8XGEFdPCI0aJqaxNEQo0D09DM/GvDNb+9Z
	zP676QzQevoIsi1JW3RMJjCa/3KK0Yk=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d37b6so23017805e9.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:43:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790689389; cv=none;
        d=google.com; s=arc-20260327;
        b=aNLqTkaI4VVtWcF45niBPghsZZQiXIFsdnOFIZKYdqwsCOm8GAaup0C/5/FPKlR0hu
         aBgbbYHtcET5ZpZZ8MKBCNOLk+OAJf7UyD/NGu9ej4J5Bulk371XB/umIfyevnRD2SnZ
         14SKYAzPIwUmiAxsRzBXpvmiWALG60IcvP6WBw11weSOiWsudEcIHyDPFXl8Y2cixB7j
         8OocEWikbWIuTWYSApy7RDM1vTKcL6G9A5aH+3CIWsdmWmXVlDPSlDWPR9hs2xzS2AX9
         xqVKGy/tnjSL5r13S1Jg4JZ9am8RfzesRK4wu/80RAfTlHOQfA9adcXyMTgXcR79qRjM
         MB2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G7jnymnyh4wNs1wifMEqk5jjYIJtuGqcqWV2+z65JOE=;
        fh=W5rx6LIgw4lBGNGxy1ER8nSV3TSt8F5jyN4sHmBydQY=;
        b=qoy8x7QZgMs1NvMFRlJ3scGj4Wstr0kw1TZRI67C0tVqAzh02P+YyN4Gln8wnO9+qn
         3EI6yxrnlIxiEAc4/3VOrwPaOFyZNy8b658o+yTPSFQGH+NxSzqhixRBFxWvsxJ3KeEp
         O7faN8pHUdUOT6E00J+Ym22qafCXUdsnLNWTDd49mLkEbxHxzpxbPNpgwPb6L2ADtpUM
         nMIQ9mKvTm+1pEkxca/xstV2Bi1l9VcL4qUxNY0NQMdyGUhgAUuSY+aoSvtEM4FJvSFF
         XTbg6xh77T/MFqcxKlhielG5uq78FoWPFAhxE/iv9M4mMTsvLxaOWQQvccOOTU6LVzyM
         d0PQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790689389; x=1791294189; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G7jnymnyh4wNs1wifMEqk5jjYIJtuGqcqWV2+z65JOE=;
        b=oFpGHkFmCx99NtgQMYUZHIuvu9kOLiZLQEdUt6MmJZiaxDLJ4BVcHt8hxTz6t9HOja
         M39q4vXNXPa7VA8dhJpUvCvrbxRsM0Aa1UNdxAbTEvj8G2d0Sw9BVL1O03XpxkYe12uF
         rnMamB5EpwwlqFVkUofZpPAagHGHdwDdDQMcKv9qAxrUZfsWp6ft+kRYoCv80GfzOP7+
         NJFFjtExSeEcR79X31gtw1Idko0qnWlCWQI4tjvNz9lk76EkYAOeTgZciM8qvlOHcXPY
         OgzLHeE6T387nW65gEqnV8sYN80BDLggpfV1Jnt8ikmkXrY11b79e0B68aECx7Zqv5de
         Imvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790689389; x=1791294189;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G7jnymnyh4wNs1wifMEqk5jjYIJtuGqcqWV2+z65JOE=;
        b=x058EjJQXFkek/+DLRxgWAHvTGNf0BG39kVcWnFTLynvF2YxjTNZ0omHq37s2qoB3f
         XwQPm13xIgkUrO8HKIVl6RkEcRn1s2RwA36B19ObHGXpMLletsf7HdF3faj0jmY99u6R
         JFbq3IVR0tHHVVhCRQKSrVh9MSlDYJIuckwN8dm6+TAUCc4O2u4u/lj6oN0J6Kh7UowE
         H2OggYHhwKH89XGA2rVzQBmdpOkGw70AeTalkoDc8n1WQpmBb8DUHtcICcs9JFKnFmAe
         jhByn6dqBD43pFJcpgGevPjp6n9hVdhMt/c43oiIFd3l4TFieZqgxX3OvEU63vgbcfRj
         Eu2g==
X-Gm-Message-State: AFuF++mvbdL+cToQVwo7OBLiXrH68PqHF3tDtSiz01BqXSaTpK7J6YC8
	9gKERDMvgiTUXkAsmXZY18xeLF7NbJyqVvS8Q4Ry0TpW0PZ2T5R17OaASPcEpTb5VpXpQPjJx7n
	7SFONdxgj4qFxoRaLXv4g6RItxYnBthA=
X-Gm-Gg: AYBFou1HtK3VMqd0sJptWJECPKedpWR1h0Cezvp5pVb9yZ4Gk8VBtnfdiR0UoSlNtMF
	iSsk6IOC6kpCVL/T5GlzPp2ot88cuMBfQqTTogBSlnZYH0BAY0N7npJJqRP4lYAf6swOppBTgTN
	ZA4Oox/smEmVNAVQPI+dOCeueJJhBFpXsmWLSrV64tP61L4nGQq3LmmVidoR+YgpUAO0NJCOkFT
	I6X5gaXNyORYgmLkpDVk5mVTnKGM+1pMQx3PGnapLJNnHHxZraWkbyj8yJMF9PX5YIbhJUUPMJ9
	TDBWB1G+alXsJX0D4zzyQ976FpXefGUDz0haRshxRN5UnP6NvIa7DeIkvaJV9bBH6NFtQXo09Wf
	/wHjHMWhU5mTSYf5UUT0bNSnsIgY=
X-Received: by 2002:a05:600c:4f12:b0:49f:ce78:356b with SMTP id
 5b1f17b1804b1-49fe6700d0cmr318694515e9.28.1790689389342; Tue, 29 Sep 2026
 06:43:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260928081900.4187482-1-alex@ghiti.fr> <20260928081900.4187482-5-alex@ghiti.fr>
In-Reply-To: <20260928081900.4187482-5-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 29 Sep 2026 14:42:56 +0100
X-Gm-Features: AclHuK-OCCz_Kk4JrZVxkgoxQbXuwZbmMTzsZTD2RNK7ANS1v8asaSklELSJmjw
Message-ID: <CAKEwX=PJjGe3kjYCHwxijaZ+W8HvOiNQTTS-Da1R02hPW=kCDA@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] mm/zswap: move reclaim-driven writeback to a kworker
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, cgroups@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: j1hq9hfump1cacuzrawks6ux831k5947
X-Rspamd-Queue-Id: 154C31C0008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790689390-18147
X-HE-Meta: U2FsdGVkX1//OeBdLvqSYBWTJL1aTDAKYkRMQd27Ykgwr1quB1RPwlBAGZNq7RVhwD41QgqGpfdyvypsnU3nN7bJoCc4xa26Kh+F1waT/vlR3W7iFsso513HrhK3tNAcFnZdnAzOORMt1Fyjl98PqG89rQkUpZA5vzqDicFPRuadVRCpEt3IlWusvWvEjOeCFm92LF42SKNst8X1/Ok1cJxGB8+aL7NSykS56c5T/N/W2ikJ8TkaeA94DpK59+1Eb/EwtP4HF+s062cTGM+D8NPqrrMVDFeMEmh3nEQa7PYH6dUr+Gkb5nFBvcfUYlBzsmpbixk2+wE6KPE+Ql3rpeu7QMaw/rFRo15CjYGsYbwSrYIwXiRUNLJwfENG01ueek3hlaVg3exUYhHgo+TnWsIaRH61BzLE+HAPjE/M6ogJbR/W65qtDoirRkbs8oMD3lHYTniH2y3MOIv6gZoqrLrtLPHeMqmsrlfYYT7mJBFbULWtGYGISsizyWD/B3jVzODx2h2DX481gH7LsmYi4+/AYw9cd0XQWyTyTg8WeKOWM1fLMQBI97Dr3Gkf7TMZ5EudZx0jXcuXSSycEvp8qHGruz6n9o1g2RazOhGJAejZwlmI4DxBNIGi0RK0ncco9KGHuBaQeilpn24dCxbJWTVqxOl3X/Ia6M0aLAik0gSNatPkVGQEA/S2lIQg8MKX0OWFo1XwsBtqvM4+LBHGltUHGiW7y+1cjzkNuKxbqW3gm5zOCSnnHZH9lUqgyv+ozcK9tZvVW8MS2GckAJa9UBrRXlf+Un/aempQ2CaWwdTH1lW38fm8FNMEzOzHpFUILstCH8Axi08/Z6E6UV/3HngbcmsFHGFJtejEO2KFKggLEUhj0vgS9gXu1LDLWiWIEs0+2iAQeDEQpRbaFYCngC+TyRxEx+sNBiyZ+v9LquZTkakQarJGoZ/9vxt7wsbOWmhxucytzxkl9xGjsIX
 AfWzG1rE
 6n8bve2slkMvH6k3Kbe3I0BaW4mYgXTJxCjVIiPDGXQCiVbrcq8CQgr5AGcw2BanGglvyT12XILSf0/Jnsrgfsr1atEZMFlin3SZTye8FrSZ6xhWXYgR2O4G4egtU/QAMYnIdeymw/hZUATWec+CPKgtAqB04eXT9PonQy4AikraoxUeirPcjnGhN6YNqYnFbewsKfozGREMaR5DJXO5Jmju+H2XKWH5Td3Gb1L8em9UZWC4OHquNdnld4RmB5O4GB3UlqWvicmAdZKb2BNBISSStl7eYxe7xMneshwtUYGo4k839cSgtWhaaFwfCgNLcqlQLxR0VMvnqgmGF8uBN+CPYctFBrucHzm4RcpkN8CqCEh4oqmm7mljr5vEpu0AKA0A7UvtocDEMRaqSCc0FvXlUPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 9:23=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:

I understand the problem this patch is trying to solve, but this
solution seems more involved than the changelog suggests :)

>
> zswap_shrinker_scan() writes back in whatever context reclaim called it
> from: an application thread inside a page fault, or kswapd reclaiming
> for the whole node. Now that the cgroup IO controllers throttle zswap
> writeback, that context sleeps uninterruptibly until the owning cgroup's
> IO budget allows the write. Such stalls were observed on a large
> production workload.
>
> So defer the writeback to a kworker: each lruvec has its own work item
> on shrink_wq, which writes back what reclaim asked for, SWAP_CLUSTER_MAX

Ahhh, so it's one work-item (added to the shared shrink_wq)
per-lruvec, not one kworker or thread per-lruvec.

Hmm, supposed multiple tasks in a cgroup enter direct reclaim. In the
past, the amount of writeback submission will scale with the number of
tasks entering reclaim. But now, it's just a single work item
per-lruvec - IIUC, the submission of his work item is idempotent, so
it wouldn't scale like that anymore, right? I haven't wrapped quite
wrapped my head around this, but this sounds like a non-trivial
effect...

Also, do we need to defer writeback submission for proactive
reclaimer? Or kswapd? Only direct reclaimers have concerns with the
latency blowup from the throttling right?

There are a couple more behavioural changes, without proper
justifcation or mentioning in the changelog. More details inlined
below:

> entries at a time, while holding a reference on the memcg. The shrinker
> does not queue more work while the worker has yet to claim the previous

Why not?

> one, and reports nothing freed, as nothing is until the worker runs.
>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

[...]

> +
> +static bool zswap_defer_writeback(struct shrink_control *sc)
> +{
> +       struct lruvec *lruvec =3D mem_cgroup_lruvec(sc->memcg, NODE_DATA(=
sc->nid));
> +       struct zswap_lruvec_state *zls =3D &lruvec->zswap_lruvec_state;
> +       long old =3D 0;
> +
> +       /* Do not accumulate work: back off if the worker is lagging behi=
nd. */

Why not? This also has a non-trivial effect on the writeback amount...

> +       if (!atomic_long_try_cmpxchg(&zls->nr_deferred_writeback, &old,
> +                                    sc->nr_to_scan))
> +               return false;
> +
> +       if (!mem_cgroup_tryget_online(sc->memcg))
> +               return false;
>
> -       shrink_ret =3D list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_=
memcg_cb,
> -               &flags);
> +       if (!queue_work(shrink_wq, &zls->deferred_writeback_work))
> +               mem_cgroup_put(sc->memcg);
> +
> +       return true;
> +}
>
> -       if (flags & ZSWAP_SHRINK_SWAPCACHE)
> +static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
> +                                        struct shrink_control *sc)
> +{
> +       if (!zswap_shrinker_enabled ||
> +           !mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
> +               sc->nr_scanned =3D 0;
>                 return SHRINK_STOP;
> +       }
>
> -       return shrink_ret ? shrink_ret : SHRINK_STOP;
> +       /* Nothing is freed until the worker runs, so report nothing. */
> +       return zswap_defer_writeback(sc) ? 0 : SHRINK_STOP;

This will have effect on the shrinker control loop too, right?
Shrinker API accumulates the number of writebacks overtime based on
shrinker_count()'s output, and we serve that number of writebacks
throgh shrinker_scan(). With this basically that accumulation just
grows over time, correct? Check do_shrink_slab() in mm/shrinker.c...

Feels like this completely breaks that control loop.

>  }
>
>  static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
> @@ -1807,7 +1897,7 @@ static int zswap_setup(void)
>                 goto hp_fail;
>
>         shrink_wq =3D alloc_workqueue("zswap-shrink",
> -                       WQ_UNBOUND|WQ_MEM_RECLAIM, 1);
> +                       WQ_UNBOUND | WQ_MEM_RECLAIM, 0);

This turns a single-threaded workqueue into multi-threaded workqueue, IIUC.

Worth at least an callout in the changelog?

>         if (!shrink_wq)
>                 goto shrink_wq_fail;
>
> --
> 2.53.0-Meta
>

