Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD566CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 07:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6F76B0005; Wed, 27 May 2026 03:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF626B008A; Wed, 27 May 2026 03:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B7E6B008C; Wed, 27 May 2026 03:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D03226B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:53:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6AD0F8E756
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:53:07 +0000 (UTC)
X-FDA: 84812434014.21.213041C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9F0FB1C000B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:53:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y/LoAvJP";
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779868385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+kGq0uunmREFgzVVLHHxPdC664CmUzrN4A02+MaM5c=;
	b=3J05Egn71G2J3bvqTc6PbBawCZfufW3grTfzCZeT/pOo9luTdyP0Z1lhllVmuvKBuJQQ23
	j0RTnGYP+GyQdWf8LmxUU3UOuNLYagvQkijmfCJSu3dOSCJk/wMX6Ky8CFLDEzILn+JPVx
	B3hf3qfQPSa8EN2gg2Zk8XCurNNLtgc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y/LoAvJP";
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779868385; a=rsa-sha256;
	cv=none;
	b=t0mmkRafY2ugk5FWYrMohaekOEk0r7CcrmlzvgVo4HGpquopsfGcZn8L6LAZ/rh69XILq2
	0Vg93fQQ4Svi0LcKcDH00seBUb/Z9ysG2XAs4HmXP5cujAVRXwcD/+tL9Dk01nA3XuDqPM
	kU5ii43yHOOnitrKw1X1xkcqzCvTXEw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D67941AD2;
	Wed, 27 May 2026 07:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF041F000E9;
	Wed, 27 May 2026 07:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779868384;
	bh=Y+kGq0uunmREFgzVVLHHxPdC664CmUzrN4A02+MaM5c=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Y/LoAvJPd3wM9J66save3K6aXvb9rA0mMByndjKNrGjyUpfzpPle8B7OLNvHCqtKg
	 q7BGrOHY8N0MHjNtOcbmzF0zQhT4xSCFSscIbWL7kmkUaGCge8m7D3HTPOroftHtlV
	 1Q5YY+9ivs21hp4cFgJyRDziiCPltn4FSaPHz6AMCBGz7DE3IeLw1yK9B7vvkqsGa7
	 Mxw7Kr0JgyEv1n38pCyiiHR3id5tkI/HG589dmSHxuATcIQ9/yE06ZAXRNRYIsDY/S
	 m3h6OUojhIoGQAAez+DI/K0q08EYGW28qS67jpy1c6z33xfTR/Ii1mfqznW5u2+/ou
	 j2P1mnPXDtjbw==
Content-Type: multipart/mixed; boundary="===============2215855977696880001=="
MIME-Version: 1.0
Message-Id: <582275f111aae9b0fb4520a98c60b5014751114022782c3aadeced2c21cbb3c7@mail.kernel.org>
In-Reply-To: <20260527070239.2252948-2-hch@lst.de>
References: <20260527070239.2252948-2-hch@lst.de>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
From: bot+bpf-ci@kernel.org
To: hch@lst.de,vbabka@kernel.org,harry@kernel.org,akpm@linux-foundation.org
Cc: hao.li@linux.dev,cl@gentwo.org,rientjes@google.com,roman.gushchin@linux.dev,hawk@kernel.org,linux-arm-msm@vger.kernel.org,dri-devel@lists.freedesktop.org,freedreno@lists.freedesktop.org,linux-kernel@vger.kernel.org,linux-mm@kvack.org,io-uring@vger.kernel.org,kasan-dev@googlegroups.com,bpf@vger.kernel.org,netdev@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 27 May 2026 07:53:04 +0000 (UTC)
X-Rspamd-Server: rspam12
X-Stat-Signature: qu54n8f1wrpcu965nz49un46u33rw9gm
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F0FB1C000B
X-HE-Tag: 1779868385-409772
X-HE-Meta: U2FsdGVkX18buXKTwZ8ls8GFtHac8KHk2LqsWOpN2o3lqYArprXb2p44v3KpJBmc2Rcfn8+/ZMh0x9L9LHS3lzZdSFmbidniibtRa0tqjCWY6IlGIa//GZriPdmEXiRLn0v6GgGkDqG6UWZOeQPEjUBK1xmA5LSI+sNeYcySWSfcsK6cWbrJUyhHafNybbs9TJpGzPTYI4VUs6W920rS4NAQTrC0mTId8w83V0wg8717fAPKMxCETwdSlY6QoLPGiaIqSEyKGIxXL4HXM0ebJDdlmpfM0EL1glvEW5q/bx+r9J9cB93zmbzuJb7LLyamORVJnl07neORAo33UmkFnCLqADeKemCkrhCJwm9wUTa9lPQoHrmQMXO31iLyImfJBpvF2Ln1G20rhXEt8aCA/HT3VGfopgTfhQpHtvlD1GtX3RaRkw2daQNq1UdJOBv0RAnvIxjLqK2oz4h4y6sIbCQIqKpyzY2fPdvqJHjK0JKTmaID++bYftwpDkijtHa2QEEaMxiv4iFBSBWvSqLpz3iN1YwRj9B60uYEfy+Hpvo/Q/R6sHDbPwQuKviy5KcSxHHCuucFbTCFCDUyZZW1PBowrmqlXZNa+lw+6/cZr773LTzaCHF2ttBlCzfyBFrM1evdtDi30JqQoGQMJqkMhXxVlJCkaSW54N56PxoL9zS8wDTFpHPKCi2L4C7ZY+qYK+qE6Hl1rr5LxlSr9Y4JLDX8rqlsYD/25k4RpW6UdaIsFxLwUKL+41/M/2MNS5/tHwoLi8SQNzZlcIS1VtjgCGduZu2Oj1lFRKlN46gt1cF1HaZuaSeS/iiHq6+vMzM6yaENXSa7ZqyhjZ7aXWDZT0FxyY+zyhrNqYcLKu8ovoRXJOB8Zy3kyhkozPcedLQBsxCBP13D4suDZDLICW6F9b3JUMJdBoyNQQ/pZsy+5EH8DbGmsm13dpOE0/LpVs5t5Nh4/3TkRHJtHldk7KC
 6XMoKODp
 kMJJPbjU3b0jVuIhEbXCI/NGruB+IkzUYTfJqt8RfyUSe3WcupQLtiY/bRYCicU6hJGN/VCbhjLyeseLgiiFYdRp7oGaHLrC8Iz/6JiHF6oC8HVCxAiEJO9AoJrShRuprpgMGoNGfaMLOoYWA3Utn8BaFyfF2miZ3z+9CLlNRRzQN1FfhgfGkJcu4Az8E8j1lqbY2Xs3ny01B2ExOzdTsB2NSBsOK0H75pDSaQxatr9BOFIGSS+ePXzNAo8YPuwVu+HAf0eunIju+W91SC+ssybmkqSMbhp+49sxtlDHDOYpXhT2AqyoA/UrIPmbWsUFOsCVnwhncK5qdLcKaJA81SBBMFN+ZoD4P4u9EA96aft/2H6pk3XUn2q4kjNwH7H8Gm4iqU96VNUHiioglcSuBtmz9uhMBvEc+4OnRsYqwI3i8t5QZZTs2tz0xhid9kHLbJa16Wi3RLNs2H+DfsmbqVbBBE4YAQ6TMdeYjZvR+ZHeERhjKdPGPODuYG079laKAR/ACLrhu1SEC0HoaaujXy64VeY0nQh6cca8YiYg0ajCJhs5N0gj4sGVREUluzTz1T9MamhZc866ha7atPBenBvtjzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============2215855977696880001==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
> index 75d98dad7b1d..b80d7e1d5123 100644
> --- a/drivers/gpu/drm/panthor/panthor_mmu.c
> +++ b/drivers/gpu/drm/panthor/panthor_mmu.c
> @@ -1274,10 +1274,9 @@ static int panthor_vm_prepare_map_op_ctx(struct panthor_vm_op_ctx *op_ctx,
>  		goto err_cleanup;
>  	}
>
> -	ret = kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, pt_count,
> -				    op_ctx->rsvd_page_tables.pages);
> -	op_ctx->rsvd_page_tables.count = ret;
> -	if (ret != pt_count) {
> +	if (!kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, pt_count,
> +			op_ctx->rsvd_page_tables.pages)) {
> +		op_ctx->rsvd_page_tables.count = 0;
>  		ret = -ENOMEM;
>  		goto err_cleanup;
>  	}

Does this omit setting op_ctx->rsvd_page_tables.count to pt_count on success?

Since op_ctx is initialized via memset previously, the count will remain 0 when
the allocation succeeds. This could lead to memory leaks when these page tables
are consumed or cleaned up later, since the cleanup code won't know about the
allocated page tables.

The original code set the count to ret on both success and failure. The
updated code only sets count = 0 in the failure path, but doesn't set
count = pt_count in the success path.

[ ... ]

> diff --git a/lib/test_meminit.c b/lib/test_meminit.c
> index 6298f66c964b..3727dee7c262 100644
> --- a/lib/test_meminit.c
> +++ b/lib/test_meminit.c
> @@ -229,14 +229,12 @@ static int __init do_kmem_cache_size(size_t size, bool want_ctor,
>  	for (iter = 0; iter < 10; iter++) {
>  		/* Do a test of bulk allocations */
>  		if (!want_rcu && !want_ctor) {
> -			int ret;
> -
> -			ret = kmem_cache_alloc_bulk(c, alloc_mask, BULK_SIZE, bulk_array);
> -			if (!ret) {
> +			if (!kmem_cache_alloc_bulk(c, alloc_mask, BULK_SIZE,
> +					bulk_array)) {
>  				fail = true;
>  			} else {
>  				int i;
> -				for (i = 0; i < ret; i++)
> +				for (i = 0; i < BULK_SIZE; i++)
>  					fail |= check_buf(bulk_array[i], size, want_ctor, want_rcu, want_zero);
>  				kmem_cache_free_bulk(c, ret, bulk_array);
>  			}

Will this cause a compilation error?

The local variable ret is removed from this scope, but it's still used in the
kmem_cache_free_bulk() call. This should fail to compile because ret is
undeclared.

The fix should probably replace ret with BULK_SIZE in the free call:

	kmem_cache_free_bulk(c, BULK_SIZE, bulk_array);


> @@ -354,17 +352,18 @@ static int __init do_kmem_cache_size_bulk(int size, int *total_failures)
>
>  	c = kmem_cache_create("test_cache", size, size, 0, NULL);
>  	for (iter = 0; (iter < maxiter) && !fail; iter++) {
> -		num = kmem_cache_alloc_bulk(c, GFP_KERNEL, ARRAY_SIZE(objects),
> -					    objects);
> -		for (i = 0; i < num; i++) {
> +		if (!kmem_cache_alloc_bulk(c, GFP_KERNEL, ARRAY_SIZE(objects),
> +				objects))
> +			continue;
> +
> +		for (i = 0; i < ARRAY_SIZE(objects); i++) {
>  			bytes = count_nonzero_bytes(objects[i], size);
>  			if (bytes)
>  				fail = true;
>  			fill_with_garbage(objects[i], size);
>  		}
>
> -		if (num)
> -			kmem_cache_free_bulk(c, num, objects);
> +		kmem_cache_free_bulk(c, num, objects);
>  	}
>  	kmem_cache_destroy(c);
>  	*total_failures += fail;

Is num uninitialized here?

It's no longer assigned the result of the allocation call. Passing it to
kmem_cache_free_bulk() will use indeterminate stack data, which could lead to
memory corruption. The fix should probably be:

	kmem_cache_free_bulk(c, ARRAY_SIZE(objects), objects);

[ ... ]

> diff --git a/mm/slub.c b/mm/slub.c
> index a2bf3756ca7d..d9790e7c17f6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c

[ ... ]

> @@ -7352,18 +7362,18 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
>  	 */
>  	unsigned int i = 0;
>  	void *kfence_obj;
>
>  	if (!size)
> -		return 0;
> +		return false;

Does this incorrectly report an allocation failure when size is 0?

Previously, callers interpreting the return value against size (ret != size)
would treat 0 objects allocated for a request of 0 as a success. Returning
false here contradicts the typical kernel behavior where allocating 0 items is
a successful no-op.

This might cause callers to incorrectly abort with an error when they request
0 objects, which should be a valid no-op case.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26496962101
--===============2215855977696880001==--

