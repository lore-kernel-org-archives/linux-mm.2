Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ADC1CAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 04:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7E9B8E0005; Sat,  4 Oct 2025 00:37:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56D68E0002; Sat,  4 Oct 2025 00:37:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93658E0005; Sat,  4 Oct 2025 00:37:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7A1A8E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 00:37:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DB40455E6
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 04:37:24 +0000 (UTC)
X-FDA: 83959172808.06.479BA9D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6490140005
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 04:37:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TeDOSUoF;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759552642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u0XiqxfOq9vlqMHc1NeoH/5IygmQCzOyK8BHyyYUppI=;
	b=FRNd7ppj5dNRtWfoVSIDfDdin4T3o5mdXuwnUgTz5iphldLdsBBcH8o79+56VEm06q+889
	s+zk41TIe1UK5BtXQdikq1rVfU3ecRhk/7pqsmgaG9seo/SuecKobcv8yd27WZyu4JEm2W
	kbMB8fmaRI/sqbrUB1GHskNoT5OVz2Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759552642; a=rsa-sha256;
	cv=none;
	b=tOxg3oLZyBGwt+GEJZcyylLSVy+4tYZUFKWjROFXrBiNZeyEMegfD4Hs7Y5fjaC/asJF+p
	xsiTL+11xw9PAmmwo8mbj3G++nob4P/09u7YGcIzJbq8bM0clKT2NaMjqnwe5VWHI2uAHx
	NxDryhw+q+TK/MkxmF3QQ59N11Yi6ag=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TeDOSUoF;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759552641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u0XiqxfOq9vlqMHc1NeoH/5IygmQCzOyK8BHyyYUppI=;
	b=TeDOSUoFti5IJ4KVLgvicpMLCA/3ohpEXWxuBwIXa8rKR3dQO56/b/ShfwQnoFjDiP9q0+
	oEJ5++Sx413nc7oSOhT3NXz+awA4QMoqkNi+ZeYkbsB8ZVBX9fnJQ6r/HBSmzsppk1aP29
	9jsPMrwuABP4Vyb20MXCdz2InzkcG18=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-MPe9zfsJM5KkIdarp91mbw-1; Sat,
 04 Oct 2025 00:37:13 -0400
X-MC-Unique: MPe9zfsJM5KkIdarp91mbw-1
X-Mimecast-MFC-AGG-ID: MPe9zfsJM5KkIdarp91mbw_1759552632
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A3D51800452;
	Sat,  4 Oct 2025 04:37:12 +0000 (UTC)
Received: from localhost (unknown [10.72.112.27])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E62A19560AB;
	Sat,  4 Oct 2025 04:37:11 +0000 (UTC)
Date: Sat, 4 Oct 2025 12:37:07 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 10/10] mm: kvmalloc: Add non-blocking support for
 vmalloc
Message-ID: <aOCkc27YVRVa8PBW@MiWiFi-R3L-srv>
References: <20251001192647.195204-1-urezki@gmail.com>
 <20251001192647.195204-11-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001192647.195204-11-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: wn6jm7fufwcjyyg6r9syknndxu3rgwci
X-Rspam-User: 
X-Rspamd-Queue-Id: 6490140005
X-Rspamd-Server: rspam10
X-HE-Tag: 1759552642-235755
X-HE-Meta: U2FsdGVkX19hNGGV6WY+qLO1iNHpiMGQe4p2rnPmbDgOp6NznqAiPNKlCbBS2i7hNG58Ue1nzMKEJx2Z5ZwF6mmK3qBi6LOJxMK0bYvJXb4HwSsPqdSfL/sTPT9TN6nQZ9tJEEwBR9GGwg5zyl5CpqXqrn9PcW0DaHz99kb00bIuU9M5u1AkRxmxKzn+6SP6C+GcJmeoVKKMwU/RA+4e70bwPru4rHdGgz+Nqzhk+rlfkzWsaC1MP5s+6NLt2qYSyaFn2XYAD/4LpbwcTWylcqm3OVB1/yg6hcdcSHMwBQpAwOcZJeInwH6b+BdyYHKdd0ItR3nDYMwpzn4WJZ+YLzUtw/kNMQKjvZVx3pQAElzJ7ebQCva+Qmi7gr2Ac9uvD4sk8/I+FPFjQajtiqkGc3BQY0JgUBfAmqApKYiYreez6aRrOhj4+AvGQOChckysoTjlEaA7ivvn+pf9yLiznVBJuuHpSHDikGWMcGbwb+dE4GqmNX0Q6+jlUdQmgYQTVw6VcYZKR2XAxQaj2wbMG32AV3SG8C96Wl6MXNeMDIjK65fa+Ksjita0kRm4glH00qx6VTMtdCflmJyHE9Ut2jDAiEfUSyUZfq14gMcxUwqxd2qtqpx/vBAmCZn647U3n+yTJSYxUWmOi5qU/o6XkaWmQn8+nY768Cg/6qwsDhrhb6PDh85IWChmFRL2WOXCNJxsG6svEk8R7z+9hot8CU8c4wLWCUbXnuYPWnILGMEbH7h2NkYVQYTSUbdvpWrDBkaRL2iyR4ihJIK1laTJexDh/rpMbyOlV/IDuHCV8HXOtfKROGLMhiRDsTmXhHhX7O5h73fk8GhHV7JGNRCvH2l1d86p0fiS+ZEmk+SBtcgG7XIUwOuGwPItP3QfPm2tkYjOeG/Bt2XbT3g9s+PyU3fH+73rf3QM55IeMrz45dK2AzQYO34g/8Uv3sKB10ZyZ/blFEYupCL/YRWP9aF
 yolmmG5M
 VGM2f4mQe18jBLATxDqVKc1/94P9u3vN9yZIiMja/RAJAxLuNqeodfsFORM2x1LUNR6OI9d//2DSdEqz8vsDJyOksjiQq0Ek0KQjFDknpietm9URup3vG9niP/zOcMiIbhRJ8tWdG/UDM60YUaOR6apFY+ROw/RJor2d3aLeYWYnoTds/Yc8q5otxWAgjehTmxb/VLwLUUwzjNfwSlC6FXNmdeogtgQXZ63uW7JYLSm566XN6PpXJ+jqrdABHk4feOnCh7qTAp3J8WUq0MMI7NdCVOAuezDY5FRpGGrVYMIATdqvz9owPkL5wqIGBljpTzgZjSIzzxbCT1Z2nUgZBV8iJjkwbGzD9Iuc0VL+l9cGRi/sCA3yRlPBphZenTcKDQzm2M36JGbf5mKG/naZWPnSN10GqVImTBQzqg588xj9Oy4yqlD9lUYtgyg390Uup8VIH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/01/25 at 09:26pm, Uladzislau Rezki (Sony) wrote:
> Extend __kvmalloc_node_noprof() to handle non-blocking GFP flags
> (GFP_NOWAIT and GFP_ATOMIC). Previously such flags were rejected,
> returning NULL. With this change:
> 
> - kvmalloc() can fall back to vmalloc() if non-blocking contexts;
> - for non-blocking allocations the VM_ALLOW_HUGE_VMAP option is
>   disabled, since the huge mapping path still contains might_sleep();
> - documentation update to reflect that GFP_NOWAIT and GFP_ATOMIC
>   are now supported.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/slub.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 584a5ff1828b..3de0719e24e9 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7018,7 +7018,7 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
>   * Uses kmalloc to get the memory but if the allocation fails then falls back
>   * to the vmalloc allocator. Use kvfree for freeing the memory.
>   *
> - * GFP_NOWAIT and GFP_ATOMIC are not supported, neither is the __GFP_NORETRY modifier.
> + * GFP_NOWAIT and GFP_ATOMIC are supported, the __GFP_NORETRY modifier is not.
>   * __GFP_RETRY_MAYFAIL is supported, and it should be used only if kmalloc is
>   * preferable to the vmalloc fallback, due to visible performance drawbacks.
>   *
> @@ -7027,6 +7027,7 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
>  void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
>  			     gfp_t flags, int node)
>  {
> +	bool allow_block;
>  	void *ret;
>  
>  	/*
> @@ -7039,16 +7040,22 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
>  	if (ret || size <= PAGE_SIZE)
>  		return ret;
>  
> -	/* non-sleeping allocations are not supported by vmalloc */
> -	if (!gfpflags_allow_blocking(flags))
> -		return NULL;
> -
>  	/* Don't even allow crazy sizes */
>  	if (unlikely(size > INT_MAX)) {
>  		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
>  		return NULL;
>  	}
>  
> +	/*
> +	 * For non-blocking the VM_ALLOW_HUGE_VMAP is not used
> +	 * because the huge-mapping path in vmalloc contains at
> +	 * least one might_sleep() call.
> +	 *
> +	 * TODO: Revise huge-mapping path to support non-blocking
> +	 * flags.
> +	 */
> +	allow_block = gfpflags_allow_blocking(flags);
> +
>  	/*
>  	 * kvmalloc() can always use VM_ALLOW_HUGE_VMAP,
>  	 * since the callers already cannot assume anything
> @@ -7056,7 +7063,7 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
>  	 * protection games.
>  	 */
>  	return __vmalloc_node_range_noprof(size, align, VMALLOC_START, VMALLOC_END,
> -			flags, PAGE_KERNEL, VM_ALLOW_HUGE_VMAP,
> +			flags, PAGE_KERNEL, allow_block ? VM_ALLOW_HUGE_VMAP:0,
>  			node, __builtin_return_address(0));
>  }
>  EXPORT_SYMBOL(__kvmalloc_node_noprof);
> -- 
> 2.47.3
> 


