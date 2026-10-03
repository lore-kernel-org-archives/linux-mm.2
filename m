Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A86ACA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 23:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2352F6B008A; Sat,  3 Oct 2026 19:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E71F6B008C; Sat,  3 Oct 2026 19:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5F86B0092; Sat,  3 Oct 2026 19:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBB536B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 19:13:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4856F80A62
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 23:13:20 +0000 (UTC)
X-FDA: 85282868160.03.AE15E93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id AC038120004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 23:13:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ACFoJW1Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791069198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkWuqiqDosdsTbfepDgk4n0A+zN7/i6H4vHC4Dh3MNA=;
	b=vi+yqVJsoO3AXsM7kYolECtO8HVm5wPAOLYfIg58+jJnyxZRce2QSVqCb3rAXLb/yf5YcD
	vsNrcilUT5468hbEaUKX1rh/6BFzFzuRG1rE1Dl4a14rQoZYoP8ueWm0bGh266ai9VD5kv
	VW5ipe4y7EKjGH5MrqdB9qsO+aCCvd4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ACFoJW1Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791069198;
	b=UX70qm9tKy4eVleqVeTLILUPEQC0CNRnFQPqGfsYLbBgu5taOVGjfPlZjz87y9br6MkLkA
	VbnJ1k2LsiLmdRcN1l4qhb3P97iqeu7qQ3W+0KAMtG/ZLR3QXJmPTxlvBaHOr5zRYufBMQ
	W6SjFTmrUiuQ2JovtSg+iwhe8e05tVo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 045E060052;
	Sat,  3 Oct 2026 23:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E391F0089B;
	Sat,  3 Oct 2026 23:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791069197;
	bh=kkWuqiqDosdsTbfepDgk4n0A+zN7/i6H4vHC4Dh3MNA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ACFoJW1Yqe6PGgxJwf2F0m/u9oHT/ybq1nr1yppwIboE848XqG6pzYYuviGG+XCGl
	 YUbMHVEFd9oVT7MfpDDrA23d0TxDAuYAZ63q7j0MQ2mgC+4BEaBPMQdbh0hz1VtBOE
	 6HqqMocAtP58uJ5lkDb1cHZDiElUuGDZyFfUruArUgEAFZu0Ouy9zoKL8essQKfWGZ
	 yUpTIqmrR3CTfDmGmojK+aTk0hS43+4y9Dpy7HN4LnLktfsfrGp0mbIf3SHlKaud+Z
	 M1zLOdD+exlMggRd4CpZqTfLin6nAkRuEGzMOkQwToXb+PJywA2c+YGnmbvI+TkUXs
	 bQyW+AeOMWrZg==
Subject: Re: [PATCH net-next v5 2/7] mm/slab: Let kmem_buckets_create() take
 an alignment
From: netdev-bot+sashiko@kernel.org
To: kees@kernel.org
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org,
 hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, pfalcato@suse.de,
 kuniyu@google.com, linux-hardening@vger.kernel.org, davem@davemloft.net,
 hannes@cmpxchg.org, mhocko@kernel.org, shakeel.butt@linux.dev,
 muchun.song@linux.dev, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, kerneljasonxing@gmail.com,
 willemb@google.com, almasrymina@google.com, bjorn@kernel.org,
 jiayuan.chen@linux.dev, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 netdev@vger.kernel.org
Date: Sat, 03 Oct 2026 23:13:15 +0000
Message-ID: <179106919567.434549.8926945061923138895@kernel.org>
In-Reply-To: <20261002231132.1646573-2-kees@kernel.org>
References: <20261002231132.1646573-2-kees@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Rspamd-Queue-Id: AC038120004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: cidss8z6efmeoer87gorhdtz47mifn9z
X-HE-Tag: 1791069198-203341
X-HE-Meta: U2FsdGVkX18Z9t1WzxM3j/bSXvJlo2kvfUbd9qmjVVz2d4OykaKxJD3k4uxgyWGU32MyYNHkJbsw44YD0LIzS3+69othhqQB6duY2x/XSMTLeDTjw/pNRdnWjvvRTumE3J/c1nruNgZjNwVFTa37piTs+d7iBA9JiCnj0KdWW9uSTFX0fibSujHO/GnkICpFPxDRBFb19EWhmbXzyGkbuc8jkdPpVT08R4LW2n3lw8tdBkmtYukfCWMH8OYWuM+AgBScWPsocEx8XEdNM0t0kDLfja2yRDz7y2xmvd0wU6KdL4pYKjU6dyUOZRiTJYxqoEUoeAW/Zb4VfjAhHyqguP43L9Hs1ErVZpQohT05Z9M8+CS8mdLdWQZD+iy5c4Fs5WbkOjhlrz6PtkE6mHpXFZMQKetMZjBE7etC+v6j8dTrwkhAyldK/qAhVjcAexnwdJjGh10/vNS3JO7iCCUjFQ7NHhIl6csTs5y+Da45+D1AQT33vozHfjfeDPorM1q1eGe+nTt1fBtGUcDjt1506UUvGiVFNBjAfEbkI4U8YmeP4WbOe9cx3OUcqK0LbFLP8klRdRlk0E2xW0nhqPp4A6JsdtyjULtBrfI4Gi2EOTAx546QtDYE1nVbY9+Gs64EB3r8HI9muyGonNWLnOrl/IYdX5wzDWKa4avVJ8dIEXW9DuOzRc4JUGsLpvT/nQ1zB3tP3VkHWakjarZHws2Sq7ESe0bNdapw0SSvsixljVN67k529yQzHBoh/UNZ04LVlJxyZcjX0Y6EzTEuQupFjFemOQYz3UPVTZ9XqajmewgjL6uSZ0KRMBakzx/inGixqNRBaISKd4/1xOy5W+A6AKzQsNp+oS2uYEz4OjmyqWGKw2WJs3ueZujGcUGaC7av7ckl+Hx/keOrm0fN7G4y5AedWlAr67O+N3CXIdLStgJ2spBOUXuj3QF9gXeHHDUwJ+h7BGy2W18fauwcXJy
 gRKqyDb4
 ZXhv99v4n+mDvr/8L0TScb2Oyog7/Ri0P5gJ9XWi9VQSpXCPEIyz+zUoFNLfpMbCGx2pq+zEN6jXYMr4BDhlP81qDGIPYPDUVVTOxCkv/bRLMGMStwB4qvQH2a73iLf3sJwtPdM1He4wD1lXVmKKlj5U3tBc+FsvgX5Hz8rg4qpAOTAROQXG7grdTzxgQCPv3A7c+7OHo+p+hiCnzyTc8H9s7z9wcPuWcWEKFNoO2q5o3sGxCHilbjJ9NPg57rWIWXijaBRCJnKF7dvLhgIhJlOY91sa3BUQbZr65wTIBth+3NuYSk+8M0SqgnARAYn6iCcb9vdmGezIyilOeKmxK33oUOyZH1n0/Bjg+5b6kvdjY2eg6mujQX0ZNj/+Jf+dvU3dMe7GeePO4tvyOKrRi0wPIIFRJPFJc7FlhW287UD6HFO6suzae+jSQJPSRvLM8yWNxeJwMOW961KKmechW925IKS8CB7WkIalGbbhFjFfa4p8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] When kmem_buckets_create() gets a non-zero @align, it uses
  that value as the cache alignment instead of the alignment of the…
- [Low] The new kernel-doc for kmem_buckets_create() (mm/slab_common.c
  lines 418-420, copied to include/linux/slab.h and…

--

mm/slab: Let kmem_buckets_create() take an alignment

This commit adds an align argument to kmem_buckets_create(). When align is
0, each bucket cache takes the alignment of the kmalloc cache of the same
size, so bucket allocations match kmalloc() when slab metadata is enabled.
Both existing callers now pass 0.

> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index b93fdb5cb0219..71926f726a07a 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -415,6 +415,9 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
>   *			 allocations via kmem_buckets_alloc()
>   * @name: A prefix string which is used in /proc/slabinfo to identify this
>   *	  cache. The individual caches with have their sizes as the suffix.
> + * @align: The required alignment for the objects, or 0 to give each cache
> + *	   the alignment of the kmalloc cache of the same size, as a caller
> + *	   moving from kmalloc() may depend on.

[Severity: Low]
The new kernel-doc calls @align "The required alignment for the objects".
Does every path covered by this doc honour it?

With CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() returns without looking
at align:

	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
		return ZERO_SIZE_PTR;

PASS_BUCKET_PARAM(_b) is also NULL in that config, so allocations are served
from the general caches.

When set creation fails, the doc says callers can keep using the NULL
result and that allocations "will fall back to kmalloc()". The caller in
ipc/msgutil.c:init_msg_buckets() never checks the return value.

In both cases, kmalloc_slab() does this:

	if (!b)
		b = &kmalloc_caches[type];

The object then gets only kmalloc's natural alignment for that size. Take
align=256 with 64-byte objects, which is the case in the series' kunit test
(the test skips itself when !CONFIG_SLAB_BUCKETS). That caller would get
less-aligned memory on some configs and see no warning.

Later in the series, allocations of kmalloc types the set does not cover
also go to the general caches and lose align in the same way.

Should the kernel-doc say that a non-zero align only applies when the set
was actually created? Or should these fallback paths honour it?

>   * @flags: SLAB flags (see kmem_cache_create() for details).
>   * @useroffset: Starting offset within an allocation that may be copied
>   *		to/from userspace.

[ ... ]

> @@ -487,7 +491,8 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
>  			if (WARN_ON(!cache_name))
>  				goto fail;
>  			(*b)[aligned_idx] = kmem_cache_create_usercopy(cache_name, size,
> -					0, flags, cache_useroffset,
> +					align ?: kmalloc_caches[KMALLOC_NORMAL][idx]->align,

[Severity: Medium]
A non-zero align replaces the alignment of the mirrored kmalloc cache
instead of being combined with it. Below this, calculate_alignment() only
raises it to arch_slab_minalign():

	align = max(align, arch_slab_minalign());

Nothing raises it to ARCH_KMALLOC_MINALIGN, ARCH_DMA_MINALIGN, or the
power-of-two size alignment that create_boot_cache() gives kmalloc caches.

Could a caller that passes a small non-zero align end up with weaker
alignment than plain kmalloc()?

kmem_buckets_alloc() goes through __kmalloc_node_noprof(), which is
declared __assume_kmalloc_alignment. Some architectures leave
ARCH_KMALLOC_MINALIGN at its default of ARCH_DMA_MINALIGN. On those, an
explicit align below that value, with KASAN, SLUB_DEBUG_ON or slab_debug=
enabled, would break the compiler's alignment assumption.

dma_kmalloc_size_aligned() also decides whether to bounce from the size
alone:

	/*
	 * Larger kmalloc() sizes are guaranteed to be aligned to
	 * ARCH_DMA_MINALIGN.
	 */
	if (size >= 2 * ARCH_DMA_MINALIGN ||

For example, take align=64 on arm64 (ARCH_DMA_MINALIGN=128) with slab_debug
enabled. The 2048-byte objects would be only 64-byte aligned, and swiotlb
would never bounce them. Is that the same non-coherent DMA problem this
patch fixes for align == 0, just reached through a non-zero align?

Every in-tree caller passes 0 through the end of the series. The only
non-zero caller is the kunit test with align=256, so nothing triggers this
today. The comment in test_kmem_buckets_explicit_alignment says it "checks
the override both ways". That suggests alignment weaker than kmalloc's is
intended.

The same expression appears later in the series in
kmem_buckets_create_row(), as align ?: kmalloc_caches[type][idx]->align.

Would max(align, kmalloc_caches[KMALLOC_NORMAL][idx]->align) keep the
kmalloc guarantees that bucket users and the DMA layer rely on? Clamping to
at least ARCH_KMALLOC_MINALIGN might also work.

> +					flags, cache_useroffset,
>  					cache_usersize, ctor);
>  			kfree(cache_name);
>  			if (WARN_ON(!(*b)[aligned_idx]))

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261002231120.late.500-kees%40kernel.org

