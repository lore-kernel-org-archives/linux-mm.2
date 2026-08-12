Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B30A9C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07256B00D8; Wed, 12 Aug 2026 06:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9908B6B00DA; Wed, 12 Aug 2026 06:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881F36B00DB; Wed, 12 Aug 2026 06:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 621086B00D8
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:54:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 553D1A01C6
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:54:51 +0000 (UTC)
X-FDA: 85092309582.04.5B9E4FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id BE651C0005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:54:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4Kol6Pv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786532089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gcj6Nn0OFnz4GVFzatZ7HMT0a0oMws6ttw7Nr/ddbvA=;
	b=FM+bSVMR9a9y+dYNjl7wOUkU0lmCMzMVDjLC7EBmWUbnZHClZ/KioLFRuUSk+TjfCHavAa
	wr6C243VEi8Q2SPuVJapKJpztQ+SA8Q3YnwmzHKInP6x5Xf7EttUlOBWd/lQsw0pZK5j1D
	mhP/B4KmlsiuqHx0lGcnug4OSnsAUz4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4Kol6Pv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786532089;
	b=pV1DIIjJcjkPBrhpq1yeILIujwKPZnpStgRJNidwFdRuMmY+scHMMlPNv+IsPF2bu8/f6Z
	GGs2/gOJOcCnAAbs1Jv01kTfdqj1hMkwjbGWWemZzRquf59pPGc7417mes/I9D2JfkiJgr
	ETDS2zi92yXUnrlQJyjyPYuizdu/tkQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 222DF600E2;
	Wed, 12 Aug 2026 10:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF661F000E9;
	Wed, 12 Aug 2026 10:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786532088;
	bh=gcj6Nn0OFnz4GVFzatZ7HMT0a0oMws6ttw7Nr/ddbvA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=e4Kol6PvyyOtzPhPagi2RlBVhqqAA7P1Cs2LzWOU5K1eCStNaPc4a99nRCN1UdI6M
	 vVZzjgAnLWr9tk7FkTojT23M+CeDDUgNibnxOMEvO/aH/86z7TvLYW1sJmAFChKosU
	 jOb4iwX4pOZjt0f4Sk/0O9kKwQ5P0C3SKbEgXXQ1cuPk+BJrDgvIMJiZZD1MltiHN7
	 p8Sw1hpDwgA0fBhzysexJXQoMAwQxwdXSngbgu/YZtBpNHSvr7VumdzRLyG7LUhRnd
	 xhP939zAnPaZvj+3SVQDPxWI33MKbkpvx8+Zpl75fN9mjfoa89wePPk5BNR9FlrEPp
	 +1+GaVfGdRPyA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Samiullah Khawaja
 <skhawaja@google.com>,  David Matlack <dmatlack@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] kho: Introduce a helper to init high order pages
In-Reply-To: <20260803113944.3694290-2-praan@google.com> (Pranjal
	Shrivastava's message of "Mon, 3 Aug 2026 11:39:42 +0000")
References: <20260803113944.3694290-1-praan@google.com>
	<20260803113944.3694290-2-praan@google.com>
Date: Wed, 12 Aug 2026 12:54:45 +0200
Message-ID: <2vxzqzk338y2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: BE651C0005
X-Stat-Signature: mh7b94ionx946t4o3194rhs93opobdtu
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786532089-539454
X-HE-Meta: U2FsdGVkX19/S4pxTVzPHX3uNCoMBhdlweg/M5uBenXQD4OTdl3pYHc8/OP5cy9mqb2R5swA2dKfLw8MMOWPy+jIsbbK6yJ6k3T9qpcgQRpFBUdh4sugz4d6I9uHjHYCbxU5piGEaXHV10TzvIM8JyleuE0QeXvgMAwAPvxQg7hIHG+NGSepPyvUpPpU0NG3pOX0+5xy0HifTdx6mHgDxXu2UvXfdvY+LZj+bYIIeHOYgJ9puNYgVNgtRdSYKA/4R+ohTNzRYLwmQDrwv9NeBFKSN0Jhp9eEggfWhZBDUMMIlHMr5dcPyge4BKtoGlUkuUT0FpCE3j6DcK7MDF7XbtSGnWSZZMU6iLAlsTBo8yDuq1Q/bzZ2AwnwJFlspncQ9AslhAZU8J++UASmMhjNaCmo3KhcgsLSlrtqnNHA2Qq2hCoXDVdmLW9nUSeYfm8Z7ZK51dD42d+JLYxRHzKnN0rGeqQMb9otxSxpVOPydaUTh5Kr6lXgSTGhzfw44qup/vt9uoN2vsqzUTP9TlmNGXfHN6nsiE+B/afH3MkOc+Kf9hlcKibVu1vL3tMCC1r5Px6s1W/3yeWK1si1De7P4h4AKiQkRPp6+JKjl7eEGwW28nXOpdzctrJ9u31fcziKkGcyBpfhK0nWqntWQbfpxwivgXYg9gC74VMwHTtB4TiNj83EGrLaP3WCTxUJjGBAe3myFF1dcw1xAJrgCBrj3sny9wHBX8+/JqbARgWMHbKGWQN2GD0lNUUy0K5Z74WgvBm2yOhJ+8cj72/bJAiSEWUumgFz3wnC/cTKaBebIgBw+Q2M8LUaZG0EDY9hmEj5peG6nXDnvfiJreW96xJ8EQGd7IdGALPdJttqyaEvwwzWoKQKwcUr+eA3W2xYlG49/l5rFFNmGvWW1iC2wPeHIcpSLfyx2SS99/4EHliV1uZuKYNJvwXnQq4prr7OhKIlO5Ft973iVkz5RxJz7/3
 7A6gmOa5
 Yx4pqrhyyKlxTJ4Mq0bjcjX2UMMdbfqYRDP7QBx+b/XLiHJXS8UKwEUogA5UTBLy/YuZWwWOX1s0X03wTlqG01FIlBxDIgNxlqbCpmEMqi4ItZU/gPScOcpQV33N/ikiCJDhXsrc1xZwjJr1ttBDnghl0ir52qIqRS6eeW0fzyesJ3qPpAxl2RRevqX6FjdMoojR3a5U9bMmbUEgkAPDt04kHI8xzC6W7Hx795c2Tb6cWMcI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03 2026, Pranjal Shrivastava wrote:

> The current KHO restoration logic assumes all multi-page blocks are
> split into independent 4KB pages. Break out a helper to prepare for
> supporting high-order non-compound pages.
>
> Extract kho_init_high_order_page() to handle the refcount pattern
> where only the head page is refcounted. Use the helper for folio
> restoration that requires a similar refcount logic.
>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Signed-off-by: Pranjal Shrivastava <praan@google.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 4834a809985a..e836efd98795 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -357,6 +357,24 @@ int kho_radix_walk_tree(struct kho_radix_tree *tree,
>  }
>  EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
>  
> +/* For physically contiguous pages. */
> +static void kho_init_high_order_page(struct page *page, unsigned int order)
> +{
> +	unsigned long nr_pages = (1UL << order);
> +
> +	/* Head page gets refcount of 1. */
> +	set_page_count(page, 1);
> +	/* Clear head page's codetag to avoid accounting mismatch. */
> +	clear_page_tag_ref(page);
> +
> +	/* For high-order blocks, tail pages get a page count of zero. */
> +	for (unsigned long i = 1; i < nr_pages; i++) {
> +		set_page_count(page + i, 0);
> +		/* Clear each page's codetag to avoid accounting mismatch. */
> +		clear_page_tag_ref(page + i);
> +	}

That's sneaky...

The patch _almost_ looks like pure code movement, but then adds this
little change. I'm not saying this is intentionally sneaky or anything
of the sort, but these kind of things are easy to miss during code
movement and should get a patch of their own or at least be called out
in the commit message.

I don't know how page tags work, but IIRC when the change was originally
added by Ran, he said that we don't need to clear the tag for tail
pages. That held true for folios, does it not hold true for non-compound
high-order pages?

> +}
> +
>  /* For physically contiguous 0-order pages. */
>  static void kho_init_pages(struct page *page, unsigned long nr_pages)
>  {
> @@ -369,16 +387,7 @@ static void kho_init_pages(struct page *page, unsigned long nr_pages)
>  
>  static void kho_init_folio(struct page *page, unsigned int order)
>  {
> -	unsigned long nr_pages = (1 << order);
> -
> -	/* Head page gets refcount of 1. */
> -	set_page_count(page, 1);
> -	/* Clear head page's codetag to avoid accounting mismatch. */
> -	clear_page_tag_ref(page);
> -
> -	/* For higher order folios, tail pages get a page count of zero. */
> -	for (unsigned long i = 1; i < nr_pages; i++)
> -		set_page_count(page + i, 0);
> +	kho_init_high_order_page(page, order);
>  
>  	if (order > 0)
>  		prep_compound_page(page, order);

-- 
Regards,
Pratyush Yadav

