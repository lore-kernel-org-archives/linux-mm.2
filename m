Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5227FC61DB4
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327876B009F; Tue, 25 Aug 2026 06:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FF4C6B00AC; Tue, 25 Aug 2026 06:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDE06B00AE; Tue, 25 Aug 2026 06:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE5A36B009F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:36:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD7EE1C1888
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:36:54 +0000 (UTC)
X-FDA: 85139438748.26.F2A1E60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1A50D40008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:36:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XTA/Mt2V";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787654213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZb/JK/Dh5FAmjEvCkE963w53qfA4KfGbuSXikdZ8yc=;
	b=s/QCDnIzmNJ/NhIsOser749aYfL1qAACTLUV5Gq84sLxegD0q9XG9EZjqj0WWjGYwU4ETQ
	fLwCfx1bWeAJlEMeUv06tS/CWP9HASVYTXLhxSixex7eF6z4IzC+6mQyBSTuUgiIExmVdO
	yR/bZfwNm2Ti0mkLM9f2MEkzEyDSSrM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XTA/Mt2V";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787654213;
	b=NZ4qx05m6lUWEn9F2pNRu8fSUkE9bksnCLfpzDJ89g5qPWM7l0krIsyIec+88Fx6DBVK4N
	3WqbUN0rTa7b16aiSmBd34JkCIwSVvDz+YKjibZ79CUwAcgXmVgVLQKD3Lg64OTcQ80qPi
	ec+oP7/kL6W4LFL0YxtvSSlmQT400Ng=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 780C36011F;
	Tue, 25 Aug 2026 10:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540A51F000E9;
	Tue, 25 Aug 2026 10:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787654212;
	bh=MZb/JK/Dh5FAmjEvCkE963w53qfA4KfGbuSXikdZ8yc=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=XTA/Mt2VEn4QF+qKmJtNDTROxT68LJvWjnP/FbYThQypthq48pctFFdXh3GV54Iy2
	 QAagZKbHaKbxHp1ru2/7HYm8CmdGhcHddVnsHIEnfDFKRqKG/pl0X7hlgNszBrf5kW
	 DWrmF3nWXeQxjURlRgjHtwB2MBeV+BOr4E35BdQewhRNecZsixOTJdW4y+dnnNmf2+
	 Hg7RWk3PIyW1uRtRpK6YXJnR0KCpbjL9KJkXwDQ+jY/G57QtoQLFQGfTZbD7cnqYDv
	 NH60sP1sO7lC85HrF6Zg3u2bpnmLWxqN5vmQRkI5sJiQrFcF0LftR7kPUnK5K63jCU
	 MUDBJJodTAdVQ==
Message-ID: <79daa73b-0d34-4e84-8450-56f90bc700d4@kernel.org>
Date: Tue, 25 Aug 2026 12:36:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] maccess: Use a scoped guard for page faults
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)"
 <linux-arm-kernel@lists.infradead.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)"
 <bpf@vger.kernel.org>,
 "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
References: <20260824160523.3907021-1-usama.anjum@arm.com>
 <20260824160523.3907021-5-usama.anjum@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260824160523.3907021-5-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1A50D40008
X-Stat-Signature: 39xq739jr3d3i98aijmaxaasaxfmmuie
X-Rspam-User: 
X-HE-Tag: 1787654212-85587
X-HE-Meta: U2FsdGVkX1+KPKmviut9PCb9Rkh+6AH517TM70LYja7I6nt2/RYrh7NYXD2UsJ5+fy6KobVB8dbgvs8bTQYsoAYB8lP1sI3UBxSYlNPnclclO+NhrusikRw0uzoehiLx6OtudWfalvpPc21ca52gHyMTCQs+Qi88e0a2dBWknbERiywzZ9NwvgJ+hxAO8HxSREMSOvVxlABkPNbcGurFT2seErrQHvhrU4UxY2IRIftPih9vGWKsHyyzXkzxKv5A0Rey1fwiwtJ5TJtfuGZlOC5zHapaGCx7zpyFRqKfUjIE/onkM1mgA7gvjOMGuuZcKUYx5sd6mgsyjLWqmTfQr8p8YT+Z/L5gzdC3Uy4QyirKEMjsQtWQTfJDLmYvg4MhIydVNex4kmZ7r6XKMHl7CWKhURAgwQzuaYiHHnpQk0Cpt7ZZowidCr665TWMcXK7oGReX+v5egl5FhV0ZYuBQzStCzxJM0ujdt/aNqcWAkWkqkQVmZZThTGsTXDTphEQkSMholyfITpPQT6hdY9sU5xZ8tVEZlnk2mG+JGQqTGFJhKsXpD4Xm1GFBAWcAiJSV6LD3wkOcsAofxBn6zIJJaQk0HswRD8zuYg0pqq2JqwsBG22U0xWjiZYIWLf5HG3GcKZXwL4pTY3XuaoWPKIvQ/PvEt3B+txaZP/4/xg4wRnClKd4mU3jzWhrl7enD5uQtMQEIQ1scxooQXlqh2gP1S8Rc+MYephPQ/WqEnB9b885yFIGQDzdlnssDfBiAhuA4vOj5PWDdUeQ8EUMP+SuWGvABApU1kjr/ZcvCNryV6YL2J/92HBKZ1eJvqcprnwbtY9tDoRXhU5p1/RLjlPpTQTgr913AcGW0ghO8L8J03Zy1k/jZcr9HAqPay+ODCXZ38yO7ha06fuJn1XRYORrWrIW2/T3KZ+8fYVBVnZ4e/IfWaFjQwPSZeYZsIYQharM4xTigXW/rfO+CszbqI
 sMOR7I2x
 YyOsVYorM6OQU9vPPsNFHTAzXfeaQY+CUgXha4gvVKQHcdxxkoEd0BS7Q1aQZcWdGi+YMjnWtifgjkapD1lVZdakyjOPnLVGEE14uHVD1fll+oyTgzo2X46/CNRFP4lnP+EqZmVLayg9AVU6+5XxarQqhBmJBqNy0wNPSesBhYle+bWFN8lbDWWTR24RwgBOOhQUMuew6vD72yTP5bw6nASHfW/w9kqwXD0Lv7Pp8LxR0tDyRNZmYgnw57MkDL5AQcvK59Q2YKHZgIjbz7XYLiDLA6oB/FZsTCzeHoyrS/AiD1n5FBgP89ui5yS9acz1ifAZH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 18:04, Muhammad Usama Anjum wrote:
> Kernel nofault copy and string paths open-code page-fault disable and
> enable around label-based loops, duplicating cleanup on success and
> failure.
> 
> Use a page-fault scope guard instead. Leaving the scope now re-enables
> page faults on both paths without separate cleanup at the fault label.
> 
> No functional change.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  mm/maccess.c | 53 +++++++++++++++++++++++++---------------------------
>  1 file changed, 25 insertions(+), 28 deletions(-)
> 
> diff --git a/mm/maccess.c b/mm/maccess.c
> index c59a0e092d24a..f695ceefe6fcc 100644
> --- a/mm/maccess.c
> +++ b/mm/maccess.c
> @@ -38,18 +38,17 @@ long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
>  	if (!size)
>  		return 0;
>  
> -	pagefault_disable();
> -	if (!(align & 7))
> -		copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
> -	if (!(align & 3))
> -		copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
> -	if (!(align & 1))
> -		copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
> -	copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
> -	pagefault_enable();
> +	scoped_guard(pagefault) {
> +		if (!(align & 7))
> +			copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
> +		if (!(align & 3))
> +			copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
> +		if (!(align & 1))
> +			copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
> +		copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
> +	}

While I understand what pagefault_disable+pagefault_enable does, it is
completely unclear what scoped_guard(pagefault) does.

Should this be scoped_guard(disabled_pagefaults) or sth like that?

-- 
Cheers,

David

