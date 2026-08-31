Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C65C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DAA76B0098; Mon, 31 Aug 2026 11:20:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B19F6B009F; Mon, 31 Aug 2026 11:20:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CB0E6B00A0; Mon, 31 Aug 2026 11:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1CAA6B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:20:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6530F1C083E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:20:35 +0000 (UTC)
X-FDA: 85161926430.13.CDF4C40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7D4BE140011
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:20:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iypM/nne";
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788189633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6JFS2kLm337yb3dQKB2DDrEUSXPoA2CmSEWj9anOX3g=;
	b=O2ClRH1ZnVWN4pE+Rd0t7rf+RPHm4wbXQA++YNSMnaKbkkjdAX/PaORbByEAcioJH/c9tK
	RURKMcC3Q6h80Z9PBZw10FW2rCB+Fk0wx/Xu8wRd5vGFAEq6RniaUsmHgPzDSD2578r3/P
	f0HVe2DJjQ9+5rlFtB0iMMO9tTUQfqA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788189633;
	b=Q82VBb/sCWQFph1UBThVBVUVNASeL2If8kYmHXtVOZbUadNXFQEq/Dt2AhjatqZMkJbwUW
	P/l7xDMd17pak0mIbaOdf1U87F/6tRP6Il6LF62NJ2gfV9iqADjQ/1PDVHROlWLJoVVKUR
	+AvIgXTiyC2DF3ZGj/iI4B25lVN2Doo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iypM/nne";
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A66BD6020C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4AA1F00A3D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788189632;
	bh=6JFS2kLm337yb3dQKB2DDrEUSXPoA2CmSEWj9anOX3g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iypM/nneyqTV8PgsspEKnf2poc5c/P9qC9IxC2HCr38g3z5G/mIEQrrL/fiuumO1N
	 r5uFBdQE/LmbI0lKGrtyud/v+OTzbgepB4R1uEQmtZ380KdTWY8iuc7tFtgC1GfYiO
	 BPWAf7ZyJsi51rlImpK83UyKd2pe/cGQanlcZxptck+2ruvnCCEeR7Cv5oJtVcvgxj
	 wOuF3b6qjEQZqulPNGbK2sAnxNBE8OaXu6m9lJUiE/2vbOmJ81YBsGnVNIsp7PHdyA
	 +L3P00j+BmRSKQNJOQYeXWGfCLF95nWLEsw9xCHPA48QW/eBSoAY9Q/Qxuc0o0999J
	 QHeMnHz8uyRhQ==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c1600d040e4so618197966b.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:20:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqFPj4nn5FGVmzCzsWUVH0LbjMxaYJ6ebgZeZmgYEmkAqjAqBjGEXc2IDZW21xmYusDoNJfd9dVbw==@kvack.org
X-Gm-Message-State: AFuF++kD/CqWT7EmZT0luUfqgjl99dGEDo9hDSGj4s8JDuCHgQOvP7kf
	pw55bdl6yE4ssCAfVLajy5QTA3ralrUx/R5NC6Wb1NFkBkq4cKsZe3+Awd/ZCG4ypLUX823TMVk
	fsVqQrTx0/Wek0ZqluPH8cwNHiyOYGew=
X-Received: by 2002:a17:907:930b:b0:c12:8a:7d7b with SMTP id
 a640c23a62f3a-c25966a3bb1mr478179866b.1.1788189631212; Mon, 31 Aug 2026
 08:20:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260830114731.8322-1-wujianyue000@gmail.com> <20260830114731.8322-2-wujianyue000@gmail.com>
In-Reply-To: <20260830114731.8322-2-wujianyue000@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 31 Aug 2026 08:20:19 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPYZqZ9UsSU9xVcB6=m-uTkucSoPvA5xCB=mMrb9yVD_w@mail.gmail.com>
X-Gm-Features: AcwNN1UIzSfb5LeEBaceBs3HLojJ5C16n921xYexG7UOvAbwQ2-o_vxM5QWB-3s
Message-ID: <CAO9r8zPYZqZ9UsSU9xVcB6=m-uTkucSoPvA5xCB=mMrb9yVD_w@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/3] mm/zswap: release retired pools via
 queue_rcu_work() instead of synchronize_rcu()
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7D4BE140011
X-Stat-Signature: xdicso5noq8t3nmb1txg7ad7zeda8nx4
X-HE-Tag: 1788189633-288354
X-HE-Meta: U2FsdGVkX19nFY7zhlY3M6QTeXzT49HKD5ekiJIbXs028h/fR+FcVR6GoAgdeNjNARWjqclAzt24/junxlDyfVU8sLqyUtjZAn6ErZQTkx0WGyTcCBn8X/UmtgreNeiOkOqkSeMeYDvdGLVlLy3nX1kVBbv7zjsUwKgVWxbp/P/evnenA9RuwDq4uUtKM4XZnNLuiohcSR6hWL6fZoLHBLvm+B1YrYCBrR71gPhO8OVov0RlV6P5S9MnBqta3vkHSbKQE4ih8TjCtRLOwqZ49X1m+mZQSnXYa3wJrUX0hO7DFIno63dy2vGWOb38FWTmONQvt1r8+dprC+ZsW7uBcEHr6Gsvf7xj2JWEQDO83x4tKm86wlTFcdXnNySDCNy8qT2MZlzPG2kQXWJqc0E/HYs/KoUhNwIPMJW3cQT7gFW4o8x+yg8vVHrovtPQRtRu9zwZu2FsBPiwf+Gl5sLviCQ5V7heM8GyP/kncdiklwzq5I2xMOHoALeo9/C7eOYsHD7gbOWdjdSPraDUTDPxq+wr+nRhNnOfRGgNh9/cj/XnvB24vasLGMY4a3KHKb3HcXN0/NLVraHAsRFeNqDfzZFEWpQ0M8RUCvC0Xns93lEcYUeMqJgB0MyEDaTsLI8ma/kHtu8qfQewifxUsPlD+4TvitxCk5VuEHNjGMT/WJz1FKygl3FY6p5ylqIKTlFLDvVEdagkB9qpLn6QIaBksso5qbICsLcdXABKo26Cq21Zff/fLPC/RkFzYIRGycuFrdOwjPPN+OhcE92XYG/H5QgXbKGsIWUS+NN95mBDR02gZWTO8zgdbBalNqtAY/93qxgmnKXJWuCNB1HqFncX1MFweO28YZiZo7rQ2YU7fjwvpushWapaQpwjwS3kHqpJgskIds83fS+6kbBv1jqiCeizZexp3+T3IoIcU0iadV1Iust7uwFPgCPVv6QDHF2QCg0AsrICkllbxYV+xng
 VKG3RcS2
 ttQDOGtf781+YuDkuCyXrZNan5FNGvwNxrFhq+xV9d0ZO+g0ND66FpC5yvhy7eSpM1wYwCRAYRfMY7jJcfiXRRCsyUuZAqvNiZgJiNbmmhHifxeR/ysu4OKHnbhJnvll3vDpT1LEFryDo5Yv5eMG9KxxkuIjhxp1d5Efk0xB0Cl4yF/ctG007c5WOkc1+Zkb4EQPolonNJVJ6BXopNlKv6xUpCJgrVqzatXeZ2PeiYxCvn23xs/Q0coqmdUC33AMj2uSHrZv0oPHviLYFotLlUDH4Oo/a2BhFNSYNuA2Mt0GWuIayfXm/UgHLyoj5E/GBSt6Yvu0vb8+bgS5y4mDMVcbaBgShRG9G/od1B2BmxZg3WkssFVUXOcXAzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 4:47=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.com>=
 wrote:
>
> When a pool's last reference is dropped, __zswap_pool_empty() removes it
> from the pool list and schedules __zswap_pool_release(), which calls
> synchronize_rcu() to wait for readers before tearing the pool down.
>
> synchronize_rcu() is a synchronous, potentially long wait.  Replace it
> with queue_rcu_work(): __zswap_pool_empty() hands the pool to
> queue_rcu_work(), which waits for a grace period asynchronously and then
> runs __zswap_pool_release() from a worker for the sleepable teardown
> (__zswap_pool_empty() can run in atomic context and must not block).
> The grace-period guarantee is unchanged; the retirement path just no
> longer blocks on it.
>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

Why are the patches still tagged RFC?

Anyway, with one nit below:

Acked-by: Yosry Ahmed <yosry@kernel.org>

> ---
>  mm/zswap.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37f34e406c8e..0bb30e58950a 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -155,7 +155,7 @@ struct zswap_pool {
>         struct crypto_acomp_ctx __percpu *acomp_ctx;
>         struct percpu_ref ref;
>         struct list_head list;
> -       struct work_struct release_work;
> +       struct rcu_work release_work;

Seems like the convention is to use rwork in the name instead of work.

>         struct hlist_node node;
>         char tfm_name[CRYPTO_MAX_ALG_NAME];
>  };
> @@ -379,10 +379,8 @@ static void zswap_pool_destroy(struct zswap_pool *po=
ol)
>
>  static void __zswap_pool_release(struct work_struct *work)
>  {
> -       struct zswap_pool *pool =3D container_of(work, typeof(*pool),
> -                                               release_work);
> -
> -       synchronize_rcu();
> +       struct zswap_pool *pool =3D container_of(to_rcu_work(work),
> +                                              typeof(*pool), release_wor=
k);
>
>         /* nobody should have been able to get a ref... */
>         WARN_ON(!percpu_ref_is_zero(&pool->ref));
> @@ -406,8 +404,8 @@ static void __zswap_pool_empty(struct percpu_ref *ref=
)
>
>         list_del_rcu(&pool->list);
>
> -       INIT_WORK(&pool->release_work, __zswap_pool_release);
> -       schedule_work(&pool->release_work);
> +       INIT_RCU_WORK(&pool->release_work, __zswap_pool_release);
> +       queue_rcu_work(system_percpu_wq, &pool->release_work);
>
>         spin_unlock_bh(&zswap_pools_lock);
>  }
> --
> 2.43.0
>

