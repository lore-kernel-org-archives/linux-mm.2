Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D1BCCF2D9
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 10:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C40B6B0166; Mon, 19 Jan 2026 05:20:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484826B0168; Mon, 19 Jan 2026 05:20:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390BA6B0169; Mon, 19 Jan 2026 05:20:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21FDC6B0166
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:20:54 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9279BAB23
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:20:53 +0000 (UTC)
X-FDA: 84348319986.28.7782A83
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 121BA40008
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:20:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UGJywINq;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768818052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQ9min3qWVodOa87w4DKEX0UUM0vB531hXuHy0gMwsE=;
	b=X2ROBU5ZcuwdVLKqXfLfJbUrNiS8muvmfjP5adGhJ4bmKN3RZ/hiUWGxUYWiV5IESoPy3Z
	BAa+ticzHC2FEUEwqk5jLuUcKQ/CRpj2junDGi8YN+vsH+J6ctBiDNDYcYEkBzJC5w9Ndt
	EBsaA4qi0XtiMbf4TIsTDSmuofmgYMo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UGJywINq;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768818052; a=rsa-sha256;
	cv=none;
	b=mlIT6awU0PJw0DlwJGoH4gCnva6DMuz01VlV9RJGFl3PCAQavIUAviNEDUHGk3c4ju82xv
	JNOs+RAfdPePGqsQVw/Okp3555o3FN9ABwKuQnUBGDoXlK+HYVwjgxTiGBspI7jZbIGT3+
	D3f1frP86bTFM+p5QnWT1PM7SxTV7HY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 18B7560140;
	Mon, 19 Jan 2026 10:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C777C116C6;
	Mon, 19 Jan 2026 10:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768818050;
	bh=O3CZH8Niuk4d+2faxjZDZylA2Qy1X04DLYp5vprOyBE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UGJywINqQlP26oRRuhAQ30+JcvUZC+z/ghQV8udAX6B0OfOCG6e8Ee3Icuh7OauiH
	 brY18ro3p1vlEEGM50AhTaFe1ByWTrAJrlkI+Vc38HMnwRyHBXLkBfwCUD7MKp+y1J
	 wgkXJeBumJzByhtc7X5Nj8HKhbkG5+AfLAmweLY/u06veL1F8Lwy+yUwK+YFJp3deh
	 eklC+rPkPsTDk+n5Ndj2/qMIzz7E5YVB0PVzHle+JUwuGqUOGr+SYadyycXj6/6TRQ
	 gYM1iEnTf1YtwkHa+FFOYCTMh0B0qwRDcQgCJavPQE53rxebxOlIU+X92AH9h5z39s
	 ingEnw2wBQ8eQ==
Message-ID: <8e164e8b-1748-4570-822c-b973770e8fb7@kernel.org>
Date: Mon, 19 Jan 2026 11:20:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] mm: make PT_RECLAIM depends on
 MMU_GATHER_RCU_TABLE_FREE
To: Qi Zheng <qi.zheng@linux.dev>, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, dev.jain@arm.com,
 akpm@linux-foundation.org, ioworker0@gmail.com, linmag7@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
 <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
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
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAa2VybmVsLm9yZz7CwY0EEwEIADcWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCaKYhwAIbAwUJJlgIpAILCQQVCgkIAhYCAh4FAheAAAoJEE3eEPcA/4Naa5EP/3a1
 9sgS9m7oiR0uenlj+C6kkIKlpWKRfGH/WvtFaHr/y06TKnWn6cMOZzJQ+8S39GOteyCCGADh
 6ceBx1KPf6/AvMktnGETDTqZ0N9roR4/aEPSMt8kHu/GKR3gtPwzfosX2NgqXNmA7ErU4puf
 zica1DAmTvx44LOYjvBV24JQG99bZ5Bm2gTDjGXV15/X159CpS6Tc2e3KvYfnfRvezD+alhF
 XIym8OvvGMeo97BCHpX88pHVIfBg2g2JogR6f0PAJtHGYz6M/9YMxyUShJfo0Df1SOMAbU1Q
 Op0Ij4PlFCC64rovjH38ly0xfRZH37DZs6kP0jOj4QdExdaXcTILKJFIB3wWXWsqLbtJVgjR
 YhOrPokd6mDA3gAque7481KkpKM4JraOEELg8pF6eRb3KcAwPRekvf/nYVIbOVyT9lXD5mJn
 IZUY0LwZsFN0YhGhQJ8xronZy0A59faGBMuVnVb3oy2S0fO1y/r53IeUDTF1wCYF+fM5zo14
 5L8mE1GsDJ7FNLj5eSDu/qdZIKqzfY0/l0SAUAAt5yYYejKuii4kfTyLDF/j4LyYZD1QzxLC
 MjQl36IEcmDTMznLf0/JvCHlxTYZsF0OjWWj1ATRMk41/Q+PX07XQlRCRcE13a8neEz3F6we
 08oWh2DnC4AXKbP+kuD9ZP6+5+x1H1zEzsFNBFXLn5EBEADn1959INH2cwYJv0tsxf5MUCgh
 Cj/CA/lc/LMthqQ773gauB9mN+F1rE9cyyXb6jyOGn+GUjMbnq1o121Vm0+neKHUCBtHyseB
 fDXHA6m4B3mUTWo13nid0e4AM71r0DS8+KYh6zvweLX/LL5kQS9GQeT+QNroXcC1NzWbitts
 6TZ+IrPOwT1hfB4WNC+X2n4AzDqp3+ILiVST2DT4VBc11Gz6jijpC/KI5Al8ZDhRwG47LUiu
 Qmt3yqrmN63V9wzaPhC+xbwIsNZlLUvuRnmBPkTJwwrFRZvwu5GPHNndBjVpAfaSTOfppyKB
 Tccu2AXJXWAE1Xjh6GOC8mlFjZwLxWFqdPHR1n2aPVgoiTLk34LR/bXO+e0GpzFXT7enwyvF
 FFyAS0Nk1q/7EChPcbRbhJqEBpRNZemxmg55zC3GLvgLKd5A09MOM2BrMea+l0FUR+PuTenh
 2YmnmLRTro6eZ/qYwWkCu8FFIw4pT0OUDMyLgi+GI1aMpVogTZJ70FgV0pUAlpmrzk/bLbRk
 F3TwgucpyPtcpmQtTkWSgDS50QG9DR/1As3LLLcNkwJBZzBG6PWbvcOyrwMQUF1nl4SSPV0L
 LH63+BrrHasfJzxKXzqgrW28CTAE2x8qi7e/6M/+XXhrsMYG+uaViM7n2je3qKe7ofum3s4v
 q7oFCPsOgwARAQABwsF8BBgBCAAmAhsMFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAmic2qsF
 CSZYCKEACgkQTd4Q9wD/g1oq0xAAsAnw/OmsERdtdwRfAMpC74/++2wh9RvVQ0x8xXvoGJwZ
 rk0Jmck1ABIM//5sWDo7eDHk1uEcc95pbP9XGU6ZgeiQeh06+0vRYILwDk8Q/y06TrTb1n4n
 7FRwyskKU1UWnNW86lvWUJuGPABXjrkfL41RJttSJHF3M1C0u2BnM5VnDuPFQKzhRRktBMK4
 GkWBvXlsHFhn8Ev0xvPE/G99RAg9ufNAxyq2lSzbUIwrY918KHlziBKwNyLoPn9kgHD3hRBa
 Yakz87WKUZd17ZnPMZiXriCWZxwPx7zs6cSAqcfcVucmdPiIlyG1K/HIk2LX63T6oO2Libzz
 7/0i4+oIpvpK2X6zZ2cu0k2uNcEYm2xAb+xGmqwnPnHX/ac8lJEyzH3lh+pt2slI4VcPNnz+
 vzYeBAS1S+VJc1pcJr3l7PRSQ4bv5sObZvezRdqEFB4tUIfSbDdEBCCvvEMBgoisDB8ceYxO
 cFAM8nBWrEmNU2vvIGJzjJ/NVYYIY0TgOc5bS9wh6jKHL2+chrfDW5neLJjY2x3snF8q7U9G
 EIbBfNHDlOV8SyhEjtX0DyKxQKioTYPOHcW9gdV5fhSz5tEv+ipqt4kIgWqBgzK8ePtDTqRM
 qZq457g1/SXSoSQi4jN+gsneqvlTJdzaEu1bJP0iv6ViVf15+qHuY5iojCz8fa0=
In-Reply-To: <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: erytsh3mixedgk7r5re76px3zawqrckj
X-Rspamd-Queue-Id: 121BA40008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768818051-681070
X-HE-Meta: U2FsdGVkX1+fUBjA1h3auxrYT0tMhqeZ3Ebr823yW6xT1AXXlfvr0D3sSFbf5C3Av7+PzQ0Q0da8QoZocaERzl2plR/s/hWpSlvZsASnAnPrVv52Dw/raIYr/E1CnZenDZHw+4HmZcmh6yTbE+WvQFSzk0AiZ891ZViG0eLt8IpJPy3CH7Aau7Rsn9rtMfdEzgSOxObkzYmUQD8tknFhwLca7RUa2dAWQUTSuWPjhcQYYqbFAcJqTlF1CH4Em60rhuEGCgTOUUGmtA0JvhsqNr21GiSJG7N+wvHx3yQDbrIplf58qZ37tIGAwBrh3+/nIzYKSOnTABcgzzxg0zu6lkUD7Z+KOCBPBBr+yxJ5hGvtCye7wYcHY82Fm1dvPr5mcgjYTj0sV+KgudggRRfFzPkbW3AkFG5L6Bk3AybI7vsn6DnHIImMMlv4f4ooQx9VWNDL/sDEQI5LOS8LkJjSFAtioLoUsc7gcUCifG+ngNVnXdREIKV8YHDUr651ywsfsEQh8PbJyRjribhhVnPdqXJUabBSufBgFiXVHjRfyIW+Fw5bdwWohQC6qG+xREAun+PxyvZlMQjw/1Cvnu6mAuIkP3R2fTn7HYKTqyyVTUdti1EClrnHizFc2UFh5MmmnWP1gq+P7cHPJSFA5IXBcrv7rVB6IvZun3+48W0ipG4he7NRDmlRcQk7+57h1uMwdYuqm9hb4xNzyYLgYbRQPSbQpvwLtbK4UVbsB1f8VZEyV8VV9GoOuoItp57xks0Fa1lwsQVOoPR52bIOseEB7nF4PKmiCf/fcaHmuKvZJkdRLx79Wc8lNQbYqzM4r/Q11SldK0JnJDobQ0SCS6aMGxb+OyVI7CLoG539mTvtGEiqnyEs1rK7qT0VkRk/cjBI+RXAVJkDGbaDEsKcWZW9RAeO/L4doqDcZP9w7eCSQc1M/2jJr6zmku1enIVNDslLnSOsY6oqu2TbyU4XIB9
 WLfo4sX0
 nSqPyHJ7urwEksOU/XVoAyB0dupn/tesVrf8pcABON6/war1GhTiOX9tU/8IiwDsIjbXCyRJCP/tS6XltBu9NhzTsw2Gz9ov35eKRmhNggs7xrOM5vYH7XR8ezC/qRcEqOR94yYwIs9Od9s7kK6vg7Q6/hCvOgnbeObE5mEB69JohBWwtojvT9mdYdirvBDEtqDX84/ZTDg6zAt+ZJlc+8RIahiGzkxTs+qrsfmMDRH2LBWvsZi76F7BAwVdp21KNUWHQVYqlCWa9aPxHsu08c86m9pPbw3Avd48bF+/iNyZwoFmZ4ND0t1NcekukKx3/h72/+eUw8zC+KsxJ2I4TwKROrCVsmRFPyRQ6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/17/25 10:45, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The PT_RECLAIM can work on all architectures that support
> MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
> MMU_GATHER_RCU_TABLE_FREE.
> 
> BTW, change PT_RECLAIM to be enabled by default, since nobody should want
> to turn it off.

Right, and if there is ever a need to, I wonder whether that should be a 
boottime/runtime toggle instead.

So far we haven't heard of any relevant runtime overheads that causes 
problems.

> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>   arch/x86/Kconfig | 1 -
>   mm/Kconfig       | 9 ++-------
>   2 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 80527299f859a..0d22da56a71b0 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -331,7 +331,6 @@ config X86
>   	select FUNCTION_ALIGNMENT_4B
>   	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>   	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
> -	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
>   	select ARCH_SUPPORTS_SCHED_SMT		if SMP
>   	select SCHED_SMT			if SMP
>   	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
> diff --git a/mm/Kconfig b/mm/Kconfig
> index bd0ea5454af82..fc00b429b7129 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
>   	  The architecture has hardware support for userspace shadow call
>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>   
> -config ARCH_SUPPORTS_PT_RECLAIM
> -	def_bool n
> -
>   config PT_RECLAIM
> -	bool "reclaim empty user page table pages"
> -	default y
> -	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
> -	select MMU_GATHER_RCU_TABLE_FREE
> +	def_bool y
> +	depends on MMU_GATHER_RCU_TABLE_FREE
>   	help
>   	  Try to reclaim empty user page table pages in paths other than munmap
>   	  and exit_mmap path.


Nothing jumped at me. Hopefully we're not missing something important :)

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

