Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15856CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 18:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFC666B0005; Fri, 19 Jun 2026 14:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAE9B6B008A; Fri, 19 Jun 2026 14:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC54D6B008C; Fri, 19 Jun 2026 14:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B05246B0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:35:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D10FC1C70
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 18:35:48 +0000 (UTC)
X-FDA: 84897515976.05.B9D6B51
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id AA2C31C0003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 18:35:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vxqlTXYb;
	spf=pass (imf20.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781894146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQMxCGsJgO5z4xKjYc47x9IC9JtLm1aAXZzKHP5+ngY=;
	b=T0rZuXznVZ3npDsycB6I46qQKzWswvpYr/0/ZRKiZHp3hxUnPeLR4WWVC7pPf6zH4SRRnN
	dpzkmRXl5W+Taq3Bysac6iu78kvtlmWPFcCXU7b7DCTlr5tkFBeli8qYUMkviaZe8e4rdg
	RiQyUEuXiP74ne3Y1AqmL8YnaU8WpWs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vxqlTXYb;
	spf=pass (imf20.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781894146;
	b=ug696XBWyhvLFID4otmybaq3EI/E2DKSCYMLA3mYFYppRi3R4ZzRJbDPct3akAYiTyLTZY
	Xba0zHZ3nLgydnBq2Q1rveBD5fBwNm9/zFTN7n3zqlMJzCfqHyM3uTyH1om58OJ1tCr+tf
	AZX7xvSqg79vC0YjA7RRGkKwnyCHe18=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=JQMxCGsJgO5z4xKjYc47x9IC9JtLm1aAXZzKHP5+ngY=; b=vxqlTXYb+ohjD3QbIDox/VbpTZ
	hd7Uy+grwldfWVL2kS3Bu5GhxUZywxzL93GgqLNnYWvaH2q2e2RGX/7B2hyM1YHZ+xzhignyfZaUz
	8dTQ/PJOuX3u0zlWiP+cYGe+TzOx7dq3h9c13Q7vFHhb0C3G4isI5awLfBC4k7dlV/q+DnGU/L3uB
	U9T0jcPxT6mZ3RX74b9IIVrPBYgXti2EPXjdUvmgAt0C6iK7uPtykmF+g+/VK9H0duCp7550a/8Wc
	ZLxZr/MvhvXaX35nyYn96fpCGmXeasV4GyzVYOPH8MO87lMjIoVA6WAM+1pigXsIA5mvZyhMH6BUf
	O2Sz6BpA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wae42-00000002snX-3wNA;
	Fri, 19 Jun 2026 18:35:38 +0000
Message-ID: <3e206be0-3ef4-468f-b7e7-7bc03848b0d0@infradead.org>
Date: Fri, 19 Jun 2026 11:35:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH] reserve_mem: add support for static memory
To: Shyam Saini <shyamsaini@linux.microsoft.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: rppt@kernel.org, akpm@linux-foundation.org,
 tgopinath@linux.microsoft.com, bboscaccy@linux.microsoft.com,
 kees@kernel.org, tony.luck@intel.com, gpiccoli@igalia.com, bp@alien8.de,
 peterz@infradead.org, feng.tang@linux.alibaba.com,
 dapeng1.mi@linux.intel.com, elver@google.com, enelsonmoore@gmail.com,
 kuba@kernel.org, lirongqing@baidu.com, ebiggers@kernel.org
References: <20260619062331.348789-1-shyamsaini@linux.microsoft.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260619062331.348789-1-shyamsaini@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AA2C31C0003
X-Stat-Signature: co1rn6x4p6n44cnfkwpe53yedd68y5wr
X-Rspam-User: 
X-HE-Tag: 1781894145-581231
X-HE-Meta: U2FsdGVkX19GlUrFQOnSRpkvncmoC3GFQBHrgxX13lYcRGtCYk8A7Y+dd7BW7nltndqDjrdpEiuuiI3oB7omqzeVTWauf8LxTPg2fkaFcXAJuZeWsAt9epycOoAH61sP3L5n8l8QdmJmyEs42QTipnkpvdb4ImiNm0a3OThdhuK/BzVgDNbpJFjRhFXeSZFE+ukQc5gGk84PCGKQrfEW4sTvfKYj730+/Rwh0TVmV9JTq9sIBHO5SNoxcvz/6OL2pr56dpP13eVkZKMabaeTfqxxPnZZzc6AdABRWanx4cw9DZhIQ0Rjt+lmLBuTnvN1J+Lp+gxHUKibT22NN1wGQy5AGMghzWf/xW5pE4QuMooesOkzvxmzuM+3DMJFFEwJ3lE1OBZI8ObeVD+XFMk5QK5mlZQsNhLA3P/jdbyxfPtJr1mQCQZK/l5X+Ziyx0IhqpN7PrcdZAEPBPeiRsHbPFwbwgVP8GdgN3bjRdZShVLR6mlFVBm/RCxe7TkcleVf8VNprtxcMFyil07XXsb4VmYbWUMnQZHT2OuZ7dY0BInIRhiUP+RWFJTQz8jDasfhy7FrjGH54xnLfMEV4IuEv92Kp+ncO5oibKSUS1oIUoevFCS5/tKjasHFk8kEPVlyrhsX0yRmRY8n+FypMfyR58egrCm9ilOl5p7I5YG+KhNPKg7lr8M6BQI9BBf+ivCu+Hes5Ugum+UHlGfID7CQWqu2hwTeE72pZ3XeXeKksGvNKD+yaoIZwBA/Z6nVV5K4GGLCGHLA2cQFHK9u2RgUIZWaU32F10O/LrvoR7OEqzAK9XJiOxG+xk83re7krs1PX7neRKpIc76pkfvkPhAHEgm8OkKre9lxKb2CcEgH2vuw8MUGnuV3MoACIgUifVK/JqfYcE6EkKiiBHPXK0uc49XqUHKvcZf/QvjbzmnnwMpl4p3St9bdqlQUMynGeEJ2XkyLeE/hzUBxgnogN2f
 ImMg2iB4
 K5J042U5zXqsAMGIwjlIK2645wEjov8Zo7lZg7o87e8mrGA4vkKYPSOEHQ3nEPy7gFT7NPqnDhffsb6cTh/f/yFso5WnmT2WSUQw493Hg0IlGjYBPvFYrgLwmOip+ZlvWSUj4sIkpuuaawlwF/eiSgjsKFOn4jpw1w1JM/i3lv78G5QFsNp35I9R9Zosw4MSDqT4XS5fzg5M2ge0CWGmqQ5o/Xzot7vPj7T2NBFrhhovuUfPyVuNaWX8/kLq7HnbTmKMhGVsn9KkqynOCJSkGirC6oIwKcXX95YqPO/0YgZUCnmbjBwJSJLPujeonsgZv0R89CR3sfMM4NE0r4SB0I9IPwYgLkCgt5tCAsOuAw9AeYK/msA90gPvjwDrJ6DpGx9aN1S2Dkd29g6VCkr2E9VpBye9Gd9EqW8Gwz0oAkzVO+Ve8aClpsGc6rE8nC1OfFG3f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 6/18/26 11:23 PM, Shyam Saini wrote:
> reserve_mem relies on dynamic memory allocation, this limits the
> usecase where memory is required to be preserved across the boots.
> Eg: ramoops memory reservation on ACPI platforms
> 
> So add support to pass a pre-determined static address and reserve
> memory at a specified location. This enables use case like ramoops
> on ACPI platforms to reliably access ramoops region with previous
> boot logs.
> 
> Also skip the parsing of <align> when static address is passed.
> 
> Example syntax for static address
>  reserve_mem=4M@0x1E0000000:oops
> 
> Signed-off-by: Shyam Saini <shyamsaini@linux.microsoft.com>
> ---
> v1: https://lore.kernel.org/lkml/0eaf3be2-5121-48b7-aeed-196405c0a480@infradead.org/
> v2: Fix code logic and incorporate Randy's suggestion

OK, you fixed a few typos.
There are some bigger things that you seem to have ignored.

> ---
>  .../admin-guide/kernel-parameters.txt         | 15 ++++++
>  mm/memblock.c                                 | 47 +++++++++++++------
>  2 files changed, 47 insertions(+), 15 deletions(-)
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

[RAM] means "RAM disk support is enabled."
Is that the case here?  Is "reserve_mem=" only for use in case
RAM disk support is enabled?

ISTM that you need a new designator instead of RAM...
or overload the use of RAM by adding more info near the top of
Documentation/admin-guide/kernel-parameters.txt.


> +			Format: nn[KMG]:<@offset>:<label>
> +			Reserve physical memory at predetermined location and label it with
> +			a name that other subsystems can use to access it. This is typically
> +			used for systems that do not wipe the RAM, and this command
> +			line will try to reserve the same physical memory on
> +			soft reboots. Note, it is guaranteed to be the same
> +			location unless some other early allocation, e.g.: crashkernel=256M
> +                        (without static address) is reserved or overlaps this region.
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
> index 6349c48154f4b..c76cefa0a8a83 100644
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
> @@ -2736,19 +2737,27 @@ static int __init reserve_mem(char *p)
>  	if (!size || p == oldp)
>  		goto err_param;
>  
> -	if (*p != ':')
> -		goto err_param;
> +	/* parse the static memory address */
> +	if (*p == '@') {
> +		start = memparse(p+1, &p);
> +		addr_is_static = true;
> +	}
>  
> -	align = memparse(p+1, &p);
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
> @@ -2772,14 +2781,22 @@ static int __init reserve_mem(char *p)
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

		return 1;

> +	if (addr_is_static) {
> +		if (memblock_reserve(start, size)) {
> +			pr_err("reserve_mem: memblock reservation failed\n");
> +			return -ENOMEM;

			return 1;

> +		}
> +
> +	} else {
> +		/* TODO: Allocation must be outside of scratch region */
> +		start = memblock_phys_alloc(size, align);
> +		if (!start) {
> +			pr_err("reserve_mem: memblock allocation failed\n");
> +			return -ENOMEM;

			return 1;

> +		}
>  	}
>  
>  	reserved_mem_add(start, size, name);


__setup() functions return 1 for "yes, I recognized this string/option
and attempted to handle it" or 0 for "This string/option is meaningless."
There is no "return -Eerror".
If you need that, you could consider using early_param() [see
<linux/init.h>].

-- 
~Randy


