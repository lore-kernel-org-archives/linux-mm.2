Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED0C2D3B981
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 17:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C35A6B0006; Tue,  9 Dec 2025 12:31:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E3F6B0007; Tue,  9 Dec 2025 12:31:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33BF86B0008; Tue,  9 Dec 2025 12:31:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1DA3F6B0006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 12:31:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A2C1686DDF
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 17:31:57 +0000 (UTC)
X-FDA: 84200625474.25.77FA135
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf30.hostedemail.com (Postfix) with ESMTP id A47888000B
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 17:31:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oro8iw+y;
	spf=pass (imf30.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765301516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0r6smmgNfGvVjQrSAgG2MQSRnerif7fVYwrIvFf+EA=;
	b=6zQ92/Wy74NhuCaFGZwsKd14HBg9JnAzWOfYkmyxCQni/5JW39yFc5RNjB0/rS49cPYT0F
	zGcDWoXfAYdthci7qUlRtjqcAXlCYZteak5fGUzSmnML7b45sWsqyfiModdq80T8mamrD2
	jSy87Uzv0QyQuMvybF99seVUilcS5ts=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oro8iw+y;
	spf=pass (imf30.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765301516; a=rsa-sha256;
	cv=none;
	b=gEcEYc31Lx967vBUcszTU1jcJaMJgwlwe3cHl1mjzhGwLVTCp5VsAOTyi3JrTaeIYu+t9r
	rUwwYDVamJmLA0yUCIzlw2ls+Z8MSG4wNzSg5Nt41jtryrQbGR64Lb6oycn+u/OPl34CIv
	iqoWzIKceeAT3jY41yLhtB87MYmINok=
Date: Tue, 9 Dec 2025 17:31:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765301513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k0r6smmgNfGvVjQrSAgG2MQSRnerif7fVYwrIvFf+EA=;
	b=oro8iw+yCYsySwiIDvfYRW4SEi3cU6GqUjVPipwHfrmZXzH2l7EayPnm2QMKAVWOAA78pM
	1jteLiceqnsVJ9Yo+w2/Ug+vi/qfA2Vz6soCMohKlCVg7Mqa/Y+Fg3hPCMRRVhmflXlGcW
	tgEdAAkMz9bGWBBRsSJg/339Rs1Atpg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
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
Message-ID: <bfkkizyjmfulkzxgf45l7tjsnudtyutnenyngzw7l4tmmugo3k@zr2wg2xqh3uv>
References: <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
 <aTeKNEX5stqjG55i@gondor.apana.org.au>
 <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
 <SJ2PR11MB8472CE03A67C1161469CDE9EC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472CE03A67C1161469CDE9EC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 41eabpoiuzqf3m5993k5zk7n7xwbi8k3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A47888000B
X-HE-Tag: 1765301515-772904
X-HE-Meta: U2FsdGVkX1/zlxWs7WM4C9OEdV4WThJaIzRVYyzRR2/9nDkMOyhBKNesGQx0E2HWUfeayrfYsnlRcdaFZ+S0Agbnkks3y1mpaesHO2dEFpZOTSQvWabfxiXazP01VGITfbTIPiVmYcDqfIAJqFexLSEZgFe/PbWC3dRB5Tb5WlzG0k4kUE7oAtSD/HtxVpO+30UqeGNnTeIsUUNk9oMWYu1lqQiR2FmA0aYDFds5FFuE09Yfxxp1rTHfcohrKKymkQjBZP7WPvHhVxQerDQw9guMTrm19qI+JbexHLJu9KFZvbz37buBzaw9jp+OVHrrj+KMxQXepHNOAZ8IaY/seaROkxuMsRvw0ZJA3LzkqenPNYHJ8Huc37s8MeSgddW8F0oVXL7pgTDgC/8xcrv3GkawircyUXxpj5PnDcySvGABrZaq33bu5YI62/cZKncAaV9lcGNKCs02FaTuCr/flChHHH4In3m7d83soHhd27tehHcmaJnNmZs//3Ro6bgcBC8MAuRebCvKZkPwgiAj8DzUweZaLaaMOTM0iyRbI+cmRKobX0UABo4Fdy8XxHqCa+aB6hqcGg6i2LYkL+CZVgvZ09w9HcYNWmyOYgkKioxBDM+mhvPdhp4C2c5AiQBnwoDJqWwff60UqMXdiPgdQYG3shcWjTqbPOr3rDt2MYquJd/QfQFzKpyk3Fl8bUMxz2/75s4L/sl8XNrboY3lvMvxJHgo3fXR3P2JdBtNr42Bc0l1RtYCE1yl3ad4ELB/y6KBZmlRmZ9+bmjnTR/Dt8S/X0vJenTbl+BGqicZ+FQ4a90cSIdX3IcYxt14FiGKQM5aNAP6pL2qputzGnzGUyuak4KjSEdEeeY5DbIk+uMC3d4SrNgQLOCwTyyCj1UMQV9CMjUlyFNFVuC9QqwDGnZnR9tDpNw99Z2TGpSBzN0eon1rUxyOH/e1Dzrmfi9CfJgqLq5TBnVZotZUtGe
 Oxwqktlr
 FHAQljNW1eHmXpCh0pKGiWYwWZgfSgzdaxYTTKkKt/D2tVA+XqT1KfSx1BuTbrezyhmvF4ka5nEfGIH55BnBobD1b9YeBni3b0QFVlpPpkF4t/S00luLdq6gRwqngo9rH83X0X1rK1pYLObAzzJzlXgn1Xc+wH4uzTRQYA/Jf7+4gpJvUYj28EA3xXGlYXR6HK2j6p1MbHCaB/7/ynMGUaBV4L/OEE5rsFJlofH5hHugqiqkYfGpoLgycjWWk1jw5RYS4oTrsZ76IRszWQ3nutVxB8YtMLdzqkU2y2O24Iu1YsVAhDYCmIvBXpkt1GqHOHjiNYsDal0apAeUFwd8B0/a0JNWkaOWcCrHj1AVStofALp/4mzDc6OTUrbfcXXAQFKnXT0rllgfkX9KOgd1BNr1vCCcPv6b2YA0jSnDWKN68fz+3GHWfcMVhfthjwIbKu7+CMBibo+mZD4wnXMQ/5C9soNA+03qbu6/jjdamCqL+Sb6qYWK1RlCpc3ZbotalXE4HEcr3QXki3eQM6UpSkxy/IRNY8Z24xNDFjCYu74Y/FgZyoskSKsyQoMUdjPoNDyqkDm7fptA/2a8UBCFGNxq0rW/0rvdj5db+N2qfe3rZY4YfOxIA0vNdfYefGcBR1wnvqNkqmqGkt5d8Mr562qaD+JYblZkgC7I0mWB/XTHyZSgFYl+BebAUwOsmnwm755+thguI782zdKrt6aCGu94GCsmcC7Q028tpLkCWn4BhnG8HFAeQJx64BEgNbb06pj/Egm9F74BSb5mfCvFfKUzFbAgq4JMoGdV9y/qK+vHb8i2ZrSf/jBp4+spD5vhjmIsKSjGU+F9oWFcM0MkFFOqeXXuAUZsSbErVOZJM20Ze59JOrCJYo05Idg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 05:21:06PM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Tuesday, December 9, 2025 8:55 AM
> > To: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; SeongJae Park
> > <sj@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> > ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> > Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> > <vinicius.gomes@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.com>;
> > Gopal, Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> > compress batching of large folios.
> > 
> > On Tue, Dec 09, 2025 at 10:32:20AM +0800, Herbert Xu wrote:
> > > On Tue, Dec 09, 2025 at 01:15:02AM +0000, Yosry Ahmed wrote:
> > > >
> > > > Just to clarify, does this mean that zswap can pass a batch of (eight)
> > > > pages to the acomp API, and get the results for the batch uniformly
> > > > whether or not the underlying compressor supports batching?
> > >
> > > Correct.  In fact I'd like to remove the batch size exposure to zswap
> > > altogether.  zswap should just pass along whatever maximum number of
> > > pages that is convenient to itself.
> > 
> > I think exposing the batch size is still useful as a hint for zswap. In
> > the current series, zswap allocates as many per-CPU buffers as the
> > compressor's batch size, so no extra buffers for non-batching
> > compressors (including SW compressors).
> > 
> > If we use the same batch size regardless, we'll have to always allocate
> > 8 (or N) per-CPU buffers, for little to no benefit on non-batching
> > compressors.
> > 
> > So we still want the batch size on the zswap side, but we want the
> > crypto API to be uniform whether or not the compressor supports
> > batching.
> 
> Thanks Yosry, you bring up a good point. I currently have the outer for
> loop in zswap_compress() due to the above constraint. For non-batching
> compressors, we allocate only one per-CPU buffer. Hence, we need to
> call crypto_acomp_compress() and write the compressed data to the
> zs_poll for each page in the batch. Wouldn't we need to allocate
> 8 per-CPU buffers for non-batching compressors if we want zswap to
> send a batch of 8 pages uniformly to the crypto API, so that
> zswap_compress() can store the 8 pages in zs_pool after the crypto
> API returns?

Ugh, yes.. I don't think we want to burn 7 extra pages per-CPU for SW
compressors.

I think the cleanest way to handle this would be to:
- Rename zswap_compress() to __zswap_compress(), and make it handle a
  given batch size (which would be 1 or 8).
- Introduce zswap_compress() as a wrapper that breaks down the folio
  into batches and loops over them, passing them to __zswap_compress().
- __zswap_compress() has a single unified path (e.g. for compressed
  length and error handling), regardless of the batch size.

Can this be done with the current acomp API? I think all we really need
is to be able to pass in a batch of size N (which can be 1), and read
the error and compressed length in a single way. This is my main problem
with the current patch.

In the future, if it's beneifical for some SW compressors to batch
compressions, we can look into optimizations for the per-CPU buffers to
avoid allocating 8 pages per-CPU (e.g. shared page pool), or make this
opt-in for certain SW compressors that justify the cost.

> 
> Thanks,
> Kanchana
> 
> > 
> > >
> > > Cheers,
> > > --
> > > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > > Home Page: http://gondor.apana.org.au/~herbert/
> > > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

