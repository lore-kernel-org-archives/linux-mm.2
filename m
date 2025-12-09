Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C2BAD3B983
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 16:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865CF6B0006; Tue,  9 Dec 2025 11:55:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816B96B0007; Tue,  9 Dec 2025 11:55:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C746B0008; Tue,  9 Dec 2025 11:55:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 611AF6B0006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 11:55:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED53BB70ED
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 16:55:15 +0000 (UTC)
X-FDA: 84200532990.01.6CA6826
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2BC4240005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 16:55:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LceoDyAx;
	spf=pass (imf17.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765299314; a=rsa-sha256;
	cv=none;
	b=WafNp/0+gkgL+mf1zr6shCTohAUEk5EN8XgK1iKZFqZON8E3qErMJmyQ7Tl4g+fDbvl0zb
	cFb1etRtNsGybvcECqkjBmDIFL6Ajwy5LLbwyIbIdYGQDWDwbQEaMn6i8HMsXPnEyCEBdB
	vwd+YwfSee5S0xM7fcsKkPU5deG3oac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765299314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AcYeadRTyF+PlQ/oEdxR8E/IWsWlibs/HBIZ6+q3Odw=;
	b=7XE+ckAQXcQdzXMFatDwB9e5ottbm9PapHm9kLh945wF3gVOrunk6J6DJ9pSgynEzX+is4
	eVipfrpTM5jvVPJkvQDY9xdTlMyvyfJe86JuwpI/mIjX94sJ64AWcZT7Q7+Mo3Pp6KbXYQ
	rxAwwgOkpgyhDAcrFGGS0qNLLJ9eWJ4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LceoDyAx;
	spf=pass (imf17.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 9 Dec 2025 16:55:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765299311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AcYeadRTyF+PlQ/oEdxR8E/IWsWlibs/HBIZ6+q3Odw=;
	b=LceoDyAxpvE0bVPr0vdjrLOLViws7k3o9OHiuVj41YsvMwvWJx5R2677mjvLPQGnzRqoBk
	piEdE6iNoURc4kLO/JARESprqJVuI2UaqLGtVft3X7+D+1wvHlITPjUD24WZxhSOUpUY3/
	9uF25WZjP0noAwibUEvSCF8UpnjGOTA=
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
Message-ID: <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
References: <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
 <aTeKNEX5stqjG55i@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTeKNEX5stqjG55i@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2BC4240005
X-Stat-Signature: p68cut47pmap8fhzc7h5a849if8x5rf3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765299313-873476
X-HE-Meta: U2FsdGVkX1+n033TitkGD3EvN+G6/wQahpNEoSLjL6g3SKk0UVaOefN2fZZX17jpKxH595RKOPy1u8cKl/b6ET/cmCpTYdpCWUxoIOVdYhmqvjOMH4uGCw2zW7j/S0xCmMGjdYDba/oZmRXbTO3tIhcFXnXdXvmIOqMEzq2uLigC36kKqjGVK8ax20tJcpwim4QQ0mYqZX6GmA1ycW6qBrEzAGGPiRfJ+SWm7OLRiFpV5XynWNnOaN4cVlaevJb30INFOC7DRe5NUxyeFPwBSgQo9s8+N02iaObkM9o/+j9gKpR39IsGyNv98OQ5gWYu+YmF+7Xq7eOXR7tx1gVvV3+BvmATAOZTDT7LJrqz2hWLLIgiDSXgEfZwsHmEyN05hBJO1AjZmmNgSu2RZTBl/DVlR0s9X9BdGrIuHPXAGhXdZN/AQ12aYBzbtYXFK9mK+Z7xcZkt6299Ur165Q9I7dC9KV0NKbhtd8UGASyZNiohLEFoo8Tp2Zkh253pYU8TRAYzNAm5AwP8Tnj3BR2Q7mB5F9pV1y/a6uMTALIWDdE7sMqNBdE5r+AW/MoEeCEIzhOtlQiiZ38o5O9lUXksBqNUyyvbIqBJspFv3yl5sCMHmAJH4IwLr9cRF5VNBMNPTyRg3ejsIBqgp1/IPcBuREWGRnJM8np+exQyKyRCto28PXrtj3iCNlfQ1SvLOEkDvRsY3UBp21K4RiG+X+gGV0rv2ABbQGRpyQN5swDJexp/jfBacWl0k8PoHDkcJiC/hYeGRAfJ5RwXEk9Cd14fTgLbPT1WdHZOFLjA1aHaiSSM8oUWDPTYOScVati6hp+ItW6/tWh05YEbizn2t6mUNVKPaj5CjP/4b5tIM8NI7lSwvHtVVnj4qIBWfd3cY6ofu04T8MIsbQCgtT6QRGlHYdpyQKYwW55/2VtVGCWSX0g9ig2GTAB7POaPQnq0jFM7KT2A4HVhUNWnLKkkkLI
 nBEM/Gnt
 ljTGMHSYy0ZwCt3qooiwUiTTXTToY2sDsGZWy5U1yuYwRdInPwzlrn7XQt3xeg7M/hJcOCZQmCMdFW+/Qo7hivtL5GNKiuK8qHa3KInGXmuum1sgXY/5+N/jC/s/HgcnkAnNfCjBU0V5SnrQDAzyHcQToFMzURlGE+AM32NDNfx577CxHZer7wfs9TmVKSkt2y4GNADegBPhV67dGEbUrEhYVTG+8LCDpK8jvqkj/ntCKCaM3D68LhPzkq8cOumikwEV6eCvHEkuN3RpxYiD6XMhDipMQz8QfkrH84YZZrblWeCsZoMEsINNwyPqz77lVX3OVR9C4T3CUclHb0X/d9jCNsYQT0ogATp/R8OS8iRowV6o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 10:32:20AM +0800, Herbert Xu wrote:
> On Tue, Dec 09, 2025 at 01:15:02AM +0000, Yosry Ahmed wrote:
> > 
> > Just to clarify, does this mean that zswap can pass a batch of (eight)
> > pages to the acomp API, and get the results for the batch uniformly
> > whether or not the underlying compressor supports batching?
> 
> Correct.  In fact I'd like to remove the batch size exposure to zswap
> altogether.  zswap should just pass along whatever maximum number of
> pages that is convenient to itself.

I think exposing the batch size is still useful as a hint for zswap. In
the current series, zswap allocates as many per-CPU buffers as the
compressor's batch size, so no extra buffers for non-batching
compressors (including SW compressors).

If we use the same batch size regardless, we'll have to always allocate
8 (or N) per-CPU buffers, for little to no benefit on non-batching
compressors.

So we still want the batch size on the zswap side, but we want the
crypto API to be uniform whether or not the compressor supports
batching.

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

