Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BCD4CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 19:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80C28E0008; Mon, 15 Sep 2025 15:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31968E0001; Mon, 15 Sep 2025 15:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9208E0008; Mon, 15 Sep 2025 15:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B87668E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:33:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22822870E2
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:33:18 +0000 (UTC)
X-FDA: 83892483276.21.5A77797
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id EC91820006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:33:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H2T0lmJ0;
	spf=pass (imf13.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757964796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVv4w1jtg4ojHbR2lrrdyh2MgDQjPgMUDgj4NVC4Ao8=;
	b=rKW8S9uGgo1hVRoVs9W4s2vE3DxdvCPAeKhMmSoKEiSYLCzip9YNzHuYp4qdn1xfCurBJy
	zxUw+W83FIOXeqjyUu7iRrGMZAITPLSaw80fLbWxv601kpgoecEmH2Cs6iqcfaJuEbkwCg
	Say/X86dRu0SWWnCfB5EU565LzAfuPQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H2T0lmJ0;
	spf=pass (imf13.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757964796; a=rsa-sha256;
	cv=none;
	b=zD5mctToOaz+pRkG5hB5ULR8wUM6usCeOR1z8CalwHsb/zNL0xeE17+aDF/70yNnFcDMXF
	t3jANoyl/EJKx47F8KMuHWW/DA7EU7/WQ8X5wX5l4zRnHUb5532PTlajha/qgWOkLRb8lw
	i8r+8OPz6NZz6blU9l0P9AoscppWNdM=
Date: Mon, 15 Sep 2025 19:33:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757964793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UVv4w1jtg4ojHbR2lrrdyh2MgDQjPgMUDgj4NVC4Ao8=;
	b=H2T0lmJ0fQrfvBo5DS9iOk5zIjLls+m1jXijYlY+VEb+TQfas+wpUQiArrjWuFrjcnxTFP
	+wS/uAp1LZ/LCVEw6gphTx8jOZgd8JmpL6ADyUAUHqZMViz14TRa/+J2rm8YEfXsOpruWK
	wtHFI4O8MruNWckyp0Jq1xOBw+R2eDo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: zswap: interact directly with zsmalloc
Message-ID: <pduxj3r37ufwsbe2jxtx262dikjbbnwmzkagwfot5j4tajxmaf@4z3slwpmdsl4>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250829162212.208258-2-hannes@cmpxchg.org>
 <r3dzlbqyvhaho5zuac7eba6pxz47zy3cz4lopxza3ls3ibadlh@6evm5aryyuxp>
 <20250909150156.GB1474@cmpxchg.org>
 <46xtfjznexpdlemxjwykin5k74oqomedb2fyli5jrb4xnquuke@ztcmxhmhlkx7>
 <20250910134240.GA1111@cmpxchg.org>
 <f5hn4awbmkelckl6khlaosw3tbfrwzvf5l7kn6mnqpbastsdnh@77mqvfjzyfys>
 <20250915153640.GA828739@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915153640.GA828739@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EC91820006
X-Rspamd-Server: rspam05
X-Stat-Signature: 1zqqtapt43sdr5u7gjm9hxg5ja1bnb4i
X-Rspam-User: 
X-HE-Tag: 1757964795-74058
X-HE-Meta: U2FsdGVkX19+Pdw9StarN+IZ5iTARbj88YfrFCvShsfX/4J0KQYxiuUzHNZ9t6jexgmA7OD2/1mizDOwDzYEd9zZqppnaVTWddAg2WfI0zjFC3gIz7ESaPoNrbjoeq6kWFaELUSUcGNIr6WBnAMcXJQ44GBMfZDd/4h7pDwHKNo5IFNO60iHOXaWkGTxOqJ9bxOqAL/8MKNmwdTaT4gnOzbNj5mgF5o5fzjGy1OyjhbrmC2keg06nHC6jXoEiK7my/fX9UWtz5HrbuVwXn9FAHg0E9NgJ1EgtDTLisuu9QnTEz4PAU5vqomhsd7WtoTTf2X0ER2fWhHgdRrHNq9wvFsVmyXc8J6+TSd/zdzdgc9k+ll4EQVexhxIYtkcxnN8lYS/ei4vLwjvcLb8XeGLqHERzlbFUW5vSPecyAYzvJojK5F6EvoQexsZ1j8ptfKtChRrKJcuIjtuhw05A5rFUvmU176+LA9U1yjIML8JqLll0fNiV/D2NDcFgthVpqMgO3tMq1isAH2oxJesFuI5Oj5THAq5s/UH1onxss+W7gjzzppcPXSdhyJUprrWXmu2gxR/9Kg/A9Ic4iaxqWP+AqIQ4DgGeDOFPkN2LSiuzUW/9f5cOhzdVTxlmaVQ2JpSSofK0ZpbgkW8JERORoI5HYLUDbE4qLlAwCDP0S1Zm9xMIE21HUTvdJ9zj8G4LXVKr7hVa1HUw1b4NNc8NRiefyBMv0cGWOjXxaL4iv5sjixdJkk0QPHSIO9yS5j/1J3icjPr5ZbXYzF44l2RTEiocIDFv59dwmsk00fy3xXbHap1VWKd7YPvytePa6O6Y2h5Dfppip0aOcp2l/tI8y86fY5Diw+j08luEGecQEZe5UXIMyUQsMp3v85sKxv9To12Yr54A8+TpSqopUQRA4gbbp9ZrOV9srQUaGs6rpWBIpU6dzBM3tBAy7JlLccVIo2gjareuQrSPhfm8cB4QC3
 wxH31FS9
 41w0yt49iJZ5+E6eEQ/MT2KUmQjOXhUA/l/HdLugnAqcInG4EkSqofkjUrZaPlUoop7YPKcML6z/ps5inj7DM2kcbtw2fznrfUD1JUL5tmvMCJFAc4wQEDYEBB1jA+atXGun3WNdkU0yzb93LwSwO9V22humKaOjB4GiHvF2CbpnqC7egMccwsyc1sStGD0f32Kda+XmMYeze/0dBqShdlZ9gnSjB7Cn6yeLI9nfpwRJJCepx87Zw5eUjE00gHya5lxR3pRIC1aeVQVU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 11:36:40AM -0400, Johannes Weiner wrote:
> On Thu, Sep 11, 2025 at 02:30:31PM +0000, Yosry Ahmed wrote:
> > On Wed, Sep 10, 2025 at 09:42:40AM -0400, Johannes Weiner wrote:
> > > @@ -314,6 +314,10 @@ static struct zswap_pool *__zswap_pool_create_fallback(void)
> > >  		}
> > >  	}
> > >  
> > > +	/* Kconfig bug? */
> > > +	if (WARN_ON(!crypto_has_acomp(zswap_compressor, 0, 0)))
> > > +		return NULL;
> > > +
> > >  	return zswap_pool_create(zswap_compressor);
> > >  }
> > 
> > Sure, looks good, although I think it's clearer (and smaller diff) to
> > preserve the old structure instead, up to you:
> > 
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index c88ad61b232cf..bbfc087792648 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -300,18 +300,21 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
> > 
> >  static struct zswap_pool *__zswap_pool_create_fallback(void)
> >  {
> > -       if (!crypto_has_acomp(zswap_compressor, 0, 0) &&
> > +       bool has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
> > +
> > +       if (!has_comp &&
> >             strcmp(zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
> >                 pr_err("compressor %s not available, using default %s\n",
> >                        zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
> >                 param_free_charp(&zswap_compressor);
> >                 zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
> > -               if (!crypto_has_acomp(zswap_compressor, 0, 0)) {
> > -                       pr_err("default compressor %s not available\n",
> > -                              zswap_compressor);
> > -                       zswap_compressor = ZSWAP_PARAM_UNSET;
> > -                       return NULL;
> > -               }
> > +               has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
> > +       }
> > +       if (!has_comp) {
> > +               pr_err("default compressor %s not available\n",
> > +                      zswap_compressor);
> > +               zswap_compressor = ZSWAP_PARAM_UNSET;
> > +               return NULL;
> >         }
> 
> No objection to moving the branch instead of adding another one. I'd
> just like to retain the warning, since it shouldn't happen. And ditch
> the bool, IMO it pointlessly splits the test from the consequences.
> 
> If you're fine with this Yosry, Andrew can you please fold it?

LGTM, with this folded:
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Thanks!

> 
> ---
> 
> From b8fa4c7edd4f3c84853665b47acec8cebb4f4899 Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Mon, 15 Sep 2025 10:56:15 -0400
> Subject: [PATCH] mm: zswap: interact directly with zsmalloc fix
> 
> Yosry points out that the default compressor check only applies when
> something else is configured and we fall back, but not if it was
> configured out of the box but isn't available. Move the test. Kconfig
> should not permit this, so replace the pr_err() with a WARN.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/zswap.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index cba7077fda40..c1af782e54ec 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -309,12 +309,12 @@ static struct zswap_pool *__zswap_pool_create_fallback(void)
>  		       zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
>  		param_free_charp(&zswap_compressor);
>  		zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
> -		if (!crypto_has_acomp(zswap_compressor, 0, 0)) {
> -			pr_err("default compressor %s not available\n",
> -			       zswap_compressor);
> -			zswap_compressor = ZSWAP_PARAM_UNSET;
> -			return NULL;
> -		}
> +	}
> +
> +	/* Default compressor should be available. Kconfig bug? */
> +	if (WARN_ON_ONCE(!crypto_has_acomp(zswap_compressor, 0, 0))) {
> +		zswap_compressor = ZSWAP_PARAM_UNSET;
> +		return NULL;
>  	}
>  
>  	return zswap_pool_create(zswap_compressor);
> -- 
> 2.51.0
> 

