Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1F2ED2CE17
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 03:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21676B0005; Sun,  7 Dec 2025 22:24:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2546B0007; Sun,  7 Dec 2025 22:24:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8466B0008; Sun,  7 Dec 2025 22:24:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96ECC6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 22:24:01 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20FE3C0999
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:24:01 +0000 (UTC)
X-FDA: 84194859882.28.A929897
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf02.hostedemail.com (Postfix) with ESMTP id 49ABC8000D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:23:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b="j00J0/IH";
	spf=pass (imf02.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765164239; a=rsa-sha256;
	cv=none;
	b=lnFL0Sk95JjLVqvdgFBP60s8QjxicfEtHePzF1B94MHgtMHNbdAAkQGV6SJweIEgqBn6QU
	lPCuzp2BlgMycU9UBZFracsNuBTYp2cWS83pGPrL7oTqK08Li2mp+CoAjU9Crb2JPDPa53
	vQoXwtlxfx1TR7BiHsdVpEwIym8COmk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765164239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xgnn6MwSl2S/6LuXc1sx4ksRMJ6UXHwQQO3rL1/acEI=;
	b=J3/aWGpyVoUtQkx6V9QEh3YKYNLV0mhYgo4yvqNnvXcGmzaEIRO4/b8lFt0arqAMQXArtm
	XrQCT5nw8I0nEIBG+Gw4EAGssA4L5oEpATK8h2hoeUDw169Pk2Wp6GTPtRqRkeczVtSgyH
	Gaz8ZTHpDiz4dppzPpwFPn8+23R34+w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b="j00J0/IH";
	spf=pass (imf02.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xgnn6MwSl2S/6LuXc1sx4ksRMJ6UXHwQQO3rL1/acEI=; 
	b=j00J0/IHH6pOHYr1EdBh3Pfn8wlSyxziIWLWdek3IBYXF/P9SrYAS3Gs51jEyFdh4bjSifxC5jv
	ii/aC2PJTyv2sutj7cdM1hTQDoP11Fm7e8tRWpwlKpbH3qbQyXE9iJaiBJTT9/oEt8Qqh5dj2jl/A
	sFjnI0WvAu3E5l4ciYVVvKt9wuMZmGO/nQt5qlvI2+wbpFMOuwABCwOoaul2lAm0svQMCmIOHK8Iu
	LObyEF8YMbjrRvOIDBI5CnA5xXUkOe0fFG6nup7EtGu1xBcvk+jf7XHzMwvlD43xzEKTsaReTdJsb
	64CGxDvsyKlgTkA/Ye8oSpj2YQV0I0VR1a+Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vSRqn-008iGp-1h;
	Mon, 08 Dec 2025 11:23:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 08 Dec 2025 11:23:49 +0800
Date: Mon, 8 Dec 2025 11:23:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, SeongJae Park <sj@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"kasong@tencent.com" <kasong@tencent.com>,
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
Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
X-Rspamd-Queue-Id: 49ABC8000D
X-Stat-Signature: n53z1r8ag444p17spfujmydjs4ybsr8c
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765164237-72376
X-HE-Meta: U2FsdGVkX18c1pjWsa/ki51Se9jD47NCWZ4PIPaCefohgDKSJ8Oh6qt835aiU+xOrOeUM26SZplbcgbv4Sn3jZbwBI3t6pDmce5ftKy+l6mjVWMu8vGRlmY36ba6rHXOg05MZOHsrUSk/xdTLAVqsovtpKy2vWdYDxXU0lcuUAmBeuBQ/EO6y6ia82t9X6uT9AxpomqUbxfU1KHI7THa6DkYvn3WBSol/CbEPge28G6hEg0GypshXe8FMSN6YUFSmkvFFGlCLWPwTkpA7HzZgTbXY7A+xq3OBdMdr1ZZSMg06r7x2yWqlFTc0lHQfZmxJ3VOOXFjyNmFqtFgGP50UC3r2Tc1aULC+9pTYGwRGbTwxVc4ffGX5zxCjTncGCEIbyNHuHRVJ1JzkH/d6WSZRMTJ33VNe+XlLrsKADRj+z2bb23aBAaxoDGs4Po+FJzjBiA6QcVfSRiNs+2TlZ/whxZlcy+wvFb7Z6wWFbG03kDvjt9f+0+4jOE6uVM21rlfeH0AEBHv9rFC6X6Br16ByC+PuOdMfsTtUfwK901JsF2asKmmb2MLbUcm71YFu8/jOTE6mWa0+PDrEEEi1MNDT2V2SJA7olRgW+h+zxeJRb1803kE52nlHhyBJunuICAtbbwEVELTSodHzlSRwrviEDsItX6atcgcHl7MyE7c1/HSyzsGdI5jX4OGj/F5vN/FmP8BO52gvY4K2tU96hY3KwIphBuOqTn72lUBJvE2hP77DAroZjbfw0FqjO20Sm/HM3v5K9CQIrvi5DvbHOlUgjGVXozqAHwB5eckYGGtTpSxwFJsLPxM64DMV//D18GtslWn69rJnwp+NwNdw486ZmP8zMMB1jULrGtu7Zw9kxBKEKDeNTMviv36EoOZBY6S24TH9eyltEd9+JswI9ODk86/C7KYx8rjM2kgvKdAFNVrd3LifLhj+mdJL6F8HxovLRXagNrsspaZqBCCL34
 oHCCgfDo
 /v4tO2Hm2FjWnLLOYnLlFkV/u5UIOb0EqR1chJSt2MXjSjGmEEX2pGgihK97b53/RYccAmkZ4BrJhUQVLSY7B0McaJhkmYz8E1I9qK+rc+rxSYJkMNKV4fOo9V0GUtPPT9EAuuPZnBvEQLjNi4V6t3wqid4K1K/5JJF0xBvmm2GnQsadpZFq/oyjMwt0U1TxG6Kgjh2K/pk8NhnRAyB4P2Z+BKnZyhfk7IPZ1hvcA2Y98pj3CRqZTaGJiWDFUU9IaeyP7szKNrxb6Rj55IsLMoKpBfQ5SrfkeaRf/OLA/RjSJOkjt6ERTXNV1Sr7CzGmd1/yDkTeWTN7O8C3XIzY+SahXhrUOrhEdJ/5JXTIExGqHYv3tNdWIvu9VkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 08:05:40PM +0000, Sridhar, Kanchana P wrote:
>
> Herbert, to make sure I understand, will you be implementing all of these
> features in crypto_acomp for software compressors? I would appreciate it
> if you can clarify:
> 
> 1) Error & compressed length propagation to the dst sg->length only for
>     non-batching compressors.
>     a) For batching compressors, this wouldn't apply since errors could occur
>         for any page in the batch, and the first page (dst sg->length) could have
>         successfully compressed.

This would be the first step.

> 2) Will you also be handling the case where zswap can send an SG list batch
>      with multiple pages to a non-batching compressor, and the crypto_acomp
>      API will internally compress each page sequentially, propagate
>      errors/compress lengths before returning?
>         
> If so, this would really standardize the code in zswap for batching and
> non-batching compressors.

Yes this will be done as the next step.  My understanding is that
your patch-set doesn't require this yet as all non-batching compressors
will have a batch size of 1.

But yes this certainly will be extended, not just with sequential
processing, but we could also use pcrypt/cryptd to parallelise the
compression across CPUs.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

