Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32CBCD3B7E2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 01:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997C36B0005; Mon,  8 Dec 2025 20:15:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947776B0007; Mon,  8 Dec 2025 20:15:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F6E6B0008; Mon,  8 Dec 2025 20:15:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 71C076B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 20:15:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15B6CC03C3
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:15:16 +0000 (UTC)
X-FDA: 84198164232.14.F77D83D
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id 99780A0006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:15:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ei2tDT+n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765242914; a=rsa-sha256;
	cv=none;
	b=cSAx92nL/g503qVfyx/cgg3P0Fb+Y0ztcV+yaOSHr5DP8uaoMKg4IIZiU5Xdexa5QxmR9i
	rOAu6E9wdBfufA64Wews26yJrMjiPLgRmTIzI9VTYBzFfGZ770Y1/lafDMGKgpxRWTcmrY
	3vEqLyqZfbjt8dscUdlDpMpK8WDNFEA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ei2tDT+n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765242914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EEPBT0Xev9mXNC6uni6C9dTnCHCHjr/FCWwmgCETocM=;
	b=rYaSMRXh11d8qIbs3VbfE8jUVeIvRLhh2hpTK+EWaoLeiXjc3yyilD06QKP2jcXuTXfMap
	GoC8wzFHZ2vlhLdrYSlvZUNbZtF06qFyOSqUY7jBhTs8Mo2O3YkwCoSxjp6+frGaiu2cqa
	C+VeDM1eas92HiwTMMfpgiOt4ZwyLCA=
Date: Tue, 9 Dec 2025 01:15:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765242909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EEPBT0Xev9mXNC6uni6C9dTnCHCHjr/FCWwmgCETocM=;
	b=Ei2tDT+nWlmyhxNqRQP9tCKDJSJNCLCOatVZ4iyoAYOodCFg9onLqrMvpACATaFT+MggfS
	Pxf0sn53Wmuph5T65rMajz9B76E36PlpgJ2Ve2AiCeRrrCgy7cvzFuN0/GpLuCuUYTrX2H
	hWwZFL7hb4eqyuCUzZZ6H08IXbtaOcI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
	SeongJae Park <sj@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"kasong@tencent.com" <kasong@tencent.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com" <clabbe@baylibre.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, 
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
References: <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 99780A0006
X-Stat-Signature: 6a9fwt955d8yke1iyodjfb41e4aej39d
X-Rspam-User: 
X-HE-Tag: 1765242912-939430
X-HE-Meta: U2FsdGVkX1+Xea1osh0aX7Q1tUnrz5t8jSZxwd/m12jEWbca68fWbO4KP8FK1Pduj7qXvktdi4JQixU+o5IFeU39ppIXzCh64wgQT1mwlOeYF/taZdNId6ptVn4TEshbZnD01vmfCUfm0lkZ+m+eO17dosVPGkZU57AbqI1GQqignq1KTeGWGQ1wzPLH3zn61ZzwWQnliNNDGHfkj8gnYi8IeMP8hQ2UL+9yMTOeR+TcN+4PLFN83hJPcGXjbq5ch0wcfcan+g+W9dnoWjK6BmZ3ROsxeLeywwC2u0z+bbps+EIxmHjSQo4jZEQZ5dZErl02BOpntnmG3aKkeVCzugzYQAOnKimPwla8a2Q7+QA2dGrtwyNyFHEpPNVjmFqM7WDgPige6rAPV8pmQp7gCDW1gsaArQONZcPVunbfBljS8+HMBE1aSQOoVAcnxwLDiV1kby98h1v0l6EkYl2RvNiDqXBgnptEjfV0dJPZIS+RdHe5h8e96cZMdAU5VfIW6hrESjWnZ9xdSWp6fvO/IC5ngXrQqb3D08y3sVIlCviy3d1k7vcCbMtLRdQyfgS1TXAvRN66YRyKvblKYmT49YciYWa5kUrTp+ghoRo5AbfCMMxqY5OWLWrWsto1UI8NaZ9vwQl0t75j/0X4nF+INEa8Vq+Wp+lrSxEDf0B/DdWQq/YlEfkXMoO+JsXhp/6e6oQsMv/u6RLwiBRW+y5BevYcEqFZEBi9kAubHXnt3zAW0It+MXRMfPM8PumMJjve175jO1ggSaGJ5WCXoz3S3UBPL9h0n+VHaVqejKEz4+bc+NoFejPhXKEakfBUINZF1UB8Cv9ggQD0JMAe6O4LCZiqibD57wY1lDHCVP8zAOMTZRMzLEO9CRgUz6bK5Z505V1P5qzKP9OFoe1A9Fs6FDD2NzarQmaWt4RbFOEyHP+2ByZzyC2b6H6GuLjfMu+ztsixmucanYtus9bRowC
 5q33jiHS
 JUiU/Azl2EGRdOXz14CEghXxG7pJezxsukQBSBi1Ydhy32TErFguHsE8ar1MlcdEsCxpB0uyo8rYo9xZUccB0O/A67pzqnAvxy2VPkbK77MqY+b/uItl5Vbgl5paQC2+0CgxxMGTFGNbmJRTSdkGuBCrS30y5xykx7OZxMAh42qJ/asjYsaYaMwnf+WwDa+yznBhX1jZruzRZGLQSNkKNTdRgh8zXk6DWL9bXZyUUD3SFvUcgV+PEQia9Ie6nPUpn2V+opOXKBvDaQFnxUYsh/cofL6lGAeKQiuLP5VaJ341s+Za9Z3LwzgiW8nhm4XqW8U819eZHr0nKRL2z9UFRPSasRBid5aKKoPYD9Q1oeFu0FyU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 12:24:01PM +0800, Herbert Xu wrote:
> On Mon, Dec 08, 2025 at 04:17:38AM +0000, Sridhar, Kanchana P wrote:
> >
> > I see. So the way my patch-set tries to standardize batching in
> > zswap_compress() is to call it with a batch of 8 pages, regardless of batching
> > or non-batching compressors. In zswap_compress(), I presently iterate
> > through each page in the batch for sequential processing for non-batching
> > compressors whose batch size is 1. For batching compressors, the iteration
> > happens just once: the whole batch is compressed in one call to
> > crypto_acomp_compress().
> 
> Oh I wasn't aware of this.  In that case there is no need for me
> to delay the next step and we can do it straight away.
> 
> I had thought that the batch size was to limit the batching size
> to acomp.  But if it's not, perhaps we can remove the batch size
> exposure altogether.  IOW it would only be visible internally to
> the acomp API while the users such as zswap would simply batch
> things in whatever size that suits them.

Just to clarify, does this mean that zswap can pass a batch of (eight)
pages to the acomp API, and get the results for the batch uniformly
whether or not the underlying compressor supports batching?

If yes, then that's exactly what we want for zswap, because it will
simplify the interface significantly vs. what this batch is currently
doing to handle SW non-batching compressors vs HW batching compressors.

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

