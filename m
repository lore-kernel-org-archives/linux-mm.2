Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69454CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 14:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860028E0002; Thu, 11 Sep 2025 10:30:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 810238E0001; Thu, 11 Sep 2025 10:30:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D428E0002; Thu, 11 Sep 2025 10:30:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6548A8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 10:30:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 077A5591B7
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:30:40 +0000 (UTC)
X-FDA: 83877205440.26.C4548E6
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id DD132A0015
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:30:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Af4pJ3d4;
	spf=pass (imf25.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757601038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ggZBAjhYjIflaDH1RktcBl45HG8nhXAZG/qjhNo9vw=;
	b=dcQXbHPQCgLqF+63JW5L+OKVEjQ6SR/7Jv9ZF+EcdE2FyBffE+bv0hH6vJDkBUqxp2RuXA
	IXE8lPqWNbOgESH+Tf1BPEEfx5s7WT0/ZagtNd/rAupGFZdq/E22hvOtZYBMAPIMggOubF
	LSBP+6VnLdhKkr9035oCJP5irPw31lA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757601038; a=rsa-sha256;
	cv=none;
	b=h4aURxPdCNt27MY6pHnXFOakYpPDexGm8GoNbJMfGTbW78cBAIVb2j5Csodq7twJunRkAQ
	GWDwivh8qYBjCZFNkKRNr4VyhBBmJr12JUX7xP6ELfz5CRW1yRqyxFTwWxXUm36M8TaAM9
	tmBgttKUfgFTjGTrNdmdyaB8H5txohw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Af4pJ3d4;
	spf=pass (imf25.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 11 Sep 2025 14:30:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757601035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0ggZBAjhYjIflaDH1RktcBl45HG8nhXAZG/qjhNo9vw=;
	b=Af4pJ3d4AxqymMzi7MWDMC/qm2UPqpLWI0/cF/PpxmZJf7yE05u1WNdLdZ/wIdEECzISNb
	BnvqOi6giWGl8XkKWZK2NZRqleJDA8D5eZi5Ii65UFHVdvXJwrQTC7WXEu+bUNFqLXyfgR
	oPiPfo1gBKEoAQ0lNb1zkpt7wyaqU/E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: zswap: interact directly with zsmalloc
Message-ID: <f5hn4awbmkelckl6khlaosw3tbfrwzvf5l7kn6mnqpbastsdnh@77mqvfjzyfys>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250829162212.208258-2-hannes@cmpxchg.org>
 <r3dzlbqyvhaho5zuac7eba6pxz47zy3cz4lopxza3ls3ibadlh@6evm5aryyuxp>
 <20250909150156.GB1474@cmpxchg.org>
 <46xtfjznexpdlemxjwykin5k74oqomedb2fyli5jrb4xnquuke@ztcmxhmhlkx7>
 <20250910134240.GA1111@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910134240.GA1111@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD132A0015
X-Stat-Signature: jhrc6qf3iqia5mewqyp6yh9bht99rzoi
X-Rspam-User: 
X-HE-Tag: 1757601037-403822
X-HE-Meta: U2FsdGVkX189nwP9jyB6JKg7bTAr2phVBf1etLBov3JbHxJuWsiqfma49/Vj7fk44RxWm77mq82KYJxVSYrH2C3uL+fD0yCN8TTx61DEU8fQKuVoePAZSlTbZi8SaArUSzScD1pigl3iw4nITPfiyulB2Oq9Qq7/sxLM/o8Q/ezimzXVeef8AKeELco7PJ+3u3+xrnpyVcCHvxVxCwaBooGMoCxjPHDdnwvYM4bn8tYv/562irRepZalrUsbQs2DE1572ixO+ZW/6fW08T8uPbyqfp9qW1aN8tnFNM7wafmsjiW5IjJZ0o7mizE/B8yBbgi3A9QG4iaozajuOegWQZSTRydxn6gcmlMUTWN6QwxPNZCNEWsi+Z8RydIEfPXvc3JXdg3LhUccMIzKO5B7pSp05JnnPM36DdcETWEwYhd1JoKEfCaIegoTV1mioQpORB4HpnOBzE8gYmPAFTzvJyh/TQlZwNmlegzCOuC8w63CXEo01gkaSN9R48RaXiIc/W9RbpZN82fkmmeey9w8fjEX3y4hnHJSNTEh/SlHNw5g9Su3lv1zr9rOdmmsuEssPghY/G6PD56+HzmfyXhhLYG/Qd38Fg3O8M2Duc2h3zugnQceXwP0mO3c1DfAA9duMJJt4YSX/HAVinF6io1lifg3hG9oL0YPINJQGAwdoseOT1MT+nGoiNRUtgomGoe3fxS2YRN966Yg2E+b6z2IC3XBTKLqCB+kJiyNHyD/I/2qqIUIllsEuT8iSTSLiyuBQSRlSfk3CCAgmOkXX8K2PRnXA/d4orWp2RxVFrQdRq08K9MQZmcX0LbmgVpnhw1xD+C2pencRn9sGOOJb7g8OsAU+YyNCGbkaONOSmxKydckBROIlxTOcJ+gPf86ORXsshTw5KIUwXmGC/yqAzNyZbAFhNElP6TM6q8FDopMx6A7H9i5DHw+lRoydFiXyDmCY/HPOL/eLG3ZV3t8JJY
 NgkEKw0l
 5Dgc+yHeiDdIr5ERSuYRKgl+Vfu+fU9K7Sxl0HeI+m48SRh3h9BIUBcQD/rFgvvYoAb1diy1KmlXHiMb47io5VywadaeZT/BegFsCqL4+NHWTTKONVIqn+T0pUVfZKztiwoJZQLJqX3Us9CHXIk3DFRlATIUzuLXpTPMGVaPTSGHw+h6nRVH+bnteNYMCQmVFVyEhUOWDNeQpReqXEQJkhn/xM5JK4h5+8KWJUO0Zp601VMcBWjA0XNKO+SgOwLqAmzuiWLGrXUKr7vc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 09:42:40AM -0400, Johannes Weiner wrote:
> On Tue, Sep 09, 2025 at 08:10:43PM +0000, Yosry Ahmed wrote:
> > On Tue, Sep 09, 2025 at 04:01:56PM +0100, Johannes Weiner wrote:
> > > On Fri, Sep 05, 2025 at 06:53:15PM +0000, Yosry Ahmed wrote:
> > > > On Fri, Aug 29, 2025 at 05:15:26PM +0100, Johannes Weiner wrote:
> > > > > zswap goes through the zpool layer to enable runtime-switching of
> > > > > allocator backends for compressed data. However, since zbud and z3fold
> > > > > were removed in 6.15, zsmalloc has been the only option available.
> > > > > 
> > > > > As such, the zpool indirection is unnecessary. Make zswap deal with
> > > > > zsmalloc directly. This is comparable to zram, which also directly
> > > > > interacts with zsmalloc and has never supported a different backend.
> > > > > 
> > > > > Note that this does not preclude future improvements and experiments
> > > > > with different allocation strategies. Should it become necessary, it's
> > > > > possible to provide an alternate implementation for the zsmalloc API,
> > > > > selectable at compile time. However, zsmalloc is also rather mature
> > > > > and feature rich, with years of widespread production exposure; it's
> > > > > encouraged to make incremental improvements rather than fork it.
> > > > > 
> > > > > In any case, the complexity of runtime pluggability seems excessive
> > > > > and unjustified at this time. Switch zswap to zsmalloc to remove the
> > > > > last user of the zpool API.
> > > > > 
> > > > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > > > > ---
> > > > [..]
> > > > > @@ -315,52 +292,29 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
> > > > >  error:
> > > > >  	if (pool->acomp_ctx)
> > > > >  		free_percpu(pool->acomp_ctx);
> > > > > -	if (pool->zpool)
> > > > > -		zpool_destroy_pool(pool->zpool);
> > > > > +	if (pool->zs_pool)
> > > > > +		zs_destroy_pool(pool->zs_pool);
> > > > >  	kfree(pool);
> > > > >  	return NULL;
> > > > >  }
> > > > >  
> > > > >  static struct zswap_pool *__zswap_pool_create_fallback(void)
> > > > >  {
> > > > > -	bool has_comp, has_zpool;
> > > > > -
> > > > > -	has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
> > > > > -	if (!has_comp && strcmp(zswap_compressor,
> > > > > -				CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
> > > > > +	if (!crypto_has_acomp(zswap_compressor, 0, 0) &&
> > > > > +	    strcmp(zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
> > > > >  		pr_err("compressor %s not available, using default %s\n",
> > > > >  		       zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
> > > > >  		param_free_charp(&zswap_compressor);
> > > > >  		zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
> > > > > -		has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
> > > > > -	}
> > > > > -	if (!has_comp) {
> > > > > -		pr_err("default compressor %s not available\n",
> > > > > -		       zswap_compressor);
> > > > > -		param_free_charp(&zswap_compressor);
> > > > > -		zswap_compressor = ZSWAP_PARAM_UNSET;
> > > > > -	}
> > > > > -
> > > > > -	has_zpool = zpool_has_pool(zswap_zpool_type);
> > > > > -	if (!has_zpool && strcmp(zswap_zpool_type,
> > > > > -				 CONFIG_ZSWAP_ZPOOL_DEFAULT)) {
> > > > > -		pr_err("zpool %s not available, using default %s\n",
> > > > > -		       zswap_zpool_type, CONFIG_ZSWAP_ZPOOL_DEFAULT);
> > > > > -		param_free_charp(&zswap_zpool_type);
> > > > > -		zswap_zpool_type = CONFIG_ZSWAP_ZPOOL_DEFAULT;
> > > > > -		has_zpool = zpool_has_pool(zswap_zpool_type);
> > > > > -	}
> > > > > -	if (!has_zpool) {
> > > > > -		pr_err("default zpool %s not available\n",
> > > > > -		       zswap_zpool_type);
> > > > > -		param_free_charp(&zswap_zpool_type);
> > > > > -		zswap_zpool_type = ZSWAP_PARAM_UNSET;
> > > > > +		if (!crypto_has_acomp(zswap_compressor, 0, 0)) {
> > > > > +			pr_err("default compressor %s not available\n",
> > > > > +			       zswap_compressor);
> > > > > +			zswap_compressor = ZSWAP_PARAM_UNSET;
> > > > > +			return NULL;
> > > > > +		}
> > > > 
> > > > Hmm it seems like there may be a change of behavior here. If
> > > > zswap_compressor == CONFIG_ZSWAP_COMPRESSOR_DEFAULT at the beginning and
> > > > crypto_has_acomp() returns false, the old code will go into the second
> > > > if (!has_comp) block, printing an error, freeing the string, and setting
> > > > zswap_compressor to ZSWAP_PARAM_UNSET, then we eventually return NULL.
> > > > 
> > > > It seems like the new code will just call zswap_pool_create() anyway.
> > > > 
> > > > Am I missing something here?
> > > 
> > > I don't think that scenario is possible, due to the way the Kconfig
> > > works. Whatever backend I select for CONFIG_ZSWAP_COMPRESSOR_DEFAULT
> > > pulls in the crypto module as built-in/=y. It should always be there.
> > 
> > What if none of the CONFIG_ZSWAP_COMPRESSOR_DEFAULT_* options are
> > selected (i.e. empty string)? Also, can CONFIG_ZSWAP_COMPRESSOR_DEFAULT
> > be set directly to an arbitrary string?
> 
> No, that isn't possible. It's a multiple choice symbol that forces one
> of the options and has a valid default value. I tried to made it an
> empty string in .config by hand, but oldconfig restored it; if I
> remove the DEFAULT_* line entirely, oldconfig reprompts.

Good to know, I honestly never really know how kconfig handles these
things.

> 
> > I would prefer if the code behavior did not change to rely on the config
> > possibilities.
> 
> How about this on top?
> 
> From f842e1338594c4b78456f878731a261a074d5277 Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Wed, 10 Sep 2025 09:00:01 -0400
> Subject: [PATCH] yosry
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/zswap.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index c88ad61b232c..991fe380c61e 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -314,6 +314,10 @@ static struct zswap_pool *__zswap_pool_create_fallback(void)
>  		}
>  	}
>  
> +	/* Kconfig bug? */
> +	if (WARN_ON(!crypto_has_acomp(zswap_compressor, 0, 0)))
> +		return NULL;
> +
>  	return zswap_pool_create(zswap_compressor);
>  }

Sure, looks good, although I think it's clearer (and smaller diff) to
preserve the old structure instead, up to you:

diff --git a/mm/zswap.c b/mm/zswap.c
index c88ad61b232cf..bbfc087792648 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -300,18 +300,21 @@ static struct zswap_pool *zswap_pool_create(char *compressor)

 static struct zswap_pool *__zswap_pool_create_fallback(void)
 {
-       if (!crypto_has_acomp(zswap_compressor, 0, 0) &&
+       bool has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
+
+       if (!has_comp &&
            strcmp(zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
                pr_err("compressor %s not available, using default %s\n",
                       zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
                param_free_charp(&zswap_compressor);
                zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
-               if (!crypto_has_acomp(zswap_compressor, 0, 0)) {
-                       pr_err("default compressor %s not available\n",
-                              zswap_compressor);
-                       zswap_compressor = ZSWAP_PARAM_UNSET;
-                       return NULL;
-               }
+               has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
+       }
+       if (!has_comp) {
+               pr_err("default compressor %s not available\n",
+                      zswap_compressor);
+               zswap_compressor = ZSWAP_PARAM_UNSET;
+               return NULL;
        }

        return zswap_pool_create(zswap_compressor);
>  
> -- 
> 2.51.0
> 

