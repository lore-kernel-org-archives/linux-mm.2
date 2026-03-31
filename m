Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40F6D1061B39
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E64E6B0096; Tue, 31 Mar 2026 07:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD296B009D; Tue, 31 Mar 2026 07:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FA5A6B009E; Tue, 31 Mar 2026 07:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BE176B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:48:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE8E414013E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:48:46 +0000 (UTC)
X-FDA: 84606186252.24.D97A881
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1F97B40009
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:48:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qH+lWmDY;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774957725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Aw52YAuDxhZ/g4e4zwp8EqeNDbuPHuIPkJdArjeYzY=;
	b=mLPERWhxrda4fcZrwc0fJQEp3dC2dXCUXVItkKl0LF9jiHUA/EyQq+KPbbJ/TjpAWTfRl7
	c2gmQubMUCD7o0cR3Cf9NaZlXamTWFIRNr6/stacKz9s1HFSP01lSuHbxVHEOySTOp/UC8
	V8P0CMF++PYEsknJ+mfNIU33/COvtL0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qH+lWmDY;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774957725; a=rsa-sha256;
	cv=none;
	b=4PxbHdSaojXg/6EHNjf0eqRxzFTQS40o3FDIvGDReZy8+7R4ANIvMl4BhDw+vpAnwGPV1L
	56Q/bzZgS9/V9fzDdv/FW2K4K7o0sKmWBKCdYI/jghwAVoWbptJL8zNfejayXYrwqSES/e
	GMJrUrpBVhPQ5T9pHZ7kkC3zocQ0NAQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 121BE41708;
	Tue, 31 Mar 2026 11:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7772AC2BC9E;
	Tue, 31 Mar 2026 11:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774957723;
	bh=UbzwtiFI4elDO2ehY143SPhvyyOtbmJDip5hc70RcPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qH+lWmDYqwBLGcMXBzxy6RXjgL4K97AmcRwRsEq/1CMvCesL5ZZ+szGv2L8DNIURZ
	 HRGvEGwYgDMCe5y3QMwYZQeqk+W/UIVbwdN57Fc7mfE6En2wPrK10+bQfK72RxVBSz
	 XbfunX4ZYn1g1kzmFWevbfv1dVJIAr09jEfTY0ykzvC9vQaLjYKZTAyIfGZf/q5BAs
	 eutxQ/A/MG8D7oopemN4PoVsQ3VwyojuF2jMI/c6S7YK5HX1c5Xg1xJUNyFR+G3Zmi
	 3+zfaBcoF6aKf6xU4Q5MuFiAnjd2aNJHUysVFIrdYn/Tne2E9PltBbPK1OgS3wYVBU
	 mDHSC6Hd5YEMw==
Date: Tue, 31 Mar 2026 20:48:40 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH mm-stable v3] mm/memcontrol: batch memcg charging in
 __memcg_slab_post_alloc_hook
Message-ID: <acu0mGYGI6K_yTL1@hyeyoo>
References: <20260331091707.226786-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331091707.226786-1-hui.zhu@linux.dev>
X-Rspamd-Queue-Id: 1F97B40009
X-Stat-Signature: 4153m9q1finf7a6zf6q91is1c87df6om
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774957724-131324
X-HE-Meta: U2FsdGVkX1+JnA/zwMau/uZzvmfZtSCI7kA68jziVswKydNo3y8oAqHZzlYnEtQgyJGdqUS1NNqPcSLzI/M3T6ty+f9/2A1TFMUSbhwcC8HTOBssApK6YxJyDmiJxvn8DiHNWKdkd5ffYJj9KibvxckcSZObWyvG2BubsBT7NQFkzg0VmeIzEr0Gooku7r1cEbPDBJ/JHaXy5CCV8MfzC9ZGRFg9WUDPoj19s/QkMMlQTBvFo/QswWxS+Ryxn5BpMbuqx+7WnHiBauSCFZ0FwshSwFsLk+wY47y3OAzuiGlE0rjyETVLsGob3eEDMTB2fPFoO35IeFxxtmdWqIhrS3g9eq8PVzD54KPXsBXTS9ht2FwaqcBN0xIMoqCOkLAQdNko6ttN4PuuxgYoe8JtG16kzh0+/W2yDrjy5S8SKHoKsORwXKCfpNxW6gaOv00BvStjqxZDavhcu0nW1ymv96ydZRRYeUsoVscJhFdhklkZHp27QTc0bEzl3dWsLvGzEFExvCwAvBkoPyOPCrMAxNgQasNoa5ojgVRS6u8rKc+yUCl29e7MtVd4NT4r7SNG9ymq9AX9eg9tuzl+JVxtolyuxeeKw8zGl5FivuL6DxQY8NS/Iwrw9B7nCJOFhMiQNm7R1HJecNjFzNZXwZEs07z3riqZheUNcvtA3eGiuKzr5F7mVMXpFHL7Ufqkn3Wv2l6O+DHp8bXGcpAgyEDa+2ansqUsTkfWdjS6TZ6JOYKx15BWDYlOQntvmOf1eSHtZpJYm545VE7+OfDvfExhzGqE7DerDC41SFYONqKEOYrKBSmerkUUL8XRwFmwPtp0XoklG0seW0YZurRnBkCgHb+tKn0Q3zXdo10G6PkKx8bL3XS5813yvAYSfpI1Zi4bqyPdM9+RMwzhbcRbo0JhDzYM2zWtC/jx7ciD9P+mqD099NDdqvqtNKyXSybbM6oReIbUCJNsPCG3bCoLkUo
 IBL92nCO
 82A3bTW2B8uudawY0A0aF3aEnygIoZGISTrdVLPjLwvh5uNOMRdBGmWjIBv445Gnjm21FgVMW40tHeM6MT60stsGhvgsmsDqXAEGpvi/GG8I15aUICaSeYPB1XGhJiPMnL2imfZe4y8GgXUJDZDNfo5WapcRvpgPUCOphadS7LcvblhlzU/CHM1mVruBrYhZiLVRRYr+1erYugGZEFzaKjEHvonU9xzCuGOU6BhYt61zdce2bLO/Fe4nkg/ZfJGQs+hZlkcDhse6ZRrueO9Mn1/vZvxtZd0r7xii9cZsZyQ8x2B3Vmfbem8eiG/voRChwcPCYffINKOZzkW411zVjSOmNa34EHXf4ezmG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 05:17:07PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> When kmem_cache_alloc_bulk() allocates multiple objects, the post-alloc
> hook __memcg_slab_post_alloc_hook() previously charged memcg one object
> at a time, even though consecutive objects may reside on slabs backed by
> the same pgdat node.
> 
> Batch the memcg charging by scanning ahead from the current position to
> find a contiguous run of objects whose slabs share the same pgdat, then
> issue a single __obj_cgroup_charge() / __consume_obj_stock() call for
> the entire run. The per-object obj_ext assignment loop is preserved as-is
> since it cannot be further collapsed.
> 
> This implements the TODO comment left in commit bc730030f956 ("memcg:
> combine slab obj stock charging and accounting").
> 
> The existing error-recovery contract is unchanged: if size == 1 then
> memcg_alloc_abort_single() will free the sole object, and for larger
> bulk allocations kmem_cache_free_bulk() will uncharge any objects that
> were already charged before the failure.
> 
> Benchmark using kmem_cache_alloc_bulk() with SLAB_ACCOUNT
> (iters=100000):
> 
>   bulk=32  before: 215 ns/object   after: 174 ns/object  (-19%)
>   bulk=1   before: 344 ns/object   after: 335 ns/object  (  ~)
> 
> No measurable regression for bulk=1, as expected.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
> 
> Changelog:
> v3:
> Update base from "mm-unstable" to "mm-stable".
> v2:
> According to the comments in [1], add code to handle the integer
> overflow issue.
> 
> [1] https://sashiko.dev/#/patchset/20260316084839.1342163-1-hui.zhu%40linux.dev
> 
>  mm/memcontrol.c | 77 +++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 58 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 051b82ebf371..3159bf39e060 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3277,51 +3277,90 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>  			return false;
>  	}
>  
> -	for (i = 0; i < size; i++) {
> +	for (i = 0; i < size; ) {
>  		unsigned long obj_exts;
>  		struct slabobj_ext *obj_ext;
>  		struct obj_stock_pcp *stock;
> +		struct pglist_data *pgdat;
> +		int batch_bytes;
> +		size_t run_len = 0;

Let's initialize it to 1 to simplify the code. And perhaps the variable
could be renamed `batch_count` to align with `batch_bytes`.

> +		size_t j;
> +		size_t max_size;
> +		bool skip_next = false;
>  
>  		slab = virt_to_slab(p[i]);
>  
>  		if (!slab_obj_exts(slab) &&
>  		    alloc_slab_obj_exts(slab, s, flags, false)) {
> +			i++;
>  			continue;
>  		}
>  
> +		pgdat = slab_pgdat(slab);
> +		run_len = 1;

Hmm allocating 2GiB of memory at one kmem_cache_alloc_bulk() call sounds
already crazy, but if we have to check overflow anyway...

Could we simply skip the optimization
if check_mul_overflow(obj_size, size, &batch_bytes) returns nonzero?
It should be extremely unlikely to trigger anyway.

> +		/*
> +		 * The value of batch_bytes must not exceed
> +		 * (INT_MAX - PAGE_SIZE) to prevent integer overflow in

Since the vmstat data is cached at least once before it's flushed,
it isn't accurate to assume that stock->nr_slab_{un,}reclaimable will be
<= PAGE_SIZE.

So I think it's safe for `batch_bytes` to be INT_MAX but
__account_obj_stock() should check if it'll overflow before adding the
counter?

(but again that sounds quite theoretical and unlikely to hit in practice)

> +		 * the final accumulation performed by __account_obj_stock().
> +		 */
> +		max_size = min((size_t)((INT_MAX - PAGE_SIZE) / obj_size),
> +			       size);
> +
> +		for (j = i + 1; j < max_size; j++) {
> +			struct slab *slab_j = virt_to_slab(p[j]);
> +
> +			if (slab_pgdat(slab_j) != pgdat)
> +				break;
> +
> +			if (!slab_obj_exts(slab_j) &&
> +			    alloc_slab_obj_exts(slab_j, s, flags, false)) {
> +				skip_next = true;

Let's not micro-optimize it and drop skip_next.
In the next iteration of the outer loop it will be skipped anyway and
it's rare for alloc_slab_obj_exts() to fail.

> +				break;
> +			}
> +
> +			run_len++;
> +		}
> +
>  		/*
> -		 * if we fail and size is 1, memcg_alloc_abort_single() will
> +		 * If we fail and size is 1, memcg_alloc_abort_single() will
>  		 * just free the object, which is ok as we have not assigned
> -		 * objcg to its obj_ext yet
> -		 *
> -		 * for larger sizes, kmem_cache_free_bulk() will uncharge
> -		 * any objects that were already charged and obj_ext assigned
> +		 * objcg to its obj_ext yet.
>  		 *
> -		 * TODO: we could batch this until slab_pgdat(slab) changes
> -		 * between iterations, with a more complicated undo
> +		 * For larger sizes, kmem_cache_free_bulk() will uncharge
> +		 * any objects that were already charged and obj_ext assigned.
>  		 */
> +		batch_bytes = obj_size * run_len;
>  		stock = trylock_stock();
> -		if (!stock || !__consume_obj_stock(objcg, stock, obj_size)) {
> +		if (!stock || !__consume_obj_stock(objcg, stock, batch_bytes)) {
>  			size_t remainder;
>  
>  			unlock_stock(stock);
> -			if (__obj_cgroup_charge(objcg, flags, obj_size, &remainder))
> +			if (__obj_cgroup_charge(objcg, flags, batch_bytes, &remainder))
>  				return false;
>  			stock = trylock_stock();
>  			if (remainder)
>  				__refill_obj_stock(objcg, stock, remainder, false);
>  		}
> -		__account_obj_stock(objcg, stock, obj_size,
> -				    slab_pgdat(slab), cache_vmstat_idx(s));
> +		__account_obj_stock(objcg, stock, batch_bytes,
> +				    pgdat, cache_vmstat_idx(s));
>  		unlock_stock(stock);
>  
> -		obj_exts = slab_obj_exts(slab);
> -		get_slab_obj_exts(obj_exts);
> -		off = obj_to_index(s, slab, p[i]);
> -		obj_ext = slab_obj_ext(slab, obj_exts, off);
> -		obj_cgroup_get(objcg);
> -		obj_ext->objcg = objcg;
> -		put_slab_obj_exts(obj_exts);
> +		for (j = 0; j < run_len; j++) {
> +			slab = virt_to_slab(p[i + j]);
> +			obj_exts = slab_obj_exts(slab);
> +			get_slab_obj_exts(obj_exts);
> +			off = obj_to_index(s, slab, p[i + j]);
> +			obj_ext = slab_obj_ext(slab, obj_exts, off);

> +			obj_cgroup_get(objcg);

This could be batched by calling:
		obj_cgroup_get_many(objcg, batch_count);

> +			obj_ext->objcg = objcg;
> +			put_slab_obj_exts(obj_exts);
> +		}
> +
> +		if (skip_next)
> +			i = i + run_len + 1;
> +		else
> +			i += run_len;

With the suggestion above this could be `i += batch_count;`

>  	}
>  
>  	return true;

To sum up... something like this?

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3d98ab41f1f..3252252ea9c3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3184,8 +3184,12 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
 		*bytes = nr;
 		nr = 0;
 	} else {
-		*bytes += nr;
-		if (abs(*bytes) > PAGE_SIZE) {
+		int old = *bytes;
+
+		if (unlikely(check_add_overflow(old, nr, bytes))) {
+			*bytes = nr;
+			nr = old;
+		} else if (abs(*bytes) > PAGE_SIZE) {
 			nr = *bytes;
 			*bytes = 0;
 		} else {
@@ -3422,6 +3426,8 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	struct slab *slab;
 	unsigned long off;
 	size_t i;
+	int batch_bytes;
+	bool skip_batching = false;

 	/*
 	 * The obtained objcg pointer is safe to use within the current scope,
@@ -3455,51 +3461,77 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 			return false;
 	}

-	for (i = 0; i < size; i++) {
+	if (check_mul_overflow(obj_size, size, &batch_bytes))
+		skip_batching = true;
+
+	for (i = 0; i < size; ) {
 		unsigned long obj_exts;
 		struct slabobj_ext *obj_ext;
 		struct obj_stock_pcp *stock;
+		struct pglist_data *pgdat;
+		size_t batch_count = 1;
+		size_t j;

 		slab = virt_to_slab(p[i]);
-
 		if (!slab_obj_exts(slab) &&
 		    alloc_slab_obj_exts(slab, s, flags, false)) {
+			i++;
 			continue;
 		}

+		pgdat = slab_pgdat(slab);
+
+		if (likely(!skip_batching)) {
+			for (j = i + 1; j < size; j++) {
+				struct slab *slab_j = virt_to_slab(p[j]);
+
+				if (slab_pgdat(slab_j) != pgdat)
+					break;
+
+				if (!slab_obj_exts(slab_j) &&
+				    alloc_slab_obj_exts(slab_j, s, flags, false))
+					break;
+
+				batch_count++;
+			}
+		}
+
 		/*
-		 * if we fail and size is 1, memcg_alloc_abort_single() will
+		 * If we fail and size is 1, memcg_alloc_abort_single() will
 		 * just free the object, which is ok as we have not assigned
-		 * objcg to its obj_ext yet
-		 *
-		 * for larger sizes, kmem_cache_free_bulk() will uncharge
-		 * any objects that were already charged and obj_ext assigned
+		 * objcg to its obj_ext yet.
 		 *
-		 * TODO: we could batch this until slab_pgdat(slab) changes
-		 * between iterations, with a more complicated undo
+		 * For larger sizes, kmem_cache_free_bulk() will uncharge
+		 * any objects that were already charged and obj_ext assigned.
 		 */
+		batch_bytes = obj_size * batch_count;
 		stock = trylock_stock();
-		if (!stock || !__consume_obj_stock(objcg, stock, obj_size)) {
+		if (!stock || !__consume_obj_stock(objcg, stock, batch_bytes)) {
 			size_t remainder;

 			unlock_stock(stock);
-			if (__obj_cgroup_charge(objcg, flags, obj_size, &remainder))
+			if (__obj_cgroup_charge(objcg, flags, batch_bytes, &remainder))
 				return false;
 			stock = trylock_stock();
 			if (remainder)
 				__refill_obj_stock(objcg, stock, remainder, false);
 		}
-		__account_obj_stock(objcg, stock, obj_size,
-				    slab_pgdat(slab), cache_vmstat_idx(s));
+		__account_obj_stock(objcg, stock, batch_bytes,
+				    pgdat, cache_vmstat_idx(s));
 		unlock_stock(stock);

-		obj_exts = slab_obj_exts(slab);
-		get_slab_obj_exts(obj_exts);
-		off = obj_to_index(s, slab, p[i]);
-		obj_ext = slab_obj_ext(slab, obj_exts, off);
-		obj_cgroup_get(objcg);
-		obj_ext->objcg = objcg;
-		put_slab_obj_exts(obj_exts);
+		obj_cgroup_get_many(objcg, batch_count);
+		for (j = 0; j < batch_count; j++) {
+			slab = virt_to_slab(p[i + j]);
+			obj_exts = slab_obj_exts(slab);
+			get_slab_obj_exts(obj_exts);
+			off = obj_to_index(s, slab, p[i + j]);
+			obj_ext = slab_obj_ext(slab, obj_exts, off);
+			obj_ext->objcg = objcg;
+			put_slab_obj_exts(obj_exts);
+		}
+
+		i += batch_count;
 	}

 	return true;
--
2.43.0

-- 
Cheers,
Harry / Hyeonggon

