Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24A8CA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 18:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B04D8E0006; Fri,  5 Sep 2025 14:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487EB8E0001; Fri,  5 Sep 2025 14:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C92B8E0006; Fri,  5 Sep 2025 14:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5C48E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:58:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F01085571
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:58:57 +0000 (UTC)
X-FDA: 83856108714.27.A1C7A46
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id BFE7780004
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:58:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CmAZIflN;
	spf=pass (imf30.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757098735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQ3ZV2rIcZqWrNTn60s3bJyix3OLwt0qzQmfA3uB8V4=;
	b=seaGsrwzlqilqc6AiOkba+nGgGjv3oAXMR52IDkOwk3qDHGWIxWi3Dt33uLoK7aj7BSd9g
	5jOeGBVoO39MC+XRhyYYFEFy94Dm6iCpdGxctnQcWuP1zQ3wrTKvGlnANcl5Vp9MKkH6tL
	FD/5okq5F/60p26LdBatxs2ofHyJWFw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CmAZIflN;
	spf=pass (imf30.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757098735; a=rsa-sha256;
	cv=none;
	b=ELdouXMclWU8Ln3a2X6M6feDpCf0BU+xEThj4Wbsqot+CVomzOGMGb1ZzpRFdj3FI/IAYP
	KLso1Imr5AqUfnPT2Dr9bmgxu5kU4JNO17gcp/yfXUnpBdNdOyERkYINeF2m3UxuzSvLBz
	EiMVRpP8v4B5K/ggs1PZ/dnNXRpdBBM=
Date: Fri, 5 Sep 2025 18:58:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757098733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KQ3ZV2rIcZqWrNTn60s3bJyix3OLwt0qzQmfA3uB8V4=;
	b=CmAZIflNjkLkw8GZc13r30pIOLfga26PwOImCr/jXxTkHxN5K9+ItoBAnh5K8hTnZw3gCT
	M/7Q1nSxa1W06D88NF46oILU0E0aED6r5aCX7+hIHyFoIqfGP/ndUaB9DWFvYvkCwwHmdZ
	oUGkBV/heXKDqzgHCK9MuDUhZ6813Cw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: remove unused zpool layer
Message-ID: <rcxmemdxbxuvtag2qv4sjxoh7ho4z3bz3od6i76rc5yholx2rc@vncn6iuuee7b>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250829162212.208258-3-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829162212.208258-3-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zxro8rnnc3iky6534eu7fdznabqb9yhu
X-Rspam-User: 
X-Rspamd-Queue-Id: BFE7780004
X-Rspamd-Server: rspam05
X-HE-Tag: 1757098735-144223
X-HE-Meta: U2FsdGVkX1/QZywvIvgauQOuiMD1oYBvrWZbqbHaZG6BHR+Fq18kYR3uqkXETp4pqbYJta5umQcQkSGeYZ5kTOjVknGVeO/LdlJCB50ltouKEiE59IvntZlRf/HjBku03En7ooLxIUr18AMmWKWf3KwNqyx34wH/LNxahACQoMKtDWDaeerwkuC4OeF01ltfy7L+aFidQLvO7DPdogri2HGFtAK6OXvewokBMV9Lz+PnFe+w+9o7XThwm+b3aQmdsZiTJI37xd5hzuzqBv4rR+4yjGHnhnM3bY5IYFLeuLvwnM1S803FYFtORe2jNbqGDgnqcZpWZz/usVV8xJ6/gaVuWi1Nso7vmKrBXxfgCXOBSK/uv38S55505Ivd5heYj7dC1yXvKM26UHf6hhzZqncr+LcArhs8gOOtRViLI+ndQD4GLS2fjXUsU0SovIYEqqcYyKP14fHrOmbOcVy5RVg9sJoblL4XxJN8QFevdcpvfpZGBqge4wylnn1IeiYQ/QkJkM6p8o4gzQoiS0cnVbmUgan+ZdjptAM4h7n5X0FVzqI+js8ySktgOCI9j/eDDzBzNt1xcPWZDFslbvp2VzXpPxy1mIiiXacEQtrhJgKYwgxxoYRQIjKuH7b6DiDh1CF0QMmP3oVvJnL8CvRCNLQHF8RJFqXAlQPeDD7kHDD2WVZ3F+OdchgtZDux6rlXAl5zRFtmojStiOL/NQNb1RZcXQFqafaCcU+IZ70P1+mUPixnasLvy5pWQ5z+zlckAIx0ygXZitIleshW591KXxCjEbroBrFpFiThejKTqDmfpVsNF0J8YnT1SFYRDRZakjtasZT2NHGFTeSNqriqbcOMVXqdLNp4/MqhYp0cTGHq6FShulNmaFUOGdE998otBoGtbF1gpBoVMb3/5Ha4+DIvAiCCE0RusoB2Eu3ZuMt4GOgbXDs5o/kHf0i78hlfADj26liWyrrD9a0wbxZ
 GMDY4Pvt
 aJhEK5zygBzRzkwAoBzSZ1H+/XsIIxn1juyCpyYlvmAyVJt4DaoDzoedeRX61U1ZpO1M+uMRrITZ1TbW+x2sSic0hVdeF7jp27uh2lBPV7HJ3XeAHECBiUUb/J/3qKAqAPrUeULQSBZyhhNRVHZEZ5fQqtm6xzZIvThIZjw+JUYru8hZ61VzFgSypXCVhOqug5jxwkGEjrhsnsDQqzhHFek5hD+uzaGUrOQI2X+9m0MtBECfcrx1cgNRERk1WP0y7+H+kCFTc8pH0gEs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 05:15:27PM +0100, Johannes Weiner wrote:
> With zswap using zsmalloc directly, there are no more in-tree users of
> this code. Remove it.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
[..]
> @@ -125,45 +122,18 @@ config ZSWAP_COMPRESSOR_DEFAULT
>         default "zstd" if ZSWAP_COMPRESSOR_DEFAULT_ZSTD
>         default ""
>  
> -choice
> -	prompt "Default allocator"
> -	depends on ZSWAP
> -	default ZSWAP_ZPOOL_DEFAULT_ZSMALLOC if MMU
> -	help
> -	  Selects the default allocator for the compressed cache for
> -	  swap pages.
> -	  The default is 'zbud' for compatibility, however please do
> -	  read the description of each of the allocators below before
> -	  making a right choice.
> -
> -	  The selection made here can be overridden by using the kernel
> -	  command line 'zswap.zpool=' option.
> +config ZSMALLOC
> +	tristate
>  
> -config ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
> -	bool "zsmalloc"
> -	select ZSMALLOC
> -	help
> -	  Use the zsmalloc allocator as the default allocator.
> -endchoice
> +if ZSMALLOC
>  
> -config ZSWAP_ZPOOL_DEFAULT
> -       string
> -       depends on ZSWAP
> -       default "zsmalloc" if ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
> -       default ""
> +menu "Zsmalloc allocator options"
> +	depends on ZSMALLOC
>  
> -config ZSMALLOC
> -	tristate
> -	prompt "N:1 compression allocator (zsmalloc)" if (ZSWAP || ZRAM)
> -	depends on MMU
> -	help
> -	  zsmalloc is a slab-based memory allocator designed to store
> -	  pages of various compression levels efficiently. It achieves
> -	  the highest storage density with the least amount of fragmentation.

Why remove the prompt and help text here?

> +comment "Zsmalloc is a common backend allocator for zswap & zram"
>  
>  config ZSMALLOC_STAT
>  	bool "Export zsmalloc statistics"
> -	depends on ZSMALLOC
>  	select DEBUG_FS
>  	help
>  	  This option enables code in the zsmalloc to collect various
[..]

