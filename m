Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82415F5A8B1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 19:29:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0DC76B0088; Mon, 20 Apr 2026 15:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BEDA6B0089; Mon, 20 Apr 2026 15:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AD946B008A; Mon, 20 Apr 2026 15:29:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 71FAF6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:29:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 135FC1A0A5F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:29:07 +0000 (UTC)
X-FDA: 84679922334.29.197CC30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 485101C0014
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:29:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hJH6Mnra;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776713345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XOKt4xuu9aYGHMo0ozO5emvfr5AohzSbQDIYd2jJk3g=;
	b=KFnYJN5S+ajJHbXXe6OyDKydMPGfwpA88Nc6QToGCwypNVTEVFbBUakVpZNjYXA6alpJfC
	QLVQ88sMm8CTZfeIR5z+kBS+fUj87VKlW8WxCGPJOHq0osAEv6pHdJAH+vrHOy+LWUXXrG
	Tt8cMoh7JD7nHesc4o9b6cEjRiyhzgc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776713345; a=rsa-sha256;
	cv=none;
	b=FpcvG/fXR42kTEZuwr+fYAE7TVyH6iwHDDHo0tcHbsWyIxnENq9xvm+wXeFVij57vn61Rs
	7RMXZUv+zgp2Yg0k+f0A/XRjX4JSJ2R0RB8blDZPt1MrEqQ1CVgTQZGQFCp7bRzyj/g9z4
	IjmojG9y0Um4MnItj60zYxmglMiJssM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hJH6Mnra;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9308760018;
	Mon, 20 Apr 2026 19:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6018AC19425;
	Mon, 20 Apr 2026 19:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776713344;
	bh=QdgAajlf6kAwRHtkgflL6wCDhjveKOc9T3w7CaJc3Ac=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hJH6MnrayH7tH7XZNu4+MSSVAtDe6/j7JkTnUkZ0vRtSmV6VgsTR719xNXjz+vuae
	 bG7WsXAbqdu9ujKzv4fC/pGW1a6KxsqJdlftGLAUSHU6jkkY0/zTvjjwPZ6m/nRUc/
	 qkn0wyAkW1gNLhWsnHGbK2KOkFz+cXC1sQvZRxR14c9ssIVBO18l1ZH+U1B9/KUkdh
	 8WUbGg4Uh3JvLzI3RHfBzNg0CCXVUzTVXGZKHpYsky2nuIdsnZbRyWwrk65SzNw1hP
	 o5Pqr/LfmAROKXeF+HX5+mxZ+gUe2vI/KXisxiSnBMs3UfHIKBMIoEi8wUwlqLph/0
	 oL1GZBpyWKvgg==
Message-ID: <2809fac6-44ef-426a-923d-01661e2f428c@kernel.org>
Date: Mon, 20 Apr 2026 21:28:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm/gup: add missing pXdp_get() conversions
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>
References: <cover.1776684344.git.agordeev@linux.ibm.com>
 <3d0213714273d83c07cb7681119b799ca77984b9.1776684344.git.agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3d0213714273d83c07cb7681119b799ca77984b9.1776684344.git.agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ztg61wxoz41ykd58afjrcdy7875zgwf6
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 485101C0014
X-Rspam-User: 
X-HE-Tag: 1776713345-790906
X-HE-Meta: U2FsdGVkX1+ApWRAhCE3fWjclCNI0a0Fj7ymzMZJO/3AdAWeaeOAQfK2SqBgruDTw9wILUo5lYxLUuBrNlPpM8FyVAOM1TKUQfIyTiI9Yh2VdnGxV0qVXHOn7Jb0VsW0lwzOoptbMnb8KyWpGsq8zHy3TAqQWpyFtBi472go151QS4vJ+9ktkg1DduZbWBs5h7RjRscBIliONavYAdYsCkm7bCs4yOLe0Yf2ENFal/mNG2PiTVtQJyRFUR9Hvco6M3Xg6RTPSce/V8OLLGapcHIjmm4ZZxsJTwQng3DlyR5Juf2QILRlLJ/JjuhQKRGlxhQPDGBczACL4S0CQiYU7K3Ym5PRAgPltkUUe2PPK72de+qdn+H2RrBClWCZCHD/u0MLhW8q2kl4ZpQawB18/OluuYnsXvAe4EhLHeFkIbzq3Jvc095fJkrTqspuETVpCdIDg55KEvJzIy3Yoe5LKUD+hRy+3krXsMvmZiyG4ad7IRdMeBw21NeurgXZ6nrcZRcDBlbxwFhgQ8xy9DWPF74AVHr9zhfalNmcdwmE5w9XHPNTFz4KhHHeP/48ch6I67pzk1Vlg6Tp/hyOsxz+D8nUi9YEzKL8Vl59oRFjyyp5a0+PTYOFJYvsPcozLz/M36fJBYaCsiVPZoHFMMtJ+5KBTizfAti6+CQW+A5oZvV99HBum/3wWSp+Q89p8IDJfGXzZZZUmB/AcO7cVXhr5bjX6/d/slKRo6Y3jvGvSLJBYJ7T9MBus57Uzx18k3vpXl6YXT5+TpWl03vMP4Pcxncaf8ZQXLLEvFBckZjygPROtgsfvDTYMEMwtqZd5VC2pjnvRzX8r1CFMkr36J09k5AXzu046HJWeRhrxnumh8XJMrTMkAQbuFMKQcYlOtBORE9Skvp9lTmep9Kqy8x45JVoSoVP1XLLcZH5GsWRx00rQs8klKyYa18T6SGshVVVX8lzZSLN2bPIKiVJopi
 FgXjrAnr
 AXagTPemOp9KALsO4I3ih3nhRpWLDULiV98eSvQ5qk/y5eUDqC9W+3f/FaUP4UfCo6JJrDeSi63Ncyj/cr+te/KM8EuNH0CuHj1JplNusyC8UjUVbYa1WFS4kBrawZ2sGAzaZBgYD1xa2dhdQUdwu6lVzq/3VINDKaAjrpxmJskLaE7OY+IOUXv0gIH6PQJgtkBPsj6E2u1gekRB+tC53OMB4bPn5heo7eKEwZpxDWCdVCiL6cjGoXUwpAxcohWgpySQEobt7h5el2guxci6rlY4VBj1RxNQLABUWSJPBNYWssJIlAoVuqQf4t9xfhCB96d/9dIPEV+glj0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/20/26 14:13, Alexander Gordeev wrote:
> PMD and PUD entries revalidation has the same semantics as
> PTE entry revalidation. Convert the remaining direct entry
> dereferences to the corresponding pXdp_get() accessors.
> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  mm/gup.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 8e7dc2c6ee73..d149a4b0df71 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2865,7 +2865,7 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>  		if (!folio)
>  			goto pte_unmap;
>  
> -		if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
> +		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get(pmdp))) ||
>  		    unlikely(pte_val(pte) != pte_val(ptep_get(ptep)))) {
>  			gup_put_folio(folio, 1, flags);
>  			goto pte_unmap;
> @@ -2942,7 +2942,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>  	if (!folio)
>  		return 0;
>  
> -	if (unlikely(pmd_val(orig) != pmd_val(*pmdp))) {
> +	if (unlikely(pmd_val(orig) != pmd_val(pmdp_get(pmdp)))) {
>  		gup_put_folio(folio, refs, flags);
>  		return 0;
>  	}
> @@ -2985,7 +2985,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>  	if (!folio)
>  		return 0;
>  
> -	if (unlikely(pud_val(orig) != pud_val(*pudp))) {
> +	if (unlikely(pud_val(orig) != pud_val(pudp_get(pudp)))) {
>  		gup_put_folio(folio, refs, flags);
>  		return 0;
>  	}

These are all on lockless code paths. Shouldn't we be using the lockless
pte/pmd variants?

(not a matter of correctness, rather a matter of semantics)

-- 
Cheers,

David

