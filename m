Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AC7DD78789
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7FF6B0088; Fri, 19 Dec 2025 10:26:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631A66B0089; Fri, 19 Dec 2025 10:26:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F1B6B008A; Fri, 19 Dec 2025 10:26:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 482E06B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:26:18 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E56D2B7C85
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:26:17 +0000 (UTC)
X-FDA: 84236596794.04.50F9811
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 40573C0004
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:26:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="R3/X1Ce3";
	spf=pass (imf22.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766157976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AV6l+3QPJOj+3ABXPS+GUdyLpMiv6Gbs09n7zqVMbwA=;
	b=y4us3SSTGVrfJpgMDlG8+nNdGrO3W2OdsQnGndgKALG6SRhhVUoYe8//qTkhJAG0mZOSUV
	ETIXCeq/qnLXMITfn7FP3FJ7fRouvtQZwJitzxOciZl9XUYLmIh0vNrrZdUBqrsh+g30cB
	fCIu9D6hItcXIYY7L5RXjsBNi4cZMGg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="R3/X1Ce3";
	spf=pass (imf22.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766157976; a=rsa-sha256;
	cv=none;
	b=byjEYe8Xnbf6zpcIg9/k7dPgyFfEVIemdIh0wpxZYTQ/TZz72xlN+Og2Looyk/E0U0HK89
	Guc1/WPLrDxCHkrc1SUH5TFf3+G/Ilo3pgvxYjGuhFPwaHxoxZnNF1mfhPWw8cX4Dkmmty
	h3p/J+z8jzCNLyw1puuvD77aJjWkvng=
Date: Fri, 19 Dec 2025 15:26:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766157974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AV6l+3QPJOj+3ABXPS+GUdyLpMiv6Gbs09n7zqVMbwA=;
	b=R3/X1Ce3qK0UY2cGkwZriN0mfPxH7BKu3e44uRo1xI2IeUOmIIQ/OHYjE17tya25yQ16fD
	EVaqs/Rb2QvpXVI0fWgrlr5x/wta6dnXtWIJMgQMbqHaku2y1+RHbC0nGQW0Wlw73BK2ev
	irSs4A8Ao67m4tnsTzJYxkz0cJiNhFc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, 
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com" <clabbe@baylibre.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, 
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <uqznqihjuyfk3ifyxsjwp6x7nvk2vloinody6fomfuqepfu64n@25yboetztah3>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <vc65dxjoledwtojbcdgyxh2xt3hhlqrzgxcnbgufji7sgnhkus@fqkcflhwbags>
 <SJ2PR11MB847267511A5B6CF9EBFA1A0DC9A9A@SJ2PR11MB8472.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB847267511A5B6CF9EBFA1A0DC9A9A@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: hqakyq7i8onangacqioudyt4b3to618h
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 40573C0004
X-HE-Tag: 1766157975-788076
X-HE-Meta: U2FsdGVkX19+IkLT1Our30p2nun+GWTaISXJZu0hPYGuQcovL7CEh93rc3i6H/ljrn6d1NvFCXNUZodXbKOO1fExK2ZUXwWSldaJt+ayYh+186DObBosDJam5fCkja3/PM4imZY5LY77UJWi92c+3SzDdWhICN5fJ/J6+2zPh5wkaMluzSP+yk9OZB5ezpOwDgtRDFYWsTIYpcHr76KWu7pTnEjSAMocNs7j/qDIDx3YRFAa3MkxSuP9u5wsB89bZFQ/iC0bWI1K1EgMJf2GRGRM99vk/2ze1CSDG/laawgiEaX4qLochlacgL42HOJSdU52Q9gcKmCmcRDXaVfGAHkeMliJ0dU2Jcu0FC1h+XxU9R1nCUt8uTkQ3Kbc+5A+xXntaj7z+NgsfYwg/7qScWdSkO4r6QGipiS9Og0ygUsazsJAZJnEODm+2b56kobT9/CYc+zqxGCjMaK3BS1vwd+nLfiShcU/514IGOtwBZCHZyCas4nWnzmkhjLfztZhvRHMTk+11r+r/iu9DmV6x+O39aHb5eh8Xrei+WudIODoVfN+ziRXgQ0y+k0pOmiF5RK9yiOitVtEFh9bsKwPmsRAgBSJ2W7nnBhzbDheYVDr5Wqvms+gXsMbV7Gdj5WiO5qNx9o1IhmfnlAFcNweN+McHOuXBo3XiYzwEniesz00Rq5iOP9xGYjuS01C71NvYd5O8Hn9T5guPFbcQiA1BpMPvIOn3ZH2RBEBHGG3I6r12Kl8N1fKBLbK9zwtlVILlOC39ugGkbjoAE9JM6zGI2pv+EBdJeBhpDBTjNc17HGWuksIELjsp/3HShlGYw0RtJoA90mQhfeHC/e0KS+pyvAE3uouaV8eNRUKwiHcAINIYInDNnABvk3THQ+6+A9hcFjEJiROl7Sl7RJ4N8QauvO7RdACm6W9WHsR7OII5uny6r7OI06r7sKoUSrT5rOBVEkFYZaZ9vk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 02:29:15AM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Thursday, November 13, 2025 4:46 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> > compress batching of large folios.
> [...]
> > > > > Architectural considerations for the zswap batching framework:
> > > > >
> > > >
> > ==============================================================
> > > > > We have designed the zswap batching framework to be
> > > > > hardware-agnostic. It has no dependencies on Intel-specific features
> > and
> > > > > can be leveraged by any hardware accelerator or software-based
> > > > > compressor. In other words, the framework is open and inclusive by
> > > > > design.
> > > > >
> > > > > Other ongoing work that can use batching:
> > > > > =========================================
> > > > > This patch-series demonstrates the performance benefits of compress
> > > > > batching when used in zswap_store() of large folios. shrink_folio_list()
> > > > > "reclaim batching" of any-order folios is the major next work that uses
> > > > > the zswap compress batching framework: our testing of
> > kernel_compilation
> > > > > with writeback and the zswap shrinker indicates 10X fewer pages get
> > > > > written back when we reclaim 32 folios as a batch, as compared to one
> > > > > folio at a time: this is with deflate-iaa and with zstd. We expect to
> > > > > submit a patch-series with this data and the resulting performance
> > > > > improvements shortly. Reclaim batching relieves memory pressure
> > faster
> > > > > than reclaiming one folio at a time, hence alleviates the need to scan
> > > > > slab memory for writeback.
> > > > >
> > > > > Nhat has given ideas on using batching with the ongoing kcompressd
> > work,
> > > > > as well as beneficially using decompression batching & block IO batching
> > > > > to improve zswap writeback efficiency.
> > > > >
> > > > > Experiments that combine zswap compress batching, reclaim batching,
> > > > > swapin_readahead() decompression batching of prefetched pages, and
> > > > > writeback batching show that 0 pages are written back with deflate-iaa
> > > > > and zstd. For comparison, the baselines for these compressors see
> > > > > 200K-800K pages written to disk (kernel compilation 'allmod' config).
> > > > >
> > > > > To summarize, these are future clients of the batching framework:
> > > > >
> > > > >    - shrink_folio_list() reclaim batching of multiple folios:
> > > > >        Implemented, will submit patch-series.
> > > > >    - zswap writeback with decompress batching:
> > > > >        Implemented, will submit patch-series.
> > > > >    - zram:
> > > > >        Implemented, will submit patch-series.
> > > > >    - kcompressd:
> > > > >        Not yet implemented.
> > > > >    - file systems:
> > > > >        Not yet implemented.
> > > > >    - swapin_readahead() decompression batching of prefetched pages:
> > > > >        Implemented, will submit patch-series.
> > > > >
> > > > > Additionally, any place we have folios that need to be compressed, can
> > > > > potentially be parallelized.
> 
> [...]
> 
> > For example, you should remove mentions of ongoing work and future work,
> > simply because things change and they may not land. Just briefly
> > mentioning that there are future use cases (with maybe an example) is
> > sufficient.
> 
> Hi Yosry,
> 
> The mentions of ongoing/future work were included as per Andrew's suggestion.
> Hence, I would like to keep these in the commit log. Hope this is Ok with you?

We can keep them, but not in the detail they are currently in, and
avoiding mentioning what is implemented or not implemented yet because
it's not very relevant to the patch imo.

So maybe focus on the fact that the compression batching can be used for
other use cases like batching decompression in zswap writeback, batching
compression in zram, batch compression of different folios during
reclaim, etc -- without going too much into detail because these details
will probably change when these extensions are proposed.


> 
> Thanks,
> Kanchana
> 

