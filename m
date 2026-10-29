Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3B75606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 08:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=UHmLTmmx
Received: by kanga.kvack.org (Postfix)
	id 1A46E6B05B3; Thu, 29 Oct 2026 04:23:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17BBD6B05B4; Thu, 29 Oct 2026 04:23:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9476B05B5; Thu, 29 Oct 2026 04:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E09E26B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:23:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7674CA0319
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:23:04 +0000 (UTC)
X-FDA: 85374973488.28.7AFF618
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf31.hostedemail.com (Postfix) with ESMTP id D210120002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:23:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=UHmLTmmx;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf31.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793262183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2apa8Mr/pCcSFyuTTcmI9mAPuP1EGz22opH+X2kB18Y=;
	b=SMeuRX//St/XDSvTYqQGFEmgXs4DAgvU7bHvcmL4zx0QKzwvqQozA9mYyK0zNgfgYtD4Kl
	Gf+855dXXMBk9mwkkbgiLwLWLBuB8lvivCvxY6zAOgqzRovQBGTB7AuZnifyvC17dRzWt/
	kz5x11m9vrNZrlUPsNUHb8+vUXyhVAU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=UHmLTmmx;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf31.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793262183;
	b=TVZBUi6Pu+V6di2hBDYTQiIHrQLuQRWek5R2m63KFzblSe86DosjmipcXwgCzfi6kBu4Hs
	WOmwC38sOtTcBYcITA19iXPCeFH4/6wFsd+JVnfZSqM5LPPFmjL9NYEyO3vS8VIvrzmIF7
	zBbop3q8smOy/AxiLLy1ir+Mubn7HU0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2apa8Mr/pCcSFyuTTcmI9mAPuP1EGz22opH+X2kB18Y=; 
	b=UHmLTmmxsQXWP79uUgFoAw2NJDK2NcG91qq8NUxO8PYoCNxAbqtAn5bxrjB3K3d6fhnDZf35Nh/
	7ayNPUu4q6o/SOeRc31+HInmDlj0qLHaWuh4ikJZ2H/qa3CFz20nWDAlMc394xpqr3538+KzpiMoD
	Uh56gWhTFg12MubXPjP0caNCb+dlFP0UKOTUwwAtXOVxhyKx/WfGHReQ5Aj2FVOGjHTlbsMMylb/t
	bb4VRAaYPYGo86gFO15cfVyAbrsiz/YgUVwBCZ4caDV/SbMzozdIMaNFDh7O9ySIyQNjuG2ZLLGvG
	NV7T0J/LrWlMLnvPgl42t9aRP6wloAC00xXg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xMLPL-00000008gDW-1lPL;
	Thu, 29 Oct 2026 16:22:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 29 Oct 2026 16:22:47 +0800
Date: Thu, 29 Oct 2026 16:22:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, rientjes@google.com,
	willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v2 3/8] crypto: acomp - Add trivial segmentation wrapper.
Message-ID: <auMCV1AFlEFuJnk7@gondor.apana.org.au>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-4-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-188655@kernel.org>
 <CACpmpodu3C=uYH6dmFM-xkvdJxiRDjamRKs1Q4jU6_KKjFWNqA@mail.gmail.com>
 <auLbyon-KaV5Sw5_@gondor.apana.org.au>
 <CACpmpofcd=ZPKhAoHJfvJU_JZshKs1GGJZf5JhjAW1PZzDq-Lw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpofcd=ZPKhAoHJfvJU_JZshKs1GGJZf5JhjAW1PZzDq-Lw@mail.gmail.com>
X-Rspamd-Queue-Id: D210120002
X-Stat-Signature: eidjany64q5h95o9ph64g1hxsbzmp44h
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793262182-74084
X-HE-Meta: U2FsdGVkX1+geCGs/dKiBe/D+NsbfsStcKhCqz5IqlVTQUvV0KHY2uBAWLSuu9cHDWF1nj35sTPJrDqB89BNtscdoEtp8QI/lC1jPk80c2GeXB1B4T6TLYLwi0aUjDv+f1NtIYr5QZ+XOmUcHo+aguJOKkNNsq+Y339IwZ28/GOpipjxU4gCnbqt3tkYVAjqkfPFfHbGoWNV2pvRrl5Y+CxzhBU9Ir7QL1B2cdYxT2N2vg7tLRrc/Uok4yNyTQ9kLxTNTuH3b3SLa8GAItEYCfG0L6kH8b5xZ13ffe7OAPsR0tHIHi/4Yu5HtxFcNEgd8yN8ZrGXJCxtlgsBaJlgQqc5Twi03dcGjHu1BmGD2p1YWmaVA+8X5ETZJevmnKOJsq9KI8h28+otxRXAVGJDAc2WyB/xAgVgR/xVyy5IQS+qiNMRJUUcIoMHc4+gMklFpaXkAKx/X/78jrLeq7mHarhuoV7RDdFoJwSPWi3nvuhWAsQ88x5i5lhXeQrsGCZFlZOZ699LvdqlH3ys5BzL2qLmcQCR/yE6p4/dJLcsRouyjQsc+xwUAxCwe68GkoA1KPIGFZhzn70C6Lr/+PvjjcbTlwMuHU7/FwoyVWL0yu7K6WQs/ymocQOnbEzr4vNfU8pYb+eW1JVpyo2fmBbFouLi0fK6TfQyyl4GeEJWKrraDd7bn63cT1/Gh6WwJOmXOYcNzXT6GYPk9s8VUWLVlzDCquTv1aNTDNSf8hWiCLssiJmGT87VCBFDsWbVQ7dGjX+Po4dLWYcf26J2ryK0l0pHlWlL0gwVBScp7puZe42R3di25POpplbKWaEStTZe2VXzAE0iMwVuq038Ue/cOwii+836p8KPgYL8cPKLozaMiYs8Ph0vyn8fLBCw1EmDVRsVkidoM0Nva62b7PX1ZYzAuZ06Rave7OgEx4pLk/ll8XYlDZcZo2laUvn0jAMGARLG07AIV9Hu1Ts5Gqn
 Nb8yFLR5
 9wqKSiqX2ttFDphNcFBUU58E8Ik30Z8+/kr8nM21LJ9Vp1FOTSugOG8CLuxovdzdg49xz7HIhqXbKfoargmQ/JCwPXEw4h0hw53wD+C1a9TVkHEWtAMWnnpel1wecP0Diy8rOa512ZBz0YN5oKAq18dvdUvd+Z05QcN77igO0HNcbZxU4B4puRRyTue/cAu7vzoKeuW3ErI56JCvZb3UXQxW8xiRpGzezP9l1QWHaPbbwxBWZo8v7fnh3qpKMJxWalZdrZ5Ao8CQ0SOpwmZpJqhWshM2lPNsRqhL1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 11:03:55PM -0700, Kanchana P. Sridhar wrote:
> 
> I was under the impression that if acomp_req_on_stack and synchronous
> tfm, it would go through acomp_do_req_chain(). Please correct me if I
> am wrong, and I can modify the conditional accordingly.

It's perfectly fine for a stack request to go to a sync tfm.  What
isn't legal is for a stack request to go through an async tfm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

