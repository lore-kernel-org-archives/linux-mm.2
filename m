Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5114FCEACC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D7B08E0038; Fri, 14 Nov 2025 14:44:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AF278E000A; Fri, 14 Nov 2025 14:44:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C46F8E0038; Fri, 14 Nov 2025 14:44:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5278E000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:44:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1FFA9C04D6
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:44:29 +0000 (UTC)
X-FDA: 84110239458.01.7AB2A3B
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1DC038000B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:44:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oECBROwT;
	spf=pass (imf30.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763149467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VmtmWeVNeDQubCUVIegKVeaojqJ5R7D+neANaxfZ/xM=;
	b=t4+qXdoAzM5qgOYgGIpSktj5zk+M688hrS+e+JOW2HVVZNdSJue2FP0qEnE4Z7iQS2TAtK
	D5oK28IlDlDC6FT28n6HS7PYC/7ewvd1KsYedGkIX/2xmlmyVUHlOw2/cfJVCxa5YS/1T3
	Tk5Slj38sGs+YgTSt98jLyijsZE0IZs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763149467; a=rsa-sha256;
	cv=none;
	b=7r8mjVqHXcH31KZZYF9aTm8FeHEkofMnCp5vIipQoHF2kS+F7eAs+gFsLj7PFzxm2ynAdK
	cUOLalu9BqCXxkEjNPYchhw8HvhinjBqknDXLVQk3VVGbOCtr28A1NZveg9trzyMUBOUej
	QR72PtmUMAZeYMmdEcL61ITca7DMbqs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oECBROwT;
	spf=pass (imf30.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 14 Nov 2025 19:44:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763149463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VmtmWeVNeDQubCUVIegKVeaojqJ5R7D+neANaxfZ/xM=;
	b=oECBROwTZkUKRWuM22PjHPCS/YhfD5lND8hPGbXU6uUs8SYac1gb+XRHmW6iqtkb7imn85
	sP+Hn5rjdoo/uLNvFcPFpxV42UR9uOTmYsDBn1/R+0bX4O/ZFWcxdT/9FW9mAkZF+7VBI/
	wC5h61dzOV6ofF+MxRf9zPsBXkYQlSQ=
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
Message-ID: <keys236tojsj7a4lx6tyqtr3hbhvtjtkbpb73zejgzxmegjwrb@i2xkzvgp5ake>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <SJ2PR11MB84727C029B980E5E06F7291EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB84727C029B980E5E06F7291EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xm4gxj4fmjwxdesbsqmyqtq5f7shm6qj
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DC038000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1763149466-216680
X-HE-Meta: U2FsdGVkX18pmtBOg5KwjPIwym2r3RgQrvM8VcgrSKXrFt0Dmw7bb4Wz2mKTVMe78GVBufnG+blp1ZPMDau7UTeYBut60nrGPpMRKfoGQtaF03temKMLYmmiCYyzv6mG5aCN5Q6+dgPLiMmaetPkZenrOIfYhD/Jyg3g19atkS0kOasdb3XcsDlz9SX6fp2QlSD9TCWF2ARbg7tkmHF4BwO5W2Gg172RtQd4mAbqNP4SnKmI1cuVKGNzNPlOR8sorp9MOa6S33pPGHk18BfgqgossDD5HTn98g9ORyvltvqjbDkNpGcHXSsoDitlbNRHwCBbCnFwFkaN91MmL0uVMQEJ9G6FmHunTtmuqUHGGZFh1QICYn0G96kpX03thiuw0saGF5DuIHrN5Kx5RBxoa1c+XWVjID79in1rbcuOy5Ez8dYlRxmrkUnDCbXpgUT7HOjLClteZPFjZyw6481QrT6GloW8IWn6FKZZQtXOA+XLWq+5QwY9+Z/LeFzclBWOx/OWL1JJKqBr0U8cUzr6c1nLT62SvltpDLg8F2pSduxe1SD181kYcwlCcxyN+yS3JTA8ryFDfBRO0dDQKlDm53dMxOyoANy4421W2H9051bInmNYKUi+QQHnLGhOjJIAKZ3O4u1kcMeyjqQNNL65tIrO0nKLYatKQOze9MlCQITp0/RLWRGpN35mC/9yjgqevDMVmyxjTpn6LKCVo1PDbSS7dMymD1XUChb83L+gxdvzwG6kh+VgX0K0gb6h66zfgDq0/OgVvVbnqu/tFcbvbgizVlQuFAc60AypXd++Mrg+I8gKrfAAwhyNKN3HcxnR2qPO2ZUfOxQi/zrgh6Az/SkjfkcVAVTK5NNsxwEQo9yUKf5ti7CXeYIWJyqdg+btbq+mjYCgLNdKUEpnIMQLXpmMVNz7jF7/Ad69hg6VCylF2b96bP8qxNp/RORptL+K3k0LnUoHJFAWGCWcqQh
 8JsUT91D
 Xzfztw9tC3TiugV5ib8fbeqvaOy29LIwbCusvqW4qwv+XGL8uTKgm9mpOjJ/6KS3LWCNjgkzeoEub9B8f3tpqYf7q8hQtLYw3bdZIkmfJsp3t5L7mOZA+wkfCajyxEfM6GdJ3gAgY3SAqanOz/UwA/eWvnNxcpGGYc3MfPVdb8OdX5D7TfqTQWN5n5xsO1lp2frexH54GheV+ZZXxfjXudROHvG+rmowBQbNEvjv5S/U9h85IludoDl05p7SWAcxacxOwD25UhMfRVZ1arF4DNWvMdpi+6Ranw8FsuKlxQJoJ2qs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 07:23:42PM +0000, Sridhar, Kanchana P wrote:
[..]
 > > > > >
> > > > > > > +		if (err && !wb_enabled)
> > > > > > > +			goto compress_error;
> > > > > > > +
> > > > > > > +		for_each_sg(acomp_ctx->sg_outputs->sgl, sg,
> > nr_comps, k) {
> > > > > > > +			j = k + i;
> > > > > >
[..]
> > > > >
> > > > > >
> > > > > > > +			dst = acomp_ctx->buffers[k];
> > > > > > > +			dlen = sg->length | *errp;
> > > > > >
> > > > > > Why are we doing this?
> > > > > >
> > > > > > > +
> > > > > > > +			if (dlen < 0) {
> > > > > >
> > > > > > We should do the incompressible page handling also if dlen is
> > PAGE_SIZE,
> > > > > > or if the compression failed (I guess that's the intention of bit OR'ing
> > > > > > with *errp?)
> > > > >
> > > > > Yes, indeed: that's the intention of bit OR'ing with *errp.
> > > >
> > > > ..and you never really answered my question. In the exising code we
> > > > store the page as incompressible if writeback is enabled AND
> > > > crypto_wait_req() fails or dlen is zero or PAGE_SIZE. We check above
> > > > if crypto_wait_req() fails and writeback is disabled, but what about the
> > > > rest?
> > >
> > > Let me explain this some more. The new code only relies on the assumption
> > > that if dlen is zero or >= PAGE_SIZE, the compressor will not return a 0
> > > ("successful status"). In other words, the compressor will return an error
> > status
> > > in this case, which is expected to be a negative error code.
> > 
> > I am not sure if all compressors do that, especially for the case where
> > dlen >= PAGE_SIZE. The existing code does not assume that there will be
> > an error code in these cases.
> > 
> > For the dlen == 0 case, the check was introduced recently by commit
> > dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
> > as-is"). Looking through the history it seems like it was introduced in
> > v4 of that patch but I don't see the reasoning.
> 
> The existing code did not check for dlen == 0 and dlen >= PAGE_SIZE
> prior to commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression
> failed page as-is") either. We need SeongJae or Herbert to clarify whether
> this check is needed, or if it is sufficient to rely on comp_ret, the return from
> crypto_wait_req().
> 
> > 
> > SeongJae, did you observe any compressors returning dlen == 0 but no
> > error code? What was the reasoning behind the dlen == 0 check?
> > 
> > >
> > > Under these (hopefully valid) assumptions, the code handles the simple case
> > > of an error compression return status and writeback is disabled, by the
> > > "goto compress_error".
> > >
> > > The rest is handled by these:
> > >
> > > 1) First, I need to adapt the use of sg_outputs->sgl->length to represent the
> > > compress length for software compressors, so I do this after
> > crypto_wait_req()
> > > returns:
> > >
> > >                 acomp_ctx->sg_outputs->sgl->length = acomp_ctx->req->dlen;
> > 
> > For SW compressors, why is acomp_ctx->sg_outputs->sgl->length not set?
> > IIUC we are using the same API for SW and HW compressors, why is the
> > output length in different places for each of them?
> 
> This is to first implement the SG lists batching interface in iaa_crypto, while
> maintaining backward compatibility for SW compressors with the new API.
> I believe we may want to adapt the crypto API to SW compressors
> at a later point. I also believe this would be outside the scope of this patch.
> It would be nice if Herbert can share his vision on this aspect.
> 
> > 
> > >
> > > I did not want to propose any changes to crypto software compressors
> > protocols.
> > >
> > > 2) After the check for the "if (err && !wb_enabled)" case, the new code has
> > this:
> > >
> > >                 for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
> > >                         j = k + i;
> > >                         dst = acomp_ctx->buffers[k];
> > >                         dlen = sg->length | *errp;
> > >
> > >                         if (dlen < 0) {
> > >                                 dlen = PAGE_SIZE;
> > >                                 dst = kmap_local_page(folio_page(folio, start + j));
> > >                         }
> > >
> > > For batching compressors, namely, iaa_crypto, the individual output SG
> > > lists sg->length follows the requirements from Herbert: each sg->length
> > > is the compressed length or the error status (a negative error code).
> > >
> > > Then all I need to know whether to store the page as incompressible
> > > is to either directly test if sg->length is negative (for batching compressors),
> > > or sg->length bit-OR'ed with the crypto_wait_req() return status ("err")
> > > is negative. This is accomplished by the "dlen = sg->length | *errp;".
> > >
> > > I believe this maintains backward compatibility with the existing code.
> > > Please let me know if you agree.
> > 
> > For batching compressors, will 'err' be set as well, or just sg->length?
> > If it's just sg->length, then we need to check again if WB is enabled
> > here before storing the page uncompressed. Right?
> 
> iaa_crypto will set 'err' and set the sg->length as per the batching interface
> spec from Herbert.

So both 'err' and sg->length will contain the same error? In this case
why do we need to check if dlen < 0? Shouldn't checking 'err' be
sufficient? and it would work for both SW and HW and we wouldn't need
errp. Did I miss something?

> 
> > 
> > >
> > > >
> > > > We don't check again if writeback is enabled before storing the page is
> > > > incompressible, and we do not check if dlen is zero or PAGE_SIZE. Are
> > > > these cases no longer possible?
> > >
> > > Hope the above explanation clarifies things some more? These case
> > > are possible, and as long as they return an error status, they should be
> > > correctly handled by the new code.
> > 
> > As mentioned above, I am not sure if that's correct for dlen >=
> > PAGE_SIZE.
> 
> We need to get clarity on this from SeongJae/Herbert.
> 
> > 
> > >
> > > >
> > > > Also, why use errp, why not explicitly use the appropriate error code?
> > > > It's also unclear to me why the error code is always zero with HW
> > > > compression?
> > >
> > > This is because of the sg->length requirements (compressed length/error)
> > > for the batching interface suggested by Herbert. Hence, I upfront define
> > > err_sg to 0, and, set errp to &err_sg for batching compressors. For software
> > > compressors, errp is set to &err, namely, the above check will always apply
> > > the software compressor's error status to the compressed length via
> > > the bit-OR to determine if the page needs to be stored uncompressed.
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
> 
> That was not how I understood Herbert's suggestion for the batching interface.
> He did suggest the following:
> 
> "Before the call to acomp, the destination SG list should contain as
> many elements as the number of units.  On return, the dst lengths
> should be stored in each destination SG entry."
> 
> I have incorporated this suggestion in the iaa_crypto driver. For SW
> compressors, I have tried not to propose any API changes, while making
> sure that the zswap changes for the SG lists batching API work as expected
> for SW without too much special-casing code.
> 
> I suppose I always assumed that we would update SW compressors later,
> and not as part of this patch-set.

I am not sure I understand what changes lie in the crypto layer and what
changes lie in the SW compressors. I am not suggesting we do any
modification to the SW compressors.

I imagined that the crypto layer would present a uniform API regardless
of whether or not the compressor supports batching. Ideally zswap would
pass in a batch to crypto and it would figure out if it needs to break
them down or not. Then the output length and errors would be presented
uniformly to the caller.

That being said, I am not at all familiar with how crypto works and how
straightforward that would be. Herbert, WDYT?

> 
> > 
> > This would simplify usage as we do not have to handle the differences in
> > zswap.
> 
> That's the nice thing about SG lists - I think the zswap_compress() calls to
> the new batching API appears agnostic to SW and HW compressors.
> Other than the upfront "errp = (pool->compr_batch_size == 1) ? &err : &err_sg;"
> the logical code organization of the new zswap_compress() is quite similar to
> the existing code. The post-compress "dlen = sg->length | *errp;" handles the rest.

It would be even nicer if the batches are also abstracted by SG lists.

Also, I don't like how the error codes and output lengths are presented
differently for HW and SW compressors.

