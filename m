Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F846CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 22:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31FAF6B0088; Fri,  2 Oct 2026 18:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0D36B008A; Fri,  2 Oct 2026 18:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E65E6B008C; Fri,  2 Oct 2026 18:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDF6C6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:59:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6DC4BA0782
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 22:59:38 +0000 (UTC)
X-FDA: 85279204836.13.61C7F5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B8E9140003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 22:59:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HNfHSg1U;
	spf=pass (imf12.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790981976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJBZoitWEBQrTY8FcV1qjmfA5wNk/u7NZng6rYh3IJw=;
	b=iX0c5taf/2oTJE2EEsLWF42B7et8fRaB2AL4RelO8J22tc4mlKRMbGrdPNXvTLDejS+wzI
	zypZN/zFp8FpI6WUYo5wHFSmoqtu5hNBYGi6DWWuNVoDEg6cUR3bizvHT98Z+pDaJr0VaL
	bclBQPSuorr5m++YW4JJLnUGb9Wa4aY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790981976;
	b=k887qldc2y+crgBdDK6sarwt5rZWtXIQ3Rz1kpyZnRciNSAXwJ69+Pu/mW7RsmX6atvLaj
	bgJx+2ZNRavdn+vvzXYWAfIPo8+jCB+XNaxeiNJlkgXZ7SD9IZArRpI8mmR05tM8BZHtei
	DRhzVYyeFZcawzYbkAlbndmN3lN6cUs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HNfHSg1U;
	spf=pass (imf12.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A0E3419C4;
	Fri,  2 Oct 2026 22:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662DD1F000FF;
	Fri,  2 Oct 2026 22:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790981975;
	bh=JJBZoitWEBQrTY8FcV1qjmfA5wNk/u7NZng6rYh3IJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HNfHSg1Uf8VJletd/R2fu339SQf15SzodVIk+PgQjnibCGWW0FKaGqCJtTB9CsNHH
	 6ZUjgPXjwhCfn0EGwOSXZnhmp45GPc+8mBA4KIzr/toF9NifDgEMbBmB4wpIm6Wuoy
	 PGDxN8NS97pBFrWQT9d7hKP5mkCXJblmyL+hkEVaPn1KH1+pekc/czSzjfNxTn5i4w
	 2Iq0tz+X5nmVOxpuWhDIPmemZAOT9ihSSeBT885X0ojH1LJGqvnzh7JC6JlgbypVQl
	 HfjwRzYoVzwUGjpamhY/kQ/PSG3PTNTaVZ5goiedFc9jkBzMgkMLorUjrNGTzbdTns
	 xrxKXyue6TwAw==
Date: Fri, 2 Oct 2026 15:59:35 -0700
From: Kees Cook <kees@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>, netdev@vger.kernel.org,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 7/7] net: skb: isolate skb data area allocations into
 a separate bucket
Message-ID: <202610021554.58F5CBB8@keescook>
References: <20260921075811.too.775-kees@kernel.org>
 <20260921075820.1718334-7-kees@kernel.org>
 <8862b9ed-6f96-48c6-a134-6e8635c38987@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8862b9ed-6f96-48c6-a134-6e8635c38987@redhat.com>
X-Rspam-User: 
X-Stat-Signature: natcand4sa7n1ymencnqmwdwwau9kd1y
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B8E9140003
X-HE-Tag: 1790981976-850446
X-HE-Meta: U2FsdGVkX18ZMO/U8eVBNYol2qGPIaWohLmbor0xiQo4YN3LafdCPE1hl2etVWSgGo6/i7qPZ3OXSqfdQ6wXy64Yle6hFbZriW9w8+5uD5ghhx8Au8yISQeFhFCIGqm1ncS/cpSMimMo9dUQwLT5ve9AIcSiEOSmzvSPAM/ptaF4/FNupn3f0tEbfImLcs5OPws6B5gXg+CLp40eg2AKCooT6ltBohQpgZROfZf4FrnIzGJ590cXBsJAHv45S+BNh3SZYRGxA/tgmnynWTY+euVni8cgccZ7Xr6dcET0TeUg/PIvJCwD4WHnB8lBiZ9/egHBW/JzPmtTLD1crrG6/EF8nurHvsVFHzo6Hnv9roU4o52OZBjrui6Q/URRq88frcG5wpRuA2u/3Da0EoKow9U7wiCT+0SxmBsPXOHMQvtfBBrdb7YxHBMCBYj7oUVVcVRESNKJMo8h0EIPC5cu3ozJ5PME9jfRuz8qTEwp1j5lKcsmrxXWr4d/yPEAXdorw3hcKQ6ZHQC+4MJO18X0kJpt0TOVL6dT3IRWB1ZG4DxOceRjFDI/0PNgXq0+5P6Jrn1UpdcA9GheUw1iWzwyhUID71wkTU8kb199UqWFwLniCJ1khRnzP/ynKm1w0hCJRVNzllDSlCvEsztuXLsjudCCJl+g1fvWLSqZ5J4xY+si8VXnETFbqxPh9DScfEQSqxXaz9WjgFCfqNX4pIj70A5G+n37wD9O0M1TeBzaSrJN4kWF69WDxNfrJWBNRUdtNkBdLf4A/dMN3HGefz9hfX/N4mL6Qu64Hm5JEyZGSWGiwJ3zps8kTwMaBKwkDMtF3cqjZd4p8KyGqHv49rVKIp7g//ZWK/wEFtdGBMygsG+skOAMsmgc5+xoUd42H3xs5NCfZpXzp/GxELPNIyyPhdii2yGTcSMdozVEtWIU2jgKKI0Yf0CPR3Wy8Px8t8SehFZlVrlh6f2IONsDRFV
 4gmpD3Dj
 heA6yEdDbj7O6o2qUVvcFMbA8QB8xWpBmpiYmylx6DTZTWYL99KITk6bhgndSlA6d0Y0HM8S2RDqUHWiVYYbi/4ydemtoCXaedXEu0qX/S5ij7MHy6eR0GVS4PEmImzxfgh8/080INtZOXWSPcfvVqczEJn9PtFyebOPK9vWunJ3R1qlfEr5al8RVeXAaI9LynUObUaHdA2mGMe4kFZ+KsICaDe32eduhJ4Jyk6OpNCbUUppkaWMA0gMOo+tNlCdVjy6TIxI2kcqZW4z0QfTtqRZpHt/owSWvC22ym920iCx9QiNsXdvyP9mXrgK2dR+QVHfZDsG1obvqKF/dw8tjnvzZFhLcO8mFKcv5R+fYEIqQN5ToUI0KQoffJ5LcRvI38VPJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 27, 2026 at 10:24:16AM +0200, Paolo Abeni wrote:
> On 9/21/26 09:58, Kees Cook wrote:
> > From: Pedro Falcato <pfalcato@suse.de>
> > 
> > SKB data area allocations (as done from alloc_skb()) use kmalloc().
> > These allocations can be variably sized and their contents can be more
> > or less controlled from userspace, which makes them useful for attackers
> > that want to overwrite a use-after-free'd object from the same kmalloc slab
> > (which often just requires the sizes to roughly match into the same kmalloc
> > bucket). [0] is an easy example of an exploit that uses netlink skb
> > allocation to target another similarly-sized accidentally freed object.
> > 
> > While other mitigations like CONFIG_RANDOM_KMALLOC_CACHES exist, these are
> > probabilistic. Use the existing kmem buckets API to further isolate these
> > allocations in a guaranteed fashion, when CONFIG_SLAB_BUCKETS=y.
> > 
> > Ask for the accounted kmalloc type as well as the normal one. AF_UNIX
> > sets sk_allocation to GFP_KERNEL_ACCOUNT, so without it every AF_UNIX
> > skb data area would fall back to the general caches, and those are the
> > ones most worth isolating. GFP_DMA is left to fall back, being passed to
> > an skb allocator only by rare devices.
> > 
> > Link: https://github.com/google/security-research/blob/master/pocs/linux/kernelctf/CVE-2023-4207_lts_cos_mitigation_2/docs/exploit.md [0]
> > Reviewed-by: Kees Cook <kees@kernel.org>
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> I would be curious to learn how about the memory usage delta.
> However I see buckets are protected by their own kconfig, small
> systems can unselect them.

Correct. But here's the delta for a 1 node NUMA with memcg, which is
dominated by sysfs. 26 caches (13 normal and 13 memcg):

  sysfs, 26 caches                                          113,152
  struct kmem_cache, 26                                       6,656
  kmem_cache_node, 26                                         1,664
  node_barn, 26                                               1,664
  names, 26                                                   1,248
  the set itself, 2 rows × 14 pointers in kmalloc_buckets       224
  per-CPU sheaf structs                                 CPUSx x 832

> For the networking bits:
> 
> Acked-by: Paolo Abeni <pabeni@redhat.com>

Thanks!

-- 
Kees Cook

