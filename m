Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B6FECF6BED
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 05:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09A96B0088; Wed,  7 Jan 2026 00:39:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3EB6B0092; Wed,  7 Jan 2026 00:39:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7436B0093; Wed,  7 Jan 2026 00:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B9A826B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:39:57 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 674A3138162
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:39:57 +0000 (UTC)
X-FDA: 84304066434.02.B2AB0E0
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7ED69180005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:39:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X809OQYx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767764395; a=rsa-sha256;
	cv=none;
	b=FriYxKxUuaIBQU4oVk3RdIDrnv7h67L6MJHY1TDVhmVk2Heemr7vhoeiXDQp68uY6tq3xu
	OauUMibhza670r/cHPsJyu/sjUQDdFlwJUVJRmrvX4AmHaI6j8bTz2Uq+zuFx/wQNs/qOp
	v9kllKHPWHTV46g58JFFxq25T8yPxKg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X809OQYx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767764395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EO7QxiUX2cfRPRoeNoYBjPawt4DwoH+tri6kf2FLhqo=;
	b=wAvoK4sXx0Z22q/1vtXjqiu4hAnkJ6+doOIphsd/fxp0nDtn8yg5+8wOl+BoZKPGv3BFtr
	2XurutHOop6U446txWyK+2grch0+n7V4KTjyg5IKfZI6bHWPKQm5eWftLSItd8pTb5csLS
	Fx+MXvuQ4ORTy2wIRAus7gpH8oc0F+Y=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767764392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EO7QxiUX2cfRPRoeNoYBjPawt4DwoH+tri6kf2FLhqo=;
	b=X809OQYxpxEtJBMzt9bxtE2GdVBcxsJeMUlsgsno7J8+5jGdHcVZA3JTm9kyHH1j6LJHnh
	HtCnpz6EqlZtR1wwzqW8LJSOh0XReIoY0F9Oa0xtM508cMi4W19Y409dqPmepQ14/0cD8K
	1FeEE88QoIwgL114di7k7jORkgjoOzY=
Date: Wed, 07 Jan 2026 05:39:50 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <9b7d6e6292c64f21b8d09def1b6723f02faffe88@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: "Sergey Senozhatsky" <senozhatsky@chromium.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Nhat Pham" <nphamcs@gmail.com>, "Minchan
 Kim" <minchan@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Brian
 Geffon" <bgeffon@google.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
In-Reply-To: <aV3uXguDCaVAbY53@gondor.apana.org.au>
References: <20260101013814.2312147-1-senozhatsky@chromium.org>
 <20260101013814.2312147-3-senozhatsky@chromium.org>
 <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
 <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
 <v5veb673xrz6z3tevfdymhuik7nltojrvcqyjih4ds7co4p4hr@5e7ngdkrxo32>
 <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
 <7q5gqpfshnc3lfhzxughpks3fc2knw2delpm5io2oe54monydl@5isuxnjputjr>
 <aVyYuS_usi-lpHkM@gondor.apana.org.au>
 <dou7g3n5fpynsab7hmxf4bgmqdewtdhkkiriwlghxzyduick7h@bsi3q2kivvbs>
 <aV3uXguDCaVAbY53@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 7ED69180005
X-Rspamd-Server: rspam10
X-Stat-Signature: yqnzkdmy1qmhkidtn7hc9uj3dkwe47ag
X-HE-Tag: 1767764395-434459
X-HE-Meta: U2FsdGVkX19OmnVbSWQ25oxBGQDbBrXNUZlEYVaMIJx+8DFpcFLxwlts7yK9an6+/9tM10cJUl6NtrSYjx7Ysl9purpGT6J02t/cEwF7QXtUViSQZ2ciO+UCFFxW7BC3wbsvmFnU7jHUrve87cEzeF2oOpY4cbciZEiAxadvN9e4kffDFYosbyKzLqynCXIPp9SnqiILh8lzoJ2V/3vIfFdn3EB+jLmHH8ZNI9ccqK52zxj1qi0TQgBNOPiC1dF2ojqhxXAP6fmKt8D6ewqsujaMVBcI+Pg9tsfDa4kbEVh6AhsJEnWwVDaIM3diiWC8Tc/GXWs7IO5PO940J2rjwA2EVKE/HvSmQ+gDeLJs1jK5+I9yrBTcG+JFYJmFTiSNWFbKfWSKMUOF+jErnI/a7HVs7OKyOV/q2gS03H6iVkIf8VX/RYGKAaD4vaVt7U8bml4Wt/HjRXeWv2xV752eZJWOAtTc2kNSaHAtY/Ihic8Ej2WWJu9VsvVwuB4hLwbCRZFIT1Iyqt7YtP7bjW6lEyBgDkdDoDoEMx7wmRbs2WnSt1AjppSI/GUdbXoaZrLhR5b5rUxifSIxY0P8N8ADixtwf5xEzhVO7M29jyBbYsaAc/saT7P0z6aacV2siM0bwfDV842Tkfeeeorc92lyZ0sf9wF1hqtdhsszCTwMcqSJMrAT8nnFiJNLreAzGAq/TyUmkjJZyKBLEdA/E19WYclkUUza4l7nXO9ZVsnqYT/oX87ccTKD1iBQXQRCN1DKNRY/aLMNMJ4UJW2G490FNMmEwc7NMKO5zlzqpKum6O4klAl9jCNa7dqfe5o6oTN0ARWZKvYnYJhRHxT9kbRURlnP1Aw1U+mwQSCTw0AHAOFbMEKSJLcfFEey3wD4e6Ro/edPX1D+qpdpQAf8twFY7RjOwVSv3pTGNQ0VX8AiqLCc1uIqwnmp5uR6wbE23Ja4lq5jUcztbEWBP+MhMGV
 /wcPDwif
 XlMMqPVycBl9Cp+z9mGZLfiLIZmf4EqkMLtyKqWUJp+J/nEt9zq5626HeW9QydRskjHiYbqLqAiVA9gV2TowoneOZvo1dRdDxDi1Lw6TJPOaJIFvpitj5E56eFH8ozanZKZo7FXUVxz19H06c/bGg7xHPDHNwM7T/7UL/yjg1oMStOeQQQx4Ktu+8TNzik3nEpOwXNNq+xuBHdwZ6U2iWjBQFy5wOpomnahDK8d/WL93WzbHZKSvA/l5KHNGHKSr9UvSe2VBZRjTSI14=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

January 6, 2026 at 9:25 PM, "Herbert Xu" <herbert@gondor.apana.org.au> wr=
ote:


>=20
>=20On Tue, Jan 06, 2026 at 04:24:45PM +0000, Yosry Ahmed wrote:
>=20
>=20>=20
>=20> Just to clarify, IIUC the SG support would mean that zram or zswap =
can
> >  pass a non-contiguous SG-list to the crypto API, regardless of
> >  compressor support. I assume that the crypto layer will either pass =
the
> >  SG-list as-is to the compressor if it supports it, or copy it into
> >  scratch space to be contiguous if needed.
> >=20
>=20>  So zswap, for example, will get an SG list from zsmalloc and pass =
it
> >  directly to the crypto API for decompression. Then the effort to add
> >  support to compressors can be done separately.
> >=20=20
>=20>  Did I get this right?
> >=20
>=20Correct, you can already do that today with the scomp layer providing
> the fallback linearisation.

In this case I think we can just make zsmalloc return an SG list and use =
it in both zswap and zram. We will fallback to the memcpy() in scomp inst=
ead of the memcpy() in zsmalloc, and we'll drop the memcpy() logic in zsw=
ap as a bonus.

Will this for acomp though?

>=20
>=20Adding native SG support to LZO simply means removing the memcpy that
> scomp would otherwise have to do.

Yeah the effort to add native support to compressors can be done separate=
ly. For zswap, I think the most common compressors are actually zstd and =
LZ4.

>=20
>=20Cheers,
> --=20
>=20Email: Herbert Xu <>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>

