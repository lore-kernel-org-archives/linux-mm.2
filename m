Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCB88EA7960
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 04:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B7C6B0005; Wed,  4 Feb 2026 23:16:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33C1A6B0089; Wed,  4 Feb 2026 23:16:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248B96B0092; Wed,  4 Feb 2026 23:16:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11CFB6B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 23:16:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE8B158ADB
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:16:30 +0000 (UTC)
X-FDA: 84409091340.12.C7CA473
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf10.hostedemail.com (Postfix) with ESMTP id C5E53C0009
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:16:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=huepo6yn;
	spf=pass (imf10.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770264989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lg84RfkI/0u9tfwUkwG5gebJADOIUofTA9PDMtsrLJ8=;
	b=S/IZIZFOWyvdNTzFyIWxe50VwPLTbM6KGGX9XWo2GzrRT9tspYv2iqn7Njpay/996Mc41e
	P4AYhjDxr+V5omfTX68A+pK9m7DcvIHXISLSLzyYzUlOcqcettBfUlRrw0LCC4n/0v5Z+L
	YBOGNOob/Co3Wx7119Qm3Fn4J/Q9Ivk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=huepo6yn;
	spf=pass (imf10.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770264989; a=rsa-sha256;
	cv=none;
	b=iZkBXScKaireAdQt+ahOEO3GuVlFuXFlSIVr1i+cfWdrv7ssTWnwokKh8P0zvsrntH80L2
	RCBI/mOmwMeKzFlLiX5F/NuyjlJAVVaJhiTkFvj2mNrU3n+YDq9SO0HuP2J1jxp6j3fRhO
	d+BVyPl1hT8Mf/K8L94biDG/ldSZRnA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Lg84RfkI/0u9tfwUkwG5gebJADOIUofTA9PDMtsrLJ8=; 
	b=huepo6yn7ETjMtBjjbKxFX3j8PjAwq4ZQVDu//1Qwh4uhb0bHNJhF4rd+KETFBjmOOPeS5Uuh0a
	dLehGYzWbnRRzHRe92uWcd9H016ATpvdyoUENLZbKuOdU56yGfp68BGlQPCtJQHV72gTMgMP+xHVB
	l26hmYFRlTXufIlsW1JgAaS5Iy/C9cNdH32k4yQ4VF++6AwCKXqA+cHdgaoAoDQfpRHYu8Z1Zq58C
	E8wT/h9EQ4fBwiML3Y+3TgMk29n2zTxrBrE4DrJsgb6xgvJ/ZH7PPJtfdn+B3cLwy+g3Wm4YV7vbx
	zLWKORCZBGbAjo2NBBkvoUnlOgSZtdkwGYXQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vnqn0-004dxr-0U;
	Thu, 05 Feb 2026 12:16:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 05 Feb 2026 12:16:22 +0800
Date: Thu, 5 Feb 2026 12:16:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, senozhatsky@chromium.org,
	sj@kernel.org, kasong@tencent.com, linux-crypto@vger.kernel.org,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, giovanni.cabiddu@intel.com,
	wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 00/26] zswap compression batching with optimized
 iaa_crypto driver
Message-ID: <aYQZliax5c7-fVJm@gondor.apana.org.au>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <nlsqmn3x56ug7vfxw3vmpsmlyc6sie2plr22hpu7q6j7jq3adx@jbgg7sza67mv>
 <20260204103925.fd15632afc3bccc0ea8f500d@linux-foundation.org>
 <t6n4qhqpexui7gfzkdw6r4ai3pztt7qg45fc5hjg3qydodp77n@oh5k6pzpyjwa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <t6n4qhqpexui7gfzkdw6r4ai3pztt7qg45fc5hjg3qydodp77n@oh5k6pzpyjwa>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C5E53C0009
X-Stat-Signature: 6zazmwije1nnrbw63mnhgxxpk6ggu74w
X-Rspam-User: 
X-HE-Tag: 1770264988-617315
X-HE-Meta: U2FsdGVkX19nt7fwLAvM8mnwMPFWER89//eQrXaOYtkkewfbNmqEJMNhz46p+YWnGhZzcCpkiQ3FUYNsIbCnENtv4tA7X0PRFKEiwKdJ/jeLkC76RwZAFqmBGcdRs/TNz/NB2nrSbpzgfIeaKfErP3psQ+Pd/ReNPjZvljqiOHOmMcyGrX6Tw0ycA8xhZZ2Hrzv8rcGNzkU2GY5YLxHSWpk0BwsbFAluFnUW8CocgtwYy/gZkesF5CMz348AguSXW4+WchNEISbGeRdFRAAy+lPCQFOi9BICyrO/5hDDRY5bln6oBXgm8v9EPTL9nji5jIf1pQ5FIUnMQk9g8GxRIJbxwGAuFKoFJNQdofFAjJdphrm3n2LW3b7ylFpFhPQs7VOXHjdkTZkUdupkZPScZdvy2EdzupEqbk9CJPZtBRNQpWnEeUr5mWPEGKNISJR+8ERyIddg76GrpgF8UJJu9BkUcP7bswneu7vhJfp9PTFy6b92YsxHhhlLJPOES1dEs5ULHs0Ba7Y1RciBUpNaXzm4JiRuNsTg4BtcuRCKvODHNQaphXrurBLoIP3gsV1adClFpg61xSrCmUQTlnzbvvgGIegpdEZx5+fnCYRclMUvsB3ki+/Z8RmTpJsfzjlrB14R9wTAlJ0HCPWpjFY9niSVg1PerbxTMiBf6gsFoj3nxK9YciC0PnbueHI6knnr9ZN3DiVSxdnrlLDj4vvhZ7P3L6SWLaUYTPgUm+x7/9S9LAdxKXkO7qXL0v945j7mgyDUOYIKra+lb3ywFiZoCm5tMyTnyawIH7xupWLDoH27Mg850STBwivr/8JX9eCtFmR24Jv0mtTXQ4waCu8/xj/Eb62h2U5kDL3BU8bcFBOARezPFp9xtUtUdbGVLPqN/J54DUvgw38NmSfxSNyXI8xzv1EFYjrhHEpnLWCiaySvkgniAt3WpVrH7V+JD9msvAhZxbNamxeYmQDppGE
 Kx392cmK
 5O0Ew7bvTVZs9F6lj7Lat0eqo8VTVjz8MmLY/TtnJ99DxiI1+NKolWhF8zI7OLnDAo1jOax7i4YzufIE3pQ0MoFtRdKD11AUP+18/M2ekJY7tlmRs4gcM23FafkO3VW8WCoC9u1CpbHdMmNLdZdTRZBSQQx+djkqsa/cv8QjDqwzFPsGjHnHDbs3d2nVrxILNeoRuzet1J99fyPHP5ZqEEYeVnKhqaH57y0h4SVgE2CeSsQ5nVYEcxp+J/qCkr7UmiBnvuA3ZMBJhogELI5QlZdAmBI4h+TzqLtYaN5Qyqb/imkOLj0zqlKMnsvy6+WVBKqPz1qCXVkotntU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 06:49:03PM +0000, Yosry Ahmed wrote:
>
> Herbert, are the crypto patches ready to be picked up? If yes, could you
> please pick them, then we can figure out how to route the dependent
> zswap patches based on the timeline?

I can take the first half of the series (up to patch 15) and
we can use that as the base for the next revision.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

