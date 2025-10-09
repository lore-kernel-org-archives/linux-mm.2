Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82DA2CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 03:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C29B08E005F; Wed,  8 Oct 2025 23:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01618E0002; Wed,  8 Oct 2025 23:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3EBA8E005F; Wed,  8 Oct 2025 23:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9FBB98E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 23:03:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 404C746613
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:03:28 +0000 (UTC)
X-FDA: 83977080096.06.4245655
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7BCBF20008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:03:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ilJhnx/f";
	spf=pass (imf03.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759979006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJj6r6vYdVMEeyImI7y3r2/OjUGGxLmQKEZBFpvBlaw=;
	b=Eo3XU6QyCjSqfqxsvCUJlon88LvdhMeFV9aMueP6NWUrIryeF4iGxPcBcHfpL/gp9OdeF7
	Ef/MTRvSixkMr7LcWbU98/f4Obm1rSo0vKVXfswUoxjDtb83qT2D1IKqIsSF6ZGaliYT+E
	v/IWkXGJfnpiqqaVvQ07jahQ2qkMywo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ilJhnx/f";
	spf=pass (imf03.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759979006; a=rsa-sha256;
	cv=none;
	b=KR2cF32cEhFoUYK0GdbCPoCNEF4cmTBLcKgp140EFcD+mFrV02mVT7CDEIMBpAlaWx3zL4
	zSn0P37tGbG3GRx0nSEm0nlOQ9u+K3XCuJvJGErwD8G+NGmutKd//NG+Gg4xYglwAI4zEG
	jE7RdR3+HBBXU7vzf13EotkAWXL65E0=
Message-ID: <821faf8b-e61e-4f0a-bbb8-4a0f00c9fe53@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759979005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RJj6r6vYdVMEeyImI7y3r2/OjUGGxLmQKEZBFpvBlaw=;
	b=ilJhnx/ftLkdNla4VIywngzFsaPQIQwX0mNkGUAXqUJPxKUSRnuS0b+bgKKfts0BW60XOu
	hJLnSG23ToRqVUi7pvzv1wtwUkJN8Yj8i+koZcqos/c3zFHN096KjNSCl6Qr1YTTWl7k6f
	6fpnA8QQHPNUxHpJJbQwsW/4EBr0wFI=
Date: Thu, 9 Oct 2025 11:03:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] mm/zswap: s/red-black tree/xarray/
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251003203851.43128-1-sj@kernel.org>
 <20251003203851.43128-4-sj@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <20251003203851.43128-4-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9d41t7c1p4zkb3z8p1693771dpkzfj3u
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7BCBF20008
X-HE-Tag: 1759979006-969203
X-HE-Meta: U2FsdGVkX19hn2Ug4kqB3mAHctQ57oaJGYvRqwsMLllKsWeT1mmmUrFNBfPvrD1E85PtTlY7o1NnGTmgIjmO4hNoyg7XUL4Jumfru5YoyhgLLDBN33e7mdqyH4LCK4vAv3M9ighr5ISslvN5ypsSvkzlPTfDTMRYAKh14AOF5AXa5Tp/c25zw7V+yeaCh6V6MM9Lqn6dWOKDzUoDyt8+G22QHydGOKjQ4ntddqf98nko50NWHT23EJvHPMeIPwdP2gzj3lYF1NW8Au9J2puTrC8rV53zIqfWJVdBA8n+vhwLEcOl9s5XrC9aNEia0RBk3Jf4CmOskUskQfBqQG9zX8kKbjzbAqjoWQucdvHzdWnrCHpZy4xpje/i74k3O08Nk+YMb63dAV4Ki5qeGQlkpfNbSG8O/rNXd4QmIlpHq3D9uYlTQ8shbk5Xy7GaAUjyl9qpHoWBLszTKO3QHj9srPgFu7yu+WbBWiOdAh9FI0W0UQtCaGCCGkatwtelqFjFnMFMIVfidWkQR6mSfFue6mO9O+At5hBYNdZ3WRqpWdILOMdpss7hxIxTxtEbcuGN6+HrRo/dIGYIPXjVCxXIkYTzmEx7b9XIkbeQkgmrXEeK2hhyo67vok65o4NzLSADPLCJ5fSaq/IusfB1+2/XXVCFR5ld46qScu90RSJaSI6KS0rH4DhQXBPPWUUq1bS/n2ZgW/vWtSO407/pEtqNswtcabNJmnlIcZtyHOZ0r2aH4JY6m0/4Hd3iQ9jUN0d/hU4ZxToFrFDwdKa1DfH4ggXaoSb8q6/czE68TnumgyYReP5a6O9kqvMZ80it4bpK6M8zy73gQVse5k9NNDHVrlbBy7qG8dGHj3YcD1tg+C89IYG5++3nzc0N/hX2+uilsWNRjxoPfTN4LfNsWvxgXHKfLpeTV77wyZ5J6QxPLUyg/HgwRtwShJRT5jdNQA4Ii/lhi7N/xiPAwBZ8aIh
 fXiB0/N0
 v1/T+TLMPR9uBC78KMPKaiQMj+OM+fm1GIe4yxvrUzNU4tZe0l5GiKMRRp6WI8entNBJGGXujQJV8PJ8GzCft7HnlTaeUG+/yy4osUvjMcTyaHMu45HYmkK3ZueJ9AQUOBS2HcL9mdmLXwY/SgLWrdQ3wrSgJ7aUJRxTLXk4Or2m+gTXbJaMrcV5eIHHe3yDFVEgDguAv1fWrKNJAcjzmu64xwyZkKSga5edLvDZFATzCViw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/4 04:38, SeongJae Park wrote:
> Changes made by commit 796c2c23e14e ("zswap: replace RB tree with
> xarray") is not reflected on a comment.  Update the comment.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>

Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>

> ---
>   mm/zswap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index f6b1c8832a4f..5d0f8b13a958 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -175,7 +175,7 @@ static struct shrinker *zswap_shrinker;
>    * This structure contains the metadata for tracking a single compressed
>    * page within zswap.
>    *
> - * swpentry - associated swap entry, the offset indexes into the red-black tree
> + * swpentry - associated swap entry, the offset indexes into the xarray
>    * length - the length in bytes of the compressed page data.  Needed during
>    *          decompression.
>    * referenced - true if the entry recently entered the zswap pool. Unset by the

