Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BACACD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 14:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E05506B0005; Fri, 12 Jun 2026 10:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB66A6B008C; Fri, 12 Jun 2026 10:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCC206B0096; Fri, 12 Jun 2026 10:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDA426B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:25:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F5D51C00AF
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:25:01 +0000 (UTC)
X-FDA: 84871482402.11.BC4BA79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8AC602000D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:24:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BmXV9GHE;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781274299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x6Ya9QYj0XFq7gyk+7qpbpXHofjdcXC20XPazYbg+ns=;
	b=XSWvv0cJ6aC8Ruwxc+50QLulQpdxFsDYWQROcgRqNNdP/NVsw/Hok6PrHVfYXmCuMFkuZc
	I5J7WZAwpP3a+dz4AgbNgxH4FsP//OcdEQwZiETuaGg4IXxt8N1QdizogN97SFwounsDng
	WXs5Y7M1lH0F8zWgeXVVNq397wAL4qA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781274299;
	b=iLVxXdLouTmrEvPsLXkiU+pJPlHx7fBxangLtrUjC7QdVp03V6EtmTPYxhUNWt4ia5EMTw
	Zmf0VA7amNkrgAx3DRSYStAa3YeVZzE9bvYIdwKP1XXnnD/yHtPB/nDOoht75sBI3YtfDw
	s0Y9g/aOtpYHVnvX8FLDl6lEaAAyp3g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BmXV9GHE;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18CD96008A;
	Fri, 12 Jun 2026 14:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2B71F000E9;
	Fri, 12 Jun 2026 14:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781274298;
	bh=x6Ya9QYj0XFq7gyk+7qpbpXHofjdcXC20XPazYbg+ns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BmXV9GHEYRrExHCEy4rRQ9NVeIIfANNm8fdnohNfi3LqhcEsqiCgBPCpAHyW83C0X
	 JbLp6+tiWoS86I2ljesOhQIKPjMe6YoOY5uzPsym0dQKF/oDu3qK0Wc9mhURPN1F6P
	 yh5s54niXCzItUe+nqBrj3ZqRtJtflQmClW5A/83s/G1LzqOPloSrEXa76rZ/AKp0p
	 gv+ZJdXMakjEB86tXICzGIBZFWl+1jt3SEwFQZVt0u8thwBN3raQ0Gs9JyMAcRiPtE
	 ZQK8DDczVgSpxWAfRYUj9KJIMpOKxFGeytO7lu6yq6Njm1X9drZ7TDlOP2b70Qqz4b
	 GQLTptAxLJ/IQ==
Message-ID: <9ee74fad-9426-4bab-a64c-024a3c9959b0@kernel.org>
Date: Fri, 12 Jun 2026 16:24:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: drop flag-conversion "optimisation"
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8AC602000D
X-Rspam-User: 
X-Stat-Signature: 37c98w9adfeg75ap6egw96pahg9d36ho
X-Rspamd-Server: rspam08
X-HE-Tag: 1781274299-3598
X-HE-Meta: U2FsdGVkX1+N0PYdecIXvjU5smgqvuztlYCMvb0R6+4ngPPnduTy+jN3ekQOb9lpn59ATunL93+gePiskeGCmdwLNH8HE3ePtAMUu9Ar32vhvBIa1nWiedqjSVSl2c3ZFEfgRgUQ9CbtIWVau27MVXde55/+OVqiqYP6gZqT+eCinm3RecugeJL3wk6u9Z4yxofKiOffi1imwgiPwdksgxNDo77H1MPYY6kN95SletcnCilraOSKCgu5LsrmXlN4z98bdAJhTTh3d2m6grmYvkZ+aM4NYXWiNYT+BGw+uDPNmNg5220xqaRrW5UXDcMDIAKTt70bVAdKGWntjYrF+iJSNCoHq3R5XChfWVWnV5hOSBBsw/WGkDp0cxICxrFIgQW346nX2HZ6vyXmcM3XKZah097efcDUFxGlGftQF3HQxISOhID24hu1+yebAhNF6ylSl0X1yCotbJfvu7M1XzKClgCEKaBog2DlY7pqR4Jx6CTJLjEaQ9o19SxR/zfkzNpe0rgGftQUrFEC5ukpmwp0xeU7Rl7xe3sO67vCY1y5K0AZwCPyKce73PaS2WtVTrdCcJYsRoxvbI6mecONewJZyBf7Wt5XgsUOsqCmxb25Y4PHp6CBDnJY7QTtQpNKy965LaZihKq0mVRKnEQ0DBXejLs6a0JPxYv/cJDhA/47JNxbEu5/MFCYRaiZ99TZvwBJrjlTLEtu6/+jfx9H523AcvQm2gLMaXIQ6FOQrAVlyzvI6FiyiJW3j7drtT45fx0hI6VYjA8I9kO0vux83gBD1NZixrrIF9nuy6xvlj8coAsxH+zDeBu2YqvTl1YRZJRcZRwQO841sl4qIHiXRw/rXwkyw3jrpZAgKkx/wuRHDWh5hjGtUPIJ5PFeoUrhj9BcdLGxlD6Wyvio4mNXMYY/H3h8od3w0eaQxxZonKrL9zRuSgNcSmN4qG+sde8QuFfJ9FYmKiM0t6cWJuI
 GYVwNCSG
 BTkbKo1l9fCjLmo1beHNdbGTgBTv56LX9akOEh6umaborYmwa8mveCyQiAKSN1JxSVf/UxYHW9ND8JyRgMX95l2qh89HBng5FKyzXCCsBpA5yfPre+ZxOosLXwa11k9uADU4SlDvbkVJ2yptWIf/KvLno3mIWyE4Z9rac6HSIC2oaO654fApIzYQyZ1F5PnvFlP40qgWln8/fu5EkxMbHIjoQidMMUQRY2OoDLdSNkXnMCiBqh4KQjCBv2REP64eBTwNqzFNcKW9+2F0UKdfuLi35NloQM582mtnQVyYhTaog3t7J/C9/oBmLkCAH2v4BJYzckkjmuzSaUxITSHcR/gQtsLbn6krd/pXWUT2YndbQ5aisc2v4Ie2WYEWpPM4XtGqS3YdXPWtcX599BF8QUCW7/KzX7/OvXBf5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 16:15, Brendan Jackman wrote:
> This code uses flag equivalences to try to optimise conversion from
> GFP_ to ALLOC_ but there's no clear reason to believe it makes things
> faster. Even if it gets rid of conditional branches, it just trades them
> for a data dependency.
> 
> CPUs are pretty good at conditional branches. But, in my GCC x86 build
> it doesn't look like there are any branches anyway, the compiler found
> some conditional instruction tricks. (Caveat: This was extracted &
> annotated by Gemini AI, I did not actually read the disasm myself)
> 
> Old code:
> 
>         ae50:    8b 04 24                 mov    (%rsp),%eax           # Load gfp_mask
>         ...
>         ae5d:    41 89 c4                 mov    %eax,%r12d
>         ae64:    41 81 e4 20 08 00 00     and    $0x820,%r12d          # Mask both flags at once
>         ...
>         ae6f:    44 89 e1                 mov    %r12d,%ecx
>         ae77:    83 c9 40                 or     $0x40,%ecx            # OR with ALLOC_CPUSET (0x40)
>         ae7a:    89 4c 24 60              mov    %ecx,0x60(%rsp)       # Store to alloc_flags
> 
> New code:
> 
>   For  __GFP_HIGH  ( 0x20 ):
>   It uses the Carry Flag (via  sbb ) to conditionally add  0x20  to the base  0x40  ( ALLOC_CPUSET ) flag:
> 
>         ae63:    83 e0 20                 and    $0x20,%eax            # Test __GFP_HIGH
>         ...
>         ae6a:    83 f8 01                 cmp    $0x1,%eax             # Set carry flag if 0
>         ae6f:    45 19 e4                 sbb    %r12d,%r12d           # %r12d = (gfp & 0x20) ? 0 : -1
>         ae80:    41 83 e4 e0              and    $0xffffffe0,%r12d     # %r12d = (gfp & 0x20) ? 0 : -32
>         ae87:    41 83 c4 60              add    $0x60,%r12d           # %r12d = (gfp & 0x20) ? 0x60 : 0x40
> 
>   For  __GFP_KSWAPD_RECLAIM  ( 0x800 ):
>   It uses a conditional move ( cmov ) later in the function to set the  ALLOC_KSWAPD  ( 0x800 ) bit:
> 
>         ae72:    25 00 08 00 00           and    $0x800,%eax           # Test __GFP_KSWAPD_RECLAIM
>         ae77:    89 44 24 30              mov    %eax,0x30(%rsp)       # Store result
>         ...
>         af2c:    80 cf 08                 or     $0x8,%bh              # Set ALLOC_KSWAPD (0x800) in temp reg
>         af2f:    45 85 c9                 test   %r9d,%r9d             # Check if __GFP_KSWAPD_RECLAIM was set
>         af32:    0f 44 d8                 cmove  %eax,%ebx             # If not, revert to flags without it
> 
> Testing with a modified version[0] of lib/free_pages_test.c (adding
> printks with timing)...
> 
> [0] https://github.com/bjackman/aethelred/blob/2ccdc84ef087c2a631914f58e106e99e19bd3b98/page-alloc-test/page-alloc-test.c
> 
> Old results from a Sapphire Rapids consumer CPU:
> 
> [   67.157118] page_alloc_test: Testing with GFP_KERNEL
> [   67.157122] page_alloc_test: Starting 1,000,000 allocations...
> [   70.704446] page_alloc_test: Completed. Time: 3543002 us (Avg: 3543.00 ns per alloc+free loop)
> [   70.704456] page_alloc_test: Testing with GFP_KERNEL | __GFP_COMP
> [   70.704460] page_alloc_test: Starting 1,000,000 allocations...
> [   70.944672] page_alloc_test: Completed. Time: 239980 us (Avg: 239.98 ns per alloc+free loop)
> [   70.944675] page_alloc_test: Test completed
> 
> New results:
> 
> [   70.079015] page_alloc_test: Testing with GFP_KERNEL
> [   70.079020] page_alloc_test: Starting 1,000,000 allocations...
> [   73.669396] page_alloc_test: Completed. Time: 3586954 us (Avg: 3586.95 ns per alloc+free loop)
> [   73.669402] page_alloc_test: Testing with GFP_KERNEL | __GFP_COMP
> [   73.669405] page_alloc_test: Starting 1,000,000 allocations...
> [   73.905084] page_alloc_test: Completed. Time: 235496 us (Avg: 235.49 ns per alloc+free loop)
> [   73.905086] page_alloc_test: Test completed
> 
> Seems like a wash.
> 
> So, drop the flag value coupling here and let the compiler and CPU do
> their job. Superscalar CPUs are pretty neat after all.

True

> (Used AI for the disasm but the rest is all manual).
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks.

> ---
>  mm/page_alloc.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ee902a468c2f5..9e1949ea13a6d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4478,22 +4478,16 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
>  {
>  	unsigned int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
>  
> -	/*
> -	 * __GFP_HIGH is assumed to be the same as ALLOC_MIN_RESERVE
> -	 * and __GFP_KSWAPD_RECLAIM is assumed to be the same as ALLOC_KSWAPD
> -	 * to save two branches.
> -	 */
> -	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_MIN_RESERVE);
> -	BUILD_BUG_ON(__GFP_KSWAPD_RECLAIM != (__force gfp_t) ALLOC_KSWAPD);
> -
>  	/*
>  	 * The caller may dip into page reserves a bit more if the caller
>  	 * cannot run direct reclaim, or if the caller has realtime scheduling
>  	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
>  	 * set both ALLOC_NON_BLOCK and ALLOC_MIN_RESERVE(__GFP_HIGH).
>  	 */
> -	alloc_flags |= (__force int)
> -		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
> +	if (gfp_mask & __GFP_HIGH)
> +		alloc_flags |= ALLOC_MIN_RESERVE;
> +	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
> +		alloc_flags |= ALLOC_KSWAPD;
>  
>  	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
>  		/*
> 
> ---
> base-commit: ca2351ac6da277a470d4fcf122b53267e02b2716
> change-id: 20260612-gfp-pessimisation-b258a4bb5ebd
> 
> Best regards,


