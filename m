Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E57B8C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEA8B6B0096; Mon, 31 Aug 2026 05:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2656B0098; Mon, 31 Aug 2026 05:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2736B0099; Mon, 31 Aug 2026 05:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FBA66B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:46:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23CCE40417
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:46:21 +0000 (UTC)
X-FDA: 85161084162.10.3165BF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5D1C114000B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:46:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFozu4Ur;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788169579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vuRH3okFqpVfHNcse9s0fjgkHIwVRawZ8XAdlXHNyXU=;
	b=1IwxC1EnxeCc1OuK/zCO2CLM5CRPfgdxNJTnQEx2Fll/SiCpkr3zYoi6evxOV2pccXsfRO
	Qu4vtqQJPt+OUBrysO0WsZpOSYHFPVKnwrBZLmBG+2a1jJk5hE7ZQ2CI8XxC821YDmM7hV
	oQ4MepU4fyOzY88/AM77XO8QAcf6G1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788169579;
	b=8ZeRD7eU7jsmDwQXzE8pB63gh3JcivOyxcfecsMYicAd5jn49dJ0NuV1qt6/y/w5Qjgek7
	Zlv4I/HDH2RMZO7XTBqUjs6E0fpYTSL39ZaZcXPybZl93DPwQsI1G/2UltTilXfYhE8eHu
	FgS2ta0yd/kD2dx11FVsE45lA/QkCls=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFozu4Ur;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FC21418DF;
	Mon, 31 Aug 2026 09:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080281F000E9;
	Mon, 31 Aug 2026 09:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788169578;
	bh=vuRH3okFqpVfHNcse9s0fjgkHIwVRawZ8XAdlXHNyXU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DFozu4UrAiFyexHRH2zquy4w4RXQ+MiRV42rq8WA0cCgcSs4xx2BUx796mVaL7jz7
	 Zf/tsRRTywiEOadLY2ecGWn869ajFax8DqvAA3y34juABmM8Uq9b5m74QlqfBLdJLj
	 V0HzkN0xFipMX8qtvogh9ZVIy+t29ZCmRoCdkN+aVk3Y2AtfIwTsJNSZF9t0O8HLBg
	 2U3EtySpBXiFXc+Ym93wQZwCUNxI0284MSw2OJwEIgHwNOtoW19aV3tj2+WBQShWZq
	 8k9fmkhCnTn/VKcq379wojMCyK6n5A/ykUp+dRVFl5xgMY1SeMLC8Cm+67UWBWTR3U
	 Orhv7fKBUaiMA==
Message-ID: <ff5e5e0c-ec37-4e6b-bf43-59e061343f7f@kernel.org>
Date: Mon, 31 Aug 2026 11:46:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slab: reject unsupported kmalloc() sizes
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260830-limit_kmalloc_size-v2-1-bf4ca9c63c88@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260830-limit_kmalloc_size-v2-1-bf4ca9c63c88@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5D1C114000B
X-Stat-Signature: eozak3arqi1gdstjz8c1eap6b9fjcpst
X-HE-Tag: 1788169579-486929
X-HE-Meta: U2FsdGVkX1/k0GB2BWSDaD4HWKQhTvZn0npysUDbvOVUOGoJnt/ldUmC4QrMca54ck9qCVZXEUCfMi+GTDS9vtT7kL7zGyn2hywO9z/JgVuTl8RnO7+f3ngoEa7yNchJkrl2/FCbT721Hiko/nz+b/sFVGapjwpAqp9/I1+A/FP7ZbtWxCokLHfKusC+m7zSHREMr9C9/oGFbkyF/jfHcMZEFW+TRSoNmzO38+S3rjDenqnUtHdSfnW5MEZm/QM6WCIxNIRxT3f/0CjxX9A0CDwfH3HMw7ndNQUO5M0XGv9qd540nHNnqfgYzJb7z9MOuy4lUq69hW2MTC31SQRaLxdxknPUgdU7+JJEN8mPRnJRusQ+Yicl5vuF/OMeCnxhvymkTXEqPYo+1ceMGOLm7sGiTadTdqcinOk9K/cebJd5XEw/85Mf4QMK44jQazEdqJuI5HuEFYkz2yaw5Vb/5/hY4odWus+gFJ9MCi3vpf/bNYr701AIYI6hMRwz8XLH4g1wSJBiKK5hvfqzN6ZnZ2CON/HZ5Voi1D6sDu33OEpZx7CUDKkwgapbYc/r5xnEIFYjWJBjuJxx8jYvGl2r/MW/3s5OZlAWLHvXbpY1NcMTj55uYb9L+ffJfrrJLr1m6xBjdCpNWnBFSv/6YyJuX2NRcMM6nWro2DOuXtHiTYvEcKjkwRVzpuCmFe/VwI3ks+63hj6yb+uuGOgMhz/Sr7zfAhrHdG3eWM4siVsno/Z8Bv89F9PlpoL4Ee6M6BLBGql2C3Zn9kRRDIp+uuC9w17E6pUrPYLxtq0T+YQAtnCErOaTgBBf215NHw5T4Y67+E3TOTdxlndajnoTUlJFPpDWBZJ47hWAUwU2j3IPTkl2yfcPJXYtRB6IgKyDGikTCvu8miFW4mf8my8oO20zxAXTjNf7FrZ1I2gngs3wJ6+QDWkV0vE30syZotPCDTJFZbinLMpaKPOvq5h6Zap
 +WN9rlbZ
 zJ8pb8Jtr/SkWyHrevu5Uy9iza20XI91KuUHddvbbtB9BGky0Kh4PKdPScSWefjuTaGi8l4U15X4LLgGIxDsQwr5kMHQzd7tG1HIptZYWlRsADOBZm7fXVHvoIFuWNxP0K1R9G3O+hOugcBsmlw8LgrofTk15rOEvJ4sZovGdiGHlkOyDu4qtC4te0Gr27y1ZXp39bEIs4+Rbjr8kUYnVrJfoy1x9QQHg2cBhqTDdnvXWt7mLZ918/tA+nv+27jw1qRtPddWcmWVCSO+iibMjM/annqYybUhpXcb1e/kxa4nUhP9R8IR4Za+LdzBlHM78QRDjDT/7p7btIaEWwvriP4puN9X4fg6LO/Mul22HNFGU6nT4D8zJjOGtnBc/ttQCwqNQOmVi16YrZOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 04:23, Zi Yan wrote:
> kmalloc() is used to allocate physically contiguous memory for kernel
> allocations. For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc()
> uses the page allocator and can only support up to KMALLOC_MAX_SIZE. For
> request sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a
> WARN because kmalloc() allocates an order greater than MAX_PAGE_ORDER. To
> make the KMALLOC_MAX_SIZE limit more explicit instead of relying on the
> page allocator check, add a KMALLOC_MAX_SIZE check inside kmalloc() to emit
> a WARN and return NULL for requested sizes bigger than KMALLOC_MAX_SIZE.
> Like the WARN in the page allocator and kvmalloc(), allow __GFP_NOWARN to
> suppress the WARN.
> 
> Suggested-by: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Thanks, added to mm/slab.git slab/for-next

> ---
> Instead of passing requests greater than KMALLOC_MAX_SIZE to the page
> allocator, reject them early inside kmalloc().
> ---
> Changes in v2:
> 1. Rejected kmalloc() request sizes bigger than KMALLOC_MAX_SIZE by
>    emitting a WARN and returning NULL inside kmalloc(). The WARN can be
>    suppressed by __GFP_NOWARN. So the page allocator will no longer see
>    excessively large requests from kmalloc().
> - Link to v1: https://patch.msgid.link/20260817-limit_kmalloc_size-v1-1-5bef487701cc@nvidia.com
> ---
>  mm/slub.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f9b56cb439e70..23e57a8fe55b4 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5342,7 +5342,12 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
>  {
>  	struct page *page;
>  	void *ptr = NULL;
> -	unsigned int order = get_order(size);
> +	unsigned int order;
> +
> +	if (WARN_ON_ONCE_GFP(size > KMALLOC_MAX_SIZE, flags))
> +		return NULL;
> +
> +	order = get_order(size);
>  
>  	if (unlikely(flags & GFP_SLAB_BUG_MASK))
>  		flags = kmalloc_fix_flags(flags);
> 
> ---
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> change-id: 20260817-limit_kmalloc_size-3a4a2c73beac
> 
> Best regards,
> --  
> Yan, Zi
> 


