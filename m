Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F8CDCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 09:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B1F16B00A4; Tue,  2 Jun 2026 05:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462756B03CF; Tue,  2 Jun 2026 05:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378446B03D1; Tue,  2 Jun 2026 05:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 265696B00A4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:10:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C967B1C212F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:10:13 +0000 (UTC)
X-FDA: 84834401106.16.6CD0FF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id EAA5F160007
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:10:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JoneNJ5b;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780391411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kq5G0oHDkBWFEFFqoWIBja9YbwYgAYGaHMrsEu/NhUE=;
	b=qcBRifmWtSYp3RpePn/jVSNZa4q5ukv0Tx90uwqohOnj7ZZ95oau+MZwatPKrurtMguEGK
	eGuDQ0x8u9jxSwjaF4Y7RvHIol+8+wPdqxAWN01CuDp6MSTRrQojoxGD1nOCA/XqZxCGaX
	F8sc3VqfbSL0qHlSTSGcZ+EwR0ZRB+0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780391411;
	b=qXj2LsHKu9FiJasqHk3bQ/HOiDIuUUno19ohUmOUEOqK2qa+K1nL87hyAw3c7Ja/i1rsyv
	lE/mURtP9I4dv358/+YYBGa4Axiziw6RgwVVdCofqiCh+TPRHQv0uMVTlAo7GkeHRUWBP5
	h3uHtLXHmyt2xpOQqcL1tN//1WCIqFE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JoneNJ5b;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DCA4601D8;
	Tue,  2 Jun 2026 09:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688A21F00899;
	Tue,  2 Jun 2026 09:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780391411;
	bh=kq5G0oHDkBWFEFFqoWIBja9YbwYgAYGaHMrsEu/NhUE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JoneNJ5b/Q0IaGwhfeEspKw8KT/XrtpSuyDwYnlA1H7DFKwtqJnKWbwiRyhY/u3XK
	 DeQSI09SyNWmgWRnO6BhSHJr49DCNaeiDjDBqO9isA/PYFXcAJydRbYe8C3dp6VecI
	 lGGreseU3n2X9YSMa5sZvg5nOzKPeu4lFHilZs8VtxwenM3VDQ4dbp6bSK6Np9nUAF
	 uukUzKeptcEDqZf8vJ5Izy3O1wagGDcsutLa5/1s5vebHAZkHnaTuFxQID+JzFqd1O
	 Yo3hSlTEMi8bx97RafJX7n6Nz0XLx2Zlb0vpPDUkGTNRV7Gzed0IQlV9hKvmjtBUio
	 m2PV4G0DuQgfw==
Message-ID: <3674d3a8-b30e-4bf1-a4ab-0f82c494d131@kernel.org>
Date: Tue, 2 Jun 2026 11:10:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][v2] mm/mempool: Untangle CONFIG_SLUB_DEBUG_ON abuse and
 switch to static key
Content-Language: en-US
To: lirongqing <lirongqing@baidu.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Usama Arif <usama.arif@linux.dev>
References: <20260602062142.1790-1-lirongqing@baidu.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260602062142.1790-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EAA5F160007
X-Rspam-User: 
X-Stat-Signature: kfr5nd4d17iqidifuw6hpptww5c4apxx
X-Rspamd-Server: rspam08
X-HE-Tag: 1780391411-340127
X-HE-Meta: U2FsdGVkX18cInb6xg77S9RpLoGjc1dgxLgxUe2vRXghavpShSq8D2GEwYi/NBKSfrFh6vLep7f29H2qcCFlswogjz7PbcO4JIAbRcVHVWAB76bDzRWzj/KAoBWbpTc9OEkXMnctfCPP0Sm8N0KWXe7P3dVRP3G/e7hjCFF0yEhB9ZSAipoZTrrBpQOh2gWXkvR0FIF09uf9iaZULEoP5pFUfnuUt1y2mUxm7qQjpX6899YBzNlMOzB2M14Byt6BMNlD47Ed5gTcJ7qjf36O74bTIfCQpwkV3vs41nAiKHxpilEf/sG1MQAZzP9yxuYh3d2Tff/fhqB88hUkrLPCmGDa+oH/t0k3aEU394toeSvlJxa8QK0G04HRUTraYQbMWs2R5ZBP/g0LpEPpQvY/JQ/oc4YE3wdxiU6rfGlVcFBJ9RjCrtKXSBDsfCwZ5PO82H9QQu4lJHv7dVm7CSb1xKIpQ8K4xBaRF47JpO3XG6DmoQ5xm9ckP1aOetn01wCBVg4OxIkhLStsbtglH/QyRupicqdDLUPMfYVt14yhzVQruTisUNkbG1zjuuSYWtDHRFGM6yBle8xOpbtfaGnltrz6aNeOl1FpzHhY7Xgn0fj5wkem5ZyBRnYGAbE9MQlo2ge4R6pQi5MzdKix7qjrPOKFQaizgtcCrrSR43aLv6Ipwv5c38xExtrqgvtDoNhvq2zu6Fo+JgxXxkiWMHvogTi7yENFsmr67PHszU0k8OXkZvpx6jrLTYG1BNN28WYd63T6ogaLhCg3Gh8uhwmx11TmwJoRs6/+GN5gsnvWyYwOne6sIhyKokMysWekQKTXt8j7A9z6JLvYJHFCVCGpISTvfSzVT2AFUJEhgVY64koogCGJyRHxUdNu0DX5N3dNiloXOZz83xHx9XuyZior0NHnm3jVlef+JkrUR3dZ+a8LoNqZgK7n9wVT/a6yO3RGwnE/qfJP07C8M5Y1UjX
 mFvR6TVy
 uyL+cyOYn7xAHhIR1i/aoIyZP8YDQfZmlMPudJ/bV3sQ4r6hy+jW4EJRphfyuZSNbhpozVsP1YmYoW5EQA9XiQCR6XRFRY9U3VfxZGLz0wRQe6ei8dQsewRiCdm6pBoBqODqZf14Or9eCLLtUKaw0QTdmCYiwcelBVF7riQuy1eck59UhP9IGNwDEtn1E/iLh13i7wgc9Gf4iS+UdMNXuCtQxatjqxMEmYJkD7r3mZq0h7m7ynrZNvAzBM+z70G9uxqHFiTHJsulmvxPexmi9u/DpJYIEyqIFOQiqib9Pn77/jQCyL7/Sp7vzQKgV/8RKyg8H75nvsemDaJlLEo/2qKzDhmbFXJ99V2M+mK2tygbBHbCYY4hNzC5CzDIxs9ipuQLV0XK0TOdrg9UhsPfn8ca6SCddAlfLdBIQqe3gm7RquTNEpSydN0B9TW4P7INrsSDYG5o+/AfvqkzB4HEqqGZMM5HiXNsA/tm9wsm8oJC91X9izoMcg01c8aOrDIehGnpYw7mbb4KWJC0Jf1ejbHhKJ9c8PVI3REa2/EshErJtQuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 08:21, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> The mempool subsystem historically wrapped its debugging logic inside an
> merely defines compile-time defaults for SLUB and caused two flaws:
> 
> 1. On production kernels where CONFIG_SLUB_DEBUG=y but
>    CONFIG_SLUB_DEBUG_ON=n, mempool debugging was completely compiled out
>    at compile time.
> 2. On kernels with CONFIG_SLUB_DEBUG_ON=y, mempool debugging stayed active
>    even if a user explicitly disabled slub debugging at boot time.
> 
> Clean up this mess by removing the #ifdef and switching to a runtime static
> key (mempool_debug_enabled), allowing mempool debugging to be toggled
> cleanly via its own boot parameter.
> 
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Harry Yoo <harry@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hao Li <hao.li@linux.dev>
> Cc: Christoph Lameter <cl@gentwo.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Usama Arif <usama.arif@linux.dev>
> ---
> Diff with v1:
> 	Rewrite commit message, change early_param to __setup
> 
>  Documentation/admin-guide/kernel-parameters.txt |  5 ++++
>  mm/mempool.c                                    | 32 ++++++++++++++++++-------
>  2 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 642659b..89b5994 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3980,6 +3980,11 @@ Kernel parameters
>  			Note that even when enabled, there are a few cases where
>  			the feature is not effective.
>  
> +	mempool_debug	[MM]
> +			Enable mempool debugging. This enables element
> +			poison checking when freeing elements back to the
> +			pool. Useful for debugging mempool corruption.
> +
>  	memtest=	[KNL,X86,ARM,M68K,PPC,RISCV,EARLY] Enable memtest
>  			Format: <integer>
>  			default : 0 <disable>
> diff --git a/mm/mempool.c b/mm/mempool.c
> index db23e0e..71e4b54 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -16,11 +16,28 @@
>  #include <linux/export.h>
>  #include <linux/mempool.h>
>  #include <linux/writeback.h>
> +#include <linux/static_key.h>
> +#include <linux/init.h>
>  #include "slab.h"
>  
>  static DECLARE_FAULT_ATTR(fail_mempool_alloc);
>  static DECLARE_FAULT_ATTR(fail_mempool_alloc_bulk);
>  
> +/*
> + * Debugging support for mempool using static key.
> + *
> + * This allows enabling mempool debug at boot time via:
> + *   mempool_debug
> + */
> +static DEFINE_STATIC_KEY_FALSE(mempool_debug_enabled);
> +
> +static int __init mempool_debug_setup(char *str)
> +{
> +	static_branch_enable(&mempool_debug_enabled);
> +	return 1;
> +}
> +__setup("mempool_debug", mempool_debug_setup);
> +
>  static int __init mempool_faul_inject_init(void)
>  {
>  	int error;
> @@ -37,7 +54,6 @@ static int __init mempool_faul_inject_init(void)
>  }
>  late_initcall(mempool_faul_inject_init);
>  
> -#ifdef CONFIG_SLUB_DEBUG_ON
>  static void poison_error(struct mempool *pool, void *element, size_t size,
>  			 size_t byte)
>  {
> @@ -73,6 +89,9 @@ static void __check_element(struct mempool *pool, void *element, size_t size)
>  
>  static void check_element(struct mempool *pool, void *element)
>  {
> +	if (!static_branch_unlikely(&mempool_debug_enabled))
> +		return;

With static keys it's better to have the check in the caller of
check_element so we skip over that call if it's disabled, and not do a call
that immediately returns. Since there's a single caller, there's no need for
an extra inline wrapper.

> +
>  	/* Skip checking: KASAN might save its metadata in the element. */
>  	if (kasan_enabled())
>  		return;
> @@ -112,6 +131,9 @@ static void __poison_element(void *element, size_t size)
>  
>  static void poison_element(struct mempool *pool, void *element)
>  {
> +	if (!static_branch_unlikely(&mempool_debug_enabled))
> +		return;

Ditto.

> +
>  	/* Skip poisoning: KASAN might save its metadata in the element. */
>  	if (kasan_enabled())
>  		return;
> @@ -140,14 +162,6 @@ static void poison_element(struct mempool *pool, void *element)
>  #endif
>  	}
>  }
> -#else /* CONFIG_SLUB_DEBUG_ON */
> -static inline void check_element(struct mempool *pool, void *element)
> -{
> -}
> -static inline void poison_element(struct mempool *pool, void *element)
> -{
> -}
> -#endif /* CONFIG_SLUB_DEBUG_ON */
>  
>  static __always_inline bool kasan_poison_element(struct mempool *pool,
>  		void *element)


