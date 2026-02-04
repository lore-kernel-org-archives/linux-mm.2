Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DB81EA7943
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 20:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6179B6B0005; Wed,  4 Feb 2026 15:47:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D5516B0092; Wed,  4 Feb 2026 15:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7896B0093; Wed,  4 Feb 2026 15:47:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 393A96B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:47:32 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3B6B1C15A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:47:31 +0000 (UTC)
X-FDA: 84407959902.06.288963B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id EEEFA100014
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:47:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ceImbz8E;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770238050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JE9K9cnxHEioD0bY/0SBJmhMUUNEI8hO7Ksv7scdRCc=;
	b=IT+W6HTVXfVCXrxNBbuevZ56CsvPFXP2MUKrpvrMmhf87sDmMlEV+F13Y0etXpa1E6qRLL
	40Cx5BDMqHykvcJ+TiYeM/Ah+ujVcRWB7xuxmh1iA8glfsGAU6SbezZbq6KilDjspsHj7e
	4KlVXkZAOFMj+Bwzj9z+XWqXdaLjY1o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ceImbz8E;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770238050; a=rsa-sha256;
	cv=none;
	b=1+CrnEr71C4ExkQI74kefxrv6mxF6BAtPT16q2gtn1Cw0rOUYwdEhmsEuIAhGWFWJ34RHM
	pvF+8tvRLPTOfTzrOKcGDyda9FlqYo9vCQ5iJoM7azv7eCss33PSTRsXRQhZv9v/gGwaeM
	5eNhOMrZd/8hmRZzwzPa3Q7L8brGiYY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 591C560010;
	Wed,  4 Feb 2026 20:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6EFC4CEF7;
	Wed,  4 Feb 2026 20:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770238049;
	bh=M6F4r+8xqCKwYdWkmNuqBBLFmaH1X62wessV5kAOjaY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ceImbz8Ehfv99L+KpKZmE6O02UITPIW3Q3unzHK6ZvZ03KKVV9vd0o/zcMuSR8I/T
	 H1Ir3pkRy/Ac8NihhmQc2XLTMSvLY7g8u6dkzpUWxLGR59JnhG3WFIY+0sjN6+ny7L
	 OA5yX5VUcxDkJ35fbSlJkf7gZPNX9n4UDZ49V6CXYwaJng3pK5jMKjC8bZQ49jWrDJ
	 mh81ww5c4mKrrXjIQs9nNyAtjUxe+jiJJyDGCyhHXV8PWeMF/uLi6iv05wTvaTDa01
	 /w1na7IgsBIyj8KXiazPHDVq2pFYUxDfVF0755O+BReCpOPHi91jybdC/Nf+ItlP65
	 sGqFAAkbH50Hw==
Message-ID: <36511161-6fb0-4928-a0ed-9b5e03b50a27@kernel.org>
Date: Wed, 4 Feb 2026 21:47:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable] arch, mm: consolidate empty_zero_page
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dinh Nguyen
 <dinguyen@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Guo Ren <guoren@kernel.org>, Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Palmer Dabbelt <palmer@dabbelt.com>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org
References: <20260124095628.668870-1-rppt@kernel.org>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260124095628.668870-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EEEFA100014
X-Stat-Signature: pdkg5471czcjhxii17izt8h516ioxaaz
X-Rspam-User: 
X-HE-Tag: 1770238049-648711
X-HE-Meta: U2FsdGVkX18Xx5ZSEjBtRTdArk1WQnY+GdBGjJ0yYIrZEKVPx1MxLjRM9kluXa5v/4THd4Sjz7ZNqMvdLmaQAqWDAWLV9NglqhVYYcZEnfg7vUrtvj3ifMrzkP8F6v4/AeRKmF4xmZknrvveQXkkYPN9Qsm33AppnrD3GiumeTqc7U+7VS1MKdOEcQ9TFw/3facT9IiGjYEPfCu2T5CNP/kWuuJvDYhZBDSv0aCv+MVdkkhRGiv9/sSxAeRXd5ctTVMnwRzB7UvacJZC/HeWwiTEKqu639k52XvueJgqSYpmAIscEYy4fnqsqdmdo8w7RQwgn82sS2AMwF9lEavZdm50CU3SSNU3S/0FBqC1Hwh/5zZm3dooQ0K1esuQ8Om0ksQdACRgmJ7Wv12looAw4ldqpxIN3cO2UTC+bkDwCMpDPbExW5kCNyDLmR12yhj6Mm0tAzO94rcgwjRLc2f5ARp9DuQeNJm592R7ribdUDJa8/9TxXilynQFuvPgFR+MSgZngab9dfHnRFUtyg94myDVhbdaKMM9sRK2XCByKSNGQqotGJ0rJjE8aqrmPMdHlJeJzBlb2g1eZ7WiNTBEtznbuKJc+wteHPuuyq4xKAWAXdjVlLQ0Q05sO8hAUjcLaOfl1dVD7X8suK7U+kBnz0ZZ5nV8pcYfzrFb49CjH0JwhVV5Mq8wObjPtVlu7yj+V5dAsFe0y/2PB9/qNoyj7kk3ZKcTuJ3o28cEyt/padkZfDl4CqJCTSfhAJ/DPTlBakwRa18AmQJDh46gM+/KrcLcE30gDvCPx4WcFgQ7XkvrNVUP84QQ49m0+88zQkiaziGeGYOGOALLGvqdn7BfzkNH1Ib3SW2hq/wf6uf2Q6zoz+teLIVS2RTVA1N/oGnti4fnF4NiL7P0R5B9RQyCl8g6gA4LI1r/5LgSXBZJDUae6ygPnqxd4p2HHOBFrYn9o7uP/RKJ6RSrvVWMulk
 7Gg0B7fT
 lWnhpq3z0tSRoYF2LuxnB1xD8IOJhFbS+GgMSzXBgMGltsoE43vXwo+KwxjZe86JRlqBYlpX0HYnpCYpOq1SxU76l1YJ8BEH2/79xnU01DcOpLPnF2kcOVFrRAaCqnH1O95/pOXZXv+EU01QGWxdZ8VT0nIXN5nXfIOIRXng7YYjKcjxuVdkJU+omNONTcFRV7ZqBamnNTqH5jVFFrWyYy6DY+whcfyYBjLDvc/PUJgJWjvy7sHCAo6NAmPfoK9BdBxLdEDVKTbna+cR9D+6ol7S7Kcs86beD+0UmGLhwEegJVe93YUX4xP97qK6ZAw+dN7EDgRK3q0etpBA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/24/26 10:56, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Reduce 22 declarations of empty_zero_page to 3 and 23 declarations of
> ZERO_PAGE() to 4.
> 
> Every architecture defines empty_zero_page that way or another, but for the
> most of them it is always a page aligned page in BSS and most definitions
> of ZERO_PAGE do virt_to_page(empty_zero_page).
> 
> Move Linus vetted x86 definition of empty_zero_page and ZERO_PAGE() to the
> core MM and drop these definitions in architectures that do not implement
> colored zero page (MIPS and s390).
> 
> ZERO_PAGE() remains a macro because turning it to a wrapper for a static
> inline causes severe pain in header dependencies.

That's just what I wanted to ask after looking at it :)

> 
> For the most part the change is mechanical, with these being noteworthy:
> 
> * alpha: aliased empty_zero_page with ZERO_PGE that was also used for boot
>    parameters. Switching to a generic empty_zero_page removes the aliasing
>    and keeps ZERO_PGE for boot parameters only
> * arm64: uses __pa_symbol() in ZERO_PAGE() so that definition of
>    ZERO_PAGE() is kept intact.
> * m68k/parisc/sparc64/um: allocated empty_zero_page from memblock,
>    although they do not support zero page coloring and having it in BSS
>    will work fine.
> * sh: used empty_zero_page for boot parameters at the very early boot.
>    Rename the parameters page to boot_params_page and let sh use the generic
>    empty_zero_page.
> * hexagon: had an amusing comment about empty_zero_page
> 
> 	/* A handy thing to have if one has the RAM. Declared in head.S */
> 
>    that unfortunately had to go :)
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

[...]

>   
> +#ifndef __HAVE_COLOR_ZERO_PAGE
> +extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
> +#endif
> +
> +#ifndef ZERO_PAGE
> +#define ZERO_PAGE(vaddr) ((void)(vaddr),virt_to_page(empty_zero_page))

Took me a second ...

> +#endif
> +
>   #endif /* !__ASSEMBLY__ */
>   
>   #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 1a29a719af58..8ea5b76f317f 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -53,6 +53,15 @@ EXPORT_SYMBOL(mem_map);
>   void *high_memory;
>   EXPORT_SYMBOL(high_memory);
>   
> +#ifndef __HAVE_COLOR_ZERO_PAGE
> +/*
> + * ZERO_PAGE is a global shared page that is always zero: used
> + * for zero-mapped memory areas etc..
> + */

I am not so sure of how much value that comment here is.

... and in particular, why it is not next to ZERO_PAGE in pgtable.h? ;)

> +unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)] __page_aligned_bss;

Is there a good (or historic) reason why this is not simply

uint8_t empty_zero_page[PAGE_SIZE] __page_aligned_bss;

Almost looks to simple, right? So there must be some problem with it :)

> +EXPORT_SYMBOL(empty_zero_page);
> +#endif

Nothing else jumped at me, nice cleanup ... if you get sparc to work :P

-- 
Cheers,

David

