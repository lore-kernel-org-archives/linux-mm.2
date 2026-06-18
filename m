Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C25ECD98F0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 23:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E41516B0088; Thu, 18 Jun 2026 19:02:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCC796B008A; Thu, 18 Jun 2026 19:02:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93F86B008C; Thu, 18 Jun 2026 19:02:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89A3E6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 19:02:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED3B61A0243
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 23:02:51 +0000 (UTC)
X-FDA: 84894560142.04.ECA6FE8
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5720620007
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 23:02:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cCKIzVae;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf13.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781823770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4j6dypNydyNZWpcmpTVOpkkjjc8wCdYie1REZ5aJwCU=;
	b=GfZWd4sidSeLQVpuPQFMT/u62NMmTJvJ800FtEETNfl9tWnufmRlDLZSm+O99mKI8Hlmfr
	TSxj3ERaORYSClIAzUlc1fB72eYIU8MXBLbu+zxUZDPpWMkeJa22f/HbzQzlmKbUf+X5JP
	Wa2ZKQopSSKls5hV8go5Hu52E7f3Zco=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cCKIzVae;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf13.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781823770;
	b=Gus9TzWqWerL1aslIkzFpKnteTUQxCipNVRzpuqyUAChUT4gcuDf62G8LQz+tyqbktXx9r
	OPvuaoW8A1u9kkJRVnHkPlWJqNDu1ePSqis9oxcHrywh3kDoFAM5kf5UnHndemYL+aHgQZ
	gjraYHcEGRG/vRYbUBWo+ktVHsHLBN0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=4j6dypNydyNZWpcmpTVOpkkjjc8wCdYie1REZ5aJwCU=; b=cCKIzVaeKyEvueahgMfXWkQCmj
	Qe72fL1qIvGWlRb4X/kTKZSinScDQVhcTXU7H53EQroz4X8/a67OMv5i2LK6xtzX/5mfLyTeFE280
	rlSXvZeoDLLbTWwckGWZI/purqhGqXzcO4mRzdNKfvrPQ24QSFkM0C1L+ubryKPYap3x2J1wJ5xds
	wbkWWW8z81kUanG1PzqTakan53bNvm2nIYsN8I+D8jzVs1C4dCEYVgw5HkvPlg1hP5l6UmLUgsN5R
	1B6lVQyi2HcgnjxvBzaidSD0GQeX5r8IQXIz0v/ORHTB5Ipz/IKvxmHH14kKFVAGmu0RE5jS0tgHZ
	WdigT2QQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waLky-00000001r4w-26uA;
	Thu, 18 Jun 2026 23:02:44 +0000
Message-ID: <0eaf3be2-5121-48b7-aeed-196405c0a480@infradead.org>
Date: Thu, 18 Jun 2026 16:02:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] reserve_mem: add support for static memory
To: Shyam Saini <shyamsaini@linux.microsoft.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: rppt@kernel.org, akpm@linux-foundation.org, kees@kernel.org,
 tony.luck@intel.com, gpiccoli@igalia.com, bp@alien8.de,
 peterz@infradead.org, feng.tang@linux.alibaba.com,
 dapeng1.mi@linux.intel.com, elver@google.com, enelsonmoore@gmail.com,
 kuba@kernel.org, lirongqing@baidu.com, ebiggers@kernel.org
References: <20260618224018.117978-1-shyamsaini@linux.microsoft.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260618224018.117978-1-shyamsaini@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5720620007
X-Stat-Signature: 5xd5wrco5xgp3b4oincwohjjm64bxfg5
X-Rspam-User: 
X-HE-Tag: 1781823769-687805
X-HE-Meta: U2FsdGVkX1/rzK0JCL7sva7jodF5lG/UhvEhh5JGkZ1cjJO9PEmPDqTxcSLOI0ZR6zFTo2/BD5W2USTA3/g2e3iEfXNoMNjwkmwXoCVtBDFrYTyvJhlOl+Kj4HrzfJQ/uhBaQKEbMCTUExGv4UvrCpzUNn6Szgxo/EWq131tb7KxN5OYIqNO+Rw+aR143rqdbfRCMrL1fbElY7+/FnVQJtIfxfdkZtPKNrWV2b3xNVfR/EoSI/xrId3NxnKc1ZrCfZe4HIa5TI3hb+lDU4OBsVNeIXMXEDsG7XQ+jbkXDNVSGlwKQzl3Izf6WOkjtlNLG7WzBl8XB8dM97Vfb94hGDpPk21eSAUOFwYPoGxAszo2fYtrSuZ3y8TFw9amMuyLnMxWqXiK2KI2z/IYrNu4b0/PwRRTs3oPjsMhIWnaxEQDDtknPAJo45XBct+Yfr2/DmwEUjwC7u1Ni6+KiCkv8V8LQ1EQQIRLCojuXmfVrxnGkmeStpVF56Qn57wZSsBbdpnfi/djExXtTcdvq7gO8RnMFiBdaeqRJASivELQamv9EkZ6HKjAzM0AiFoSoGyoDOJgxeUC8ko6ocXcNoONnYWt+oTkq9yKQP3shOqU8DFbI+3xvdWy7Pb6j94VXqzIDWl6xFxAC91+p+Q/XgwBi0IMnZIwJT8ua3W6UA28qKSS5s8tWbczhrBG/0Txd6xuCFD7kvUWtd3Kknw8BdpplI4pJ5TtfMiTFNuWWLNfcduu5yiny3/Iq3kI79FgCaoo0mFAyUsw0Rf2ldPwL86e2uWyX4a9Bj9oTJgf0a7N59I+EC7NRcULILSJqm7BG+Ye4T41rpjZu01oh1XiVT5CzWIyPVRBdjXFrWW648iIi9cad8tvR6HdXjjf2A+N3I3Gc7JSjt9N3JQiJVxJPb+USd1G3unRJBcvr0IJQlm6vyIw2Px1tsJdfwJLfZPfYYy3uJ7yBvvGCR99rLTvHAW
 G/mtgfGj
 /iE8oKB84lMNBhZMbSKoUwkqGwLyAXg7Tzyu+N7P+9MmqNwi/zQRFi7hLkGxc+H7uYrXRcMdiLFigMZjrLL8AgeUsVgSefm1Db28brbvykkRAr2jr301GmgkrY6TJLRZ4QmzH8Kei865w+TBfyI7koF3lXz4UcJBfARQulSMNIiinJvdJVLIbUmQFcEh4tvoMkyXkp9APKAZoz3dGNrPlu2rbCvqnVadN5rL9zwZPZDYLgVPv1UU+2GSFjsXIfA6pWonEMLFs2N91Q2O56wq369nWIXzwsGT5KwODlwbPl4YxNZ6MuHBFqmpM7UYPPxoAgomnZ+TBlzL23eN6ZsvyI6vRQ/9c8qCnkLjSe7570F89TH9wle9S9VV36eXW8w3mHIRwtV0RqiEV3D0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/18/26 3:40 PM, Shyam Saini wrote:
> reserve_mem relies on dynamic memory allocation, this limits the
> usecase where memory and its address is required to be preserved
> across the boots. Eg: ramoops memory reservation on ACPI platforms
> 
> So add support to pass a pre-determined static address and reserve
> memory at this specified address. This enables use case like ramoops
> on ACPI platforms to reliably access ramoops region across the boots.
> 
> Also skip parsing of "align" parameter when static address is passed.
> 
> Example syntax for static address
>  reserve_mem=4M@0x1E0000000:oops ramoops.mem_name=oops
> 
> Signed-off-by: Shyam Saini <shyamsaini@linux.microsoft.com>
> ---
>  .../admin-guide/kernel-parameters.txt         | 15 ++++++
>  mm/memblock.c                                 | 48 +++++++++++++------
>  2 files changed, 49 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index b5493a7f8f228..7e0baca564b97 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -6563,6 +6563,21 @@ Kernel parameters
>  
>  			reserve_mem=12M:4096:oops ramoops.mem_name=oops
>  
> +	reserve_mem=	[RAM]

According to this file (kernel-parameters.txt), "RAM" means that this
option applies when "RAM disk support is enabled."
Is that correct here?
My guess is that it's incorrect for the other (existing) "reserve_mem=" also.


> +			Format: nn[KMG]:<@offset>:<label>
> +			Reserve physical memory at pre-determined location and label it with

Preferably		                           predetermined

> +			a name that other subsystems can use to access it. This is typically
> +			used for systems that do not wipe the RAM, and this command
> +			line will try to reserve the same physical memory on
> +			soft reboots. Note, it is guaranteed to be the same
> +			location unless some other early allocation for eg: crashkernel=256M

			                                 allocation, e.g.: crashkernel=256M

> +                        (without static address) is reserved or overlapps this region.

			                                           overlaps

> +
> +			The format is size:offset:label for example, to request
> +			4 megabytes for ramoops at 0x1E0000000:
> +
> +			reserve_mem=4M@0x1E0000000:oops ramoops.mem_name=oops
> +
>  	reservetop=	[X86-32,EARLY]
>  			Format: nn[KMG]
>  			Reserves a hole at the top of the kernel virtual
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 6349c48154f4b..79f1f806ea364 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2721,6 +2721,7 @@ static int __init reserve_mem(char *p)
>  	char *name;
>  	char *oldp;
>  	int len;
> +	bool addr_is_static = false;
>  
>  	if (!p)
>  		goto err_param;
> @@ -2739,16 +2740,27 @@ static int __init reserve_mem(char *p)
>  	if (*p != ':')
>  		goto err_param;
>  
> -	align = memparse(p+1, &p);
> +	/* parse the static memory address */
> +	if (*p == '@') {
> +		start = memparse(p+1, &p);
> +		addr_is_static = true;
> +	}
> +
>  	if (*p != ':')
>  		goto err_param;
>  
> -	/*
> -	 * memblock_phys_alloc() doesn't like a zero size align,
> -	 * but it is OK for this command to have it.
> -	 */
> -	if (align < SMP_CACHE_BYTES)
> -		align = SMP_CACHE_BYTES;
> +	if (!addr_is_static) {
> +		align = memparse(p+1, &p);
> +		if (*p != ':')
> +			goto err_param;
> +
> +		/*
> +		 * memblock_phys_alloc() doesn't like a zero size align,
> +		 * but it is OK for this command to have it.
> +		 */
> +		if (align < SMP_CACHE_BYTES)
> +			align = SMP_CACHE_BYTES;
> +	}
>  
>  	name = p + 1;
>  	len = strlen(name);
> @@ -2772,16 +2784,24 @@ static int __init reserve_mem(char *p)
>  	}
>  
>  	/* Pick previous allocations up from KHO if available */
> -	if (reserve_mem_kho_revive(name, size, align))
> +	if (!addr_is_static && reserve_mem_kho_revive(name, size, align))
>  		return 1;
>  
> -	/* TODO: Allocation must be outside of scratch region */
> -	start = memblock_phys_alloc(size, align);
> -	if (!start) {
> -		pr_err("reserve_mem: memblock allocation failed\n");
> -		return -ENOMEM;
> -	}
> +	if (addr_is_static) {
> +		if (memblock_reserve(start, size)) {
> +			pr_err("reserve_mem: memblock reservation failed\n");
> +			return -ENOMEM;
> +		}
> +
> +	} else {
> +		/* TODO: Allocation must be outside of scratch region */
> +		start = memblock_phys_alloc(size, align);
> +		if (!start) {
> +			pr_err("reserve_mem: memblock allocation failed\n");
> +			return -ENOMEM;
> +		}
>  
> +	}
>  	reserved_mem_add(start, size, name);
>  
>  	return 1;

__setup() functions return 1 for "yes, I handled this option" (even if there
were errors in it) and 0 for failure ("no idea what this string/option means").
These -ENOMEM, -EINVAL, -EBUSY (in this function) are non-zero so they look like
success and should not be here.

-- 
~Randy


