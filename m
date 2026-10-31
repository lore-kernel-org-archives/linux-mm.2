Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E28CE606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 04:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YYb7BKxt
Received: by kanga.kvack.org (Postfix)
	id F34046B00EF; Sat, 31 Oct 2026 00:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBDDB6B05B1; Sat, 31 Oct 2026 00:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89296B05B2; Sat, 31 Oct 2026 00:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3B636B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:28:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 109648061D
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:28:34 +0000 (UTC)
X-FDA: 85381640148.23.7C64244
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 62F1040006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:28:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYb7BKxt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793420912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nPI7+m7xqukMbqrFFt+ctdQhrHqe+UHCY/7XpSE1aQU=;
	b=SCf59m2XT3YjTGM3cXZq7R3AIrkoIdC12uCIErRpZyf4j6cW2ZhuwZS+Kv8IMS0Ve/Dalh
	rwRIzqxWcaDVaS1Rm5yDZawJkDcy47P9eZVDMXDD6Bx7qGSIxSFv33RppqhRB94tfx5dSH
	uqdPVJgW9+J6aBvauRT6rBcG03qDe1w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYb7BKxt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793420912;
	b=Xn/dK3C1HFly0maozGxXcGobMt6QRzk0L6HHxmRVtT3MVVPbcseFM/lpiHSvVtQq6S7fnB
	4rBSBeqjrHIP3u72tu+LNEoC8NE4oZBwsjVyszMta7VJ7YmZvqNGFgiVeQSG6TsIB9A2fG
	qwkBu9/kRcdzlkneXUz3HQ4OybofykQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59EDB4378D;
	Sat, 31 Oct 2026 04:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389E31F000C1;
	Sat, 31 Oct 2026 04:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793420911;
	bh=nPI7+m7xqukMbqrFFt+ctdQhrHqe+UHCY/7XpSE1aQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YYb7BKxtbnvtVVP17CkQSB9ZHp+q7J5pQnsntezGl3/r67S0/g58i2DSZyhH4Vcc+
	 8zHUeXXiqXoaogxItyNX3VmIJffBG+2qwMRxX2b5gZaoe2R7eNUsxLwWct4M1pJcU3
	 u8AEKYNCE2vXGX+8ZOkVT0kczwGR4QPYYo7obUvEOlacUL/7pt1CHJN9Rf33ojM1lH
	 u8qBgs0DngHLJeIYCVYXuLPpu7MhtfZnlcUgoTvsFbNMrfzEq38fzrF9PgtKONtCac
	 MNHhdYS9I/TKZIF/Sm8OemJe2Ne5yyAvMh2f3JkX+q9FBkzPgyONJZIykuMTDNEBPC
	 OZadJGLN+hLEw==
Date: Fri, 30 Oct 2026 21:28:30 -0700
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
Subject: Re: [PATCH v2 5/6] mm/slab: Support disabling
 KMALLOC_PARTITION_CACHES at boot
Message-ID: <202610302123.687A961@keescook>
References: <cover.1793253633.git.chris@chrisdown.name>
 <617bbfdce4fb2689c2510f0cd7f9adbb3ab8edfa.1793253633.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <617bbfdce4fb2689c2510f0cd7f9adbb3ab8edfa.1793253633.git.chris@chrisdown.name>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 62F1040006
X-Stat-Signature: uajmox7zz3fyujsraknjgs8tnkiusejx
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793420912-98431
X-HE-Meta: U2FsdGVkX18ULHWPvyOTEcNzLZJ+wVqBTIBF3ylHVsGrETKqsle0SpcqKjao0Lf6FU43hs8TdFgjsyr42hyF9NlX25pPpAl9lZp9CVXNNwyYH2WzKafi01K52ETrn6rg1CSZprIMFocREgsKVb9NNAXj8HdyOsCsSxKqR9/z0vKgCBqIZb9hDFbZkv5jUCV1lBpKYdKoBzo+ve+ldNjuHIaZuW47NzEwpaB60m/eXFu9ZUEuSvBeYygCzjp6COnXjg6rm119e5iWsGHrgNzjlzN8Q7xW670VkOdn+c+WhNZY71yYz14aTlRTw0QbyYBGU/2FBhHk/TYiBiyRFZ4weaHaJXIdcpyLepZh5jvBUH/qvkcgko/aSPzA1PGjieNm500z/GlgsUbFTOuP2iyAmHKU22ENy+JQwwPyDjw6L9ucs8nEgXpwxqBtNXLqcJpkwDMTGMUW8CgnAW19m5866AIKEJjk/7TYXCBBVOCssrAseU4eexUvqj7QCWutO03g+lYA/rj+SSpaGxxpll1y0hN2G6iT/NpkzY2zsB5JyZ3z5FvNnVKuWN15Wt7+CQV7QY0FJR0/1Tbp5E+6C2xSdtZC5k+p16tHFkkT7QaCYzAAmIDO9yx3Ph4YkzAzrvusC0GAR7pZs1E9TivjxAwbfKqBGaxLEx8FFmTKdoPs/2oDs1AnPNIKCSArwLHAXussqo6nffS/4zH/L/f4o9lomlHO7f3OULpFqexmif3qA01gjcKGdw/D6AH1U8IC/CIDw1jcQV/yPhmZXacBOLKCO6HmLI+FIbDU4fJ4eUHqRow/LHwEM72IhZhW7ZfzydxlTyAQ9yVu1T6S8BLAPNm/ynWKR8DW0yKsj9EbTukRw3JOpicJqtrZCbTUic63EbSCGxptbCAzK4O/ybt+zKPBFmVUVu8T5+X6HOBft3EO2TwSpsmTPEEJKKV+5STF3kZQuashlEGGykUYSWGoGCf
 uY9JwsSD
 57whpGwy6oiHdVc7pv6S334GgOc6KHUtz3YQvY3BEdNdObx6kAlNPRuI1qCDGn1VXFZ5atzfhqLhCQUkL8i31SMJbrBYvONTwNDHw6e9+LaN/ocm447lrXBoLs7eiEmrlTt1IwP3KVU5dYVzu4RVW37KSEBnpJkydSHrxV+Jxz4ll+mlFaEGAGLR+08pukFOBwcFrp6kMQ9nVNuFyV/61o2r6lV+P/ZL1q8qbawxrC/xqvur/vOT2EmAPXzVasDlT9AY8UJZmC35HnONuIGzd4UQFPF4ttdwoB14qFhdAnTGcslBspUHd+RbeGlBNfx61pAgINfYjuchMouhQ4s+LpswrYV84azjyjGeZb7tBNcsm02g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 02:09:09PM +0800, Chris Down wrote:
> KMALLOC_PARTITION_CACHES creates several copies of each normal kmalloc
> cache and spreads allocations across them. That costs a fair bit of
> memory: Harry measured about 18 MiB more slab memory after boot on a 64
> CPU, 64 GiB VM, mostly from under-used slabs [1]. Like SLAB_BUCKETS, it
> can only be chosen at build time.
> 
> Add a kmalloc_partition= early parameter, enabled by default on kernels
> built with CONFIG_KMALLOC_PARTITION_CACHES=y. When it's off, the copies
> alias the normal caches rather than being created.
> 
> Let's leave kmalloc_type() unchanged since each index simply resolves to
> the same cache when partitioning is off.
> 
> Link: https://lore.kernel.org/r/179312451613.474906.1475329637924619088@kernel.org [1]
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  .../admin-guide/kernel-parameters.txt         |  7 +++++++
>  mm/Kconfig                                    |  5 +++++
>  mm/slab_common.c                              | 19 ++++++++++++++++++-
>  3 files changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index de2fd6963a16..6633a553a79c 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3054,6 +3054,13 @@ Kernel parameters
>  			Configure the RouterBoard 532 series on-chip
>  			Ethernet adapter MAC address.
>  
> +	kmalloc_partition= [MM,EARLY]
> +			Format: <bool>
> +			Enable or disable kmalloc cache partitioning on
> +			kernels built with CONFIG_KMALLOC_PARTITION_CACHES=y.
> +			Ignored without that option.
> +			Default: on.
> +
>  	kmemleak=	[KNL,EARLY] Boot-time kmemleak enable/disable
>  			Valid arguments: on, off
>  			Default: on
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 48078c1fd26f..b90b3915fcd5 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -266,6 +266,11 @@ config KMALLOC_PARTITION_CACHES
>  	  limited degree of memory and CPU overhead that relates to hardware
>  	  and system workload.
>  
> +	  The partitioning can be disabled at boot with the
> +	  "kmalloc_partition=0" kernel parameter, in which case the copies
> +	  are not created and all normal kmalloc allocations use the
> +	  regular kmalloc caches.
> +
>  choice
>  	prompt "Partitioned slab cache mode"
>  	depends on KMALLOC_PARTITION_CACHES
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 9fe48da12010..5391149a2eed 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -781,6 +781,16 @@ unsigned long random_kmalloc_seed __ro_after_init;
>  EXPORT_SYMBOL(random_kmalloc_seed);
>  #endif
>  
> +#ifdef CONFIG_KMALLOC_PARTITION_CACHES
> +static bool kmalloc_partition_enabled __ro_after_init = true;
> +
> +static int __init setup_kmalloc_partition(char *str)
> +{
> +	return kstrtobool(str, &kmalloc_partition_enabled);
> +}
> +early_param("kmalloc_partition", setup_kmalloc_partition);
> +#endif
> +
>  /*
>   * Conversion table for small slabs sizes / 8 to the index in the
>   * kmalloc array. This is necessary for slabs < 192 since we have non power
> @@ -1013,8 +1023,15 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
>  	}
>  
>  #ifdef CONFIG_KMALLOC_PARTITION_CACHES

Swap the ifdef for a CONFIG-controlled static branch that defaults off
without CONFIG_KMALLOC_PARTITION_CACHES.

> -	if (type >= KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END)
> +	if (!kmalloc_partition_enabled) {
> +		/* Use the normal caches, which have already been created. */
> +		if (type > KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END) {
> +			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
> +			return;
> +		}
> +	} else if (type >= KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END) {
>  		flags |= SLAB_NO_MERGE;
> +	}
>  #endif
>  
>  	/*
> -- 
> 2.54.0
> 

-- 
Kees Cook

