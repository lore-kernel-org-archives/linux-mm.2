Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3CE0606A68E
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 04:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dHE5kvuJ
Received: by kanga.kvack.org (Postfix)
	id E00626B05B3; Fri, 20 Nov 2026 23:20:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7AA6B05B4; Fri, 20 Nov 2026 23:20:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D149B6B05B5; Fri, 20 Nov 2026 23:20:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 979106B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:20:10 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 745E6160329
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 04:20:09 +0000 (UTC)
X-FDA: 85457823738.26.6E9DA3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B75F340003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 04:20:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dHE5kvuJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795234807;
	b=bMs4YR1WvMuWKGIQEFe3TK7uEQfzgfYTzEK/uq7DH2x8mfb2zXD3HvnuchFrvRBWBTLmg+
	1cJ2NPM2ZXvyt8ozXSxPwLfif07cHkFt3vjQK7VXLCL9LCUXcmv/hUFmsd7pZ2Xg8pi5Uv
	kHwZa1jQFtyooiWtydK5NcE6Flwid5E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795234807;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ZqbbDSjke+XMJ3ebFLBEmOYyidYIFJAnfBofycZOb8=;
	b=cmGgWxs5Man0Jrq68GN9HGcSIe7WmDqU8BS8BPeKpaq1PIIRJYTAsq56mTmy1WIYl7eLRS
	0xze57S4b70Lm9lWBSTU/Tw2odZ4DrEk60d7u0pZL9+u6WBqfHedZFmY6AEJnpFn/IWB5/
	wo3c4ZFY5x9EdhHRgsLbBABc61GHibw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dHE5kvuJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 106A54049E;
	Sat, 21 Nov 2026 04:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646721F000C0;
	Sat, 21 Nov 2026 04:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795234806;
	bh=8ZqbbDSjke+XMJ3ebFLBEmOYyidYIFJAnfBofycZOb8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dHE5kvuJY5/LeYveUlenuretLxiRsnhTU576aiX7Voj9dKn4BshHsU8K03gyizSM2
	 NCfy+T43GbQ/ZsGJMgG1oAB4IsBm+5VFEozoRSXZxFKqgsXpza6leHoxETCWLTeHvf
	 kZnVF5WKV8lF1APrsZYaSyvjqUBSCrOz0rW3j/3ts9hwdbJYfBbL5CQBPvPlCGRbim
	 o1BXuTsLFd1Rc7PvUad15wIUorvA1Up411QtkkQmsXl0hNmvGO7CUZXA6FJlZdrukt
	 cup+zwO67wRNB9inCdy2nRJWD893Ts97kPtMtlLr5bjGvMexeg+7z+4jociWt05NFC
	 i10YDnnNf8baw==
Message-ID: <sashiko-outbox-226638@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 8/8] mm: zswap: Batched zswap_compress() for storing
 large folios in batches.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261120041906.5785-9-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-9-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 04:20:06 +0000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B75F340003
X-Rspam-User:
X-Stat-Signature: rtaizbqq9uqt9gp6sumd5bfonmj784na
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795234807-959387
X-HE-Meta: U2FsdGVkX1/nXTVHOJG7zP25St8OxJXpe5EzPQolKlgk+1nsQSa/iahtp3Iy1NyyB4cYAPrAmOJhIpy+CDd2wnNAGsGhUahmJYptyOehdat+NpRxg2d0+bFT5cYP6aqQPp80qy2j28ta3d4a1duWFCSnw6iAfwyofAtxYBCArre49YKkXk+fcetnUAjT/snlHjXcgB60qmjCxHZd4RxqfiMkYWyC2xkJE06cQEV9Gtc4y5jEEq/N+NNCsq/jZmMBTGQFju4/6vNMMCvY9nCbmJDM0ZhDr5SOFGVnO67j/BFKFb4JT06lPDaKVcND5uJJxLqxi/7K6QqFAUDSJDIj/gffGzavlaK078zgR6LeXRXW5Q6ZvTZbaf/4iKYA/o26rauqRWOxsUpUSOYP9D4ul57MMlpR+srr5hf1kLqsqMwnz2AWUSURb0IDPgxFQcPqNuzr+/ftqcVwxa3tsElGAx00r95O06ByI0nkJ1tgu2s1vAwH7vARDdXy0vo7iyZREkAKqm+EmIzkCmd2HLNtHwR2mn1AmZtb/kH7EH/qrJGo0MopfzIjk6mu9lN3dL1Vv6ZYVbasZG9f+lCoY8SJOnxGENEaI/XU5wT5hFyCpZGwcbQTsFeyRms8il917E5ITpB72DbtHilZ6JK2AZuR6w8X8X1x759+fx4aeUIORn06KWcTKjMMsLSbmV2lMGdwXu1xqF0bThPGwjiVVv5fqMnIqgQ4uWKasnPpU21p1k//MZShuWIkblk3LncBv7L5hTdaG/41dF8Av658P3eb2kTDycS98hkiYn/6ChclR96hOHRw2EeenDroQY+U5yrYRN1Ls9WwXJjJnh9c487R3ODHN5ZjJXg0LpAHgYdNwl5hQvjp3UILKE59X+nR42LXO7z+EMFuVS/eSiaTkRdFdG+F1Vw4n+J1eRdTTsdStXalZW+34BvA+M2IdKSTfROgVtXDdF3p3Ueq2Q51JDP
 swIQmN+m
 7wgboyyLNnxt+NbzIYogmrwoQowL603UuMfDPhwKct+eWjbtN7W7nA/fbw09jUb1AP4twiRerDU+PydFGDkJlQGnaDlPDgJlpqZB4ri+1/Lw5NM4i5j4SNYllrrPfq8YvQxJuPIkpQX7u7GlGbnCCyaqXp2u9gO8CvL9NHp4Z7Rv/kzuyQoRZFejiaVFTwrctdtZ+v9JzMx83007arlJkSNfjXYLdS4cJLyyMiV2Hpqg0GzYRFmUnu8L5zFuZqKnNsOIg54A+W2yJ8wD5wVGSRqj8KACRF3x/6yGI3lbL5TNbMKdlK4be52xztIL/WvO9N8bqYVSouC9L+Bu+jEfzJfYeH7Do9sfKiP2r3PfpmJMZGB0HEKXY3zQeRnr4s3xGRpWP/1qOq+eN8MCvGNsNUJ4XwcN3n5zmrUwDPmMeiAHqIl+/G2eB6xu1E4oNWie6glT1dKw6l0fhj71+Uj8zxI1SBC0HM9p/6P3KaR3rCLp4WyWkp0eDs3qwnC55cEzgqfKyK/df2UYdNlbAIY+f7e9G8P7pu5zgNxb+c2DmTrvpL93uFsY40hUKckFE409UETwutavTnOmAzgi/31gdCopMT2ZtnPXtL0WaZCqPve+7xJbNzND8QYbf3EfoNweebelgxu554dSbHuOmhle4/GgPpWFgdm+2JKtKak+Cd3imCz05OEl3E+wob/ATqRD/1NM6NsdtUDnKHzN35I1DovFY/e568fwDMyWeEYhiBcG6WmhQr8XTPawrhDW2drHX4fGQ8yFShNZ2DSeUdpgJSctdwC7FLMPp/eylh720JGpZkUpqJW0p6B4jlrw26UfvyceONNZBeLaTYf6diAJmShrng5GcQRUr6/uGnVISAIojEz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] mm: zswap: invalid and unreset dst scatterlist lengths in
  zswap_compress()
- [High] mm: zswap: unterminated dst scatterlist slice passed in
  zswap_compress()
- [Medium] mm: zswap: unsigned sg->length check and error accounting in
  zswap_compress()
--

commit a77cc3e636d5134b6371aa977bb1025c031583c2
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Batched zswap_compress() for storing large folios in batches.

This commit replaces the per-page zswap_compress() call in
zswap_store_pages() with a batched zswap_compress() and
zswap_update_entries() that compress up to ZSWAP_MAX_BATCH_SIZE pages per
batch using a per-CPU scatterlist table mapped to destination buffers.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5e1fb5624ffb8..56354a568bad0 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
[ ... ]
> @@ -949,6 +971,26 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, =
struct hlist_node *node)
>  		}
>  	}
> =20
> +	acomp_ctx->comp.sg_table =3D kmalloc(sizeof(*acomp_ctx->comp.sg_table),
> +					   GFP_KERNEL);
> +	if (!acomp_ctx->comp.sg_table) {
> +		ret =3D -ENOMEM;
> +		goto req_fail;
> +	}
> +
> +	if (sg_alloc_table(acomp_ctx->comp.sg_table, ZSWAP_MAX_BATCH_SIZE,
> +			   GFP_KERNEL)) {
> +		ret =3D -ENOMEM;
> +		goto req_fail;
> +	}
> +
> +	/*
> +	 * Statically map the per-CPU destination buffers to the per-CPU
> +	 * SG lists; crucial for performance.
> +	 */
> +	for_each_sg(acomp_ctx->comp.sg_table->sgl, sg, ZSWAP_MAX_BATCH_SIZE, i)
> +		sg_set_buf(sg, acomp_ctx->comp.buffers[i], PAGE_SIZE);
> +
[ ... ]
> @@ -965,88 +1007,179 @@ static int zswap_cpu_comp_prepare(unsigned int cp=
u, struct hlist_node *node)
[ ... ]
> +static bool zswap_compress(struct zswap_store_context *zc)
> +{
> +	u8 nr_batch_pages, batch_start, comp_batch_iter;
> +	struct scatterlist *sg, *dst_sg;
> +	unsigned int slen;
> +	int err;
> =20
>  	/*
> +	 * @nr_batch_pages is constrained by the per-CPU comp_ctx's compressor
> +	 * batch size and the @zc->nr_pages in this store batch. @slen indicates
> +	 * the total source length bytes for @nr_batch_pages.
>  	 */
> +	nr_batch_pages =3D min(zc->comp_ctx->compr_batch_size, zc->nr_pages);
> =20
>  	/*
> +	 * Compress the @nr_pages in @folio starting at index @folio_start
> +	 * in batches of @nr_batch_pages.
>  	 */
> +	for (batch_start =3D 0; batch_start < zc->nr_pages;
> +	     batch_start +=3D nr_batch_pages) {
> +		/*
> +		 * Clamp the last iteration's batch size if the compressor's
> +		 * batch_size does not evenly divide @zc->nr_pages.
> +		 */
> +		nr_batch_pages =3D min(nr_batch_pages, zc->nr_pages - batch_start);
> +		slen =3D nr_batch_pages * PAGE_SIZE;
> +
> +		/*
> +		 * Send @nr_batch_pages to crypto_acomp for compression:
> +		 *
> +		 * These pages are in @zc->folio's range of indices in the
> +		 * interval:
> +		 *     [@zc->folio_start + @batch_start,
> +		 *      @zc->folio_start + @batch_start + @nr_batch_pages).
> +		 *
> +		 * The source folio pages in the batch are directly submitted to
> +		 * crypto_acomp via acomp_request_set_src_folio().
> +		 */
> +		acomp_request_set_src_folio(zc->comp_ctx->areq.req, zc->folio,
> +				(zc->folio_start + batch_start) * PAGE_SIZE,
> +				slen);
> +
> +		dst_sg =3D zc->comp_ctx->sg_table->sgl + batch_start;
> +		dst_sg->length =3D slen;

[Severity: High]
Does setting only dst_sg->length =3D slen overrun acomp_ctx->comp.buffers[]
and leave dst_sg[1 .. nr_batch_pages - 1].length uninitialized when
nr_batch_pages > 1?

Each entry in acomp_ctx->comp.sg_table->sgl is mapped to a single
PAGE_SIZE buffer in acomp_ctx->comp.buffers[i], and earlier runs overwrite
each entry's sg->length with compressed lengths or negative error codes.
When a batching compressor runs with nr_batch_pages > 1, dst_sg[0].length
is set to nr_batch_pages * PAGE_SIZE (exceeding its PAGE_SIZE buffer),
while dst_sg[1 .. nr_batch_pages - 1].length are not reset to PAGE_SIZE.
If the compressor fails when zc->wb_enabled is true without updating
dst_sg[1 .. nr_batch_pages - 1].length, any entry still holding a stale
compressed length (0 < sg->length < PAGE_SIZE) from a previous call will
skip the PAGE_SIZE fallback and cause zswap_update_entries() to store
stale data from the previous folio.

Each of the nr_batch_pages scatterlist entries in dst_sg needs its length
reset to PAGE_SIZE before crypto_acomp_compress().

> +
> +		/*
> +		 * The per-CPU @zc->comp_ctx->sg_table scatterlists are statically
> +		 * mapped to the per-CPU dst @buffers at pool creation time.
> +		 * There are ZSWAP_MAX_BATCH_SIZE per-CPU SG lists and dst
> +		 * buffers allocated for all compressors.
> +		 */
> +		acomp_request_set_dst_sg(zc->comp_ctx->areq.req, dst_sg, slen);

[Severity: High]
Isn't dst_sg an unterminated scatterlist slice whenever
batch_start + nr_batch_pages < ZSWAP_MAX_BATCH_SIZE?

sg_alloc_table() only sets SG_END on sgl[ZSWAP_MAX_BATCH_SIZE - 1], so
passing dst_sg as req->dst leaves sg_nents(req->dst) equal to
ZSWAP_MAX_BATCH_SIZE - batch_start (4, 3, or 2 instead of nr_batch_pages).
In-tree hardware acomp drivers rely on sg_nents(req->dst):
iaa_comp_acompress() falls back to software deflate whenever
sg_nents(req->dst) > 1 (affecting all order-0 folios and 3 of every 4
pages in a batch), while __qat_bl_sgl_to_bufl() and
hisi_acc_sg_buf_map_to_hw_sgl() walk and DMA-map all sg_nents(req->dst)
entries up to sgl[3] using their sg->length fields, which can still hold a
negative errno such as (unsigned int)-ENOSPC (~4 GiB) left behind by a
prior failed batch.

> +
> +		err =3D crypto_wait_req(crypto_acomp_compress(zc->comp_ctx->areq.req),
> +				      &zc->comp_ctx->areq.wait);
> +
> +		/*
> +		 * If a page cannot be compressed into a size smaller than
> +		 * PAGE_SIZE, save the content as is without a compression, to
> +		 * keep the LRU order of writebacks.  If writeback is disabled,
> +		 * reject the page since it only adds metadata overhead.
> +		 * swap_writeout() will put the page back to the active LRU list
> +		 * in the case.
> +		 */
> +		if (err && !zc->wb_enabled)
> +			goto compress_error;
> +
> +		/*
> +		 * For each output SG list in @acomp_ctx->req->sg_table->sgl,
> +		 * the @sg->length should be set to either the page's compressed
> +		 * length (success), or it's negative value compression error.
> +		 */
> +		for_each_sg(dst_sg, sg, nr_batch_pages, comp_batch_iter) {
> +			if (((int)sg->length <=3D 0) || (sg->length >=3D PAGE_SIZE)) {
> +				if (!zc->wb_enabled) {
> +					if (sg->length =3D=3D PAGE_SIZE)
> +						sg->length =3D -ENOSPC;
> +					else if (WARN_ON_ONCE(!sg->length || sg->length > PAGE_SIZE))
> +						sg->length =3D -EINVAL;
> +					goto compress_error;
> +				}
> +
> +				sg->length =3D PAGE_SIZE;
> +			}
> +		}
>  	}
> =20
> +	return zswap_update_entries(zc);
> =20
> +compress_error:
> +	for_each_sg(dst_sg, sg, nr_batch_pages, comp_batch_iter) {
> +		if ((int)sg->length < 0) {
> +			if ((int)sg->length =3D=3D -ENOSPC)
> +				zswap_reject_compress_poor++;
> +			else
> +				zswap_reject_compress_fail++;
> +		}
> +	}
> =20
> +	return false;
>  }

[Severity: Medium]
Won't evaluating sg->length > PAGE_SIZE on an unsigned int trigger
WARN_ON_ONCE() whenever sg->length holds a negative error code?

Because sg->length is unsigned, a negative error code in sg->length (such
as -ENOSPC from a failed page in a batch) satisfies sg->length > PAGE_SIZE
when !zc->wb_enabled, firing a spurious WARN_ON_ONCE() and overwriting the
error code with -EINVAL so compress_error increments
zswap_reject_compress_fail instead of zswap_reject_compress_poor.
Conversely, if crypto_acomp_compress() returns an early request-level
error in err before writing negative error codes into dst_sg->length,
jumping to compress_error leaves all sg->length values positive and
returns false without incrementing either rejection counter.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120041906.5785=
-1-kanchanapsridhar2026@gmail.com?part=3D8

