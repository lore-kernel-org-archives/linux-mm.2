Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE72EEDEBF5
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 23:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF2EE6B0088; Tue,  3 Mar 2026 18:53:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76B66B0089; Tue,  3 Mar 2026 18:53:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9759F6B008A; Tue,  3 Mar 2026 18:53:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 833AF6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 18:53:48 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C34BC17A5
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:53:48 +0000 (UTC)
X-FDA: 84506406936.16.44952D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 338F2180002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:53:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pclDVVeH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772582026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5gTXT9V0sDO+RzK/GZttN8bxzSTZbquy7JS7RbLPDJw=;
	b=sz4mXoCXfMx/sJRgfeeoLJgayF2eUK2OHSm6Tlh2itsefym7R8zP7ICbsqHLUZJojH/sJJ
	eNdQTT4bORVgYmSsTpYNaQt3rb2jrk46xqpuxV9xt4OWIMEOaJ7jrmJssUgmSiLCHkvNkl
	7uO3Yv+eJZT571rDaynWtN0vSREZz6c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772582026; a=rsa-sha256;
	cv=none;
	b=mmBV+iteiIA0lVQOFYXE9wrHCqQ4Sj3up5N5R/YgG/j+UQ/hs3OXWsxwQ3SFpozMzTTr74
	DtBCRhsUp01aIFnpGbXldOVgbTwBvU7mDh+HT6WaeV0MncJ3p2hn5Cci6ajhZTIX/ZOJ70
	afX1lvmdqqe+KAaGjRnolsP4qFzlYsA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pclDVVeH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 18ACF44114
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD09C2BCB4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772582025;
	bh=fObzBjsb6GX+dDjfb/ilAFCOs/Qr4uRWvHMt1EbvpjY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pclDVVeHMxKXjQJmVe4aAlzpJCxcMUxiMQwo99JDgd7C6akvdo+I2Hzg0nSQ6MAlK
	 +qe8ss2Tb1hB0UsRsmakvcpiNA+nW9L9BWvImG9IikpN/o2vtQai4tswQzWXfilyQV
	 khi0O8W2lXHKJHwk4MvppyPCbI/yEZbTs0qT+ave17kIaNuucsjNS2p7cWTKh83mb5
	 Flnk79aKLEj73XHEjJGt6e2eWYwDQZcQBbi2t+/tQlEChgvEbCIpkGysGdxrA8NQfK
	 ZEQ32emUWtE6N5PMnrJg8jSwRey9dNN4MC3KrUe8FA5KjLyP5UOexJxCTXoGRRH3JE
	 maaGhBmuLO2MQ==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b936331787bso1024247166b.3
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 15:53:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUQv49ryEcy9FvRsx/xoRaxtJ2O0+vxJ0zz4iGxMrsIKR1dyD8vK3SR+pJPogWV6JWPKphnBf+plA==@kvack.org
X-Gm-Message-State: AOJu0Yzr4s3Hq/5Sa9qLi+l/39DH2U5iwGdC6Jg9h1o99papjoa5FHh9
	dUemSvA8W+MGGTgMKHVpvFzporP5sjRN68Xst/BPoBrVJFbqSfYT2D+qLVNfdKLHz+Lq6S5DKqk
	XNkEeV1zVNoyvxEWAjCyaRDZgch+Kufg=
X-Received: by 2002:a17:907:3c94:b0:b93:51df:dd23 with SMTP id
 a640c23a62f3a-b937639ba94mr1099210366b.16.1772582023631; Tue, 03 Mar 2026
 15:53:43 -0800 (PST)
MIME-Version: 1.0
References: <20260226192936.3190275-1-joshua.hahnjy@gmail.com> <20260226192936.3190275-7-joshua.hahnjy@gmail.com>
In-Reply-To: <20260226192936.3190275-7-joshua.hahnjy@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 3 Mar 2026 15:53:31 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOFS7zU-eGkErcjud=DW0t00_WqNqCzq_QDf061dOsYSQ@mail.gmail.com>
X-Gm-Features: AaiRm52Yk463FChq_84ojqG3qlKdUbfHqxoYs1pEzz26FFpHqxgDwturcqbb_Yg
Message-ID: <CAO9r8zOFS7zU-eGkErcjud=DW0t00_WqNqCzq_QDf061dOsYSQ@mail.gmail.com>
Subject: Re: [PATCH 6/8] mm/zsmalloc, zswap: Handle objcg charging and
 lifetime in zsmalloc
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Nhat Pham <hoangnhat.pham@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 338F2180002
X-Stat-Signature: reqn1eci5y7cz98rzwjw4iqr6ph17xx3
X-Rspam-User: 
X-HE-Tag: 1772582026-235515
X-HE-Meta: U2FsdGVkX196gmLWDfnTaSdyvNhNMbiuo7WeWk8ZqSjC+0wPeePwlsrUY//pBL28u9TR2hePvyDZZOofVl8etIJZLWk98pz+TWeMWqIK8uLpw063lz6k2wS4nRuIFKlADdoovju3tl/mGWFwRPu4wmna7no/awfnloJWkTbueN3E2uOzZ3kPuC9JfY6gbv2bPg9x27PvwW0A1xQdvQsEEJpqj7w4FAhkDN4Iio33Gy89PxG1aSRn8qLb4t8wSHLHBi5Bg+tVyqswYaUNiXbiU03V9RkEilvobN60k1FbGzO7EZwWcsWQrAl6pepgSUhX/Yw6r5l8eJcgzWtDUyQ9ExlANNHuA4IISdA0jbT/uk1Z0wf+vYLicpAbvbdiZD/pGkdJpF7daQj+opXhN6lQRcIZaoYWpEokaegZrNo7z8b6c4OJA/7lI55ijZxhuftnlzLWqekwwup3QY7VnmD0ny1EgUxmZH8qwFVz5p/sZV5WTIK7340z/2+B7XU+2Vn16vjR0PVWD+E6OgAzN+RLlpziYsypaRqcA3EmSPntjKAzZrLmMayt+AwwZSdU1170wQZHE5BqigfEn/nUUcgT8qTy7YtViFY1ufNXXwuxpTx1wXErSFwhLV557DfTGJfn8A/jAeidBLfuiTdNr4e1NQg0zB/ulMpRQGt5J1sptHz6ZUEUAdUOM+WZL3nIjR1RnUGu6NXbohl3Wju/aEDZ3/rfZDkruWonZFEGT+hKyRsT7vS7/UjOlLmrLKFkKaBZx1giJMyVk+9yAHSjTlhgmytqJwmROhc6Yd3ZAy53mjpWcBmm2NggiRmoJEXjqJ2VIRJTacFEmF425GZXVkOLUzNHzP3TJsTAPeIWIxblsUsl5RgD9hKGd1PmCKyuC89/dEXvPPj8BBGInAzvsBADbxEtCVqsULvO+tGCd5DTFAUBPNYb1hUar4BDLKmkJmbdEoc1+VFrUk7rrQgbDLi
 YiMAo8fO
 2NB9dvx36wnZyDDdS17e58b+o0c8iPDk6O2l5RF1/BI20tfJcD8uKtrlzCklnHMu0yExRh/yZ1wDmKuS4cysfNgik8mDHJVOIZ9BbNVeA4Cd1EXBhkZFg0ArWswIuZTmx1Xy0qhztlK6jwZelMuQ+GYlrmVazXbfxXbpFgeq/dIgQsnMqa7JMXOh/T/EFFOdClUIHYwR+SK+HSuMR8I2Kq+KhkuwN+CzUiqHeoA0xHhTIsF/mGkzCNySc4PZ3uy2a+qP3VgdWA/hAqsJR4jkx197dnhYD4OhB9OirDTtAVl20X1XUPdGefXRUmmFkfva+dqOJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 067215a6ddcc..88c7cd399261 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -963,6 +963,44 @@ static bool alloc_zspage_objcgs(struct size_class *class, gfp_t gfp,
>         return true;
>  }
>
> +static void zs_charge_objcg(struct zpdesc *zpdesc, struct obj_cgroup *objcg,
> +                           int size, unsigned long offset)
> +{
> +       struct mem_cgroup *memcg;
> +
> +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +               return;
> +
> +       VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
> +
> +       /* PF_MEMALLOC context, charging must succeed */
> +       if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
> +               VM_WARN_ON_ONCE(1);
> +
> +       rcu_read_lock();
> +       memcg = obj_cgroup_memcg(objcg);
> +       mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
> +       mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);

Zsmalloc should not be updating zswap stats (e.g. in case zram starts
supporting memcg charging).  How about moving the stat updates to
zswap?

