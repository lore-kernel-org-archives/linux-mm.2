Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F06D606A331
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hoY+nVJd
Received: by kanga.kvack.org (Postfix)
	id C1B206B05BA; Mon, 26 Oct 2026 05:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCBC06B05BB; Mon, 26 Oct 2026 05:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABB9A6B05BC; Mon, 26 Oct 2026 05:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2386B05BA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:41:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3ED9C068B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:16 +0000 (UTC)
X-FDA: 85364284194.12.CAD7467
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3413040002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hoY+nVJd;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmErr11J4yiDe+oqOLxrAHXMe+lgqHj/gW1PNNiv0PY=;
	b=IHBCf42cjm8dKo7LDalms2s6wPr4bnibZ2tDiUs6q0eNmg7qYm10c8LoxGwf6r7Rg0Qfc4
	nkGara+IDDXGhF2rQ+d4onY007asJoM+Yq0ekOMEYTwy6nUrohTB8MSvxATVW408vhEIyB
	+K26LgP6Cn3W0zLqCSOE6cmz6xz4+JQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007675;
	b=g6qgd/zN9Zp79EiNy2W+xL1jmXYlPrTuvVnRc6i9JZsKk6MJv4ZwoqH49MA5jVNh9v/q2W
	92/nXSd1nqP1N+wqZCak+BOpi/OEqIiphkvQHLA/hcHygxwRBhXbhAZIbOn66qhiS4rWes
	WCrVimTucpT4Ql6JUBUsSNZY+cuG4/o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hoY+nVJd;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 85517414C8;
	Mon, 26 Oct 2026 09:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56F11F031E2;
	Mon, 26 Oct 2026 09:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007674;
	bh=fmErr11J4yiDe+oqOLxrAHXMe+lgqHj/gW1PNNiv0PY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hoY+nVJdTpF+bOnGRqA60bqEon5wES0uTDgRThXCOwAPT/eYwNotrJ8PurgaBDBH8
	 6RTUTlsQSoBeGbuLzwDPLxO6Tg9aX0DzEGmjJzZhajmJdWtdQFKWaGv+iqM+2uBKpu
	 026t64oG7a4GhVyDaiFRtUzs+QhNWsy1qp4OK/oABUnwArhQHMz6REf23JPiDPpyUt
	 H3PBDpVbqxeuL8lP8i6Dj/GHiIrypsBVaNKkQxsf+1b7KTZ/1TIdboA/vnbPXaRbcE
	 n8p/qSrc52pFTkI67KgPo+ShAyE6zmyE2/FC0JJN0+EVo+8neJxNDYKWgRVYf+Oiv/
	 WBm0YdS18Y/Ng==
Message-ID: <a6cbfb24-efea-41ef-8f1b-dd2bd160cff4@kernel.org>
Date: Sun, 25 Oct 2026 13:43:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: ppm: add PPM (Page-Plugger Under Memory) to Page
 Fault and Overcommit elimination
To: dev12124 <joaoanandalima@gmail.com>, linux-mm@kvack.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, ardb@kernel.org, keescook@chromium.org
References: <20261024104552.394-1-joaoanandalima@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261024104552.394-1-joaoanandalima@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3413040002
X-Stat-Signature: g1urzyucnof1czw5nofh7itiju8os93r
X-Rspam-User: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793007675-261950
X-HE-Meta: U2FsdGVkX1/eLrB7uH3v+H18XWe4qZuRr81ChaRZM3g/76LaInjdpWBJw+W1KzdYX6S/3JuV0p0A9rGAGYZaluu82RaEtBUo319UFAsnn6be0P4G5Z0h7c2gSGeMQiLVdy6m6GtQtyU3f1zH+gGMDsE0dbf7R6pFT/iT5+aBANASC9Fb8dxhvRy419tw5gTPvTx9hYhzscIAFHj2DkwSkZ3pqYhGLAyMqOMw8I4odjU8x3ours2mXm03tJH4qthEP4k1q3faZ2ZCOa7TRgv/7aCQvuRXYY/NZdvUbgo4VasvzdKFm/9/KmBIBaMCyrg5A4juc9N/27yxOASGQQW1HBikxpEeneQ0H0MnByfBgZjegjGzhs682YpcPbV6jlU9foqfxxu+v8hBFh1+48giWZW4FOUY97x44P/PqqTpmkfUXsId4VNFLjc4ux+oChXyJMfHOuZ9Ha2+9aAkOzHV8MdL5LS0AJrP3wjGCtIAmgmvt7q35sSILoy+3sGeYrzwwVBr/r1UMFCZa6aPG32/I6sXgQeqx/KBFA0xznJVFJnlk81G8QAXo04UBhgjkUSPlATeUBAxaExp1tt10M0O9awoVHoT0XXXRm2MlqUDf1buDqLFY6vSYy3SLTMdEaRcCVNVCkM3K67ka/qE8ctGLLgfEIYuQuw5p+j3EJ2TeVEyhIssUDLHdYth6LCxufP3f+LtVVlhLbD96byIlxj+6espmmi4kY6Md9NrYJqyPUSrJtgO966JYKBJ4AX61p+mdUuhG8pQmneZEipu78Ss/ewL2JohHLFlYIoFCDH/OeW6UDg2UkZEWYTFS3vPU+cGLJHNJmed06GBgVzoWREw2v9q6XFOOrco+X4CniqbvQE0n4Z2U8kpVsMKV4ema1gzawDK0hHAi4jdj0A+6Uct7XE+coW/VkY6j4ZfZQGsMuW4gLq4hurEAE4NZtBA+iFb5Vh3l+kUIT4hNG0FRgN
 R0hpzxKb
 U4tzg8MBwl4VeGunF+Mu0yam4FAQ0fqaVB2HgGuD+FftBooGCHO4SqQOtHW3cTuvcGnmb/+jvDIMIh7CvGMui9TjcIkK1xumAslAgA+HyI7M9mcwhMND9TIK7Uxlrz9QS6p0WKgGaSWhrEbiwvTN23XY43ygl0F126RZKKlmM/KHK52/lUbQrvRxJUyqp9eR0RHZuTwLKxKeEOauvI6LD5+wsAZH7tHVSLGa4eEWMF5D5S558QqRwmvZX+qlioUq2F3RiC1PQmnyfGwEZeOacNSpKPc4n9WRZjT6pRWvPXIXEOG7icOk22Tlo9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/24/26 12:45, dev12124 wrote:
> Hi mm subsystem,

Hi,

> 
> This patch implements the Memory Tatic called PPM, Page-Plugger Under Memory.
> The Main Objective is: Page Faults and Overcommit Elimination.
> 
> A few points under additionate:
> 
> 1. Allocation Handshake (ppm_kalloc):
> Using the GFP_PLUG_MEMORY mask, the allocator completely bypasses
> passive overcommit verification. It instantly isolates physical frames
> on the RAM, maps the page table entries síncronamente, and forces the
> Present Bit and Writable Bit to 1 before returning the address block
> register to the CPU.
> 
> 2. Desallocation Cleanup (ppm_kfree):
> Triggered via the GFP_FREE_T parameter, the release phase executes an
> immediate length truncation to 0. It forces a synchronous TLB
> invalidation (via invlpg execution) and flushes the data out of the L3
> cache lines using clflushopt instructions before moving the hot clean
> pages into a dedicated priority recycling pool.
> 
> I additionate a Buffer/Cache with store important objects.

Reading this description I have no idea what this patch does, what it tries to
solve, and why anybody should spend their time to look into it.

> ---
>  include/linux/ppm/gfp_types.h |  74 ++++++++++++++++
>  include/linux/slab.h          |  11 +++
>  mm/memory.c                   | 158 ++++++++++++++++++++++++++++++++++
>  3 files changed, 243 insertions(+)
>  create mode 100644 include/linux/ppm/gfp_types.h
> 
> diff --git a/include/linux/ppm/gfp_types.h b/include/linux/ppm/gfp_types.h
> new file mode 100644
> index 000000000..741122b2d
> --- /dev/null
> +++ b/include/linux/ppm/gfp_types.h
> @@ -0,0 +1,74 @@
> +/* 
> +  Memory Tatic: PPM (Page-Plugger Under Memory).
> +  This File is for PPM Flags/Macros/Functions/Types.
> +  Engineer (brazilian): João Guilherme da Silva Freitas Lima <joanandalima@gmail.com>
> + */
> +
> +/* Types Include Guards */
> +#ifndef __PPM_TYPES_MEMORY 
> +#define __PPM_TYPES_MEMORY 
> +
> +typedef unsigned char uint8_t;
> +typedef unsigned short uint16_t;
> +typedef unsigned int uint32_t;
> +typedef unsigned long long uint64_t;
> +typedef uint64_t gfp_t;
> +/* For errors in Allocation */
> +#define __PPM_ALLOC_ERROR -102
> +/* For errors in Desallocation */
> +#define __PPM_FREE_ERROR 0x04 
> +/* For success */
> +#define __PPM_SUCCESS 0
> +#endif
> +
> +/* Functions Include Guards */
> +#ifndef __PPM_FUNCTIONS_MEMORY
> +#define __PPM_FUNCTIONS_MEMORY 
> +
> +/* Initializer */
> +void __init_ppm_memory();
> +
> +/* Allocator Optimized */
> +int ppm_kalloc(unsigned long address, uint64_t size, gfp_t flags);
> +
> +/* Desallocator Optimized */
> +int ppm_kfree(uint64_t size);
> +
> +#endif
> +
> +/* Flags Include Guards */
> +#ifndef __PPM_FLAGS_MEMORY 
> +#define __PPM_FLAGS_MEMORY
> +
> +/* PPM inits/starts in Bit 54 of a 
> +   64-bit variable 
> + */
> +gfp_t GFP_PLUG_MEMORY = (1ULL << 54); 
> +
> +/* For free memory, the Bit 55 is 
> +   used 
> + */
> +gfp_t GFP_FREE_T = (1ULL << 55);
> +
> +#endif 
> +
> +/* Macros Include Guards */
> +#ifndef __PPM_MACROS_MEMORY
> +#define __PPM_MACROS_MEMORY
> +
> +/* For Kernel Kernel tests 2 Bits (54 and 55) in 
> +  1 Clock Cycle (or in small clocks, example: 5 Clocks), 
> +  is used a mask using | 
> + */
> +gfp_t GFP_MASK = GFP_PLUG_MEMORY | GFP_FREE_T;
> +
> +#endif
> +
> +/* 
> +  Notes:
> +    E-Mail of RFC:
> +        [RFC] mm: page-fault: overcommit: PPM (Page-Plugger Under Memory)
> +    
> +    
> +    Assigned-Off-by: João <joanandalima@gmail.com>

I don't know if I am supposed to laugh or cry ;)

-- 
Cheers,

David

