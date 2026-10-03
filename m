Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F48ECA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 23:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40A0B6B008C; Sat,  3 Oct 2026 19:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BAF56B0092; Sat,  3 Oct 2026 19:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 234F16B0093; Sat,  3 Oct 2026 19:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7A756B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 19:13:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 046111C3661
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 23:13:21 +0000 (UTC)
X-FDA: 85282868244.08.0C62C10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5CB51140003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 23:13:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bej0s0NJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791069200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjdLeITgvZLNhUTfFbAwoCm4iJ6OC8058r//qE36TfE=;
	b=LUEYosrJN+zyO9r+qCPdauZkgzBLGOhiF4abCmP65qg3UjCtFMjVf4V9fJXSMtB/sgBwin
	fy8ya7JNU9pwuBjmD5b3HbB+QQCoyLoeMHAvw/hAua6dXBwdKoKh56cxqeo14lRWF5QN9s
	ZygZPhMRaSOsA3kWgBuDEU0WFjIwA4M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bej0s0NJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791069200;
	b=z97kDtjSDqxBeLNjSi6bAMWayNucx1Ngcd9hPRQJx1WVgTdqLc9zsF5XaGXcBOXgqgsIN7
	pW9098c8qqfBbqJdytSc8A3ju5t28XJAzC0td7HUUWA3Lnj3cXpaLtrtO2t/zkLdNMuwmz
	nGWor6jYXqbA2Gr4kwQ0+VaZs69lIbo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EFADC6020C;
	Sat,  3 Oct 2026 23:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EF41F0089C;
	Sat,  3 Oct 2026 23:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791069199;
	bh=hjdLeITgvZLNhUTfFbAwoCm4iJ6OC8058r//qE36TfE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Bej0s0NJaASQzvzEI3tJ2yAj9Wz8FjWNRSLLb9vrlcUbicahh11ViNrcIzsFNv9SZ
	 VNqD6If/BUxrnMUDLp61l1jBFmz/dMAqXFyo0FIyWD2sw+dosk2gXuZEq2G4o87mMk
	 RAkkx00cpBitBnKZPk1KZS7ZQbeuXtqOHTETmSVnqbNvzXmcU/bidYY9TvTx/jdqX9
	 43tunTgAvDHU85VDXc25vioamh8euZEAfMEP852K8gGHxgYbvEG/TKK8qOShcXs0K0
	 V4pPxSWdduWDaAm2p5aZ5H5OFfEvhBg+ShX0f4eBSNLRrRF382ni++enIquZEV68S4
	 K3ln1PsxEZRqg==
Subject: Re: [PATCH net-next v5 3/7] mm/slab: Add kmem_buckets_destroy()
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
Date: Sat, 03 Oct 2026 23:13:17 +0000
Message-ID: <179106919785.434549.14247431491192293062@kernel.org>
In-Reply-To: <20261002231132.1646573-3-kees@kernel.org>
References: <20261002231132.1646573-3-kees@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Stat-Signature: puke5in6h8icse5nuxr99tbpiu75isq4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CB51140003
X-HE-Tag: 1791069200-280563
X-HE-Meta: U2FsdGVkX1/RgAIJZ8zuM5uSCQ/AiFDC5NkXj5pBrRm8iklOPl/jwJikMtUffLYeWV5P7pxuUHQcmHGm6nIsV8hArmf3lzAwGacGtKQPG5HiURKD3HniZVFjGxHcaloiArSXgfgCDoysVviyHT8dUyzZ8rxYrJ06Oe2tYmLCeARQd4T2TyhgFFwgwKZpKIuHGT01xNQW4qeHxlSbKWT/9Y2fEK6ZvYodVLkEwGmlP8l4bMHipTkNxWFS0brwmLZa91L35FY57v6zS+O1mzxi9dQ7piiwioCq2ueBjYvArPV1YNtc3xJ4lJN5iHZbUFe6krcvY+BtnYBPdkFfTZBSPoE/dDnhBcZXh1wh40d9hSnpK/NruYGyimKmdbhhPjZHN2pdFhKywZLinSE7dNDuiVFdFXhWpk1f2C5zrdkpR1xr4LMEnLu2D3oB+Gv5iCXoeIxQ4uldIMfuruiR8YxT2XAFjG1qyOKJlrOVPHJxPWOOUx+R1HZbp31xlKhG3YgRufp4kk4Z4PZnFqQeUM4AbJjlQD3shElZgVr/Qt0DrF315Cz8H/33tReZX57i3ma2CV2KmWrgQmX9i9gFG3AYmxr3D8cZxZ+xNuWPRi85ncjnCtIhcosQQyfVpa9X7z0PYxOCqDO7hDOntwinPyzD6s1aJKEqFaf/8W0Hruu2QpUfWfiNLdWOxBEzLPBz15+r5LaJ8tf3LZ5o7mn9NWd5u8KfAiEmml5PfcD0QiqrfCO0c+f/P8pNOsBEZdXkkDF2Lqjm+JlFfWsjB62h6jBhwFYZR2sKf2q7DZi8mTEnxp41vSqFMdGyvE0aQJhCiHPlfPelDUDzWVM0mmbeN+8QoeSEscN+exuvWLxcYHNetMQbJMBESeHU0Zh0l4nqdTQ0Hu7kWRQQ+OTDDiOioR7dmsZuD+i0TRbShNrLK3hBSh4qLR/VDImBjR6tYWb5Ap29Z5yJI7LD5H6WghsvLfa
 aU/Si1Bb
 kXKtgPhG/oWUTwke/u8UODZiHU9UImVifZog9mMJG+oaaeYM57HOGMR+86f59e3A7wkcJANy5ZkJyvDXH0ITEp5u2mPho3ukCn4+FDtAKQOm7kFHY7ela6ZC+4L1GQN/n3IT0vdP5ddJo4XmTZJoqBj4nDiFx6Ot87C1VP6bqPKMO1yAK1IX3JcaMzooqm/VUz3brH8NkxAtXIcOPNj4tOamRD07ydSU6dAzmOb1/nf2o7kvK8r9sMYjRJm+UNu0jKjLeWaVA/GLrwx/Z6wFxnOPOdfCHBf/RixtRISulajwc3Jfm04NQ+dASdEZopmJuG6DtxEkydvmTp5TIhR6E05La3Ugsi22Oo68M4WbyG0SgHPQ9RPr56vARet1kdX0DdPBBRMvPLX3x5QE/nkeQMS5cZDh+SybCtug9KGpK7zDISJle72XnLPlzQdAFOpWgkbSARyUVueTkhLLjvRMdyiEW43MfJ46mnr7GVpSMu8BumuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The new comment in kmem_buckets_destroy() (mm/slab_common.c)
  says: "Sizes below arch_slab_minalign() share one cache, which…

--

mm/slab: Add kmem_buckets_destroy()

This adds kmem_buckets_destroy() as a counterpart to kmem_buckets_create(),
so that KUnit tests built as modules can tear down a bucket set. The
create path's bitmap-based error unwinding is replaced with a call to the
new helper. The helper clears every aliased pointer to a cache before
destroying it.

Link: https://lore.kernel.org/all/20240809073309.2134488-1-kees@kernel.org/

> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 71926f726a07a..bdc34a5e6d6f5 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c

[ ... ]

> +void kmem_buckets_destroy(kmem_buckets *bucket)
> +{
> +	unsigned int idx, i;
> +
> +	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS) || ZERO_OR_NULL_PTR(bucket))
> +		return;
> +
> +	for (idx = 0; idx < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); idx++) {
> +		struct kmem_cache *cache = (*bucket)[idx];
> +
> +		if (!cache)
> +			continue;
> +
> +		/*
> +		 * Sizes below arch_slab_minalign() share one cache, which
> +		 * kmem_buckets_create() then stores at each of their indices.

[Severity: Low]
This isn't a bug, but is this comment accurate about where the aliasing
comes from?

The aliasing in kmalloc_caches[] is set up by new_kmalloc_cache(). It uses
__kmalloc_minalign(), and that is not arch_slab_minalign() on its own:

mm/slab_common.c:__kmalloc_minalign() {
	unsigned int minalign = dma_get_cache_alignment();
	...
	return max(minalign, arch_slab_minalign());
}

new_kmalloc_cache() then rounds every size up to that alignment:

	if (minalign > ARCH_KMALLOC_MINALIGN) {
		aligned_size = ALIGN(aligned_size, minalign);
		aligned_idx = __kmalloc_index(aligned_size, false);
	}

This aliases sizes that are not multiples of minalign, even when they are
not below it. For example, kmalloc-96 maps to the 128 cache when minalign
is 64, and kmalloc-192 maps to the 256 cache when minalign is 128.

kmem_buckets_create() reads object_size from the already-aliased
kmalloc_caches[KMALLOC_NORMAL][idx], so the same aliasing ends up in the
bucket set.

The code itself is fine, because the inner loop clears every matching
pointer whatever caused the alias. Could the comment say that sizes are
rounded up to the kmalloc minimum alignment, rather than "sizes below
arch_slab_minalign()"?

The same wording also survives in the later commit "mm/slab: Let a
bucket set handle __GFP_ACCOUNT". That commit rewords this comment but
keeps "sizes below arch_slab_minalign() share one".

> +		 * Drop every reference to it before destroying it, so that no
> +		 * later pass reads a pointer to a cache that is already gone.
> +		 */
> +		for (i = idx; i < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); i++)
> +			if ((*bucket)[i] == cache)
> +				(*bucket)[i] = NULL;
> +
> +		kmem_cache_destroy(cache);
> +	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261002231120.late.500-kees%40kernel.org

