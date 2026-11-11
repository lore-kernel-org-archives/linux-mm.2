Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D2C606A338
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iyOp41w6
Received: by kanga.kvack.org (Postfix)
	id C62C16B05BC; Wed, 11 Nov 2026 03:20:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A9C6B05BE; Wed, 11 Nov 2026 03:20:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50DA6B05BF; Wed, 11 Nov 2026 03:20:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AE276B05BC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:20:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3FB0A1401EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:20:03 +0000 (UTC)
X-FDA: 85422140286.26.90B97CC
Received: from mta1.migadu.com (out-19.mta1.migadu.com [95.215.58.19])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3D600120005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:20:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iyOp41w6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.19 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794385201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3d3b2tM519kuIvjkSRexg4H0KkdNZyWkRnjj4rZTd4=;
	b=oMd7z1F+od/5v/9k8MVW9wnssFPwJ+RpEPyF8guRsQfKlgSec6PubNzELcw7vkUS42S4cB
	QNJVjKsvsrLEHEhf4te9gD/CxaQG7FgzV87aMXoJI2A596K0eqf6f++UGU1WQP9jPoay/r
	wYbisYKRUVab7XM4TqVL5vPiOu4htsk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iyOp41w6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.19 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794385201;
	b=3Xc+5YN8wNgB/2UB0T7Y5BHBaTGzWpvt96PXm9F9JfpTW3NXkBbud/noWM3taph030tFrS
	cazLmIdvcgcaLOj3SrKmS7lsMYIng+kBgbrWtsKSzP7tKBo9ZD2t2llWKxXV+377rtP9FS
	bRltYZKgB+BKvpXVPg2gR+0jWUGgPK4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=01hkxhMvjpH0YwUfWPSVcu2PhKCcNEL9gg0Q0PcG8gI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794385199; v=1; x=1794989999;
 b=iyOp41w6ePFfiABPcVNymqvnRo7CvaC7mYHYLS9IIcdtQDFFSmovUlyn7TOR60F6UJXjYQHx
 HBdMKlOMlV0Fj9OFgH1bcGEq7R3P7yexH45CjSDoP4/BLlil+pzb4rmq/ZUZgqqgEe0v0YN/1Yc
 B25Xx13HT1EETMUH+9zTErRQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2365b7a9a39834f0;
	Wed, 11 Nov 2026 08:19:59 +0000
X-Mizu-Trace-ID: 2365b7a9a39834f0
X-Migadu-Flow: FLOW_OUT
Date: Wed, 11 Nov 2026 16:19:49 +0800
From: Hao Li <hao.li@linux.dev>
To: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	loongarch@lists.linux.dev, bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/slub: Genericize x86-specific cmpxchg16b comment
Message-ID: <avQkXxpsIdxB5Ye6@fedora>
References: <20261111011108.29311-1-yangtiezhu@loongson.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111011108.29311-1-yangtiezhu@loongson.cn>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3D600120005
X-Stat-Signature: hq3e59bt3b15fezx9q8f9qqby66rjjhi
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794385201-623826
X-HE-Meta: U2FsdGVkX18fp03FPqZb9RJsRhKXcjVGS8/yj/bEL8yuQPMDzEh+Mln7LTaw7ccii0HQLYURStnUtHlFwCwgFi41qWl+qgLGyaX8HHAD7RnDYBE8TBkBDYIym7a/UYCe3Y5SATZ66Vv4J9N1mpDwxRbOdnx6dN3pk9qMaEsew8H1DTAuSy2JnARZjnscPjpdHxiWvKGmAuH48Fhi7WlRlrMumcVv452RDFHGv164U6ndM3hZcUJxn5WA+93/gO3XWth3um7wG4n74M+jIC+/jkBWYykisBdBGVKjUP1EaTmBI17WSh4q2Zt9Mx6j3b9B8Ke7kSHHlc+DveMNeV7uJR9p7QnzH2Np0LtustUoRBoRealitvrHmUIDROAy0SjAjOR3iRJcWKlbLG7KXYa8agFn4J4WX2cEL3leXGft6CxF8Y5P+5gcNS3ZUWu1qNFkpjm8m+WETBv5v+PS8ZLTqTK1JY9WW+WEqK8wOtuEcQjMe6OIZ9PWZ032rHbgEg0aStifNd09shxW2lenkHtFmK59T4uRhdxVCX1sfDGa4gu+kmZ+H89lIYxFC/+0vp3X6n9+BzKdtRFMCJC1gMI4BU8n4PYec1INyT3k5QxxAo6RYo2Odj2FPqz7rHcMOCCz8MJE4ZUyEzCPuBgJ1LBZ7ss8VIKfStOh6HBYA1cnpKjMSjL979GHyu0sRU+MfFcyeq6oG1vHovDR69/p0Qj0oVIOuFzbthHQqsf3PtGFCoVQcygW35WFscPr8g6rrsUULvOpDvKF0Q+XmbhQHbcabjwoIAu3Qd3LmdGH+1o4lINzXS1Wuj6SwGwY8U3PHL9mWZXAnkVa3TAVPlV1Hevk7VcjYV7oIG97FSMScl75SpaDW7F5JqCXTIt5fmjRhikHUkbWbZ2f8JULcQHu0mqTHfASApfqTNFCm74Sv/640BHc4QEWjnkMNpsYGzTIEfsy9wzIf7UEp2vWFHIcnGz
 Nno6ZT8O
 jaxPV8dwjuOA0IHe6+4sv4AuLdikQ+xYlUkU/JL33o/Iz6NQF0J4sWteae4xfiO7Rk3N5ooCjBSoGaGCDIJks1fsN1/YpKCVZfE5wur5BT7GqoNRr2+a5Q5he2DAnXFVNCqdM9CV7ivftnZnajvcEpcJltZcZJ6cbOD+LUeXozWldwJwCv9lY0qcdIGXaBNGG/rylYLARxPtLD+0jn7dDVAQS7PTULgIe5FuUAd/8l6o+o27bElkYGu29L72iA2hu7hi3uj95sZLWS08ny1z+oVmo2BXH5jEbRmj8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 09:11:08AM +0800, Tiezhu Yang wrote:
> In __kmalloc_nolock_noprof(), update the comment from x86-specific
> "cmpxchg16b" to generic "double-width atomic cmpxchg".
> 
> Suggested-by: Harry Yoo <harry@kernel.org>
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
> v3:
>   - add missing Suggested-by tag for Harry
>   - use shorter commit message as requested
> 
>  mm/slub.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 45e077c7526c..090302f1daeb 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5589,8 +5589,8 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
>  	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
>  		/*
>  		 * kmalloc_nolock() is not supported on architectures that
> -		 * don't implement cmpxchg16b and thus need slab_lock()
> -		 * which could be preempted by a nmi.
> +		 * don't implement double-width atomic cmpxchg and thus need
> +		 * slab_lock() which could be preempted by a nmi.
>  		 * But debug caches don't use that and only rely on
>  		 * kmem_cache_node->list_lock, so kmalloc_nolock() can attempt
>  		 * to allocate from debug caches by
> -- 
> 2.42.0
> 

Looks good to me.

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

