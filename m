Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76F69606B353
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C4gedXQ7
Received: by kanga.kvack.org (Postfix)
	id 776D86B05CE; Fri, 13 Nov 2026 03:48:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726B26B05CF; Fri, 13 Nov 2026 03:48:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63EAA6B05D6; Fri, 13 Nov 2026 03:48:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC766B05CE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:48:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2C8E4013E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:48:07 +0000 (UTC)
X-FDA: 85429468614.19.587DDA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 048AA80003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:48:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4gedXQ7;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WUk9FinFc009HUamqKcrxr6huw6b41fEG0JGHs5yi3k=;
	b=m74rRkPR006gWNvPMdq27kD6XFxy9nxeEX0u/cnYqeqDPwYO00CsF9Sxfxx5XFYK3zOQZq
	NIm8ks2ve6hc8ppPirDOcuHzMvL/tZWHPfHc4dvSglYBOsuHe3fzE2xBn2FaCaAtQyFV4+
	QZhG4mz+S1mtHsrhh5osXUVzD09hs0c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559686;
	b=EdkR8IY27i7GgRzqzgmOfPWq1nKNilUeKQU1StD7UOjt1XmrWq37jr67Be8DVg8+wPgWDn
	hkgcWtagEVEfjFvS8SvDden6tU4s+ZSlHVubZ6v2sYDIy1uufyWuipnqioUI7G4sIZO4Xa
	YhdHP4Hqpx7Z1IPyRytrtBARIQ1l21A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4gedXQ7;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FC6A40A74;
	Fri, 13 Nov 2026 08:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E6D1F000C4;
	Fri, 13 Nov 2026 08:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794559684;
	bh=WUk9FinFc009HUamqKcrxr6huw6b41fEG0JGHs5yi3k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C4gedXQ7XDhmHXH9HZz7kP9n7VQp/iOs8L8VQ6qfvTuIungInhOiTMzhlR6NEr6f5
	 etU6IHCgGIzC6MsTM//0BAQQucZWw1eRfviF6oNZhvqLjzItMYkjaGIsCNTdsBE9QT
	 2DzK4LkfsjJBaitOetjMb6wRpwAZz9zx3TGBPAXCgVDcvMCzjWgG4LY91h7Df35lCx
	 YJQljYpqeShiQfGEBdQvJa+8zIHRKtEvIv9VisNeXkdWqpM4eUwwBgE3ML2GQnkfb1
	 yJhaNxbmtwT3MjcPXmxh6IebgqvQwtBr+CySca9msZ73esj47OpIp438hk9+q7uyGC
	 FSHqGhxGAME4g==
Message-ID: <ab518ee3-ba4e-4c36-afeb-5943a3192ea7@kernel.org>
Date: Fri, 13 Nov 2026 09:48:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: page_alloc: add nid to mm_page_alloc tracepoint
To: Ye Bin <yebin@huaweicloud.com>, harry@kernel.org, hao.li@linux.dev,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org
Cc: yebin10@huawei.com
References: <20261113062007.95040-1-yebin@huaweicloud.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261113062007.95040-1-yebin@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 5m8q75rm4dsacxhfqtdnaa4z1yctkdr9
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 048AA80003
X-Rspam-User: 
X-HE-Tag: 1794559685-544448
X-HE-Meta: U2FsdGVkX1+KLmvBrHriGp4bMQHrieEY+G2RvH43a6/8zWTy8LKs14Gwtq4hHNAfj1oMHIUQpXv6/8cueVmNTY/YwlluwbeccVbhs8cQdu+vjrQ34rjqEXww2MzmEOiVFv1PdM9fHJoz3yMe3V2l0qN+MEBu+QSDCq06T6tMSpi9OWEW5IQaPVWKY+J+l1Dsb+1sfDM6S3O+d+CXSKTj83WoeBukiFtXHZ2gKbI6r4XwspUptlALds/6yL9aO4k/6k+Xz9D6WI+j2f4l5CkR4QZ05qAPaBLJ5B5TPxEdJvbKAE2Dl52yIClh1kQLVygcZWy5mj/FdwFx81u7s1ildnPsvaZqwIa7BxlqAIVlvRuvIMk8nr4WD3PRbRB+yYJEIQDABZfWdHsVUH58byrYrqTPu0LDt+6gE5qwhNbUj/UqWJdNcvzMTtYeSDeYmKoxc1JSk0Bb1UMbeC2TuA2xbU1V7rgyb+vMn+HQ7pkrNuQY2kEL6o6G0X+EYhJxjG8Yagm7a1Q55VEYbm/Xgz9rQJJwYwjL31bjn2+fictJEyJlZ8u2POUtVCsX0lvdzu6Gu9OuBvut4GKjd8EwRDmaoklUufUQ9rPDQRrbpGKVO7GO7LGrMCtwmLe6vN2pHCEqISOr+PdoHAYv5EROZrNqIm5IGi2Uo5FE1z8Cj+5kvKwo8z9q96ZQjMJcsify9hUNcYUjKuZeXtNXebyE9l34NCr/4PPzrts3viZllozns1XaDh4Wpl0QEEQkF7Dc1NcnrcfIq8eQnCGLi6CUBATtbvE8Nfhv/8zifdzjlXsmciEnej6j7FA0YvvhlnSjT5F9+mHwD62BMgQQHN6Wr7Sagx8wxHFoEG7nvJx8OCKwjIK2tJiaEZzwxkuga7j8fp12pYTDOyoheZXGEbhl0uBeYY69HjAriXK7gMB9Tn2hMLa7biTNhFuo7OdcwGuY4Gox0U75p6C7ck+YxLhz3y+
 r9uIMRyZ
 u7XfMYXPvAkUxN4iYQV4+osrTKhxnhaxGDVeQ+EsGdzD76cmWBbOR19M6cCaQwgGT8cI0dwDN06eDoMlOdI4VPt1Cs35/IznurUsQgI7WTIRETX9EOc0yfICzMqgRxiBJwTUkJSCs59JTFEh+YCELKFD4elxyAQMs/hU2iG0YKXJm4YhMO+EpyrqjyFn+aDks4t3DVK3Fv0/GCGOOBQtWCEmCK5NQVjkUhDFMhgeg2wCxM1fBSZb+mCEh0z0xUPCbLH/3RZmCBhoVgl+0Ubf37aQeRkZcBJNajv2pprP9XmwbeEJK13xQPanlYglGwA3IWMuWPqjkYbRqBpQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 07:20, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> Add the NUMA node id to the mm_page_alloc trace event so that page
> allocations can be attributed to a specific node directly from the
> trace, without having to look up the pfn separately.

But is it the right tradeoff? Trace data should be as minimal as possible
for cpu and memory purposes. Anything extra that can be achieved by
postprocessing is better done that way. Matching pfn to node using
/proc/zoneinfo is simple.

> The nid is derived from the allocated page, or set to -1 when no page
> is available (e.g. failed allocations).
> 
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  include/trace/events/kmem.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
> index cd7920c81f85..8bf4e992d8bb 100644
> --- a/include/trace/events/kmem.h
> +++ b/include/trace/events/kmem.h
> @@ -189,6 +189,7 @@ TRACE_EVENT(mm_page_alloc,
>  		__field(	unsigned int,	order		)
>  		__field(	unsigned long,	gfp_flags	)
>  		__field(	int,		migratetype	)
> +		__field(	int,		nid		)
>  	),
>  
>  	TP_fast_assign(
> @@ -196,13 +197,15 @@ TRACE_EVENT(mm_page_alloc,
>  		__entry->order		= order;
>  		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
>  		__entry->migratetype	= migratetype;
> +		__entry->nid		= page ? page_to_nid(page) : -1;
>  	),
>  
> -	TP_printk("page=%p pfn=0x%lx order=%d migratetype=%d gfp_flags=%s",
> +	TP_printk("page=%p pfn=0x%lx order=%d migratetype=%d nid=%d gfp_flags=%s",
>  		__entry->pfn != -1UL ? pfn_to_page(__entry->pfn) : NULL,
>  		__entry->pfn != -1UL ? __entry->pfn : 0,
>  		__entry->order,
>  		__entry->migratetype,
> +		__entry->nid,
>  		show_gfp_flags(__entry->gfp_flags))
>  );
>  


