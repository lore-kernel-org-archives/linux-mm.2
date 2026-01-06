Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A77C4CE9D6F
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 16:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1CB16B00A0; Tue,  6 Jan 2026 11:24:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA4C6B00A1; Tue,  6 Jan 2026 11:24:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD68F6B00A2; Tue,  6 Jan 2026 11:24:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C915C6B00A0
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:24:57 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 975D31A04AF
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:24:57 +0000 (UTC)
X-FDA: 84302063034.15.49D2ED7
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id CF022120004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:24:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wq0+Fvyf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767716696; a=rsa-sha256;
	cv=none;
	b=VO5FaGiPKiHBJTQNovN5nwNuYeWNFYhLJpgNU9dTHSCyqqFYkh2b1PXfYs64POLfWzAcGY
	M8Mb846+IyEl2SdJ1oQvrI1EB884+Pjr/cLNG+RZM49eCxswnkvYnXfzli8gVxf9c1QN/a
	yvyP1KbE3+35/CkYPD6H6Q9m9tJJyhI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wq0+Fvyf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767716696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xy+iO6JE2tmVjALe8fTi0G1UevQ+KFFMhU4WqwTl0fk=;
	b=Vz8lTKOc2d3AYhqQtzqTovzTSMDJgVxGSaWxvRCe1GmI1qIle/hi5n3bdT/B3t972ueoZq
	T56lDxcQe4tgwRQ0NgOUf7ovrAqBNQ0v/w3X5IHql1WhIP3IScnjGXdfi4jVcTkMBhyV78
	V5e046G1ldG+Q0g2dSekIQEMRh//cXs=
Date: Tue, 6 Jan 2026 16:24:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767716693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xy+iO6JE2tmVjALe8fTi0G1UevQ+KFFMhU4WqwTl0fk=;
	b=wq0+FvyfmQO2Rzs3r7s8fSPpNWrOcUYAcmnWdSQ98GR3xeS24mgmiSTZTvb0SS+wTptwrS
	pdf62dgeXSo88YlYWD/q+ny07KbwyJs5RFs9k7jo6JSABVU3Wutbm5xNNnfnxhs2fN8/A+
	OIrqv0/5F0dDDyj3OfpsW1vtOcuiYkU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <dou7g3n5fpynsab7hmxf4bgmqdewtdhkkiriwlghxzyduick7h@bsi3q2kivvbs>
References: <20260101013814.2312147-1-senozhatsky@chromium.org>
 <20260101013814.2312147-3-senozhatsky@chromium.org>
 <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
 <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
 <v5veb673xrz6z3tevfdymhuik7nltojrvcqyjih4ds7co4p4hr@5e7ngdkrxo32>
 <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
 <7q5gqpfshnc3lfhzxughpks3fc2knw2delpm5io2oe54monydl@5isuxnjputjr>
 <aVyYuS_usi-lpHkM@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVyYuS_usi-lpHkM@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CF022120004
X-Stat-Signature: 9gw3n3qqu9a1zn7mohufp8ursuyrfcbe
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767716695-505050
X-HE-Meta: U2FsdGVkX194QNAMM1th79MrLrG5jsmvBLdPYC516oLaeoNkjSUvv3PIOokBC6qSqG44ZxNZitx52a6tXfE8X+i53Qoq/KdiMeW2dIbf+3m3veBZhAaVSBqCyWka1QYzGLzeADTFBKShsTiz06xjR4/+mscUs/i769w+YwwrJSX3FcWPCQOUDFfXN+kKmgRiHD+VMuRZrF4QfTcsuSjBySqhOk/EliYg7Z2LKdgkQft/fLIGB0yIFeZjUVn5OjIqPw74PQbbGj7sqA35YvF3Tb6YcgvlhIzFsiWOCs6I2Bg1sXFiDd5hIZmhQvFNg9J/VbCBVcV0iunn543gkOkWXGE6GYpo7yrniaw5o57r34moN3sg3a//lJyWphg/UFJTafO4imGKJq595IC2Nw2loh0P7a9K4pdHpowsCskaATvuOzuojsVedwoFN0NL0wHMyOpWPQJ8IMqjyC1r4etF9W2tG8fEdpVREvgb56rgZc5bD1BOWx04X4oMGMkJCm8j7mf6ZrnjIN8bpGZvfkRBZ5bt1kGZtdiz1grpWI7Cb5L5qAfXzxTwBteA9+j+QOWKDIKBU/KnKqzSSUMkEJsGxFdHDtFcPKuInZkRabIp+W7r6l8RfZDf32cZCdJ15hiTC7TSH2TwVHQnJQVC6sLQuuEEPSDiGK4kfyE1F/o29EKLOqt++VSk/xclp7AjbHRvpzLsEZArwMtXVeXUmki7o6Lr5JVac3j1OC/VhzvyUNQh7l7czsMkU/5hnYHBeyaUx75rZ0zRqDUX4r2s/iZ0kYpVjLe/UFpDTKt6DpncUcKGNYOtzBQMpR8r2JbEjcqExpjjX1BXNZeGnx5IMyjtoY1dT9gzZ2UAev4cZsCSyZ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 01:08:09PM +0800, Herbert Xu wrote:
> On Tue, Jan 06, 2026 at 01:22:45PM +0900, Sergey Senozhatsky wrote:
> > On (26/01/06 13:20), Sergey Senozhatsky wrote:
> > [..]
> > > > I am not sure tbh, adding Herbert here. I remember looking at the code
> > > > in scomp_acomp_comp_decomp() at some point, and I think it will take
> > > > care of non-contiguous SG-lists. Not sure if that's the correct place to
> > > > look tho.
> > > 
> > > Ah, so it does kmap under the hood.  I suppose that can work.
> > 
> > I'm hallucinating, sorry.  Yeah, let's hear from Herbert what's
> > the direction here.
> 
> I have not implemented the underlying SG support yet because
> there are no users in the kernel as of now.  But if this is
> useful for you then we can certainly do this, at least for
> LZO which is fairly simple.

Just to clarify, IIUC the SG support would mean that zram or zswap can
pass a non-contiguous SG-list to the crypto API, regardless of
compressor support. I assume that the crypto layer will either pass the
SG-list as-is to the compressor if it supports it, or copy it into
scratch space to be contiguous if needed.

So zswap, for example, will get an SG list from zsmalloc and pass it
directly to the crypto API for decompression. Then the effort to add
support to compressors can be done separately.

Did I get this right?

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

