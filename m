Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46AF606A332
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=ZjGjgkEj
Received: by kanga.kvack.org (Postfix)
	id 0824E6B05B0; Fri, 20 Nov 2026 04:52:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033426B05B1; Fri, 20 Nov 2026 04:52:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8AD76B05B2; Fri, 20 Nov 2026 04:52:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2C5E6B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:52:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F73D140E05
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:52:51 +0000 (UTC)
X-FDA: 85455033342.30.52BCE65
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf07.hostedemail.com (Postfix) with ESMTP id 45F9840003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:52:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=ZjGjgkEj;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf07.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795168369;
	b=DHGCONon+6iFY+s+CIXGFMKwb+GxnZ/tFhJz0w2I16doeaqsyScdiYALurelOZ6oawFAm5
	ZQ8fRhOWxlDP0OdsBytnK7yojAQMnEp9Dm9ca6+VtRQ5CxbMV/O616NycpZ1lM2jrFlBI1
	lOqV5ZUbsXU8OP2/0uqyXf1RI7C/YqM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795168369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWI42pcN1z/Hd5o40uFRHKZPgvOeoK3APx1Ezx3rCNQ=;
	b=yqhwkMSagwcKRU9Rkwp7hqXOkznsqG/hmmJQJ3mHXNka1U0KxaSYgNU7rCsOqtyjiEVNPO
	hukRqbfKZQpYzL7getoAvbLD2EVE3JdUdJFj32xpkXJNgLWph2YjkErRYigdwYdQtG5azF
	w39f+TEVXrkh1AV5qrpCLtQp9r7swhY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=ZjGjgkEj;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf07.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=aWI42pcN1z/Hd5o40uFRHKZPgvOeoK3APx1Ezx3rCNQ=; 
	b=ZjGjgkEjaAwURjO2ORIJHmEgyNAtDuXhDLBELVNjmH7N6D7EFTOozczmz5YZyc46EL2RCSmbNCI
	9HJjmo1qMXeFT+zg/2YFQmIq0I4aj3HhMZEk7+bOMIlv+9YCeiSss5xVFuVoeP9e6/fFt/MyA/f/P
	qqOGJRknuAgA5fO1qHpr/njyf6hXDb/jybHhSf1QPtDg1ybg+8CohyrDJp0RWUVUzh7Nu/FVqarsV
	pOE+y4leDJL5OrQnTmuftdexzmyGOjqGhZOx4axT8pptHMaL7EbQtfg26BUJpnMCku7oIQF7GCCmh
	mBmaxHUzXjH8vNg0V+GTnrBN/ZGHuQ5kaj1w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULIK-0000000HYdr-2Vgn;
	Fri, 20 Nov 2026 17:52:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:52:36 +0800
Date: Fri, 20 Nov 2026 17:52:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Usama Arif <usama.arif@linux.dev>
Cc: davem@davemloft.net, terrelln@fb.com, dsterba@suse.com,
	hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, riel@surriel.com,
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH 0/2] crypto: use vmalloc() for large stream workspaces
Message-ID: <awAYZHFnq2NBTDdA@gondor.apana.org.au>
References: <20261111153532.1036709-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261111153532.1036709-1-usama.arif@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 45F9840003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: fpm7ux3kgut95ph76sk9fsnbhac4iug3
X-Rspam-User:
X-HE-Tag: 1795168368-754487
X-HE-Meta: U2FsdGVkX19b88ZS61Q+jBNKhBfb6fo0RmhfY7NBO7VvfsaVw2x9OZHidiYQQYgrbgHmSg12SHkijUZ0OCnYwlWwJ60oX4TuAm2Xl4+xkn3h8hILMPF4VFfIrjb3pGv9zLx7XnCOmZVaQHAkMIRcS2BtPnAEXZ/uoGheetd/ksSrPLDsVKdRlW0FlqRWXPDfwUx1N+kMtHj+yDi7rW7b5RFZFLOwNVAMod4XDATeoZ4isBKRjPOTq/s9c1s/hxjKFgYJkoPnG9Dr73B1a4c886AFnDNVcnqC7fIo/h6w8J6gZ0HtOL+/7l9Kt9THxW7sPXa5tY8DKt9Ojb5AC4GBWDhecLZPzWSuf2Awz1kYIZ1XekD8vFAotpmN7QNyK9buMv9jcCo+sWLYA50IykvmlavNd+xceGxQyYtYL7q85hHto3hTPdfCcS6B1df4mwvY2jtZ18uSGHaCTD56odgIYDYBefbk3AcXUCcDFBalq8MKzZB9+iByFuwfqGttzX7RCLYMqC6gOZ7X+esUqjMy9O/CDeyUB5SlCRiEUk9EBlgqf3TaWA5Im12+JSdewY/mNqiNDO+G6TNkOW2kr/iFOcN97pTFkVrKikmMW7x7vSWU+lSWUmUd7n47TlBgKx5TuFhCrOM9EKoXroDXjf59S+g7WnZURmlb4yM8T7c5TTvO+EClXVcvOg0qLXJtRCcDJMCGtMnl8YHFYmaMA1nSsToAhxyJM/i3OelScQ4cZnDwa1Ggg1NVGupN5nVT20W1buK8yGXURg3eiMr4tfjUhfT21L/soRvMC5mNS/WnpJ9Y4DtDdgDdgHeHiAVQiulzs2E347ULl4E9UmwWXAVZ9e9kqvFV6DS2p76+3Y0/tVKQXKVyUZN8b8Kx1L3dO/+IWU4Z+D19WTZmF4hYhe5r2c8XrKTAsJNzzEDwOctT3wSADavtW7DoqU0QtY+e2SPx4N9fX44A/1pabYzpq+d
 rYM6Kxde
 L/pAAFUibLKLRZ+Awy5Ef74VLMWCAZMbmFbZ6cFxuvU1yVIOgRINony2T8YWJGTEVWiQr/iV9H4QSQzh8wpPDBibGYv42b3x+UanWz7GHpePU0tW0bd036WtiuomOGO0oSQafbBrz39t8TaiQZunr7CCOKc0dId8tiyEJf5bchTCIx70q6vR/7rZrg5ppaAivzFYq6eqmluJcuHiIGYX3FsziCWwMNPW3IUNE6oBhrMRZitpUjOMAWIX35SJ9KJEGb7J1/93idiPLjnjIiN+n+U3W5lpBYuYS1Jl6a/xpflSmbZXGnkwmVnLP0O7ALh5r6P65MnDDuUECC92+mhnWrpoA4LM/YkpyJJ5AcLyzs2fA0JzkTvqVbHZC+2itKcqkSU0EKQBHPF+T276gEDkEDrx/ln/Lb3G/m7JVllpIazRNYtv4tkScxWvPJYq53MPRVYN5Qfj2p1yHFe1Rw7rgXXgiUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 07:07:38AM -0800, Usama Arif wrote:
> The zstd and deflate acomp implementations retain per-CPU stream
> workspaces until the algorithms are unregistered. On x86-64 with 4 KiB
> pages, kvmalloc() can back them with order-9 and order-6 kmalloc()
> blocks, respectively.
> 
> Use vmalloc() and vfree() instead. For a server with 384 CPUs, if
> we have streams on all of the CPUs and kvmalloc() takes the
> kmalloc() path for every stream, their workspaces use 193.5 MiB more
> for zstd and 42 MiB for deflate.
> 
> In five before/after boot pairs on a 96-vCPU x86-64 VM with 8 GiB RAM,
> the test populated both algorithms crypto workspaces on every CPU. All
> 192 baseline workspaces used kmalloc() without these patches. The patches
> reduced workspace backing by 48.375 MiB for zstd and 10.5 MiB for deflate
> —58.875 MiB combined—in each pair.
> 
> In five before/after runs in a 4-vCPU x86-64 VM, median compression
> and decompression throughput changed by less than 1% (-0.93% to +0.64%).
> Inputs were 4 KiB and 64 KiB synthetic buffers containing pseudorandom
> data or a 50/50 mix of repeating-pattern and pseudorandom bytes.
> The differences were within the observed run-to-run variation.
>  
> Usama Arif (2):
>   crypto: zstd - use vmalloc() for stream workspaces
>   crypto: deflate - use vmalloc() for stream workspaces
> 
>  crypto/deflate.c | 5 +++--
>  crypto/zstd.c    | 4 ++--
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> -- 
> 2.53.0-Meta

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

