Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 815FFC44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 23:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD6A6B0005; Wed, 21 Jan 2026 18:58:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87B766B0089; Wed, 21 Jan 2026 18:58:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77DA56B008A; Wed, 21 Jan 2026 18:58:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 649776B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:58:57 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5972D45E9
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 23:58:56 +0000 (UTC)
X-FDA: 84357639072.20.59F76AA
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf15.hostedemail.com (Postfix) with ESMTP id A6FA1A0006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 23:58:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NQVNFZbM;
	spf=pass (imf15.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769039935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LoXxVnLGAE6Kr3vjQsZjRSedpom6fDkEVTXkB9gcjAM=;
	b=jgaiOtRZw51y6YLm6478TB2UgylNoWM9pReoCCn8RJHzejz/We1AiED8QgPiGb9jtXRcEP
	AsuuR3RVZDT2y7sXfD02Lh80Eo8gnxkEF5JL0lkywRUKm5TLvHAfnLYJjbxyrz8MMfzw+r
	LgW0YnvGU5MLqfvIMeXJck4UsQjFJNM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NQVNFZbM;
	spf=pass (imf15.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769039935; a=rsa-sha256;
	cv=none;
	b=SjL53rIFqzjO6oUatVpm6FfNFQdR+HZioVOeYv0vPDBtKolmSJV0Gz+D3Pi8GxrXz1Hutw
	G1x6zL5382huc40qw14cFhHaeGOvJqUAGAdYJrktUsm1zrKVvL1VL4xCeUdHECJoKh/XfH
	VlySKxRkbHqH1MukFW5KQo1r9hPE1Tw=
Date: Wed, 21 Jan 2026 23:58:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769039932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LoXxVnLGAE6Kr3vjQsZjRSedpom6fDkEVTXkB9gcjAM=;
	b=NQVNFZbMs3vBIpTR6SM4U03LGftFMIMt0rAQsC5GIPvvzRs6HRIP1QB2QbDdP6zF16uFy/
	JSkg3OWVLrJM31CaHgnsRJigsN/WNTuOs7DJZn1Ljau5ElT1b3fYLCCtTB8XgiLducEcEg
	Q+r4gfaMKrw5APt271gnfleJ4VV71H0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] zsmalloc: make common caches global
Message-ID: <cevxzukpt4363kdlb5ofre5tquuvm6jyphstp6nlxjxqibj4wx@2yg4xwlcxwg5>
References: <20260116044841.334821-1-senozhatsky@chromium.org>
 <zfmvd2oogwtx6mbavyjgwxralsvrd576ye6jnscfwvqy4u4ayp@q7qpxnyaxb6f>
 <CAKEwX=OJBc38i6ZhObNsvsNGJ16ZuNXkV18f-j=JRd-2xecJQg@mail.gmail.com>
 <kmku2oyevj5vbt6na73iyksyod4sjcvik5zx43h4mw55m744oo@ddiynkvadmni>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <kmku2oyevj5vbt6na73iyksyod4sjcvik5zx43h4mw55m744oo@ddiynkvadmni>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A6FA1A0006
X-Stat-Signature: uus45yifrfz6z5o88hkn4tmhj9ck7tec
X-Rspam-User: 
X-HE-Tag: 1769039934-681398
X-HE-Meta: U2FsdGVkX18MuPqs5p0a7J96Dg8cEl8mawCaNRYoW/WfU6qhTwnafYOAldrlm7BbMMY1vde5bP8asf8ZCwNZrLKzPAUxePtt6r12uwiGyWWzuGXkp42oP/D+RTBEgN0UxmiyU6axuqbpfTszx8zrMrTEVTUF/mQWlk388EZ3sTDweewCc7FX21ftvYIrgzfMa6ybZ7pmUOyAGCX4aeEgZhDUnjk+YRM4cxSh7JxFnO0DuhG2GFoq6uj8mkGhLVSIYC7Kh+KFPDWZpvEKfsXC7PLEFeKRROFV1MVHWEOtjMCrBPnq4+zdJU6vwZmEQ3P1aZdEEkyqTwIJpuQFWfarwpzIXfOr7L0AvmARweRFcgRq7DTZcu81VfiqJlKC1KE+uHoDllrgXRqgILNAGNnPWtbThN5cmN03q6ZaDE0Lkv6Nvzoe4Oe+3HUKOO1qRBAwlFqFiiO1Mf1PutNUimrzt9udDngl39QOo+Z8eXJbf7dg1lhvqGGLbthJ3aJwOhCknDvn3YXfrizkFdSRqBflkHeliueryrtlRspDGnu/jlz/Wq32vT85tJIwWv1W5EMd1d1RupUCF5YoKo9Grc7jyAJ0LWTTDIRqN1sLkEkGUxaF3Jy20IHDBJdcrKJe7BDMkhyHtFNKJSL6XiRBk5tteInRlwyckA9kNNHhL5mPDZcXWluXA2uj4iS1tiZ6fVU7sAyDwkmE3EM+n7kYl+sPy5+pRphmGuseLHH43spOZ5Lbq/eoqhB2tKQagp6RQ3z6eaB4Lmdf1dHvYSmRa9bOikHQZIVLi5z2nSr6mUjF3WCneNtGQ4sjc8zYUERDIN3+UmS2fNw+PkKN3nADWvCghlTvYAhYqyA6Q6tv5zr1SvtLa8Gb24jq4ZRG5/xZm/pgqyvpz2sMi+k4cL5Of13dtwPzuSNy1AsFBLHvsUZU4B0BJvarQeFO3javPUug+AqOpnWzIRjj26ymAGRngM4
 aIDYbKfS
 rtkfGcVra7GU0lctsMtCpNIk5VkL0+czFZZhUrq7D5OYwZOwuFfrN/Xng+0HkeOEp2N9HXHWhQzm+0G4pJnpwaIlQfh/8qsHJSmvNTxzUzayJNBlvhUQpgknxou9kddOxeJxFzYw8lEd3Av29g6pOPubqU2jL/+nNZqVnpTzgESOR+O0aVlHXRgpCXO9CYfdGhu7TsqSFBEGPzFZ/uAzW3OCgUvq6IBFydg2ZfPm2PXbua0/Hsn9Ti+RMW6YgTp+7ipP3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 12:41:39PM +0900, Sergey Senozhatsky wrote:
> On (26/01/19 13:44), Nhat Pham wrote:
> > On Thu, Jan 15, 2026 at 9:53 PM Sergey Senozhatsky
> > <senozhatsky@chromium.org> wrote:
> > >
> > > On (26/01/16 13:48), Sergey Senozhatsky wrote:
> > > > Currently, zsmalloc creates kmem_cache of handles and zspages
> > > > for each pool, which may be suboptimal from the memory usage
> > > > point of view (extra internal fragmentation per pool).  Systems
> > > > that create multiple zsmalloc pools may benefit from shared
> > > > common zsmalloc caches.
> > >
> > > This is step 1.
> > >
> > > Step 2 is to look into possibility of sharing zsmalloc pools.
> > > E.g. if there are N zram devices in the system, do we really need
> > > N zsmalloc pools?  Can we just share a single pool between them?
> > 
> > Ditto for zswap (although here, we almost always only have a single zswap pool).
> 
> COMPLETELY UNTESTED (current linux-next doesn't boot for me, hitting
> an "Oops: stack guard page: 0000" early during boot).
> 
> So I'm thinking of something like below.  Basically have a Kconfig
> option to turn zsmalloc into a singleton pool mode, transparently
> for zsmalloc users.

Why do we need a config option? Is the main concern with a single pool
lock contention? If yes, we can probably measure it by spawning many
zram devices and stressing them at the same time.

> 
> ---
>  mm/Kconfig    | 11 ++++++++
>  mm/zsmalloc.c | 73 ++++++++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 72 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 4fc1a171dffa..ff6855e74c3d 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -132,6 +132,17 @@ menu "Zsmalloc allocator options"
>  
>  comment "Zsmalloc is a common backend allocator for zswap & zram"
>  
> +config ZSMALLOC_SINGLETON_POOL
> +	bool "Use a singleton zsmalloc pool"
> +	default n
> +	help
> +	  This option enables the use of a single global zsmalloc pool
> +	  instance for all users of zsmalloc (e.g., zswap, zram). This
> +	  reduces memory overhead and fragmentation by sharing size class
> +	  configurations and memory between different users.
> +
> +	  If unsure, say N.
> +
>  config ZSMALLOC_STAT
>  	bool "Export zsmalloc statistics"
>  	select DEBUG_FS
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 8df45aa1b5c8..acd14b001342 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -224,6 +224,10 @@ struct zs_pool {
>  	atomic_t compaction_in_progress;
>  };
>  
> +#ifdef CONFIG_ZSMALLOC_SINGLETON_POOL
> +static struct zs_pool *zs_singleton_pool;
> +#endif
> +
>  static inline void zpdesc_set_first(struct zpdesc *zpdesc)
>  {
>  	SetPagePrivate(zpdesc_page(zpdesc));
> @@ -2051,17 +2055,7 @@ static int calculate_zspage_chain_size(int class_size)
>  	return chain_size;
>  }
>  
> -/**
> - * zs_create_pool - Creates an allocation pool to work from.
> - * @name: pool name to be created
> - *
> - * This function must be called before anything when using
> - * the zsmalloc allocator.
> - *
> - * On success, a pointer to the newly created pool is returned,
> - * otherwise NULL.
> - */
> -struct zs_pool *zs_create_pool(const char *name)
> +static struct zs_pool *__zs_create_pool(const char *name)
>  {
>  	int i;
>  	struct zs_pool *pool;
> @@ -2170,9 +2164,29 @@ struct zs_pool *zs_create_pool(const char *name)
>  	zs_destroy_pool(pool);
>  	return NULL;
>  }
> +
> +/**
> + * zs_create_pool - Creates an allocation pool to work from.
> + * @name: pool name to be created
> + *
> + * This function must be called before anything when using
> + * the zsmalloc allocator.
> + *
> + * On success, a pointer to the newly created pool is returned,
> + * otherwise NULL.
> + */
> +struct zs_pool *zs_create_pool(const char *name)
> +{
> +#ifdef CONFIG_ZSMALLOC_SINGLETON_POOL
> +	return zs_singleton_pool;
> +#else
> +	return __zs_create_pool(name);
> +#endif
> +
> +}
>  EXPORT_SYMBOL_GPL(zs_create_pool);
>  
> -void zs_destroy_pool(struct zs_pool *pool)
> +static void __zs_destroy_pool(struct zs_pool *pool)
>  {
>  	int i;
>  
> @@ -2203,8 +2217,35 @@ void zs_destroy_pool(struct zs_pool *pool)
>  	kfree(pool->name);
>  	kfree(pool);
>  }
> +
> +void zs_destroy_pool(struct zs_pool *pool __maybe_unused)
> +{
> +#ifndef CONFIG_ZSMALLOC_SINGLETON_POOL
> +	__zs_destroy_pool(pool);
> +#endif
> +}
>  EXPORT_SYMBOL_GPL(zs_destroy_pool);
>  
> +static void zs_destroy_singleton_pool(void)
> +{
> +#ifdef CONFIG_ZSMALLOC_SINGLETON_POOL
> +	if (zs_singleton_pool) {
> +		__zs_destroy_pool(zs_singleton_pool);
> +		zs_singleton_pool = NULL;
> +	}
> +#endif
> +}
> +
> +static int zs_create_singleton_pool(void)
> +{
> +#ifdef CONFIG_ZSMALLOC_SINGLETON_POOL
> +	zs_singleton_pool = __zs_create_pool("zsmalloc");
> +	if (!zs_singleton_pool)
> +		return -ENOMEM;
> +#endif
> +	return 0;
> +}
> +
>  static void zs_destroy_caches(void)
>  {
>  	kmem_cache_destroy(handle_cachep);
> @@ -2235,9 +2276,16 @@ static int __init zs_init(void)
>  	if (rc)
>  		return rc;
>  
> +	rc = zs_create_singleton_pool();
> +	if (rc) {
> +		zs_destroy_caches();
> +		return rc;
> +	}
> +
>  #ifdef CONFIG_COMPACTION
>  	rc = set_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
>  	if (rc) {
> +		zs_destroy_singleton_pool();
>  		zs_destroy_caches();
>  		return rc;
>  	}
> @@ -2252,6 +2300,7 @@ static void __exit zs_exit(void)
>  	set_movable_ops(NULL, PGTY_zsmalloc);
>  #endif
>  	zs_stat_exit();
> +	zs_destroy_singleton_pool();
>  	zs_destroy_caches();
>  }
>  
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

