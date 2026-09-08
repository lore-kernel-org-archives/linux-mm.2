Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1A83C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03AD26B00BE; Tue,  8 Sep 2026 02:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014066B00BF; Tue,  8 Sep 2026 02:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91996B00C1; Tue,  8 Sep 2026 02:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C49BB6B00BE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:49:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5FD8A16037F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:49:08 +0000 (UTC)
X-FDA: 85189667976.16.3E3B866
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id AE21180005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:49:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GodIgLic;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788850146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+V0gQUek4roVUIMGP5SuDI1Fxh1F92NftXXq9vzYLk=;
	b=VhQ2L3igo4XlpLuz+UCyVt35F8BE9+t44GmTIUDZcFDzlIWGLx6AR272cpz2//Ac7qH7dl
	GpyvfSuYTnSz8/PpjHjOXtpgtwLy6ISe+cMPYtQz7OvOgDQ4bspvxmFynQYMVZtrdCK7Pg
	kC8dsYH1OZEx/R2IDnR1WegSyMGQg9o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788850146;
	b=pgw+1WZ8RNEe77e/sxAitpD9D37NLORc5B53qj4oNZvgZgnMOz3pfPOUdWSsBXunSxiKVd
	rdddBuZkyeBdoHajajIvxJ5f1j7Q+roi1JsoFHoOdWzmNJrCedJxR7WBD20yauoBpw5gvs
	+RTsmihrzI70WFWiudOZHIF85ampQMc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GodIgLic;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B0E043C84;
	Tue,  8 Sep 2026 06:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201601F00A3A;
	Tue,  8 Sep 2026 06:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788850145;
	bh=M+V0gQUek4roVUIMGP5SuDI1Fxh1F92NftXXq9vzYLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GodIgLiculBgnr1L+B/xHVBA/lvCV0+GpGc5f33ROX4ultFHutW9kCTSGKHsBeTmN
	 D1sZCeS9pgzZLXBnMZQ0gAKQRJqWU2ROPjZydEUoxjGnRsUNpXcZ+sHFrV1teWQmhZ
	 Ll9mQf3FUTUk3jS6iI5bBCpoJxE+O9p9JhlQcbE16ODDCQY+JuejoU4b6oNV3mjOUl
	 CT9+XBB0Q8REvLmfdvrZSEyWn9EYNJKdzEW3roxzBrqPYlXw/xXyQONeefURgnR+YL
	 HCVP5D9EIkxOY0fjgqb5xtPRq3JYC7GY98qRTn12zUWSQqGqa8OlqLApyhsWuus/f2
	 329hnatAS22IA==
Date: Tue, 8 Sep 2026 09:48:57 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v2] memblock: reject non-page-aligned reserve_mem regions
Message-ID: <ap-v2XUH2Usov_RK@kernel.org>
References: <20260905141526.1546478-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905141526.1546478-1-ekffu200098@gmail.com>
X-Stat-Signature: ftu87h58d4p7d7hk7m49c3gzji6uc7t8
X-Rspamd-Queue-Id: AE21180005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788850146-40902
X-HE-Meta: U2FsdGVkX1/6irGjLg58shAR3vqxI+S8VQg623AOtiBozhGtnJ8TcpIETghtPDew3x3ALWWVDQEVMyFDnep6U82azZKkd+tRUZuHgUPyrc+lyGp5SJ2P7NGMJtuQFPvcucBeS6hX0fiGTqkDEkWkN5L4KCjPrjF07Zy3bz2K7Sg4tlooJSaJw3MDenpiNRoXKqqBsoNSljTp7HH7W7Tpq+hio3SGj/reqyyEqUzkWUm44okXh7G+XrhQZJX2cun8bMdPowlp00kosNGA0LwQfmS7ZAEkPUXC8bqDQxc+ON/AvLLrBSF/9dyU0/Fam6V/8bmn3DIA4md9bV2tCSStN83bfLBjI88JiZWZChX8YH/zjiMinaK8m5WBL0tAGwj6sNM1OfoEgwum8/1CNNl40NLtUiY8zD5mfbSG+mWzCQ411lvXnIoRZVOmvybXYZwFIs9ByljVFw4d4UfBRaCSxBEBrfAgPaq+8evHQ8sEBLjNfPUrNZ50vlbetoGDOm12PHOtfw8ch7O1qR0Rzz0+w50Y3c9GwMkjPaQEuIQzX+AsB0MYlFMKIZVxtmJLm0Qt4lNjRWXKvckLjSm9Gp8PeexHGE6eyqyd+gsptkJVZYiowtvT4CKllg2CFFZMWpu79DcazNGFWk23AWs4UD5hqLob9NcpKNDqFpJezNsA8WsKAI8FpG+1ZfEGrFizwpZeJ1qrLbUN7vuWTNFXeBzXafvYLKzLFgpQnhn+1BG5g9ZY5WzjjyFBsF6OVh359zfz+f60bUxh6QvgaAfIWgbzxYcYqVuOAHdT7hbSxloluyTCUN0ujcaNyAg5BCapyrE5f0dumBNEH3KeZgVExnlEyQbn5WCWietUeyF2DFSBtV0lF8FA4S5HUQAvM+bKYjRkETXhRgCu9Dc3PjXlnWVJUsRgilChzzq7BYqYUWEXnKcmbXG9KhzObUcIGtDExY/s0bYKrxz9+epn44LkTlQ
 UfVnGDRk
 TcUuuNbUKk7hv0h+DWS6+YnFtscaQg4jHZb1W2ZnMcPk4rOU1XDJBhElrcmAs47qyecryo0mzd21sBLJKnqCBKNrkcA9PGUYh2TRuzW/0X7X4kruj3ejL/W01zL+StpeAXsoMDqEfdAZO0vF7ECrVRmCnMPFXaDXHKZr4DWPY7fZn53FrVHUPhYNCmqd7wJIlNe4Edv1OoZBevanjzZIO+otucbK1+1RmTkPwyOQK0elqKA3ZXUJHxKQrHRvxlOxhmsckK77KTg8KzdUwxQTGEaoNLRZu2wbFfPZRWOqbU100ZY0Xu2/9WGrrLgMLnkaNiFEXLXLj6IbEonedzElLUXnN+BGelK5zX9q/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(adding tracing and pstore folks)

On Sat, Sep 05, 2026 at 11:15:24PM +0900, Sang-Heon Jeon wrote:
> When map->start or map->size is not page aligned,
> reserved_mem_preserve() does not preserve the last one or two pages of
> the region from map->start to map->start + map->size.
> 
> After kexec the new kernel reserves only the preserved pages, so those
> pages are released to the buddy allocator. But
> reserve_mem_find_by_name() still returns the whole region including
> them, so they can be allocated while the subsystem is still using them.
> 
> So reject a reserve_mem= size or alignment that is not a multiple of
> PAGE_SIZE to keep both map->start and map->size page aligned.
> 
> Fixes: 8375b76517cb ("kho: replace kho_preserve_phys() with kho_preserve_pages()")
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> Changes from v1 [1]
> - reject non-page-aligned size and align instead of fix page count when
>   preserving reserve_mem regions
> 
> [1] https://lore.kernel.org/all/20260901165237.1025973-1-ekffu200098@gmail.com/
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 3 +++
>  mm/memblock.c                                   | 9 +++++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 68647ff4bdd2..f969085fffb7 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -6648,6 +6648,9 @@ Kernel parameters
>  
>  			reserve_mem=12M:4096:oops ramoops.mem_name=oops
>  
> +			Both the size and the alignment must be multiples of
> +			the page size.
> +
>  	reservetop=	[X86-32,EARLY]
>  			Format: nn[KMG]
>  			Reserves a hole at the top of the kernel virtual
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 4302fb4ab85c..5e93b6da53e3 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2816,12 +2816,17 @@ static int __init reserve_mem(char *p)
>  	if (*p != ':')
>  		goto err_param;
>  
> +	if (!IS_ALIGNED(size, PAGE_SIZE) || !IS_ALIGNED(align, PAGE_SIZE)) {
> +		pr_err("reserve_mem: size and align must be multiples of the page size\n");
> +		return -EINVAL;
> +	}
> +
>  	/*
>  	 * memblock_phys_alloc() doesn't like a zero size align,
>  	 * but it is OK for this command to have it.
>  	 */
> -	if (align < SMP_CACHE_BYTES)
> -		align = SMP_CACHE_BYTES;
> +	if (!align)
> +		align = PAGE_SIZE;
>  
>  	name = p + 1;
>  	len = strlen(name);
> 
> base-commit: dbffc67777cd752ef3f77818109e1d2ef13e2949
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

