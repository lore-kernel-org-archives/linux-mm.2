Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D21CCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 06:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF516B0005; Wed, 17 Jun 2026 02:53:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0906B0088; Wed, 17 Jun 2026 02:53:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68FE96B008A; Wed, 17 Jun 2026 02:53:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 359706B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:53:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CAF88D2CE
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:53:05 +0000 (UTC)
X-FDA: 84888487530.12.17349A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id E0D76180003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:53:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NklfJCj5;
	spf=pass (imf06.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781679184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bM4VGvKJIagGPyGZhns/SGKBdrac6vGwNBZ/hApzcjg=;
	b=XCb+I6lC+acFN1Jf8I077kvynoO3qapjp91JEmdWbGXr60+9ZUOD3IgQECrP1BzLEBywxW
	aIUAoosEJeZtwvF1AX0h50HZKZFijMadUZ/1VOhEZzmgslgYgokmNlGn+4ctpd7YiG7ct+
	3SIWECToUraPASQUaiq1Yx8A3XiP+bQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NklfJCj5;
	spf=pass (imf06.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781679184;
	b=J9ksDBsx1Kaspnj3Jgtk6aZlMtb9/31Fe2xnNv2ldlEA9teR5yMWXmP5RWdqXh5zLIra7H
	mbIqH5vkdRM1Q4kN1Y7EaoCYGBsEW2qWzpBDLcyKiienfVOiQxgZkqPwRJ5cEYwtVb79Ic
	Mt1oQzZBdpNuEsO3qc+c5rQS+f3Mq4I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B8A740851;
	Wed, 17 Jun 2026 06:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CFD1F000E9;
	Wed, 17 Jun 2026 06:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781679183;
	bh=bM4VGvKJIagGPyGZhns/SGKBdrac6vGwNBZ/hApzcjg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NklfJCj5xkDpZWlzAQO9begPqSpvXD3y+bWn3EmLpAZw3Od+Ta/ohvgj/YwmUNnCV
	 MyaSkl3B0vpJaYbIrRnHXgXLtuZxO/qq9e0tKnpOAgzTIU5WQlSX6uJrTfi5nVu55a
	 G4JMRRrFJwnCkh34lGLxqtZKT1PYyjIA+metdq1Dtw1SSbTQP8DZIrvvvCBbJxTDk/
	 B40UxgaImUHHy4Yys2EBGS/Yk81801tcXBmewRSG7KMFU2n6utoWbmYNnyncB9UtrV
	 UYDZFCQltHPA+imjbgtsdtOfRHmrpFVg7e6eW8iC5b2rAKUDLsxuP+M12K67ZUdees
	 2P1gy/j/FVyQA==
Date: Tue, 16 Jun 2026 23:53:01 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v3 3/3] mm/percpu: Avoid IO/FS reclaim in backing
 allocations
Message-ID: <ajJETfcD2XzzpR8w@palisades.local>
References: <20260612022648.13008-1-kaitao.cheng@linux.dev>
 <20260612022648.13008-4-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612022648.13008-4-kaitao.cheng@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E0D76180003
X-Stat-Signature: j5ce8kwrfu5ksxgbtj4f73zan68dwf6z
X-Rspam-User: 
X-HE-Tag: 1781679183-581044
X-HE-Meta: U2FsdGVkX18KdCE3H61JVvAbB4ZqI639AVQD0mBQ0CNFMoH10N1E+nA0DphXh0jE/NSmCASBeO35JRK09U/zKSKUuRoPHbfzrqbuyJ17h/eVB1MGgA0bFIHFp39eh75cvxMOgc6W6tMvHaqRsrAKvA1hHtrmxAJ3TpruLGMm+IKN7mH83WmckM6/+H+zEVmMTt+DEEGnfSWdqGIWWGuLyt91qmcFii1APa1UXSMK/FCFFKSY4EKtEFbAn7oRNzdKvBhCQUA9OvcCkbQVXaYO9eFnNxYr7wxkZ6X8FnvAFXdqx0cEXGvjnG3r/ywWmhcBGWdw2XwdiXfDJV3BkgpnvxE6IVOfs513PXngRkw7AAd1Uo6CsnS0SJxTVqvZhoXgQu2NPZqn/FkJOW41pLbFOkMZA2yVz4QxQZ233bnHrtslGJnHsEOZfcwL+bNqT1XLxIk3alh+SjrjvvYSlXEYTMMdszmsSltwPg2ChZq6Kpv0PDILq+O6TJbJIDOjEQR3fJNMMBnsxdYBjo0KCrPLQt8vwSowMWC/1/rluiNUQT5PVOFB5Aq2JThYQ12Qqc7VyAHcSg06lrpoV1LXP2Be9fq0vsYjW/NDdoW4+jYjQ2p5z3Lcp9nYrmboro1FYPUnE9J5ObyT1+C7Zw2plxy16F3tX1wvDWaRTU9ZhHhouzyTNhd89UE/a3a92e3WN+5d+y2psQ3jGYZmPJoZSR2tphTJh3Vo7aNGHwWZS3psMrS+rMvOfgyVTKFSw6Tz9BHb4uWKO7m0rb7MfjEmEOb0fqY0oMFXTwK4xZ1DgCSJuhEpXi8QRYbN3F6sypI5AoPPkSjJM7sBNnuYem78WuhJ3034NTKd5EYCLQWuRhMbxGiYoG2PKPNw7O4iHnLEDhg7xnDyu9F2OZiYFTbNsFffm6/oTIFXldEZrpFO6AEMgSgftgDIsPKoxy6BSoaY2vwwMawXrRqIV5jhhMnMiET
 85wuw+Qk
 srqMIKi0ummJzK9OHll6ypx7q5ZpVx4TqwbQCtQyzFAlhsaReLByNqugNKsLLfCaPJibA8D/61kiyQ3OrBseyykJkrZO+12EMBQr+O/unzNeCQJMw47QfZdAFyIwF9WPW/kgWByqrz1hP/AZ4d+L1nlJtF1Mu9Sat7vUYV+SZ0nE34HJP4eQg3D7heTP6eqiAo1lhRSUXmKf8AHV6fLbHTurzHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 10:26:48AM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable
> allocations atomic") allows sleepable GFP_NOIO and GFP_NOFS percpu
> allocations to take pcpu_alloc_mutex.  This avoids premature allocation
> failures, but it also makes the mutex visible to callers from constrained
> IO/FS contexts.
> 
> Thread A calls pcpu_alloc_noprof() with GFP_KERNEL and takes
> pcpu_alloc_mutex. Since the internal allocation is not constrained by
> NOFS, it may enter FS reclaim while still holding pcpu_alloc_mutex,
> creating a dependency like: pcpu_alloc_mutex -> fs_reclaim -> FS lock
> 
> At the same time, Thread B may already hold an FS lock and then call
> pcpu_alloc_noprof() with GFP_NOFS. It will try to acquire
> pcpu_alloc_mutex and block, creating the reverse dependency:
> FS lock -> pcpu_alloc_mutex
> 
> This can still form a potential deadlock cycle.
> 
> Avoid the dependency by restricting percpu backing allocations to GFP_NOIO.
> The public allocation still uses the caller's GFP context to decide whether
> it may block, but the internal memory allocations performed while
> pcpu_alloc_mutex is held cannot recurse into IO or FS reclaim.
> 
> Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  mm/percpu.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 4d89965cba16..47824061a701 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1726,9 +1726,9 @@ static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t s
>   * @gfp: allocation flags
>   *
>   * Allocate percpu area of @size bytes aligned at @align.  If @gfp doesn't
> - * contain %GFP_KERNEL, the allocation is atomic. If @gfp has __GFP_NOWARN
> - * then no warning will be triggered on invalid or failed allocation
> - * requests.
> + * allow blocking, the allocation is atomic. If @gfp has __GFP_NOFAIL, backing
> + * allocation failures are retried. If @gfp has __GFP_NOWARN then no warning
> + * will be triggered on invalid or failed allocation requests.
>   *
>   * RETURNS:
>   * Percpu pointer to the allocated area on success, NULL on failure.
> @@ -1749,8 +1749,14 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
>  	size_t bits, bit_align;
>  
>  	gfp = current_gfp_context(gfp);
> -	/* whitelisted flags that can be passed to the backing allocators */
> -	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
> +	/*
> +	 * Allowlisted flags that can be passed to the backing allocators.
> +	 * Backing allocations under pcpu_alloc_mutex must not recurse into
> +	 * IO/FS reclaim.  Otherwise a GFP_KERNEL caller holding the mutex can
> +	 * block on reclaim while a GFP_NOIO/NOFS caller holding an IO/FS lock
> +	 * waits for the same mutex.
> +	 */
> +	pcpu_gfp = gfp & (GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN | __GFP_NOFAIL);
>  	is_atomic = !gfpflags_allow_blocking(gfp);
>  	do_warn = !(gfp & __GFP_NOWARN);
>  

I think GFP_KERNEL -> GFP_NOIO makes sense. It breaks the cycle.

For __GFP_NOFAIL, I think my concern is that a chunk can be quite large
and might need numerous pages. If we allow __GFP_NOFAIL, then we could
potentially churn and stall out other allocations for quite some time
while GFP_NOIO tries to reclaim without access to fs or io paths.

Thanks,
Dennis

