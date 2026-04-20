Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7803EF5A8B1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 19:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83386B008C; Mon, 20 Apr 2026 15:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5AE06B0092; Mon, 20 Apr 2026 15:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6EB96B0093; Mon, 20 Apr 2026 15:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A516D6B008C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:29:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5269C1A0AAF
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:29:52 +0000 (UTC)
X-FDA: 84679924224.03.0018E6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 84AB41C000A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:29:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IxxpSCtm;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776713390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9+W9O1t17WZksDlNIod7UMuWgANY0prMHn8cuMjB/0=;
	b=4xHfw6Miei2pdPc0o+pn3TvdiXV+PLssOuDOV8gWogE8+cpaQYElJD7s9TJMZpO/lAM1tj
	H9vQKegzWiS0TUBvBtUh3mhHhH4mV//uXkk5QvYkf7llHdXBGK7BFAV+UpCZf2gpcmI4RE
	ezTTHj+BtojRCtRdQZCVh7D0MQqbUAU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776713390; a=rsa-sha256;
	cv=none;
	b=C6Iaz52xYd34HkL3xKNIVRwz+kMq2WE1RsHSpZJb4UfruyxIjzFA2RKS6yNjRZhFNGA/cj
	P/LLCXaUa0AzrMlxPf4TS7dboRi8Wee384lfaW/TBJ3RZa50ecBpyYhb6a6wLggdpPDCvd
	6Xmj3d0/F12rCDf8Y0FoJVr6HKqB8Uc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IxxpSCtm;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B3EF444AC;
	Mon, 20 Apr 2026 19:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5453C2BCB0;
	Mon, 20 Apr 2026 19:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776713389;
	bh=KEGY4s5L8vddgO3MvEHaS3XpKhUKLKraGKWm1E7ZRm0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IxxpSCtmgQ8r5uOHX3CS8mUlg7Q4a37vM06e/YT73FKCBbUmrQu+4Vj/89P5SYFKT
	 R5MpM/cwzv9st9kD7vQxzKltEVryMB8H/9LpXQfafBSP2XiUskoWF/R4CFti4AA8cZ
	 1aNVhMQ2MhbL+Wp1OX5WO1wOAZ/oaxCX4ybz7G/QMEiIlYp4GJvFMSl2wh24uQyfm9
	 DqIrGGbdLU7k7AbJOcqxjDz01xd7cPHIWo2aPHmLyobKp/mYulTNaKeARvgFb0Q8Gl
	 6AN9PeobwjlTiEPvZA6wguXZgEUQHoPjKGBA1ba4cjyRlBufdLwuPVrZSkOnnosdyj
	 XDH+iEPWyU04g==
Message-ID: <f13fba7c-e279-41d6-abf6-a12e79bad770@kernel.org>
Date: Mon, 20 Apr 2026 21:29:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] mm/gup: add lockless access semantics on entries
 validation
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>
References: <cover.1776684344.git.agordeev@linux.ibm.com>
 <55c295e17221dc882e09b4caddc7b3bf4f1309ba.1776684344.git.agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
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
In-Reply-To: <55c295e17221dc882e09b4caddc7b3bf4f1309ba.1776684344.git.agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 84AB41C000A
X-Rspamd-Server: rspam07
X-Stat-Signature: c5dd4e7d4h5hpg66y14rsy8uk7oz16sn
X-Rspam-User: 
X-HE-Tag: 1776713390-218423
X-HE-Meta: U2FsdGVkX195MfNwQruxg5LgNSMIxDK5yNyRDmSIzPtqhSCV1C0qXVfzcFGC8vV00vetYEwnFL8xPu5SQZkc0tfARXiY0Eozv1FOZc/ThIzWRUZd4d8tmfDHFw02qkDKl5g4aeq53zOHO6tcZ2x7tasbH1Syzcya8MdlFyYCtOL0++DeYCx8X5jN7AcayfY+zbtmBYlmvZXVONeUABH05BJY3QBzXBJLP+GCRBt/7UOdRJMQkCAjOdmB6lTeRi5ezE9oMRQPqhEW5XVhvnjbZA6cwUW9RHYAai06IvTjlO2dA/GRLPA0ICvRw+L3KfArCmovPC4P1GslgeWKI4APFHlCEa4Y2Vt7zhlApZw8eWFdigRpPZJkCBDebSoeKx1jU/ZRAz4rhv7v8o8qxRo/TqspttsRBEgr5e2I92ARhmm1FHB571KFgblm9KLJcv7iG8cB10t5JN9HcWGvgx6hezCzp+JJdb4egMj2AxnTFwWQXgCNHesDAJz8Lz89UVSYzWdNguS3ZVXKhHqiRtnWJDKd5qAVknSJPqSijX5Otymz3tC40t3fdGsJho9pR97q8MTl7CjLojy0KqOaDXpU+9E6PixwtorDiJiU7iBI9+T1tXLyocoi/FWVumcxwwULxAE5iJGYFLFiStytfTY8UD6C1Fw1KtWCTng/6SNRqmwlRsSi0+tIqkeG3Fi+CV61CMKVmajdqrgbwsOWadpbH8mKmU15j1lFq8Vlyu+j+MgSDHLIgPuKTlVZYYo/SVL3aU3zr/djTU+oxf9ejGVXQ7ASa32u9uy63257gsJR/2pIEi38DgHiywADnxQJ+PyLuxdO45nLqzTmgv6V9i8lEq4ViflOqvtuzhZPOnSprJlVjfiB3SwTYk3Mu72D6MY1l+9YA3u5890KCqQPeVbp02Av9QG53ymgqPW9kAsW+6Ak8Og8Co9h2Mw9tmlyBvdPViS1IM/X4u6LGpmGmCX
 cl1F+LNj
 YgUKBtz11rWG8ekKLdPljzxzpAXBzvTCPMNr2xf5ybvB9bU2IQ/jjhKa5+b+PYiWc8T8HZKEkBEuvzu11T213mNnHVyYs6u41GeEzsfnr4wSUxK/vzcg0z9a0DOyqnhbyafeWN4uerrMwy/LrCoA7g2phNnJ7FWGvwUISASumfkpPN6A1C4deMDMrELGt9ceBIQumm8oyDPGLS77KfyihY6bKo15xWd1A6Qy+04EghOrFzwbmbhYhlhM3pA/OsCs9jSPYZ3oNdUrIAN3M3WJBm1v9fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/20/26 14:13, Alexander Gordeev wrote:
> The PTE validation in gup_fast_pte_range() is inconsistent with the
> prior value acquisition in the sense that it drops the lockless
> access semantics.
> 
> Although this is highly unlikely, prevent a future scenario in which
> a semantically mismatching ptep_get() incorrectly yields the same
> result as the preceding ptep_get_lockless(), while ptep_get_lockless()
> would otherwise return a different value.
> 
> Likewise the PMD validation is inconsistent with the prior value
> acquisition in gup_fast_pmd_range().
> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  mm/gup.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index d149a4b0df71..236450feea9a 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2865,8 +2865,8 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>  		if (!folio)
>  			goto pte_unmap;
>  
> -		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get(pmdp))) ||
> -		    unlikely(pte_val(pte) != pte_val(ptep_get(ptep)))) {
> +		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get_lockless(pmdp))) ||
> +		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep)))) {
>  			gup_put_folio(folio, 1, flags);
>  			goto pte_unmap;
>  		}
> @@ -2942,7 +2942,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>  	if (!folio)
>  		return 0;
>  
> -	if (unlikely(pmd_val(orig) != pmd_val(pmdp_get(pmdp)))) {
> +	if (unlikely(pmd_val(orig) != pmd_val(pmdp_get_lockless(pmdp)))) {
>  		gup_put_folio(folio, refs, flags);
>  		return 0;
>  	}

Oh, that should be squashed into #1 :)

-- 
Cheers,

David

