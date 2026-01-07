Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC984CF6BE4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 05:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 585CE6B0005; Wed,  7 Jan 2026 00:43:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55CE36B0096; Wed,  7 Jan 2026 00:43:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493556B0098; Wed,  7 Jan 2026 00:43:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34D2D6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:43:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB5AA87BF1
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:43:10 +0000 (UTC)
X-FDA: 84304074540.30.387B60D
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf18.hostedemail.com (Postfix) with ESMTP id 936341C0011
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:43:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=Kw+G0TDb;
	spf=pass (imf18.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767764589; a=rsa-sha256;
	cv=none;
	b=dJKDdHj/EuQncjs+ftm+Q5QaMWBazJwEmn/M4hU7TNekiozcVkTK/IH4OKg3b6FvfoBHZx
	WCJb1hKCwYRHExuMlG8Mx31S/lTXq4etCfGwwwxyBop5Wd9MSd1K+AZ8HxSh5GFZDKxEkp
	hP2PTJbaekHvQlC5PLGjq/PCrrRxCSU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=Kw+G0TDb;
	spf=pass (imf18.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767764589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iitbgM450gN2Z/tpWVzbqWUN/OZbgIFpKN7OaANwQPc=;
	b=TQGbgJt41ZILt572jGMSwo5Ofm97nk02eU5pP6q8t4sQNS67Q5R73yLcJnEjk/b8BAoZBL
	jSFsQ6jv9dT1tf+o15PqB5fzOVt43DH/ZNjZhpWXpgCIaDG6dRzRaI2SURGZKqNvEPaxpn
	TKg4XVeD6QPaRPlAxqXaEjkHpXf9q7Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=iitbgM450gN2Z/tpWVzbqWUN/OZbgIFpKN7OaANwQPc=; 
	b=Kw+G0TDb9MizjeijBu17cyEUZmBMLGJ5eJDX8C1FvTXcnXBZleoqwZ5FGGWaplpDy1QZdeiaMBU
	Upa7Mp8TEAEWn3FCGauqurv1HXW0L6zXFJb3gCMtlUTRtJM+KZIxSioHyVQvRUlb+kpyx7Oq8YJ4F
	+EE5yMomnnXEDuYgspieDgKk3JKw0FfFcQVZLluYZgvlv1G4faJGf4GAqkMziCO2cEOKyBwYKpf8x
	nDakF0wFnCainV2v8qnD7YY9t/lZYdFXOU3JBG4VpGZBVDTIQowHPktq/7O1lJATUow87xjzLhwOO
	tf0n+0PEMZBwR0gQoBBPNuaQPpGubH7i2gkg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vdMJj-00EqNT-1f;
	Wed, 07 Jan 2026 13:42:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 Jan 2026 13:42:47 +0800
Date: Wed, 7 Jan 2026 13:42:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <aV3yVyoz508hmdEY@gondor.apana.org.au>
References: <20260101013814.2312147-3-senozhatsky@chromium.org>
 <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
 <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
 <v5veb673xrz6z3tevfdymhuik7nltojrvcqyjih4ds7co4p4hr@5e7ngdkrxo32>
 <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
 <7q5gqpfshnc3lfhzxughpks3fc2knw2delpm5io2oe54monydl@5isuxnjputjr>
 <aVyYuS_usi-lpHkM@gondor.apana.org.au>
 <dou7g3n5fpynsab7hmxf4bgmqdewtdhkkiriwlghxzyduick7h@bsi3q2kivvbs>
 <aV3uXguDCaVAbY53@gondor.apana.org.au>
 <9b7d6e6292c64f21b8d09def1b6723f02faffe88@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b7d6e6292c64f21b8d09def1b6723f02faffe88@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 936341C0011
X-Rspamd-Server: rspam04
X-Stat-Signature: daxcprdgxgsfqyzcikquoezqef4awin4
X-HE-Tag: 1767764588-5762
X-HE-Meta: U2FsdGVkX1/f94t6nNHJjEp8pC5X7BBl5x91JONBGuPBTchqcF7LLOtHYjYA6M9gDQeJ5adMDxe3yyunu05FgpVbefbQr7FOassID6p2fF4WsTsPrmBPXDvyQzu3ENggYIADUsZXrzGMjnussEXMVlPMMQavcN37pJL0G9S7Cxun8L9VIEsqGZEzZYqA81Z7NDjN/o+ubBHy3nAOPEWMJkOqUvo0CeeIxG7x6Io7+HIBz/slH7ttPGZn0psaBhqSgX60kH+uZOyTcwmhjWc57A5uIu70RfvxM4rL1en+0w56HdMqf1sehzXKa3jzeIufiDaM3UDr7adlCSROXMESv8D8czu5j1mBoaWHdgmp1DLs5ByXJhzNA5e5c46S11LrFwjEgh9xbfkcremy1vtJoYb/MmnWSv/DGu58d213pVyVuKhm2t9JWzOFvulU8oWERjsaOYp8gSHXM1dN1PyOndcz0GPyA3wrqOkFf2iLiNHXid+5VRwX9POFH6/rCzyUhoXwnSppmrwAAzEbxegF1N3UBqUUBXl/0qVutEsjVa1KvEROV0MbxEhuf5sDu8KpToRu7d8gZuIKprModsDEYAkvCRxPugphzeJ6ETZR+2N3TJOUZo5/JlvYptb5NkMT1R6n2IavqtzFoRUNrJByK0x+PqLdZAIS+KvukwO61JJu1wzenbwZw0FJvuajdbUbqFYPZixWNGMGcCW2km5NWLOaTH5LA0V/ADHtIjmFoFhA3vemXiRgmMHUPjRJnJx+pDrAd4fRHGyTvyJmEIZiGwgZHgGjmzTqwDx5ApBm0C3n9OXjTBjor+qh50FNym4++fdYVB0NYx4NkBtaA36GflaeDk52vY1XLM+pfGry5xrNFGFDFzlsRnBrx9dov7t6Rqblu1q+NEwpGxfAYD8/HQQKQWHohVFI+fcC4D6nhbv+QwEBX2K9b0is5Q+HbhZqM7TV56PBL1Pmq/UPE1y
 DVoHz2GE
 ssNiMDy8MwMyk6dVF7FicrJVhBd1pbbk6Tm1USbWni11p+CLS/n541p8lyzYs3D6zRjAQK0ygo9FvQBTSXPcmHNMAywWFC4GibeHaNSrCvkvC5g5FEfIGd0rVnKKnmF0kXekQ4SBzhyn5bmBwm8psLwEzFImQpnQSkjysorqE0l1CxhfKMV0ysRnAM3MyZr5h4AUaAMnYjcehTzqF78eetNf2FDett39jkmqoKawO4jImgTbLKSlErRKV3Q5+5qVRfKpWpaQwLYF+4m3gKS375NeE4urEuFNvFWx3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 05:39:50AM +0000, Yosry Ahmed wrote:
>
> In this case I think we can just make zsmalloc return an SG list and use it in both zswap and zram. We will fallback to the memcpy() in scomp instead of the memcpy() in zsmalloc, and we'll drop the memcpy() logic in zswap as a bonus.
> 
> Will this for acomp though?

Yes it works for acomp too since scomp sits underneath acomp.
 
> Yeah the effort to add native support to compressors can be done separately. For zswap, I think the most common compressors are actually zstd and LZ4.

OK once you start using it then I could add the native SG support
to LZO and it should become a little bit faster (and eliminate the
need for the scomp bounce page).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

