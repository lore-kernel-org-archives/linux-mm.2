Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 930D5CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 15:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F17796B000D; Tue,  9 Sep 2025 11:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB9B6B000E; Tue,  9 Sep 2025 11:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2DC6B0011; Tue,  9 Sep 2025 11:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C696A6B000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:03:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A7A61D9ECB
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:03:32 +0000 (UTC)
X-FDA: 83870030664.06.80F08EA
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7F53E18001C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:03:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=ewX7nL6f;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757430210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mu/1i0QY1lAahv44Zab7jGfKcHqDQqbZccixOVrtOOw=;
	b=ueiYjlCycifO+xwB6uvYUjL2QLErZO0JroxW58FIUsp9eZHKB9vqkUgdvSW9n9DuTnuZ3y
	TtMsdCze84pLSng6ZndJMwa5eOtZdgEdDKrOveGjJkPIh/9dXL2XtE+HWA3eMXB0EVT3l1
	kaJUH/rM+kB4QNLABvaqYKufteQeMNo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=ewX7nL6f;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757430210; a=rsa-sha256;
	cv=none;
	b=5Mz89BxktP0KG9qTRhJWOTHxH1K1IgtbtHOwBLNW2kXcHKOWPsmP4SrYH4d9vc0jetpCA5
	bTRx2QOHEVT8ys5lE9BmWVi2NUC8hoSsyv/IjvzC/jcEfIxo2ZAhlTbk8wqcfKv8Q49Bin
	U9CIUzdlSbUjU+ckWFJE1uN/QqAFZ4s=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-72816012c5cso47462186d6.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 08:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1757430209; x=1758035009; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Mu/1i0QY1lAahv44Zab7jGfKcHqDQqbZccixOVrtOOw=;
        b=ewX7nL6fgaayp/DlOHcu+M8o/zge5wIFkTZqeC2n1i3XZryOc8S1VJAWyhi5ebKb1s
         jVTxVDw9t6pPQASFEyRhpUbRyfB3a6lKga/YfIkFcTLMW25THH1MEpZzQ1h5UHzYrWkz
         yAzUGiIH2NzZqCQBqodzzIn64UAGECCkZj42OApa+WxPOquN5TDVMcPtGqLa9zZPEAt4
         WAnE8On/LkCx07ZO/axKml8Gv144+XIt+0Iplej/NZbvA/VCnZYrO1wog6C976hqmYZr
         yiynMXxWq0gzen6/XKVUleTC+PZyLUrhFWEeTvB1euBPijxMFYRy+MrGuTBcKg4SNYBT
         AnFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757430209; x=1758035009;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mu/1i0QY1lAahv44Zab7jGfKcHqDQqbZccixOVrtOOw=;
        b=JJVmHpPIprlzRyzVWpJsnn2+KaE9YjaAz8Aug8smdRBdd5Kuihy6QwRaieMo2nQZ23
         rXswNn4ZBYvSss/p69Z7ewTTz5pW6x1fxxAXa6yAlBVMpVErE6jnVBp+X2JuTUC/h+dG
         QpcLytewn1iEcwMVlMiPb97jkHNUcyTwGOH2zYLnLENHxJPR0cph5CEUK9X1wfnt8ush
         r+Qvm+uAKETHeF70SXenyi8RkAiFqvhSt0BR9+yDVXDyesdO2RXrUEFPkR0sV+PX8C/Z
         L1AiJ09NNdh8reNX3e+3MPSTWheM9CctUJ9fuon3IlYhiis+uea8OvzpEbccRiuvArxL
         jbLA==
X-Forwarded-Encrypted: i=1; AJvYcCVaQH08tw4+06TRfN3GixZTzwtK/DIawzR5M4EjQZqdp3RUAZojqv175BhcYyb4mxBFMz/yrjrdpw==@kvack.org
X-Gm-Message-State: AOJu0YyCVhU89Xkk00Rt2s7EoebzDYAZRDnqWoojyompAX+iBBY2CuYB
	J3VaCDSLkcrHY34zuIAC1vvYqZ2zN6n0xFJ6PJtn/rfrPJuLqEldaBcw8nT5SZP9KbA=
X-Gm-Gg: ASbGnctNcqHiHXioo5imc3WVk1Q9SAnSRy+lcUJHLHpcr+hoK3LVdxuae7bs+yiZ19s
	aiyF1Z7xlZE1AXrKts/CTxAjjKokjyAMPozjOVdaHGmSIR71JOdgvmwKV64e+GgqrJqea0lsctC
	cH4of7MEiMACOgwilQYkTGFHVY3foCi7NTAZsOVnI6VCBa8ZIC3bYUk84CDKPEDl38SXjkaLyqQ
	18d+PvzG4Vkf6Feekq9wbtFvKQAcHXYVWt1r3+9b6zmpWsygUlxs4CopbkXrsyHYQKuuCxgKepY
	t41pi/AqcJhMI0TuxGLh+C/4jGBb63Ba54USAh+j5jYoUYaFXTIovVq5rG39HZ/mrC2qzLWiqnJ
	mpLoOyzAtES3R
X-Google-Smtp-Source: AGHT+IEjOrf2aDiDBedKoPEPVw6yfvKoqORxFwFZL8tpRk7gQlzrwvc8I4YBCMey02oIsQCUL6PFJw==
X-Received: by 2002:a05:6214:c4f:b0:734:4ca1:1d97 with SMTP id 6a1803df08f44-7391c8e0647mr128950756d6.16.1757430208186;
        Tue, 09 Sep 2025 08:03:28 -0700 (PDT)
Received: from localhost ([2620:10d:c091:600::43c9])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-720ac16de47sm141863736d6.15.2025.09.09.08.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 08:03:27 -0700 (PDT)
Date: Tue, 9 Sep 2025 16:03:26 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] mm: remove zpool
Message-ID: <20250909150326.GC1474@cmpxchg.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <CAKEwX=M8ccnsOUc4_ZcFrg-8MSwDDF250=LCFKctvTrL5vJZ6g@mail.gmail.com>
 <4vpqew3bfs74kesmgd6kaafgm6nr6zbtt2t3hl2khkc6ds4zep@hllgy77hdumf>
 <CAKEwX=P=2cm7X4VMGO==xqmcFfBj4tq_YU9DqCSbyAmCioDccg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=P=2cm7X4VMGO==xqmcFfBj4tq_YU9DqCSbyAmCioDccg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7F53E18001C
X-Stat-Signature: j1h5t97usboeesw4g5g565hdctmqawk7
X-HE-Tag: 1757430210-346090
X-HE-Meta: U2FsdGVkX1+0QEIhQPo1kIVk5RtHDoldU/1+ecRq2gMqzRiibBj8QZiB5yzdG5YL9TvuiGj3ddWBgwOXMH5kHELD6bUxUhLPnjHXUhk8n4y2d8UDb18v+hrc6ckcIevLEyVg9NZNIeocrjTsVMh1NOTRgpkCgWeFCPjNYItbmCJRpEgZDPT4t8P7yxRsskW9mOZiFnZ0zPVsO/SaY0fRtO4TTBxJSXJ3w+en95Y8MaNBSkG8+HPdob2M0TWQ1PWhYPJorGsTR6PWm9LzZ1cp8a5NbJ810rpgpFTupyUdRbttaK04Wt7BbV2te68kfdVDT0cQnla2+k2tWX4GCZxqf0+IMmxul8SN1mhgf33eygBfuBaHmChbzek4kmJVob6/uhfbmIlOdlBKlkoGk9uoTIsGUTzLXbLCYl9PyoWRu64AlruYfVtFvFD9/XD4DN8k5WP34iSuxHtubaGM6uK2EkfFHMJSSgERT2grnTUpC8mi/xeMiEiZCBimoYT+OK1LgnpPrVdPlgjtNLsRNkaRnm3SGieddbspD+T6mhjStmwX6rofND2FnrcgLm9e3vWWxhAYcS6P7fuSuXbtxkVmvO9rJfxAuPu0EkYdyRcitmECYKqMowzUfiEEHIgyMidQD5A8Xr7ivEM2PcODqVL9NTpvv1S9Atu2ipkfDSPMzRRr/LvjXLEUCjqY7xnpFgMhcHuutzO8dlkMEjcm9SmDXQEu605Lvb8WFM9ZAVWENN0kbwEnpGptprQ0kyR5ANnDsitC2NqHBXm9AqJUW0wLQRmHH3qoplanelYOOnAxi95/m/7SyFMcvBr8MF467E8twkKmvJAVRz8jCNDJuB7/NlASwd0C5Lihc9sMdarlqlXAoM5SkEVceG2dSqudHEqojXfUMH7hAESrPtSP8+u3VmMywMugOefxJq++EWvDHxp6dGzEcGCLTWR5krowGmsxeLcDnrMKcKI7b2Euz2J
 8ATlCZ8W
 +XcPkgmZSUoGYKEx/Fy7jsEbzPERT/Tg/M9ep7DGyCsPbDGP6vSmQnTJ57yEVTD7TMtTyyRvD/dbEb+NY225gVu9q6GZzKhhLUAPi1BjqVo+bstZ6+n8FI0xHi3ZFz6kpAredR9N27Rgxgs73hdzKSpPKPooK4vUB9NpPJVdBQXoSrq1z+RdYNgW8SHELhKzc0OQ1CA96q9DPgDoNIjYs8UBWoVge9LnuYu2HJTNJNTjQzo2npEpVAB0pJ+tb87oWMfCvMrCFrRKcLVtVL923qm/CSzlFw0XoJkTj/z0ky/ZhYlurD1hTo5oBiHfGn9vmqueuO/jPHDvyflYnd5J6UwtFK5cTjDG2ePlCTIpKdRyQx8AB8rDrnetT6TT0HSOvyEZBboI2PcaTpaQGc0tVooPJg70AdUioa18AkkP3D7B/yDaOlg/mxuuL6l+at6Ozg6lLpDA8uyszHxwSmUxfR3wT9h24tUw7Ua4cE+Gy7ONK3Vr4xdpYnuZOtuDbGPmlBL0aY+E5V9JRizrsZCVyZy3+PMaeTUFpyr+3MSnfr1PUp1U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 02:35:12PM -0700, Nhat Pham wrote:
> On Fri, Sep 5, 2025 at 12:45 PM Yosry Ahmed <yosry.ahmed@linux.dev> wrote:
> >
> > On Fri, Sep 05, 2025 at 10:52:18AM -0700, Nhat Pham wrote:
> > > On Fri, Aug 29, 2025 at 9:22 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > >
> > > > zpool is an indirection layer for zswap to switch between multiple
> > > > allocator backends at runtime. Since 6.15, zsmalloc is the only
> > > > allocator left in-tree, so there is no point in keeping zpool around.
> > > >
> > >
> > > Taking a step back, even if we do have needs for multiple allocators
> > > for different setups, having it runtime-selectable makes no sense.
> >
> > Honestly I think we should take it a step further and make the
> > compressor selection only at build/boot time and completely get rid of
> > supporting having multiple pools. We'd create one pool at initilization
> > and that would be it.
> >
> > I believe this will simplify things considerably, and I doubt changing
> > the compressor at runtime has a valid use case beyond experimentation.
> 
> You are completely right.
> 
> And, even if there's a setup where we benefit from multiple
> compressors, the current setup is definitely not it. How are we
> realistically going to use these sysfs knobs? Change to one
> compressor, then quickly change it back? How is this remotely useful?
> 
> Let's remove it all. In the future, if we want to do multiple
> compression tiers, or per-cgroup compression algorithm, we will need a
> completely different architecture anyway.

+1 Completely agreed, it's not worth all this fragile code in zswap.c.

I'll send follow-up patches.

