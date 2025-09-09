Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECB6CCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262818E0012; Tue,  9 Sep 2025 16:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214658E0001; Tue,  9 Sep 2025 16:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1505D8E0012; Tue,  9 Sep 2025 16:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 052A98E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:11:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9CBAF13B464
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:11:06 +0000 (UTC)
X-FDA: 83870805732.16.C0D5196
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id 74999C000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:11:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OhQBNah4;
	spf=pass (imf10.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4eYRTxjvnA6MW/zv+G899pRJVXBN4zrOcQfsvxM2GA=;
	b=zGcDPwcHMMHpVcuKnOPV9dt/wp785eRuXucHYZx3DVjNvVsoK9DPXL5qvGeoZ8ZtlgwoPo
	T8Yn6g/rju6lOh0MoIc/qnanbIIYtXITg+fFAKbeRkYMwVDZVFifn3yhn/m2LYpc2NVGzr
	+CrjUAho+mhDUmtRJJ4xE0y/6M7OuT4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448664; a=rsa-sha256;
	cv=none;
	b=LrorR4n43oGqAhsY9ZBNZYs/vB4izIw75WM5Xa3drCOHg57bTnGjpDIcxplIg+IBaVJW22
	WRu8bukEc7h/1oPVjgL5IOLYi1amh/V4Q4FZ9YU8Pa4GJypvChLJwHHVTMZSRaAQfzWsla
	UOxEKozmk9HZ9fcThyRv6y5LBSi81t4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OhQBNah4;
	spf=pass (imf10.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 9 Sep 2025 20:10:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757448662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f4eYRTxjvnA6MW/zv+G899pRJVXBN4zrOcQfsvxM2GA=;
	b=OhQBNah4OLU8MJa4JvL0i4ShrB+X7l5Tv4/Pfk0Q2htMlWHDzjwUkXCIstGjBDfQ3He6DC
	Ecg4o9i4CVGY/7MhNbAZYfMxqZ4pKNqbUPZkYkpGMxWWrBdlDibKWkTJ5ceTxZhH5ejSPB
	RQzbrERB3ahhdPkvzIWJp3QRQXwtUSM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: zswap: interact directly with zsmalloc
Message-ID: <46xtfjznexpdlemxjwykin5k74oqomedb2fyli5jrb4xnquuke@ztcmxhmhlkx7>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250829162212.208258-2-hannes@cmpxchg.org>
 <r3dzlbqyvhaho5zuac7eba6pxz47zy3cz4lopxza3ls3ibadlh@6evm5aryyuxp>
 <20250909150156.GB1474@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909150156.GB1474@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gd9x64798ww8rjwcpemfksdqx14khoca
X-Rspam-User: 
X-Rspamd-Queue-Id: 74999C000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1757448664-792600
X-HE-Meta: U2FsdGVkX1+cTHRRdKc+15RH6XZ0KLVCV0EMfh0rsYZIfS3T8Cm03eJAslzLoksaSWnvsoIB42imJAnjiqY4QqdApBFHogU/qNmqQwLApsoiKyca6TrZDGeflEfeCoxYApY03CdRZorYlD6ZypZZ1lJm7W1JM9vWeFDRZrb2OE2IKxbYV0PtjEF1GVzJaGBXky7L84tuXwfLq/vCJKttO4mTcABgEe72DbVMNsLiyoe8iCXxkTQbsc8REdDAzVGgUbAwvhHAzCghwWHzuWre1v+4rbRJF1l82J5/WYaQ5eUTsJfsZzg8cTt+dqOhe3UtZP194h6eNDlAvtK9A3ecMxtf4r2x7BYe7hmLyOi0Va9eL2LoGAO+Jdcb3G2az+P3lJ/O57DS4VbWqEkBBaNstK0yqg3EnplXMooDlSu00swCn96yizG8JzQxuoDqGhebuGRqJoxsMW73BE+701jLT+J6vG3QUjocRendkDwskP4zJLD03zEUd4zAJU13WAnnfyO444z2mB3iBdWm/sN+1geQSzzSKdSQj/TGZz8h2c9zhp9t8BFwYyplM9ooRnnYoiY8C7+DZ9Gy5O0QTyOE5KxTeWF9Dr6/oSkOezhSpFNH7pnWt54bTnkNsxF+tnri86/1KV+xFyLh0gdGTlJzsVuOsdjUoYXgaJGP/uwyD42PQ67qrUMCSAZtpK8pXpWpH7y0MxFszqsWfDJqtSsWkumYarT02SXmjBRWH0UbT2AkR1eOij+ihTeMW+PfZzroogKhC0FjM9xPmMlcR++CmBDhw6WBaQDzBnvp534RexU6UPcuQlKN0YB9UuG9cBq0OPsybOcrd56F2BpUBeBeOnzqHl8LrY0TioEZ/t4+pH4GgmRws0O8XB/2WPjKfd6nFFxgX6T/dhPqkdgHaL8Wf2VrlPorGZg1YFPhRaFd3h4F3uBjm4zUpuQf/A5ZL2wNDj3ARm+aNok6MtkgLp9
 M5sjaiwV
 RJ7GzCPfLaemed15FDM6WW32XZB3pvTJzyQQCE9jrSW66s/jkH9CpJF4E0aKu3VVi2vzLCzrBBIDDtOznCSK85E/IM4+492ZIMMzeMnJHAd/Bg0c9OkK2UK4cAr34ATEgCnlrv0InCdEQYvKLaFIwZ2TzeV7TW+otfErA0e410vzmrEC3k3KNmcr3RNfOkONr/TJ3mU2ZauqVMp9LIDPHb4NKHUxwk/TgfyJ//KgU3Ts1iRW2uL1C3HOupz3idhQuUI32z1NfCZwdh3ljKU/tthT4kcjR67At0YDyXfSJAQRmI7Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 04:01:56PM +0100, Johannes Weiner wrote:
> On Fri, Sep 05, 2025 at 06:53:15PM +0000, Yosry Ahmed wrote:
> > On Fri, Aug 29, 2025 at 05:15:26PM +0100, Johannes Weiner wrote:
> > > zswap goes through the zpool layer to enable runtime-switching of
> > > allocator backends for compressed data. However, since zbud and z3fold
> > > were removed in 6.15, zsmalloc has been the only option available.
> > > 
> > > As such, the zpool indirection is unnecessary. Make zswap deal with
> > > zsmalloc directly. This is comparable to zram, which also directly
> > > interacts with zsmalloc and has never supported a different backend.
> > > 
> > > Note that this does not preclude future improvements and experiments
> > > with different allocation strategies. Should it become necessary, it's
> > > possible to provide an alternate implementation for the zsmalloc API,
> > > selectable at compile time. However, zsmalloc is also rather mature
> > > and feature rich, with years of widespread production exposure; it's
> > > encouraged to make incremental improvements rather than fork it.
> > > 
> > > In any case, the complexity of runtime pluggability seems excessive
> > > and unjustified at this time. Switch zswap to zsmalloc to remove the
> > > last user of the zpool API.
> > > 
> > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > > ---
> > [..]
> > > @@ -315,52 +292,29 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
> > >  error:
> > >  	if (pool->acomp_ctx)
> > >  		free_percpu(pool->acomp_ctx);
> > > -	if (pool->zpool)
> > > -		zpool_destroy_pool(pool->zpool);
> > > +	if (pool->zs_pool)
> > > +		zs_destroy_pool(pool->zs_pool);
> > >  	kfree(pool);
> > >  	return NULL;
> > >  }
> > >  
> > >  static struct zswap_pool *__zswap_pool_create_fallback(void)
> > >  {
> > > -	bool has_comp, has_zpool;
> > > -
> > > -	has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
> > > -	if (!has_comp && strcmp(zswap_compressor,
> > > -				CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
> > > +	if (!crypto_has_acomp(zswap_compressor, 0, 0) &&
> > > +	    strcmp(zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
> > >  		pr_err("compressor %s not available, using default %s\n",
> > >  		       zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
> > >  		param_free_charp(&zswap_compressor);
> > >  		zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
> > > -		has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
> > > -	}
> > > -	if (!has_comp) {
> > > -		pr_err("default compressor %s not available\n",
> > > -		       zswap_compressor);
> > > -		param_free_charp(&zswap_compressor);
> > > -		zswap_compressor = ZSWAP_PARAM_UNSET;
> > > -	}
> > > -
> > > -	has_zpool = zpool_has_pool(zswap_zpool_type);
> > > -	if (!has_zpool && strcmp(zswap_zpool_type,
> > > -				 CONFIG_ZSWAP_ZPOOL_DEFAULT)) {
> > > -		pr_err("zpool %s not available, using default %s\n",
> > > -		       zswap_zpool_type, CONFIG_ZSWAP_ZPOOL_DEFAULT);
> > > -		param_free_charp(&zswap_zpool_type);
> > > -		zswap_zpool_type = CONFIG_ZSWAP_ZPOOL_DEFAULT;
> > > -		has_zpool = zpool_has_pool(zswap_zpool_type);
> > > -	}
> > > -	if (!has_zpool) {
> > > -		pr_err("default zpool %s not available\n",
> > > -		       zswap_zpool_type);
> > > -		param_free_charp(&zswap_zpool_type);
> > > -		zswap_zpool_type = ZSWAP_PARAM_UNSET;
> > > +		if (!crypto_has_acomp(zswap_compressor, 0, 0)) {
> > > +			pr_err("default compressor %s not available\n",
> > > +			       zswap_compressor);
> > > +			zswap_compressor = ZSWAP_PARAM_UNSET;
> > > +			return NULL;
> > > +		}
> > 
> > Hmm it seems like there may be a change of behavior here. If
> > zswap_compressor == CONFIG_ZSWAP_COMPRESSOR_DEFAULT at the beginning and
> > crypto_has_acomp() returns false, the old code will go into the second
> > if (!has_comp) block, printing an error, freeing the string, and setting
> > zswap_compressor to ZSWAP_PARAM_UNSET, then we eventually return NULL.
> > 
> > It seems like the new code will just call zswap_pool_create() anyway.
> > 
> > Am I missing something here?
> 
> I don't think that scenario is possible, due to the way the Kconfig
> works. Whatever backend I select for CONFIG_ZSWAP_COMPRESSOR_DEFAULT
> pulls in the crypto module as built-in/=y. It should always be there.

What if none of the CONFIG_ZSWAP_COMPRESSOR_DEFAULT_* options are
selected (i.e. empty string)? Also, can CONFIG_ZSWAP_COMPRESSOR_DEFAULT
be set directly to an arbitrary string?

I would prefer if the code behavior did not change to rely on the config
possibilities.

