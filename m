Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C200D606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U/zzQhn9
Received: by kanga.kvack.org (Postfix)
	id E17736B05D4; Thu,  5 Nov 2026 12:03:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC83A6B05D5; Thu,  5 Nov 2026 12:03:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8F386B05D6; Thu,  5 Nov 2026 12:03:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2ED6B05D4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:03:08 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 31558160B5F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:03:08 +0000 (UTC)
X-FDA: 85401685656.09.1C97120
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id B7ACD20011
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:03:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U/zzQhn9";
	spf=pass (imf31.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793898186;
	b=3mUhfY9xGS0KK5JfkJpetEzCRlYnhpAcuW62Yt35wUB8IJ2ThMhuJ85HDP5npJmtxaalCR
	uLLY82qK2tDT8RRMEWXqXzUL18tkFaoqrdSSZTeB78IjMIMtFi6Xg+DgBtBMtZMtEyhq14
	eGjhkdqck+fFAj27046GGdjtPPeN23k=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U/zzQhn9";
	spf=pass (imf31.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793898186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+GDK5SHSY6SA93NwCdlZTl+b20QDETC0OdxKh5BTja4=;
	b=kRvfZ2ZdF6RbfFuXb1lSH/b9Q//NP8JjRRdTix3Q0C52KK5HHJu7uTcjVkMJmRvlB/udem
	rf5qo0qb/vNsZ4J8H5Ab9v2lWwqUzof5SoDFqTlAQYIN/KXwigLn42KsGC8nlcbzDKHTkV
	5prYA13ZOHs5rll6uZJRc9bz2g6RLvs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1A9643BD8;
	Thu,  5 Nov 2026 17:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4329B1F00A15;
	Thu,  5 Nov 2026 17:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793898185;
	bh=+GDK5SHSY6SA93NwCdlZTl+b20QDETC0OdxKh5BTja4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U/zzQhn9F9RkCJilk4OZI/QAAx01gxRgJL5gzdN1eBbPe+uIGkyUIY/eHuti0URuV
	 PC7SUDFqmuz2hgDMK1d01qt6xjAyjtPUFHYy28KJ/ecJVH9fN82lpkhN/4yVV1XlRO
	 J+g/tpgZlN6y1WvV3NayHklvEYOpvWYENJlITQYLg5XptBrIk+g6mtTGVFojNMYH0f
	 k08K2sSlJ0/J3aq6my/f7r4uDwhlW8g15clSQ4VvKR/0ZgfPRWwuC2F48xkjZIw6dX
	 57HFiVyxHavVE/PKepqny3sH4DJ91vEiRpr6mCqisqmj08Gc+2CBOd1Z/MKUn0p7F3
	 5Eai81R5zHBiQ==
Date: Thu, 5 Nov 2026 17:03:03 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/7] zsmalloc: switch handle type to struct zs_handle
Message-ID: <auy19VvYgb25vnFc@google.com>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
 <20261105044752.1997895-4-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105044752.1997895-4-senozhatsky@chromium.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B7ACD20011
X-Stat-Signature: jpjroobs7bzpu9qu5mj6qjasab15ijb9
X-Rspam-User: 
X-HE-Tag: 1793898187-424237
X-HE-Meta: U2FsdGVkX18gpqwFqHvVd+GH/w+ff6JeSwvryWnFD6S/GxM+voUTBTsz1uBYXkv4HVm1e7OytkoJQYmtDH67ErMIpEskXBa1c6s+yTA+vv9KbHlDl6Z4RO/0Xk5cpG2pV8PjIV5/NwLNYa/zwulHmkUzX22k4kf8AvkYqHz/SeRLzwt7BVZwWUGUt2VBnaQYlhfbFAZPgA5dIzH72aXKb5mtNaBksa2xD3Ik6PGU0iwuzFc5/p92wl5ST8D+5vuikv83QKOt/XOR6SoJ7jfkkJMFe17/ro4e/TXc8XZ+0xd8D4FSzgNlu5YkuzjAgCZhqBPYYeOTFeV7qbRNKJt8lkhSTSTMIYw3hP9xyBDhvcpgJ75iZW+D7bP6bMHKJmoMrlFhOxJe+SHnlGP/Kq44O+30EFsjYRt/wSaKNXvZoWW2yjtP8qEti99qvGTc/yokCj3X9tzUGuGLk9eNhsK2aVNqLZwLFbpQ347Z14D/uHrIATAfQj5Bdc28jnTvQqN6HdaURFE+Huzo7/za6L8KeoHS2uV1iVp+32AGxbqQ4UZxfOriDetKw3vPKqXcwWCRppGidANnrPoMn0ASoG0qqg/z928wZVBUlCy/mTLoTrzv1A79GShUBLkpwmR8/j4OJvfW2HQNQ29BmQplyHEUOKDFjetohoCPLBpEqgZmMIurDGkAjFfE/BO9JIDDnJg5ODcmIKeIHsfUwrtR6ZtwNxBIv9Z3/VOUas64bQnRWQw5kn+uTuLXbKdDwQ8X/ULpNxxO8J7QY/Fve9VrpKZ04SkRBFznsrBFkPs3lx2T+5RFrwMwB6YSW7KU4Zi5fO1j1hSVvxVBhquR+pcU7+I/D1ug2WtoBTEsez13fjN4H5Y2Gbiiw4U8liscAoI3HaV70sx1BE6JgHHbimnhDDE70HK6328sXzjuJWIg8sAtQwJV+u3ust0o52+yGLdjJ49N4m0nGUyrgPVk8c39//m
 5B7NeLQi
 rJupm+V/sEhNuEXYphHksBChFHCd8bpZK3OUCPckwRCCmJHt6cSIl9fR1vbJRGmQkM40xpScm/Sai3g83xeUqHUFoPrufwwYWiifk1UyVdXAUb/DSkjOWPUm5dX/cnjcKnp9Lxm1qZOnPvIo1MXI+gv5//KwTAOiZVwzgbRszaqzeJr+7wLsdqHvU32+u9DpjiGVwGOWmmgP3VBjV03vo/S3IuxEEmw7yrBy/qZuCAbeahY25n3FqW2bAUJ5BbIAu95wr3GBbSQ2B6DqPBsnF0/kJeElssdr/Wlcj/P1TjJL9gN60Qm7ykXxxIBLlzEQfbaPLpRZViFrxPG0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[..]
> diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> index 5b7298a5026b..693c9484b638 100644
> --- a/include/linux/zsmalloc.h
> +++ b/include/linux/zsmalloc.h
> @@ -22,14 +22,15 @@ struct zs_pool_stats {
>  };
>  
>  struct zs_pool;
> +struct zs_handle;
>  struct scatterlist;
>  
>  struct zs_pool *zs_create_pool(const char *name);
>  void zs_destroy_pool(struct zs_pool *pool);
>  
> -unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags,
> -			const int nid);
> -void zs_free(struct zs_pool *pool, unsigned long obj);
> +struct zs_handle *zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags,
> +			    const int nid);
> +void zs_free(struct zs_pool *pool, struct zs_handle *handle);
>  
>  size_t zs_huge_class_size(struct zs_pool *pool);
>  
> @@ -40,10 +41,10 @@ unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size);
>  
>  void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
>  
> -void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
> +void zs_obj_read_sg_begin(struct zs_pool *pool, struct zs_handle *handle,
>  			  struct scatterlist *sg, size_t mem_len);
> -void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
> -void zs_obj_write(struct zs_pool *pool, unsigned long handle,
> +void zs_obj_read_sg_end(struct zs_pool *pool, struct zs_handle *handle);
> +void zs_obj_write(struct zs_pool *pool, struct zs_handle *handle,
>  		  void *handle_mem, size_t mem_len);

I would squash patch 7's constification here.

>  
>  extern const struct movable_operations zsmalloc_mops;
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 7ef80e0da626..7d8aab56f5cd 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -264,6 +264,10 @@ struct link_free {
>  	};
>  };
>  
> +struct zs_handle {
> +	unsigned long __private obj;
> +};
> +
>  static struct kmem_cache *handle_cachep;
>  static struct kmem_cache *zspage_cachep;
>  
> @@ -438,16 +442,16 @@ static void init_deferred_free(struct zs_pool *pool) {}
>  static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage) {}
>  #endif
>  
> -static unsigned long cache_alloc_handle(gfp_t gfp)
> +static struct zs_handle *cache_alloc_handle(gfp_t gfp)
>  {
>  	gfp = gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE);
>  
> -	return (unsigned long)kmem_cache_alloc(handle_cachep, gfp);
> +	return kmem_cache_alloc(handle_cachep, gfp);
>  }
>  
> -static void cache_free_handle(unsigned long handle)
> +static void cache_free_handle(struct zs_handle *handle)
>  {
> -	kmem_cache_free(handle_cachep, (void *)handle);
> +	kmem_cache_free(handle_cachep, handle);
>  }
>  
>  static struct zspage *cache_alloc_zspage(gfp_t gfp)
> @@ -466,9 +470,9 @@ static void cache_free_zspage(struct zspage *zspage)
>   * Pairs with READ_ONCE() in handle_to_obj(): zs_free() may read the
>   * handle locklessly, so prevent store tearing here.
>   */
> -static void record_obj(unsigned long handle, unsigned long obj)
> +static void record_obj(struct zs_handle *handle, unsigned long obj)
>  {
> -	WRITE_ONCE(*(unsigned long *)handle, obj);
> +	WRITE_ONCE(ACCESS_PRIVATE(handle, obj), obj);
>  }
>  
>  /* Protected by class->lock */
> @@ -817,13 +821,13 @@ static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int obj_idx
>  	return obj;
>  }
>  
> -static unsigned long handle_to_obj(unsigned long handle)
> +static unsigned long handle_to_obj(struct zs_handle *handle)
>  {
> -	return READ_ONCE(*(unsigned long *)handle);
> +	return READ_ONCE(ACCESS_PRIVATE(handle, obj));
>  }
>  
>  static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
> -				 unsigned long *phandle)
> +				 struct zs_handle **phandle)
>  {
>  	unsigned long handle;
>  	struct zspage *zspage = get_zspage(zpdesc);
> @@ -839,7 +843,7 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
>  		return false;
>  
>  	/* Clear all tags before returning the handle */
> -	*phandle = handle & ~OBJ_TAG_MASK;
> +	*phandle = (struct zs_handle *)(handle & ~OBJ_TAG_MASK);
>  	return true;
>  }

Would it be cleaerer if obj_allocated() just returned the handle here? I
believe this can be done separately in a prep patch.


