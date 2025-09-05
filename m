Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A94A0CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 18:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE5408E0006; Fri,  5 Sep 2025 14:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95788E0001; Fri,  5 Sep 2025 14:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ABDC8E0006; Fri,  5 Sep 2025 14:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8335F8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:53:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2683C118547
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:53:25 +0000 (UTC)
X-FDA: 83856094770.12.C145A6D
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf25.hostedemail.com (Postfix) with ESMTP id 50C7BA0008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:53:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rWJfsIBe;
	spf=pass (imf25.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757098403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GFrZHAdnL5vuRC8mNJl86GVBWYQcUC0CUwEWAjwZ5Os=;
	b=v8UKjrs0U9p/hgCbklDBvceAXtR5WmJy2McTNxTI0jBEpsaanz5xr1MdYwvkIiHiOOdMB3
	dw1O+fHckAEe6Qzn/My6ayjlOdmAI8EXC1+CnGjfCeiumQtBryH6wNgNvLeSnL/kexV81C
	ry+yJcarYqWNORDQJgX22786DQYX6Cg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rWJfsIBe;
	spf=pass (imf25.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757098403; a=rsa-sha256;
	cv=none;
	b=espAwKKmqqixlKfwbYoRn0nJQxWh0JDFrUphiBEEq5h50nYBunjoxcGKf9Y0M3HhETnbKl
	ImJqeLi0Fv/tQPxpnGNfFnuP4ipXla+17Cbxc6hqnjtbmSoQvfrWabqgDkzIOaunFK0mnw
	+qGQfs2jJkw2W5dEgW50kWcigKRzC3o=
Date: Fri, 5 Sep 2025 18:53:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757098399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GFrZHAdnL5vuRC8mNJl86GVBWYQcUC0CUwEWAjwZ5Os=;
	b=rWJfsIBelsOcCsUfbSOTUwgGLrFU8FzW4E9TiZ9L/wgQQu/tUmCpA8DJ0fflwpGj8HHmDz
	maqoRNr1+3dC7Ps/M2hGAZKsoUVvDsQxnHa9tApDxg36f84fDG3H/yatr8TuAx9EJ9xjjn
	c8kxqnXdPY2O/abRQ0N3FGMkKPudomg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: zswap: interact directly with zsmalloc
Message-ID: <r3dzlbqyvhaho5zuac7eba6pxz47zy3cz4lopxza3ls3ibadlh@6evm5aryyuxp>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250829162212.208258-2-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829162212.208258-2-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 50C7BA0008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 363d9wjdk4keunjnrcx6jcanyqzr3w61
X-HE-Tag: 1757098403-110716
X-HE-Meta: U2FsdGVkX1/u8+ubtDi5LfxweHAmoqYn2gg8hxQZG57FyPF8nZMOv5Xnd25EuioqoXWcPLuNs6icO2IZluV+uWxN3VVSADeBjcXzIhGQPnXaaX1c/ryJ7HAJRSKhqx6syTdCu9qs52L0nTjytOd5y6ZxHNKbIXaus1ZEw3LMgIJrGjfX8JAae3Z/i6skxKADyBG57rOGouW1vei4LYoCpFqzoEfTkFtIe5TfjxLOupRjfLgxngV+zNxii9qFL3NRTs0cB6GrAMY+3zyAJBAcgcsKpNq/C5jvQSUp+sI3H3cRw9PkdaGyFv3iAxPbNcso1zdgD8CxsEW1Ek/rr53JNamUbxDJNEhg9kYbViVdBxdfTNjDm/+aeKyUSXTs/Hn6+edWbm/77J5UCT7CIb3aYprsiX0fmKyIfyC5Wc5QzT6QeV084cigLVV8PlTC3J5ENoSJ5VDCVXwQX5uTcubECROwqYybaCEXh1A3fVU7xN92L2ig6vIOaK5fsz3CXLvDiJvYbTc4P1I+DJ+oDdddKkvdShs/EvUzoCAznV8FUnBZe3X44P/55NzrwZINzp27w+u4Tcp6dly/3+l+Jp2SZUMXsbGKl9kPJZBIrJ2t+ahLHUazW7gj/PRYoXVlwibutAFnuyjxoVZNqPVxEQy/tzUdLS1hiLvGtFSrOOe0kfPoC3RzbikYD1XcA7OhDS57NWql3CYg78Cj/9sTLD960H8UZ+K4RkI1ShZ4TfSsCRBFg8ftisQSQvE0N0tPLZ9oSUsNNky056JbzGNu3aT0ZiPTHYfcIQW4bVJwGynheV0qepg8aTbTN2qG0Ixn2e0zPoSitPJqYkL7LZcgj0YDCkKiThdUUD+wS4R5MN07DXM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 05:15:26PM +0100, Johannes Weiner wrote:
> zswap goes through the zpool layer to enable runtime-switching of
> allocator backends for compressed data. However, since zbud and z3fold
> were removed in 6.15, zsmalloc has been the only option available.
> 
> As such, the zpool indirection is unnecessary. Make zswap deal with
> zsmalloc directly. This is comparable to zram, which also directly
> interacts with zsmalloc and has never supported a different backend.
> 
> Note that this does not preclude future improvements and experiments
> with different allocation strategies. Should it become necessary, it's
> possible to provide an alternate implementation for the zsmalloc API,
> selectable at compile time. However, zsmalloc is also rather mature
> and feature rich, with years of widespread production exposure; it's
> encouraged to make incremental improvements rather than fork it.
> 
> In any case, the complexity of runtime pluggability seems excessive
> and unjustified at this time. Switch zswap to zsmalloc to remove the
> last user of the zpool API.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
[..]
> @@ -315,52 +292,29 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
>  error:
>  	if (pool->acomp_ctx)
>  		free_percpu(pool->acomp_ctx);
> -	if (pool->zpool)
> -		zpool_destroy_pool(pool->zpool);
> +	if (pool->zs_pool)
> +		zs_destroy_pool(pool->zs_pool);
>  	kfree(pool);
>  	return NULL;
>  }
>  
>  static struct zswap_pool *__zswap_pool_create_fallback(void)
>  {
> -	bool has_comp, has_zpool;
> -
> -	has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
> -	if (!has_comp && strcmp(zswap_compressor,
> -				CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
> +	if (!crypto_has_acomp(zswap_compressor, 0, 0) &&
> +	    strcmp(zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
>  		pr_err("compressor %s not available, using default %s\n",
>  		       zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
>  		param_free_charp(&zswap_compressor);
>  		zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
> -		has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
> -	}
> -	if (!has_comp) {
> -		pr_err("default compressor %s not available\n",
> -		       zswap_compressor);
> -		param_free_charp(&zswap_compressor);
> -		zswap_compressor = ZSWAP_PARAM_UNSET;
> -	}
> -
> -	has_zpool = zpool_has_pool(zswap_zpool_type);
> -	if (!has_zpool && strcmp(zswap_zpool_type,
> -				 CONFIG_ZSWAP_ZPOOL_DEFAULT)) {
> -		pr_err("zpool %s not available, using default %s\n",
> -		       zswap_zpool_type, CONFIG_ZSWAP_ZPOOL_DEFAULT);
> -		param_free_charp(&zswap_zpool_type);
> -		zswap_zpool_type = CONFIG_ZSWAP_ZPOOL_DEFAULT;
> -		has_zpool = zpool_has_pool(zswap_zpool_type);
> -	}
> -	if (!has_zpool) {
> -		pr_err("default zpool %s not available\n",
> -		       zswap_zpool_type);
> -		param_free_charp(&zswap_zpool_type);
> -		zswap_zpool_type = ZSWAP_PARAM_UNSET;
> +		if (!crypto_has_acomp(zswap_compressor, 0, 0)) {
> +			pr_err("default compressor %s not available\n",
> +			       zswap_compressor);
> +			zswap_compressor = ZSWAP_PARAM_UNSET;
> +			return NULL;
> +		}

Hmm it seems like there may be a change of behavior here. If
zswap_compressor == CONFIG_ZSWAP_COMPRESSOR_DEFAULT at the beginning and
crypto_has_acomp() returns false, the old code will go into the second
if (!has_comp) block, printing an error, freeing the string, and setting
zswap_compressor to ZSWAP_PARAM_UNSET, then we eventually return NULL.

It seems like the new code will just call zswap_pool_create() anyway.

Am I missing something here?

