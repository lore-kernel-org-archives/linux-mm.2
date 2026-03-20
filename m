Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7924C109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEB916B0420; Thu, 19 Mar 2026 23:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2286B042E; Thu, 19 Mar 2026 23:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFFFE6B042F; Thu, 19 Mar 2026 23:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BEDC76B0420
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:14:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6AE078C53F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:14:37 +0000 (UTC)
X-FDA: 84564973794.27.E5E2DF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id C5AE840006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:14:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=o1wA1ZmS;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773976475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aVJQbKEfor+RxmQcFK97BTwdfEIJFHktsF6U5NupqIo=;
	b=ff9BhAQKkKapbbNgzJTr68ESsPFuA0o3TSl2sX9zy+8LzWF1JYTzfG1DaFYfxLLKIU3lzb
	YZm7adqi+MnGfq63vk52hh1ABDS+snaibvT3sGcKGDRBSEcbOHrKQVewsD+YFYAj1pm3Ee
	imvbp+HCxIMADrd95I5FdkyZ8xOJttU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=o1wA1ZmS;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773976475; a=rsa-sha256;
	cv=none;
	b=kL9TqHRXw3ysilfmE5l/PdMS80SAZ8/mH1WDEb5LjcwK8XgLeirw82VztYof370zjkj0g2
	sEXvlKwMAdXGsG+LAI4clj5G39RHGyytJohJgpOBqq0rUNING2T1aUUCVFwIbJb1nJYiCk
	lE3xJberD7OcoT3bK/jwazNl+ilJsWo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 12FCF60097;
	Fri, 20 Mar 2026 03:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F43C19424;
	Fri, 20 Mar 2026 03:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773976474;
	bh=1ldpoIJJPrstSo7P+uHcHJMsXGhDf6QFzETNfcD8JmU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=o1wA1ZmS2n1U/a7/+G5dzNWCWW02PcdZ1i1f1hnH4Yx/UFtzuij7AxCt9D/7vunfK
	 RYMQ5fgggQVSL/sesJzy7eFjfAzbwzfHbTpbwfm8C6fzywK1xCK3d/8K9JKQjB8lZB
	 M/aa0TN73tcSF97ejcTfl9m+9LcYyg7blP1FQzAI=
Date: Thu, 19 Mar 2026 20:14:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Kent Overstreet
 <kent.overstreet@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
Message-Id: <20260319201434.b51833a0fea2801a2b220ee5@linux-foundation.org>
In-Reply-To: <20260319083153.2488005-1-hao.ge@linux.dev>
References: <20260319083153.2488005-1-hao.ge@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C5AE840006
X-Stat-Signature: tien5c759ns97u78p8k1jxioim4wfk3a
X-Rspam-User: 
X-HE-Tag: 1773976475-282308
X-HE-Meta: U2FsdGVkX1/9u8Hfs0g5du0PZrvY6me5PY6SDq/bRXz84NkPr1hKm0VCJ7pSKMwUehfPv8NEPal/qClGk0E52Cj4LWCobhdPnXMzZ0pIjC+0gdpLgSvjvAlXmGkHinBoHJRcK9Yb/4Q/boYzFRZ2s74DIvsf4waf/moaMXBPtBbO5gv2upoIAWooh9hr6IDvupwjeOfRNIG7BNfg8oMoyxcE/O6sFu8zEsOoKtiybNqYTDhhkcyPQpjsD5Mmu3o6gLIyz5CFnZJcXjWEl/tn0nhXiDhRTkfCHaawe9Tf6caBVImH74bZaJxpZDSuU1fvYwI0C3kr9XjNPLQkIKujpXXHFGF0VGCHTr6mUI/snYUAVeCnG0Ie6phAr4LwO9KUTPzA6DdXze6tKih/YWPPDhkVXho+9bOb3+FIeC/cp7sgzHnHTSpa+PB2vmw6jZN9g9/X+sCmTQAHhYOltjo0QooMWdXMHUq7xRXVAeI1xY5X3MLo01blNTev51bT6g61MSbUYjoPCUnTnkLgOGAxVSuzinwJXTTdy518dcBeNm0oxQNR4kdzVuDWrB8jxQ4ngbInVsKJbX7TfE0l0MMGiEadv0KGidbq+Wg9yXJeI10Rjd2ajk3gfSgQav4cdHGFj+WI7ZXXALQYFlTBjnXtFxaQZplRlIUA6Y8SDE0CA9meow+K4rsJXHmIWJmUFPk4db58yhZTIxU9e8yIcbGggPQG/dfWRnt3t2aGrQaeWhYcQB+KIN/EfAL2cHELZooRx2N3gts4jjm2vocrgABXk21Rco3nxeLwvpu688UdAbM4YWZ5xbwWrmpJ1+Jq30SLO6B117c31gGOS2Brf8KSFWbzarcfNnpUAlhLxbmUhUAlKRAFAKkyWg7nq7PYVMQ0q3n6wK/1mNrsxNjCPAm3m5/2WfH3S01HQbo6rjvCrZHDVywQEboxdcu9sdXyd6KRvfhmk1g2ZBgYmgPOQ2e
 y97f/glk
 v7oAaNrs9vanlhp6WI8KwCxu+QyNdGzHuzsUJf18ylawUuN4Pmrn2ID18mbdXPlnRHsD+kKd6P8hC0UCZsNqzGNBT+jx8EMUb3h9JRNYSfVi2KIqcekzM4tEeDhZU5jFPPGWR7m5YgCejvmooeNBuf3pVD+780q5+nwm2sNMNXNYGJhDNhsTQpU2AEKSoMLJXOl5UXFWPjax++9euRW7oh4aBuO8d5nXudtHZq8v0xdu+a6pvIptbxFf42MxSFt5wHU0ru4vGYhqnfhHi2efYiMXhoVf/wK8silhzA7QgNZMW0utfieDzvXi1X44m9vd34dmac0q9A5rzI+GDtGSkMC3C8lH+Lj0Ck4I+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 16:31:53 +0800 Hao Ge <hao.ge@linux.dev> wrote:

> Due to initialization ordering, page_ext is allocated and initialized
> relatively late during boot. Some pages have already been allocated
> and freed before page_ext becomes available, leaving their codetag
> uninitialized.
> 
> A clear example is in init_section_page_ext(): alloc_page_ext() calls
> kmemleak_alloc(). If the slab cache has no free objects, it falls back
> to the buddy allocator to allocate memory. However, at this point page_ext
> is not yet fully initialized, so these newly allocated pages have no
> codetag set. These pages may later be reclaimed by KASAN,which causes
> the warning to trigger when they are freed because their codetag ref is
> still empty.
> 
> Use a global array to track pages allocated before page_ext is fully
> initialized, similar to how kmemleak tracks early allocations.
> When page_ext initialization completes, set their codetag
> to empty to avoid warnings when they are freed later.

AI review asks questions:
	https://sashiko.dev/#/patchset/20260319083153.2488005-1-hao.ge%40linux.dev

