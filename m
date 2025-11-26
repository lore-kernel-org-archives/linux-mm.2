Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4015AD0EE29
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 06:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202836B0008; Wed, 26 Nov 2025 01:34:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2B76B000A; Wed, 26 Nov 2025 01:34:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C88B6B000C; Wed, 26 Nov 2025 01:34:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFE736B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 01:34:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8ABEB12B65
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:34:58 +0000 (UTC)
X-FDA: 84151795476.06.DB7A251
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5AD1340005
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:34:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Z/1NgAnW";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764138896; a=rsa-sha256;
	cv=none;
	b=vDgytIuwvltiIkkUFKON42r3LnPV+8XIsYzEJlYLZdidlNIRfClLapQhGoFuTn9u8u7CTW
	23r51IPhpadTeFJ4+CH1RXGIYkwo3kKOr9GGzywKYlut3aoEhlYFSLIcn/6mAwV1BQUawH
	mIyBicYUW68+h8coKdX7O8ilC2Pq3eA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Z/1NgAnW";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764138896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pt3UEXc3/Z0TV1okLPkYdDhe3DfPfF0KumEJGXKpnc4=;
	b=eem8cjT96e2AXbdFN28ARlv8CjXsUF9pFnfJb0J0qIdZhgYDNTiQGmxTvCuZ78/GmOiAg/
	zdA+u1EBxe2RGB2GYAe3CUP80SxroSW0jTpy0NFUp/CvbXskyDgwE5ETGMJwMkmuEdrWTY
	c20hytBD1cj9uhMz7Tcjc8ckKUs7lMs=
Date: Wed, 26 Nov 2025 06:34:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764138893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pt3UEXc3/Z0TV1okLPkYdDhe3DfPfF0KumEJGXKpnc4=;
	b=Z/1NgAnWeaYRTwRyoaHBMoUoPuUlstfNUGHAfAtiGEkjTykAe3zrpTXgovCyTnFNg5WW1j
	FGKWaS7yJhssoDVCZ53OZ/cnaHN5te5Qtb9hfofHcCZhA/BOEwzZTIhs22+mW4FCJ46Uhz
	+t1+Cv16cU+qbQvGmE4J3+Yf7D3wfcA=
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
Message-ID: <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSaUUez5J1w5WyE-@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5AD1340005
X-Stat-Signature: xi91oynttxeg5kyp3xz81ujguekzyfcw
X-Rspam-User: 
X-HE-Tag: 1764138896-891182
X-HE-Meta: U2FsdGVkX1/Y/KvmgvQ8aW9/+nYMb0FU3DIquzvgcripAFBKbNvMjp8zTtT+IYtp+lptx4RrQXbvsAHGCRmyYbaRXfupVGr2k4OCd/y6xRPmziy4nxh10Pi7KcYSfEsWq44XubF/ICOiWAv+QqarcF99trlJR24Y2MpfLV4ZR5Oq/fpxEoinhVj7tcmv6wVqeCAo8w59IjCxqyzTBWPTUDikl2yoP+3xEmk0lKWhQXZ33vZOzxI6ckrKR6LkDygsr94xpiCfQ15IYmbaJm9Sjqd8IQk6HyrSBMTlUy5tSoDxiETAOATGJimtuELNxuxHo9b/ksq+11HEDM9x8TNJ+5XNNPFlQWEWWzs5CLf+hRXr/Hp4+r055wWu+h0CeRLgq8zzVpJrF47QVfVY5BJ+pNIaRIiJMYKOxsabEYfvIEg4RChvPFol2ALfVDAYihPJU7AspIswMGYBMr3E7kgK3FVbwvimfpHHqMTVpEQnR6YwLIZl5GLbshkAx02dgYLLU49f2Ez/F7HnoVaXvWN9YgfEwtFug1dWSVcDqgwTKsYHfZEvoF0nvrgZCKTMbKcXNT7+coqeZYtNJS68cRdRDz95uzFpOUYu6MmMvyPohsKveX+tzi+raiAUkoFytICtEkjJqF/xyNIV8QDFS2/roZjNF8s7XIKG86ShjpbOwlVobLll82s+kZoS6eiywM3GeGZktLKaOjINS+hXpC8hAFKJg6tbeans5UzX1wR7Qw8pKC5i98FU6hNVB9YrlDLjills6tbLgMlnZNEaEEN9h4v3u05UKFs3MBs+ZWaxt27Mw+kukE/YyRNGveO8eG0+DR7V6Id88hzVrA3k/0VfTs/N0Nbb7PtlDNmE77+RzhYNe30KU4iZ80YYrgJJuR3dvJKXzKPd0DceZCP9O6QGxPGz7XilaiGuLV+ayUS83EJ+pgU1x6IypeETkOp6+t4SOWHl0KIltmEf67GtPYi
 TB9vEKt7
 VQC86d6w4698USPms3IlnvyR2vUv4m3pPJ5DpFPvSIL4EnT10lOT6jRYJBkpOG2C3xn9WEkm81rCOV4lFaL6ZI10UmPrt3HGVksW8pejY7kw0zO0vMDk3j85Xji7XVatZGh8MOHpMAOJ2EM9hhJRugMm1UvOV9FpsqP1SciW8CfvrypZcIol9PmeCw5t+eIae1ZXNEn21UyucWC16Ojieia2Iczgd1p5UjEuClR2AMoPqF41+f28pZSWoWkEfXFbL91vFJTML2PmBFrWtFE1zz/PVijt5iqxklrk8wnUoovHix2pOkz8zxXmwhn4BFR392Oj65mNUWshdsBNTGGbUk98JofatOx3F/6MIGnE9wakqXtc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 01:46:57PM +0800, Herbert Xu wrote:
> On Fri, Nov 14, 2025 at 03:37:53PM +0000, Yosry Ahmed wrote:
> >
> > Thanks for the clarification. I understand that the error code has
> > different sources for SW and HW compressors, but I do not like using
> > errp as an indirection. It makes the code unclear. I would rather we
> > explicitly check err for SW compressors and dlen for HW compressors.
> > 
> > That being said, I thought what Herbert suggested was that the same API
> > is used for both SW and HW compressors. IOW, either way we submit a
> > batch of pages (8 pages for SW compressors), and then the crypto API
> > would either give the entire batch to the compressor if it supports
> > batching, or loop over them internally and hand them page-by-page to
> > the compressor.
> > 
> > This would simplify usage as we do not have to handle the differences in
> > zswap.
> > 
> > If that is not doable, at the very least the API should be consistent.
> > Right now the error code and length are propagated differently to the
> > caller based on whether or not the compressor support batching.
> 
> Yes we should only have one code path in zswap, regardless of whether
> batching is used or not.
> 
> The degenerate case of a batch with a single page should be handled
> by the Crypto API.
> 
> So I will change crypto_acomp to take care of this case.

Nice :)

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

