Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B6B2CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2D046B008C; Thu,  1 Oct 2026 07:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DD306B0092; Thu,  1 Oct 2026 07:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3116B0093; Thu,  1 Oct 2026 07:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 643EC6B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:34:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79C8E403BD
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:34:39 +0000 (UTC)
X-FDA: 85273849878.30.83E5CF2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A5F15140009
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:34:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hU/U6Fzr";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790854477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OFUfBJhfs43LK2uJ35trWg6Dxj/vYrf6yAbtRpo/I9Q=;
	b=4TsbcxY6uKRUCLS4H6ev4Nh1+8AryJYKhLCakP5Z28DKc8+G0Hmal95ycqyHr0K7rloHZ9
	mhjHiRnW+dDEr98BRxG7oNYZfdzxTNSblFb0Udv+YCrWWJoHFowj6MI4F02xd6OsF1HRIj
	bGO6QSCkmQq8KjnP6CFbl+bMn65M0vQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hU/U6Fzr";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790854477;
	b=ECYfGzqM/VW1Y/JpTUheq+DAIjUN7oNTxgOGF63yfMjZClX31fXzM6YGTaLGNo5ybfiH1K
	4F8mVrSywFJZwtGTSPhfVmPT6oIRGoNbppuZlcddfjcsf84NyNiZBYhNI6wro+7lj7Mph+
	utk1j1z2zazlJYTFQebFqKzl2v/McLY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C98D941745;
	Thu,  1 Oct 2026 11:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7079C1F000FF;
	Thu,  1 Oct 2026 11:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790854476;
	bh=OFUfBJhfs43LK2uJ35trWg6Dxj/vYrf6yAbtRpo/I9Q=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=hU/U6FzrcmDrLuYwspEuImByZobXbfI3VhwI7ef+aDvD2f2HwXe2U0G2qGEHQJzu6
	 fgcV7rEMPAoLLQN1Q2c2AXy58ZQUD8hIexEoci4gM6Ih/uiXQxHxNonUVR69E6Z8gX
	 ZTd2WblSoo4EGpHGIeFX6HXyLNzS/Cdpm+hpU9rUMMXmjb05OM36DMx4SfGLcf0gsY
	 Xd5ro+jXBJIF3mVya4X9/ghB9UFUxuxmCPjf3cWIEx2a3tmZoAqGLQznV8tA3UPEsW
	 K4ktT/2AdvhFaj3l0TnW65UsRSRYVUOIcQe3dCdHOI6V/iROn3Thy4HYnYpDvZky5p
	 AYOKVxe1+r+vg==
Message-ID: <10fd28a8-04e0-4e50-860b-ae094dd1e008@kernel.org>
Date: Thu, 1 Oct 2026 13:34:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] maccess: Skip setup for zero-sized kernel nofault
 copies
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
 <20260824160523.3907021-4-usama.anjum@arm.com>
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
In-Reply-To: <20260824160523.3907021-4-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A5F15140009
X-Rspam-User: 
X-Stat-Signature: gqt8m5ebj5apt5xwxsk1gho5k6qdfojc
X-HE-Tag: 1790854477-34976
X-HE-Meta: U2FsdGVkX1/3NmSUDKPsApjBQj5OyXk8UlCSihUvaqnaSKHV6Yib64Da46AezUSjS7ZNsvb24dROwfazC5+N+ciN8G9TicOsgvjm1UyaxnbHTFplJukUU90+Fr02yjTfekNQoiA9A/d8r6u/bAa9wb+S2E+YKb9HidNHKj9PA0td2tsPXfsvAskv50gEtUCwxScue3SY+d9NOf0xn1wTGiCfjCiBU/9/wFWtYTwGfnpikWjysbJuF5/x42Z5J8/S4jnw5mHUskZJNNB+DEwCCNdZuGE9tGctwPHaaYeRlsxZ4SLHS01abZiSmK7hE+80KCcms1BbeBWh4Q5ysfLI5nCjhG6sAh4QlaEEYJotG/5Ufca2Xtr5n0LIUSDl6WjFSOYKwYSFDR1vvTYudWxBDZDDGEECWMO6HjXYd9MBf9uz9Jashl0lbNjWVGX+Gsf2bnG2MlgbKPelhO/3I6X4x8mou6YKCAcIt7fwN9tP5IEdGAeQvxHsT39iLtyA/jBYtbLWeVUbtUGQLs+TQPEUEYjjf4o+bS4xxNX0A30ylqeHV0+X7K5huoUOITAl0jtbqhUWywA0e2Ab12lL847AWEo7uYL3eoD/gfzjr7ESJrR6LCOUmSOBkYD/pG3/I73KvVjiqUrfbtKlq37w9cCEPSAc+KsFK0chUOg9hYJjpeLcbT5Rf2y+71pH7/cVkFG3lt4S74y59Q/hbMDR7O/6oO91vEvYRlGvHebIqRv1YwDtjkhqoJqq+SRMS2yRo/+oFZh2pvquUjpo6G4H/8F4DvGfN5kqVD5fK83t5crB3L1Jhr3sAVPDfTgKV3dP5DxtJCt5vWVrcRJIXbsX0+qrMsks4bJYUz2tY6zXMmLq/UplM54ZaD46pbtsJPEeBAm2cPCfFBIxYu2krNWfyDLWEb37/+SUrHP5INFr9ZFLU7xJM2uJxyqIDe7CsIkPxX8wovGq7BVzu9t4Qls1o/U
 TgmFzmHH
 7auKgoi11Zw4N1NtzQewir+VpRZwNZ7m7ZCwD70raWfYc07HIyzOTa4sToNZlecK4qnQpLdTtkfMLkHweBI/uQHD8794QQ6Tpx2kSlaame3B+9EiB79WbIwfpf37S1a4BDUSjMkpl950At6yWpK9DnW9sPexSjQNZBn/o3Bw0eyOvXpTFp14JCZm21JnpXEo1MlOKLxV4gRCZCaCzq+myqctih9Btb9juz1YiFi7NCZEZUaGWrCV9T8J4Hzc+KiTdqn21s9YRAMpqhGIIFYzvRBd5ddKB5Vg6BY8oSggdPK0i4H4KrtFpOnecdqGUjNlTfV2m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 18:04, Muhammad Usama Anjum wrote:
> A zero-sized kernel nofault copy does not enter an access loop, but it
> still disables and re-enables page faults.
> 
> Zero sizes are valid. BPF probe-read helpers accept them, and KGDB memory
> packets may carry a zero length.
> 
> Return before changing page-fault state when there is nothing to copy.
> For reads, keep architecture-specific address validation before the fast
> path so its behavior is unchanged.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  mm/maccess.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/maccess.c b/mm/maccess.c
> index 486559d688583..c59a0e092d24a 100644
> --- a/mm/maccess.c
> +++ b/mm/maccess.c
> @@ -35,6 +35,8 @@ long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
>  
>  	if (!copy_from_kernel_nofault_allowed(src, size))
>  		return -ERANGE;
> +	if (!size)
> +		return 0;
>  
>  	pagefault_disable();
>  	if (!(align & 7))
> @@ -65,6 +67,9 @@ long copy_to_kernel_nofault(void *dst, const void *src, size_t size)
>  {
>  	unsigned long align = 0;
>  
> +	if (!size)
> +		return 0;
> +

Worth an unlikely() ? It's the corner case.

-- 
Cheers,

David

