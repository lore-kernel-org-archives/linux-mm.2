Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDFC0CEACCE
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 20:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361348E000A; Fri, 14 Nov 2025 15:50:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3382B8E0005; Fri, 14 Nov 2025 15:50:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27AC48E000A; Fri, 14 Nov 2025 15:50:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 142488E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:50:05 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2FA0C0536
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 20:50:04 +0000 (UTC)
X-FDA: 84110404728.04.63A794D
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9E21C180010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 20:50:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=It51VS1w;
	spf=pass (imf16.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763153403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCubXLGEjf5yNbIg/so5Dl6MiWPjIZCOszTICQIIzp8=;
	b=n4qH/pDbIBGKvQeJW6Bm/aCwG03b/KFhLO+Fo4Cqsk2zC9o55QHtzQUaBMR5d6xcIbRxnV
	e8ZTxO/hPEVZPpkKQy6pRXgiI+hz5x4mEga6IUJp4R56BC50Sf/mLmM9FbJZdNLVMoiZVe
	Gj3IsM1EYxgdiIwTmTSYPfwHhVzZKdI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=It51VS1w;
	spf=pass (imf16.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763153403; a=rsa-sha256;
	cv=none;
	b=fdW+T41Go0AFqEzieosNxiGaqzUt2mEljE1lOO7+H+ZBN7tBrzJrcboXcwPCXyNEW1jcN5
	ZnPUaip0K+8tTZ8EUpqIbch5aKZpHYNr2yvKBz52yV1aY2RKbNXWqsgvGjFGIWalGRnUWr
	Wv6U8YarXUzi7A8Q5LHjVWkkvmsG70E=
Date: Fri, 14 Nov 2025 20:49:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763153400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uCubXLGEjf5yNbIg/so5Dl6MiWPjIZCOszTICQIIzp8=;
	b=It51VS1wlp2x9Qt7YpG8krPvvqoaLDqdqRwhNlKo8zhqqq/V0B5K3FWIMQ3XBjycbofuHC
	pGAwtOiIS939CuoE805Eqsd1Nkmh0lzAgoH2XeO3Km5Ew9kb+rWySvMgoU3Tox+gw8Nyeq
	yGJjTREn5JqefyyP7mOBjmOxamJBXaI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: SeongJae Park <sj@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, "usamaarif642@gmail.com" <usamaarif642@gmail.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, 
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com" <clabbe@baylibre.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, 
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <ekilv3urk442lezvzul5dwergk6baubuhgrnflf5j4yfj47lwx@ae6y6mvsvs3v>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <SJ2PR11MB84727C029B980E5E06F7291EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <keys236tojsj7a4lx6tyqtr3hbhvtjtkbpb73zejgzxmegjwrb@i2xkzvgp5ake>
 <SJ2PR11MB8472CE2B46F08804CF5F2158C9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472CE2B46F08804CF5F2158C9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9E21C180010
X-Stat-Signature: 3wzhpb8tbkptkw419ysoyt6h8gyjdr34
X-Rspam-User: 
X-HE-Tag: 1763153402-453094
X-HE-Meta: U2FsdGVkX19dZc39nVcJvY0Lory5i/7HNTZaGEtOWHOAZDOTfNNVyNKFpO2g//LD1FXT1zTw4zZxNmNqqJzxQf/ba1NJ2wOGNXaUHMFT/buL57lopDHiqOmE6cosjyuMIcjPyiMOPTs8JDKz3HBHux4eEbjvtJEiHbUWy09YqKO5V+8DuSLPqhPJwu+TYWsRtZv4Atw0jYboyRGsTOHmvYwN7fq9/ifkB2Mr82QjUuH0iSTx9U/IoBCfInSoGAmHx9E4S1bUdjE+yUm1b5v3mxS4d916mJR7Jg1yGQ+fdn0ITT7kmCJJPwI7p/+Yh0omSjHHb6/BYFEy69NYZQPGAwfDzzw11mc1UG+VwQQi/1tEFsCjDy9u7IDW4OmlVPu794YkW8HfmofEoyotTLzm29jahkj3109sZ3xO1rIf58gTEvg+d0X7UFL4/KofAtqJL2fWcMcG7hVV7ntXma3lAh3RF+sn5Q+zv+Q6jUQeryBPL1afZDzza6RVfyIFeef6HMNNuex0OJ7FtJOQI1cvsosDY9MPzcrC4/3W57Y8NwXfZ2FOME7a8Nv9BiquPxNaeKYV0cwS0Isvg9Qpd7wLU3g2zMETG9ZJNguZEqvJbxjKE87QUI6lX/rg+aUABVR88fJbz2Qxy4J0z45Pj7pU2fIi2j/TG+JmeitCHQ5AQoaU3SGi6lgAS9/2DLTVYO+TKXS8ntwMDSSoQ3CpumumALam5BFMaZhTWR7F/+SLS422cka1veF9mD0kJfoInBPqGrKArKmoZk/G8H7/KRQHBneaGNcpTZzxQpEPyNTjS29QjxkouLUPk4VBxdTa4cbzLQUZutnJyulpbY+UhApnuwUaOCojweEggxDpsVubE6YHTJ4T1DyGjf4wozHStE1KCpqRqOUcsp1xAxvn0IT53uYgOmtyTbayBIIoIYQdpddHoojZV09B/w1S6rKgsdEfHDcvQE7oaHtx56iWyQz
 GzatYy0b
 kqHH037xNSI5JBmUvMgotmJVP4P20RMi9fU44kOpLdV6ov/Jbeo9KAZFp3fJ1xjnJo9VZqGlAoZ/K0tdR1acUyAmbgP7bxP1vdGBOrtEi003F5Zw9b2fqViBXIekOyuZ3IFc9MXaJuFwSpDmIoGg/lufS8yujicY4OdLS+q9LsEkoWJfBaTHxbJojz/e9uIe3QQwhimQ/C4SMfW6LJr0UoELxh7p3/QLY6J6/9qjdVANt4QxDEbWWhQcAqlJkb3/GmMok4yzaZWDNRWv/XHa3LTxjmTpTpjmiq1WJ9iGtiLbQ0h575tUWusnGVQAioFQ5KOAUTdVGfhgg63zWK6V9FMV4PkAeJfX1Svc7+CAd8vXIkEXJs1i8Vw1TMMqJKj/cYdJnF6S4V/6epAUOvqI/gxlXhVg6+0E+2+CHffvYjx2lElpSKh/81b6Qi7B9E27GFB87yCiSj+vQBZxRappNCoa3MUUh7H6UJb2wO6pk23mz2Ny1nSKB4dJ2uKAYcWgpAbxqsbxlDq1i0vVbD8RByIZoZE0jXahw5ro49tNA2wKXiBPnreWaRFC8uNNChlXh7hJ8bdLWuH6CPaaqYCmGLsmsrTjuPUSCp3OlknxlBXu33mXQ2360aEDNHHnODTIIsUPs6hVHAjIgjkbqP7HOQNE+uZd9+Li1lZO18vQEX3LvBH3XqMh3PXVODjztjAJGN+GaabFF8LmQKSYr/9l+xB4n7TrFVBMBtMuo/3NRaD8EARkeOQwv3YgJS13MMTpfumND/69SAGjuTwbdOTHfCAZcTjh6a4rnrzcI8ezjDXD5Wglseao0Hz+/xVx7XNYkH+pLG3WuMc9BVe2nF/hVrB58EaEcCL2jWAbEg+wZTApXMrmbL78EfxD1kw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 07:59:57PM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Friday, November 14, 2025 11:44 AM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: SeongJae Park <sj@kernel.org>; linux-kernel@vger.kernel.org; linux-
> > mm@kvack.org; hannes@cmpxchg.org; nphamcs@gmail.com;
> > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> > compress batching of large folios.
> > 
> > On Fri, Nov 14, 2025 at 07:23:42PM +0000, Sridhar, Kanchana P wrote:
> > [..]
> >  > > > > >
> > > > > > > > > +		if (err && !wb_enabled)
> > > > > > > > > +			goto compress_error;
> > > > > > > > > +
> > > > > > > > > +		for_each_sg(acomp_ctx->sg_outputs->sgl, sg,
> > > > nr_comps, k) {
> > > > > > > > > +			j = k + i;
> > > > > > > >
> > [..]
> > > > > > >
> > > > > > > >
> > > > > > > > > +			dst = acomp_ctx->buffers[k];
> > > > > > > > > +			dlen = sg->length | *errp;
> > > > > > > >
> > > > > > > > Why are we doing this?
> > > > > > > >
> > > > > > > > > +
> > > > > > > > > +			if (dlen < 0) {
> > > > > > > >
> > > > > > > > We should do the incompressible page handling also if dlen is
> > > > PAGE_SIZE,
> > > > > > > > or if the compression failed (I guess that's the intention of bit
> > OR'ing
> > > > > > > > with *errp?)
> > > > > > >
> > > > > > > Yes, indeed: that's the intention of bit OR'ing with *errp.
> > > > > >
> > > > > > ..and you never really answered my question. In the exising code we
> > > > > > store the page as incompressible if writeback is enabled AND
> > > > > > crypto_wait_req() fails or dlen is zero or PAGE_SIZE. We check above
> > > > > > if crypto_wait_req() fails and writeback is disabled, but what about the
> > > > > > rest?
> > > > >
> > > > > Let me explain this some more. The new code only relies on the
> > assumption
> > > > > that if dlen is zero or >= PAGE_SIZE, the compressor will not return a 0
> > > > > ("successful status"). In other words, the compressor will return an error
> > > > status
> > > > > in this case, which is expected to be a negative error code.
> > > >
> > > > I am not sure if all compressors do that, especially for the case where
> > > > dlen >= PAGE_SIZE. The existing code does not assume that there will be
> > > > an error code in these cases.
> > > >
> > > > For the dlen == 0 case, the check was introduced recently by commit
> > > > dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
> > > > as-is"). Looking through the history it seems like it was introduced in
> > > > v4 of that patch but I don't see the reasoning.
> > >
> > > The existing code did not check for dlen == 0 and dlen >= PAGE_SIZE
> > > prior to commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression
> > > failed page as-is") either. We need SeongJae or Herbert to clarify whether
> > > this check is needed, or if it is sufficient to rely on comp_ret, the return from
> > > crypto_wait_req().
> > >
> > > >
> > > > SeongJae, did you observe any compressors returning dlen == 0 but no
> > > > error code? What was the reasoning behind the dlen == 0 check?
> > > >
> > > > >
> > > > > Under these (hopefully valid) assumptions, the code handles the simple
> > case
> > > > > of an error compression return status and writeback is disabled, by the
> > > > > "goto compress_error".
> > > > >
> > > > > The rest is handled by these:
> > > > >
> > > > > 1) First, I need to adapt the use of sg_outputs->sgl->length to represent
> > the
> > > > > compress length for software compressors, so I do this after
> > > > crypto_wait_req()
> > > > > returns:
> > > > >
> > > > >                 acomp_ctx->sg_outputs->sgl->length = acomp_ctx->req->dlen;
> > > >
> > > > For SW compressors, why is acomp_ctx->sg_outputs->sgl->length not set?
> > > > IIUC we are using the same API for SW and HW compressors, why is the
> > > > output length in different places for each of them?
> > >
> > > This is to first implement the SG lists batching interface in iaa_crypto, while
> > > maintaining backward compatibility for SW compressors with the new API.
> > > I believe we may want to adapt the crypto API to SW compressors
> > > at a later point. I also believe this would be outside the scope of this patch.
> > > It would be nice if Herbert can share his vision on this aspect.
> > >
> > > >
> > > > >
> > > > > I did not want to propose any changes to crypto software compressors
> > > > protocols.
> > > > >
> > > > > 2) After the check for the "if (err && !wb_enabled)" case, the new code
> > has
> > > > this:
> > > > >
> > > > >                 for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
> > > > >                         j = k + i;
> > > > >                         dst = acomp_ctx->buffers[k];
> > > > >                         dlen = sg->length | *errp;
> > > > >
> > > > >                         if (dlen < 0) {
> > > > >                                 dlen = PAGE_SIZE;
> > > > >                                 dst = kmap_local_page(folio_page(folio, start + j));
> > > > >                         }
> > > > >
> > > > > For batching compressors, namely, iaa_crypto, the individual output SG
> > > > > lists sg->length follows the requirements from Herbert: each sg->length
> > > > > is the compressed length or the error status (a negative error code).
> > > > >
> > > > > Then all I need to know whether to store the page as incompressible
> > > > > is to either directly test if sg->length is negative (for batching
> > compressors),
> > > > > or sg->length bit-OR'ed with the crypto_wait_req() return status ("err")
> > > > > is negative. This is accomplished by the "dlen = sg->length | *errp;".
> > > > >
> > > > > I believe this maintains backward compatibility with the existing code.
> > > > > Please let me know if you agree.
> > > >
> > > > For batching compressors, will 'err' be set as well, or just sg->length?
> > > > If it's just sg->length, then we need to check again if WB is enabled
> > > > here before storing the page uncompressed. Right?
> > >
> > > iaa_crypto will set 'err' and set the sg->length as per the batching interface
> > > spec from Herbert.
> > 
> > So both 'err' and sg->length will contain the same error? In this case
> > why do we need to check if dlen < 0? Shouldn't checking 'err' be
> > sufficient? and it would work for both SW and HW and we wouldn't need
> > errp. Did I miss something?
> 
> Great question. For a batching compressor, 'err' will contain an error if any
> page in the batch had a compression error. This allows the early bail-out
> path for SW and HW compressors if writeback is not enabled for the folio.
> 
> Only the specific pages' sg->length will contain an error code. The other
> batch pages that compressed fine will have the compressed length in
> sg->length. This enables the post-compression loop with the errp check
> bit-ORed with the sg->length, which for SW, has been brought up to date
> with the acomp_req->dlen before we get to the wb_enabled code path.
> 
> > 
> > >
> > > >
> > > > >
> > > > > >
> > > > > > We don't check again if writeback is enabled before storing the page is
> > > > > > incompressible, and we do not check if dlen is zero or PAGE_SIZE. Are
> > > > > > these cases no longer possible?
> > > > >
> > > > > Hope the above explanation clarifies things some more? These case
> > > > > are possible, and as long as they return an error status, they should be
> > > > > correctly handled by the new code.
> > > >
> > > > As mentioned above, I am not sure if that's correct for dlen >=
> > > > PAGE_SIZE.
> > >
> > > We need to get clarity on this from SeongJae/Herbert.
> > >
> > > >
> > > > >
> > > > > >
> > > > > > Also, why use errp, why not explicitly use the appropriate error code?
> > > > > > It's also unclear to me why the error code is always zero with HW
> > > > > > compression?
> > > > >
> > > > > This is because of the sg->length requirements (compressed
> > length/error)
> > > > > for the batching interface suggested by Herbert. Hence, I upfront define
> > > > > err_sg to 0, and, set errp to &err_sg for batching compressors. For
> > software
> > > > > compressors, errp is set to &err, namely, the above check will always
> > apply
> > > > > the software compressor's error status to the compressed length via
> > > > > the bit-OR to determine if the page needs to be stored uncompressed.
> > > >
> > > > Thanks for the clarification. I understand that the error code has
> > > > different sources for SW and HW compressors, but I do not like using
> > > > errp as an indirection. It makes the code unclear. I would rather we
> > > > explicitly check err for SW compressors and dlen for HW compressors.
> > > >
> > > > That being said, I thought what Herbert suggested was that the same API
> > > > is used for both SW and HW compressors. IOW, either way we submit a
> > > > batch of pages (8 pages for SW compressors), and then the crypto API
> > > > would either give the entire batch to the compressor if it supports
> > > > batching, or loop over them internally and hand them page-by-page to
> > > > the compressor.
> > >
> > > That was not how I understood Herbert's suggestion for the batching
> > interface.
> > > He did suggest the following:
> > >
> > > "Before the call to acomp, the destination SG list should contain as
> > > many elements as the number of units.  On return, the dst lengths
> > > should be stored in each destination SG entry."
> > >
> > > I have incorporated this suggestion in the iaa_crypto driver. For SW
> > > compressors, I have tried not to propose any API changes, while making
> > > sure that the zswap changes for the SG lists batching API work as expected
> > > for SW without too much special-casing code.
> > >
> > > I suppose I always assumed that we would update SW compressors later,
> > > and not as part of this patch-set.
> > 
> > I am not sure I understand what changes lie in the crypto layer and what
> > changes lie in the SW compressors. I am not suggesting we do any
> > modification to the SW compressors.
> > 
> > I imagined that the crypto layer would present a uniform API regardless
> > of whether or not the compressor supports batching. Ideally zswap would
> > pass in a batch to crypto and it would figure out if it needs to break
> > them down or not. Then the output length and errors would be presented
> > uniformly to the caller.
> 
> From my understanding, this would require changes to the crypto layer for
> SW compressors, which again IIUC, does not set the sg->length, only sets
> the acomp_req->dlen (IIUC, a temporary state until crypto for SW also uses
> SG lists).
> 
> Ideally, batching could be handled similarly by crypto for SW. I believe we
> will get there, albeit outside the scope of this patch.
> 
> > 
> > That being said, I am not at all familiar with how crypto works and how
> > straightforward that would be. Herbert, WDYT?
> > 
> > >
> > > >
> > > > This would simplify usage as we do not have to handle the differences in
> > > > zswap.
> > >
> > > That's the nice thing about SG lists - I think the zswap_compress() calls to
> > > the new batching API appears agnostic to SW and HW compressors.
> > > Other than the upfront "errp = (pool->compr_batch_size == 1) ? &err :
> > &err_sg;"
> > > the logical code organization of the new zswap_compress() is quite similar to
> > > the existing code. The post-compress "dlen = sg->length | *errp;" handles
> > the rest.
> > 
> > It would be even nicer if the batches are also abstracted by SG lists.
> > 
> > Also, I don't like how the error codes and output lengths are presented
> > differently for HW and SW compressors.
> 
> I do believe this is short-term and is the first step in implementing batching
> in zswap. We should get Herbert's thoughts on this.

If we have to keep the different approaches for now I would still like
to simplify the error handling. We should remove errp and explicitly
check sg->length or 'err' based on the batch size.

