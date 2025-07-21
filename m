Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E71AC83F25
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 23:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C05806B009C; Mon, 21 Jul 2025 19:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5AD6B009D; Mon, 21 Jul 2025 19:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC076B009E; Mon, 21 Jul 2025 19:00:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6186B009C
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:00:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 226031100DE
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:00:00 +0000 (UTC)
X-FDA: 83689791360.12.7DBAF10
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1680740012
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 22:59:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="H7aGJ/Bd";
	spf=pass (imf01.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753138798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k6qH8mhMJUNtpiP5ZkZtwmZQrunIQJlcyvnjoj0lgTw=;
	b=xtQ+rtqTViIdY5K3i1Uk0kqBnObxDwss8i0eVa43iVI8uZeme/vDUFiSC+uj4wBaQWHliM
	gdrjfKyHkH1lzizqOlKSDQrphxNE0GRcYlSiBw0/LWc0V+9azGIsRVDbrOda0dg5G/uCHU
	tJfbmSpu9MgwCPVVs+XEKHcvvrvrYkc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753138798; a=rsa-sha256;
	cv=none;
	b=48Ctfdt4nLHbZuQhsBNv+TDbBMYc/Z8dGWZswiXy22PexNFAOhgQUWEbb2FebvinTFFpMF
	M5hL99aeeSwk5JPg1HJF4KntlRYt+3JL5WbenEhz2I1JdmkjFlrk60XhyIroWGpVZEQ0WY
	oefGDjpilk/uss/3dLzRaB5BVdPtRNc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="H7aGJ/Bd";
	spf=pass (imf01.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ae35eb87810so98058066b.1
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 15:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753138796; x=1753743596; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k6qH8mhMJUNtpiP5ZkZtwmZQrunIQJlcyvnjoj0lgTw=;
        b=H7aGJ/BdLtFhOmnjhnIU+rE5ETaXpqr6yELVo8Giuvd0G9ARIoFlCkNNemLeBfa4zE
         cn5VGtdE81l/xRbiIwZuQ0B3nD1BW9iR9nTVUgCswldzN4RIvgCtgkeo2XM6OL9b2FQn
         kYAOGbqYuFa9dhWpeIWVbSAuinb47/3aJIDFuSQveEvhHk7QuSal6x88+kCZyrb6QG6Q
         pXUydAEEuT0hGV8SHzyzoowxiDZdvQ3icDiExWurOB9a1SFBhHChTs1KpIIfxIxHGrj2
         Sm0uVJOW04ZVR6b5HKt+0B5bfBH4ATMb6A//KDxSlPKwxDGRU/vd1k16rSjMKYCY2tDQ
         3HOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753138796; x=1753743596;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k6qH8mhMJUNtpiP5ZkZtwmZQrunIQJlcyvnjoj0lgTw=;
        b=m6uXkQB4gOWL1nmTDtl1g3lLAPusyGhyCgLVsYIA+yDOLeKjIkH1BcA6FBcoBMJA5U
         yOTo1teIihjvx05rOlimzHCEYnCnZzk15IsuUmH/5aRX3LW9W7Y1IR+yn0TAy7otca2P
         /5FUEU8QqLyW4gTJNEcrE3S/y36BUNQEOjVh0DEJzCrRgM3dkPoDhjgG0wPZBphbEM5M
         kMXTh/BqS9j1aUqxTCWh8MnMTMtvYj8hwXGR7ClCV1Jr3reBR01+YgSiRMyociqJxALF
         b98gvzwK7x4CcLow3MD8nGAZBIpAM36hURwKekR16nm7+XalJO+NAEbD4pR2+yzLErj0
         u2jw==
X-Forwarded-Encrypted: i=1; AJvYcCWX/HavZUzXrmcPSnvmEqX0VA29ySMuW7kyY0XXq6/vZlKEdU/lJ/XiMpgsf2cv35JUyu/OSlqzgQ==@kvack.org
X-Gm-Message-State: AOJu0YwH0o9rWwG0RsxI3iBbjtjhMDIk0gSrkGq/QNbgdKWULIp6/hS+
	pJGsHy+f877aB9gkmnRujfGgdZUnBOcxnPODZhIYAaRGtnaVzB+T0xzn
X-Gm-Gg: ASbGncu62B41t0gbW3DFJ/LK7S1yVU3FWcSdoFB7OltGVOGneeU2sJPkzUhFge0hLwi
	r9OzqnU0JN0qtQyuZj5Me93EFUG7BwW2waMb3ujcuIzwbXoOuLiMgAorPQ2VkqTv4o0EUMEMFuY
	BVBu7TACgnIhIKH0ArR2UE76UYGRKaVCdBnuBsWu7QJy6goBXMPi0hqXUwg3f7v5YkDGL7H+/z4
	WRXaUE6XTjbQmGh0Z/EePIkcRgj855u9oqyyiQLskJBruPvW+nJ8GAgF9zdBigZ9auR7aXXUs2L
	zK1KAshBd4VTMMU2t8CgyZmP8Z3Gjbsi3gR3l3RpH0sf1Gxs2Y6BPZwl5V4SgxaHWhuAx0kvi3I
	OEzRjG5GRsCaHTBim7c97AmQjXMUob48lG86gPyYxh5ZSka+rgRxnjbyHmsR9bJKOK0x5gplWEd
	GpNkM=
X-Google-Smtp-Source: AGHT+IEnEupELw4ajNrlfkyI1uQuImlm2WT9jEJPd1nte24ZB52Dcj+jDrjKRG7BtovOALnxWEn+Rg==
X-Received: by 2002:a05:6402:3582:b0:612:b0d9:3969 with SMTP id 4fb4d7f45d1cf-612b0d93f03mr5896841a12.8.1753138796402;
        Mon, 21 Jul 2025 15:59:56 -0700 (PDT)
Received: from [192.168.0.18] (cable-94-189-142-142.dynamic.sbb.rs. [94.189.142.142])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-612c8f543ddsm5962670a12.30.2025.07.21.15.59.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jul 2025 15:59:55 -0700 (PDT)
Message-ID: <bc47c08b-fbc7-4954-8e81-c22bce654556@gmail.com>
Date: Tue, 22 Jul 2025 00:59:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/12] lib/kasan: introduce CONFIG_ARCH_DEFER_KASAN
 option
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>, hca@linux.ibm.com,
 christophe.leroy@csgroup.eu, andreyknvl@gmail.com, agordeev@linux.ibm.com,
 akpm@linux-foundation.org
Cc: glider@google.com, dvyukov@google.com, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
References: <20250717142732.292822-1-snovitoll@gmail.com>
 <20250717142732.292822-2-snovitoll@gmail.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20250717142732.292822-2-snovitoll@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1680740012
X-Stat-Signature: pea1nud8hp9bptt3b7gofbaew4ey71bc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753138797-373148
X-HE-Meta: U2FsdGVkX18vZY1HvvkT5FOMgTN7oloxQ99ZmNK5pkz2NLcu8quBZHxAQmI6yYag4yRhJaYyzdoM3GQEXt8zjqqgnZq9dFZLyvHcIvk5LabWsom3T9Eel1wAeKAjQb6LXUQIIM1n+jw5aLKf3D79Qy8c7PzSPFahAWu/f5GE1mDwiCfzScgBaJhV9COmcddOd8U7QqMXEErK/zCInD0XH+cRUvGz9Eg4zl43VE3drzB755gIvH7+c2hTRhLN1nmSXWNKTsDTuOb3Ai9YD/NuUC/1cKbXfHJvltxlzIUAXQdNAeFB5jsEwE3oEBu4F3UOoLJhfRKqalMkheVc0IOJSfRgjmCukDb/QIVDIHIiZl37xx57v7BXHamqwg0MPbI1GnwBSqBIrh2+mMUhvO6FsSYFmCRgeXzTY2b/kccg+n3dEbHR45ADxT1PGrgueFootNnaIavts4zY4k+nLe3MXNNcOgo4yVvULLcjfPmzujnK2hMDYb9LtbQky/fkT4GvWd3h+gA6f24kLdnBfHAArTx+ClQmkGxt7mq2uhG7gllYT6Ct3zCQA/QwjzP7BY8ZTdUjKrdOOWiO7fT4hIpYNsnp25jjudpwGud47FVxUEzzMMbwrfUhSYHJxNRjbYhBzTScC5zREcePvYT+aRiqNhGozxpuKtWgD0/YF0Mak/1MKaNltOSSdNF77w2rCr/6XSSlOO+Qj+bqw51MDnApSr0dIuq45fEqg617vPCHUu82pCYrIJGoBKAD0+qmKQR4jm9AFfKazAol1O/0dEBfXpPl2UI8YJOOfkmE4aybjDa/G645wzdunng9PFmKZjHytmJfChYdPvjsqmCnPD8jGONWhcBRXGuV5mCJ5jLjSXqQklbUnbbeLXDUU1Q4EdOk6F+vpkThxQzU7pP/RW/SPdeRz88b9pZU26PkgFgNmUU4Ibdy+ToA4iCbYzcCb49FutgIMoVJJ1HDA/OsYhe
 yrB52QYK
 x8Lgb9CfapX/mG3lzZD+Ln4SINS5U/f7yDVBe8/JPxChps+TDXwkdsaEfAncIxepo0Afy1x1Qd0oBOMTd666ClmHNdfxlyalmUqk7I4EV7RNqkIxikxyC/5AIBtilAs79NK09uJ/K/THHOacrmD2uaeknNUetTIp2Pcsw4pgnHbaLJEUtdm7KWjkdLqdQO5kitDmrhFUWZdRsQZUqaxhnLwPrJpD6Br99BHIowVMAObGVj/qicnazh1Sws3tf7OO0KXxVDd91KjNloQ6J/QzNLLI/kNMovrwecQIkDsNLeycT++gTnUo6R6+OXHVIhB/KImFOCrH1nO6jAjuBYBZ+dFQoErhpUkXK/zLfVWQj9c19Mk3N1IdzeYZWNjOdkZl1j5VRrYW93116AWQqxJif3mrf4ZPPTRxZOOul7S09XsenKPveZm5oH3RMMmMwg3AvTaACGgQFPUvHGEIA0Rc+aCqB2J3rz6jPP1Bqhx6j4bmoGoFxepgPaSp/aA3DMoBQJrM2H4fTs8L1eksNmudS6EmQOQpIKNS+Ck1Hd+5/DEsAbIzH7KxjlC0Hxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/17/25 4:27 PM, Sabyrzhan Tasbolatov wrote:
> Introduce CONFIG_ARCH_DEFER_KASAN to identify architectures that need
> to defer KASAN initialization until shadow memory is properly set up.
> 
> Some architectures (like PowerPC with radix MMU) need to set up their
> shadow memory mappings before KASAN can be safely enabled, while others
> (like s390, x86, arm) can enable KASAN much earlier or even from the
> beginning.
> 
> This option allows us to:
> 1. Use static keys only where needed (avoiding overhead)
> 2. Use compile-time constants for arch that don't need runtime checks
> 3. Maintain optimal performance for both scenarios
> 
> Architectures that need deferred KASAN should select this option.
> Architectures that can enable KASAN early will get compile-time
> optimizations instead of runtime checks.
> 
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> ---
> Changes in v3:
> - Introduced CONFIG_ARCH_DEFER_KASAN to control static key usage
> ---
>  lib/Kconfig.kasan | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
> index f82889a830f..38456560c85 100644
> --- a/lib/Kconfig.kasan
> +++ b/lib/Kconfig.kasan
> @@ -19,6 +19,14 @@ config ARCH_DISABLE_KASAN_INLINE
>  	  Disables both inline and stack instrumentation. Selected by
>  	  architectures that do not support these instrumentation types.
>  
> +config ARCH_DEFER_KASAN
> +	bool
> +	help
> +	  Architectures should select this if they need to defer KASAN
> +	  initialization until shadow memory is properly set up. This
> +	  enables runtime control via static keys. Otherwise, KASAN uses
> +	  compile-time constants for better performance.
> +
>  config CC_HAS_KASAN_GENERIC
>  	def_bool $(cc-option, -fsanitize=kernel-address)
>  

This needs to be merged with the next patch where this option at least has some users.


