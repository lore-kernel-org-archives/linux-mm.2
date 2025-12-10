Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA3AFD3C922
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 16:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 078716B0005; Wed, 10 Dec 2025 11:02:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0028D6B0006; Wed, 10 Dec 2025 11:02:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0BA86B0008; Wed, 10 Dec 2025 11:02:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAA426B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 11:02:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C018140249
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:02:11 +0000 (UTC)
X-FDA: 84204028062.18.E3D4BF1
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 035F540004
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:02:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qo5LTV5m;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765382529; a=rsa-sha256;
	cv=none;
	b=zgDixBxa4iWLTkoPq4KEsmPb9+LMHJ1EZ6QPrlGeIEkqDb92sGU/VsPPqdRVxuM9DXab8U
	fWQoWOlMNGMR8IvxzZ/Mv/rhZVs0YRRL5xmJRHe0+xMmSjIT8VOuj5q/w2ipJAareR2ft+
	Q2ql+UcIw82IxlwCnbgroi6S2GVXR7U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qo5LTV5m;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765382529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dWoR7UIzQcb07jlgSZ/0O0cJ2y2/O3Euwx3b+WfcfL8=;
	b=EaUHmDtSpK2/mryiMXoeJLccOYRW9/F61rBHkPxZHeYfhhqtgGF8EJrNiRo5lpLU17AM+0
	opmhRZXjgcwuCS6s1J5a09rP4wd95elhDa7ou9bxNj72S/84ZwMvrMBzFt8lg3oFbU2JvC
	9saohWMAF63OB9IOZTA0VMw6kQZTTNU=
Date: Wed, 10 Dec 2025 16:01:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765382521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dWoR7UIzQcb07jlgSZ/0O0cJ2y2/O3Euwx3b+WfcfL8=;
	b=qo5LTV5mTOnx7nIoTU+LKhYwSrfrTkAeZCQdagkhS+BEeI3hmFSvbe/JuD6qH6K8chR8R3
	JWnrrO9QyYWYXi0+9vxUEWAAKORhM7fnlO68nFiwGNndu2k6Jqdm76GEv6NLru2zruclAg
	vHX1YivYOm6Ckn6M6wHoanBUEQQjQZc=
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
Message-ID: <yhecgcnt52hnsyf23p576mz2mlnffqrluikwzv6tdn3bnmzumc@thpyltdpxtjq>
References: <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
 <aTeKNEX5stqjG55i@gondor.apana.org.au>
 <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
 <SJ2PR11MB8472CE03A67C1161469CDE9EC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <bfkkizyjmfulkzxgf45l7tjsnudtyutnenyngzw7l4tmmugo3k@zr2wg2xqh3uv>
 <SJ2PR11MB8472D347836B6CA3FEB0CDEEC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472D347836B6CA3FEB0CDEEC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 035F540004
X-Stat-Signature: esiksozpk3afrptxmxxpusr5hjncyj8n
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765382528-233502
X-HE-Meta: U2FsdGVkX19DFg5nZeyQbBqBd53eAm5IckvpDexp2YY7M7ZnUEbCa7wqBel5xMy+tMEVEa4YN5TyC+Q94InWH7E11Jqu3aJcie5kIc5nP1THIq24GSYguQsB7Q1mq5kBkzFcZDH120EEftZuxIQyFeNmD5eOKoEYaXo+PgSm1nmW6KM4FhIAloMRy4qSF26g55k2wzxmb5658tFp6IQimgB+rj9xgFbi4g6N+fGBb/L3nfGd2wUooczprqr4Is/aePu9jQVZvA5DN08VXrPRDf1OwMK2fKK6vlMoBjhI4yNIzkmOrXu6OlO9g7XYFJx0nW5Je3tCwozv+KGZX0HhzEoq5wphhH60stWASgtAlloffLgU/VuGc/T9hfWhYZp6vT7SFGlESFlRaIdUlym4OrzEnXSdWpLVekdX8nLq6avNWEYxwjnkmPhTBeklzGannnhSPpqA3q4I/ijYOlOuQQdSyOfiaWFLXc5ONdNI5Tux9COeHiLHDZLUh6dkY5ERce/tUbspOuqM1ogTIK1sEMftcqGrR3agrc7M+W6LjWPlOYazT+Skb+udEZL4pL9mxaDluYdrAe61DadrmpR+sGNYVItTdNiniWaylsWONmQHtvt+Csqkcc4KzI6hJ8KjavcFzywRhZRvacULcahIHWcr2qXJwnfLbR2ZHdqqfUZ7/CwtI2t4iA4Zd0ZhK+s7ToeiHKOee2KovnruD33wOcUHGkfpv9rBoqyOQl2tqr7tmwXkMXPxVmGNbbvnU1sr4xlqQjQ9bz0AzxbC/Fgh54nYZl9z1+y5ttMtpNxeni5NZwDgGQGrk7VvKnfkngeAosk96S3SVKkIdBwHQM2ooL5dgd94Suv0+A70LLuT89prOENhImORYmqhIhxGuPJsPvLSdNiHFSlC06/xuFeG9En098JzjOGMV7/L9WTEXzTl+ZytAtlLQesF8cNzERdA+VkQZwQj24RlrYzCHab
 /SRCIF2n
 t5jaGvSdVAHgTHaPkpMPHzVjgnjTL083Li5wPKZoCSqSjiULSG3C5yixSd3RQgoSjYBcujZ/byZELIDxJtsIfjALBuvpU5qggATZKlsGNi92jtU4zbWStMQ+iryyFTALM1zzIwMVCrOb6t5pMCPq+Debn3VcqrDxs5i79j5hktXKzHAnPYlzOC0Tpbu5Yy+leA1WNMN03uZGcGwKPNWz64GlzyMV4Q2+vQVj9h0Vhi0JtXFgj1lRwLMXGyJI9VHO+fm/FhAYpYRJ3qGbPTHGmj3fAqu/nXlphY+K0tOhiRqPEMDOzuWxvuKM2tuRziKcMDg/7R6yam1Rjd29RpQunyOzkUXrvjoiiBc43RbuocjKwcmanB7nL6fT2hRLTGHIsjmIjhBjARnncSNFwcnM4FpLJjC0/npPXFcVRaCH4pao0ZP9kYWpAZF+Z4OAoaFj6tXxEdKL6anc9Js4a9tnSr0JljrhnEdLEfpJH3P8XBvCwHUD0BIhe4hxLJ3haZVR68DED8HSv7sS7OO+enEI7ywyoH5jXFosfUmhH9SUSKGwtZ6BtuTGSQW/lGIRmEo0bp68XB42oDdJA5uOKyjVVMN5xq+z13hGuIFAWtoX5Tu+L5VDkoE8ztmXqm1/VWeFcqQL047+g5XRsvTBaiTnRL1VT+HTGwG3C6vJQYd9SaznWIFXKupv2udmB3yB3yEJklquC9Ee8H0JaZOcNgKe0o9EOjw/nzJvOE+wa0hear7hfCQ7qzHzSH+hU9mdEW+XE5dJ15MAlNFX/Ib2kw6P8wrBkkb8qB2pg+M2qJ219TRcT0Nac5V2cFGENmvYR1JoYvGOUnkXCRNdtie5sluaWqqUaq+EOxsMGtA9aBv8my/aJjV1rpkC0b3nuHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 07:38:20PM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Tuesday, December 9, 2025 9:32 AM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>; SeongJae Park
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
> > On Tue, Dec 09, 2025 at 05:21:06PM +0000, Sridhar, Kanchana P wrote:
> > >
> > > > -----Original Message-----
> > > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > Sent: Tuesday, December 9, 2025 8:55 AM
> > > > To: Herbert Xu <herbert@gondor.apana.org.au>
> > > > Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; SeongJae Park
> > > > <sj@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > > > hannes@cmpxchg.org; nphamcs@gmail.com;
> > chengming.zhou@linux.dev;
> > > > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > > > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > > > senozhatsky@chromium.org; kasong@tencent.com; linux-
> > > > crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> > > > ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> > > > Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> > > > <vinicius.gomes@intel.com>; Feghali, Wajdi K
> > <wajdi.k.feghali@intel.com>;
> > > > Gopal, Vinodh <vinodh.gopal@intel.com>
> > > > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress()
> > with
> > > > compress batching of large folios.
> > > >
> > > > On Tue, Dec 09, 2025 at 10:32:20AM +0800, Herbert Xu wrote:
> > > > > On Tue, Dec 09, 2025 at 01:15:02AM +0000, Yosry Ahmed wrote:
> > > > > >
> > > > > > Just to clarify, does this mean that zswap can pass a batch of (eight)
> > > > > > pages to the acomp API, and get the results for the batch uniformly
> > > > > > whether or not the underlying compressor supports batching?
> > > > >
> > > > > Correct.  In fact I'd like to remove the batch size exposure to zswap
> > > > > altogether.  zswap should just pass along whatever maximum number of
> > > > > pages that is convenient to itself.
> > > >
> > > > I think exposing the batch size is still useful as a hint for zswap. In
> > > > the current series, zswap allocates as many per-CPU buffers as the
> > > > compressor's batch size, so no extra buffers for non-batching
> > > > compressors (including SW compressors).
> > > >
> > > > If we use the same batch size regardless, we'll have to always allocate
> > > > 8 (or N) per-CPU buffers, for little to no benefit on non-batching
> > > > compressors.
> > > >
> > > > So we still want the batch size on the zswap side, but we want the
> > > > crypto API to be uniform whether or not the compressor supports
> > > > batching.
> > >
> > > Thanks Yosry, you bring up a good point. I currently have the outer for
> > > loop in zswap_compress() due to the above constraint. For non-batching
> > > compressors, we allocate only one per-CPU buffer. Hence, we need to
> > > call crypto_acomp_compress() and write the compressed data to the
> > > zs_poll for each page in the batch. Wouldn't we need to allocate
> > > 8 per-CPU buffers for non-batching compressors if we want zswap to
> > > send a batch of 8 pages uniformly to the crypto API, so that
> > > zswap_compress() can store the 8 pages in zs_pool after the crypto
> > > API returns?
> > 
> > Ugh, yes.. I don't think we want to burn 7 extra pages per-CPU for SW
> > compressors.
> > 
> > I think the cleanest way to handle this would be to:
> > - Rename zswap_compress() to __zswap_compress(), and make it handle a
> >   given batch size (which would be 1 or 8).
> > - Introduce zswap_compress() as a wrapper that breaks down the folio
> >   into batches and loops over them, passing them to __zswap_compress().
> > - __zswap_compress() has a single unified path (e.g. for compressed
> >   length and error handling), regardless of the batch size.
> > 
> > Can this be done with the current acomp API? I think all we really need
> > is to be able to pass in a batch of size N (which can be 1), and read
> > the error and compressed length in a single way. This is my main problem
> > with the current patch.
> 
> Once Herbert gives us the crypto_acomp modification for non-batching
> compressors to set the acomp_req->dst->length to the
> compressed length/error value, I think the same could be accomplished
> with the current patch, since I will be able to delete the "errp". IOW, I think
> a simplification is possible without introducing __zswap_compress(). The
> code will look seamless for non-batching and batching compressors, and the
> distinction will be made apparent by the outer for loop that iterates over
> the batch based on the pool->compr_batch_size in the current patch.

I think moving the outer loop outside to a wrapper could make the
function digestable without nested loops.

> 
> Alternately, we could introduce the __zswap_compress() that abstracts
> one single iteration through the outer for loop: it compresses 1 or 8 pages
> as a "batch". However, the distinction would still need to be made for
> non-batching vs. batching compressors in the zswap_compress() wrapper:
> both for sending the pool->compr_batch_size # of pages to
> __zswap_compress() and for iterating over the single/multiple dst buffers
> to write to zs_pool (the latter could be done within __zswap_compress(),
> but the point remains: we would need to distinguish in one or the other).

Not sure what you mean by the latter. IIUC, for all compressors
__zswap_compress() would iterate over the dst buffers and write to
zs_pool, whether the number of dst buffers is 1 or 8. So there wouldn't
be any different handling in __zswap_compress(), right?

That's my whole motivation for introducing a wrapper that abstracts away
the batching size.

> 
> It could be argued that keeping the seamless-ness in handling the calls to
> crypto based on the pool->compr_batch_size and the logical distinctions
> imposed by this in iterating over the output SG lists/buffers, would be
> cleaner being self-contained in zswap_compress(). We already have a
> zswap_store_pages() that processes the folio in batches. Maybe minimizing
> the functions that do batch processing could be cleaner?

Yeah it's not great that we'll end up with zswap_store_pages() splitting
the folio into batches of 8, then zswap_compress() further splitting
them into compression batches -- but we'll have that anyway. Whether
it's inside zswap_compress() or a wrapper doesn't make things much
different imo.

Also, splitting the folio differently at different levels make semantic
sense. zswap_store_pages() splits it into batches of 8, because this is
what zswap handles (mainly to avoid dynamically allocating things like
entries). zswap_compress() will split it further if the underlying
compressor prefers that, to avoid allocating many buffer pages. So I
think it kinda makes sense.

In the future, we can revisit the split in zswap_compress() if we have a
good case for batching compression for SW (e.g. compress every 8 pages
as a single unit), or if we can optimize the per-CPU buffers somehow.

> 
> In any case, let me know which would be preferable.
> 
> Thanks,
> Kanchana
> 
> > 
> > In the future, if it's beneifical for some SW compressors to batch
> > compressions, we can look into optimizations for the per-CPU buffers to
> > avoid allocating 8 pages per-CPU (e.g. shared page pool), or make this
> > opt-in for certain SW compressors that justify the cost.
> > 
> > >
> > > Thanks,
> > > Kanchana
> > >
> > > >
> > > > >
> > > > > Cheers,
> > > > > --
> > > > > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > > > > Home Page: http://gondor.apana.org.au/~herbert/
> > > > > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

