Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 305F4CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B026B0005; Fri, 12 Jun 2026 12:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C816B0088; Fri, 12 Jun 2026 12:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6318D6B008C; Fri, 12 Jun 2026 12:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 568A16B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:04:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B237C163A22
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:04:53 +0000 (UTC)
X-FDA: 84871734066.19.3256C2B
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id CF9094000F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:04:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RqCKZKOE;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.167.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781280291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhTsWnt1ltZwTIfMb0wntlq3uSFMtI1YmVFNWpYqAW8=;
	b=SQTBC8MiwbPS9K4IiLTrAjsbFkkLQCOVkUY7jJDOdNnMWQFHZqUY88LhQmj4ydt1qtDkKR
	ZdL/2P/A2zWfmJWeoplzJoBvzw1Y+2YGVqHliraKtcG9iKc3H84rMaJio5J6pTUOYR1fHN
	u7AkkI/r8viwVegX2v1y7YaB10kzSKc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RqCKZKOE;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.167.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781280291;
	b=0cexl6/s2DPEQy4RuFjrQl4OVn8O6T6idg7PjhY6YGJ7Y9aVS+L7cTmlDYe4rCXrJWKq78
	dbPx+I0UHew9m+wzK60ivHglgd1tmvWRnRYvBnR3i+lfjM7VUgWPjAge7eVi/5s4S7Rkff
	C8YPkWNsXzmPwgmZQ3tU7dHQUvJDQdw=
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-486b93fc7c8so543095b6e.3
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781280291; x=1781885091; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WhTsWnt1ltZwTIfMb0wntlq3uSFMtI1YmVFNWpYqAW8=;
        b=RqCKZKOE8fJmIMq9pDyvjPlznwaEOy6VNXt4UC1MzJQeA5/HvxKrJ67lTk5/y2E4mX
         wI+aR01Nnsgs9T8KGrOhywjETTAkOci0dNFyKt3f4sLWmlb7MUyRM4pj1QgToajKfQsu
         hmluA3nrHsKbLNj2/VTEr1dKfFwgoZfiCU18UI32D5qp0gKP+v5g8bpOIRhkaWQE8xNL
         eamA/nwdG/duIpX11RxCz0QyOUQjv+SUvoU9w4eH13r84PpD3d7DJGk0CWLwodiyBCAw
         tQ+zLUxfxEmjPskgpdBrInnOZpgAKrUTy/0MnHglrPbfKoMtC5ZSxNOwAGhi2c5KjrCT
         Mncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781280291; x=1781885091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WhTsWnt1ltZwTIfMb0wntlq3uSFMtI1YmVFNWpYqAW8=;
        b=fQMXeGmWyfOwpiYB6A8t7K4gr6RqaDVKBm8Ho+x4ITNEiWpjPofoh7nY0S6UB9e/U5
         2/fHq6xBLn8WzhSKCykuSPI4PqJaCrPtCInVx5dfKdg7s1YScqRqvFP/ZRgSlvlSPvi3
         1hK9lw3lL0Ioyr9a0Lx0OXDJ6vYgh13XHA53NvI8Dp4LFODKG2L4C8sa586axdkbg4ny
         dPEdu2XVtO/xWbMCV3cApV+kUUiv4Y0SYN4hOfN8tQDT0kFhlglnuaJzdMisQVtkWM/R
         3D25GuBSZCtpIC5jvPpoYY8ssprYOgAzyto2rmk/EJZlIiYiBVgMldXFGOOc5mvjVi9N
         i8wg==
X-Forwarded-Encrypted: i=1; AFNElJ8YhcD6rSvqA1Kg1bRFCVIJzOFnrRSLPGSm4ixWaUr86EFzdN3zHO8bIWFnXjtHQ25lAizBgzoFdA==@kvack.org
X-Gm-Message-State: AOJu0YxqQS+JuUI3onljbqaHbIQ8GP5i14Hbqa33Y7yBhjafKWvf4eox
	Dz1gjtSChdLCiV0PYa3p/zfisWdpM3FWbGv4svim7N+B53LAX9BW37cXDm+3fXl9BBE=
X-Gm-Gg: Acq92OEO5dvWKe5xTS/kk8FxxKmujHt4oydrVzo1zVS5+6MkhVqTqMjWDhM8j7t5uWC
	5jEAEBHesmiXYkzQLVOmqem3Iurw5S4m/jvlmNZO2pbOtn49Bfp+S9AMYd41ms8CjhldPGAukI3
	j3Ng5z1+WYSwdxElED2bIew5fod9iY/iIkQwa2mpR5ZxVRWeQuo5qwFCITnacsnyeM7q0np37O/
	V8Q8OtpI3GVp8+jlPFWMq4swLLIefjgvxT635u8ztfEknS80u7MpenzI1Iu8nfzNKZ4CyDzGaf3
	zVbklMwTuv4psgillDaw3xquzA3rWX1ImBZlLgvYnyLxXILsPTN4k+OOegZUdXgN4gRfWZtqINr
	n+EUzDCEWOl0h662wB6pF4BFtRfRYm5uyJ8fxpIjgGNbizKPsjjQulXgejI2fbm6yQOBpZ6p2jD
	jXo4Sz/ym4fI/txO/JBLjb/GfnsI3tteRq1znF50tEYeGrAb9g8LpLl/G9DAUxktFISj2viPkop
	owSqas=
X-Received: by 2002:a05:6808:c192:b0:47b:c8d0:512e with SMTP id 5614622812f47-48741b24246mr195066b6e.34.1781280290644;
        Fri, 12 Jun 2026 09:04:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb61d948sm24363771cf.1.2026.06.12.09.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 09:04:49 -0700 (PDT)
Date: Fri, 12 Jun 2026 12:04:48 -0400
From: Gregory Price <gourry@gourry.net>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: drop flag-conversion "optimisation"
Message-ID: <aiwuIINhEA_adaf-@gourry-fedora-PF4VCD3F>
References: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CF9094000F
X-Stat-Signature: 5nhwqp91ngu65fg4c66pxp8rnk7n4ay3
X-Rspam-User: 
X-HE-Tag: 1781280291-242299
X-HE-Meta: U2FsdGVkX19rYaqSsj2wr+UlJ6o9AZu4AXniup5NfKa+/MvkAGKvCEnjRFfftnJR5dZuABrGEpgGpE3xth1baIy4dq8Q3j/343dxbEr4IEMpmHRtzi5Ml5nqHxvkEaiB0VftBJXRWMjGkMs1evE+GLr7D/CbjYJ4/V3fyTmD26x1lyXFOj99SEE8NPmue43xhTZfqK5AAyppl8SbQLAyrq059OGkuZUvbY7xX6nlfoDzOJK2YejZI/8lR+MP3G1lM0RE/x1XdV35GaeaNNJb5x/Oad6/WyZzfD91v7G23M0IPFi2WT4NI+t3iq+X7wL7CMX38diWaKsdMPFF/isupA83F5HBUVUharZIrw5UHSwUlA/ffM9gQ/FR66hTux7uTY1T8YzZ0acXToW2EkzAhHmLfLyQAsD6L2qP+GZGWbMP5yznKmpG8TIFZyNw1xQQsqEDqIR4pn3H050bHS4kKFjp/qnqJRHg87ZID8LyeTOXLck37/qwfgJb9oboBU6RjziE/+vsn0O8amoO27A7fv97DBczRHT5U3E/TatW2Bm6a1mPdZE1mQaTNg6+QzxDfuVCVOrfg3DwEM6Q653xeiYttdneDqutC9emSgr1xSdNOr5cGqFz1fIofIpCg62kHo3KN/sOVkuLRCnuMlkS7yTMogd76B80pNiDC/0gf3sTJYZK5LShCULd6tZpYlX9iokj0fKSO1kfRp0wZHhvjIz1+oo05r8gLE6xGS8ElgqPMou88h4whoL8yNo8bHxfZkmsOZx+/CVl/aUg14kdduwC6fq3TTko5X5JB/2+JHh8YGqyhOX1OfkzRmNTNd9V3v3iS4zuwp0PpA/cLxFwh3eIem6guZ5hHb6bvqUkgdPJ+elVsspg8bxcL9/OjUffQvHVixjZSSFaRDWizH1FX8iSL1mur1C5mk3pzD0c6Gw5KdYIZt7U4X9LegQqUILlqxMTDt6qjIuUZDMDiw5
 nE6pZQE8
 oeVoxQ3/nS7zw41scbRMyQ0OKTX8gpmPJxCnkuLQHyIaDl7fWmqksxNKvi6JpVymUgDNPtecnEB+uduOYlX77qAhEJsHEBQYUZYaJU8kc8MdtblwH/Ung6wUj186ZlPGUIAP9fWZFblzuJaRpmJ0oKtByWXlPNB4QcLyZOJQuCoadcsyT5IbkaVFe6wyjve7VLClZumQkUR3y/tNhAQV09JnA0NX87r3zSrMK179H7gkqEJAY1sSrzTGq5a/+/VG6Nk6vjDShuCWOQ8sP/VORbe/mfF4OlQ9Hv2Zk5lMzzSoUxEsxjq1j+VWnmMYmfdmyKW9DAOmRL5LAk2bZ7LsZ/Opt+O+VH9W84luM9e3VyOAtuIkWdagBb5VJfaa0yNqz/19kLASO7jVQhs8Gwha2tyd+nNcBdDaKkm+8Sb5clvxy0Dn0rqx+mhU263NyhohcpoEJowD4LZqydks0prhNdCJxyHb2m+uiXl+l4lAUSRpPI55PsNTNHb3HXxmu5IrI9SAQu9aw0qM1fOA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 02:15:44PM +0000, Brendan Jackman wrote:
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
> 
> (Used AI for the disasm but the rest is all manual).
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Love me some readability improvements and code reduction :]

Reviewed-by: Gregory Price <gourry@gourry.net>

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
> -- 
> Brendan Jackman <jackmanb@google.com>
> 

