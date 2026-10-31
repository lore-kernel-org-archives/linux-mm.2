Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11F76606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 04:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X+ZJukh0
Received: by kanga.kvack.org (Postfix)
	id ED1FB6B05B3; Sat, 31 Oct 2026 00:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E82CF6B05B4; Sat, 31 Oct 2026 00:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D99BE6B05B5; Sat, 31 Oct 2026 00:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B1F9E6B05B3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:17:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACAAD4092F
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:17:31 +0000 (UTC)
X-FDA: 85381612302.13.02EF1E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1C76A180003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:17:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X+ZJukh0;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793420250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TqGj30S1M01nBTKS0rP1dh/7dQv0SfGvxWL56l6kOw=;
	b=NIysDsGLYEB+gliVcP8246wZ4ALgfSmB7vO3Y5OQYSut5CQinXsvEGFQq88/Es6dEHjcNx
	O8/cDoBuvQpINEd6sbTtaKJp5QnIY0nQH4wBJSGRNRI9u4WkiayT9cOU8olOpYM03SBzqO
	03yYFdkynxzVpRYGqeiiXnZ+cqUfhHI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X+ZJukh0;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793420250;
	b=MeVXBSmo9+Y3w52MAMF7mx2q8OHbsrKBn6DZjL+U8Ar3kj1Skl4VP5ls4EC5SZxvHU1+gU
	K6sszcXTjkXT/wWvJRMjzzOmWFzBPs8LK9T8hIjscR2FhOuCrtJo82xyMEzvMwD8McdG+v
	HZjw3vFUd1aN9sMaal2EwVGpJS7ZTko=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 983F2600C8;
	Sat, 31 Oct 2026 04:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C01C1F000C1;
	Sat, 31 Oct 2026 04:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793420249;
	bh=8TqGj30S1M01nBTKS0rP1dh/7dQv0SfGvxWL56l6kOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X+ZJukh09k95tOFSiSKcjzf5IwhTAal9NzT7PYeaTHJoqQh5dMzFVaWuMmxRZ2PU+
	 J3iDFNpMYWaxrW/WtmmKGpNX2iBRZKH4a2/ClNtvAKMkyA99RNu2rZgdwnlt6uPmrV
	 yUtQ8BWtxmVm4pcpKzmcvo2yyl4hvzLF+W/MNur9t2urIv3NLjFwckiVHtYHEAjgF0
	 XUPXmh+KP9fQpwWzJy4Y13Mnmx7En7pc0bET9jzOcEgZ6nQfEJ1o3unw9iidX2V4xR
	 ZJBlkuLY+fyGgjCTWQjBixbzS4mJgTaMtXJA0BaY6wVAEdI1kS41JfLwsSquG9nNDt
	 Pc9fIkWhVHh4w==
Date: Fri, 30 Oct 2026 21:17:29 -0700
From: Kees Cook <kees@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 3/6] mm/slab: Support disabling SLAB_BUCKETS at boot
Message-ID: <202610302115.8C7AD110@keescook>
References: <cover.1793253633.git.chris@chrisdown.name>
 <9a68a4d95830352ad3821437c2e22c30a673055b.1793253633.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a68a4d95830352ad3821437c2e22c30a673055b.1793253633.git.chris@chrisdown.name>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1C76A180003
X-Stat-Signature: tz3spqntfwshny7f1tukqghnpbci1sjc
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793420249-461784
X-HE-Meta: U2FsdGVkX1/EE17y9I+3ChHa61Y9Mb5A0kY2UW4k+Qtm3l82PfbS1aGF+LQg0tprS34ifmsytNvBOLFOnjv3GTiJ9y4SlJWmyqU6N15q74AC83eMEq0wZbKhJ5spfog90NZGpZa1Y+NTqVIbVLYiH2EpQESrqiVQFRjWqwBZtL6thl+iTLevTBwrvvhV1IHBfsmTknMfPVQBmwk9ENw0y4DLw0FT/Z4ag+ZeM89WhvC87DX29aeS+y+IG8pcD20RfNlf7i9/5Qgrj+p+94UTfoSt3R5TA5zkdccOD5YG4Aua2CLi59tohHqnde7AfizmGBGFogfMl+tH8jC6P5IA53dLGERc92bV/gnrthtRQfBa7hv9XsWZiwePac6VjpJlfdSkOePzUp18ha2eJXLKzkezjfoypCmiQBkPGWdHywVlEjV6VTeWAxOAZC4Jp6Dbg2e17JcoIZsIk3mxYPalgVQu6wfPJd2dke4HHMYahva/OmZZLrLgmcLQNenxmTFHMERVJY1+lgC9cADCDufx3dwWTRRQdFeYeD0Tqcg11g4PlhtlM6EdbpgxMrn5pzpHdQ+1s0+NE4jeyKurocq+aJ3+mpVaDtJy8Bi7D3u9gMmWy/4ZVsH6bd1tLm+lLx0CnMHUKJHS6Ib+n8XMNO56Zwl2ZiyijSOKtSuQw8E/AZG8A3FITZDiB+KDUI+beIXEKYGozKeZ+Cv/iBsoc+X6MsqFA012X5uoXB8N0UvD9TFh+f9M/m6kbMRLoqPB+3IstTkmYz/HYJ6+4i91LJywblWmVBL03IBQ31wO0DmO8ArxDUDOLwl8MHXIPb9G38XBNvkEKS6razJVQkxR1tXP6d04I+Rjua9w23hDwaa86rSvFASjAVUVXCrFzi681TgL8dN9Yzr57bdxDWC/xZNCKanSh3F+p7ZzsBb9JK2BgGFBftJJSJiKm9noQUSUK/oaL2naXazkLNlpCdNMrfl
 zrblAGNc
 /JciD7R95T7Dh2caMcleLZrBh+qTtQtBA7hAgQBr2Rx7dKsFv3sSE9MAkuzIPq+nbXHE7f3Cu9JTTs8y5nWwKqzTOyWtCRbdIeSSa6nKzCoBRym2iCheF7UAftQhFQQfyi0+55EBgWnEfh5C4l1Hxq9NVHs/IkW8Nu6w6cme66V0aAUpx70BwapcaSkTCYRk0iK7BGm+GKEOhWIg6a13EMx/icDUnl388RVxopzB8Vx2c+KkZ/5O0S5CT6nbE6Cc2SFcMLQ8TZeMl58uJi820Li25Jupw+J8/0R4kECnjl4J0wks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 02:08:25PM +0800, Chris Down wrote:
> SLAB_BUCKETS gives allocations with user-controlled size and contents,
> like memdup_user() and msg_msg, their own set of kmalloc caches, at the
> cost of the memory for those caches. It can only be chosen at build
> time, so hosts which want it and hosts which would rather not pay for it
> need separate kernels.
> 
> Add a slab_buckets= early parameter, enabled by default on kernels built
> with CONFIG_SLAB_BUCKETS=y, so that it can be turned off at boot.

I thought the issue here was about calling convention (i.e. with
CONFIG_SLAB_BUCKETS Vlastimil had suggested making the argument lists
for the call chain shorter by dropping the bucket argument entirely).

> 
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  .../admin-guide/kernel-parameters.txt         |  8 ++++++
>  mm/Kconfig                                    |  4 +++
>  mm/slab_common.c                              | 26 +++++++++++++++----
>  3 files changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 68647ff4bdd2..de2fd6963a16 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -7001,6 +7001,14 @@ Kernel parameters
>  			apic=verbose is specified.
>  			Example: apic=debug show_lapic=all
>  
> +	slab_buckets= [MM,EARLY]
> +			Format: <bool>
> +			Enable or disable separate kmalloc buckets on kernels
> +			built with CONFIG_SLAB_BUCKETS=y. When disabled,
> +			allocations use regular kmalloc caches. Ignored
> +			without that option.
> +			Default: on.
> +
>  	slab_debug[=options[,slabs][;[options[,slabs]]...]]	[MM]
>  			Enabling slab_debug allows one to determine the
>  			culprit if slab objects become corrupted. Enabling
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 92ff97ff24fb..48078c1fd26f 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -231,6 +231,10 @@ config SLAB_BUCKETS
>  	  of extra pages since the bulk of user-controlled allocations
>  	  are relatively long-lived.
>  
> +	  The separate buckets can be disabled at boot with the
> +	  "slab_buckets=0" kernel parameter, in which case these
> +	  allocations use the regular kmalloc caches.
> +
>  	  If unsure, say Y.
>  
>  config SLUB_STATS
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index e66c0778ee98..b7a46c368ab1 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -410,6 +410,16 @@ EXPORT_SYMBOL(__kmem_cache_create_args);
>  
>  static struct kmem_cache *kmem_buckets_cache __ro_after_init;
>  
> +static bool slab_buckets_enabled __ro_after_init = IS_ENABLED(CONFIG_SLAB_BUCKETS);
> +
> +#ifdef CONFIG_SLAB_BUCKETS
> +static int __init setup_slab_buckets(char *str)
> +{
> +	return kstrtobool(str, &slab_buckets_enabled);
> +}
> +early_param("slab_buckets", setup_slab_buckets);
> +#endif
> +
>  /**
>   * kmem_buckets_create - Create a set of caches that handle dynamic sized
>   *			 allocations via kmem_buckets_alloc()
> @@ -424,10 +434,12 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
>   *
>   * Context: Cannot be called within an interrupt, but can be interrupted.
>   *
> - * Return: a pointer to the cache on success, NULL on failure. When
> - * CONFIG_SLAB_BUCKETS is not enabled, ZERO_SIZE_PTR is returned, and
> - * subsequent calls to kmem_buckets_alloc() will fall back to kmalloc().
> - * (i.e. callers only need to check for NULL on failure.)
> + * Return: a pointer to the cache on success, NULL on failure or when the
> + * separate buckets were disabled with the "slab_buckets=0" boot parameter.
> + * When CONFIG_SLAB_BUCKETS is not enabled, ZERO_SIZE_PTR is returned. In all
> + * of these cases subsequent calls to kmem_buckets_alloc() with the returned
> + * value fall back to kmalloc(), so callers that can live without separate
> + * buckets do not need to check the return value.
>   */
>  kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
>  				  unsigned int useroffset,
> @@ -448,6 +460,10 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
>  	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
>  		return ZERO_SIZE_PTR;
>  
> +	/* NULL makes kmalloc_slab() use the regular kmalloc caches. */
> +	if (!slab_buckets_enabled)
> +		return NULL;

Regardless, I still prefer this being a static branch so we don't end
up with a needless rodata global check.

> +
>  	if (WARN_ON(!kmem_buckets_cache))
>  		return NULL;
>  
> @@ -1059,7 +1075,7 @@ void __init create_kmalloc_caches(void)
>  	/* Kmalloc array is now usable */
>  	slab_state = UP;
>  
> -	if (IS_ENABLED(CONFIG_SLAB_BUCKETS))
> +	if (IS_ENABLED(CONFIG_SLAB_BUCKETS) && slab_buckets_enabled)
>  		kmem_buckets_cache = kmem_cache_create("kmalloc_buckets",
>  						       sizeof(kmem_buckets),
>  						       0, SLAB_NO_MERGE, NULL);
> -- 
> 2.54.0
> 

-- 
Kees Cook

