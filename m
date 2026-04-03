Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CC06D730A7
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 06:28:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D900A6B0005; Fri,  3 Apr 2026 02:28:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42226B0089; Fri,  3 Apr 2026 02:28:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85846B008A; Fri,  3 Apr 2026 02:28:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B8CA96B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 02:28:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86C2AC1F12
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:28:31 +0000 (UTC)
X-FDA: 84616265622.25.254B07A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D30C240014
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:28:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DanqkANJ;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775197710; a=rsa-sha256;
	cv=none;
	b=WdIEAuK6FCKMdmYKhL+HPpWyLiQkYfbhwGiZxXnVQhu+7ivRryMkDe/IRd/1Aj+DDn3BgM
	9nnITTlS3StQa3ztDxdG3WxqQKvSh5dQNyyWKZS4AROoY/8BVNnWb/nqsul1ezbSiB1iDB
	2LR6dZeWaYm6Hm8E8B9Gdjgx6ac1XYg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775197710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=radoC5R9uUdcMUVJ4fsiJdq/8ee8e/WoPx9910CGq9Y=;
	b=dhNilM4/NU9PJMFiUk21AxzX2OkJzRe2VTR7x2XYyjramdjTVxYvUc/i8xqSN5lsF+HAFk
	aGp4K5eJQ6JNBGF7TsPLGTtZ1OI5deW24PRsM02aCFzR1M8us8RJReK2+fR9IiPGv1V2LX
	E9yV/Ra+GBJZvtCIysFKMLVrnxzGkcw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DanqkANJ;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 97CD444166;
	Fri,  3 Apr 2026 06:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DEDC4CEF7;
	Fri,  3 Apr 2026 06:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775197708;
	bh=EDKbDUM1va14MDdISCCEcbu9DRzxd+M/3/KumOtFn0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DanqkANJAv/p4747ceEo4NiyHCyXTNuIVxqmrdP6rant/XCjDo2CzwtmbOD9Zz2cZ
	 Eh1/q+uCKk6qJjlC650pXBD5+/r3fIQOOU/ntFVFe/OAlsMpHEJIxpWF4aLmcw0y0z
	 4MDr+Q9Tew7x3K5tDWu7XmZZO4lbXdFzKEAtJ7rswVZ1K09URrAy7DnSYuODP8TfqC
	 dzwCh32bZvHNIwUQ6aelmzqJoGessmqA2Q8PmT9LVnw6egPO4nxruQZdo2DPAQvbNo
	 dEZa2pdtLShjcbl3JNj99YxmX6Qt6UZXG1X59wDLE6qTlZtozzPMAHeEa1SUiJNV7l
	 oO8uymPhkojww==
Date: Fri, 3 Apr 2026 15:28:26 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com,
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>,
	Florent Revest <revest@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jann Horn <jannh@google.com>, KP Singh <kpsingh@kernel.org>,
	Matteo Rizzo <matteorizzo@google.com>
Subject: Re: [PATCH v1] slab: support for compiler-assisted type-based slab
 cache partitioning
Message-ID: <ac9eCi0b33CYENpX@hyeyoo>
References: <20260331111240.153913-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331111240.153913-1-elver@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D30C240014
X-Stat-Signature: bwm8gbab7xm93zsza75hxpqwwsxuj57g
X-HE-Tag: 1775197709-861326
X-HE-Meta: U2FsdGVkX1/S8PkEKeDEnNmXo20CVfaDoy/CzpHVD8chjz+0kppaX/t5LwzR1ENP18ENTU17r8FF1w+lgGRFdWVJNhZyVLysvWfKQbsrX30gFNLnPIKMeElwIq4QPfwS6GSZsm+2k3Tc67f+KZXUND5n6tBai1bp0dsroRxBWqq5JF/LaUYiDNbjz4L0sG9bcjwY6jdKLIkwmB1cqsfa3k3rWDd/nNwHLjXCr+/rU6YvEbSjcbyNCcmJlIw7xBDkzUypBG2xtPZ68uFAGTeNKHhK2sW9ePDqKSFuIIE1dg5/WsZvq/TkISYp7/4kRI6fwyz9askvdSiMJf8SZ0dXuONjexRQ45FHIQy9j9u30H3oRxb8+lMowRasHlFUypq+6ZdyQI7tLIw68edQCWuXhWQccU8+Saom9KupZT17FShcd5mTPDLzXn4+QizRGUcZeIe776xwzfXErYTv+y56/r5e0bjjAGrIisoTXGBoYORuenMQ1ZFo1bZqsYos+z67r7X0lT0MogOrQu2oStG29i3U/1YpNMU4e3SBO+qcapAzfxwI/dqPuRWfQcZkniH0aEvEl/ekRUJr/lUY7s9U1Wf9nnP8bUBZaxdLEQMnUbch1UgIZnXq+7zBQWH9YY3wYp8uzdxFwQN4haUob2ek1i5Zm+RWZSXuhm2tCH5g0EU18HvE8NFys/lqXwwBEWCXcBMVk6HeYcZFcB5lv266DYLZTrPBhmYpKB6b1I6x3FwtRojCD1ULc+WilGMVcxkjC5A+6ZUBo/xsfrB7/WtZY7+biSzuvK2bAU/TciQx5QWWKEm8oFjRODDsKx5WjDSkVaeTdDnBfYz92o3RRD+eJYTjAflsM3lAFdP0EzGYGtmxjByXSgV0VxDSXGrCSVHYhkHHnM2M4NolvJjXt6xhP9Cn0dMVlFXyqe12ryauFvvNLGOfhfZsSVAZBd6Ar8I5vqjIdkt+C5Qxy4Uz1XZ
 m3Bq1oK+
 aBYZ3hDdl85CqPjuYTXeUoAbMQz9KKQ9ucJdskNeNqeQnzOQXKCsKHLVySAdVVKXrMY0RTDjgQBDj479HgR5QgrL99GUcCARx3NJrNUDPVaEq2mjwDaL7bW+6zyemwjuETrIJmvfqSkipcwJcZZQUUDfb10niSB7W6FSmvjmJaXlJjSg/u/AqpuXzJA2Us44TNj1LOGyzwHgm7TnXgW3j5JzGDfv/dOmFRxMQegiEYsR17vxfB5vWxLmAnF62jLYf7Ti/MuBssKEgOzM9GkwwVQTf8irfqTkAJpnQvs+mr1KBK/xxEBYkUUz0TLZuwFGUmkZmT+bYbB6Lu3jI96K1sRbk7BWOoQTPelRBTTDPosmQM/Tupywi7KajE7GHGWOIq/iRqhBlYAHPZ/hfDZOwrb2IjwrTJxLm4n5A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now somewhat out-of-scope (or at least pre-existing) review comments
from Sashiko that I think are still worth mentioning...

> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -662,9 +662,20 @@ extern kmem_buckets kmalloc_caches[NR_KMALLOC_TYPES];
> -static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags, unsigned long caller)
> +static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags, kmalloc_token_t token)
>  {
>  	/*
>  	 * The most common case is KMALLOC_NORMAL, so test for it
> @@ -672,9 +683,11 @@ static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags, unsigne
>  	 */
>  	if (likely((flags & KMALLOC_NOT_NORMAL_BITS) == 0))

Sashiko pointed out KMALLOC_CGROUP caches are not partitioned [1]:
| Do allocations with the __GFP_ACCOUNT flag completely bypass typed
| and random partitioning? KMALLOC_NOT_NORMAL_BITS includes __GFP_ACCOUNT.

Right.

| If this bit is set, the code bypasses the partitioning logic and routes
| the allocation to the KMALLOC_CGROUP cache.

Right.

| Since user-controllable objects
| like msg_msg, file descriptors, and pipes are allocated with __GFP_ACCOUNT,

Right.

| they will all be clustered in the exact same unpartitioned cache.

Right.

From security perspective do you think it'd be worthwhile to partition
KMALLOC_CGROUP caches? (I see at least few hundreds of users, unlike
KMALLOC_RECLAIM where there are only few users).

Another valid concern from Sashiko [1]:
| Does this leave reallocation functions like krealloc() and kvrealloc()
| without allocation token propagation?
|
| When an object is reallocated and requires memory expansion, the underlying
| generic SLUB code allocates a new buffer. Because the token macro is not
| applied to these realloc paths, __builtin_infer_alloc_token() evaluates
| locally on a generic size_t variable rather than the original type.

I think this is a valid point and worth addressing.

| This causes it to return the fallback token (0), which silently migrates the
| object from its isolated typed cache to the shared fallback cache
| (kmalloc-part-00) when resized.

[1] https://sashiko.dev/#/patchset/20260331111240.153913-1-elver%40google.com

-- 
Cheers,
Harry / Hyeonggon

