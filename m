Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5571606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QYpHcabK
Received: by kanga.kvack.org (Postfix)
	id 914236B05B2; Thu, 26 Nov 2026 09:45:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EAEE6B05B3; Thu, 26 Nov 2026 09:45:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829076B05BB; Thu, 26 Nov 2026 09:45:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 606E66B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:45:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 015241C3CE9
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:45:51 +0000 (UTC)
X-FDA: 85477544544.22.E9E4B72
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5E90D80009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:45:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QYpHcabK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795704350;
	b=fvYyQYx2g4xXacey3QiVARh3+xuRBxj8+NZejK8HYivaADIV5+yJ6uAwMHYTTBPuNqqOMB
	3OwAL+Hh7eU84+pzrEcgpu33ORangN+mDqHb9bWqLHW81xmXkzywakwOvcKhj0toFrq8Bu
	RjAgsVRWROeuzTWXhERb1GLDqw7UCOg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795704350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jL8G5ucVxhl6XpniwOn5qtswk6ptTrbZ5+4HABky+sU=;
	b=3gnJXsu3lhaG8WSZBHLaD4Csz9JBkSifwltoGOoAzA4bktgb82GKFX/b5C6ygqXG/as8Od
	j/pyB+t3dp77pO32Rf8MD1BlTcgZHnHKLL9MZ6poL/T23svk6T24Fxq+L676rOV69TF7yB
	jfPEcj3L/k2DfeqheMX5pHR8e7b/fk8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QYpHcabK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAA1D609E9;
	Thu, 26 Nov 2026 14:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143091F000CF;
	Thu, 26 Nov 2026 14:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795704349;
	bh=jL8G5ucVxhl6XpniwOn5qtswk6ptTrbZ5+4HABky+sU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QYpHcabKB8A5uWvZwYP0lVVKukfxNBAoWXWIiefHci3pC7KeBZuK9SW74oFBLaL/n
	 cqoy/YByLDr3wbHOeVLQpYgccznfeMUzUqdPzyy/mCPSRwNus9t2fEJhvgOyNiL3Ik
	 CpxHXbHuwbSmrgI4HhKBY+dqG7HxT/ovasWRAo0bThZaUsMYGqyANx2X2Anu9ZHqac
	 RWPcSr0SxN5twTU4v1fxRR5LjIFgxbooxghKmaVh6D3j6/M3FOYhCY0I3/Zdg+WZ6G
	 iOxtN+NF8R5vwquyyXJSd3DGD1douEkXCCA5EFXRUm/A1kmTGvX3KeW7M5TR77O7KZ
	 gdo+aWcLq46mg==
Date: Thu, 26 Nov 2026 14:45:47 +0000
From: Harry Yoo <harry@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable+noautosel@kernel.org
Subject: Re: [PATCH 1/3] mm/slab: update the documentation of sheaf_capacity
Message-ID: <awhCltyLWlLRBtsG@thinkstation>
References: <20261125-sheaf-doc-update-v1-0-4a579abaf0b8@kernel.org>
 <20261125-sheaf-doc-update-v1-1-4a579abaf0b8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125-sheaf-doc-update-v1-1-4a579abaf0b8@kernel.org>
X-Rspamd-Queue-Id: 5E90D80009
X-Stat-Signature: qmemb5j4ycx8gnz8zy11wk1ob3kog38p
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795704350-410375
X-HE-Meta: U2FsdGVkX18sBUD4qPEiBzfD6jKDNv3NEBmwl2ZdFh80DRaXtjh97WLgaLnB/EkrVIj0l8XJkNPg27NJ5WWrYTq32WKPnktRSlxI9aDuk3GYh0B2DzaX1xbXd7uyMFnESutYkJ7srVY512Q2BtCxm2d3XJGicIKMYmIowQ2YussQqCRNV5YRSBBO8RnSiyQQT7kElg8Kaw8sPQVmauectFQjyzSYHOOWO8LibUGQOJoHx51EmnRwyGdSL8KML8ym6xkB6ChIhSe1PVbnUb9+5HQCfjlI393JX3rnEDnXb3pjPRMfByHBwuevOBy/IQFrcNLHFvKrpKmmszcEOGZyFv2T9SkIyaKck65iOZkoW31W2vXehOOsyTbUi0w4iSbLamnGx5yxGXBLuwKxkGgakJAKqSi7rWz4vgACrEsWhAfvgO3gM+11vVesmGrzzJ/cbr6nD7ljjRyBUxDwbsXqN/t7xBgHBgpDTOzs1G22OGo1IH74ndvQxBNLhv1DMOumaFdpkcNfKeiLyhTBo8fLqWu5hU5cCfO17zZIC9vOOTBz00sLfg20RvxISrm//FEiTF56XwnNtyXXlNCm/LU5xNOM3wek5/of7DIhQl64fnsl4qUJJq05uThgBAI70VZ7wUsLsFSQIN1iJaPVLcAKsJnmWHSt7Kz+nV+tAHcd6esqTEGpkc8+8kiWkZtZ2TZQGr5qtEIl2ziW7BtoiaFjVzX7wIi0OwPu0Ug7pl6OPtjQuqgh502T5d9w/rUFEXOiR8LY88mAAZoU88vznLoQ2Fr9cbWihljaKj+VFdR4tH+Ji7kadn7wyWJSxNCpc6Lg45stRAS3JiZgwhC0T2PThfzXdxSzoTXlA+zNQEFNFkF+753MHw9UCaIbTtTC6URR+y1ECSfKPlp9yQsvlVm0MlkVzTNCQoQsijh95WIRz38yoKQng1feB21b03ZLwikpVMiuCdl3tirLH0w+Mpg
 nFV864kh
 qVcZGHh9wHlgJXFxq05JSp4er8YfSXt3b9wU5ccsUq6LoBNKpFRCFo1VYp28FWXG8qqx8+5dNQSXClLbnyXySj7woKrT8LXzc/PZZLAWlAZEw1/BN8GkAdpHrND4J9yhzm1sQTpbf9dWGuSeUYcxT56GWC+4MTwYErnMcT4QY0ABq3T0Kxdc/u8qZUOUyI4c4mGt5iEwJCdHDM+ApfvBf83X1YmWsjTMNYhTs7GatkfDvSVdjSvdIm3NNY752ZFNQW+rrsI/eEN6xuMVJz4ymPNH0quOMKOK+KyTFKck8OYeEjOZBDg607xmEzToSBKm7/jp/Bt68u8azx0vYo5n30keQpO9F4hH+E8ll4lyy1F37Jdc9R/ygeSolM18YuJx6PhH+d3joaUKXCuAmJ72TwHWWS9pSrEcdSXmxDsNTaEaLh9POJV3bpFJRKCe+o1ZR9DMgnKrNe3Wl5UuPxwUHfCAUDcXHeOiwwFQDz++Px3s73B+fJWSZXB768rJ3vFR6GiBmnzecamn+1GEaB1iqwdtOsrxYk32ij+PH9lPmw1hbPwVtTN4p51HYJmqwaMeyFEAtyCrB2wFhdFh7Py7pSR7IH6QjjQzDDyOsdOc/EwGeCQT2SqOLk1mwym4iy/k6RyFxeVs0zOGLkgHM3gSfl3BQytaFIYAr+ui1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 08:35:12PM +0100, Andreas Hindborg wrote:
> The documentation of the sheaf_capacity member of struct kmem_cache_args
> describes sheaves as an opt-in feature: a non-zero value enables sheaves of
> the given capacity, and zero means that no sheaves are created.
> 
> This has not been the case since sheaves were added to most caches.
> calculate_sheaf_capacity() now calculates a capacity from the object size
> for all caches and returns the larger of that and the requested capacity.
> The requested capacity is thus a minimum, and zero selects the calculated
> capacity, as pointed out in [1].
> 
> Update the documentation to match.

> While at it, mention that a non-zero
> value makes the cache unmergeable,

This is not something we want to guarantee in the API?
Otherwise LGTM.

> that the requested capacity is also not
> used when slab_tiny is enabled, and refer to the debugging parameter by its
> current name, slab_debug.
> 
> The updated text refers to the slab_tiny boot parameter, which older
> kernels do not have, so exclude the patch from stable autoselection.
> 
> Fixes: e47c897a2949 ("slab: add sheaves to most caches")
> Cc: <stable+noautosel@kernel.org> # slab_tiny is not in older kernels
>
> Link: https://lore.kernel.org/r/8a73da1c-0167-4aa5-a62c-4190327685cd@kernel.org [1]
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  include/linux/slab.h | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index ad645967a3ee..64daeb239f78 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -351,13 +351,12 @@ struct kmem_cache_args {
>  	 */
>  	void (*ctor)(void *);
>  	/**
> -	 * @sheaf_capacity: Enable sheaves of given capacity for the cache.
> +	 * @sheaf_capacity: Minimum capacity of the sheaves of the cache.
>  	 *
> -	 * With a non-zero value, allocations from the cache go through caching
> -	 * arrays called sheaves. Each cpu has a main sheaf that's always
> -	 * present, and a spare sheaf that may be not present. When both become
> -	 * empty, there's an attempt to replace an empty sheaf with a full sheaf
> -	 * from the per-node barn.
> +	 * Allocations from the cache go through caching arrays called sheaves.
> +	 * Each cpu has a main sheaf that's always present, and a spare sheaf
> +	 * that may be not present. When both become empty, there's an attempt
> +	 * to replace an empty sheaf with a full sheaf from the per-node barn.

>  	 * When no full sheaf is available, and gfp flags allow blocking, a
>  	 * sheaf is allocated and filled from slab(s) using bulk allocation.
> @@ -375,10 +374,19 @@ struct kmem_cache_args {
>  	 * Bulk allocation and free operations also try to use the cpu sheaves
>  	 * and barn, but fallback to using slab pages directly.
>  	 *
> -	 * When slub_debug is enabled for the cache, the sheaf_capacity argument
> -	 * is ignored.
> +	 * The allocator selects a default capacity for the sheaves based on the
> +	 * size of the objects in the cache, with larger objects giving a lower
> +	 * capacity. With a non-zero value, the capacity is at least the given
> +	 * value. Use this to match the expected maximum size passed to
> +	 * kmem_cache_prefill_sheaf(), to avoid low-performance oversize
> +	 * sheaves. A cache created with a non-zero value is not merged with
> +	 * other caches.
>  	 *
> -	 * %0 means no sheaves will be created.
> +	 * When slab_tiny is enabled, or when slab_debug is enabled for the
> +	 * cache, no percpu sheaves are created and the requested capacity is
> +	 * not used. A non-zero value still prevents merging of the cache.
> +	 *
> +	 * %0 means the calculated capacity is used.
>  	 */
>  	unsigned int sheaf_capacity;
>  };

-- 
Cheers,
Harry / Hyeonggon

