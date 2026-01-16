Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB136C982C0
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 20:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AD616B0088; Fri, 16 Jan 2026 15:49:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25B656B0089; Fri, 16 Jan 2026 15:49:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167646B008C; Fri, 16 Jan 2026 15:49:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 045CD6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:49:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7CAF1AE2B2
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:49:38 +0000 (UTC)
X-FDA: 84339018036.20.D8FE902
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1D6D0C0002
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:49:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BPJlkgrU;
	spf=pass (imf10.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768596576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQzf2KruKYLHDSYMyFQBestybveGGtJpw9S7mJySnK8=;
	b=f9moPBucEB0pRSHYSk3JpJhfIvQUBMS/JsZFQ9z+UeDIDEplcgcsAfJg8oXAAL7BjuM912
	xKOM5O8r3jQzPW2Za2W0Gdoz39jKbEDHxIKA8B0W0J0X8ToDvVeJWqwRcc8p8m66+8diwI
	FEvyWvod/YOpCdXUiz6gpHIDss3KrAg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BPJlkgrU;
	spf=pass (imf10.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768596576; a=rsa-sha256;
	cv=none;
	b=aX1C4JoNq8BXZpyQ7d0xP6UIX4YdsEdcTmPUqWnd+HeMmV+9RnAl10AAaq8M2qqgnHQpTP
	b0xi0EUFIDwuSIRSFv1jf9zPu19bBizAsyzOX/HetEH+fe/lm9aqENYu3MCndjLAYSBqq7
	mNRt0+2LAEIqBo2uzc5A3vSpmC11FsY=
Date: Fri, 16 Jan 2026 20:49:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768596571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZQzf2KruKYLHDSYMyFQBestybveGGtJpw9S7mJySnK8=;
	b=BPJlkgrUQ0vjhoWQMnDwYWlUX2nnC3BfG7xf5hl+TyAl7UJ9rzzrW4qAkCvaJNIaiHFo+B
	N/p8Gn/Ewi6w6L26m0jPTLCPDPIcR09a5kw4afsXyzc625k71JyG6qBXLQdNtZNRDbgATk
	v3ip+4fJENwF4nZGnYFxpdwixv37q2Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] zsmalloc: make common caches global
Message-ID: <z52lw2spqxmvgn6zo7b77nvxyjtxez5nxd6gsn6s3mwqnkvynq@gtd7kpedbtfr>
References: <20260116044841.334821-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116044841.334821-1-senozhatsky@chromium.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8rbyikbtijozwbu9ihmaqwu73obasgp8
X-Rspamd-Queue-Id: 1D6D0C0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768596574-199409
X-HE-Meta: U2FsdGVkX18O0wIHLKHS1uOPtX4jjh51feuyWLfE/fiQkRbJNUqEHpwwSilo1+mlmnedga7S+tiFlWaEj7y+QfzKWHlyMU5E/LxkXalAUYwlmh8Ps9qHViS8MxTtIiVgmPZz61p5Q11xs6amuETjh5pKhLiIKXRLSDhv6l4Pa/iOukYiQkR44qVjkSOOp1eV2xQ6Ued8oQrm072kjmkjj5QDYQbIWuoLRTUaabr/++2GlyEDcLpYC0/ZwemwiFSl89YezoZipKdqn2Gayq7lipG6gRjxkSjbqNSZMBj5HcDUt3huWRCNoG2w6DL8D+hYy9dHbvO6q93qVweWNza6g9rMv6phl/SmjmQYDm99m5ldZXH9ZX/LY95ZnEIaI2ibjDp2j793Ksu4/aWULa+nu+SKMiS3IQKGHJx+/hf/l0AI8gj2zXIgk/T602plOsp2FOGl6EFdcidiPtes20CtlWmiCNESKlOP0J+YszrgpwqoRe04sJ592kPcmRqndBAgGMjyCZpLb/em+jLLV5rkUNTCX8Hm5TerXR3E8oJxM94XDMijYsrd6+dKcvnFfdhZfF3S4eEUrQmNxyyj/te1YTMBKHk3G36QpRNonOpT2fYIxE69cbflB/sbSqQ4mRiCn9mGfYNW23ARfsEPVq7odNkE8opeBtLllPeQosdX65jQZcO0lx18IyCGZmJy/UUPQqoxYFrmP1YJAGrnp24RQ3ddDNTPt6wb84FVOgMmoJJcCiNudcU4ox99lnjtOzu+2J5n87oeu2siBsFpDVacDXx20B0yjNTRnkVPQWVViz32sujkd9A7CoU5JcI/zh4qYgnFsP/R4QgHm4ucV/86S1VULSZrDgb0k8/sEFpzTEQC5twd0LQtKhUCXizbl/g5BUN1EAS5Fc+/PHP+lHrUjfHUADVU2h4mSBh6U9JoYPiIAxXUGd7/cTC5CnzqdpZayXF4HNGT5Q+zSiatq5T
 Kt8co83D
 U0QOprnsI95HOu3m7vb67eNVuiOvBQiwSsrdYsPGmmak5qCn4nndY4Qvamr2tRBhtYhYrsBTza7c5danJiYnJeYDS1yth9DmWlCEjuO4oSLjNc8AlY2wltbMtYJ/nWAfbZkD7pTA+ZJWkKbN7TLCt5ZiWY7BnTua2fhIoMd4LMiGDAvkdz8+UNWLYBZJEOWOQHCD1qm5jnx6NlghbXaZe0PPOzK0iHZKA33G0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 01:48:41PM +0900, Sergey Senozhatsky wrote:
> Currently, zsmalloc creates kmem_cache of handles and zspages
> for each pool, which may be suboptimal from the memory usage
> point of view (extra internal fragmentation per pool).  Systems
> that create multiple zsmalloc pools may benefit from shared
> common zsmalloc caches.

I had a similar patch internally when we had 32 zsmalloc pools with
zswap.

You can calculate the savings by using /proc/slabinfo. The unused memory
is (num_objs-active_objs)*objsize. You can sum this across all caches
when you have multiple pools, and compare it to the unused memory with a
single cache.

> 
> Make handles and zspages kmem caches global.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  mm/zsmalloc.c | 95 ++++++++++++++++++++++-----------------------------
>  1 file changed, 40 insertions(+), 55 deletions(-)
> 
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 5abb8bc0956a..05ed3539aa1e 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -198,12 +198,13 @@ struct link_free {
>  	};
>  };
>  
> +static struct kmem_cache *handle_cachep;
> +static struct kmem_cache *zspage_cachep;
> +
>  struct zs_pool {
>  	const char *name;
>  
>  	struct size_class *size_class[ZS_SIZE_CLASSES];
> -	struct kmem_cache *handle_cachep;
> -	struct kmem_cache *zspage_cachep;
>  
>  	atomic_long_t pages_allocated;
>  
> @@ -376,60 +377,28 @@ static void init_deferred_free(struct zs_pool *pool) {}
>  static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage) {}
>  #endif
>  
> -static int create_cache(struct zs_pool *pool)
> +static unsigned long cache_alloc_handle(gfp_t gfp)
>  {
> -	char *name;
> -
> -	name = kasprintf(GFP_KERNEL, "zs_handle-%s", pool->name);
> -	if (!name)
> -		return -ENOMEM;
> -	pool->handle_cachep = kmem_cache_create(name, ZS_HANDLE_SIZE,
> -						0, 0, NULL);
> -	kfree(name);
> -	if (!pool->handle_cachep)
> -		return -EINVAL;
> -
> -	name = kasprintf(GFP_KERNEL, "zspage-%s", pool->name);
> -	if (!name)
> -		return -ENOMEM;
> -	pool->zspage_cachep = kmem_cache_create(name, sizeof(struct zspage),
> -						0, 0, NULL);
> -	kfree(name);
> -	if (!pool->zspage_cachep) {
> -		kmem_cache_destroy(pool->handle_cachep);
> -		pool->handle_cachep = NULL;
> -		return -EINVAL;
> -	}
> -
> -	return 0;
> -}
> +	gfp = gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE);
>  
> -static void destroy_cache(struct zs_pool *pool)
> -{
> -	kmem_cache_destroy(pool->handle_cachep);
> -	kmem_cache_destroy(pool->zspage_cachep);
> +	return (unsigned long)kmem_cache_alloc(handle_cachep, gfp);
>  }
>  
> -static unsigned long cache_alloc_handle(struct zs_pool *pool, gfp_t gfp)
> +static void cache_free_handle(unsigned long handle)
>  {
> -	return (unsigned long)kmem_cache_alloc(pool->handle_cachep,
> -			gfp & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
> +	kmem_cache_free(handle_cachep, (void *)handle);
>  }
>  
> -static void cache_free_handle(struct zs_pool *pool, unsigned long handle)
> +static struct zspage *cache_alloc_zspage(gfp_t gfp)
>  {
> -	kmem_cache_free(pool->handle_cachep, (void *)handle);
> -}
> +	gfp = gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE);
>  
> -static struct zspage *cache_alloc_zspage(struct zs_pool *pool, gfp_t flags)
> -{
> -	return kmem_cache_zalloc(pool->zspage_cachep,
> -			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
> +	return kmem_cache_zalloc(zspage_cachep, gfp);
>  }
>  
> -static void cache_free_zspage(struct zs_pool *pool, struct zspage *zspage)
> +static void cache_free_zspage(struct zspage *zspage)
>  {
> -	kmem_cache_free(pool->zspage_cachep, zspage);
> +	kmem_cache_free(zspage_cachep, zspage);
>  }
>  
>  /* class->lock(which owns the handle) synchronizes races */
> @@ -858,7 +827,7 @@ static void __free_zspage(struct zs_pool *pool, struct size_class *class,
>  		zpdesc = next;
>  	} while (zpdesc != NULL);
>  
> -	cache_free_zspage(pool, zspage);
> +	cache_free_zspage(zspage);
>  
>  	class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
>  	atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
> @@ -971,7 +940,7 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
>  {
>  	int i;
>  	struct zpdesc *zpdescs[ZS_MAX_PAGES_PER_ZSPAGE];
> -	struct zspage *zspage = cache_alloc_zspage(pool, gfp);
> +	struct zspage *zspage = cache_alloc_zspage(gfp);
>  
>  	if (!zspage)
>  		return NULL;
> @@ -993,7 +962,7 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
>  				zpdesc_dec_zone_page_state(zpdescs[i]);
>  				free_zpdesc(zpdescs[i]);
>  			}
> -			cache_free_zspage(pool, zspage);
> +			cache_free_zspage(zspage);
>  			return NULL;
>  		}
>  		__zpdesc_set_zsmalloc(zpdesc);
> @@ -1346,7 +1315,7 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
>  	if (unlikely(size > ZS_MAX_ALLOC_SIZE))
>  		return (unsigned long)ERR_PTR(-ENOSPC);
>  
> -	handle = cache_alloc_handle(pool, gfp);
> +	handle = cache_alloc_handle(gfp);
>  	if (!handle)
>  		return (unsigned long)ERR_PTR(-ENOMEM);
>  
> @@ -1370,7 +1339,7 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
>  
>  	zspage = alloc_zspage(pool, class, gfp, nid);
>  	if (!zspage) {
> -		cache_free_handle(pool, handle);
> +		cache_free_handle(handle);
>  		return (unsigned long)ERR_PTR(-ENOMEM);
>  	}
>  
> @@ -1450,7 +1419,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
>  		free_zspage(pool, class, zspage);
>  
>  	spin_unlock(&class->lock);
> -	cache_free_handle(pool, handle);
> +	cache_free_handle(handle);
>  }
>  EXPORT_SYMBOL_GPL(zs_free);
>  
> @@ -2112,9 +2081,6 @@ struct zs_pool *zs_create_pool(const char *name)
>  	if (!pool->name)
>  		goto err;
>  
> -	if (create_cache(pool))
> -		goto err;
> -
>  	/*
>  	 * Iterate reversely, because, size of size_class that we want to use
>  	 * for merging should be larger or equal to current size.
> @@ -2236,7 +2202,6 @@ void zs_destroy_pool(struct zs_pool *pool)
>  		kfree(class);
>  	}
>  
> -	destroy_cache(pool);
>  	kfree(pool->name);
>  	kfree(pool);
>  }
> @@ -2246,10 +2211,28 @@ static int __init zs_init(void)
>  {
>  	int rc __maybe_unused;
>  
> +	handle_cachep = kmem_cache_create("zs_handle", ZS_HANDLE_SIZE, 0, 0,
> +					  NULL);
> +	if (!handle_cachep)
> +		return -ENOMEM;
> +
> +	zspage_cachep = kmem_cache_create("zspage", sizeof(struct zspage), 0,
> +					  0, NULL);
> +	if (!zspage_cachep) {
> +		kmem_cache_destroy(handle_cachep);
> +		handle_cachep = NULL;
> +		return -ENOMEM;
> +	}
> +
>  #ifdef CONFIG_COMPACTION
>  	rc = set_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
> -	if (rc)
> +	if (rc) {
> +		kmem_cache_destroy(zspage_cachep);
> +		kmem_cache_destroy(handle_cachep);
> +		zspage_cachep = NULL;
> +		handle_cachep = NULL;
>  		return rc;
> +	}
>  #endif
>  	zs_stat_init();
>  	return 0;
> @@ -2261,6 +2244,8 @@ static void __exit zs_exit(void)
>  	set_movable_ops(NULL, PGTY_zsmalloc);
>  #endif
>  	zs_stat_exit();
> +	kmem_cache_destroy(zspage_cachep);
> +	kmem_cache_destroy(handle_cachep);
>  }

Hmm instead of the repeated kmem_cache_destroy() calls, can we do sth
like this:

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index dccb88d52c07..86e2ca95ac4c 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -2235,14 +2235,43 @@ void zs_destroy_pool(struct zs_pool *pool)
 }
 EXPORT_SYMBOL_GPL(zs_destroy_pool);

+static void __init zs_destroy_caches(void)
+{
+       kmem_cache_destroy(zs_handle_cache);
+       zs_handle_cache = NULL;
+       kmem_cache_destroy(zspage_cache);
+       zspage_cache = NULL;
+}
+
+static int __init zs_init_caches(void)
+{
+       zs_handle_cache = kmem_cache_create("zs_handle", ZS_HANDLE_SIZE,
+                                           0, 0, NULL);
+       zspage_cache = kmem_cache_create("zspage", sizeof(struct zspage),
+                                        0, 0, NULL);
+
+       if (!zs_handle_cache || !zspage_cache) {
+               zs_destroy_caches();
+               return -ENOMEM;
+       }
+       return 0;
+}
+
+
 static int __init zs_init(void)
 {
-       int rc __maybe_unused;
+       int rc;
+
+       rc = zs_init_caches();
+       if (rc)
+               return rc;

 #ifdef CONFIG_COMPACTION
        rc = set_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
-       if (rc)
+       if (rc) {
+               zs_destroy_caches();
                return rc;
+       }
 #endif
        zs_stat_init();
        return 0;

>  
>  module_init(zs_init);
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

