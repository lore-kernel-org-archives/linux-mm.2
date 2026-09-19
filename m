Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D74D6C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 05:38:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C12976B0088; Sat, 19 Sep 2026 01:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3BF6B008A; Sat, 19 Sep 2026 01:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA366B008C; Sat, 19 Sep 2026 01:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4366B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:38:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15D4DA01D5
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 05:38:26 +0000 (UTC)
X-FDA: 85229406612.29.3A05D32
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf21.hostedemail.com (Postfix) with ESMTP id 664661C0003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 05:38:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b="nXMmlJt/";
	spf=pass (imf21.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789796304;
	b=R3LUfh6eFrVP+CoX5oOMQqXHAT0uXcW7fvx9bKEQJkiugW/PuqwT5e9GY1h5kVxw+KlC1V
	IAxPfOtmSl/jJu8OK5tbL+ZesYztgpItwEngJ85ISFLyIqe2fBIjNcjih9Fm0PS2Y05S6t
	Ad3DZuF+QYvxi3D/JD9XAjYjXl3l02s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b="nXMmlJt/";
	spf=pass (imf21.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789796304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ENQeUofgSvdXsG20SUWKPC4j+he5hd9gfMYMd3+pFYM=;
	b=bnaOhWyEF6No3uDjLFGGz/5IQpeZG7Hp+lnfrm4rMc3i5XCBZhJnRGAdfcJnK+RPxbwSY0
	w6aPZ3BMSLghgmrjwOOmqFPTrn7a/a9uB2b2tKObiX8mEJki9EBG4MZdd9Dvahpy0/VC4J
	xsLLMRsd/Bqpqo+Q7aAZzKKTdyMTUME=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ENQeUofgSvdXsG20SUWKPC4j+he5hd9gfMYMd3+pFYM=; 
	b=nXMmlJt/yRy/p5gfjTs8ZIH6BkdvbOctDHQOIF2mQvcw2Ys6PGkjYi7s3VNUBirUgYPbdkD5AWl
	wZVudOLbbKXzdVJoqtySzfWEBknpSRLglUK7NTAfdN7O1nHV6aYIA9d8ervnZAmQuk6lhQaGkSFOz
	K5tw9z31f1MMl4g9un7GnHZiKwGHwsOVSjhF+6Pirk+Z4QuQ0kcGyigSoEp/w6rBuMTfvRJDZ6LgG
	DoJyiEnvaDTCi4tQ5q5KtLusWQAgq4HrY5A7L9FVx+/91px/lcDXl0s7aK8GxoJ5L4bCrbdhwVFgR
	NF/zyQ6/LapgD8qd+UcT+Sotn01W7yT+nlSw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7nmB-0000000FeCb-3pqT;
	Sat, 19 Sep 2026 13:38:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Sep 2026 15:38:15 +1000
Date: Sat, 19 Sep 2026 15:38:15 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>,
	Song Hu <husong@kylinos.cn>, linux-mm@kvack.org, hannes@cmpxchg.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev, ljs@kernel.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zswap: flush dcache in the compressed decompression
 path
Message-ID: <aq4fxxoaX0jjUWUM@gondor.apana.org.au>
References: <CAO9r8zN4ig_GGP4a=NLZ9PUW+jFmSfY1yBLrkPA9azvDCrGSvQ@mail.gmail.com>
 <20260710184052.3614560-1-joshua.hahnjy@gmail.com>
 <CAO9r8zOuRFcYnLGUcRYyg9_nAk1TvCxUvV_0101msKL0Mx0P6A@mail.gmail.com>
 <133c3c19-22ae-4de5-98e0-6970b707bf37@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <133c3c19-22ae-4de5-98e0-6970b707bf37@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 664661C0003
X-Stat-Signature: iimssfz37obab9dcruehu8tkrf9ein6z
X-HE-Tag: 1789796303-336205
X-HE-Meta: U2FsdGVkX1+ZeJJDYrOBQms0blX0UHrNnwKj7kF7SlYCPfXA6+f3FKT8X/1n+rfaGuQ0uH4ogL0MJjnaZhLCRQ8V8rVV3pZmM8p1XDC0yPPJhCfzpG/HNIRePrjE0jiUqCvjGWDhdd27tzt3YDhzdDiby+rHfrNdHlUiGGZGXyZv11eh3HglWIfzDkSs0c/mpQOIYGHkszMJq5a6vmH3F3frIBJP3Xqpsr/mwa6qoSuy7jdPt56pV+kCCpBHns8djH2nnaF7C6MYjqCCZZKMSaI/uc8hHhj+eXGqT5qwbp0fkPJk71qA9dX6l8FfpE1OptUtbZcdSmM8npQZyU6Bhf4oFnPIOHibEaxYzuNPOVrJaRaUKkKtDspwQdU8aybFu1M0plc3JKi9hk6xsSCl2OeWs8REG8ZUhBSkdT6qe1FQnCZ0NY4TDTxIYij22LNdI78QdKjoLRZdwGtqkNYsi1IVtlT6+FoyV6H2bG4Ju4ne+aGtEJjAtTD7iNLqRU3Wog3OU2O5b7US2F98EsqwC9PFLa1OmuTdrrHQEAKfyWvlK1x5utVeLvaq+ykG3pNn4H1aPyb25M/vrHpbo0HnY5meb3hbLd710lo1oEsfp7z7CRUgG/xaaxaEgR9ExdrCZ6T/w0fe39P2ddtKX+wbLzyvn5UquHjBR1+2rTqrc3Hn63Y7ljToI0A6Lcs+Dfzxm/Hwr6ij+5O3lVyIrxd6Iw52Z1Z6RMAJJYesMZFpdGkT72Zh5kP9n8RmGAIkcGrIqroA9MHWu/HnYgJjhIvUtUCub5jkJ6HOYfIVq/X6hG6towlKFYCQ64OJYE5hRJq+3AIW0GSSCGKTY2E3ZLGswdYRlj6l1sUTm5kIvGl0oWqFdeueDtiycHNkytxjOagJ4P7NcHWAf9pskNC6dzKFWwyrrJynztPt1x06XumIvtf/FMbbrz81TapweU14wsIihBwwy2YxF8WBPBPdDoY
 ksfpqACm
 qOmVfVOrRxtBPCXsozPgQCiSYfNI6BFZBoajDykn/SLnnWjCTz5hxkNPfbJ81hdgRxTMlZZGwKsOetQeyrm6aZ1WwM5JuST1LiuJtJ4CIvv5YZkXDrxD1z6YIFZoyZw1FVlHNO4yL4J+nlbS12+kOpGHIZQnt9Eei78OKvLDTeoDneMiHsLDX6UTGhjDQ/rKx81RKZckiwWJoAdu+C9rLIQoMoI6A0NFEZ3FG4SDmvTRxzywfWMzIMDkzodhriyQFLjqKnQ0/gla4mQchtbEQQkb17Fb48BmQcFLEi0WZKkX5Ve2U9K3tZyVP08VT9wOmPxKFK0FvboIGgc4Mp6jwrKuf2JR+iaFzN4dO7p/lzJ2w4/4sRLO3XVPZBOPie4HXkXJ/2O0bp8eAFkf4DteC53arevx0uhaYt13BdRz13qVaXqAQq5ASDOyedQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 11, 2026 at 08:25:31AM +0800, Zenghui Yu wrote:
> [+Cc Herbert, in case you missed that]
> 
> On 7/11/26 2:43 AM, Yosry Ahmed wrote:
> > On Fri, Jul 10, 2026 at 11:40 AM Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> > >
> > > On Fri, 10 Jul 2026 11:22:43 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
> > >
> > > > On Fri, Jul 10, 2026 at 1:28 AM Song Hu <husong@kylinos.cn> wrote:
> > > > >
> > > > > Both branches of zswap_decompress() write the destination folio through a
> > > > > kernel mapping: the incompressible branch via kmap_local_folio() and the
> > > > > compressed branch via the crypto scatterwalk. Yet only the incompressible
> > > > > branch calls flush_dcache_folio(); the compressed branch was missed. On
> > > > > aliasing D-cache architectures this can leave stale cache lines visible to
> > > > > userland after a zswap load.
> > > >
> > > > Adding Herbert here.
> > > >
> > > > Doesn't the Crypto API take care of this for the decompression path?
> > > > Maybe in scomp_acomp_comp_decomp()?
> > >
> > > This is what I think too. Actually if you use something like
> > > zstd_decompress() as well, it ends up calling:
> > > acomp_walk_done_dst() --> scatterwalk_done_dst()
> > >                       --> __scatterwalk_flush_dcache_pages()
> > >                       --> flush_dcache_page()
> > > over all the pages in the loop.
> > >
> > > Maybe I'm missing a path here that would require us to manually flush
> > > from zswap? But even still, I think that should be handled by the
> > > path that is repsonsible for doing the actual decompression, not
> > > zswap.
> > >
> > > What do you think?
> > 
> > Yeah I am hoping Herbert will help us out here.

Sorry for the late response.  But yes the Crypto API will definitely
do a flush if the page was written to.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

