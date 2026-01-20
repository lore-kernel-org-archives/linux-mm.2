Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6167D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 11:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B916B03CF; Tue, 20 Jan 2026 06:57:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC70F6B03D0; Tue, 20 Jan 2026 06:57:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4066B03D1; Tue, 20 Jan 2026 06:57:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE0286B03CF
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:57:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 601D91AE793
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:57:39 +0000 (UTC)
X-FDA: 84352192638.14.60F3BC1
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5FE1B120002
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:57:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rJ4VrhTy;
	spf=pass (imf29.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768910257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYEpCcCgyOkPKRRfQKMgVhYxxpRPIrOqb5axcNzE03I=;
	b=TxV8LngzhmKcY+hxepUQ94TOxLqbnU1nqUBMSrROfE/u0/G9UHsUM6zjNZxrXyqg6urHxD
	DnH5IGexBLUpnfD0J0xkIglrJ3iPFy3rD3fI9MD4msxypHU38Q+4veJ2hzEQ7qgwD9m9qa
	wGzENrjoHlCNZOWg+uACbmzo+jpsrUE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rJ4VrhTy;
	spf=pass (imf29.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768910257; a=rsa-sha256;
	cv=none;
	b=ezPZvYpHyb60jP2ZNj9FHm+b7CrwfGw4Fs59wHnjk/u+VCosS/DZOz/DkF6mHDXcU4e+Xu
	viRe6CwNnFaR3ViOftgAp05vWpredk88JQUL23NAxpXrvR19b6QsHeE6BUeqypRDgHBcGt
	zYPIq9WcBdcpucpfmw4PMdq/0NHISQQ=
Date: Tue, 20 Jan 2026 19:57:26 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768910255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HYEpCcCgyOkPKRRfQKMgVhYxxpRPIrOqb5axcNzE03I=;
	b=rJ4VrhTyQdhFkerciHCs4dOwK9+lY9C7TBgHlyFYs8jDjUXtO+FfCbZ3OKuoZ5ZpEN81wo
	jwdDHUZNY4AGhASTayKavNAEBTL4zkrJcH1/9r7+3ho1ZECOr0LQZ5kPav2OThdYhYKGQy
	voC9+uXPzq1YLOkFof5WavjYyk3wXRM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Eric Dumazet <edumazet@google.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev
Subject: Re: [PATCH] slab: replace cache_from_obj() with inline checks
Message-ID: <imazcyfzfkxofsnriyp5wa5v6yzszozljircucw2tgj6zex2ee@ytew6wy4kkh6>
References: <20260120-b4-remove_cache_from_obj-v1-1-ace30c41eecf@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120-b4-remove_cache_from_obj-v1-1-ace30c41eecf@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5FE1B120002
X-Stat-Signature: dnq13um4x9mdmyrepk8i3ah458n8r67e
X-HE-Tag: 1768910257-257914
X-HE-Meta: U2FsdGVkX18IY19nXHMfDFM5f9KG6CIkA4cMU084O29wSFfJucGMJP2xikDUrEJbRaSMuDRzaXbp8G0BvGrQ9R8FafzA2BdOwHcetJAJ1OgJ5aOP5VNklhdfeFIBrObItNuDFntbR4RJMTmBZcHnpdkcUtb1KqQ1sAqUIEl1AQV808nZr+80UyMKzUqAOKVYnFXD0weuf5+Ra63vWd+KQNw6erduAct40fT/IxLdEvgkumAt54CfR/hBrXkTsHhRopJZlCugqpC8ld4NWafQrZGbQDgQAx+QdFSCs0AcKbRH0d/bygU8l4D6n0iAqOKB1jqfRrPk/dkfBO9/8pUVOcVSdRvuww62+hBDUMbBDWUGIPAbjBlWbHp3/b60d/j373zrgo6tRnaQVEdTPojKqQRq0T6vvqvL8O+Qpjs1SEwVU1+/TH3f22WCeqV7a8kvlZ23aEW1ULiqjuxRauqr0iAWRNm297EDTv1nrL2ZB+l65vZMPgfXFKxrHKc728uXoiIFJKLvmjahSZn4ycArmqpGWcyFBeOyoSfQXuTwoH2g2bLlV4kHmkKQvlOn6V+zH8F6RKXGeM64SvCA1Kk3EX34MjKO7auVsNSflGjXVbPv3Z1mWRZqa/gNsANYp9ak9XNs3xQhBmSGhaMq4APiqka1yjrgNWt2ebuZnDpw9W7C7lczZ4w6VNvIYh91OAzL9HW3Vihe/IZolTdH7VJkG/CCHSpMPm8jxOW3tzQkIXdNlGU9GBYYP8Z/xJMkYsmcoNKG8HTTsgFJZ60oMbByvs7WzJ0LsioH2QFLG4B+TT6bMSV+seCW6kR7m4momdizHGg5ik7a0Zg4B7s6rGkPDTPhiMN1ZZ+sAda7p6ETj0+0dx9HBDYRwFXKNwsS3XThCGmJ+tKQTOwnH3PuhoTHgCxTi7s5qc3HNwc9G63XSb5mG6AtnGr8wVYLwUF/9q5qA8xdIRUH4WMSvQL2Xs6
 jgzTF5qI
 tkO335UMpAnbiiY9XNdyMLwDTuDBeL5sPoUunSDumNmixez1mjytAj5kGF/pz9awO5fbpJKWqO5T3XGTku/AvYxOxa4058RO4NcqOCih0wcYSbdcse/UtUf+EElMHtp6GGL9eBxmH8FRuz3eqPtS7HcpMDiqZYTe9wUnow9esc0gWv7mWIZrvhqkHSdJMeGUEqWj6FXLITQpT5xh6hx5mD1kKbS10KL7WoZnsOQiFbt63Zea2fLCzdwakI49LHd5/19dX2mZEHd6Eoierl1hJPOJy9/lnuEkg4RaknaFLvclLzLw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 10:35:42AM +0100, Vlastimil Babka wrote:
> Eric Dumazet has noticed cache_from_obj() is not inlined with clang and
> suggested splitting it into two functions, where the smaller inlined one
> assumes the fastpath is !CONFIG_SLAB_FREELIST_HARDENED. However most
> distros enable it these days and so this would likely add a function
> call to the object free fastpaths.
> 
> Instead take a step back and consider that cache_from_obj() is a relict
> from when memcgs created their separate kmem_cache copies, as the
> outdated comment in build_detached_freelist() reminds us.
> 
> Meanwhile hardening/debugging had reused cache_from_obj() to validate
> that the freed object really belongs to a slab from the cache we think
> we are freeing from.
> 
> In build_detached_freelist() simply remove this, because it did not
> handle the NULL result from cache_from_obj() failure properly, nor
> validate objects (for the NULL slab->slab_cache pointer) when called via
> kfree_bulk(). If anyone is motivated to implement it properly, it should
> be possible in a similar way to kmem_cache_free().
> 
> In kmem_cache_free(), do the hardening/debugging checks directly so they
> are inlined by definition and virt_to_slab(obj) is performed just once.
> In case they failed, call a newly introduced warn_free_bad_obj() that
> performs the warnings outside of the fastpath.
> 
> As a result the fastpath should be inlined in all configs and the
> warnings are moved away.
> 
> Reported-by: Eric Dumazet <edumazet@google.com>
> Closes: https://lore.kernel.org/all/20260115130642.3419324-1-edumazet@google.com/
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 52 +++++++++++++++++++++++++++++-----------------------
>  1 file changed, 29 insertions(+), 23 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 861592ac5425..1bdb4f73d61b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6738,30 +6738,26 @@ void ___cache_free(struct kmem_cache *cache, void *x, unsigned long addr)
>  }
>  #endif
>  
> -static inline struct kmem_cache *virt_to_cache(const void *obj)
> +static noinline void warn_free_bad_obj(struct kmem_cache *s, void *obj)
>  {
> +	struct kmem_cache *cachep;
>  	struct slab *slab;
>  
>  	slab = virt_to_slab(obj);
> -	if (WARN_ONCE(!slab, "%s: Object is not a Slab page!\n", __func__))
> -		return NULL;
> -	return slab->slab_cache;
> -}
> -
> -static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
> -{
> -	struct kmem_cache *cachep;
> +	if (WARN_ONCE(!slab,
> +			"kmem_cache_free(%s, %p): object is not in a slab page\n",
> +			s->name, obj))
> +		return;
>  
> -	if (!IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
> -	    !kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS))
> -		return s;
> +	cachep = slab->slab_cache;
>  
> -	cachep = virt_to_cache(x);
> -	if (WARN(cachep && cachep != s,
> -		 "%s: Wrong slab cache. %s but object is from %s\n",
> -		 __func__, s->name, cachep->name))
> -		print_tracking(cachep, x);
> -	return cachep;
> +	if (WARN_ONCE(cachep != s,
> +			"kmem_cache_free(%s, %p): object belongs to different cache %s\n",
> +			s->name, obj, cachep ? cachep->name : "(NULL)")) {
> +		if (cachep)
> +			print_tracking(cachep, obj);
> +		return;
> +	}
>  }
>  
>  /**
> @@ -6774,11 +6770,21 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
>   */
>  void kmem_cache_free(struct kmem_cache *s, void *x)
>  {
> -	s = cache_from_obj(s, x);
> -	if (!s)
> -		return;
> +	struct slab *slab;
> +
> +	slab = virt_to_slab(x);
> +
> +	if (IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) ||
> +	    kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS)) {
> +
> +		if (unlikely(!slab || (slab->slab_cache != s))) {
> +			warn_free_bad_obj(s, x);

Just to make sure I'm understanding correctly, are we intentionally not
releasing the object x in this case? Thanks.

> +			return;
> +		}
> +	}
> +
>  	trace_kmem_cache_free(_RET_IP_, x, s);
> -	slab_free(s, virt_to_slab(x), x, _RET_IP_);
> +	slab_free(s, slab, x, _RET_IP_);
>  }
>  EXPORT_SYMBOL(kmem_cache_free);
>  
> @@ -7305,7 +7311,7 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
>  		df->s = slab->slab_cache;
>  	} else {
>  		df->slab = slab;
> -		df->s = cache_from_obj(s, object); /* Support for memcg */
> +		df->s = s;
>  	}
>  
>  	/* Start new detached freelist */
> 
> ---
> base-commit: 0f61b1860cc3f52aef9036d7235ed1f017632193
> change-id: 20260120-b4-remove_cache_from_obj-190fcaf16789
> 
> Best regards,
> -- 
> Vlastimil Babka <vbabka@suse.cz>
> 

