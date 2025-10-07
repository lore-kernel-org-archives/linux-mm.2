Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD56CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 23:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D486D8E0011; Tue,  7 Oct 2025 19:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8B18E0005; Tue,  7 Oct 2025 19:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0EA78E0011; Tue,  7 Oct 2025 19:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFB908E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:41:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4BD1F1A016A
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:41:17 +0000 (UTC)
X-FDA: 83972941794.05.ADD8DBE
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7C106A000D
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:41:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QqZrbH4y;
	spf=pass (imf25.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759880475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZYXV+Qnwlv/z/wJbyc9UEz70EvXyBteIQP5Vd1/xMI0=;
	b=KBv04IjO06jONlgqDRt0vukd2C5yzaH3as8vDITM9ixFIPioFg2jiwgcF7W9O8UnRZTUQD
	OgvlM/FtRn5IvWHD7cOjYbHUheVKFL5JW4FyxsoNiz1SYirjC0b3bXAmBzVPMF8kf3yjNf
	AvnnaSv130GfnJufmOSm09scw3IWJWo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759880475; a=rsa-sha256;
	cv=none;
	b=MX5gkJofdIXeLvpiHeBAG+V8hcYUJJ+WFmacHmZ3uYlNvJPc9kWIIZdO6YsVgDhN+YWaBa
	8Li5GK8lpa9XvYWjWlZ1kE7G/S2G1Hd+QbjX454jCj544VTSID/W9oAoao2zPm51NX/G+u
	qClblDjA8trpBMfn0Ly/Y9z+wY9G78o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QqZrbH4y;
	spf=pass (imf25.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 7 Oct 2025 23:41:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759880473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZYXV+Qnwlv/z/wJbyc9UEz70EvXyBteIQP5Vd1/xMI0=;
	b=QqZrbH4yImYyWUDdM+niZ73T8dgbBbJWK6HWt/+yM68ii/XRRp8ZvHsewlimuAj5NYkoea
	C0D+GPzYNCbmybAPVpvUBt8JPvK75HU/JYLx22FePVwzMcdXJQM8bVjc9yoL0q30CgyCwF
	uEijvTQnqXHjVXvLXN7FSPTVywP1Wsw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Nhat Pham <nphamcs@gmail.com>, kernel-team@meta.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm/zswap: s/red-black tree/xarray/
Message-ID: <yo7yflwtjp3xjqnfkvuakxamvpxlv5jnukaij2vr5gdg546if6@xcooxyrm7awp>
References: <20251003203851.43128-1-sj@kernel.org>
 <20251003203851.43128-4-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003203851.43128-4-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: 7o3u4x7drhszyjnbaqj9tw8rm4daj4i7
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C106A000D
X-HE-Tag: 1759880475-326469
X-HE-Meta: U2FsdGVkX1906YBP2FY6RMBxMmcjRGHCNKQsB7bD5gQrLjR88Vq9D7/1G0VU+bDgxC3c0M3trH6zeIS4/SpcElLlafhz3RUnkRwwJ8Q7OfQsi8rBqFHadEXdd4Q6gNlK4UF0ESJzB2q6uGUKDQGLz9wxbsmcq1D/hs9NYQUdXQ1Gj1IuA0tTDTHz5Ogj1rLDlaYdLjv7OnNL7h3GkIbJC6nxALNuVc2JYJBhrHBAYa0/W3+A+RvE2p2zl7GcR4hFZxWK0OnJ7XYL+vvWhx7666TqLwCdFSiP1jeKqR1o4f9GZYdddyvUcNzx8I5cw91JfUsIbivQ7MMzNFc7fBEdgnf2tk2iK70Zs6WqUiVrp1/jqqAYKJNxydm8TBenggcXsMHLx6IXqvfK7PXinuI0GkeJmRTgzmTOCsQgKROvKmnnYaDnl/gWiZq1NwQqvWVjF/1WVEjCBwo3Iby2FwkbpSU6bXq/mrmEPc5rluhYMPotyv6YvmQ7Ue0F/mDkwNVAqEqVihqYSNW4puzlzhPtagdjsUiTq5Spn+sVHQ9RQuEd3I7msX5a5TnnnOV329X1fiKZOWue3EFk3oWV5OP4wkSVxMMsKvTaiys4B4kqAShGPI2HrlVfdBxlFMYACcCs/ttcrEmUP40m4q7pOyX4g6p4Ptg+u4gyN1Dt6xvLZ+gynBBu/W/n1LE5NA80mbqIFLB+L+0uRLTOyWGAH4KyWk3ZoQGvXldNcbna4lli/3SGpq6TmRPyZ0QPRFk6iTmeAQxR4SJNe1wzIK1AMI7yTK+t0nBTK9xyB+1GID+CWDQYTYvdoYZCcC4K6TD3YBM8W3lL0zFKW/h2vyaaW2miaLMSwlt11eAosZKsSnMz/xEsH3QgG0p2wRyplzqZ1EoLUQ7Qj51a+QfEZvUIbEijD1gMUDBsOWsJrRGCo+4jWmMjeUyduJUJExhFSjfpifHV2msCjT+Ir69krheUTaI
 pEFg+9Ug
 b//qTgVPTGGaZupv4nITu5Ybl2BVMtpo5E/x4JsxSGgeFPzpmQ+nPlVjWdxwQ+Pa9oQ5yJ7pLfLgugQKq5nFTCvuFaftR/WJoFlY0qI4h7cP2fKz90+GOzjV5ZrF2MDy5LoDCQ9KY4ujSKfgq7DTq7IP85kwy/affc5RA+ZXwN+nxWTT2eD//4dL4xWdx01ViWMssWC6amOjmm9517IZuQU7V0PL95R1yZczj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 01:38:50PM -0700, SeongJae Park wrote:
> Changes made by commit 796c2c23e14e ("zswap: replace RB tree with
> xarray") is not reflected on a comment.  Update the comment.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>

Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  mm/zswap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index f6b1c8832a4f..5d0f8b13a958 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -175,7 +175,7 @@ static struct shrinker *zswap_shrinker;
>   * This structure contains the metadata for tracking a single compressed
>   * page within zswap.
>   *
> - * swpentry - associated swap entry, the offset indexes into the red-black tree
> + * swpentry - associated swap entry, the offset indexes into the xarray
>   * length - the length in bytes of the compressed page data.  Needed during
>   *          decompression.
>   * referenced - true if the entry recently entered the zswap pool. Unset by the
> -- 
> 2.39.5

