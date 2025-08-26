Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F214CA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 04:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A94D8E0094; Tue, 26 Aug 2025 00:14:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95B248E0090; Tue, 26 Aug 2025 00:14:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86FC08E0094; Tue, 26 Aug 2025 00:14:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 766048E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:14:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 18660118CE6
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:14:59 +0000 (UTC)
X-FDA: 83817593118.19.C996E08
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf09.hostedemail.com (Postfix) with ESMTP id C219A140004
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:14:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=orenYixY;
	spf=pass (imf09.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756181697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ertIYPEFECJ0bvh76dRuNtOkYGLs+05loEH4MTifk1A=;
	b=hO80vG0ePPsr0xoMF+BjMCF1iFPbKc2YplX8ZIS47P0O4GBObMXAmxThUFRKaQ64SPDceX
	p9xTWKyQkxfWx+jR5UeaEcr5m4NwGaw7BQHHOwp9EBXMnCgyEccNM0MHosIGDHIPHV6Jd3
	PNj5XMv2HnE4Um1IfxV2KtJuGHrLl4c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=orenYixY;
	spf=pass (imf09.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756181697; a=rsa-sha256;
	cv=none;
	b=6D95wD/wZz377HBBPedkjRgkk6OiDd1h+p71yQsqXPviZzJd/9ySUPSpNmnDvuVwGNphHs
	0AO1YFxPkHiz8ZYp3lX2jshMQ3r/WU8eVYbRFsYtSuaKXXmm4seSPskrdCMKYv7O1SaDaU
	pnStt9d96dldXzgqHKfiFLiV+RWKMsI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ertIYPEFECJ0bvh76dRuNtOkYGLs+05loEH4MTifk1A=; b=orenYixY1R7z+wDwcpNDDXjvLl
	Zs9EOdg4bUD8MnprbkzgLahp57QL/LL+E4y2b5dmQ5xIcuPsGw7Bj55ZlOcjdf2oy7lH+jryamLOF
	8vdBASxwlFMoSzUYxpGgXEBzAUGZwc5T2nAtyRZE2RBalBVgsz/JBH+z0QdWf29XcedjF89WD/hjF
	tWpIDwa/Rk12XgjMNLWPn1ENLC1XMuvOhjmRn4Bedoa+vAYgT4wPz/rfF/NDSWVPkVM2DErij2GMw
	yxEjf1YfcTxrbMhEZx9XcRfjoGPlEQYWopyqNuY5nezXm1V1Mjjf/LRkoa5IbKoW8EOoQcAsgMW3Q
	hPNSbtpQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uqkpf-00HHmm-1S;
	Tue, 26 Aug 2025 12:14:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 26 Aug 2025 12:14:47 +0800
Date: Tue, 26 Aug 2025 12:14:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Message-ID: <aK00t9ld3YOWJo1I@gondor.apana.org.au>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
 <aJ7FSUdvxtZyiHBq@gondor.apana.org.au>
 <PH7PR11MB812143269E98B00ED4E5BE4DC93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aKv28XTvAITuq-p8@gondor.apana.org.au>
 <PH7PR11MB812163C97D4C533F0302FA20C93EA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aK0KNAmQh_JVgnML@gondor.apana.org.au>
 <PH7PR11MB8121473792ACC3AD50D5F129C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB8121473792ACC3AD50D5F129C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
X-Stat-Signature: dpk75mre5pbo9ue3racsez4w9krbda4h
X-Rspam-User: 
X-Rspamd-Queue-Id: C219A140004
X-Rspamd-Server: rspam05
X-HE-Tag: 1756181696-819765
X-HE-Meta: U2FsdGVkX18q8JUPzB37Dq/GXKLefHr339Iq3vdn2P6s0LGvaSuaw88DmSPKt8lyAdppY/KQ+JnfGnpBlINqx3fKbiXwjKeMVWCmvC5XlHvZj3jVn/npYK0B4FZNBjIynjrVHOjqT9+9VbNvter/wB7hpTVVCLxIkJtKC4xjhA3KQpSc7Idie4F5qOPPxPVzb/OW3lF/WY+fAbKy+fMrBsqZadj+V8Q6obAHeuVO3oSicCVpueS16FkRgqrMnTZrdv8K/lxJoxyVGBVDQVVj3y/Y79QIdPdNHwbcIQD17EX0STWc23p9eE2FVd/hPGaEL0UNwEfLYtov87dobYxDj5sFGDrbg/tMRf9AzE8L4JIaNYW0TEyD4KIOCqm069NLYR8K/DVXoEIoar7csiwHQ6/jZ3jKYeeYW6S6ac03AcFPWaPpYf7M/NydpZkcdbiySK2st9qUSckxZeuq9X/kuUoD61Ld/9JSvN5+XJaJC76/1usbBRr9dgSn4+d1lMr4rY3k0aa1M2tRUlxHbtZuNo9GjwmUb6PzUw58DZMLkcS76f+pFm88VguQEtYvfAv6+g7IxHciFTSJdZl4FMHyBVEp5xvxYZmbC3tMUW3ETWLJtTc4KSVaMDFJJmUEeLsl8ATe88GZ/hE//FOhunG1Bh0x6peiIR9531d/ZL6ltB0wzMCOpnfz3wHPdbaYoB8W/hr/CBF6jq/p2q1OlweAIMkAUZNa9F8rx1wxL8dCjIG65mnC9yxzou2pWOxgc4O4ODjUmk/vsrBw2eX0tVTaWDmL4nfW2n7ouRC1k7qJR3SFujlvO2XrkRbt61HOZEjY+uG1bu1U6EfOXcEfTXgkoHiw93xJ7a2fAfnmNG/Mn0393JrJnUrvE0s4YowIEZfUAjggr3js+0ZXqrJhWO4QZZ5xg3qGhkvC2F6aA1JB9BdSBRE24FZHSVj96/WArQoeUA8zrwFu5rZjOp3WFDD
 1qaDreko
 rHF+6WJ++faOtgWUv8JgysKA4yO2htW0TrZXkacjMaPtZD4QMLE4HjYF2jCTNL57HnmIbiUJ5GipV279W+jERn0voiYH9VJ5GEvwCJ4VsQvnTsqXF6RvHoi9JCAZuyco6dkjBlNHvug310HHUEpyIDOi3y3wrqOn1NM2N4lNQaJshGweybYVJ0M7xnImrbOBjuduKA05cAcybJqx1pUCS9cd5TQ+tusm6jy/K8n1tFjlUI0rA/HWcB5s7qHn4jFc3ROjlkRVo6Q+XDyXo8eReZePu+RBf2BfJOaI7BviVCieMXwSp2khJNbGvnPRqNT/iWplvy2kHrWVMOHg+oKpPVgpp9nb7lCCFpjVe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 04:09:45AM +0000, Sridhar, Kanchana P wrote:
> 
> Thanks Herbert. Just want to make sure I understand this. Are you
> referring to replacing sg_set_page() for the input with sg_set_folio()?
> We have to pass in a scatterlist for the acomp_req->src..

I'm talking about acomp_request_set_src_folio.  You can pass just
a portion of a folio by specifying an offset and a length.

>         for (i = 0; i < nr_pages; i += nr_comps) {
>                 for_each_sg(acomp_ctx->sg_inputs->sgl, sg, nr_comps, k)
>                         sg_set_folio(sg, folio, PAGE_SIZE, (start + k + i) * PAGE_SIZE);
> 
>                 /*                                                                                                                        
>                  * We need PAGE_SIZE * 2 here since there maybe over-compression case,                                                    
>                  * and hardware-accelerators may won't check the dst buffer size, so                                                      
>                  * giving the dst buffer with enough length to avoid buffer overflow.                                                     
>                  */
>                 for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k)
>                         sg_set_buf(sg, acomp_ctx->buffers[k], PAGE_SIZE * 2);
>
>                 acomp_request_set_params(acomp_ctx->req,
>                                          acomp_ctx->sg_inputs->sgl,
>                                          acomp_ctx->sg_outputs->sgl,
>                                          nr_comps * PAGE_SIZE,
>                                          nr_comps * PAGE_SIZE);

I meant something more like:

		acomp_request_set_src_folio(req, folio, start_offset,
					    nr_comps * PAGE_SIZE);
		acomp_request_set_dst_sg(req, acomp_ctx_sg_outputs->sgl,
					 nr_comps * PAGE_SIZE);
		acomp_request_set_unit_size(req, PAGE_SIZE);

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

