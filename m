Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9161D3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 04:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D736B0005; Sun,  7 Dec 2025 23:24:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F586B0007; Sun,  7 Dec 2025 23:24:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63DB6B0008; Sun,  7 Dec 2025 23:24:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 98C0D6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 23:24:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 207AB5BC84
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:24:12 +0000 (UTC)
X-FDA: 84195011544.06.4E4EB6E
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf26.hostedemail.com (Postfix) with ESMTP id 90454140011
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:24:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=pAX9BWs5;
	spf=pass (imf26.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765167850; a=rsa-sha256;
	cv=none;
	b=1kGw77fApaaHNowhU3KSBKqyQIBJSr8dAuT5GybOlmglzdnhV92ejcm4dIpCg3QOzDn6Zv
	TsbemTi6YbYg3X9cSDFPz2QuOcB3zdk+KiG5MxcSRA5vAIYULX9efGtdS0VSj031u8vtUK
	/KSDomfWr6g1Zv5QAQBg4GmyG9zGxNE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765167850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/loCMcRK3SHcozV/rrXZo27ykLob1cEFT8/fXdhGbo=;
	b=EPpktCY2xkAkaX6rXMDbamLhrjoINr9d2s7K+PevL80VPUitHYnTiqkdr2TuW2u2k0CX90
	bI78S5i6/uwVNaIh6mDk3TbUaxXeze+vUFox/MFzYoz9MoLUq9hn9W+fM5zOg0rTZRX/ud
	Og4aJtQqPn1IcFBWeAZPrYeS7iS7oK4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=pAX9BWs5;
	spf=pass (imf26.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=i/loCMcRK3SHcozV/rrXZo27ykLob1cEFT8/fXdhGbo=; 
	b=pAX9BWs5XC3KEOmZeupzQOtI/cj30E3YtWBMizDnBzLV1sarSrYDYsJqJYYnMbIw9f0Ha3KsfQg
	SOzxnTJEdldqQC7ZGLp/jd9Nllq5DOHdFVoTj4qIQkV3YXr0r9uYFvf1XVyEQsaezaknQ+6gTIYz3
	atXO4C/0T5iqpR510EsZ77iFDjXRdN1kqRGkOMjJmfsDYrRXtOGoIdDwsv77rwk68W9/R8g0Nh6al
	sEsynd2C4MIFRaKWnzXsnB2oABqWTOhxxCsuXaohy0bwpxygmQ6UGNEOExAiirUgI0r2ck0yfu4I3
	6GjUZoz/GMUyNtJEbtTy4uf8KbJJkzSqDqQA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vSSn3-008ihW-33;
	Mon, 08 Dec 2025 12:24:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 08 Dec 2025 12:24:01 +0800
Date: Mon, 8 Dec 2025 12:24:01 +0800
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
Message-ID: <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
References: <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Rspamd-Queue-Id: 90454140011
X-Stat-Signature: f89n7tc1rxr3r9aopa67u1n7c958n3an
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765167849-457852
X-HE-Meta: U2FsdGVkX18Q9SUEHutIgUIZBnxOBnvlI6xUNut6sit31PEPMQIB/aCCxaXpo66Rv/JWSsq7V/NOwbG4VPjFBNKVncko9EQvd22DfoB1ZS3Wmg4/nwaFxhmyL+uDpMBqn5cBFDT4JmQZruBL23M8IQsnFHJwjnucD7qaKwor4fRLHvGg/EL12DoJLduk/khKwOS52MPIjJiYFR4emWlZs5ZWhPeKMz+oIG6lNHJ6aqVTwoOr3wlM0jwa4MNtKMhvcXczyAbI6wBjAR56l+JjJ5KvHM3AF6cKcy8OjIshb9h/XEmyOq3Nc9rIkN50hZQFN7mqqZlPr/YavNJT9rPvG6ARdDPl6qIqQ+kaor7z3ODsT+BJws6vPAvzEB3P3SlcLRlaXdsL99HDJlKddNlkgmPx7Az+Mw+qRfvSjTwzS8NQtl3QDNa4b3uz5yRRDZj+iFRHZwJX7eX5oB2SRaDxGt/3XASTjiKhDGa651lXrr/QnMrcB5r8ir8MK8AFzDe7Pe/s/JMkcYcLfTGtRAYqhMkrgTFhfHYXs84q6CnKNa7crlDwvBs8zv5P8EG/ITkKMbGsbI8JvaV9SG2R5OYbONrn0l3QjHCEcLZ7H9KnvwHtaY3xSGGONDlSllf2RWjuKVc8hem2uze1RT+miRq9XaW4aAKKrusjqZHjxR/Ma1ursWgwWgn3JVfYZzndlEP7eCCqk+metKy6cHFV6Wtc2KmSed/TyZDmkecd7uz351v0u0QGS0+3QnoixO0ca6tE50c5TvLuwwFWF6yp6HXFdk6/1RALEbEXbZLyZg/wiNzhENmiUAR7oMMQnEmHmqvTUcKO7ePZq0vbY5tTjDn9C+Ip8BcdDkmmdAqdxy33ezABlpfixExf4ZqD9mZtxBqMDRJHQfwh1mHifbwsbIzM1KWgwRCxwMmovUnz3dcQis40jetSxuv/8fRZfKusRmtWoZUJj+pA905e31Acw+U
 nb4R7Hrw
 qWBt3OVyyov6eJs4vHJjPwszuqJ5DFCLii5Xvlp9mvC+0f1hiPD2+c3TAlCTl0EzPb3SgPSKOFs55C9Xwg3r7HX+QjqqUYceiEgG3HEIYqnHPh81GqiISiH2MguvRMPqG6DpQqxJE/oDSIKrjXzPYVf3sl7AYs+dWd47RyF3nIc4yAqJYgXDLEqdE0KhFOCy88ha+M5sQV0BZIesF17LJguRgF8SeGD8F3GByB30PWYkGkOCzcwHQJSNhqTvUzbAEdYIZ5q1xGT1rJnR7v73RNJojml2Mw9s/ZY3U8a4fQRaXU8Q2X7ZneL2Xcub2I3+jDGrE/zooPdPDs7M6DBjH8jlUgIwFIm9SWsY7dG8vc2HZRQAOPAFZyTQMw8hcpTr7t8x5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 04:17:38AM +0000, Sridhar, Kanchana P wrote:
>
> I see. So the way my patch-set tries to standardize batching in
> zswap_compress() is to call it with a batch of 8 pages, regardless of batching
> or non-batching compressors. In zswap_compress(), I presently iterate
> through each page in the batch for sequential processing for non-batching
> compressors whose batch size is 1. For batching compressors, the iteration
> happens just once: the whole batch is compressed in one call to
> crypto_acomp_compress().

Oh I wasn't aware of this.  In that case there is no need for me
to delay the next step and we can do it straight away.

I had thought that the batch size was to limit the batching size
to acomp.  But if it's not, perhaps we can remove the batch size
exposure altogether.  IOW it would only be visible internally to
the acomp API while the users such as zswap would simply batch
things in whatever size that suits them.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

