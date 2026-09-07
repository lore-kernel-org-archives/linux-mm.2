Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D9CC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 11:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 113456B009D; Mon,  7 Sep 2026 07:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EADE6B009E; Mon,  7 Sep 2026 07:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027A16B009F; Mon,  7 Sep 2026 07:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C81126B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:33:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50ADC120136
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:33:46 +0000 (UTC)
X-FDA: 85186756452.30.EEAF81C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5A44114000A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:33:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sw8YClOh;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788780824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irZ0fuPGmEXIuvkRoDmmm/9mv1DPowEwpNdMgIfCvy0=;
	b=ruVyz70DdKtO9YG0SgkP9FErOpWC0BXVf64okJLUF/HbOQZZjHH4IPs1P1ItCMKc8wRQu0
	D5/JW+kFjJW3N8EEpIsLocYOKHmmDXQvWuxf5mFMHpB2oYYvxCBV9iaFhPYXihkifB7lmc
	U9K8ooV2wca/m78kPVaPzijaOZRyncg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sw8YClOh;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788780824;
	b=7wlKI60MpgJz51Q6H2LR2BAXHYhVcVC36dJ7ehhwlmu6IGi1fDOrmaJ0EIg3TMpoZWaFcS
	RteQenW/DUXiFq5DueuYth6nEgWeXGyZG2L494H9xi4yu2ON5fL/k+cC/BCGy9vHAh+3ls
	8NmUZ4kmq4fqee3AFYiI1pfwetI5+Xs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 719BC43D64
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D1E1F0155F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788780823;
	bh=irZ0fuPGmEXIuvkRoDmmm/9mv1DPowEwpNdMgIfCvy0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Sw8YClOhAIpUfUT7tgl1G+Z07bWN4b+Vv+g8xfZzDSf4EqeGKWViZG2mMh8vLwMZq
	 ZJm4nLMgKnTvhgGHj5WvTIi7OonrMu0//98YYlhyjx9FJFy9gIrCu9BgLOISUWsxJj
	 fcU6lZjWMwk8HpoB0OvCRlzPwU4etKssDPgSAg3gDxfIwMrCgrdWxjrFrsMafu/R3W
	 YlWXp/ocHjCDhTZEBX6l2JYNXVbO5sxvVSciFDccHvpFNMLnSC5v1Lg8J9kbzrDA94
	 oEL/OsJ98Q2mUbcr72ximflqHlW1SvcrM/3kAeGGhzpPZfbQumGFvMxc/nSQDjdf38
	 +9M4PSr9kJZWA==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c252e703fa3so518958066b.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 04:33:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz0dVcBePqa6xWKKUaGN/SXnGUgQ2zJ/7t1SkwgaVTts9cm+S8SjeEZsDH0WSUZRF7zmJdfr37L2w==@kvack.org
X-Gm-Message-State: AFuF++ksTDXxtGjhS+UHEJx7EWVE+u8tDT8pOf3fKRZQu27p1VA/vJgr
	ZLiG1f7UVfl4vzA82hyu8dxmATdEK2jRDug+biSFn06WkiW5i716bIF/nVO4OyczX2yi5wl045j
	uOK+WMOdjGgoSNwrtrm2K/TI2MbkAl/E=
X-Received: by 2002:a17:907:b04c:10b0:c26:1648:a074 with SMTP id
 a640c23a62f3a-c261648b742mr472935666b.47.1788780821956; Mon, 07 Sep 2026
 04:33:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com> <20260907110111.2286932-5-qinyuntan@linux.alibaba.com>
In-Reply-To: <20260907110111.2286932-5-qinyuntan@linux.alibaba.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 7 Sep 2026 04:33:30 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOtGdbaYe4cQJjaPkj5spD6gY2G33BBFrh3CURb6p2R1g@mail.gmail.com>
X-Gm-Features: AcwNN1WUxkV0t1H79v8s5n6xxY8uRxvyRY1wjk5P6CDIF6YhixLFaZDpcmnoz4Y
Message-ID: <CAO9r8zOtGdbaYe4cQJjaPkj5spD6gY2G33BBFrh3CURb6p2R1g@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Usama Arif <usama.arif@linux.dev>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Xunlei Pang <xlpang@linux.alibaba.com>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: c6endqgse78whorfoyatgjui6ae4849h
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5A44114000A
X-Rspam-User: 
X-HE-Tag: 1788780824-968905
X-HE-Meta: U2FsdGVkX18WRQXZGzTtiYDjo6UnFhRpmmt3robSWt4Huyxx0kRCb5NTZ9PglsSWf/V3/fibMaHVKwV8KJCpXBHK+4PxsOdzxt2XO3B8Cq26DfJoZ0eMUQ5WvWkx7uoprTHilHiWMU1MXQhHUn8UMq5Z3cG5zFOo/X6woNUfdYTh3KQxv7CryMDQd1O7WHwOA7ygwgC5I9CDhwrZdDjLrYamSbQY0+h+m6fhGMLJFFuF9GxpUY5n3PR4rAGx5s6LUzADMwIisZR/r0LQSDJ4Rlei9vyt+KjdeHujPqEKt9RuQF9FACVM1+UhT25C+FJoaEIuU6OD4wBILBiq2h1nBtsDj5PaTW5+Et1jyhhPfBalBSJoxVelBVns5gPlf/67l6vPSG9ygNGjVNfdViMprvLOLUkMK9YwFnP261hBsddH4eEBFVwhV4dIQ9/FwOL82B8Tgv56qAJYFyxbrID2qLkttE+lyJa8ypmoHrIxewouWGls3S6dqbXnhfzDrfpTFqvF+gd0Gub/zfccc/cluBn+HK19m3jUsPelR73fOHpTs5/sCHsxgef1v4RhliNBl20z55erE5BqoFZRbnMKL1WMTki4efLLt9bpE1lkbd6pJVzAOU9lkghTMBtd7k2L8y/7ty4DUzdGNPrqxdxs2qVtLh04qxps1tvYEMiGw8wMAtmZWxEGdKh7wJM7NSclaB0cBl9DpkEWXLM4a0HqS2IOSe0aILSI2fS55aHrKoqUu0podZKGFK/Mu3VT3MtPtf1OObJ2wrzxlxPKRvtWIvqLANzYcm/fgQ+WdMm0K/gGtoIqlQ8K0TpQebSDZ0MLycKJZJIpE9FTyUe1DWBCYj/HfXH6ulCaQK9Jm/8rRziE6seSSvYQr0LH+VIdlHq9mG7+JFVkkEwqZYRs7WPloHggPvOONZM2clX7Uos0Mpvs6SraRXae5by9ouZ24gn+4wYqNni35G+cVnkGBEe
 NSSG3ZYM
 DDsKpqXsthJpA9YV942iFPfwhRdCt/eYXcOI0YLcU4KOm2FRTTrMfMLRCpa9mH99MtnVYUQo8vURG9FmJFevJU8Vpb6bDBoDPrsV4xjYCUW5hr60OUWiHVQACCEy8NYJ4K44TcN3jI0cVZQAw5a2cgw7rPUV6w6Ybw8oA+bE9n0DJwClgSlk1Lukl6zRgggXsgYuclxnWV/q8bUrxIS++Z8JekrDq1NTB1jxdEgzNfzb9DkjceZ8H4AhnKNy/UrTkluSEvsD9XywBWLiubnONKCla2jRq7WhI5kdDdRXreRaV1e8/La/JhHOtveydHpTiiX9vqn+wVlwP+7XwzkQ1HBLFEwuiGACCsgIRWNp1lbR7IfwFbF4ZNqdAouI4wJRKfnlacgLfE5qvj4/Hu8dywqy4m3O6Pe8+Ow33Wuu+5DW7B1IFopm5xR+6Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 4:01=E2=80=AFAM Qinyun Tan <qinyuntan@linux.alibaba.=
com> wrote:
>
> With kmem accounting disabled (cgroup.memory=3Dnokmem), memcg reclaim
> never invokes the zswap shrinker: a cgroup under memory pressure does
> not write back its own zswapped pages to make room; they are only
> written back by global reclaim or once the global pool limit kicks in.
>
> The zswap shrinker is registered memcg-aware but without
> SHRINKER_NONSLAB, so under nokmem it is treated as a slab shrinker:
> before commit 03375203e1da ("mm: do not allocate shrinker info with
> cgroup.memory=3Dnokmem") it was skipped by the !memcg_kmem_online()
> check in shrink_slab_memcg(); since that commit it is demoted to
> non-memcg-aware at registration.  But the zswap shrinker is not a slab
> shrinker: it tracks zswap entries and resolves the owning memcg from
> the folio's objcg, independent of kmem accounting.
>
> This was noticed by Michal during review of the patch "mm/list_lru:
> don't copy stale shrinker id from non-memcg-aware shrinkers" [1].
>
> Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs
> under memcg reclaim with nokmem.
>
> [1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@lin=
ux.alibaba.com/
>
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
> Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> Acked-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Yosry Ahmed <yosry@kernel.org>

> ---
>  mm/zswap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index f3ae3c81e48ea..032136942c172 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1252,8 +1252,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
>  {
>         struct shrinker *shrinker;
>
> -       shrinker =3D
> -               shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE=
, "mm-zswap");
> +       shrinker =3D shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_=
AWARE |
> +                                 SHRINKER_NONSLAB, "mm-zswap");
>         if (!shrinker)
>                 return NULL;
>
> --
> 2.43.7
>
>

