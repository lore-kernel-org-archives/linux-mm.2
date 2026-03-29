Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0EFDF3D5FB
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 392B76B009E; Sun, 29 Mar 2026 11:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369E86B009F; Sun, 29 Mar 2026 11:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6F16B00A0; Sun, 29 Mar 2026 11:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3486B009E
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:34:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BBEB15904E
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:34:28 +0000 (UTC)
X-FDA: 84599497416.17.BFD46C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 319FB4000A
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:34:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=emb8JOOd;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=emb8JOOd;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774798467; a=rsa-sha256;
	cv=none;
	b=A9MB2SARcFO/8ATv5AeVK7kovb4ANJ6+g1qZwAnKRtjglfNUQsZNmUaQWojOuAWYvZlPrK
	JRkFsmZQRc6VS1fKNyf4N34K2tirKjAjHXPa7hg/m/OmTKZVh/1O+2wloetFHi3lHZwnfI
	tIlw/g5GXCFvRS5Hb+DWczFN4TgI9c8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774798467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Egro3sYHNkwJy6d7YDpenPd5MVo8IwF3y1HnHo65PPY=;
	b=ptuLxfEfwDP1PljwvGeUdjEB+Li2FyB2//qehnWW8x+DsMDkroxFOxVz9qHVzXYiMNjDcg
	DN24HcdYuYoSfb7MpgqRimlpaJ3vTMfLfRM5Rc/zrxD180j3Qa6wXR/ZGAXAJ7W+0gYyNs
	1ozWVjDUzqLkXTmBO/Lf78PMzfLPQeQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A3B94600AC;
	Sun, 29 Mar 2026 15:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8CEC116C6;
	Sun, 29 Mar 2026 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774798466;
	bh=mjxyo8Wo+1BzdKdGSoOUfInOew/XdVOErwdc0gvYZeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emb8JOOdNpsqVfoiVtt1ZKVYb5ifOAkMWDVK+O8IGT3lolH/H/6nJ8XA6yRU09plT
	 xJGPyqusIY3NKAg6l9nnpb1E3aDTMO7pAVFvrjEuw224RDZ+mQs0frbC3fcA88gp+v
	 FXuR2S6a02iGDizYm7aA+Q5EFxQmO4lkpsluUo+PBFjn5bKvp7sfL8bUONfoTd3mAj
	 g/pb7oY1VQvOTay/v05/LGkRJlTn2D+lcbjJDjnK73kB7WVewp4a1ytlyHEMQGu1fV
	 rDrjT/ZxB0oC/f2Q5W+8qYkNczR6kLo+cCnVqblzQGXA5n1SttNtK/t/T9OvxrLDf6
	 tJigshNKmIHhA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 19 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH 2/2] mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
Date: Sun, 29 Mar 2026 08:34:24 -0700
Message-ID: <20260329153425.47097-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329043902.46163-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 319FB4000A
X-Stat-Signature: ngxcr3bdmpamb6zdo7d7nysqsodin4bn
X-Rspam-User: 
X-HE-Tag: 1774798467-733504
X-HE-Meta: U2FsdGVkX1/MnSFWif/TxuMDKrdzW0S+9N03qtQyd9JNMpfS67jyn6uU3Z7S96lJDif19fP51wljj9ssF1u25fBo9tD2FoIBbV5S3B93iOKcV5PKi5+SE6IoSt4+bVXyu5fxjH7d1r0k/zYes9/v/ALvhMCT4IOv7qGVWd/Kx/aQ0dmoxuTsqbe7cH7R2t/WtpY7eiJezw7ea7/XGgnGJQInYWWGCeBEKWAgCC6t5lViVQEP0exeGhh9BDEtcovx5qxyLJ3CGT1gBpxQS6WtJATLOu2avNhnmXYCM6H6RJQ00fBdB3qxtXtGG4isXh0l30TnT+SxjI6KmNqBQY4cZJVjAFUVyZJEtQbkTMV6KPa6MAZYGPv56N1RVmWxTXXS7ZvhQJaoRvMpYGWcRFWLEC8mT4AZUntB4qrWZjwYGAAE+336iefgkUzoWV7nez/c7McP6gncYB9FXQxE08KyNFJ1E0dr5nM5fQPqFneyBUyCOYSPQ6PTxZ6SLH1ZApCU8zNoETlFp40KLNPvDTbfGeDaOxMdTY3gemSE/UukELrtY0iLfr6MKwNpYOkJ6EHg1y5EPB8CY3cO/xV01O1n1U1pEMjjqgUUnXi3KOFU9MmTcVdBKnIyn+CZB0p6Ywrux98L15OcFfY5y7SPjRAOIqPmw+UytpovOcpNtdgyI68tyMvw1UJGqHIa41fUWNm7fsJzjm+SKGZ0M+IONb6G87n70rmdyFWO87kRhKNJHbLYewFdAZotFy+ZdxHfEUuvZkTrw4BPesB1a7PQ8YwtpItV8icbqGq8l2rLEOdxFuoKHTCHtIhKlkXUFjUcWbiKqaZv2ZsyUCkxNGIFBQ9+a9PqBcAeUExUgH6Hqupycd/KQAqQlteRT/oyEuwAoKLRPi3AEBEi15C2VMk9x6M9YRVOLGPjTnnXI6cRQmzQIt/8MquXeWDCEEcXRR775gK7adqfXcTOh+sZ4ykCIKu
 KTLngM1K
 FnW8GWiTymCdERmp3u/WOBB8DMBCUHQNBPzRrkktHynwa3G8kF0I77EbI3Lva4WNFDT1CHgO+i2CP8UFuR299C3d4NIj0ErLh6FpjxtlM9Rgn22DI3TQPP9NLIO52DXr1AA4/zqfqMzLKhtWjSQRE3+I2rAxJp0Bl+4hslzF5Hfu/XWxpe8QvQ23sKumDgW7ixqloFhqwYYP+6GKQ3+0Fk/FEgvyZ4dpQqh9uDvDS/bhk+GSEb0XWyxBlJLgA0cBZi/T5YsPnEZ1riWPjw0AC7ovQxF3MoaAkkRMciAMLW/qr8RtjSGFNgll9lEtsOeS1NRFvpvcnYdKfpncFEO7YhVIK8vQTDxL2sg2O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260329043902.46163-3-sj@kernel.org
# start of sashiko.dev inline review
commit 1ede2d837f5cbf8e8d96fe4c6eab34aeaa071d56
Author: SeongJae Park <sj@kernel.org>

mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp

This commit adds validation for the node id in damos_get_node_memcg_used_bp()
to prevent out-of-bounds memory access. If an invalid node id is provided, it
now safely returns 0% for used memory and 100% for free memory.

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 26bdeb658799..c45c62f8449d 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2273,6 +2273,13 @@ static unsigned long damos_get_node_memcg_used_bp(
>  	unsigned long used_pages, numerator;
>  	struct sysinfo i;
>  
> +	if (invalid_mem_node(goal->nid)) {
> +		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
> +			return 0;
> +		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
> +			return 10000;
> +	}
> +
>  	memcg = mem_cgroup_get_from_id(goal->memcg_id);
>  	if (!memcg) {
>  		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)

This isn't a bug introduced by this patch, but can the subtraction later in
this function underflow?

damos_get_node_memcg_used_bp() {
    ...
    else    /* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
        numerator = i.totalram - used_pages;
    ...
}

Since used_pages is fetched locklessly and i.totalram is the global managed
pages count, could asynchronous rstat accounting lag or concurrent memory
hot-remove operations cause used_pages to transiently exceed i.totalram?

Also regarding the end of this function, is it possible for i.totalram to
evaluate to 0 here?

damos_get_node_memcg_used_bp() {
    ...
    return mult_frac(numerator, 10000, i.totalram);
}

If a node's memory is entirely reserved or concurrently offlined,
si_meminfo_node() might set i.totalram to 0. If that happens, does
mult_frac() execute an unchecked division by zero internally?

Finally, does the mult_frac() macro overflow unsigned long on 32-bit
architectures?

The macro evaluates to q * n_ + r * n_ / d_, where r is
numerator % i.totalram. On 32-bit systems, r is a 32-bit unsigned long.

For nodes with more than ~1.7GB of RAM (where i.totalram exceeds ~429,496
pages), could r * 10000 silently overflow the 32-bit boundary and return a
severely truncated value?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260329043902.46163-3-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260329043902.46163-3-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

