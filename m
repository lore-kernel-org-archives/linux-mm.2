Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F45C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 05:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B4686B009B; Wed, 12 Aug 2026 01:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68B2A6B009D; Wed, 12 Aug 2026 01:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A4E26B009E; Wed, 12 Aug 2026 01:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 30FB06B009B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:47:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE0EBA0297
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:47:49 +0000 (UTC)
X-FDA: 85091535858.04.5F610C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id F2F3CA0006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:47:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ruEA3kvk;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786513668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IWjDjgp43HDOKAAvhXf6tJ9XRcep7H8R/FphtBkyvCY=;
	b=B2Ipd2DUF6a6zc4eObbqTWTmV9lymQupnpzQW0/fObN8tXOBgb/xuhlGX1yZ1ZUg7uCABK
	YvcE2FPF97a9uZi98u+XhVWYWqhCl3OpgksbaloAKnBs8wNfZgtq8gNOpBObYooUmT0HFQ
	E04rGzOyVd67DmjrdPUwnyln2nMXRDM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ruEA3kvk;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786513668;
	b=lGsyNoh87rFUmnkPCnA8rI8RdeofwA9TAcFOmndjfFFEvyItTh//HkcnPEadLNx67BqEw5
	xR6upBChx9ZIQIZ1zO6p+j4IZxxEy2XsByoums9pIjdWkBhVuxa2S50snS7pBmRunadXZw
	hX1rYjBpLOYGH6SybMxbW8BZP+1R1GU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D6AF60A7E;
	Wed, 12 Aug 2026 05:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DEB1F000E9;
	Wed, 12 Aug 2026 05:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786513667;
	bh=IWjDjgp43HDOKAAvhXf6tJ9XRcep7H8R/FphtBkyvCY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ruEA3kvkxtFK7eWbkAqQPen2AEMf+hlBpUgBhnXOPr9FJ/KiPmgD7eVNKyF39gyr8
	 bK22sipkB+8gno+UM3kQXsWneAHxc/0If9eU5cgeb7WifH7vwo+7A5aL/KR/qVmOg4
	 Bp/vobOrCFOQRgVZhubk/5vbkMdDLmoMGBelxhi8=
Date: Tue, 11 Aug 2026 22:47:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Nick Desaulniers
 <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, Justin Stitt
 <justinstitt@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, stable@vger.kernel.org, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH] arch_numa: Avoid false positive fortify warning in
 setup_node_to_cpumask_map()
Message-Id: <20260811224746.fdb85bcf47533e12d365b182@linux-foundation.org>
In-Reply-To: <20260811-arch_numa-avoid-fortify-warning-v1-1-59ce3e689f3a@kernel.org>
References: <20260811-arch_numa-avoid-fortify-warning-v1-1-59ce3e689f3a@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F2F3CA0006
X-Stat-Signature: zsce91pg88fpam7t9yatwyifjpgkmnxg
X-Rspam-User: 
X-HE-Tag: 1786513667-539667
X-HE-Meta: U2FsdGVkX1+iBeWf2673xrwuDEbg+mHUIj6CkhHSJhK/mqOO2vvCdxp2Kh+flEsvbsnudvTUDJYFy8D6qwlSiePfX/7AGvyXOJFk9vSe2p4LA0yiiqdHQGxX0D5hoxZv2rz3r3ish6H3mfBQieHZFIkC8xzh7MAKhoRU2+r6aKz9b1Gw4LUpdLftj7aPezQdRYJNDNwxm+J0a0qMMg+koT3OI65mzCbdc5objIrYA3tjLnanUJX/bnHm4jxtrNPSA68VxjuQeZnvpR8aFJA72G5nvSLG/G+kVDN/2Jc/HdPoYxyQ5Imi7hK/kYE0/2bZYcebZSaayRovUAUi/ksxMSPLtvLUzDytrH7vQCDZd3EGWOrxbs7SiwPFimrkdPufZ+GdY5LXuWuioK+BZlJLoN6Oiw1wcoDwIz/M2rSqwDAI3wdwLc5z5bnhk89ZXe1L5vi75IMHVTsIoT15cLozxOFvZ9WsrGQHoXGcVez3B3cKkxoHSgDdjtJ528Hd3HZ9JjCRjhv+W83d+S0a9Z/K+2Q0gVaN3KgAOnOgPJjoNing7oRWMsszEKOcORi02BGqaI2tcGemePe7V/GaSTfIbX28XuJWacxRJTX6w6MMLt6KzxQwaDRJCtWNTNcJgS5MCsj60hFBVrJXbTXW/hbFGfUa7+VHtAC0jgPcsYG3jRhkyVEFn0uhYlFdRRIMNdUIFDCXJvGGNGrDkNxXwztkTJLKNrEDLKMgU6Xy6YkwgsdACpPgc1+eeaRlP7o1lSM10pAVCBXempRcURbke91qzni6N60J5fDDNshrd+JqWTLODcWik1EhpmpZsAgMedtQ5gBJyYbhoAXbE5SEn1/5+8FdLQWGD188avHvQ0hTXFl2rMFltUKO6FsqGzvO83w5WxSZWncuZ0hYjYAPCmjME43IjZf7LppSOX2O2CzbdTPxlaBhuBPwuvtTRvecSFU7+EA2+wnyLi7Wjcxy8Xa
 TOt/sRK1
 2F0kc1s1K9aoR2xEW67BQkZ9jFXX/CIQqIGpK+cYflk81QVdmoJE4sGK0STjs9rK5r7mXBYp2uYXDWNJw7t4MexQdfnFvp8ezrsIOno2cMzQopezrqo7xcekC4OBnvT0KvUcO93qksbFeKoEMq3UK6MAwjoK+E+SDQheDeHo6c9/qRTPN3kS9Pi8R+Illwccq0EDU/BT9satx1UEuyIjn+O2ga9uyBRKiwknOCr94GoZZnUpOUGcMjBXLlAkxBiwkj5a62dw3zQh+DMQi8Mm87d1qKRysAQOM6dCEPhAlTjXIPOum6Gy+KJuOUfkoU4rVuwSiyP8301T8TNFin63pEcPgrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 22:22:42 -0700 Nathan Chancellor <nathan@kernel.org> wrote:

> When building ARCH=riscv using clang with CONFIG_FORTIFY_SOURCE and
> CONFIG_UBSAN_BOUNDS enabled, CONFIG_NR_CPUS > 64, and the default value
> of 2 for CONFIG_NODES_SHIFT, there is a compiletime warning from the
> fortify routines.

(cc Kees)

>   In file included from mm/arch_numa.c:11:
>   In file included from include/linux/acpi.h:14:
>   In file included from include/linux/resource_ext.h:11:
>   In file included from include/linux/slab.h:17:
>   In file included from include/linux/gfp.h:7:
>   In file included from include/linux/mmzone.h:8:
>   In file included from include/linux/spinlock.h:60:
>   In file included from include/linux/interrupt_rc.h:17:
>   In file included from include/linux/smp.h:13:
>   In file included from include/linux/cpumask.h:11:
>   In file included from include/linux/bitmap.h:13:
>   In file included from include/linux/string.h:383:
>   include/linux/fortify-string.h:430:4: warning: call to '__write_overflow_field' declared with 'warning' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribue-warning]
>     430 |                         __write_overflow_field(p_size_field, size);
>         |                         ^
>   include/linux/fortify-string.h:430:4: note: called by function 'fortify_memset_chk(unsigned long, unsigned long, unsigned long)'
>   include/linux/bitmap.h:248:3: note: inlined by function 'setup_node_to_cpumask_map'
>     248 |                 memset(dst, 0, len);
>         |                 ^
>   include/linux/fortify-string.h:462:25: note: expanded from macro 'memset'
>     462 | #define memset(p, c, s) __fortify_memset_chk(p, c, s,                   \
>         |                         ^
>   include/linux/fortify-string.h:453:2: note: expanded from macro '__fortify_memset_chk'
>     453 |         fortify_memset_chk(__fortify_size, p_size, p_size_field),       \
>         |         ^
>   include/linux/fortify-string.h:430:4: note: use '-gline-directives-only' (implied by '-g1') or higher for more accurate inlining chain locations
>     430 |                         __write_overflow_field(p_size_field, size);
>         |                         ^
>   1 warning generated.
> 
> In this configuration, MAX_NUMNODES is 4. clang unrolls the for loop in
> setup_node_to_cpumask_map() past this, which triggers the fortify check
> when accessing node_to_cpumask_map on the theoretical fifth loop
> iteration because it would be an out of bounds write.
> 
> Make it clear to clang that nr_node_ids is bounded by MAX_NUMNODES due
> to the logic in setup_nr_node_ids() by early returning in
> setup_node_to_cpumask_map() should that condition be violated.
> 
> Cc: stable@vger.kernel.org # all applicable
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2174
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> This is based on mm-unstable due to the move of arch_numa.c from mm/ to
> drivers/base/ living there. I have CC'd stable because this warning
> appears in my testing back to at least 6.1 but I see no reason why it
> should not apply to all trees. No fixes tag since this is a layered
> problem that just happens to appear under certain conditions.
> 
> Another alternative would be using the __assume macro to say something
> like
> 
>   __assume(nr_node_ids <= MAX_NUMNODES);
> 
> but that seems a little more fragile.
> ---
>  mm/arch_numa.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/mm/arch_numa.c b/mm/arch_numa.c
> index 442ea239bba7..bd7772b05bcf 100644
> --- a/mm/arch_numa.c
> +++ b/mm/arch_numa.c
> @@ -105,6 +105,18 @@ static void __init setup_node_to_cpumask_map(void)
>  	if (nr_node_ids == MAX_NUMNODES)
>  		setup_nr_node_ids();
>  
> +	/*
> +	 * This check should never be true but it makes it clear to compilers
> +	 * that node_to_cpumask_map is bound by nr_node_ids, avoiding false
> +	 * positive fortify warnings when accessing node_to_cpumask_map in the
> +	 * for loop below.
> +	 */
> +	if (unlikely(nr_node_ids > MAX_NUMNODES)) {
> +		pr_err("nr_node_ids (%u) is larger than MAX_NUMNODES (%d)",

Sashiko wants a \n there.

> +		       nr_node_ids, MAX_NUMNODES);

Lord only knows why nr_node_ids is unsigned but MAX_NUMNODES is signed.

lgtm otherwise.

> +		return;
> +	}
> +


