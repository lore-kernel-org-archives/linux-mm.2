Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4495ECE7AA3
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 09:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93C2A8E000E; Fri, 14 Nov 2025 04:59:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC7C8E0002; Fri, 14 Nov 2025 04:59:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB178E000E; Fri, 14 Nov 2025 04:59:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 644668E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:59:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01F57C02B8
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:59:35 +0000 (UTC)
X-FDA: 84108765552.15.EDC384C
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf12.hostedemail.com (Postfix) with ESMTP id 205E04000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:59:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=LqnKDYHJ;
	spf=pass (imf12.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763114374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2r/Q/+wRJ2BFr/BHn0s3SothtWMfgvNhJUxmswYYkc=;
	b=Kawpq/XBd2YuBBs7ersLnUB3WmEcTwv9qAHNyvQZmuZlGVjk+axTUdkvn1i90aWFWLdB/5
	R/RbrSaLSOu/iZj9rXFc4F20EjAWQ3tcPp1E7RpShNTPCQA1Ac45MsRwzjjOBq5iYCo1Jr
	toMxfceX721AiQ7SXaos2ETtS2laXuI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763114374; a=rsa-sha256;
	cv=none;
	b=aWEkZDFYh+DMfvb67ATpCffR85npium59AdFT2vhCPU4bxkhOs+zv4xhVKfyZ79UO8rWDU
	LZNz2lpTaoS2LaxQdCith8JXwwETTF+a2F8WTT3rzDAbM190IUGkC6TP0TeMUIuIZxuSmW
	7lHPjIYhAatn4VWhZJ2DYY0Wo8PWDHI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=LqnKDYHJ;
	spf=pass (imf12.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=A2r/Q/+wRJ2BFr/BHn0s3SothtWMfgvNhJUxmswYYkc=; 
	b=LqnKDYHJ2hV1IWITk+XlcWoHcu2Bw8J4lGqIWsyd9e2uwsdNVw9Yn38Wt/o2M7PcyulnvfUhU39
	4KxuZBwog498fmSq/U2tuU0k1n2FhhPvnzMSrrDQr7Jml0Grp5VoP6FxpqtpZGKQDMdd2Yt0AjfTr
	b8ud4vzpnGbgPkdCX7WvJR+hGGpKIU55v5G3xX2WxkSZlqnkmFRg3XEKLH6yztg4cjQUjeCWaTktt
	LFaXDmsiA1XVetPG1Y0YvcILkSqEt/RLoe1cNVyvZpfYpmgW9p5gKglPeIz6HhQnaFov/u9bkhRB5
	EKf+ZLk6JT1ynYj6u61PoNfgwjO2ZHji95Eg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vJqaS-002y5g-25;
	Fri, 14 Nov 2025 17:59:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Nov 2025 17:59:24 +0800
Date: Fri, 14 Nov 2025 17:59:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com
Subject: Re: [PATCH v13 13/22] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Message-ID: <aRb9fGDUhgRASTmM@gondor.apana.org.au>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-14-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104091235.8793-14-kanchana.p.sridhar@intel.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 205E04000E
X-Stat-Signature: gk3y4ajwti9g13xodh3nea6pihmbhwrs
X-HE-Tag: 1763114372-275331
X-HE-Meta: U2FsdGVkX1/7x9g/J8ZTP60TjPqPsjO/k9Fa5ASIO0Fxh+Xxlh/zlKa0/PKp1lU6bHaQMC8inytsiG9l7ygIOS9xNpJ+QI98p9AGpI5jamxnfkndeVqxG9uryu4xkmtB2Fq5Aat74OXONf07lqidnm6Vu2vMAfYBeZ2/4WCs6NP1hQlQ01YBYlrtGzWwWpATHIJYLS6fmMRtdJueHpMtH9RI4up8caNSBGaaoiZ2yDzo1eCPVBQWXdK55ZcVNg2GZyFpAUTX1vyZ6DXoe06hVa15nYnylBnrNo9gBtgc/MyqsNv9q0L+qUJ+M7VtUw+hjVmBYDJ42hq+nU39OD/KnUzWv3ud1W4GizIpQ0WVXhM8jspyIUIBvY20hgexWxhmuJN39yRi1hAJDkSZvNPxLKncPw0SHAHqOj57juE4fEw+4/hE136IGjL91VgoF2yAA+MoJ+KHVt233PVhPQyI9qGXq6rNBlC6BvsjCyI0dR2ppaqRp1rDVtDu1oG78eM42KU7kAQfQK/2UBx2fWf4dJMr4jtkycbGp/uKqMUhAuTYN59YblHn6SQv0IKcb58jJ3aK0zzb6Z1ekcNMwTAO3035BTZchBlUm/kdw3T3oZodELVmZDRHRUWck7RRhXuF77trkaiTOY/TyAAHZXpMSpuU0U07ROGoCOygM196soORwrRWl/kYl/j9rwaS3y5YtrwGfAu/AuoZAYCtDTUIbqqtgEgjNkx52uMNKpRJm4q5EUN5H5+kLvItgwEYusKyRXdDgj3JGuf3HR1bkNFyzgJBa/xG0euFnLBoXFpBLhfN7y9BdYKnNgCz/2PANxd+CaOqRKaSdFdMqZRP6uFj2yHa/LjP93qQ0wG+ds+EsNMHDv+U2sGFyoPnIzvPR8L3O3w0LpGHHOvvqQcoJm/Ca9EgYpc0/JAJrjTaPN/mfRkC2PapdL0X5LjB8mv7mPBFq6dupi+Mu8GUNemlpX9
 GB6c0P/D
 iQuMpd304is8ZhF4IgSP6T6WIf0u4DI0B3SwMIPFymZ/tAU14ApWJkDe9ybCdZdUCquqlwKGuqqPxcvhP8+CCoaXw/k4rRsWu6tDKOEQAi7ZfGNPHDLtdMrc2DnhWl+yvUIrd6pQ8wQ7+2qgNJcG+pl9fBNsFD0EvS4O5RN7y78+DXq6zWO1KtnDSHMTUULgs6nXoC2e9nq41OVXW04peXM/X7SnFlrI8yy06AbGqpwXcAbGvUPzrB3kgXjU61ShWhg7A70HJBn2gh/nCDoUoDN8VCgAlGjRiIUa4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 01:12:26AM -0800, Kanchana P Sridhar wrote:
>
> +/**
> + * This API provides IAA compress batching functionality for use by swap
> + * modules.
> + *
> + * @ctx:  compression ctx for the requested IAA mode (fixed/dynamic).
> + * @parent_req: The "parent" iaa_req that contains SG lists for the batch's
> + *              inputs and outputs.
> + * @unit_size: The unit size to apply to @parent_req->slen to get the number of
> + *             scatterlists it contains.
> + *
> + * The caller should check the individual sg->lengths in the @parent_req for
> + * errors, including incompressible page errors.
> + *
> + * Returns 0 if all compress requests in the batch complete successfully,
> + * -EINVAL otherwise.
> + */
> +static int iaa_comp_acompress_batch(
> +	struct iaa_compression_ctx *ctx,
> +	struct iaa_req *parent_req,
> +	unsigned int unit_size)
> +{
> +	struct iaa_batch_ctx *cpu_ctx = raw_cpu_ptr(iaa_batch_ctx);
> +	int nr_reqs = parent_req->slen / unit_size;
> +	int errors[IAA_CRYPTO_MAX_BATCH_SIZE];
> +	int *dlens[IAA_CRYPTO_MAX_BATCH_SIZE];
> +	bool compressions_done = false;
> +	struct sg_page_iter sgiter;
> +	struct scatterlist *sg;
> +	struct iaa_req **reqs;
> +	int i, err = 0;
> +
> +	mutex_lock(&cpu_ctx->mutex);
> +
> +	reqs = cpu_ctx->reqs;
> +
> +	__sg_page_iter_start(&sgiter, parent_req->src, nr_reqs,
> +			     parent_req->src->offset/unit_size);
> +
> +	for (i = 0; i < nr_reqs; ++i, ++sgiter.sg_pgoffset) {
> +		sg_set_page(reqs[i]->src, sg_page_iter_page(&sgiter), PAGE_SIZE, 0);
> +		reqs[i]->slen = PAGE_SIZE;
> +	}
> +
> +	for_each_sg(parent_req->dst, sg, nr_reqs, i) {
> +		sg->length = PAGE_SIZE;
> +		dlens[i] = &sg->length;
> +		reqs[i]->dst = sg;
> +		reqs[i]->dlen = PAGE_SIZE;
> +	}
> +
> +	iaa_set_req_poll(reqs, nr_reqs, true);
> +
> +	/*
> +	 * Prepare and submit the batch of iaa_reqs to IAA. IAA will process
> +	 * these compress jobs in parallel.
> +	 */
> +	for (i = 0; i < nr_reqs; ++i) {
> +		errors[i] = iaa_comp_acompress(ctx, reqs[i]);
> +
> +		if (likely(errors[i] == -EINPROGRESS)) {
> +			errors[i] = -EAGAIN;
> +		} else if (unlikely(errors[i])) {
> +			*dlens[i] = errors[i];
> +			err = -EINVAL;
> +		} else {
> +			*dlens[i] = reqs[i]->dlen;
> +		}
> +	}
> +
> +	/*
> +	 * Asynchronously poll for and process IAA compress job completions.
> +	 */
> +	while (!compressions_done) {
> +		compressions_done = true;
> +
> +		for (i = 0; i < nr_reqs; ++i) {
> +			/*
> +			 * Skip, if the compression has already completed
> +			 * successfully or with an error.
> +			 */
> +			if (errors[i] != -EAGAIN)
> +				continue;
> +
> +			errors[i] = iaa_comp_poll(ctx, reqs[i]);
> +
> +			if (errors[i]) {
> +				if (likely(errors[i] == -EAGAIN)) {
> +					compressions_done = false;
> +				} else {
> +					*dlens[i] = errors[i];
> +					err = -EINVAL;
> +				}
> +			} else {
> +				*dlens[i] = reqs[i]->dlen;
> +			}
> +		}
> +	}

Why is this polling necessary?

The crypto_acomp interface is async, even if the only user that
you're proposing is synchronous.

IOW the driver shouldn't care about synchronous polling at all.
Just invoke the callback once all the sub-requests are complete
and the wait call in zswap will take care of the rest.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

