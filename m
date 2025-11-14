Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15442CDE00A
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 05:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 123C58E0003; Fri, 14 Nov 2025 00:52:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FB988E0002; Fri, 14 Nov 2025 00:52:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 038348E0003; Fri, 14 Nov 2025 00:52:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E63408E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:52:40 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8DC1BC025D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:52:40 +0000 (UTC)
X-FDA: 84108143280.20.8B4B52C
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf14.hostedemail.com (Postfix) with ESMTP id EE503100003
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:52:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I4Zby4cW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763099558; a=rsa-sha256;
	cv=none;
	b=r0D4sMaoIg3nFLQ27K/gQFDlIqIf16qoNnUfUKOVHcC1dK+0Xy82y8Cl6PbX/l+uxldVpV
	v8ke60PZ6StnyoVSlXwqcD5XXH/SFrUYVTwfLQjkCNEqhMz6xV48S1wwX7xqFFwPkdSO61
	6FPKZWsmZY24cXKMc7vTAOj8eNY+zeM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I4Zby4cW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763099558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jXkxn+nUrE4qhcH53ASIXVe+cIbpnFTU4tsJNDHC20I=;
	b=LuSW/gqRvT4kfbg4AS+ovok8i1OM04m5AqBE5lukCjV6N2+o3blVNFpAcdh45gJXhlS7A6
	ez3wazjTz2shpvK2vPs5MT6/PFhc7sGMgdAEVmnnooA6qQkbHvsKxKw6D9306geXBulEjb
	nc/RlTtuakMqorBMelk6fPjOjAEnt2A=
Date: Fri, 14 Nov 2025 05:52:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763099554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jXkxn+nUrE4qhcH53ASIXVe+cIbpnFTU4tsJNDHC20I=;
	b=I4Zby4cWK2XFX5NxE4X+qHrxjoy5T/HYxLZrxPbMMl9bUlmDerYHa0lpiGb6YgQpuPzFTZ
	Wtf8HEMRXWaWYQNSKHTyCgYSjs60uxptFvI7K1dJ1YnvNApqgx7ot5Xa7Cu8DZYMJdGCZm
	AytU+hPToISs+NkMJgd7rnXrXiUq+vo=
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
Message-ID: <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EE503100003
X-Stat-Signature: 5druwpfhhqxscjyw7mgujkj4qdpjckcf
X-Rspam-User: 
X-HE-Tag: 1763099556-850253
X-HE-Meta: U2FsdGVkX1+2WMqt7wwIdZr3xydHrcUDsDKRR2n+dT7iZ+LQpGofwGbaHZ1K5xk2GPItMAhA3SsQqGe/mkOdjPXVFybE05SUk0GF0g29XyoajDgQvkTDL4ywAM/VXXeP0vgdl+zqfCHfK24XMPNbzjfYjEw8+YFzXfVJkpY4rN/VB7vNDt1tM7MrhuVV0vjxUIAh9AUwzWukrYZwvF/L0X/E25ClpmL1tCMTgOT73FapQAHIWmyR5I1x8UqYCSqWnXpwzo7mT6XInytPLIGiOSViKROE2+LT0ejeslyEYENqIIzP1/AU4cUSxlGDHzZ6mcm1drsbbjAufPjGQMN4R2ifrwX1Wb3re6E9XLiJqh+tp3mJm0dofowgsJSG1KCbHOC+hS1OER9AmGWrUW4XcYx5vx8Z8EdFPm2+kAQGMj4RHAvTD9ps9eJsT84xfVHwxwhFkPhG5CgblLcwSfojMK19WVovRnt7XRCvqbFS/T06QogxUckFZ8j1ajRvnpKYDq4LEeyzHNyHGkUQHvlRjWuXnd/5eltkxgcx+2oYQsOkeBYl3JVVWo0CHU6X1kLR+01KIXbLoMYho/PREpNJrbJl1ZRcMAUKFGwMth4OfS3etYbWhtcAqIRGNL11LzhIWtdtc9INrdr+SIXnp8EvPn8CRuk6rb8gmu1bYpuMx9zyybQfnJtRKMgq66UTx76NsWYQgXXhJ3LlX7SnMHqL8XoRWaBauppybBj3e+4qPlCmZNwEPtzYihmeIhR+Z5AQ11WW5IK3ltgTA/PoljXZyHsFuc5kHzlspenFgy10Qo1GStyVMBuw09Zpkndcsrg0wocSRjqyKdmFZdBj4/SWonzkoxSpjgIypnOyP69MngQmCpJwdRhQYrKrRhDF0xW6Mm938zPH8zZU2zsXn+4c4e8M2ERm++CETq11KywEjtgl1p/rmSVYHsuhwkqfCkKkfxX424lWTlCGmKlzCTP
 bXbpjjz5
 w3dUpD/EEahiYssbFsv/sWiptm8fJJQ6TEsalPtAvy6pAo7zQNrhjLKjGQjgZ5OmY9O2kXKQn98j6LNmQ9Goj7ruTFusYOjx+G1RLZJuGzfidmgyfFv4foqh+v3AIdIb/6Eqsqgn95F9Um3IFQWgAv7nPKv8OC+CkmoR38EWvRIb7/30Bt0fDby2ZFmg/04+qppSx0B5cwRRdxvuyzybPlONBZenDUYcX4ezIJRF96WB1KM4wWd3QSXastG1vsS8xu/rtcaRTIMMuwREh/KxL3ZeKtVs3EwykL1AQxuIvWYh+NGxaH9TF724lNMyYCAm/4A9HfepahJ/4LhP0miCWxemNjFp2Tm2zQQN4CAouNWSbn9vcDZEDrhQJNIsIuujHahw23gD9uxewoqPVe/4UjIpr8NjdiebwG9s0xUxzzGlguEY5UZZJdGKjfxDEDMTrjr4v/8v3IsnHINSVmdJLfwNLBRbcMhYXAzQQmyy0XgWEwleYD1fdUhRfm/a1jxzSuIm0C4ZmSMW1LUEY73WIdFC4Jv3OqlS5Q6VO/mlZ2Si5FOH/jPP2jBvI/kqY733AJoSyZadB6m2MEq8lvevGBn6/GBObKE1Fj0yquIRjvGXvYLkEZ/+64PGXa9y/ZIhLFKLYxo4vw9myXp0n8GdFc/r0LW9+A/hZv/LGNAQVTYuAoblIyrXiqU+llwU3JaiZf2rTE8tuk4iMfYD6rsDK2vAxHQdrnYpD6sWumhEzvekTuD6J9UXmxN5IMWvd0YOUsFNDBGcVpPZIOzZLC+ubrHis+nMtVxyemYTvE5akfg6AoayAafL642xv8czXAoIu3SttDrTsAdhY7hGmN5jrQUwvyj6wjTdQzMoyp8A9V7X717dxE5OS4ATg3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 11:55:10PM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Thursday, November 13, 2025 1:35 PM
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
> > 
[..]
> > > +		/*
> > > +		 * If a page cannot be compressed into a size smaller than
> > > +		 * PAGE_SIZE, save the content as is without a compression,
> > to
> > > +		 * keep the LRU order of writebacks.  If writeback is disabled,
> > > +		 * reject the page since it only adds metadata overhead.
> > > +		 * swap_writeout() will put the page back to the active LRU
> > list
> > > +		 * in the case.
> > > +		 *
> > > +		 * It is assumed that any compressor that sets the output
> > length
> > > +		 * to 0 or a value >= PAGE_SIZE will also return a negative
> > > +		 * error status in @err; i.e, will not return a successful
> > > +		 * compression status in @err in this case.
> > > +		 */
> > 
> > Ugh, checking the compression error and checking the compression length
> > are now in separate places so we need to check if writeback is disabled
> > in separate places and store the page as-is. It's ugly, and I think the
> > current code is not correct.
> 
> The code is 100% correct. You need to spend more time understanding
> the code. I have stated my assumption above in the comments to
> help in understanding the "why".
> 
> From a maintainer, I would expect more responsible statements than
> this. A flippant remark made without understanding the code (and,
> disparaging the comments intended to help you do this), can impact
> someone's career. I am held accountable in my job based on your
> comments.
> 
> That said, I have worked tirelessly and innovated to make the code
> compliant with Herbert's suggestions (which btw have enabled an
> elegant batching implementation and code commonality for IAA and
> software compressors), validated it thoroughly for IAA and ZSTD to
> ensure that both demonstrate performance improvements, which
> are crucial for memory savings. I am proud of this work.
> 
> 
> > 
> > > +		if (err && !wb_enabled)
> > > +			goto compress_error;
> > > +
> > > +		for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
> > > +			j = k + i;
> > 
> > Please use meaningful iterator names rather than i, j, and k and the huge
> > comment explaining what they are.
> 
> I happen to have a different view: having longer iterator names firstly makes
> code seem "verbose" and detracts from readability, not to mention exceeding the
> 80-character line limit. The comments are essential for code maintainability
> and avoid out-of-bounds errors when the next zswap developer wants to
> optimize the code.
> 
> One drawback of i/j/k iterators is mis-typing errors which cannot be caught
> at compile time. Let me think some more about how to strike a good balance.
> 
> > 
> > > +			dst = acomp_ctx->buffers[k];
> > > +			dlen = sg->length | *errp;
> > 
> > Why are we doing this?
> > 
> > > +
> > > +			if (dlen < 0) {
> > 
> > We should do the incompressible page handling also if dlen is PAGE_SIZE,
> > or if the compression failed (I guess that's the intention of bit OR'ing
> > with *errp?)
> 
> Yes, indeed: that's the intention of bit OR'ing with *errp.

..and you never really answered my question. In the exising code we
store the page as incompressible if writeback is enabled AND
crypto_wait_req() fails or dlen is zero or PAGE_SIZE. We check above
if crypto_wait_req() fails and writeback is disabled, but what about the
rest?

We don't check again if writeback is enabled before storing the page is
incompressible, and we do not check if dlen is zero or PAGE_SIZE. Are
these cases no longer possible?

Also, why use errp, why not explicitly use the appropriate error code?
It's also unclear to me why the error code is always zero with HW
compression?

> 
> > 
> > > +				dlen = PAGE_SIZE;
> > > +				dst = kmap_local_page(folio_page(folio, start
> > + j));
> > > +			}
> > > +
> > > +			handle = zs_malloc(pool->zs_pool, dlen, gfp, nid);
> > >
> > > -	zs_obj_write(pool->zs_pool, handle, dst, dlen);
> > > -	entry->handle = handle;
> > > -	entry->length = dlen;
> > > +			if (IS_ERR_VALUE(handle)) {
> > > +				if (PTR_ERR((void *)handle) == -ENOSPC)
> > > +					zswap_reject_compress_poor++;
> > > +				else
> > > +					zswap_reject_alloc_fail++;
> > >
> > > -unlock:
> > > -	if (mapped)
> > > -		kunmap_local(dst);
> > > -	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
> > > -		zswap_reject_compress_poor++;
> > > -	else if (comp_ret)
> > > -		zswap_reject_compress_fail++;
> > > -	else if (alloc_ret)
> > > -		zswap_reject_alloc_fail++;
> > > +				goto err_unlock;
> > > +			}
> > > +
> > > +			zs_obj_write(pool->zs_pool, handle, dst, dlen);
> > > +			entries[j]->handle = handle;
> > > +			entries[j]->length = dlen;
> > > +			if (dst != acomp_ctx->buffers[k])
> > > +				kunmap_local(dst);
> > > +		}
> > > +	} /* finished compress and store nr_pages. */
> > > +
> > > +	mutex_unlock(&acomp_ctx->mutex);
> > > +	return true;
> > > +
> > > +compress_error:
> > > +	for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
> > > +		if ((int)sg->length < 0) {
> > > +			if ((int)sg->length == -ENOSPC)
> > > +				zswap_reject_compress_poor++;
> > > +			else
> > > +				zswap_reject_compress_fail++;
> > > +		}
> > > +	}
> > >
> > > +err_unlock:
> > >  	mutex_unlock(&acomp_ctx->mutex);
> > > -	return comp_ret == 0 && alloc_ret == 0;
> > > +	return false;
> > >  }
> > >
> > >  static bool zswap_decompress(struct zswap_entry *entry, struct folio
> > *folio)
> > > @@ -1488,12 +1604,9 @@ static bool zswap_store_pages(struct folio
> > *folio,
> > >  		INIT_LIST_HEAD(&entries[i]->lru);
> > >  	}
> > >
> > > -	for (i = 0; i < nr_pages; ++i) {
> > > -		struct page *page = folio_page(folio, start + i);
> > > -
> > > -		if (!zswap_compress(page, entries[i], pool, wb_enabled))
> > > -			goto store_pages_failed;
> > > -	}
> > > +	if (unlikely(!zswap_compress(folio, start, nr_pages, entries, pool,
> > > +				     nid, wb_enabled)))
> > > +		goto store_pages_failed;
> > >
> > >  	for (i = 0; i < nr_pages; ++i) {
> > >  		struct zswap_entry *old, *entry = entries[i];
> > > --
> > > 2.27.0
> > >

