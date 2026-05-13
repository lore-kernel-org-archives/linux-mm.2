Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44E26CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7D5A6B0005; Wed, 13 May 2026 06:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2DD76B008A; Wed, 13 May 2026 06:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91BED6B008C; Wed, 13 May 2026 06:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7BEA06B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:24:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14CA8160A61
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:24:44 +0000 (UTC)
X-FDA: 84762012888.10.AD8C15A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 59B55180002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:24:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bna+1el4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778667882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmegjzJYvUzZN9hTHgSbYDCMHZW8AMx/BzoTTEOGUh8=;
	b=Gao6imTElp0bHL3bXXSP5LMW/6Nwm4mQvEn2gntkQcRWOplmswy1uA8yhtOl1yL2Vm+JqD
	BIUy/GQ3POfIifU92vAiTynd+TpxuviKcpS39La0t5bjiRBWZQsXG+ZXTpUBkUBX75J83R
	OqmYucrcfC7fYbYdzC5yfAAsLH6cE7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778667882; a=rsa-sha256;
	cv=none;
	b=qwZ7roA/5ih4deaQbZ6foUK2ohNoMRHhC4vd0vbC1NycfFoVZwEr56NICIz2utneyz+NJK
	gR/41ShSbjGVuSr0vHvHuQ0Nw8WHqUWJc+QbqXYCKF+dyxH+TqkhgH2wKQgoarNSHvPPw0
	90dh2mlR0mMc2mhpV+GvxWJeRY24bls=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bna+1el4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A36806012B;
	Wed, 13 May 2026 10:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E73C2BCFA;
	Wed, 13 May 2026 10:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778667881;
	bh=nRj/ZOMJOwQ3eYN8qoWo96aWvkfgzk6m6kyfgL1dzr4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Bna+1el4eb1zN7Scsid60/Qy5eka2UlXtxe/Z/p6OQxqIOTtR4oywr/zwj7NGxOyX
	 1z1D5jpFc6vy69NQdMbOnSeWnHW6tYC3NKlkAzPVngHwCVR6+wrTYrfiYkdok92oMI
	 NAAwVM/EGhZIy2ua7TD+RE4KiBDebnrCAUKGKqaPqWDjrMwXV6Uag1iJ92P+fozkyP
	 abmAe2T3FTbDqZOIAHQufmgJsn3C4QQMz+8m8fJ0gKoIuQ0mlRphPluMOfpoe6f+eO
	 Y8Kl2q+J8Y70xEg6kl/JPrCeTBUhMH1GIwBHsBVpgQC8vgzCNK7WFlVbzeXNG6z8Mn
	 SwZTnOu3MG5dA==
Message-ID: <1b81b2d8-d9e2-4c51-b475-785989aa81b1@kernel.org>
Date: Wed, 13 May 2026 12:24:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] tools/mm/page-types: Fix ternary operator precedence
 in sigbus handler
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260513022120.58033-1-ye.liu@linux.dev>
 <20260513022120.58033-3-ye.liu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260513022120.58033-3-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 59B55180002
X-Stat-Signature: xymb1n9nqjbtqzn5nanq3t5curbs7hdq
X-Rspam-User: 
X-HE-Tag: 1778667882-110479
X-HE-Meta: U2FsdGVkX1/LPMPzAilzeInPWvlGOc2ydRrDhfF91GcOBwUz19v5YMd+FeMD5B52o33OyIYFupagxrBFkLsUpxn/Ww8nD+cdmO9MXhB7BZ5SSS+7FrPfVsaZT8Erkr0f2tZCkzGlF3GY1JSLwLq75HDn2mThjWszCABlMxPuh2CO9cdpMeuVm1+VTOzGuyRghVbr9AfhJ05m7Mv9BYBqEc1T62oUp7BkUVChaJCqRVtqCH23Yn838aUjxARVMHlMk60fzMvrEo2EiPuyseV0I999j4hM3BeKejmFdNHKWAQc7sle/VWLWI3sjXdJ/k0zERqVUee0vmlNjODnUnHoSZvCKDUFxAxflYZUlqCkDLIzEjovHUacRiwxiZAmAlortVlCnd/RyyqVxMpzvlJqyX5EWOg/aB9vir2PLuYUYTjBicHTbiEvd8Nu2SaJ1Esh5czXeUw5JYA7/zAe3gHltSsHxdWqQurnoL1hT305a4Al4PJaBhnNMyhYkkPmDdXAXsl5SSC7NyY0+iiZ7uDpWNJuFLQByWI2I9VvPu7Bx2PGrgZ9to4cPeeB0VqN+asL/pPSFU4XfRgq/VZn7M58vR84I/GrO6uUz/H4j5WNlE/ojhcRmLiYLcnRpC5CvO9k12ZLm/ObGTiaP7V6Dy11eUfkPCCwKGOwDmeglDJR2SK6xZ8j/DrEHFoxPBAzc7GMRd03j6AWnHfCJm7EZJ1WO7QhbuJk6RgPI1CYUC2m4sonMHrUrd9zN0KYE6vGDCQi63mRBxvx4yh2oWpczBh1HMZQSqococZP9PwmwB/O2DJjSTiP0a8GiGY19VxSC86MlHawz/h5/8h/bVWbZKQA9a3nxt724pbm3yIF/c5bFngFz22Ykyc4e97asgFAsFmFAof7muvG9NXgkvyF56YYx8IMeh+nuxraiTgpW9c3hTpj2KcIekoT8O0mKTtTCgtkASD9KBKc83RH/XcUL6L
 CYTagcZH
 BFlzWASjSowKlTZp6EICw/wG6e9vECr4MauM7HfFzI2VpMLst1moByV3c26B/24wmySPdn7k/m+M1l+J1OncQOIEMoemkWWq91OMqvDDDxxQdA+jtPUVQYrXD2ot0Mc9CRUxPnU1h2rg+Lj3RQ39WtMzzFA87SEXBtNG/Rltpl4XqzJyD4ma7G+znuuH50R2x6CcN2eAd0WzTpoQLL0LjiJnILmiJwud/wmaKtOYUlRKCVg4q4XdqRhdEQ9ey1Emggre1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 04:21, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> The ternary operator (?:) has lower precedence than addition (+), so
> the expression `off + sigbus_addr ? sigbus_addr - ptr : 0` was parsed
> as `(off + sigbus_addr) ? (sigbus_addr - ptr) : 0` rather than the
> intended `off + (sigbus_addr ? sigbus_addr - ptr : 0)`. Add explicit
> parentheses to ensure the correct evaluation order.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  tools/mm/page-types.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
> index 6594245217a8..66f429f2b698 100644
> --- a/tools/mm/page-types.c
> +++ b/tools/mm/page-types.c
> @@ -1000,7 +1000,7 @@ static void walk_file_range(const char *name, int fd,
>  			fatal("madvise failed: %s", name);
>  
>  		if (sigsetjmp(sigbus_jmp, 1)) {
> -			end = off + sigbus_addr ? sigbus_addr - ptr : 0;
> +			end = off + (sigbus_addr ? sigbus_addr - ptr : 0);
>  			fprintf(stderr, "got sigbus at offset %lld: %s\n",
>  					(long long)end, name);
>  			goto got_sigbus;

"sigbus_addr - ptr" will give us the offset into the mmap(). Adding that to off
will give us the offset into the file.

No idea what happens if we don't have sigbus_addr ...

Anyhow, your change looks good, I just have no idea whether updating "end" here
is the right thing to do.

-- 
Cheers,

David

