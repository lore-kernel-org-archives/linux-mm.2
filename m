Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC47DEA7942
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 18:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430046B0089; Wed,  4 Feb 2026 13:49:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DDB16B0092; Wed,  4 Feb 2026 13:49:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DCB16B0093; Wed,  4 Feb 2026 13:49:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BEF86B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:49:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C9AD71BF1D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:49:15 +0000 (UTC)
X-FDA: 84407661870.25.F38E4F5
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id DF5F518000C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:49:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f08uPGd4;
	spf=pass (imf16.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770230954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MjfPZJeH7W0tyAXZccSBDr1Jf1dziT02Ti4YrzFlQYU=;
	b=hQjwwymAao3TL2dQPYeddSz7ny6OolO99Z302dDw+XOlam7RxNBv0ZA4KUNCrjOXGkxK74
	tAN1se9Kel27ES4P6aIaiAB3Q+wztefXs3Zt9Y+Qp652g0G3YqG6zqzYj1RK1u9rKqL83c
	8ht2bD4NaYo+Eq+qVb4ErzCpWh2c5Us=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f08uPGd4;
	spf=pass (imf16.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770230954; a=rsa-sha256;
	cv=none;
	b=JqUT2wSDg53bjui6R4T4LBkLo81A29zbP+zSsZW1Pkd4kURx2ng/NAEjn8/ogM/Z3FGf8z
	hu2Wmup437FW3JYFV9iNIdo00Kvoh4MAxjH2t2+NFCYacRRrXt3LQ5MUUYiyMVnFm9I+36
	VB5gtzJ6c2qY8rsWq/9Y3aURUwyU4ZI=
Date: Wed, 4 Feb 2026 18:49:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770230951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MjfPZJeH7W0tyAXZccSBDr1Jf1dziT02Ti4YrzFlQYU=;
	b=f08uPGd4dcaI3FVK/d4pK+H/sXu3Cy1o6tN2X3Jv/bLQZPLxnfe30kY04FmoujhNo8zhyg
	5C6SnreLJmlMRZwqVLOpt4wNi5Fv50DhO4hspcVeKL5iPA+KUON7lBL7N8GRuRhP5sMntA
	xmuMc0qU/GH37vB32p0qNXHVwiF2jvo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com, 
	ying.huang@linux.alibaba.com, senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, vinicius.gomes@intel.com, giovanni.cabiddu@intel.com, 
	wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 00/26] zswap compression batching with optimized
 iaa_crypto driver
Message-ID: <t6n4qhqpexui7gfzkdw6r4ai3pztt7qg45fc5hjg3qydodp77n@oh5k6pzpyjwa>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <nlsqmn3x56ug7vfxw3vmpsmlyc6sie2plr22hpu7q6j7jq3adx@jbgg7sza67mv>
 <20260204103925.fd15632afc3bccc0ea8f500d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204103925.fd15632afc3bccc0ea8f500d@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF5F518000C
X-Stat-Signature: mcwzy6m4yd4xatwywu9h1zm5rsgjwn9w
X-Rspam-User: 
X-HE-Tag: 1770230953-960735
X-HE-Meta: U2FsdGVkX19Q+wHdW/YUPtR/U1lAiL5ex8vQeAe3yA9AHAo9oCY7lKhbHsQpHnB+YqlTOBeUUun8RK6KrgwhEFv5qlvbzHHhkbgcgKnESRTDd13sG+4GxOTqu6W/plGe0dC3GWRfsj9+MeWhMVpcnsYUBgcyDMhBkyjMgX2wBLffgvEfsRNfMf+1eKto/urgFg2B49te+xidQMyg+pm5DXYYUuIj9OVpnUN66XAlC6mKbFA5/O195l2LLuLW8b/2IrjM5Ir9QiHLVq5PUNz2g8a7wl9t9NFFFDjygOoIl0/wCOcmfI0XingPEv4fdreSD0VigpmcO725gFcagMUg9LiKlRa3SwERCLH8rFWPYF0O5iere3psFHnyWLeV8aYDiuv9xcwnCYvbt7ElF9PACMQ4rtB0AXYDE8SM91sZg4RlKzacTnLV3TDSjZD3LvKeMdZOCLW4jZ1Zm/+APAPMmsRRELKAIAJ4JPTOtQdaXGTXYGHs8oH2uUqWadxjshzJVBta4ZVWBklOl2wmbU2kG0+XEDxJJq74G3bRHhi+5d6gf0HfAIccOYM0JuA7qY8QUknFpbqy5RvhLDCb/KGsF0zC9eQmzeFfxt1t7L1KjPQnxVFWGBn/XnPwSsEf+Ah58je8MrGtbLd59OoG+Im7xgq0M2TRU6eSns0qLR6fa3M7G93sp1JREstiHnRUWb6n/8IYGlSgUIsaFGz1twvdpFdz7V2kqjOn/81B3K9F5ggDA0jhXmB1JsbBseLVxcVEVrYDDFme2ASmgVo+q11DMu7cpLwb12YMLR2kl2tGgKft7Xag99OUofQw4QRQPPay327nIQyckoGR1KP7tynjq5lHN1ej5viA5yO3ySTR3UQ+Tb1Z12UF1YRBNUPQZwCZPDn865nV9jLeLZwXNOkS+EgFJIKckAxLpgu7ypWD7PbUO478G1wJFocUg+a1Cd0IWiT3UXUgO8dFDBIqO1b
 +GkFVQOi
 XiS3P5rzM1lfGDF0lHpKpJRStNYojaHeM2KeLo9z79qYAM5hJUZ+dsKJ0FnoVYEek4U7V141qtWdJNXoBQ6bs2cej+6rKwGxmGZvGpBMLmQU2OjWO8tjQ9rQm5D6VyYL4YGdDmGDEwVWfwAUy3orkcb19BdHmRU747DT0lMu42wxIdG/aEMQSqlu3Oflk+RIaNryW+X1/W90vseN0N4qUlF+QsTGqikAM3iCD9EGBSLl4D56HMAQ6z/GHCJfUtjndx3Zu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 10:39:25AM -0800, Andrew Morton wrote:
> On Wed, 4 Feb 2026 18:21:43 +0000 Yosry Ahmed <yosry.ahmed@linux.dev> wrote:
> 
> > On Sat, Jan 24, 2026 at 07:35:11PM -0800, Kanchana P Sridhar wrote:
> > [..] 
> > 
> > I think this series is really hard to move and respin in its current
> > form.
> > 
> > Herbert, could we take in the crypto patches separately (if they are
> > ready)? Not sure if it's better to take them through the crypto tree
> > (and provide a tag for Andrew?), or through the mm tree.
> 
> Keeping everything in the same tree is of course simpler.
> 
> > But either way,
> > most review is on the later zswap patches and respinning all these
> > crypto patch every time is a pain.
> 
> It's mainly a crypto patchset by linecount:
> 
> :  .../driver-api/crypto/iaa/iaa-crypto.rst      |  168 +-
> :  crypto/acompress.c                            |  110 +-
> :  crypto/testmgr.c                              |   10 +
> :  crypto/testmgr.h                              |   74 +
> :  drivers/crypto/intel/iaa/Makefile             |    4 +-
> :  drivers/crypto/intel/iaa/iaa_crypto.h         |   95 +-
> :  .../intel/iaa/iaa_crypto_comp_dynamic.c       |   22 +
> :  drivers/crypto/intel/iaa/iaa_crypto_main.c    | 2926 ++++++++++++-----
> :  drivers/crypto/intel/iaa/iaa_crypto_stats.c   |    8 +
> :  drivers/crypto/intel/iaa/iaa_crypto_stats.h   |    2 +
> :  include/crypto/acompress.h                    |   68 +
> :  include/crypto/algapi.h                       |    5 +
> :  include/crypto/internal/acompress.h           |   15 +
> :  include/linux/crypto.h                        |    3 +
> :  mm/zswap.c                                    |  724 ++--
> :  15 files changed, 3144 insertions(+), 1090 deletions(-)
> :  create mode 100644 drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c
> 
> So I expect it'll work to take all this into the crypto tree.

Herbert, are the crypto patches ready to be picked up? If yes, could you
please pick them, then we can figure out how to route the dependent
zswap patches based on the timeline?

> 
> > >   mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
> > >   mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
> > >     resources.
> > 
> > Andrew, I think this two zswap patches are in good shape, and are
> > standalone improvements. Do they apply to mm-unstable? Could we take
> > them in separately to lighten the load of respinning this?
> 
> "mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool" throws a few
> rejects.
> 
> "mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
> resources" also throws rejects when applied standalone.

Kanchana, could you please respin these 2 changes, and a new change to
store the nid in the zswap_entry, and send them out separately?

We can land them separate from the rest of the series to accelerate
things.

