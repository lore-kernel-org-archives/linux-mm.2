Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2B46CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 08:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 277906B0093; Fri, 12 Jun 2026 04:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24F996B0095; Fri, 12 Jun 2026 04:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C776B0096; Fri, 12 Jun 2026 04:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 071BB6B0093
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:03:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1D7B1C3AC1
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:03:23 +0000 (UTC)
X-FDA: 84870520686.21.884FD34
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7261B40002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:03:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rn3tCeCy;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781251402;
	b=OLOGBhQ8Bw9h9pGfMs1crk0DkYi3KOcwrwJJ1mTC50vCC8CokyJElrJx8Dg7736bBFuiQs
	S95rwg7uY21eiG/W1YyUgoZhAGjZfhYCAOA2rQ9LBDD99t0l6LHSqIg9lAPoJVZLeh9vzS
	BIBjmNP8tC9q0Nx/h7fERTsDT2zCIGg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rn3tCeCy;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781251402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpaBDcnd03Rl1JTLs5faOENgBW+ak0IDfAB1rJ8oj0g=;
	b=Qpvo7TfHRZX8aK8NniaCidWuSGgHdJbbyqQRYBFqLe0bKr2m7xtIgaKR9wPcxiYEOZtE2V
	OKhYVjQUO1o3SxMrOKDnfR0tFI4iWMnMSsn7vgA3eay8QDKJZbRDvciaT0SxuNqgTT0QVl
	wMTQM5VxqKoB9SMqVGcOHUfK1JmDb+4=
Date: Fri, 12 Jun 2026 16:02:51 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781251399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cpaBDcnd03Rl1JTLs5faOENgBW+ak0IDfAB1rJ8oj0g=;
	b=Rn3tCeCyjTYry5rK2dNU3DI/xAdxSKj6UZkgMeIHm/Wse+dqXRXkzq9MGHfpePUU4F1wAA
	NpMELWWqM5o7p05gBoEaZXDiVcggeTFsoDVIGVUuIABHrcm/RfX/13pdoe9vyqGG/oHZ6+
	b/xyQ7UFNPSsJXyk4iddelK5Ls3LSj0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 14/16] mm/slab: introduce kmalloc_flags()
Message-ID: <aiu8W3EQhalCP9HW@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-14-7190909db118@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-14-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7261B40002
X-Rspam-User: 
X-Stat-Signature: qasaprmuzx3xw97brybpsm6sf6ngnjf4
X-HE-Tag: 1781251401-799923
X-HE-Meta: U2FsdGVkX1/4bQ2rzlqO9+FtcUsns9Ap3zcQwpfko4Wb0u7JuKjIYkLqLh8BgTZ/90N4PzynEDSlLYAKquN3YhY9GoZBcbRciBlGDfMzBx2nrsR4QAV/t930F9PYhb3vtrkfToA+2MXjksioNn6jZ2VOMxLttHtYzwovfqfGlrrZjg64CDV10bVgviPgFSbJaS4NSPHVYKvX6ZKZJ4UdsaNm6d6l7q0X1t1eb9ZWfJjLbE47blPE7kNA+M++bfXwuoqHWxEsM8tJz01bD7TGWUoZSuv7TjmIkqA9zE9uZiIGYR9HYZo6yJruGRAgXYUlOxqSrQZIkFDw9pnW1k0WKrB4eQIMK44FBnRUwVOEwzg+HQKQbIGi+wDdAllcppg/pCv34q+TiQ5MvchL+0FJR0j7wQY2lVU4UA5rhCSEj2WerADvu0INtOlvKcMuxxR5VNOd42qqF6M118ma5OgLKdIeS2sYGkZaf5TRD4JYb1CQNaUnuMCPgYOGzPpPsVuxK4VKdcE/D85xnfv3Gw/ovfysvDTDOwdL4ERY+jZojcMo3lhWAwxGdlKJ3bCIJfnuxxXDJsgbQyhSJ2eWmiIeyWW80FenPc2vEMZT6Jx3xzaHAu6EMe2neY7KqJCOJwToJbHUQQe1EAnxUwHWZHkN4VnvIGlNPwp19YEF8lzWfMBzVFTc2afIclwLdB4HEdRGCH6PIrnQCoTbF1BykGFdOA8vn7Tt1NdAGAXikiJUeUMb6kgNR7YL6/o/+56A4zblEa9Ro0cwO88Zo1FkEvKzcHncg4ktTjSs+ZJ2OEuVz7NN8o1HRkUGxKMT5Xl8/YrbD0UXJTVxKhT3t6ZA/1TqGhRvgAMgj1jX+UtXhNN+zQ+3Jsrz8VW4iTv7xcb1/HHuo9EYjit/4qvJY1rCsXTGMvT8F8oUqeY0Sop81hBzlGhxK/J/3XSYHDx9EbmgNTSirheB00GEWN1M/VI920L
 9s/Q3zV2
 d89UrY+7VoMkXcIMQbyyNXiXHs1BooRQ6/Q2WXG2Q11Y0e5e7H9QBYQzsH2TRqeurAhA/AfQadbU2IYezj8HzW8YcLvrz44/S0N4EIW1Ls8GadLthk+pZLywQZQNRia8ZlwHzw3JrJxV1e3JBWs3RhiyFSf/ioEm3BbAjmfhjYahtLDjvur84fSmRpIFFZ9ybk21uxyWD0OGDG3kU5aDxWyaiJ3GvvC9I65qUNw2iU524Q9hcpqcl6fxvkPmGY35C+fdIcliwVc1Vt3QSktSWa+bzCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:40:16PM +0200, Vlastimil Babka (SUSE) wrote:
> With alloc_flags usage in slab, we can replace __GFP_NO_OBJ_EXT with an
> alloc flag that prevents kmalloc recursion. For that we need a version
> of kmalloc() that takes alloc_flags and use it in places that perform
> these potentially recursive kmalloc allocations (of sheaves or obj_ext
> arrays).
> 
> Add this function, named kmalloc_flags(). Right now it's only useful for
> these nested allocations, so it doesn't need to optimize build-time
> constant sizes like kmalloc() or kmalloc_buckets.
> 
> Since we need it to support both normal and non-spinning
> kmalloc_nolock() context through the SLAB_ALLOC_TRYLOCK flag, split out
> most of the special _kmalloc_nolock_noprof() implementation to
> __kmalloc_nolock_noprof() that takes a slab_alloc_context, and make
> _kmalloc_nolock_noprof() a simple tail calling wrapper with the proper
> context.
> 
> kmalloc_flags() can thus determine whether to call
> __kmalloc_nolock_noprof() or __do_kmalloc_node(), based on the
> given alloc_flags.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

