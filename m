Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30FDAED7B8B
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CAB06B00A1; Tue, 14 Apr 2026 04:39:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97B476B00A2; Tue, 14 Apr 2026 04:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7C86B00A3; Tue, 14 Apr 2026 04:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7EAE06B00A1
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:39:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 33BC31A04D8
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:39:45 +0000 (UTC)
X-FDA: 84656513130.07.C5286D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9567840002
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:39:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ckPJXq+q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776155983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MH06MgtqpT8TDUJJ0rXetfEuxYP0gdx43mesSQYu6/Y=;
	b=B37UxL+mbr2Od4AbrUutVUCB2SDSYuaDTgcrCs/uGRG9E/plnl8bz95YC622lWQmRw2lzJ
	+im9EeHsntKdwQBiiBJedBxfQgD93ns4TwCECEJVjoSy2s9ZJAxYQjmSs+7+hdKcsfhgM5
	aHp5QDjveaPZkX1r676ZV18uEGth+Ag=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776155983; a=rsa-sha256;
	cv=none;
	b=T8ALVcPOI73BL+3HcSVo2iRgPEU+gzYKmbjQq/bXigkaYVvg1cdiJq6uJf8XY21yaTsuXg
	xW9CBUQgTiYrYi8A0177HGtLSs30Uf8ZXDhk0FjJSLg6UHKtBgN7kUy4qLzmB2zKyNDivV
	QyFWf9+b31nNwNW2XsSz4Y/Kbpphzi8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ckPJXq+q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E891560126;
	Tue, 14 Apr 2026 08:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4077EC2BCB3;
	Tue, 14 Apr 2026 08:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776155982;
	bh=dTsKf5QGkHEZ0NirCa4nKFVsSG+K2ezLehSVdRT7+Kg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ckPJXq+q85RoKzdyUiC0AsL/P7iGhIrZCQCSTIMMsCbDbomk9cEU7rozdFd9dy713
	 OvChzhC7wLGFpoWFTLdWwZ+OQ43uJUKC7W89yoKUQTQbrYw1m2Znw5oJpqQZm/r6Bu
	 SOsUs9hes1RYE4F4VLb2z2gzeL3pMZzNc+opt2ynkg7pCkwWA6w3SZipIfpI7SkotV
	 4/pyMet9KeIsH1DU9frghV1TKtdZxjOtZNz7EVT1uxtewR1YWL7ZhLsupKE6HzGsJ8
	 F0Qur5pRvAL9PrwM/URHPUc2Pg7PPvOLYR7NpdPdc/h5/vxgWmRWG2TKxKPmUcHEq9
	 MWqQjwXBdbonQ==
Date: Tue, 14 Apr 2026 17:39:40 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [RFC PATCH] slub: spill refill leftover objects into percpu
 sheaves
Message-ID: <ad39TJZYLItrEnIM@hyeyoo>
References: <20260410112202.142597-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410112202.142597-1-hao.li@linux.dev>
X-Rspamd-Queue-Id: 9567840002
X-Stat-Signature: yytyy3d1jbf9iyxajwcioc518k3ot7r6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776155983-930639
X-HE-Meta: U2FsdGVkX19QyfAEPNAZiLS72dO5zvIIlAdPdn5DGAbxohlCZYGsb9iYsewnGJshMX/gE6nQiPe/jk3ANUV1R52k86To7VHpNUK1ev3q793ZN97EZpfJszn9IFX6fKzR71/qw0SvqU/WEHbqRZzUtEXNO4BAdHwjO9INXFOHf65b1SkylUgnBqGwJu3iAW5bN7K2RWVS2+6WNlWRcpO5D5nBW43iCVcM/TwUoGUCFlcwx7zSSLqL4LOzPCrDkH/nmzbA+ojNydQyjKwpzmhj0UeXWzTO76IjzRfh2ee/wGbKszCNo6ElTOpB19/5cmLRr5KU7h/3Wxe0lS4RLUA+8aPD8umw/eyRLtiYqfkzx1nD1Ujt8JqqqQdImuzb94ubDz8S4qHcUKnf6aVqXQflZK4tVHCilAqCCU+JKOWv/kX2ONWyb4l2U7dwbNxWgj+c57nB24aQB4Qx2BQtDBmxDwBw7tQbpqP0KENIgxyx/bl+JqSI1jTy1s2yD6pNAj9Kl7jTKCqMjn9PChIsfbnONFvS4J1lqqibQSWSJaJ7YNrAjbCcNRB5ddkK7+qk3VmfRbs/M2oIHe6Xjj7958KgZiVDqbkiCLUAXqXPse60u/vfEZsTN/1TqBnA0B+0RoAgDdQdxbjoZfYBg47SFEK/KcKXpMoygQQttYC3dTgOmSxobdWeeSqAToVGUumnacuNFTKGD5KFSA4AL/llmLAC9mZPf8ftP1aVYzRzZaFCaPdtwXvJyr+YbLki+KcgGDkpjCjnlEoScLEtdAoNTcdFn1ZR1XFieBHpq4t3zq/hJSxjm3kpfOVzIzmumeC9Koa80WTJF8gqzjn6n/aakmTXtoxyyhvBRDm/BItFWkoIclq0++obJpFHXpBxdVV74NvHt4PrZvJuOyqHWO8NIoN2LqG3PXjenojIZvpI2kqMNhzwR1njRGxBMebzlXSW7hrdFy3CUCeOU6s5N4OHHTo
 fMQtVT20
 6hEuzcicbFqIexgk2ZpDfNybGn35junkdZsBpLFnO5z+jWi7sLMVuEIdz8BQMk2w8zxX3ZVONHM8moMTQ/vyq2CVvzAyEWQU4dDBCto7zvBw22jzjNJZeUTYiJYJA1e8rx8I8VyoRqjIsaLTBg7px4kET3rA7CEY9IpHsaikv6C6P6FCSOGauRJZj802T14z6KsWuPIEEamP/Wmx51vRVSqCL+BsA+BMVeqtuVfxZNHwkGRbuqS4aufCNOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 07:16:57PM +0800, Hao Li wrote:
> When performing objects refill, we tend to optimistically assume that
> there will be more allocation requests coming next; this is the
> fundamental assumption behind this optimization.

I think the reason why currently we have two sheaves per CPU instead of
one bigger sheaf is to avoid unfairly pessimizing when the alloc/free
pattern frequently changes.

By refilling more objects, frees are more likely to hit the slowpath.
How can it be argued that this optimization is beneficial to have
in general, not just for caches with specific alloc/free patterns?

> When __refill_objects_node() isolates a partial slab and satisfies a
> bulk allocation from its freelist, the slab can still have a small tail
> of free objects left over. Today those objects are freed back to the
> slab immediately.
> 
> If the leftover tail is local and small enough to fit, keep it in the
> current CPU's sheaves instead. This avoids pushing those objects back
> through the __slab_free slowpath.

So there are two different paths:

1. When refilling prefilled sheaves, spill objects into ->main and
   ->spare. 
2. When refilling ->main sheaf, spill objects into ->spare.
 
> Add a helper to obtain both the freelist and its free-object count, and
> then spill the remaining objects into a percpu sheaf when:
> - the tail fits in a sheaf
> - the slab is local to the current CPU
> - the slab is not pfmemalloc
> - the target sheaf has enough free space
> 
> Otherwise keep the existing fallback and free the tail back to the slab.
> 
> Also add a SHEAF_SPILL stat so the new path can be observed in SLUB
> stats.
> 
> On the mmap2 case in the will-it-scale benchmark suite,

> this patch can improve performance by about 2~5%.

Where do you think the improvement comes from? (hopefully w/ some data)

e.g.:
  1. the benefit is from largely or partly from
     reduced contention on n->list_lock.

  2. this change reduces # of alloc slowpath at the cost of increased
     of free slowpath hits, but that's better because the slowpath frees
     are mostly lockless.

  3. the alloc/free pattern of the workload is benefiting from
     spilling objects to the CPU's sheaves.

or something else?

> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---
> 
> This patch is an exploratory attempt to address the leftover objects and
> partial slab issues in the refill path, and it is marked as RFC to warmly
> welcome any feedback, suggestions, and discussion!

Yeah, let's discuss!

By the way, have you also been considering having min-max capacity
for sheaves? (that I think Vlastimil suggested somewhere)

-- 
Cheers,
Harry / Hyeonggon

